@echo off
setlocal
rem Chirpy 7 requires Ruby 3.x. Prefer the installed Ruby 3.2 on this PC.
if exist "C:\Ruby32-x64\bin\ruby.exe" set "PATH=C:\Ruby32-x64\bin;%PATH%"
rem RubyInstaller can share the development toolchain across Ruby versions.
if not defined MSYS2_PATH if exist "C:\Ruby40-x64\msys64\usr\bin\sh.exe" set "MSYS2_PATH=C:\Ruby40-x64\msys64"

pushd "%~dp0.."
ruby -e "abort 'Chirpy requires Ruby 3.x.' unless RUBY_VERSION.start_with?('3.')"
if errorlevel 1 goto failed

if "%~1"=="install" goto install
if "%~1"=="build" goto build
if "%~1"=="serve" goto serve
if "%~1"=="" goto serve
echo Usage: tools\windows.cmd [install^|build^|serve]
popd
exit /b 1

:install
call bundle install
goto done

:build
call bundle exec jekyll build
goto done

:serve
call bundle exec jekyll serve --livereload --host 127.0.0.1
goto done

:done
set "BLOG_EXIT_CODE=%ERRORLEVEL%"
popd
exit /b %BLOG_EXIT_CODE%

:failed
popd
exit /b 1

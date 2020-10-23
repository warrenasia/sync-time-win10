@echo off

:sync
:: Stop the time sync service, if already running
net stop w32time
:: Start the time sync service
net start w32time
:: Force a time resync with the default time/NTP server
w32tm /resync
:: If successful, go to end, else allow user to retry
if %errorlevel% == 0 (goto :end) else (goto :repeat)

:repeat
:: Allow user to retry or cancel.
:: /t 5  = Time out in 5 seconds
:: /c rx = Choices are r = retry / x = exit
:: /d r  = On time out, default action is retry
:: /n    = Hide list of choices (already shown in message below)
:: /m    = Message text
choice /t 5 /c rx /d r /n /m "Retry (r) or Exit (x)?"

:: If user selects first choice, retry, else cancel the operation
if %errorlevel% == 1 (goto :sync) else (goto :cancel)

:end
echo Completed
pause
exit /b 0

:cancel
echo Failed
pause
exit /b 2

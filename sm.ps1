Import-Module $env:SyncroModule

<#
.SYNOPSIS
   Monitors the status of the specified service
.DESCRIPTION
   Checks the status of the specified service, and optionally starts the service and/or creates a Syncro alert if it was not already running.
.EXAMPLE
   <An example of using the script>
#>

<#
	Set your run options below.  Specify the service name that you want to monitor, and whether or not you want to start it if it's stopped and/or alert if it's stopped.
#>

$serviceName = "Your Service Here"
$startIfStopped = "true"
$alertIfStopped = "true"
<#
	If alertIfStopped is true, then set the category below.
#>
$alertCategory = "Other"


<#
	Nothing below here requires editing.
#>


$service = Get-Service -Name $serviceName
$stat = $service.Status

if ($stat -ne "Running") {
	if ($startIfStopped -eq "true") {
		Start-Service $serviceName
		if ($alertIfStopped -eq "true") {
			$stat = $service.Status
			Rmm-Alert -Category $alertCategory -Body "$serviceName was stopped.  Attempted to start it.  Current status is: $stat"
		}
	}else {
		Rmm-Alert -Category $alertCategory -Body "Warning!  $serviceName was stopped.  Was not set to start it... the current status is: $stat"
	}
}
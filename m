Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68872251FE
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 15:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgGSNgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 09:36:54 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40939 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725988AbgGSNgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 09:36:52 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 19 Jul 2020 16:36:41 +0300
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06JDafG4018658;
        Sun, 19 Jul 2020 16:36:41 +0300
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 06JDaek2013807;
        Sun, 19 Jul 2020 16:36:40 +0300
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 06JDaen9013806;
        Sun, 19 Jul 2020 16:36:40 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: [PATCH iproute2-next 3/3] devlink: Update devlink-health and devlink-port manpages
Date:   Sun, 19 Jul 2020 16:36:03 +0300
Message-Id: <1595165763-13657-4-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595165763-13657-1-git-send-email-moshe@mellanox.com>
References: <1595165763-13657-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Describe support for per-port reporters in devlink-health and
devlink-port commands.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 man/man8/devlink-health.8 |   84 ++++++++++++++++++++++++++++++++-------------
 man/man8/devlink-port.8   |   19 ++++++++++
 2 files changed, 79 insertions(+), 24 deletions(-)

diff --git a/man/man8/devlink-health.8 b/man/man8/devlink-health.8
index 215f549..47b9613 100644
--- a/man/man8/devlink-health.8
+++ b/man/man8/devlink-health.8
@@ -19,37 +19,37 @@ devlink-health \- devlink health reporting and recovery
 
 .ti -8
 .B devlink health show
-.RI "[ " DEV ""
+.RI "[ { " DEV " | " DEV/PORT_INDEX " }"
 .B reporter
 .RI ""REPORTER " ] "
 
 .ti -8
 .B devlink health recover
-.RI "" DEV ""
+.RI "{ " DEV " | " DEV/PORT_INDEX " }"
 .B reporter
 .RI "" REPORTER ""
 
 .ti -8
 .B devlink health diagnose
-.RI "" DEV ""
+.RI "{ " DEV " | " DEV/PORT_INDEX " }"
 .B reporter
 .RI "" REPORTER ""
 
 .ti -8
 .B devlink health dump show
-.RI "" DEV ""
+.RI "{ " DEV " | " DEV/PORT_INDEX " }"
 .B  reporter
 .RI "" REPORTER ""
 
 .ti -8
 .B devlink health dump clear
-.RI "" DEV ""
+.RI "{ " DEV " | " DEV/PORT_INDEX " }"
 .B reporter
 .RI "" REPORTER ""
 
 .ti -8
 .B devlink health set
-.RI "" DEV ""
+.RI "{ " DEV " | " DEV/PORT_INDEX " }"
 .B reporter
 .RI "" REPORTER ""
 [
@@ -64,15 +64,19 @@ devlink-health \- devlink health reporting and recovery
 .B devlink health help
 
 .SH "DESCRIPTION"
-.SS devlink health show - Show status and configuration on all supported reporters on all devlink devices.
+.SS devlink health show - Show status and configuration on all supported reporters.
+Displays info about reporters registered on devlink devices and ports.
 
 .PP
 .I "DEV"
 - specifies the devlink device.
+.br
+.I DEV/PORT_INDEX
+- specifies the devlink port.
 
 .PP
 .I "REPORTER"
-- specifies the reporter's name registered on the devlink device.
+- specifies the reporter's name registered on specified devlink device or port.
 
 .SS devlink health recover - Initiate a recovery operation on a reporter.
 This action performs a recovery and increases the recoveries counter on success.
@@ -80,20 +84,26 @@ This action performs a recovery and increases the recoveries counter on success.
 .PP
 .I "DEV"
 - specifies the devlink device.
+.br
+.I DEV/PORT_INDEX
+- specifies the devlink port.
 
 .PP
 .I "REPORTER"
-- specifies the reporter's name registered on the devlink device.
+- specifies the reporter's name registered on specified devlink device or port.
 
 .SS devlink health diagnose - Retrieve diagnostics data on a reporter.
 
 .PP
-.I "DEV"
+.I DEV
 - specifies the devlink device.
+.br
+.I DEV/PORT_INDEX
+- specifies the devlink port.
 
 .PP
 .I "REPORTER"
-- specifies the reporter's name registered on the devlink device.
+- specifies the reporter's name registered on specified devlink device or port.
 
 .SS devlink health dump show - Display the last saved dump.
 
@@ -111,10 +121,13 @@ reporter reports on an error or manually at the user's request.
 .PP
 .I "DEV"
 - specifies the devlink device.
+.br
+.I DEV/PORT_INDEX
+- specifies the devlink port.
 
 .PP
 .I "REPORTER"
-- specifies the reporter's name registered on the devlink device.
+- specifies the reporter's name registered on specified devlink device or port.
 
 .SS devlink health dump clear - Delete the saved dump.
 Deleting the saved dump enables a generation of a new dump on
@@ -126,10 +139,13 @@ the next "devlink health dump show" command.
 .PP
 .I "DEV"
 - specifies the devlink device.
+.br
+.I DEV/PORT_INDEX
+- specifies the devlink port.
 
 .PP
 .I "REPORTER"
-- specifies the reporter's name registered on the devlink device.
+- specifies the reporter's name registered on specified devlink device or port.
 
 .SS devlink health set - Configure health reporter.
 Please note that some params are not supported on a reporter which
@@ -138,10 +154,13 @@ doesn't support a recovery or dump method.
 .PP
 .I "DEV"
 - specifies the devlink device.
+.br
+.I DEV/PORT_INDEX
+- specifies the devlink port.
 
 .PP
 .I "REPORTER"
-- specifies the reporter's name registered on the devlink device.
+- specifies the reporter's name registered on specified devlink device or port.
 
 .TP
 .BI grace_period " MSEC "
@@ -159,38 +178,55 @@ Indicates whether the devlink should execute automatic dump on error.
 .PP
 devlink health show
 .RS 4
-List status and configuration of available reporters on devices.
+List status and configuration of available reporters on devices and ports.
+.RE
+.PP
+devlink health show pci/0000:00:09.0/1 reporter tx
+.RS 4
+List status and configuration of tx reporter registered on port on pci/0000:00:09.0/1
 .RE
 .PP
-devlink health recover pci/0000:00:09.0 reporter tx
+devlink health recover pci/0000:00:09.0 reporter fw_fatal
 .RS 4
-Initiate recovery on tx reporter registered on pci/0000:00:09.0.
+Initiate recovery on fw_fatal reporter registered on device on pci/0000:00:09.0.
 .RE
 .PP
-devlink health diagnose pci/0000:00:09.0 reporter tx
+devlink health recover pci/0000:00:09.0/1 reporter tx
+.RS 4
+Initiate recovery on tx reporter registered on port on pci/0000:00:09.0/1.
+.RE
+.PP
+devlink health diagnose pci/0000:00:09.0 reporter fw
 .RS 4
 List diagnostics data on the specified device and reporter.
 .RE
 .PP
-devlink health dump show pci/0000:00:09.0 reporter tx
+devlink health dump show pci/0000:00:09.0/1 reporter tx
 .RS 4
-Display the last saved dump on the specified device and reporter.
+Display the last saved dump on the specified port and reporter.
 .RE
 .PP
-devlink health dump clear pci/0000:00:09.0 reporter tx
+devlink health dump clear pci/0000:00:09.0/1 reporter tx
 .RS 4
-Delete saved dump on the specified device and reporter.
+Delete saved dump on the specified port and reporter.
 .RE
 .PP
-devlink health set pci/0000:00:09.0 reporter tx grace_period 3500
+devlink health set pci/0000:00:09.0 reporter fw_fatal grace_period 3500
 .RS 4
 Set time interval between auto recoveries to minimum of 3500 msec on
 the specified device and reporter.
 .RE
 .PP
-devlink health set pci/0000:00:09.0 reporter tx auto_recover false
+devlink health set pci/0000:00:09.0/1 reporter tx grace_period 3500
+.RS 4
+Set time interval between auto recoveries to minimum of 3500 msec on
+the specified port and reporter.
+.RE
+.PP
+devlink health set pci/0000:00:09.0 reporter fw_fatal auto_recover false
 .RS 4
 Turn off auto recovery on the specified device and reporter.
+
 .RE
 .SH SEE ALSO
 .BR devlink (8),
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 188bffb..966faae 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -40,6 +40,10 @@ devlink-port \- devlink port configuration
 .RI "[ " DEV/PORT_INDEX " ]"
 
 .ti -8
+.B devlink port health
+.RI "{ " show " | " recover " | " diagnose " | " dump " | " set " }"
+
+.ti -8
 .B devlink port help
 
 .SH "DESCRIPTION"
@@ -91,6 +95,10 @@ Could be performed on any split port of the same split group.
 - specifies the devlink port to show.
 If this argument is omitted all ports are listed.
 
+.SS devlink port health - devlink health reporting and recovery
+Is an alias for
+.BR devlink-health (8).
+
 .SH "EXAMPLES"
 .PP
 devlink port show
@@ -117,12 +125,23 @@ devlink port unsplit pci/0000:01:00.0/1
 .RS 4
 Unplit the specified previously split devlink port.
 .RE
+.PP
+devlink port health show
+.RS 4
+Shows status and configuration of all supported reporters registered on all devlink ports.
+.RE
+.PP
+devlink port health show pci/0000:01:00.0/1 reporter tx
+.RS 4
+Shows status and configuration of tx reporter registered on pci/0000:01:00.0/1 devlink port.
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
 .BR devlink-dev (8),
 .BR devlink-sb (8),
 .BR devlink-monitor (8),
+.BR devlink-health (8),
 .br
 
 .SH AUTHOR
-- 
1.7.1


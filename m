Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63301C182E
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgEAOpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729582AbgEAOpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:12 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC84A2499A;
        Fri,  1 May 2020 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344307;
        bh=bFUSU0CDHE5bMJp0MuJssCpCSNpjL04f4SSrum4JlSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1HY3viXkg/ce+4Lsps7SyAbfYUV4XIK3F2wLKZtfGcTquw/WMwZfsI7Ut6yVI4+X5
         g3Gkbhijgaj5rMGZ/osWC+mMjQ0vs2LPi9HzjpnOI5E0IS5GDZY22sE0XVdzxACBZT
         dCHgSnZIAsrDK+aFiw5/DK/ZcoeHPI8mxZioILX4=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCeS-RX; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 24/37] docs: networking: device drivers: convert intel/ipw2100.txt to ReST
Date:   Fri,  1 May 2020 16:44:46 +0200
Message-Id: <9f8e6ca792b65b691fadafc5a1f20de20b4f7c6f.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust titles and chapters, adding proper markups;
- comment out text-only TOC from html/pdf output;
- use copyright symbol;
- use :field: markup;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/device_drivers/index.rst       |   1 +
 .../intel/{ipw2100.txt => ipw2100.rst}        | 242 ++++++++++--------
 MAINTAINERS                                   |   2 +-
 drivers/net/wireless/intel/ipw2x00/Kconfig    |   2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c  |   2 +-
 5 files changed, 140 insertions(+), 109 deletions(-)
 rename Documentation/networking/device_drivers/intel/{ipw2100.txt => ipw2100.rst} (70%)

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index cec3415ee459..54ed10f3d1a7 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -39,6 +39,7 @@ Contents:
    dlink/dl2k
    freescale/dpaa
    freescale/gianfar
+   intel/ipw2100
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/intel/ipw2100.txt b/Documentation/networking/device_drivers/intel/ipw2100.rst
similarity index 70%
rename from Documentation/networking/device_drivers/intel/ipw2100.txt
rename to Documentation/networking/device_drivers/intel/ipw2100.rst
index 6f85e1d06031..d54ad522f937 100644
--- a/Documentation/networking/device_drivers/intel/ipw2100.txt
+++ b/Documentation/networking/device_drivers/intel/ipw2100.rst
@@ -1,31 +1,37 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: <isonum.txt>
 
-Intel(R) PRO/Wireless 2100 Driver for Linux in support of:
+===========================================
+Intel(R) PRO/Wireless 2100 Driver for Linux
+===========================================
 
-Intel(R) PRO/Wireless 2100 Network Connection
+Support for:
 
-Copyright (C) 2003-2006, Intel Corporation
+- Intel(R) PRO/Wireless 2100 Network Connection
+
+Copyright |copy| 2003-2006, Intel Corporation
 
 README.ipw2100
 
-Version: git-1.1.5
-Date   : January 25, 2006
+:Version: git-1.1.5
+:Date:    January 25, 2006
+
+.. Index
+
+    0. IMPORTANT INFORMATION BEFORE USING THIS DRIVER
+    1. Introduction
+    2. Release git-1.1.5 Current Features
+    3. Command Line Parameters
+    4. Sysfs Helper Files
+    5. Radio Kill Switch
+    6. Dynamic Firmware
+    7. Power Management
+    8. Support
+    9. License
+
 
-Index
------------------------------------------------
 0. IMPORTANT INFORMATION BEFORE USING THIS DRIVER
-1. Introduction
-2. Release git-1.1.5 Current Features
-3. Command Line Parameters
-4. Sysfs Helper Files
-5. Radio Kill Switch
-6. Dynamic Firmware
-7. Power Management
-8. Support
-9. License
-
-
-0.   IMPORTANT INFORMATION BEFORE USING THIS DRIVER
------------------------------------------------
+=================================================
 
 Important Notice FOR ALL USERS OR DISTRIBUTORS!!!!
 
@@ -75,10 +81,10 @@ obtain a tested driver from Intel Customer Support at:
 http://www.intel.com/support/wireless/sb/CS-006408.htm
 
 1. Introduction
------------------------------------------------
+===============
 
-This document provides a brief overview of the features supported by the 
-IPW2100 driver project.  The main project website, where the latest 
+This document provides a brief overview of the features supported by the
+IPW2100 driver project.  The main project website, where the latest
 development version of the driver can be found, is:
 
 	http://ipw2100.sourceforge.net
@@ -89,10 +95,11 @@ for the driver project.
 
 
 2. Release git-1.1.5 Current Supported Features
------------------------------------------------
+===============================================
+
 - Managed (BSS) and Ad-Hoc (IBSS)
 - WEP (shared key and open)
-- Wireless Tools support 
+- Wireless Tools support
 - 802.1x (tested with XSupplicant 1.0.1)
 
 Enabled (but not supported) features:
@@ -105,11 +112,11 @@ performed on a given feature.
 
 
 3. Command Line Parameters
------------------------------------------------
+==========================
 
 If the driver is built as a module, the following optional parameters are used
 by entering them on the command line with the modprobe command using this
-syntax:
+syntax::
 
 	modprobe ipw2100 [<option>=<VAL1><,VAL2>...]
 
@@ -119,61 +126,76 @@ For example, to disable the radio on driver loading, enter:
 
 The ipw2100 driver supports the following module parameters:
 
-Name		Value		Example:
-debug		0x0-0xffffffff	debug=1024
-mode		0,1,2		mode=1   /* AdHoc */
-channel		int		channel=3 /* Only valid in AdHoc or Monitor */
-associate	boolean		associate=0 /* Do NOT auto associate */
-disable		boolean		disable=1 /* Do not power the HW */
+=========	==============	============  ==============================
+Name		Value		Example       Meaning
+=========	==============	============  ==============================
+debug		0x0-0xffffffff	debug=1024    Debug level set to 1024
+mode		0,1,2		mode=1        AdHoc
+channel		int		channel=3     Only valid in AdHoc or Monitor
+associate	boolean		associate=0   Do NOT auto associate
+disable		boolean		disable=1     Do not power the HW
+=========	==============	============  ==============================
 
 
 4. Sysfs Helper Files
----------------------------     
------------------------------------------------
+=====================
 
-There are several ways to control the behavior of the driver.  Many of the 
+There are several ways to control the behavior of the driver.  Many of the
 general capabilities are exposed through the Wireless Tools (iwconfig).  There
 are a few capabilities that are exposed through entries in the Linux Sysfs.
 
 
------ Driver Level ------
+**Driver Level**
+
 For the driver level files, look in /sys/bus/pci/drivers/ipw2100/
 
-  debug_level  
-	
-	This controls the same global as the 'debug' module parameter.  For 
-        information on the various debugging levels available, run the 'dvals'
+  debug_level
+	This controls the same global as the 'debug' module parameter.  For
+	information on the various debugging levels available, run the 'dvals'
 	script found in the driver source directory.
 
-	NOTE:  'debug_level' is only enabled if CONFIG_IPW2100_DEBUG is turn
-	       on.
+	.. note::
+
+	      'debug_level' is only enabled if CONFIG_IPW2100_DEBUG is turn on.
+
+**Device Level**
+
+For the device level files look in::
 
------ Device Level ------
-For the device level files look in
-	
 	/sys/bus/pci/drivers/ipw2100/{PCI-ID}/
 
-For example:
+For example::
+
 	/sys/bus/pci/drivers/ipw2100/0000:02:01.0
 
 For the device level files, see /sys/bus/pci/drivers/ipw2100:
 
   rf_kill
-	read - 
-	0 = RF kill not enabled (radio on)
-	1 = SW based RF kill active (radio off)
-	2 = HW based RF kill active (radio off)
-	3 = Both HW and SW RF kill active (radio off)
-	write -
-	0 = If SW based RF kill active, turn the radio back on
-	1 = If radio is on, activate SW based RF kill
-
-	NOTE: If you enable the SW based RF kill and then toggle the HW
-  	based RF kill from ON -> OFF -> ON, the radio will NOT come back on
+	read
+
+	==  =========================================
+	0   RF kill not enabled (radio on)
+	1   SW based RF kill active (radio off)
+	2   HW based RF kill active (radio off)
+	3   Both HW and SW RF kill active (radio off)
+	==  =========================================
+
+	write
+
+	==  ==================================================
+	0   If SW based RF kill active, turn the radio back on
+	1   If radio is on, activate SW based RF kill
+	==  ==================================================
+
+	.. note::
+
+	   If you enable the SW based RF kill and then toggle the HW
+	   based RF kill from ON -> OFF -> ON, the radio will NOT come back on
 
 
 5. Radio Kill Switch
------------------------------------------------
+====================
+
 Most laptops provide the ability for the user to physically disable the radio.
 Some vendors have implemented this as a physical switch that requires no
 software to turn the radio off and on.  On other laptops, however, the switch
@@ -186,9 +208,10 @@ on your system.
 
 
 6. Dynamic Firmware
------------------------------------------------
-As the firmware is licensed under a restricted use license, it can not be 
-included within the kernel sources.  To enable the IPW2100 you will need a 
+===================
+
+As the firmware is licensed under a restricted use license, it can not be
+included within the kernel sources.  To enable the IPW2100 you will need a
 firmware image to load into the wireless NIC's processors.
 
 You can obtain these images from <http://ipw2100.sf.net/firmware.php>.
@@ -197,52 +220,57 @@ See INSTALL for instructions on installing the firmware.
 
 
 7. Power Management
------------------------------------------------
-The IPW2100 supports the configuration of the Power Save Protocol 
-through a private wireless extension interface.  The IPW2100 supports 
+===================
+
+The IPW2100 supports the configuration of the Power Save Protocol
+through a private wireless extension interface.  The IPW2100 supports
 the following different modes:
 
+	===	===========================================================
 	off	No power management.  Radio is always on.
 	on	Automatic power management
-	1-5	Different levels of power management.  The higher the 
-		number the greater the power savings, but with an impact to 
-		packet latencies. 
+	1-5	Different levels of power management.  The higher the
+		number the greater the power savings, but with an impact to
+		packet latencies.
+	===	===========================================================
 
-Power management works by powering down the radio after a certain 
-interval of time has passed where no packets are passed through the 
-radio.  Once powered down, the radio remains in that state for a given 
-period of time.  For higher power savings, the interval between last 
+Power management works by powering down the radio after a certain
+interval of time has passed where no packets are passed through the
+radio.  Once powered down, the radio remains in that state for a given
+period of time.  For higher power savings, the interval between last
 packet processed to sleep is shorter and the sleep period is longer.
 
-When the radio is asleep, the access point sending data to the station 
-must buffer packets at the AP until the station wakes up and requests 
-any buffered packets.  If you have an AP that does not correctly support 
-the PSP protocol you may experience packet loss or very poor performance 
-while power management is enabled.  If this is the case, you will need 
-to try and find a firmware update for your AP, or disable power 
-management (via `iwconfig eth1 power off`)
+When the radio is asleep, the access point sending data to the station
+must buffer packets at the AP until the station wakes up and requests
+any buffered packets.  If you have an AP that does not correctly support
+the PSP protocol you may experience packet loss or very poor performance
+while power management is enabled.  If this is the case, you will need
+to try and find a firmware update for your AP, or disable power
+management (via ``iwconfig eth1 power off``)
 
-To configure the power level on the IPW2100 you use a combination of 
-iwconfig and iwpriv.  iwconfig is used to turn power management on, off, 
+To configure the power level on the IPW2100 you use a combination of
+iwconfig and iwpriv.  iwconfig is used to turn power management on, off,
 and set it to auto.
 
+	=========================  ====================================
 	iwconfig eth1 power off    Disables radio power down
-	iwconfig eth1 power on     Enables radio power management to 
+	iwconfig eth1 power on     Enables radio power management to
 				   last set level (defaults to AUTO)
-	iwpriv eth1 set_power 0    Sets power level to AUTO and enables 
-				   power management if not previously 
+	iwpriv eth1 set_power 0    Sets power level to AUTO and enables
+				   power management if not previously
 				   enabled.
-	iwpriv eth1 set_power 1-5  Set the power level as specified, 
-				   enabling power management if not 
+	iwpriv eth1 set_power 1-5  Set the power level as specified,
+				   enabling power management if not
 				   previously enabled.
+	=========================  ====================================
+
+You can view the current power level setting via::
 
-You can view the current power level setting via:
-	
 	iwpriv eth1 get_power
 
 It will return the current period or timeout that is configured as a string
 in the form of xxxx/yyyy (z) where xxxx is the timeout interval (amount of
-time after packet processing), yyyy is the period to sleep (amount of time to 
+time after packet processing), yyyy is the period to sleep (amount of time to
 wait before powering the radio and querying the access point for buffered
 packets), and z is the 'power level'.  If power management is turned off the
 xxxx/yyyy will be replaced with 'off' -- the level reported will be the active
@@ -250,44 +278,46 @@ level if `iwconfig eth1 power on` is invoked.
 
 
 8. Support
------------------------------------------------
+==========
 
 For general development information and support,
 go to:
-	
+
     http://ipw2100.sf.net/
 
-The ipw2100 1.1.0 driver and firmware can be downloaded from:  
+The ipw2100 1.1.0 driver and firmware can be downloaded from:
 
     http://support.intel.com
 
-For installation support on the ipw2100 1.1.0 driver on Linux kernels 
-2.6.8 or greater, email support is available from:  
+For installation support on the ipw2100 1.1.0 driver on Linux kernels
+2.6.8 or greater, email support is available from:
 
     http://supportmail.intel.com
 
 9. License
------------------------------------------------
+==========
 
-  Copyright(c) 2003 - 2006 Intel Corporation. All rights reserved.
+  Copyright |copy| 2003 - 2006 Intel Corporation. All rights reserved.
 
-  This program is free software; you can redistribute it and/or modify it 
-  under the terms of the GNU General Public License (version 2) as 
+  This program is free software; you can redistribute it and/or modify it
+  under the terms of the GNU General Public License (version 2) as
   published by the Free Software Foundation.
-  
-  This program is distributed in the hope that it will be useful, but WITHOUT 
-  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
-  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for 
+
+  This program is distributed in the hope that it will be useful, but WITHOUT
+  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
   more details.
-  
+
   You should have received a copy of the GNU General Public License along with
-  this program; if not, write to the Free Software Foundation, Inc., 59 
+  this program; if not, write to the Free Software Foundation, Inc., 59
   Temple Place - Suite 330, Boston, MA  02111-1307, USA.
-  
+
   The full GNU General Public License is included in this distribution in the
   file called LICENSE.
-  
+
   License Contact Information:
+
   James P. Ketrenos <ipw2100-admin@linux.intel.com>
+
   Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
 
diff --git a/MAINTAINERS b/MAINTAINERS
index b92568479a71..2ac9c94ff4f2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8762,7 +8762,7 @@ INTEL PRO/WIRELESS 2100, 2200BG, 2915ABG NETWORK CONNECTION SUPPORT
 M:	Stanislav Yakovlev <stas.yakovlev@gmail.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
-F:	Documentation/networking/device_drivers/intel/ipw2100.txt
+F:	Documentation/networking/device_drivers/intel/ipw2100.rst
 F:	Documentation/networking/device_drivers/intel/ipw2200.txt
 F:	drivers/net/wireless/intel/ipw2x00/
 
diff --git a/drivers/net/wireless/intel/ipw2x00/Kconfig b/drivers/net/wireless/intel/ipw2x00/Kconfig
index ab17903ba9f8..b0b3cd6296f3 100644
--- a/drivers/net/wireless/intel/ipw2x00/Kconfig
+++ b/drivers/net/wireless/intel/ipw2x00/Kconfig
@@ -16,7 +16,7 @@ config IPW2100
 	  A driver for the Intel PRO/Wireless 2100 Network
 	  Connection 802.11b wireless network adapter.
 
-	  See <file:Documentation/networking/device_drivers/intel/ipw2100.txt>
+	  See <file:Documentation/networking/device_drivers/intel/ipw2100.rst>
 	  for information on the capabilities currently enabled in this driver
 	  and for tips for debugging issues and problems.
 
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 97ea6e2035e6..624fe721e2b5 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -8352,7 +8352,7 @@ static int ipw2100_mod_firmware_load(struct ipw2100_fw *fw)
 	if (IPW2100_FW_MAJOR(h->version) != IPW2100_FW_MAJOR_VERSION) {
 		printk(KERN_WARNING DRV_NAME ": Firmware image not compatible "
 		       "(detected version id of %u). "
-		       "See Documentation/networking/device_drivers/intel/ipw2100.txt\n",
+		       "See Documentation/networking/device_drivers/intel/ipw2100.rst\n",
 		       h->version);
 		return 1;
 	}
-- 
2.25.4


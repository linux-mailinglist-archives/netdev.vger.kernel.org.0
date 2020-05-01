Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D0E1C1832
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbgEAOpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729281AbgEAOpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:12 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A6B524964;
        Fri,  1 May 2020 14:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344308;
        bh=i+lrJtK79ZaXiQi7kH81Bt50ZwWqRguIb+LxCqpjH30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZU0K1QgxxAI9rLf9ttqocELdAPAOPi1PYgrKlo5LvO9QT5Qu4VXVD/6T/htKaEYq
         b5V6HMhTiqWP4YiSQZBJd+0+QxYtjxtuCpb63Ic5YozlvxtQsS6SjVuaJe+QkwbcQY
         fvjkz3VgmBohjPXpt3e73AVW52YmpJITS1txCslY=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuU-00FCfG-40; Fri, 01 May 2020 16:45:02 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Chessman <chessman@tux.org>, netdev@vger.kernel.org
Subject: [PATCH 34/37] docs: networking: device drivers: convert ti/tlan.txt to ReST
Date:   Fri,  1 May 2020 16:44:56 +0200
Message-Id: <7964e7144500da480550be3b1b1edfaaab131744.1588344146.git.mchehab+huawei@kernel.org>
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
- mark tables as such;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/device_drivers/index.rst       |  1 +
 .../device_drivers/ti/{tlan.txt => tlan.rst}  | 73 ++++++++++++-------
 MAINTAINERS                                   |  2 +-
 drivers/net/ethernet/ti/Kconfig               |  2 +-
 drivers/net/ethernet/ti/tlan.c                |  2 +-
 5 files changed, 52 insertions(+), 28 deletions(-)
 rename Documentation/networking/device_drivers/ti/{tlan.txt => tlan.rst} (73%)

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 1d3b664e6921..adc0bf65fb02 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -49,6 +49,7 @@ Contents:
    smsc/smc9
    ti/cpsw_switchdev
    ti/cpsw
+   ti/tlan
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/ti/tlan.txt b/Documentation/networking/device_drivers/ti/tlan.rst
similarity index 73%
rename from Documentation/networking/device_drivers/ti/tlan.txt
rename to Documentation/networking/device_drivers/ti/tlan.rst
index 34550dfcef74..4fdc0907f4fc 100644
--- a/Documentation/networking/device_drivers/ti/tlan.txt
+++ b/Documentation/networking/device_drivers/ti/tlan.rst
@@ -1,20 +1,33 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+TLAN driver for Linux
+=====================
+
+:Version: 1.14a
+
 (C) 1997-1998 Caldera, Inc.
+
 (C) 1998 James Banks
+
 (C) 1999-2001 Torben Mathiasen <tmm@image.dk, torben.mathiasen@compaq.com>
 
 For driver information/updates visit http://www.compaq.com
 
 
-TLAN driver for Linux, version 1.14a
-README
 
 
-I.  Supported Devices.
+
+I. Supported Devices
+====================
 
     Only PCI devices will work with this driver.
 
     Supported:
+
+    =========	=========	===========================================
     Vendor ID	Device ID	Name
+    =========	=========	===========================================
     0e11	ae32		Compaq Netelligent 10/100 TX PCI UTP
     0e11	ae34		Compaq Netelligent 10 T PCI UTP
     0e11	ae35		Compaq Integrated NetFlex 3/P
@@ -25,13 +38,14 @@ I.  Supported Devices.
     0e11	b030		Compaq Netelligent 10/100 TX UTP
     0e11	f130		Compaq NetFlex 3/P
     0e11	f150		Compaq NetFlex 3/P
-    108d	0012		Olicom OC-2325	
+    108d	0012		Olicom OC-2325
     108d	0013		Olicom OC-2183
-    108d	0014		Olicom OC-2326	
+    108d	0014		Olicom OC-2326
+    =========	=========	===========================================
 
 
     Caveats:
-    
+
     I am not sure if 100BaseTX daughterboards (for those cards which
     support such things) will work.  I haven't had any solid evidence
     either way.
@@ -41,21 +55,25 @@ I.  Supported Devices.
 
     The "Netelligent 10 T/2 PCI UTP/Coax" (b012) device is untested,
     but I do not expect any problems.
-    
 
-II.   Driver Options
+
+II. Driver Options
+==================
+
 	1. You can append debug=x to the end of the insmod line to get
-           debug messages, where x is a bit field where the bits mean
+	   debug messages, where x is a bit field where the bits mean
 	   the following:
-	   
+
+	   ====		=====================================
 	   0x01		Turn on general debugging messages.
 	   0x02		Turn on receive debugging messages.
 	   0x04		Turn on transmit debugging messages.
 	   0x08		Turn on list debugging messages.
+	   ====		=====================================
 
 	2. You can append aui=1 to the end of the insmod line to cause
-           the adapter to use the AUI interface instead of the 10 Base T
-           interface.  This is also what to do if you want to use the BNC
+	   the adapter to use the AUI interface instead of the 10 Base T
+	   interface.  This is also what to do if you want to use the BNC
 	   connector on a TLAN based device.  (Setting this option on a
 	   device that does not have an AUI/BNC connector will probably
 	   cause it to not function correctly.)
@@ -70,41 +88,45 @@ II.   Driver Options
 
 	5. You have to use speed=X duplex=Y together now. If you just
 	   do "insmod tlan.o speed=100" the driver will do Auto-Neg.
-	   To force a 10Mbps Half-Duplex link do "insmod tlan.o speed=10 
+	   To force a 10Mbps Half-Duplex link do "insmod tlan.o speed=10
 	   duplex=1".
 
 	6. If the driver is built into the kernel, you can use the 3rd
 	   and 4th parameters to set aui and debug respectively.  For
-	   example:
+	   example::
 
-	   ether=0,0,0x1,0x7,eth0
+		ether=0,0,0x1,0x7,eth0
 
 	   This sets aui to 0x1 and debug to 0x7, assuming eth0 is a
 	   supported TLAN device.
 
 	   The bits in the third byte are assigned as follows:
 
-		0x01 = aui
-		0x02 = use half duplex
-		0x04 = use full duplex
-		0x08 = use 10BaseT
-		0x10 = use 100BaseTx
+		====   ===============
+		0x01   aui
+		0x02   use half duplex
+		0x04   use full duplex
+		0x08   use 10BaseT
+		0x10   use 100BaseTx
+		====   ===============
 
 	   You also need to set both speed and duplex settings when forcing
-	   speeds with kernel-parameters. 
+	   speeds with kernel-parameters.
 	   ether=0,0,0x12,0,eth0 will force link to 100Mbps Half-Duplex.
 
 	7. If you have more than one tlan adapter in your system, you can
 	   use the above options on a per adapter basis. To force a 100Mbit/HD
-	   link with your eth1 adapter use:
-	   
-	   insmod tlan speed=0,100 duplex=0,1
+	   link with your eth1 adapter use::
+
+		insmod tlan speed=0,100 duplex=0,1
 
 	   Now eth0 will use auto-neg and eth1 will be forced to 100Mbit/HD.
 	   Note that the tlan driver supports a maximum of 8 adapters.
 
 
-III.  Things to try if you have problems.
+III. Things to try if you have problems
+=======================================
+
 	1. Make sure your card's PCI id is among those listed in
 	   section I, above.
 	2. Make sure routing is correct.
@@ -113,5 +135,6 @@ III.  Things to try if you have problems.
 
 There is also a tlan mailing list which you can join by sending "subscribe tlan"
 in the body of an email to majordomo@vuser.vu.union.edu.
+
 There is also a tlan website at http://www.compaq.com
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 0054a0a87d5f..b0b352389d14 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17017,7 +17017,7 @@ M:	Samuel Chessman <chessman@tux.org>
 L:	tlan-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 W:	http://sourceforge.net/projects/tlan/
-F:	Documentation/networking/device_drivers/ti/tlan.txt
+F:	Documentation/networking/device_drivers/ti/tlan.rst
 F:	drivers/net/ethernet/ti/tlan.*
 
 TM6000 VIDEO4LINUX DRIVER
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 89cec778cf2d..7b0ad777828d 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -138,7 +138,7 @@ config TLAN
 
 	  Devices currently supported by this driver are Compaq Netelligent,
 	  Compaq NetFlex and Olicom cards.  Please read the file
-	  <file:Documentation/networking/device_drivers/ti/tlan.txt>
+	  <file:Documentation/networking/device_drivers/ti/tlan.rst>
 	  for more details.
 
 	  To compile this driver as a module, choose M here. The module
diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index ad465202980a..857709828058 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -70,7 +70,7 @@ MODULE_DESCRIPTION("Driver for TI ThunderLAN based ethernet PCI adapters");
 MODULE_LICENSE("GPL");
 
 /* Turn on debugging.
- * See Documentation/networking/device_drivers/ti/tlan.txt for details
+ * See Documentation/networking/device_drivers/ti/tlan.rst for details
  */
 static  int		debug;
 module_param(debug, int, 0);
-- 
2.25.4


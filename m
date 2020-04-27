Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD251BB0F8
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgD0WC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbgD0WCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:01 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C36422260;
        Mon, 27 Apr 2020 22:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=kJ7nuAYrQepxscJcqa5SQk6Dcd37HnIqGWIDAJTKfpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gH4dZdqP4JH8eN/EKaY5mayoBo96wRGMENIur4REBUcoqPNCJ62mkllreq2pgGP+q
         O2FCjUFjvTkUvQG1qe/IrZ3FPPuB+ecsUlptPV/gG6sGqTBv5MVDRxyl/RVPzokQ1X
         7xhURxSj6DMGUTWRjQtWtwLcfoY8dWjCWaSm77Kk=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000IqC-BA; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chas Williams <3chas3@gmail.com>, netdev@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net
Subject: [PATCH 32/38] docs: networking: convert iphase.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:47 +0200
Message-Id: <76e3297787c9b642d8ffe54f98eb2a6d36ff6207.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title using the proper markup;
- mark code blocks and literals as such;
- mark tables as such;
- mark lists as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 .../networking/{iphase.txt => iphase.rst}     | 185 +++++++++++-------
 drivers/atm/Kconfig                           |   2 +-
 3 files changed, 112 insertions(+), 76 deletions(-)
 rename Documentation/networking/{iphase.txt => iphase.rst} (50%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index f81aeb87aa28..505eaa41ca2b 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -67,6 +67,7 @@ Contents:
    ila
    ipddp
    ip_dynaddr
+   iphase
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/iphase.txt b/Documentation/networking/iphase.rst
similarity index 50%
rename from Documentation/networking/iphase.txt
rename to Documentation/networking/iphase.rst
index 670b72f16585..92d9b757d75a 100644
--- a/Documentation/networking/iphase.txt
+++ b/Documentation/networking/iphase.rst
@@ -1,27 +1,35 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================
+ATM (i)Chip IA Linux Driver Source
+==================================
+
+			      READ ME FISRT
 
-                              READ ME FISRT
-		  ATM (i)Chip IA Linux Driver Source
 --------------------------------------------------------------------------------
-                     Read This Before You Begin!
+
+		     Read This Before You Begin!
+
 --------------------------------------------------------------------------------
 
 Description
------------
+===========
 
-This is the README file for the Interphase PCI ATM (i)Chip IA Linux driver 
+This is the README file for the Interphase PCI ATM (i)Chip IA Linux driver
 source release.
 
 The features and limitations of this driver are as follows:
+
     - A single VPI (VPI value of 0) is supported.
-    - Supports 4K VCs for the server board (with 512K control memory) and 1K 
+    - Supports 4K VCs for the server board (with 512K control memory) and 1K
       VCs for the client board (with 128K control memory).
     - UBR, ABR and CBR service categories are supported.
-    - Only AAL5 is supported. 
-    - Supports setting of PCR on the VCs. 
+    - Only AAL5 is supported.
+    - Supports setting of PCR on the VCs.
     - Multiple adapters in a system are supported.
-    - All variants of Interphase ATM PCI (i)Chip adapter cards are supported, 
-      including x575 (OC3, control memory 128K , 512K and packet memory 128K, 
-      512K and 1M), x525 (UTP25) and x531 (DS3 and E3). See 
+    - All variants of Interphase ATM PCI (i)Chip adapter cards are supported,
+      including x575 (OC3, control memory 128K , 512K and packet memory 128K,
+      512K and 1M), x525 (UTP25) and x531 (DS3 and E3). See
       http://www.iphase.com/
       for details.
     - Only x86 platforms are supported.
@@ -29,128 +37,155 @@ The features and limitations of this driver are as follows:
 
 
 Before You Start
----------------- 
+================
 
 
 Installation
 ------------
 
 1. Installing the adapters in the system
+
    To install the ATM adapters in the system, follow the steps below.
+
        a. Login as root.
        b. Shut down the system and power off the system.
        c. Install one or more ATM adapters in the system.
-       d. Connect each adapter to a port on an ATM switch. The green 'Link' 
-          LED on the front panel of the adapter will be on if the adapter is 
-          connected to the switch properly when the system is powered up.
+       d. Connect each adapter to a port on an ATM switch. The green 'Link'
+	  LED on the front panel of the adapter will be on if the adapter is
+	  connected to the switch properly when the system is powered up.
        e. Power on and boot the system.
 
 2. [ Removed ]
 
 3. Rebuild kernel with ABR support
+
    [ a. and b. removed ]
-    c. Reconfigure the kernel, choose the Interphase ia driver through "make 
+
+    c. Reconfigure the kernel, choose the Interphase ia driver through "make
        menuconfig" or "make xconfig".
-    d. Rebuild the kernel, loadable modules and the atm tools. 
+    d. Rebuild the kernel, loadable modules and the atm tools.
     e. Install the new built kernel and modules and reboot.
 
 4. Load the adapter hardware driver (ia driver) if it is built as a module
+
        a. Login as root.
        b. Change directory to /lib/modules/<kernel-version>/atm.
        c. Run "insmod suni.o;insmod iphase.o"
-	  The yellow 'status' LED on the front panel of the adapter will blink 
-          while the driver is loaded in the system.
-       d. To verify that the 'ia' driver is loaded successfully, run the 
-          following command:
+	  The yellow 'status' LED on the front panel of the adapter will blink
+	  while the driver is loaded in the system.
+       d. To verify that the 'ia' driver is loaded successfully, run the
+	  following command::
 
-              cat /proc/atm/devices
+	      cat /proc/atm/devices
 
-          If the driver is loaded successfully, the output of the command will 
-          be similar to the following lines:
+	  If the driver is loaded successfully, the output of the command will
+	  be similar to the following lines::
 
-              Itf Type    ESI/"MAC"addr AAL(TX,err,RX,err,drop) ...
-              0   ia      xxxxxxxxx  0 ( 0 0 0 0 0 )  5 ( 0 0 0 0 0 )
+	      Itf Type    ESI/"MAC"addr AAL(TX,err,RX,err,drop) ...
+	      0   ia      xxxxxxxxx  0 ( 0 0 0 0 0 )  5 ( 0 0 0 0 0 )
 
-          You can also check the system log file /var/log/messages for messages
-          related to the ATM driver.
+	  You can also check the system log file /var/log/messages for messages
+	  related to the ATM driver.
 
-5. Ia Driver Configuration 
+5. Ia Driver Configuration
 
 5.1 Configuration of adapter buffers
     The (i)Chip boards have 3 different packet RAM size variants: 128K, 512K and
-    1M. The RAM size decides the number of buffers and buffer size. The default 
-    size and number of buffers are set as following: 
+    1M. The RAM size decides the number of buffers and buffer size. The default
+    size and number of buffers are set as following:
 
-          Total    Rx RAM   Tx RAM   Rx Buf   Tx Buf   Rx buf   Tx buf
-         RAM size   size     size     size     size      cnt      cnt
-         --------  ------   ------   ------   ------   ------   ------
-           128K      64K      64K      10K      10K       6        6
-           512K     256K     256K      10K      10K      25       25
-             1M     512K     512K      10K      10K      51       51
+	=========  =======  ======   ======   ======   ======   ======
+	 Total     Rx RAM   Tx RAM   Rx Buf   Tx Buf   Rx buf   Tx buf
+	 RAM size  size     size     size     size     cnt      cnt
+	=========  =======  ======   ======   ======   ======   ======
+	   128K      64K      64K      10K      10K       6        6
+	   512K     256K     256K      10K      10K      25       25
+	     1M     512K     512K      10K      10K      51       51
+	=========  =======  ======   ======   ======   ======   ======
 
        These setting should work well in most environments, but can be
-       changed by typing the following command: 
- 
-           insmod <IA_DIR>/ia.o IA_RX_BUF=<RX_CNT> IA_RX_BUF_SZ=<RX_SIZE> \
-                   IA_TX_BUF=<TX_CNT> IA_TX_BUF_SZ=<TX_SIZE> 
+       changed by typing the following command::
+
+	   insmod <IA_DIR>/ia.o IA_RX_BUF=<RX_CNT> IA_RX_BUF_SZ=<RX_SIZE> \
+		   IA_TX_BUF=<TX_CNT> IA_TX_BUF_SZ=<TX_SIZE>
+
        Where:
-            RX_CNT = number of receive buffers in the range (1-128)
-            RX_SIZE = size of receive buffers in the range (48-64K)
-            TX_CNT = number of transmit buffers in the range (1-128)
-            TX_SIZE = size of transmit buffers in the range (48-64K)
 
-            1. Transmit and receive buffer size must be a multiple of 4.
-            2. Care should be taken so that the memory required for the
-               transmit and receive buffers is less than or equal to the
-               total adapter packet memory.   
+	    - RX_CNT = number of receive buffers in the range (1-128)
+	    - RX_SIZE = size of receive buffers in the range (48-64K)
+	    - TX_CNT = number of transmit buffers in the range (1-128)
+	    - TX_SIZE = size of transmit buffers in the range (48-64K)
+
+	    1. Transmit and receive buffer size must be a multiple of 4.
+	    2. Care should be taken so that the memory required for the
+	       transmit and receive buffers is less than or equal to the
+	       total adapter packet memory.
 
 5.2 Turn on ia debug trace
 
-    When the ia driver is built with the CONFIG_ATM_IA_DEBUG flag, the driver 
-    can provide more debug trace if needed. There is a bit mask variable, 
-    IADebugFlag, which controls the output of the traces. You can find the bit 
-    map of the IADebugFlag in iphase.h. 
-    The debug trace can be turn on through the insmod command line option, for 
-    example, "insmod iphase.o IADebugFlag=0xffffffff" can turn on all the debug 
+    When the ia driver is built with the CONFIG_ATM_IA_DEBUG flag, the driver
+    can provide more debug trace if needed. There is a bit mask variable,
+    IADebugFlag, which controls the output of the traces. You can find the bit
+    map of the IADebugFlag in iphase.h.
+    The debug trace can be turn on through the insmod command line option, for
+    example, "insmod iphase.o IADebugFlag=0xffffffff" can turn on all the debug
     traces together with loading the driver.
 
 6. Ia Driver Test Using ttcp_atm and PVC
 
-   For the PVC setup, the test machines can either be connected back-to-back or 
-   through a switch. If connected through the switch, the switch must be 
+   For the PVC setup, the test machines can either be connected back-to-back or
+   through a switch. If connected through the switch, the switch must be
    configured for the PVC(s).
 
    a. For UBR test:
-      At the test machine intended to receive data, type:
-         ttcp_atm -r -a -s 0.100 
-      At the other test machine, type:
-         ttcp_atm -t -a -s 0.100 -n 10000
+
+      At the test machine intended to receive data, type::
+
+	 ttcp_atm -r -a -s 0.100
+
+      At the other test machine, type::
+
+	 ttcp_atm -t -a -s 0.100 -n 10000
+
       Run "ttcp_atm -h" to display more options of the ttcp_atm tool.
    b. For ABR test:
-      It is the same as the UBR testing, but with an extra command option:
-         -Pabr:max_pcr=<xxx>
-         where:
-             xxx = the maximum peak cell rate, from 170 - 353207.
-         This option must be set on both the machines.
+
+      It is the same as the UBR testing, but with an extra command option::
+
+	 -Pabr:max_pcr=<xxx>
+
+      where:
+
+	     xxx = the maximum peak cell rate, from 170 - 353207.
+
+      This option must be set on both the machines.
+
    c. For CBR test:
-      It is the same as the UBR testing, but with an extra command option:
-         -Pcbr:max_pcr=<xxx>
-         where:
-             xxx = the maximum peak cell rate, from 170 - 353207.
-         This option may only be set on the transmit machine.
 
+      It is the same as the UBR testing, but with an extra command option::
 
-OUTSTANDING ISSUES
-------------------
+	 -Pcbr:max_pcr=<xxx>
+
+      where:
+
+	     xxx = the maximum peak cell rate, from 170 - 353207.
+
+      This option may only be set on the transmit machine.
+
+
+Outstanding Issues
+==================
 
 
 
 Contact Information
 -------------------
 
+::
+
      Customer Support:
-         United States:	Telephone:	(214) 654-5555
-     			Fax:		(214) 654-5500
+	 United States:	Telephone:	(214) 654-5555
+			Fax:		(214) 654-5500
 			E-Mail:		intouch@iphase.com
 	 Europe:	Telephone:	33 (0)1 41 15 44 00
 			Fax:		33 (0)1 41 15 12 13
diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index 4af7cbdcc349..cfb0d16b60ad 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -306,7 +306,7 @@ config ATM_IA
 	  for more info about the cards. Say Y (or M to compile as a module
 	  named iphase) here if you have one of these cards.
 
-	  See the file <file:Documentation/networking/iphase.txt> for further
+	  See the file <file:Documentation/networking/iphase.rst> for further
 	  details.
 
 config ATM_IA_DEBUG
-- 
2.25.4


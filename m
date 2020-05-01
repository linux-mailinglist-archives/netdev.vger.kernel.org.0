Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475121C18AE
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgEAOsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729321AbgEAOpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:07 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFEE924953;
        Fri,  1 May 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=rN4VaRsq4TFWMvYDcHSDc7rGeR1oz6sxZaa1mHVtzsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnjBkLQ1SaYjkaqEQzDvb4oM2sQ7mcVe8hAI8/aRC7GnF8+93aedJKYAuzyc3o3Qq
         hCgthIi1Ea35Jbu0JOyLWrW1bqbk5yTD2sMtjCLfgGX3ZDLsDmIqJis9Gnr3rMWBAp
         Hhda0SfGoUCxHrBE/zO305lvallw0pxtcnANtiMg=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCe3-NJ; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH 19/37] docs: networking: device drivers: convert dec/de4x5.txt to ReST
Date:   Fri,  1 May 2020 16:44:41 +0200
Message-Id: <33e9444fb07448fd12cef68b8f469d7c4325a417.1588344146.git.mchehab+huawei@kernel.org>
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
- add a document title;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../dec/{de4x5.txt => de4x5.rst}              | 105 ++++++++++--------
 .../networking/device_drivers/index.rst       |   1 +
 drivers/net/ethernet/dec/tulip/Kconfig        |   2 +-
 3 files changed, 60 insertions(+), 48 deletions(-)
 rename Documentation/networking/device_drivers/dec/{de4x5.txt => de4x5.rst} (78%)

diff --git a/Documentation/networking/device_drivers/dec/de4x5.txt b/Documentation/networking/device_drivers/dec/de4x5.rst
similarity index 78%
rename from Documentation/networking/device_drivers/dec/de4x5.txt
rename to Documentation/networking/device_drivers/dec/de4x5.rst
index 452aac58341d..e03e9c631879 100644
--- a/Documentation/networking/device_drivers/dec/de4x5.txt
+++ b/Documentation/networking/device_drivers/dec/de4x5.rst
@@ -1,48 +1,54 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+DEC EtherWORKS Ethernet De4x5 cards
+===================================
+
     Originally,   this  driver  was    written  for the  Digital   Equipment
     Corporation series of EtherWORKS Ethernet cards:
 
-        DE425 TP/COAX EISA
-	DE434 TP PCI
-	DE435 TP/COAX/AUI PCI
-	DE450 TP/COAX/AUI PCI
-	DE500 10/100 PCI Fasternet
+	 - DE425 TP/COAX EISA
+	 - DE434 TP PCI
+	 - DE435 TP/COAX/AUI PCI
+	 - DE450 TP/COAX/AUI PCI
+	 - DE500 10/100 PCI Fasternet
 
     but it  will  now attempt  to  support all  cards which   conform to the
     Digital Semiconductor   SROM   Specification.    The  driver   currently
     recognises the following chips:
 
-        DC21040  (no SROM) 
-	DC21041[A]  
-	DC21140[A] 
-	DC21142 
-	DC21143 
+	 - DC21040  (no SROM)
+	 - DC21041[A]
+	 - DC21140[A]
+	 - DC21142
+	 - DC21143
 
     So far the driver is known to work with the following cards:
 
-        KINGSTON
-	Linksys
-	ZNYX342
-	SMC8432
-	SMC9332 (w/new SROM)
-	ZNYX31[45]
-	ZNYX346 10/100 4 port (can act as a 10/100 bridge!) 
+	 - KINGSTON
+	 - Linksys
+	 - ZNYX342
+	 - SMC8432
+	 - SMC9332 (w/new SROM)
+	 - ZNYX31[45]
+	 - ZNYX346 10/100 4 port (can act as a 10/100 bridge!)
 
     The driver has been tested on a relatively busy network using the DE425,
     DE434, DE435 and DE500 cards and benchmarked with 'ttcp': it transferred
-    16M of data to a DECstation 5000/200 as follows:
+    16M of data to a DECstation 5000/200 as follows::
 
-                TCP           UDP
-             TX     RX     TX     RX
-    DE425   1030k  997k   1170k  1128k
-    DE434   1063k  995k   1170k  1125k
-    DE435   1063k  995k   1170k  1125k
-    DE500   1063k  998k   1170k  1125k  in 10Mb/s mode
+		  TCP           UDP
+	       TX     RX     TX     RX
+      DE425   1030k  997k   1170k  1128k
+      DE434   1063k  995k   1170k  1125k
+      DE435   1063k  995k   1170k  1125k
+      DE500   1063k  998k   1170k  1125k  in 10Mb/s mode
 
     All  values are typical (in   kBytes/sec) from a  sample  of 4 for  each
     measurement. Their error is +/-20k on a quiet (private) network and also
     depend on what load the CPU has.
 
-    =========================================================================
+----------------------------------------------------------------------------
 
     The ability to load this  driver as a loadable  module has been included
     and used extensively  during the driver development  (to save those long
@@ -55,31 +61,33 @@
 
     0) have a copy of the loadable modules code installed on your system.
     1) copy de4x5.c from the  /linux/drivers/net directory to your favourite
-    temporary directory.
+       temporary directory.
     2) for fixed  autoprobes (not  recommended),  edit the source code  near
-    line 5594 to reflect the I/O address  you're using, or assign these when
-    loading by:
+       line 5594 to reflect the I/O address  you're using, or assign these when
+       loading by::
 
-                   insmod de4x5 io=0xghh           where g = bus number
-		                                        hh = device number   
+		   insmod de4x5 io=0xghh           where g = bus number
+							hh = device number
 
-       NB: autoprobing for modules is now supported by default. You may just
-           use:
+       .. note::
 
-                   insmod de4x5
+	   autoprobing for modules is now supported by default. You may just
+	   use::
 
-           to load all available boards. For a specific board, still use
+		   insmod de4x5
+
+	   to load all available boards. For a specific board, still use
 	   the 'io=?' above.
     3) compile  de4x5.c, but include -DMODULE in  the command line to ensure
-    that the correct bits are compiled (see end of source code).
+       that the correct bits are compiled (see end of source code).
     4) if you are wanting to add a new  card, goto 5. Otherwise, recompile a
-    kernel with the de4x5 configuration turned off and reboot.
+       kernel with the de4x5 configuration turned off and reboot.
     5) insmod de4x5 [io=0xghh]
-    6) run the net startup bits for your new eth?? interface(s) manually 
-    (usually /etc/rc.inet[12] at boot time). 
+    6) run the net startup bits for your new eth?? interface(s) manually
+       (usually /etc/rc.inet[12] at boot time).
     7) enjoy!
 
-    To unload a module, turn off the associated interface(s) 
+    To unload a module, turn off the associated interface(s)
     'ifconfig eth?? down' then 'rmmod de4x5'.
 
     Automedia detection is included so that in  principle you can disconnect
@@ -90,7 +98,7 @@
     By  default,  the driver will  now   autodetect any  DECchip based card.
     Should you have a need to restrict the driver to DIGITAL only cards, you
     can compile with a  DEC_ONLY define, or if  loading as a module, use the
-    'dec_only=1'  parameter. 
+    'dec_only=1'  parameter.
 
     I've changed the timing routines to  use the kernel timer and scheduling
     functions  so that the  hangs  and other assorted problems that occurred
@@ -158,18 +166,21 @@
     either at the end of the parameter list or with another board name.  The
     following parameters are allowed:
 
-            fdx        for full duplex
-	    autosense  to set the media/speed; with the following 
-	               sub-parameters:
+	    =========  ===============================================
+	    fdx        for full duplex
+	    autosense  to set the media/speed; with the following
+		       sub-parameters:
 		       TP, TP_NW, BNC, AUI, BNC_AUI, 100Mb, 10Mb, AUTO
+	    =========  ===============================================
 
     Case sensitivity is important  for  the sub-parameters. They *must*   be
-    upper case. Examples:
+    upper case. Examples::
 
-        insmod de4x5 args='eth1:fdx autosense=BNC eth0:autosense=100Mb'.
+	insmod de4x5 args='eth1:fdx autosense=BNC eth0:autosense=100Mb'.
 
-    For a compiled in driver, in linux/drivers/net/CONFIG, place e.g.
-	DE4X5_OPTS = -DDE4X5_PARM='"eth0:fdx autosense=AUI eth2:autosense=TP"' 
+    For a compiled in driver, in linux/drivers/net/CONFIG, place e.g.::
+
+	DE4X5_OPTS = -DDE4X5_PARM='"eth0:fdx autosense=AUI eth2:autosense=TP"'
 
     Yes,  I know full duplex  isn't permissible on BNC  or AUI; they're just
     examples. By default, full duplex is turned  off and AUTO is the default
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index e8db57fef2e9..4ad13ffb5800 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -34,6 +34,7 @@ Contents:
    chelsio/cxgb
    cirrus/cs89x0
    davicom/dm9000
+   dec/de4x5
 
 .. only::  subproject and html
 
diff --git a/drivers/net/ethernet/dec/tulip/Kconfig b/drivers/net/ethernet/dec/tulip/Kconfig
index 8ce6888ea722..8c4245d94bb2 100644
--- a/drivers/net/ethernet/dec/tulip/Kconfig
+++ b/drivers/net/ethernet/dec/tulip/Kconfig
@@ -114,7 +114,7 @@ config DE4X5
 	  These include the DE425, DE434, DE435, DE450 and DE500 models.  If
 	  you have a network card of this type, say Y.  More specific
 	  information is contained in
-	  <file:Documentation/networking/device_drivers/dec/de4x5.txt>.
+	  <file:Documentation/networking/device_drivers/dec/de4x5.rst>.
 
 	  To compile this driver as a module, choose M here. The module will
 	  be called de4x5.
-- 
2.25.4


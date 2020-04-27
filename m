Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51441BB145
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgD0WFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgD0WB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:01:58 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79A0321973;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=aaALIx74QyjMbTVhHHG9pqdXWwDu+Zs5Jrf90Sc9+jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3T95GqEXv+hpJG+/s9XJaXw8WQgMn4tXNqP92KsD3ITby9j7kwRs+OWTaJC9mVDX
         IlMmpLwiReQh4MDUpMxv0gYPaoeZGp+/Cj8+MYwyHI670D7CrIEjflbkp90d/EpCi4
         zPc2blBbgOhhbt7/fwGvCCx70ayyCxIVOk4QJP4k=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000IoV-PD; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 11/38] docs: networking: convert cops.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:26 +0200
Message-Id: <26d3a3792de65e8a0c5ad3ac40b8146fa809c45a.1588024424.git.mchehab+huawei@kernel.org>
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
- adjust titles and chapters, adding proper markups;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/cops.rst  | 80 ++++++++++++++++++++++++++++++
 Documentation/networking/cops.txt  | 63 -----------------------
 Documentation/networking/index.rst |  1 +
 drivers/net/appletalk/Kconfig      |  2 +-
 4 files changed, 82 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/networking/cops.rst
 delete mode 100644 Documentation/networking/cops.txt

diff --git a/Documentation/networking/cops.rst b/Documentation/networking/cops.rst
new file mode 100644
index 000000000000..964ba80599a9
--- /dev/null
+++ b/Documentation/networking/cops.rst
@@ -0,0 +1,80 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+========================================
+The COPS LocalTalk Linux driver (cops.c)
+========================================
+
+By Jay Schulist <jschlst@samba.org>
+
+This driver has two modes and they are: Dayna mode and Tangent mode.
+Each mode corresponds with the type of card. It has been found
+that there are 2 main types of cards and all other cards are
+the same and just have different names or only have minor differences
+such as more IO ports. As this driver is tested it will
+become more clear exactly what cards are supported.
+
+Right now these cards are known to work with the COPS driver. The
+LT-200 cards work in a somewhat more limited capacity than the
+DL200 cards, which work very well and are in use by many people.
+
+TANGENT driver mode:
+	- Tangent ATB-II, Novell NL-1000, Daystar Digital LT-200
+
+DAYNA driver mode:
+	- Dayna DL2000/DaynaTalk PC (Half Length), COPS LT-95,
+	- Farallon PhoneNET PC III, Farallon PhoneNET PC II
+
+Other cards possibly supported mode unknown though:
+	- Dayna DL2000 (Full length)
+
+The COPS driver defaults to using Dayna mode. To change the driver's
+mode if you built a driver with dual support use board_type=1 or
+board_type=2 for Dayna or Tangent with insmod.
+
+Operation/loading of the driver
+===============================
+
+Use modprobe like this:	/sbin/modprobe cops.o (IO #) (IRQ #)
+If you do not specify any options the driver will try and use the IO = 0x240,
+IRQ = 5. As of right now I would only use IRQ 5 for the card, if autoprobing.
+
+To load multiple COPS driver Localtalk cards you can do one of the following::
+
+	insmod cops io=0x240 irq=5
+	insmod -o cops2 cops io=0x260 irq=3
+
+Or in lilo.conf put something like this::
+
+	append="ether=5,0x240,lt0 ether=3,0x260,lt1"
+
+Then bring up the interface with ifconfig. It will look something like this::
+
+  lt0       Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-F7-00-00-00-00-00-00-00-00
+	    inet addr:192.168.1.2  Bcast:192.168.1.255  Mask:255.255.255.0
+	    UP BROADCAST RUNNING NOARP MULTICAST  MTU:600  Metric:1
+	    RX packets:0 errors:0 dropped:0 overruns:0 frame:0
+	    TX packets:0 errors:0 dropped:0 overruns:0 carrier:0 coll:0
+
+Netatalk Configuration
+======================
+
+You will need to configure atalkd with something like the following to make
+it work with the cops.c driver.
+
+* For single LTalk card use::
+
+    dummy -seed -phase 2 -net 2000 -addr 2000.10 -zone "1033"
+    lt0 -seed -phase 1 -net 1000 -addr 1000.50 -zone "1033"
+
+* For multiple cards, Ethernet and LocalTalk::
+
+    eth0 -seed -phase 2 -net 3000 -addr 3000.20 -zone "1033"
+    lt0 -seed -phase 1 -net 1000 -addr 1000.50 -zone "1033"
+
+* For multiple LocalTalk cards, and an Ethernet card.
+
+* Order seems to matter here, Ethernet last::
+
+    lt0 -seed -phase 1 -net 1000 -addr 1000.10 -zone "LocalTalk1"
+    lt1 -seed -phase 1 -net 2000 -addr 2000.20 -zone "LocalTalk2"
+    eth0 -seed -phase 2 -net 3000 -addr 3000.30 -zone "EtherTalk"
diff --git a/Documentation/networking/cops.txt b/Documentation/networking/cops.txt
deleted file mode 100644
index 3e344b448e07..000000000000
--- a/Documentation/networking/cops.txt
+++ /dev/null
@@ -1,63 +0,0 @@
-Text File for the COPS LocalTalk Linux driver (cops.c).
-	By Jay Schulist <jschlst@samba.org>
-
-This driver has two modes and they are: Dayna mode and Tangent mode.
-Each mode corresponds with the type of card. It has been found
-that there are 2 main types of cards and all other cards are
-the same and just have different names or only have minor differences
-such as more IO ports. As this driver is tested it will
-become more clear exactly what cards are supported. 
-
-Right now these cards are known to work with the COPS driver. The
-LT-200 cards work in a somewhat more limited capacity than the
-DL200 cards, which work very well and are in use by many people.
-
-TANGENT driver mode:
-	Tangent ATB-II, Novell NL-1000, Daystar Digital LT-200
-DAYNA driver mode:
-	Dayna DL2000/DaynaTalk PC (Half Length), COPS LT-95,
-	Farallon PhoneNET PC III, Farallon PhoneNET PC II
-Other cards possibly supported mode unknown though:
-	Dayna DL2000 (Full length)
-
-The COPS driver defaults to using Dayna mode. To change the driver's 
-mode if you built a driver with dual support use board_type=1 or
-board_type=2 for Dayna or Tangent with insmod.
-
-** Operation/loading of the driver.
-Use modprobe like this:	/sbin/modprobe cops.o (IO #) (IRQ #)
-If you do not specify any options the driver will try and use the IO = 0x240,
-IRQ = 5. As of right now I would only use IRQ 5 for the card, if autoprobing.
-
-To load multiple COPS driver Localtalk cards you can do one of the following.
-
-insmod cops io=0x240 irq=5
-insmod -o cops2 cops io=0x260 irq=3
-
-Or in lilo.conf put something like this:
-	append="ether=5,0x240,lt0 ether=3,0x260,lt1"
-
-Then bring up the interface with ifconfig. It will look something like this:
-lt0       Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-F7-00-00-00-00-00-00-00-00
-          inet addr:192.168.1.2  Bcast:192.168.1.255  Mask:255.255.255.0
-          UP BROADCAST RUNNING NOARP MULTICAST  MTU:600  Metric:1
-          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
-          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0 coll:0
-
-** Netatalk Configuration
-You will need to configure atalkd with something like the following to make
-it work with the cops.c driver.
-
-* For single LTalk card use.
-dummy -seed -phase 2 -net 2000 -addr 2000.10 -zone "1033"
-lt0 -seed -phase 1 -net 1000 -addr 1000.50 -zone "1033"
-
-* For multiple cards, Ethernet and LocalTalk.
-eth0 -seed -phase 2 -net 3000 -addr 3000.20 -zone "1033"
-lt0 -seed -phase 1 -net 1000 -addr 1000.50 -zone "1033"
-
-* For multiple LocalTalk cards, and an Ethernet card.
-* Order seems to matter here, Ethernet last.
-lt0 -seed -phase 1 -net 1000 -addr 1000.10 -zone "LocalTalk1"
-lt1 -seed -phase 1 -net 2000 -addr 2000.20 -zone "LocalTalk2"
-eth0 -seed -phase 2 -net 3000 -addr 3000.30 -zone "EtherTalk"
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 55802abd65a0..7b596810d479 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -46,6 +46,7 @@ Contents:
    baycom
    bonding
    cdc_mbim
+   cops
 
 .. only::  subproject and html
 
diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfig
index af509b05ac5c..d4e51c048f62 100644
--- a/drivers/net/appletalk/Kconfig
+++ b/drivers/net/appletalk/Kconfig
@@ -59,7 +59,7 @@ config COPS
 	  package. This driver is experimental, which means that it may not
 	  work. This driver will only work if you choose "AppleTalk DDP"
 	  networking support, above.
-	  Please read the file <file:Documentation/networking/cops.txt>.
+	  Please read the file <file:Documentation/networking/cops.rst>.
 
 config COPS_DAYNA
 	bool "Dayna firmware support"
-- 
2.25.4


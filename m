Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199AD1C1884
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730290AbgEAOre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729548AbgEAOpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:09 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9EDF208DB;
        Fri,  1 May 2020 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344307;
        bh=kznbsqrC35NeTiD+j3a7mVjUjRkxxuXMvy7Q1cN6UyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhR8LZQY4D/9iEsG/vjW5EyAnXjY6byZQUYUUuaegr6ZRHvQ2aWx/G6yfm6wuo5ZF
         /Yx2g292pPjpwvikGZhnD8/ByY9oGIn7rhxnwpZT2PWiIELEqkTXRhYoz9G11pU2Nw
         yboa27+IQva9+MCkRR4Qpvbvs5HnKtKWZsEOA0SA=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCeb-TJ; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH 26/37] docs: networking: device drivers: convert microsoft/netvsc.txt to ReST
Date:   Fri,  1 May 2020 16:44:48 +0200
Message-Id: <0f4b68dd901fe915980395a595bc6cced6b4530f.1588344146.git.mchehab+huawei@kernel.org>
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
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/device_drivers/index.rst       |  1 +
 .../microsoft/{netvsc.txt => netvsc.rst}      | 57 +++++++++++--------
 MAINTAINERS                                   |  2 +-
 3 files changed, 36 insertions(+), 24 deletions(-)
 rename Documentation/networking/device_drivers/microsoft/{netvsc.txt => netvsc.rst} (83%)

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index f9ce0089ec7d..575f0043b03e 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -41,6 +41,7 @@ Contents:
    freescale/gianfar
    intel/ipw2100
    intel/ipw2200
+   microsoft/netvsc
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/microsoft/netvsc.txt b/Documentation/networking/device_drivers/microsoft/netvsc.rst
similarity index 83%
rename from Documentation/networking/device_drivers/microsoft/netvsc.txt
rename to Documentation/networking/device_drivers/microsoft/netvsc.rst
index cd63556b27a0..c3f51c672a68 100644
--- a/Documentation/networking/device_drivers/microsoft/netvsc.txt
+++ b/Documentation/networking/device_drivers/microsoft/netvsc.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
 Hyper-V network driver
 ======================
 
@@ -10,15 +13,15 @@ Windows 10.
 Features
 ========
 
-  Checksum offload
-  ----------------
+Checksum offload
+----------------
   The netvsc driver supports checksum offload as long as the
   Hyper-V host version does. Windows Server 2016 and Azure
   support checksum offload for TCP and UDP for both IPv4 and
   IPv6. Windows Server 2012 only supports checksum offload for TCP.
 
-  Receive Side Scaling
-  --------------------
+Receive Side Scaling
+--------------------
   Hyper-V supports receive side scaling. For TCP & UDP, packets can
   be distributed among available queues based on IP address and port
   number.
@@ -32,30 +35,37 @@ Features
   hashing. Using L3 hashing is recommended in this case.
 
   For example, for UDP over IPv4 on eth0:
-  To include UDP port numbers in hashing:
-        ethtool -N eth0 rx-flow-hash udp4 sdfn
-  To exclude UDP port numbers in hashing:
-        ethtool -N eth0 rx-flow-hash udp4 sd
-  To show UDP hash level:
-        ethtool -n eth0 rx-flow-hash udp4
-
-  Generic Receive Offload, aka GRO
-  --------------------------------
+
+  To include UDP port numbers in hashing::
+
+	ethtool -N eth0 rx-flow-hash udp4 sdfn
+
+  To exclude UDP port numbers in hashing::
+
+	ethtool -N eth0 rx-flow-hash udp4 sd
+
+  To show UDP hash level::
+
+	ethtool -n eth0 rx-flow-hash udp4
+
+Generic Receive Offload, aka GRO
+--------------------------------
   The driver supports GRO and it is enabled by default. GRO coalesces
   like packets and significantly reduces CPU usage under heavy Rx
   load.
 
-  Large Receive Offload (LRO), or Receive Side Coalescing (RSC)
-  -------------------------------------------------------------
+Large Receive Offload (LRO), or Receive Side Coalescing (RSC)
+-------------------------------------------------------------
   The driver supports LRO/RSC in the vSwitch feature. It reduces the per packet
   processing overhead by coalescing multiple TCP segments when possible. The
   feature is enabled by default on VMs running on Windows Server 2019 and
-  later. It may be changed by ethtool command:
+  later. It may be changed by ethtool command::
+
 	ethtool -K eth0 lro on
 	ethtool -K eth0 lro off
 
-  SR-IOV support
-  --------------
+SR-IOV support
+--------------
   Hyper-V supports SR-IOV as a hardware acceleration option. If SR-IOV
   is enabled in both the vSwitch and the guest configuration, then the
   Virtual Function (VF) device is passed to the guest as a PCI
@@ -70,8 +80,8 @@ Features
   flow direction is desired, these should be applied directly to the
   VF slave device.
 
-  Receive Buffer
-  --------------
+Receive Buffer
+--------------
   Packets are received into a receive area which is created when device
   is probed. The receive area is broken into MTU sized chunks and each may
   contain one or more packets. The number of receive sections may be changed
@@ -83,8 +93,8 @@ Features
   will use slower method to handle very large packets or if the send buffer
   area is exhausted.
 
-  XDP support
-  -----------
+XDP support
+-----------
   XDP (eXpress Data Path) is a feature that runs eBPF bytecode at the early
   stage when packets arrive at a NIC card. The goal is to increase performance
   for packet processing, reducing the overhead of SKB allocation and other
@@ -99,7 +109,8 @@ Features
   overwritten by setting of synthetic NIC.
 
   XDP program cannot run with LRO (RSC) enabled, so you need to disable LRO
-  before running XDP:
+  before running XDP::
+
 	ethtool -K eth0 lro off
 
   XDP_REDIRECT action is not yet supported.
diff --git a/MAINTAINERS b/MAINTAINERS
index 62c654308bc8..ef6bd3be1bb5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7881,7 +7881,7 @@ S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git
 F:	Documentation/ABI/stable/sysfs-bus-vmbus
 F:	Documentation/ABI/testing/debugfs-hyperv
-F:	Documentation/networking/device_drivers/microsoft/netvsc.txt
+F:	Documentation/networking/device_drivers/microsoft/netvsc.rst
 F:	arch/x86/hyperv
 F:	arch/x86/include/asm/hyperv-tlfs.h
 F:	arch/x86/include/asm/mshyperv.h
-- 
2.25.4


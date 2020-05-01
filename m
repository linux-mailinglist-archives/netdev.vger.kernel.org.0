Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C4D1C1856
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgEAOq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729558AbgEAOpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:10 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDD7A2499E;
        Fri,  1 May 2020 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344307;
        bh=xVuN5WonHTjh9L8Up6vrydJPeuXiRxAhggDIL6ZiyX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTOmItD8tQwnKFDAgMNaClT3CLLg7/YXbWDDh9eNP3MDp7IcNUkdLlaRaA9XuODvp
         tg1WWd2m5lC4hL3d7S4ho8zM53nc/QtUc9LbiO0EVJZCUTHN6M0oCSXHjVfXNbF782
         GANMcmcftBQPN00szwkljXjRJQOobawiYTWRtIp4=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCel-Uy; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jon Mason <jdmason@kudzu.us>,
        netdev@vger.kernel.org
Subject: [PATCH 28/37] docs: networking: device drivers: convert neterion/vxge.txt to ReST
Date:   Fri,  1 May 2020 16:44:50 +0200
Message-Id: <e8636f884b134be9e9869dcfe8c2a91891ce926e.1588344146.git.mchehab+huawei@kernel.org>
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
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/device_drivers/index.rst       |  1 +
 .../neterion/{vxge.txt => vxge.rst}           | 60 +++++++++++++------
 MAINTAINERS                                   |  2 +-
 drivers/net/ethernet/neterion/Kconfig         |  2 +-
 4 files changed, 44 insertions(+), 21 deletions(-)
 rename Documentation/networking/device_drivers/neterion/{vxge.txt => vxge.rst} (80%)

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index da1f8438d4ea..55837244eaad 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -43,6 +43,7 @@ Contents:
    intel/ipw2200
    microsoft/netvsc
    neterion/s2io
+   neterion/vxge
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/neterion/vxge.txt b/Documentation/networking/device_drivers/neterion/vxge.rst
similarity index 80%
rename from Documentation/networking/device_drivers/neterion/vxge.txt
rename to Documentation/networking/device_drivers/neterion/vxge.rst
index abfec245f97c..589c6b15c63d 100644
--- a/Documentation/networking/device_drivers/neterion/vxge.txt
+++ b/Documentation/networking/device_drivers/neterion/vxge.rst
@@ -1,24 +1,30 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============================================================================
 Neterion's (Formerly S2io) X3100 Series 10GbE PCIe Server Adapter Linux driver
 ==============================================================================
 
-Contents
---------
+.. Contents
 
-1) Introduction
-2) Features supported
-3) Configurable driver parameters
-4) Troubleshooting
+  1) Introduction
+  2) Features supported
+  3) Configurable driver parameters
+  4) Troubleshooting
+
+1. Introduction
+===============
 
-1) Introduction:
-----------------
 This Linux driver supports all Neterion's X3100 series 10 GbE PCIe I/O
 Virtualized Server adapters.
+
 The X3100 series supports four modes of operation, configurable via
-firmware -
-	Single function mode
-	Multi function mode
-	SRIOV mode
-	MRIOV mode
+firmware:
+
+	- Single function mode
+	- Multi function mode
+	- SRIOV mode
+	- MRIOV mode
+
 The functions share a 10GbE link and the pci-e bus, but hardly anything else
 inside the ASIC. Features like independent hw reset, statistics, bandwidth/
 priority allocation and guarantees, GRO, TSO, interrupt moderation etc are
@@ -26,41 +32,49 @@ supported independently on each function.
 
 (See below for a complete list of features supported for both IPv4 and IPv6)
 
-2) Features supported:
-----------------------
+2. Features supported
+=====================
 
 i)   Single function mode (up to 17 queues)
 
 ii)  Multi function mode (up to 17 functions)
 
 iii) PCI-SIG's I/O Virtualization
+
        - Single Root mode: v1.0 (up to 17 functions)
        - Multi-Root mode: v1.0 (up to 17 functions)
 
 iv)  Jumbo frames
+
        X3100 Series supports MTU up to 9600 bytes, modifiable using
        ip command.
 
 v)   Offloads supported: (Enabled by default)
-       Checksum offload (TCP/UDP/IP) on transmit and receive paths
-       TCP Segmentation Offload (TSO) on transmit path
-       Generic Receive Offload (GRO) on receive path
+
+       - Checksum offload (TCP/UDP/IP) on transmit and receive paths
+       - TCP Segmentation Offload (TSO) on transmit path
+       - Generic Receive Offload (GRO) on receive path
 
 vi)  MSI-X: (Enabled by default)
+
        Resulting in noticeable performance improvement (up to 7% on certain
        platforms).
 
 vii) NAPI: (Enabled by default)
+
        For better Rx interrupt moderation.
 
 viii)RTH (Receive Traffic Hash): (Enabled by default)
+
        Receive side steering for better scaling.
 
 ix)  Statistics
+
        Comprehensive MAC-level and software statistics displayed using
        "ethtool -S" option.
 
 x)   Multiple hardware queues: (Enabled by default)
+
        Up to 17 hardware based transmit and receive data channels, with
        multiple steering options (transmit multiqueue enabled by default).
 
@@ -69,25 +83,33 @@ x)   Multiple hardware queues: (Enabled by default)
 
 i)  max_config_dev
        Specifies maximum device functions to be enabled.
+
        Valid range: 1-8
 
 ii) max_config_port
        Specifies number of ports to be enabled.
+
        Valid range: 1,2
+
        Default: 1
 
-iii)max_config_vpath
+iii) max_config_vpath
        Specifies maximum VPATH(s) configured for each device function.
+
        Valid range: 1-17
 
 iv) vlan_tag_strip
        Enables/disables vlan tag stripping from all received tagged frames that
        are not replicated at the internal L2 switch.
+
        Valid range: 0,1 (disabled, enabled respectively)
+
        Default: 1
 
 v)  addr_learn_en
        Enable learning the mac address of the guest OS interface in
        virtualization environment.
+
        Valid range: 0,1 (disabled, enabled respectively)
+
        Default: 0
diff --git a/MAINTAINERS b/MAINTAINERS
index 122a684d522b..91da0be7f69e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11692,7 +11692,7 @@ M:	Jon Mason <jdmason@kudzu.us>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/device_drivers/neterion/s2io.rst
-F:	Documentation/networking/device_drivers/neterion/vxge.txt
+F:	Documentation/networking/device_drivers/neterion/vxge.rst
 F:	drivers/net/ethernet/neterion/
 
 NETFILTER
diff --git a/drivers/net/ethernet/neterion/Kconfig b/drivers/net/ethernet/neterion/Kconfig
index c375ee08f6ea..a82a37094579 100644
--- a/drivers/net/ethernet/neterion/Kconfig
+++ b/drivers/net/ethernet/neterion/Kconfig
@@ -42,7 +42,7 @@ config VXGE
 	  labeled as either one, depending on its age.
 
 	  More specific information on configuring the driver is in
-	  <file:Documentation/networking/device_drivers/neterion/vxge.txt>.
+	  <file:Documentation/networking/device_drivers/neterion/vxge.rst>.
 
 	  To compile this driver as a module, choose M here. The module
 	  will be called vxge.
-- 
2.25.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209711C18A0
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgEAOsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729344AbgEAOpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:08 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E8E82495C;
        Fri,  1 May 2020 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=EmTPsmxuwAaBR5KuHJWiqABZUfAUsQPhnqBEbYl9Y0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0j1NQtY5ltDIOLbYlVd0Q2CaU6EAB6IgG6Jo2j50nM4/vON2DHxcItryfjuzrylT
         wbiPlwbj789bPZ0yDpiD8Z6WAY7EZNtqW1hbneuHYIzn5uxE9leNuEor527V4idSOB
         iHHUC0IcSYf8Hox1D8jqhWUPXRE/LJn3P3ffq1+4=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCeH-Pu; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 22/37] docs: networking: device drivers: convert freescale/dpaa.txt to ReST
Date:   Fri,  1 May 2020 16:44:44 +0200
Message-Id: <1f2de65c9290a0d3bc9c9a83102b48b454baa598.1588344146.git.mchehab+huawei@kernel.org>
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
- use :field: markup;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../freescale/{dpaa.txt => dpaa.rst}          | 139 ++++++++++--------
 .../networking/device_drivers/index.rst       |   1 +
 2 files changed, 75 insertions(+), 65 deletions(-)
 rename Documentation/networking/device_drivers/freescale/{dpaa.txt => dpaa.rst} (79%)

diff --git a/Documentation/networking/device_drivers/freescale/dpaa.txt b/Documentation/networking/device_drivers/freescale/dpaa.rst
similarity index 79%
rename from Documentation/networking/device_drivers/freescale/dpaa.txt
rename to Documentation/networking/device_drivers/freescale/dpaa.rst
index b06601ff9200..241c6c6f6e68 100644
--- a/Documentation/networking/device_drivers/freescale/dpaa.txt
+++ b/Documentation/networking/device_drivers/freescale/dpaa.rst
@@ -1,12 +1,14 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============================
 The QorIQ DPAA Ethernet Driver
 ==============================
 
 Authors:
-Madalin Bucur <madalin.bucur@nxp.com>
-Camelia Groza <camelia.groza@nxp.com>
+- Madalin Bucur <madalin.bucur@nxp.com>
+- Camelia Groza <camelia.groza@nxp.com>
 
-Contents
-========
+.. Contents
 
 	- DPAA Ethernet Overview
 	- DPAA Ethernet Supported SoCs
@@ -34,7 +36,7 @@ following drivers in the Linux kernel:
  - Queue Manager (QMan), Buffer Manager (BMan)
     drivers/soc/fsl/qbman
 
-A simplified view of the dpaa_eth interfaces mapped to FMan MACs:
+A simplified view of the dpaa_eth interfaces mapped to FMan MACs::
 
   dpaa_eth       /eth0\     ...       /ethN\
   driver        |      |             |      |
@@ -42,89 +44,93 @@ A simplified view of the dpaa_eth interfaces mapped to FMan MACs:
        -Ports  / Tx  Rx \    ...    / Tx  Rx \
   FMan        |          |         |          |
        -MACs  |   MAC0   |         |   MACN   |
-             /   dtsec0   \  ...  /   dtsecN   \ (or tgec)
-            /              \     /              \(or memac)
+	     /   dtsec0   \  ...  /   dtsecN   \ (or tgec)
+	    /              \     /              \(or memac)
   ---------  --------------  ---  --------------  ---------
       FMan, FMan Port, FMan SP, FMan MURAM drivers
   ---------------------------------------------------------
       FMan HW blocks: MURAM, MACs, Ports, SP
   ---------------------------------------------------------
 
-The dpaa_eth relation to the QMan, BMan and FMan:
-              ________________________________
+The dpaa_eth relation to the QMan, BMan and FMan::
+
+	      ________________________________
   dpaa_eth   /            eth0                \
   driver    /                                  \
   ---------   -^-   -^-   -^-   ---    ---------
   QMan driver / \   / \   / \  \   /  | BMan    |
-             |Rx | |Rx | |Tx | |Tx |  | driver  |
+	     |Rx | |Rx | |Tx | |Tx |  | driver  |
   ---------  |Dfl| |Err| |Cnf| |FQs|  |         |
   QMan HW    |FQ | |FQ | |FQs| |   |  |         |
-             /   \ /   \ /   \  \ /   |         |
+	     /   \ /   \ /   \  \ /   |         |
   ---------   ---   ---   ---   -v-    ---------
-            |        FMan QMI         |         |
-            | FMan HW       FMan BMI  | BMan HW |
-              -----------------------   --------
+	    |        FMan QMI         |         |
+	    | FMan HW       FMan BMI  | BMan HW |
+	      -----------------------   --------
 
 where the acronyms used above (and in the code) are:
-DPAA = Data Path Acceleration Architecture
-FMan = DPAA Frame Manager
-QMan = DPAA Queue Manager
-BMan = DPAA Buffers Manager
-QMI = QMan interface in FMan
-BMI = BMan interface in FMan
-FMan SP = FMan Storage Profiles
-MURAM = Multi-user RAM in FMan
-FQ = QMan Frame Queue
-Rx Dfl FQ = default reception FQ
-Rx Err FQ = Rx error frames FQ
-Tx Cnf FQ = Tx confirmation FQs
-Tx FQs = transmission frame queues
-dtsec = datapath three speed Ethernet controller (10/100/1000 Mbps)
-tgec = ten gigabit Ethernet controller (10 Gbps)
-memac = multirate Ethernet MAC (10/100/1000/10000)
+
+=============== ===========================================================
+DPAA 		Data Path Acceleration Architecture
+FMan 		DPAA Frame Manager
+QMan 		DPAA Queue Manager
+BMan 		DPAA Buffers Manager
+QMI 		QMan interface in FMan
+BMI 		BMan interface in FMan
+FMan SP 	FMan Storage Profiles
+MURAM 		Multi-user RAM in FMan
+FQ 		QMan Frame Queue
+Rx Dfl FQ 	default reception FQ
+Rx Err FQ 	Rx error frames FQ
+Tx Cnf FQ 	Tx confirmation FQs
+Tx FQs 		transmission frame queues
+dtsec 		datapath three speed Ethernet controller (10/100/1000 Mbps)
+tgec 		ten gigabit Ethernet controller (10 Gbps)
+memac 		multirate Ethernet MAC (10/100/1000/10000)
+=============== ===========================================================
 
 DPAA Ethernet Supported SoCs
 ============================
 
 The DPAA drivers enable the Ethernet controllers present on the following SoCs:
 
-# PPC
-P1023
-P2041
-P3041
-P4080
-P5020
-P5040
-T1023
-T1024
-T1040
-T1042
-T2080
-T4240
-B4860
+PPC
+- P1023
+- P2041
+- P3041
+- P4080
+- P5020
+- P5040
+- T1023
+- T1024
+- T1040
+- T1042
+- T2080
+- T4240
+- B4860
 
-# ARM
-LS1043A
-LS1046A
+ARM
+- LS1043A
+- LS1046A
 
 Configuring DPAA Ethernet in your kernel
 ========================================
 
-To enable the DPAA Ethernet driver, the following Kconfig options are required:
+To enable the DPAA Ethernet driver, the following Kconfig options are required::
 
-# common for arch/arm64 and arch/powerpc platforms
-CONFIG_FSL_DPAA=y
-CONFIG_FSL_FMAN=y
-CONFIG_FSL_DPAA_ETH=y
-CONFIG_FSL_XGMAC_MDIO=y
+  # common for arch/arm64 and arch/powerpc platforms
+  CONFIG_FSL_DPAA=y
+  CONFIG_FSL_FMAN=y
+  CONFIG_FSL_DPAA_ETH=y
+  CONFIG_FSL_XGMAC_MDIO=y
 
-# for arch/powerpc only
-CONFIG_FSL_PAMU=y
+  # for arch/powerpc only
+  CONFIG_FSL_PAMU=y
 
-# common options needed for the PHYs used on the RDBs
-CONFIG_VITESSE_PHY=y
-CONFIG_REALTEK_PHY=y
-CONFIG_AQUANTIA_PHY=y
+  # common options needed for the PHYs used on the RDBs
+  CONFIG_VITESSE_PHY=y
+  CONFIG_REALTEK_PHY=y
+  CONFIG_AQUANTIA_PHY=y
 
 DPAA Ethernet Frame Processing
 ==============================
@@ -167,7 +173,9 @@ classes as follows:
 	* priorities 8 to 11 - traffic class 2 (medium-high priority)
 	* priorities 12 to 15 - traffic class 3 (high priority)
 
-tc qdisc add dev <int> root handle 1: \
+::
+
+  tc qdisc add dev <int> root handle 1: \
 	 mqprio num_tc 4 map 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 hw 1
 
 DPAA IRQ Affinity and Receive Side Scaling
@@ -201,11 +209,11 @@ of these frame queues will arrive at the same portal and will always
 be processed by the same CPU. This ensures intra-flow order preservation
 and workload distribution for multiple traffic flows.
 
-RSS can be turned off for a certain interface using ethtool, i.e.
+RSS can be turned off for a certain interface using ethtool, i.e.::
 
 	# ethtool -N fm1-mac9 rx-flow-hash tcp4 ""
 
-To turn it back on, one needs to set rx-flow-hash for tcp4/6 or udp4/6:
+To turn it back on, one needs to set rx-flow-hash for tcp4/6 or udp4/6::
 
 	# ethtool -N fm1-mac9 rx-flow-hash udp4 sfdn
 
@@ -216,7 +224,7 @@ going to control the rx-flow-hashing for all protocols on that interface.
 Besides using the FMan Keygen computed hash for spreading traffic on the
 128 Rx FQs, the DPAA Ethernet driver also sets the skb hash value when
 the NETIF_F_RXHASH feature is on (active by default). This can be turned
-on or off through ethtool, i.e.:
+on or off through ethtool, i.e.::
 
 	# ethtool -K fm1-mac9 rx-hashing off
 	# ethtool -k fm1-mac9 | grep hash
@@ -246,6 +254,7 @@ The following statistics are exported for each interface through ethtool:
 	- Rx error count per CPU
 	- Rx error count per type
 	- congestion related statistics:
+
 		- congestion status
 		- time spent in congestion
 		- number of time the device entered congestion
@@ -254,7 +263,7 @@ The following statistics are exported for each interface through ethtool:
 The driver also exports the following information in sysfs:
 
 	- the FQ IDs for each FQ type
-	/sys/devices/platform/soc/<addr>.fman/<addr>.ethernet/dpaa-ethernet.<id>/net/fm<nr>-mac<nr>/fqids
+	  /sys/devices/platform/soc/<addr>.fman/<addr>.ethernet/dpaa-ethernet.<id>/net/fm<nr>-mac<nr>/fqids
 
 	- the ID of the buffer pool in use
-	/sys/devices/platform/soc/<addr>.fman/<addr>.ethernet/dpaa-ethernet.<id>/net/fm<nr>-mac<nr>/bpids
+	  /sys/devices/platform/soc/<addr>.fman/<addr>.ethernet/dpaa-ethernet.<id>/net/fm<nr>-mac<nr>/bpids
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index e5d1863379cb..7e59ee43c030 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -37,6 +37,7 @@ Contents:
    dec/de4x5
    dec/dmfe
    dlink/dl2k
+   freescale/dpaa
 
 .. only::  subproject and html
 
-- 
2.25.4


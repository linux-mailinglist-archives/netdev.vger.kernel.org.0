Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8D61C18A8
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgEAOsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729470AbgEAOpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:08 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F10BA24987;
        Fri,  1 May 2020 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344306;
        bh=LzZm9/U3E6zV1Rtxksb2atmQbCTG1SrCaFI5en8K55Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5TepsA1cD/QrW2DKk8H0/Mv+39uUtcne4cefhlWfRxc14ZZTJ2yvJnNGKMUMIZpx
         dMk8v1APZb6tVZmXy6UHLxtby3QHefx555v6JeJxZ1yeT1XuXpvKTYhxW6z7KejGhg
         NMOM+4eKD9XlbPvDsYTmn8ZTm7OSq6Qq9bsoQzfE=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCdY-J1; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 14/37] docs: networking: device drivers: convert amazon/ena.txt to ReST
Date:   Fri,  1 May 2020 16:44:36 +0200
Message-Id: <1c8f7109570ea829ed832596a14ec1f76b59e5ec.1588344146.git.mchehab+huawei@kernel.org>
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
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../amazon/{ena.txt => ena.rst}               | 142 +++++++++++-------
 .../networking/device_drivers/index.rst       |   1 +
 MAINTAINERS                                   |   2 +-
 3 files changed, 91 insertions(+), 54 deletions(-)
 rename Documentation/networking/device_drivers/amazon/{ena.txt => ena.rst} (86%)

diff --git a/Documentation/networking/device_drivers/amazon/ena.txt b/Documentation/networking/device_drivers/amazon/ena.rst
similarity index 86%
rename from Documentation/networking/device_drivers/amazon/ena.txt
rename to Documentation/networking/device_drivers/amazon/ena.rst
index 1bb55c7b604c..11af6388ea87 100644
--- a/Documentation/networking/device_drivers/amazon/ena.txt
+++ b/Documentation/networking/device_drivers/amazon/ena.rst
@@ -1,8 +1,12 @@
-Linux kernel driver for Elastic Network Adapter (ENA) family:
-=============================================================
+.. SPDX-License-Identifier: GPL-2.0
+
+============================================================
+Linux kernel driver for Elastic Network Adapter (ENA) family
+============================================================
+
+Overview
+========
 
-Overview:
-=========
 ENA is a networking interface designed to make good use of modern CPU
 features and system architectures.
 
@@ -35,32 +39,40 @@ debug logs.
 Some of the ENA devices support a working mode called Low-latency
 Queue (LLQ), which saves several more microseconds.
 
-Supported PCI vendor ID/device IDs:
+Supported PCI vendor ID/device IDs
+==================================
+
+=========   =======================
+1d0f:0ec2   ENA PF
+1d0f:1ec2   ENA PF with LLQ support
+1d0f:ec20   ENA VF
+1d0f:ec21   ENA VF with LLQ support
+=========   =======================
+
+ENA Source Code Directory Structure
 ===================================
-1d0f:0ec2 - ENA PF
-1d0f:1ec2 - ENA PF with LLQ support
-1d0f:ec20 - ENA VF
-1d0f:ec21 - ENA VF with LLQ support
 
-ENA Source Code Directory Structure:
-====================================
-ena_com.[ch]      - Management communication layer. This layer is
-                    responsible for the handling all the management
-                    (admin) communication between the device and the
-                    driver.
-ena_eth_com.[ch]  - Tx/Rx data path.
-ena_admin_defs.h  - Definition of ENA management interface.
-ena_eth_io_defs.h - Definition of ENA data path interface.
-ena_common_defs.h - Common definitions for ena_com layer.
-ena_regs_defs.h   - Definition of ENA PCI memory-mapped (MMIO) registers.
-ena_netdev.[ch]   - Main Linux kernel driver.
-ena_syfsfs.[ch]   - Sysfs files.
-ena_ethtool.c     - ethtool callbacks.
-ena_pci_id_tbl.h  - Supported device IDs.
+=================   ======================================================
+ena_com.[ch]        Management communication layer. This layer is
+		    responsible for the handling all the management
+		    (admin) communication between the device and the
+		    driver.
+ena_eth_com.[ch]    Tx/Rx data path.
+ena_admin_defs.h    Definition of ENA management interface.
+ena_eth_io_defs.h   Definition of ENA data path interface.
+ena_common_defs.h   Common definitions for ena_com layer.
+ena_regs_defs.h     Definition of ENA PCI memory-mapped (MMIO) registers.
+ena_netdev.[ch]     Main Linux kernel driver.
+ena_syfsfs.[ch]     Sysfs files.
+ena_ethtool.c       ethtool callbacks.
+ena_pci_id_tbl.h    Supported device IDs.
+=================   ======================================================
 
 Management Interface:
 =====================
+
 ENA management interface is exposed by means of:
+
 - PCIe Configuration Space
 - Device Registers
 - Admin Queue (AQ) and Admin Completion Queue (ACQ)
@@ -78,6 +90,7 @@ vendor-specific extensions. Most of the management operations are
 framed in a generic Get/Set feature command.
 
 The following admin queue commands are supported:
+
 - Create I/O submission queue
 - Create I/O completion queue
 - Destroy I/O submission queue
@@ -96,12 +109,16 @@ be reported using ACQ. AENQ events are subdivided into groups. Each
 group may have multiple syndromes, as shown below
 
 The events are:
+
+	====================	===============
 	Group			Syndrome
-	Link state change	- X -
-	Fatal error		- X -
+	====================	===============
+	Link state change	**X**
+	Fatal error		**X**
 	Notification		Suspend traffic
 	Notification		Resume traffic
-	Keep-Alive		- X -
+	Keep-Alive		**X**
+	====================	===============
 
 ACQ and AENQ share the same MSI-X vector.
 
@@ -113,8 +130,8 @@ the device every second. The driver re-arms the WD upon reception of a
 Keep-Alive event. A missed Keep-Alive event causes the WD handler to
 fire.
 
-Data Path Interface:
-====================
+Data Path Interface
+===================
 I/O operations are based on Tx and Rx Submission Queues (Tx SQ and Rx
 SQ correspondingly). Each SQ has a completion queue (CQ) associated
 with it.
@@ -123,11 +140,15 @@ The SQs and CQs are implemented as descriptor rings in contiguous
 physical memory.
 
 The ENA driver supports two Queue Operation modes for Tx SQs:
+
 - Regular mode
+
   * In this mode the Tx SQs reside in the host's memory. The ENA
     device fetches the ENA Tx descriptors and packet data from host
     memory.
+
 - Low Latency Queue (LLQ) mode or "push-mode".
+
   * In this mode the driver pushes the transmit descriptors and the
     first 128 bytes of the packet directly to the ENA device memory
     space. The rest of the packet payload is fetched by the
@@ -142,6 +163,7 @@ Note: Not all ENA devices support LLQ, and this feature is negotiated
 
 The driver supports multi-queue for both Tx and Rx. This has various
 benefits:
+
 - Reduced CPU/thread/process contention on a given Ethernet interface.
 - Cache miss rate on completion is reduced, particularly for data
   cache lines that hold the sk_buff structures.
@@ -151,8 +173,8 @@ benefits:
   packet is running.
 - In hardware interrupt re-direction.
 
-Interrupt Modes:
-================
+Interrupt Modes
+===============
 The driver assigns a single MSI-X vector per queue pair (for both Tx
 and Rx directions). The driver assigns an additional dedicated MSI-X vector
 for management (for ACQ and AENQ).
@@ -163,9 +185,12 @@ removed. I/O queue interrupt registration is performed when the Linux
 interface of the adapter is opened, and it is de-registered when the
 interface is closed.
 
-The management interrupt is named:
+The management interrupt is named::
+
    ena-mgmnt@pci:<PCI domain:bus:slot.function>
-and for each queue pair, an interrupt is named:
+
+and for each queue pair, an interrupt is named::
+
    <interface name>-Tx-Rx-<queue index>
 
 The ENA device operates in auto-mask and auto-clear interrupt
@@ -173,8 +198,8 @@ modes. That is, once MSI-X is delivered to the host, its Cause bit is
 automatically cleared and the interrupt is masked. The interrupt is
 unmasked by the driver after NAPI processing is complete.
 
-Interrupt Moderation:
-=====================
+Interrupt Moderation
+====================
 ENA driver and device can operate in conventional or adaptive interrupt
 moderation mode.
 
@@ -202,45 +227,46 @@ delay value to each level.
 The user can enable/disable adaptive moderation, modify the interrupt
 delay table and restore its default values through sysfs.
 
-RX copybreak:
-=============
+RX copybreak
+============
 The rx_copybreak is initialized by default to ENA_DEFAULT_RX_COPYBREAK
 and can be configured by the ETHTOOL_STUNABLE command of the
 SIOCETHTOOL ioctl.
 
-SKB:
-====
+SKB
+===
 The driver-allocated SKB for frames received from Rx handling using
 NAPI context. The allocation method depends on the size of the packet.
 If the frame length is larger than rx_copybreak, napi_get_frags()
 is used, otherwise netdev_alloc_skb_ip_align() is used, the buffer
 content is copied (by CPU) to the SKB, and the buffer is recycled.
 
-Statistics:
-===========
+Statistics
+==========
 The user can obtain ENA device and driver statistics using ethtool.
 The driver can collect regular or extended statistics (including
 per-queue stats) from the device.
 
 In addition the driver logs the stats to syslog upon device reset.
 
-MTU:
-====
+MTU
+===
 The driver supports an arbitrarily large MTU with a maximum that is
 negotiated with the device. The driver configures MTU using the
 SetFeature command (ENA_ADMIN_MTU property). The user can change MTU
 via ip(8) and similar legacy tools.
 
-Stateless Offloads:
-===================
+Stateless Offloads
+==================
 The ENA driver supports:
+
 - TSO over IPv4/IPv6
 - TSO with ECN
 - IPv4 header checksum offload
 - TCP/UDP over IPv4/IPv6 checksum offloads
 
-RSS:
-====
+RSS
+===
 - The ENA device supports RSS that allows flexible Rx traffic
   steering.
 - Toeplitz and CRC32 hash functions are supported.
@@ -255,11 +281,13 @@ RSS:
 - The user can provide a hash key, hash function, and configure the
   indirection table through ethtool(8).
 
-DATA PATH:
-==========
-Tx:
----
+DATA PATH
+=========
+Tx
+--
+
 end_start_xmit() is called by the stack. This function does the following:
+
 - Maps data buffers (skb->data and frags).
 - Populates ena_buf for the push buffer (if the driver and device are
   in push mode.)
@@ -271,8 +299,10 @@ end_start_xmit() is called by the stack. This function does the following:
 - Calls ena_com_prepare_tx(), an ENA communication layer that converts
   the ena_bufs to ENA descriptors (and adds meta ENA descriptors as
   needed.)
+
   * This function also copies the ENA descriptors and the push buffer
     to the Device memory space (if in push mode.)
+
 - Writes doorbell to the ENA device.
 - When the ENA device finishes sending the packet, a completion
   interrupt is raised.
@@ -280,14 +310,16 @@ end_start_xmit() is called by the stack. This function does the following:
 - The ena_clean_tx_irq() function is called. This function handles the
   completion descriptors generated by the ENA, with a single
   completion descriptor per completed packet.
+
   * req_id is retrieved from the completion descriptor. The tx_info of
     the packet is retrieved via the req_id. The data buffers are
     unmapped and req_id is returned to the empty req_id ring.
   * The function stops when the completion descriptors are completed or
     the budget is reached.
 
-Rx:
----
+Rx
+--
+
 - When a packet is received from the ENA device.
 - The interrupt handler schedules NAPI.
 - The ena_clean_rx_irq() function is called. This function calls
@@ -296,13 +328,17 @@ Rx:
   no new packet is found.
 - Then it calls the ena_clean_rx_irq() function.
 - ena_eth_rx_skb() checks packet length:
+
   * If the packet is small (len < rx_copybreak), the driver allocates
     a SKB for the new packet, and copies the packet payload into the
     SKB data buffer.
+
     - In this way the original data buffer is not passed to the stack
       and is reused for future Rx packets.
+
   * Otherwise the function unmaps the Rx buffer, then allocates the
     new SKB structure and hooks the Rx buffer to the SKB frags.
+
 - The new SKB is updated with the necessary information (protocol,
   checksum hw verify result, etc.), and then passed to the network
   stack, using the NAPI interface function napi_gro_receive().
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index aaac502b81ea..019a0d2efe67 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -29,6 +29,7 @@ Contents:
    stmicro/stmmac
    3com/3c509
    3com/vortex
+   amazon/ena
 
 .. only::  subproject and html
 
diff --git a/MAINTAINERS b/MAINTAINERS
index a45ab6a25942..990d1414ffd6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -816,7 +816,7 @@ R:	Saeed Bishara <saeedb@amazon.com>
 R:	Zorik Machulsky <zorik@amazon.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	Documentation/networking/device_drivers/amazon/ena.txt
+F:	Documentation/networking/device_drivers/amazon/ena.rst
 F:	drivers/net/ethernet/amazon/
 
 AMAZON RDMA EFA DRIVER
-- 
2.25.4


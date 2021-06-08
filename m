Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E38A39FBA6
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhFHQFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:05:22 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:58409 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbhFHQFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:05:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623168203; x=1654704203;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RxiNfMYUR4YioK3sN8aPaWH86Ii1jTjzkAktwL6EtWk=;
  b=awoMHI81MFC63SuMYHcLwNG5WFbTon0PEOmo2JYK2yo1zyt2MmDKAL28
   LsazCwbPC1joV/MpTDX1p+Y/cihlgkwrGjfzN/PAVQlblFEajue9kplcR
   jMEaBZH6c6JmjI/Ooy+pPcgGhI+gk1SNF0+vwgkTY06t0xDX4A1ocdSGp
   g=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="139068983"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 08 Jun 2021 16:03:16 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id C286BA4EBE;
        Tue,  8 Jun 2021 16:03:14 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.160.137) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:03:07 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: [Patch v1 net-next 07/10] net: ena: fix RST format in ENA documentation file
Date:   Tue, 8 Jun 2021 19:01:15 +0300
Message-ID: <20210608160118.3767932-8-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608160118.3767932-1-shayagr@amazon.com>
References: <20210608160118.3767932-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D35UWC003.ant.amazon.com (10.43.162.130) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The documentation file used to be written in markdown format but was
converted to reStructuredText (rst).

The converted file doesn't keep up with rst format requirements which
results in hard-to-read text.

This patch fixes the formatting of the file. The patch also
* Highlights and emphasizes some lines to improve readability
* Rephrases some hard-to-understand text
* Updates outdated function descriptions.
* Removes TSO description which falsely claims the driver supports it

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 .../device_drivers/ethernet/amazon/ena.rst    | 164 +++++++++---------
 1 file changed, 78 insertions(+), 86 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index f8c6469f2bd2..01b2a69b0cb0 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -11,12 +11,12 @@ ENA is a networking interface designed to make good use of modern CPU
 features and system architectures.
 
 The ENA device exposes a lightweight management interface with a
-minimal set of memory mapped registers and extendable command set
+minimal set of memory mapped registers and extendible command set
 through an Admin Queue.
 
 The driver supports a range of ENA devices, is link-speed independent
-(i.e., the same driver is used for 10GbE, 25GbE, 40GbE, etc.), and has
-a negotiated and extendable feature set.
+(i.e., the same driver is used for 10GbE, 25GbE, 40GbE, etc), and has
+a negotiated and extendible feature set.
 
 Some ENA devices support SR-IOV. This driver is used for both the
 SR-IOV Physical Function (PF) and Virtual Function (VF) devices.
@@ -27,9 +27,9 @@ is advertised by the device via the Admin Queue), a dedicated MSI-X
 interrupt vector per Tx/Rx queue pair, adaptive interrupt moderation,
 and CPU cacheline optimized data placement.
 
-The ENA driver supports industry standard TCP/IP offload features such
-as checksum offload and TCP transmit segmentation offload (TSO).
-Receive-side scaling (RSS) is supported for multi-core scaling.
+The ENA driver supports industry standard TCP/IP offload features such as
+checksum offload. Receive-side scaling (RSS) is supported for multi-core
+scaling.
 
 The ENA driver and its corresponding devices implement health
 monitoring mechanisms such as watchdog, enabling the device and driver
@@ -38,22 +38,20 @@ debug logs.
 
 Some of the ENA devices support a working mode called Low-latency
 Queue (LLQ), which saves several more microseconds.
-
 ENA Source Code Directory Structure
 ===================================
 
 =================   ======================================================
 ena_com.[ch]        Management communication layer. This layer is
-		    responsible for the handling all the management
-		    (admin) communication between the device and the
-		    driver.
+                    responsible for the handling all the management
+                    (admin) communication between the device and the
+                    driver.
 ena_eth_com.[ch]    Tx/Rx data path.
 ena_admin_defs.h    Definition of ENA management interface.
 ena_eth_io_defs.h   Definition of ENA data path interface.
 ena_common_defs.h   Common definitions for ena_com layer.
 ena_regs_defs.h     Definition of ENA PCI memory-mapped (MMIO) registers.
 ena_netdev.[ch]     Main Linux kernel driver.
-ena_syfsfs.[ch]     Sysfs files.
 ena_ethtool.c       ethtool callbacks.
 ena_pci_id_tbl.h    Supported device IDs.
 =================   ======================================================
@@ -69,7 +67,7 @@ ENA management interface is exposed by means of:
 - Asynchronous Event Notification Queue (AENQ)
 
 ENA device MMIO Registers are accessed only during driver
-initialization and are not involved in further normal device
+initialization and are not used during further normal device
 operation.
 
 AQ is used for submitting management commands, and the
@@ -100,28 +98,27 @@ group may have multiple syndromes, as shown below
 
 The events are:
 
-	====================	===============
-	Group			Syndrome
-	====================	===============
-	Link state change	**X**
-	Fatal error		**X**
-	Notification		Suspend traffic
-	Notification		Resume traffic
-	Keep-Alive		**X**
-	====================	===============
+====================    ===============
+Group                   Syndrome
+====================    ===============
+Link state change       **X**
+Fatal error             **X**
+Notification            Suspend traffic
+Notification            Resume traffic
+Keep-Alive              **X**
+====================    ===============
 
 ACQ and AENQ share the same MSI-X vector.
 
-Keep-Alive is a special mechanism that allows monitoring of the
-device's health. The driver maintains a watchdog (WD) handler which,
-if fired, logs the current state and statistics then resets and
-restarts the ENA device and driver. A Keep-Alive event is delivered by
-the device every second. The driver re-arms the WD upon reception of a
-Keep-Alive event. A missed Keep-Alive event causes the WD handler to
-fire.
+Keep-Alive is a special mechanism that allows monitoring the device's health.
+A Keep-Alive event is delivered by the device every second.
+The driver maintains a watchdog (WD) handler which logs the current state and
+statistics. If the keep-alive events aren't delivered as expected the WD resets
+the device and the driver.
 
 Data Path Interface
 ===================
+
 I/O operations are based on Tx and Rx Submission Queues (Tx SQ and Rx
 SQ correspondingly). Each SQ has a completion queue (CQ) associated
 with it.
@@ -131,26 +128,24 @@ physical memory.
 
 The ENA driver supports two Queue Operation modes for Tx SQs:
 
-- Regular mode
+- **Regular mode:**
+  In this mode the Tx SQs reside in the host's memory. The ENA
+  device fetches the ENA Tx descriptors and packet data from host
+  memory.
 
-  * In this mode the Tx SQs reside in the host's memory. The ENA
-    device fetches the ENA Tx descriptors and packet data from host
-    memory.
+- **Low Latency Queue (LLQ) mode or "push-mode":**
+  In this mode the driver pushes the transmit descriptors and the
+  first 128 bytes of the packet directly to the ENA device memory
+  space. The rest of the packet payload is fetched by the
+  device. For this operation mode, the driver uses a dedicated PCI
+  device memory BAR, which is mapped with write-combine capability.
 
-- Low Latency Queue (LLQ) mode or "push-mode".
-
-  * In this mode the driver pushes the transmit descriptors and the
-    first 128 bytes of the packet directly to the ENA device memory
-    space. The rest of the packet payload is fetched by the
-    device. For this operation mode, the driver uses a dedicated PCI
-    device memory BAR, which is mapped with write-combine capability.
+  **Note that** not all ENA devices support LLQ, and this feature is negotiated
+  with the device upon initialization. If the ENA device does not
+  support LLQ mode, the driver falls back to the regular mode.
 
 The Rx SQs support only the regular mode.
 
-Note: Not all ENA devices support LLQ, and this feature is negotiated
-      with the device upon initialization. If the ENA device does not
-      support LLQ mode, the driver falls back to the regular mode.
-
 The driver supports multi-queue for both Tx and Rx. This has various
 benefits:
 
@@ -165,6 +160,7 @@ benefits:
 
 Interrupt Modes
 ===============
+
 The driver assigns a single MSI-X vector per queue pair (for both Tx
 and Rx directions). The driver assigns an additional dedicated MSI-X vector
 for management (for ACQ and AENQ).
@@ -190,20 +186,21 @@ unmasked by the driver after NAPI processing is complete.
 
 Interrupt Moderation
 ====================
+
 ENA driver and device can operate in conventional or adaptive interrupt
 moderation mode.
 
-In conventional mode the driver instructs device to postpone interrupt
+**In conventional mode** the driver instructs device to postpone interrupt
 posting according to static interrupt delay value. The interrupt delay
-value can be configured through ethtool(8). The following ethtool
-parameters are supported by the driver: tx-usecs, rx-usecs
+value can be configured through `ethtool(8)`. The following `ethtool`
+parameters are supported by the driver: ``tx-usecs``, ``rx-usecs``
 
-In adaptive interrupt moderation mode the interrupt delay value is
+**In adaptive interrupt** moderation mode the interrupt delay value is
 updated by the driver dynamically and adjusted every NAPI cycle
 according to the traffic nature.
 
-Adaptive coalescing can be switched on/off through ethtool(8)
-adaptive_rx on|off parameter.
+Adaptive coalescing can be switched on/off through `ethtool(8)`'s
+:code:`adaptive_rx on|off` parameter.
 
 More information about Adaptive Interrupt Moderation (DIM) can be found in
 Documentation/networking/net_dim.rst
@@ -214,17 +211,10 @@ The rx_copybreak is initialized by default to ENA_DEFAULT_RX_COPYBREAK
 and can be configured by the ETHTOOL_STUNABLE command of the
 SIOCETHTOOL ioctl.
 
-SKB
-===
-The driver-allocated SKB for frames received from Rx handling using
-NAPI context. The allocation method depends on the size of the packet.
-If the frame length is larger than rx_copybreak, napi_get_frags()
-is used, otherwise netdev_alloc_skb_ip_align() is used, the buffer
-content is copied (by CPU) to the SKB, and the buffer is recycled.
-
 Statistics
 ==========
-The user can obtain ENA device and driver statistics using ethtool.
+
+The user can obtain ENA device and driver statistics using `ethtool`.
 The driver can collect regular or extended statistics (including
 per-queue stats) from the device.
 
@@ -232,22 +222,23 @@ In addition the driver logs the stats to syslog upon device reset.
 
 MTU
 ===
+
 The driver supports an arbitrarily large MTU with a maximum that is
 negotiated with the device. The driver configures MTU using the
 SetFeature command (ENA_ADMIN_MTU property). The user can change MTU
-via ip(8) and similar legacy tools.
+via `ip(8)` and similar legacy tools.
 
 Stateless Offloads
 ==================
+
 The ENA driver supports:
 
-- TSO over IPv4/IPv6
-- TSO with ECN
 - IPv4 header checksum offload
 - TCP/UDP over IPv4/IPv6 checksum offloads
 
 RSS
 ===
+
 - The ENA device supports RSS that allows flexible Rx traffic
   steering.
 - Toeplitz and CRC32 hash functions are supported.
@@ -260,41 +251,42 @@ RSS
   function delivered in the Rx CQ descriptor is set in the received
   SKB.
 - The user can provide a hash key, hash function, and configure the
-  indirection table through ethtool(8).
+  indirection table through `ethtool(8)`.
 
 DATA PATH
 =========
+
 Tx
 --
 
-ena_start_xmit() is called by the stack. This function does the following:
+:code:`ena_start_xmit()` is called by the stack. This function does the following:
 
-- Maps data buffers (skb->data and frags).
-- Populates ena_buf for the push buffer (if the driver and device are
-  in push mode.)
+- Maps data buffers (``skb->data`` and frags).
+- Populates ``ena_buf`` for the push buffer (if the driver and device are
+  in push mode).
 - Prepares ENA bufs for the remaining frags.
-- Allocates a new request ID from the empty req_id ring. The request
+- Allocates a new request ID from the empty ``req_id`` ring. The request
   ID is the index of the packet in the Tx info. This is used for
-  out-of-order TX completions.
+  out-of-order Tx completions.
 - Adds the packet to the proper place in the Tx ring.
-- Calls ena_com_prepare_tx(), an ENA communication layer that converts
-  the ena_bufs to ENA descriptors (and adds meta ENA descriptors as
-  needed.)
+- Calls :code:`ena_com_prepare_tx()`, an ENA communication layer that converts
+  the ``ena_bufs`` to ENA descriptors (and adds meta ENA descriptors as
+  needed).
 
   * This function also copies the ENA descriptors and the push buffer
-    to the Device memory space (if in push mode.)
+    to the Device memory space (if in push mode).
 
-- Writes doorbell to the ENA device.
+- Writes a doorbell to the ENA device.
 - When the ENA device finishes sending the packet, a completion
   interrupt is raised.
 - The interrupt handler schedules NAPI.
-- The ena_clean_tx_irq() function is called. This function handles the
+- The :code:`ena_clean_tx_irq()` function is called. This function handles the
   completion descriptors generated by the ENA, with a single
   completion descriptor per completed packet.
 
-  * req_id is retrieved from the completion descriptor. The tx_info of
-    the packet is retrieved via the req_id. The data buffers are
-    unmapped and req_id is returned to the empty req_id ring.
+  * ``req_id`` is retrieved from the completion descriptor. The ``tx_info`` of
+    the packet is retrieved via the ``req_id``. The data buffers are
+    unmapped and ``req_id`` is returned to the empty ``req_id`` ring.
   * The function stops when the completion descriptors are completed or
     the budget is reached.
 
@@ -303,12 +295,11 @@ Rx
 
 - When a packet is received from the ENA device.
 - The interrupt handler schedules NAPI.
-- The ena_clean_rx_irq() function is called. This function calls
-  ena_rx_pkt(), an ENA communication layer function, which returns the
-  number of descriptors used for a new unhandled packet, and zero if
+- The :code:`ena_clean_rx_irq()` function is called. This function calls
+  :code:`ena_com_rx_pkt()`, an ENA communication layer function, which returns the
+  number of descriptors used for a new packet, and zero if
   no new packet is found.
-- Then it calls the ena_clean_rx_irq() function.
-- ena_eth_rx_skb() checks packet length:
+- :code:`ena_rx_skb()` checks packet length:
 
   * If the packet is small (len < rx_copybreak), the driver allocates
     a SKB for the new packet, and copies the packet payload into the
@@ -317,9 +308,10 @@ Rx
     - In this way the original data buffer is not passed to the stack
       and is reused for future Rx packets.
 
-  * Otherwise the function unmaps the Rx buffer, then allocates the
-    new SKB structure and hooks the Rx buffer to the SKB frags.
+  * Otherwise the function unmaps the Rx buffer, sets the first
+    descriptor as `skb`'s linear part and the other descriptors as the
+    `skb`'s frags.
 
 - The new SKB is updated with the necessary information (protocol,
-  checksum hw verify result, etc.), and then passed to the network
-  stack, using the NAPI interface function napi_gro_receive().
+  checksum hw verify result, etc), and then passed to the network
+  stack, using the NAPI interface function :code:`napi_gro_receive()`.
-- 
2.25.1


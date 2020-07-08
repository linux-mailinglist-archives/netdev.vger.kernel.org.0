Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281F121812F
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 09:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbgGHH0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 03:26:20 -0400
Received: from mga03.intel.com ([134.134.136.65]:15287 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730279AbgGHH0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 03:26:19 -0400
IronPort-SDR: O/Zj2jhczkMT+IPYKJbJ8lydDTB12RJQbgbOdBGksUTf/aWpNIkgJJHSPW8ub9XsTQKcij18uo
 ObtV1atO0B1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="147759450"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="147759450"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 00:26:18 -0700
IronPort-SDR: CByh53ZrPYft6rgu4wbs/3b47Nhg62pvQHmCrzrbS8h48mg30/3rTZWZT+sgEkTpkxinwS1ycE
 +3sXROn1fXkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="358025287"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga001.jf.intel.com with ESMTP; 08 Jul 2020 00:26:15 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 10/10] net: eth: altera: update devicetree bindings documentation
Date:   Wed,  8 Jul 2020 15:24:01 +0800
Message-Id: <20200708072401.169150-11-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200708072401.169150-1-joyce.ooi@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@intel.com>

Update devicetree bindings documentation to include msgdma
prefetcher and ptp bindings.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
v2: no change
v3: no change
v4: no change
---
 .../devicetree/bindings/net/altera_tse.txt         | 103 +++++++++++++++++----
 1 file changed, 84 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/altera_tse.txt b/Documentation/devicetree/bindings/net/altera_tse.txt
index 0b7d4d3758ea..2f2d12603907 100644
--- a/Documentation/devicetree/bindings/net/altera_tse.txt
+++ b/Documentation/devicetree/bindings/net/altera_tse.txt
@@ -2,53 +2,86 @@
 
 Required properties:
 - compatible: Should be "altr,tse-1.0" for legacy SGDMA based TSE, and should
-		be "altr,tse-msgdma-1.0" for the preferred MSGDMA based TSE.
+		be "altr,tse-msgdma-1.0" for the preferred MSGDMA based TSE,
+		and "altr,tse-msgdma-2.0" for MSGDMA with prefetcher based
+		implementations.
 		ALTR is supported for legacy device trees, but is deprecated.
 		altr should be used for all new designs.
 - reg: Address and length of the register set for the device. It contains
   the information of registers in the same order as described by reg-names
 - reg-names: Should contain the reg names
-  "control_port": MAC configuration space region
-  "tx_csr":       xDMA Tx dispatcher control and status space region
-  "tx_desc":      MSGDMA Tx dispatcher descriptor space region
-  "rx_csr" :      xDMA Rx dispatcher control and status space region
-  "rx_desc":      MSGDMA Rx dispatcher descriptor space region
-  "rx_resp":      MSGDMA Rx dispatcher response space region
-  "s1":		  SGDMA descriptor memory
 - interrupts: Should contain the TSE interrupts and it's mode.
 - interrupt-names: Should contain the interrupt names
-  "rx_irq":       xDMA Rx dispatcher interrupt
-  "tx_irq":       xDMA Tx dispatcher interrupt
+  "rx_irq":       DMA Rx dispatcher interrupt
+  "tx_irq":       DMA Tx dispatcher interrupt
 - rx-fifo-depth: MAC receive FIFO buffer depth in bytes
 - tx-fifo-depth: MAC transmit FIFO buffer depth in bytes
 - phy-mode: See ethernet.txt in the same directory.
 - phy-handle: See ethernet.txt in the same directory.
 - phy-addr: See ethernet.txt in the same directory. A configuration should
 		include phy-handle or phy-addr.
-- altr,has-supplementary-unicast:
-		If present, TSE supports additional unicast addresses.
-		Otherwise additional unicast addresses are not supported.
-- altr,has-hash-multicast-filter:
-		If present, TSE supports a hash based multicast filter.
-		Otherwise, hash-based multicast filtering is not supported.
-
 - mdio device tree subnode: When the TSE has a phy connected to its local
 		mdio, there must be device tree subnode with the following
 		required properties:
-
 	- compatible: Must be "altr,tse-mdio".
 	- #address-cells: Must be <1>.
 	- #size-cells: Must be <0>.
 
 	For each phy on the mdio bus, there must be a node with the following
 	fields:
-
 	- reg: phy id used to communicate to phy.
 	- device_type: Must be "ethernet-phy".
 
 The MAC address will be determined using the optional properties defined in
 ethernet.txt.
 
+- altr,has-supplementary-unicast:
+		If present, TSE supports additional unicast addresses.
+		Otherwise additional unicast addresses are not supported.
+- altr,has-hash-multicast-filter:
+		If present, TSE supports a hash based multicast filter.
+		Otherwise, hash-based multicast filtering is not supported.
+- altr,has-ptp:
+		If present, TSE supports 1588 timestamping.  Currently only
+		supported with the msgdma prefetcher.
+- altr,tx-poll-cnt:
+		Optional cycle count for Tx prefetcher to poll descriptor
+		list.  If not present, defaults to 128, which at 125MHz is
+		roughly 1usec. Only for "altr,tse-msgdma-2.0".
+- altr,rx-poll-cnt:
+		Optional cycle count for Tx prefetcher to poll descriptor
+		list.  If not present, defaults to 128, which at 125MHz is
+		roughly 1usec. Only for "altr,tse-msgdma-2.0".
+
+Required registers by compatibility string:
+ - "altr,tse-1.0"
+	"control_port": MAC configuration space region
+	"tx_csr":       DMA Tx dispatcher control and status space region
+	"rx_csr" :      DMA Rx dispatcher control and status space region
+	"s1":		DMA descriptor memory
+
+ - "altr,tse-msgdma-1.0"
+	"control_port": MAC configuration space region
+	"tx_csr":       DMA Tx dispatcher control and status space region
+	"tx_desc":      DMA Tx dispatcher descriptor space region
+	"rx_csr" :      DMA Rx dispatcher control and status space region
+	"rx_desc":      DMA Rx dispatcher descriptor space region
+	"rx_resp":      DMA Rx dispatcher response space region
+
+ - "altr,tse-msgdma-2.0"
+	"control_port": MAC configuration space region
+	"tx_csr":       DMA Tx dispatcher control and status space region
+	"tx_pref":      DMA Tx prefetcher configuration space region
+	"rx_csr" :      DMA Rx dispatcher control and status space region
+	"rx_pref":      DMA Rx prefetcher configuration space region
+	"tod_ctrl":     Time of Day Control register only required when
+			timestamping support is enabled.  Timestamping is
+			only supported with the msgdma-2.0 implementation.
+
+Optional properties:
+- local-mac-address: See ethernet.txt in the same directory.
+- max-frame-size: See ethernet.txt in the same directory.
+
 Example:
 
 	tse_sub_0_eth_tse_0: ethernet@1,00000000 {
@@ -86,6 +119,11 @@ Example:
 				device_type = "ethernet-phy";
 			};
 
+			phy2: ethernet-phy@2 {
+				reg = <0x2>;
+				device_type = "ethernet-phy";
+			};
+
 		};
 	};
 
@@ -111,3 +149,30 @@ Example:
 		altr,has-hash-multicast-filter;
 		phy-handle = <&phy1>;
 	};
+
+
+	tse_sub_2_eth_tse_0: ethernet@1,00002000 {
+		compatible = "altr,tse-msgdma-2.0";
+		reg = 	<0x00000001 0x00002000 0x00000400>,
+			<0x00000001 0x00002400 0x00000020>,
+			<0x00000001 0x00002420 0x00000020>,
+			<0x00000001 0x00002440 0x00000020>,
+			<0x00000001 0x00002460 0x00000020>,
+			<0x00000001 0x00002480 0x00000040>;
+		reg-names = "control_port", "rx_csr", "rx_pref","tx_csr", "tx_pref", "tod_ctrl";
+		interrupt-parent = <&hps_0_arm_gic_0>;
+		interrupts = <0 45 4>, <0 44 4>;
+		interrupt-names = "rx_irq", "tx_irq";
+		rx-fifo-depth = <2048>;
+		tx-fifo-depth = <2048>;
+		address-bits = <48>;
+		max-frame-size = <1500>;
+		local-mac-address = [ 00 00 00 00 00 00 ];
+		phy-mode = "sgmii";
+		altr,has-supplementary-unicast;
+		altr,has-hash-multicast-filter;
+		altr,has-ptp;
+		altr,tx-poll-cnt = <128>;
+		altr,rx-poll-cnt = <32>;
+		phy-handle = <&phy2>;
+	};
-- 
2.13.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9748B22D6AC
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 12:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgGYKTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 06:19:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:54026 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgGYKTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 06:19:16 -0400
IronPort-SDR: EvP1JEY0RAegZnI/A+4uKiQGeI/+uvN9lGIwiznMBxpTSIS8diDrAkQ12Bj6zIdbiNYDUqYDgH
 naC9/KAy3WJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9692"; a="130382095"
X-IronPort-AV: E=Sophos;i="5.75,394,1589266800"; 
   d="scan'208";a="130382095"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2020 03:19:15 -0700
IronPort-SDR: r2+0/St3eP9ptLEo9qrkCYKwn0Ra2jZz0xB8yKTSFPQKB6/dh3EEovzrIU3kZw3Z680ovHwSug
 i7KefolJH00Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,394,1589266800"; 
   d="scan'208";a="327549428"
Received: from vgjayaku-ilbpg7.png.intel.com ([10.88.227.96])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Jul 2020 03:19:13 -0700
From:   vineetha.g.jaya.kumaran@intel.com
To:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        weifeng.voon@intel.com, hock.leong.kweh@intel.com,
        boon.leong.ong@intel.com
Subject: [PATCH v2 1/2] dt-bindings: net: Add bindings for Intel Keem Bay
Date:   Sat, 25 Jul 2020 18:17:58 +0800
Message-Id: <1595672279-13648-2-git-send-email-vineetha.g.jaya.kumaran@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1595672279-13648-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
References: <1595672279-13648-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>

Add Device Tree bindings documentation for the ethernet controller
on Intel Keem Bay.

Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
---
 .../devicetree/bindings/net/intel,dwmac-plat.yaml  | 121 +++++++++++++++++++++
 1 file changed, 121 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml

diff --git a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
new file mode 100644
index 00000000..e743ae7
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
@@ -0,0 +1,121 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/intel,dwmac-plat.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Intel DWMAC glue layer Device Tree Bindings
+
+maintainers:
+  - Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - intel,keembay-dwmac
+          - const: snps,dwmac-4.10a
+
+  clocks:
+    items:
+      - description: GMAC main clock
+      - description: PTP reference clock
+      - description: Tx clock
+
+  clock-names:
+    items:
+      - const: stmmaceth
+      - const: ptp_ref
+      - const: tx_clk
+
+required:
+  - compatible
+  - clocks
+  - clock-names
+
+examples:
+# FIXME: Remove defines and include the correct header file
+# once it is available in mainline.
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #define MOVISOC_KMB_PSS_GBE
+    #define MOVISOC_KMB_PSS_AUX_GBE_PTP
+    #define MOVISOC_KMB_PSS_AUX_GBE_TX
+
+    stmmac_axi_setup: stmmac-axi-config {
+        snps,lpi_en;
+        snps,wr_osr_lmt = <0x0>;
+        snps,rd_osr_lmt = <0x2>;
+        snps,blen = <0 0 0 0 16 8 4>;
+    };
+
+    mtl_rx_setup: rx-queues-config {
+        snps,rx-queues-to-use = <2>;
+        snps,rx-sched-sp;
+        queue0 {
+            snps,dcb-algorithm;
+            snps,map-to-dma-channel = <0x0>;
+            snps,priority = <0x0>;
+        };
+
+        queue1 {
+            snps,dcb-algorithm;
+            snps,map-to-dma-channel = <0x1>;
+            snps,priority = <0x1>;
+        };
+    };
+
+    mtl_tx_setup: tx-queues-config {
+        snps,tx-queues-to-use = <2>;
+        snps,tx-sched-wrr;
+        queue0 {
+           snps,weight = <0x10>;
+           snps,dcb-algorithm;
+           snps,priority = <0x0>;
+        };
+
+        queue1 {
+            snps,weight = <0x10>;
+            snps,dcb-algorithm;
+            snps,priority = <0x1>;
+        };
+    };
+
+    gmac0: ethernet@3a000000 {
+        compatible = "intel,keembay-dwmac", "snps,dwmac-4.10a";
+        interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "macirq";
+        reg = <0x3a000000 0x8000>;
+        snps,perfect-filter-entries = <128>;
+        phy-handle = <&eth_phy0>;
+        phy-mode = "rgmii";
+        rx-fifo-depth = <4096>;
+        tx-fifo-depth = <4096>;
+        clock-names = "stmmaceth", "ptp_ref", "tx_clk";
+        clocks = <&scmi_clk MOVISOC_KMB_PSS_GBE>,
+                 <&scmi_clk MOVISOC_KMB_PSS_AUX_GBE_PTP>,
+                 <&scmi_clk MOVISOC_KMB_PSS_AUX_GBE_TX>;
+        snps,pbl = <0x4>;
+        snps,axi-config = <&stmmac_axi_setup>;
+        snps,mtl-rx-config = <&mtl_rx_setup>;
+        snps,mtl-tx-config = <&mtl_tx_setup>;
+        snps,tso;
+        status = "okay";
+
+        mdio0 {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            compatible = "snps,dwmac-mdio";
+
+            ethernet-phy@0 {
+                reg = <0>;
+            };
+        };
+    };
+
+...
-- 
1.9.1


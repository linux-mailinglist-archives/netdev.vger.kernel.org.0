Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F171216588
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 06:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgGGEtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 00:49:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:18745 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbgGGEtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 00:49:14 -0400
IronPort-SDR: tv8GCjeeCDsXRA7wNo2/VeeLFSYZqfLTsPu5fxjKW4X1QuTd1FWjxTlk71PmznAmNWJJ9KGBkU
 iTIqq3iu6ZPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="135783250"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="135783250"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 21:49:13 -0700
IronPort-SDR: ypHzSTmK2tk+xSnHfkBFRFSkbhEL5ZzI+9V0TnBsBFNbS8ejpL9qM3ojolMSG35Ee/ea9e8wHX
 sbwEeXbKiZyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="279485183"
Received: from vgjayaku-ilbpg7.png.intel.com ([10.88.227.96])
  by orsmga003.jf.intel.com with ESMTP; 06 Jul 2020 21:49:11 -0700
From:   vineetha.g.jaya.kumaran@intel.com
To:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        weifeng.voon@intel.com, hock.leong.kweh@intel.com,
        boon.leong.ong@intel.com
Subject: [PATCH 1/2] dt-bindings: net: Add bindings for Intel Keem Bay
Date:   Tue,  7 Jul 2020 12:47:17 +0800
Message-Id: <1594097238-8827-2-git-send-email-vineetha.g.jaya.kumaran@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1594097238-8827-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
References: <1594097238-8827-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>

Add Device Tree bindings documentation for the ethernet controller
on Intel Keem Bay.

Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
---
 .../devicetree/bindings/net/intel,dwmac-plat.yaml  | 123 +++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml

diff --git a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
new file mode 100644
index 0000000..aef413b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
@@ -0,0 +1,123 @@
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
+  clocks:
+    maxItems: 3
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
+                compatible = "ethernet-phy-id0141.0dd0",
+                              "ethernet-phy-ieee802.3-c22";
+                reg = <0>;
+            };
+        };
+    };
+
+...
-- 
1.9.1


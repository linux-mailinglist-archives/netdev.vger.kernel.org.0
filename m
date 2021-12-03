Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF19C467207
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 07:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378659AbhLCGjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 01:39:03 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:57060 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1378622AbhLCGiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 01:38:00 -0500
X-UUID: d2471ec03bd44e5793ae9454e8b2505f-20211203
X-UUID: d2471ec03bd44e5793ae9454e8b2505f-20211203
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1507250322; Fri, 03 Dec 2021 14:34:33 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 3 Dec 2021 14:34:32 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkcas11.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Fri, 3 Dec 2021 14:34:31 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <angelogioacchino.delregno@collabora.com>, <dkirjanov@suse.de>
Subject: [PATCH v4 4/7] net-next: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
Date:   Fri, 3 Dec 2021 14:34:15 +0800
Message-ID: <20211203063418.14892-5-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211203063418.14892-1-biao.huang@mediatek.com>
References: <20211203063418.14892-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mediatek-dwmac to DT schema, and delete old mediatek-dwmac.txt.
And there are some changes in .yaml than .txt, others almost keep the same:
  1. compatible "const: snps,dwmac-4.20".
  2. delete "snps,reset-active-low;" in example, since driver remove this
     property long ago.
  3. add "snps,reset-delay-us = <0 10000 10000>" in example.
  4. the example is for rgmii interface, keep related properties only.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 .../bindings/net/mediatek-dwmac.txt           |  91 ----------
 .../bindings/net/mediatek-dwmac.yaml          | 156 ++++++++++++++++++
 2 files changed, 156 insertions(+), 91 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml

diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.txt b/Documentation/devicetree/bindings/net/mediatek-dwmac.txt
deleted file mode 100644
index afbcaebf062e..000000000000
--- a/Documentation/devicetree/bindings/net/mediatek-dwmac.txt
+++ /dev/null
@@ -1,91 +0,0 @@
-MediaTek DWMAC glue layer controller
-
-This file documents platform glue layer for stmmac.
-Please see stmmac.txt for the other unchanged properties.
-
-The device node has following properties.
-
-Required properties:
-- compatible:  Should be "mediatek,mt2712-gmac" for MT2712 SoC
-- reg:  Address and length of the register set for the device
-- interrupts:  Should contain the MAC interrupts
-- interrupt-names: Should contain a list of interrupt names corresponding to
-	the interrupts in the interrupts property, if available.
-	Should be "macirq" for the main MAC IRQ
-- clocks: Must contain a phandle for each entry in clock-names.
-- clock-names: The name of the clock listed in the clocks property. These are
-	"axi", "apb", "mac_main", "ptp_ref", "rmii_internal" for MT2712 SoC.
-- mac-address: See ethernet.txt in the same directory
-- phy-mode: See ethernet.txt in the same directory
-- mediatek,pericfg: A phandle to the syscon node that control ethernet
-	interface and timing delay.
-
-Optional properties:
-- mediatek,tx-delay-ps: TX clock delay macro value. Default is 0.
-	It should be defined for RGMII/MII interface.
-	It should be defined for RMII interface when the reference clock is from MT2712 SoC.
-- mediatek,rx-delay-ps: RX clock delay macro value. Default is 0.
-	It should be defined for RGMII/MII interface.
-	It should be defined for RMII interface.
-Both delay properties need to be a multiple of 170 for RGMII interface,
-or will round down. Range 0~31*170.
-Both delay properties need to be a multiple of 550 for MII/RMII interface,
-or will round down. Range 0~31*550.
-
-- mediatek,rmii-rxc: boolean property, if present indicates that the RMII
-	reference clock, which is from external PHYs, is connected to RXC pin
-	on MT2712 SoC.
-	Otherwise, is connected to TXC pin.
-- mediatek,rmii-clk-from-mac: boolean property, if present indicates that
-	MT2712 SoC provides the RMII reference clock, which outputs to TXC pin only.
-- mediatek,txc-inverse: boolean property, if present indicates that
-	1. tx clock will be inversed in MII/RGMII case,
-	2. tx clock inside MAC will be inversed relative to reference clock
-	   which is from external PHYs in RMII case, and it rarely happen.
-	3. the reference clock, which outputs to TXC pin will be inversed in RMII case
-	   when the reference clock is from MT2712 SoC.
-- mediatek,rxc-inverse: boolean property, if present indicates that
-	1. rx clock will be inversed in MII/RGMII case.
-	2. reference clock will be inversed when arrived at MAC in RMII case, when
-	   the reference clock is from external PHYs.
-	3. the inside clock, which be sent to MAC, will be inversed in RMII case when
-	   the reference clock is from MT2712 SoC.
-- assigned-clocks: mac_main and ptp_ref clocks
-- assigned-clock-parents: parent clocks of the assigned clocks
-
-Example:
-	eth: ethernet@1101c000 {
-		compatible = "mediatek,mt2712-gmac";
-		reg = <0 0x1101c000 0 0x1300>;
-		interrupts = <GIC_SPI 237 IRQ_TYPE_LEVEL_LOW>;
-		interrupt-names = "macirq";
-		phy-mode ="rgmii-rxid";
-		mac-address = [00 55 7b b5 7d f7];
-		clock-names = "axi",
-			      "apb",
-			      "mac_main",
-			      "ptp_ref",
-			      "rmii_internal";
-		clocks = <&pericfg CLK_PERI_GMAC>,
-			 <&pericfg CLK_PERI_GMAC_PCLK>,
-			 <&topckgen CLK_TOP_ETHER_125M_SEL>,
-			 <&topckgen CLK_TOP_ETHER_50M_SEL>,
-			 <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
-		assigned-clocks = <&topckgen CLK_TOP_ETHER_125M_SEL>,
-				  <&topckgen CLK_TOP_ETHER_50M_SEL>,
-				  <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
-		assigned-clock-parents = <&topckgen CLK_TOP_ETHERPLL_125M>,
-					 <&topckgen CLK_TOP_APLL1_D3>,
-					 <&topckgen CLK_TOP_ETHERPLL_50M>;
-		power-domains = <&scpsys MT2712_POWER_DOMAIN_AUDIO>;
-		mediatek,pericfg = <&pericfg>;
-		mediatek,tx-delay-ps = <1530>;
-		mediatek,rx-delay-ps = <1530>;
-		mediatek,rmii-rxc;
-		mediatek,txc-inverse;
-		mediatek,rxc-inverse;
-		snps,txpbl = <1>;
-		snps,rxpbl = <1>;
-		snps,reset-gpio = <&pio 87 GPIO_ACTIVE_LOW>;
-		snps,reset-active-low;
-	};
diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
new file mode 100644
index 000000000000..9207266a6e69
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
@@ -0,0 +1,156 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mediatek-dwmac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek DWMAC glue layer controller
+
+maintainers:
+  - Biao Huang <biao.huang@mediatek.com>
+
+description:
+  This file documents platform glue layer for stmmac.
+
+# We need a select here so we don't match all nodes with 'snps,dwmac'
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - mediatek,mt2712-gmac
+  required:
+    - compatible
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - mediatek,mt2712-gmac
+          - const: snps,dwmac-4.20a
+
+  clocks:
+    items:
+      - description: AXI clock
+      - description: APB clock
+      - description: MAC Main clock
+      - description: PTP clock
+      - description: RMII reference clock provided by MAC
+
+  clock-names:
+    items:
+      - const: axi
+      - const: apb
+      - const: mac_main
+      - const: ptp_ref
+      - const: rmii_internal
+
+  mediatek,pericfg:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      The phandle to the syscon node that control ethernet
+      interface and timing delay.
+
+  mediatek,tx-delay-ps:
+    description:
+      The internal TX clock delay (provided by this driver) in nanoseconds.
+      For MT2712 RGMII interface, Allowed value need to be a multiple of 170,
+      or will round down. Range 0~31*170.
+      For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
+      or will round down. Range 0~31*550.
+
+  mediatek,rx-delay-ps:
+    description:
+      The internal RX clock delay (provided by this driver) in nanoseconds.
+      For MT2712 RGMII interface, Allowed value need to be a multiple of 170,
+      or will round down. Range 0~31*170.
+      For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
+      or will round down. Range 0~31*550.
+
+  mediatek,rmii-rxc:
+    type: boolean
+    description:
+      If present, indicates that the RMII reference clock, which is from external
+      PHYs, is connected to RXC pin. Otherwise, is connected to TXC pin.
+
+  mediatek,rmii-clk-from-mac:
+    type: boolean
+    description:
+      If present, indicates that MAC provides the RMII reference clock, which
+      outputs to TXC pin only.
+
+  mediatek,txc-inverse:
+    type: boolean
+    description:
+      If present, indicates that
+      1. tx clock will be inversed in MII/RGMII case,
+      2. tx clock inside MAC will be inversed relative to reference clock
+         which is from external PHYs in RMII case, and it rarely happen.
+      3. the reference clock, which outputs to TXC pin will be inversed in RMII case
+         when the reference clock is from MAC.
+
+  mediatek,rxc-inverse:
+    type: boolean
+    description:
+      If present, indicates that
+      1. rx clock will be inversed in MII/RGMII case.
+      2. reference clock will be inversed when arrived at MAC in RMII case, when
+         the reference clock is from external PHYs.
+      3. the inside clock, which be sent to MAC, will be inversed in RMII case when
+         the reference clock is from MAC.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - interrupt-names
+  - clocks
+  - clock-names
+  - phy-mode
+  - mediatek,pericfg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/mt2712-clk.h>
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/power/mt2712-power.h>
+
+    eth: ethernet@1101c000 {
+        compatible = "mediatek,mt2712-gmac", "snps,dwmac-4.20a";
+        reg = <0x1101c000 0x1300>;
+        interrupts = <GIC_SPI 237 IRQ_TYPE_LEVEL_LOW>;
+        interrupt-names = "macirq";
+        phy-mode ="rgmii-rxid";
+        mac-address = [00 55 7b b5 7d f7];
+        clock-names = "axi",
+                      "apb",
+                      "mac_main",
+                      "ptp_ref",
+                      "rmii_internal";
+        clocks = <&pericfg CLK_PERI_GMAC>,
+                 <&pericfg CLK_PERI_GMAC_PCLK>,
+                 <&topckgen CLK_TOP_ETHER_125M_SEL>,
+                 <&topckgen CLK_TOP_ETHER_50M_SEL>,
+                 <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
+        assigned-clocks = <&topckgen CLK_TOP_ETHER_125M_SEL>,
+                          <&topckgen CLK_TOP_ETHER_50M_SEL>,
+                          <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
+        assigned-clock-parents = <&topckgen CLK_TOP_ETHERPLL_125M>,
+                                 <&topckgen CLK_TOP_APLL1_D3>,
+                                 <&topckgen CLK_TOP_ETHERPLL_50M>;
+        power-domains = <&scpsys MT2712_POWER_DOMAIN_AUDIO>;
+        mediatek,pericfg = <&pericfg>;
+        mediatek,tx-delay-ps = <1530>;
+        snps,txpbl = <1>;
+        snps,rxpbl = <1>;
+        snps,reset-gpio = <&pio 87 GPIO_ACTIVE_LOW>;
+        snps,reset-delays-us = <0 10000 10000>;
+    };
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B0F67142F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 07:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjARGbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 01:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjARG10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 01:27:26 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680B839294;
        Tue, 17 Jan 2023 22:17:09 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id A7DF324E116;
        Wed, 18 Jan 2023 14:17:07 +0800 (CST)
Received: from EXMBX073.cuchost.com (172.16.6.83) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 14:17:07 +0800
Received: from wyh-VirtualBox.starfivetech.com (171.223.208.138) by
 EXMBX073.cuchost.com (172.16.6.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Wed, 18 Jan 2023 14:17:06 +0800
From:   Yanhong Wang <yanhong.wang@starfivetech.com>
To:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: [PATCH v4 4/7] dt-bindings: net: Add support StarFive dwmac
Date:   Wed, 18 Jan 2023 14:16:58 +0800
Message-ID: <20230118061701.30047-5-yanhong.wang@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX073.cuchost.com
 (172.16.6.83)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation to describe StarFive dwmac driver(GMAC).

Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
---
 .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
 .../bindings/net/starfive,jh7110-dwmac.yaml   | 113 ++++++++++++++++++
 MAINTAINERS                                   |   5 +
 3 files changed, 119 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index baf2c5b9e92d..8b07bc9c8b00 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -91,6 +91,7 @@ properties:
         - snps,dwmac-5.20
         - snps,dwxgmac
         - snps,dwxgmac-2.10
+        - starfive,jh7110-dwmac
 
   reg:
     minItems: 1
diff --git a/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
new file mode 100644
index 000000000000..eb0767da834a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
@@ -0,0 +1,113 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (C) 2022 StarFive Technology Co., Ltd.
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/starfive,jh7110-dwmac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: StarFive JH7110 DWMAC glue layer
+
+maintainers:
+  - Yanhong Wang <yanhong.wang@starfivetech.com>
+
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - starfive,jh7110-dwmac
+  required:
+    - compatible
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - starfive,jh7110-dwmac
+      - const: snps,dwmac-5.20
+
+  clocks:
+    items:
+      - description: GMAC main clock
+      - description: GMAC AHB clock
+      - description: PTP clock
+      - description: TX clock
+      - description: GTXC clock
+      - description: GTX clock
+
+  clock-names:
+    items:
+      - const: stmmaceth
+      - const: pclk
+      - const: ptp_ref
+      - const: tx
+      - const: gtxc
+      - const: gtx
+
+  resets:
+    items:
+      - description: MAC Reset signal.
+      - description: AHB Reset signal.
+
+  reset-names:
+    items:
+      - const: stmmaceth
+      - const: ahb
+
+allOf:
+  - $ref: snps,dwmac.yaml#
+
+unevaluatedProperties: true
+
+required:
+  - compatible
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+
+examples:
+  - |
+    ethernet@16030000 {
+        compatible = "starfive,jh7110-dwmac", "snps,dwmac-5.20";
+        reg = <0x16030000 0x10000>;
+        clocks = <&clk 3>, <&clk 2>, <&clk 109>,
+                 <&clk 5>, <&clk 111>, <&clk 108>;
+        clock-names = "stmmaceth", "pclk", "ptp_ref",
+                      "tx", "gtxc", "gtx";
+        resets = <&rst 1>, <&rst 2>;
+        reset-names = "stmmaceth", "ahb";
+        interrupts = <7>, <6>, <5>;
+        interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
+        phy-mode = "rgmii-id";
+        snps,multicast-filter-bins = <64>;
+        snps,perfect-filter-entries = <8>;
+        rx-fifo-depth = <2048>;
+        tx-fifo-depth = <2048>;
+        snps,fixed-burst;
+        snps,no-pbl-x8;
+        snps,tso;
+        snps,force_thresh_dma_mode;
+        snps,axi-config = <&stmmac_axi_setup>;
+        snps,en-tx-lpi-clockgating;
+        snps,txpbl = <16>;
+        snps,rxpbl = <16>;
+        phy-handle = <&phy0>;
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            compatible = "snps,dwmac-mdio";
+
+            phy0: ethernet-phy@0 {
+                reg = <0>;
+            };
+        };
+
+        stmmac_axi_setup: stmmac-axi-config {
+            snps,lpi_en;
+            snps,wr_osr_lmt = <4>;
+            snps,rd_osr_lmt = <4>;
+            snps,blen = <256 128 64 32 0 0 0>;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index a70c1d0f303e..56be59bb09f7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19606,6 +19606,11 @@ F:	Documentation/devicetree/bindings/clock/starfive*
 F:	drivers/clk/starfive/
 F:	include/dt-bindings/clock/starfive*
 
+STARFIVE DWMAC GLUE LAYER
+M:	Yanhong Wang <yanhong.wang@starfivetech.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
+
 STARFIVE PINCTRL DRIVER
 M:	Emil Renner Berthing <kernel@esmil.dk>
 M:	Jianlong Huang <jianlong.huang@starfivetech.com>
-- 
2.17.1


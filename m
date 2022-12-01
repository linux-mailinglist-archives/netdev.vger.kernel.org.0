Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6434C63EBCE
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLAJCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLAJCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:02:08 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433DA31DC4;
        Thu,  1 Dec 2022 01:02:07 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 1F87A24E0AC;
        Thu,  1 Dec 2022 17:02:06 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 1 Dec
 2022 17:02:06 +0800
Received: from wyh-VirtualBox.starfivetech.com (171.223.208.138) by
 EXMBX173.cuchost.com (172.16.6.93) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Thu, 1 Dec 2022 17:02:04 +0800
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
Subject: [PATCH v1 3/7] dt-bindings: net: Add bindings for StarFive dwmac
Date:   Thu, 1 Dec 2022 17:02:38 +0800
Message-ID: <20221201090242.2381-4-yanhong.wang@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS065.cuchost.com (172.16.6.25) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings for the StarFive dwmac module on the StarFive RISC-V SoCs.

Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
---
 .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
 .../bindings/net/starfive,dwmac-plat.yaml     | 106 ++++++++++++++++++
 MAINTAINERS                                   |   5 +
 3 files changed, 112 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index d8779d3de3d6..13c5928d7170 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -33,6 +33,7 @@ select:
           - snps,dwmac-5.20
           - snps,dwxgmac
           - snps,dwxgmac-2.10
+          - starfive,dwmac
 
           # Deprecated
           - st,spear600-gmac
diff --git a/Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml b/Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
new file mode 100644
index 000000000000..561cf2a713ab
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
@@ -0,0 +1,106 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (C) 2022 StarFive Technology Co., Ltd.
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/dwmac-starfive.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: StarFive DWMAC glue layer
+
+maintainers:
+  - Yanhong Wang <yanhong.wang@starfivetech.com>
+
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - starfive,dwmac
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
+               - starfive,dwmac
+          - const: snps,dwmac-5.20
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
+    contains:
+      enum:
+        - stmmaceth
+        - pclk
+        - ptp_ref
+        - tx
+        - gtxc
+        - gtx
+
+required:
+  - compatible
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/starfive-jh7110.h>
+    #include <dt-bindings/reset/starfive-jh7110.h>
+
+    stmmac_axi_setup: stmmac-axi-config {
+        snps,wr_osr_lmt = <4>;
+        snps,rd_osr_lmt = <4>;
+        snps,blen = <256 128 64 32 0 0 0>;
+    };
+
+    gmac0: ethernet@16030000 {
+        compatible = "starfive,dwmac", "snps,dwmac-5.20";
+        reg = <0x16030000 0x10000>;
+        clocks = <&aoncrg_clk JH7110_AONCLK_GMAC0_AXI>,
+                 <&aoncrg_clk JH7110_AONCLK_GMAC0_AHB>,
+                 <&syscrg_clk JH7110_SYSCLK_GMAC0_PTP>,
+                 <&aoncrg_clk JH7110_AONCLK_GMAC0_TX>,
+                 <&syscrg_clk JH7110_SYSCLK_GMAC0_GTXC>,
+                 <&syscrg_clk JH7110_SYSCLK_GMAC0_GTXCLK>;
+        clock-names = "stmmaceth",
+                      "pclk",
+                      "ptp_ref",
+                      "tx",
+                      "gtxc",
+                      "gtx";
+        resets = <&aoncrg JH7110_AONRST_GMAC0_AXI>,
+                 <&aoncrg JH7110_AONRST_GMAC0_AHB>;
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
+        snps,force_thresh_dma_mode;
+        snps,axi-config = <&stmmac_axi_setup>;
+        snps,tso;
+        snps,en-tx-lpi-clockgating;
+        snps,lpi_en;
+        snps,txpbl = <16>;
+        snps,rxpbl = <16>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index a70c1d0f303e..7eaaec8d3b96 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19606,6 +19606,11 @@ F:	Documentation/devicetree/bindings/clock/starfive*
 F:	drivers/clk/starfive/
 F:	include/dt-bindings/clock/starfive*
 
+STARFIVE DWMAC GLUE LAYER
+M:	Yanhong Wang <yanhong.wang@starfivetech.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
+
 STARFIVE PINCTRL DRIVER
 M:	Emil Renner Berthing <kernel@esmil.dk>
 M:	Jianlong Huang <jianlong.huang@starfivetech.com>
-- 
2.17.1


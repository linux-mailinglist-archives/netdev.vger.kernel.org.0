Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032E231987D
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhBLDBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:01:37 -0500
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:56586 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhBLDBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:01:01 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 11C2wKdu006939; Fri, 12 Feb 2021 11:58:20 +0900
X-Iguazu-Qid: 34tKUV8MihhtQgcHLw
X-Iguazu-QSIG: v=2; s=0; t=1613098700; q=34tKUV8MihhtQgcHLw; m=nRYY4YP/THjVbadpKDf6ToY9gB2Eq8mnnFWU7W6Ng3I=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1512) id 11C2wJek010337;
        Fri, 12 Feb 2021 11:58:19 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11C2wJJ4017964;
        Fri, 12 Feb 2021 11:58:19 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11C2wImw003979;
        Fri, 12 Feb 2021 11:58:18 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, punit1.agrawal@toshiba.co.jp,
        yuji2.ishikawa@toshiba.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH v2 1/4] dt-bindings: net: Add DT bindings for Toshiba Visconti TMPV7700 SoC
Date:   Fri, 12 Feb 2021 11:58:03 +0900
X-TSB-HOP: ON
Message-Id: <20210212025806.556217-2-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.30.0.rc2
In-Reply-To: <20210212025806.556217-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20210212025806.556217-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree bindings for ethernet controller of Toshiba Visconti
TMPV7700 SoC series.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 .../bindings/net/toshiba,visconti-dwmac.yaml  | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml

diff --git a/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml b/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
new file mode 100644
index 000000000000..21ae140cfd5c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
@@ -0,0 +1,87 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/toshiba,visconti-dwmac.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Toshiba Visconti DWMAC Ethernet controller
+
+maintainers:
+  - Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
+
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - toshiba,visconti-dwmac
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
+              - toshiba,visconti-dwmac
+          - const: snps,dwmac-4.10a
+
+  reg:
+    items:
+      - description:
+          A register range should be the one of the DWMAC controller
+
+  clocks:
+    items:
+      - description: main clock
+      - description: PHY reference clock
+
+  clock-names:
+    items:
+      - const: stmmaceth
+      - const: phy_ref_clk
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    soc {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        piether: ethernet@28000000 {
+            compatible = "toshiba,visconti-dwmac", "snps,dwmac-4.10a";
+            reg = <0 0x28000000 0 0x10000>;
+            interrupts = <GIC_SPI 156 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "macirq";
+            clocks = <&clk300mhz>, <&clk125mhz>;
+            clock-names = "stmmaceth", "phy_ref_clk";
+            snps,txpbl = <4>;
+            snps,rxpbl = <4>;
+            dma-coherent;
+            phy-mode = "rgmii";
+            phy-handle = <&phy0>;
+
+            mdio0 {
+                #address-cells = <0x1>;
+                #size-cells = <0x0>;
+                compatible = "snps,dwmac-mdio";
+
+                phy0: ethernet-phy@1 {
+                    device_type = "ethernet-phy";
+                    reg = <0x1>;
+                };
+            };
+        };
+    };
-- 
2.30.0.rc2


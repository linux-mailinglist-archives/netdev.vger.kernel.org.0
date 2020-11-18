Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBD52B7869
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgKRIV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:21:57 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45142 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726894AbgKRIV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:21:56 -0500
X-UUID: cde4731824b74a8582f11ddf7e081e48-20201118
X-UUID: cde4731824b74a8582f11ddf7e081e48-20201118
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2132649961; Wed, 18 Nov 2020 16:21:46 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 18 Nov 2020 16:21:45 +0800
Received: from mtkslt301.mediatek.inc (10.21.14.114) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Nov 2020 16:21:45 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v3 03/11] dt-bindings: phy: convert phy-mtk-xsphy.txt to YAML schema
Date:   Wed, 18 Nov 2020 16:21:18 +0800
Message-ID: <20201118082126.42701-3-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201118082126.42701-1-chunfeng.yun@mediatek.com>
References: <20201118082126.42701-1-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert phy-mtk-xsphy.txt to YAML schema mediatek,xsphy.yaml

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
---
v3:
  1. remove type for property with standard unit suffix suggested by Rob
  2. remove '|' for descritpion
  3. fix yamllint warning

v2:
  1. modify description and compatible definition suggested by Rob
---
 .../bindings/phy/mediatek,xsphy.yaml          | 199 ++++++++++++++++++
 .../devicetree/bindings/phy/phy-mtk-xsphy.txt | 109 ----------
 2 files changed, 199 insertions(+), 109 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/mediatek,xsphy.yaml
 delete mode 100644 Documentation/devicetree/bindings/phy/phy-mtk-xsphy.txt

diff --git a/Documentation/devicetree/bindings/phy/mediatek,xsphy.yaml b/Documentation/devicetree/bindings/phy/mediatek,xsphy.yaml
new file mode 100644
index 000000000000..598fd2b95c29
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/mediatek,xsphy.yaml
@@ -0,0 +1,199 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (c) 2020 MediaTek
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/mediatek,xsphy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek XS-PHY Controller Device Tree Bindings
+
+maintainers:
+  - Chunfeng Yun <chunfeng.yun@mediatek.com>
+
+description: |
+  The XS-PHY controller supports physical layer functionality for USB3.1
+  GEN2 controller on MediaTek SoCs.
+
+  Banks layout of xsphy
+  ----------------------------------
+  port        offset    bank
+  u2 port0    0x0000    MISC
+              0x0100    FMREG
+              0x0300    U2PHY_COM
+  u2 port1    0x1000    MISC
+              0x1100    FMREG
+              0x1300    U2PHY_COM
+  u2 port2    0x2000    MISC
+              ...
+  u31 common  0x3000    DIG_GLB
+              0x3100    PHYA_GLB
+  u31 port0   0x3400    DIG_LN_TOP
+              0x3500    DIG_LN_TX0
+              0x3600    DIG_LN_RX0
+              0x3700    DIG_LN_DAIF
+              0x3800    PHYA_LN
+  u31 port1   0x3a00    DIG_LN_TOP
+              0x3b00    DIG_LN_TX0
+              0x3c00    DIG_LN_RX0
+              0x3d00    DIG_LN_DAIF
+              0x3e00    PHYA_LN
+              ...
+  DIG_GLB & PHYA_GLB are shared by U31 ports.
+
+properties:
+  $nodename:
+    pattern: "^xs-phy@[0-9a-f]+$"
+
+  compatible:
+    items:
+      - enum:
+          - mediatek,mt3611-xsphy
+          - mediatek,mt3612-xsphy
+      - const: mediatek,xsphy
+
+  reg:
+    description:
+      Register shared by multiple U3 ports, exclude port's private register,
+      if only U2 ports provided, shouldn't use the property.
+    maxItems: 1
+
+  "#address-cells":
+    enum: [1, 2]
+
+  "#size-cells":
+    enum: [1, 2]
+
+  ranges: true
+
+  mediatek,src-ref-clk-mhz:
+    description:
+      Frequency of reference clock for slew rate calibrate
+    default: 26
+
+  mediatek,src-coef:
+    description:
+      Coefficient for slew rate calibrate, depends on SoC process
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 17
+
+# Required child node:
+patternProperties:
+  "^usb-phy@[0-9a-f]+$":
+    type: object
+    description:
+      A sub-node is required for each port the controller provides.
+      Address range information including the usual 'reg' property
+      is used inside these nodes to describe the controller's topology.
+
+    properties:
+      reg:
+        maxItems: 1
+
+      clocks:
+        items:
+          - description: Reference clock, (HS is 48Mhz, SS/P is 24~27Mhz)
+
+      clock-names:
+        items:
+          - const: ref
+
+      "#phy-cells":
+        const: 1
+        description: |
+          The cells contain the following arguments.
+
+          - description: The PHY type
+              enum:
+                - PHY_TYPE_USB2
+                - PHY_TYPE_USB3
+
+      # The following optional vendor properties are only for debug or HQA test
+      mediatek,eye-src:
+        description:
+          The value of slew rate calibrate (U2 phy)
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 7
+
+      mediatek,eye-vrt:
+        description:
+          The selection of VRT reference voltage (U2 phy)
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 7
+
+      mediatek,eye-term:
+        description:
+          The selection of HS_TX TERM reference voltage (U2 phy)
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 7
+
+      mediatek,efuse-intr:
+        description:
+          The selection of Internal Resistor (U2/U3 phy)
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 63
+
+      mediatek,efuse-tx-imp:
+        description:
+          The selection of TX Impedance (U3 phy)
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 31
+
+      mediatek,efuse-rx-imp:
+        description:
+          The selection of RX Impedance (U3 phy)
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 31
+
+    required:
+      - reg
+      - clocks
+      - clock-names
+      - "#phy-cells"
+
+    additionalProperties: false
+
+required:
+  - compatible
+  - "#address-cells"
+  - "#size-cells"
+  - ranges
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/phy/phy.h>
+
+    u3phy: xs-phy@11c40000 {
+        compatible = "mediatek,mt3611-xsphy", "mediatek,xsphy";
+        reg = <0x11c43000 0x0200>;
+        mediatek,src-ref-clk-mhz = <26>;
+        mediatek,src-coef = <17>;
+        #address-cells = <1>;
+        #size-cells = <1>;
+        ranges;
+
+        u2port0: usb-phy@11c40000 {
+            reg = <0x11c40000 0x0400>;
+            clocks = <&clk48m>;
+            clock-names = "ref";
+            mediatek,eye-src = <4>;
+            #phy-cells = <1>;
+        };
+
+        u3port0: usb-phy@11c43000 {
+            reg = <0x11c43400 0x0500>;
+            clocks = <&clk26m>;
+            clock-names = "ref";
+            mediatek,efuse-intr = <28>;
+            #phy-cells = <1>;
+        };
+    };
+
+...
diff --git a/Documentation/devicetree/bindings/phy/phy-mtk-xsphy.txt b/Documentation/devicetree/bindings/phy/phy-mtk-xsphy.txt
deleted file mode 100644
index e7caefa0b9c2..000000000000
--- a/Documentation/devicetree/bindings/phy/phy-mtk-xsphy.txt
+++ /dev/null
@@ -1,109 +0,0 @@
-MediaTek XS-PHY binding
---------------------------
-
-The XS-PHY controller supports physical layer functionality for USB3.1
-GEN2 controller on MediaTek SoCs.
-
-Required properties (controller (parent) node):
- - compatible	: should be "mediatek,<soc-model>-xsphy", "mediatek,xsphy",
-		  soc-model is the name of SoC, such as mt3611 etc;
-		  when using "mediatek,xsphy" compatible string, you need SoC specific
-		  ones in addition, one of:
-		  - "mediatek,mt3611-xsphy"
-
- - #address-cells, #size-cells : should use the same values as the root node
- - ranges: must be present
-
-Optional properties (controller (parent) node):
- - reg		: offset and length of register shared by multiple U3 ports,
-		  exclude port's private register, if only U2 ports provided,
-		  shouldn't use the property.
- - mediatek,src-ref-clk-mhz	: u32, frequency of reference clock for slew rate
-		  calibrate
- - mediatek,src-coef	: u32, coefficient for slew rate calibrate, depends on
-		  SoC process
-
-Required nodes	: a sub-node is required for each port the controller
-		  provides. Address range information including the usual
-		  'reg' property is used inside these nodes to describe
-		  the controller's topology.
-
-Required properties (port (child) node):
-- reg		: address and length of the register set for the port.
-- clocks	: a list of phandle + clock-specifier pairs, one for each
-		  entry in clock-names
-- clock-names	: must contain
-		  "ref": 48M reference clock for HighSpeed analog phy; and 26M
-			reference clock for SuperSpeedPlus analog phy, sometimes is
-			24M, 25M or 27M, depended on platform.
-- #phy-cells	: should be 1
-		  cell after port phandle is phy type from:
-			- PHY_TYPE_USB2
-			- PHY_TYPE_USB3
-
-The following optional properties are only for debug or HQA test
-Optional properties (PHY_TYPE_USB2 port (child) node):
-- mediatek,eye-src	: u32, the value of slew rate calibrate
-- mediatek,eye-vrt	: u32, the selection of VRT reference voltage
-- mediatek,eye-term	: u32, the selection of HS_TX TERM reference voltage
-- mediatek,efuse-intr	: u32, the selection of Internal Resistor
-
-Optional properties (PHY_TYPE_USB3 port (child) node):
-- mediatek,efuse-intr	: u32, the selection of Internal Resistor
-- mediatek,efuse-tx-imp	: u32, the selection of TX Impedance
-- mediatek,efuse-rx-imp	: u32, the selection of RX Impedance
-
-Banks layout of xsphy
--------------------------------------------------------------
-port        offset    bank
-u2 port0    0x0000    MISC
-            0x0100    FMREG
-            0x0300    U2PHY_COM
-u2 port1    0x1000    MISC
-            0x1100    FMREG
-            0x1300    U2PHY_COM
-u2 port2    0x2000    MISC
-            ...
-u31 common  0x3000    DIG_GLB
-            0x3100    PHYA_GLB
-u31 port0   0x3400    DIG_LN_TOP
-            0x3500    DIG_LN_TX0
-            0x3600    DIG_LN_RX0
-            0x3700    DIG_LN_DAIF
-            0x3800    PHYA_LN
-u31 port1   0x3a00    DIG_LN_TOP
-            0x3b00    DIG_LN_TX0
-            0x3c00    DIG_LN_RX0
-            0x3d00    DIG_LN_DAIF
-            0x3e00    PHYA_LN
-            ...
-
-DIG_GLB & PHYA_GLB are shared by U31 ports.
-
-Example:
-
-u3phy: usb-phy@11c40000 {
-	compatible = "mediatek,mt3611-xsphy", "mediatek,xsphy";
-	reg = <0 0x11c43000 0 0x0200>;
-	mediatek,src-ref-clk-mhz = <26>;
-	mediatek,src-coef = <17>;
-	#address-cells = <2>;
-	#size-cells = <2>;
-	ranges;
-
-	u2port0: usb-phy@11c40000 {
-		reg = <0 0x11c40000 0 0x0400>;
-		clocks = <&clk48m>;
-		clock-names = "ref";
-		mediatek,eye-src = <4>;
-		#phy-cells = <1>;
-	};
-
-	u3port0: usb-phy@11c43000 {
-		reg = <0 0x11c43400 0 0x0500>;
-		clocks = <&clk26m>;
-		clock-names = "ref";
-		mediatek,efuse-intr = <28>;
-		#phy-cells = <1>;
-	};
-};
-- 
2.18.0


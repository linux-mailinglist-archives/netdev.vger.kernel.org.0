Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D831B6D28
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 07:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgDXFVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 01:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725967AbgDXFVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 01:21:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C692C09B045
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 22:21:22 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jRqm7-0003I8-AJ; Fri, 24 Apr 2020 07:21:19 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jRqm6-0004UP-N7; Fri, 24 Apr 2020 07:21:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v1] dt-bindings: net: convert qca,ar71xx documentation to yaml
Date:   Fri, 24 Apr 2020 07:21:16 +0200
Message-Id: <20200424052116.17204-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the DT validation in place, let's convert the device tree
bindings for the Atheros AR71XX over to a YAML schemas.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../devicetree/bindings/net/qca,ar71xx.txt    |  45 ----
 .../devicetree/bindings/net/qca,ar71xx.yaml   | 216 ++++++++++++++++++
 2 files changed, 216 insertions(+), 45 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/qca,ar71xx.txt
 create mode 100644 Documentation/devicetree/bindings/net/qca,ar71xx.yaml

diff --git a/Documentation/devicetree/bindings/net/qca,ar71xx.txt b/Documentation/devicetree/bindings/net/qca,ar71xx.txt
deleted file mode 100644
index 2a33e71ba72b8..0000000000000
--- a/Documentation/devicetree/bindings/net/qca,ar71xx.txt
+++ /dev/null
@@ -1,45 +0,0 @@
-Required properties:
-- compatible:	Should be "qca,<soc>-eth". Currently support compatibles are:
-		qca,ar7100-eth - Atheros AR7100
-		qca,ar7240-eth - Atheros AR7240
-		qca,ar7241-eth - Atheros AR7241
-		qca,ar7242-eth - Atheros AR7242
-		qca,ar9130-eth - Atheros AR9130
-		qca,ar9330-eth - Atheros AR9330
-		qca,ar9340-eth - Atheros AR9340
-		qca,qca9530-eth - Qualcomm Atheros QCA9530
-		qca,qca9550-eth - Qualcomm Atheros QCA9550
-		qca,qca9560-eth - Qualcomm Atheros QCA9560
-
-- reg : Address and length of the register set for the device
-- interrupts : Should contain eth interrupt
-- phy-mode : See ethernet.txt file in the same directory
-- clocks: the clock used by the core
-- clock-names: the names of the clock listed in the clocks property. These are
-	"eth" and "mdio".
-- resets: Should contain phandles to the reset signals
-- reset-names: Should contain the names of reset signal listed in the resets
-		property. These are "mac" and "mdio"
-
-Optional properties:
-- phy-handle : phandle to the PHY device connected to this device.
-- fixed-link : Assume a fixed link. See fixed-link.txt in the same directory.
-  Use instead of phy-handle.
-
-Optional subnodes:
-- mdio : specifies the mdio bus, used as a container for phy nodes
-  according to phy.txt in the same directory
-
-Example:
-
-ethernet@1a000000 {
-	compatible = "qca,ar9330-eth";
-	reg = <0x1a000000 0x200>;
-	interrupts = <5>;
-	resets = <&rst 13>, <&rst 23>;
-	reset-names = "mac", "mdio";
-	clocks = <&pll ATH79_CLK_AHB>, <&pll ATH79_CLK_MDIO>;
-	clock-names = "eth", "mdio";
-
-	phy-mode = "gmii";
-};
diff --git a/Documentation/devicetree/bindings/net/qca,ar71xx.yaml b/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
new file mode 100644
index 0000000000000..f99a5aabe9232
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qca,ar71xx.yaml
@@ -0,0 +1,216 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qca,ar71xx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: QCA AR71XX MAC
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+maintainers:
+  - Oleksij Rempel <o.rempel@pengutronix.de>
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - qca,ar7100-eth   # Atheros AR7100
+              - qca,ar7240-eth   # Atheros AR7240
+              - qca,ar7241-eth   # Atheros AR7241
+              - qca,ar7242-eth   # Atheros AR7242
+              - qca,ar9130-eth   # Atheros AR9130
+              - qca,ar9330-eth   # Atheros AR9330
+              - qca,ar9340-eth   # Atheros AR9340
+              - qca,qca9530-eth  # Qualcomm Atheros QCA9530
+              - qca,qca9550-eth  # Qualcomm Atheros QCA9550
+              - qca,qca9560-eth  # Qualcomm Atheros QCA9560
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  '#address-cells':
+    description: number of address cells for the MDIO bus
+    const: 1
+
+  '#size-cells':
+    description: number of size cells on the MDIO bus
+    const: 0
+
+  clocks:
+    items:
+      - description: MAC main clock
+      - description: MDIO clock
+
+  clock-names:
+    items:
+      - const: eth
+      - const: mdio
+
+  resets:
+    items:
+      - description: MAC reset
+      - description: MDIO reset
+
+  reset-names:
+    items:
+      - const: mac
+      - const: mdio
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - phy-mode
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+
+examples:
+  # Lager board
+  - |
+    eth0: ethernet@19000000 {
+        compatible = "qca,ar9330-eth";
+        reg = <0x19000000 0x200>;
+        interrupts = <4>;
+        resets = <&rst 9>, <&rst 22>;
+        reset-names = "mac", "mdio";
+        clocks = <&pll 1>, <&pll 2>;
+        clock-names = "eth", "mdio";
+        qca,ethcfg = <&ethcfg>;
+        phy-mode = "mii";
+        phy-handle = <&phy_port4>;
+    };
+
+    eth1: ethernet@1a000000 {
+        compatible = "qca,ar9330-eth";
+        reg = <0x1a000000 0x200>;
+        interrupts = <5>;
+        resets = <&rst 13>, <&rst 23>;
+        reset-names = "mac", "mdio";
+        clocks = <&pll 1>, <&pll 2>;
+        clock-names = "eth", "mdio";
+
+        phy-mode = "gmii";
+
+        status = "disabled";
+
+        fixed-link {
+            speed = <1000>;
+            full-duplex;
+        };
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            switch10: switch@10 {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                compatible = "qca,ar9331-switch";
+                reg = <0x10>;
+                resets = <&rst 8>;
+                reset-names = "switch";
+
+                interrupt-parent = <&miscintc>;
+                interrupts = <12>;
+
+                interrupt-controller;
+                #interrupt-cells = <1>;
+
+                ports {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+
+                    switch_port0: port@0 {
+                        reg = <0x0>;
+                        label = "cpu";
+                        ethernet = <&eth1>;
+
+                        phy-mode = "gmii";
+
+                        fixed-link {
+                            speed = <1000>;
+                            full-duplex;
+                        };
+                    };
+
+                    switch_port1: port@1 {
+                        reg = <0x1>;
+                        phy-handle = <&phy_port0>;
+                        phy-mode = "internal";
+
+                        status = "disabled";
+                    };
+
+                    switch_port2: port@2 {
+                        reg = <0x2>;
+                        phy-handle = <&phy_port1>;
+                        phy-mode = "internal";
+
+                        status = "disabled";
+                    };
+
+                    switch_port3: port@3 {
+                        reg = <0x3>;
+                        phy-handle = <&phy_port2>;
+                        phy-mode = "internal";
+
+                        status = "disabled";
+                    };
+
+                    switch_port4: port@4 {
+                        reg = <0x4>;
+                        phy-handle = <&phy_port3>;
+                        phy-mode = "internal";
+
+                        status = "disabled";
+                    };
+                };
+
+                mdio {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+
+                    interrupt-parent = <&switch10>;
+
+                    phy_port0: phy@0 {
+                        reg = <0x0>;
+                        interrupts = <0>;
+                        status = "disabled";
+                    };
+
+                    phy_port1: phy@1 {
+                        reg = <0x1>;
+                        interrupts = <0>;
+                        status = "disabled";
+                    };
+
+                    phy_port2: phy@2 {
+                        reg = <0x2>;
+                        interrupts = <0>;
+                        status = "disabled";
+                    };
+
+                    phy_port3: phy@3 {
+                        reg = <0x3>;
+                        interrupts = <0>;
+                        status = "disabled";
+                    };
+
+                    phy_port4: phy@4 {
+                        reg = <0x4>;
+                        interrupts = <0>;
+                        status = "disabled";
+                    };
+                };
+            };
+        };
+    };
-- 
2.26.1


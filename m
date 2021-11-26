Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CAA45F2EB
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbhKZRdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:33:14 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:34837 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbhKZRbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:31:06 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id CD215240005;
        Fri, 26 Nov 2021 17:27:50 +0000 (UTC)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next v3 1/4] dt-bindings: net: mscc,vsc7514-switch: convert txt bindings to yaml
Date:   Fri, 26 Nov 2021 18:27:36 +0100
Message-Id: <20211126172739.329098-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211126172739.329098-1-clement.leger@bootlin.com>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert existing txt bindings to yaml format. Additionally, add bindings
for FDMA support and phy-mode property.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 .../bindings/net/mscc,vsc7514-switch.yaml     | 191 ++++++++++++++++++
 .../devicetree/bindings/net/mscc-ocelot.txt   |  83 --------
 2 files changed, 191 insertions(+), 83 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mscc-ocelot.txt

diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
new file mode 100644
index 000000000000..112f3ee98412
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
@@ -0,0 +1,191 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mscc,vsc7514-switch.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip VSC7514 Ethernet switch controller
+
+maintainers:
+  - Vladimir Oltean <vladimir.oltean@nxp.com>
+  - Claudiu Manoil <claudiu.manoil@nxp.com>
+  - Alexandre Belloni <alexandre.belloni@bootlin.com>
+
+description: |
+  Bindings for the Microchip VSC7514 switch driver
+
+  The VSC7514 switch driver handles up to 11 ports and can inject/extract
+  packets using CPU. Additionally, PTP is supported as well as FDMA for faster
+  packet extraction/injection.
+
+properties:
+  $nodename:
+    pattern: "^switch@[0-9a-f]+$"
+
+  compatible:
+    const: mscc,vsc7514-switch
+
+  reg:
+    items:
+      - description: system target
+      - description: rewriter target
+      - description: qs target
+      - description: PTP target
+      - description: Port0 target
+      - description: Port1 target
+      - description: Port2 target
+      - description: Port3 target
+      - description: Port4 target
+      - description: Port5 target
+      - description: Port6 target
+      - description: Port7 target
+      - description: Port8 target
+      - description: Port9 target
+      - description: Port10 target
+      - description: QSystem target
+      - description: Analyzer target
+      - description: S0 target
+      - description: S1 target
+      - description: S2 target
+      - description: fdma target
+
+  reg-names:
+    items:
+      - const: sys
+      - const: rew
+      - const: qs
+      - const: ptp
+      - const: port0
+      - const: port1
+      - const: port2
+      - const: port3
+      - const: port4
+      - const: port5
+      - const: port6
+      - const: port7
+      - const: port8
+      - const: port9
+      - const: port10
+      - const: qsys
+      - const: ana
+      - const: s0
+      - const: s1
+      - const: s2
+      - const: fdma
+
+  interrupts:
+    minItems: 1
+    items:
+      - description: PTP ready
+      - description: register based extraction
+      - description: frame dma based extraction
+
+  interrupt-names:
+    minItems: 1
+    items:
+      - const: ptp_rdy
+      - const: xtr
+      - const: fdma
+
+  ethernet-ports:
+    type: object
+
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    additionalProperties: false
+
+    patternProperties:
+      "^port@[0-9a-f]+$":
+        type: object
+        description: Ethernet ports handled by the switch
+
+        $ref: ethernet-controller.yaml#
+
+        unevaluatedProperties: false
+
+        properties:
+          reg:
+            description: Switch port number
+
+          phy-handle: true
+
+          phy-mode: true
+
+          fixed-link: true
+
+          mac-address: true
+
+        required:
+          - reg
+
+        oneOf:
+          - required:
+              - phy-handle
+              - phy-mode
+          - required:
+              - fixed-link
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - interrupts
+  - interrupt-names
+  - ethernet-ports
+
+additionalProperties: false
+
+examples:
+  - |
+    switch@1010000 {
+      compatible = "mscc,vsc7514-switch";
+      reg = <0x1010000 0x10000>,
+            <0x1030000 0x10000>,
+            <0x1080000 0x100>,
+            <0x10e0000 0x10000>,
+            <0x11e0000 0x100>,
+            <0x11f0000 0x100>,
+            <0x1200000 0x100>,
+            <0x1210000 0x100>,
+            <0x1220000 0x100>,
+            <0x1230000 0x100>,
+            <0x1240000 0x100>,
+            <0x1250000 0x100>,
+            <0x1260000 0x100>,
+            <0x1270000 0x100>,
+            <0x1280000 0x100>,
+            <0x1800000 0x80000>,
+            <0x1880000 0x10000>,
+            <0x1040000 0x10000>,
+            <0x1050000 0x10000>,
+            <0x1060000 0x10000>,
+            <0x1a0 0x1c4>;
+      reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
+            "port2", "port3", "port4", "port5", "port6",
+            "port7", "port8", "port9", "port10", "qsys",
+            "ana", "s0", "s1", "s2", "fdma";
+      interrupts = <18 21 16>;
+      interrupt-names = "ptp_rdy", "xtr", "fdma";
+
+      ethernet-ports {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        port0: port@0 {
+          reg = <0>;
+          phy-handle = <&phy0>;
+          phy-mode = "internal";
+        };
+        port1: port@1 {
+          reg = <1>;
+          phy-handle = <&phy1>;
+          phy-mode = "internal";
+        };
+      };
+    };
+
+...
diff --git a/Documentation/devicetree/bindings/net/mscc-ocelot.txt b/Documentation/devicetree/bindings/net/mscc-ocelot.txt
deleted file mode 100644
index 3b6290b45ce5..000000000000
--- a/Documentation/devicetree/bindings/net/mscc-ocelot.txt
+++ /dev/null
@@ -1,83 +0,0 @@
-Microsemi Ocelot network Switch
-===============================
-
-The Microsemi Ocelot network switch can be found on Microsemi SoCs (VSC7513,
-VSC7514)
-
-Required properties:
-- compatible: Should be "mscc,vsc7514-switch"
-- reg: Must contain an (offset, length) pair of the register set for each
-  entry in reg-names.
-- reg-names: Must include the following entries:
-  - "sys"
-  - "rew"
-  - "qs"
-  - "ptp" (optional due to backward compatibility)
-  - "qsys"
-  - "ana"
-  - "portX" with X from 0 to the number of last port index available on that
-    switch
-- interrupts: Should contain the switch interrupts for frame extraction,
-  frame injection and PTP ready.
-- interrupt-names: should contain the interrupt names: "xtr", "inj". Can contain
-  "ptp_rdy" which is optional due to backward compatibility.
-- ethernet-ports: A container for child nodes representing switch ports.
-
-The ethernet-ports container has the following properties
-
-Required properties:
-
-- #address-cells: Must be 1
-- #size-cells: Must be 0
-
-Each port node must have the following mandatory properties:
-- reg: Describes the port address in the switch
-
-Port nodes may also contain the following optional standardised
-properties, described in binding documents:
-
-- phy-handle: Phandle to a PHY on an MDIO bus. See
-  Documentation/devicetree/bindings/net/ethernet.txt for details.
-
-Example:
-
-	switch@1010000 {
-		compatible = "mscc,vsc7514-switch";
-		reg = <0x1010000 0x10000>,
-		      <0x1030000 0x10000>,
-		      <0x1080000 0x100>,
-		      <0x10e0000 0x10000>,
-		      <0x11e0000 0x100>,
-		      <0x11f0000 0x100>,
-		      <0x1200000 0x100>,
-		      <0x1210000 0x100>,
-		      <0x1220000 0x100>,
-		      <0x1230000 0x100>,
-		      <0x1240000 0x100>,
-		      <0x1250000 0x100>,
-		      <0x1260000 0x100>,
-		      <0x1270000 0x100>,
-		      <0x1280000 0x100>,
-		      <0x1800000 0x80000>,
-		      <0x1880000 0x10000>;
-		reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
-			    "port2", "port3", "port4", "port5", "port6",
-			    "port7", "port8", "port9", "port10", "qsys",
-			    "ana";
-		interrupts = <18 21 22>;
-		interrupt-names = "ptp_rdy", "xtr", "inj";
-
-		ethernet-ports {
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			port0: port@0 {
-				reg = <0>;
-				phy-handle = <&phy0>;
-			};
-			port1: port@1 {
-				reg = <1>;
-				phy-handle = <&phy1>;
-			};
-		};
-	};
-- 
2.33.1


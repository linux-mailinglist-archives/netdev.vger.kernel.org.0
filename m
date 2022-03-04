Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853CA4CD273
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiCDKfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiCDKfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:35:10 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3938BEA37B;
        Fri,  4 Mar 2022 02:34:21 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EC2BB24000F;
        Fri,  4 Mar 2022 10:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646390060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aNxUJLIkcAu5DHgHCNnuDLsWx+04q7o2jFfhBc9Lcq8=;
        b=W3hX5IkhRjMN2I7T3YD5kysnHYhoCl+5oUSLrR8HO2gIP9DRCxE59s+eBV4p2ntZU5PcSh
        ryM2zKLBLvUFMFmPja/Bpju67RgCbG9ROAo/74aV22Y7Q9pi4/Nltmx4yWNsKms6VEQGVP
        okj6DayDEa5l4Cq984TsjYMxnVD9gjL00l0FYNCUT9GrHiVlakudp84CgNXV1dfxNOlFpH
        YMPlEPxASlSjuf0qlOwuG6Rzi3x/fgzn1O9Jd3cTtv9gIT1l+4NtIlLdbOncgWFSs9OBix
        feKtV8QkIM36icmNqYwEOovTXRyh/v5eivSYrx8T7Wtk3KpLfA+daCI5V1SlKw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [PATCH] dt-bindings: net: mscc,vsc7514-switch: convert txt bindings to yaml
Date:   Fri,  4 Mar 2022 11:32:25 +0100
Message-Id: <20220304103225.111428-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert existing txt bindings to yaml format.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 .../bindings/net/mscc,vsc7514-switch.yaml     | 191 ++++++++++++++++++
 .../devicetree/bindings/net/mscc-ocelot.txt   |  83 --------
 2 files changed, 191 insertions(+), 83 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mscc-ocelot.txt

diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
new file mode 100644
index 000000000000..ee0a504bdb24
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
+          - phy-mode
+
+        oneOf:
+          - required:
+              - phy-handle
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
2.34.1


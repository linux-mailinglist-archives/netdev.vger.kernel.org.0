Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CD4392A00
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbhE0Iuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235694AbhE0IuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:50:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4FCC061345
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgn-0002It-Oj
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:25 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CD61F62D401
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7D2C662D3D9;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 70331d84;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 01/21] dt-bindings: can: rcar_can: Convert to json-schema
Date:   Thu, 27 May 2021 10:45:12 +0200
Message-Id: <20210527084532.1384031-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Convert the Renesas R-Car CAN Controller Device Tree binding
documentation to json-schema.

Document missing properties.
Update the example to match reality.

Link: https://lore.kernel.org/r/561c35648e22a3c1e3b5477ae27fd1a50da7fe98.1620323639.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../devicetree/bindings/net/can/rcar_can.txt  |  80 ----------
 .../bindings/net/can/renesas,rcar-can.yaml    | 139 ++++++++++++++++++
 2 files changed, 139 insertions(+), 80 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/can/rcar_can.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/renesas,rcar-can.yaml

diff --git a/Documentation/devicetree/bindings/net/can/rcar_can.txt b/Documentation/devicetree/bindings/net/can/rcar_can.txt
deleted file mode 100644
index 90ac4fef23f5..000000000000
--- a/Documentation/devicetree/bindings/net/can/rcar_can.txt
+++ /dev/null
@@ -1,80 +0,0 @@
-Renesas R-Car CAN controller Device Tree Bindings
--------------------------------------------------
-
-Required properties:
-- compatible: "renesas,can-r8a7742" if CAN controller is a part of R8A7742 SoC.
-	      "renesas,can-r8a7743" if CAN controller is a part of R8A7743 SoC.
-	      "renesas,can-r8a7744" if CAN controller is a part of R8A7744 SoC.
-	      "renesas,can-r8a7745" if CAN controller is a part of R8A7745 SoC.
-	      "renesas,can-r8a77470" if CAN controller is a part of R8A77470 SoC.
-	      "renesas,can-r8a774a1" if CAN controller is a part of R8A774A1 SoC.
-	      "renesas,can-r8a774b1" if CAN controller is a part of R8A774B1 SoC.
-	      "renesas,can-r8a774c0" if CAN controller is a part of R8A774C0 SoC.
-	      "renesas,can-r8a774e1" if CAN controller is a part of R8A774E1 SoC.
-	      "renesas,can-r8a7778" if CAN controller is a part of R8A7778 SoC.
-	      "renesas,can-r8a7779" if CAN controller is a part of R8A7779 SoC.
-	      "renesas,can-r8a7790" if CAN controller is a part of R8A7790 SoC.
-	      "renesas,can-r8a7791" if CAN controller is a part of R8A7791 SoC.
-	      "renesas,can-r8a7792" if CAN controller is a part of R8A7792 SoC.
-	      "renesas,can-r8a7793" if CAN controller is a part of R8A7793 SoC.
-	      "renesas,can-r8a7794" if CAN controller is a part of R8A7794 SoC.
-	      "renesas,can-r8a7795" if CAN controller is a part of R8A7795 SoC.
-	      "renesas,can-r8a7796" if CAN controller is a part of R8A77960 SoC.
-	      "renesas,can-r8a77961" if CAN controller is a part of R8A77961 SoC.
-	      "renesas,can-r8a77965" if CAN controller is a part of R8A77965 SoC.
-	      "renesas,can-r8a77990" if CAN controller is a part of R8A77990 SoC.
-	      "renesas,can-r8a77995" if CAN controller is a part of R8A77995 SoC.
-	      "renesas,rcar-gen1-can" for a generic R-Car Gen1 compatible device.
-	      "renesas,rcar-gen2-can" for a generic R-Car Gen2 or RZ/G1
-	      compatible device.
-	      "renesas,rcar-gen3-can" for a generic R-Car Gen3 or RZ/G2
-	      compatible device.
-	      When compatible with the generic version, nodes must list the
-	      SoC-specific version corresponding to the platform first
-	      followed by the generic version.
-
-- reg: physical base address and size of the R-Car CAN register map.
-- interrupts: interrupt specifier for the sole interrupt.
-- clocks: phandles and clock specifiers for 3 CAN clock inputs.
-- clock-names: 3 clock input name strings: "clkp1", "clkp2", and "can_clk".
-- pinctrl-0: pin control group to be used for this controller.
-- pinctrl-names: must be "default".
-
-Required properties for R8A774A1, R8A774B1, R8A774C0, R8A774E1, R8A7795,
-R8A77960, R8A77961, R8A77965, R8A77990, and R8A77995:
-For the denoted SoCs, "clkp2" can be CANFD clock. This is a div6 clock and can
-be used by both CAN and CAN FD controller at the same time. It needs to be
-scaled to maximum frequency if any of these controllers use it. This is done
-using the below properties:
-
-- assigned-clocks: phandle of clkp2(CANFD) clock.
-- assigned-clock-rates: maximum frequency of this clock.
-
-Optional properties:
-- renesas,can-clock-select: R-Car CAN Clock Source Select. Valid values are:
-			    <0x0> (default) : Peripheral clock (clkp1)
-			    <0x1> : Peripheral clock (clkp2)
-			    <0x3> : External input clock
-
-Example
--------
-
-SoC common .dtsi file:
-
-	can0: can@e6e80000 {
-		compatible = "renesas,can-r8a7791", "renesas,rcar-gen2-can";
-		reg = <0 0xe6e80000 0 0x1000>;
-		interrupts = <0 186 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&mstp9_clks R8A7791_CLK_RCAN0>,
-			 <&cpg_clocks R8A7791_CLK_RCAN>, <&can_clk>;
-		clock-names = "clkp1", "clkp2", "can_clk";
-		status = "disabled";
-	};
-
-Board specific .dts file:
-
-&can0 {
-	pinctrl-0 = <&can0_pins>;
-	pinctrl-names = "default";
-	status = "okay";
-};
diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-can.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-can.yaml
new file mode 100644
index 000000000000..fadc871fd6b0
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-can.yaml
@@ -0,0 +1,139 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/renesas,rcar-can.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Renesas R-Car CAN Controller
+
+maintainers:
+  - Sergei Shtylyov <sergei.shtylyov@gmail.com>
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - renesas,can-r8a7778      # R-Car M1-A
+              - renesas,can-r8a7779      # R-Car H1
+          - const: renesas,rcar-gen1-can # R-Car Gen1
+
+      - items:
+          - enum:
+              - renesas,can-r8a7742      # RZ/G1H
+              - renesas,can-r8a7743      # RZ/G1M
+              - renesas,can-r8a7744      # RZ/G1N
+              - renesas,can-r8a7745      # RZ/G1E
+              - renesas,can-r8a77470     # RZ/G1C
+              - renesas,can-r8a7790      # R-Car H2
+              - renesas,can-r8a7791      # R-Car M2-W
+              - renesas,can-r8a7792      # R-Car V2H
+              - renesas,can-r8a7793      # R-Car M2-N
+              - renesas,can-r8a7794      # R-Car E2
+          - const: renesas,rcar-gen2-can # R-Car Gen2 and RZ/G1
+
+      - items:
+          - enum:
+              - renesas,can-r8a774a1     # RZ/G2M
+              - renesas,can-r8a774b1     # RZ/G2N
+              - renesas,can-r8a774c0     # RZ/G2E
+              - renesas,can-r8a774e1     # RZ/G2H
+              - renesas,can-r8a7795      # R-Car H3
+              - renesas,can-r8a7796      # R-Car M3-W
+              - renesas,can-r8a77961     # R-Car M3-W+
+              - renesas,can-r8a77965     # R-Car M3-N
+              - renesas,can-r8a77990     # R-Car E3
+              - renesas,can-r8a77995     # R-Car D3
+          - const: renesas,rcar-gen3-can # R-Car Gen3 and RZ/G2
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 3
+
+  clock-names:
+    items:
+      - const: clkp1
+      - const: clkp2
+      - const: can_clk
+
+  power-domains:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  renesas,can-clock-select:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [ 0, 1, 3 ]
+    default: 0
+    description: |
+      R-Car CAN Clock Source Select.  Valid values are:
+        <0x0> (default) : Peripheral clock (clkp1)
+        <0x1> : Peripheral clock (clkp2)
+        <0x3> : External input clock
+
+  assigned-clocks:
+    description:
+      Reference to the clkp2 (CANFD) clock.
+      On R-Car Gen3 and RZ/G2 SoCs, "clkp2" is the CANFD clock.  This is a div6
+      clock and can be used by both CAN and CAN FD controllers at the same
+      time.  It needs to be scaled to maximum frequency if any of these
+      controllers use it.
+
+  assigned-clock-rates:
+    description: Maximum frequency of the CANFD clock.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - power-domains
+
+allOf:
+  - $ref: can-controller.yaml#
+
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              const: renesas,rcar-gen1-can
+    then:
+      required:
+        - resets
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: renesas,rcar-gen3-can
+    then:
+      required:
+        - assigned-clocks
+        - assigned-clock-rates
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/r8a7791-cpg-mssr.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/power/r8a7791-sysc.h>
+
+    can0: can@e6e80000 {
+            compatible = "renesas,can-r8a7791", "renesas,rcar-gen2-can";
+            reg = <0xe6e80000 0x1000>;
+            interrupts = <GIC_SPI 186 IRQ_TYPE_LEVEL_HIGH>;
+            clocks = <&cpg CPG_MOD 916>,
+                     <&cpg CPG_CORE R8A7791_CLK_RCAN>, <&can_clk>;
+            clock-names = "clkp1", "clkp2", "can_clk";
+            power-domains = <&sysc R8A7791_PD_ALWAYS_ON>;
+            resets = <&cpg 916>;
+    };

base-commit: 59c56342459a483d5e563ed8b5fdb77ab7622a73
-- 
2.30.2



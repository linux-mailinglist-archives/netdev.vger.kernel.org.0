Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896AE3929F2
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbhE0IuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbhE0Itx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580AAC06138B
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgg-00022N-Jy
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:18 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 78BA962D418
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A0D9A62D3DB;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c820ab38;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 02/21] dt-bindings: can: rcar_canfd: Convert to json-schema
Date:   Thu, 27 May 2021 10:45:13 +0200
Message-Id: <20210527084532.1384031-3-mkl@pengutronix.de>
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

Convert the Renesas R-Car CAN FD Controller Device Tree binding
documentation to json-schema.

Document missing properties.
The CANFD clock needs to be configured for the maximum frequency on
R-Car V3M and V3H, too.
Update the example to match reality.

Link: https://lore.kernel.org/r/905134c87f72e2d8e37c309e0ce28ecd7d4f3992.1620323639.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../bindings/net/can/rcar_canfd.txt           | 107 ---------------
 .../bindings/net/can/renesas,rcar-canfd.yaml  | 122 ++++++++++++++++++
 2 files changed, 122 insertions(+), 107 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/can/rcar_canfd.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml

diff --git a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
deleted file mode 100644
index 248c4ed97a0a..000000000000
--- a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
+++ /dev/null
@@ -1,107 +0,0 @@
-Renesas R-Car CAN FD controller Device Tree Bindings
-----------------------------------------------------
-
-Required properties:
-- compatible: Must contain one or more of the following:
-  - "renesas,rcar-gen3-canfd" for R-Car Gen3 and RZ/G2 compatible controllers.
-  - "renesas,r8a774a1-canfd" for R8A774A1 (RZ/G2M) compatible controller.
-  - "renesas,r8a774b1-canfd" for R8A774B1 (RZ/G2N) compatible controller.
-  - "renesas,r8a774c0-canfd" for R8A774C0 (RZ/G2E) compatible controller.
-  - "renesas,r8a774e1-canfd" for R8A774E1 (RZ/G2H) compatible controller.
-  - "renesas,r8a7795-canfd" for R8A7795 (R-Car H3) compatible controller.
-  - "renesas,r8a7796-canfd" for R8A7796 (R-Car M3-W) compatible controller.
-  - "renesas,r8a77965-canfd" for R8A77965 (R-Car M3-N) compatible controller.
-  - "renesas,r8a77970-canfd" for R8A77970 (R-Car V3M) compatible controller.
-  - "renesas,r8a77980-canfd" for R8A77980 (R-Car V3H) compatible controller.
-  - "renesas,r8a77990-canfd" for R8A77990 (R-Car E3) compatible controller.
-  - "renesas,r8a77995-canfd" for R8A77995 (R-Car D3) compatible controller.
-
-  When compatible with the generic version, nodes must list the
-  SoC-specific version corresponding to the platform first, followed by the
-  family-specific and/or generic versions.
-
-- reg: physical base address and size of the R-Car CAN FD register map.
-- interrupts: interrupt specifiers for the Channel & Global interrupts
-- clocks: phandles and clock specifiers for 3 clock inputs.
-- clock-names: 3 clock input name strings: "fck", "canfd", "can_clk".
-- pinctrl-0: pin control group to be used for this controller.
-- pinctrl-names: must be "default".
-
-Required child nodes:
-The controller supports two channels and each is represented as a child node.
-The name of the child nodes are "channel0" and "channel1" respectively. Each
-child node supports the "status" property only, which is used to
-enable/disable the respective channel.
-
-Required properties for R8A774A1, R8A774B1, R8A774C0, R8A774E1, R8A7795,
-R8A7796, R8A77965, R8A77990, and R8A77995:
-In the denoted SoCs, canfd clock is a div6 clock and can be used by both CAN
-and CAN FD controller at the same time. It needs to be scaled to maximum
-frequency if any of these controllers use it. This is done using the below
-properties:
-
-- assigned-clocks: phandle of canfd clock.
-- assigned-clock-rates: maximum frequency of this clock.
-
-Optional property:
-The controller can operate in either CAN FD only mode (default) or
-Classical CAN only mode. The mode is global to both the channels. In order to
-enable the later, define the following optional property.
- - renesas,no-can-fd: puts the controller in Classical CAN only mode.
-
-Example
--------
-
-SoC common .dtsi file:
-
-		canfd: can@e66c0000 {
-			compatible = "renesas,r8a7795-canfd",
-				     "renesas,rcar-gen3-canfd";
-			reg = <0 0xe66c0000 0 0x8000>;
-			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
-				   <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&cpg CPG_MOD 914>,
-			       <&cpg CPG_CORE R8A7795_CLK_CANFD>,
-			       <&can_clk>;
-			clock-names = "fck", "canfd", "can_clk";
-			assigned-clocks = <&cpg CPG_CORE R8A7795_CLK_CANFD>;
-			assigned-clock-rates = <40000000>;
-			power-domains = <&cpg>;
-			status = "disabled";
-
-			channel0 {
-				status = "disabled";
-			};
-
-			channel1 {
-				status = "disabled";
-			};
-		};
-
-Board specific .dts file:
-
-E.g. below enables Channel 1 alone in the board in Classical CAN only mode.
-
-&canfd {
-	pinctrl-0 = <&canfd1_pins>;
-	pinctrl-names = "default";
-	renesas,no-can-fd;
-	status = "okay";
-
-	channel1 {
-		status = "okay";
-	};
-};
-
-E.g. below enables Channel 0 alone in the board using External clock
-as fCAN clock.
-
-&canfd {
-	pinctrl-0 = <&canfd0_pins>, <&can_clk_pins>;
-	pinctrl-names = "default";
-	status = "okay";
-
-	channel0 {
-		status = "okay";
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
new file mode 100644
index 000000000000..0b33ba9ccb47
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -0,0 +1,122 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/renesas,rcar-canfd.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Renesas R-Car CAN FD Controller
+
+maintainers:
+  - Fabrizio Castro <fabrizio.castro.jz@renesas.com>
+
+allOf:
+  - $ref: can-controller.yaml#
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - renesas,r8a774a1-canfd     # RZ/G2M
+              - renesas,r8a774b1-canfd     # RZ/G2N
+              - renesas,r8a774c0-canfd     # RZ/G2E
+              - renesas,r8a774e1-canfd     # RZ/G2H
+              - renesas,r8a7795-canfd      # R-Car H3
+              - renesas,r8a7796-canfd      # R-Car M3-W
+              - renesas,r8a77965-canfd     # R-Car M3-N
+              - renesas,r8a77970-canfd     # R-Car V3M
+              - renesas,r8a77980-canfd     # R-Car V3H
+              - renesas,r8a77990-canfd     # R-Car E3
+              - renesas,r8a77995-canfd     # R-Car D3
+          - const: renesas,rcar-gen3-canfd # R-Car Gen3 and RZ/G2
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    items:
+      - description: Channel interrupt
+      - description: Global interrupt
+
+  clocks:
+    maxItems: 3
+
+  clock-names:
+    items:
+      - const: fck
+      - const: canfd
+      - const: can_clk
+
+  power-domains:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  renesas,no-can-fd:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      The controller can operate in either CAN FD only mode (default) or
+      Classical CAN only mode.  The mode is global to both the channels.
+      Specify this property to put the controller in Classical CAN only mode.
+
+  assigned-clocks:
+    description:
+      Reference to the CANFD clock.  The CANFD clock is a div6 clock and can be
+      used by both CAN (if present) and CAN FD controllers at the same time.
+      It needs to be scaled to maximum frequency if any of these controllers
+      use it.
+
+  assigned-clock-rates:
+    description: Maximum frequency of the CANFD clock.
+
+patternProperties:
+  "^channel[01]$":
+    type: object
+    description:
+      The controller supports two channels and each is represented as a child
+      node.  Each child node supports the "status" property only, which
+      is used to enable/disable the respective channel.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - power-domains
+  - resets
+  - assigned-clocks
+  - assigned-clock-rates
+  - channel0
+  - channel1
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/r8a7795-cpg-mssr.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/power/r8a7795-sysc.h>
+
+    canfd: can@e66c0000 {
+            compatible = "renesas,r8a7795-canfd",
+                         "renesas,rcar-gen3-canfd";
+            reg = <0xe66c0000 0x8000>;
+            interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+            clocks = <&cpg CPG_MOD 914>,
+                     <&cpg CPG_CORE R8A7795_CLK_CANFD>,
+                     <&can_clk>;
+            clock-names = "fck", "canfd", "can_clk";
+            assigned-clocks = <&cpg CPG_CORE R8A7795_CLK_CANFD>;
+            assigned-clock-rates = <40000000>;
+            power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
+            resets = <&cpg 914>;
+
+            channel0 {
+            };
+
+            channel1 {
+            };
+    };
-- 
2.30.2



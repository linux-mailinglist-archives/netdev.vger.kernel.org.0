Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7643757B284
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240382AbiGTIM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240380AbiGTILx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:11:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30029691E3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:11:35 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE4nt-0000Nq-7t
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:11:33 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BAED1B58DD
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:10:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D68FCB58C3;
        Wed, 20 Jul 2022 08:10:38 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 50fa90e6;
        Wed, 20 Jul 2022 08:10:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Biju Das <biju.das.jz@bp.renesas.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 07/29] dt-bindings: can: sja1000: Convert to json-schema
Date:   Wed, 20 Jul 2022 10:10:12 +0200
Message-Id: <20220720081034.3277385-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720081034.3277385-1-mkl@pengutronix.de>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

Convert the NXP SJA1000 CAN Controller Device Tree binding
documentation to json-schema.

Update the example to match reality.

Link: https://lore.kernel.org/all/20220710115248.190280-2-biju.das.jz@bp.renesas.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../bindings/net/can/nxp,sja1000.yaml         | 101 ++++++++++++++++++
 .../devicetree/bindings/net/can/sja1000.txt   |  58 ----------
 2 files changed, 101 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/sja1000.txt

diff --git a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
new file mode 100644
index 000000000000..ca9bfdfa50ab
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
@@ -0,0 +1,101 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/nxp,sja1000.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Memory mapped SJA1000 CAN controller from NXP (formerly Philips)
+
+maintainers:
+  - Wolfgang Grandegger <wg@grandegger.com>
+
+properties:
+  compatible:
+    enum:
+      - nxp,sja1000
+      - technologic,sja1000
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  reg-io-width:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: I/O register width (in bytes) implemented by this device
+    default: 1
+    enum: [ 1, 2, 4 ]
+
+  nxp,external-clock-frequency:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 16000000
+    description: |
+      Frequency of the external oscillator clock in Hz.
+      The internal clock frequency used by the SJA1000 is half of that value.
+
+  nxp,tx-output-mode:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [ 0, 1, 2, 3 ]
+    default: 1
+    description: |
+      operation mode of the TX output control logic. Valid values are:
+        <0> : bi-phase output mode
+        <1> : normal output mode (default)
+        <2> : test output mode
+        <3> : clock output mode
+
+  nxp,tx-output-config:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 0x02
+    description: |
+      TX output pin configuration. Valid values are any one of the below
+      or combination of TX0 and TX1:
+        <0x01> : TX0 invert
+        <0x02> : TX0 pull-down (default)
+        <0x04> : TX0 pull-up
+        <0x06> : TX0 push-pull
+        <0x08> : TX1 invert
+        <0x10> : TX1 pull-down
+        <0x20> : TX1 pull-up
+        <0x30> : TX1 push-pull
+
+  nxp,clock-out-frequency:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      clock frequency in Hz on the CLKOUT pin.
+      If not specified or if the specified value is 0, the CLKOUT pin
+      will be disabled.
+
+  nxp,no-comparator-bypass:
+    type: boolean
+    description: Allows to disable the CAN input comparator.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+allOf:
+  - $ref: can-controller.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: technologic,sja1000
+    then:
+      required:
+        - reg-io-width
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    can@1a000 {
+        compatible = "technologic,sja1000";
+        reg = <0x1a000 0x100>;
+        interrupts = <1>;
+        reg-io-width = <2>;
+        nxp,tx-output-config = <0x06>;
+        nxp,external-clock-frequency = <24000000>;
+    };
diff --git a/Documentation/devicetree/bindings/net/can/sja1000.txt b/Documentation/devicetree/bindings/net/can/sja1000.txt
deleted file mode 100644
index ac3160eca96a..000000000000
--- a/Documentation/devicetree/bindings/net/can/sja1000.txt
+++ /dev/null
@@ -1,58 +0,0 @@
-Memory mapped SJA1000 CAN controller from NXP (formerly Philips)
-
-Required properties:
-
-- compatible : should be one of "nxp,sja1000", "technologic,sja1000".
-
-- reg : should specify the chip select, address offset and size required
-	to map the registers of the SJA1000. The size is usually 0x80.
-
-- interrupts: property with a value describing the interrupt source
-	(number and sensitivity) required for the SJA1000.
-
-Optional properties:
-
-- reg-io-width : Specify the size (in bytes) of the IO accesses that
-	should be performed on the device.  Valid value is 1, 2 or 4.
-	This property is ignored for technologic version.
-	Default to 1 (8 bits).
-
-- nxp,external-clock-frequency : Frequency of the external oscillator
-	clock in Hz. Note that the internal clock frequency used by the
-	SJA1000 is half of that value. If not specified, a default value
-	of 16000000 (16 MHz) is used.
-
-- nxp,tx-output-mode : operation mode of the TX output control logic:
-	<0x0> : bi-phase output mode
-	<0x1> : normal output mode (default)
-	<0x2> : test output mode
-	<0x3> : clock output mode
-
-- nxp,tx-output-config : TX output pin configuration:
-	<0x01> : TX0 invert
-	<0x02> : TX0 pull-down (default)
-	<0x04> : TX0 pull-up
-	<0x06> : TX0 push-pull
-	<0x08> : TX1 invert
-	<0x10> : TX1 pull-down
-	<0x20> : TX1 pull-up
-	<0x30> : TX1 push-pull
-
-- nxp,clock-out-frequency : clock frequency in Hz on the CLKOUT pin.
-	If not specified or if the specified value is 0, the CLKOUT pin
-	will be disabled.
-
-- nxp,no-comparator-bypass : Allows to disable the CAN input comparator.
-
-For further information, please have a look to the SJA1000 data sheet.
-
-Examples:
-
-can@3,100 {
-	compatible = "nxp,sja1000";
-	reg = <3 0x100 0x80>;
-	interrupts = <2 0>;
-	interrupt-parent = <&mpic>;
-	nxp,external-clock-frequency = <16000000>;
-};
-
-- 
2.35.1



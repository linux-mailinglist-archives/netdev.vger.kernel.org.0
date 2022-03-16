Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6094DB9BF
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358065AbiCPUuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243535AbiCPUus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:50:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3EA55BE6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:49:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nUaaJ-0003qR-Gu
        for netdev@vger.kernel.org; Wed, 16 Mar 2022 21:49:31 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 323A54CBB7
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:47:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BFA104CB81;
        Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 55d4793f;
        Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 4/5] dt-bindings: can: xilinx_can: Convert Xilinx CAN binding to YAML
Date:   Wed, 16 Mar 2022 21:47:09 +0100
Message-Id: <20220316204710.716341-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316204710.716341-1-mkl@pengutronix.de>
References: <20220316204710.716341-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>

Convert Xilinx CAN binding documentation to YAML.

Link: https://lore.kernel.org/all/20220316171105.17654-1-amit.kumar-mahapatra@xilinx.com
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../bindings/net/can/xilinx,can.yaml          | 161 ++++++++++++++++++
 .../bindings/net/can/xilinx_can.txt           |  61 -------
 2 files changed, 161 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/xilinx,can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt

diff --git a/Documentation/devicetree/bindings/net/can/xilinx,can.yaml b/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
new file mode 100644
index 000000000000..65af8183cb9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
@@ -0,0 +1,161 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/xilinx,can.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title:
+  Xilinx Axi CAN/Zynq CANPS controller
+
+maintainers:
+  - Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
+
+properties:
+  compatible:
+    enum:
+      - xlnx,zynq-can-1.0
+      - xlnx,axi-can-1.00.a
+      - xlnx,canfd-1.0
+      - xlnx,canfd-2.0
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 1
+    maxItems: 2
+
+  clock-names:
+    maxItems: 2
+
+  power-domains:
+    maxItems: 1
+
+  tx-fifo-depth:
+    $ref: "/schemas/types.yaml#/definitions/uint32"
+    description: CAN Tx fifo depth (Zynq, Axi CAN).
+
+  rx-fifo-depth:
+    $ref: "/schemas/types.yaml#/definitions/uint32"
+    description: CAN Rx fifo depth (Zynq, Axi CAN, CAN FD in sequential Rx mode)
+
+  tx-mailbox-count:
+    $ref: "/schemas/types.yaml#/definitions/uint32"
+    description: CAN Tx mailbox buffer count (CAN FD)
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+
+unevaluatedProperties: false
+
+allOf:
+  - $ref: can-controller.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - xlnx,zynq-can-1.0
+
+    then:
+      properties:
+        clock-names:
+          items:
+            - const: can_clk
+            - const: pclk
+      required:
+        - tx-fifo-depth
+        - rx-fifo-depth
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - xlnx,axi-can-1.00.a
+
+    then:
+      properties:
+        clock-names:
+          items:
+            - const: can_clk
+            - const: s_axi_aclk
+      required:
+        - tx-fifo-depth
+        - rx-fifo-depth
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - xlnx,canfd-1.0
+              - xlnx,canfd-2.0
+
+    then:
+      properties:
+        clock-names:
+          items:
+            - const: can_clk
+            - const: s_axi_aclk
+      required:
+        - tx-mailbox-count
+        - rx-fifo-depth
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    can@e0008000 {
+        compatible = "xlnx,zynq-can-1.0";
+        reg = <0xe0008000 0x1000>;
+        clocks = <&clkc 19>, <&clkc 36>;
+        clock-names = "can_clk", "pclk";
+        interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-parent = <&intc>;
+        tx-fifo-depth = <0x40>;
+        rx-fifo-depth = <0x40>;
+    };
+
+  - |
+    can@40000000 {
+        compatible = "xlnx,axi-can-1.00.a";
+        reg = <0x40000000 0x10000>;
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk", "s_axi_aclk";
+        interrupt-parent = <&intc>;
+        interrupts = <GIC_SPI 59 IRQ_TYPE_EDGE_RISING>;
+        tx-fifo-depth = <0x40>;
+        rx-fifo-depth = <0x40>;
+    };
+
+  - |
+    can@40000000 {
+        compatible = "xlnx,canfd-1.0";
+        reg = <0x40000000 0x2000>;
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk", "s_axi_aclk";
+        interrupt-parent = <&intc>;
+        interrupts = <GIC_SPI 59 IRQ_TYPE_EDGE_RISING>;
+        tx-mailbox-count = <0x20>;
+        rx-fifo-depth = <0x20>;
+    };
+
+  - |
+    can@ff060000 {
+        compatible = "xlnx,canfd-2.0";
+        reg = <0xff060000 0x6000>;
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk", "s_axi_aclk";
+        interrupt-parent = <&intc>;
+        interrupts = <GIC_SPI 59 IRQ_TYPE_EDGE_RISING>;
+        tx-mailbox-count = <0x20>;
+        rx-fifo-depth = <0x40>;
+    };
diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.txt b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
deleted file mode 100644
index 100cc40b8510..000000000000
--- a/Documentation/devicetree/bindings/net/can/xilinx_can.txt
+++ /dev/null
@@ -1,61 +0,0 @@
-Xilinx Axi CAN/Zynq CANPS controller Device Tree Bindings
----------------------------------------------------------
-
-Required properties:
-- compatible		: Should be:
-			  - "xlnx,zynq-can-1.0" for Zynq CAN controllers
-			  - "xlnx,axi-can-1.00.a" for Axi CAN controllers
-			  - "xlnx,canfd-1.0" for CAN FD controllers
-			  - "xlnx,canfd-2.0" for CAN FD 2.0 controllers
-- reg			: Physical base address and size of the controller
-			  registers map.
-- interrupts		: Property with a value describing the interrupt
-			  number.
-- clock-names		: List of input clock names
-			  - "can_clk", "pclk" (For CANPS),
-			  - "can_clk", "s_axi_aclk" (For AXI CAN and CAN FD).
-			  (See clock bindings for details).
-- clocks		: Clock phandles (see clock bindings for details).
-- tx-fifo-depth		: Can Tx fifo depth (Zynq, Axi CAN).
-- rx-fifo-depth		: Can Rx fifo depth (Zynq, Axi CAN, CAN FD in
-                          sequential Rx mode).
-- tx-mailbox-count	: Can Tx mailbox buffer count (CAN FD).
-- rx-mailbox-count	: Can Rx mailbox buffer count (CAN FD in mailbox Rx
-			  mode).
-
-
-Example:
-
-For Zynq CANPS Dts file:
-	zynq_can_0: can@e0008000 {
-			compatible = "xlnx,zynq-can-1.0";
-			clocks = <&clkc 19>, <&clkc 36>;
-			clock-names = "can_clk", "pclk";
-			reg = <0xe0008000 0x1000>;
-			interrupts = <0 28 4>;
-			interrupt-parent = <&intc>;
-			tx-fifo-depth = <0x40>;
-			rx-fifo-depth = <0x40>;
-		};
-For Axi CAN Dts file:
-	axi_can_0: axi-can@40000000 {
-			compatible = "xlnx,axi-can-1.00.a";
-			clocks = <&clkc 0>, <&clkc 1>;
-			clock-names = "can_clk","s_axi_aclk" ;
-			reg = <0x40000000 0x10000>;
-			interrupt-parent = <&intc>;
-			interrupts = <0 59 1>;
-			tx-fifo-depth = <0x40>;
-			rx-fifo-depth = <0x40>;
-		};
-For CAN FD Dts file:
-	canfd_0: canfd@40000000 {
-			compatible = "xlnx,canfd-1.0";
-			clocks = <&clkc 0>, <&clkc 1>;
-			clock-names = "can_clk", "s_axi_aclk";
-			reg = <0x40000000 0x2000>;
-			interrupt-parent = <&intc>;
-			interrupts = <0 59 1>;
-			tx-mailbox-count = <0x20>;
-			rx-fifo-depth = <0x20>;
-		};
-- 
2.35.1



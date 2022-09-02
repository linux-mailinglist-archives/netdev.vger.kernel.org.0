Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFFB5AAA0C
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 10:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbiIBIcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 04:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbiIBIcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 04:32:18 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55013C120B;
        Fri,  2 Sep 2022 01:32:16 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5ED77C0006;
        Fri,  2 Sep 2022 08:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662107534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qegMkF19xAcLQa6JDOAXefIyKZArlASawEgscX+n7gY=;
        b=grRy+tUsmfd9JoMDtWg5RfGqluecCw7P3WMhHPXfkIHcbhkYZ5qlYZstd4K5UqqEzwHc7O
        IIsNeEZd4gJ3fwdSsqMm8JxCevyuCN/KtuP63TNG8x/ytHQKboZEuTRYfw/a3+nIulSWzx
        +zFPx6hoGxYGUnt/2kaKGTUJzC4fImJ1GZcubelUtbYFgn7X80dk/OsWUbY/gUI+mA0aF3
        bZSqNmCzEPm51iFF+ISJd/iH4dQFyArd3pxrBmiJDTctVUM4q8o7L4pjLQZ4BW5dtlvpgQ
        F4lRGO20WEyQim9z6usAchgN1bJRIgHHY5CDwSt8i+bLUENjWm0iuKa+Q/Qg8Q==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v4 1/5] dt-bindings: net: Convert Altera TSE bindings to yaml
Date:   Fri,  2 Sep 2022 10:32:01 +0200
Message-Id: <20220902083205.483438-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220902083205.483438-1-maxime.chevallier@bootlin.com>
References: <20220902083205.483438-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the bindings for the Altera Triple-Speed Ethernet to yaml.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V3->V4 : No changes
V2->V3:
 - Moved allOf below required
 - Removed unnedded reg/reg-names in the properties section
 - Removed stray minItems

V1->V2:
 - Removed unnedded maxItems
 - Added missing minItems
 - Fixed typos in some properties names
 - Fixed the mdio subnode definition

 .../devicetree/bindings/net/altera_tse.txt    | 113 --------------
 .../devicetree/bindings/net/altr,tse.yaml     | 141 ++++++++++++++++++
 2 files changed, 141 insertions(+), 113 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/altera_tse.txt
 create mode 100644 Documentation/devicetree/bindings/net/altr,tse.yaml

diff --git a/Documentation/devicetree/bindings/net/altera_tse.txt b/Documentation/devicetree/bindings/net/altera_tse.txt
deleted file mode 100644
index 1d9148ff5130..000000000000
--- a/Documentation/devicetree/bindings/net/altera_tse.txt
+++ /dev/null
@@ -1,113 +0,0 @@
-* Altera Triple-Speed Ethernet MAC driver (TSE)
-
-Required properties:
-- compatible: Should be "altr,tse-1.0" for legacy SGDMA based TSE, and should
-		be "altr,tse-msgdma-1.0" for the preferred MSGDMA based TSE.
-		ALTR is supported for legacy device trees, but is deprecated.
-		altr should be used for all new designs.
-- reg: Address and length of the register set for the device. It contains
-  the information of registers in the same order as described by reg-names
-- reg-names: Should contain the reg names
-  "control_port": MAC configuration space region
-  "tx_csr":       xDMA Tx dispatcher control and status space region
-  "tx_desc":      MSGDMA Tx dispatcher descriptor space region
-  "rx_csr" :      xDMA Rx dispatcher control and status space region
-  "rx_desc":      MSGDMA Rx dispatcher descriptor space region
-  "rx_resp":      MSGDMA Rx dispatcher response space region
-  "s1":		  SGDMA descriptor memory
-- interrupts: Should contain the TSE interrupts and its mode.
-- interrupt-names: Should contain the interrupt names
-  "rx_irq":       xDMA Rx dispatcher interrupt
-  "tx_irq":       xDMA Tx dispatcher interrupt
-- rx-fifo-depth: MAC receive FIFO buffer depth in bytes
-- tx-fifo-depth: MAC transmit FIFO buffer depth in bytes
-- phy-mode: See ethernet.txt in the same directory.
-- phy-handle: See ethernet.txt in the same directory.
-- phy-addr: See ethernet.txt in the same directory. A configuration should
-		include phy-handle or phy-addr.
-- altr,has-supplementary-unicast:
-		If present, TSE supports additional unicast addresses.
-		Otherwise additional unicast addresses are not supported.
-- altr,has-hash-multicast-filter:
-		If present, TSE supports a hash based multicast filter.
-		Otherwise, hash-based multicast filtering is not supported.
-
-- mdio device tree subnode: When the TSE has a phy connected to its local
-		mdio, there must be device tree subnode with the following
-		required properties:
-
-	- compatible: Must be "altr,tse-mdio".
-	- #address-cells: Must be <1>.
-	- #size-cells: Must be <0>.
-
-	For each phy on the mdio bus, there must be a node with the following
-	fields:
-
-	- reg: phy id used to communicate to phy.
-	- device_type: Must be "ethernet-phy".
-
-The MAC address will be determined using the optional properties defined in
-ethernet.txt.
-
-Example:
-
-	tse_sub_0_eth_tse_0: ethernet@1,00000000 {
-		compatible = "altr,tse-msgdma-1.0";
-		reg =	<0x00000001 0x00000000 0x00000400>,
-			<0x00000001 0x00000460 0x00000020>,
-			<0x00000001 0x00000480 0x00000020>,
-			<0x00000001 0x000004A0 0x00000008>,
-			<0x00000001 0x00000400 0x00000020>,
-			<0x00000001 0x00000420 0x00000020>;
-		reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc";
-		interrupt-parent = <&hps_0_arm_gic_0>;
-		interrupts = <0 41 4>, <0 40 4>;
-		interrupt-names = "rx_irq", "tx_irq";
-		rx-fifo-depth = <2048>;
-		tx-fifo-depth = <2048>;
-		address-bits = <48>;
-		max-frame-size = <1500>;
-		local-mac-address = [ 00 00 00 00 00 00 ];
-		phy-mode = "gmii";
-		altr,has-supplementary-unicast;
-		altr,has-hash-multicast-filter;
-		phy-handle = <&phy0>;
-		mdio {
-			compatible = "altr,tse-mdio";
-			#address-cells = <1>;
-			#size-cells = <0>;
-			phy0: ethernet-phy@0 {
-				reg = <0x0>;
-				device_type = "ethernet-phy";
-			};
-
-			phy1: ethernet-phy@1 {
-				reg = <0x1>;
-				device_type = "ethernet-phy";
-			};
-
-		};
-	};
-
-	tse_sub_1_eth_tse_0: ethernet@1,00001000 {
-		compatible = "altr,tse-msgdma-1.0";
-		reg = 	<0x00000001 0x00001000 0x00000400>,
-			<0x00000001 0x00001460 0x00000020>,
-			<0x00000001 0x00001480 0x00000020>,
-			<0x00000001 0x000014A0 0x00000008>,
-			<0x00000001 0x00001400 0x00000020>,
-			<0x00000001 0x00001420 0x00000020>;
-		reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc";
-		interrupt-parent = <&hps_0_arm_gic_0>;
-		interrupts = <0 43 4>, <0 42 4>;
-		interrupt-names = "rx_irq", "tx_irq";
-		rx-fifo-depth = <2048>;
-		tx-fifo-depth = <2048>;
-		address-bits = <48>;
-		max-frame-size = <1500>;
-		local-mac-address = [ 00 00 00 00 00 00 ];
-		phy-mode = "gmii";
-		altr,has-supplementary-unicast;
-		altr,has-hash-multicast-filter;
-		phy-handle = <&phy1>;
-	};
diff --git a/Documentation/devicetree/bindings/net/altr,tse.yaml b/Documentation/devicetree/bindings/net/altr,tse.yaml
new file mode 100644
index 000000000000..78c7a2047910
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/altr,tse.yaml
@@ -0,0 +1,141 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/altr,tse.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Altera Triple Speed Ethernet MAC driver (TSE)
+
+maintainers:
+  - Maxime Chevallier <maxime.chevallier@bootlin.com>
+
+properties:
+  compatible:
+    oneOf:
+      - const: altr,tse-1.0
+      - const: ALTR,tse-1.0
+        deprecated: true
+      - const: altr,tse-msgdma-1.0
+
+  interrupts:
+    minItems: 2
+
+  interrupt-names:
+    items:
+      - const: rx_irq
+      - const: tx_irq
+
+  rx-fifo-depth:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Depth in bytes of the RX FIFO
+
+  tx-fifo-depth:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Depth in bytes of the TX FIFO
+
+  altr,has-supplementary-unicast:
+    type: boolean
+    description:
+      If present, TSE supports additional unicast addresses.
+
+  altr,has-hash-multicast-filter:
+    type: boolean
+    description:
+      If present, TSE supports hash based multicast filter.
+
+  mdio:
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
+    description:
+      Creates and registers an MDIO bus.
+
+    properties:
+      compatible:
+        const: altr,tse-mdio
+
+    required:
+      - compatible
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - rx-fifo-depth
+  - tx-fifo-depth
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - const: altr,tse-1.0
+              - const: ALTR,tse-1.0
+    then:
+      properties:
+        reg:
+          minItems: 4
+        reg-names:
+          items:
+            - const: control_port
+            - const: rx_csr
+            - const: tx_csr
+            - const: s1
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - altr,tse-msgdma-1.0
+    then:
+      properties:
+        reg:
+          minItems: 6
+        reg-names:
+          items:
+            - const: control_port
+            - const: rx_csr
+            - const: rx_desc
+            - const: rx_resp
+            - const: tx_csr
+            - const: tx_desc
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    tse_sub_1_eth_tse_0: ethernet@1,00001000 {
+        compatible = "altr,tse-msgdma-1.0";
+        reg = <0x00001000 0x00000400>,
+              <0x00001460 0x00000020>,
+              <0x00001480 0x00000020>,
+              <0x000014A0 0x00000008>,
+              <0x00001400 0x00000020>,
+              <0x00001420 0x00000020>;
+        reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc";
+        interrupt-parent = <&hps_0_arm_gic_0>;
+        interrupts = <0 43 4>, <0 42 4>;
+        interrupt-names = "rx_irq", "tx_irq";
+        rx-fifo-depth = <2048>;
+        tx-fifo-depth = <2048>;
+        max-frame-size = <1500>;
+        local-mac-address = [ 00 00 00 00 00 00 ];
+        phy-mode = "gmii";
+        altr,has-supplementary-unicast;
+        altr,has-hash-multicast-filter;
+        phy-handle = <&phy1>;
+        mdio {
+            compatible = "altr,tse-mdio";
+            #address-cells = <1>;
+            #size-cells = <0>;
+            phy1: ethernet-phy@1 {
+                reg = <0x1>;
+            };
+        };
+    };
+
+...
-- 
2.37.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD3F3B20A
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 11:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389002AbfFJJ07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 05:26:59 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46327 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388999AbfFJJ06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 05:26:58 -0400
X-Originating-IP: 90.88.159.246
Received: from localhost (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 225D860003;
        Mon, 10 Jun 2019 09:26:51 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 05/11] dt-bindings: net: sun4i-emac: Convert the binding to a schemas
Date:   Mon, 10 Jun 2019 11:25:44 +0200
Message-Id: <d198d29119b37b2fdb700d8992b31963e98b6693.1560158667.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch our Allwinner A10 EMAC controller binding to a YAML schema to enable
the DT validation.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt      | 19 -------------------
 2 files changed, 55 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
new file mode 100644
index 000000000000..b5d82d0a59d8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/allwinner,sun4i-a10-emac.yaml
@@ -0,0 +1,55 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/allwinner,sun4i-a10-emac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner A10 EMAC Ethernet Controller Device Tree Bindings
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+maintainers:
+  - Chen-Yu Tsai <wens@csie.org>
+  - Maxime Ripard <maxime.ripard@bootlin.com>
+
+properties:
+  compatible:
+    const: allwinner,sun4i-a10-emac
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  allwinner,sram:
+    description: Phandle to the device SRAM
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - phy
+  - allwinner,sram
+
+examples:
+  - |
+    emac: ethernet@1c0b000 {
+        compatible = "allwinner,sun4i-a10-emac";
+        reg = <0x01c0b000 0x1000>;
+        interrupts = <55>;
+        clocks = <&ahb_gates 17>;
+        phy = <&phy0>;
+    };
+
+# FIXME: We should set it, but it would report all the generic
+# properties as additional properties.
+# additionalProperties: false
+
+...
diff --git a/Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt b/Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt
deleted file mode 100644
index e98118aef5f6..000000000000
--- a/Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt
+++ /dev/null
@@ -1,19 +0,0 @@
-* Allwinner EMAC ethernet controller
-
-Required properties:
-- compatible: should be "allwinner,sun4i-a10-emac" (Deprecated:
-              "allwinner,sun4i-emac")
-- reg: address and length of the register set for the device.
-- interrupts: interrupt for the device
-- phy: see ethernet.txt file in the same directory.
-- clocks: A phandle to the reference clock for this device
-
-Example:
-
-emac: ethernet@1c0b000 {
-       compatible = "allwinner,sun4i-a10-emac";
-       reg = <0x01c0b000 0x1000>;
-       interrupts = <55>;
-       clocks = <&ahb_gates 17>;
-       phy = <&phy0>;
-};
-- 
git-series 0.9.1

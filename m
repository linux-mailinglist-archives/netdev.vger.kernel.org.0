Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FD4585AE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfF0PcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:32:17 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:58637 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0PcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:32:17 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 9B895240004;
        Thu, 27 Jun 2019 15:32:09 +0000 (UTC)
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
Subject: [PATCH v4 03/13] dt-bindings: net: Add a YAML schemas for the generic MDIO options
Date:   Thu, 27 Jun 2019 17:31:45 +0200
Message-Id: <e99ff7377a0d3d140cf62200fd9d62c108dac24e.1561649505.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
References: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDIO buses have a number of available device tree properties that can
be used in their device tree node. Add a YAML schemas for those.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 Documentation/devicetree/bindings/net/mdio.txt  | 38 +-------------
 Documentation/devicetree/bindings/net/mdio.yaml | 51 ++++++++++++++++++-
 2 files changed, 52 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/mdio.yaml

diff --git a/Documentation/devicetree/bindings/net/mdio.txt b/Documentation/devicetree/bindings/net/mdio.txt
index e3e1603f256c..cf8a0105488e 100644
--- a/Documentation/devicetree/bindings/net/mdio.txt
+++ b/Documentation/devicetree/bindings/net/mdio.txt
@@ -1,37 +1 @@
-Common MDIO bus properties.
-
-These are generic properties that can apply to any MDIO bus.
-
-Optional properties:
-- reset-gpios: One GPIO that control the RESET lines of all PHYs on that MDIO
-  bus.
-- reset-delay-us: RESET pulse width in microseconds.
-
-A list of child nodes, one per device on the bus is expected. These
-should follow the generic phy.txt, or a device specific binding document.
-
-The 'reset-delay-us' indicates the RESET signal pulse width in microseconds and
-applies to all PHY devices. It must therefore be appropriately determined based
-on all PHY requirements (maximum value of all per-PHY RESET pulse widths).
-
-Example :
-This example shows these optional properties, plus other properties
-required for the TI Davinci MDIO driver.
-
-	davinci_mdio: ethernet@5c030000 {
-		compatible = "ti,davinci_mdio";
-		reg = <0x5c030000 0x1000>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		reset-gpios = <&gpio2 5 GPIO_ACTIVE_LOW>;
-		reset-delay-us = <2>;
-
-		ethphy0: ethernet-phy@1 {
-			reg = <1>;
-		};
-
-		ethphy1: ethernet-phy@3 {
-			reg = <3>;
-		};
-	};
+This file has moved to mdio.yaml.
diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
new file mode 100644
index 000000000000..b8fa8251c4bc
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -0,0 +1,51 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mdio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MDIO Bus Generic Binding
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Heiner Kallweit <hkallweit1@gmail.com>
+
+description:
+  These are generic properties that can apply to any MDIO bus. Any
+  MDIO bus must have a list of child nodes, one per device on the
+  bus. These should follow the generic ethernet-phy.yaml document, or
+  a device specific binding document.
+
+properties:
+  reset-gpios:
+    maxItems: 1
+    description:
+      The phandle and specifier for the GPIO that controls the RESET
+      lines of all PHYs on that MDIO bus.
+
+  reset-delay-us:
+    description:
+      RESET pulse width in microseconds. It applies to all PHY devices
+      and must therefore be appropriately determined based on all PHY
+      requirements (maximum value of all per-PHY RESET pulse widths).
+
+examples:
+  - |
+    davinci_mdio: mdio@5c030000 {
+        compatible = "ti,davinci_mdio";
+        reg = <0x5c030000 0x1000>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        reset-gpios = <&gpio2 5 1>;
+        reset-delay-us = <2>;
+
+        ethphy0: ethernet-phy@1 {
+            reg = <1>;
+        };
+
+        ethphy1: ethernet-phy@3 {
+            reg = <3>;
+        };
+    };
-- 
git-series 0.9.1

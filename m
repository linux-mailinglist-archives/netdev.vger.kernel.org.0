Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD72F3B203
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 11:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388992AbfFJJ0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 05:26:48 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52293 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388397AbfFJJ0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 05:26:46 -0400
X-Originating-IP: 90.88.159.246
Received: from localhost (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id A773AC000B;
        Mon, 10 Jun 2019 09:26:42 +0000 (UTC)
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
Subject: [PATCH v2 10/11] dt-bindings: net: dwmac: Deprecate the PHY reset properties
Date:   Mon, 10 Jun 2019 11:25:49 +0200
Message-Id: <ff6306c71a6b6ad174007f9f2823499d3093e21c.1560158667.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though the DWMAC driver uses some driver specific properties, the PHY
core has a bunch of generic properties and can deal with them nicely.

Let's deprecate our specific properties.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

---

Changes from v1:
  - New patch
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 54 ++++++------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index c48a089edc21..a2d56e8a7a39 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -171,26 +171,6 @@ properties:
             * snps,low_credit, max read outstanding req. limit
           * snps,priority, TX queue priority (Range 0x0 to 0xF)
 
-  snps,reset-gpio:
-    maxItems: 1
-    description:
-      PHY Reset GPIO
-
-  snps,reset-active-low:
-    $ref: /schemas/types.yaml#definitions/flag
-    description:
-      Indicates that the PHY Reset is active low
-
-  snps,reset-delays-us:
-    allOf:
-      - $ref: /schemas/types.yaml#definitions/uint32-array
-      - minItems: 3
-        maxItems: 3
-    description:
-      Triplet of delays. The 1st cell is reset pre-delay in micro
-      seconds. The 2nd cell is reset pulse in micro seconds. The 3rd
-      cell is reset post-delay in micro seconds.
-
   snps,aal:
     $ref: /schemas/types.yaml#definitions/flag
     description:
@@ -253,6 +233,36 @@ properties:
     required:
       - compatible
 
+  ## Deprecated properties
+  #
+  # Deprecated in favor of ethernet phy's reset-gpios property
+  # snps,reset-gpio:
+  #   maxItems: 1
+  #   description:
+  #     PHY Reset GPIO
+
+  # Deprecated in favor of ethernet phy's reset-gpios property
+  # snps,reset-active-low:
+  #   $ref: /schemas/types.yaml#definitions/flag
+  #   description:
+  #     Indicates that the PHY Reset is active low
+
+  # Deprecated in favor of ethernet phy's reset-assert-us and
+  # reset-deassert-us properties
+  # snps,reset-delays-us:
+  #   allOf:
+  #     - $ref: /schemas/types.yaml#definitions/uint32-array
+  #     - minItems: 3
+  #       maxItems: 3
+  #   description:
+  #     Triplet of delays. The 1st cell is reset pre-delay in micro
+  #     seconds. The 2nd cell is reset pulse in micro seconds. The 3rd
+  #     cell is reset post-delay in micro seconds.
+
+# dependencies:
+#   snps,reset-active-low: ["snps,reset-gpio"]
+#   snps,reset-delay-us: ["snps,reset-gpio"]
+
 required:
   - compatible
   - reg
@@ -260,10 +270,6 @@ required:
   - interrupt-names
   - phy-mode
 
-dependencies:
-  snps,reset-active-low: ["snps,reset-gpio"]
-  snps,reset-delay-us: ["snps,reset-gpio"]
-
 allOf:
   - $ref: "ethernet-controller.yaml#"
   - if:
-- 
git-series 0.9.1

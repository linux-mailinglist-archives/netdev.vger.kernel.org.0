Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA341C3454
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgEDI03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725941AbgEDI01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:26:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B6CC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:26:27 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVWQe-0001ZE-Mr; Mon, 04 May 2020 10:26:20 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVWQc-0002zd-Ub; Mon, 04 May 2020 10:26:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: [RFC PATCH] dt-bindings: net: nxp,tja11xx: add compatible support
Date:   Mon,  4 May 2020 10:26:17 +0200
Message-Id: <20200504082617.11326-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

... and correct SPDX-License-Identifier.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../devicetree/bindings/net/nxp,tja11xx.yaml  | 51 ++++++++++++-------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
index 42be0255512b3..e4ae8257f3258 100644
--- a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0+
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
 $id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
@@ -14,25 +14,36 @@ maintainers:
 description:
   Bindings for NXP TJA11xx automotive PHYs
 
-allOf:
-  - $ref: ethernet-phy.yaml#
+properties:
+  compatible:
+    oneOf:
+      - items:
+        - enum:
+          - nxp,tja1102
+        - const: ethernet-phy-ieee802.3-c22
 
-patternProperties:
-  "^ethernet-phy@[0-9a-f]+$":
-    type: object
-    description: |
-      Some packages have multiple PHYs. Secondary PHY should be defines as
-      subnode of the first (parent) PHY.
+  $nodename:
+    pattern: "^ethernet-phy(@[a-f0-9]+)?$"
 
-    properties:
-      reg:
-        minimum: 0
-        maximum: 31
-        description:
-          The ID number for the child PHY. Should be +1 of parent PHY.
+  reg:
+    minimum: 0
+    maximum: 31
+    description:
+      The ID number for the child PHY. Should be +1 of parent PHY.
 
-    required:
-      - reg
+  '#address-cells':
+    description: number of address cells for the MDIO bus
+    const: 1
+
+  '#size-cells':
+    description: number of size cells on the MDIO bus
+    const: 0
+
+required:
+  - compatible
+  - reg
+  - '#address-cells'
+  - '#size-cells'
 
 examples:
   - |
@@ -40,8 +51,9 @@ examples:
         #address-cells = <1>;
         #size-cells = <0>;
 
-        tja1101_phy0: ethernet-phy@4 {
-            reg = <0x4>;
+        tja1101_phy0: ethernet-phy@1 {
+            compatible = "nxp,tja1101", "ethernet-phy-ieee802.3-c22";
+            reg = <0x1>;
         };
     };
   - |
@@ -50,6 +62,7 @@ examples:
         #size-cells = <0>;
 
         tja1102_phy0: ethernet-phy@4 {
+            compatible = "nxp,tja1102", "ethernet-phy-ieee802.3-c22";
             reg = <0x4>;
             #address-cells = <1>;
             #size-cells = <0>;
-- 
2.26.2


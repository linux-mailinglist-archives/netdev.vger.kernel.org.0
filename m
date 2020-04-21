Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7821B26C1
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgDUMwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728850AbgDUMwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:52:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C35C061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:52:31 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jQsNz-0004N3-SF; Tue, 21 Apr 2020 14:52:23 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jQsNx-0002Gp-5g; Tue, 21 Apr 2020 14:52:21 +0200
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
Subject: [PATCH net-next v4 1/4] dt-bindings: net: phy: Add support for NXP TJA11xx
Date:   Tue, 21 Apr 2020 14:52:16 +0200
Message-Id: <20200421125219.8402-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421125219.8402-1-o.rempel@pengutronix.de>
References: <20200421125219.8402-1-o.rempel@pengutronix.de>
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

Document the NXP TJA11xx PHY bindings.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../devicetree/bindings/net/nxp,tja11xx.yaml  | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nxp,tja11xx.yaml

diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
new file mode 100644
index 000000000000..42be0255512b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: GPL-2.0+
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP TJA11xx PHY
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Heiner Kallweit <hkallweit1@gmail.com>
+
+description:
+  Bindings for NXP TJA11xx automotive PHYs
+
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+patternProperties:
+  "^ethernet-phy@[0-9a-f]+$":
+    type: object
+    description: |
+      Some packages have multiple PHYs. Secondary PHY should be defines as
+      subnode of the first (parent) PHY.
+
+    properties:
+      reg:
+        minimum: 0
+        maximum: 31
+        description:
+          The ID number for the child PHY. Should be +1 of parent PHY.
+
+    required:
+      - reg
+
+examples:
+  - |
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        tja1101_phy0: ethernet-phy@4 {
+            reg = <0x4>;
+        };
+    };
+  - |
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        tja1102_phy0: ethernet-phy@4 {
+            reg = <0x4>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            tja1102_phy1: ethernet-phy@5 {
+                reg = <0x5>;
+            };
+        };
+    };
-- 
2.25.1


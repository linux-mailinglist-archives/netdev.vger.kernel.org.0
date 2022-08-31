Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D6B5A7EE2
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiHaNdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiHaNdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:33:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D32D2B1F
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:33:07 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oTNpl-0004Ao-Sr; Wed, 31 Aug 2022 15:32:45 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oTNpj-0034tT-Ln; Wed, 31 Aug 2022 15:32:43 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oTNpi-00Da3z-1g; Wed, 31 Aug 2022 15:32:42 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v5 6/7] dt-bindings: net: pse-dt: add bindings for regulator based PoDL PSE controller
Date:   Wed, 31 Aug 2022 15:32:39 +0200
Message-Id: <20220831133240.3236779-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220831133240.3236779-1-o.rempel@pengutronix.de>
References: <20220831133240.3236779-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
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

Add bindings for the regulator based Ethernet PoDL PSE controller and
generic bindings for all PSE controllers.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
changes v5:
- rename to podl-pse-regulator.yaml
- remove compatible description
- remove "-1" on node name
- add pse-controller.yaml for common properties
changes v4:
- rename to PSE regulator
- drop currently unused properties
- use own compatible for PoDL PSE
changes v2:
- rename compatible to more generic "ieee802.3-pse"
- add class and type properties for PoDL and PoE variants
- add pairs property
---
 .../net/pse-pd/podl-pse-regulator.yaml        | 40 +++++++++++++++++++
 .../bindings/net/pse-pd/pse-controller.yaml   | 28 +++++++++++++
 2 files changed, 68 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
 create mode 100644 Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml

diff --git a/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml b/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
new file mode 100644
index 0000000000000..c6b1c188abf7e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/pse-pd/podl-pse-regulator.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Regulator based Power Sourcing Equipment
+
+maintainers:
+  - Oleksij Rempel <o.rempel@pengutronix.de>
+
+description: Regulator based PoDL PSE controller. The device must be referenced
+  by the PHY node to control power injection to the Ethernet cable.
+
+allOf:
+  - $ref: "pse-controller.yaml#"
+
+properties:
+  compatible:
+    const: podl-pse-regulator
+
+  '#pse-cells':
+    const: 0
+
+  pse-supply:
+    description: Power supply for the PSE controller
+
+additionalProperties: false
+
+required:
+  - compatible
+  - pse-supply
+
+examples:
+  - |
+    ethernet-pse {
+      compatible = "podl-pse-regulator";
+      pse-supply = <&reg_t1l1>;
+      #pse-cells = <0>;
+    };
diff --git a/Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml b/Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml
new file mode 100644
index 0000000000000..36e398fea220c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/pse-pd/pse-controller.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: PSE Generic Bindings
+
+maintainers:
+  - Oleksij Rempel <o.rempel@pengutronix.de>
+
+properties:
+  $nodename:
+    pattern: "^ethernet-pse(@[a-f0-9]+)?$"
+
+  "#pse-cells":
+    description:
+      Used to uniquely identify a PSE instance within an IC. Will be
+      0 on PSE nodes with only a single output and at least 1 on nodes
+      controlling several outputs.
+    enum: [0, 1]
+
+required:
+  - "#pse-cells"
+
+additionalProperties: true
+
+...
-- 
2.30.2


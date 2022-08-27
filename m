Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7355A34BF
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 07:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345421AbiH0FLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 01:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345128AbiH0FLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 01:11:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409D3DF4E8
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 22:11:04 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRo5i-00025l-SG; Sat, 27 Aug 2022 07:10:43 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRo5f-002E59-4j; Sat, 27 Aug 2022 07:10:39 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRo5e-00GNWC-8R; Sat, 27 Aug 2022 07:10:38 +0200
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
Subject: [PATCH net-next v3 1/7] dt-bindings: net: pse-dt: add bindings for generic PSE controller
Date:   Sat, 27 Aug 2022 07:10:27 +0200
Message-Id: <20220827051033.3903585-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220827051033.3903585-1-o.rempel@pengutronix.de>
References: <20220827051033.3903585-1-o.rempel@pengutronix.de>
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

Add binding for generic Ethernet PSE controller.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
changes v2:
- rename compatible to more generic "ieee802.3-pse"
- add class and type properties for PoDL and PoE variants
- add pairs property
---
 .../bindings/net/pse-pd/generic-pse.yaml      | 95 +++++++++++++++++++
 1 file changed, 95 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml

diff --git a/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml b/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml
new file mode 100644
index 0000000000000..ecd226df66f4e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml
@@ -0,0 +1,95 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/pse-pd/generic-pse.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Generic Power Sourcing Equipment
+
+maintainers:
+  - Oleksij Rempel <o.rempel@pengutronix.de>
+
+description: Generic PSE controller. The device must be referenced by the PHY
+  node to control power injection to the Ethernet cable.
+
+properties:
+  compatible:
+    const: ieee802.3-pse
+
+  '#pse-cells':
+    const: 0
+
+  ieee802.3-pse-supply:
+    description: Power supply for the PSE controller
+
+  ieee802.3-pairs:
+    $ref: /schemas/types.yaml#/definitions/int8-array
+    description: Array of number of twisted-pairs capable to deliver power.
+      Since not all circuits are able to support all pair variants, the array of
+      supported variants should be specified.
+      Note - single twisted-pair PSE is formally know as PoDL PSE.
+    items:
+      enum: [1, 2, 4]
+
+  ieee802.3-pse-type:
+    $ref: /schemas/types.yaml#/definitions/uint8
+    minimum: 1
+    maximum: 2
+    description: PSE Type. Describes classification- and class-capabilities.
+      Not compatible with PoDL PSE Type.
+      Type 1 - provides a Class 0, 1, 2, or 3 signature during Physical Layer
+      classification.
+      Type 2 - provides a Class 4 signature during Physical Layer
+      classification, understands 2-Event classification, and is capable of
+      Data Link Layer classification.
+
+  ieee802.3-pse-class:
+    $ref: /schemas/types.yaml#/definitions/int8-array
+    items:
+      enum: [0, 1, 2, 3, 4]
+    description: PSE Class. Array of supported classes by the 2 and 4 pair PSE.
+
+  ieee802.3-podl-pse-type:
+    $ref: /schemas/types.yaml#/definitions/string
+    enum: [a, b, c, d, e]
+    description: PoDL PSE Type. Describes compatibility to physical Layer
+      specifications.
+      Type A - cost optimized for 100BASE-T1
+      Type B - cost optimized for 1000BASE-T1
+      Type C - works with 100BASE-T1 and 1000BASE-T1
+      Type D - optimized for 10BASE-T1S
+      Type E - optimized for 10BASE-T1L
+
+  ieee802.3-podl-pse-class:
+    $ref: /schemas/types.yaml#/definitions/int8-array
+    items:
+      enum: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
+    description: PoDL PSE Class. Array of supported classes by the
+      single twisted-pair PoDL PSE.
+
+additionalProperties: false
+
+required:
+  - compatible
+  - '#pse-cells'
+  - ieee802.3-pse-supply
+
+examples:
+  - |
+    pse_t1l2: ethernet-pse-1 {
+      compatible = "ieee802.3-pse";
+      ieee802.3-pse-supply = <&reg_t1l1>;
+      ieee802.3-podl-pse-type = "e";
+      ieee802.3-podl-pse-class = /bits/ 8 <0 1>;
+      ieee802.3-pairs = /bits/ 8 <1>;
+      #pse-cells = <0>;
+    };
+  - |
+    pse_poe: ethernet-pse-2 {
+      compatible = "ieee802.3-pse";
+      ieee802.3-pse-supply = <&reg_poe>;
+      ieee802.3-pairs = /bits/ 8 <2 4>;
+      ieee802.3-pse-type = /bits/ 8 <1>;
+      ieee802.3-pse-class = /bits/ 8 <0 1>;
+      #pse-cells = <0>;
+    };
-- 
2.30.2


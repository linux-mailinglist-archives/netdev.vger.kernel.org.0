Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0D94AEBE4
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240804AbiBIIKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240697AbiBIIKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:10:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BF5C05CB81
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 00:10:34 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nHi3Y-0004o1-8t; Wed, 09 Feb 2022 09:10:28 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nHi3X-0098j6-KP; Wed, 09 Feb 2022 09:10:27 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v2 1/2] dt-bindings: net: add schema for ASIX USB Ethernet controllers
Date:   Wed,  9 Feb 2022 09:10:24 +0100
Message-Id: <20220209081025.2178435-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209081025.2178435-1-o.rempel@pengutronix.de>
References: <20220209081025.2178435-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
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

Create initial schema for ASIX USB Ethernet controllers and import all
currently supported USB IDs form drivers/net/usb/asix_devices.c

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../devicetree/bindings/net/asix,ax88178.yaml | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88178.yaml

diff --git a/Documentation/devicetree/bindings/net/asix,ax88178.yaml b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
new file mode 100644
index 000000000000..2337a1a05bda
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
@@ -0,0 +1,68 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/asix,ax88178.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: The device tree bindings for the USB Ethernet controllers
+
+maintainers:
+  - Oleksij Rempel <o.rempel@pengutronix.de>
+
+description: |
+  Device tree properties for hard wired USB Ethernet devices.
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - usbb95,1720   # ASIX AX88172
+          - usbb95,172a   # ASIX AX88172A
+          - usbb95,1780   # ASIX AX88178
+          - usbb95,7720   # ASIX AX88772
+          - usbb95,772a   # ASIX AX88772A
+          - usbb95,772b   # ASIX AX88772B
+          - usbb95,7e2b   # ASIX AX88772B
+
+  reg: true
+  local-mac-address: true
+  mac-address: true
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    usb {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet@1 {
+            compatible = "usbdb0,a877";
+            reg = <1>;
+            local-mac-address = [00 00 00 00 00 00];
+        };
+    };
+  - |
+    usb {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        usb1@1 {
+            compatible = "usb1234,5678";
+            reg = <1>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            ethernet@1 {
+               compatible = "usbdb0,a877";
+               reg = <1>;
+            };
+        };
+    };
-- 
2.30.2


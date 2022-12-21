Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB8D652FCD
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 11:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiLUKsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 05:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiLUKsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 05:48:10 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C876394
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 02:48:10 -0800 (PST)
Received: from dude05.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::54])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1p7wds-00065f-9P; Wed, 21 Dec 2022 11:48:08 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] dt-bindings: net: Add rfkill-gpio binding
Date:   Wed, 21 Dec 2022 11:48:02 +0100
Message-Id: <20221221104803.1693874-1-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::54
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a device tree binding document for GPIO controlled rfkill switches.
The name, type, shutdown-gpios and reset-gpios properties are the same
as defined for ACPI.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 .../devicetree/bindings/net/rfkill-gpio.yaml  | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/rfkill-gpio.yaml

diff --git a/Documentation/devicetree/bindings/net/rfkill-gpio.yaml b/Documentation/devicetree/bindings/net/rfkill-gpio.yaml
new file mode 100644
index 000000000000..6e62e6c96456
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/rfkill-gpio.yaml
@@ -0,0 +1,60 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/rfkill-gpio.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: GPIO controlled rfkill switch
+
+maintainers:
+  - Johannes Berg <johannes@sipsolutions.net>
+  - Philipp Zabel <p.zabel@pengutronix.de>
+
+properties:
+  compatible:
+    const: rfkill-gpio
+
+  name:
+    $ref: /schemas/types.yaml#/definitions/string
+    description: rfkill switch name, defaults to node name
+
+  type:
+    description: rfkill radio type
+    enum:
+      - wlan
+      - bluetooth
+      - ultrawideband
+      - wimax
+      - wwan
+      - gps
+      - fm
+      - nfc
+
+  shutdown-gpios:
+    maxItems: 1
+
+  reset-gpios:
+    maxItems: 1
+
+required:
+  - compatible
+  - type
+
+oneOf:
+  - required:
+      - shutdown-gpios
+  - required:
+      - reset-gpios
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    rfkill-pcie-wlan {
+        compatible = "rfkill-gpio";
+        name = "rfkill-pcie-wlan";
+        type = "wlan";
+        shutdown-gpios = <&gpio2 25 GPIO_ACTIVE_HIGH>;
+    };
-- 
2.30.2


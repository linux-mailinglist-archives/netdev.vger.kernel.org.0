Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AC049DFC3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbiA0KtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239659AbiA0KtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:49:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D739C061751
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:49:17 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2Kz-0007km-2z; Thu, 27 Jan 2022 11:49:09 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2Kx-003lzF-Mn; Thu, 27 Jan 2022 11:49:07 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v1 3/4] dt-bindings: net: add "label" property for all usbnet Ethernet controllers
Date:   Thu, 27 Jan 2022 11:49:04 +0100
Message-Id: <20220127104905.899341-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127104905.899341-1-o.rempel@pengutronix.de>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For hard wired Ethernet controllers it is helpful to assign name related
to port description on the board. Or name, related to the special
internal function, if the USB ethernet controller attached to the CPU
port of some DSA switch.

This patch provides documentation for "label" property, reusable for all
usbnet controllers.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../devicetree/bindings/net/asix,ax88178.yaml |  4 ++-
 .../bindings/net/microchip,lan95xx.yaml       |  4 ++-
 .../devicetree/bindings/net/usbnet.yaml       | 36 +++++++++++++++++++
 3 files changed, 42 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/usbnet.yaml

diff --git a/Documentation/devicetree/bindings/net/asix,ax88178.yaml b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
index 74b6806006e3..c8ad767a2e45 100644
--- a/Documentation/devicetree/bindings/net/asix,ax88178.yaml
+++ b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
@@ -13,7 +13,7 @@ description: |
   Device tree properties for hard wired USB Ethernet devices.
 
 allOf:
-  - $ref: ethernet-controller.yaml#
+  - $ref: usbnet.yaml#
 
 properties:
   compatible:
@@ -58,6 +58,7 @@ properties:
           - usb6189,182d  # Sitecom LN-029
 
   reg: true
+  label: true
   local-mac-address: true
   mac-address: true
 
@@ -77,6 +78,7 @@ examples:
         ethernet@1 {
             compatible = "usbdb0,a877";
             reg = <1>;
+            label = "LAN0";
             local-mac-address = [00 00 00 00 00 00];
         };
     };
diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
index b185c7068a8a..259879bba3a0 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
@@ -14,7 +14,7 @@ description: |
   controller.
 
 allOf:
-  - $ref: ethernet-controller.yaml#
+  - $ref: usbnet.yaml#
 
 properties:
   compatible:
@@ -40,6 +40,7 @@ properties:
           - usb424,ec00   # SMSC9512/9514 USB Hub & Ethernet Device
 
   reg: true
+  label: true
   local-mac-address: true
   mac-address: true
 
@@ -59,6 +60,7 @@ examples:
         ethernet@1 {
             compatible = "usb424,ec00";
             reg = <1>;
+            label = "LAN0";
             local-mac-address = [00 00 00 00 00 00];
         };
     };
diff --git a/Documentation/devicetree/bindings/net/usbnet.yaml b/Documentation/devicetree/bindings/net/usbnet.yaml
new file mode 100644
index 000000000000..fe0848433263
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/usbnet.yaml
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/usbnet.yaml#
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
+  compatible: true
+
+  reg:
+    description: Port number
+
+  label:
+    description:
+      Describes the label associated with this port, which will become
+      the netdev name
+    $ref: /schemas/types.yaml#/definitions/string
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: true
+
+...
-- 
2.30.2


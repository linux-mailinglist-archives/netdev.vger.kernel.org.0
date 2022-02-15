Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577824B686B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbiBOKA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:00:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236226AbiBOKAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:00:51 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE66E10E077
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 02:00:41 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nJudB-0001tE-P5; Tue, 15 Feb 2022 11:00:21 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nJud9-009fw4-CS; Tue, 15 Feb 2022 11:00:19 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v4 2/8] dt-bindings: net: add schema for Microchip/SMSC LAN95xx USB Ethernet controllers
Date:   Tue, 15 Feb 2022 11:00:12 +0100
Message-Id: <20220215100018.2306046-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220215100018.2306046-1-o.rempel@pengutronix.de>
References: <20220215100018.2306046-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create initial schema for Microchip/SMSC LAN95xx USB Ethernet controllers and
import some of currently supported USB IDs form drivers/net/usb/smsc95xx.c

This devices are already used in some of DTs. So, this schema makes it official.
NOTE: there was no previously documented txt based DT binding for this
controllers.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../bindings/net/microchip,lan95xx.yaml       | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml

diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
new file mode 100644
index 000000000000..8521c65366b4
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
@@ -0,0 +1,80 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/microchip,lan95xx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: The device tree bindings for the USB Ethernet controllers
+
+maintainers:
+  - Oleksij Rempel <o.rempel@pengutronix.de>
+
+description: |
+  Device tree properties for hard wired SMSC95xx compatible USB Ethernet
+  controller.
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - usb424,9500   # SMSC9500 USB Ethernet Device
+          - usb424,9505   # SMSC9505 USB Ethernet Device
+          - usb424,9530   # SMSC LAN9530 USB Ethernet Device
+          - usb424,9730   # SMSC LAN9730 USB Ethernet Device
+          - usb424,9900   # SMSC9500 USB Ethernet Device (SAL10)
+          - usb424,9901   # SMSC9505 USB Ethernet Device (SAL10)
+          - usb424,9902   # SMSC9500A USB Ethernet Device (SAL10)
+          - usb424,9903   # SMSC9505A USB Ethernet Device (SAL10)
+          - usb424,9904   # SMSC9512/9514 USB Hub & Ethernet Device (SAL10)
+          - usb424,9905   # SMSC9500A USB Ethernet Device (HAL)
+          - usb424,9906   # SMSC9505A USB Ethernet Device (HAL)
+          - usb424,9907   # SMSC9500 USB Ethernet Device (Alternate ID)
+          - usb424,9908   # SMSC9500A USB Ethernet Device (Alternate ID)
+          - usb424,9909   # SMSC9512/9514 USB Hub & Ethernet Devic.  ID)
+          - usb424,9e00   # SMSC9500A USB Ethernet Device
+          - usb424,9e01   # SMSC9505A USB Ethernet Device
+          - usb424,9e08   # SMSC LAN89530 USB Ethernet Device
+          - usb424,ec00   # SMSC9512/9514 USB Hub & Ethernet Device
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
+            compatible = "usb424,ec00";
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
+            compatible = "usb424,9514";
+            reg = <1>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            ethernet@1 {
+               compatible = "usb424,ec00";
+               reg = <1>;
+            };
+        };
+    };
-- 
2.30.2


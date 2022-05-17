Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3100852A02C
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344963AbiEQLPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiEQLPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:15:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E542BB39
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 04:15:18 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nqvAT-0004KB-05; Tue, 17 May 2022 13:15:09 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nqvAR-002rTd-QL; Tue, 17 May 2022 13:15:06 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nqvAP-003tsk-Mi; Tue, 17 May 2022 13:15:05 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v6 2/3] dt-bindings: net: add schema for Microchip/SMSC LAN95xx USB Ethernet controllers
Date:   Tue, 17 May 2022 13:15:04 +0200
Message-Id: <20220517111505.929722-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220517111505.929722-1-o.rempel@pengutronix.de>
References: <20220517111505.929722-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
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

These devices are already used in some of DTs. So, this schema makes it official.
NOTE: there was no previously documented txt based DT binding for this
controllers.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../bindings/net/microchip,lan95xx.yaml       | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml

diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
new file mode 100644
index 000000000000..cf91fecd8909
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
@@ -0,0 +1,63 @@
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
+            compatible = "usb424,9e00";
+            reg = <1>;
+            local-mac-address = [00 00 00 00 00 00];
+        };
+    };
-- 
2.30.2


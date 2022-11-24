Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE14637757
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiKXLQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiKXLQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:16:26 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223A26F827;
        Thu, 24 Nov 2022 03:16:15 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7F04F1C001B;
        Thu, 24 Nov 2022 11:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669288573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HV9/wEcExWLHQQPoN4mFGB5lnbuV27WEICfLca/Ccg0=;
        b=dRef3dKVQm1MjPwdeKlmDsIQg65JK/ItXzI8EhvXIW1WoZcnr2hHPmVN2E5zGsQaEW7cHe
        OxtGw2q/VyZ0g4sP9IjLnIPizb6/rYqEl/SCzbm5EjybyUq5hgM0G43Cx/QlXohSKoiIlo
        jX+WH4NEAV5KZBZ6YcJtOhL/SBz8wgdhcgTorCUB43YltD8YXTtahbFQreaeQd3LzxXmUi
        3fpR8M/bDW0K+ydZAKhmdrDtmanmq/s9R0dqEhOg1PQq/DDDN4mM8vpvLXtpIAmFQmhAHY
        5a8+NHfap3GfF6IAkqJ68mx2nbNSe9/xJxFQUA6T7Ksf6P2XtM+W82qUeYI0XA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Marcin Wojtas <mw@semihalf.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v2 4/7] dt-bindings: net: marvell,prestera: Describe PCI devices of the prestera family
Date:   Thu, 24 Nov 2022 12:15:53 +0100
Message-Id: <20221124111556.264647-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124111556.264647-1-miquel.raynal@bootlin.com>
References: <20221124111556.264647-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though the devices have very little in common beside the name and
the main "switch" feature, Marvell Prestera switch family is also
composed of PCI-only devices which can receive additional static
properties, like nvmem cells to point at MAC addresses, for
instance. Let's describe them.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/marvell,prestera.yaml        | 62 ++++++++++++++++---
 1 file changed, 54 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.yaml b/Documentation/devicetree/bindings/net/marvell,prestera.yaml
index b0a3ecca406e..5ea8b73663a5 100644
--- a/Documentation/devicetree/bindings/net/marvell,prestera.yaml
+++ b/Documentation/devicetree/bindings/net/marvell,prestera.yaml
@@ -4,19 +4,24 @@
 $id: http://devicetree.org/schemas/net/marvell,prestera.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Marvell Prestera AlleyCat3 switch
+title: Marvell Prestera switch family
 
 maintainers:
   - Miquel Raynal <miquel.raynal@bootlin.com>
 
 properties:
   compatible:
-    items:
+    oneOf:
+      - items:
+          - enum:
+              - marvell,prestera-98dx3236
+              - marvell,prestera-98dx3336
+              - marvell,prestera-98dx4251
+          - const: marvell,prestera
       - enum:
-          - marvell,prestera-98dx3236
-          - marvell,prestera-98dx3336
-          - marvell,prestera-98dx4251
-      - const: marvell,prestera
+          - pci11ab,c804
+          - pci11ab,c80c
+          - pci11ab,cc1e
 
   reg:
     maxItems: 1
@@ -28,12 +33,37 @@ properties:
     description: Reference to the DFX Server bus node.
     $ref: /schemas/types.yaml#/definitions/phandle
 
+  nvmem-cells: true
+
+  nvmem-cell-names: true
+
+if:
+  properties:
+    compatible:
+      contains:
+        const: marvell,prestera
+
+# Memory mapped AlleyCat3 family
+then:
+  properties:
+    nvmem-cells: false
+    nvmem-cell-names: false
+  required:
+    - interrupts
+
+# PCI Aldrin family
+else:
+  properties:
+    interrupts: false
+    dfx: false
+
 required:
   - compatible
   - reg
-  - interrupts
 
-additionalProperties: false
+# Ports can also be described
+additionalProperties:
+  type: object
 
 examples:
   - |
@@ -43,3 +73,19 @@ examples:
         interrupts = <33>, <34>, <35>;
         dfx = <&dfx>;
     };
+
+  - |
+    pcie@0 {
+        #address-cells = <3>;
+        #size-cells = <2>;
+        ranges = <0x0 0x0 0x0 0x0 0x0 0x0>;
+        reg = <0x0 0x0 0x0 0x0 0x0 0x0>;
+        device_type = "pci";
+
+        switch@0,0 {
+            reg = <0x0 0x0 0x0 0x0 0x0>;
+            compatible = "pci11ab,c80c";
+            nvmem-cells = <&mac_address 0>;
+            nvmem-cell-names = "mac-address";
+        };
+    };
-- 
2.34.1


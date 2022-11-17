Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FCD62E766
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241024AbiKQV4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240967AbiKQV4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:56:10 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B14C701AF;
        Thu, 17 Nov 2022 13:56:09 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 83D961C0006;
        Thu, 17 Nov 2022 21:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1668722168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yawSIzf80y+QPuk3p4CbTozUsBVN5TQDmNLqiNFv4Ko=;
        b=ojAzpIa8PSRxBGZ/3V/HQ+oOPwwBAw/DEbRDE8Zlcpuu6QRGjD9oQU2H93x5tSWQC57mUM
        1EtWUHraeLj7DFAX8Nf5WgCDgo8w1jzn23sAJsqhddDa8Ip5eTGREIWVcUnY8lH7+ER6Pm
        zpQY/J7ZRimd1jLZVUwh0kJJpmkCH25IPYbEHcZLIw2YY3hF2SeKM2jMvBJyiEKhOg/Ex0
        47ug83K9aCpCnxNncx7+67ln06UGin0Hc/kaRdlAYHu26GyRZ1pxHmGPCXQzf3tHtob2GK
        yVAJ1QRzJQU9+APnkHyc9BJWJr0dKklb6vy2hOlFTd74IbYuRyQxMf+k6erdZQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Taras Chornyi <tchornyi@marvell.com>,
        <linux-kernel@vger.kernel.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4/6] dt-bindings: net: marvell,prestera: Describe PCI devices of the prestera family
Date:   Thu, 17 Nov 2022 22:55:55 +0100
Message-Id: <20221117215557.1277033-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
References: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
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
---
 .../bindings/net/marvell,prestera.yaml        | 55 ++++++++++++++++---
 1 file changed, 48 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.yaml b/Documentation/devicetree/bindings/net/marvell,prestera.yaml
index b0a3ecca406e..f159fadf86ec 100644
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
@@ -28,10 +33,33 @@ properties:
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
 
 additionalProperties: false
 
@@ -43,3 +71,16 @@ examples:
         interrupts = <33>, <34>, <35>;
         dfx = <&dfx>;
     };
+
+  - |
+    pcie {
+        #address-cells = <3>;
+        #size-cells = <2>;
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


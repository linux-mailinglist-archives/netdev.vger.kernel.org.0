Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4314669D17D
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 17:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjBTQl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 11:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjBTQlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 11:41:15 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DBE13D7C;
        Mon, 20 Feb 2023 08:41:11 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pU9Dy-0002bu-0c;
        Mon, 20 Feb 2023 17:41:10 +0100
Date:   Mon, 20 Feb 2023 16:41:06 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: [PATCH v9 02/12] dt-bindings: net: mediatek,net: add mt7981-eth
 binding
Message-ID: <75752d6e97bd473845c9d16f4a46ba3c4942cfd9.1676910958.git.daniel@makrotopia.org>
References: <cover.1676910958.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1676910958.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce DT bindings for the MT7981 SoC to mediatek,net.yaml.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../devicetree/bindings/net/mediatek,net.yaml | 52 +++++++++++++++++--
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
index 7ef696204c5a7..925ab2982d54b 100644
--- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
@@ -21,6 +21,7 @@ properties:
       - mediatek,mt7623-eth
       - mediatek,mt7622-eth
       - mediatek,mt7629-eth
+      - mediatek,mt7981-eth
       - mediatek,mt7986-eth
       - ralink,rt5350-eth
 
@@ -78,6 +79,11 @@ properties:
     description:
       List of phandles to wireless ethernet dispatch nodes.
 
+  mediatek,wed-pcie:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the mediatek wed-pcie controller.
+
   dma-coherent: true
 
   mdio-bus:
@@ -123,6 +129,8 @@ allOf:
 
         mediatek,wed: false
 
+        mediatek,wed-pci: false
+
   - if:
       properties:
         compatible:
@@ -206,6 +214,45 @@ allOf:
 
         mediatek,wed: false
 
+        mediatek,wed-pci: false
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mediatek,mt7981-eth
+    then:
+      properties:
+        interrupts:
+          minItems: 4
+
+        clocks:
+          minItems: 15
+          maxItems: 15
+
+        clock-names:
+          items:
+            - const: fe
+            - const: gp2
+            - const: gp1
+            - const: wocpu0
+            - const: sgmii_ck
+            - const: sgmii_tx250m
+            - const: sgmii_rx250m
+            - const: sgmii_cdr_ref
+            - const: sgmii_cdr_fb
+            - const: sgmii2_tx250m
+            - const: sgmii2_rx250m
+            - const: sgmii2_cdr_ref
+            - const: sgmii2_cdr_fb
+            - const: netsys0
+            - const: netsys1
+
+        mediatek,sgmiisys:
+          minItems: 2
+          maxItems: 2
+
+
   - if:
       properties:
         compatible:
@@ -242,11 +289,6 @@ allOf:
           minItems: 2
           maxItems: 2
 
-        mediatek,wed-pcie:
-          $ref: /schemas/types.yaml#/definitions/phandle
-          description:
-            Phandle to the mediatek wed-pcie controller.
-
 patternProperties:
   "^mac@[0-1]$":
     type: object
-- 
2.39.2


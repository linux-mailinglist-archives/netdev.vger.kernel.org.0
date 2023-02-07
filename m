Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE37568DA74
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbjBGOVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbjBGOVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:21:09 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE5B3BD8B;
        Tue,  7 Feb 2023 06:20:53 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pPOq3-00027e-1t;
        Tue, 07 Feb 2023 15:20:51 +0100
Date:   Tue, 7 Feb 2023 14:19:15 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
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
Subject: [PATCH v2 02/11] dt-bindings: net: mediatek,net: add mt7981-eth
 binding
Message-ID: <a48462893e76fc04dbb814b5ec6e79222ff90a78.1675779094.git.daniel@makrotopia.org>
References: <cover.1675779094.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675779094.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce DT bindings for the MT7981 SoC to mediatek,net.yaml.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../devicetree/bindings/net/mediatek,net.yaml | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
index 7ef696204c5a..d17e2eb46118 100644
--- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
@@ -21,6 +21,7 @@ properties:
       - mediatek,mt7623-eth
       - mediatek,mt7622-eth
       - mediatek,mt7629-eth
+      - mediatek,mt7981-eth
       - mediatek,mt7986-eth
       - ralink,rt5350-eth
 
@@ -206,6 +207,47 @@ allOf:
 
         mediatek,wed: false
 
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
+        mediatek,wed-pcie:
+          $ref: /schemas/types.yaml#/definitions/phandle
+          description:
+            Phandle to the mediatek wed-pcie controller.
+
   - if:
       properties:
         compatible:
-- 
2.39.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CAA693241
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 17:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjBKQE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 11:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjBKQE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 11:04:57 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1C62B0B6;
        Sat, 11 Feb 2023 08:04:34 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pQsMY-0004LV-1h;
        Sat, 11 Feb 2023 17:04:31 +0100
Date:   Sat, 11 Feb 2023 16:02:55 +0000
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
Subject: [PATCH v5 04/12] dt-bindings: arm: mediatek: sgmiisys: add MT7981 SoC
Message-ID: <7273678366079b93ee19c4c6f6ea9bc13cd8dcfb.1676128246.git.daniel@makrotopia.org>
References: <cover.1676128246.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1676128246.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mediatek,pnswap boolean property as well as an example for the
MediaTek MT7981 SoC making use of that new property.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../arm/mediatek/mediatek,sgmiisys.yaml       | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
index 99ceb08ad7c0..97d4ab70e541 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
@@ -23,6 +23,8 @@ properties:
           - enum:
               - mediatek,mt7622-sgmiisys
               - mediatek,mt7629-sgmiisys
+              - mediatek,mt7981-sgmiisys_0
+              - mediatek,mt7981-sgmiisys_1
               - mediatek,mt7986-sgmiisys_0
               - mediatek,mt7986-sgmiisys_1
           - const: syscon
@@ -33,6 +35,10 @@ properties:
   '#clock-cells':
     const: 1
 
+  mediatek,pnswap:
+    description: Invert polarity of the SGMII data lanes
+    type: boolean
+
 required:
   - compatible
   - reg
@@ -51,3 +57,19 @@ examples:
         #clock-cells = <1>;
       };
     };
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+      sgmiisys0: syscon@10060000 {
+        compatible = "mediatek,mt7981-sgmiisys_0", "syscon";
+        reg = <0 0x10060000 0 0x1000>;
+        mediatek,pnswap;
+        #clock-cells = <1>;
+      };
+      sgmiisys1: syscon@10070000 {
+        compatible = "mediatek,mt7981-sgmiisys_1", "syscon";
+        reg = <0 0x10070000 0 0x1000>;
+        #clock-cells = <1>;
+      };
+    };
-- 
2.39.1


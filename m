Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B88E5BBE11
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 15:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiIRNm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 09:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiIRNmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 09:42:23 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8F81A82D;
        Sun, 18 Sep 2022 06:42:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663508502; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=OItcQHojLQt8Xpk2H4OgBvas5Hmz21To2oy5fjVvrnkzlN3eiGBl5paxagC+Y0DWL/9/e1WK/R/XiMuFB4THFu6CvEqnny+xyLXsrVo/D0Ckq/qRGDKhXjXLeGyKsgThZ0qiUZYBQGTgBlyBH4TAH+1kssD52SVmui526gsA8Bg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663508502; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=mv8wnCQI8K+FkvB2ZahCjYMMUvp+WpG/VEtG06Ocnio=; 
        b=FpQdu0FgeDMcw3wK0DZrLL8gSF4hPghgUdr2rGQS3ekXvVbRHMllHMuZwwoMRj8h437T9ZUnQ450stVZ6MHC4t+82+5TxVTgImpnDBGqqjzlkNgMQ91tGdZIk5PrPOV0dVky76nBLpQo0QfbdV4GJp/Z2DUeuVaK3fvKql0vtC4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663508502;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=mv8wnCQI8K+FkvB2ZahCjYMMUvp+WpG/VEtG06Ocnio=;
        b=Z/lZ7EVWbrFILGt5R6plaSvE+fsP6gxGgxfCo0dxnwh00EdMfCHKKRZ+gISGjot+
        3uINCWoixO6lM/l7BhoyAUYWLoGQTM3alwZa3Jz7uGOZwVVDiYJixKWFq5NHyyaUOuz
        HCsCv3tLDNy3l0U9vNywkKCgM8tT9jp+kZJQWyhY=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 166350850131962.28244589605106; Sun, 18 Sep 2022 06:41:41 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Sungbo Eo <mans0n@gorani.run>, Rob Herring <robh@kernel.org>
Subject: [PATCH v3 net-next 02/10] dt-bindings: net: dsa: mediatek,mt7530: change mt7530 switch address
Date:   Sun, 18 Sep 2022 16:41:10 +0300
Message-Id: <20220918134118.554813-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220918134118.554813-1-arinc.unal@arinc9.com>
References: <20220918134118.554813-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of muxing phy0 of the MT7530 switch, the switch and the phy
will have the same address on the mdio bus, 0. This causes the ethernet
driver to fail since devices on the mdio bus cannot share an address.

Any address can be used for the switch, therefore, change the switch
address to 0x1f.

Suggested-by: Sungbo Eo <mans0n@gorani.run>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index f9e7b6e20b35..2c73d13adf14 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -294,9 +294,9 @@ examples:
         #address-cells = <1>;
         #size-cells = <0>;
 
-        switch@0 {
+        switch@1f {
             compatible = "mediatek,mt7530";
-            reg = <0>;
+            reg = <0x1f>;
 
             reset-gpios = <&pio 33 0>;
 
@@ -356,9 +356,9 @@ examples:
         #address-cells = <1>;
         #size-cells = <0>;
 
-        switch@0 {
+        switch@1f {
             compatible = "mediatek,mt7530";
-            reg = <0>;
+            reg = <0x1f>;
 
             mediatek,mcm;
             resets = <&ethsys MT2701_ETHSYS_MCM_RST>;
@@ -486,9 +486,9 @@ examples:
         #address-cells = <1>;
         #size-cells = <0>;
 
-        switch@0 {
+        switch@1f {
             compatible = "mediatek,mt7621";
-            reg = <0>;
+            reg = <0x1f>;
 
             mediatek,mcm;
             resets = <&sysc MT7621_RST_MCM>;
@@ -573,9 +573,9 @@ examples:
                 reg = <4>;
             };
 
-            switch@0 {
+            switch@1f {
                 compatible = "mediatek,mt7621";
-                reg = <0>;
+                reg = <0x1f>;
 
                 mediatek,mcm;
                 resets = <&sysc MT7621_RST_MCM>;
@@ -664,9 +664,9 @@ examples:
                 phy-mode = "rgmii";
             };
 
-            switch@0 {
+            switch@1f {
                 compatible = "mediatek,mt7621";
-                reg = <0>;
+                reg = <0x1f>;
 
                 mediatek,mcm;
                 resets = <&sysc MT7621_RST_MCM>;
@@ -745,9 +745,9 @@ examples:
                 phy-mode = "rgmii";
             };
 
-            switch@0 {
+            switch@1f {
                 compatible = "mediatek,mt7621";
-                reg = <0>;
+                reg = <0x1f>;
 
                 mediatek,mcm;
                 resets = <&sysc MT7621_RST_MCM>;
-- 
2.34.1


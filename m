Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D953059F817
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 12:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbiHXKog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 06:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236911AbiHXKo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 06:44:26 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C85582F92;
        Wed, 24 Aug 2022 03:44:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661337835; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=nGBayXmFjxXQke5t4+LXhpw908kxXlrbaI77yke/xdxLf8u0Aq66+/yHxuQsPYN3XKQ6NIuobFEKD/jMOHzoeXqTqQJAfWL8tWu3d1VkAemAbn0x88IV3DA9h05fiEFuV6LggzQGNxtCXeDKYWvyZ638doYDvhqb7HkcLcmfjTU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1661337835; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=vgkEJPRHfhmBzG1fz6Px6SFuhmQW5PscDfkr1hfPyIg=; 
        b=AM4gARZTqUrevflwPr49ka8L1RNRGoGGube50iFbGiHkCSnCscqI3h/TlAbgBWKs6lwZLvITPng0vQLeQj+Jf6GnTD7Fdpn1q7SiGony5Pmk8aBEC72PUn/jubEry+uqz3D9Uo6Hdwdv8OQWQH8xeeXpwHPoyYIBcRxNOwBhK4w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661337835;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=vgkEJPRHfhmBzG1fz6Px6SFuhmQW5PscDfkr1hfPyIg=;
        b=D1hEC3pLOt5nC1l8d4mkQeIM8tEhZ9V3YHaTidY7iBckJE/D3Eyaf0l+JjA7FvlN
        u0wBHjIAwuLeqiyY67q/TboeEmnsuRljN41Y8cym45Pjnm1oKLuO/yEeRS67nvNy6gY
        8Ssa8jaCBKbwHJPcw3n4F6IQXzZvi7GQG4VLrozA=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1661337833791867.3390861462567; Wed, 24 Aug 2022 03:43:53 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH v5 6/7] dt-bindings: net: dsa: mediatek,mt7530: define phy-mode for switch models
Date:   Wed, 24 Aug 2022 13:40:39 +0300
Message-Id: <20220824104040.17527-7-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220824104040.17527-1-arinc.unal@arinc9.com>
References: <20220824104040.17527-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define acceptable phy-mode values for the CPU port of mt7530 and mt7531
switches. Remove relevant information from the description of the binding.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 61 +++++++++++++++----
 1 file changed, 50 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index a6003db87113..6d7228687d36 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -49,17 +49,6 @@ description: |
   * mt7621: phy-mode = "rgmii-txid";
   * mt7623: phy-mode = "rgmii";
 
-  CPU-Ports need a phy-mode property:
-    Allowed values on mt7530 and mt7621:
-      - "rgmii"
-      - "trgmii"
-    On mt7531:
-      - "1000base-x"
-      - "2500base-x"
-      - "rgmii"
-      - "sgmii"
-
-
 properties:
   compatible:
     oneOf:
@@ -150,6 +139,30 @@ $defs:
                 label:
                   const: cpu
             then:
+              if:
+                properties:
+                  reg:
+                    const: 5
+              then:
+                properties:
+                  phy-mode:
+                    enum:
+                      - gmii
+                      - mii
+                      - rgmii
+              else:
+                properties:
+                  phy-mode:
+                    enum:
+                      - rgmii
+                      - trgmii
+
+              properties:
+                reg:
+                  enum:
+                    - 5
+                    - 6
+
               required:
                 - phy-mode
 
@@ -164,6 +177,32 @@ $defs:
                 label:
                   const: cpu
             then:
+              if:
+                properties:
+                  reg:
+                    const: 5
+              then:
+                properties:
+                  phy-mode:
+                    enum:
+                      - 1000base-x
+                      - 2500base-x
+                      - rgmii
+                      - sgmii
+              else:
+                properties:
+                  phy-mode:
+                    enum:
+                      - 1000base-x
+                      - 2500base-x
+                      - sgmii
+
+              properties:
+                reg:
+                  enum:
+                    - 5
+                    - 6
+
               required:
                 - phy-mode
 
-- 
2.34.1


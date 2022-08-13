Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9C5591BA8
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 17:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239996AbiHMPqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 11:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239913AbiHMPpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 11:45:49 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15406326C5;
        Sat, 13 Aug 2022 08:45:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660405509; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=D1Zfk5JkXA6KE5KzpCAb9VVLrjlrX6Lntp8gKyxlnkaRGVy9/8q+uJsXmEUnX9F6cK3dfp0IuTK/ZJORL0EkgLbvOyY/mlNDhXrgnEv2p1DV2sm40VB6Lmcq43w6USRkO2artg2dqfgkogf1G4x5Q1y5+E2wMRjHyFvLbAwCAYw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660405509; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=jsLNwKu69dMoowXkaVBPR2TlA1Lu17rBjhIrh9GsaeU=; 
        b=fmr2aK5GjjT3eU7K9tiVKKzGbnjRZsbbAtm2KLqS+UQzfPJsHvTewBpbGHfumXsEJ5CFY1rMtyWFvn5TxMKSI0dG5GGDGa/m8hIdJX5DyPnw0tGjxvs/cEvQkEr4q8uU+XLOancp4b+SeewL+8ZKoj3xGX0q41dXL0Av5CtRjk0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660405509;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=jsLNwKu69dMoowXkaVBPR2TlA1Lu17rBjhIrh9GsaeU=;
        b=SRMEhb/h5L6+dlrsVv6DPRaXYXEM4U0TpzWSqh1iM7yNYEOxqTdPNi9iIiIdKA5G
        XhYQvb6Iw/1/Ex2zWzDsdmtzEhGKLutHpzGpvhvzFsONThLpqdAarrZzrvbIyDik+nq
        k7Tj1gcIv9U7R+eTT6l8P9gInbL+OcaBE89kMMtg=
Received: from arinc9-PC.lan (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1660405507469429.1380002259672; Sat, 13 Aug 2022 08:45:07 -0700 (PDT)
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
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH v2 5/7] dt-bindings: net: dsa: mediatek,mt7530: remove unnecesary lines
Date:   Sat, 13 Aug 2022 18:44:13 +0300
Message-Id: <20220813154415.349091-6-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220813154415.349091-1-arinc.unal@arinc9.com>
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary lines as they are already included from the referred
dsa.yaml.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 27 -------------------
 1 file changed, 27 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index ff51a2f6875f..a27cb4fa490f 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -162,15 +162,8 @@ allOf:
 
       patternProperties:
         "^(ethernet-)?ports$":
-          type: object
-
           patternProperties:
             "^(ethernet-)?port@[0-9]+$":
-              type: object
-              description: Ethernet switch ports
-
-              unevaluatedProperties: false
-
               properties:
                 reg:
                   description:
@@ -178,7 +171,6 @@ allOf:
                     0 to 5 for user ports.
 
               allOf:
-                - $ref: dsa-port.yaml#
                 - if:
                     properties:
                       label:
@@ -186,7 +178,6 @@ allOf:
                           - const: cpu
                   then:
                     required:
-                      - reg
                       - phy-mode
 
   - if:
@@ -200,15 +191,8 @@ allOf:
 
       patternProperties:
         "^(ethernet-)?ports$":
-          type: object
-
           patternProperties:
             "^(ethernet-)?port@[0-9]+$":
-              type: object
-              description: Ethernet switch ports
-
-              unevaluatedProperties: false
-
               properties:
                 reg:
                   description:
@@ -216,7 +200,6 @@ allOf:
                     0 to 5 for user ports.
 
               allOf:
-                - $ref: dsa-port.yaml#
                 - if:
                     properties:
                       label:
@@ -224,7 +207,6 @@ allOf:
                           - const: cpu
                   then:
                     required:
-                      - reg
                       - phy-mode
 
   - if:
@@ -238,15 +220,8 @@ allOf:
 
       patternProperties:
         "^(ethernet-)?ports$":
-          type: object
-
           patternProperties:
             "^(ethernet-)?port@[0-9]+$":
-              type: object
-              description: Ethernet switch ports
-
-              unevaluatedProperties: false
-
               properties:
                 reg:
                   description:
@@ -254,7 +229,6 @@ allOf:
                     0 to 5 for user ports.
 
               allOf:
-                - $ref: dsa-port.yaml#
                 - if:
                     properties:
                       label:
@@ -262,7 +236,6 @@ allOf:
                           - const: cpu
                   then:
                     required:
-                      - reg
                       - phy-mode
 
 unevaluatedProperties: false
-- 
2.34.1


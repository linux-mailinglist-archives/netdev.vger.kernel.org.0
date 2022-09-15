Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CC55B94D9
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiIOG5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiIOG45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:56:57 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DE280EA0;
        Wed, 14 Sep 2022 23:56:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663224982; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=R24zklqrI9qIqxk3259K6ZKoTBYLv5VUriWjfbj650S0zuD1nevO4jD144ZZQIO5nickNvvcShcsxjc5Wb4oah4SU3353GFzvSZvaLnC5enQZXQYIDBuGSgONCgTnak6TLx4JzHzotbiPZfoQLFnSOVaNsZP5JwcSV13QP1Ad68=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663224982; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=08pH7piTGTvh/ZeXP1Swxz+oCzEd8UkwdY3/1IA2wBY=; 
        b=k/5mYhqkjlHVaLB7S88jbmeY6ThLdTkUfv/NO5xbg4UUrZPlxASz8pEJ7ZVvG5Nxgu45NK4MNfN+/lcZ4sAtqOGGtHNUYl5iZSaNQyR1oVCch75/mdny36edeFsIJHCXECsmBs1WS61Ui24CUtECkVYMtYTyfFcuIBGmoM3cTtg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663224982;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=08pH7piTGTvh/ZeXP1Swxz+oCzEd8UkwdY3/1IA2wBY=;
        b=dC3xBg86CXJrIBN8TVnijgnUioa+94YiC/h1Tvg1cx6l6uOLJSjhHCbdvsIarbo0
        SdJTMoqTcppaXrMuAzI5Y791TAPdThaC/xokX/2E07osJpYN+gqpPEZj0fgsHHq8ALr
        ZuQZbOciurjQIKyeZ1Y20fdOe//zftAd6NlBrRXI=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 16632249800711018.5785289818914; Wed, 14 Sep 2022 23:56:20 -0700 (PDT)
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
        Rob Herring <robh@kernel.org>
Subject: [PATCH v2 net-next 03/10] dt-bindings: net: dsa: mediatek,mt7530: expand gpio-controller description
Date:   Thu, 15 Sep 2022 09:55:35 +0300
Message-Id: <20220915065542.13150-4-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220915065542.13150-1-arinc.unal@arinc9.com>
References: <20220915065542.13150-1-arinc.unal@arinc9.com>
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

Expand the description of the gpio-controller property to include the
controllable pins of the MT7530 switch.

The gpio-controller property is only used for the MT7530 switch. Therefore,
invalidate it for the MT7531 switch.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml   | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 2c73d13adf14..3ec4fffec780 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -104,7 +104,14 @@ properties:
   gpio-controller:
     type: boolean
     description:
-      If defined, MT7530's LED controller will run on GPIO mode.
+      If defined, LED controller of the MT7530 switch will run on GPIO mode.
+
+      There are 15 controllable pins.
+      port 0 LED 0..2 as GPIO 0..2
+      port 1 LED 0..2 as GPIO 3..5
+      port 2 LED 0..2 as GPIO 6..8
+      port 3 LED 0..2 as GPIO 9..11
+      port 4 LED 0..2 as GPIO 12..14
 
   "#interrupt-cells":
     const: 1
@@ -272,6 +279,7 @@ allOf:
     then:
       $ref: "#/$defs/mt7531-dsa-port"
       properties:
+        gpio-controller: false
         mediatek,mcm: false
 
   - if:
-- 
2.34.1


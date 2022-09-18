Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966FC5BBE0B
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 15:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiIRNmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 09:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIRNmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 09:42:10 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817311A05D;
        Sun, 18 Sep 2022 06:42:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663508508; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=VNFOYKWX+MAMRMNdzgDrKx77bE/I/O9IerSAcDbwIEtHWGaxGCBYIRII8e42dKUAE/3iQfUVPIaKBEe8+OkWuaV0zYf9KKulcfe+o4py1Yddz+UwFFodGEAcm+EdngcJOcP20PuGgE9cFgFLgbuVgDVidmIQq6oLMD9ys1Wekjc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663508508; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=08pH7piTGTvh/ZeXP1Swxz+oCzEd8UkwdY3/1IA2wBY=; 
        b=kw4QhSMI5LvrA4cW1o+4rdGR6PQ6kyL2QUCU2ZdYgSR84ZVanBnjWwxdNnt9AxNCJ5vYYzIPXiggd2vqs2kFZ8K7ZQCxfQjC+nAOToU4RhGBPP1Apz3+I/1sfSOA1PfuXrTR41LDej5HOHfJGecuecwVx6FTymPVXU/B0uGkTEk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663508508;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=08pH7piTGTvh/ZeXP1Swxz+oCzEd8UkwdY3/1IA2wBY=;
        b=bJwJ9pZgGKJ2soleOcTp3Pb4A2Yc9ruWTQHVVczJjVx4FRTqUSgglQ4TXr8YqDcm
        PI9sMDR0Kq4k05d1/rOh0osy0YpVDB0dfhoKTqeRDEbROq3GDGY0nNl0DXaxpsm8DpI
        MAruco12d/4SkZYNIsL1tetCx+Rue6Hkwoun8h1k=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663508507395778.7535002580399; Sun, 18 Sep 2022 06:41:47 -0700 (PDT)
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
Subject: [PATCH v3 net-next 03/10] dt-bindings: net: dsa: mediatek,mt7530: expand gpio-controller description
Date:   Sun, 18 Sep 2022 16:41:11 +0300
Message-Id: <20220918134118.554813-4-arinc.unal@arinc9.com>
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


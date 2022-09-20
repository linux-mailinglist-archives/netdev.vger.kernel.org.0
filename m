Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC595BEBE2
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiITR1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiITR1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:27:18 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1C55AC41;
        Tue, 20 Sep 2022 10:27:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663694810; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Vf4SWT654FdYobDvJdXk5Qbm/45ar0C8Ef6qbNZzX8An7in+9Gs1SbmlDfxCq63lgY5Gx/Z+UkOJe2FZ+dHa6Fgb0YYaYv3kyORMgyROjMhrILA4eiuyL7BKht5V64BAUddWo5mNAuNgjpgNw3ZPWM3EEFZMMTM21sFYEqE37eo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663694810; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=q2aHD/2EQ0E3NOJZmAmLUmUUrpAWHblOhyutE0P5unM=; 
        b=YhUNPcWi8hNKxBIlyxgHkOfXjh8EeC+FTV+tG13wj2UNK6ohCpNzM+3Rmk9Mb7TqSWfNKIR7mDvxApUiw38Bdn5g97M3NZiii46uxILHBwMphK2EqjJ2M7YFgnn6g2EECS5+/j3r1FlnrRFW/Urljbj7yvCuL58e1dM4aE1yf1E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663694810;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=q2aHD/2EQ0E3NOJZmAmLUmUUrpAWHblOhyutE0P5unM=;
        b=EiaQkh4dX2Q7XjYLdtQcB/Irw5Ut8+4ukyCjOfZjfwQJqi/lr22tQfeQ7Fu9EQ3M
        Qu1whWvYaV9+LyB5FSoru0CKypyK0OBfcKZGYK2KpdKVB+MK8f3/89uUGtTBuHfeNzF
        3YyLZNSebvjUxuarSZ9NHnq8WzY/3GUjUUfRZK4s=
Received: from arinc9-Xeront.fusolab.local (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663694806491670.9202934830495; Tue, 20 Sep 2022 10:26:46 -0700 (PDT)
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
Subject: [PATCH v4 net-next 03/10] dt-bindings: net: dsa: mediatek,mt7530: expand gpio-controller description
Date:   Tue, 20 Sep 2022 20:25:49 +0300
Message-Id: <20220920172556.16557-4-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920172556.16557-1-arinc.unal@arinc9.com>
References: <20220920172556.16557-1-arinc.unal@arinc9.com>
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
index 138ee6bff267..f2e9ff3f580b 100644
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
@@ -263,6 +270,7 @@ allOf:
     then:
       $ref: "#/$defs/mt7531-dsa-port"
       properties:
+        gpio-controller: false
         mediatek,mcm: false
 
   - if:
-- 
2.34.1


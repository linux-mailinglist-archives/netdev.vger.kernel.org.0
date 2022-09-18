Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9CC15BBE10
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 15:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiIRNmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 09:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiIRNmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 09:42:17 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6E01A398;
        Sun, 18 Sep 2022 06:42:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663508514; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=S1qAyiqCwwGXSXSaum2foeUyBtDGDSP6pgA0t5noF79kSnhl/lmGngF72rFn90F3lN+zVir7kHfxNzCiYKBL1FDiyro3KtOW36MEUY5FJ0zzD3vn1ffdrXPDUxAxXo3/0q/JTgZwy3/03D4kTe8gPNXAXHZazI3UIKFFDZyAJw8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663508514; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=QOwUQUGXzXW7a2cfxQ09efax8bzqXaZd89GFxaHq3Yo=; 
        b=fkPnYbKyc3pHI+tKoFCQd1zRoEO3frde32u0NbrU/Dr+t6jUBIqIkIwUGN/7MF43eYuGwD8hlYQ8eBHzWJma/6NnIVlMr9xoEwxIyXcoFHL2l4zwTCFY7QJC/M4FLrzSVB2tVxwoJS0kmCmGTur0vx3ZHSk4GYRYoacNcTwH0Oc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663508514;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=QOwUQUGXzXW7a2cfxQ09efax8bzqXaZd89GFxaHq3Yo=;
        b=XZskVF4Jmr/dR96L5mac1dJRQIGQGMg3pfnfMOKRs71CoFYrmoH7AsSVlQJH/a/5
        KUTFhFOyprMER/LJvT6uYLBs+4N7hAeDwy1ZzUuvms46xHUP9bLwKg6QqLuCnHCcLEP
        OxBu5HYttglL5R106jmLgC6K0ErccISSrzy9lzCc=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663508513207144.86270917599222; Sun, 18 Sep 2022 06:41:53 -0700 (PDT)
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
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH v3 net-next 04/10] dt-bindings: memory: mt7621: add syscon as compatible string
Date:   Sun, 18 Sep 2022 16:41:12 +0300
Message-Id: <20220918134118.554813-5-arinc.unal@arinc9.com>
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

The syscon string was introduced because the mt7621 clock driver needs to
read some registers creating a regmap from the syscon. The bindings were
added before the clock driver was properly mainlined and at first the clock
driver was using ralink architecture dependent operations rt_memc_* defined
in 'arch/mips/include/asm/mach-ralink/ralink_regs.h'.

This string is already there on the memory controller node on mt7621.dtsi.

Add syscon as a constant string on the compatible property, now that memc
became a syscon. Update the example accordingly.

Fixes: 5278e4a181ff ("dt-bindings: memory: add binding for Mediatek's MT7621 SDRAM memory controller")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
---
 .../bindings/memory-controllers/mediatek,mt7621-memc.yaml | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml b/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml
index 85e02854f083..ba8cd6d81d08 100644
--- a/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml
@@ -11,7 +11,9 @@ maintainers:
 
 properties:
   compatible:
-    const: mediatek,mt7621-memc
+    items:
+      - const: mediatek,mt7621-memc
+      - const: syscon
 
   reg:
     maxItems: 1
@@ -24,7 +26,7 @@ additionalProperties: false
 
 examples:
   - |
-    memory-controller@5000 {
-        compatible = "mediatek,mt7621-memc";
+    syscon@5000 {
+        compatible = "mediatek,mt7621-memc", "syscon";
         reg = <0x5000 0x1000>;
     };
-- 
2.34.1


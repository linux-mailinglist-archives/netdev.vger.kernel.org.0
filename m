Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB245B94E4
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiIOG53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIOG5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:57:00 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6047B292;
        Wed, 14 Sep 2022 23:56:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663224988; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=DtkLVanyqdqnMijdcJ8E8I+HH26K+7kPnzMjhzUt9BgtGLE+7vvxo2MqXLjtly+TtwJk6j2BRSG9Pez7mX2ctKDQSIXNhrBBFGruf+L1V/WkGZYR+Yk+dg/qZkClIEsoc+5eiRXHkoaCKotaAZbd8DoVx3B8yvWrTO8zx4g4YeA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663224988; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=uxq9y3bsFrsASdnzwwwd9DFyyq4MC9dAYxIHLkGs7pw=; 
        b=lto9vRj1jqIxv5q2LfGU8F6FD448a8B9TRgER/47a7KMwCga4fx8kiilDj+y1j3Xy3jpieGPD5dqLM3hlKr+rgpTyf5gFyTzeZAAvao/yFEF04U+aAW7FbWNH7Lo6f8Y3yFAmNx86HIrxApgITnzFHNAOMUIXHyiSsqmfznpvdI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663224988;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=uxq9y3bsFrsASdnzwwwd9DFyyq4MC9dAYxIHLkGs7pw=;
        b=LzA02yfItoiCAOQbFbdQKT0Gc3NzlVR5uGf+TpnWu2KorA8b10yITZWPCdwHsoAz
        VIegVrRkuCfWMDF/0SePWLb2jPtq1DofPadzRga3ORM4uzTzglr28+dGR2DNh/E0/zl
        R+mUBC0imljpNEqn9T2mqHBhfdI04KVnWGQA98Jo=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663224985900288.02172322388776; Wed, 14 Sep 2022 23:56:25 -0700 (PDT)
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
Subject: [PATCH v2 net-next 04/10] dt-bindings: memory: mt7621: add syscon as compatible string
Date:   Thu, 15 Sep 2022 09:55:36 +0300
Message-Id: <20220915065542.13150-5-arinc.unal@arinc9.com>
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

Add syscon as a constant string on the compatible property as it's required
for the SoC to work. Update the example accordingly.

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


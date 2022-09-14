Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DDF5B835F
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 10:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiINIz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 04:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiINIzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 04:55:52 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC09A6C75B;
        Wed, 14 Sep 2022 01:55:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663145726; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ICKDQjUAhOLFVv/HjDOGzmAJz6nF18Dq9PkHoQt4pYdWNPez4NLWFh88k5jwCziRBSRdsCwZLvBnAL1ba/w/b4dxtYZxgPxUD2DkN72aZcjr835MlqGmR7lvXxpI4Ilvt1cm6bzpqsB949WMcBn/PLq0XLGwrp6P4HuwOJ5CiVg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663145726; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=OKLAhyPIS7u1j1ZgI5worLlV8YgMFCXUQ3FS/Nhbktk=; 
        b=X3Z9AKHQasC8oyW2Otbfa5qt27yEtJO0gz4lT/uOUHipUFG59BdIg3PuzUwDbvmhGmAnyX2CwuaOCbrqXimmlR1SChO7VkHcGptDX2SD+uZuBQxt2/jdhnpfRqYqvNp7TvQBn+O0J/vLbQmky0kP+jp+eql/AwtFk8BRupJRumU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663145726;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=OKLAhyPIS7u1j1ZgI5worLlV8YgMFCXUQ3FS/Nhbktk=;
        b=QgbkSiplZPCP5/i+0PAkspRCysqPKZ/m76m0QSaJE6NKg9expeaAspAGyp45rwX+
        2foXHjCVmkXjsRVZezz6xN3Sn4SCILHrL6zjjACJPhOtea88jjf3RH0aVIEFt6t1Teh
        UBGgCG4R29+ZKBBd9VklQd144DIWYMT+0Q4WB/fE=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 16631457251941006.247763449766; Wed, 14 Sep 2022 01:55:25 -0700 (PDT)
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
Subject: [PATCH 04/10] dt-bindings: memory: mt7621: add syscon as compatible string
Date:   Wed, 14 Sep 2022 11:54:45 +0300
Message-Id: <20220914085451.11723-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914085451.11723-1-arinc.unal@arinc9.com>
References: <20220914085451.11723-1-arinc.unal@arinc9.com>
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
---
 .../bindings/memory-controllers/mediatek,mt7621-memc.yaml   | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml b/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml
index 85e02854f083..6ccdaf99c778 100644
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
@@ -25,6 +27,6 @@ additionalProperties: false
 examples:
   - |
     memory-controller@5000 {
-        compatible = "mediatek,mt7621-memc";
+        compatible = "mediatek,mt7621-memc", "syscon";
         reg = <0x5000 0x1000>;
     };
-- 
2.34.1


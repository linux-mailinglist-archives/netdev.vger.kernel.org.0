Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537EF5BBE2B
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 15:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiIRNoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 09:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiIRNnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 09:43:39 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318301D0D3;
        Sun, 18 Sep 2022 06:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663508538; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=nGcW+J7cUl4Npm7YylRYVaY3x4tmLfXLCiDmXgrD+BTVs7jiUqFCMLu4KOk1qAcvcIhL11nHer5DxIHmSGsGPtELImuHWBKfGUYV7JbmblLKYMXltIS46CVmRTefzmkRCNMbqEFjo8Z9gn/Nu+pGWcnO958DjGyNldx2AzDCbfg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663508538; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Sk44jnot7uocJ4arpLBcXWdU4CoMjGzCainAQsmuR8w=; 
        b=DYez03mXmCqDDj/u6CGPeakJaFNwIuXUGabjpp8k8q5xpGFWiFRvs+FN/1EH/gJKdfeOT81v77yHoszmRdgayhBic+CL6v3KrPmArmJplNlPQ1kvBWVEKQdBkAJyf4OC87uw7CLJh6yGxifYU4CrYan9ayY1bkoEz1HWObDXJc0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663508538;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=Sk44jnot7uocJ4arpLBcXWdU4CoMjGzCainAQsmuR8w=;
        b=EEP8sUuGCCt0h+GgcCvIr7ye+zABBtJ5LF9oJzskblPhpAIM6rYbbo+S6J4mbWAG
        Y3qgQq86EjPZZ0gjzMGBKvlPTv5m4E1DJrIcaCNY6MA79hM4NPYqojCUTofKXgwgUgs
        SvYWeyUQjT1xX19++IQ33AcufY9mK7YE23bQUsK8=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663508536708451.20108562227756; Sun, 18 Sep 2022 06:42:16 -0700 (PDT)
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
        Sungbo Eo <mans0n@gorani.run>
Subject: [PATCH v3 net-next 08/10] mips: dts: ralink: mt7621: change mt7530 switch address
Date:   Sun, 18 Sep 2022 16:41:16 +0300
Message-Id: <20220918134118.554813-9-arinc.unal@arinc9.com>
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
Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
---
 arch/mips/boot/dts/ralink/mt7621.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/boot/dts/ralink/mt7621.dtsi b/arch/mips/boot/dts/ralink/mt7621.dtsi
index 3d4a8e4bd4f8..7900760212c9 100644
--- a/arch/mips/boot/dts/ralink/mt7621.dtsi
+++ b/arch/mips/boot/dts/ralink/mt7621.dtsi
@@ -340,9 +340,9 @@ mdio: mdio-bus {
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			switch0: switch@0 {
+			switch0: switch@1f {
 				compatible = "mediatek,mt7621";
-				reg = <0>;
+				reg = <0x1f>;
 				mediatek,mcm;
 				resets = <&sysc MT7621_RST_MCM>;
 				reset-names = "mcm";
-- 
2.34.1


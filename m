Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0FA5B94F8
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiIOG6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiIOG6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:58:04 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8C97B1FD;
        Wed, 14 Sep 2022 23:57:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663225010; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ehPnzbvvznPAATqgIdoYPe9uBLvUR+z7YQFXY3VJXxe5YjgULocelK8YbsbR9H7aQkF1JK7ZC2doS6oB6v9rVQR3Qg/xidtUh4rmTJa/k0xdlKL6oNzH/2eiTnszVwyggVGc1v/z619I1uji3Nx9E0+6mrecKVxnKwyMmPfPp8I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663225010; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Sk44jnot7uocJ4arpLBcXWdU4CoMjGzCainAQsmuR8w=; 
        b=gNWC6R9qgN+Rbfhzrx/y76P7jgPqypybPsUzKQuLw70QY1XB0PQRRc0ncWO5ysJQv84q82S3mqu/BzbqLwyjHIHiWyO0FzQjzO2jOh+yhQ3JrVMVqaJEDzjMYtb3bKMwC7o8NRqF95RCyTyEbDyVxSW3cjHcjN3g1V46rIwAVbI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663225010;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=Sk44jnot7uocJ4arpLBcXWdU4CoMjGzCainAQsmuR8w=;
        b=AbTuLrbc/qnVwI2zMprNbk+fyhKlwKdG1IMs8l98deHvgWKTjiQLPZv8Yrwzt/t9
        QQtzQmICz8d4HSCVqnhvJ48ouXAODqFTN8XpqpU6ZqGV8lhPbx5JJFEwr2xEPka0G8o
        pNS0agLgxYXVgll+lKmXfMx/9iNM1WO46qkORpgU=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663225009736593.0930673821944; Wed, 14 Sep 2022 23:56:49 -0700 (PDT)
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
Subject: [PATCH v2 net-next 08/10] mips: dts: ralink: mt7621: change mt7530 switch address
Date:   Thu, 15 Sep 2022 09:55:40 +0300
Message-Id: <20220915065542.13150-9-arinc.unal@arinc9.com>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BAE5B94F9
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiIOG6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiIOG6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:58:04 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC34F7FE5C;
        Wed, 14 Sep 2022 23:57:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663225023; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=CNs2AW5H4dDTvLgtu1vUQG1bb73GF6bE+bOEQBsMVWZRL2WoCXmnDTSPc6YZxGHlVIwsOpbIX8ZFtltmgUFfgPgTbriFQ5rY97Xv+IEixeni9CI1OiBt+qKmHMb0UqSc01XZRJFFtkt9HOq3HyG04f86Xzs3h59A86tGE6iCPtg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663225023; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8AjFH1BLUb+TXyGp2qTPrkMzOdVeStVDjagqGC2aBMo=; 
        b=KFrs9OqcYngQLSqvrsxRho9ER6yge/e+FxIpzdncakgKvKAuEzT43yZGB5c3EerFB/1XsdrVHioxv5U80dt1VJTmOGQS7xns0aVACyt7QtW8VGQ1odSpptTs3LJE06513v8eQsM2BTmYHIqcyEv0Y1qy+Wx6lq4U9He/GytkoOc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663225023;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=8AjFH1BLUb+TXyGp2qTPrkMzOdVeStVDjagqGC2aBMo=;
        b=HULaQFufMOYqyloyhleYocI3EGw4XMQ7STyt3LItSPi30fSCSpnREeuMEau+syLa
        RMhVxHt93VwCjyjbXtssfvuoR7eg91xvX9+Woqbu+TVt/J/gJumrqyeO9FIF1K5GNWB
        bJRl3VZXIJ6tcham161/6QUDVygYtVC941e/+H40=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663225021653925.7003964608373; Wed, 14 Sep 2022 23:57:01 -0700 (PDT)
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
        Petr Louda <petr.louda@outlook.cz>
Subject: [PATCH v2 net-next 10/10] mips: dts: ralink: mt7621: add GB-PC2 LEDs
Date:   Thu, 15 Sep 2022 09:55:42 +0300
Message-Id: <20220915065542.13150-11-arinc.unal@arinc9.com>
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

Add the missing LEDs for GB-PC2. The ethblack-green, ethblue-green, power
and system LEDs weren't added previously, because they don't exist on the
device schematics. Tests on a GB-PC2 by me and Petr proved otherwise.

The i2c bus cannot be used on GB-PC2 as its pins are wired to LEDs instead,
and GB-PC1 does not use it. Therefore, do not enable it on both devices.

Link: https://github.com/ngiger/GnuBee_Docs/blob/master/GB-PCx/Documents/GB-PC2_V1.1_schematic.pdf
Tested-by: Petr Louda <petr.louda@outlook.cz>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
---
 .../boot/dts/ralink/mt7621-gnubee-gb-pc1.dts  |  6 ---
 .../boot/dts/ralink/mt7621-gnubee-gb-pc2.dts  | 42 ++++++++++++++++---
 2 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
index 6ecb8165efe8..0128bd8fa7ed 100644
--- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
+++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
@@ -20,12 +20,6 @@ chosen {
 		bootargs = "console=ttyS0,57600";
 	};
 
-	palmbus: palmbus@1e000000 {
-		i2c@900 {
-			status = "okay";
-		};
-	};
-
 	gpio-keys {
 		compatible = "gpio-keys";
 
diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
index 5f52193a4c37..7515555388ae 100644
--- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
+++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
@@ -20,12 +20,6 @@ chosen {
 		bootargs = "console=ttyS0,57600";
 	};
 
-	palmbus: palmbus@1e000000 {
-		i2c@900 {
-			status = "okay";
-		};
-	};
-
 	gpio-keys {
 		compatible = "gpio-keys";
 
@@ -35,6 +29,42 @@ key-reset {
 			linux,code = <KEY_RESTART>;
 		};
 	};
+
+	gpio-leds {
+		compatible = "gpio-leds";
+
+		ethblack-green {
+			label = "green:ethblack";
+			gpios = <&gpio 3 GPIO_ACTIVE_LOW>;
+		};
+
+		ethblue-green {
+			label = "green:ethblue";
+			gpios = <&gpio 4 GPIO_ACTIVE_LOW>;
+		};
+
+		ethyellow-green {
+			label = "green:ethyellow";
+			gpios = <&gpio 15 GPIO_ACTIVE_LOW>;
+		};
+
+		ethyellow-orange {
+			label = "orange:ethyellow";
+			gpios = <&gpio 13 GPIO_ACTIVE_LOW>;
+		};
+
+		power {
+			label = "green:power";
+			gpios = <&gpio 6 GPIO_ACTIVE_LOW>;
+			linux,default-trigger = "default-on";
+		};
+
+		system {
+			label = "green:system";
+			gpios = <&gpio 8 GPIO_ACTIVE_LOW>;
+			linux,default-trigger = "disk-activity";
+		};
+	};
 };
 
 &mmc {
-- 
2.34.1


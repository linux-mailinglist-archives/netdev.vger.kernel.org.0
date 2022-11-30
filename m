Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A27263D7E2
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiK3OOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiK3OOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:14:07 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091343205A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:14:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1669817537; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=lpWTA9IYY2ZfSZaCqUUWebw/3azHlDmFX05c2uu/LZR9rloJgzF+3xDqKKkaHGNlQZYl8/ZjSM1CflY9G6/8Fn5907Arkwl0i0Lq2JJaiI2gby/z03Eyx5JpX9JwtPZFT+PHiS5E+4hCKjWXUucZYZG1hqmsKrufAdGILPOk7P0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1669817537; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=5T2hFCnKbsJUfnztAU4x1LWotILvCAGDUjNXts9SDRs=; 
        b=H8BdQNQKaUwQGaLshU9DAVShtFqnlaxdgM3PXwmyyKKQ2NY6cz451gN+OXcWfS/d3fRDoZKwgfpECYNhPHaP87f2JfSXaLp6W5fsOwDN8YFQYRmrdfIkspzNWmwMnbvUnhwdv2pRl4RhV4G5K7urVTz/EXsL7iM0L+TEaKDinys=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1669817536;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=5T2hFCnKbsJUfnztAU4x1LWotILvCAGDUjNXts9SDRs=;
        b=VIIMOpcJVUfPaf9v0FoefDG1mLup6O8o86mQ4RpAAAcGZ7dr1OdAu7/D/GarV9vH
        EzqgfFXnByix2V11jYWJPqpC34RaF1SEekDLPMJpiEKRNa6g6e9HZjdRYglzyl3QyO5
        7OXlMN+G4J6YkMHJjIEZoIjVMia9JrcMvtUzm4bw=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1669817534805446.0276977419554; Wed, 30 Nov 2022 06:12:14 -0800 (PST)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        soc@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Stefan Agner <stefan@agner.ch>,
        Heiko Stuebner <heiko@sntech.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Tim Harvey <tharvey@gateworks.com>,
        Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Frank Wunderlich <frank-w@public-files.de>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@lists.linux.dev, linux-rockchip@lists.infradead.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/5] arm: dts: remove label = "cpu" from DSA dt-binding
Date:   Wed, 30 Nov 2022 17:10:37 +0300
Message-Id: <20221130141040.32447-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221130141040.32447-1-arinc.unal@arinc9.com>
References: <20221130141040.32447-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not used by the DSA dt-binding, so remove it from all devicetrees.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 arch/arm/boot/dts/armada-370-rd.dts                       | 1 -
 arch/arm/boot/dts/armada-381-netgear-gs110emx.dts         | 1 -
 arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts          | 1 -
 arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts          | 1 -
 arch/arm/boot/dts/armada-385-linksys.dtsi                 | 1 -
 arch/arm/boot/dts/armada-385-turris-omnia.dts             | 1 -
 arch/arm/boot/dts/armada-388-clearfog.dts                 | 1 -
 arch/arm/boot/dts/armada-xp-linksys-mamba.dts             | 1 -
 arch/arm/boot/dts/at91-sama5d2_icp.dts                    | 1 -
 arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts            | 1 -
 arch/arm/boot/dts/bcm-cygnus.dtsi                         | 1 -
 arch/arm/boot/dts/bcm4708-buffalo-wzr-1166dhp-common.dtsi | 1 -
 arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts              | 1 -
 arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts              | 1 -
 arch/arm/boot/dts/bcm4708-netgear-r6250.dts               | 1 -
 arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts             | 1 -
 arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts        | 1 -
 arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts             | 1 -
 arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts             | 1 -
 arch/arm/boot/dts/bcm4709-netgear-r8000.dts               | 1 -
 arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dts              | 3 ---
 arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts             | 1 -
 arch/arm/boot/dts/bcm47094-linksys-panamera.dts           | 4 ----
 arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts             | 1 -
 arch/arm/boot/dts/bcm47094-luxul-xap-1610.dts             | 1 -
 arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts             | 1 -
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts             | 1 -
 arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts             | 1 -
 arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts          | 1 -
 arch/arm/boot/dts/bcm47189-tenda-ac9.dts                  | 1 -
 arch/arm/boot/dts/bcm53015-meraki-mr26.dts                | 1 -
 arch/arm/boot/dts/bcm53016-meraki-mr32.dts                | 1 -
 arch/arm/boot/dts/bcm953012er.dts                         | 1 -
 arch/arm/boot/dts/bcm958622hr.dts                         | 1 -
 arch/arm/boot/dts/bcm958623hr.dts                         | 1 -
 arch/arm/boot/dts/bcm958625hr.dts                         | 1 -
 arch/arm/boot/dts/bcm958625k.dts                          | 1 -
 arch/arm/boot/dts/bcm988312hr.dts                         | 1 -
 arch/arm/boot/dts/gemini-dlink-dir-685.dts                | 1 -
 arch/arm/boot/dts/gemini-sl93512r.dts                     | 1 -
 arch/arm/boot/dts/gemini-sq201.dts                        | 1 -
 arch/arm/boot/dts/imx51-zii-rdu1.dts                      | 1 -
 arch/arm/boot/dts/imx51-zii-scu2-mezz.dts                 | 1 -
 arch/arm/boot/dts/imx51-zii-scu3-esb.dts                  | 1 -
 arch/arm/boot/dts/imx53-kp-hsc.dts                        | 1 -
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi                | 1 -
 arch/arm/boot/dts/imx6q-b450v3.dts                        | 1 -
 arch/arm/boot/dts/imx6q-b650v3.dts                        | 1 -
 arch/arm/boot/dts/imx6q-b850v3.dts                        | 1 -
 arch/arm/boot/dts/imx6qdl-gw5904.dtsi                     | 1 -
 arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi                   | 1 -
 arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi                   | 1 -
 arch/arm/boot/dts/imx6qp-prtwd3.dts                       | 1 -
 arch/arm/boot/dts/imx7d-zii-rpu2.dts                      | 1 -
 arch/arm/boot/dts/kirkwood-dir665.dts                     | 1 -
 arch/arm/boot/dts/kirkwood-l-50.dts                       | 1 -
 arch/arm/boot/dts/kirkwood-linksys-viper.dts              | 1 -
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts            | 1 -
 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi                 | 1 -
 arch/arm/boot/dts/mt7623a-rfb-emmc.dts                    | 1 -
 arch/arm/boot/dts/mt7623a-rfb-nand.dts                    | 1 -
 arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts             | 1 -
 arch/arm/boot/dts/mt7623n-rfb-emmc.dts                    | 1 -
 arch/arm/boot/dts/orion5x-netgear-wnr854t.dts             | 1 -
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts                 | 2 --
 arch/arm/boot/dts/r9a06g032.dtsi                          | 1 -
 arch/arm/boot/dts/stm32mp151a-prtt1c.dts                  | 1 -
 arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts                 | 1 -
 arch/arm/boot/dts/vf610-zii-cfu1.dts                      | 1 -
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts                 | 1 -
 arch/arm/boot/dts/vf610-zii-dev-rev-c.dts                 | 1 -
 arch/arm/boot/dts/vf610-zii-scu4-aib.dts                  | 1 -
 arch/arm/boot/dts/vf610-zii-spb4.dts                      | 1 -
 arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts                  | 1 -
 arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts                 | 1 -
 75 files changed, 81 deletions(-)

diff --git a/arch/arm/boot/dts/armada-370-rd.dts b/arch/arm/boot/dts/armada-370-rd.dts
index be005c9f42ef..469f18b7f08c 100644
--- a/arch/arm/boot/dts/armada-370-rd.dts
+++ b/arch/arm/boot/dts/armada-370-rd.dts
@@ -171,7 +171,6 @@ port@3 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&eth1>;
 				fixed-link {
 					speed = <1000>;
diff --git a/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts b/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
index 095df5567c93..dd183dec9e3b 100644
--- a/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
+++ b/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
@@ -148,7 +148,6 @@ ports {
 
 			port@0 {
 				ethernet = <&eth0>;
-				label = "cpu";
 				reg = <0>;
 
 				fixed-link {
diff --git a/arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts b/arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts
index c9ac630e5874..a2749e2815d1 100644
--- a/arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts
+++ b/arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts
@@ -68,7 +68,6 @@ port@8 {
 
 			port@10 {
 				reg = <10>;
-				label = "cpu";
 				ethernet = <&eth1>;
 			};
 
diff --git a/arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts b/arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts
index fa653b379490..a792fe334b0f 100644
--- a/arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts
+++ b/arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts
@@ -48,7 +48,6 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&eth1>;
 			};
 
diff --git a/arch/arm/boot/dts/armada-385-linksys.dtsi b/arch/arm/boot/dts/armada-385-linksys.dtsi
index 116aca5e688f..207f25df9b8d 100644
--- a/arch/arm/boot/dts/armada-385-linksys.dtsi
+++ b/arch/arm/boot/dts/armada-385-linksys.dtsi
@@ -195,7 +195,6 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&eth2>;
 
 				fixed-link {
diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
index 72ac807cae25..eb1fdf3494ac 100644
--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -473,7 +473,6 @@ ports@4 {
 
 			ports@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&eth1>;
 				phy-mode = "rgmii-id";
 
diff --git a/arch/arm/boot/dts/armada-388-clearfog.dts b/arch/arm/boot/dts/armada-388-clearfog.dts
index 95299167dcf5..36b9a9cc4589 100644
--- a/arch/arm/boot/dts/armada-388-clearfog.dts
+++ b/arch/arm/boot/dts/armada-388-clearfog.dts
@@ -129,7 +129,6 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&eth1>;
 				fixed-link {
 					speed = <1000>;
diff --git a/arch/arm/boot/dts/armada-xp-linksys-mamba.dts b/arch/arm/boot/dts/armada-xp-linksys-mamba.dts
index 622ac40dd164..08724bc17a13 100644
--- a/arch/arm/boot/dts/armada-xp-linksys-mamba.dts
+++ b/arch/arm/boot/dts/armada-xp-linksys-mamba.dts
@@ -302,7 +302,6 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&eth0>;
 				fixed-link {
 					speed = <1000>;
diff --git a/arch/arm/boot/dts/at91-sama5d2_icp.dts b/arch/arm/boot/dts/at91-sama5d2_icp.dts
index dd1dec9d4e07..e8de8b202e21 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -137,7 +137,6 @@ port@1 {
 
 				port@2 {
 					reg = <2>;
-					label = "cpu";
 					ethernet = <&macb0>;
 					phy-mode = "mii";
 					fixed-link {
diff --git a/arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts b/arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts
index 14af1fd6d247..038ceb8ce4ba 100644
--- a/arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts
@@ -149,7 +149,6 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&macb0>;
 				phy-mode = "rgmii-txid";
 
diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
index f9f79ed82518..e05cad244cf8 100644
--- a/arch/arm/boot/dts/bcm-cygnus.dtsi
+++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
@@ -210,7 +210,6 @@ port@1 {
 
 				port@8 {
 					reg = <8>;
-					label = "cpu";
 					ethernet = <&eth0>;
 					fixed-link {
 						speed = <1000>;
diff --git a/arch/arm/boot/dts/bcm4708-buffalo-wzr-1166dhp-common.dtsi b/arch/arm/boot/dts/bcm4708-buffalo-wzr-1166dhp-common.dtsi
index a658b9b7bcec..01e0d01a5298 100644
--- a/arch/arm/boot/dts/bcm4708-buffalo-wzr-1166dhp-common.dtsi
+++ b/arch/arm/boot/dts/bcm4708-buffalo-wzr-1166dhp-common.dtsi
@@ -185,7 +185,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts b/arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts
index 14ee410183af..87292d048664 100644
--- a/arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts
+++ b/arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts
@@ -73,7 +73,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts b/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
index 600ab087f5e5..c067d809e2a8 100644
--- a/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
+++ b/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
@@ -75,7 +75,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm4708-netgear-r6250.dts b/arch/arm/boot/dts/bcm4708-netgear-r6250.dts
index fd6d8d2a4456..c53e57a6c3c4 100644
--- a/arch/arm/boot/dts/bcm4708-netgear-r6250.dts
+++ b/arch/arm/boot/dts/bcm4708-netgear-r6250.dts
@@ -126,7 +126,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts b/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
index 6bcdfb73cb9e..4f229ffb0b1a 100644
--- a/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
+++ b/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
@@ -149,7 +149,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts b/arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
index 0edc2543e568..c4982edf7fd9 100644
--- a/arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
+++ b/arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
@@ -149,7 +149,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts b/arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts
index c8c02377543b..ba9b79c0bef8 100644
--- a/arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts
+++ b/arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts
@@ -68,7 +68,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts b/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
index 3b35a7af4b1c..e29767cebf24 100644
--- a/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
+++ b/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
@@ -141,7 +141,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm4709-netgear-r8000.dts b/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
index 087f7f60de18..324304ef67ae 100644
--- a/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
+++ b/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
@@ -217,7 +217,6 @@ port@4 {
 
 		port@8 {
 			reg = <8>;
-			label = "cpu";
 			ethernet = <&gmac2>;
 
 			fixed-link {
diff --git a/arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dts b/arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dts
index a5fec56d11c0..3fb7ed0e342e 100644
--- a/arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dts
+++ b/arch/arm/boot/dts/bcm47094-asus-rt-ac88u.dts
@@ -136,7 +136,6 @@ port@3 {
 
 			port@6 {
 				reg = <6>;
-				label = "cpu";
 				ethernet = <&sw0_p5>;
 				phy-mode = "rgmii";
 				tx-internal-delay-ps = <2000>;
@@ -220,7 +219,6 @@ fixed-link {
 		port@7 {
 			reg = <7>;
 			ethernet = <&gmac1>;
-			label = "cpu";
 
 			fixed-link {
 				speed = <1000>;
@@ -231,7 +229,6 @@ fixed-link {
 		port@8 {
 			reg = <8>;
 			ethernet = <&gmac2>;
-			label = "cpu";
 
 			fixed-link {
 				speed = <1000>;
diff --git a/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts b/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts
index 2c38b642a8b8..2c819564beba 100644
--- a/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts
+++ b/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts
@@ -150,7 +150,6 @@ port@4 {
 
 		port@8 {
 			reg = <8>;
-			label = "cpu";
 			ethernet = <&gmac2>;
 
 			fixed-link {
diff --git a/arch/arm/boot/dts/bcm47094-linksys-panamera.dts b/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
index 86c7cc0fa70e..1cd1942f5d63 100644
--- a/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
+++ b/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
@@ -180,7 +180,6 @@ port@4 {
 					sw1_p8: port@8 {
 						reg = <8>;
 						ethernet = <&sw0_p0>;
-						label = "cpu";
 
 						fixed-link {
 							speed = <1000>;
@@ -230,7 +229,6 @@ port@4 {
 		port@5 {
 			reg = <5>;
 			ethernet = <&gmac0>;
-			label = "cpu";
 			status = "disabled";
 
 			fixed-link {
@@ -242,7 +240,6 @@ fixed-link {
 		port@7 {
 			reg = <7>;
 			ethernet = <&gmac1>;
-			label = "cpu";
 			status = "disabled";
 
 			fixed-link {
@@ -254,7 +251,6 @@ fixed-link {
 		port@8 {
 			reg = <8>;
 			ethernet = <&gmac2>;
-			label = "cpu";
 
 			fixed-link {
 				speed = <1000>;
diff --git a/arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts b/arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts
index 9ad15bcae1ca..b2d7f43e9a75 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts
@@ -100,7 +100,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xap-1610.dts b/arch/arm/boot/dts/bcm47094-luxul-xap-1610.dts
index ee24d3768536..b14d9259c314 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xap-1610.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xap-1610.dts
@@ -71,7 +71,6 @@ port@1 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts b/arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts
index 6549d07b9887..526221f0980f 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts
@@ -100,7 +100,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts b/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
index 654fcce9fded..dbec4ae9a650 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
@@ -62,7 +62,6 @@ port@0 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts b/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts
index bf053a2fcc7c..c074891400a5 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts
@@ -140,7 +140,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts b/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts
index 78a90dd57a4e..5c3b12b42b0b 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts
@@ -123,7 +123,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm47189-tenda-ac9.dts b/arch/arm/boot/dts/bcm47189-tenda-ac9.dts
index 55b92645b0f1..96273fe213d8 100644
--- a/arch/arm/boot/dts/bcm47189-tenda-ac9.dts
+++ b/arch/arm/boot/dts/bcm47189-tenda-ac9.dts
@@ -137,7 +137,6 @@ port@4 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm53015-meraki-mr26.dts b/arch/arm/boot/dts/bcm53015-meraki-mr26.dts
index 14f58033efeb..00c2f6402ea3 100644
--- a/arch/arm/boot/dts/bcm53015-meraki-mr26.dts
+++ b/arch/arm/boot/dts/bcm53015-meraki-mr26.dts
@@ -123,7 +123,6 @@ port@0 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 
 			fixed-link {
diff --git a/arch/arm/boot/dts/bcm53016-meraki-mr32.dts b/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
index e678bc03d816..0c525a669fe0 100644
--- a/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
+++ b/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
@@ -182,7 +182,6 @@ port@0 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 
 			fixed-link {
diff --git a/arch/arm/boot/dts/bcm953012er.dts b/arch/arm/boot/dts/bcm953012er.dts
index 4fe3b3653376..3d80e16c0361 100644
--- a/arch/arm/boot/dts/bcm953012er.dts
+++ b/arch/arm/boot/dts/bcm953012er.dts
@@ -81,7 +81,6 @@ port@1 {
 
 		port@5 {
 			reg = <5>;
-			label = "cpu";
 			ethernet = <&gmac0>;
 		};
 	};
diff --git a/arch/arm/boot/dts/bcm958622hr.dts b/arch/arm/boot/dts/bcm958622hr.dts
index 9db3c851451a..9c0a9c3ba2dd 100644
--- a/arch/arm/boot/dts/bcm958622hr.dts
+++ b/arch/arm/boot/dts/bcm958622hr.dts
@@ -204,7 +204,6 @@ port@4 {
 
 		port@8 {
 			ethernet = <&amac2>;
-			label = "cpu";
 			reg = <8>;
 			fixed-link {
 				speed = <1000>;
diff --git a/arch/arm/boot/dts/bcm958623hr.dts b/arch/arm/boot/dts/bcm958623hr.dts
index 32786e7c4e12..1af7d3025eff 100644
--- a/arch/arm/boot/dts/bcm958623hr.dts
+++ b/arch/arm/boot/dts/bcm958623hr.dts
@@ -208,7 +208,6 @@ port@4 {
 
 		port@8 {
 			ethernet = <&amac2>;
-			label = "cpu";
 			reg = <8>;
 			fixed-link {
 				speed = <1000>;
diff --git a/arch/arm/boot/dts/bcm958625hr.dts b/arch/arm/boot/dts/bcm958625hr.dts
index 74263d98de73..a267a9bf775e 100644
--- a/arch/arm/boot/dts/bcm958625hr.dts
+++ b/arch/arm/boot/dts/bcm958625hr.dts
@@ -231,7 +231,6 @@ port@5 {
 
 		port@8 {
 			ethernet = <&amac2>;
-			label = "cpu";
 			reg = <8>;
 			fixed-link {
 				speed = <1000>;
diff --git a/arch/arm/boot/dts/bcm958625k.dts b/arch/arm/boot/dts/bcm958625k.dts
index 69ebc7a913a7..97bd2e98eacc 100644
--- a/arch/arm/boot/dts/bcm958625k.dts
+++ b/arch/arm/boot/dts/bcm958625k.dts
@@ -244,7 +244,6 @@ port@4 {
 
 		port@8 {
 			ethernet = <&amac2>;
-			label = "cpu";
 			reg = <8>;
 			fixed-link {
 				speed = <1000>;
diff --git a/arch/arm/boot/dts/bcm988312hr.dts b/arch/arm/boot/dts/bcm988312hr.dts
index e96bc3f2d5cf..f6ea175b3201 100644
--- a/arch/arm/boot/dts/bcm988312hr.dts
+++ b/arch/arm/boot/dts/bcm988312hr.dts
@@ -216,7 +216,6 @@ port@4 {
 
 		port@8 {
 			ethernet = <&amac2>;
-			label = "cpu";
 			reg = <8>;
 			fixed-link {
 				speed = <1000>;
diff --git a/arch/arm/boot/dts/gemini-dlink-dir-685.dts b/arch/arm/boot/dts/gemini-dlink-dir-685.dts
index 396149664297..c8446fedf213 100644
--- a/arch/arm/boot/dts/gemini-dlink-dir-685.dts
+++ b/arch/arm/boot/dts/gemini-dlink-dir-685.dts
@@ -235,7 +235,6 @@ port@4 {
 			};
 			rtl8366rb_cpu_port: port@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&gmac0>;
 				phy-mode = "rgmii";
 				fixed-link {
diff --git a/arch/arm/boot/dts/gemini-sl93512r.dts b/arch/arm/boot/dts/gemini-sl93512r.dts
index 91c19e8ebfe8..c295bfc64948 100644
--- a/arch/arm/boot/dts/gemini-sl93512r.dts
+++ b/arch/arm/boot/dts/gemini-sl93512r.dts
@@ -123,7 +123,6 @@ port@3 {
 				};
 				vsc: port@6 {
 					reg = <6>;
-					label = "cpu";
 					ethernet = <&gmac1>;
 					phy-mode = "rgmii";
 					fixed-link {
diff --git a/arch/arm/boot/dts/gemini-sq201.dts b/arch/arm/boot/dts/gemini-sq201.dts
index d0efd76695da..7b15ae959767 100644
--- a/arch/arm/boot/dts/gemini-sq201.dts
+++ b/arch/arm/boot/dts/gemini-sq201.dts
@@ -108,7 +108,6 @@ port@3 {
 				};
 				vsc: port@6 {
 					reg = <6>;
-					label = "cpu";
 					ethernet = <&gmac1>;
 					phy-mode = "rgmii";
 					fixed-link {
diff --git a/arch/arm/boot/dts/imx51-zii-rdu1.dts b/arch/arm/boot/dts/imx51-zii-rdu1.dts
index 3140f038aa98..223641f678fe 100644
--- a/arch/arm/boot/dts/imx51-zii-rdu1.dts
+++ b/arch/arm/boot/dts/imx51-zii-rdu1.dts
@@ -181,7 +181,6 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
 					ethernet = <&fec>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts b/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
index aa91e5dde4b8..4adf421a5a14 100644
--- a/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
+++ b/arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
@@ -82,7 +82,6 @@ port@3 {
 
 				port@4 {
 					reg = <4>;
-					label = "cpu";
 					ethernet = <&fec>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/imx51-zii-scu3-esb.dts b/arch/arm/boot/dts/imx51-zii-scu3-esb.dts
index 875b10a7d674..11634a92b278 100644
--- a/arch/arm/boot/dts/imx51-zii-scu3-esb.dts
+++ b/arch/arm/boot/dts/imx51-zii-scu3-esb.dts
@@ -267,7 +267,6 @@ fixed-link {
 
 				port@6 {
 					reg = <6>;
-					label = "cpu";
 					phy-mode = "mii";
 					ethernet = <&fec>;
 
diff --git a/arch/arm/boot/dts/imx53-kp-hsc.dts b/arch/arm/boot/dts/imx53-kp-hsc.dts
index 6e3d71baac0f..0009e4bfbcc3 100644
--- a/arch/arm/boot/dts/imx53-kp-hsc.dts
+++ b/arch/arm/boot/dts/imx53-kp-hsc.dts
@@ -34,7 +34,6 @@ ports {
 
 			port@0 { /* RMII fixed link to master */
 				reg = <0>;
-				label = "cpu";
 				ethernet = <&fec>;
 			};
 
diff --git a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
index 52162e8c7274..d13ab193f055 100644
--- a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
+++ b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
@@ -138,7 +138,6 @@ switch_ports: ports {
 
 				ethphy0: port@0 {
 					reg = <0>;
-					label = "cpu";
 					phy-mode = "rgmii-id";
 					ethernet = <&fec>;
 
diff --git a/arch/arm/boot/dts/imx6q-b450v3.dts b/arch/arm/boot/dts/imx6q-b450v3.dts
index d994b32ad825..0c4739594542 100644
--- a/arch/arm/boot/dts/imx6q-b450v3.dts
+++ b/arch/arm/boot/dts/imx6q-b450v3.dts
@@ -139,7 +139,6 @@ port@3 {
 
 	port@4 {
 		reg = <4>;
-		label = "cpu";
 		ethernet = <&switch_nic>;
 		phy-handle = <&switchphy4>;
 	};
diff --git a/arch/arm/boot/dts/imx6q-b650v3.dts b/arch/arm/boot/dts/imx6q-b650v3.dts
index fa1a1df37cde..e1367fb8bab9 100644
--- a/arch/arm/boot/dts/imx6q-b650v3.dts
+++ b/arch/arm/boot/dts/imx6q-b650v3.dts
@@ -138,7 +138,6 @@ port@3 {
 
 	port@4 {
 		reg = <4>;
-		label = "cpu";
 		ethernet = <&switch_nic>;
 		phy-handle = <&switchphy4>;
 	};
diff --git a/arch/arm/boot/dts/imx6q-b850v3.dts b/arch/arm/boot/dts/imx6q-b850v3.dts
index db8c332df6a1..3b3f136e235b 100644
--- a/arch/arm/boot/dts/imx6q-b850v3.dts
+++ b/arch/arm/boot/dts/imx6q-b850v3.dts
@@ -288,7 +288,6 @@ port@3 {
 
 	port@4 {
 		reg = <4>;
-		label = "cpu";
 		ethernet = <&switch_nic>;
 		phy-handle = <&switchphy4>;
 	};
diff --git a/arch/arm/boot/dts/imx6qdl-gw5904.dtsi b/arch/arm/boot/dts/imx6qdl-gw5904.dtsi
index 612b6e068e28..fec6a58c8ae3 100644
--- a/arch/arm/boot/dts/imx6qdl-gw5904.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw5904.dtsi
@@ -238,7 +238,6 @@ port@3 {
 
 				port@5 {
 					reg = <5>;
-					label = "cpu";
 					ethernet = <&fec>;
 				};
 			};
diff --git a/arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi b/arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi
index 3def1b621c8e..45b144872e28 100644
--- a/arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi
@@ -87,7 +87,6 @@ ports@1 {
 
 				ports@2 {
 					reg = <2>;
-					label = "cpu";
 					ethernet = <&fec>;
 					phy-mode = "rmii";
 
diff --git a/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi b/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
index 525ff62b47f5..2d48452cd3c9 100644
--- a/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
@@ -757,7 +757,6 @@ port@1 {
 
 				port@2 {
 					reg = <2>;
-					label = "cpu";
 					ethernet = <&fec>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/imx6qp-prtwd3.dts b/arch/arm/boot/dts/imx6qp-prtwd3.dts
index cf6571cc4682..bf0c4545e648 100644
--- a/arch/arm/boot/dts/imx6qp-prtwd3.dts
+++ b/arch/arm/boot/dts/imx6qp-prtwd3.dts
@@ -175,7 +175,6 @@ port@3 {
 
 			port@4 {
 				reg = <4>;
-				label = "cpu";
 				ethernet = <&fec>;
 				phy-mode = "rgmii-id";
 				rx-internal-delay-ps = <2000>;
diff --git a/arch/arm/boot/dts/imx7d-zii-rpu2.dts b/arch/arm/boot/dts/imx7d-zii-rpu2.dts
index 9d29490ab4c9..cf20f48dddaa 100644
--- a/arch/arm/boot/dts/imx7d-zii-rpu2.dts
+++ b/arch/arm/boot/dts/imx7d-zii-rpu2.dts
@@ -262,7 +262,6 @@ fixed-link {
 
 				port@5 {
 					reg = <5>;
-					label = "cpu";
 					ethernet = <&fec1>;
 					phy-mode = "rgmii-id";
 
diff --git a/arch/arm/boot/dts/kirkwood-dir665.dts b/arch/arm/boot/dts/kirkwood-dir665.dts
index f9f4b0143ba8..76d0e075d619 100644
--- a/arch/arm/boot/dts/kirkwood-dir665.dts
+++ b/arch/arm/boot/dts/kirkwood-dir665.dts
@@ -232,7 +232,6 @@ port@4 {
 
 			port@6 {
 				reg = <6>;
-				label = "cpu";
 				ethernet = <&eth0port>;
 				fixed-link {
 					speed = <1000>;
diff --git a/arch/arm/boot/dts/kirkwood-l-50.dts b/arch/arm/boot/dts/kirkwood-l-50.dts
index 60c1e94f5dd3..6b42d7dd7945 100644
--- a/arch/arm/boot/dts/kirkwood-l-50.dts
+++ b/arch/arm/boot/dts/kirkwood-l-50.dts
@@ -254,7 +254,6 @@ fixed-link {
 
 			port@6 {
 				reg = <6>;
-				label = "cpu";
 				phy-mode = "rgmii-id";
 				ethernet = <&eth1port>;
 				fixed-link {
diff --git a/arch/arm/boot/dts/kirkwood-linksys-viper.dts b/arch/arm/boot/dts/kirkwood-linksys-viper.dts
index 2f9660f3b457..8fedd4e05d7c 100644
--- a/arch/arm/boot/dts/kirkwood-linksys-viper.dts
+++ b/arch/arm/boot/dts/kirkwood-linksys-viper.dts
@@ -198,7 +198,6 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&eth0port>;
 				fixed-link {
 					speed = <1000>;
diff --git a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
index ced576acfb95..60566e82b58f 100644
--- a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
+++ b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
@@ -149,7 +149,6 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&eth0port>;
 				fixed-link {
 					speed = <1000>;
diff --git a/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi b/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
index e21aa674945d..60b18cb3213b 100644
--- a/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
+++ b/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
@@ -105,7 +105,6 @@ port@3 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&eth0port>;
 				fixed-link {
 					speed = <1000>;
diff --git a/arch/arm/boot/dts/mt7623a-rfb-emmc.dts b/arch/arm/boot/dts/mt7623a-rfb-emmc.dts
index e8b4b6d30d19..5c27c63a6694 100644
--- a/arch/arm/boot/dts/mt7623a-rfb-emmc.dts
+++ b/arch/arm/boot/dts/mt7623a-rfb-emmc.dts
@@ -171,7 +171,6 @@ port@4 {
 
 				port@6 {
 					reg = <6>;
-					label = "cpu";
 					ethernet = <&gmac0>;
 					phy-mode = "trgmii";
 
diff --git a/arch/arm/boot/dts/mt7623a-rfb-nand.dts b/arch/arm/boot/dts/mt7623a-rfb-nand.dts
index 61f5da68d4b0..1fee1bfa5ee8 100644
--- a/arch/arm/boot/dts/mt7623a-rfb-nand.dts
+++ b/arch/arm/boot/dts/mt7623a-rfb-nand.dts
@@ -175,7 +175,6 @@ port@4 {
 
 				port@6 {
 					reg = <6>;
-					label = "cpu";
 					ethernet = <&gmac0>;
 					phy-mode = "trgmii";
 
diff --git a/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts b/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts
index 5008115d2494..551a0967d487 100644
--- a/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts
+++ b/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts
@@ -228,7 +228,6 @@ port@4 {
 
 				port@6 {
 					reg = <6>;
-					label = "cpu";
 					ethernet = <&gmac0>;
 					phy-mode = "trgmii";
 
diff --git a/arch/arm/boot/dts/mt7623n-rfb-emmc.dts b/arch/arm/boot/dts/mt7623n-rfb-emmc.dts
index bf67a8e9be59..552866426a6f 100644
--- a/arch/arm/boot/dts/mt7623n-rfb-emmc.dts
+++ b/arch/arm/boot/dts/mt7623n-rfb-emmc.dts
@@ -225,7 +225,6 @@ port@4 {
 
 				port@6 {
 					reg = <6>;
-					label = "cpu";
 					ethernet = <&gmac0>;
 					phy-mode = "trgmii";
 
diff --git a/arch/arm/boot/dts/orion5x-netgear-wnr854t.dts b/arch/arm/boot/dts/orion5x-netgear-wnr854t.dts
index 4f4888ec9138..ec24fc5a4208 100644
--- a/arch/arm/boot/dts/orion5x-netgear-wnr854t.dts
+++ b/arch/arm/boot/dts/orion5x-netgear-wnr854t.dts
@@ -137,7 +137,6 @@ port@2 {
 
 			port@3 {
 				reg = <3>;
-				label = "cpu";
 				ethernet = <&ethport>;
 			};
 
diff --git a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
index 5a65cce2500c..38fd0149d6dc 100644
--- a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
+++ b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
@@ -55,7 +55,6 @@ ports {
 
 				switch0cpu: port@0 {
 					reg = <0>;
-					label = "cpu";
 					ethernet = <&gmac0>;
 					phy-mode = "rgmii-id";
 					fixed-link {
@@ -122,7 +121,6 @@ ports {
 
 				switch1cpu: port@0 {
 					reg = <0>;
-					label = "cpu";
 					ethernet = <&gmac3>;
 					phy-mode = "sgmii";
 					fixed-link {
diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
index 41e19c0986ce..338deb39a4bf 100644
--- a/arch/arm/boot/dts/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/r9a06g032.dtsi
@@ -401,7 +401,6 @@ switch_port3: port@3 {
 				switch_port4: port@4 {
 					reg = <4>;
 					ethernet = <&gmac2>;
-					label = "cpu";
 					phy-mode = "internal";
 					status = "disabled";
 					fixed-link {
diff --git a/arch/arm/boot/dts/stm32mp151a-prtt1c.dts b/arch/arm/boot/dts/stm32mp151a-prtt1c.dts
index 7ecf31263abc..672d48fc6009 100644
--- a/arch/arm/boot/dts/stm32mp151a-prtt1c.dts
+++ b/arch/arm/boot/dts/stm32mp151a-prtt1c.dts
@@ -290,7 +290,6 @@ port@3 {
 
 			port@4 {
 				reg = <4>;
-				label = "cpu";
 				ethernet = <&ethernet0>;
 				phy-mode = "rmii";
 
diff --git a/arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts b/arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts
index 97518afe4658..98c4daa5562f 100644
--- a/arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts
+++ b/arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts
@@ -169,7 +169,6 @@ port4: port@4 {
 
 				port8: port@8 {
 					reg = <8>;
-					label = "cpu";
 					ethernet = <&gmac>;
 					phy-mode = "rgmii-txid";
 					fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-cfu1.dts b/arch/arm/boot/dts/vf610-zii-cfu1.dts
index 96495d965163..67bab3f32feb 100644
--- a/arch/arm/boot/dts/vf610-zii-cfu1.dts
+++ b/arch/arm/boot/dts/vf610-zii-cfu1.dts
@@ -202,7 +202,6 @@ port@5 {
 
 				port@6 {
 					reg = <6>;
-					label = "cpu";
 					ethernet = <&fec1>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
index 42ed4a04a12e..bf481d6e366b 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
@@ -75,7 +75,6 @@ fixed-link {
 
 					port@6 {
 						reg = <6>;
-						label = "cpu";
 						ethernet = <&fec1>;
 
 						fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
index f892977da9e4..fcce4743ed43 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
@@ -44,7 +44,6 @@ ports {
 
 					port@0 {
 						reg = <0>;
-						label = "cpu";
 						ethernet = <&fec1>;
 
 						fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
index 040a1f8b6130..ca53c50ab1d7 100644
--- a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
+++ b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
@@ -59,7 +59,6 @@ ports {
 
 					port@0 {
 						reg = <0>;
-						label = "cpu";
 						ethernet = <&fec1>;
 
 						fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-spb4.dts b/arch/arm/boot/dts/vf610-zii-spb4.dts
index 6c6ec46fd015..a6c33eacc2db 100644
--- a/arch/arm/boot/dts/vf610-zii-spb4.dts
+++ b/arch/arm/boot/dts/vf610-zii-spb4.dts
@@ -140,7 +140,6 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
 					ethernet = <&fec1>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
index 73fdace4cb42..5978ef45b778 100644
--- a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
+++ b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
@@ -129,7 +129,6 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
 					ethernet = <&fec1>;
 
 					fixed-link {
diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
index fe600ab2e4bd..625fc6d10ac0 100644
--- a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
+++ b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
@@ -154,7 +154,6 @@ ports {
 
 				port@0 {
 					reg = <0>;
-					label = "cpu";
 					ethernet = <&fec1>;
 
 					fixed-link {
-- 
2.34.1


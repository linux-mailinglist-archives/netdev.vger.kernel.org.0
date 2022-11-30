Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8903463D82D
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiK3Oau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiK3OaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:30:20 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F525477B;
        Wed, 30 Nov 2022 06:30:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1669817569; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=JSacKIfuxVnGPNdOvTNL3VXsKQM4qKYAcNyM62uN0wuH9uI7u4LEUiHbLOklN7MsfxHvazieG2u/0J81Px89NKXRwBPqu4Pw6jInhCXzE3rdWRXhdfZaNTzHLSO9lJPkKtwpitvMR3jgZVj/fr12LzFmvrFen8xyh/DxxgNJ+14=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1669817569; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=rw2F9BBmZz7hCr2YZL7OfKiCcti+Y/szmYlgYlkB1sE=; 
        b=Qz//DYinXkVfGaASn1n1TLCXq2S9vL1Nmzeni4L4pbkQxUX6o2mfkIOQEpBudE90saz+FnsTnRKRDmS+fdI2X0cjmxoXlNAtqnUhiMpOl52qMuR2sraP/JJbtqDyyJvA3zg+R3KPiIff8pxLZ0GD4b8+VoOj+usjoXQ7TcBh7Zo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1669817569;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=rw2F9BBmZz7hCr2YZL7OfKiCcti+Y/szmYlgYlkB1sE=;
        b=Y3UfQeV6t5e6v1+lcSZhghTS0CZxtNhA9fhWhX01/PX+V0q+eUWYHvSIyUBh2gw0
        hVkCpwAY6EqKEk+cLkhndVHFFnyrRhER+VrpqH9ZxtSVnoH+Ecw3yVjk12T2WlQlAT3
        hGUf4H0F/Rx7+ehrD/hI7pNaE5FDByojV/CtfC+c=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1669817565868514.798752313474; Wed, 30 Nov 2022 06:12:45 -0800 (PST)
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
Subject: [PATCH 4/5] mips: dts: remove label = "cpu" from DSA dt-binding
Date:   Wed, 30 Nov 2022 17:10:39 +0300
Message-Id: <20221130141040.32447-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221130141040.32447-1-arinc.unal@arinc9.com>
References: <20221130141040.32447-1-arinc.unal@arinc9.com>
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

This is not used by the DSA dt-binding, so remove it from all devicetrees.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 arch/mips/boot/dts/qca/ar9331.dtsi    | 1 -
 arch/mips/boot/dts/ralink/mt7621.dtsi | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/mips/boot/dts/qca/ar9331.dtsi b/arch/mips/boot/dts/qca/ar9331.dtsi
index c4102b280b47..768ac0f869b1 100644
--- a/arch/mips/boot/dts/qca/ar9331.dtsi
+++ b/arch/mips/boot/dts/qca/ar9331.dtsi
@@ -176,7 +176,6 @@ ports {
 
 						switch_port0: port@0 {
 							reg = <0x0>;
-							label = "cpu";
 							ethernet = <&eth1>;
 
 							phy-mode = "gmii";
diff --git a/arch/mips/boot/dts/ralink/mt7621.dtsi b/arch/mips/boot/dts/ralink/mt7621.dtsi
index f3f4c1f26e01..445817cbf376 100644
--- a/arch/mips/boot/dts/ralink/mt7621.dtsi
+++ b/arch/mips/boot/dts/ralink/mt7621.dtsi
@@ -386,7 +386,6 @@ port@4 {
 
 					port@6 {
 						reg = <6>;
-						label = "cpu";
 						ethernet = <&gmac0>;
 						phy-mode = "trgmii";
 
-- 
2.34.1


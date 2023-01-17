Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528CA66D64C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 07:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbjAQGT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 01:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235866AbjAQGTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 01:19:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793842BEEF
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 22:16:17 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFb-0002TJ-Do; Tue, 17 Jan 2023 07:15:15 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFY-006bzx-US; Tue, 17 Jan 2023 07:15:12 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFX-00Fcks-5a; Tue, 17 Jan 2023 07:15:11 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 19/19] ARM: dts: imx6ul-prti6g: configure ethernet reference clock parent
Date:   Tue, 17 Jan 2023 07:14:53 +0100
Message-Id: <20230117061453.3723649-20-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230117061453.3723649-1-o.rempel@pengutronix.de>
References: <20230117061453.3723649-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On this board the PHY is the ref clock provider. So, configure ethernet
reference clock as input.

Without this patch we have relatively high amount of dropped packets.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/boot/dts/imx6ul-prti6g.dts | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/imx6ul-prti6g.dts b/arch/arm/boot/dts/imx6ul-prti6g.dts
index c18390f238e1..b7c96fbe7a91 100644
--- a/arch/arm/boot/dts/imx6ul-prti6g.dts
+++ b/arch/arm/boot/dts/imx6ul-prti6g.dts
@@ -26,6 +26,7 @@ clock_ksz8081_out: clock-ksz8081-out {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <50000000>;
+		clock-output-names = "enet1_ref_pad";
 	};
 
 	leds {
@@ -60,6 +61,13 @@ &can2 {
 	status = "okay";
 };
 
+&clks {
+	clocks = <&ckil>, <&osc>, <&ipp_di0>, <&ipp_di1>, <&clock_ksz8081_out>;
+	clock-names = "ckil", "osc", "ipp_di0", "ipp_di1", "enet1_ref_pad";
+	assigned-clocks = <&clks IMX6UL_CLK_ENET1_REF_SEL>;
+	assigned-clock-parents = <&clock_ksz8081_out>;
+};
+
 &ecspi1 {
 	cs-gpios = <&gpio4 26 GPIO_ACTIVE_LOW>;
 	pinctrl-names = "default";
@@ -85,12 +93,6 @@ &fec1 {
 	pinctrl-0 = <&pinctrl_eth1>;
 	phy-mode = "rmii";
 	phy-handle = <&rmii_phy>;
-	clocks = <&clks IMX6UL_CLK_ENET>,
-		 <&clks IMX6UL_CLK_ENET_AHB>,
-		 <&clks IMX6UL_CLK_ENET_PTP>,
-		 <&clock_ksz8081_out>;
-	clock-names = "ipg", "ahb", "ptp",
-		      "enet_clk_ref";
 	status = "okay";
 
 	mdio {
-- 
2.30.2


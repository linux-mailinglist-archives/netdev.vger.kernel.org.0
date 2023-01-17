Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C3166D64E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 07:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbjAQGUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 01:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235769AbjAQGU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 01:20:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66B52D14B
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 22:16:38 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFb-0002Th-E2; Tue, 17 Jan 2023 07:15:15 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFa-006c0c-Fq; Tue, 17 Jan 2023 07:15:14 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFX-00Fcjr-1k; Tue, 17 Jan 2023 07:15:11 +0100
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
Subject: [PATCH v2 12/19] ARM: dts: imx6qdl-skov-cpu: configure ethernet reference clock parent
Date:   Tue, 17 Jan 2023 07:14:46 +0100
Message-Id: <20230117061453.3723649-13-o.rempel@pengutronix.de>
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

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi b/arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi
index 3def1b621c8e..2731faede1cb 100644
--- a/arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-skov-cpu.dtsi
@@ -105,6 +105,7 @@ clk50m_phy: phy-clock {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <50000000>;
+		clock-output-names = "enet_ref_pad";
 	};
 
 	reg_3v3: regulator-3v3 {
@@ -232,13 +233,16 @@ adc: adc@0 {
 	};
 };
 
+&clks {
+	clocks = <&clk50m_phy>;
+	clock-names = "enet_ref_pad";
+	assigned-clocks = <&clks IMX6QDL_CLK_ENET_REF_SEL>;
+	assigned-clock-parents = <&clk50m_phy>;
+};
+
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	clocks = <&clks IMX6QDL_CLK_ENET>,
-		 <&clks IMX6QDL_CLK_ENET>,
-		 <&clk50m_phy>;
-	clock-names = "ipg", "ahb", "ptp";
 	phy-mode = "rmii";
 	phy-supply = <&reg_3v3>;
 	status = "okay";
-- 
2.30.2


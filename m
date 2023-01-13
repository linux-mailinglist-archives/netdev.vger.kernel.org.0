Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFF7669A8D
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjAMOff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjAMOde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:33:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9D04F124
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:27:59 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pGL1g-0006Il-Bz; Fri, 13 Jan 2023 15:27:24 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pGL1f-005mzP-KP; Fri, 13 Jan 2023 15:27:23 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pGL1b-00CkRW-IV; Fri, 13 Jan 2023 15:27:19 +0100
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
        Lee Jones <lee@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 14/20] ARM: dts: imx6dl-eckelmann-ci4x10: configure ethernet reference clock parent
Date:   Fri, 13 Jan 2023 15:27:12 +0100
Message-Id: <20230113142718.3038265-15-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230113142718.3038265-1-o.rempel@pengutronix.de>
References: <20230113142718.3038265-1-o.rempel@pengutronix.de>
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

Configure Ethernet reference clock parent in an obvious way instead of
using cryptic ptp way.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts b/arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts
index 864dc5018451..33825b5a8f26 100644
--- a/arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts
+++ b/arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts
@@ -28,6 +28,7 @@ rmii_clk: clock-rmii {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <50000000>;
+		clock-output-names = "enet_ref_pad";
 	};
 
 	reg_usb_h1_vbus: regulator-usb-h1-vbus {
@@ -64,6 +65,13 @@ &can2 {
 	status = "okay";
 };
 
+&clks {
+	clocks = <&rmii_clk>;
+	clock-names = "enet_ref_pad";
+	assigned-clocks = <&clks IMX6QDL_CLK_ENET_REF_SEL>;
+	assigned-clock-parents = <&rmii_clk>;
+};
+
 &ecspi2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_ecspi2>;
@@ -297,11 +305,6 @@ &fec {
 	phy-mode = "rmii";
 	phy-reset-gpios = <&gpio1 18 GPIO_ACTIVE_LOW>;
 	phy-handle = <&phy>;
-	clocks = <&clks IMX6QDL_CLK_ENET>,
-		 <&clks IMX6QDL_CLK_ENET>,
-		 <&rmii_clk>,
-		 <&clks IMX6QDL_CLK_ENET_REF>;
-	clock-names = "ipg", "ahb", "ptp", "enet_out";
 	status = "okay";
 
 	mdio {
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FC4669A9A
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjAMOgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjAMOeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:34:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A15544CC
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:28:10 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pGL1g-0006JF-Gw; Fri, 13 Jan 2023 15:27:24 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pGL1f-005mze-RF; Fri, 13 Jan 2023 15:27:23 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pGL1b-00CkRE-HI; Fri, 13 Jan 2023 15:27:19 +0100
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
Subject: [PATCH v1 12/20] ARM: dts: imx6q-prtwd2: configure ethernet reference clock parent
Date:   Fri, 13 Jan 2023 15:27:10 +0100
Message-Id: <20230113142718.3038265-13-o.rempel@pengutronix.de>
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
 arch/arm/boot/dts/imx6q-prtwd2.dts | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-prtwd2.dts b/arch/arm/boot/dts/imx6q-prtwd2.dts
index 349959d38020..54a57a4548e2 100644
--- a/arch/arm/boot/dts/imx6q-prtwd2.dts
+++ b/arch/arm/boot/dts/imx6q-prtwd2.dts
@@ -22,6 +22,13 @@ memory@80000000 {
 		reg = <0x80000000 0x20000000>;
 	};
 
+	clk50m_phy: phy-clock {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <50000000>;
+		clock-output-names = "enet_ref_pad";
+	};
+
 	usdhc2_wifi_pwrseq: usdhc2_wifi_pwrseq {
 		compatible = "mmc-pwrseq-simple";
 		pinctrl-names = "default";
@@ -49,13 +56,17 @@ &can1 {
 	status = "okay";
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
 	phy-mode = "rmii";
-	clocks = <&clks IMX6QDL_CLK_ENET>,
-		 <&clks IMX6QDL_CLK_ENET>;
-	clock-names = "ipg", "ahb";
 	status = "okay";
 
 	fixed-link {
-- 
2.30.2


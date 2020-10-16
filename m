Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C2328FF5B
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 09:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404717AbgJPHom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 03:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404704AbgJPHom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 03:44:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DE5C0613CF
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 00:44:42 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kTKPj-0007Q6-Gn; Fri, 16 Oct 2020 09:44:35 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kTKPi-0006rP-Ty; Fri, 16 Oct 2020 09:44:34 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH v1] ARM: dts: imx6/7: sync fsl,stop-mode with current flexcan driver
Date:   Fri, 16 Oct 2020 09:44:32 +0200
Message-Id: <20201016074432.26323-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After this patch we need 2 arguments less for the fsl,stop-mode
property:

| commit d9b081e3fc4bdc33e672dcb7bb256394909432fc
| Author: Marc Kleine-Budde <mkl@pengutronix.de>
| Date:   Sun Jun 14 21:09:20 2020 +0200
|
| can: flexcan: remove ack_grp and ack_bit handling from driver
|
| Since commit:
|
|  048e3a34a2e7 can: flexcan: poll MCR_LPM_ACK instead of GPR ACK for stop mode acknowledgment
|
| the driver polls the IP core's internal bit MCR[LPM_ACK] as stop mode
| acknowledge and not the acknowledgment on chip level.
|
| This means the 4th and 5th value of the property "fsl,stop-mode" isn't used
| anymore. This patch removes the used "ack_gpr" and "ack_bit" from the driver.

This patch removes the two last arguments, as they are not needed
anymore.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

 # Please enter the commit message for your changes. Lines starting
---
 arch/arm/boot/dts/imx6qdl.dtsi | 4 ++--
 arch/arm/boot/dts/imx6sx.dtsi  | 4 ++--
 arch/arm/boot/dts/imx6ul.dtsi  | 4 ++--
 arch/arm/boot/dts/imx7s.dtsi   | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 43edbf1156c7..5efb9b923bf9 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -549,7 +549,7 @@ can1: flexcan@2090000 {
 				clocks = <&clks IMX6QDL_CLK_CAN1_IPG>,
 					 <&clks IMX6QDL_CLK_CAN1_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x34 28 0x10 17>;
+				fsl,stop-mode = <&gpr 0x34 28>;
 				status = "disabled";
 			};
 
@@ -560,7 +560,7 @@ can2: flexcan@2094000 {
 				clocks = <&clks IMX6QDL_CLK_CAN2_IPG>,
 					 <&clks IMX6QDL_CLK_CAN2_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x34 29 0x10 18>;
+				fsl,stop-mode = <&gpr 0x34 29>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index b480dfa9e251..8770e522d21c 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -463,7 +463,7 @@ flexcan1: can@2090000 {
 				clocks = <&clks IMX6SX_CLK_CAN1_IPG>,
 					 <&clks IMX6SX_CLK_CAN1_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 1 0x10 17>;
+				fsl,stop-mode = <&gpr 0x10 1>;
 				status = "disabled";
 			};
 
@@ -474,7 +474,7 @@ flexcan2: can@2094000 {
 				clocks = <&clks IMX6SX_CLK_CAN2_IPG>,
 					 <&clks IMX6SX_CLK_CAN2_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 2 0x10 18>;
+				fsl,stop-mode = <&gpr 0x10 2>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 2b088f210331..4a059708ff20 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -430,7 +430,7 @@ can1: flexcan@2090000 {
 				clocks = <&clks IMX6UL_CLK_CAN1_IPG>,
 					 <&clks IMX6UL_CLK_CAN1_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 1 0x10 17>;
+				fsl,stop-mode = <&gpr 0x10 1>;
 				status = "disabled";
 			};
 
@@ -441,7 +441,7 @@ can2: flexcan@2094000 {
 				clocks = <&clks IMX6UL_CLK_CAN2_IPG>,
 					 <&clks IMX6UL_CLK_CAN2_SERIAL>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 2 0x10 18>;
+				fsl,stop-mode = <&gpr 0x10 2>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 1cfaf410aa43..837f0da08686 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -971,7 +971,7 @@ flexcan1: can@30a00000 {
 				clocks = <&clks IMX7D_CLK_DUMMY>,
 					<&clks IMX7D_CAN1_ROOT_CLK>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 1 0x10 17>;
+				fsl,stop-mode = <&gpr 0x10 1>;
 				status = "disabled";
 			};
 
@@ -982,7 +982,7 @@ flexcan2: can@30a10000 {
 				clocks = <&clks IMX7D_CLK_DUMMY>,
 					<&clks IMX7D_CAN2_ROOT_CLK>;
 				clock-names = "ipg", "per";
-				fsl,stop-mode = <&gpr 0x10 2 0x10 18>;
+				fsl,stop-mode = <&gpr 0x10 2>;
 				status = "disabled";
 			};
 
-- 
2.28.0


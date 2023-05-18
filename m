Return-Path: <netdev+bounces-3527-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB56707B10
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBCA3281851
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4C72A9F1;
	Thu, 18 May 2023 07:33:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B317053B1
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:33:22 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A4930EC
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:33:03 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pzY81-00015Z-2S
	for netdev@vger.kernel.org; Thu, 18 May 2023 09:32:49 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id 29DAD1C7A42
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:32:48 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id 7325F1C7A0C;
	Thu, 18 May 2023 07:32:44 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c7629806;
	Thu, 18 May 2023 07:32:43 +0000 (UTC)
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	linux-can@vger.kernel.org,
	kernel@pengutronix.de,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Alexandre TORGUE <alexandre.torgue@foss.st.com>,
	kernel test robot <lkp@intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH net 7/7] Revert "ARM: dts: stm32: add CAN support on stm32f746"
Date: Thu, 18 May 2023 09:32:41 +0200
Message-Id: <20230518073241.1110453-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230518073241.1110453-1-mkl@pengutronix.de>
References: <20230518073241.1110453-1-mkl@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This reverts commit 0920ccdf41e3078a4dd2567eb905ea154bc826e6.

The commit 0920ccdf41e3 ("ARM: dts: stm32: add CAN support on
stm32f746") depends on the patch "dt-bindings: mfd: stm32f7: add
binding definition for CAN3" [1], which is not in net/main, yet. This
results in a parsing error of "stm32f746.dtsi".

So revert this commit.

[1] https://lore.kernel.org/all/20230423172528.1398158-2-dario.binacchi@amarulasolutions.com

Cc: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202305172108.x5acbaQG-lkp@intel.com
Closes: https://lore.kernel.org/oe-kbuild-all/202305172130.eGGEUhpi-lkp@intel.com
Fixes: 0920ccdf41e3 ("ARM: dts: stm32: add CAN support on stm32f746")
Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/20230517181950.1106697-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 arch/arm/boot/dts/stm32f746.dtsi | 47 --------------------------------
 1 file changed, 47 deletions(-)

diff --git a/arch/arm/boot/dts/stm32f746.dtsi b/arch/arm/boot/dts/stm32f746.dtsi
index 973698bc9ef4..dc868e6da40e 100644
--- a/arch/arm/boot/dts/stm32f746.dtsi
+++ b/arch/arm/boot/dts/stm32f746.dtsi
@@ -257,23 +257,6 @@ rtc: rtc@40002800 {
 			status = "disabled";
 		};
 
-		can3: can@40003400 {
-			compatible = "st,stm32f4-bxcan";
-			reg = <0x40003400 0x200>;
-			interrupts = <104>, <105>, <106>, <107>;
-			interrupt-names = "tx", "rx0", "rx1", "sce";
-			resets = <&rcc STM32F7_APB1_RESET(CAN3)>;
-			clocks = <&rcc 0 STM32F7_APB1_CLOCK(CAN3)>;
-			st,gcan = <&gcan3>;
-			status = "disabled";
-		};
-
-		gcan3: gcan@40003600 {
-			compatible = "st,stm32f4-gcan", "syscon";
-			reg = <0x40003600 0x200>;
-			clocks = <&rcc 0 STM32F7_APB1_CLOCK(CAN3)>;
-		};
-
 		usart2: serial@40004400 {
 			compatible = "st,stm32f7-uart";
 			reg = <0x40004400 0x400>;
@@ -354,36 +337,6 @@ i2c4: i2c@40006000 {
 			status = "disabled";
 		};
 
-		can1: can@40006400 {
-			compatible = "st,stm32f4-bxcan";
-			reg = <0x40006400 0x200>;
-			interrupts = <19>, <20>, <21>, <22>;
-			interrupt-names = "tx", "rx0", "rx1", "sce";
-			resets = <&rcc STM32F7_APB1_RESET(CAN1)>;
-			clocks = <&rcc 0 STM32F7_APB1_CLOCK(CAN1)>;
-			st,can-primary;
-			st,gcan = <&gcan1>;
-			status = "disabled";
-		};
-
-		gcan1: gcan@40006600 {
-			compatible = "st,stm32f4-gcan", "syscon";
-			reg = <0x40006600 0x200>;
-			clocks = <&rcc 0 STM32F7_APB1_CLOCK(CAN1)>;
-		};
-
-		can2: can@40006800 {
-			compatible = "st,stm32f4-bxcan";
-			reg = <0x40006800 0x200>;
-			interrupts = <63>, <64>, <65>, <66>;
-			interrupt-names = "tx", "rx0", "rx1", "sce";
-			resets = <&rcc STM32F7_APB1_RESET(CAN2)>;
-			clocks = <&rcc 0 STM32F7_APB1_CLOCK(CAN2)>;
-			st,can-secondary;
-			st,gcan = <&gcan1>;
-			status = "disabled";
-		};
-
 		cec: cec@40006c00 {
 			compatible = "st,stm32-cec";
 			reg = <0x40006C00 0x400>;
-- 
2.39.2




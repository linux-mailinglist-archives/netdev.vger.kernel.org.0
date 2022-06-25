Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922DA55A9C4
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiFYMG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbiFYMGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E032C675
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YV-0002jh-Ua
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:27 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D64BA9F1C0
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:04:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4750D9F185;
        Sat, 25 Jun 2022 12:04:01 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 69e16054;
        Sat, 25 Jun 2022 12:03:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/22] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
Date:   Sat, 25 Jun 2022 14:03:21 +0200
Message-Id: <20220625120335.324697-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220625120335.324697-1-mkl@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Only a few drivers rely on the CAN rx offload framework (as of the
writing of this patch, only four: flexcan, m_can, mcp251xfd and
ti_hecc). Split it out of can-dev and add a new config symbol:
CAN_RX_OFFLOAD.

The drivers relying on CAN rx offload are in different sub
folders. Make CAN_RX_OFFLOAD an hidden option and tag all the drivers
depending on that feature with "select CAN_RX_OFFLOAD" so that the
option gets automatically enabled if and only if one of those drivers
is chosen.

Link: https://lore.kernel.org/all/20220610143009.323579-5-mailhol.vincent@wanadoo.fr
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Acked-by: Max Staudt <max@enpas.org>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/Kconfig               | 5 +++++
 drivers/net/can/dev/Makefile          | 2 +-
 drivers/net/can/m_can/Kconfig         | 1 +
 drivers/net/can/spi/mcp251xfd/Kconfig | 1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 87470feae6b1..5335f3afc0a5 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -102,6 +102,9 @@ config CAN_CALC_BITTIMING
 
 	  If unsure, say Y.
 
+config CAN_RX_OFFLOAD
+	bool
+
 config CAN_AT91
 	tristate "Atmel AT91 onchip CAN controller"
 	depends on (ARCH_AT91 || COMPILE_TEST) && HAS_IOMEM
@@ -113,6 +116,7 @@ config CAN_FLEXCAN
 	tristate "Support for Freescale FLEXCAN based chips"
 	depends on OF || COLDFIRE || COMPILE_TEST
 	depends on HAS_IOMEM
+	select CAN_RX_OFFLOAD
 	help
 	  Say Y here if you want to support for Freescale FlexCAN.
 
@@ -162,6 +166,7 @@ config CAN_SUN4I
 config CAN_TI_HECC
 	depends on ARM
 	tristate "TI High End CAN Controller"
+	select CAN_RX_OFFLOAD
 	help
 	  Driver for TI HECC (High End CAN Controller) module found on many
 	  TI devices. The device specifications are available from www.ti.com
diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
index 791e6b297ea3..633687d6b6c0 100644
--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -9,4 +9,4 @@ can-dev-$(CONFIG_CAN_NETLINK) += bittiming.o
 can-dev-$(CONFIG_CAN_NETLINK) += dev.o
 can-dev-$(CONFIG_CAN_NETLINK) += length.o
 can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
-can-dev-$(CONFIG_CAN_NETLINK) += rx-offload.o
+can-dev-$(CONFIG_CAN_RX_OFFLOAD) += rx-offload.o
diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index 45ad1b3f0cd0..fc2afab36279 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig CAN_M_CAN
 	tristate "Bosch M_CAN support"
+	select CAN_RX_OFFLOAD
 	help
 	  Say Y here if you want support for Bosch M_CAN controller framework.
 	  This is common support for devices that embed the Bosch M_CAN IP.
diff --git a/drivers/net/can/spi/mcp251xfd/Kconfig b/drivers/net/can/spi/mcp251xfd/Kconfig
index dd0fc0a54be1..877e4356010d 100644
--- a/drivers/net/can/spi/mcp251xfd/Kconfig
+++ b/drivers/net/can/spi/mcp251xfd/Kconfig
@@ -2,6 +2,7 @@
 
 config CAN_MCP251XFD
 	tristate "Microchip MCP251xFD SPI CAN controllers"
+	select CAN_RX_OFFLOAD
 	select REGMAP
 	select WANT_DEV_COREDUMP
 	help
-- 
2.35.1



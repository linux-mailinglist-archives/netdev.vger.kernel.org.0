Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCC027F32E
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgI3USo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730233AbgI3US1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:18:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBABC0613D1
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:18:27 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kNiYT-0002Qt-QE; Wed, 30 Sep 2020 22:18:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Thomas Kopp <thomas.kopp@microchip.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 07/13] can: mcp25xxfd: narrow down wildcards in device tree bindings to "microchip,mcp251xfd"
Date:   Wed, 30 Sep 2020 22:18:10 +0200
Message-Id: <20200930201816.1032054-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930201816.1032054-1-mkl@pengutronix.de>
References: <20200930201816.1032054-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Kopp <thomas.kopp@microchip.com>

The wildcard should be narrowed down to prevent existing and future devices
that are not compatible from matching. It is very unlikely that incompatible
devices will be released that do not match the wildcard.

Discussion Reference: https://lore.kernel.org/r/CAMuHMdVkwGjr6dJuMyhQNqFoJqbh6Ec5V2b5LenCshwpM2SDsQ@mail.gmail.com

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Thomas Kopp <thomas.kopp@microchip.com>
Link: https://lore.kernel.org/r/20200930091423.755-1-thomas.kopp@microchip.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c | 18 +++++++++---------
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h      |  4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
index 95d5cb46bc63..181207139343 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
@@ -41,10 +41,10 @@ static const struct mcp25xxfd_devtype_data mcp25xxfd_devtype_data_mcp2518fd = {
 };
 
 /* Autodetect model, start with CRC enabled. */
-static const struct mcp25xxfd_devtype_data mcp25xxfd_devtype_data_mcp25xxfd = {
+static const struct mcp25xxfd_devtype_data mcp25xxfd_devtype_data_mcp251xfd = {
 	.quirks = MCP25XXFD_QUIRK_CRC_REG | MCP25XXFD_QUIRK_CRC_RX |
 		MCP25XXFD_QUIRK_CRC_TX | MCP25XXFD_QUIRK_ECC,
-	.model = MCP25XXFD_MODEL_MCP25XXFD,
+	.model = MCP25XXFD_MODEL_MCP251XFD,
 };
 
 static const struct can_bittiming_const mcp25xxfd_bittiming_const = {
@@ -78,8 +78,8 @@ static const char *__mcp25xxfd_get_model_str(enum mcp25xxfd_model model)
 		return "MCP2517FD"; break;
 	case MCP25XXFD_MODEL_MCP2518FD:
 		return "MCP2518FD"; break;
-	case MCP25XXFD_MODEL_MCP25XXFD:
-		return "MCP25xxFD"; break;
+	case MCP25XXFD_MODEL_MCP251XFD:
+		return "MCP251xFD"; break;
 	}
 
 	return "<unknown>";
@@ -2494,7 +2494,7 @@ static int mcp25xxfd_register_chip_detect(struct mcp25xxfd_priv *priv)
 	else
 		devtype_data = &mcp25xxfd_devtype_data_mcp2517fd;
 
-	if (!mcp25xxfd_is_25XX(priv) &&
+	if (!mcp25xxfd_is_251X(priv) &&
 	    priv->devtype_data.model != devtype_data->model) {
 		netdev_info(ndev,
 			    "Detected %s, but firmware specifies a %s. Fixing up.",
@@ -2703,8 +2703,8 @@ static const struct of_device_id mcp25xxfd_of_match[] = {
 		.compatible = "microchip,mcp2518fd",
 		.data = &mcp25xxfd_devtype_data_mcp2518fd,
 	}, {
-		.compatible = "microchip,mcp25xxfd",
-		.data = &mcp25xxfd_devtype_data_mcp25xxfd,
+		.compatible = "microchip,mcp251xfd",
+		.data = &mcp25xxfd_devtype_data_mcp251xfd,
 	}, {
 		/* sentinel */
 	},
@@ -2719,8 +2719,8 @@ static const struct spi_device_id mcp25xxfd_id_table[] = {
 		.name = "mcp2518fd",
 		.driver_data = (kernel_ulong_t)&mcp25xxfd_devtype_data_mcp2518fd,
 	}, {
-		.name = "mcp25xxfd",
-		.driver_data = (kernel_ulong_t)&mcp25xxfd_devtype_data_mcp25xxfd,
+		.name = "mcp251xfd",
+		.driver_data = (kernel_ulong_t)&mcp25xxfd_devtype_data_mcp251xfd,
 	}, {
 		/* sentinel */
 	},
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h
index 3bc799204cb0..b1b5d7fd33ea 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h
@@ -553,7 +553,7 @@ struct mcp25xxfd_regs_status {
 enum mcp25xxfd_model {
 	MCP25XXFD_MODEL_MCP2517FD = 0x2517,
 	MCP25XXFD_MODEL_MCP2518FD = 0x2518,
-	MCP25XXFD_MODEL_MCP25XXFD = 0xffff,	/* autodetect model */
+	MCP25XXFD_MODEL_MCP251XFD = 0xffff,	/* autodetect model */
 };
 
 struct mcp25xxfd_devtype_data {
@@ -607,7 +607,7 @@ mcp25xxfd_is_##_model(const struct mcp25xxfd_priv *priv) \
 
 MCP25XXFD_IS(2517);
 MCP25XXFD_IS(2518);
-MCP25XXFD_IS(25XX);
+MCP25XXFD_IS(251X);
 
 static inline u8 mcp25xxfd_first_byte_set(u32 mask)
 {
-- 
2.28.0


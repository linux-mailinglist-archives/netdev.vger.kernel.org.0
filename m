Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD21B27F321
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgI3USd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730260AbgI3USb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:18:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED33EC0613D8
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:18:28 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kNiYU-0002Qt-TY; Wed, 30 Sep 2020 22:18:27 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 10/13] can: mcp251xfd: rename all remaining occurrence to mcp251xfd
Date:   Wed, 30 Sep 2020 22:18:13 +0200
Message-Id: <20200930201816.1032054-11-mkl@pengutronix.de>
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

In [1] Geert noted that the autodetect compatible for the mcp25xxfd driver,
which is "microchip,mcp25xxfd" might be too generic and overlap with upcoming,
but incompatible chips.

In the previous patch the autodetect DT compatbile has been renamed to
"microchip,mcp251xfd", this patch changes all non user facing occurrence of
"mcp25xxfd" to "mcp251xfd" and "MCP25XXFD" to "MCP251XFD".

[1] http://lore.kernel.org/r/CAMuHMdVkwGjr6dJuMyhQNqFoJqbh6Ec5V2b5LenCshwpM2SDsQ@mail.gmail.com

Link: https://lore.kernel.org/r/20200930091424.792165-10-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 1330 ++++++++---------
 .../net/can/spi/mcp251xfd/mcp251xfd-crc16.c   |   22 +-
 .../net/can/spi/mcp251xfd/mcp251xfd-regmap.c  |  230 +--
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     |  972 ++++++------
 4 files changed, 1277 insertions(+), 1277 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 37d3f07c9bf6..c3f49543ff26 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 //
-// mcp25xxfd - Microchip MCP25xxFD Family CAN controller driver
+// mcp251xfd - Microchip MCP251xFD Family CAN controller driver
 //
 // Copyright (c) 2019, 2020 Pengutronix,
 //                          Marc Kleine-Budde <kernel@pengutronix.de>
@@ -27,27 +27,27 @@
 
 #define DEVICE_NAME "mcp251xfd"
 
-static const struct mcp25xxfd_devtype_data mcp25xxfd_devtype_data_mcp2517fd = {
-	.quirks = MCP25XXFD_QUIRK_MAB_NO_WARN | MCP25XXFD_QUIRK_CRC_REG |
-		MCP25XXFD_QUIRK_CRC_RX | MCP25XXFD_QUIRK_CRC_TX |
-		MCP25XXFD_QUIRK_ECC,
-	.model = MCP25XXFD_MODEL_MCP2517FD,
+static const struct mcp251xfd_devtype_data mcp251xfd_devtype_data_mcp2517fd = {
+	.quirks = MCP251XFD_QUIRK_MAB_NO_WARN | MCP251XFD_QUIRK_CRC_REG |
+		MCP251XFD_QUIRK_CRC_RX | MCP251XFD_QUIRK_CRC_TX |
+		MCP251XFD_QUIRK_ECC,
+	.model = MCP251XFD_MODEL_MCP2517FD,
 };
 
-static const struct mcp25xxfd_devtype_data mcp25xxfd_devtype_data_mcp2518fd = {
-	.quirks = MCP25XXFD_QUIRK_CRC_REG | MCP25XXFD_QUIRK_CRC_RX |
-		MCP25XXFD_QUIRK_CRC_TX | MCP25XXFD_QUIRK_ECC,
-	.model = MCP25XXFD_MODEL_MCP2518FD,
+static const struct mcp251xfd_devtype_data mcp251xfd_devtype_data_mcp2518fd = {
+	.quirks = MCP251XFD_QUIRK_CRC_REG | MCP251XFD_QUIRK_CRC_RX |
+		MCP251XFD_QUIRK_CRC_TX | MCP251XFD_QUIRK_ECC,
+	.model = MCP251XFD_MODEL_MCP2518FD,
 };
 
 /* Autodetect model, start with CRC enabled. */
-static const struct mcp25xxfd_devtype_data mcp25xxfd_devtype_data_mcp251xfd = {
-	.quirks = MCP25XXFD_QUIRK_CRC_REG | MCP25XXFD_QUIRK_CRC_RX |
-		MCP25XXFD_QUIRK_CRC_TX | MCP25XXFD_QUIRK_ECC,
-	.model = MCP25XXFD_MODEL_MCP251XFD,
+static const struct mcp251xfd_devtype_data mcp251xfd_devtype_data_mcp251xfd = {
+	.quirks = MCP251XFD_QUIRK_CRC_REG | MCP251XFD_QUIRK_CRC_RX |
+		MCP251XFD_QUIRK_CRC_TX | MCP251XFD_QUIRK_ECC,
+	.model = MCP251XFD_MODEL_MCP251XFD,
 };
 
-static const struct can_bittiming_const mcp25xxfd_bittiming_const = {
+static const struct can_bittiming_const mcp251xfd_bittiming_const = {
 	.name = DEVICE_NAME,
 	.tseg1_min = 2,
 	.tseg1_max = 256,
@@ -59,7 +59,7 @@ static const struct can_bittiming_const mcp25xxfd_bittiming_const = {
 	.brp_inc = 1,
 };
 
-static const struct can_bittiming_const mcp25xxfd_data_bittiming_const = {
+static const struct can_bittiming_const mcp251xfd_data_bittiming_const = {
 	.name = DEVICE_NAME,
 	.tseg1_min = 1,
 	.tseg1_max = 32,
@@ -71,14 +71,14 @@ static const struct can_bittiming_const mcp25xxfd_data_bittiming_const = {
 	.brp_inc = 1,
 };
 
-static const char *__mcp25xxfd_get_model_str(enum mcp25xxfd_model model)
+static const char *__mcp251xfd_get_model_str(enum mcp251xfd_model model)
 {
 	switch (model) {
-	case MCP25XXFD_MODEL_MCP2517FD:
+	case MCP251XFD_MODEL_MCP2517FD:
 		return "MCP2517FD"; break;
-	case MCP25XXFD_MODEL_MCP2518FD:
+	case MCP251XFD_MODEL_MCP2518FD:
 		return "MCP2518FD"; break;
-	case MCP25XXFD_MODEL_MCP251XFD:
+	case MCP251XFD_MODEL_MCP251XFD:
 		return "MCP251xFD"; break;
 	}
 
@@ -86,36 +86,36 @@ static const char *__mcp25xxfd_get_model_str(enum mcp25xxfd_model model)
 }
 
 static inline const char *
-mcp25xxfd_get_model_str(const struct mcp25xxfd_priv *priv)
+mcp251xfd_get_model_str(const struct mcp251xfd_priv *priv)
 {
-	return __mcp25xxfd_get_model_str(priv->devtype_data.model);
+	return __mcp251xfd_get_model_str(priv->devtype_data.model);
 }
 
-static const char *mcp25xxfd_get_mode_str(const u8 mode)
+static const char *mcp251xfd_get_mode_str(const u8 mode)
 {
 	switch (mode) {
-	case MCP25XXFD_REG_CON_MODE_MIXED:
+	case MCP251XFD_REG_CON_MODE_MIXED:
 		return "Mixed (CAN FD/CAN 2.0)"; break;
-	case MCP25XXFD_REG_CON_MODE_SLEEP:
+	case MCP251XFD_REG_CON_MODE_SLEEP:
 		return "Sleep"; break;
-	case MCP25XXFD_REG_CON_MODE_INT_LOOPBACK:
+	case MCP251XFD_REG_CON_MODE_INT_LOOPBACK:
 		return "Internal Loopback"; break;
-	case MCP25XXFD_REG_CON_MODE_LISTENONLY:
+	case MCP251XFD_REG_CON_MODE_LISTENONLY:
 		return "Listen Only"; break;
-	case MCP25XXFD_REG_CON_MODE_CONFIG:
+	case MCP251XFD_REG_CON_MODE_CONFIG:
 		return "Configuration"; break;
-	case MCP25XXFD_REG_CON_MODE_EXT_LOOPBACK:
+	case MCP251XFD_REG_CON_MODE_EXT_LOOPBACK:
 		return "External Loopback"; break;
-	case MCP25XXFD_REG_CON_MODE_CAN2_0:
+	case MCP251XFD_REG_CON_MODE_CAN2_0:
 		return "CAN 2.0"; break;
-	case MCP25XXFD_REG_CON_MODE_RESTRICTED:
+	case MCP251XFD_REG_CON_MODE_RESTRICTED:
 		return "Restricted Operation"; break;
 	}
 
 	return "<unknown>";
 }
 
-static inline int mcp25xxfd_vdd_enable(const struct mcp25xxfd_priv *priv)
+static inline int mcp251xfd_vdd_enable(const struct mcp251xfd_priv *priv)
 {
 	if (!priv->reg_vdd)
 		return 0;
@@ -123,7 +123,7 @@ static inline int mcp25xxfd_vdd_enable(const struct mcp25xxfd_priv *priv)
 	return regulator_enable(priv->reg_vdd);
 }
 
-static inline int mcp25xxfd_vdd_disable(const struct mcp25xxfd_priv *priv)
+static inline int mcp251xfd_vdd_disable(const struct mcp251xfd_priv *priv)
 {
 	if (!priv->reg_vdd)
 		return 0;
@@ -132,7 +132,7 @@ static inline int mcp25xxfd_vdd_disable(const struct mcp25xxfd_priv *priv)
 }
 
 static inline int
-mcp25xxfd_transceiver_enable(const struct mcp25xxfd_priv *priv)
+mcp251xfd_transceiver_enable(const struct mcp251xfd_priv *priv)
 {
 	if (!priv->reg_xceiver)
 		return 0;
@@ -141,7 +141,7 @@ mcp25xxfd_transceiver_enable(const struct mcp25xxfd_priv *priv)
 }
 
 static inline int
-mcp25xxfd_transceiver_disable(const struct mcp25xxfd_priv *priv)
+mcp251xfd_transceiver_disable(const struct mcp251xfd_priv *priv)
 {
 	if (!priv->reg_xceiver)
 		return 0;
@@ -149,7 +149,7 @@ mcp25xxfd_transceiver_disable(const struct mcp25xxfd_priv *priv)
 	return regulator_disable(priv->reg_xceiver);
 }
 
-static int mcp25xxfd_clks_and_vdd_enable(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_clks_and_vdd_enable(const struct mcp251xfd_priv *priv)
 {
 	int err;
 
@@ -157,22 +157,22 @@ static int mcp25xxfd_clks_and_vdd_enable(const struct mcp25xxfd_priv *priv)
 	if (err)
 		return err;
 
-	err = mcp25xxfd_vdd_enable(priv);
+	err = mcp251xfd_vdd_enable(priv);
 	if (err)
 		clk_disable_unprepare(priv->clk);
 
 	/* Wait for oscillator stabilisation time after power up */
-	usleep_range(MCP25XXFD_OSC_STAB_SLEEP_US,
-		     2 * MCP25XXFD_OSC_STAB_SLEEP_US);
+	usleep_range(MCP251XFD_OSC_STAB_SLEEP_US,
+		     2 * MCP251XFD_OSC_STAB_SLEEP_US);
 
 	return err;
 }
 
-static int mcp25xxfd_clks_and_vdd_disable(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_clks_and_vdd_disable(const struct mcp251xfd_priv *priv)
 {
 	int err;
 
-	err = mcp25xxfd_vdd_disable(priv);
+	err = mcp251xfd_vdd_disable(priv);
 	if (err)
 		return err;
 
@@ -182,30 +182,30 @@ static int mcp25xxfd_clks_and_vdd_disable(const struct mcp25xxfd_priv *priv)
 }
 
 static inline u8
-mcp25xxfd_cmd_prepare_write_reg(const struct mcp25xxfd_priv *priv,
-				union mcp25xxfd_write_reg_buf *write_reg_buf,
+mcp251xfd_cmd_prepare_write_reg(const struct mcp251xfd_priv *priv,
+				union mcp251xfd_write_reg_buf *write_reg_buf,
 				const u16 reg, const u32 mask, const u32 val)
 {
 	u8 first_byte, last_byte, len;
 	u8 *data;
 	__le32 val_le32;
 
-	first_byte = mcp25xxfd_first_byte_set(mask);
-	last_byte = mcp25xxfd_last_byte_set(mask);
+	first_byte = mcp251xfd_first_byte_set(mask);
+	last_byte = mcp251xfd_last_byte_set(mask);
 	len = last_byte - first_byte + 1;
 
-	data = mcp25xxfd_spi_cmd_write(priv, write_reg_buf, reg + first_byte);
+	data = mcp251xfd_spi_cmd_write(priv, write_reg_buf, reg + first_byte);
 	val_le32 = cpu_to_le32(val >> BITS_PER_BYTE * first_byte);
 	memcpy(data, &val_le32, len);
 
-	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_REG) {
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_REG) {
 		u16 crc;
 
-		mcp25xxfd_spi_cmd_crc_set_len_in_reg(&write_reg_buf->crc.cmd,
+		mcp251xfd_spi_cmd_crc_set_len_in_reg(&write_reg_buf->crc.cmd,
 						     len);
 		/* CRC */
 		len += sizeof(write_reg_buf->crc.cmd);
-		crc = mcp25xxfd_crc16_compute(&write_reg_buf->crc, len);
+		crc = mcp251xfd_crc16_compute(&write_reg_buf->crc, len);
 		put_unaligned_be16(crc, (void *)write_reg_buf + len);
 
 		/* Total length */
@@ -218,80 +218,80 @@ mcp25xxfd_cmd_prepare_write_reg(const struct mcp25xxfd_priv *priv,
 }
 
 static inline int
-mcp25xxfd_tef_tail_get_from_chip(const struct mcp25xxfd_priv *priv,
+mcp251xfd_tef_tail_get_from_chip(const struct mcp251xfd_priv *priv,
 				 u8 *tef_tail)
 {
 	u32 tef_ua;
 	int err;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_TEFUA, &tef_ua);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_TEFUA, &tef_ua);
 	if (err)
 		return err;
 
-	*tef_tail = tef_ua / sizeof(struct mcp25xxfd_hw_tef_obj);
+	*tef_tail = tef_ua / sizeof(struct mcp251xfd_hw_tef_obj);
 
 	return 0;
 }
 
 static inline int
-mcp25xxfd_tx_tail_get_from_chip(const struct mcp25xxfd_priv *priv,
+mcp251xfd_tx_tail_get_from_chip(const struct mcp251xfd_priv *priv,
 				u8 *tx_tail)
 {
 	u32 fifo_sta;
 	int err;
 
 	err = regmap_read(priv->map_reg,
-			  MCP25XXFD_REG_FIFOSTA(MCP25XXFD_TX_FIFO),
+			  MCP251XFD_REG_FIFOSTA(MCP251XFD_TX_FIFO),
 			  &fifo_sta);
 	if (err)
 		return err;
 
-	*tx_tail = FIELD_GET(MCP25XXFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
+	*tx_tail = FIELD_GET(MCP251XFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
 
 	return 0;
 }
 
 static inline int
-mcp25xxfd_rx_head_get_from_chip(const struct mcp25xxfd_priv *priv,
-				const struct mcp25xxfd_rx_ring *ring,
+mcp251xfd_rx_head_get_from_chip(const struct mcp251xfd_priv *priv,
+				const struct mcp251xfd_rx_ring *ring,
 				u8 *rx_head)
 {
 	u32 fifo_sta;
 	int err;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_FIFOSTA(ring->fifo_nr),
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_FIFOSTA(ring->fifo_nr),
 			  &fifo_sta);
 	if (err)
 		return err;
 
-	*rx_head = FIELD_GET(MCP25XXFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
+	*rx_head = FIELD_GET(MCP251XFD_REG_FIFOSTA_FIFOCI_MASK, fifo_sta);
 
 	return 0;
 }
 
 static inline int
-mcp25xxfd_rx_tail_get_from_chip(const struct mcp25xxfd_priv *priv,
-				const struct mcp25xxfd_rx_ring *ring,
+mcp251xfd_rx_tail_get_from_chip(const struct mcp251xfd_priv *priv,
+				const struct mcp251xfd_rx_ring *ring,
 				u8 *rx_tail)
 {
 	u32 fifo_ua;
 	int err;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_FIFOUA(ring->fifo_nr),
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_FIFOUA(ring->fifo_nr),
 			  &fifo_ua);
 	if (err)
 		return err;
 
-	fifo_ua -= ring->base - MCP25XXFD_RAM_START;
+	fifo_ua -= ring->base - MCP251XFD_RAM_START;
 	*rx_tail = fifo_ua / ring->obj_size;
 
 	return 0;
 }
 
 static void
-mcp25xxfd_tx_ring_init_tx_obj(const struct mcp25xxfd_priv *priv,
-			      const struct mcp25xxfd_tx_ring *ring,
-			      struct mcp25xxfd_tx_obj *tx_obj,
+mcp251xfd_tx_ring_init_tx_obj(const struct mcp251xfd_priv *priv,
+			      const struct mcp251xfd_tx_ring *ring,
+			      struct mcp251xfd_tx_obj *tx_obj,
 			      const u8 rts_buf_len,
 			      const u8 n)
 {
@@ -299,12 +299,12 @@ mcp25xxfd_tx_ring_init_tx_obj(const struct mcp25xxfd_priv *priv,
 	u16 addr;
 
 	/* FIFO load */
-	addr = mcp25xxfd_get_tx_obj_addr(ring, n);
-	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_TX)
-		mcp25xxfd_spi_cmd_write_crc_set_addr(&tx_obj->buf.crc.cmd,
+	addr = mcp251xfd_get_tx_obj_addr(ring, n);
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_TX)
+		mcp251xfd_spi_cmd_write_crc_set_addr(&tx_obj->buf.crc.cmd,
 						     addr);
 	else
-		mcp25xxfd_spi_cmd_write_nocrc(&tx_obj->buf.nocrc.cmd,
+		mcp251xfd_spi_cmd_write_nocrc(&tx_obj->buf.nocrc.cmd,
 					      addr);
 
 	xfer = &tx_obj->xfer[0];
@@ -324,11 +324,11 @@ mcp25xxfd_tx_ring_init_tx_obj(const struct mcp25xxfd_priv *priv,
 					ARRAY_SIZE(tx_obj->xfer));
 }
 
-static void mcp25xxfd_ring_init(struct mcp25xxfd_priv *priv)
+static void mcp251xfd_ring_init(struct mcp251xfd_priv *priv)
 {
-	struct mcp25xxfd_tx_ring *tx_ring;
-	struct mcp25xxfd_rx_ring *rx_ring, *prev_rx_ring = NULL;
-	struct mcp25xxfd_tx_obj *tx_obj;
+	struct mcp251xfd_tx_ring *tx_ring;
+	struct mcp251xfd_rx_ring *rx_ring, *prev_rx_ring = NULL;
+	struct mcp251xfd_tx_obj *tx_obj;
 	u32 val;
 	u16 addr;
 	u8 len;
@@ -342,27 +342,27 @@ static void mcp25xxfd_ring_init(struct mcp25xxfd_priv *priv)
 	tx_ring = priv->tx;
 	tx_ring->head = 0;
 	tx_ring->tail = 0;
-	tx_ring->base = mcp25xxfd_get_tef_obj_addr(tx_ring->obj_num);
+	tx_ring->base = mcp251xfd_get_tef_obj_addr(tx_ring->obj_num);
 
 	/* FIFO request to send */
-	addr = MCP25XXFD_REG_FIFOCON(MCP25XXFD_TX_FIFO);
-	val = MCP25XXFD_REG_FIFOCON_TXREQ | MCP25XXFD_REG_FIFOCON_UINC;
-	len = mcp25xxfd_cmd_prepare_write_reg(priv, &tx_ring->rts_buf,
+	addr = MCP251XFD_REG_FIFOCON(MCP251XFD_TX_FIFO);
+	val = MCP251XFD_REG_FIFOCON_TXREQ | MCP251XFD_REG_FIFOCON_UINC;
+	len = mcp251xfd_cmd_prepare_write_reg(priv, &tx_ring->rts_buf,
 					      addr, val, val);
 
-	mcp25xxfd_for_each_tx_obj(tx_ring, tx_obj, i)
-		mcp25xxfd_tx_ring_init_tx_obj(priv, tx_ring, tx_obj, len, i);
+	mcp251xfd_for_each_tx_obj(tx_ring, tx_obj, i)
+		mcp251xfd_tx_ring_init_tx_obj(priv, tx_ring, tx_obj, len, i);
 
 	/* RX */
-	mcp25xxfd_for_each_rx_ring(priv, rx_ring, i) {
+	mcp251xfd_for_each_rx_ring(priv, rx_ring, i) {
 		rx_ring->head = 0;
 		rx_ring->tail = 0;
 		rx_ring->nr = i;
-		rx_ring->fifo_nr = MCP25XXFD_RX_FIFO(i);
+		rx_ring->fifo_nr = MCP251XFD_RX_FIFO(i);
 
 		if (!prev_rx_ring)
 			rx_ring->base =
-				mcp25xxfd_get_tx_obj_addr(tx_ring,
+				mcp251xfd_get_tx_obj_addr(tx_ring,
 							  tx_ring->obj_num);
 		else
 			rx_ring->base = prev_rx_ring->base +
@@ -373,7 +373,7 @@ static void mcp25xxfd_ring_init(struct mcp25xxfd_priv *priv)
 	}
 }
 
-static void mcp25xxfd_ring_free(struct mcp25xxfd_priv *priv)
+static void mcp251xfd_ring_free(struct mcp251xfd_priv *priv)
 {
 	int i;
 
@@ -383,31 +383,31 @@ static void mcp25xxfd_ring_free(struct mcp25xxfd_priv *priv)
 	}
 }
 
-static int mcp25xxfd_ring_alloc(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 {
-	struct mcp25xxfd_tx_ring *tx_ring;
-	struct mcp25xxfd_rx_ring *rx_ring;
+	struct mcp251xfd_tx_ring *tx_ring;
+	struct mcp251xfd_rx_ring *rx_ring;
 	int tef_obj_size, tx_obj_size, rx_obj_size;
 	int tx_obj_num;
 	int ram_free, i;
 
-	tef_obj_size = sizeof(struct mcp25xxfd_hw_tef_obj);
+	tef_obj_size = sizeof(struct mcp251xfd_hw_tef_obj);
 	/* listen-only mode works like FD mode */
 	if (priv->can.ctrlmode & (CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_FD)) {
-		tx_obj_num = MCP25XXFD_TX_OBJ_NUM_CANFD;
-		tx_obj_size = sizeof(struct mcp25xxfd_hw_tx_obj_canfd);
-		rx_obj_size = sizeof(struct mcp25xxfd_hw_rx_obj_canfd);
+		tx_obj_num = MCP251XFD_TX_OBJ_NUM_CANFD;
+		tx_obj_size = sizeof(struct mcp251xfd_hw_tx_obj_canfd);
+		rx_obj_size = sizeof(struct mcp251xfd_hw_rx_obj_canfd);
 	} else {
-		tx_obj_num = MCP25XXFD_TX_OBJ_NUM_CAN;
-		tx_obj_size = sizeof(struct mcp25xxfd_hw_tx_obj_can);
-		rx_obj_size = sizeof(struct mcp25xxfd_hw_rx_obj_can);
+		tx_obj_num = MCP251XFD_TX_OBJ_NUM_CAN;
+		tx_obj_size = sizeof(struct mcp251xfd_hw_tx_obj_can);
+		rx_obj_size = sizeof(struct mcp251xfd_hw_rx_obj_can);
 	}
 
 	tx_ring = priv->tx;
 	tx_ring->obj_num = tx_obj_num;
 	tx_ring->obj_size = tx_obj_size;
 
-	ram_free = MCP25XXFD_RAM_SIZE - tx_obj_num *
+	ram_free = MCP251XFD_RAM_SIZE - tx_obj_num *
 		(tef_obj_size + tx_obj_size);
 
 	for (i = 0;
@@ -421,7 +421,7 @@ static int mcp25xxfd_ring_alloc(struct mcp25xxfd_priv *priv)
 		rx_ring = kzalloc(sizeof(*rx_ring) + rx_obj_size * rx_obj_num,
 				  GFP_KERNEL);
 		if (!rx_ring) {
-			mcp25xxfd_ring_free(priv);
+			mcp251xfd_ring_free(priv);
 			return -ENOMEM;
 		}
 		rx_ring->obj_num = rx_obj_num;
@@ -437,7 +437,7 @@ static int mcp25xxfd_ring_alloc(struct mcp25xxfd_priv *priv)
 		   tx_obj_num, tef_obj_size, tef_obj_size * tx_obj_num,
 		   tx_obj_num, tx_obj_size, tx_obj_size * tx_obj_num);
 
-	mcp25xxfd_for_each_rx_ring(priv, rx_ring, i) {
+	mcp251xfd_for_each_rx_ring(priv, rx_ring, i) {
 		netdev_dbg(priv->ndev,
 			   "FIFO setup: RX-%d: %d*%d bytes = %d bytes\n",
 			   i, rx_ring->obj_num, rx_ring->obj_size,
@@ -452,48 +452,48 @@ static int mcp25xxfd_ring_alloc(struct mcp25xxfd_priv *priv)
 }
 
 static inline int
-mcp25xxfd_chip_get_mode(const struct mcp25xxfd_priv *priv, u8 *mode)
+mcp251xfd_chip_get_mode(const struct mcp251xfd_priv *priv, u8 *mode)
 {
 	u32 val;
 	int err;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_CON, &val);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_CON, &val);
 	if (err)
 		return err;
 
-	*mode = FIELD_GET(MCP25XXFD_REG_CON_OPMOD_MASK, val);
+	*mode = FIELD_GET(MCP251XFD_REG_CON_OPMOD_MASK, val);
 
 	return 0;
 }
 
 static int
-__mcp25xxfd_chip_set_mode(const struct mcp25xxfd_priv *priv,
+__mcp251xfd_chip_set_mode(const struct mcp251xfd_priv *priv,
 			  const u8 mode_req, bool nowait)
 {
 	u32 con, con_reqop;
 	int err;
 
-	con_reqop = FIELD_PREP(MCP25XXFD_REG_CON_REQOP_MASK, mode_req);
-	err = regmap_update_bits(priv->map_reg, MCP25XXFD_REG_CON,
-				 MCP25XXFD_REG_CON_REQOP_MASK, con_reqop);
+	con_reqop = FIELD_PREP(MCP251XFD_REG_CON_REQOP_MASK, mode_req);
+	err = regmap_update_bits(priv->map_reg, MCP251XFD_REG_CON,
+				 MCP251XFD_REG_CON_REQOP_MASK, con_reqop);
 	if (err)
 		return err;
 
-	if (mode_req == MCP25XXFD_REG_CON_MODE_SLEEP || nowait)
+	if (mode_req == MCP251XFD_REG_CON_MODE_SLEEP || nowait)
 		return 0;
 
-	err = regmap_read_poll_timeout(priv->map_reg, MCP25XXFD_REG_CON, con,
-				       FIELD_GET(MCP25XXFD_REG_CON_OPMOD_MASK,
+	err = regmap_read_poll_timeout(priv->map_reg, MCP251XFD_REG_CON, con,
+				       FIELD_GET(MCP251XFD_REG_CON_OPMOD_MASK,
 						 con) == mode_req,
-				       MCP25XXFD_POLL_SLEEP_US,
-				       MCP25XXFD_POLL_TIMEOUT_US);
+				       MCP251XFD_POLL_SLEEP_US,
+				       MCP251XFD_POLL_TIMEOUT_US);
 	if (err) {
-		u8 mode = FIELD_GET(MCP25XXFD_REG_CON_OPMOD_MASK, con);
+		u8 mode = FIELD_GET(MCP251XFD_REG_CON_OPMOD_MASK, con);
 
 		netdev_err(priv->ndev,
 			   "Controller failed to enter mode %s Mode (%u) and stays in %s Mode (%u).\n",
-			   mcp25xxfd_get_mode_str(mode_req), mode_req,
-			   mcp25xxfd_get_mode_str(mode), mode);
+			   mcp251xfd_get_mode_str(mode_req), mode_req,
+			   mcp251xfd_get_mode_str(mode), mode);
 		return err;
 	}
 
@@ -501,25 +501,25 @@ __mcp25xxfd_chip_set_mode(const struct mcp25xxfd_priv *priv,
 }
 
 static inline int
-mcp25xxfd_chip_set_mode(const struct mcp25xxfd_priv *priv,
+mcp251xfd_chip_set_mode(const struct mcp251xfd_priv *priv,
 			const u8 mode_req)
 {
-	return __mcp25xxfd_chip_set_mode(priv, mode_req, false);
+	return __mcp251xfd_chip_set_mode(priv, mode_req, false);
 }
 
 static inline int
-mcp25xxfd_chip_set_mode_nowait(const struct mcp25xxfd_priv *priv,
+mcp251xfd_chip_set_mode_nowait(const struct mcp251xfd_priv *priv,
 			       const u8 mode_req)
 {
-	return __mcp25xxfd_chip_set_mode(priv, mode_req, true);
+	return __mcp251xfd_chip_set_mode(priv, mode_req, true);
 }
 
-static inline bool mcp25xxfd_osc_invalid(u32 reg)
+static inline bool mcp251xfd_osc_invalid(u32 reg)
 {
 	return reg == 0x0 || reg == 0xffffffff;
 }
 
-static int mcp25xxfd_chip_clock_enable(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_clock_enable(const struct mcp251xfd_priv *priv)
 {
 	u32 osc, osc_reference, osc_mask;
 	int err;
@@ -527,10 +527,10 @@ static int mcp25xxfd_chip_clock_enable(const struct mcp25xxfd_priv *priv)
 	/* Set Power On Defaults for "Clock Output Divisor" and remove
 	 * "Oscillator Disable" bit.
 	 */
-	osc = FIELD_PREP(MCP25XXFD_REG_OSC_CLKODIV_MASK,
-			 MCP25XXFD_REG_OSC_CLKODIV_10);
-	osc_reference = MCP25XXFD_REG_OSC_OSCRDY;
-	osc_mask = MCP25XXFD_REG_OSC_OSCRDY | MCP25XXFD_REG_OSC_PLLRDY;
+	osc = FIELD_PREP(MCP251XFD_REG_OSC_CLKODIV_MASK,
+			 MCP251XFD_REG_OSC_CLKODIV_10);
+	osc_reference = MCP251XFD_REG_OSC_OSCRDY;
+	osc_mask = MCP251XFD_REG_OSC_OSCRDY | MCP251XFD_REG_OSC_PLLRDY;
 
 	/* Note:
 	 *
@@ -538,19 +538,19 @@ static int mcp25xxfd_chip_clock_enable(const struct mcp25xxfd_priv *priv)
 	 * removes the "Oscillator Disable" bit and powers it up. All
 	 * other bits are unaffected.
 	 */
-	err = regmap_write(priv->map_reg, MCP25XXFD_REG_OSC, osc);
+	err = regmap_write(priv->map_reg, MCP251XFD_REG_OSC, osc);
 	if (err)
 		return err;
 
 	/* Wait for "Oscillator Ready" bit */
-	err = regmap_read_poll_timeout(priv->map_reg, MCP25XXFD_REG_OSC, osc,
+	err = regmap_read_poll_timeout(priv->map_reg, MCP251XFD_REG_OSC, osc,
 				       (osc & osc_mask) == osc_reference,
-				       MCP25XXFD_OSC_STAB_SLEEP_US,
-				       MCP25XXFD_OSC_STAB_TIMEOUT_US);
-	if (mcp25xxfd_osc_invalid(osc)) {
+				       MCP251XFD_OSC_STAB_SLEEP_US,
+				       MCP251XFD_OSC_STAB_TIMEOUT_US);
+	if (mcp251xfd_osc_invalid(osc)) {
 		netdev_err(priv->ndev,
 			   "Failed to detect %s (osc=0x%08x).\n",
-			   mcp25xxfd_get_model_str(priv), osc);
+			   mcp251xfd_get_model_str(priv), osc);
 		return -ENODEV;
 	} else if (err == -ETIMEDOUT) {
 		netdev_err(priv->ndev,
@@ -564,19 +564,19 @@ static int mcp25xxfd_chip_clock_enable(const struct mcp25xxfd_priv *priv)
 	return 0;
 }
 
-static int mcp25xxfd_chip_softreset_do(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_softreset_do(const struct mcp251xfd_priv *priv)
 {
-	const __be16 cmd = mcp25xxfd_cmd_reset();
+	const __be16 cmd = mcp251xfd_cmd_reset();
 	int err;
 
 	/* The Set Mode and SPI Reset command only seems to works if
 	 * the controller is not in Sleep Mode.
 	 */
-	err = mcp25xxfd_chip_clock_enable(priv);
+	err = mcp251xfd_chip_clock_enable(priv);
 	if (err)
 		return err;
 
-	err = mcp25xxfd_chip_set_mode(priv, MCP25XXFD_REG_CON_MODE_CONFIG);
+	err = mcp251xfd_chip_set_mode(priv, MCP251XFD_REG_CON_MODE_CONFIG);
 	if (err)
 		return err;
 
@@ -584,29 +584,29 @@ static int mcp25xxfd_chip_softreset_do(const struct mcp25xxfd_priv *priv)
 	return spi_write_then_read(priv->spi, &cmd, sizeof(cmd), NULL, 0);
 }
 
-static int mcp25xxfd_chip_softreset_check(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_softreset_check(const struct mcp251xfd_priv *priv)
 {
 	u32 osc, osc_reference;
 	u8 mode;
 	int err;
 
-	err = mcp25xxfd_chip_get_mode(priv, &mode);
+	err = mcp251xfd_chip_get_mode(priv, &mode);
 	if (err)
 		return err;
 
-	if (mode != MCP25XXFD_REG_CON_MODE_CONFIG) {
+	if (mode != MCP251XFD_REG_CON_MODE_CONFIG) {
 		netdev_info(priv->ndev,
 			    "Controller not in Config Mode after reset, but in %s Mode (%u).\n",
-			    mcp25xxfd_get_mode_str(mode), mode);
+			    mcp251xfd_get_mode_str(mode), mode);
 		return -ETIMEDOUT;
 	}
 
-	osc_reference = MCP25XXFD_REG_OSC_OSCRDY |
-		FIELD_PREP(MCP25XXFD_REG_OSC_CLKODIV_MASK,
-			   MCP25XXFD_REG_OSC_CLKODIV_10);
+	osc_reference = MCP251XFD_REG_OSC_OSCRDY |
+		FIELD_PREP(MCP251XFD_REG_OSC_CLKODIV_MASK,
+			   MCP251XFD_REG_OSC_CLKODIV_10);
 
 	/* check reset defaults of OSC reg */
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_OSC, &osc);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_OSC, &osc);
 	if (err)
 		return err;
 
@@ -620,22 +620,22 @@ static int mcp25xxfd_chip_softreset_check(const struct mcp25xxfd_priv *priv)
 	return 0;
 }
 
-static int mcp25xxfd_chip_softreset(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_softreset(const struct mcp251xfd_priv *priv)
 {
 	int err, i;
 
-	for (i = 0; i < MCP25XXFD_SOFTRESET_RETRIES_MAX; i++) {
+	for (i = 0; i < MCP251XFD_SOFTRESET_RETRIES_MAX; i++) {
 		if (i)
 			netdev_info(priv->ndev,
 				    "Retrying to reset Controller.\n");
 
-		err = mcp25xxfd_chip_softreset_do(priv);
+		err = mcp251xfd_chip_softreset_do(priv);
 		if (err == -ETIMEDOUT)
 			continue;
 		if (err)
 			return err;
 
-		err = mcp25xxfd_chip_softreset_check(priv);
+		err = mcp251xfd_chip_softreset_check(priv);
 		if (err == -ETIMEDOUT)
 			continue;
 		if (err)
@@ -650,7 +650,7 @@ static int mcp25xxfd_chip_softreset(const struct mcp25xxfd_priv *priv)
 	return -ETIMEDOUT;
 }
 
-static int mcp25xxfd_chip_clock_init(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_clock_init(const struct mcp251xfd_priv *priv)
 {
 	u32 osc;
 	int err;
@@ -659,10 +659,10 @@ static int mcp25xxfd_chip_clock_init(const struct mcp25xxfd_priv *priv)
 	 * works on the MCP2518FD. The MCP2517FD will go into normal
 	 * Sleep Mode instead.
 	 */
-	osc = MCP25XXFD_REG_OSC_LPMEN |
-		FIELD_PREP(MCP25XXFD_REG_OSC_CLKODIV_MASK,
-			   MCP25XXFD_REG_OSC_CLKODIV_10);
-	err = regmap_write(priv->map_reg, MCP25XXFD_REG_OSC, osc);
+	osc = MCP251XFD_REG_OSC_LPMEN |
+		FIELD_PREP(MCP251XFD_REG_OSC_CLKODIV_MASK,
+			   MCP251XFD_REG_OSC_CLKODIV_10);
+	err = regmap_write(priv->map_reg, MCP251XFD_REG_OSC, osc);
 	if (err)
 		return err;
 
@@ -671,11 +671,11 @@ static int mcp25xxfd_chip_clock_init(const struct mcp25xxfd_priv *priv)
 	 * This means an overflow of the 32 bit Time Base Counter
 	 * register at 40 MHz every 107 seconds.
 	 */
-	return regmap_write(priv->map_reg, MCP25XXFD_REG_TSCON,
-			    MCP25XXFD_REG_TSCON_TBCEN);
+	return regmap_write(priv->map_reg, MCP251XFD_REG_TSCON,
+			    MCP251XFD_REG_TSCON_TBCEN);
 }
 
-static int mcp25xxfd_set_bittiming(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_set_bittiming(const struct mcp251xfd_priv *priv)
 {
 	const struct can_bittiming *bt = &priv->can.bittiming;
 	const struct can_bittiming *dbt = &priv->can.data_bittiming;
@@ -699,32 +699,32 @@ static int mcp25xxfd_set_bittiming(const struct mcp25xxfd_priv *priv)
 	 * - protocol exception is treated as a form error
 	 * - Do not compare data bytes
 	 */
-	val = FIELD_PREP(MCP25XXFD_REG_CON_REQOP_MASK,
-			 MCP25XXFD_REG_CON_MODE_CONFIG) |
-		MCP25XXFD_REG_CON_STEF |
-		MCP25XXFD_REG_CON_ESIGM |
-		MCP25XXFD_REG_CON_RTXAT |
-		FIELD_PREP(MCP25XXFD_REG_CON_WFT_MASK,
-			   MCP25XXFD_REG_CON_WFT_T11FILTER) |
-		MCP25XXFD_REG_CON_WAKFIL |
-		MCP25XXFD_REG_CON_PXEDIS;
+	val = FIELD_PREP(MCP251XFD_REG_CON_REQOP_MASK,
+			 MCP251XFD_REG_CON_MODE_CONFIG) |
+		MCP251XFD_REG_CON_STEF |
+		MCP251XFD_REG_CON_ESIGM |
+		MCP251XFD_REG_CON_RTXAT |
+		FIELD_PREP(MCP251XFD_REG_CON_WFT_MASK,
+			   MCP251XFD_REG_CON_WFT_T11FILTER) |
+		MCP251XFD_REG_CON_WAKFIL |
+		MCP251XFD_REG_CON_PXEDIS;
 
 	if (!(priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO))
-		val |= MCP25XXFD_REG_CON_ISOCRCEN;
+		val |= MCP251XFD_REG_CON_ISOCRCEN;
 
-	err = regmap_write(priv->map_reg, MCP25XXFD_REG_CON, val);
+	err = regmap_write(priv->map_reg, MCP251XFD_REG_CON, val);
 	if (err)
 		return err;
 
 	/* Nominal Bit Time */
-	val = FIELD_PREP(MCP25XXFD_REG_NBTCFG_BRP_MASK, bt->brp - 1) |
-		FIELD_PREP(MCP25XXFD_REG_NBTCFG_TSEG1_MASK,
+	val = FIELD_PREP(MCP251XFD_REG_NBTCFG_BRP_MASK, bt->brp - 1) |
+		FIELD_PREP(MCP251XFD_REG_NBTCFG_TSEG1_MASK,
 			   bt->prop_seg + bt->phase_seg1 - 1) |
-		FIELD_PREP(MCP25XXFD_REG_NBTCFG_TSEG2_MASK,
+		FIELD_PREP(MCP251XFD_REG_NBTCFG_TSEG2_MASK,
 			   bt->phase_seg2 - 1) |
-		FIELD_PREP(MCP25XXFD_REG_NBTCFG_SJW_MASK, bt->sjw - 1);
+		FIELD_PREP(MCP251XFD_REG_NBTCFG_SJW_MASK, bt->sjw - 1);
 
-	err = regmap_write(priv->map_reg, MCP25XXFD_REG_NBTCFG, val);
+	err = regmap_write(priv->map_reg, MCP251XFD_REG_NBTCFG, val);
 	if (err)
 		return err;
 
@@ -732,28 +732,28 @@ static int mcp25xxfd_set_bittiming(const struct mcp25xxfd_priv *priv)
 		return 0;
 
 	/* Data Bit Time */
-	val = FIELD_PREP(MCP25XXFD_REG_DBTCFG_BRP_MASK, dbt->brp - 1) |
-		FIELD_PREP(MCP25XXFD_REG_DBTCFG_TSEG1_MASK,
+	val = FIELD_PREP(MCP251XFD_REG_DBTCFG_BRP_MASK, dbt->brp - 1) |
+		FIELD_PREP(MCP251XFD_REG_DBTCFG_TSEG1_MASK,
 			   dbt->prop_seg + dbt->phase_seg1 - 1) |
-		FIELD_PREP(MCP25XXFD_REG_DBTCFG_TSEG2_MASK,
+		FIELD_PREP(MCP251XFD_REG_DBTCFG_TSEG2_MASK,
 			   dbt->phase_seg2 - 1) |
-		FIELD_PREP(MCP25XXFD_REG_DBTCFG_SJW_MASK, dbt->sjw - 1);
+		FIELD_PREP(MCP251XFD_REG_DBTCFG_SJW_MASK, dbt->sjw - 1);
 
-	err = regmap_write(priv->map_reg, MCP25XXFD_REG_DBTCFG, val);
+	err = regmap_write(priv->map_reg, MCP251XFD_REG_DBTCFG, val);
 	if (err)
 		return err;
 
 	/* Transmitter Delay Compensation */
 	tdco = clamp_t(int, dbt->brp * (dbt->prop_seg + dbt->phase_seg1),
 		       -64, 63);
-	val = FIELD_PREP(MCP25XXFD_REG_TDC_TDCMOD_MASK,
-			 MCP25XXFD_REG_TDC_TDCMOD_AUTO) |
-		FIELD_PREP(MCP25XXFD_REG_TDC_TDCO_MASK, tdco);
+	val = FIELD_PREP(MCP251XFD_REG_TDC_TDCMOD_MASK,
+			 MCP251XFD_REG_TDC_TDCMOD_AUTO) |
+		FIELD_PREP(MCP251XFD_REG_TDC_TDCO_MASK, tdco);
 
-	return regmap_write(priv->map_reg, MCP25XXFD_REG_TDC, val);
+	return regmap_write(priv->map_reg, MCP251XFD_REG_TDC, val);
 }
 
-static int mcp25xxfd_chip_rx_int_enable(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_rx_int_enable(const struct mcp251xfd_priv *priv)
 {
 	u32 val;
 
@@ -769,12 +769,12 @@ static int mcp25xxfd_chip_rx_int_enable(const struct mcp25xxfd_priv *priv)
 	 * (in the first byte of the SPI transfer) and configuring the
 	 * PIN as interrupt (in the last byte of the SPI transfer).
 	 */
-	val = MCP25XXFD_REG_IOCON_PM0 | MCP25XXFD_REG_IOCON_TRIS1 |
-		MCP25XXFD_REG_IOCON_TRIS0;
-	return regmap_write(priv->map_reg, MCP25XXFD_REG_IOCON, val);
+	val = MCP251XFD_REG_IOCON_PM0 | MCP251XFD_REG_IOCON_TRIS1 |
+		MCP251XFD_REG_IOCON_TRIS0;
+	return regmap_write(priv->map_reg, MCP251XFD_REG_IOCON, val);
 }
 
-static int mcp25xxfd_chip_rx_int_disable(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_rx_int_disable(const struct mcp251xfd_priv *priv)
 {
 	u32 val;
 
@@ -785,14 +785,14 @@ static int mcp25xxfd_chip_rx_int_disable(const struct mcp25xxfd_priv *priv)
 	 * - PIN0: GPIO Input
 	 * - PIN1: GPIO Input
 	 */
-	val = MCP25XXFD_REG_IOCON_PM1 | MCP25XXFD_REG_IOCON_PM0 |
-		MCP25XXFD_REG_IOCON_TRIS1 | MCP25XXFD_REG_IOCON_TRIS0;
-	return regmap_write(priv->map_reg, MCP25XXFD_REG_IOCON, val);
+	val = MCP251XFD_REG_IOCON_PM1 | MCP251XFD_REG_IOCON_PM0 |
+		MCP251XFD_REG_IOCON_TRIS1 | MCP251XFD_REG_IOCON_TRIS0;
+	return regmap_write(priv->map_reg, MCP251XFD_REG_IOCON, val);
 }
 
 static int
-mcp25xxfd_chip_rx_fifo_init_one(const struct mcp25xxfd_priv *priv,
-				const struct mcp25xxfd_rx_ring *ring)
+mcp251xfd_chip_rx_fifo_init_one(const struct mcp251xfd_priv *priv,
+				const struct mcp251xfd_rx_ring *ring)
 {
 	u32 fifo_con;
 
@@ -802,89 +802,89 @@ mcp25xxfd_chip_rx_fifo_init_one(const struct mcp25xxfd_priv *priv,
 	 * generate a RXOVIF, use this to properly detect RX MAB
 	 * overflows.
 	 */
-	fifo_con = FIELD_PREP(MCP25XXFD_REG_FIFOCON_FSIZE_MASK,
+	fifo_con = FIELD_PREP(MCP251XFD_REG_FIFOCON_FSIZE_MASK,
 			      ring->obj_num - 1) |
-		MCP25XXFD_REG_FIFOCON_RXTSEN |
-		MCP25XXFD_REG_FIFOCON_RXOVIE |
-		MCP25XXFD_REG_FIFOCON_TFNRFNIE;
+		MCP251XFD_REG_FIFOCON_RXTSEN |
+		MCP251XFD_REG_FIFOCON_RXOVIE |
+		MCP251XFD_REG_FIFOCON_TFNRFNIE;
 
 	if (priv->can.ctrlmode & (CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_FD))
-		fifo_con |= FIELD_PREP(MCP25XXFD_REG_FIFOCON_PLSIZE_MASK,
-				       MCP25XXFD_REG_FIFOCON_PLSIZE_64);
+		fifo_con |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
+				       MCP251XFD_REG_FIFOCON_PLSIZE_64);
 	else
-		fifo_con |= FIELD_PREP(MCP25XXFD_REG_FIFOCON_PLSIZE_MASK,
-				       MCP25XXFD_REG_FIFOCON_PLSIZE_8);
+		fifo_con |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
+				       MCP251XFD_REG_FIFOCON_PLSIZE_8);
 
 	return regmap_write(priv->map_reg,
-			    MCP25XXFD_REG_FIFOCON(ring->fifo_nr), fifo_con);
+			    MCP251XFD_REG_FIFOCON(ring->fifo_nr), fifo_con);
 }
 
 static int
-mcp25xxfd_chip_rx_filter_init_one(const struct mcp25xxfd_priv *priv,
-				  const struct mcp25xxfd_rx_ring *ring)
+mcp251xfd_chip_rx_filter_init_one(const struct mcp251xfd_priv *priv,
+				  const struct mcp251xfd_rx_ring *ring)
 {
 	u32 fltcon;
 
-	fltcon = MCP25XXFD_REG_FLTCON_FLTEN(ring->nr) |
-		MCP25XXFD_REG_FLTCON_FBP(ring->nr, ring->fifo_nr);
+	fltcon = MCP251XFD_REG_FLTCON_FLTEN(ring->nr) |
+		MCP251XFD_REG_FLTCON_FBP(ring->nr, ring->fifo_nr);
 
 	return regmap_update_bits(priv->map_reg,
-				  MCP25XXFD_REG_FLTCON(ring->nr >> 2),
-				  MCP25XXFD_REG_FLTCON_FLT_MASK(ring->nr),
+				  MCP251XFD_REG_FLTCON(ring->nr >> 2),
+				  MCP251XFD_REG_FLTCON_FLT_MASK(ring->nr),
 				  fltcon);
 }
 
-static int mcp25xxfd_chip_fifo_init(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_fifo_init(const struct mcp251xfd_priv *priv)
 {
-	const struct mcp25xxfd_tx_ring *tx_ring = priv->tx;
-	const struct mcp25xxfd_rx_ring *rx_ring;
+	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+	const struct mcp251xfd_rx_ring *rx_ring;
 	u32 val;
 	int err, n;
 
 	/* TEF */
-	val = FIELD_PREP(MCP25XXFD_REG_TEFCON_FSIZE_MASK,
+	val = FIELD_PREP(MCP251XFD_REG_TEFCON_FSIZE_MASK,
 			 tx_ring->obj_num - 1) |
-		MCP25XXFD_REG_TEFCON_TEFTSEN |
-		MCP25XXFD_REG_TEFCON_TEFOVIE |
-		MCP25XXFD_REG_TEFCON_TEFNEIE;
+		MCP251XFD_REG_TEFCON_TEFTSEN |
+		MCP251XFD_REG_TEFCON_TEFOVIE |
+		MCP251XFD_REG_TEFCON_TEFNEIE;
 
-	err = regmap_write(priv->map_reg, MCP25XXFD_REG_TEFCON, val);
+	err = regmap_write(priv->map_reg, MCP251XFD_REG_TEFCON, val);
 	if (err)
 		return err;
 
 	/* FIFO 1 - TX */
-	val = FIELD_PREP(MCP25XXFD_REG_FIFOCON_FSIZE_MASK,
+	val = FIELD_PREP(MCP251XFD_REG_FIFOCON_FSIZE_MASK,
 			 tx_ring->obj_num - 1) |
-		MCP25XXFD_REG_FIFOCON_TXEN |
-		MCP25XXFD_REG_FIFOCON_TXATIE;
+		MCP251XFD_REG_FIFOCON_TXEN |
+		MCP251XFD_REG_FIFOCON_TXATIE;
 
 	if (priv->can.ctrlmode & (CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_FD))
-		val |= FIELD_PREP(MCP25XXFD_REG_FIFOCON_PLSIZE_MASK,
-				  MCP25XXFD_REG_FIFOCON_PLSIZE_64);
+		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
+				  MCP251XFD_REG_FIFOCON_PLSIZE_64);
 	else
-		val |= FIELD_PREP(MCP25XXFD_REG_FIFOCON_PLSIZE_MASK,
-				  MCP25XXFD_REG_FIFOCON_PLSIZE_8);
+		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_PLSIZE_MASK,
+				  MCP251XFD_REG_FIFOCON_PLSIZE_8);
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
-		val |= FIELD_PREP(MCP25XXFD_REG_FIFOCON_TXAT_MASK,
-				  MCP25XXFD_REG_FIFOCON_TXAT_ONE_SHOT);
+		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_TXAT_MASK,
+				  MCP251XFD_REG_FIFOCON_TXAT_ONE_SHOT);
 	else
-		val |= FIELD_PREP(MCP25XXFD_REG_FIFOCON_TXAT_MASK,
-				  MCP25XXFD_REG_FIFOCON_TXAT_UNLIMITED);
+		val |= FIELD_PREP(MCP251XFD_REG_FIFOCON_TXAT_MASK,
+				  MCP251XFD_REG_FIFOCON_TXAT_UNLIMITED);
 
 	err = regmap_write(priv->map_reg,
-			   MCP25XXFD_REG_FIFOCON(MCP25XXFD_TX_FIFO),
+			   MCP251XFD_REG_FIFOCON(MCP251XFD_TX_FIFO),
 			   val);
 	if (err)
 		return err;
 
 	/* RX FIFOs */
-	mcp25xxfd_for_each_rx_ring(priv, rx_ring, n) {
-		err = mcp25xxfd_chip_rx_fifo_init_one(priv, rx_ring);
+	mcp251xfd_for_each_rx_ring(priv, rx_ring, n) {
+		err = mcp251xfd_chip_rx_fifo_init_one(priv, rx_ring);
 		if (err)
 			return err;
 
-		err = mcp25xxfd_chip_rx_filter_init_one(priv, rx_ring);
+		err = mcp251xfd_chip_rx_filter_init_one(priv, rx_ring);
 		if (err)
 			return err;
 	}
@@ -892,195 +892,195 @@ static int mcp25xxfd_chip_fifo_init(const struct mcp25xxfd_priv *priv)
 	return 0;
 }
 
-static int mcp25xxfd_chip_ecc_init(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_ecc_init(struct mcp251xfd_priv *priv)
 {
-	struct mcp25xxfd_ecc *ecc = &priv->ecc;
+	struct mcp251xfd_ecc *ecc = &priv->ecc;
 	void *ram;
 	u32 val = 0;
 	int err;
 
 	ecc->ecc_stat = 0;
 
-	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_ECC)
-		val = MCP25XXFD_REG_ECCCON_ECCEN;
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_ECC)
+		val = MCP251XFD_REG_ECCCON_ECCEN;
 
-	err = regmap_update_bits(priv->map_reg, MCP25XXFD_REG_ECCCON,
-				 MCP25XXFD_REG_ECCCON_ECCEN, val);
+	err = regmap_update_bits(priv->map_reg, MCP251XFD_REG_ECCCON,
+				 MCP251XFD_REG_ECCCON_ECCEN, val);
 	if (err)
 		return err;
 
-	ram = kzalloc(MCP25XXFD_RAM_SIZE, GFP_KERNEL);
+	ram = kzalloc(MCP251XFD_RAM_SIZE, GFP_KERNEL);
 	if (!ram)
 		return -ENOMEM;
 
-	err = regmap_raw_write(priv->map_reg, MCP25XXFD_RAM_START, ram,
-			       MCP25XXFD_RAM_SIZE);
+	err = regmap_raw_write(priv->map_reg, MCP251XFD_RAM_START, ram,
+			       MCP251XFD_RAM_SIZE);
 	kfree(ram);
 
 	return err;
 }
 
-static inline void mcp25xxfd_ecc_tefif_successful(struct mcp25xxfd_priv *priv)
+static inline void mcp251xfd_ecc_tefif_successful(struct mcp251xfd_priv *priv)
 {
-	struct mcp25xxfd_ecc *ecc = &priv->ecc;
+	struct mcp251xfd_ecc *ecc = &priv->ecc;
 
 	ecc->ecc_stat = 0;
 }
 
-static u8 mcp25xxfd_get_normal_mode(const struct mcp25xxfd_priv *priv)
+static u8 mcp251xfd_get_normal_mode(const struct mcp251xfd_priv *priv)
 {
 	u8 mode;
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
-		mode = MCP25XXFD_REG_CON_MODE_LISTENONLY;
+		mode = MCP251XFD_REG_CON_MODE_LISTENONLY;
 	else if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
-		mode = MCP25XXFD_REG_CON_MODE_MIXED;
+		mode = MCP251XFD_REG_CON_MODE_MIXED;
 	else
-		mode = MCP25XXFD_REG_CON_MODE_CAN2_0;
+		mode = MCP251XFD_REG_CON_MODE_CAN2_0;
 
 	return mode;
 }
 
 static int
-__mcp25xxfd_chip_set_normal_mode(const struct mcp25xxfd_priv *priv,
+__mcp251xfd_chip_set_normal_mode(const struct mcp251xfd_priv *priv,
 				 bool nowait)
 {
 	u8 mode;
 
-	mode = mcp25xxfd_get_normal_mode(priv);
+	mode = mcp251xfd_get_normal_mode(priv);
 
-	return __mcp25xxfd_chip_set_mode(priv, mode, nowait);
+	return __mcp251xfd_chip_set_mode(priv, mode, nowait);
 }
 
 static inline int
-mcp25xxfd_chip_set_normal_mode(const struct mcp25xxfd_priv *priv)
+mcp251xfd_chip_set_normal_mode(const struct mcp251xfd_priv *priv)
 {
-	return __mcp25xxfd_chip_set_normal_mode(priv, false);
+	return __mcp251xfd_chip_set_normal_mode(priv, false);
 }
 
 static inline int
-mcp25xxfd_chip_set_normal_mode_nowait(const struct mcp25xxfd_priv *priv)
+mcp251xfd_chip_set_normal_mode_nowait(const struct mcp251xfd_priv *priv)
 {
-	return __mcp25xxfd_chip_set_normal_mode(priv, true);
+	return __mcp251xfd_chip_set_normal_mode(priv, true);
 }
 
-static int mcp25xxfd_chip_interrupts_enable(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_interrupts_enable(const struct mcp251xfd_priv *priv)
 {
 	u32 val;
 	int err;
 
-	val = MCP25XXFD_REG_CRC_FERRIE | MCP25XXFD_REG_CRC_CRCERRIE;
-	err = regmap_write(priv->map_reg, MCP25XXFD_REG_CRC, val);
+	val = MCP251XFD_REG_CRC_FERRIE | MCP251XFD_REG_CRC_CRCERRIE;
+	err = regmap_write(priv->map_reg, MCP251XFD_REG_CRC, val);
 	if (err)
 		return err;
 
-	val = MCP25XXFD_REG_ECCCON_DEDIE | MCP25XXFD_REG_ECCCON_SECIE;
-	err = regmap_update_bits(priv->map_reg, MCP25XXFD_REG_ECCCON, val, val);
+	val = MCP251XFD_REG_ECCCON_DEDIE | MCP251XFD_REG_ECCCON_SECIE;
+	err = regmap_update_bits(priv->map_reg, MCP251XFD_REG_ECCCON, val, val);
 	if (err)
 		return err;
 
-	val = MCP25XXFD_REG_INT_CERRIE |
-		MCP25XXFD_REG_INT_SERRIE |
-		MCP25XXFD_REG_INT_RXOVIE |
-		MCP25XXFD_REG_INT_TXATIE |
-		MCP25XXFD_REG_INT_SPICRCIE |
-		MCP25XXFD_REG_INT_ECCIE |
-		MCP25XXFD_REG_INT_TEFIE |
-		MCP25XXFD_REG_INT_MODIE |
-		MCP25XXFD_REG_INT_RXIE;
+	val = MCP251XFD_REG_INT_CERRIE |
+		MCP251XFD_REG_INT_SERRIE |
+		MCP251XFD_REG_INT_RXOVIE |
+		MCP251XFD_REG_INT_TXATIE |
+		MCP251XFD_REG_INT_SPICRCIE |
+		MCP251XFD_REG_INT_ECCIE |
+		MCP251XFD_REG_INT_TEFIE |
+		MCP251XFD_REG_INT_MODIE |
+		MCP251XFD_REG_INT_RXIE;
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)
-		val |= MCP25XXFD_REG_INT_IVMIE;
+		val |= MCP251XFD_REG_INT_IVMIE;
 
-	return regmap_write(priv->map_reg, MCP25XXFD_REG_INT, val);
+	return regmap_write(priv->map_reg, MCP251XFD_REG_INT, val);
 }
 
-static int mcp25xxfd_chip_interrupts_disable(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_interrupts_disable(const struct mcp251xfd_priv *priv)
 {
 	int err;
 	u32 mask;
 
-	err = regmap_write(priv->map_reg, MCP25XXFD_REG_INT, 0);
+	err = regmap_write(priv->map_reg, MCP251XFD_REG_INT, 0);
 	if (err)
 		return err;
 
-	mask = MCP25XXFD_REG_ECCCON_DEDIE | MCP25XXFD_REG_ECCCON_SECIE;
-	err = regmap_update_bits(priv->map_reg, MCP25XXFD_REG_ECCCON,
+	mask = MCP251XFD_REG_ECCCON_DEDIE | MCP251XFD_REG_ECCCON_SECIE;
+	err = regmap_update_bits(priv->map_reg, MCP251XFD_REG_ECCCON,
 				 mask, 0x0);
 	if (err)
 		return err;
 
-	return regmap_write(priv->map_reg, MCP25XXFD_REG_CRC, 0);
+	return regmap_write(priv->map_reg, MCP251XFD_REG_CRC, 0);
 }
 
-static int mcp25xxfd_chip_stop(struct mcp25xxfd_priv *priv,
+static int mcp251xfd_chip_stop(struct mcp251xfd_priv *priv,
 			       const enum can_state state)
 {
 	priv->can.state = state;
 
-	mcp25xxfd_chip_interrupts_disable(priv);
-	mcp25xxfd_chip_rx_int_disable(priv);
-	return mcp25xxfd_chip_set_mode(priv, MCP25XXFD_REG_CON_MODE_SLEEP);
+	mcp251xfd_chip_interrupts_disable(priv);
+	mcp251xfd_chip_rx_int_disable(priv);
+	return mcp251xfd_chip_set_mode(priv, MCP251XFD_REG_CON_MODE_SLEEP);
 }
 
-static int mcp25xxfd_chip_start(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_chip_start(struct mcp251xfd_priv *priv)
 {
 	int err;
 
-	err = mcp25xxfd_chip_softreset(priv);
+	err = mcp251xfd_chip_softreset(priv);
 	if (err)
 		goto out_chip_stop;
 
-	err = mcp25xxfd_chip_clock_init(priv);
+	err = mcp251xfd_chip_clock_init(priv);
 	if (err)
 		goto out_chip_stop;
 
-	err = mcp25xxfd_set_bittiming(priv);
+	err = mcp251xfd_set_bittiming(priv);
 	if (err)
 		goto out_chip_stop;
 
-	err = mcp25xxfd_chip_rx_int_enable(priv);
+	err = mcp251xfd_chip_rx_int_enable(priv);
 	if (err)
 		return err;
 
-	err = mcp25xxfd_chip_ecc_init(priv);
+	err = mcp251xfd_chip_ecc_init(priv);
 	if (err)
 		goto out_chip_stop;
 
-	mcp25xxfd_ring_init(priv);
+	mcp251xfd_ring_init(priv);
 
-	err = mcp25xxfd_chip_fifo_init(priv);
+	err = mcp251xfd_chip_fifo_init(priv);
 	if (err)
 		goto out_chip_stop;
 
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
-	err = mcp25xxfd_chip_set_normal_mode(priv);
+	err = mcp251xfd_chip_set_normal_mode(priv);
 	if (err)
 		goto out_chip_stop;
 
 	return 0;
 
  out_chip_stop:
-	mcp25xxfd_chip_stop(priv, CAN_STATE_STOPPED);
+	mcp251xfd_chip_stop(priv, CAN_STATE_STOPPED);
 
 	return err;
 }
 
-static int mcp25xxfd_set_mode(struct net_device *ndev, enum can_mode mode)
+static int mcp251xfd_set_mode(struct net_device *ndev, enum can_mode mode)
 {
-	struct mcp25xxfd_priv *priv = netdev_priv(ndev);
+	struct mcp251xfd_priv *priv = netdev_priv(ndev);
 	int err;
 
 	switch (mode) {
 	case CAN_MODE_START:
-		err = mcp25xxfd_chip_start(priv);
+		err = mcp251xfd_chip_start(priv);
 		if (err)
 			return err;
 
-		err = mcp25xxfd_chip_interrupts_enable(priv);
+		err = mcp251xfd_chip_interrupts_enable(priv);
 		if (err) {
-			mcp25xxfd_chip_stop(priv, CAN_STATE_STOPPED);
+			mcp251xfd_chip_stop(priv, CAN_STATE_STOPPED);
 			return err;
 		}
 
@@ -1094,30 +1094,30 @@ static int mcp25xxfd_set_mode(struct net_device *ndev, enum can_mode mode)
 	return 0;
 }
 
-static int __mcp25xxfd_get_berr_counter(const struct net_device *ndev,
+static int __mcp251xfd_get_berr_counter(const struct net_device *ndev,
 					struct can_berr_counter *bec)
 {
-	const struct mcp25xxfd_priv *priv = netdev_priv(ndev);
+	const struct mcp251xfd_priv *priv = netdev_priv(ndev);
 	u32 trec;
 	int err;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_TREC, &trec);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_TREC, &trec);
 	if (err)
 		return err;
 
-	if (trec & MCP25XXFD_REG_TREC_TXBO)
+	if (trec & MCP251XFD_REG_TREC_TXBO)
 		bec->txerr = 256;
 	else
-		bec->txerr = FIELD_GET(MCP25XXFD_REG_TREC_TEC_MASK, trec);
-	bec->rxerr = FIELD_GET(MCP25XXFD_REG_TREC_REC_MASK, trec);
+		bec->txerr = FIELD_GET(MCP251XFD_REG_TREC_TEC_MASK, trec);
+	bec->rxerr = FIELD_GET(MCP251XFD_REG_TREC_REC_MASK, trec);
 
 	return 0;
 }
 
-static int mcp25xxfd_get_berr_counter(const struct net_device *ndev,
+static int mcp251xfd_get_berr_counter(const struct net_device *ndev,
 				      struct can_berr_counter *bec)
 {
-	const struct mcp25xxfd_priv *priv = netdev_priv(ndev);
+	const struct mcp251xfd_priv *priv = netdev_priv(ndev);
 
 	/* Avoid waking up the controller if the interface is down */
 	if (!(ndev->flags & IFF_UP))
@@ -1131,22 +1131,22 @@ static int mcp25xxfd_get_berr_counter(const struct net_device *ndev,
 		return 0;
 	}
 
-	return __mcp25xxfd_get_berr_counter(ndev, bec);
+	return __mcp251xfd_get_berr_counter(ndev, bec);
 }
 
-static int mcp25xxfd_check_tef_tail(const struct mcp25xxfd_priv *priv)
+static int mcp251xfd_check_tef_tail(const struct mcp251xfd_priv *priv)
 {
 	u8 tef_tail_chip, tef_tail;
 	int err;
 
-	if (!IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY))
+	if (!IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY))
 		return 0;
 
-	err = mcp25xxfd_tef_tail_get_from_chip(priv, &tef_tail_chip);
+	err = mcp251xfd_tef_tail_get_from_chip(priv, &tef_tail_chip);
 	if (err)
 		return err;
 
-	tef_tail = mcp25xxfd_get_tef_tail(priv);
+	tef_tail = mcp251xfd_get_tef_tail(priv);
 	if (tef_tail_chip != tef_tail) {
 		netdev_err(priv->ndev,
 			   "TEF tail of chip (0x%02x) and ours (0x%08x) inconsistent.\n",
@@ -1158,20 +1158,20 @@ static int mcp25xxfd_check_tef_tail(const struct mcp25xxfd_priv *priv)
 }
 
 static int
-mcp25xxfd_check_rx_tail(const struct mcp25xxfd_priv *priv,
-			const struct mcp25xxfd_rx_ring *ring)
+mcp251xfd_check_rx_tail(const struct mcp251xfd_priv *priv,
+			const struct mcp251xfd_rx_ring *ring)
 {
 	u8 rx_tail_chip, rx_tail;
 	int err;
 
-	if (!IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY))
+	if (!IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY))
 		return 0;
 
-	err = mcp25xxfd_rx_tail_get_from_chip(priv, ring, &rx_tail_chip);
+	err = mcp251xfd_rx_tail_get_from_chip(priv, ring, &rx_tail_chip);
 	if (err)
 		return err;
 
-	rx_tail = mcp25xxfd_get_rx_tail(ring);
+	rx_tail = mcp251xfd_get_rx_tail(ring);
 	if (rx_tail_chip != rx_tail) {
 		netdev_err(priv->ndev,
 			   "RX tail of chip (%d) and ours (%d) inconsistent.\n",
@@ -1183,17 +1183,17 @@ mcp25xxfd_check_rx_tail(const struct mcp25xxfd_priv *priv,
 }
 
 static int
-mcp25xxfd_handle_tefif_recover(const struct mcp25xxfd_priv *priv, const u32 seq)
+mcp251xfd_handle_tefif_recover(const struct mcp251xfd_priv *priv, const u32 seq)
 {
-	const struct mcp25xxfd_tx_ring *tx_ring = priv->tx;
+	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
 	u32 tef_sta;
 	int err;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_TEFSTA, &tef_sta);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_TEFSTA, &tef_sta);
 	if (err)
 		return err;
 
-	if (tef_sta & MCP25XXFD_REG_TEFSTA_TEFOVIF) {
+	if (tef_sta & MCP251XFD_REG_TEFSTA_TEFOVIF) {
 		netdev_err(priv->ndev,
 			   "Transmit Event FIFO buffer overflow.\n");
 		return -ENOBUFS;
@@ -1201,8 +1201,8 @@ mcp25xxfd_handle_tefif_recover(const struct mcp25xxfd_priv *priv, const u32 seq)
 
 	netdev_info(priv->ndev,
 		    "Transmit Event FIFO buffer %s. (seq=0x%08x, tef_tail=0x%08x, tef_head=0x%08x, tx_head=0x%08x)\n",
-		    tef_sta & MCP25XXFD_REG_TEFSTA_TEFFIF ?
-		    "full" : tef_sta & MCP25XXFD_REG_TEFSTA_TEFNEIF ?
+		    tef_sta & MCP251XFD_REG_TEFSTA_TEFFIF ?
+		    "full" : tef_sta & MCP251XFD_REG_TEFSTA_TEFNEIF ?
 		    "not empty" : "empty",
 		    seq, priv->tef.tail, priv->tef.head, tx_ring->head);
 
@@ -1211,15 +1211,15 @@ mcp25xxfd_handle_tefif_recover(const struct mcp25xxfd_priv *priv, const u32 seq)
 }
 
 static int
-mcp25xxfd_handle_tefif_one(struct mcp25xxfd_priv *priv,
-			   const struct mcp25xxfd_hw_tef_obj *hw_tef_obj)
+mcp251xfd_handle_tefif_one(struct mcp251xfd_priv *priv,
+			   const struct mcp251xfd_hw_tef_obj *hw_tef_obj)
 {
-	struct mcp25xxfd_tx_ring *tx_ring = priv->tx;
+	struct mcp251xfd_tx_ring *tx_ring = priv->tx;
 	struct net_device_stats *stats = &priv->ndev->stats;
 	u32 seq, seq_masked, tef_tail_masked;
 	int err;
 
-	seq = FIELD_GET(MCP25XXFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK,
+	seq = FIELD_GET(MCP251XFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK,
 			hw_tef_obj->flags);
 
 	/* Use the MCP2517FD mask on the MCP2518FD, too. We only
@@ -1227,39 +1227,39 @@ mcp25xxfd_handle_tefif_one(struct mcp25xxfd_priv *priv,
 	 * net-yet-completed, i.e. old TEF objects.
 	 */
 	seq_masked = seq &
-		field_mask(MCP25XXFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK);
+		field_mask(MCP251XFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK);
 	tef_tail_masked = priv->tef.tail &
-		field_mask(MCP25XXFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK);
+		field_mask(MCP251XFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK);
 	if (seq_masked != tef_tail_masked)
-		return mcp25xxfd_handle_tefif_recover(priv, seq);
+		return mcp251xfd_handle_tefif_recover(priv, seq);
 
 	stats->tx_bytes +=
 		can_rx_offload_get_echo_skb(&priv->offload,
-					    mcp25xxfd_get_tef_tail(priv),
+					    mcp251xfd_get_tef_tail(priv),
 					    hw_tef_obj->ts);
 	stats->tx_packets++;
 
 	/* finally increment the TEF pointer */
-	err = regmap_update_bits(priv->map_reg, MCP25XXFD_REG_TEFCON,
+	err = regmap_update_bits(priv->map_reg, MCP251XFD_REG_TEFCON,
 				 GENMASK(15, 8),
-				 MCP25XXFD_REG_TEFCON_UINC);
+				 MCP251XFD_REG_TEFCON_UINC);
 	if (err)
 		return err;
 
 	priv->tef.tail++;
 	tx_ring->tail++;
 
-	return mcp25xxfd_check_tef_tail(priv);
+	return mcp251xfd_check_tef_tail(priv);
 }
 
-static int mcp25xxfd_tef_ring_update(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_tef_ring_update(struct mcp251xfd_priv *priv)
 {
-	const struct mcp25xxfd_tx_ring *tx_ring = priv->tx;
+	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
 	unsigned int new_head;
 	u8 chip_tx_tail;
 	int err;
 
-	err = mcp25xxfd_tx_tail_get_from_chip(priv, &chip_tx_tail);
+	err = mcp251xfd_tx_tail_get_from_chip(priv, &chip_tx_tail);
 	if (err)
 		return err;
 
@@ -1273,17 +1273,17 @@ static int mcp25xxfd_tef_ring_update(struct mcp25xxfd_priv *priv)
 	/* ... but it cannot exceed the TX head. */
 	priv->tef.head = min(new_head, tx_ring->head);
 
-	return mcp25xxfd_check_tef_tail(priv);
+	return mcp251xfd_check_tef_tail(priv);
 }
 
 static inline int
-mcp25xxfd_tef_obj_read(const struct mcp25xxfd_priv *priv,
-		       struct mcp25xxfd_hw_tef_obj *hw_tef_obj,
+mcp251xfd_tef_obj_read(const struct mcp251xfd_priv *priv,
+		       struct mcp251xfd_hw_tef_obj *hw_tef_obj,
 		       const u8 offset, const u8 len)
 {
-	const struct mcp25xxfd_tx_ring *tx_ring = priv->tx;
+	const struct mcp251xfd_tx_ring *tx_ring = priv->tx;
 
-	if (IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY) &&
+	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
 	    (offset > tx_ring->obj_num ||
 	     len > tx_ring->obj_num ||
 	     offset + len > tx_ring->obj_num)) {
@@ -1294,36 +1294,36 @@ mcp25xxfd_tef_obj_read(const struct mcp25xxfd_priv *priv,
 	}
 
 	return regmap_bulk_read(priv->map_rx,
-				mcp25xxfd_get_tef_obj_addr(offset),
+				mcp251xfd_get_tef_obj_addr(offset),
 				hw_tef_obj,
 				sizeof(*hw_tef_obj) / sizeof(u32) * len);
 }
 
-static int mcp25xxfd_handle_tefif(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
 {
-	struct mcp25xxfd_hw_tef_obj hw_tef_obj[MCP25XXFD_TX_OBJ_NUM_MAX];
+	struct mcp251xfd_hw_tef_obj hw_tef_obj[MCP251XFD_TX_OBJ_NUM_MAX];
 	u8 tef_tail, len, l;
 	int err, i;
 
-	err = mcp25xxfd_tef_ring_update(priv);
+	err = mcp251xfd_tef_ring_update(priv);
 	if (err)
 		return err;
 
-	tef_tail = mcp25xxfd_get_tef_tail(priv);
-	len = mcp25xxfd_get_tef_len(priv);
-	l = mcp25xxfd_get_tef_linear_len(priv);
-	err = mcp25xxfd_tef_obj_read(priv, hw_tef_obj, tef_tail, l);
+	tef_tail = mcp251xfd_get_tef_tail(priv);
+	len = mcp251xfd_get_tef_len(priv);
+	l = mcp251xfd_get_tef_linear_len(priv);
+	err = mcp251xfd_tef_obj_read(priv, hw_tef_obj, tef_tail, l);
 	if (err)
 		return err;
 
 	if (l < len) {
-		err = mcp25xxfd_tef_obj_read(priv, &hw_tef_obj[l], 0, len - l);
+		err = mcp251xfd_tef_obj_read(priv, &hw_tef_obj[l], 0, len - l);
 		if (err)
 			return err;
 	}
 
 	for (i = 0; i < len; i++) {
-		err = mcp25xxfd_handle_tefif_one(priv, &hw_tef_obj[i]);
+		err = mcp251xfd_handle_tefif_one(priv, &hw_tef_obj[i]);
 		/* -EAGAIN means the Sequence Number in the TEF
 		 * doesn't match our tef_tail. This can happen if we
 		 * read the TEF objects too early. Leave loop let the
@@ -1336,9 +1336,9 @@ static int mcp25xxfd_handle_tefif(struct mcp25xxfd_priv *priv)
 	}
 
  out_netif_wake_queue:
-	mcp25xxfd_ecc_tefif_successful(priv);
+	mcp251xfd_ecc_tefif_successful(priv);
 
-	if (mcp25xxfd_get_tx_free(priv->tx)) {
+	if (mcp251xfd_get_tx_free(priv->tx)) {
 		/* Make sure that anybody stopping the queue after
 		 * this sees the new tx_ring->tail.
 		 */
@@ -1350,14 +1350,14 @@ static int mcp25xxfd_handle_tefif(struct mcp25xxfd_priv *priv)
 }
 
 static int
-mcp25xxfd_rx_ring_update(const struct mcp25xxfd_priv *priv,
-			 struct mcp25xxfd_rx_ring *ring)
+mcp251xfd_rx_ring_update(const struct mcp251xfd_priv *priv,
+			 struct mcp251xfd_rx_ring *ring)
 {
 	u32 new_head;
 	u8 chip_rx_head;
 	int err;
 
-	err = mcp25xxfd_rx_head_get_from_chip(priv, ring, &chip_rx_head);
+	err = mcp251xfd_rx_head_get_from_chip(priv, ring, &chip_rx_head);
 	if (err)
 		return err;
 
@@ -1370,47 +1370,47 @@ mcp25xxfd_rx_ring_update(const struct mcp25xxfd_priv *priv,
 
 	ring->head = new_head;
 
-	return mcp25xxfd_check_rx_tail(priv, ring);
+	return mcp251xfd_check_rx_tail(priv, ring);
 }
 
 static void
-mcp25xxfd_hw_rx_obj_to_skb(const struct mcp25xxfd_priv *priv,
-			   const struct mcp25xxfd_hw_rx_obj_canfd *hw_rx_obj,
+mcp251xfd_hw_rx_obj_to_skb(const struct mcp251xfd_priv *priv,
+			   const struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj,
 			   struct sk_buff *skb)
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (hw_rx_obj->flags & MCP25XXFD_OBJ_FLAGS_IDE) {
+	if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_IDE) {
 		u32 sid, eid;
 
-		eid = FIELD_GET(MCP25XXFD_OBJ_ID_EID_MASK, hw_rx_obj->id);
-		sid = FIELD_GET(MCP25XXFD_OBJ_ID_SID_MASK, hw_rx_obj->id);
+		eid = FIELD_GET(MCP251XFD_OBJ_ID_EID_MASK, hw_rx_obj->id);
+		sid = FIELD_GET(MCP251XFD_OBJ_ID_SID_MASK, hw_rx_obj->id);
 
 		cfd->can_id = CAN_EFF_FLAG |
-			FIELD_PREP(MCP25XXFD_REG_FRAME_EFF_EID_MASK, eid) |
-			FIELD_PREP(MCP25XXFD_REG_FRAME_EFF_SID_MASK, sid);
+			FIELD_PREP(MCP251XFD_REG_FRAME_EFF_EID_MASK, eid) |
+			FIELD_PREP(MCP251XFD_REG_FRAME_EFF_SID_MASK, sid);
 	} else {
-		cfd->can_id = FIELD_GET(MCP25XXFD_OBJ_ID_SID_MASK,
+		cfd->can_id = FIELD_GET(MCP251XFD_OBJ_ID_SID_MASK,
 					hw_rx_obj->id);
 	}
 
 	/* CANFD */
-	if (hw_rx_obj->flags & MCP25XXFD_OBJ_FLAGS_FDF) {
+	if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_FDF) {
 		u8 dlc;
 
-		if (hw_rx_obj->flags & MCP25XXFD_OBJ_FLAGS_ESI)
+		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_ESI)
 			cfd->flags |= CANFD_ESI;
 
-		if (hw_rx_obj->flags & MCP25XXFD_OBJ_FLAGS_BRS)
+		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_BRS)
 			cfd->flags |= CANFD_BRS;
 
-		dlc = FIELD_GET(MCP25XXFD_OBJ_FLAGS_DLC, hw_rx_obj->flags);
+		dlc = FIELD_GET(MCP251XFD_OBJ_FLAGS_DLC, hw_rx_obj->flags);
 		cfd->len = can_dlc2len(get_canfd_dlc(dlc));
 	} else {
-		if (hw_rx_obj->flags & MCP25XXFD_OBJ_FLAGS_RTR)
+		if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_RTR)
 			cfd->can_id |= CAN_RTR_FLAG;
 
-		cfd->len = get_can_dlc(FIELD_GET(MCP25XXFD_OBJ_FLAGS_DLC,
+		cfd->len = get_can_dlc(FIELD_GET(MCP251XFD_OBJ_FLAGS_DLC,
 						 hw_rx_obj->flags));
 	}
 
@@ -1418,16 +1418,16 @@ mcp25xxfd_hw_rx_obj_to_skb(const struct mcp25xxfd_priv *priv,
 }
 
 static int
-mcp25xxfd_handle_rxif_one(struct mcp25xxfd_priv *priv,
-			  struct mcp25xxfd_rx_ring *ring,
-			  const struct mcp25xxfd_hw_rx_obj_canfd *hw_rx_obj)
+mcp251xfd_handle_rxif_one(struct mcp251xfd_priv *priv,
+			  struct mcp251xfd_rx_ring *ring,
+			  const struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj)
 {
 	struct net_device_stats *stats = &priv->ndev->stats;
 	struct sk_buff *skb;
 	struct canfd_frame *cfd;
 	int err;
 
-	if (hw_rx_obj->flags & MCP25XXFD_OBJ_FLAGS_FDF)
+	if (hw_rx_obj->flags & MCP251XFD_OBJ_FLAGS_FDF)
 		skb = alloc_canfd_skb(priv->ndev, &cfd);
 	else
 		skb = alloc_can_skb(priv->ndev, (struct can_frame **)&cfd);
@@ -1437,7 +1437,7 @@ mcp25xxfd_handle_rxif_one(struct mcp25xxfd_priv *priv,
 		return 0;
 	}
 
-	mcp25xxfd_hw_rx_obj_to_skb(priv, hw_rx_obj, skb);
+	mcp251xfd_hw_rx_obj_to_skb(priv, hw_rx_obj, skb);
 	err = can_rx_offload_queue_sorted(&priv->offload, skb, hw_rx_obj->ts);
 	if (err)
 		stats->rx_fifo_errors++;
@@ -1446,21 +1446,21 @@ mcp25xxfd_handle_rxif_one(struct mcp25xxfd_priv *priv,
 
 	/* finally increment the RX pointer */
 	return regmap_update_bits(priv->map_reg,
-				  MCP25XXFD_REG_FIFOCON(ring->fifo_nr),
+				  MCP251XFD_REG_FIFOCON(ring->fifo_nr),
 				  GENMASK(15, 8),
-				  MCP25XXFD_REG_FIFOCON_UINC);
+				  MCP251XFD_REG_FIFOCON_UINC);
 }
 
 static inline int
-mcp25xxfd_rx_obj_read(const struct mcp25xxfd_priv *priv,
-		      const struct mcp25xxfd_rx_ring *ring,
-		      struct mcp25xxfd_hw_rx_obj_canfd *hw_rx_obj,
+mcp251xfd_rx_obj_read(const struct mcp251xfd_priv *priv,
+		      const struct mcp251xfd_rx_ring *ring,
+		      struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj,
 		      const u8 offset, const u8 len)
 {
 	int err;
 
 	err = regmap_bulk_read(priv->map_rx,
-			       mcp25xxfd_get_rx_obj_addr(ring, offset),
+			       mcp251xfd_get_rx_obj_addr(ring, offset),
 			       hw_rx_obj,
 			       len * ring->obj_size / sizeof(u32));
 
@@ -1468,27 +1468,27 @@ mcp25xxfd_rx_obj_read(const struct mcp25xxfd_priv *priv,
 }
 
 static int
-mcp25xxfd_handle_rxif_ring(struct mcp25xxfd_priv *priv,
-			   struct mcp25xxfd_rx_ring *ring)
+mcp251xfd_handle_rxif_ring(struct mcp251xfd_priv *priv,
+			   struct mcp251xfd_rx_ring *ring)
 {
-	struct mcp25xxfd_hw_rx_obj_canfd *hw_rx_obj = ring->obj;
+	struct mcp251xfd_hw_rx_obj_canfd *hw_rx_obj = ring->obj;
 	u8 rx_tail, len;
 	int err, i;
 
-	err = mcp25xxfd_rx_ring_update(priv, ring);
+	err = mcp251xfd_rx_ring_update(priv, ring);
 	if (err)
 		return err;
 
-	while ((len = mcp25xxfd_get_rx_linear_len(ring))) {
-		rx_tail = mcp25xxfd_get_rx_tail(ring);
+	while ((len = mcp251xfd_get_rx_linear_len(ring))) {
+		rx_tail = mcp251xfd_get_rx_tail(ring);
 
-		err = mcp25xxfd_rx_obj_read(priv, ring, hw_rx_obj,
+		err = mcp251xfd_rx_obj_read(priv, ring, hw_rx_obj,
 					    rx_tail, len);
 		if (err)
 			return err;
 
 		for (i = 0; i < len; i++) {
-			err = mcp25xxfd_handle_rxif_one(priv, ring,
+			err = mcp251xfd_handle_rxif_one(priv, ring,
 							(void *)hw_rx_obj +
 							i * ring->obj_size);
 			if (err)
@@ -1499,13 +1499,13 @@ mcp25xxfd_handle_rxif_ring(struct mcp25xxfd_priv *priv,
 	return 0;
 }
 
-static int mcp25xxfd_handle_rxif(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_handle_rxif(struct mcp251xfd_priv *priv)
 {
-	struct mcp25xxfd_rx_ring *ring;
+	struct mcp251xfd_rx_ring *ring;
 	int err, n;
 
-	mcp25xxfd_for_each_rx_ring(priv, ring, n) {
-		err = mcp25xxfd_handle_rxif_ring(priv, ring);
+	mcp251xfd_for_each_rx_ring(priv, ring, n) {
+		err = mcp251xfd_handle_rxif_ring(priv, ring);
 		if (err)
 			return err;
 	}
@@ -1513,29 +1513,29 @@ static int mcp25xxfd_handle_rxif(struct mcp25xxfd_priv *priv)
 	return 0;
 }
 
-static inline int mcp25xxfd_get_timestamp(const struct mcp25xxfd_priv *priv,
+static inline int mcp251xfd_get_timestamp(const struct mcp251xfd_priv *priv,
 					  u32 *timestamp)
 {
-	return regmap_read(priv->map_reg, MCP25XXFD_REG_TBC, timestamp);
+	return regmap_read(priv->map_reg, MCP251XFD_REG_TBC, timestamp);
 }
 
 static struct sk_buff *
-mcp25xxfd_alloc_can_err_skb(const struct mcp25xxfd_priv *priv,
+mcp251xfd_alloc_can_err_skb(const struct mcp251xfd_priv *priv,
 			    struct can_frame **cf, u32 *timestamp)
 {
 	int err;
 
-	err = mcp25xxfd_get_timestamp(priv, timestamp);
+	err = mcp251xfd_get_timestamp(priv, timestamp);
 	if (err)
 		return NULL;
 
 	return alloc_can_err_skb(priv->ndev, cf);
 }
 
-static int mcp25xxfd_handle_rxovif(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_handle_rxovif(struct mcp251xfd_priv *priv)
 {
 	struct net_device_stats *stats = &priv->ndev->stats;
-	struct mcp25xxfd_rx_ring *ring;
+	struct mcp251xfd_rx_ring *ring;
 	struct sk_buff *skb;
 	struct can_frame *cf;
 	u32 timestamp, rxovif;
@@ -1544,16 +1544,16 @@ static int mcp25xxfd_handle_rxovif(struct mcp25xxfd_priv *priv)
 	stats->rx_over_errors++;
 	stats->rx_errors++;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_RXOVIF, &rxovif);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_RXOVIF, &rxovif);
 	if (err)
 		return err;
 
-	mcp25xxfd_for_each_rx_ring(priv, ring, i) {
+	mcp251xfd_for_each_rx_ring(priv, ring, i) {
 		if (!(rxovif & BIT(ring->fifo_nr)))
 			continue;
 
 		/* If SERRIF is active, there was a RX MAB overflow. */
-		if (priv->regs_status.intf & MCP25XXFD_REG_INT_SERRIF) {
+		if (priv->regs_status.intf & MCP251XFD_REG_INT_SERRIF) {
 			netdev_info(priv->ndev,
 				    "RX-%d: MAB overflow detected.\n",
 				    ring->nr);
@@ -1563,14 +1563,14 @@ static int mcp25xxfd_handle_rxovif(struct mcp25xxfd_priv *priv)
 		}
 
 		err = regmap_update_bits(priv->map_reg,
-					 MCP25XXFD_REG_FIFOSTA(ring->fifo_nr),
-					 MCP25XXFD_REG_FIFOSTA_RXOVIF,
+					 MCP251XFD_REG_FIFOSTA(ring->fifo_nr),
+					 MCP251XFD_REG_FIFOSTA_RXOVIF,
 					 0x0);
 		if (err)
 			return err;
 	}
 
-	skb = mcp25xxfd_alloc_can_err_skb(priv, &cf, &timestamp);
+	skb = mcp251xfd_alloc_can_err_skb(priv, &cf, &timestamp);
 	if (!skb)
 		return 0;
 
@@ -1584,14 +1584,14 @@ static int mcp25xxfd_handle_rxovif(struct mcp25xxfd_priv *priv)
 	return 0;
 }
 
-static int mcp25xxfd_handle_txatif(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_handle_txatif(struct mcp251xfd_priv *priv)
 {
 	netdev_info(priv->ndev, "%s\n", __func__);
 
 	return 0;
 }
 
-static int mcp25xxfd_handle_ivmif(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_handle_ivmif(struct mcp251xfd_priv *priv)
 {
 	struct net_device_stats *stats = &priv->ndev->stats;
 	u32 bdiag1, timestamp;
@@ -1599,18 +1599,18 @@ static int mcp25xxfd_handle_ivmif(struct mcp25xxfd_priv *priv)
 	struct can_frame *cf = NULL;
 	int err;
 
-	err = mcp25xxfd_get_timestamp(priv, &timestamp);
+	err = mcp251xfd_get_timestamp(priv, &timestamp);
 	if (err)
 		return err;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_BDIAG1, &bdiag1);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_BDIAG1, &bdiag1);
 	if (err)
 		return err;
 
 	/* Write 0s to clear error bits, don't write 1s to non active
 	 * bits, as they will be set.
 	 */
-	err = regmap_write(priv->map_reg, MCP25XXFD_REG_BDIAG1, 0x0);
+	err = regmap_write(priv->map_reg, MCP251XFD_REG_BDIAG1, 0x0);
 	if (err)
 		return err;
 
@@ -1621,29 +1621,29 @@ static int mcp25xxfd_handle_ivmif(struct mcp25xxfd_priv *priv)
 		cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
 	/* Controller misconfiguration */
-	if (WARN_ON(bdiag1 & MCP25XXFD_REG_BDIAG1_DLCMM))
+	if (WARN_ON(bdiag1 & MCP251XFD_REG_BDIAG1_DLCMM))
 		netdev_err(priv->ndev,
 			   "recv'd DLC is larger than PLSIZE of FIFO element.");
 
 	/* RX errors */
-	if (bdiag1 & (MCP25XXFD_REG_BDIAG1_DCRCERR |
-		      MCP25XXFD_REG_BDIAG1_NCRCERR)) {
+	if (bdiag1 & (MCP251XFD_REG_BDIAG1_DCRCERR |
+		      MCP251XFD_REG_BDIAG1_NCRCERR)) {
 		netdev_dbg(priv->ndev, "CRC error\n");
 
 		stats->rx_errors++;
 		if (cf)
 			cf->data[3] |= CAN_ERR_PROT_LOC_CRC_SEQ;
 	}
-	if (bdiag1 & (MCP25XXFD_REG_BDIAG1_DSTUFERR |
-		      MCP25XXFD_REG_BDIAG1_NSTUFERR)) {
+	if (bdiag1 & (MCP251XFD_REG_BDIAG1_DSTUFERR |
+		      MCP251XFD_REG_BDIAG1_NSTUFERR)) {
 		netdev_dbg(priv->ndev, "Stuff error\n");
 
 		stats->rx_errors++;
 		if (cf)
 			cf->data[2] |= CAN_ERR_PROT_STUFF;
 	}
-	if (bdiag1 & (MCP25XXFD_REG_BDIAG1_DFORMERR |
-		      MCP25XXFD_REG_BDIAG1_NFORMERR)) {
+	if (bdiag1 & (MCP251XFD_REG_BDIAG1_DFORMERR |
+		      MCP251XFD_REG_BDIAG1_NFORMERR)) {
 		netdev_dbg(priv->ndev, "Format error\n");
 
 		stats->rx_errors++;
@@ -1652,7 +1652,7 @@ static int mcp25xxfd_handle_ivmif(struct mcp25xxfd_priv *priv)
 	}
 
 	/* TX errors */
-	if (bdiag1 & MCP25XXFD_REG_BDIAG1_NACKERR) {
+	if (bdiag1 & MCP251XFD_REG_BDIAG1_NACKERR) {
 		netdev_dbg(priv->ndev, "NACK error\n");
 
 		stats->tx_errors++;
@@ -1661,16 +1661,16 @@ static int mcp25xxfd_handle_ivmif(struct mcp25xxfd_priv *priv)
 			cf->data[2] |= CAN_ERR_PROT_TX;
 		}
 	}
-	if (bdiag1 & (MCP25XXFD_REG_BDIAG1_DBIT1ERR |
-		      MCP25XXFD_REG_BDIAG1_NBIT1ERR)) {
+	if (bdiag1 & (MCP251XFD_REG_BDIAG1_DBIT1ERR |
+		      MCP251XFD_REG_BDIAG1_NBIT1ERR)) {
 		netdev_dbg(priv->ndev, "Bit1 error\n");
 
 		stats->tx_errors++;
 		if (cf)
 			cf->data[2] |= CAN_ERR_PROT_TX | CAN_ERR_PROT_BIT1;
 	}
-	if (bdiag1 & (MCP25XXFD_REG_BDIAG1_DBIT0ERR |
-		      MCP25XXFD_REG_BDIAG1_NBIT0ERR)) {
+	if (bdiag1 & (MCP251XFD_REG_BDIAG1_DBIT0ERR |
+		      MCP251XFD_REG_BDIAG1_NBIT0ERR)) {
 		netdev_dbg(priv->ndev, "Bit0 error\n");
 
 		stats->tx_errors++;
@@ -1688,7 +1688,7 @@ static int mcp25xxfd_handle_ivmif(struct mcp25xxfd_priv *priv)
 	return 0;
 }
 
-static int mcp25xxfd_handle_cerrif(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_handle_cerrif(struct mcp251xfd_priv *priv)
 {
 	struct net_device_stats *stats = &priv->ndev->stats;
 	struct sk_buff *skb;
@@ -1697,22 +1697,22 @@ static int mcp25xxfd_handle_cerrif(struct mcp25xxfd_priv *priv)
 	u32 trec, timestamp;
 	int err;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_TREC, &trec);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_TREC, &trec);
 	if (err)
 		return err;
 
-	if (trec & MCP25XXFD_REG_TREC_TXBO)
+	if (trec & MCP251XFD_REG_TREC_TXBO)
 		tx_state = CAN_STATE_BUS_OFF;
-	else if (trec & MCP25XXFD_REG_TREC_TXBP)
+	else if (trec & MCP251XFD_REG_TREC_TXBP)
 		tx_state = CAN_STATE_ERROR_PASSIVE;
-	else if (trec & MCP25XXFD_REG_TREC_TXWARN)
+	else if (trec & MCP251XFD_REG_TREC_TXWARN)
 		tx_state = CAN_STATE_ERROR_WARNING;
 	else
 		tx_state = CAN_STATE_ERROR_ACTIVE;
 
-	if (trec & MCP25XXFD_REG_TREC_RXBP)
+	if (trec & MCP251XFD_REG_TREC_RXBP)
 		rx_state = CAN_STATE_ERROR_PASSIVE;
-	else if (trec & MCP25XXFD_REG_TREC_RXWARN)
+	else if (trec & MCP251XFD_REG_TREC_RXWARN)
 		rx_state = CAN_STATE_ERROR_WARNING;
 	else
 		rx_state = CAN_STATE_ERROR_ACTIVE;
@@ -1724,7 +1724,7 @@ static int mcp25xxfd_handle_cerrif(struct mcp25xxfd_priv *priv)
 	/* The skb allocation might fail, but can_change_state()
 	 * handles cf == NULL.
 	 */
-	skb = mcp25xxfd_alloc_can_err_skb(priv, &cf, &timestamp);
+	skb = mcp251xfd_alloc_can_err_skb(priv, &cf, &timestamp);
 	can_change_state(priv->ndev, cf, tx_state, rx_state);
 
 	if (new_state == CAN_STATE_BUS_OFF) {
@@ -1733,11 +1733,11 @@ static int mcp25xxfd_handle_cerrif(struct mcp25xxfd_priv *priv)
 		 * userspace, if do_get_berr_counter() is called while
 		 * the chip is in Bus Off.
 		 */
-		err = __mcp25xxfd_get_berr_counter(priv->ndev, &priv->bec);
+		err = __mcp251xfd_get_berr_counter(priv->ndev, &priv->bec);
 		if (err)
 			return err;
 
-		mcp25xxfd_chip_stop(priv, CAN_STATE_BUS_OFF);
+		mcp251xfd_chip_stop(priv, CAN_STATE_BUS_OFF);
 		can_bus_off(priv->ndev);
 	}
 
@@ -1747,7 +1747,7 @@ static int mcp25xxfd_handle_cerrif(struct mcp25xxfd_priv *priv)
 	if (new_state != CAN_STATE_BUS_OFF) {
 		struct can_berr_counter bec;
 
-		err = mcp25xxfd_get_berr_counter(priv->ndev, &bec);
+		err = mcp251xfd_get_berr_counter(priv->ndev, &bec);
 		if (err)
 			return err;
 		cf->data[6] = bec.txerr;
@@ -1762,20 +1762,20 @@ static int mcp25xxfd_handle_cerrif(struct mcp25xxfd_priv *priv)
 }
 
 static int
-mcp25xxfd_handle_modif(const struct mcp25xxfd_priv *priv, bool *set_normal_mode)
+mcp251xfd_handle_modif(const struct mcp251xfd_priv *priv, bool *set_normal_mode)
 {
-	const u8 mode_reference = mcp25xxfd_get_normal_mode(priv);
+	const u8 mode_reference = mcp251xfd_get_normal_mode(priv);
 	u8 mode;
 	int err;
 
-	err = mcp25xxfd_chip_get_mode(priv, &mode);
+	err = mcp251xfd_chip_get_mode(priv, &mode);
 	if (err)
 		return err;
 
 	if (mode == mode_reference) {
 		netdev_dbg(priv->ndev,
 			   "Controller changed into %s Mode (%u).\n",
-			   mcp25xxfd_get_mode_str(mode), mode);
+			   mcp251xfd_get_mode_str(mode), mode);
 		return 0;
 	}
 
@@ -1789,16 +1789,16 @@ mcp25xxfd_handle_modif(const struct mcp25xxfd_priv *priv, bool *set_normal_mode)
 	 * first. When polling this bit we see that it will transition
 	 * to Restricted Operation Mode shortly after.
 	 */
-	if ((priv->devtype_data.quirks & MCP25XXFD_QUIRK_MAB_NO_WARN) &&
-	    (mode == MCP25XXFD_REG_CON_MODE_RESTRICTED ||
-	     mode == MCP25XXFD_REG_CON_MODE_LISTENONLY))
+	if ((priv->devtype_data.quirks & MCP251XFD_QUIRK_MAB_NO_WARN) &&
+	    (mode == MCP251XFD_REG_CON_MODE_RESTRICTED ||
+	     mode == MCP251XFD_REG_CON_MODE_LISTENONLY))
 		netdev_dbg(priv->ndev,
 			   "Controller changed into %s Mode (%u).\n",
-			   mcp25xxfd_get_mode_str(mode), mode);
+			   mcp251xfd_get_mode_str(mode), mode);
 	else
 		netdev_err(priv->ndev,
 			   "Controller changed into %s Mode (%u).\n",
-			   mcp25xxfd_get_mode_str(mode), mode);
+			   mcp251xfd_get_mode_str(mode), mode);
 
 	/* After the application requests Normal mode, the Controller
 	 * will automatically attempt to retransmit the message that
@@ -1806,19 +1806,19 @@ mcp25xxfd_handle_modif(const struct mcp25xxfd_priv *priv, bool *set_normal_mode)
 	 *
 	 * However, if there is an ECC error in the TX-RAM, we first
 	 * have to reload the tx-object before requesting Normal
-	 * mode. This is done later in mcp25xxfd_handle_eccif().
+	 * mode. This is done later in mcp251xfd_handle_eccif().
 	 */
-	if (priv->regs_status.intf & MCP25XXFD_REG_INT_ECCIF) {
+	if (priv->regs_status.intf & MCP251XFD_REG_INT_ECCIF) {
 		*set_normal_mode = true;
 		return 0;
 	}
 
-	return mcp25xxfd_chip_set_normal_mode_nowait(priv);
+	return mcp251xfd_chip_set_normal_mode_nowait(priv);
 }
 
-static int mcp25xxfd_handle_serrif(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_handle_serrif(struct mcp251xfd_priv *priv)
 {
-	struct mcp25xxfd_ecc *ecc = &priv->ecc;
+	struct mcp251xfd_ecc *ecc = &priv->ecc;
 	struct net_device_stats *stats = &priv->ndev->stats;
 	bool handled = false;
 
@@ -1844,19 +1844,19 @@ static int mcp25xxfd_handle_serrif(struct mcp25xxfd_priv *priv)
 	 *
 	 * Treat all as a known system errors..
 	 */
-	if ((priv->regs_status.intf & MCP25XXFD_REG_INT_MODIF &&
-	     priv->regs_status.intf & MCP25XXFD_REG_INT_IVMIF) ||
-	    priv->regs_status.intf & MCP25XXFD_REG_INT_ECCIF ||
+	if ((priv->regs_status.intf & MCP251XFD_REG_INT_MODIF &&
+	     priv->regs_status.intf & MCP251XFD_REG_INT_IVMIF) ||
+	    priv->regs_status.intf & MCP251XFD_REG_INT_ECCIF ||
 	    ecc->cnt) {
 		const char *msg;
 
-		if (priv->regs_status.intf & MCP25XXFD_REG_INT_ECCIF ||
+		if (priv->regs_status.intf & MCP251XFD_REG_INT_ECCIF ||
 		    ecc->cnt)
 			msg = "TX MAB underflow due to ECC error detected.";
 		else
 			msg = "TX MAB underflow detected.";
 
-		if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_MAB_NO_WARN)
+		if (priv->devtype_data.quirks & MCP251XFD_QUIRK_MAB_NO_WARN)
 			netdev_dbg(priv->ndev, "%s\n", msg);
 		else
 			netdev_info(priv->ndev, "%s\n", msg);
@@ -1880,8 +1880,8 @@ static int mcp25xxfd_handle_serrif(struct mcp25xxfd_priv *priv)
 	 *
 	 * Treat all as a known system errors..
 	 */
-	if (priv->regs_status.intf & MCP25XXFD_REG_INT_RXOVIF ||
-	    priv->regs_status.intf & MCP25XXFD_REG_INT_RXIF) {
+	if (priv->regs_status.intf & MCP251XFD_REG_INT_RXOVIF ||
+	    priv->regs_status.intf & MCP251XFD_REG_INT_RXIF) {
 		stats->rx_dropped++;
 		handled = true;
 	}
@@ -1895,22 +1895,22 @@ static int mcp25xxfd_handle_serrif(struct mcp25xxfd_priv *priv)
 }
 
 static int
-mcp25xxfd_handle_eccif_recover(struct mcp25xxfd_priv *priv, u8 nr)
+mcp251xfd_handle_eccif_recover(struct mcp251xfd_priv *priv, u8 nr)
 {
-	struct mcp25xxfd_tx_ring *tx_ring = priv->tx;
-	struct mcp25xxfd_ecc *ecc = &priv->ecc;
-	struct mcp25xxfd_tx_obj *tx_obj;
+	struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+	struct mcp251xfd_ecc *ecc = &priv->ecc;
+	struct mcp251xfd_tx_obj *tx_obj;
 	u8 chip_tx_tail, tx_tail, offset;
 	u16 addr;
 	int err;
 
-	addr = FIELD_GET(MCP25XXFD_REG_ECCSTAT_ERRADDR_MASK, ecc->ecc_stat);
+	addr = FIELD_GET(MCP251XFD_REG_ECCSTAT_ERRADDR_MASK, ecc->ecc_stat);
 
-	err = mcp25xxfd_tx_tail_get_from_chip(priv, &chip_tx_tail);
+	err = mcp251xfd_tx_tail_get_from_chip(priv, &chip_tx_tail);
 	if (err)
 		return err;
 
-	tx_tail = mcp25xxfd_get_tx_tail(tx_ring);
+	tx_tail = mcp251xfd_get_tx_tail(tx_ring);
 	offset = (nr - chip_tx_tail) & (tx_ring->obj_num - 1);
 
 	/* Bail out if one of the following is met:
@@ -1919,7 +1919,7 @@ mcp25xxfd_handle_eccif_recover(struct mcp25xxfd_priv *priv, u8 nr)
 	 * - for mcp2518fd: offset not 0 or 1
 	 */
 	if (chip_tx_tail != tx_tail ||
-	    !(offset == 0 || (offset == 1 && mcp25xxfd_is_2518(priv)))) {
+	    !(offset == 0 || (offset == 1 && mcp251xfd_is_2518(priv)))) {
 		netdev_err(priv->ndev,
 			   "ECC Error information inconsistent (addr=0x%04x, nr=%d, tx_tail=0x%08x(%d), chip_tx_tail=%d, offset=%d).\n",
 			   addr, nr, tx_ring->tail, tx_tail, chip_tx_tail,
@@ -1929,7 +1929,7 @@ mcp25xxfd_handle_eccif_recover(struct mcp25xxfd_priv *priv, u8 nr)
 
 	netdev_info(priv->ndev,
 		    "Recovering %s ECC Error at address 0x%04x (in TX-RAM, tx_obj=%d, tx_tail=0x%08x(%d), offset=%d).\n",
-		    ecc->ecc_stat & MCP25XXFD_REG_ECCSTAT_SECIF ?
+		    ecc->ecc_stat & MCP251XFD_REG_ECCSTAT_SECIF ?
 		    "Single" : "Double",
 		    addr, nr, tx_ring->tail, tx_tail, offset);
 
@@ -1940,13 +1940,13 @@ mcp25xxfd_handle_eccif_recover(struct mcp25xxfd_priv *priv, u8 nr)
 		return err;
 
 	/* ... and trigger retransmit */
-	return mcp25xxfd_chip_set_normal_mode(priv);
+	return mcp251xfd_chip_set_normal_mode(priv);
 }
 
 static int
-mcp25xxfd_handle_eccif(struct mcp25xxfd_priv *priv, bool set_normal_mode)
+mcp251xfd_handle_eccif(struct mcp251xfd_priv *priv, bool set_normal_mode)
 {
-	struct mcp25xxfd_ecc *ecc = &priv->ecc;
+	struct mcp251xfd_ecc *ecc = &priv->ecc;
 	const char *msg;
 	bool in_tx_ram;
 	u32 ecc_stat;
@@ -1954,18 +1954,18 @@ mcp25xxfd_handle_eccif(struct mcp25xxfd_priv *priv, bool set_normal_mode)
 	u8 nr;
 	int err;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_ECCSTAT, &ecc_stat);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_ECCSTAT, &ecc_stat);
 	if (err)
 		return err;
 
-	err = regmap_update_bits(priv->map_reg, MCP25XXFD_REG_ECCSTAT,
-				 MCP25XXFD_REG_ECCSTAT_IF_MASK, ~ecc_stat);
+	err = regmap_update_bits(priv->map_reg, MCP251XFD_REG_ECCSTAT,
+				 MCP251XFD_REG_ECCSTAT_IF_MASK, ~ecc_stat);
 	if (err)
 		return err;
 
 	/* Check if ECC error occurred in TX-RAM */
-	addr = FIELD_GET(MCP25XXFD_REG_ECCSTAT_ERRADDR_MASK, ecc_stat);
-	err = mcp25xxfd_get_tx_nr_by_addr(priv->tx, &nr, addr);
+	addr = FIELD_GET(MCP251XFD_REG_ECCSTAT_ERRADDR_MASK, ecc_stat);
+	err = mcp251xfd_get_tx_nr_by_addr(priv->tx, &nr, addr);
 	if (!err)
 		in_tx_ram = true;
 	else if (err == -ENOENT)
@@ -1985,9 +1985,9 @@ mcp25xxfd_handle_eccif(struct mcp25xxfd_priv *priv, bool set_normal_mode)
 	 * correction. Instead, handle both interrupts as a
 	 * notification that the RAM word at ERRADDR was corrupted.
 	 */
-	if (ecc_stat & MCP25XXFD_REG_ECCSTAT_SECIF)
+	if (ecc_stat & MCP251XFD_REG_ECCSTAT_SECIF)
 		msg = "Single ECC Error detected at address";
-	else if (ecc_stat & MCP25XXFD_REG_ECCSTAT_DEDIF)
+	else if (ecc_stat & MCP251XFD_REG_ECCSTAT_DEDIF)
 		msg = "Double ECC Error detected at address";
 	else
 		return -EINVAL;
@@ -2009,57 +2009,57 @@ mcp25xxfd_handle_eccif(struct mcp25xxfd_priv *priv, bool set_normal_mode)
 			    "%s 0x%04x (in TX-RAM, tx_obj=%d), occurred %d time%s.\n",
 			    msg, addr, nr, ecc->cnt, ecc->cnt > 1 ? "s" : "");
 
-		if (ecc->cnt >= MCP25XXFD_ECC_CNT_MAX)
-			return mcp25xxfd_handle_eccif_recover(priv, nr);
+		if (ecc->cnt >= MCP251XFD_ECC_CNT_MAX)
+			return mcp251xfd_handle_eccif_recover(priv, nr);
 	}
 
 	if (set_normal_mode)
-		return mcp25xxfd_chip_set_normal_mode_nowait(priv);
+		return mcp251xfd_chip_set_normal_mode_nowait(priv);
 
 	return 0;
 }
 
-static int mcp25xxfd_handle_spicrcif(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_handle_spicrcif(struct mcp251xfd_priv *priv)
 {
 	int err;
 	u32 crc;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_CRC, &crc);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_CRC, &crc);
 	if (err)
 		return err;
 
-	err = regmap_update_bits(priv->map_reg, MCP25XXFD_REG_CRC,
-				 MCP25XXFD_REG_CRC_IF_MASK,
+	err = regmap_update_bits(priv->map_reg, MCP251XFD_REG_CRC,
+				 MCP251XFD_REG_CRC_IF_MASK,
 				 ~crc);
 	if (err)
 		return err;
 
-	if (crc & MCP25XXFD_REG_CRC_FERRIF)
+	if (crc & MCP251XFD_REG_CRC_FERRIF)
 		netdev_notice(priv->ndev, "CRC write command format error.\n");
-	else if (crc & MCP25XXFD_REG_CRC_CRCERRIF)
+	else if (crc & MCP251XFD_REG_CRC_CRCERRIF)
 		netdev_notice(priv->ndev,
 			      "CRC write error detected. CRC=0x%04lx.\n",
-			      FIELD_GET(MCP25XXFD_REG_CRC_MASK, crc));
+			      FIELD_GET(MCP251XFD_REG_CRC_MASK, crc));
 
 	return 0;
 }
 
-#define mcp25xxfd_handle(priv, irq, ...) \
+#define mcp251xfd_handle(priv, irq, ...) \
 ({ \
-	struct mcp25xxfd_priv *_priv = (priv); \
+	struct mcp251xfd_priv *_priv = (priv); \
 	int err; \
 \
-	err = mcp25xxfd_handle_##irq(_priv, ## __VA_ARGS__); \
+	err = mcp251xfd_handle_##irq(_priv, ## __VA_ARGS__); \
 	if (err) \
 		netdev_err(_priv->ndev, \
-			"IRQ handler mcp25xxfd_handle_%s() returned %d.\n", \
+			"IRQ handler mcp251xfd_handle_%s() returned %d.\n", \
 			__stringify(irq), err); \
 	err; \
 })
 
-static irqreturn_t mcp25xxfd_irq(int irq, void *dev_id)
+static irqreturn_t mcp251xfd_irq(int irq, void *dev_id)
 {
-	struct mcp25xxfd_priv *priv = dev_id;
+	struct mcp251xfd_priv *priv = dev_id;
 	irqreturn_t handled = IRQ_NONE;
 	int err;
 
@@ -2071,7 +2071,7 @@ static irqreturn_t mcp25xxfd_irq(int irq, void *dev_id)
 			if (!rx_pending)
 				break;
 
-			err = mcp25xxfd_handle(priv, rxif);
+			err = mcp251xfd_handle(priv, rxif);
 			if (err)
 				goto out_fail;
 
@@ -2082,90 +2082,90 @@ static irqreturn_t mcp25xxfd_irq(int irq, void *dev_id)
 		u32 intf_pending, intf_pending_clearable;
 		bool set_normal_mode = false;
 
-		err = regmap_bulk_read(priv->map_reg, MCP25XXFD_REG_INT,
+		err = regmap_bulk_read(priv->map_reg, MCP251XFD_REG_INT,
 				       &priv->regs_status,
 				       sizeof(priv->regs_status) /
 				       sizeof(u32));
 		if (err)
 			goto out_fail;
 
-		intf_pending = FIELD_GET(MCP25XXFD_REG_INT_IF_MASK,
+		intf_pending = FIELD_GET(MCP251XFD_REG_INT_IF_MASK,
 					 priv->regs_status.intf) &
-			FIELD_GET(MCP25XXFD_REG_INT_IE_MASK,
+			FIELD_GET(MCP251XFD_REG_INT_IE_MASK,
 				  priv->regs_status.intf);
 
 		if (!(intf_pending))
 			return handled;
 
 		/* Some interrupts must be ACKed in the
-		 * MCP25XXFD_REG_INT register.
+		 * MCP251XFD_REG_INT register.
 		 * - First ACK then handle, to avoid lost-IRQ race
 		 *   condition on fast re-occurring interrupts.
 		 * - Write "0" to clear active IRQs, "1" to all other,
 		 *   to avoid r/m/w race condition on the
-		 *   MCP25XXFD_REG_INT register.
+		 *   MCP251XFD_REG_INT register.
 		 */
 		intf_pending_clearable = intf_pending &
-			MCP25XXFD_REG_INT_IF_CLEARABLE_MASK;
+			MCP251XFD_REG_INT_IF_CLEARABLE_MASK;
 		if (intf_pending_clearable) {
 			err = regmap_update_bits(priv->map_reg,
-						 MCP25XXFD_REG_INT,
-						 MCP25XXFD_REG_INT_IF_MASK,
+						 MCP251XFD_REG_INT,
+						 MCP251XFD_REG_INT_IF_MASK,
 						 ~intf_pending_clearable);
 			if (err)
 				goto out_fail;
 		}
 
-		if (intf_pending & MCP25XXFD_REG_INT_MODIF) {
-			err = mcp25xxfd_handle(priv, modif, &set_normal_mode);
+		if (intf_pending & MCP251XFD_REG_INT_MODIF) {
+			err = mcp251xfd_handle(priv, modif, &set_normal_mode);
 			if (err)
 				goto out_fail;
 		}
 
-		if (intf_pending & MCP25XXFD_REG_INT_RXIF) {
-			err = mcp25xxfd_handle(priv, rxif);
+		if (intf_pending & MCP251XFD_REG_INT_RXIF) {
+			err = mcp251xfd_handle(priv, rxif);
 			if (err)
 				goto out_fail;
 		}
 
-		if (intf_pending & MCP25XXFD_REG_INT_TEFIF) {
-			err = mcp25xxfd_handle(priv, tefif);
+		if (intf_pending & MCP251XFD_REG_INT_TEFIF) {
+			err = mcp251xfd_handle(priv, tefif);
 			if (err)
 				goto out_fail;
 		}
 
-		if (intf_pending & MCP25XXFD_REG_INT_RXOVIF) {
-			err = mcp25xxfd_handle(priv, rxovif);
+		if (intf_pending & MCP251XFD_REG_INT_RXOVIF) {
+			err = mcp251xfd_handle(priv, rxovif);
 			if (err)
 				goto out_fail;
 		}
 
-		if (intf_pending & MCP25XXFD_REG_INT_TXATIF) {
-			err = mcp25xxfd_handle(priv, txatif);
+		if (intf_pending & MCP251XFD_REG_INT_TXATIF) {
+			err = mcp251xfd_handle(priv, txatif);
 			if (err)
 				goto out_fail;
 		}
 
-		if (intf_pending & MCP25XXFD_REG_INT_IVMIF) {
-			err = mcp25xxfd_handle(priv, ivmif);
+		if (intf_pending & MCP251XFD_REG_INT_IVMIF) {
+			err = mcp251xfd_handle(priv, ivmif);
 			if (err)
 				goto out_fail;
 		}
 
-		if (intf_pending & MCP25XXFD_REG_INT_SERRIF) {
-			err = mcp25xxfd_handle(priv, serrif);
+		if (intf_pending & MCP251XFD_REG_INT_SERRIF) {
+			err = mcp251xfd_handle(priv, serrif);
 			if (err)
 				goto out_fail;
 		}
 
-		if (intf_pending & MCP25XXFD_REG_INT_ECCIF) {
-			err = mcp25xxfd_handle(priv, eccif, set_normal_mode);
+		if (intf_pending & MCP251XFD_REG_INT_ECCIF) {
+			err = mcp251xfd_handle(priv, eccif, set_normal_mode);
 			if (err)
 				goto out_fail;
 		}
 
-		if (intf_pending & MCP25XXFD_REG_INT_SPICRCIF) {
-			err = mcp25xxfd_handle(priv, spicrcif);
+		if (intf_pending & MCP251XFD_REG_INT_SPICRCIF) {
+			err = mcp251xfd_handle(priv, spicrcif);
 			if (err)
 				goto out_fail;
 		}
@@ -2174,16 +2174,16 @@ static irqreturn_t mcp25xxfd_irq(int irq, void *dev_id)
 		 * CERRIF IRQ on the transition TX ERROR_WARNING -> TX
 		 * ERROR_ACTIVE.
 		 */
-		if (intf_pending & MCP25XXFD_REG_INT_CERRIF ||
+		if (intf_pending & MCP251XFD_REG_INT_CERRIF ||
 		    priv->can.state > CAN_STATE_ERROR_ACTIVE) {
-			err = mcp25xxfd_handle(priv, cerrif);
+			err = mcp251xfd_handle(priv, cerrif);
 			if (err)
 				goto out_fail;
 
 			/* In Bus Off we completely shut down the
 			 * controller. Every subsequent register read
 			 * will read bogus data, and if
-			 * MCP25XXFD_QUIRK_CRC_REG is enabled the CRC
+			 * MCP251XFD_QUIRK_CRC_REG is enabled the CRC
 			 * check will fail, too. So leave IRQ handler
 			 * directly.
 			 */
@@ -2197,30 +2197,30 @@ static irqreturn_t mcp25xxfd_irq(int irq, void *dev_id)
  out_fail:
 	netdev_err(priv->ndev, "IRQ handler returned %d (intf=0x%08x).\n",
 		   err, priv->regs_status.intf);
-	mcp25xxfd_chip_interrupts_disable(priv);
+	mcp251xfd_chip_interrupts_disable(priv);
 
 	return handled;
 }
 
 static inline struct
-mcp25xxfd_tx_obj *mcp25xxfd_get_tx_obj_next(struct mcp25xxfd_tx_ring *tx_ring)
+mcp251xfd_tx_obj *mcp251xfd_get_tx_obj_next(struct mcp251xfd_tx_ring *tx_ring)
 {
 	u8 tx_head;
 
-	tx_head = mcp25xxfd_get_tx_head(tx_ring);
+	tx_head = mcp251xfd_get_tx_head(tx_ring);
 
 	return &tx_ring->obj[tx_head];
 }
 
 static void
-mcp25xxfd_tx_obj_from_skb(const struct mcp25xxfd_priv *priv,
-			  struct mcp25xxfd_tx_obj *tx_obj,
+mcp251xfd_tx_obj_from_skb(const struct mcp251xfd_priv *priv,
+			  struct mcp251xfd_tx_obj *tx_obj,
 			  const struct sk_buff *skb,
 			  unsigned int seq)
 {
 	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
-	struct mcp25xxfd_hw_tx_obj_raw *hw_tx_obj;
-	union mcp25xxfd_tx_obj_load_buf *load_buf;
+	struct mcp251xfd_hw_tx_obj_raw *hw_tx_obj;
+	union mcp251xfd_tx_obj_load_buf *load_buf;
 	u8 dlc;
 	u32 id, flags;
 	int offset, len;
@@ -2228,15 +2228,15 @@ mcp25xxfd_tx_obj_from_skb(const struct mcp25xxfd_priv *priv,
 	if (cfd->can_id & CAN_EFF_FLAG) {
 		u32 sid, eid;
 
-		sid = FIELD_GET(MCP25XXFD_REG_FRAME_EFF_SID_MASK, cfd->can_id);
-		eid = FIELD_GET(MCP25XXFD_REG_FRAME_EFF_EID_MASK, cfd->can_id);
+		sid = FIELD_GET(MCP251XFD_REG_FRAME_EFF_SID_MASK, cfd->can_id);
+		eid = FIELD_GET(MCP251XFD_REG_FRAME_EFF_EID_MASK, cfd->can_id);
 
-		id = FIELD_PREP(MCP25XXFD_OBJ_ID_EID_MASK, eid) |
-			FIELD_PREP(MCP25XXFD_OBJ_ID_SID_MASK, sid);
+		id = FIELD_PREP(MCP251XFD_OBJ_ID_EID_MASK, eid) |
+			FIELD_PREP(MCP251XFD_OBJ_ID_SID_MASK, sid);
 
-		flags = MCP25XXFD_OBJ_FLAGS_IDE;
+		flags = MCP251XFD_OBJ_FLAGS_IDE;
 	} else {
-		id = FIELD_PREP(MCP25XXFD_OBJ_ID_SID_MASK, cfd->can_id);
+		id = FIELD_PREP(MCP251XFD_OBJ_ID_SID_MASK, cfd->can_id);
 		flags = 0;
 	}
 
@@ -2245,25 +2245,25 @@ mcp25xxfd_tx_obj_from_skb(const struct mcp25xxfd_priv *priv,
 	 * TEF object.
 	 */
 	dlc = can_len2dlc(cfd->len);
-	flags |= FIELD_PREP(MCP25XXFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK, seq) |
-		FIELD_PREP(MCP25XXFD_OBJ_FLAGS_DLC, dlc);
+	flags |= FIELD_PREP(MCP251XFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK, seq) |
+		FIELD_PREP(MCP251XFD_OBJ_FLAGS_DLC, dlc);
 
 	if (cfd->can_id & CAN_RTR_FLAG)
-		flags |= MCP25XXFD_OBJ_FLAGS_RTR;
+		flags |= MCP251XFD_OBJ_FLAGS_RTR;
 
 	/* CANFD */
 	if (can_is_canfd_skb(skb)) {
 		if (cfd->flags & CANFD_ESI)
-			flags |= MCP25XXFD_OBJ_FLAGS_ESI;
+			flags |= MCP251XFD_OBJ_FLAGS_ESI;
 
-		flags |= MCP25XXFD_OBJ_FLAGS_FDF;
+		flags |= MCP251XFD_OBJ_FLAGS_FDF;
 
 		if (cfd->flags & CANFD_BRS)
-			flags |= MCP25XXFD_OBJ_FLAGS_BRS;
+			flags |= MCP251XFD_OBJ_FLAGS_BRS;
 	}
 
 	load_buf = &tx_obj->buf;
-	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_TX)
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_TX)
 		hw_tx_obj = &load_buf->crc.hw_tx_obj;
 	else
 		hw_tx_obj = &load_buf->nocrc.hw_tx_obj;
@@ -2274,25 +2274,25 @@ mcp25xxfd_tx_obj_from_skb(const struct mcp25xxfd_priv *priv,
 	/* Clear data at end of CAN frame */
 	offset = round_down(cfd->len, sizeof(u32));
 	len = round_up(can_dlc2len(dlc), sizeof(u32)) - offset;
-	if (MCP25XXFD_SANITIZE_CAN && len)
+	if (MCP251XFD_SANITIZE_CAN && len)
 		memset(hw_tx_obj->data + offset, 0x0, len);
 	memcpy(hw_tx_obj->data, cfd->data, cfd->len);
 
 	/* Number of bytes to be written into the RAM of the controller */
 	len = sizeof(hw_tx_obj->id) + sizeof(hw_tx_obj->flags);
-	if (MCP25XXFD_SANITIZE_CAN)
+	if (MCP251XFD_SANITIZE_CAN)
 		len += round_up(can_dlc2len(dlc), sizeof(u32));
 	else
 		len += round_up(cfd->len, sizeof(u32));
 
-	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_TX) {
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_TX) {
 		u16 crc;
 
-		mcp25xxfd_spi_cmd_crc_set_len_in_ram(&load_buf->crc.cmd,
+		mcp251xfd_spi_cmd_crc_set_len_in_ram(&load_buf->crc.cmd,
 						     len);
 		/* CRC */
 		len += sizeof(load_buf->crc.cmd);
-		crc = mcp25xxfd_crc16_compute(&load_buf->crc, len);
+		crc = mcp251xfd_crc16_compute(&load_buf->crc, len);
 		put_unaligned_be16(crc, (void *)load_buf + len);
 
 		/* Total length */
@@ -2304,16 +2304,16 @@ mcp25xxfd_tx_obj_from_skb(const struct mcp25xxfd_priv *priv,
 	tx_obj->xfer[0].len = len;
 }
 
-static int mcp25xxfd_tx_obj_write(const struct mcp25xxfd_priv *priv,
-				  struct mcp25xxfd_tx_obj *tx_obj)
+static int mcp251xfd_tx_obj_write(const struct mcp251xfd_priv *priv,
+				  struct mcp251xfd_tx_obj *tx_obj)
 {
 	return spi_async(priv->spi, &tx_obj->msg);
 }
 
-static bool mcp25xxfd_tx_busy(const struct mcp25xxfd_priv *priv,
-			      struct mcp25xxfd_tx_ring *tx_ring)
+static bool mcp251xfd_tx_busy(const struct mcp251xfd_priv *priv,
+			      struct mcp251xfd_tx_ring *tx_ring)
 {
-	if (mcp25xxfd_get_tx_free(tx_ring) > 0)
+	if (mcp251xfd_get_tx_free(tx_ring) > 0)
 		return false;
 
 	netif_stop_queue(priv->ndev);
@@ -2321,7 +2321,7 @@ static bool mcp25xxfd_tx_busy(const struct mcp25xxfd_priv *priv,
 	/* Memory barrier before checking tx_free (head and tail) */
 	smp_mb();
 
-	if (mcp25xxfd_get_tx_free(tx_ring) == 0) {
+	if (mcp251xfd_get_tx_free(tx_ring) == 0) {
 		netdev_dbg(priv->ndev,
 			   "Stopping tx-queue (tx_head=0x%08x, tx_tail=0x%08x, len=%d).\n",
 			   tx_ring->head, tx_ring->tail,
@@ -2335,33 +2335,33 @@ static bool mcp25xxfd_tx_busy(const struct mcp25xxfd_priv *priv,
 	return false;
 }
 
-static netdev_tx_t mcp25xxfd_start_xmit(struct sk_buff *skb,
+static netdev_tx_t mcp251xfd_start_xmit(struct sk_buff *skb,
 					struct net_device *ndev)
 {
-	struct mcp25xxfd_priv *priv = netdev_priv(ndev);
-	struct mcp25xxfd_tx_ring *tx_ring = priv->tx;
-	struct mcp25xxfd_tx_obj *tx_obj;
+	struct mcp251xfd_priv *priv = netdev_priv(ndev);
+	struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+	struct mcp251xfd_tx_obj *tx_obj;
 	u8 tx_head;
 	int err;
 
 	if (can_dropped_invalid_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
-	if (mcp25xxfd_tx_busy(priv, tx_ring))
+	if (mcp251xfd_tx_busy(priv, tx_ring))
 		return NETDEV_TX_BUSY;
 
-	tx_obj = mcp25xxfd_get_tx_obj_next(tx_ring);
-	mcp25xxfd_tx_obj_from_skb(priv, tx_obj, skb, tx_ring->head);
+	tx_obj = mcp251xfd_get_tx_obj_next(tx_ring);
+	mcp251xfd_tx_obj_from_skb(priv, tx_obj, skb, tx_ring->head);
 
 	/* Stop queue if we occupy the complete TX FIFO */
-	tx_head = mcp25xxfd_get_tx_head(tx_ring);
+	tx_head = mcp251xfd_get_tx_head(tx_ring);
 	tx_ring->head++;
 	if (tx_ring->head - tx_ring->tail >= tx_ring->obj_num)
 		netif_stop_queue(ndev);
 
 	can_put_echo_skb(skb, ndev, tx_head);
 
-	err = mcp25xxfd_tx_obj_write(priv, tx_obj);
+	err = mcp251xfd_tx_obj_write(priv, tx_obj);
 	if (err)
 		goto out_err;
 
@@ -2373,9 +2373,9 @@ static netdev_tx_t mcp25xxfd_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-static int mcp25xxfd_open(struct net_device *ndev)
+static int mcp251xfd_open(struct net_device *ndev)
 {
-	struct mcp25xxfd_priv *priv = netdev_priv(ndev);
+	struct mcp251xfd_priv *priv = netdev_priv(ndev);
 	const struct spi_device *spi = priv->spi;
 	int err;
 
@@ -2389,27 +2389,27 @@ static int mcp25xxfd_open(struct net_device *ndev)
 	if (err)
 		goto out_pm_runtime_put;
 
-	err = mcp25xxfd_ring_alloc(priv);
+	err = mcp251xfd_ring_alloc(priv);
 	if (err)
 		goto out_close_candev;
 
-	err = mcp25xxfd_transceiver_enable(priv);
+	err = mcp251xfd_transceiver_enable(priv);
 	if (err)
-		goto out_mcp25xxfd_ring_free;
+		goto out_mcp251xfd_ring_free;
 
-	err = mcp25xxfd_chip_start(priv);
+	err = mcp251xfd_chip_start(priv);
 	if (err)
 		goto out_transceiver_disable;
 
 	can_rx_offload_enable(&priv->offload);
 
-	err = request_threaded_irq(spi->irq, NULL, mcp25xxfd_irq,
+	err = request_threaded_irq(spi->irq, NULL, mcp251xfd_irq,
 				   IRQF_ONESHOT, dev_name(&spi->dev),
 				   priv);
 	if (err)
 		goto out_can_rx_offload_disable;
 
-	err = mcp25xxfd_chip_interrupts_enable(priv);
+	err = mcp251xfd_chip_interrupts_enable(priv);
 	if (err)
 		goto out_free_irq;
 
@@ -2422,29 +2422,29 @@ static int mcp25xxfd_open(struct net_device *ndev)
  out_can_rx_offload_disable:
 	can_rx_offload_disable(&priv->offload);
  out_transceiver_disable:
-	mcp25xxfd_transceiver_disable(priv);
- out_mcp25xxfd_ring_free:
-	mcp25xxfd_ring_free(priv);
+	mcp251xfd_transceiver_disable(priv);
+ out_mcp251xfd_ring_free:
+	mcp251xfd_ring_free(priv);
  out_close_candev:
 	close_candev(ndev);
  out_pm_runtime_put:
-	mcp25xxfd_chip_stop(priv, CAN_STATE_STOPPED);
+	mcp251xfd_chip_stop(priv, CAN_STATE_STOPPED);
 	pm_runtime_put(ndev->dev.parent);
 
 	return err;
 }
 
-static int mcp25xxfd_stop(struct net_device *ndev)
+static int mcp251xfd_stop(struct net_device *ndev)
 {
-	struct mcp25xxfd_priv *priv = netdev_priv(ndev);
+	struct mcp251xfd_priv *priv = netdev_priv(ndev);
 
 	netif_stop_queue(ndev);
-	mcp25xxfd_chip_interrupts_disable(priv);
+	mcp251xfd_chip_interrupts_disable(priv);
 	free_irq(ndev->irq, priv);
 	can_rx_offload_disable(&priv->offload);
-	mcp25xxfd_chip_stop(priv, CAN_STATE_STOPPED);
-	mcp25xxfd_transceiver_disable(priv);
-	mcp25xxfd_ring_free(priv);
+	mcp251xfd_chip_stop(priv, CAN_STATE_STOPPED);
+	mcp251xfd_transceiver_disable(priv);
+	mcp251xfd_ring_free(priv);
 	close_candev(ndev);
 
 	pm_runtime_put(ndev->dev.parent);
@@ -2452,72 +2452,72 @@ static int mcp25xxfd_stop(struct net_device *ndev)
 	return 0;
 }
 
-static const struct net_device_ops mcp25xxfd_netdev_ops = {
-	.ndo_open = mcp25xxfd_open,
-	.ndo_stop = mcp25xxfd_stop,
-	.ndo_start_xmit	= mcp25xxfd_start_xmit,
+static const struct net_device_ops mcp251xfd_netdev_ops = {
+	.ndo_open = mcp251xfd_open,
+	.ndo_stop = mcp251xfd_stop,
+	.ndo_start_xmit	= mcp251xfd_start_xmit,
 	.ndo_change_mtu = can_change_mtu,
 };
 
 static void
-mcp25xxfd_register_quirks(struct mcp25xxfd_priv *priv)
+mcp251xfd_register_quirks(struct mcp251xfd_priv *priv)
 {
 	const struct spi_device *spi = priv->spi;
 	const struct spi_controller *ctlr = spi->controller;
 
 	if (ctlr->flags & SPI_CONTROLLER_HALF_DUPLEX)
-		priv->devtype_data.quirks |= MCP25XXFD_QUIRK_HALF_DUPLEX;
+		priv->devtype_data.quirks |= MCP251XFD_QUIRK_HALF_DUPLEX;
 }
 
-static int mcp25xxfd_register_chip_detect(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_register_chip_detect(struct mcp251xfd_priv *priv)
 {
 	const struct net_device *ndev = priv->ndev;
-	const struct mcp25xxfd_devtype_data *devtype_data;
+	const struct mcp251xfd_devtype_data *devtype_data;
 	u32 osc;
 	int err;
 
 	/* The OSC_LPMEN is only supported on MCP2518FD, so use it to
 	 * autodetect the model.
 	 */
-	err = regmap_update_bits(priv->map_reg, MCP25XXFD_REG_OSC,
-				 MCP25XXFD_REG_OSC_LPMEN,
-				 MCP25XXFD_REG_OSC_LPMEN);
+	err = regmap_update_bits(priv->map_reg, MCP251XFD_REG_OSC,
+				 MCP251XFD_REG_OSC_LPMEN,
+				 MCP251XFD_REG_OSC_LPMEN);
 	if (err)
 		return err;
 
-	err = regmap_read(priv->map_reg, MCP25XXFD_REG_OSC, &osc);
+	err = regmap_read(priv->map_reg, MCP251XFD_REG_OSC, &osc);
 	if (err)
 		return err;
 
-	if (osc & MCP25XXFD_REG_OSC_LPMEN)
-		devtype_data = &mcp25xxfd_devtype_data_mcp2518fd;
+	if (osc & MCP251XFD_REG_OSC_LPMEN)
+		devtype_data = &mcp251xfd_devtype_data_mcp2518fd;
 	else
-		devtype_data = &mcp25xxfd_devtype_data_mcp2517fd;
+		devtype_data = &mcp251xfd_devtype_data_mcp2517fd;
 
-	if (!mcp25xxfd_is_251X(priv) &&
+	if (!mcp251xfd_is_251X(priv) &&
 	    priv->devtype_data.model != devtype_data->model) {
 		netdev_info(ndev,
 			    "Detected %s, but firmware specifies a %s. Fixing up.",
-			    __mcp25xxfd_get_model_str(devtype_data->model),
-			    mcp25xxfd_get_model_str(priv));
+			    __mcp251xfd_get_model_str(devtype_data->model),
+			    mcp251xfd_get_model_str(priv));
 	}
 	priv->devtype_data = *devtype_data;
 
 	/* We need to preserve the Half Duplex Quirk. */
-	mcp25xxfd_register_quirks(priv);
+	mcp251xfd_register_quirks(priv);
 
 	/* Re-init regmap with quirks of detected model. */
-	return mcp25xxfd_regmap_init(priv);
+	return mcp251xfd_regmap_init(priv);
 }
 
-static int mcp25xxfd_register_check_rx_int(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_register_check_rx_int(struct mcp251xfd_priv *priv)
 {
 	int err, rx_pending;
 
 	if (!priv->rx_int)
 		return 0;
 
-	err = mcp25xxfd_chip_rx_int_enable(priv);
+	err = mcp251xfd_chip_rx_int_enable(priv);
 	if (err)
 		return err;
 
@@ -2526,7 +2526,7 @@ static int mcp25xxfd_register_check_rx_int(struct mcp25xxfd_priv *priv)
 	 */
 	rx_pending = gpiod_get_value_cansleep(priv->rx_int);
 
-	err = mcp25xxfd_chip_rx_int_disable(priv);
+	err = mcp251xfd_chip_rx_int_disable(priv);
 	if (err)
 		return err;
 
@@ -2542,11 +2542,11 @@ static int mcp25xxfd_register_check_rx_int(struct mcp25xxfd_priv *priv)
 }
 
 static int
-mcp25xxfd_register_get_dev_id(const struct mcp25xxfd_priv *priv,
+mcp251xfd_register_get_dev_id(const struct mcp251xfd_priv *priv,
 			      u32 *dev_id, u32 *effective_speed_hz)
 {
-	struct mcp25xxfd_map_buf_nocrc *buf_rx;
-	struct mcp25xxfd_map_buf_nocrc *buf_tx;
+	struct mcp251xfd_map_buf_nocrc *buf_rx;
+	struct mcp251xfd_map_buf_nocrc *buf_tx;
 	struct spi_transfer xfer[2] = { };
 	int err;
 
@@ -2565,7 +2565,7 @@ mcp25xxfd_register_get_dev_id(const struct mcp25xxfd_priv *priv,
 	xfer[1].rx_buf = buf_rx->data;
 	xfer[1].len = sizeof(dev_id);
 
-	mcp25xxfd_spi_cmd_read_nocrc(&buf_tx->cmd, MCP25XXFD_REG_DEVID);
+	mcp251xfd_spi_cmd_read_nocrc(&buf_tx->cmd, MCP251XFD_REG_DEVID);
 	err = spi_sync_transfer(priv->spi, xfer, ARRAY_SIZE(xfer));
 	if (err)
 		goto out_kfree_buf_tx;
@@ -2581,32 +2581,32 @@ mcp25xxfd_register_get_dev_id(const struct mcp25xxfd_priv *priv,
 	return 0;
 }
 
-#define MCP25XXFD_QUIRK_ACTIVE(quirk) \
-	(priv->devtype_data.quirks & MCP25XXFD_QUIRK_##quirk ? '+' : '-')
+#define MCP251XFD_QUIRK_ACTIVE(quirk) \
+	(priv->devtype_data.quirks & MCP251XFD_QUIRK_##quirk ? '+' : '-')
 
 static int
-mcp25xxfd_register_done(const struct mcp25xxfd_priv *priv)
+mcp251xfd_register_done(const struct mcp251xfd_priv *priv)
 {
 	u32 dev_id, effective_speed_hz;
 	int err;
 
-	err = mcp25xxfd_register_get_dev_id(priv, &dev_id,
+	err = mcp251xfd_register_get_dev_id(priv, &dev_id,
 					    &effective_speed_hz);
 	if (err)
 		return err;
 
 	netdev_info(priv->ndev,
 		    "%s rev%lu.%lu (%cRX_INT %cMAB_NO_WARN %cCRC_REG %cCRC_RX %cCRC_TX %cECC %cHD c:%u.%02uMHz m:%u.%02uMHz r:%u.%02uMHz e:%u.%02uMHz) successfully initialized.\n",
-		    mcp25xxfd_get_model_str(priv),
-		    FIELD_GET(MCP25XXFD_REG_DEVID_ID_MASK, dev_id),
-		    FIELD_GET(MCP25XXFD_REG_DEVID_REV_MASK, dev_id),
+		    mcp251xfd_get_model_str(priv),
+		    FIELD_GET(MCP251XFD_REG_DEVID_ID_MASK, dev_id),
+		    FIELD_GET(MCP251XFD_REG_DEVID_REV_MASK, dev_id),
 		    priv->rx_int ? '+' : '-',
-		    MCP25XXFD_QUIRK_ACTIVE(MAB_NO_WARN),
-		    MCP25XXFD_QUIRK_ACTIVE(CRC_REG),
-		    MCP25XXFD_QUIRK_ACTIVE(CRC_RX),
-		    MCP25XXFD_QUIRK_ACTIVE(CRC_TX),
-		    MCP25XXFD_QUIRK_ACTIVE(ECC),
-		    MCP25XXFD_QUIRK_ACTIVE(HALF_DUPLEX),
+		    MCP251XFD_QUIRK_ACTIVE(MAB_NO_WARN),
+		    MCP251XFD_QUIRK_ACTIVE(CRC_REG),
+		    MCP251XFD_QUIRK_ACTIVE(CRC_RX),
+		    MCP251XFD_QUIRK_ACTIVE(CRC_TX),
+		    MCP251XFD_QUIRK_ACTIVE(ECC),
+		    MCP251XFD_QUIRK_ACTIVE(HALF_DUPLEX),
 		    priv->can.clock.freq / 1000000,
 		    priv->can.clock.freq % 1000000 / 1000 / 10,
 		    priv->spi_max_speed_hz_orig / 1000000,
@@ -2619,12 +2619,12 @@ mcp25xxfd_register_done(const struct mcp25xxfd_priv *priv)
 	return 0;
 }
 
-static int mcp25xxfd_register(struct mcp25xxfd_priv *priv)
+static int mcp251xfd_register(struct mcp251xfd_priv *priv)
 {
 	struct net_device *ndev = priv->ndev;
 	int err;
 
-	err = mcp25xxfd_clks_and_vdd_enable(priv);
+	err = mcp251xfd_clks_and_vdd_enable(priv);
 	if (err)
 		return err;
 
@@ -2634,19 +2634,19 @@ static int mcp25xxfd_register(struct mcp25xxfd_priv *priv)
 		goto out_runtime_put_noidle;
 	pm_runtime_enable(ndev->dev.parent);
 
-	mcp25xxfd_register_quirks(priv);
+	mcp251xfd_register_quirks(priv);
 
-	err = mcp25xxfd_chip_softreset(priv);
+	err = mcp251xfd_chip_softreset(priv);
 	if (err == -ENODEV)
 		goto out_runtime_disable;
 	if (err)
 		goto out_chip_set_mode_sleep;
 
-	err = mcp25xxfd_register_chip_detect(priv);
+	err = mcp251xfd_register_chip_detect(priv);
 	if (err)
 		goto out_chip_set_mode_sleep;
 
-	err = mcp25xxfd_register_check_rx_int(priv);
+	err = mcp251xfd_register_check_rx_int(priv);
 	if (err)
 		goto out_chip_set_mode_sleep;
 
@@ -2654,7 +2654,7 @@ static int mcp25xxfd_register(struct mcp25xxfd_priv *priv)
 	if (err)
 		goto out_chip_set_mode_sleep;
 
-	err = mcp25xxfd_register_done(priv);
+	err = mcp251xfd_register_done(priv);
 	if (err)
 		goto out_unregister_candev;
 
@@ -2662,7 +2662,7 @@ static int mcp25xxfd_register(struct mcp25xxfd_priv *priv)
 	 * disable the clocks and vdd. If CONFIG_PM is not enabled,
 	 * the clocks and vdd will stay powered.
 	 */
-	err = mcp25xxfd_chip_set_mode(priv, MCP25XXFD_REG_CON_MODE_SLEEP);
+	err = mcp251xfd_chip_set_mode(priv, MCP251XFD_REG_CON_MODE_SLEEP);
 	if (err)
 		goto out_unregister_candev;
 
@@ -2673,17 +2673,17 @@ static int mcp25xxfd_register(struct mcp25xxfd_priv *priv)
  out_unregister_candev:
 	unregister_candev(ndev);
  out_chip_set_mode_sleep:
-	mcp25xxfd_chip_set_mode(priv, MCP25XXFD_REG_CON_MODE_SLEEP);
+	mcp251xfd_chip_set_mode(priv, MCP251XFD_REG_CON_MODE_SLEEP);
  out_runtime_disable:
 	pm_runtime_disable(ndev->dev.parent);
  out_runtime_put_noidle:
 	pm_runtime_put_noidle(ndev->dev.parent);
-	mcp25xxfd_clks_and_vdd_disable(priv);
+	mcp251xfd_clks_and_vdd_disable(priv);
 
 	return err;
 }
 
-static inline void mcp25xxfd_unregister(struct mcp25xxfd_priv *priv)
+static inline void mcp251xfd_unregister(struct mcp251xfd_priv *priv)
 {
 	struct net_device *ndev	= priv->ndev;
 
@@ -2691,47 +2691,47 @@ static inline void mcp25xxfd_unregister(struct mcp25xxfd_priv *priv)
 
 	pm_runtime_get_sync(ndev->dev.parent);
 	pm_runtime_put_noidle(ndev->dev.parent);
-	mcp25xxfd_clks_and_vdd_disable(priv);
+	mcp251xfd_clks_and_vdd_disable(priv);
 	pm_runtime_disable(ndev->dev.parent);
 }
 
-static const struct of_device_id mcp25xxfd_of_match[] = {
+static const struct of_device_id mcp251xfd_of_match[] = {
 	{
 		.compatible = "microchip,mcp2517fd",
-		.data = &mcp25xxfd_devtype_data_mcp2517fd,
+		.data = &mcp251xfd_devtype_data_mcp2517fd,
 	}, {
 		.compatible = "microchip,mcp2518fd",
-		.data = &mcp25xxfd_devtype_data_mcp2518fd,
+		.data = &mcp251xfd_devtype_data_mcp2518fd,
 	}, {
 		.compatible = "microchip,mcp251xfd",
-		.data = &mcp25xxfd_devtype_data_mcp251xfd,
+		.data = &mcp251xfd_devtype_data_mcp251xfd,
 	}, {
 		/* sentinel */
 	},
 };
-MODULE_DEVICE_TABLE(of, mcp25xxfd_of_match);
+MODULE_DEVICE_TABLE(of, mcp251xfd_of_match);
 
-static const struct spi_device_id mcp25xxfd_id_table[] = {
+static const struct spi_device_id mcp251xfd_id_table[] = {
 	{
 		.name = "mcp2517fd",
-		.driver_data = (kernel_ulong_t)&mcp25xxfd_devtype_data_mcp2517fd,
+		.driver_data = (kernel_ulong_t)&mcp251xfd_devtype_data_mcp2517fd,
 	}, {
 		.name = "mcp2518fd",
-		.driver_data = (kernel_ulong_t)&mcp25xxfd_devtype_data_mcp2518fd,
+		.driver_data = (kernel_ulong_t)&mcp251xfd_devtype_data_mcp2518fd,
 	}, {
 		.name = "mcp251xfd",
-		.driver_data = (kernel_ulong_t)&mcp25xxfd_devtype_data_mcp251xfd,
+		.driver_data = (kernel_ulong_t)&mcp251xfd_devtype_data_mcp251xfd,
 	}, {
 		/* sentinel */
 	},
 };
-MODULE_DEVICE_TABLE(spi, mcp25xxfd_id_table);
+MODULE_DEVICE_TABLE(spi, mcp251xfd_id_table);
 
-static int mcp25xxfd_probe(struct spi_device *spi)
+static int mcp251xfd_probe(struct spi_device *spi)
 {
 	const void *match;
 	struct net_device *ndev;
-	struct mcp25xxfd_priv *priv;
+	struct mcp251xfd_priv *priv;
 	struct gpio_desc *rx_int;
 	struct regulator *reg_vdd, *reg_xceiver;
 	struct clk *clk;
@@ -2769,39 +2769,39 @@ static int mcp25xxfd_probe(struct spi_device *spi)
 	freq = clk_get_rate(clk);
 
 	/* Sanity check */
-	if (freq < MCP25XXFD_SYSCLOCK_HZ_MIN ||
-	    freq > MCP25XXFD_SYSCLOCK_HZ_MAX) {
+	if (freq < MCP251XFD_SYSCLOCK_HZ_MIN ||
+	    freq > MCP251XFD_SYSCLOCK_HZ_MAX) {
 		dev_err(&spi->dev,
 			"Oscillator frequency (%u Hz) is too low or high.\n",
 			freq);
 		return -ERANGE;
 	}
 
-	if (freq <= MCP25XXFD_SYSCLOCK_HZ_MAX / MCP25XXFD_OSC_PLL_MULTIPLIER) {
+	if (freq <= MCP251XFD_SYSCLOCK_HZ_MAX / MCP251XFD_OSC_PLL_MULTIPLIER) {
 		dev_err(&spi->dev,
 			"Oscillator frequency (%u Hz) is too low and PLL is not supported.\n",
 			freq);
 		return -ERANGE;
 	}
 
-	ndev = alloc_candev(sizeof(struct mcp25xxfd_priv),
-			    MCP25XXFD_TX_OBJ_NUM_MAX);
+	ndev = alloc_candev(sizeof(struct mcp251xfd_priv),
+			    MCP251XFD_TX_OBJ_NUM_MAX);
 	if (!ndev)
 		return -ENOMEM;
 
 	SET_NETDEV_DEV(ndev, &spi->dev);
 
-	ndev->netdev_ops = &mcp25xxfd_netdev_ops;
+	ndev->netdev_ops = &mcp251xfd_netdev_ops;
 	ndev->irq = spi->irq;
 	ndev->flags |= IFF_ECHO;
 
 	priv = netdev_priv(ndev);
 	spi_set_drvdata(spi, priv);
 	priv->can.clock.freq = freq;
-	priv->can.do_set_mode = mcp25xxfd_set_mode;
-	priv->can.do_get_berr_counter = mcp25xxfd_get_berr_counter;
-	priv->can.bittiming_const = &mcp25xxfd_bittiming_const;
-	priv->can.data_bittiming_const = &mcp25xxfd_data_bittiming_const;
+	priv->can.do_set_mode = mcp251xfd_set_mode;
+	priv->can.do_get_berr_counter = mcp251xfd_get_berr_counter;
+	priv->can.bittiming_const = &mcp251xfd_bittiming_const;
+	priv->can.data_bittiming_const = &mcp251xfd_data_bittiming_const;
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LISTENONLY |
 		CAN_CTRLMODE_BERR_REPORTING | CAN_CTRLMODE_FD |
 		CAN_CTRLMODE_FD_NON_ISO;
@@ -2814,9 +2814,9 @@ static int mcp25xxfd_probe(struct spi_device *spi)
 
 	match = device_get_match_data(&spi->dev);
 	if (match)
-		priv->devtype_data = *(struct mcp25xxfd_devtype_data *)match;
+		priv->devtype_data = *(struct mcp251xfd_devtype_data *)match;
 	else
-		priv->devtype_data = *(struct mcp25xxfd_devtype_data *)
+		priv->devtype_data = *(struct mcp251xfd_devtype_data *)
 			spi_get_device_id(spi)->driver_data;
 
 	/* Errata Reference:
@@ -2855,16 +2855,16 @@ static int mcp25xxfd_probe(struct spi_device *spi)
 	if (err)
 		goto out_free_candev;
 
-	err = mcp25xxfd_regmap_init(priv);
+	err = mcp251xfd_regmap_init(priv);
 	if (err)
 		goto out_free_candev;
 
 	err = can_rx_offload_add_manual(ndev, &priv->offload,
-					MCP25XXFD_NAPI_WEIGHT);
+					MCP251XFD_NAPI_WEIGHT);
 	if (err)
 		goto out_free_candev;
 
-	err = mcp25xxfd_register(priv);
+	err = mcp251xfd_register(priv);
 	if (err)
 		goto out_free_candev;
 
@@ -2878,49 +2878,49 @@ static int mcp25xxfd_probe(struct spi_device *spi)
 	return err;
 }
 
-static int mcp25xxfd_remove(struct spi_device *spi)
+static int mcp251xfd_remove(struct spi_device *spi)
 {
-	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
+	struct mcp251xfd_priv *priv = spi_get_drvdata(spi);
 	struct net_device *ndev = priv->ndev;
 
 	can_rx_offload_del(&priv->offload);
-	mcp25xxfd_unregister(priv);
+	mcp251xfd_unregister(priv);
 	spi->max_speed_hz = priv->spi_max_speed_hz_orig;
 	free_candev(ndev);
 
 	return 0;
 }
 
-static int __maybe_unused mcp25xxfd_runtime_suspend(struct device *device)
+static int __maybe_unused mcp251xfd_runtime_suspend(struct device *device)
 {
-	const struct mcp25xxfd_priv *priv = dev_get_drvdata(device);
+	const struct mcp251xfd_priv *priv = dev_get_drvdata(device);
 
-	return mcp25xxfd_clks_and_vdd_disable(priv);
+	return mcp251xfd_clks_and_vdd_disable(priv);
 }
 
-static int __maybe_unused mcp25xxfd_runtime_resume(struct device *device)
+static int __maybe_unused mcp251xfd_runtime_resume(struct device *device)
 {
-	const struct mcp25xxfd_priv *priv = dev_get_drvdata(device);
+	const struct mcp251xfd_priv *priv = dev_get_drvdata(device);
 
-	return mcp25xxfd_clks_and_vdd_enable(priv);
+	return mcp251xfd_clks_and_vdd_enable(priv);
 }
 
-static const struct dev_pm_ops mcp25xxfd_pm_ops = {
-	SET_RUNTIME_PM_OPS(mcp25xxfd_runtime_suspend,
-			   mcp25xxfd_runtime_resume, NULL)
+static const struct dev_pm_ops mcp251xfd_pm_ops = {
+	SET_RUNTIME_PM_OPS(mcp251xfd_runtime_suspend,
+			   mcp251xfd_runtime_resume, NULL)
 };
 
-static struct spi_driver mcp25xxfd_driver = {
+static struct spi_driver mcp251xfd_driver = {
 	.driver = {
 		.name = DEVICE_NAME,
-		.pm = &mcp25xxfd_pm_ops,
-		.of_match_table = mcp25xxfd_of_match,
+		.pm = &mcp251xfd_pm_ops,
+		.of_match_table = mcp251xfd_of_match,
 	},
-	.probe = mcp25xxfd_probe,
-	.remove = mcp25xxfd_remove,
-	.id_table = mcp25xxfd_id_table,
+	.probe = mcp251xfd_probe,
+	.remove = mcp251xfd_remove,
+	.id_table = mcp251xfd_id_table,
 };
-module_spi_driver(mcp25xxfd_driver);
+module_spi_driver(mcp251xfd_driver);
 
 MODULE_AUTHOR("Marc Kleine-Budde <mkl@pengutronix.de>");
 MODULE_DESCRIPTION("Microchip MCP251xFD Family CAN controller driver");
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-crc16.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-crc16.c
index bc90afb34df2..a02ca76ac239 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-crc16.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-crc16.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 //
-// mcp25xxfd - Microchip MCP25xxFD Family CAN controller driver
+// mcp251xfd - Microchip MCP251xFD Family CAN controller driver
 //
 // Copyright (c) 2020 Pengutronix,
 //                    Marc Kleine-Budde <kernel@pengutronix.de>
@@ -20,7 +20,7 @@
  *
  * http://lkml.iu.edu/hypermail/linux/kernel/0508.1/1085.html
  */
-static const u16 mcp25xxfd_crc16_table[] = {
+static const u16 mcp251xfd_crc16_table[] = {
 	0x0000, 0x8005, 0x800f, 0x000a, 0x801b, 0x001e, 0x0014, 0x8011,
 	0x8033, 0x0036, 0x003c, 0x8039, 0x0028, 0x802d, 0x8027, 0x0022,
 	0x8063, 0x0066, 0x006c, 0x8069, 0x0078, 0x807d, 0x8077, 0x0072,
@@ -55,35 +55,35 @@ static const u16 mcp25xxfd_crc16_table[] = {
 	0x8213, 0x0216, 0x021c, 0x8219, 0x0208, 0x820d, 0x8207, 0x0202
 };
 
-static inline u16 mcp25xxfd_crc16_byte(u16 crc, const u8 data)
+static inline u16 mcp251xfd_crc16_byte(u16 crc, const u8 data)
 {
 	u8 index = (crc >> 8) ^ data;
 
-	return (crc << 8) ^ mcp25xxfd_crc16_table[index];
+	return (crc << 8) ^ mcp251xfd_crc16_table[index];
 }
 
-static u16 mcp25xxfd_crc16(u16 crc, u8 const *buffer, size_t len)
+static u16 mcp251xfd_crc16(u16 crc, u8 const *buffer, size_t len)
 {
 	while (len--)
-		crc = mcp25xxfd_crc16_byte(crc, *buffer++);
+		crc = mcp251xfd_crc16_byte(crc, *buffer++);
 
 	return crc;
 }
 
-u16 mcp25xxfd_crc16_compute(const void *data, size_t data_size)
+u16 mcp251xfd_crc16_compute(const void *data, size_t data_size)
 {
 	u16 crc = 0xffff;
 
-	return mcp25xxfd_crc16(crc, data, data_size);
+	return mcp251xfd_crc16(crc, data, data_size);
 }
 
-u16 mcp25xxfd_crc16_compute2(const void *cmd, size_t cmd_size,
+u16 mcp251xfd_crc16_compute2(const void *cmd, size_t cmd_size,
 			     const void *data, size_t data_size)
 {
 	u16 crc;
 
-	crc = mcp25xxfd_crc16_compute(cmd, cmd_size);
-	crc = mcp25xxfd_crc16(crc, data, data_size);
+	crc = mcp251xfd_crc16_compute(cmd, cmd_size);
+	crc = mcp251xfd_crc16(crc, data, data_size);
 
 	return crc;
 }
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
index 3511317bb49b..ba25902dd78c 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 //
-// mcp25xxfd - Microchip MCP25xxFD Family CAN controller driver
+// mcp251xfd - Microchip MCP251xFD Family CAN controller driver
 //
 // Copyright (c) 2019, 2020 Pengutronix,
 //                          Marc Kleine-Budde <kernel@pengutronix.de>
@@ -10,10 +10,10 @@
 
 #include <asm/unaligned.h>
 
-static const struct regmap_config mcp25xxfd_regmap_crc;
+static const struct regmap_config mcp251xfd_regmap_crc;
 
 static int
-mcp25xxfd_regmap_nocrc_write(void *context, const void *data, size_t count)
+mcp251xfd_regmap_nocrc_write(void *context, const void *data, size_t count)
 {
 	struct spi_device *spi = context;
 
@@ -21,13 +21,13 @@ mcp25xxfd_regmap_nocrc_write(void *context, const void *data, size_t count)
 }
 
 static int
-mcp25xxfd_regmap_nocrc_gather_write(void *context,
+mcp251xfd_regmap_nocrc_gather_write(void *context,
 				    const void *reg, size_t reg_len,
 				    const void *val, size_t val_len)
 {
 	struct spi_device *spi = context;
-	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
-	struct mcp25xxfd_map_buf_nocrc *buf_tx = priv->map_buf_nocrc_tx;
+	struct mcp251xfd_priv *priv = spi_get_drvdata(spi);
+	struct mcp251xfd_map_buf_nocrc *buf_tx = priv->map_buf_nocrc_tx;
 	struct spi_transfer xfer[] = {
 		{
 			.tx_buf = buf_tx,
@@ -37,7 +37,7 @@ mcp25xxfd_regmap_nocrc_gather_write(void *context,
 
 	BUILD_BUG_ON(sizeof(buf_tx->cmd) != sizeof(__be16));
 
-	if (IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY) &&
+	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
 	    reg_len != sizeof(buf_tx->cmd.cmd))
 		return -EINVAL;
 
@@ -47,20 +47,20 @@ mcp25xxfd_regmap_nocrc_gather_write(void *context,
 	return spi_sync_transfer(spi, xfer, ARRAY_SIZE(xfer));
 }
 
-static inline bool mcp25xxfd_update_bits_read_reg(unsigned int reg)
+static inline bool mcp251xfd_update_bits_read_reg(unsigned int reg)
 {
 	switch (reg) {
-	case MCP25XXFD_REG_INT:
-	case MCP25XXFD_REG_TEFCON:
-	case MCP25XXFD_REG_FIFOCON(MCP25XXFD_RX_FIFO(0)):
-	case MCP25XXFD_REG_FLTCON(0):
-	case MCP25XXFD_REG_ECCSTAT:
-	case MCP25XXFD_REG_CRC:
+	case MCP251XFD_REG_INT:
+	case MCP251XFD_REG_TEFCON:
+	case MCP251XFD_REG_FIFOCON(MCP251XFD_RX_FIFO(0)):
+	case MCP251XFD_REG_FLTCON(0):
+	case MCP251XFD_REG_ECCSTAT:
+	case MCP251XFD_REG_CRC:
 		return false;
-	case MCP25XXFD_REG_CON:
-	case MCP25XXFD_REG_FIFOSTA(MCP25XXFD_RX_FIFO(0)):
-	case MCP25XXFD_REG_OSC:
-	case MCP25XXFD_REG_ECCCON:
+	case MCP251XFD_REG_CON:
+	case MCP251XFD_REG_FIFOSTA(MCP251XFD_RX_FIFO(0)):
+	case MCP251XFD_REG_OSC:
+	case MCP251XFD_REG_ECCCON:
 		return true;
 	default:
 		WARN(1, "Status of reg 0x%04x unknown.\n", reg);
@@ -70,13 +70,13 @@ static inline bool mcp25xxfd_update_bits_read_reg(unsigned int reg)
 }
 
 static int
-mcp25xxfd_regmap_nocrc_update_bits(void *context, unsigned int reg,
+mcp251xfd_regmap_nocrc_update_bits(void *context, unsigned int reg,
 				   unsigned int mask, unsigned int val)
 {
 	struct spi_device *spi = context;
-	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
-	struct mcp25xxfd_map_buf_nocrc *buf_rx = priv->map_buf_nocrc_rx;
-	struct mcp25xxfd_map_buf_nocrc *buf_tx = priv->map_buf_nocrc_tx;
+	struct mcp251xfd_priv *priv = spi_get_drvdata(spi);
+	struct mcp251xfd_map_buf_nocrc *buf_rx = priv->map_buf_nocrc_rx;
+	struct mcp251xfd_map_buf_nocrc *buf_tx = priv->map_buf_nocrc_tx;
 	__le32 orig_le32 = 0, mask_le32, val_le32, tmp_le32;
 	u8 first_byte, last_byte, len;
 	int err;
@@ -84,22 +84,22 @@ mcp25xxfd_regmap_nocrc_update_bits(void *context, unsigned int reg,
 	BUILD_BUG_ON(sizeof(buf_rx->cmd) != sizeof(__be16));
 	BUILD_BUG_ON(sizeof(buf_tx->cmd) != sizeof(__be16));
 
-	if (IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY) &&
+	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
 	    mask == 0)
 		return -EINVAL;
 
-	first_byte = mcp25xxfd_first_byte_set(mask);
-	last_byte = mcp25xxfd_last_byte_set(mask);
+	first_byte = mcp251xfd_first_byte_set(mask);
+	last_byte = mcp251xfd_last_byte_set(mask);
 	len = last_byte - first_byte + 1;
 
-	if (mcp25xxfd_update_bits_read_reg(reg)) {
+	if (mcp251xfd_update_bits_read_reg(reg)) {
 		struct spi_transfer xfer[2] = { };
 		struct spi_message msg;
 
 		spi_message_init(&msg);
 		spi_message_add_tail(&xfer[0], &msg);
 
-		if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_HALF_DUPLEX) {
+		if (priv->devtype_data.quirks & MCP251XFD_QUIRK_HALF_DUPLEX) {
 			xfer[0].tx_buf = buf_tx;
 			xfer[0].len = sizeof(buf_tx->cmd);
 
@@ -111,11 +111,11 @@ mcp25xxfd_regmap_nocrc_update_bits(void *context, unsigned int reg,
 			xfer[0].rx_buf = buf_rx;
 			xfer[0].len = sizeof(buf_tx->cmd) + len;
 
-			if (MCP25XXFD_SANITIZE_SPI)
+			if (MCP251XFD_SANITIZE_SPI)
 				memset(buf_tx->data, 0x0, len);
 		}
 
-		mcp25xxfd_spi_cmd_read_nocrc(&buf_tx->cmd, reg + first_byte);
+		mcp251xfd_spi_cmd_read_nocrc(&buf_tx->cmd, reg + first_byte);
 		err = spi_sync(spi, &msg);
 		if (err)
 			return err;
@@ -129,21 +129,21 @@ mcp25xxfd_regmap_nocrc_update_bits(void *context, unsigned int reg,
 	tmp_le32 = orig_le32 & ~mask_le32;
 	tmp_le32 |= val_le32 & mask_le32;
 
-	mcp25xxfd_spi_cmd_write_nocrc(&buf_tx->cmd, reg + first_byte);
+	mcp251xfd_spi_cmd_write_nocrc(&buf_tx->cmd, reg + first_byte);
 	memcpy(buf_tx->data, &tmp_le32, len);
 
 	return spi_write(spi, buf_tx, sizeof(buf_tx->cmd) + len);
 }
 
 static int
-mcp25xxfd_regmap_nocrc_read(void *context,
+mcp251xfd_regmap_nocrc_read(void *context,
 			    const void *reg, size_t reg_len,
 			    void *val_buf, size_t val_len)
 {
 	struct spi_device *spi = context;
-	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
-	struct mcp25xxfd_map_buf_nocrc *buf_rx = priv->map_buf_nocrc_rx;
-	struct mcp25xxfd_map_buf_nocrc *buf_tx = priv->map_buf_nocrc_tx;
+	struct mcp251xfd_priv *priv = spi_get_drvdata(spi);
+	struct mcp251xfd_map_buf_nocrc *buf_rx = priv->map_buf_nocrc_rx;
+	struct mcp251xfd_map_buf_nocrc *buf_tx = priv->map_buf_nocrc_tx;
 	struct spi_transfer xfer[2] = { };
 	struct spi_message msg;
 	int err;
@@ -151,14 +151,14 @@ mcp25xxfd_regmap_nocrc_read(void *context,
 	BUILD_BUG_ON(sizeof(buf_rx->cmd) != sizeof(__be16));
 	BUILD_BUG_ON(sizeof(buf_tx->cmd) != sizeof(__be16));
 
-	if (IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY) &&
+	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
 	    reg_len != sizeof(buf_tx->cmd.cmd))
 		return -EINVAL;
 
 	spi_message_init(&msg);
 	spi_message_add_tail(&xfer[0], &msg);
 
-	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_HALF_DUPLEX) {
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_HALF_DUPLEX) {
 		xfer[0].tx_buf = reg;
 		xfer[0].len = sizeof(buf_tx->cmd);
 
@@ -171,7 +171,7 @@ mcp25xxfd_regmap_nocrc_read(void *context,
 		xfer[0].len = sizeof(buf_tx->cmd) + val_len;
 
 		memcpy(&buf_tx->cmd, reg, sizeof(buf_tx->cmd));
-		if (MCP25XXFD_SANITIZE_SPI)
+		if (MCP251XFD_SANITIZE_SPI)
 			memset(buf_tx->data, 0x0, val_len);
 	};
 
@@ -179,20 +179,20 @@ mcp25xxfd_regmap_nocrc_read(void *context,
 	if (err)
 		return err;
 
-	if (!(priv->devtype_data.quirks & MCP25XXFD_QUIRK_HALF_DUPLEX))
+	if (!(priv->devtype_data.quirks & MCP251XFD_QUIRK_HALF_DUPLEX))
 		memcpy(val_buf, buf_rx->data, val_len);
 
 	return 0;
 }
 
 static int
-mcp25xxfd_regmap_crc_gather_write(void *context,
+mcp251xfd_regmap_crc_gather_write(void *context,
 				  const void *reg_p, size_t reg_len,
 				  const void *val, size_t val_len)
 {
 	struct spi_device *spi = context;
-	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
-	struct mcp25xxfd_map_buf_crc *buf_tx = priv->map_buf_crc_tx;
+	struct mcp251xfd_priv *priv = spi_get_drvdata(spi);
+	struct mcp251xfd_map_buf_crc *buf_tx = priv->map_buf_crc_tx;
 	struct spi_transfer xfer[] = {
 		{
 			.tx_buf = buf_tx,
@@ -205,39 +205,39 @@ mcp25xxfd_regmap_crc_gather_write(void *context,
 
 	BUILD_BUG_ON(sizeof(buf_tx->cmd) != sizeof(__be16) + sizeof(u8));
 
-	if (IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY) &&
+	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
 	    reg_len != sizeof(buf_tx->cmd.cmd) +
-	    mcp25xxfd_regmap_crc.pad_bits / BITS_PER_BYTE)
+	    mcp251xfd_regmap_crc.pad_bits / BITS_PER_BYTE)
 		return -EINVAL;
 
-	mcp25xxfd_spi_cmd_write_crc(&buf_tx->cmd, reg, val_len);
+	mcp251xfd_spi_cmd_write_crc(&buf_tx->cmd, reg, val_len);
 	memcpy(buf_tx->data, val, val_len);
 
-	crc = mcp25xxfd_crc16_compute(buf_tx, sizeof(buf_tx->cmd) + val_len);
+	crc = mcp251xfd_crc16_compute(buf_tx, sizeof(buf_tx->cmd) + val_len);
 	put_unaligned_be16(crc, buf_tx->data + val_len);
 
 	return spi_sync_transfer(spi, xfer, ARRAY_SIZE(xfer));
 }
 
 static int
-mcp25xxfd_regmap_crc_write(void *context,
+mcp251xfd_regmap_crc_write(void *context,
 			   const void *data, size_t count)
 {
 	const size_t data_offset = sizeof(__be16) +
-		mcp25xxfd_regmap_crc.pad_bits / BITS_PER_BYTE;
+		mcp251xfd_regmap_crc.pad_bits / BITS_PER_BYTE;
 
-	return mcp25xxfd_regmap_crc_gather_write(context,
+	return mcp251xfd_regmap_crc_gather_write(context,
 						 data, data_offset,
 						 data + data_offset,
 						 count - data_offset);
 }
 
 static int
-mcp25xxfd_regmap_crc_read_one(struct mcp25xxfd_priv *priv,
+mcp251xfd_regmap_crc_read_one(struct mcp251xfd_priv *priv,
 			      struct spi_message *msg, unsigned int data_len)
 {
-	const struct mcp25xxfd_map_buf_crc *buf_rx = priv->map_buf_crc_rx;
-	const struct mcp25xxfd_map_buf_crc *buf_tx = priv->map_buf_crc_tx;
+	const struct mcp251xfd_map_buf_crc *buf_rx = priv->map_buf_crc_rx;
+	const struct mcp251xfd_map_buf_crc *buf_tx = priv->map_buf_crc_tx;
 	u16 crc_received, crc_calculated;
 	int err;
 
@@ -249,7 +249,7 @@ mcp25xxfd_regmap_crc_read_one(struct mcp25xxfd_priv *priv,
 		return err;
 
 	crc_received = get_unaligned_be16(buf_rx->data + data_len);
-	crc_calculated = mcp25xxfd_crc16_compute2(&buf_tx->cmd,
+	crc_calculated = mcp251xfd_crc16_compute2(&buf_tx->cmd,
 						  sizeof(buf_tx->cmd),
 						  buf_rx->data,
 						  data_len);
@@ -260,14 +260,14 @@ mcp25xxfd_regmap_crc_read_one(struct mcp25xxfd_priv *priv,
 }
 
 static int
-mcp25xxfd_regmap_crc_read(void *context,
+mcp251xfd_regmap_crc_read(void *context,
 			  const void *reg_p, size_t reg_len,
 			  void *val_buf, size_t val_len)
 {
 	struct spi_device *spi = context;
-	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
-	struct mcp25xxfd_map_buf_crc *buf_rx = priv->map_buf_crc_rx;
-	struct mcp25xxfd_map_buf_crc *buf_tx = priv->map_buf_crc_tx;
+	struct mcp251xfd_priv *priv = spi_get_drvdata(spi);
+	struct mcp251xfd_map_buf_crc *buf_rx = priv->map_buf_crc_rx;
+	struct mcp251xfd_map_buf_crc *buf_tx = priv->map_buf_crc_tx;
 	struct spi_transfer xfer[2] = { };
 	struct spi_message msg;
 	u16 reg = *(u16 *)reg_p;
@@ -276,15 +276,15 @@ mcp25xxfd_regmap_crc_read(void *context,
 	BUILD_BUG_ON(sizeof(buf_rx->cmd) != sizeof(__be16) + sizeof(u8));
 	BUILD_BUG_ON(sizeof(buf_tx->cmd) != sizeof(__be16) + sizeof(u8));
 
-	if (IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY) &&
+	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
 	    reg_len != sizeof(buf_tx->cmd.cmd) +
-	    mcp25xxfd_regmap_crc.pad_bits / BITS_PER_BYTE)
+	    mcp251xfd_regmap_crc.pad_bits / BITS_PER_BYTE)
 		return -EINVAL;
 
 	spi_message_init(&msg);
 	spi_message_add_tail(&xfer[0], &msg);
 
-	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_HALF_DUPLEX) {
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_HALF_DUPLEX) {
 		xfer[0].tx_buf = buf_tx;
 		xfer[0].len = sizeof(buf_tx->cmd);
 
@@ -297,21 +297,21 @@ mcp25xxfd_regmap_crc_read(void *context,
 		xfer[0].len = sizeof(buf_tx->cmd) + val_len +
 			sizeof(buf_tx->crc);
 
-		if (MCP25XXFD_SANITIZE_SPI)
+		if (MCP251XFD_SANITIZE_SPI)
 			memset(buf_tx->data, 0x0, val_len +
 			       sizeof(buf_tx->crc));
 	}
 
-	mcp25xxfd_spi_cmd_read_crc(&buf_tx->cmd, reg, val_len);
+	mcp251xfd_spi_cmd_read_crc(&buf_tx->cmd, reg, val_len);
 
-	for (i = 0; i < MCP25XXFD_READ_CRC_RETRIES_MAX; i++) {
-		err = mcp25xxfd_regmap_crc_read_one(priv, &msg, val_len);
+	for (i = 0; i < MCP251XFD_READ_CRC_RETRIES_MAX; i++) {
+		err = mcp251xfd_regmap_crc_read_one(priv, &msg, val_len);
 		if (!err)
 			goto out;
 		if (err != -EBADMSG)
 			return err;
 
-		/* MCP25XXFD_REG_OSC is the first ever reg we read from.
+		/* MCP251XFD_REG_OSC is the first ever reg we read from.
 		 *
 		 * The chip may be in deep sleep and this SPI transfer
 		 * (i.e. the assertion of the CS) will wake the chip
@@ -325,7 +325,7 @@ mcp25xxfd_regmap_crc_read(void *context,
 		 * to the caller. It will take care of both cases.
 		 *
 		 */
-		if (reg == MCP25XXFD_REG_OSC) {
+		if (reg == MCP251XFD_REG_OSC) {
 			err = 0;
 			goto out;
 		}
@@ -350,88 +350,88 @@ mcp25xxfd_regmap_crc_read(void *context,
 	return 0;
 }
 
-static const struct regmap_range mcp25xxfd_reg_table_yes_range[] = {
+static const struct regmap_range mcp251xfd_reg_table_yes_range[] = {
 	regmap_reg_range(0x000, 0x2ec),	/* CAN FD Controller Module SFR */
 	regmap_reg_range(0x400, 0xbfc),	/* RAM */
 	regmap_reg_range(0xe00, 0xe14),	/* MCP2517/18FD SFR */
 };
 
-static const struct regmap_access_table mcp25xxfd_reg_table = {
-	.yes_ranges = mcp25xxfd_reg_table_yes_range,
-	.n_yes_ranges = ARRAY_SIZE(mcp25xxfd_reg_table_yes_range),
+static const struct regmap_access_table mcp251xfd_reg_table = {
+	.yes_ranges = mcp251xfd_reg_table_yes_range,
+	.n_yes_ranges = ARRAY_SIZE(mcp251xfd_reg_table_yes_range),
 };
 
-static const struct regmap_config mcp25xxfd_regmap_nocrc = {
+static const struct regmap_config mcp251xfd_regmap_nocrc = {
 	.name = "nocrc",
 	.reg_bits = 16,
 	.reg_stride = 4,
 	.pad_bits = 0,
 	.val_bits = 32,
 	.max_register = 0xffc,
-	.wr_table = &mcp25xxfd_reg_table,
-	.rd_table = &mcp25xxfd_reg_table,
+	.wr_table = &mcp251xfd_reg_table,
+	.rd_table = &mcp251xfd_reg_table,
 	.cache_type = REGCACHE_NONE,
 	.read_flag_mask = (__force unsigned long)
-		cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_READ),
+		cpu_to_be16(MCP251XFD_SPI_INSTRUCTION_READ),
 	.write_flag_mask = (__force unsigned long)
-		cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_WRITE),
+		cpu_to_be16(MCP251XFD_SPI_INSTRUCTION_WRITE),
 };
 
-static const struct regmap_bus mcp25xxfd_bus_nocrc = {
-	.write = mcp25xxfd_regmap_nocrc_write,
-	.gather_write = mcp25xxfd_regmap_nocrc_gather_write,
-	.reg_update_bits = mcp25xxfd_regmap_nocrc_update_bits,
-	.read = mcp25xxfd_regmap_nocrc_read,
+static const struct regmap_bus mcp251xfd_bus_nocrc = {
+	.write = mcp251xfd_regmap_nocrc_write,
+	.gather_write = mcp251xfd_regmap_nocrc_gather_write,
+	.reg_update_bits = mcp251xfd_regmap_nocrc_update_bits,
+	.read = mcp251xfd_regmap_nocrc_read,
 	.reg_format_endian_default = REGMAP_ENDIAN_BIG,
 	.val_format_endian_default = REGMAP_ENDIAN_LITTLE,
-	.max_raw_read = sizeof_field(struct mcp25xxfd_map_buf_nocrc, data),
-	.max_raw_write = sizeof_field(struct mcp25xxfd_map_buf_nocrc, data),
+	.max_raw_read = sizeof_field(struct mcp251xfd_map_buf_nocrc, data),
+	.max_raw_write = sizeof_field(struct mcp251xfd_map_buf_nocrc, data),
 };
 
-static const struct regmap_config mcp25xxfd_regmap_crc = {
+static const struct regmap_config mcp251xfd_regmap_crc = {
 	.name = "crc",
 	.reg_bits = 16,
 	.reg_stride = 4,
 	.pad_bits = 16,		/* keep data bits aligned */
 	.val_bits = 32,
 	.max_register = 0xffc,
-	.wr_table = &mcp25xxfd_reg_table,
-	.rd_table = &mcp25xxfd_reg_table,
+	.wr_table = &mcp251xfd_reg_table,
+	.rd_table = &mcp251xfd_reg_table,
 	.cache_type = REGCACHE_NONE,
 };
 
-static const struct regmap_bus mcp25xxfd_bus_crc = {
-	.write = mcp25xxfd_regmap_crc_write,
-	.gather_write = mcp25xxfd_regmap_crc_gather_write,
-	.read = mcp25xxfd_regmap_crc_read,
+static const struct regmap_bus mcp251xfd_bus_crc = {
+	.write = mcp251xfd_regmap_crc_write,
+	.gather_write = mcp251xfd_regmap_crc_gather_write,
+	.read = mcp251xfd_regmap_crc_read,
 	.reg_format_endian_default = REGMAP_ENDIAN_NATIVE,
 	.val_format_endian_default = REGMAP_ENDIAN_LITTLE,
-	.max_raw_read = sizeof_field(struct mcp25xxfd_map_buf_crc, data),
-	.max_raw_write = sizeof_field(struct mcp25xxfd_map_buf_crc, data),
+	.max_raw_read = sizeof_field(struct mcp251xfd_map_buf_crc, data),
+	.max_raw_write = sizeof_field(struct mcp251xfd_map_buf_crc, data),
 };
 
 static inline bool
-mcp25xxfd_regmap_use_nocrc(struct mcp25xxfd_priv *priv)
+mcp251xfd_regmap_use_nocrc(struct mcp251xfd_priv *priv)
 {
-	return (!(priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_REG)) ||
-		(!(priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_RX));
+	return (!(priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_REG)) ||
+		(!(priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_RX));
 }
 
 static inline bool
-mcp25xxfd_regmap_use_crc(struct mcp25xxfd_priv *priv)
+mcp251xfd_regmap_use_crc(struct mcp251xfd_priv *priv)
 {
-	return (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_REG) ||
-		(priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_RX);
+	return (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_REG) ||
+		(priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_RX);
 }
 
 static int
-mcp25xxfd_regmap_init_nocrc(struct mcp25xxfd_priv *priv)
+mcp251xfd_regmap_init_nocrc(struct mcp251xfd_priv *priv)
 {
 	if (!priv->map_nocrc) {
 		struct regmap *map;
 
-		map = devm_regmap_init(&priv->spi->dev, &mcp25xxfd_bus_nocrc,
-				       priv->spi, &mcp25xxfd_regmap_nocrc);
+		map = devm_regmap_init(&priv->spi->dev, &mcp251xfd_bus_nocrc,
+				       priv->spi, &mcp251xfd_regmap_nocrc);
 		if (IS_ERR(map))
 			return PTR_ERR(map);
 
@@ -456,16 +456,16 @@ mcp25xxfd_regmap_init_nocrc(struct mcp25xxfd_priv *priv)
 			return -ENOMEM;
 	}
 
-	if (!(priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_REG))
+	if (!(priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_REG))
 		priv->map_reg = priv->map_nocrc;
 
-	if (!(priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_RX))
+	if (!(priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_RX))
 		priv->map_rx = priv->map_nocrc;
 
 	return 0;
 }
 
-static void mcp25xxfd_regmap_destroy_nocrc(struct mcp25xxfd_priv *priv)
+static void mcp251xfd_regmap_destroy_nocrc(struct mcp251xfd_priv *priv)
 {
 	if (priv->map_buf_nocrc_rx) {
 		devm_kfree(&priv->spi->dev, priv->map_buf_nocrc_rx);
@@ -478,13 +478,13 @@ static void mcp25xxfd_regmap_destroy_nocrc(struct mcp25xxfd_priv *priv)
 }
 
 static int
-mcp25xxfd_regmap_init_crc(struct mcp25xxfd_priv *priv)
+mcp251xfd_regmap_init_crc(struct mcp251xfd_priv *priv)
 {
 	if (!priv->map_crc) {
 		struct regmap *map;
 
-		map = devm_regmap_init(&priv->spi->dev, &mcp25xxfd_bus_crc,
-				       priv->spi, &mcp25xxfd_regmap_crc);
+		map = devm_regmap_init(&priv->spi->dev, &mcp251xfd_bus_crc,
+				       priv->spi, &mcp251xfd_regmap_crc);
 		if (IS_ERR(map))
 			return PTR_ERR(map);
 
@@ -509,16 +509,16 @@ mcp25xxfd_regmap_init_crc(struct mcp25xxfd_priv *priv)
 			return -ENOMEM;
 	}
 
-	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_REG)
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_REG)
 		priv->map_reg = priv->map_crc;
 
-	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_RX)
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_RX)
 		priv->map_rx = priv->map_crc;
 
 	return 0;
 }
 
-static void mcp25xxfd_regmap_destroy_crc(struct mcp25xxfd_priv *priv)
+static void mcp251xfd_regmap_destroy_crc(struct mcp251xfd_priv *priv)
 {
 	if (priv->map_buf_crc_rx) {
 		devm_kfree(&priv->spi->dev, priv->map_buf_crc_rx);
@@ -530,26 +530,26 @@ static void mcp25xxfd_regmap_destroy_crc(struct mcp25xxfd_priv *priv)
 	}
 }
 
-int mcp25xxfd_regmap_init(struct mcp25xxfd_priv *priv)
+int mcp251xfd_regmap_init(struct mcp251xfd_priv *priv)
 {
 	int err;
 
-	if (mcp25xxfd_regmap_use_nocrc(priv)) {
-		err = mcp25xxfd_regmap_init_nocrc(priv);
+	if (mcp251xfd_regmap_use_nocrc(priv)) {
+		err = mcp251xfd_regmap_init_nocrc(priv);
 
 		if (err)
 			return err;
 	} else {
-		mcp25xxfd_regmap_destroy_nocrc(priv);
+		mcp251xfd_regmap_destroy_nocrc(priv);
 	}
 
-	if (mcp25xxfd_regmap_use_crc(priv)) {
-		err = mcp25xxfd_regmap_init_crc(priv);
+	if (mcp251xfd_regmap_use_crc(priv)) {
+		err = mcp251xfd_regmap_init_crc(priv);
 
 		if (err)
 			return err;
 	} else {
-		mcp25xxfd_regmap_destroy_crc(priv);
+		mcp251xfd_regmap_destroy_crc(priv);
 	}
 
 	return 0;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index b1b5d7fd33ea..fa1246e39980 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -1,14 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0
  *
- * mcp25xxfd - Microchip MCP25xxFD Family CAN controller driver
+ * mcp251xfd - Microchip MCP251xFD Family CAN controller driver
  *
  * Copyright (c) 2019 Pengutronix,
  *                    Marc Kleine-Budde <kernel@pengutronix.de>
  * Copyright (c) 2019 Martin Sperl <kernel@martin.sperl.org>
  */
 
-#ifndef _MCP25XXFD_H
-#define _MCP25XXFD_H
+#ifndef _MCP251XFD_H
+#define _MCP251XFD_H
 
 #include <linux/can/core.h>
 #include <linux/can/dev.h>
@@ -19,405 +19,405 @@
 #include <linux/regulator/consumer.h>
 #include <linux/spi/spi.h>
 
-/* MPC25xx registers */
+/* MPC251x registers */
 
 /* CAN FD Controller Module SFR */
-#define MCP25XXFD_REG_CON 0x00
-#define MCP25XXFD_REG_CON_TXBWS_MASK GENMASK(31, 28)
-#define MCP25XXFD_REG_CON_ABAT BIT(27)
-#define MCP25XXFD_REG_CON_REQOP_MASK GENMASK(26, 24)
-#define MCP25XXFD_REG_CON_MODE_MIXED 0
-#define MCP25XXFD_REG_CON_MODE_SLEEP 1
-#define MCP25XXFD_REG_CON_MODE_INT_LOOPBACK 2
-#define MCP25XXFD_REG_CON_MODE_LISTENONLY 3
-#define MCP25XXFD_REG_CON_MODE_CONFIG 4
-#define MCP25XXFD_REG_CON_MODE_EXT_LOOPBACK 5
-#define MCP25XXFD_REG_CON_MODE_CAN2_0 6
-#define MCP25XXFD_REG_CON_MODE_RESTRICTED 7
-#define MCP25XXFD_REG_CON_OPMOD_MASK GENMASK(23, 21)
-#define MCP25XXFD_REG_CON_TXQEN BIT(20)
-#define MCP25XXFD_REG_CON_STEF BIT(19)
-#define MCP25XXFD_REG_CON_SERR2LOM BIT(18)
-#define MCP25XXFD_REG_CON_ESIGM BIT(17)
-#define MCP25XXFD_REG_CON_RTXAT BIT(16)
-#define MCP25XXFD_REG_CON_BRSDIS BIT(12)
-#define MCP25XXFD_REG_CON_BUSY BIT(11)
-#define MCP25XXFD_REG_CON_WFT_MASK GENMASK(10, 9)
-#define MCP25XXFD_REG_CON_WFT_T00FILTER 0x0
-#define MCP25XXFD_REG_CON_WFT_T01FILTER 0x1
-#define MCP25XXFD_REG_CON_WFT_T10FILTER 0x2
-#define MCP25XXFD_REG_CON_WFT_T11FILTER 0x3
-#define MCP25XXFD_REG_CON_WAKFIL BIT(8)
-#define MCP25XXFD_REG_CON_PXEDIS BIT(6)
-#define MCP25XXFD_REG_CON_ISOCRCEN BIT(5)
-#define MCP25XXFD_REG_CON_DNCNT_MASK GENMASK(4, 0)
-
-#define MCP25XXFD_REG_NBTCFG 0x04
-#define MCP25XXFD_REG_NBTCFG_BRP_MASK GENMASK(31, 24)
-#define MCP25XXFD_REG_NBTCFG_TSEG1_MASK GENMASK(23, 16)
-#define MCP25XXFD_REG_NBTCFG_TSEG2_MASK GENMASK(14, 8)
-#define MCP25XXFD_REG_NBTCFG_SJW_MASK GENMASK(6, 0)
-
-#define MCP25XXFD_REG_DBTCFG 0x08
-#define MCP25XXFD_REG_DBTCFG_BRP_MASK GENMASK(31, 24)
-#define MCP25XXFD_REG_DBTCFG_TSEG1_MASK GENMASK(20, 16)
-#define MCP25XXFD_REG_DBTCFG_TSEG2_MASK GENMASK(11, 8)
-#define MCP25XXFD_REG_DBTCFG_SJW_MASK GENMASK(3, 0)
-
-#define MCP25XXFD_REG_TDC 0x0c
-#define MCP25XXFD_REG_TDC_EDGFLTEN BIT(25)
-#define MCP25XXFD_REG_TDC_SID11EN BIT(24)
-#define MCP25XXFD_REG_TDC_TDCMOD_MASK GENMASK(17, 16)
-#define MCP25XXFD_REG_TDC_TDCMOD_AUTO 2
-#define MCP25XXFD_REG_TDC_TDCMOD_MANUAL 1
-#define MCP25XXFD_REG_TDC_TDCMOD_DISABLED 0
-#define MCP25XXFD_REG_TDC_TDCO_MASK GENMASK(14, 8)
-#define MCP25XXFD_REG_TDC_TDCV_MASK GENMASK(5, 0)
-
-#define MCP25XXFD_REG_TBC 0x10
-
-#define MCP25XXFD_REG_TSCON 0x14
-#define MCP25XXFD_REG_TSCON_TSRES BIT(18)
-#define MCP25XXFD_REG_TSCON_TSEOF BIT(17)
-#define MCP25XXFD_REG_TSCON_TBCEN BIT(16)
-#define MCP25XXFD_REG_TSCON_TBCPRE_MASK GENMASK(9, 0)
-
-#define MCP25XXFD_REG_VEC 0x18
-#define MCP25XXFD_REG_VEC_RXCODE_MASK GENMASK(30, 24)
-#define MCP25XXFD_REG_VEC_TXCODE_MASK GENMASK(22, 16)
-#define MCP25XXFD_REG_VEC_FILHIT_MASK GENMASK(12, 8)
-#define MCP25XXFD_REG_VEC_ICODE_MASK GENMASK(6, 0)
-
-#define MCP25XXFD_REG_INT 0x1c
-#define MCP25XXFD_REG_INT_IF_MASK GENMASK(15, 0)
-#define MCP25XXFD_REG_INT_IE_MASK GENMASK(31, 16)
-#define MCP25XXFD_REG_INT_IVMIE BIT(31)
-#define MCP25XXFD_REG_INT_WAKIE BIT(30)
-#define MCP25XXFD_REG_INT_CERRIE BIT(29)
-#define MCP25XXFD_REG_INT_SERRIE BIT(28)
-#define MCP25XXFD_REG_INT_RXOVIE BIT(27)
-#define MCP25XXFD_REG_INT_TXATIE BIT(26)
-#define MCP25XXFD_REG_INT_SPICRCIE BIT(25)
-#define MCP25XXFD_REG_INT_ECCIE BIT(24)
-#define MCP25XXFD_REG_INT_TEFIE BIT(20)
-#define MCP25XXFD_REG_INT_MODIE BIT(19)
-#define MCP25XXFD_REG_INT_TBCIE BIT(18)
-#define MCP25XXFD_REG_INT_RXIE BIT(17)
-#define MCP25XXFD_REG_INT_TXIE BIT(16)
-#define MCP25XXFD_REG_INT_IVMIF BIT(15)
-#define MCP25XXFD_REG_INT_WAKIF BIT(14)
-#define MCP25XXFD_REG_INT_CERRIF BIT(13)
-#define MCP25XXFD_REG_INT_SERRIF BIT(12)
-#define MCP25XXFD_REG_INT_RXOVIF BIT(11)
-#define MCP25XXFD_REG_INT_TXATIF BIT(10)
-#define MCP25XXFD_REG_INT_SPICRCIF BIT(9)
-#define MCP25XXFD_REG_INT_ECCIF BIT(8)
-#define MCP25XXFD_REG_INT_TEFIF BIT(4)
-#define MCP25XXFD_REG_INT_MODIF BIT(3)
-#define MCP25XXFD_REG_INT_TBCIF BIT(2)
-#define MCP25XXFD_REG_INT_RXIF BIT(1)
-#define MCP25XXFD_REG_INT_TXIF BIT(0)
+#define MCP251XFD_REG_CON 0x00
+#define MCP251XFD_REG_CON_TXBWS_MASK GENMASK(31, 28)
+#define MCP251XFD_REG_CON_ABAT BIT(27)
+#define MCP251XFD_REG_CON_REQOP_MASK GENMASK(26, 24)
+#define MCP251XFD_REG_CON_MODE_MIXED 0
+#define MCP251XFD_REG_CON_MODE_SLEEP 1
+#define MCP251XFD_REG_CON_MODE_INT_LOOPBACK 2
+#define MCP251XFD_REG_CON_MODE_LISTENONLY 3
+#define MCP251XFD_REG_CON_MODE_CONFIG 4
+#define MCP251XFD_REG_CON_MODE_EXT_LOOPBACK 5
+#define MCP251XFD_REG_CON_MODE_CAN2_0 6
+#define MCP251XFD_REG_CON_MODE_RESTRICTED 7
+#define MCP251XFD_REG_CON_OPMOD_MASK GENMASK(23, 21)
+#define MCP251XFD_REG_CON_TXQEN BIT(20)
+#define MCP251XFD_REG_CON_STEF BIT(19)
+#define MCP251XFD_REG_CON_SERR2LOM BIT(18)
+#define MCP251XFD_REG_CON_ESIGM BIT(17)
+#define MCP251XFD_REG_CON_RTXAT BIT(16)
+#define MCP251XFD_REG_CON_BRSDIS BIT(12)
+#define MCP251XFD_REG_CON_BUSY BIT(11)
+#define MCP251XFD_REG_CON_WFT_MASK GENMASK(10, 9)
+#define MCP251XFD_REG_CON_WFT_T00FILTER 0x0
+#define MCP251XFD_REG_CON_WFT_T01FILTER 0x1
+#define MCP251XFD_REG_CON_WFT_T10FILTER 0x2
+#define MCP251XFD_REG_CON_WFT_T11FILTER 0x3
+#define MCP251XFD_REG_CON_WAKFIL BIT(8)
+#define MCP251XFD_REG_CON_PXEDIS BIT(6)
+#define MCP251XFD_REG_CON_ISOCRCEN BIT(5)
+#define MCP251XFD_REG_CON_DNCNT_MASK GENMASK(4, 0)
+
+#define MCP251XFD_REG_NBTCFG 0x04
+#define MCP251XFD_REG_NBTCFG_BRP_MASK GENMASK(31, 24)
+#define MCP251XFD_REG_NBTCFG_TSEG1_MASK GENMASK(23, 16)
+#define MCP251XFD_REG_NBTCFG_TSEG2_MASK GENMASK(14, 8)
+#define MCP251XFD_REG_NBTCFG_SJW_MASK GENMASK(6, 0)
+
+#define MCP251XFD_REG_DBTCFG 0x08
+#define MCP251XFD_REG_DBTCFG_BRP_MASK GENMASK(31, 24)
+#define MCP251XFD_REG_DBTCFG_TSEG1_MASK GENMASK(20, 16)
+#define MCP251XFD_REG_DBTCFG_TSEG2_MASK GENMASK(11, 8)
+#define MCP251XFD_REG_DBTCFG_SJW_MASK GENMASK(3, 0)
+
+#define MCP251XFD_REG_TDC 0x0c
+#define MCP251XFD_REG_TDC_EDGFLTEN BIT(25)
+#define MCP251XFD_REG_TDC_SID11EN BIT(24)
+#define MCP251XFD_REG_TDC_TDCMOD_MASK GENMASK(17, 16)
+#define MCP251XFD_REG_TDC_TDCMOD_AUTO 2
+#define MCP251XFD_REG_TDC_TDCMOD_MANUAL 1
+#define MCP251XFD_REG_TDC_TDCMOD_DISABLED 0
+#define MCP251XFD_REG_TDC_TDCO_MASK GENMASK(14, 8)
+#define MCP251XFD_REG_TDC_TDCV_MASK GENMASK(5, 0)
+
+#define MCP251XFD_REG_TBC 0x10
+
+#define MCP251XFD_REG_TSCON 0x14
+#define MCP251XFD_REG_TSCON_TSRES BIT(18)
+#define MCP251XFD_REG_TSCON_TSEOF BIT(17)
+#define MCP251XFD_REG_TSCON_TBCEN BIT(16)
+#define MCP251XFD_REG_TSCON_TBCPRE_MASK GENMASK(9, 0)
+
+#define MCP251XFD_REG_VEC 0x18
+#define MCP251XFD_REG_VEC_RXCODE_MASK GENMASK(30, 24)
+#define MCP251XFD_REG_VEC_TXCODE_MASK GENMASK(22, 16)
+#define MCP251XFD_REG_VEC_FILHIT_MASK GENMASK(12, 8)
+#define MCP251XFD_REG_VEC_ICODE_MASK GENMASK(6, 0)
+
+#define MCP251XFD_REG_INT 0x1c
+#define MCP251XFD_REG_INT_IF_MASK GENMASK(15, 0)
+#define MCP251XFD_REG_INT_IE_MASK GENMASK(31, 16)
+#define MCP251XFD_REG_INT_IVMIE BIT(31)
+#define MCP251XFD_REG_INT_WAKIE BIT(30)
+#define MCP251XFD_REG_INT_CERRIE BIT(29)
+#define MCP251XFD_REG_INT_SERRIE BIT(28)
+#define MCP251XFD_REG_INT_RXOVIE BIT(27)
+#define MCP251XFD_REG_INT_TXATIE BIT(26)
+#define MCP251XFD_REG_INT_SPICRCIE BIT(25)
+#define MCP251XFD_REG_INT_ECCIE BIT(24)
+#define MCP251XFD_REG_INT_TEFIE BIT(20)
+#define MCP251XFD_REG_INT_MODIE BIT(19)
+#define MCP251XFD_REG_INT_TBCIE BIT(18)
+#define MCP251XFD_REG_INT_RXIE BIT(17)
+#define MCP251XFD_REG_INT_TXIE BIT(16)
+#define MCP251XFD_REG_INT_IVMIF BIT(15)
+#define MCP251XFD_REG_INT_WAKIF BIT(14)
+#define MCP251XFD_REG_INT_CERRIF BIT(13)
+#define MCP251XFD_REG_INT_SERRIF BIT(12)
+#define MCP251XFD_REG_INT_RXOVIF BIT(11)
+#define MCP251XFD_REG_INT_TXATIF BIT(10)
+#define MCP251XFD_REG_INT_SPICRCIF BIT(9)
+#define MCP251XFD_REG_INT_ECCIF BIT(8)
+#define MCP251XFD_REG_INT_TEFIF BIT(4)
+#define MCP251XFD_REG_INT_MODIF BIT(3)
+#define MCP251XFD_REG_INT_TBCIF BIT(2)
+#define MCP251XFD_REG_INT_RXIF BIT(1)
+#define MCP251XFD_REG_INT_TXIF BIT(0)
 /* These IRQ flags must be cleared by SW in the CAN_INT register */
-#define MCP25XXFD_REG_INT_IF_CLEARABLE_MASK \
-	(MCP25XXFD_REG_INT_IVMIF | MCP25XXFD_REG_INT_WAKIF | \
-	 MCP25XXFD_REG_INT_CERRIF |  MCP25XXFD_REG_INT_SERRIF | \
-	 MCP25XXFD_REG_INT_MODIF)
-
-#define MCP25XXFD_REG_RXIF 0x20
-#define MCP25XXFD_REG_TXIF 0x24
-#define MCP25XXFD_REG_RXOVIF 0x28
-#define MCP25XXFD_REG_TXATIF 0x2c
-#define MCP25XXFD_REG_TXREQ 0x30
-
-#define MCP25XXFD_REG_TREC 0x34
-#define MCP25XXFD_REG_TREC_TXBO BIT(21)
-#define MCP25XXFD_REG_TREC_TXBP BIT(20)
-#define MCP25XXFD_REG_TREC_RXBP BIT(19)
-#define MCP25XXFD_REG_TREC_TXWARN BIT(18)
-#define MCP25XXFD_REG_TREC_RXWARN BIT(17)
-#define MCP25XXFD_REG_TREC_EWARN BIT(16)
-#define MCP25XXFD_REG_TREC_TEC_MASK GENMASK(15, 8)
-#define MCP25XXFD_REG_TREC_REC_MASK GENMASK(7, 0)
-
-#define MCP25XXFD_REG_BDIAG0 0x38
-#define MCP25XXFD_REG_BDIAG0_DTERRCNT_MASK GENMASK(31, 24)
-#define MCP25XXFD_REG_BDIAG0_DRERRCNT_MASK GENMASK(23, 16)
-#define MCP25XXFD_REG_BDIAG0_NTERRCNT_MASK GENMASK(15, 8)
-#define MCP25XXFD_REG_BDIAG0_NRERRCNT_MASK GENMASK(7, 0)
-
-#define MCP25XXFD_REG_BDIAG1 0x3c
-#define MCP25XXFD_REG_BDIAG1_DLCMM BIT(31)
-#define MCP25XXFD_REG_BDIAG1_ESI BIT(30)
-#define MCP25XXFD_REG_BDIAG1_DCRCERR BIT(29)
-#define MCP25XXFD_REG_BDIAG1_DSTUFERR BIT(28)
-#define MCP25XXFD_REG_BDIAG1_DFORMERR BIT(27)
-#define MCP25XXFD_REG_BDIAG1_DBIT1ERR BIT(25)
-#define MCP25XXFD_REG_BDIAG1_DBIT0ERR BIT(24)
-#define MCP25XXFD_REG_BDIAG1_TXBOERR BIT(23)
-#define MCP25XXFD_REG_BDIAG1_NCRCERR BIT(21)
-#define MCP25XXFD_REG_BDIAG1_NSTUFERR BIT(20)
-#define MCP25XXFD_REG_BDIAG1_NFORMERR BIT(19)
-#define MCP25XXFD_REG_BDIAG1_NACKERR BIT(18)
-#define MCP25XXFD_REG_BDIAG1_NBIT1ERR BIT(17)
-#define MCP25XXFD_REG_BDIAG1_NBIT0ERR BIT(16)
-#define MCP25XXFD_REG_BDIAG1_BERR_MASK \
-	(MCP25XXFD_REG_BDIAG1_DLCMM | MCP25XXFD_REG_BDIAG1_ESI | \
-	 MCP25XXFD_REG_BDIAG1_DCRCERR | MCP25XXFD_REG_BDIAG1_DSTUFERR | \
-	 MCP25XXFD_REG_BDIAG1_DFORMERR | MCP25XXFD_REG_BDIAG1_DBIT1ERR | \
-	 MCP25XXFD_REG_BDIAG1_DBIT0ERR | MCP25XXFD_REG_BDIAG1_TXBOERR | \
-	 MCP25XXFD_REG_BDIAG1_NCRCERR | MCP25XXFD_REG_BDIAG1_NSTUFERR | \
-	 MCP25XXFD_REG_BDIAG1_NFORMERR | MCP25XXFD_REG_BDIAG1_NACKERR | \
-	 MCP25XXFD_REG_BDIAG1_NBIT1ERR | MCP25XXFD_REG_BDIAG1_NBIT0ERR)
-#define MCP25XXFD_REG_BDIAG1_EFMSGCNT_MASK GENMASK(15, 0)
-
-#define MCP25XXFD_REG_TEFCON 0x40
-#define MCP25XXFD_REG_TEFCON_FSIZE_MASK GENMASK(28, 24)
-#define MCP25XXFD_REG_TEFCON_FRESET BIT(10)
-#define MCP25XXFD_REG_TEFCON_UINC BIT(8)
-#define MCP25XXFD_REG_TEFCON_TEFTSEN BIT(5)
-#define MCP25XXFD_REG_TEFCON_TEFOVIE BIT(3)
-#define MCP25XXFD_REG_TEFCON_TEFFIE BIT(2)
-#define MCP25XXFD_REG_TEFCON_TEFHIE BIT(1)
-#define MCP25XXFD_REG_TEFCON_TEFNEIE BIT(0)
-
-#define MCP25XXFD_REG_TEFSTA 0x44
-#define MCP25XXFD_REG_TEFSTA_TEFOVIF BIT(3)
-#define MCP25XXFD_REG_TEFSTA_TEFFIF BIT(2)
-#define MCP25XXFD_REG_TEFSTA_TEFHIF BIT(1)
-#define MCP25XXFD_REG_TEFSTA_TEFNEIF BIT(0)
-
-#define MCP25XXFD_REG_TEFUA 0x48
-
-#define MCP25XXFD_REG_TXQCON 0x50
-#define MCP25XXFD_REG_TXQCON_PLSIZE_MASK GENMASK(31, 29)
-#define MCP25XXFD_REG_TXQCON_PLSIZE_8 0
-#define MCP25XXFD_REG_TXQCON_PLSIZE_12 1
-#define MCP25XXFD_REG_TXQCON_PLSIZE_16 2
-#define MCP25XXFD_REG_TXQCON_PLSIZE_20 3
-#define MCP25XXFD_REG_TXQCON_PLSIZE_24 4
-#define MCP25XXFD_REG_TXQCON_PLSIZE_32 5
-#define MCP25XXFD_REG_TXQCON_PLSIZE_48 6
-#define MCP25XXFD_REG_TXQCON_PLSIZE_64 7
-#define MCP25XXFD_REG_TXQCON_FSIZE_MASK GENMASK(28, 24)
-#define MCP25XXFD_REG_TXQCON_TXAT_UNLIMITED 3
-#define MCP25XXFD_REG_TXQCON_TXAT_THREE_SHOT 1
-#define MCP25XXFD_REG_TXQCON_TXAT_ONE_SHOT 0
-#define MCP25XXFD_REG_TXQCON_TXAT_MASK GENMASK(22, 21)
-#define MCP25XXFD_REG_TXQCON_TXPRI_MASK GENMASK(20, 16)
-#define MCP25XXFD_REG_TXQCON_FRESET BIT(10)
-#define MCP25XXFD_REG_TXQCON_TXREQ BIT(9)
-#define MCP25XXFD_REG_TXQCON_UINC BIT(8)
-#define MCP25XXFD_REG_TXQCON_TXEN BIT(7)
-#define MCP25XXFD_REG_TXQCON_TXATIE BIT(4)
-#define MCP25XXFD_REG_TXQCON_TXQEIE BIT(2)
-#define MCP25XXFD_REG_TXQCON_TXQNIE BIT(0)
-
-#define MCP25XXFD_REG_TXQSTA 0x54
-#define MCP25XXFD_REG_TXQSTA_TXQCI_MASK GENMASK(12, 8)
-#define MCP25XXFD_REG_TXQSTA_TXABT BIT(7)
-#define MCP25XXFD_REG_TXQSTA_TXLARB BIT(6)
-#define MCP25XXFD_REG_TXQSTA_TXERR BIT(5)
-#define MCP25XXFD_REG_TXQSTA_TXATIF BIT(4)
-#define MCP25XXFD_REG_TXQSTA_TXQEIF BIT(2)
-#define MCP25XXFD_REG_TXQSTA_TXQNIF BIT(0)
-
-#define MCP25XXFD_REG_TXQUA 0x58
-
-#define MCP25XXFD_REG_FIFOCON(x) (0x50 + 0xc * (x))
-#define MCP25XXFD_REG_FIFOCON_PLSIZE_MASK GENMASK(31, 29)
-#define MCP25XXFD_REG_FIFOCON_PLSIZE_8 0
-#define MCP25XXFD_REG_FIFOCON_PLSIZE_12 1
-#define MCP25XXFD_REG_FIFOCON_PLSIZE_16 2
-#define MCP25XXFD_REG_FIFOCON_PLSIZE_20 3
-#define MCP25XXFD_REG_FIFOCON_PLSIZE_24 4
-#define MCP25XXFD_REG_FIFOCON_PLSIZE_32 5
-#define MCP25XXFD_REG_FIFOCON_PLSIZE_48 6
-#define MCP25XXFD_REG_FIFOCON_PLSIZE_64 7
-#define MCP25XXFD_REG_FIFOCON_FSIZE_MASK GENMASK(28, 24)
-#define MCP25XXFD_REG_FIFOCON_TXAT_MASK GENMASK(22, 21)
-#define MCP25XXFD_REG_FIFOCON_TXAT_ONE_SHOT 0
-#define MCP25XXFD_REG_FIFOCON_TXAT_THREE_SHOT 1
-#define MCP25XXFD_REG_FIFOCON_TXAT_UNLIMITED 3
-#define MCP25XXFD_REG_FIFOCON_TXPRI_MASK GENMASK(20, 16)
-#define MCP25XXFD_REG_FIFOCON_FRESET BIT(10)
-#define MCP25XXFD_REG_FIFOCON_TXREQ BIT(9)
-#define MCP25XXFD_REG_FIFOCON_UINC BIT(8)
-#define MCP25XXFD_REG_FIFOCON_TXEN BIT(7)
-#define MCP25XXFD_REG_FIFOCON_RTREN BIT(6)
-#define MCP25XXFD_REG_FIFOCON_RXTSEN BIT(5)
-#define MCP25XXFD_REG_FIFOCON_TXATIE BIT(4)
-#define MCP25XXFD_REG_FIFOCON_RXOVIE BIT(3)
-#define MCP25XXFD_REG_FIFOCON_TFERFFIE BIT(2)
-#define MCP25XXFD_REG_FIFOCON_TFHRFHIE BIT(1)
-#define MCP25XXFD_REG_FIFOCON_TFNRFNIE BIT(0)
-
-#define MCP25XXFD_REG_FIFOSTA(x) (0x54 + 0xc * (x))
-#define MCP25XXFD_REG_FIFOSTA_FIFOCI_MASK GENMASK(12, 8)
-#define MCP25XXFD_REG_FIFOSTA_TXABT BIT(7)
-#define MCP25XXFD_REG_FIFOSTA_TXLARB BIT(6)
-#define MCP25XXFD_REG_FIFOSTA_TXERR BIT(5)
-#define MCP25XXFD_REG_FIFOSTA_TXATIF BIT(4)
-#define MCP25XXFD_REG_FIFOSTA_RXOVIF BIT(3)
-#define MCP25XXFD_REG_FIFOSTA_TFERFFIF BIT(2)
-#define MCP25XXFD_REG_FIFOSTA_TFHRFHIF BIT(1)
-#define MCP25XXFD_REG_FIFOSTA_TFNRFNIF BIT(0)
-
-#define MCP25XXFD_REG_FIFOUA(x) (0x58 + 0xc * (x))
-
-#define MCP25XXFD_REG_FLTCON(x) (0x1d0 + 0x4 * (x))
-#define MCP25XXFD_REG_FLTCON_FLTEN3 BIT(31)
-#define MCP25XXFD_REG_FLTCON_F3BP_MASK GENMASK(28, 24)
-#define MCP25XXFD_REG_FLTCON_FLTEN2 BIT(23)
-#define MCP25XXFD_REG_FLTCON_F2BP_MASK GENMASK(20, 16)
-#define MCP25XXFD_REG_FLTCON_FLTEN1 BIT(15)
-#define MCP25XXFD_REG_FLTCON_F1BP_MASK GENMASK(12, 8)
-#define MCP25XXFD_REG_FLTCON_FLTEN0 BIT(7)
-#define MCP25XXFD_REG_FLTCON_F0BP_MASK GENMASK(4, 0)
-#define MCP25XXFD_REG_FLTCON_FLTEN(x) (BIT(7) << 8 * ((x) & 0x3))
-#define MCP25XXFD_REG_FLTCON_FLT_MASK(x) (GENMASK(7, 0) << (8 * ((x) & 0x3)))
-#define MCP25XXFD_REG_FLTCON_FBP(x, fifo) ((fifo) << 8 * ((x) & 0x3))
-
-#define MCP25XXFD_REG_FLTOBJ(x) (0x1f0 + 0x8 * (x))
-#define MCP25XXFD_REG_FLTOBJ_EXIDE BIT(30)
-#define MCP25XXFD_REG_FLTOBJ_SID11 BIT(29)
-#define MCP25XXFD_REG_FLTOBJ_EID_MASK GENMASK(28, 11)
-#define MCP25XXFD_REG_FLTOBJ_SID_MASK GENMASK(10, 0)
-
-#define MCP25XXFD_REG_FLTMASK(x) (0x1f4 + 0x8 * (x))
-#define MCP25XXFD_REG_MASK_MIDE BIT(30)
-#define MCP25XXFD_REG_MASK_MSID11 BIT(29)
-#define MCP25XXFD_REG_MASK_MEID_MASK GENMASK(28, 11)
-#define MCP25XXFD_REG_MASK_MSID_MASK GENMASK(10, 0)
+#define MCP251XFD_REG_INT_IF_CLEARABLE_MASK \
+	(MCP251XFD_REG_INT_IVMIF | MCP251XFD_REG_INT_WAKIF | \
+	 MCP251XFD_REG_INT_CERRIF |  MCP251XFD_REG_INT_SERRIF | \
+	 MCP251XFD_REG_INT_MODIF)
+
+#define MCP251XFD_REG_RXIF 0x20
+#define MCP251XFD_REG_TXIF 0x24
+#define MCP251XFD_REG_RXOVIF 0x28
+#define MCP251XFD_REG_TXATIF 0x2c
+#define MCP251XFD_REG_TXREQ 0x30
+
+#define MCP251XFD_REG_TREC 0x34
+#define MCP251XFD_REG_TREC_TXBO BIT(21)
+#define MCP251XFD_REG_TREC_TXBP BIT(20)
+#define MCP251XFD_REG_TREC_RXBP BIT(19)
+#define MCP251XFD_REG_TREC_TXWARN BIT(18)
+#define MCP251XFD_REG_TREC_RXWARN BIT(17)
+#define MCP251XFD_REG_TREC_EWARN BIT(16)
+#define MCP251XFD_REG_TREC_TEC_MASK GENMASK(15, 8)
+#define MCP251XFD_REG_TREC_REC_MASK GENMASK(7, 0)
+
+#define MCP251XFD_REG_BDIAG0 0x38
+#define MCP251XFD_REG_BDIAG0_DTERRCNT_MASK GENMASK(31, 24)
+#define MCP251XFD_REG_BDIAG0_DRERRCNT_MASK GENMASK(23, 16)
+#define MCP251XFD_REG_BDIAG0_NTERRCNT_MASK GENMASK(15, 8)
+#define MCP251XFD_REG_BDIAG0_NRERRCNT_MASK GENMASK(7, 0)
+
+#define MCP251XFD_REG_BDIAG1 0x3c
+#define MCP251XFD_REG_BDIAG1_DLCMM BIT(31)
+#define MCP251XFD_REG_BDIAG1_ESI BIT(30)
+#define MCP251XFD_REG_BDIAG1_DCRCERR BIT(29)
+#define MCP251XFD_REG_BDIAG1_DSTUFERR BIT(28)
+#define MCP251XFD_REG_BDIAG1_DFORMERR BIT(27)
+#define MCP251XFD_REG_BDIAG1_DBIT1ERR BIT(25)
+#define MCP251XFD_REG_BDIAG1_DBIT0ERR BIT(24)
+#define MCP251XFD_REG_BDIAG1_TXBOERR BIT(23)
+#define MCP251XFD_REG_BDIAG1_NCRCERR BIT(21)
+#define MCP251XFD_REG_BDIAG1_NSTUFERR BIT(20)
+#define MCP251XFD_REG_BDIAG1_NFORMERR BIT(19)
+#define MCP251XFD_REG_BDIAG1_NACKERR BIT(18)
+#define MCP251XFD_REG_BDIAG1_NBIT1ERR BIT(17)
+#define MCP251XFD_REG_BDIAG1_NBIT0ERR BIT(16)
+#define MCP251XFD_REG_BDIAG1_BERR_MASK \
+	(MCP251XFD_REG_BDIAG1_DLCMM | MCP251XFD_REG_BDIAG1_ESI | \
+	 MCP251XFD_REG_BDIAG1_DCRCERR | MCP251XFD_REG_BDIAG1_DSTUFERR | \
+	 MCP251XFD_REG_BDIAG1_DFORMERR | MCP251XFD_REG_BDIAG1_DBIT1ERR | \
+	 MCP251XFD_REG_BDIAG1_DBIT0ERR | MCP251XFD_REG_BDIAG1_TXBOERR | \
+	 MCP251XFD_REG_BDIAG1_NCRCERR | MCP251XFD_REG_BDIAG1_NSTUFERR | \
+	 MCP251XFD_REG_BDIAG1_NFORMERR | MCP251XFD_REG_BDIAG1_NACKERR | \
+	 MCP251XFD_REG_BDIAG1_NBIT1ERR | MCP251XFD_REG_BDIAG1_NBIT0ERR)
+#define MCP251XFD_REG_BDIAG1_EFMSGCNT_MASK GENMASK(15, 0)
+
+#define MCP251XFD_REG_TEFCON 0x40
+#define MCP251XFD_REG_TEFCON_FSIZE_MASK GENMASK(28, 24)
+#define MCP251XFD_REG_TEFCON_FRESET BIT(10)
+#define MCP251XFD_REG_TEFCON_UINC BIT(8)
+#define MCP251XFD_REG_TEFCON_TEFTSEN BIT(5)
+#define MCP251XFD_REG_TEFCON_TEFOVIE BIT(3)
+#define MCP251XFD_REG_TEFCON_TEFFIE BIT(2)
+#define MCP251XFD_REG_TEFCON_TEFHIE BIT(1)
+#define MCP251XFD_REG_TEFCON_TEFNEIE BIT(0)
+
+#define MCP251XFD_REG_TEFSTA 0x44
+#define MCP251XFD_REG_TEFSTA_TEFOVIF BIT(3)
+#define MCP251XFD_REG_TEFSTA_TEFFIF BIT(2)
+#define MCP251XFD_REG_TEFSTA_TEFHIF BIT(1)
+#define MCP251XFD_REG_TEFSTA_TEFNEIF BIT(0)
+
+#define MCP251XFD_REG_TEFUA 0x48
+
+#define MCP251XFD_REG_TXQCON 0x50
+#define MCP251XFD_REG_TXQCON_PLSIZE_MASK GENMASK(31, 29)
+#define MCP251XFD_REG_TXQCON_PLSIZE_8 0
+#define MCP251XFD_REG_TXQCON_PLSIZE_12 1
+#define MCP251XFD_REG_TXQCON_PLSIZE_16 2
+#define MCP251XFD_REG_TXQCON_PLSIZE_20 3
+#define MCP251XFD_REG_TXQCON_PLSIZE_24 4
+#define MCP251XFD_REG_TXQCON_PLSIZE_32 5
+#define MCP251XFD_REG_TXQCON_PLSIZE_48 6
+#define MCP251XFD_REG_TXQCON_PLSIZE_64 7
+#define MCP251XFD_REG_TXQCON_FSIZE_MASK GENMASK(28, 24)
+#define MCP251XFD_REG_TXQCON_TXAT_UNLIMITED 3
+#define MCP251XFD_REG_TXQCON_TXAT_THREE_SHOT 1
+#define MCP251XFD_REG_TXQCON_TXAT_ONE_SHOT 0
+#define MCP251XFD_REG_TXQCON_TXAT_MASK GENMASK(22, 21)
+#define MCP251XFD_REG_TXQCON_TXPRI_MASK GENMASK(20, 16)
+#define MCP251XFD_REG_TXQCON_FRESET BIT(10)
+#define MCP251XFD_REG_TXQCON_TXREQ BIT(9)
+#define MCP251XFD_REG_TXQCON_UINC BIT(8)
+#define MCP251XFD_REG_TXQCON_TXEN BIT(7)
+#define MCP251XFD_REG_TXQCON_TXATIE BIT(4)
+#define MCP251XFD_REG_TXQCON_TXQEIE BIT(2)
+#define MCP251XFD_REG_TXQCON_TXQNIE BIT(0)
+
+#define MCP251XFD_REG_TXQSTA 0x54
+#define MCP251XFD_REG_TXQSTA_TXQCI_MASK GENMASK(12, 8)
+#define MCP251XFD_REG_TXQSTA_TXABT BIT(7)
+#define MCP251XFD_REG_TXQSTA_TXLARB BIT(6)
+#define MCP251XFD_REG_TXQSTA_TXERR BIT(5)
+#define MCP251XFD_REG_TXQSTA_TXATIF BIT(4)
+#define MCP251XFD_REG_TXQSTA_TXQEIF BIT(2)
+#define MCP251XFD_REG_TXQSTA_TXQNIF BIT(0)
+
+#define MCP251XFD_REG_TXQUA 0x58
+
+#define MCP251XFD_REG_FIFOCON(x) (0x50 + 0xc * (x))
+#define MCP251XFD_REG_FIFOCON_PLSIZE_MASK GENMASK(31, 29)
+#define MCP251XFD_REG_FIFOCON_PLSIZE_8 0
+#define MCP251XFD_REG_FIFOCON_PLSIZE_12 1
+#define MCP251XFD_REG_FIFOCON_PLSIZE_16 2
+#define MCP251XFD_REG_FIFOCON_PLSIZE_20 3
+#define MCP251XFD_REG_FIFOCON_PLSIZE_24 4
+#define MCP251XFD_REG_FIFOCON_PLSIZE_32 5
+#define MCP251XFD_REG_FIFOCON_PLSIZE_48 6
+#define MCP251XFD_REG_FIFOCON_PLSIZE_64 7
+#define MCP251XFD_REG_FIFOCON_FSIZE_MASK GENMASK(28, 24)
+#define MCP251XFD_REG_FIFOCON_TXAT_MASK GENMASK(22, 21)
+#define MCP251XFD_REG_FIFOCON_TXAT_ONE_SHOT 0
+#define MCP251XFD_REG_FIFOCON_TXAT_THREE_SHOT 1
+#define MCP251XFD_REG_FIFOCON_TXAT_UNLIMITED 3
+#define MCP251XFD_REG_FIFOCON_TXPRI_MASK GENMASK(20, 16)
+#define MCP251XFD_REG_FIFOCON_FRESET BIT(10)
+#define MCP251XFD_REG_FIFOCON_TXREQ BIT(9)
+#define MCP251XFD_REG_FIFOCON_UINC BIT(8)
+#define MCP251XFD_REG_FIFOCON_TXEN BIT(7)
+#define MCP251XFD_REG_FIFOCON_RTREN BIT(6)
+#define MCP251XFD_REG_FIFOCON_RXTSEN BIT(5)
+#define MCP251XFD_REG_FIFOCON_TXATIE BIT(4)
+#define MCP251XFD_REG_FIFOCON_RXOVIE BIT(3)
+#define MCP251XFD_REG_FIFOCON_TFERFFIE BIT(2)
+#define MCP251XFD_REG_FIFOCON_TFHRFHIE BIT(1)
+#define MCP251XFD_REG_FIFOCON_TFNRFNIE BIT(0)
+
+#define MCP251XFD_REG_FIFOSTA(x) (0x54 + 0xc * (x))
+#define MCP251XFD_REG_FIFOSTA_FIFOCI_MASK GENMASK(12, 8)
+#define MCP251XFD_REG_FIFOSTA_TXABT BIT(7)
+#define MCP251XFD_REG_FIFOSTA_TXLARB BIT(6)
+#define MCP251XFD_REG_FIFOSTA_TXERR BIT(5)
+#define MCP251XFD_REG_FIFOSTA_TXATIF BIT(4)
+#define MCP251XFD_REG_FIFOSTA_RXOVIF BIT(3)
+#define MCP251XFD_REG_FIFOSTA_TFERFFIF BIT(2)
+#define MCP251XFD_REG_FIFOSTA_TFHRFHIF BIT(1)
+#define MCP251XFD_REG_FIFOSTA_TFNRFNIF BIT(0)
+
+#define MCP251XFD_REG_FIFOUA(x) (0x58 + 0xc * (x))
+
+#define MCP251XFD_REG_FLTCON(x) (0x1d0 + 0x4 * (x))
+#define MCP251XFD_REG_FLTCON_FLTEN3 BIT(31)
+#define MCP251XFD_REG_FLTCON_F3BP_MASK GENMASK(28, 24)
+#define MCP251XFD_REG_FLTCON_FLTEN2 BIT(23)
+#define MCP251XFD_REG_FLTCON_F2BP_MASK GENMASK(20, 16)
+#define MCP251XFD_REG_FLTCON_FLTEN1 BIT(15)
+#define MCP251XFD_REG_FLTCON_F1BP_MASK GENMASK(12, 8)
+#define MCP251XFD_REG_FLTCON_FLTEN0 BIT(7)
+#define MCP251XFD_REG_FLTCON_F0BP_MASK GENMASK(4, 0)
+#define MCP251XFD_REG_FLTCON_FLTEN(x) (BIT(7) << 8 * ((x) & 0x3))
+#define MCP251XFD_REG_FLTCON_FLT_MASK(x) (GENMASK(7, 0) << (8 * ((x) & 0x3)))
+#define MCP251XFD_REG_FLTCON_FBP(x, fifo) ((fifo) << 8 * ((x) & 0x3))
+
+#define MCP251XFD_REG_FLTOBJ(x) (0x1f0 + 0x8 * (x))
+#define MCP251XFD_REG_FLTOBJ_EXIDE BIT(30)
+#define MCP251XFD_REG_FLTOBJ_SID11 BIT(29)
+#define MCP251XFD_REG_FLTOBJ_EID_MASK GENMASK(28, 11)
+#define MCP251XFD_REG_FLTOBJ_SID_MASK GENMASK(10, 0)
+
+#define MCP251XFD_REG_FLTMASK(x) (0x1f4 + 0x8 * (x))
+#define MCP251XFD_REG_MASK_MIDE BIT(30)
+#define MCP251XFD_REG_MASK_MSID11 BIT(29)
+#define MCP251XFD_REG_MASK_MEID_MASK GENMASK(28, 11)
+#define MCP251XFD_REG_MASK_MSID_MASK GENMASK(10, 0)
 
 /* RAM */
-#define MCP25XXFD_RAM_START 0x400
-#define MCP25XXFD_RAM_SIZE SZ_2K
+#define MCP251XFD_RAM_START 0x400
+#define MCP251XFD_RAM_SIZE SZ_2K
 
 /* Message Object */
-#define MCP25XXFD_OBJ_ID_SID11 BIT(29)
-#define MCP25XXFD_OBJ_ID_EID_MASK GENMASK(28, 11)
-#define MCP25XXFD_OBJ_ID_SID_MASK GENMASK(10, 0)
-#define MCP25XXFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK GENMASK(31, 9)
-#define MCP25XXFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK GENMASK(15, 9)
-#define MCP25XXFD_OBJ_FLAGS_SEQ_MASK MCP25XXFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK
-#define MCP25XXFD_OBJ_FLAGS_ESI BIT(8)
-#define MCP25XXFD_OBJ_FLAGS_FDF BIT(7)
-#define MCP25XXFD_OBJ_FLAGS_BRS BIT(6)
-#define MCP25XXFD_OBJ_FLAGS_RTR BIT(5)
-#define MCP25XXFD_OBJ_FLAGS_IDE BIT(4)
-#define MCP25XXFD_OBJ_FLAGS_DLC GENMASK(3, 0)
-
-#define MCP25XXFD_REG_FRAME_EFF_SID_MASK GENMASK(28, 18)
-#define MCP25XXFD_REG_FRAME_EFF_EID_MASK GENMASK(17, 0)
+#define MCP251XFD_OBJ_ID_SID11 BIT(29)
+#define MCP251XFD_OBJ_ID_EID_MASK GENMASK(28, 11)
+#define MCP251XFD_OBJ_ID_SID_MASK GENMASK(10, 0)
+#define MCP251XFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK GENMASK(31, 9)
+#define MCP251XFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK GENMASK(15, 9)
+#define MCP251XFD_OBJ_FLAGS_SEQ_MASK MCP251XFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK
+#define MCP251XFD_OBJ_FLAGS_ESI BIT(8)
+#define MCP251XFD_OBJ_FLAGS_FDF BIT(7)
+#define MCP251XFD_OBJ_FLAGS_BRS BIT(6)
+#define MCP251XFD_OBJ_FLAGS_RTR BIT(5)
+#define MCP251XFD_OBJ_FLAGS_IDE BIT(4)
+#define MCP251XFD_OBJ_FLAGS_DLC GENMASK(3, 0)
+
+#define MCP251XFD_REG_FRAME_EFF_SID_MASK GENMASK(28, 18)
+#define MCP251XFD_REG_FRAME_EFF_EID_MASK GENMASK(17, 0)
 
 /* MCP2517/18FD SFR */
-#define MCP25XXFD_REG_OSC 0xe00
-#define MCP25XXFD_REG_OSC_SCLKRDY BIT(12)
-#define MCP25XXFD_REG_OSC_OSCRDY BIT(10)
-#define MCP25XXFD_REG_OSC_PLLRDY BIT(8)
-#define MCP25XXFD_REG_OSC_CLKODIV_10 3
-#define MCP25XXFD_REG_OSC_CLKODIV_4 2
-#define MCP25XXFD_REG_OSC_CLKODIV_2 1
-#define MCP25XXFD_REG_OSC_CLKODIV_1 0
-#define MCP25XXFD_REG_OSC_CLKODIV_MASK GENMASK(6, 5)
-#define MCP25XXFD_REG_OSC_SCLKDIV BIT(4)
-#define MCP25XXFD_REG_OSC_LPMEN BIT(3)	/* MCP2518FD only */
-#define MCP25XXFD_REG_OSC_OSCDIS BIT(2)
-#define MCP25XXFD_REG_OSC_PLLEN BIT(0)
-
-#define MCP25XXFD_REG_IOCON 0xe04
-#define MCP25XXFD_REG_IOCON_INTOD BIT(30)
-#define MCP25XXFD_REG_IOCON_SOF BIT(29)
-#define MCP25XXFD_REG_IOCON_TXCANOD BIT(28)
-#define MCP25XXFD_REG_IOCON_PM1 BIT(25)
-#define MCP25XXFD_REG_IOCON_PM0 BIT(24)
-#define MCP25XXFD_REG_IOCON_GPIO1 BIT(17)
-#define MCP25XXFD_REG_IOCON_GPIO0 BIT(16)
-#define MCP25XXFD_REG_IOCON_LAT1 BIT(9)
-#define MCP25XXFD_REG_IOCON_LAT0 BIT(8)
-#define MCP25XXFD_REG_IOCON_XSTBYEN BIT(6)
-#define MCP25XXFD_REG_IOCON_TRIS1 BIT(1)
-#define MCP25XXFD_REG_IOCON_TRIS0 BIT(0)
-
-#define MCP25XXFD_REG_CRC 0xe08
-#define MCP25XXFD_REG_CRC_FERRIE BIT(25)
-#define MCP25XXFD_REG_CRC_CRCERRIE BIT(24)
-#define MCP25XXFD_REG_CRC_FERRIF BIT(17)
-#define MCP25XXFD_REG_CRC_CRCERRIF BIT(16)
-#define MCP25XXFD_REG_CRC_IF_MASK GENMASK(17, 16)
-#define MCP25XXFD_REG_CRC_MASK GENMASK(15, 0)
-
-#define MCP25XXFD_REG_ECCCON 0xe0c
-#define MCP25XXFD_REG_ECCCON_PARITY_MASK GENMASK(14, 8)
-#define MCP25XXFD_REG_ECCCON_DEDIE BIT(2)
-#define MCP25XXFD_REG_ECCCON_SECIE BIT(1)
-#define MCP25XXFD_REG_ECCCON_ECCEN BIT(0)
-
-#define MCP25XXFD_REG_ECCSTAT 0xe10
-#define MCP25XXFD_REG_ECCSTAT_ERRADDR_MASK GENMASK(27, 16)
-#define MCP25XXFD_REG_ECCSTAT_IF_MASK GENMASK(2, 1)
-#define MCP25XXFD_REG_ECCSTAT_DEDIF BIT(2)
-#define MCP25XXFD_REG_ECCSTAT_SECIF BIT(1)
-
-#define MCP25XXFD_REG_DEVID 0xe14	/* MCP2518FD only */
-#define MCP25XXFD_REG_DEVID_ID_MASK GENMASK(7, 4)
-#define MCP25XXFD_REG_DEVID_REV_MASK GENMASK(3, 0)
+#define MCP251XFD_REG_OSC 0xe00
+#define MCP251XFD_REG_OSC_SCLKRDY BIT(12)
+#define MCP251XFD_REG_OSC_OSCRDY BIT(10)
+#define MCP251XFD_REG_OSC_PLLRDY BIT(8)
+#define MCP251XFD_REG_OSC_CLKODIV_10 3
+#define MCP251XFD_REG_OSC_CLKODIV_4 2
+#define MCP251XFD_REG_OSC_CLKODIV_2 1
+#define MCP251XFD_REG_OSC_CLKODIV_1 0
+#define MCP251XFD_REG_OSC_CLKODIV_MASK GENMASK(6, 5)
+#define MCP251XFD_REG_OSC_SCLKDIV BIT(4)
+#define MCP251XFD_REG_OSC_LPMEN BIT(3)	/* MCP2518FD only */
+#define MCP251XFD_REG_OSC_OSCDIS BIT(2)
+#define MCP251XFD_REG_OSC_PLLEN BIT(0)
+
+#define MCP251XFD_REG_IOCON 0xe04
+#define MCP251XFD_REG_IOCON_INTOD BIT(30)
+#define MCP251XFD_REG_IOCON_SOF BIT(29)
+#define MCP251XFD_REG_IOCON_TXCANOD BIT(28)
+#define MCP251XFD_REG_IOCON_PM1 BIT(25)
+#define MCP251XFD_REG_IOCON_PM0 BIT(24)
+#define MCP251XFD_REG_IOCON_GPIO1 BIT(17)
+#define MCP251XFD_REG_IOCON_GPIO0 BIT(16)
+#define MCP251XFD_REG_IOCON_LAT1 BIT(9)
+#define MCP251XFD_REG_IOCON_LAT0 BIT(8)
+#define MCP251XFD_REG_IOCON_XSTBYEN BIT(6)
+#define MCP251XFD_REG_IOCON_TRIS1 BIT(1)
+#define MCP251XFD_REG_IOCON_TRIS0 BIT(0)
+
+#define MCP251XFD_REG_CRC 0xe08
+#define MCP251XFD_REG_CRC_FERRIE BIT(25)
+#define MCP251XFD_REG_CRC_CRCERRIE BIT(24)
+#define MCP251XFD_REG_CRC_FERRIF BIT(17)
+#define MCP251XFD_REG_CRC_CRCERRIF BIT(16)
+#define MCP251XFD_REG_CRC_IF_MASK GENMASK(17, 16)
+#define MCP251XFD_REG_CRC_MASK GENMASK(15, 0)
+
+#define MCP251XFD_REG_ECCCON 0xe0c
+#define MCP251XFD_REG_ECCCON_PARITY_MASK GENMASK(14, 8)
+#define MCP251XFD_REG_ECCCON_DEDIE BIT(2)
+#define MCP251XFD_REG_ECCCON_SECIE BIT(1)
+#define MCP251XFD_REG_ECCCON_ECCEN BIT(0)
+
+#define MCP251XFD_REG_ECCSTAT 0xe10
+#define MCP251XFD_REG_ECCSTAT_ERRADDR_MASK GENMASK(27, 16)
+#define MCP251XFD_REG_ECCSTAT_IF_MASK GENMASK(2, 1)
+#define MCP251XFD_REG_ECCSTAT_DEDIF BIT(2)
+#define MCP251XFD_REG_ECCSTAT_SECIF BIT(1)
+
+#define MCP251XFD_REG_DEVID 0xe14	/* MCP2518FD only */
+#define MCP251XFD_REG_DEVID_ID_MASK GENMASK(7, 4)
+#define MCP251XFD_REG_DEVID_REV_MASK GENMASK(3, 0)
 
 /* number of TX FIFO objects, depending on CAN mode
  *
  * FIFO setup: tef: 8*12 bytes = 96 bytes, tx: 8*16 bytes = 128 bytes
  * FIFO setup: tef: 4*12 bytes = 48 bytes, tx: 4*72 bytes = 288 bytes
  */
-#define MCP25XXFD_TX_OBJ_NUM_CAN 8
-#define MCP25XXFD_TX_OBJ_NUM_CANFD 4
+#define MCP251XFD_TX_OBJ_NUM_CAN 8
+#define MCP251XFD_TX_OBJ_NUM_CANFD 4
 
-#if MCP25XXFD_TX_OBJ_NUM_CAN > MCP25XXFD_TX_OBJ_NUM_CANFD
-#define MCP25XXFD_TX_OBJ_NUM_MAX MCP25XXFD_TX_OBJ_NUM_CAN
+#if MCP251XFD_TX_OBJ_NUM_CAN > MCP251XFD_TX_OBJ_NUM_CANFD
+#define MCP251XFD_TX_OBJ_NUM_MAX MCP251XFD_TX_OBJ_NUM_CAN
 #else
-#define MCP25XXFD_TX_OBJ_NUM_MAX MCP25XXFD_TX_OBJ_NUM_CANFD
+#define MCP251XFD_TX_OBJ_NUM_MAX MCP251XFD_TX_OBJ_NUM_CANFD
 #endif
 
-#define MCP25XXFD_NAPI_WEIGHT 32
-#define MCP25XXFD_TX_FIFO 1
-#define MCP25XXFD_RX_FIFO(x) (MCP25XXFD_TX_FIFO + 1 + (x))
+#define MCP251XFD_NAPI_WEIGHT 32
+#define MCP251XFD_TX_FIFO 1
+#define MCP251XFD_RX_FIFO(x) (MCP251XFD_TX_FIFO + 1 + (x))
 
 /* SPI commands */
-#define MCP25XXFD_SPI_INSTRUCTION_RESET 0x0000
-#define MCP25XXFD_SPI_INSTRUCTION_WRITE 0x2000
-#define MCP25XXFD_SPI_INSTRUCTION_READ 0x3000
-#define MCP25XXFD_SPI_INSTRUCTION_WRITE_CRC 0xa000
-#define MCP25XXFD_SPI_INSTRUCTION_READ_CRC 0xb000
-#define MCP25XXFD_SPI_INSTRUCTION_WRITE_CRC_SAFE 0xc000
-#define MCP25XXFD_SPI_ADDRESS_MASK GENMASK(11, 0)
-
-#define MCP25XXFD_SYSCLOCK_HZ_MAX 40000000
-#define MCP25XXFD_SYSCLOCK_HZ_MIN 1000000
-#define MCP25XXFD_SPICLOCK_HZ_MAX 20000000
-#define MCP25XXFD_OSC_PLL_MULTIPLIER 10
-#define MCP25XXFD_OSC_STAB_SLEEP_US (3 * USEC_PER_MSEC)
-#define MCP25XXFD_OSC_STAB_TIMEOUT_US (10 * MCP25XXFD_OSC_STAB_SLEEP_US)
-#define MCP25XXFD_POLL_SLEEP_US (10)
-#define MCP25XXFD_POLL_TIMEOUT_US (USEC_PER_MSEC)
-#define MCP25XXFD_SOFTRESET_RETRIES_MAX 3
-#define MCP25XXFD_READ_CRC_RETRIES_MAX 3
-#define MCP25XXFD_ECC_CNT_MAX 2
-#define MCP25XXFD_SANITIZE_SPI 1
-#define MCP25XXFD_SANITIZE_CAN 1
+#define MCP251XFD_SPI_INSTRUCTION_RESET 0x0000
+#define MCP251XFD_SPI_INSTRUCTION_WRITE 0x2000
+#define MCP251XFD_SPI_INSTRUCTION_READ 0x3000
+#define MCP251XFD_SPI_INSTRUCTION_WRITE_CRC 0xa000
+#define MCP251XFD_SPI_INSTRUCTION_READ_CRC 0xb000
+#define MCP251XFD_SPI_INSTRUCTION_WRITE_CRC_SAFE 0xc000
+#define MCP251XFD_SPI_ADDRESS_MASK GENMASK(11, 0)
+
+#define MCP251XFD_SYSCLOCK_HZ_MAX 40000000
+#define MCP251XFD_SYSCLOCK_HZ_MIN 1000000
+#define MCP251XFD_SPICLOCK_HZ_MAX 20000000
+#define MCP251XFD_OSC_PLL_MULTIPLIER 10
+#define MCP251XFD_OSC_STAB_SLEEP_US (3 * USEC_PER_MSEC)
+#define MCP251XFD_OSC_STAB_TIMEOUT_US (10 * MCP251XFD_OSC_STAB_SLEEP_US)
+#define MCP251XFD_POLL_SLEEP_US (10)
+#define MCP251XFD_POLL_TIMEOUT_US (USEC_PER_MSEC)
+#define MCP251XFD_SOFTRESET_RETRIES_MAX 3
+#define MCP251XFD_READ_CRC_RETRIES_MAX 3
+#define MCP251XFD_ECC_CNT_MAX 2
+#define MCP251XFD_SANITIZE_SPI 1
+#define MCP251XFD_SANITIZE_CAN 1
 
 /* Silence TX MAB overflow warnings */
-#define MCP25XXFD_QUIRK_MAB_NO_WARN BIT(0)
+#define MCP251XFD_QUIRK_MAB_NO_WARN BIT(0)
 /* Use CRC to access registers */
-#define MCP25XXFD_QUIRK_CRC_REG BIT(1)
+#define MCP251XFD_QUIRK_CRC_REG BIT(1)
 /* Use CRC to access RX/TEF-RAM */
-#define MCP25XXFD_QUIRK_CRC_RX BIT(2)
+#define MCP251XFD_QUIRK_CRC_RX BIT(2)
 /* Use CRC to access TX-RAM */
-#define MCP25XXFD_QUIRK_CRC_TX BIT(3)
+#define MCP251XFD_QUIRK_CRC_TX BIT(3)
 /* Enable ECC for RAM */
-#define MCP25XXFD_QUIRK_ECC BIT(4)
+#define MCP251XFD_QUIRK_ECC BIT(4)
 /* Use Half Duplex SPI transfers */
-#define MCP25XXFD_QUIRK_HALF_DUPLEX BIT(5)
+#define MCP251XFD_QUIRK_HALF_DUPLEX BIT(5)
 
-struct mcp25xxfd_hw_tef_obj {
+struct mcp251xfd_hw_tef_obj {
 	u32 id;
 	u32 flags;
 	u32 ts;
@@ -426,86 +426,86 @@ struct mcp25xxfd_hw_tef_obj {
 /* The tx_obj_raw version is used in spi async, i.e. without
  * regmap. We have to take care of endianness ourselves.
  */
-struct mcp25xxfd_hw_tx_obj_raw {
+struct mcp251xfd_hw_tx_obj_raw {
 	__le32 id;
 	__le32 flags;
 	u8 data[sizeof_field(struct canfd_frame, data)];
 };
 
-struct mcp25xxfd_hw_tx_obj_can {
+struct mcp251xfd_hw_tx_obj_can {
 	u32 id;
 	u32 flags;
 	u8 data[sizeof_field(struct can_frame, data)];
 };
 
-struct mcp25xxfd_hw_tx_obj_canfd {
+struct mcp251xfd_hw_tx_obj_canfd {
 	u32 id;
 	u32 flags;
 	u8 data[sizeof_field(struct canfd_frame, data)];
 };
 
-struct mcp25xxfd_hw_rx_obj_can {
+struct mcp251xfd_hw_rx_obj_can {
 	u32 id;
 	u32 flags;
 	u32 ts;
 	u8 data[sizeof_field(struct can_frame, data)];
 };
 
-struct mcp25xxfd_hw_rx_obj_canfd {
+struct mcp251xfd_hw_rx_obj_canfd {
 	u32 id;
 	u32 flags;
 	u32 ts;
 	u8 data[sizeof_field(struct canfd_frame, data)];
 };
 
-struct mcp25xxfd_tef_ring {
+struct mcp251xfd_tef_ring {
 	unsigned int head;
 	unsigned int tail;
 
 	/* u8 obj_num equals tx_ring->obj_num */
-	/* u8 obj_size equals sizeof(struct mcp25xxfd_hw_tef_obj) */
+	/* u8 obj_size equals sizeof(struct mcp251xfd_hw_tef_obj) */
 };
 
-struct __packed mcp25xxfd_buf_cmd {
+struct __packed mcp251xfd_buf_cmd {
 	__be16 cmd;
 };
 
-struct __packed mcp25xxfd_buf_cmd_crc {
+struct __packed mcp251xfd_buf_cmd_crc {
 	__be16 cmd;
 	u8 len;
 };
 
-union mcp25xxfd_tx_obj_load_buf {
+union mcp251xfd_tx_obj_load_buf {
 	struct __packed {
-		struct mcp25xxfd_buf_cmd cmd;
-		struct mcp25xxfd_hw_tx_obj_raw hw_tx_obj;
+		struct mcp251xfd_buf_cmd cmd;
+		struct mcp251xfd_hw_tx_obj_raw hw_tx_obj;
 	} nocrc;
 	struct __packed {
-		struct mcp25xxfd_buf_cmd_crc cmd;
-		struct mcp25xxfd_hw_tx_obj_raw hw_tx_obj;
+		struct mcp251xfd_buf_cmd_crc cmd;
+		struct mcp251xfd_hw_tx_obj_raw hw_tx_obj;
 		__be16 crc;
 	} crc;
 } ____cacheline_aligned;
 
-union mcp25xxfd_write_reg_buf {
+union mcp251xfd_write_reg_buf {
 	struct __packed {
-		struct mcp25xxfd_buf_cmd cmd;
+		struct mcp251xfd_buf_cmd cmd;
 		u8 data[4];
 	} nocrc;
 	struct __packed {
-		struct mcp25xxfd_buf_cmd_crc cmd;
+		struct mcp251xfd_buf_cmd_crc cmd;
 		u8 data[4];
 		__be16 crc;
 	} crc;
 } ____cacheline_aligned;
 
-struct mcp25xxfd_tx_obj {
+struct mcp251xfd_tx_obj {
 	struct spi_message msg;
 	struct spi_transfer xfer[2];
-	union mcp25xxfd_tx_obj_load_buf buf;
+	union mcp251xfd_tx_obj_load_buf buf;
 };
 
-struct mcp25xxfd_tx_ring {
+struct mcp251xfd_tx_ring {
 	unsigned int head;
 	unsigned int tail;
 
@@ -513,11 +513,11 @@ struct mcp25xxfd_tx_ring {
 	u8 obj_num;
 	u8 obj_size;
 
-	struct mcp25xxfd_tx_obj obj[MCP25XXFD_TX_OBJ_NUM_MAX];
-	union mcp25xxfd_write_reg_buf rts_buf;
+	struct mcp251xfd_tx_obj obj[MCP251XFD_TX_OBJ_NUM_MAX];
+	union mcp251xfd_write_reg_buf rts_buf;
 };
 
-struct mcp25xxfd_rx_ring {
+struct mcp251xfd_rx_ring {
 	unsigned int head;
 	unsigned int tail;
 
@@ -527,41 +527,41 @@ struct mcp25xxfd_rx_ring {
 	u8 obj_num;
 	u8 obj_size;
 
-	struct mcp25xxfd_hw_rx_obj_canfd obj[];
+	struct mcp251xfd_hw_rx_obj_canfd obj[];
 };
 
-struct __packed mcp25xxfd_map_buf_nocrc {
-	struct mcp25xxfd_buf_cmd cmd;
+struct __packed mcp251xfd_map_buf_nocrc {
+	struct mcp251xfd_buf_cmd cmd;
 	u8 data[256];
 } ____cacheline_aligned;
 
-struct __packed mcp25xxfd_map_buf_crc {
-	struct mcp25xxfd_buf_cmd_crc cmd;
+struct __packed mcp251xfd_map_buf_crc {
+	struct mcp251xfd_buf_cmd_crc cmd;
 	u8 data[256 - 4];
 	__be16 crc;
 } ____cacheline_aligned;
 
-struct mcp25xxfd_ecc {
+struct mcp251xfd_ecc {
 	u32 ecc_stat;
 	int cnt;
 };
 
-struct mcp25xxfd_regs_status {
+struct mcp251xfd_regs_status {
 	u32 intf;
 };
 
-enum mcp25xxfd_model {
-	MCP25XXFD_MODEL_MCP2517FD = 0x2517,
-	MCP25XXFD_MODEL_MCP2518FD = 0x2518,
-	MCP25XXFD_MODEL_MCP251XFD = 0xffff,	/* autodetect model */
+enum mcp251xfd_model {
+	MCP251XFD_MODEL_MCP2517FD = 0x2517,
+	MCP251XFD_MODEL_MCP2518FD = 0x2518,
+	MCP251XFD_MODEL_MCP251XFD = 0xffff,	/* autodetect model */
 };
 
-struct mcp25xxfd_devtype_data {
-	enum mcp25xxfd_model model;
+struct mcp251xfd_devtype_data {
+	enum mcp251xfd_model model;
 	u32 quirks;
 };
 
-struct mcp25xxfd_priv {
+struct mcp251xfd_priv {
 	struct can_priv can;
 	struct can_rx_offload offload;
 	struct net_device *ndev;
@@ -570,87 +570,87 @@ struct mcp25xxfd_priv {
 	struct regmap *map_rx;			/* RX/TEF RAM access */
 
 	struct regmap *map_nocrc;
-	struct mcp25xxfd_map_buf_nocrc *map_buf_nocrc_rx;
-	struct mcp25xxfd_map_buf_nocrc *map_buf_nocrc_tx;
+	struct mcp251xfd_map_buf_nocrc *map_buf_nocrc_rx;
+	struct mcp251xfd_map_buf_nocrc *map_buf_nocrc_tx;
 
 	struct regmap *map_crc;
-	struct mcp25xxfd_map_buf_crc *map_buf_crc_rx;
-	struct mcp25xxfd_map_buf_crc *map_buf_crc_tx;
+	struct mcp251xfd_map_buf_crc *map_buf_crc_rx;
+	struct mcp251xfd_map_buf_crc *map_buf_crc_tx;
 
 	struct spi_device *spi;
 	u32 spi_max_speed_hz_orig;
 
-	struct mcp25xxfd_tef_ring tef;
-	struct mcp25xxfd_tx_ring tx[1];
-	struct mcp25xxfd_rx_ring *rx[1];
+	struct mcp251xfd_tef_ring tef;
+	struct mcp251xfd_tx_ring tx[1];
+	struct mcp251xfd_rx_ring *rx[1];
 
 	u8 rx_ring_num;
 
-	struct mcp25xxfd_ecc ecc;
-	struct mcp25xxfd_regs_status regs_status;
+	struct mcp251xfd_ecc ecc;
+	struct mcp251xfd_regs_status regs_status;
 
 	struct gpio_desc *rx_int;
 	struct clk *clk;
 	struct regulator *reg_vdd;
 	struct regulator *reg_xceiver;
 
-	struct mcp25xxfd_devtype_data devtype_data;
+	struct mcp251xfd_devtype_data devtype_data;
 	struct can_berr_counter bec;
 };
 
-#define MCP25XXFD_IS(_model) \
+#define MCP251XFD_IS(_model) \
 static inline bool \
-mcp25xxfd_is_##_model(const struct mcp25xxfd_priv *priv) \
+mcp251xfd_is_##_model(const struct mcp251xfd_priv *priv) \
 { \
-	return priv->devtype_data.model == MCP25XXFD_MODEL_MCP##_model##FD; \
+	return priv->devtype_data.model == MCP251XFD_MODEL_MCP##_model##FD; \
 }
 
-MCP25XXFD_IS(2517);
-MCP25XXFD_IS(2518);
-MCP25XXFD_IS(251X);
+MCP251XFD_IS(2517);
+MCP251XFD_IS(2518);
+MCP251XFD_IS(251X);
 
-static inline u8 mcp25xxfd_first_byte_set(u32 mask)
+static inline u8 mcp251xfd_first_byte_set(u32 mask)
 {
 	return (mask & 0x0000ffff) ?
 		((mask & 0x000000ff) ? 0 : 1) :
 		((mask & 0x00ff0000) ? 2 : 3);
 }
 
-static inline u8 mcp25xxfd_last_byte_set(u32 mask)
+static inline u8 mcp251xfd_last_byte_set(u32 mask)
 {
 	return (mask & 0xffff0000) ?
 		((mask & 0xff000000) ? 3 : 2) :
 		((mask & 0x0000ff00) ? 1 : 0);
 }
 
-static inline __be16 mcp25xxfd_cmd_reset(void)
+static inline __be16 mcp251xfd_cmd_reset(void)
 {
-	return cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_RESET);
+	return cpu_to_be16(MCP251XFD_SPI_INSTRUCTION_RESET);
 }
 
 static inline void
-mcp25xxfd_spi_cmd_read_nocrc(struct mcp25xxfd_buf_cmd *cmd, u16 addr)
+mcp251xfd_spi_cmd_read_nocrc(struct mcp251xfd_buf_cmd *cmd, u16 addr)
 {
-	cmd->cmd = cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_READ | addr);
+	cmd->cmd = cpu_to_be16(MCP251XFD_SPI_INSTRUCTION_READ | addr);
 }
 
 static inline void
-mcp25xxfd_spi_cmd_write_nocrc(struct mcp25xxfd_buf_cmd *cmd, u16 addr)
+mcp251xfd_spi_cmd_write_nocrc(struct mcp251xfd_buf_cmd *cmd, u16 addr)
 {
-	cmd->cmd = cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_WRITE | addr);
+	cmd->cmd = cpu_to_be16(MCP251XFD_SPI_INSTRUCTION_WRITE | addr);
 }
 
-static inline bool mcp25xxfd_reg_in_ram(unsigned int reg)
+static inline bool mcp251xfd_reg_in_ram(unsigned int reg)
 {
 	static const struct regmap_range range =
-		regmap_reg_range(MCP25XXFD_RAM_START,
-				 MCP25XXFD_RAM_START + MCP25XXFD_RAM_SIZE - 4);
+		regmap_reg_range(MCP251XFD_RAM_START,
+				 MCP251XFD_RAM_START + MCP251XFD_RAM_SIZE - 4);
 
 	return regmap_reg_in_range(reg, &range);
 }
 
 static inline void
-__mcp25xxfd_spi_cmd_crc_set_len(struct mcp25xxfd_buf_cmd_crc *cmd,
+__mcp251xfd_spi_cmd_crc_set_len(struct mcp251xfd_buf_cmd_crc *cmd,
 				u16 len, bool in_ram)
 {
 	/* Number of u32 for RAM access, number of u8 otherwise. */
@@ -661,59 +661,59 @@ __mcp25xxfd_spi_cmd_crc_set_len(struct mcp25xxfd_buf_cmd_crc *cmd,
 }
 
 static inline void
-mcp25xxfd_spi_cmd_crc_set_len_in_ram(struct mcp25xxfd_buf_cmd_crc *cmd, u16 len)
+mcp251xfd_spi_cmd_crc_set_len_in_ram(struct mcp251xfd_buf_cmd_crc *cmd, u16 len)
 {
-	__mcp25xxfd_spi_cmd_crc_set_len(cmd, len, true);
+	__mcp251xfd_spi_cmd_crc_set_len(cmd, len, true);
 }
 
 static inline void
-mcp25xxfd_spi_cmd_crc_set_len_in_reg(struct mcp25xxfd_buf_cmd_crc *cmd, u16 len)
+mcp251xfd_spi_cmd_crc_set_len_in_reg(struct mcp251xfd_buf_cmd_crc *cmd, u16 len)
 {
-	__mcp25xxfd_spi_cmd_crc_set_len(cmd, len, false);
+	__mcp251xfd_spi_cmd_crc_set_len(cmd, len, false);
 }
 
 static inline void
-mcp25xxfd_spi_cmd_read_crc_set_addr(struct mcp25xxfd_buf_cmd_crc *cmd, u16 addr)
+mcp251xfd_spi_cmd_read_crc_set_addr(struct mcp251xfd_buf_cmd_crc *cmd, u16 addr)
 {
-	cmd->cmd = cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_READ_CRC | addr);
+	cmd->cmd = cpu_to_be16(MCP251XFD_SPI_INSTRUCTION_READ_CRC | addr);
 }
 
 static inline void
-mcp25xxfd_spi_cmd_read_crc(struct mcp25xxfd_buf_cmd_crc *cmd,
+mcp251xfd_spi_cmd_read_crc(struct mcp251xfd_buf_cmd_crc *cmd,
 			   u16 addr, u16 len)
 {
-	mcp25xxfd_spi_cmd_read_crc_set_addr(cmd, addr);
-	__mcp25xxfd_spi_cmd_crc_set_len(cmd, len, mcp25xxfd_reg_in_ram(addr));
+	mcp251xfd_spi_cmd_read_crc_set_addr(cmd, addr);
+	__mcp251xfd_spi_cmd_crc_set_len(cmd, len, mcp251xfd_reg_in_ram(addr));
 }
 
 static inline void
-mcp25xxfd_spi_cmd_write_crc_set_addr(struct mcp25xxfd_buf_cmd_crc *cmd,
+mcp251xfd_spi_cmd_write_crc_set_addr(struct mcp251xfd_buf_cmd_crc *cmd,
 				     u16 addr)
 {
-	cmd->cmd = cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_WRITE_CRC | addr);
+	cmd->cmd = cpu_to_be16(MCP251XFD_SPI_INSTRUCTION_WRITE_CRC | addr);
 }
 
 static inline void
-mcp25xxfd_spi_cmd_write_crc(struct mcp25xxfd_buf_cmd_crc *cmd,
+mcp251xfd_spi_cmd_write_crc(struct mcp251xfd_buf_cmd_crc *cmd,
 			    u16 addr, u16 len)
 {
-	mcp25xxfd_spi_cmd_write_crc_set_addr(cmd, addr);
-	__mcp25xxfd_spi_cmd_crc_set_len(cmd, len, mcp25xxfd_reg_in_ram(addr));
+	mcp251xfd_spi_cmd_write_crc_set_addr(cmd, addr);
+	__mcp251xfd_spi_cmd_crc_set_len(cmd, len, mcp251xfd_reg_in_ram(addr));
 }
 
 static inline u8 *
-mcp25xxfd_spi_cmd_write(const struct mcp25xxfd_priv *priv,
-			union mcp25xxfd_write_reg_buf *write_reg_buf,
+mcp251xfd_spi_cmd_write(const struct mcp251xfd_priv *priv,
+			union mcp251xfd_write_reg_buf *write_reg_buf,
 			u16 addr)
 {
 	u8 *data;
 
-	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_REG) {
-		mcp25xxfd_spi_cmd_write_crc_set_addr(&write_reg_buf->crc.cmd,
+	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_REG) {
+		mcp251xfd_spi_cmd_write_crc_set_addr(&write_reg_buf->crc.cmd,
 						     addr);
 		data = write_reg_buf->crc.data;
 	} else {
-		mcp25xxfd_spi_cmd_write_nocrc(&write_reg_buf->nocrc.cmd,
+		mcp251xfd_spi_cmd_write_nocrc(&write_reg_buf->nocrc.cmd,
 					      addr);
 		data = write_reg_buf->nocrc.data;
 	}
@@ -721,115 +721,115 @@ mcp25xxfd_spi_cmd_write(const struct mcp25xxfd_priv *priv,
 	return data;
 }
 
-static inline u16 mcp25xxfd_get_tef_obj_addr(u8 n)
+static inline u16 mcp251xfd_get_tef_obj_addr(u8 n)
 {
-	return MCP25XXFD_RAM_START +
-		sizeof(struct mcp25xxfd_hw_tef_obj) * n;
+	return MCP251XFD_RAM_START +
+		sizeof(struct mcp251xfd_hw_tef_obj) * n;
 }
 
 static inline u16
-mcp25xxfd_get_tx_obj_addr(const struct mcp25xxfd_tx_ring *ring, u8 n)
+mcp251xfd_get_tx_obj_addr(const struct mcp251xfd_tx_ring *ring, u8 n)
 {
 	return ring->base + ring->obj_size * n;
 }
 
 static inline u16
-mcp25xxfd_get_rx_obj_addr(const struct mcp25xxfd_rx_ring *ring, u8 n)
+mcp251xfd_get_rx_obj_addr(const struct mcp251xfd_rx_ring *ring, u8 n)
 {
 	return ring->base + ring->obj_size * n;
 }
 
-static inline u8 mcp25xxfd_get_tef_head(const struct mcp25xxfd_priv *priv)
+static inline u8 mcp251xfd_get_tef_head(const struct mcp251xfd_priv *priv)
 {
 	return priv->tef.head & (priv->tx->obj_num - 1);
 }
 
-static inline u8 mcp25xxfd_get_tef_tail(const struct mcp25xxfd_priv *priv)
+static inline u8 mcp251xfd_get_tef_tail(const struct mcp251xfd_priv *priv)
 {
 	return priv->tef.tail & (priv->tx->obj_num - 1);
 }
 
-static inline u8 mcp25xxfd_get_tef_len(const struct mcp25xxfd_priv *priv)
+static inline u8 mcp251xfd_get_tef_len(const struct mcp251xfd_priv *priv)
 {
 	return priv->tef.head - priv->tef.tail;
 }
 
-static inline u8 mcp25xxfd_get_tef_linear_len(const struct mcp25xxfd_priv *priv)
+static inline u8 mcp251xfd_get_tef_linear_len(const struct mcp251xfd_priv *priv)
 {
 	u8 len;
 
-	len = mcp25xxfd_get_tef_len(priv);
+	len = mcp251xfd_get_tef_len(priv);
 
-	return min_t(u8, len, priv->tx->obj_num - mcp25xxfd_get_tef_tail(priv));
+	return min_t(u8, len, priv->tx->obj_num - mcp251xfd_get_tef_tail(priv));
 }
 
-static inline u8 mcp25xxfd_get_tx_head(const struct mcp25xxfd_tx_ring *ring)
+static inline u8 mcp251xfd_get_tx_head(const struct mcp251xfd_tx_ring *ring)
 {
 	return ring->head & (ring->obj_num - 1);
 }
 
-static inline u8 mcp25xxfd_get_tx_tail(const struct mcp25xxfd_tx_ring *ring)
+static inline u8 mcp251xfd_get_tx_tail(const struct mcp251xfd_tx_ring *ring)
 {
 	return ring->tail & (ring->obj_num - 1);
 }
 
-static inline u8 mcp25xxfd_get_tx_free(const struct mcp25xxfd_tx_ring *ring)
+static inline u8 mcp251xfd_get_tx_free(const struct mcp251xfd_tx_ring *ring)
 {
 	return ring->obj_num - (ring->head - ring->tail);
 }
 
 static inline int
-mcp25xxfd_get_tx_nr_by_addr(const struct mcp25xxfd_tx_ring *tx_ring, u8 *nr,
+mcp251xfd_get_tx_nr_by_addr(const struct mcp251xfd_tx_ring *tx_ring, u8 *nr,
 			    u16 addr)
 {
-	if (addr < mcp25xxfd_get_tx_obj_addr(tx_ring, 0) ||
-	    addr >= mcp25xxfd_get_tx_obj_addr(tx_ring, tx_ring->obj_num))
+	if (addr < mcp251xfd_get_tx_obj_addr(tx_ring, 0) ||
+	    addr >= mcp251xfd_get_tx_obj_addr(tx_ring, tx_ring->obj_num))
 		return -ENOENT;
 
-	*nr = (addr - mcp25xxfd_get_tx_obj_addr(tx_ring, 0)) /
+	*nr = (addr - mcp251xfd_get_tx_obj_addr(tx_ring, 0)) /
 		tx_ring->obj_size;
 
 	return 0;
 }
 
-static inline u8 mcp25xxfd_get_rx_head(const struct mcp25xxfd_rx_ring *ring)
+static inline u8 mcp251xfd_get_rx_head(const struct mcp251xfd_rx_ring *ring)
 {
 	return ring->head & (ring->obj_num - 1);
 }
 
-static inline u8 mcp25xxfd_get_rx_tail(const struct mcp25xxfd_rx_ring *ring)
+static inline u8 mcp251xfd_get_rx_tail(const struct mcp251xfd_rx_ring *ring)
 {
 	return ring->tail & (ring->obj_num - 1);
 }
 
-static inline u8 mcp25xxfd_get_rx_len(const struct mcp25xxfd_rx_ring *ring)
+static inline u8 mcp251xfd_get_rx_len(const struct mcp251xfd_rx_ring *ring)
 {
 	return ring->head - ring->tail;
 }
 
 static inline u8
-mcp25xxfd_get_rx_linear_len(const struct mcp25xxfd_rx_ring *ring)
+mcp251xfd_get_rx_linear_len(const struct mcp251xfd_rx_ring *ring)
 {
 	u8 len;
 
-	len = mcp25xxfd_get_rx_len(ring);
+	len = mcp251xfd_get_rx_len(ring);
 
-	return min_t(u8, len, ring->obj_num - mcp25xxfd_get_rx_tail(ring));
+	return min_t(u8, len, ring->obj_num - mcp251xfd_get_rx_tail(ring));
 }
 
-#define mcp25xxfd_for_each_tx_obj(ring, _obj, n) \
+#define mcp251xfd_for_each_tx_obj(ring, _obj, n) \
 	for ((n) = 0, (_obj) = &(ring)->obj[(n)]; \
 	     (n) < (ring)->obj_num; \
 	     (n)++, (_obj) = &(ring)->obj[(n)])
 
-#define mcp25xxfd_for_each_rx_ring(priv, ring, n) \
+#define mcp251xfd_for_each_rx_ring(priv, ring, n) \
 	for ((n) = 0, (ring) = *((priv)->rx + (n)); \
 	     (n) < (priv)->rx_ring_num; \
 	     (n)++, (ring) = *((priv)->rx + (n)))
 
-int mcp25xxfd_regmap_init(struct mcp25xxfd_priv *priv);
-u16 mcp25xxfd_crc16_compute2(const void *cmd, size_t cmd_size,
+int mcp251xfd_regmap_init(struct mcp251xfd_priv *priv);
+u16 mcp251xfd_crc16_compute2(const void *cmd, size_t cmd_size,
 			     const void *data, size_t data_size);
-u16 mcp25xxfd_crc16_compute(const void *data, size_t data_size);
+u16 mcp251xfd_crc16_compute(const void *data, size_t data_size);
 
 #endif
-- 
2.28.0


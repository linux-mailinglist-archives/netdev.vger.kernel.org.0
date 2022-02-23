Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECDF4C1EFB
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244642AbiBWWpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244586AbiBWWpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:45:06 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D7854186
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:44:00 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN0MY-0006vf-AB
        for netdev@vger.kernel.org; Wed, 23 Feb 2022 23:43:58 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D87563BC5F
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A4CC03BC4E;
        Wed, 23 Feb 2022 22:43:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 51cd9ecc;
        Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 36/36] can: mcp251xfd: mcp251xfd_priv: introduce macros specifying the number of supported TEF/RX/TX rings
Date:   Wed, 23 Feb 2022 23:43:32 +0100
Message-Id: <20220223224332.2965690-37-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223224332.2965690-1-mkl@pengutronix.de>
References: <20220223224332.2965690-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces macros to define the number of supported TEF, RX
and TX rings. As well as some assertions as sanity checks.

Link: https://lore.kernel.org/all/20220217103826.2299157-9-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index f359dd0aa458..87cc13d455c1 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -2,7 +2,7 @@
  *
  * mcp251xfd - Microchip MCP251xFD Family CAN controller driver
  *
- * Copyright (c) 2019, 2020 Pengutronix,
+ * Copyright (c) 2019, 2020, 2021 Pengutronix,
  *               Marc Kleine-Budde <kernel@pengutronix.de>
  * Copyright (c) 2019 Martin Sperl <kernel@martin.sperl.org>
  */
@@ -410,6 +410,15 @@ static_assert(MCP251XFD_TIMESTAMP_WORK_DELAY_SEC <
 #define MCP251XFD_SANITIZE_SPI 1
 #define MCP251XFD_SANITIZE_CAN 1
 
+/* FIFO and Ring */
+#define MCP251XFD_FIFO_TEF_NUM 1U
+#define MCP251XFD_FIFO_RX_NUM_MAX 1U
+#define MCP251XFD_FIFO_TX_NUM 1U
+
+static_assert(MCP251XFD_FIFO_TEF_NUM == 1U);
+static_assert(MCP251XFD_FIFO_TEF_NUM == MCP251XFD_FIFO_TX_NUM);
+static_assert(MCP251XFD_FIFO_RX_NUM_MAX <= 4U);
+
 /* Silence TX MAB overflow warnings */
 #define MCP251XFD_QUIRK_MAB_NO_WARN BIT(0)
 /* Use CRC to access registers */
@@ -596,9 +605,9 @@ struct mcp251xfd_priv {
 	u32 spi_max_speed_hz_fast;
 	u32 spi_max_speed_hz_slow;
 
-	struct mcp251xfd_tef_ring tef[1];
-	struct mcp251xfd_rx_ring *rx[1];
-	struct mcp251xfd_tx_ring tx[1];
+	struct mcp251xfd_tef_ring tef[MCP251XFD_FIFO_TEF_NUM];
+	struct mcp251xfd_rx_ring *rx[MCP251XFD_FIFO_RX_NUM_MAX];
+	struct mcp251xfd_tx_ring tx[MCP251XFD_FIFO_TX_NUM];
 
 	u8 rx_ring_num;
 
-- 
2.34.1



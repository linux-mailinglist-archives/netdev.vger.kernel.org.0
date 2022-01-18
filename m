Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57094919F6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346304AbiARC5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345490AbiARCs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:48:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26E8C0612EA;
        Mon, 17 Jan 2022 18:39:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3178B610AB;
        Tue, 18 Jan 2022 02:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3113C36AF3;
        Tue, 18 Jan 2022 02:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473596;
        bh=csDPm90U76rsS2TRvT3VQSdssrRCu4Q7DK66RQylqBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPTZI2fZ3fHm8ZZyW87z30deSDRZ88+Fo52kdEf6KaeqHmTp1hvbTNG54QKqxtenc
         TE4EbvtIdgBp2IqrzTkTv4HsRNR/W1MUuY09YmH1kwgnta7u0wLjx0Axhu4zt3jh4i
         VHvSOkAxC9c37UsB3I7BYCz7vhWTaGgQoBt1bwpKVOX9b4HYSntBpUD97yycp0qNIs
         3nlpBP9p/TXbIM8i1HxlkhbWzxmonngxFvIGTjvtYl66cm+nWzlupiNba1GZH1UaP0
         gz6tzeH/kywt+iUP8XKeNvtJbh9JrYI1/cm8ZoPVfHmw3y19PO2PiwTjYq5a8v1A5+
         URWEd2leiwiig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 185/188] can: flexcan: rename RX modes
Date:   Mon, 17 Jan 2022 21:31:49 -0500
Message-Id: <20220118023152.1948105-185-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 34ea4e1c99f1f177f87e4ae7896caef238dd741a ]

Most flexcan IP cores support 2 RX modes:
- FIFO
- mailbox

The names for these modes were chosen to reflect the name of the
rx-offload mode they are using.

The name of the RX modes should better reflect their difference with
regards the flexcan IP core. So this patch renames the various
occurrences of OFF_FIFO to RX_FIFO and OFF_TIMESTAMP to RX_MAILBOX:

| FLEXCAN_TX_MB_RESERVED_OFF_FIFO -> FLEXCAN_TX_MB_RESERVED_RX_FIFO
| FLEXCAN_TX_MB_RESERVED_OFF_TIMESTAMP -> FLEXCAN_TX_MB_RESERVED_RX_MAILBOX
| FLEXCAN_QUIRK_USE_OFF_TIMESTAMP -> FLEXCAN_QUIRK_USE_RX_MAILBOX

Link: https://lore.kernel.org/all/20220107193105.1699523-4-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 48 +++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 3178557e40208..02299befe2852 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -173,9 +173,9 @@
 
 /* FLEXCAN interrupt flag register (IFLAG) bits */
 /* Errata ERR005829 step7: Reserve first valid MB */
-#define FLEXCAN_TX_MB_RESERVED_OFF_FIFO		8
-#define FLEXCAN_TX_MB_RESERVED_OFF_TIMESTAMP	0
-#define FLEXCAN_RX_MB_OFF_TIMESTAMP_FIRST	(FLEXCAN_TX_MB_RESERVED_OFF_TIMESTAMP + 1)
+#define FLEXCAN_TX_MB_RESERVED_RX_FIFO	8
+#define FLEXCAN_TX_MB_RESERVED_RX_MAILBOX	0
+#define FLEXCAN_RX_MB_RX_MAILBOX_FIRST	(FLEXCAN_TX_MB_RESERVED_RX_MAILBOX + 1)
 #define FLEXCAN_IFLAG_MB(x)		BIT_ULL(x)
 #define FLEXCAN_IFLAG_RX_FIFO_OVERFLOW	BIT(7)
 #define FLEXCAN_IFLAG_RX_FIFO_WARN	BIT(6)
@@ -234,8 +234,8 @@
 #define FLEXCAN_QUIRK_ENABLE_EACEN_RRS  BIT(3)
 /* Disable non-correctable errors interrupt and freeze mode */
 #define FLEXCAN_QUIRK_DISABLE_MECR BIT(4)
-/* Use timestamp based offloading */
-#define FLEXCAN_QUIRK_USE_OFF_TIMESTAMP BIT(5)
+/* Use mailboxes (not FIFO) for RX path */
+#define FLEXCAN_QUIRK_USE_RX_MAILBOX BIT(5)
 /* No interrupt for error passive */
 #define FLEXCAN_QUIRK_BROKEN_PERR_STATE BIT(6)
 /* default to BE register access */
@@ -402,38 +402,38 @@ static const struct flexcan_devtype_data fsl_imx28_devtype_data = {
 
 static const struct flexcan_devtype_data fsl_imx6q_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
 		FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR,
 };
 
 static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
 		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW,
 };
 
 static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
+		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
 		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR |
 		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
+		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
 		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_RX_MAILBOX,
 };
 
 static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_SUPPORT_FD |
+		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_SUPPORT_FD |
 		FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
@@ -1018,7 +1018,7 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 
 	mb = flexcan_get_mb(priv, n);
 
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
 		u32 code;
 
 		do {
@@ -1083,7 +1083,7 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 	}
 
  mark_as_read:
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)
 		flexcan_write64(priv, FLEXCAN_IFLAG_MB(n), &regs->iflag1);
 	else
 		priv->write(FLEXCAN_IFLAG_RX_FIFO_AVAILABLE, &regs->iflag1);
@@ -1109,7 +1109,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 	enum can_state last_state = priv->can.state;
 
 	/* reception interrupt */
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
 		u64 reg_iflag_rx;
 		int ret;
 
@@ -1429,20 +1429,20 @@ static int flexcan_rx_offload_setup(struct net_device *dev)
 		priv->mb_count = (sizeof(priv->regs->mb[0]) / priv->mb_size) +
 				 (sizeof(priv->regs->mb[1]) / priv->mb_size);
 
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)
 		priv->tx_mb_reserved =
-			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_OFF_TIMESTAMP);
+			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_RX_MAILBOX);
 	else
 		priv->tx_mb_reserved =
-			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_OFF_FIFO);
+			flexcan_get_mb(priv, FLEXCAN_TX_MB_RESERVED_RX_FIFO);
 	priv->tx_mb_idx = priv->mb_count - 1;
 	priv->tx_mb = flexcan_get_mb(priv, priv->tx_mb_idx);
 	priv->tx_mask = FLEXCAN_IFLAG_MB(priv->tx_mb_idx);
 
 	priv->offload.mailbox_read = flexcan_mailbox_read;
 
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
-		priv->offload.mb_first = FLEXCAN_RX_MB_OFF_TIMESTAMP_FIRST;
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
+		priv->offload.mb_first = FLEXCAN_RX_MB_RX_MAILBOX_FIRST;
 		priv->offload.mb_last = priv->mb_count - 2;
 
 		priv->rx_mask = GENMASK_ULL(priv->offload.mb_last,
@@ -1532,10 +1532,10 @@ static int flexcan_chip_start(struct net_device *dev)
 	/* MCR
 	 *
 	 * FIFO:
-	 * - disable for timestamp mode
+	 * - disable for mailbox mode
 	 * - enable for FIFO mode
 	 */
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)
 		reg_mcr &= ~FLEXCAN_MCR_FEN;
 	else
 		reg_mcr |= FLEXCAN_MCR_FEN;
@@ -1631,7 +1631,7 @@ static int flexcan_chip_start(struct net_device *dev)
 		priv->write(reg_fdctrl, &regs->fdctrl);
 	}
 
-	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
 		for (i = priv->offload.mb_first; i <= priv->offload.mb_last; i++) {
 			mb = flexcan_get_mb(priv, i);
 			priv->write(FLEXCAN_MB_CODE_RX_EMPTY,
@@ -1639,7 +1639,7 @@ static int flexcan_chip_start(struct net_device *dev)
 		}
 	} else {
 		/* clear and invalidate unused mailboxes first */
-		for (i = FLEXCAN_TX_MB_RESERVED_OFF_FIFO; i < priv->mb_count; i++) {
+		for (i = FLEXCAN_TX_MB_RESERVED_RX_FIFO; i < priv->mb_count; i++) {
 			mb = flexcan_get_mb(priv, i);
 			priv->write(FLEXCAN_MB_CODE_RX_INACTIVE,
 				    &mb->can_ctrl);
@@ -2164,7 +2164,7 @@ static int flexcan_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	if ((devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) &&
-	    !(devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)) {
+	    !(devtype_data->quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)) {
 		dev_err(&pdev->dev, "CAN-FD mode doesn't work with FIFO mode!\n");
 		return -EINVAL;
 	}
-- 
2.34.1


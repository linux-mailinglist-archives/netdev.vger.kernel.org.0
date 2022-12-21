Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81D565335E
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbiLUP2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbiLUP0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:26:35 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC4724F1F
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:58 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id m21so11989076edc.3
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnuTWgs891MmWmFfR4Qv/YHEM/0HR/0MI73lfSbcCY4=;
        b=aDBvkMWROJJ1SF+9K9XlqbliT77HqNm+Vg5LPrt86sC4Ox5IwW9S7z2MqBRFrwymjk
         x7HxUiz5K3uaKEspxe6fxE7SNlrdB/bWXv09FrzCMWHgpVAYsOeKjOEVeqtMjSWF3Yg8
         WX2sngaQTsSIA7AJSuQu38M1rxX8VC6NEPdDFqV3PBRoEvM/4MCvqu7tBTjx93bUpU91
         rBt88EiXsD8zuGQ1GhkgCceg4wn015vd7Qw/8VgCB2nLuZxCurot8eNjf4nQErgTCcOP
         UgvKDKyLu4ksD/vcMo6gQ8mqmaGNQHys7TstbQ9HsR44nEQdz+njgtBBNZ6oQGh2zCUY
         avoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnuTWgs891MmWmFfR4Qv/YHEM/0HR/0MI73lfSbcCY4=;
        b=hh+1nSoVtHLULwDl/MV/ZM/1UnIJCd5hfs03QrBBDLUvAfRpcFCChIqbTiPaGwJ0YA
         yrnoqTFNGhwClFSugocQqajlbnf3pm0uTNLsKV4Ny17CksdiabOwsYgQ6k3KkwWe9wsm
         36J9g9HU6PdJp7YvzPUHeXvGJsdUf6de+uks49FFfdk/Z+SSLf5NS+JZHeejPsjwu2cK
         cG1uJi/ekxo7O9fceVyyXrE6K/5GRUVIDznSupGFbjKplNfPuz57TtHYlG+ru/IRMrbX
         oaOsFXbTTCJ7o6v80ytIxPi/dWrvlTR4xLTTlOq+jzGT1ISN6fAOjMEpSUe3rgUseqaM
         M4DA==
X-Gm-Message-State: AFqh2krfj6y3MATh5wDqRgAmaRXvp621YdA17okyKDutqOb4qw1FmuKw
        m3aASD2ckzfGB5g4rVo8nLkXkA==
X-Google-Smtp-Source: AMrXdXvXBnVEANUHuH8J6f3JaGNS3lJlvVbNU9b6rlvuhc1hs1KbMNUqeWvEeHdBjrov1egw19JJfA==
X-Received: by 2002:a05:6402:14d8:b0:45c:835b:944f with SMTP id f24-20020a05640214d800b0045c835b944fmr1651513edx.11.1671636358062;
        Wed, 21 Dec 2022 07:25:58 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:57 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 18/18] can: m_can: Implement transmit submission coalescing
Date:   Wed, 21 Dec 2022 16:25:37 +0100
Message-Id: <20221221152537.751564-19-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
References: <20221221152537.751564-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

m_can supports submitting mulitple transmits with one register write.
This is an interesting option to reduce the number of SPI transfers for
peripheral chips.

The m_can_tx_op is extended with a bool that signals if it is the last
transmission and the submit should be executed immediately.

The worker then writes the skb to the FIFO and submits it only if the
submit bool is set. If it isn't set, the worker will write the next skb
which is waiting in the workqueue to the FIFO, etc.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---

Notes:
    Notes:
    - I ran into lost messages in the receive FIFO when using this
      implementation. I guess this only shows up with my test setup in
      loopback mode and maybe not enough CPU power.
    - I put this behind the tx-frames ethtool coalescing option as we do
      wait before submitting packages but it is something different than the
      tx-frames-irq option. I am not sure if this is the correct option,
      please let me know.

 drivers/net/can/m_can/m_can.c | 56 ++++++++++++++++++++++++++++++++---
 drivers/net/can/m_can/m_can.h |  6 ++++
 2 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 719a7dfe154a..9431735fb887 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1457,6 +1457,9 @@ static void m_can_start(struct net_device *dev)
 	/* basic m_can configuration */
 	m_can_chip_config(dev);
 
+	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(cdev->net, 0),
+				       cdev->tx_max_coalesced_frames);
+
 	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	m_can_enable_all_interrupts(cdev);
@@ -1764,8 +1767,13 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 		 */
 		can_put_echo_skb(skb, dev, putidx, frame_len);
 
-		/* Enable TX FIFO element to start transfer  */
-		m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
+		if (cdev->is_peripheral) {
+			/* Delay enabling TX FIFO element */
+			cdev->tx_peripheral_submit |= BIT(putidx);
+		} else {
+			/* Enable TX FIFO element to start transfer  */
+			m_can_write(cdev, M_CAN_TXBAR, BIT(putidx));
+		}
 		cdev->tx_fifo_putidx = (++cdev->tx_fifo_putidx >= cdev->can.echo_skb_max ?
 					0 : cdev->tx_fifo_putidx);
 	}
@@ -1778,6 +1786,17 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 	return NETDEV_TX_BUSY;
 }
 
+static void m_can_tx_submit(struct m_can_classdev *cdev)
+{
+	if (cdev->version == 30)
+		return;
+	if (!cdev->is_peripheral)
+		return;
+
+	m_can_write(cdev, M_CAN_TXBAR, cdev->tx_peripheral_submit);
+	cdev->tx_peripheral_submit = 0;
+}
+
 static void m_can_tx_work_queue(struct work_struct *ws)
 {
 	struct m_can_tx_op *op = container_of(ws, struct m_can_tx_op, work);
@@ -1786,11 +1805,15 @@ static void m_can_tx_work_queue(struct work_struct *ws)
 
 	op->skb = NULL;
 	m_can_tx_handler(cdev, skb);
+	if (op->submit)
+		m_can_tx_submit(cdev);
 }
 
-static void m_can_tx_queue_skb(struct m_can_classdev *cdev, struct sk_buff *skb)
+static void m_can_tx_queue_skb(struct m_can_classdev *cdev, struct sk_buff *skb,
+			       bool submit)
 {
 	cdev->tx_ops[cdev->next_tx_op].skb = skb;
+	cdev->tx_ops[cdev->next_tx_op].submit = submit;
 	queue_work(cdev->tx_wq, &cdev->tx_ops[cdev->next_tx_op].work);
 
 	++cdev->next_tx_op;
@@ -1801,6 +1824,8 @@ static void m_can_tx_queue_skb(struct m_can_classdev *cdev, struct sk_buff *skb)
 static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
 					       struct sk_buff *skb)
 {
+	bool submit;
+
 	if (cdev->can.state == CAN_STATE_BUS_OFF) {
 		m_can_clean(cdev->net);
 		return NETDEV_TX_OK;
@@ -1818,7 +1843,15 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
 	}
 	spin_unlock(&cdev->tx_handling_spinlock);
 
-	m_can_tx_queue_skb(cdev, skb);
+	++cdev->nr_txs_without_submit;
+	if (cdev->nr_txs_without_submit >= cdev->tx_max_coalesced_frames ||
+	    !netdev_xmit_more()) {
+		cdev->nr_txs_without_submit = 0;
+		submit = true;
+	} else {
+		submit = false;
+	}
+	m_can_tx_queue_skb(cdev, skb, submit);
 
 	return NETDEV_TX_OK;
 }
@@ -1954,6 +1987,7 @@ static int m_can_get_coalesce(struct net_device *dev,
 
 	ec->rx_max_coalesced_frames_irq = cdev->rx_max_coalesced_frames_irq;
 	ec->rx_coalesce_usecs_irq = cdev->rx_coalesce_usecs_irq;
+	ec->tx_max_coalesced_frames = cdev->tx_max_coalesced_frames;
 	ec->tx_max_coalesced_frames_irq = cdev->tx_max_coalesced_frames_irq;
 	ec->tx_coalesce_usecs_irq = cdev->tx_coalesce_usecs_irq;
 
@@ -1998,6 +2032,18 @@ static int m_can_set_coalesce(struct net_device *dev,
 		netdev_err(dev, "tx-frames-irq and tx-usecs-irq can only be set together\n");
 		return -EINVAL;
 	}
+	if (ec->tx_max_coalesced_frames > cdev->mcfg[MRAM_TXE].num) {
+		netdev_err(dev, "tx-frames (%u) greater than the TX event FIFO (%u)\n",
+			   ec->tx_max_coalesced_frames,
+			   cdev->mcfg[MRAM_TXE].num);
+		return -EINVAL;
+	}
+	if (ec->tx_max_coalesced_frames > cdev->mcfg[MRAM_TXB].num) {
+		netdev_err(dev, "tx-frames (%u) greater than the TX FIFO (%u)\n",
+			   ec->tx_max_coalesced_frames,
+			   cdev->mcfg[MRAM_TXB].num);
+		return -EINVAL;
+	}
 	if (ec->rx_coalesce_usecs_irq != 0 && ec->tx_coalesce_usecs_irq != 0 &&
 	    ec->rx_coalesce_usecs_irq != ec->tx_coalesce_usecs_irq) {
 		netdev_err(dev, "rx-usecs-irq (%u) needs to be equal to tx-usecs-irq (%u) if both are enabled\n",
@@ -2008,6 +2054,7 @@ static int m_can_set_coalesce(struct net_device *dev,
 
 	cdev->rx_max_coalesced_frames_irq = ec->rx_max_coalesced_frames_irq;
 	cdev->rx_coalesce_usecs_irq = ec->rx_coalesce_usecs_irq;
+	cdev->tx_max_coalesced_frames = ec->tx_max_coalesced_frames;
 	cdev->tx_max_coalesced_frames_irq = ec->tx_max_coalesced_frames_irq;
 	cdev->tx_coalesce_usecs_irq = ec->tx_coalesce_usecs_irq;
 
@@ -2025,6 +2072,7 @@ static const struct ethtool_ops m_can_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS_IRQ |
 		ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ |
 		ETHTOOL_COALESCE_TX_USECS_IRQ |
+		ETHTOOL_COALESCE_TX_MAX_FRAMES |
 		ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ,
 	.get_ts_info = ethtool_op_get_ts_info,
 	.get_coalesce = m_can_get_coalesce,
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index adbd4765accc..40d90016285b 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -74,6 +74,7 @@ struct m_can_tx_op {
 	struct m_can_classdev *cdev;
 	struct work_struct work;
 	struct sk_buff *skb;
+	bool submit;
 };
 
 struct m_can_classdev {
@@ -103,6 +104,7 @@ struct m_can_classdev {
 	u32 active_interrupts;
 	u32 rx_max_coalesced_frames_irq;
 	u32 rx_coalesce_usecs_irq;
+	u32 tx_max_coalesced_frames;
 	u32 tx_max_coalesced_frames_irq;
 	u32 tx_coalesce_usecs_irq;
 
@@ -117,6 +119,10 @@ struct m_can_classdev {
 	int nr_tx_ops;
 	int next_tx_op;
 
+	int nr_txs_without_submit;
+	/* bitfield of fifo elements that will be submitted together */
+	u32 tx_peripheral_submit;
+
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
 };
 
-- 
2.38.1


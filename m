Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0715A62CB9D
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbiKPUyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234171AbiKPUxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:53:46 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E26E31
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:27 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id n12so47099469eja.11
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ymKWfG3hBUHC+wOiiQxZhyFHyJiOcWTWeXnW4/XpvSQ=;
        b=uBIdtaeGMMK0etaJ10sYW6BxgNAyYojLXCGy0W42C+OfWLPOupay7/r0gtDdbrusfx
         UMGtFFUhGTNuo62g/z04us3xcWWsJylHgFAzaLUOKDz4nkF7I6lR5JYF1XR+1z9PCcMO
         SWZ5+W2N46uWnqy/y4Iec02er6vZlbge75TGJyzfM44ovW2lte7VHobLp4A7N+P1kHiE
         hSV2cRdrnkUqf3fhiHpB7Ya2OHa2borOYj/kxMXgVL392o4f21DoNWSwft4nNhJSLfM6
         O54h8A2SVNF+4tTC6/YQnzgL/WfzCj9ZIJUkJ3wnyAi1hCo1xrSRnjhVaINTIrKp94SE
         Jm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ymKWfG3hBUHC+wOiiQxZhyFHyJiOcWTWeXnW4/XpvSQ=;
        b=pgxdQ+3yduPi6vWfaa09eju3B3Xvn/6+mLI3vFM5PhKZeMCkpy+4fi3S80n7XKqFmu
         Zg8yUbn3v4FEOZbVByMwBfnmkI7P8Lz2w3BWgwzvjGthozqlQPnjTatyI0rV56sNMFF3
         0SsATLCvrka7X4h9mkqzuWfvp/Id8xhIWkieOyebQ9TEJKEEKdqf78NV0pBju537wBsM
         /2Nh50uTBgrxTl9n3fNZuXrOvL68Z7lpr60f/i+uZRxgmJRzF50+eWOVPBeU86kLvMnZ
         zfWJFUeg3hjKEpiAXK4GQv3Ftz1CaYyip2Oc9lcYCUmAUIYqe/XRGXzknmgbMCzo8MCj
         ythw==
X-Gm-Message-State: ANoB5pmK3hZPww1dDF+2ju1flnS2qcjfKYCrZDvzu02+vchV4/X1LkG4
        5C9NrG45S3Bynm3m2pCrnGVvzA==
X-Google-Smtp-Source: AA0mqf5RtmC4SVdyOxL7UJ+lPNbAvIxVBnVYZ5yvegJySAd+TTMaVLm+yOWD7L+39PITwJrZLo3yag==
X-Received: by 2002:a17:906:49c2:b0:79f:e0b3:3b9b with SMTP id w2-20020a17090649c200b0079fe0b33b9bmr18729246ejv.378.1668632006474;
        Wed, 16 Nov 2022 12:53:26 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:26 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 03/15] can: m_can: Cache tx putidx and transmits in flight
Date:   Wed, 16 Nov 2022 21:52:56 +0100
Message-Id: <20221116205308.2996556-4-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116205308.2996556-1-msp@baylibre.com>
References: <20221116205308.2996556-1-msp@baylibre.com>
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

On peripheral chips every read/write can be costly. Avoid reading easily
trackable information and cache them internally. This saves multiple
reads.

Transmit FIFO put index is cached, this is increased for every time we
enqueue a transmit request.

The transmits in flight is cached as well. With each transmit request it
is increased when reading the finished transmit event it is decreased.

A submit limit is cached to avoid submitting too many transmits at once,
either because the TX FIFO or the TXE FIFO is limited. This is currently
done very conservatively as the minimum of the fifo sizes. This means we
can reach FIFO full events but won't drop anything.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 21 +++++++++++++++------
 drivers/net/can/m_can/m_can.h |  5 +++++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 4adf03111782..f5bba848bd56 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1041,6 +1041,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
 		/* ack txe element */
 		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
 							  fgi));
+		--cdev->tx_fifo_in_flight;
 
 		/* update stats */
 		m_can_tx_update_stats(cdev, msg_mark, timestamp);
@@ -1376,6 +1377,14 @@ static void m_can_start(struct net_device *dev)
 	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	m_can_enable_all_interrupts(cdev);
+
+	if (cdev->version > 30) {
+		cdev->tx_fifo_putidx = FIELD_GET(TXFQS_TFQPI_MASK,
+						 m_can_read(cdev, M_CAN_TXFQS));
+		cdev->tx_fifo_in_flight = 0;
+		cdev->tx_fifo_submit_limit = min(cdev->mcfg[MRAM_TXE].num,
+						 cdev->mcfg[MRAM_TXB].num);
+	}
 }
 
 static int m_can_set_mode(struct net_device *dev, enum can_mode mode)
@@ -1589,7 +1598,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	struct sk_buff *skb = cdev->tx_skb;
 	struct id_and_dlc fifo_header;
 	u32 cccr, fdflags;
-	u32 txfqs;
 	int err;
 	int putidx;
 
@@ -1646,10 +1654,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	} else {
 		/* Transmit routine for version >= v3.1.x */
 
-		txfqs = m_can_read(cdev, M_CAN_TXFQS);
-
 		/* Check if FIFO full */
-		if (_m_can_tx_fifo_full(txfqs)) {
+		if (cdev->tx_fifo_in_flight >= cdev->tx_fifo_submit_limit) {
 			/* This shouldn't happen */
 			netif_stop_queue(dev);
 			netdev_warn(dev,
@@ -1665,7 +1671,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		}
 
 		/* get put index for frame */
-		putidx = FIELD_GET(TXFQS_TFQPI_MASK, txfqs);
+		putidx = cdev->tx_fifo_putidx;
 
 		/* Construct DLC Field, with CAN-FD configuration.
 		 * Use the put index of the fifo as the message marker,
@@ -1699,9 +1705,12 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 
 		/* Enable TX FIFO element to start transfer  */
 		m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
+		++cdev->tx_fifo_in_flight;
+		cdev->tx_fifo_putidx = (++cdev->tx_fifo_putidx >= cdev->can.echo_skb_max ?
+					0 : cdev->tx_fifo_putidx);
 
 		/* stop network queue if fifo full */
-		if (m_can_tx_fifo_full(cdev) ||
+		if (cdev->tx_fifo_in_flight >= cdev->tx_fifo_submit_limit ||
 		    m_can_next_echo_skb_occupied(dev, putidx))
 			netif_stop_queue(dev);
 		else if (cdev->is_peripheral && !cdev->tx_skb && netif_queue_stopped(dev))
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 4c0267f9f297..7464ce56753a 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -92,6 +92,11 @@ struct m_can_classdev {
 	int pm_clock_support;
 	int is_peripheral;
 
+	// Store this internally to avoid fetch delays on peripheral chips
+	int tx_fifo_putidx;
+	int tx_fifo_in_flight;
+	int tx_fifo_submit_limit;
+
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
 };
 
-- 
2.38.1


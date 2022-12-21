Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B21965334A
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbiLUP0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234691AbiLUP0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:26:01 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C22164B9
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:53 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id m19so22437328edj.8
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l41KMmbZ167AwdM3fjtskgTgOQAD6k/gmKgP2JjeSuo=;
        b=4OB2I3tYmsRBUZNhYofMKCKmoNI6xPhNUXFV8al/t4QzEmrkbBStccpNMk7ol0te7O
         +rcqpFb1Ta0dUoXP73+whP8SeKRo0jgHLsXujiIXnvPSreMPugYWo8aLge1WxZss+M+u
         Bv7C5lu3//oWQ+rXwOZ0MSHUf4d9KoM73wUCwTzJzT+B1Hz/SJ6k19J//0dXJ32Bd5IP
         3hlFPuTWTH6iiyVnVKYGMnTo/RkTifZNNRJveyvl23q6XqDay5QtiCV6yGyb1F7JaKMR
         So9ND/Km44lWkOLdDpblVkSACkAogzIf7jaJE3i0M8aUqBzqfsUXTaV9Vp8Ukg+6mAr1
         Umcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l41KMmbZ167AwdM3fjtskgTgOQAD6k/gmKgP2JjeSuo=;
        b=mZJbmBxwUG/MyRm167GKyjnKPi5rFORq4qEa7L8v2/HgUGVv9ghPH5hLb+/eIjvdSA
         paYuQddu89owdqThETavNwJRy7T1PC0zd+sogfpnnCrwlliRDyLsJBJtJLHLTW0kJM0I
         E0I7rJ4XI0QD2+UdywjktNjQ3+c7f0DDe/Kq81vfm7BUFy4oo1LHdYYC4eVtI61pluiM
         Bc2OLtspJjONyU6bfGd1E59Az+zSEnEbIQ+sacARzfjQylK1ZqL179rmOsq+UN7S4FiL
         nY/g+wHwKXv2s59GV0GvMSunIgKyg62quP+mJ8GK9KB64BbfC5v//Mb1mJMWXpS/Yqk9
         7fGg==
X-Gm-Message-State: AFqh2kpELtfHJwoUFzIbKuPNqayWpRhCgI5P2fljCjNN3j9GpUO9D1r4
        GwFmsIDBB53BDTDQu52dJjWftw==
X-Google-Smtp-Source: AMrXdXsNI6CVAxTDlHMb6s0lavRi40Yfp8rRvWUFHoe8RYEumH8HQ7BH2o2CWsoQtIR/fsKRcJNXOQ==
X-Received: by 2002:a05:6402:7ca:b0:470:39d2:24c5 with SMTP id u10-20020a05640207ca00b0047039d224c5mr1869091edy.35.1671636352881;
        Wed, 21 Dec 2022 07:25:52 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:52 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 13/18] can: m_can: Cache tx putidx
Date:   Wed, 21 Dec 2022 16:25:32 +0100
Message-Id: <20221221152537.751564-14-msp@baylibre.com>
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

m_can_tx_handler is the only place where data is written to the tx fifo.
We can calculate the putidx in the driver code here to avoid the
dependency on the txfqs register.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 8 +++++++-
 drivers/net/can/m_can/m_can.h | 3 +++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index fc5a269f4930..5b882c2fec52 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1452,6 +1452,10 @@ static void m_can_start(struct net_device *dev)
 	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	m_can_enable_all_interrupts(cdev);
+
+	if (cdev->version > 30)
+		cdev->tx_fifo_putidx = FIELD_GET(TXFQS_TFQPI_MASK,
+						 m_can_read(cdev, M_CAN_TXFQS));
 }
 
 static int m_can_set_mode(struct net_device *dev, enum can_mode mode)
@@ -1740,7 +1744,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		}
 
 		/* get put index for frame */
-		putidx = FIELD_GET(TXFQS_TFQPI_MASK, txfqs);
+		putidx = cdev->tx_fifo_putidx;
 
 		/* Construct DLC Field, with CAN-FD configuration.
 		 * Use the put index of the fifo as the message marker,
@@ -1773,6 +1777,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 
 		/* Enable TX FIFO element to start transfer  */
 		m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
+		cdev->tx_fifo_putidx = (++cdev->tx_fifo_putidx >= cdev->can.echo_skb_max ?
+					0 : cdev->tx_fifo_putidx);
 
 		/* stop network queue if fifo full */
 		if (m_can_tx_fifo_full(cdev) ||
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 62631a613076..185289a3719c 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -102,6 +102,9 @@ struct m_can_classdev {
 	u32 tx_max_coalesced_frames_irq;
 	u32 tx_coalesce_usecs_irq;
 
+	// Store this internally to avoid fetch delays on peripheral chips
+	int tx_fifo_putidx;
+
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
 };
 
-- 
2.38.1


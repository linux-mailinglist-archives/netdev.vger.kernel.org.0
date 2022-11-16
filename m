Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A04162CB95
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbiKPUyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbiKPUxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:53:50 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCE91159
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:30 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id kt23so47159358ejc.7
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bbjKmVvFBDrESxHm1md/sljGuNuz1laUujygzg6feGk=;
        b=B/KjXbxQuT9Gao+aqZROklxkKnU1p+JXxNuxzuhCtYHY1qTn69DbzDH9lQBT/eNtGu
         4cvQiebMBzu2VeLwimrApbHF9QayhwvoyCWlOCRBn8/pI5cMT9/jVYr9FdPjS78n3BFG
         L1pif1BFc5E4V2kPh8B84h3XUMsGCRsYm5dOaNMhyLQo4J0WKRh/DlSE7T/JBJrD1n0z
         vvHzwckjHAiqraXNKoeG3vhOgwbAclMQU49UtaQb6AJAR6UYGVjv7SWDu6CwlttxVwQi
         VRcCrCalM2c6S0NuQeiqn9hJGg01DtEbjpSdHH1RqkJRZOnR6GXu/3esQC8fI16aIqDe
         Z6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bbjKmVvFBDrESxHm1md/sljGuNuz1laUujygzg6feGk=;
        b=AW4CBmDFCOaC9keHCh0v3ew/SLLemZzNJpqy1G83mN6j2gmKHLFTx+IsLFCqtUeOqN
         SOOUykalHstl8d0SENk5GYcPsg+31/GK45bMr+PKkQDe81PMV59kHNBDmIgagvpiBd9Q
         ifbvjISUWB7VlMLUYSA6VEP3TyPuBpnQJiNZUg8McRPENx+KBHxHzZX4uln9j0xWiUv/
         cMxSlfiQXBEBSypNj34iE81aMotxuhiIwuS+2cug074Vj2lc0B2xnWQHntQ9S9+LG3NB
         BdvDuoJGdLRHsXsHE4CCQt1/A/Ivhl2mfFjymm2i2T4L8S5HiYs/LAdrb1mJLlC2qtgH
         9pIQ==
X-Gm-Message-State: ANoB5pmrp7mz9VLj3c7pnFf3bfIcb+qv6LKaOdJyazzMixsvhhfNYAgF
        ETeRL7r/yaD+OCtt+XA5xAsTvOvqvlqHfw==
X-Google-Smtp-Source: AA0mqf5Nm+7E+pI2+mVyMKOZ+hhoiLffdy2qs4ZnZpOiqCStipKLy7DN1WH8OXWV5oL0hqD/qSZTuA==
X-Received: by 2002:a17:906:141b:b0:78d:5176:c4d2 with SMTP id p27-20020a170906141b00b0078d5176c4d2mr18738240ejc.532.1668632008850;
        Wed, 16 Nov 2022 12:53:28 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:28 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 06/15] can: m_can: Avoid reading irqstatus twice
Date:   Wed, 16 Nov 2022 21:52:59 +0100
Message-Id: <20221116205308.2996556-7-msp@baylibre.com>
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

For peripheral devices the m_can_rx_handler is called directly after
setting cdev->irqstatus. This means we don't have to read the irqstatus
again in m_can_rx_handler. Avoid this by adding a parameter that is
false for direct calls.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 5c00c6162058..0efa6dee0617 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -896,14 +896,13 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 	return work_done;
 }
 
-static int m_can_rx_handler(struct net_device *dev, int quota)
+static int m_can_rx_handler(struct net_device *dev, int quota, u32 irqstatus)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int rx_work_or_err;
 	int work_done = 0;
-	u32 irqstatus, psr;
+	u32 psr;
 
-	irqstatus = cdev->irqstatus | m_can_read(cdev, M_CAN_IR);
 	if (!irqstatus)
 		goto end;
 
@@ -947,12 +946,12 @@ static int m_can_rx_handler(struct net_device *dev, int quota)
 	return work_done;
 }
 
-static int m_can_rx_peripheral(struct net_device *dev)
+static int m_can_rx_peripheral(struct net_device *dev, u32 irqstatus)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done;
 
-	work_done = m_can_rx_handler(dev, NAPI_POLL_WEIGHT);
+	work_done = m_can_rx_handler(dev, NAPI_POLL_WEIGHT, irqstatus);
 
 	/* Don't re-enable interrupts if the driver had a fatal error
 	 * (e.g., FIFO read failure).
@@ -968,8 +967,11 @@ static int m_can_poll(struct napi_struct *napi, int quota)
 	struct net_device *dev = napi->dev;
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done;
+	u32 irqstatus;
+
+	irqstatus = cdev->irqstatus | m_can_read(cdev, M_CAN_IR);
 
-	work_done = m_can_rx_handler(dev, quota);
+	work_done = m_can_rx_handler(dev, quota, irqstatus);
 
 	/* Don't re-enable interrupts if the driver had a fatal error
 	 * (e.g., FIFO read failure).
@@ -1080,7 +1082,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 		m_can_disable_all_interrupts(cdev);
 		if (!cdev->is_peripheral)
 			napi_schedule(&cdev->napi);
-		else if (m_can_rx_peripheral(dev) < 0)
+		else if (m_can_rx_peripheral(dev, ir) < 0)
 			goto out_fail;
 	}
 
-- 
2.38.1


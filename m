Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE6762CBAB
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239023AbiKPUyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238463AbiKPUx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:53:57 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EE96555
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:34 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id f27so13906eje.1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=63B61nbFxXevaqifM6unbv7DVTV+dONfI4xcJ7fYbEM=;
        b=XrxRLv0ioHvztchOOEylzwIXG5E6/NOIFrU0lDh3B+0C0zkoUMrAFpJRw5jxDREGEQ
         p6GpjhDPZ5pODwZZUQtgNoFhFAbLTCrl+H6achFwFFRrd/Zy5aTWNvi3Gr5fB7kk2UtA
         AVAQLiexAir2XBwRfZHloDmCAlDgzVrEK8mSWP+Mox+pGSLt2NJnziGicFxo06eyvGwi
         +nvJE09r0HP94yDjezRuisu3bCGIabGRbmxdPasO5vG2NO4bfHB6Qo/YcTBQIx+PEVJR
         SS3NhGa6W/yb9shUV8lZ13ZLOL8QC4CeWXtYPE1BrDK4+jsh/TVT7EjGFDmbzbuwrwFD
         V7yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=63B61nbFxXevaqifM6unbv7DVTV+dONfI4xcJ7fYbEM=;
        b=ZuzZsQiA/vWppMlv9EeDkGGUdt1cZKnv4VGy+O84+m2uOgnIw+QxpPS1hPOWMQ88dk
         UCDtULY5/XgRRiv0/XLIVIGXsWCpO0/YzyMYWSA2An8ePgs2Mo01NSKfdQjirazr8xKN
         FqUheM7EhbFq0HNwRVcMGWgptWDwSLfdvGNkXQzPE+r0lzUUXYWhMf1cREiVoOD+HvSw
         SAYtSPGdrVI2Rpug+St7lEAv7fkHLrnzVqHu05WzROSPjKfzJZU62Jx0HlZ+eCptOTsK
         TDwGJZ7+d3gGJBKl2Kf0vZHcBGGeDpSW1YoEjdqwoyMXpq3XZjwu2Z/a4eg3wJSIiWgV
         0rQA==
X-Gm-Message-State: ANoB5pmHY5txPZgVjrUTjldBulR0sxJX8R192pXam2YSZAg1Hk9IUM+G
        5Bs+ibCO0u95bbhMlI7WG3W/+w==
X-Google-Smtp-Source: AA0mqf4VmKP/3sic4raGQLJBlVHPCDU/nX49+PnUbUwkmjRxB1AaE46QV5EDtvVgcKQkbAoKaefZsQ==
X-Received: by 2002:a17:907:2b26:b0:7ae:c460:c65f with SMTP id gc38-20020a1709072b2600b007aec460c65fmr18733831ejc.226.1668632012845;
        Wed, 16 Nov 2022 12:53:32 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:32 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 11/15] can: m_can: Batch acknowledge transmit events
Date:   Wed, 16 Nov 2022 21:53:04 +0100
Message-Id: <20221116205308.2996556-12-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116205308.2996556-1-msp@baylibre.com>
References: <20221116205308.2996556-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Transmit events from the txe fifo can be batch acknowledged by
acknowledging the last read txe fifo item. This will save txe_count
writes which is important for peripheral chips.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 6179b9e815ed..347ba8e7d1b3 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1019,7 +1019,9 @@ static int m_can_echo_tx_event(struct net_device *dev)
 	u32 txe_count = 0;
 	u32 m_can_txefs;
 	u32 fgi = 0;
+	int ack_fgi = -1;
 	int i = 0;
+	int err = 0;
 	unsigned int msg_mark;
 
 	struct m_can_classdev *cdev = netdev_priv(dev);
@@ -1034,21 +1036,18 @@ static int m_can_echo_tx_event(struct net_device *dev)
 	/* Get and process all sent elements */
 	for (i = 0; i < txe_count; i++) {
 		u32 txe, timestamp = 0;
-		int err;
 
 		/* get message marker, timestamp */
 		err = m_can_txe_fifo_read(cdev, fgi, 4, &txe);
 		if (err) {
 			netdev_err(dev, "TXE FIFO read returned %d\n", err);
-			return err;
+			break;
 		}
 
 		msg_mark = FIELD_GET(TX_EVENT_MM_MASK, txe);
 		timestamp = FIELD_GET(TX_EVENT_TXTS_MASK, txe) << 16;
 
-		/* ack txe element */
-		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
-							  fgi));
+		ack_fgi = fgi;
 		fgi = (++fgi >= cdev->mcfg[MRAM_TXE].num ? 0 : fgi);
 		--cdev->tx_fifo_in_flight;
 
@@ -1056,7 +1055,11 @@ static int m_can_echo_tx_event(struct net_device *dev)
 		m_can_tx_update_stats(cdev, msg_mark, timestamp);
 	}
 
-	return 0;
+	if (ack_fgi != -1)
+		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
+							  ack_fgi));
+
+	return err;
 }
 
 static irqreturn_t m_can_isr(int irq, void *dev_id)
-- 
2.38.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68A762CB8E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbiKPUyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbiKPUxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:53:47 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BA5F2C
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:28 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id n21so6409953ejb.9
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAaUVMJZwNldvM6e6aFGn3ObvVWSf2L0v/SEyFHK/I4=;
        b=ltqQnT0EMFXwbpNbg9tdXI3avhCvHSr0oRUgU1tqw7+Unw0j+hl2GIavNu3ounoJDP
         nvNUC7Rd2dmnkcoByRgHQMhN2Jt4l1/KXgNv0sSJb+TiuAeuqfAnAJz5atJAXnGg99H8
         UpdwG2F5AtucQXp6D8/Scz6aeCIdU8MXHn8EVGBz5ESYLLQRzTAbbP/gp6ksMxMJbCts
         Gs6tbhKZub13E96iZdU3qWuiP2WpqlcvYHSxlnDAJkidA4ULgmmj2hDHWbdq79H5FxsM
         g7iR8wYul79Lf08h1AekXk82Zcmmsk6LgHF6aSPOCqsOPbaSii3ag97VLOF4Qql2/YYp
         uN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WAaUVMJZwNldvM6e6aFGn3ObvVWSf2L0v/SEyFHK/I4=;
        b=hbLmYanupAkQ5pcfLyBn6Q4BvSK//Xxw81hdMfEzzBT+e+mq617e548nEGJDreELp0
         QXf7kfVOHZ65pPRdBFQLKTeKvHEdhB6uB3lHIxeMm65bdpKEJT8QCv+nqlUngUIaW+3A
         DQpHxM6Xqbf7lk6mURBl5TWTerj6dE8jyrd5q+FFJS/HJCvJBZopVWQa+G8GQ8bb/wCP
         4+v8y6pyi+5ErZmxh4C6z0XHEW2qcKRkoKQH3AhpNpH+P50lsINb7GAtz7QkrbaBUZwt
         Ux4P4ZMZppCb71wR9hCCj/y4AVYQrkCd5luaOmw7anC/NmXNsHzo8Myud/gBz6+217qL
         yIIg==
X-Gm-Message-State: ANoB5pkZrSKMEtLLIKHtEaAmGytLBN41mnHvvVxzKc9iM6PwFAmGeDJe
        sWQu4vtXyojxX0O+8rGZgOsv2A==
X-Google-Smtp-Source: AA0mqf7xLFzXunaORvAE8arlr2EHMF5IL/TxTAZ+Eb4AFkrbZOZnz+40iVztVdNYmE1kGgvIA1QyhQ==
X-Received: by 2002:a17:906:33da:b0:78d:b046:aaae with SMTP id w26-20020a17090633da00b0078db046aaaemr18417533eja.218.1668632007251;
        Wed, 16 Nov 2022 12:53:27 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:26 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 04/15] can: m_can: Use transmit event FIFO watermark level interrupt
Date:   Wed, 16 Nov 2022 21:52:57 +0100
Message-Id: <20221116205308.2996556-5-msp@baylibre.com>
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

Currently the only mode of operation is an interrupt for every transmit
event. This is inefficient for peripheral chips. Use the transmit FIFO
event watermark interrupt instead if the FIFO size is more than 2. Use
FIFOsize - 1 for the watermark so the interrupt is triggered early
enough to not stop transmitting.

Note that if the number of transmits is less than the watermark level,
the transmit events will not be processed until there is any other
interrupt. This will only affect statistic counters. Also there is an
interrupt every time the timestamp wraps around.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index f5bba848bd56..4a6972c8bacd 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -254,6 +254,7 @@ enum m_can_reg {
 #define TXESC_TBDS_64B		0x7
 
 /* Tx Event FIFO Configuration (TXEFC) */
+#define TXEFC_EFWM_MASK		GENMASK(29, 24)
 #define TXEFC_EFS_MASK		GENMASK(21, 16)
 
 /* Tx Event FIFO Status (TXEFS) */
@@ -1094,8 +1095,8 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			netif_wake_queue(dev);
 		}
 	} else  {
-		if (ir & IR_TEFN) {
-			/* New TX FIFO Element arrived */
+		if (ir & (IR_TEFN | IR_TEFW)) {
+			/* New TX FIFO Element arrived or watermark reached */
 			if (m_can_echo_tx_event(dev) != 0)
 				goto out_fail;
 			if (!cdev->tx_skb && netif_queue_stopped(dev))
@@ -1242,6 +1243,7 @@ static void m_can_chip_config(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	u32 cccr, test;
+	u32 interrupts = IR_ALL_INT;
 
 	m_can_config_endisable(cdev, true);
 
@@ -1276,11 +1278,20 @@ static void m_can_chip_config(struct net_device *dev)
 			    FIELD_PREP(TXEFC_EFS_MASK, 1) |
 			    cdev->mcfg[MRAM_TXE].off);
 	} else {
+		u32 txe_watermark;
+
+		txe_watermark = cdev->mcfg[MRAM_TXE].num - 1;
 		/* Full TX Event FIFO is used */
 		m_can_write(cdev, M_CAN_TXEFC,
+			    FIELD_PREP(TXEFC_EFWM_MASK,
+				       txe_watermark) |
 			    FIELD_PREP(TXEFC_EFS_MASK,
 				       cdev->mcfg[MRAM_TXE].num) |
 			    cdev->mcfg[MRAM_TXE].off);
+
+		/* Watermark interrupt mode */
+		if (txe_watermark)
+			interrupts &= ~IR_TEFN;
 	}
 
 	/* rx fifo configuration, blocking mode, fifo size 1 */
@@ -1338,15 +1349,13 @@ static void m_can_chip_config(struct net_device *dev)
 
 	/* Enable interrupts */
 	m_can_write(cdev, M_CAN_IR, IR_ALL_INT);
-	if (!(cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING))
+	if (!(cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)) {
 		if (cdev->version == 30)
-			m_can_write(cdev, M_CAN_IE, IR_ALL_INT &
-				    ~(IR_ERR_LEC_30X));
+			interrupts &= ~(IR_ERR_LEC_30X);
 		else
-			m_can_write(cdev, M_CAN_IE, IR_ALL_INT &
-				    ~(IR_ERR_LEC_31X));
-	else
-		m_can_write(cdev, M_CAN_IE, IR_ALL_INT);
+			interrupts &= ~(IR_ERR_LEC_31X);
+	}
+	m_can_write(cdev, M_CAN_IE, interrupts);
 
 	/* route all interrupts to INT0 */
 	m_can_write(cdev, M_CAN_ILS, ILS_ALL_INT0);
-- 
2.38.1


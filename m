Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FAF62CB92
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiKPUyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234463AbiKPUxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:53:48 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DEDDC8
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:25 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id n12so47099205eja.11
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rJ/wCekKfh+/zbab0KIF63OXyhft6t7a9cE754TRYE=;
        b=P2To7HYyeZgnQrgVSiKYZjY/MFYOIWjd/XCA+rlJONO4UE9NbuRNNXqh4OoyMZDMFD
         8Jf5jjQg1yf4Vyr1mTAAW8m6RnMK0YsErEsVDcNgxGXty8Ezc6tEkn/cflJkqTKCAMtP
         GZ7exwXlAMjj1At6Tc/0RmiIDNSF1RMyZg3yIdEIJLGYXi1ucQ7ODKnL+s0di9XHxfaQ
         slvIwH/ocjac5SAAfER5A1IWBuhmNTJ+e/WhRYA/VeSeEWyGUUyumYgQbgc6gQMyylXG
         TOVZtkibuNn46tWev4OobR6gdDQVrGUxaw0tXDwxjwLTmKrHDf5404mUyxGyYeqnyRSa
         HUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2rJ/wCekKfh+/zbab0KIF63OXyhft6t7a9cE754TRYE=;
        b=IDfMZeqqRPiiEwUZFKfXeLZrZE0zq6jBitY732LEoNQhFOIt/Es0tpuZJSoeVm+9r4
         OKNOQ4qQ5civoeghQYu3iBOQpcrLzZ5GHvJRAd9Wm9N8if4t3/HbZ2g+fnHkN2CUb2fL
         5ziaQYB5kyed9LZsVBLyQQ6+M5J57Qh87b7lT6IyS7aV/6gbgvQe6t1RCUiqa8gn46Yb
         +J+dpOm9hiNMXOI6ia3f5yHyqTavIDDCfmemdFUBE8ZQP1Lhw0OTHg3/gmkhuSNaNQVU
         aC1bNLqasGyvNAiQOd0uG+RUW1TeLtbMjn9JEpwqDncH5D/NEX+osbJm4K2Dvh+3rRmu
         bvoQ==
X-Gm-Message-State: ANoB5pkY6+BoMIAbI1kliL20kdQqJxU8L15emSFSgXwvM3EAoYkBkywv
        TBiBtr8LEoRjXETJUNa7rebqlUmGX2P+cg==
X-Google-Smtp-Source: AA0mqf7gkUlgqdFMbhRGiQ4SNQC97BkRRTReNc1yfIImtknfhy+YxiIiJqYtvcTWGm8CTPGs3KmFqA==
X-Received: by 2002:a17:906:1248:b0:7ad:f9da:8986 with SMTP id u8-20020a170906124800b007adf9da8986mr19202437eja.54.1668632004349;
        Wed, 16 Nov 2022 12:53:24 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:23 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 01/15] can: m_can: Eliminate double read of TXFQS in tx_handler
Date:   Wed, 16 Nov 2022 21:52:54 +0100
Message-Id: <20221116205308.2996556-2-msp@baylibre.com>
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

The TXFQS register is read first to check if the fifo is full and then
immediately again to get the putidx. This is unnecessary and adds
significant overhead if read requests are done over a slow bus, for
example SPI with tcan4x5x.

Add a variable to store the value of the register. Split the
m_can_tx_fifo_full function into two to avoid the hidden m_can_read call
if not needed.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 00d11e95fd98..2c01e3f7b23f 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -368,9 +368,14 @@ m_can_txe_fifo_read(struct m_can_classdev *cdev, u32 fgi, u32 offset, u32 *val)
 	return cdev->ops->read_fifo(cdev, addr_offset, val, 1);
 }
 
+static inline bool _m_can_tx_fifo_full(u32 txfqs)
+{
+	return !!(txfqs & TXFQS_TFQF);
+}
+
 static inline bool m_can_tx_fifo_full(struct m_can_classdev *cdev)
 {
-	return !!(m_can_read(cdev, M_CAN_TXFQS) & TXFQS_TFQF);
+	return _m_can_tx_fifo_full(m_can_read(cdev, M_CAN_TXFQS));
 }
 
 static void m_can_config_endisable(struct m_can_classdev *cdev, bool enable)
@@ -1585,6 +1590,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	struct sk_buff *skb = cdev->tx_skb;
 	struct id_and_dlc fifo_header;
 	u32 cccr, fdflags;
+	u32 txfqs;
 	int err;
 	int putidx;
 
@@ -1641,8 +1647,10 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	} else {
 		/* Transmit routine for version >= v3.1.x */
 
+		txfqs = m_can_read(cdev, M_CAN_TXFQS);
+
 		/* Check if FIFO full */
-		if (m_can_tx_fifo_full(cdev)) {
+		if (_m_can_tx_fifo_full(txfqs)) {
 			/* This shouldn't happen */
 			netif_stop_queue(dev);
 			netdev_warn(dev,
@@ -1658,8 +1666,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		}
 
 		/* get put index for frame */
-		putidx = FIELD_GET(TXFQS_TFQPI_MASK,
-				   m_can_read(cdev, M_CAN_TXFQS));
+		putidx = FIELD_GET(TXFQS_TFQPI_MASK, txfqs);
 
 		/* Construct DLC Field, with CAN-FD configuration.
 		 * Use the put index of the fifo as the message marker,
-- 
2.38.1


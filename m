Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DED362CBA7
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbiKPUyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238109AbiKPUxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:53:55 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52AB63E1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:32 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id m22so47109634eji.10
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=76EqNlpDreQF4PZmggfgrCfKC4hAP4lphiWDRZe7nMM=;
        b=uqThAUy/RKwtT1RRbAu8P5FOVTNwBorxorshelO+Gn57d4TcNitGks2jHG8VjQaJT5
         TEavYIJSpNPGFpNDMMxKMRiDVcrerBSpI03qY1cHLpu4Pp4zoLW6+xH9aWJwIFdnkCAX
         0ETvxF2Apny/2uqVTtLgkjN2UIHwXAqRhbGiOYQJD4Eb3rAUT61h0518k/ei4UTZiryA
         i2YbNLFvgObJVuHDg/QVg4DSJn1XczUQoYspgCNo6+FTr1x0glc82I6g7nZo6e/KVk/A
         1qoiG9heuHqcuR4buQqWP6K0bkU2ZNU7Tn+yhL1XqlnQWFTTdgdp0FlqnVi6oiegV22Y
         tuJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=76EqNlpDreQF4PZmggfgrCfKC4hAP4lphiWDRZe7nMM=;
        b=cJ4QDQHk4GVgLm9rKJuj4GJ7hGtzx/+i5ok2RB4KQLC7EPtXwouhZQ0Cz5/GxAdztj
         7dnYbPW8QYK1ZnUJCDaR750iMrKokPGQ/6qtFUig7B2jxAm237atnv+NCDiiGp/x+xct
         Tnr4zO/wmGKw4xmZgdKm4Da984kHF93NpeBe6e6d9tmjhGGEL3tykh6AuokFvtzs0ykK
         bgJXzfhJu1Zj7ZcrSuWKgUqFfDEsW1MxHfJgatkMEggPECCxKdTS3qsxnndNbDIo+Dg/
         sssu959TqgFFbtlrPjhZ6f8gjgymDRjkWpatgjnehOBkvwlb/IVamyHrzWlvVwQQkdwc
         gJRg==
X-Gm-Message-State: ANoB5pk1DbLYgSyjHEN19V4115hrAkr8CivHroZ2bWz0+KpgL7YUkQwJ
        QcIkJWuwfHPxkAVDnQPtrGQREw==
X-Google-Smtp-Source: AA0mqf7MN/Xm4agt2Z305vGmVl+Fecn281QR6SF6xs4XZMbAZV+jPObReGYvCRgliq0mgWfkvUrvPQ==
X-Received: by 2002:a17:906:2696:b0:7ae:4ed2:84f4 with SMTP id t22-20020a170906269600b007ae4ed284f4mr18752930ejc.429.1668632011225;
        Wed, 16 Nov 2022 12:53:31 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:30 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 09/15] can: m_can: Count read getindex in the driver
Date:   Wed, 16 Nov 2022 21:53:02 +0100
Message-Id: <20221116205308.2996556-10-msp@baylibre.com>
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

The getindex gets increased by one every time. We can calculate the
correct getindex in the driver and avoid the additional reads of rxfs.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 27095a7254dd..02fd7fe4e9f8 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -477,19 +477,16 @@ static void m_can_receive_skb(struct m_can_classdev *cdev,
 	}
 }
 
-static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
+static int m_can_read_fifo(struct net_device *dev, u32 fgi)
 {
 	struct net_device_stats *stats = &dev->stats;
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	struct canfd_frame *cf;
 	struct sk_buff *skb;
 	struct id_and_dlc fifo_header;
-	u32 fgi;
 	u32 timestamp = 0;
 	int err;
 
-	/* calculate the fifo get index for where to read data */
-	fgi = FIELD_GET(RXFS_FGI_MASK, rxfs);
 	err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_ID, &fifo_header, 2);
 	if (err)
 		goto out_fail;
@@ -554,6 +551,9 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	u32 pkts = 0;
 	u32 rxfs;
+	u32 rx_count;
+	u32 fgi;
+	int i;
 	int err;
 
 	rxfs = m_can_read(cdev, M_CAN_RXF0S);
@@ -562,14 +562,17 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 		return 0;
 	}
 
-	while ((rxfs & RXFS_FFL_MASK) && (quota > 0)) {
-		err = m_can_read_fifo(dev, rxfs);
+	rx_count = FIELD_GET(RXFS_FFL_MASK, rxfs);
+	fgi = FIELD_GET(RXFS_FGI_MASK, rxfs);
+
+	for (i = 0; i < rx_count && quota > 0; ++i) {
+		err = m_can_read_fifo(dev, fgi);
 		if (err)
 			return err;
 
 		quota--;
 		pkts++;
-		rxfs = m_can_read(cdev, M_CAN_RXF0S);
+		fgi = (++fgi >= cdev->mcfg[MRAM_RXF0].num ? 0 : fgi);
 	}
 
 	return pkts;
-- 
2.38.1


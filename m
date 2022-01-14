Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B53048F32E
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 00:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiANXs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 18:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiANXsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 18:48:55 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F08C061574;
        Fri, 14 Jan 2022 15:48:55 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id d18-20020a05600c251200b0034974323cfaso9884358wma.4;
        Fri, 14 Jan 2022 15:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q1vawQ0DtsMy/giBeIttsSJVFFvGpTMkVdU2i1xq8oM=;
        b=FqcYiryfiaD/4yTSgUtZjZ0/2/oPwHS9TO7gI20z9wvkwy6EuykQqTatHvOCG9ABbb
         2cxYvUgYAhg9fc0q56nQAFC2MKlV8l4XqoWh2cLq/+oZUkSGPxe8W8orWKCKSbGbW/Lm
         0VQFEL4hKLUz8aKS3FNAqf4oqTwevj0DhFJFdMocQ6eMX7QECnync6zAbFKB9eWa6RgS
         Dqy3k8K/VAEUfxe2PwiHTP5CDhV1Ef2lcancJaB9wM60wMgRIGza9OM+nhnQbZv5rFE0
         UZg87uvM4r+kFW6+tcE6XIoypo8hill3ShEQ1P6R6Nw2Xlr8gZf0JGYEufaJH6YNVV/g
         Hwig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q1vawQ0DtsMy/giBeIttsSJVFFvGpTMkVdU2i1xq8oM=;
        b=ljewJepNnsTlbG9kSwjo/poDUr/0cPWLOCwhodM1+5/H+YnEi3MDVZfIWSSkLBFmvQ
         sVssaGeY/aPxo8KCBJ5nnZsVG8ExyKTmKzHP+2FRmBzQSwI+m0yPqM/MyKuBViol0419
         HmRru4G01Rs3qUFRJIrzpROys7EH5uimQFVTjRUR+/nROyGrxtnYOx8QDilJ3Of5f3aH
         wAv/GoFdzHRZ8PJrRg6wvCK8URCMmv2juYY+EkiVNj0cokhtekDksEhwbSoPVI5Hu9Ia
         kRMF0tKDMzlX/JRYSeZCHxIzNh9z5gVeT7meFTsz2K1qbE1wSbCauzramkc8sxf9nDrD
         8dJg==
X-Gm-Message-State: AOAM530K/Dh+9kWuIVUGcYK4V6+eSjfihaUAAdeOqIq/FdBEMcjceWS8
        buOZbxOe+87kAJD5n/YMj1chfqOo1Kc=
X-Google-Smtp-Source: ABdhPJyhRxTCK3V867hG941Q2EW2kxf/2uXkZLqFrRjKMHdc/mDEFXuWpL5V96H4zqB2L7mkdUURNQ==
X-Received: by 2002:a05:600c:1d9a:: with SMTP id p26mr17854109wms.38.1642204133778;
        Fri, 14 Jan 2022 15:48:53 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7684-7400-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7684:7400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id i3sm5788533wmq.21.2022.01.14.15.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:48:53 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/4] rtw88: pci: Change queue datatype from u8 to enum rtw_tx_queue_type
Date:   Sat, 15 Jan 2022 00:48:23 +0100
Message-Id: <20220114234825.110502-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
References: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes it easier to understand which values are allowed for the
"queue" variable.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 13f1f50b2867..2da057d18188 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -30,7 +30,8 @@ static u32 rtw_pci_tx_queue_idx_addr[] = {
 	[RTW_TX_QUEUE_H2C]	= RTK_PCI_TXBD_IDX_H2CQ,
 };
 
-static u8 rtw_pci_get_tx_qsel(struct sk_buff *skb, u8 queue)
+static u8 rtw_pci_get_tx_qsel(struct sk_buff *skb,
+			      enum rtw_tx_queue_type queue)
 {
 	switch (queue) {
 	case RTW_TX_QUEUE_BCN:
@@ -542,7 +543,7 @@ static int rtw_pci_setup(struct rtw_dev *rtwdev)
 static void rtw_pci_dma_release(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci)
 {
 	struct rtw_pci_tx_ring *tx_ring;
-	u8 queue;
+	enum rtw_tx_queue_type queue;
 
 	rtw_pci_reset_trx_ring(rtwdev);
 	for (queue = 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++) {
@@ -608,8 +609,8 @@ static void rtw_pci_deep_ps_enter(struct rtw_dev *rtwdev)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct rtw_pci_tx_ring *tx_ring;
+	enum rtw_tx_queue_type queue;
 	bool tx_empty = true;
-	u8 queue;
 
 	if (rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_TX_WAKE))
 		goto enter_deep_ps;
@@ -800,7 +801,8 @@ static void rtw_pci_flush_queues(struct rtw_dev *rtwdev, u32 queues, bool drop)
 	__rtw_pci_flush_queues(rtwdev, pci_queues, drop);
 }
 
-static void rtw_pci_tx_kick_off_queue(struct rtw_dev *rtwdev, u8 queue)
+static void rtw_pci_tx_kick_off_queue(struct rtw_dev *rtwdev,
+				      enum rtw_tx_queue_type queue)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct rtw_pci_tx_ring *ring;
@@ -819,7 +821,7 @@ static void rtw_pci_tx_kick_off_queue(struct rtw_dev *rtwdev, u8 queue)
 static void rtw_pci_tx_kick_off(struct rtw_dev *rtwdev)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
-	u8 queue;
+	enum rtw_tx_queue_type queue;
 
 	for (queue = 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++)
 		if (test_and_clear_bit(queue, rtwpci->tx_queued))
@@ -828,7 +830,8 @@ static void rtw_pci_tx_kick_off(struct rtw_dev *rtwdev)
 
 static int rtw_pci_tx_write_data(struct rtw_dev *rtwdev,
 				 struct rtw_tx_pkt_info *pkt_info,
-				 struct sk_buff *skb, u8 queue)
+				 struct sk_buff *skb,
+				 enum rtw_tx_queue_type queue)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct rtw_chip_info *chip = rtwdev->chip;
@@ -946,9 +949,9 @@ static int rtw_pci_tx_write(struct rtw_dev *rtwdev,
 			    struct rtw_tx_pkt_info *pkt_info,
 			    struct sk_buff *skb)
 {
+	enum rtw_tx_queue_type queue = rtw_hw_queue_mapping(skb);
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct rtw_pci_tx_ring *ring;
-	u8 queue = rtw_hw_queue_mapping(skb);
 	int ret;
 
 	ret = rtw_pci_tx_write_data(rtwdev, pkt_info, skb, queue);
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768D26570FD
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiL0Xam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiL0Xaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:30:39 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF060B1D;
        Tue, 27 Dec 2022 15:30:38 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id m21so20871091edc.3;
        Tue, 27 Dec 2022 15:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QgYIIlUvjlkzoxTeBuZUOBlSUY/sYjLMbmvA+ggqjk4=;
        b=f8Q1fmpjOhzEzXHLPY1LdK57FaUha8exOzkLcZooLGGFKyh2mqirDEHC+lPYFj8jyo
         SKnx/gUtLtgjouRtJ+hoK5JiIrDhns3umKoqi9vMl46y9NHIPWMWTcxTmC0IAq6Xxe9+
         AEZOtIsYqUPhA4+t1KuArfIY5wpJyjAqzd90dXmJAzmSfsbwYhcOGtMBs9ro+hgxYT8n
         QTkSawKFC8jApbFf50mY5WTKBGwhnmk5wweKAEJhL67FxeS/igD3pz0SQnxpR7BW2Xql
         EWVXA6jCutyT2rRrXCnw/foPbG5r2Y4gGw4eEGpkcPLBumD5JU+M+lpzuRQTDqpXIRR9
         ngIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QgYIIlUvjlkzoxTeBuZUOBlSUY/sYjLMbmvA+ggqjk4=;
        b=z+81AYuSuJ7vmZn71AEZ0wD03rwVlSmGI/Ip+1g+QjtrWxmC5Wm6ARONowlxgttll3
         vT/Msad7/FO6QChqRrT+ys8Ut4EObVjGmt7qc9pXZrvqbD6LREhGZDxcHiR1KDC3jv26
         ZcPd5J3htqLqGHsAVpf9A58KSeei+4nhw8glWNxnRcU0e/Br8Xx2pti1malSVqDbHbXm
         OD+YUwoVLFxLraedRepp9o/GHL/Ik1od6cs2c+wlloetGC6ywXIH9PuncOUk+l147aVO
         wk4s356CVEQX3c3Qizp6aIc3XEi2vSNYFeYIlQ7IsEvoGJMHJUd5Yo5gKQWftlOjRN9h
         u3KA==
X-Gm-Message-State: AFqh2krWqyUE1w/J7eUaY4dFUBAHCdD35rY/dm3eJ/23SGdhUpFDKGnP
        xIO3r5XcIav26avEuk43FdE1TN4Ed7k=
X-Google-Smtp-Source: AMrXdXtYznvIwhA5xcrLA4jT1xTMSU2g3QGo4kymjSxBSJ4mdDphNO4Ov1B2Tad9ek0tC3WBKJRpCA==
X-Received: by 2002:a05:6402:550e:b0:45c:835b:ac64 with SMTP id fi14-20020a056402550e00b0045c835bac64mr19668822edb.31.1672183838243;
        Tue, 27 Dec 2022 15:30:38 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:37 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC PATCH v1 03/19] rtw88: pci: Change queue datatype from u8 to enum rtw_tx_queue_type
Date:   Wed, 28 Dec 2022 00:30:04 +0100
Message-Id: <20221227233020.284266-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 45ce7e624c03..5492107fc85b 100644
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
@@ -803,7 +804,8 @@ static void rtw_pci_flush_queues(struct rtw_dev *rtwdev, u32 queues, bool drop)
 	__rtw_pci_flush_queues(rtwdev, pci_queues, drop);
 }
 
-static void rtw_pci_tx_kick_off_queue(struct rtw_dev *rtwdev, u8 queue)
+static void rtw_pci_tx_kick_off_queue(struct rtw_dev *rtwdev,
+				      enum rtw_tx_queue_type queue)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct rtw_pci_tx_ring *ring;
@@ -822,7 +824,7 @@ static void rtw_pci_tx_kick_off_queue(struct rtw_dev *rtwdev, u8 queue)
 static void rtw_pci_tx_kick_off(struct rtw_dev *rtwdev)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
-	u8 queue;
+	enum rtw_tx_queue_type queue;
 
 	for (queue = 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++)
 		if (test_and_clear_bit(queue, rtwpci->tx_queued))
@@ -831,7 +833,8 @@ static void rtw_pci_tx_kick_off(struct rtw_dev *rtwdev)
 
 static int rtw_pci_tx_write_data(struct rtw_dev *rtwdev,
 				 struct rtw_tx_pkt_info *pkt_info,
-				 struct sk_buff *skb, u8 queue)
+				 struct sk_buff *skb,
+				 enum rtw_tx_queue_type queue)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	const struct rtw_chip_info *chip = rtwdev->chip;
@@ -949,9 +952,9 @@ static int rtw_pci_tx_write(struct rtw_dev *rtwdev,
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
2.39.0


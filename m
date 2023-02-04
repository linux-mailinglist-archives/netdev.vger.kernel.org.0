Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F8E68AD78
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 00:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjBDXad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 18:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbjBDXaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 18:30:30 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ACD22DF8;
        Sat,  4 Feb 2023 15:30:28 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id q19so8426130edd.2;
        Sat, 04 Feb 2023 15:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6UgdhmqWocOBQz+eQ8ew5GqkBUQxNNwSV7ocstJJqs=;
        b=QQBddVqS2/y8BHJEpL0Gok9noxj5m3QC3aAsMRYvcruT3kqu6I7QgdsEb5eXypojuy
         ZT6cyhabERR3oMuv7M6SdHEzV+TIDlTElsLir4OtTd+ab+QCFxHV1tFlkJeusC6w3Fkv
         RitfAXmTN43OzfoHVaS7MC64eISy8OtyHy/+5dm2VjzUoteCMOJDSZZ9IF/B7Zy7AtDL
         6g933RxqErpj9Z1pW7SmBegfkMLSbddY97GZWlxtzIA/cM3GrZUN89rhPdNR1qmLljua
         AzxxEPc4wG/kLgC5BlzBrV3hNTfEZ4efJLDMx9ZknTkFjiLZvxIeu4osLQNZ25Ys4LbN
         tA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6UgdhmqWocOBQz+eQ8ew5GqkBUQxNNwSV7ocstJJqs=;
        b=IDzLrAS9XGj3l6rlUmIv11oyBzmqYvYzgXo4arvjw8Z35AuA7ZqU6Np9LnyhlXkCYb
         MGHqQ5hQjyDVdg2ggWl5rCfkk7CqF40y+BwULXWfwiVeSC3H7K4X3p9yMf0c/z2xESxb
         BDyQixgSdcByVgwQ6wSLSnHcUvRTFgmS6EaG7SgHDDr164r0oDNaHStvLdnhtQpf0mcp
         GydMjTJeeuFUMLVpALAMoXndG7tHqY2416PSnDwDz5b9n2ZypFzcxkgsQgmD+8BtlsUE
         hi2zjXQGUhgGfppIebcAq1IemZmRJe27qz8BEcnJGqopkYizfDnw7Zwy/evIpTDA+yIP
         1+Nw==
X-Gm-Message-State: AO0yUKUKj9vVyMtQIv45VobRcKEsHgy9ghIcaz8Gcw2g8WbKplu6Vfeu
        WP1HFbU4IJbvzj8L1f9Mzj0l0pri6hE=
X-Google-Smtp-Source: AK7set/xbtNPaYyRyrRexiTwkymptbgSjSZV1sYj7RCcoc7XJ42wiUlUuMpKaEL9+JLRL9OIbmo/+w==
X-Received: by 2002:a50:9f4a:0:b0:4aa:a4f3:49cd with SMTP id b68-20020a509f4a000000b004aaa4f349cdmr1848814edf.19.1675553426583;
        Sat, 04 Feb 2023 15:30:26 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7777-cc00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7777:cc00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id v5-20020a1709061dc500b0084d4e9a13cbsm3386658ejh.221.2023.02.04.15.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:30:26 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 2/4] wifi: rtw88: pci: Change queue datatype to enum rtw_tx_queue_type
Date:   Sun,  5 Feb 2023 00:29:59 +0100
Message-Id: <20230204233001.1511643-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204233001.1511643-1-martin.blumenstingl@googlemail.com>
References: <20230204233001.1511643-1-martin.blumenstingl@googlemail.com>
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
"queue" variable when using the enum instead of an u8.

Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---

Changes from v1 -> v2:
- reword subject and include the "wifi" prefix
- add Ping-Ke's Acked-by


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
2.39.1


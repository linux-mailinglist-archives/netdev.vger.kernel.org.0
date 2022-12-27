Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F06657112
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiL0Xa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiL0Xan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:30:43 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C4DDEBA;
        Tue, 27 Dec 2022 15:30:40 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id u18so19465924eda.9;
        Tue, 27 Dec 2022 15:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dm4pitK4ZNMJZL5DH9iTHJHi+FnWxGRFQtHIaCaoNGo=;
        b=YWwi7CzLyKrwEdFyuUxmvizsWkIpPn2Rka2qKD03A3ewM59kw2KvC5v6EpON1xlSSq
         UOaqKeBlhGa/2dVFREhtyFZmlTdOSWMO1pbXfH8y5NntpGghgcjPjDvN8RC0ny8CJtUE
         oRcmdiMR1EXhw5f3m69RFo89af3ku7UJalnnCn2j9AaUyzDoDNRkmj7sz9Qm0sbaRxxa
         9Q4FSp2zIY2u6nwYxeV8CJuLjEjRaExTmMOd4hhCcfo6iBgouRLa6Rk4o1zSjDh3VLkA
         PvqMl7qUCM5cvszlAUsHnWBFyyvBjergKkMhdQ1kidb6MaVWZNdfjMw6lNcFGCDqjsVz
         PLeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dm4pitK4ZNMJZL5DH9iTHJHi+FnWxGRFQtHIaCaoNGo=;
        b=Sboh7uBIxISXXw6Qr5GGuWT/hc4Se5cb0ygTkz6fb0lRu22OLh+kwktWEv16Kap8cW
         7SQrpuPEQozdieKBmNN5vAlwtRWdba0fN9mNf2zrdMncYgOywN+BJHuK/zeA3GB8QpwL
         YUuvfY12buRTXWwa2Y+AXn6s4qglulcwSKsKi015xjsfgJvmP+Uh2NGr301HC/4iyke6
         ge7BBUKsFQTiS+inqAeECr+hOQJKW2M2OxdZgWxq5jY18IPVZ7JM+n+pkADooXdqorPT
         oDz4UIlAxvpQNsFtQ4VOMXLFgAgoV2z7YVDvpfusxDwSY+YkriJXjudSH2xjZc+Rk8ux
         THQg==
X-Gm-Message-State: AFqh2krTLZPec1BeaePGH+yIM/xE7h7osKZ03oi5Uiwu7MZpW7C0abFJ
        +dQ5oQLo4ccuSrHwaLUavao8oJNV+4Y=
X-Google-Smtp-Source: AMrXdXsS9hX335Fkht6+2053XGKLxjVMk10eknNraAxGKhiL8aCk1KR+3rgtmHKYD77nKNtWUI+8iA==
X-Received: by 2002:a05:6402:501f:b0:46c:a763:5889 with SMTP id p31-20020a056402501f00b0046ca7635889mr29038360eda.25.1672183839073;
        Tue, 27 Dec 2022 15:30:39 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:38 -0800 (PST)
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
Subject: [RFC PATCH v1 04/19] rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
Date:   Wed, 28 Dec 2022 00:30:05 +0100
Message-Id: <20221227233020.284266-5-martin.blumenstingl@googlemail.com>
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

This code is not specific to the PCIe bus type but can be re-used by USB
and SDIO bus types. Move it to tx.{c,h} to avoid code-duplication in the
future. While here, add checking of the ac argument in
rtw_tx_ac_to_hwq() so we're not accessing entries beyond the end of the
array.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 35 ++------------------
 drivers/net/wireless/realtek/rtw88/tx.c  | 41 ++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/tx.h  |  3 ++
 3 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 5492107fc85b..b4bd831c9845 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -670,37 +670,6 @@ static void rtw_pci_deep_ps(struct rtw_dev *rtwdev, bool enter)
 	spin_unlock_bh(&rtwpci->irq_lock);
 }
 
-static const enum rtw_tx_queue_type ac_to_hwq[] = {
-	[IEEE80211_AC_VO] = RTW_TX_QUEUE_VO,
-	[IEEE80211_AC_VI] = RTW_TX_QUEUE_VI,
-	[IEEE80211_AC_BE] = RTW_TX_QUEUE_BE,
-	[IEEE80211_AC_BK] = RTW_TX_QUEUE_BK,
-};
-
-static_assert(ARRAY_SIZE(ac_to_hwq) == IEEE80211_NUM_ACS);
-
-static enum rtw_tx_queue_type rtw_hw_queue_mapping(struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	__le16 fc = hdr->frame_control;
-	u8 q_mapping = skb_get_queue_mapping(skb);
-	enum rtw_tx_queue_type queue;
-
-	if (unlikely(ieee80211_is_beacon(fc)))
-		queue = RTW_TX_QUEUE_BCN;
-	else if (unlikely(ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)))
-		queue = RTW_TX_QUEUE_MGMT;
-	else if (is_broadcast_ether_addr(hdr->addr1) ||
-		 is_multicast_ether_addr(hdr->addr1))
-		queue = RTW_TX_QUEUE_HI0;
-	else if (WARN_ON_ONCE(q_mapping >= ARRAY_SIZE(ac_to_hwq)))
-		queue = ac_to_hwq[IEEE80211_AC_BE];
-	else
-		queue = ac_to_hwq[q_mapping];
-
-	return queue;
-}
-
 static void rtw_pci_release_rsvd_page(struct rtw_pci *rtwpci,
 				      struct rtw_pci_tx_ring *ring)
 {
@@ -798,7 +767,7 @@ static void rtw_pci_flush_queues(struct rtw_dev *rtwdev, u32 queues, bool drop)
 	} else {
 		for (i = 0; i < rtwdev->hw->queues; i++)
 			if (queues & BIT(i))
-				pci_queues |= BIT(ac_to_hwq[i]);
+				pci_queues |= BIT(rtw_tx_ac_to_hwq(i));
 	}
 
 	__rtw_pci_flush_queues(rtwdev, pci_queues, drop);
@@ -952,7 +921,7 @@ static int rtw_pci_tx_write(struct rtw_dev *rtwdev,
 			    struct rtw_tx_pkt_info *pkt_info,
 			    struct sk_buff *skb)
 {
-	enum rtw_tx_queue_type queue = rtw_hw_queue_mapping(skb);
+	enum rtw_tx_queue_type queue = rtw_tx_queue_mapping(skb);
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct rtw_pci_tx_ring *ring;
 	int ret;
diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index ab39245e9c2f..bb5c7492c98b 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -682,3 +682,44 @@ void rtw_txq_cleanup(struct rtw_dev *rtwdev, struct ieee80211_txq *txq)
 		list_del_init(&rtwtxq->list);
 	spin_unlock_bh(&rtwdev->txq_lock);
 }
+
+static const enum rtw_tx_queue_type ac_to_hwq[] = {
+	[IEEE80211_AC_VO] = RTW_TX_QUEUE_VO,
+	[IEEE80211_AC_VI] = RTW_TX_QUEUE_VI,
+	[IEEE80211_AC_BE] = RTW_TX_QUEUE_BE,
+	[IEEE80211_AC_BK] = RTW_TX_QUEUE_BK,
+};
+
+static_assert(ARRAY_SIZE(ac_to_hwq) == IEEE80211_NUM_ACS);
+
+enum rtw_tx_queue_type rtw_tx_ac_to_hwq(enum ieee80211_ac_numbers ac)
+{
+	if (WARN_ON(unlikely(ac >= IEEE80211_NUM_ACS)))
+		return RTW_TX_QUEUE_BE;
+
+	return ac_to_hwq[ac];
+}
+EXPORT_SYMBOL(rtw_tx_ac_to_hwq);
+
+enum rtw_tx_queue_type rtw_tx_queue_mapping(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	__le16 fc = hdr->frame_control;
+	u8 q_mapping = skb_get_queue_mapping(skb);
+	enum rtw_tx_queue_type queue;
+
+	if (unlikely(ieee80211_is_beacon(fc)))
+		queue = RTW_TX_QUEUE_BCN;
+	else if (unlikely(ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)))
+		queue = RTW_TX_QUEUE_MGMT;
+	else if (is_broadcast_ether_addr(hdr->addr1) ||
+		 is_multicast_ether_addr(hdr->addr1))
+		queue = RTW_TX_QUEUE_HI0;
+	else if (WARN_ON_ONCE(q_mapping >= ARRAY_SIZE(ac_to_hwq)))
+		queue = ac_to_hwq[IEEE80211_AC_BE];
+	else
+		queue = ac_to_hwq[q_mapping];
+
+	return queue;
+}
+EXPORT_SYMBOL(rtw_tx_queue_mapping);
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index a2f3ac326041..197d5868c8ad 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -131,6 +131,9 @@ rtw_tx_write_data_h2c_get(struct rtw_dev *rtwdev,
 			  struct rtw_tx_pkt_info *pkt_info,
 			  u8 *buf, u32 size);
 
+enum rtw_tx_queue_type rtw_tx_ac_to_hwq(enum ieee80211_ac_numbers ac);
+enum rtw_tx_queue_type rtw_tx_queue_mapping(struct sk_buff *skb);
+
 static inline
 void fill_txdesc_checksum_common(u8 *txdesc, size_t words)
 {
-- 
2.39.0


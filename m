Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC83048F333
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 00:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiANXtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 18:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbiANXs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 18:48:56 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C8AC061574;
        Fri, 14 Jan 2022 15:48:56 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id ay4-20020a05600c1e0400b0034a81a94607so7518745wmb.1;
        Fri, 14 Jan 2022 15:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZYFhsrkPrDaI7lwyyln6Ae8gj83V6alxweKHKFm4f+A=;
        b=JSL8FM+GsgePxacg49pCRuZ/CUkofU0ywNyKPNV0APiLos8dVF9EL5rgBUIBq5GTQb
         W20OSwpmMxTSEpVm0ZXi87xFd/kWNRZJNAKgikQMhW8/p2K542KZUzahLhR2fkhVCf9k
         w5dtXdgNK7stGolRhEHVnKMVwrRsriDmy/Rh1hji9ZWTK6vGg6pQ1Ng7m8zfI/WAKL7e
         z+7OkzwRMP6f5iNMmgdB2M0Y36Iq3wKes765u1X3l43+j3LimV0+Y6tFAVyTRq01L6z9
         KvHrOJr618f0WwU3ISgmgRM//rneqrZaxVA+zI4ng8nX9M3KQhrgsD7YvbISv4X2CXVl
         jNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZYFhsrkPrDaI7lwyyln6Ae8gj83V6alxweKHKFm4f+A=;
        b=BOF53khrmsPACtjffJjQolqqDUCFXDo8zTAauhC4OJFkkMJw1DO3AdeqxRvw7X7ZR2
         52TkMaAcHEHzP7ARKsdXwhibFhNGwmdA0C527pVLl5l6fVNwg6Z0V40mdoUSRiuU0rgl
         vylCjc0ozvcLmkjn0vwqohK8MN+YZLEI0yfFEq+EmWTRZSTQ5QJEWVCG4JH8bnP2FBs7
         YGh857G95Mk/c1KdbB2KfMcogaeHlMhIgrq8KwCeKVENO0B/+PmVYYZFCjGmFelDvdoG
         WHNUsLLKrSSQBCEuiJimmEvHbPfd6iwLPa/ngIfYBUfpWfYCtRtdMdr/tdUjoxQLW+gP
         ZSBQ==
X-Gm-Message-State: AOAM532/zLVVd1X8q+DiUO1GgIDCgfYRb/e9oK6JTLwIS0RsXknOcRq0
        9w5IbSR76+Bf6hjoKFhrHQvy6ZF3duc=
X-Google-Smtp-Source: ABdhPJwVNkrZbm6qLx8MbY43Zmb6jXlKsBObROSx5JUTnx2Fylr/k27C6KCf3FC8xYnJjipiLMAM0g==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr8698232wrn.502.1642204134687;
        Fri, 14 Jan 2022 15:48:54 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7684-7400-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7684:7400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id i3sm5788533wmq.21.2022.01.14.15.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:48:54 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 3/4] rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
Date:   Sat, 15 Jan 2022 00:48:24 +0100
Message-Id: <20220114234825.110502-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
References: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code is not specific to the PCIe bus type but can be re-used by USB
and SDIO bus types. Move it to tx.{c,h} to avoid code-duplication in the
future.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 32 ++--------------------
 drivers/net/wireless/realtek/rtw88/tx.c  | 35 ++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/tx.h  |  3 ++
 3 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 2da057d18188..945411a5947b 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -670,34 +670,6 @@ static void rtw_pci_deep_ps(struct rtw_dev *rtwdev, bool enter)
 	spin_unlock_bh(&rtwpci->irq_lock);
 }
 
-static enum rtw_tx_queue_type ac_to_hwq[] = {
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
@@ -795,7 +767,7 @@ static void rtw_pci_flush_queues(struct rtw_dev *rtwdev, u32 queues, bool drop)
 	} else {
 		for (i = 0; i < rtwdev->hw->queues; i++)
 			if (queues & BIT(i))
-				pci_queues |= BIT(ac_to_hwq[i]);
+				pci_queues |= BIT(rtw_tx_ac_to_hwq(i));
 	}
 
 	__rtw_pci_flush_queues(rtwdev, pci_queues, drop);
@@ -949,7 +921,7 @@ static int rtw_pci_tx_write(struct rtw_dev *rtwdev,
 			    struct rtw_tx_pkt_info *pkt_info,
 			    struct sk_buff *skb)
 {
-	enum rtw_tx_queue_type queue = rtw_hw_queue_mapping(skb);
+	enum rtw_tx_queue_type queue = rtw_tx_queue_mapping(skb);
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct rtw_pci_tx_ring *ring;
 	int ret;
diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index efcc1b0371a8..ec6a3683c3f8 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -665,3 +665,38 @@ void rtw_txq_cleanup(struct rtw_dev *rtwdev, struct ieee80211_txq *txq)
 		list_del_init(&rtwtxq->list);
 	spin_unlock_bh(&rtwdev->txq_lock);
 }
+
+static enum rtw_tx_queue_type ac_to_hwq[] = {
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
+	else if (WARN_ON_ONCE(q_mapping >= ARRAY_SIZE(ac_to_hwq)))
+		queue = ac_to_hwq[IEEE80211_AC_BE];
+	else
+		queue = ac_to_hwq[q_mapping];
+
+	return queue;
+}
+EXPORT_SYMBOL(rtw_tx_queue_mapping);
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index 56371eff9f7f..940f944fd39c 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -119,4 +119,7 @@ rtw_tx_write_data_h2c_get(struct rtw_dev *rtwdev,
 			  struct rtw_tx_pkt_info *pkt_info,
 			  u8 *buf, u32 size);
 
+enum rtw_tx_queue_type rtw_tx_ac_to_hwq(enum ieee80211_ac_numbers ac);
+enum rtw_tx_queue_type rtw_tx_queue_mapping(struct sk_buff *skb);
+
 #endif
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9C168AD74
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 00:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjBDXab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 18:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjBDXa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 18:30:29 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C790C148;
        Sat,  4 Feb 2023 15:30:28 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id lu11so24891157ejb.3;
        Sat, 04 Feb 2023 15:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HW/43DsO23wMM/PBvyHhtD5GvgJpDufOCANf4LVvWfk=;
        b=ne8x7rZxJOVDlM1J3JENOJsBo3jC9kh2eTD945pf7aIDfJHZR88Tl66rh2eVihwCqe
         bgNSmiPk61GbFRu4UlDuMEgHHiBvkOmjqD2YDxo5NvAKJqPSIqWpS3QLZ4r8WzKqLFJN
         vntBri+0K5kt9rdrzT0O60eci853AZd2B9JspCtudh7XuxULJvqPsqENuP3rgl2haETs
         zOuSrNWVf12o3aborjNpY8IfKWBxkVEnfMCBm7O3OR5Z97jjVrKNZ7nneO+epvWU/1mu
         XWfrgyPJimRTh+bQJtBRAyVDH4L8JXmXy2J4neH66J581FSXJUQA2y82m+m92iLs4ych
         wwvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HW/43DsO23wMM/PBvyHhtD5GvgJpDufOCANf4LVvWfk=;
        b=ySx7RHNkozobyIIO5IU9Kgg5O64/Zgnywn9Fjiq2qzaNgrR3WxftbO6ojq3Ra8cKuQ
         adNqOePr+ODN9/vQ/ZExIIj92Lw7ydyORpXroUWWnrrcyVNfcnoYULwHbs2V5o8WkkmM
         gbJvZPf81oUzmx1yfXPNw9aQUDfQs1qoY0aMr/RrrlwzY5+C8UsaoJgLDKFqsBREtUb7
         sYok/Yacfbcam3wM3r17h5CFqLa4U9PljnJ8Smbd2sHRHKIZSqjEnqAaxrVPmCONNGj7
         GpY9RUHEIIeCJwrfg+TEONaoY+0jrzQrXJBdWkoDTUqKJUw8V/IB03t7V1qT04YzQ8cU
         TeWA==
X-Gm-Message-State: AO0yUKXxmr+kLSO4fai9QKDsg++DH1k8NvuIgmnFShYyGvvh7NLVhETt
        cVklaIWRAjA+IpRQgMcKGBJjuDYAbJ0=
X-Google-Smtp-Source: AK7set8DVBdqBbGn9YF3tvA+eC3dh0t5o/yHbzl3VsJTEDQSg9yt4IMHlxrQzzxW1sS3qZ0CFYrkSw==
X-Received: by 2002:a17:906:d7a7:b0:87b:d3e3:c23 with SMTP id pk7-20020a170906d7a700b0087bd3e30c23mr16435923ejb.54.1675553427469;
        Sat, 04 Feb 2023 15:30:27 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7777-cc00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7777:cc00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id v5-20020a1709061dc500b0084d4e9a13cbsm3386658ejh.221.2023.02.04.15.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:30:27 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 3/4] wifi: rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
Date:   Sun,  5 Feb 2023 00:30:00 +0100
Message-Id: <20230204233001.1511643-4-martin.blumenstingl@googlemail.com>
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

This code is not specific to the PCIe bus type but can be re-used by USB
and SDIO bus types. Move it to tx.{c,h} to avoid code-duplication in the
future. While here, add checking of the ac argument in
rtw_tx_ac_to_hwq() so we're not accessing entries beyond the end of the
array.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---

Changes from v1 -> v2:
- add out of bounds check (with a fallback) in rtw_tx_queue_type()
- reword subject and include the "wifi" prefix


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
2.39.1


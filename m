Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C6268AD6D
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 00:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjBDXaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 18:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjBDXa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 18:30:28 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E7520D3F;
        Sat,  4 Feb 2023 15:30:27 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qw12so24904297ejc.2;
        Sat, 04 Feb 2023 15:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MjjMvrw5tJrb/cltfe+ZEhTawCPcDiUPZTdFHcpnzm4=;
        b=HoWYHrdvFCGhcXWlarOny3c24oMzEhjdRXQzdySqTnM05N23bR5f2jVD9zsYjkVqCH
         58L1tKW0nY0NKLOYF+bXN/vQYRzR2Q5vC1204cwHXn7EzOVP7eNyqRirbDINCIJY4DDY
         NlrTjFCw9WdaVeQIIvQoDyrw1iQZ8oXhGklIoMycw9laFHAO4ex8NSZMu5rK1BiYKRyK
         FhUn3KRCOAztglGWcwpd1kh803RJ21Bp+8j57BAt7OH4HL7qfj6g5MGfHKNY3cAR/1jL
         OnQfc979MZmqPYEmO7wImiMW47EnyRBv6wAb0PqSKGhOBQXryLsFlwgRVS+42b5c19NR
         gk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MjjMvrw5tJrb/cltfe+ZEhTawCPcDiUPZTdFHcpnzm4=;
        b=4KqxOHrnmp32mLkgakImFgyMy1bhSM/8/5Ik1/IZi+nSmZpn5gS1L8CA5fyY4TGfJA
         ucnr+hj6xND3+l/8tttEMGs+TV75SoWTKvru5CS7LnTx9QTc2VFDNHrzl+A5IwhCh6vY
         /CRbZwLG+3EplsNn0ErnNt6Nmx3jLQmRwzRl5nEa9Bu8UA1A0/po8kQEXU3KYFSycyc9
         RXjYNAdFVSmeHmqXf6zdoWYWyJp5pn95F2x5mAcfbTTH3Ccacbpga0lokoFN4bhhEHC5
         MKKtVJ0YmH2Qi+Vjb2aR0Bcy7veO0/X7liHdyUSes4ikhgSPCkxD71AwkEe8e0RPfu8I
         Ujhw==
X-Gm-Message-State: AO0yUKVlIw4YTwPyjy2soxMzTrzWkV+S+LYHIdM50uAgx52Ind4z+DFa
        ChATKPoZ55ZMXRlIAwh7amXyhaBirIc=
X-Google-Smtp-Source: AK7set92M3F5KuzFAmBymgQnZPqzD40IunbRn4HKzv/59C1RYG7NfpILQ+xwX9hFZy6oeSbIUTfraA==
X-Received: by 2002:a17:906:199b:b0:878:6631:7fe with SMTP id g27-20020a170906199b00b00878663107femr16536254ejd.20.1675553425726;
        Sat, 04 Feb 2023 15:30:25 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7777-cc00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7777:cc00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id v5-20020a1709061dc500b0084d4e9a13cbsm3386658ejh.221.2023.02.04.15.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:30:25 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 1/4] wifi: rtw88: pci: Use enum type for rtw_hw_queue_mapping() and ac_to_hwq
Date:   Sun,  5 Feb 2023 00:29:58 +0100
Message-Id: <20230204233001.1511643-2-martin.blumenstingl@googlemail.com>
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

rtw_hw_queue_mapping() and ac_to_hwq[] hold values of type enum
rtw_tx_queue_type. Change their types to reflect this to make it easier
to understand this part of the code.

While here, also change the array to be static const as it is not
supposed to be modified at runtime.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---

Changes from v1 -> v2:
- also make ac_to_hwq static const (instead of just static)
- reword subject and include the "wifi" prefix


 drivers/net/wireless/realtek/rtw88/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 0975d27240e4..45ce7e624c03 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -669,7 +669,7 @@ static void rtw_pci_deep_ps(struct rtw_dev *rtwdev, bool enter)
 	spin_unlock_bh(&rtwpci->irq_lock);
 }
 
-static u8 ac_to_hwq[] = {
+static const enum rtw_tx_queue_type ac_to_hwq[] = {
 	[IEEE80211_AC_VO] = RTW_TX_QUEUE_VO,
 	[IEEE80211_AC_VI] = RTW_TX_QUEUE_VI,
 	[IEEE80211_AC_BE] = RTW_TX_QUEUE_BE,
@@ -678,12 +678,12 @@ static u8 ac_to_hwq[] = {
 
 static_assert(ARRAY_SIZE(ac_to_hwq) == IEEE80211_NUM_ACS);
 
-static u8 rtw_hw_queue_mapping(struct sk_buff *skb)
+static enum rtw_tx_queue_type rtw_hw_queue_mapping(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
 	u8 q_mapping = skb_get_queue_mapping(skb);
-	u8 queue;
+	enum rtw_tx_queue_type queue;
 
 	if (unlikely(ieee80211_is_beacon(fc)))
 		queue = RTW_TX_QUEUE_BCN;
-- 
2.39.1


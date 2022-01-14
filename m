Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8732048F32F
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 00:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiANXtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 18:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiANXsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 18:48:55 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAEBC061574;
        Fri, 14 Jan 2022 15:48:54 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p1-20020a1c7401000000b00345c2d068bdso9879351wmc.3;
        Fri, 14 Jan 2022 15:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uIChTMrcpS/kkRKECZG0ehIyzqFS6xzet6sL4NEDXxE=;
        b=QLyYWW22YcFEzS+cr0DBjjT9/xbhNFfFyS8WWGJeTzoUOVDMVSN3M+/RJRXcfMZ1Du
         4Cr3Bh3xSZhXArrksIkAQJje6da3w6TRdQWtIWltD5wb67GcTuvqmDX4cAwqkl7wNy6N
         xDmhyk3lylAuLjWsj/xq42tlb4DVNIiSI2scoo/MxE55aJCU2K257CE1Nn2gd0vA2yWd
         x/B85/Jq92DV4WobbBYgJbTxbVGsHr+AwW3SkeS9hoeXRupAHASnPMknMqX0j3R8T7hf
         FFTTARlPULqoj0Jv2L7ALbrq8Bt0MhSuW00uh5Y+EtJxPdQmJ4/DLiaYKDA9TevtThJp
         oZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uIChTMrcpS/kkRKECZG0ehIyzqFS6xzet6sL4NEDXxE=;
        b=c8DnxIEuzyW3mEhhV0AJ42f9CwTZKkHoMlbj7VnDFnt/fjzqaTJzfKvzz+DVMv7aGj
         uKIOs7Vd6DpdjXAnlrqygX7/LAd/b9Y/mPC6GKWv3piEXyfrC0/YYuZ74VXh8jkjRpFb
         aOzyg2SYsYBc5u13xVPGDNYnYJg+2RX/V+SWx5ga1aX+c9bzsT+Do+dnF97cfXWOK1Vn
         jJOhgDwHqjPC+C8wsqqkO6H45jqTt47CaNsQsvJ7BBx5vgYmFXp9I2w5X+TBqEtqzOny
         1NTtyyVTF3zcSQvsx6LjD6yYNsvUtVf650pMIK2SuJcWYTNg0CiWnpsdXHf2Vb3wBuMy
         ac3w==
X-Gm-Message-State: AOAM5309zJaHgOrP9hsHT6ObbOd+D6nthVQn7u2lo1YsK1ZP6TIsv7BL
        x/dUsdrCFjMjcG4U9hCQWCnhofMey24=
X-Google-Smtp-Source: ABdhPJym9iys6gxC30Btb8GDrmAnFVKrA7I1y2VDy7wlDyvHvXVM71/hxP9QyA7hXKPQAZRejdvIhQ==
X-Received: by 2002:a05:600c:4e88:: with SMTP id f8mr10269102wmq.45.1642204132991;
        Fri, 14 Jan 2022 15:48:52 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7684-7400-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7684:7400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id i3sm5788533wmq.21.2022.01.14.15.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:48:52 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/4] rtw88: pci: Change type of rtw_hw_queue_mapping() and ac_to_hwq to enum
Date:   Sat, 15 Jan 2022 00:48:22 +0100
Message-Id: <20220114234825.110502-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
References: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtw_hw_queue_mapping() and ac_to_hwq[] hold values of type enum
rtw_tx_queue_type. Change their types to reflect this to make it easier
to understand this part of the code.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a0991d3f15c0..13f1f50b2867 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -669,7 +669,7 @@ static void rtw_pci_deep_ps(struct rtw_dev *rtwdev, bool enter)
 	spin_unlock_bh(&rtwpci->irq_lock);
 }
 
-static u8 ac_to_hwq[] = {
+static enum rtw_tx_queue_type ac_to_hwq[] = {
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
2.34.1


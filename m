Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1D0657106
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiL0Xar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiL0Xal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:30:41 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174F4640A;
        Tue, 27 Dec 2022 15:30:39 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id i15so20927597edf.2;
        Tue, 27 Dec 2022 15:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=On9zqZfBSd6xwFAzv2KqvU5VwSXHqqET7/qhE6YwsIw=;
        b=SNTmAxZHbI4rGrDL7WSqhXiMSYLuok7XiLn5jsUBjNZsBWfLGdEDvkwzYn9kEt+ExM
         yM01zDvSzvFF7btI3VKgLCuKWyCjzSN+oxtbnnNtANe7++q877ohJS16q7qtb+peoLGT
         379THwFkmXqEVK9LNWbZlaOwXWM9iWHwyXFNrN1L+LS62ez69W/wfVm9DP60TQxDcDMH
         Q0KGjBV8EPo9dceholSgOX+RCkfC+K6D8rq7TOSrGFZrR73jNZaxK+dgq8e2H3dtwDCX
         CRnRHBY8N6ymfOg0ZMvNjLoSF96sgPeplR8IkhyS5/ADf7al6pndKCfylPoELyjwhWSI
         iE5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=On9zqZfBSd6xwFAzv2KqvU5VwSXHqqET7/qhE6YwsIw=;
        b=K3W+chiaRArHiKSV1lOoCmnCOznquzW+yTX7DxyPfSIN97SIOQ1y2ON66NPUVvF6U+
         +p+v1q9alH56ll9haMyhzLHslPLL0lQqfkAsBvXhXu4VPphbgPML8kRGF/Uf4/ESmlNo
         UK9fIMdKWPNrOG/PXJbSVmdC1KlsF0rgYr8tsfwM8a3aFtlbk8l1qMRy76e6CY+QjhVR
         xZvnFFYcIkSjC/q1Ie5tPQSSAF6KE484lmlxIAVJgiODnDbjWt5zMYQfynctbLZHrGpK
         KW1NAuIYfYK1e5Z0N3m6QP31F/CG+Az5H7/fgGvrf1rtyyfvMzhpDpJb9TuapU7hAmcq
         ojuw==
X-Gm-Message-State: AFqh2kqpzSyCyb18SioF6HlD7/0GVialvYtc/ue5762f5olQy8mkLmab
        3izNhsS8hHtpUW4UlzKqJyauiA8S13Y=
X-Google-Smtp-Source: AMrXdXuwosdtKiTC3mmRWDVuPEeTdqyk/vj73kPIT20gET9jjxQKc5Hyp65eea/c0ByvQPRSemJWOA==
X-Received: by 2002:a05:6402:754:b0:485:9d0f:6193 with SMTP id p20-20020a056402075400b004859d0f6193mr5697630edy.38.1672183837463;
        Tue, 27 Dec 2022 15:30:37 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:36 -0800 (PST)
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
Subject: [RFC PATCH v1 02/19] rtw88: pci: Change type of rtw_hw_queue_mapping() and ac_to_hwq to enum
Date:   Wed, 28 Dec 2022 00:30:03 +0100
Message-Id: <20221227233020.284266-3-martin.blumenstingl@googlemail.com>
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

rtw_hw_queue_mapping() and ac_to_hwq[] hold values of type enum
rtw_tx_queue_type. Change their types to reflect this to make it easier
to understand this part of the code.

While here, also change the array to be static const as it is not
supposed to be modified at runtime.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
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
2.39.0


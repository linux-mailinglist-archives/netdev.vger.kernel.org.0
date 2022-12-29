Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1282E658CE6
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 13:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiL2Muw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 07:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiL2MtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 07:49:18 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06691057B;
        Thu, 29 Dec 2022 04:49:16 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c17so26517719edj.13;
        Thu, 29 Dec 2022 04:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FdmvaeMNmNESXg2Bm+GivnT9MUmG0nTE7m4Nif5YY+w=;
        b=XyKTz13T3nT39wJI2E8a+WhRDTPnxNtpjRpmPXYcFPRxb4Y1UemPmrXlUMMoegYBu1
         PKMgpVzl+JvZ+pU3Ig5WSPs2QGh+GblNk9uYtdnnpPjIUMpSO+etz6bRV9yPMVOjJ2ip
         aICV9p53iaE1JBPF/3JBxlhk9grBpDEu2Mj6vxNkNWngL11EOLYDWjqN1YGefHCXBd3T
         TowLRu4ByOzsYDhfm2LBUnJXlRt+XQSszHIFT5qn4NWcA7zKAHTcjVTDhxkNnFvokdr5
         xV2vtwBUt1IwwC6Q+TSDGyvkdg/fDqxi8FWzTfGwuccGrch4R5gF/u9D9dTK+4Kzof/B
         bO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FdmvaeMNmNESXg2Bm+GivnT9MUmG0nTE7m4Nif5YY+w=;
        b=Qm6QSxCEr4mOsyns9TLeEnMqlgkKuA7ia3KYiNh/UUql1lLfI/3ENfpjmMsQi7G8vg
         ikFg/JwhhLHH4Eglgd5Hnm90abkXE4OlIagwbGvsoKrcczGwpBTaMV+RFR14bveVVRCc
         93wbtdkEwrzoWIJPtuz0cviiv+qMyUaVjLh5KbEJk1r258fRdqNRdmgIkHBpWg2a4zHe
         viUPNJEQs9QiYBuRJt8zYbt++5MJfIY2c9TEmEEbBl47hWKu40rLBMb4Mn1/nWxZNUsN
         yEUO4DZyQcCB1vHpLPv31HovclAjZpH/5osU1GpDu5NgBWbjPPHL29CyMfZQSFwkcwsv
         pwgg==
X-Gm-Message-State: AFqh2kq0hkOaLHqpukvVSxWsDEcTRelgibUgUK4rZRBPW2+eFXN+aS0t
        AuKFHjffxOT9RjhgjbeTXm7D2YbD+Ss=
X-Google-Smtp-Source: AMrXdXt7M9fcIhyspkEURxl3uMIC5sS+7gdrmQhg/daPLFCN35b5gLQAWLyPPvoWOQreq9zyn3KXQA==
X-Received: by 2002:a05:6402:1609:b0:46a:f004:5e38 with SMTP id f9-20020a056402160900b0046af0045e38mr23718823edv.37.1672318155241;
        Thu, 29 Dec 2022 04:49:15 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7789-6e00-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7789:6e00::e63])
        by smtp.googlemail.com with ESMTPSA id b12-20020aa7dc0c000000b0046892e493dcsm8166299edu.26.2022.12.29.04.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 04:49:14 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 4/4] rtw88: Use non-atomic rtw_iterate_stas() in rtw_ra_mask_info_update()
Date:   Thu, 29 Dec 2022 13:48:45 +0100
Message-Id: <20221229124845.1155429-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
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

USB and (upcoming) SDIO support may sleep in the read/write handlers.
Use non-atomic rtw_iterate_stas() in rtw_ra_mask_info_update() because
the iterator function rtw_ra_mask_info_update_iter() needs to read and
write registers from within rtw_update_sta_info(). Using the non-atomic
iterator ensures that we can sleep during USB and SDIO register reads
and writes. This fixes "scheduling while atomic" or "Voluntary context
switch within RCU read-side critical section!" warnings as seen by SDIO
card users (but it also affects USB cards).

Fixes: 78d5bf925f30 ("wifi: rtw88: iterate over vif/sta list non-atomically")
Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 776a9a9884b5..3b92ac611d3f 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -737,7 +737,7 @@ static void rtw_ra_mask_info_update(struct rtw_dev *rtwdev,
 	br_data.rtwdev = rtwdev;
 	br_data.vif = vif;
 	br_data.mask = mask;
-	rtw_iterate_stas_atomic(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
+	rtw_iterate_stas(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
 }
 
 static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
@@ -746,7 +746,9 @@ static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
 {
 	struct rtw_dev *rtwdev = hw->priv;
 
+	mutex_lock(&rtwdev->mutex);
 	rtw_ra_mask_info_update(rtwdev, vif, mask);
+	mutex_unlock(&rtwdev->mutex);
 
 	return 0;
 }
-- 
2.39.0


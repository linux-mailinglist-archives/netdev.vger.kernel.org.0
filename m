Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA6C657745
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 14:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiL1NhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 08:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbiL1Ngp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 08:36:45 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157CF1A5;
        Wed, 28 Dec 2022 05:36:44 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id u9so38550432ejo.0;
        Wed, 28 Dec 2022 05:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7cV9Fdo1DL6GcPAsaixy13a9upftzi/bKQrV6XnSaJE=;
        b=USJJdxr3Yz8nPXAAgyGOZVykqPmSUXeK/1ry0KFjCY4hRH9aQWpkx9ZKCwUvS584LV
         3HhqWFaVguLKjkYq8mRugAQ9zk9YkAxiUc9efCumVsgRzEfzQ6EN1065HgROUie4jPPG
         vAj84V1WGloWB6MzSoW1mJxCuhYjFrup/jdHI+DJ6Us+WV6Qq9i0GBRY+1UtrBvBTCAl
         +mqO8WOHkzeQz1df6+SckyhA397MA5O99MwtWmyBkXFl7FJQ+1ZuS5s9/C9+WRKagckQ
         tyIgytef+lt5OPs15rEhdyo7K4egpTm5rnoY6NeVyQVm1XqIF7DVDSOq94jrVjFNMCiz
         9Xng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7cV9Fdo1DL6GcPAsaixy13a9upftzi/bKQrV6XnSaJE=;
        b=GaKXG8tpKAsQ8igP5/xpKrq/kAuTTSSmVAg4Chh52TQXqjeI71Z65Z3k2iPzw9Lig4
         rR4xMgY23WeOt8QVQY7G509sO+W7TuV81N6sc3UCzdZ3yFq79R2oCjGvVUMtZ6OiSnRi
         WyzNYOxSl4uB4wB7DleuB+u06Acr46IM1v9iBvlrUTTvA0tWVIwFBanS1lCWCGY4159A
         bncOMSICqiOObL1teCd73v/PE6kGYc/EpiAuJknOF+afnQcFVO3zlDqaqSg3teFqDEHP
         4zkv+xti5laCJS1gzrHKcSjw+y+5UGRtlIvf9mogmFiMkFMKKEdpULswzf1FO8GR/AEq
         aaCA==
X-Gm-Message-State: AFqh2kpuYMMwOAGI0Z4/oB1zsfly6RjWpoEoWgNhLUq27ieHBkmnJuVU
        3Q/wWI205KfqbCSv5zGSg3hGFUnPJiY=
X-Google-Smtp-Source: AMrXdXsjhQ2pro9S2msXgEkEhAegxknZw8ooT5nRpSojikoYXWDpEfjoMoGN6JfJAJAae6odJFUHLw==
X-Received: by 2002:a17:906:6d2:b0:7e7:4dd7:bb88 with SMTP id v18-20020a17090606d200b007e74dd7bb88mr18612063ejb.57.1672234602426;
        Wed, 28 Dec 2022 05:36:42 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b830-5100-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:b830:5100:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id g3-20020a170906538300b0082535e2da13sm7450475ejo.6.2022.12.28.05.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 05:36:42 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        tehuang@realtek.com, s.hauer@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 4/4] rtw88: Use non-atomic rtw_iterate_stas() in rtw_ra_mask_info_update()
Date:   Wed, 28 Dec 2022 14:35:47 +0100
Message-Id: <20221228133547.633797-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
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


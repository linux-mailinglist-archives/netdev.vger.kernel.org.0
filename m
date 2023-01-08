Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AD36619D0
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 22:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbjAHVOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 16:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbjAHVNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 16:13:37 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FC5DED8;
        Sun,  8 Jan 2023 13:13:37 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id tz12so15611065ejc.9;
        Sun, 08 Jan 2023 13:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6iCeauKtAdV4BHRnRbqupjiQnftMeTdF0kVtH3hB+E=;
        b=G9lcAMCTgFzpB/3Dm9t/28beZyeu4Nte6d9/pPXfwO2I2wqHIopt9W+893yGZNEuNq
         pCMS7rORqej2jzzTQgup0eL9ELK4CGyo3T7Hyy6y6DP5irJYlcvUT6ywGOnDGA/Btm2w
         T/++gQMnez8Uz1dh+/G0uMIeZTp1ESuQJQarot7SIiq0KzQmJfszGjmbNrdN9mRV/shc
         hRhtSvaf9Fpspe6YvBVdV+07wk5aEA8HjbIy/GtPKB5ZMVPT1DRNLgpXYNW4WLXLU/t8
         uor6zPu8ZZC9L/Aliv9+ux7KY3myaN28Xg3E09mG0SDbLQCM7Vc/T9DCZ5an3evdxc/V
         o7dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W6iCeauKtAdV4BHRnRbqupjiQnftMeTdF0kVtH3hB+E=;
        b=GhRQlfF5INrn/NVsgryA2sof5D6/DJ0NOq3t5to3UWjpxI+U3wo+Ub11/gRFGQCGZc
         +GN+8F1jScCFGNU/TnhJRt833fkkT7TUeBeHMulNhTEJnEs9X2VEJDNWUytIZiyVNV6d
         ls0ZiYfE1MN2K5g6agVbIuJv5imkqpIoz4KWVp1sMGYRM4zxLOUPnc1dJ6uFiA5HQ48h
         GDu2bqKeOJMFrdtHMXDR+nzUu/Vx5k5UofB5iy0fIQLr8L3roOgOkP0ogtzggqhnYWjV
         z2c2OLL6bjcwGqE1re3XV+N1OauJpVFyC9uJjS7R7k//YX6cV35UjWxQVhx1y99ZhiH5
         p7yw==
X-Gm-Message-State: AFqh2krAgNkaUSLqmNQOY5Tn4TWM4iGZ26Aox36YibhZR1pwjgJfOTkW
        1Bk0CvhEXdCVVu98FLxZtFpQN4lXmK4=
X-Google-Smtp-Source: AMrXdXuMazg5jY6xTFm581wcDdAoeMxptf7hyehgj6rhH0L+UWBeBgT6q+wjdyQZNzmOgcG1+O4VLg==
X-Received: by 2002:a17:907:d68e:b0:7c1:37:421c with SMTP id wf14-20020a170907d68e00b007c10037421cmr55961135ejc.32.1673212415338;
        Sun, 08 Jan 2023 13:13:35 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c485-2500-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c485:2500::e63])
        by smtp.googlemail.com with ESMTPSA id x25-20020a170906b09900b0080345493023sm2847997ejy.167.2023.01.08.13.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 13:13:35 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 3/3] wifi: rtw88: Use non-atomic sta iterator in rtw_ra_mask_info_update()
Date:   Sun,  8 Jan 2023 22:13:24 +0100
Message-Id: <20230108211324.442823-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
References: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
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
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
v1 -> v2:
- Added Ping-Ke's Reviewed-by (thank you!)

v2 -> v3:
- Added Sascha's Tested-by (thank you!)
- added "wifi" prefix to the subject and reworded the title accordingly


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


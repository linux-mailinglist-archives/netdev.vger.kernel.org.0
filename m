Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E859765773F
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 14:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbiL1NhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 08:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbiL1Ngn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 08:36:43 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828AB101E2;
        Wed, 28 Dec 2022 05:36:42 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id qk9so38432746ejc.3;
        Wed, 28 Dec 2022 05:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3q41smj/ytzNCubyI8baX/IOyt0BWi1B4JVJle7DtVs=;
        b=LpnNr+Q1krL40BPmaKAm9yeFtu0YJAiPWjQ2SxbadRPOOH4m4tJngQSUGeiQcwmi97
         7EfUlYS0ZBi+WXFg549D4fN0UaJqgV36IZJ/mVgA73U6v/qbh+a7dsEl+c5CuB/YOE1g
         j8oGIYu2CWWRE/zOlhh8v/Gb/XwDkQHeRpLrAcHhxf17SbZye2x91/d2YV5IeX7dZL3a
         sKI3uS+mZLQrgtgwRfoQ5fl2PY+BNBNH7cCeY0n0Eilerme06UDVN2xbD2O4m3D8lCLQ
         b8rHT3SMVxv2zRYwmPNFq8hxKwM+9c0RLce8dvW+Ywl0YRciyfZBTFuBfVXKulI5G1ra
         L2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3q41smj/ytzNCubyI8baX/IOyt0BWi1B4JVJle7DtVs=;
        b=ZU/lXFqhxJd7Med0UzI+g5H9FUVfWvKq9m213bz8srIPuunmhpQ41+Zd4WPI1M2NuD
         OPX0w59OzhSSf1pht8wmk3tPieb0awXVWLcT8wdsCPHqiUCTM+cv+d42mmYf1I2ZgQET
         K1lkmK42TjSMuGz6Z6IYi4WeuDZGhnG6FcQUn/MaV+BqzJHLNaClPbQmzdmqfT24DDlK
         BlLCXJ/ajfpJ4p5KNLZxUeMiW8739WL2JCZbJ/7puSu1QDyoCMpHpFOMt+qjdF7UPrjn
         4kcSo4ufYF3WB32gF+ge1XWl+8Qy3RRAAzWbRTmGxvZzdUXOoIUzNjd/vVoFarg5p3Kx
         bemQ==
X-Gm-Message-State: AFqh2kr61PYV9iIUCL5WteaN6MwVY+s/GqpDrJHN2t116LPhTJQKr1IM
        vaOz6qGccLC4mtisefYNqvwBPCX+QS0=
X-Google-Smtp-Source: AMrXdXtMZ2irLyN6LgT+kvA24YzaE6vNH6PWdYx+kb/ya0zicrtv7m0ajHJPqS88u5Ouww9e1dCiAg==
X-Received: by 2002:a17:907:7d8f:b0:7b5:911c:9b12 with SMTP id oz15-20020a1709077d8f00b007b5911c9b12mr25792298ejc.1.1672234600767;
        Wed, 28 Dec 2022 05:36:40 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b830-5100-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:b830:5100:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id g3-20020a170906538300b0082535e2da13sm7450475ejo.6.2022.12.28.05.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 05:36:40 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        tehuang@realtek.com, s.hauer@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/4] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
Date:   Wed, 28 Dec 2022 14:35:45 +0100
Message-Id: <20221228133547.633797-3-martin.blumenstingl@googlemail.com>
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
Shrink the RCU critical section so it only cover the call to
ieee80211_find_sta() and finding the ic_vht_cap/vht_cap based on the
found station. This moves the chip's BFEE configuration outside the
rcu_read_lock section and thus prevent "scheduling while atomic" or
"Voluntary context switch within RCU read-side critical section!"
warnings when accessing the registers using an SDIO card (which is
where this issue has been spotted in the real world - but it also
affects USB cards).

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/bf.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/bf.c b/drivers/net/wireless/realtek/rtw88/bf.c
index 038a30b170ef..c827c4a2814b 100644
--- a/drivers/net/wireless/realtek/rtw88/bf.c
+++ b/drivers/net/wireless/realtek/rtw88/bf.c
@@ -49,19 +49,23 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 
 	sta = ieee80211_find_sta(vif, bssid);
 	if (!sta) {
+		rcu_read_unlock();
+
 		rtw_warn(rtwdev, "failed to find station entry for bss %pM\n",
 			 bssid);
-		goto out_unlock;
+		return;
 	}
 
 	ic_vht_cap = &hw->wiphy->bands[NL80211_BAND_5GHZ]->vht_cap;
 	vht_cap = &sta->deflink.vht_cap;
 
+	rcu_read_unlock();
+
 	if ((ic_vht_cap->cap & IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE) &&
 	    (vht_cap->cap & IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)) {
 		if (bfinfo->bfer_mu_cnt >= chip->bfer_mu_max_num) {
 			rtw_dbg(rtwdev, RTW_DBG_BF, "mu bfer number over limit\n");
-			goto out_unlock;
+			return;
 		}
 
 		ether_addr_copy(bfee->mac_addr, bssid);
@@ -75,7 +79,7 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 		   (vht_cap->cap & IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)) {
 		if (bfinfo->bfer_su_cnt >= chip->bfer_su_max_num) {
 			rtw_dbg(rtwdev, RTW_DBG_BF, "su bfer number over limit\n");
-			goto out_unlock;
+			return;
 		}
 
 		sound_dim = vht_cap->cap &
@@ -98,9 +102,6 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 
 		rtw_chip_config_bfee(rtwdev, rtwvif, bfee, true);
 	}
-
-out_unlock:
-	rcu_read_unlock();
 }
 
 void rtw_bf_init_bfer_entry_mu(struct rtw_dev *rtwdev,
-- 
2.39.0


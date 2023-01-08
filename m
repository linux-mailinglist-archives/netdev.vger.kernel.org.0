Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673826619D3
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 22:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbjAHVOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 16:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236282AbjAHVNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 16:13:35 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E6E6565;
        Sun,  8 Jan 2023 13:13:34 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ud5so15649087ejc.4;
        Sun, 08 Jan 2023 13:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6bqgwx8SnsGvqrMFtHPg0KAjXh9chwbJoWM8918hmw=;
        b=i0RsI7bx2VQuzfi0WeLfoxFXqRLzGNyBa54n4h04kWwBbMxM1rS2WwuIHUY+IOdL7t
         fH7jgDLe/S8X4Rz3AOU7wE0g2dUdrB8TF1B+3iDkCE05XziNsb8daIXl6GlqqsPPd69R
         SwbF0rdxaP3HXwqUFWid5LK2VQLGm+60bEqpTzsKvU/t4bQmL0cPTzqEV0f5bLSxA0pG
         T1+aeUGf/hrpFfZBqrF6ZP7GwKG79ek9MRlMu3FYf7j28i2FlehragxsyJfFf6/fUrjA
         sWJS7qVN8V52uibnx97FcwkM+BCwiLEExaGZTdXvNliwWE+CfDApG824DVXj+B8h1AH4
         QZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g6bqgwx8SnsGvqrMFtHPg0KAjXh9chwbJoWM8918hmw=;
        b=UIqCG1I0HJgC44JWwmOzfu6Ea5JZtUCXwZ5J2BVdp4M1ICDlAOU4WwLPtMBtV1KZkd
         0sSz4TF9Np0ARXooGLba53OQxttV5vWgkGryi5R/vks3L2mNrCW3REhVAWQ/Y6OUJGWp
         6WGK8081RkTDUlC/AxH6XjoJDpKqNYSjY+whf5gQj49xXqybCqTw1+RJ04Xa3fxLtNOM
         pjflbQ/K6h8pJk7y5Domy/xQKIvuz5a4uEwB1MbEJMQsGpRhsbrCPck69tQOIy5Y2yCq
         cfkUPKiTE5PoMWbELyY6biGeu9vj6LU9vVoG3zoD05MdM2rmu40rl/+X1JFT22tI1nde
         LUjQ==
X-Gm-Message-State: AFqh2krrldEYje546Re1GAu0MmhkHuJnIL3M9cjPAbtisz0m2F32iMAT
        CWYGLVo1UrA9uwimVxDkA8cA/zZvp6U=
X-Google-Smtp-Source: AMrXdXtO6Ry2EzaKtRnlxJtEPh44IZH4kZJDTQbjH6QEMAJF4txRzjSWkABm3MEStkNW/g5tHxLvtg==
X-Received: by 2002:a17:906:e2d3:b0:7c0:deb3:596a with SMTP id gr19-20020a170906e2d300b007c0deb3596amr56800096ejb.70.1673212413289;
        Sun, 08 Jan 2023 13:13:33 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c485-2500-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c485:2500::e63])
        by smtp.googlemail.com with ESMTPSA id x25-20020a170906b09900b0080345493023sm2847997ejy.167.2023.01.08.13.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 13:13:32 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 1/3] wifi: rtw88: Move register access from rtw_bf_assoc() outside the RCU
Date:   Sun,  8 Jan 2023 22:13:22 +0100
Message-Id: <20230108211324.442823-2-martin.blumenstingl@googlemail.com>
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
Shrink the RCU critical section so it only cover the call to
ieee80211_find_sta() and finding the ic_vht_cap/vht_cap based on the
found station. This moves the chip's BFEE configuration outside the
rcu_read_lock section and thus prevent "scheduling while atomic" or
"Voluntary context switch within RCU read-side critical section!"
warnings when accessing the registers using an SDIO card (which is
where this issue has been spotted in the real world - but it also
affects USB cards).

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
v1 -> v2:
- Added Ping-Ke's Reviewed-by (thank you!)

v2 -> v3:
- Added Sascha's Tested-by (thank you!)
- added "wifi" prefix to the subject and reworded the title accordingly


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


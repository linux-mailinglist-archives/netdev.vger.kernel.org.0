Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3392B658CDE
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 13:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbiL2MtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 07:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiL2MtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 07:49:16 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCCE63E9;
        Thu, 29 Dec 2022 04:49:15 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g1so12353739edj.8;
        Thu, 29 Dec 2022 04:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jS0BiJw2eP0LQeJB4SgDtJllStgyNgULQaap6Y5302g=;
        b=qUxgdoWcXPNKGV3jwKEZYVeP+ev4EebR7XyHf8T2jnR2VWM35VS03JfARWCYMCKuVH
         Azz47TJAb6TGskMibN9h9OukfXB0Jcrm+9TkiH5JfUebfu3trOqIMk3TBn6EKzIHu/s8
         EFCk81y85REqM5c2+o8fShnAamaGg3vp65NLULXplDl5/zebxLRoN7dv8GLVGU8qPOho
         h3RwZIM2VCw77M+6YAu6sQw+zTIX6GxXmwkhXntVWmLIPct70U3O+aiK30oYceodzsgh
         bYTIC/CNBPaWk06st51LO9tlrDgCIYkn1L99JPcDfHN8TGR7RqLyJcSuL/62eUR8+hWw
         UX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jS0BiJw2eP0LQeJB4SgDtJllStgyNgULQaap6Y5302g=;
        b=EEIh645jqMn2X5j6OPJOa+YFOHGyJS7qhppZNH0oWN8VKP3yPkfutDxh+Mo9hzevBp
         ZbTFLg4cD2pkr61rRAwdtMIxxM4C4Z28NdO46a66ixfWC+5kN/Cdtmv8Dv94ut7y405K
         7yZ7KChWoH9uanyoT1f0s36iyWVCIrm2Ko0Eyzc0RaZV8Qx6CpTjLvpOUAzEaws64p1b
         RxoWCxsQ/213AcDaynzdq1pQlh5RGagIh5yh8thw3cB/pHbPBdj240eJmBtC/w4SMIYA
         Evzt6s2NVAp8qYXnpku5RqTgUDHFmS0w8s9ZdXPUJfNg7gK7HniAnbmmOaf1UC7HPdM8
         9zrw==
X-Gm-Message-State: AFqh2kraudP7vuaDmVX9szE5keQsH2UdDFnIn/OqPk85mNx05QyVYtbN
        w1Q+mhhDr9tgRdh23HmaPOSbIEQQZic=
X-Google-Smtp-Source: AMrXdXsunfKh92D2/cZnTt4ol0i/ilao2jAh47Nmz9xmsczrGF7l7VU4C3EPAjodMDSnisYURfmS+Q==
X-Received: by 2002:a50:ff0f:0:b0:47f:5c62:310f with SMTP id a15-20020a50ff0f000000b0047f5c62310fmr19001519edu.35.1672318153389;
        Thu, 29 Dec 2022 04:49:13 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7789-6e00-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7789:6e00::e63])
        by smtp.googlemail.com with ESMTPSA id b12-20020aa7dc0c000000b0046892e493dcsm8166299edu.26.2022.12.29.04.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 04:49:12 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/4] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
Date:   Thu, 29 Dec 2022 13:48:43 +0100
Message-Id: <20221229124845.1155429-3-martin.blumenstingl@googlemail.com>
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
Shrink the RCU critical section so it only cover the call to
ieee80211_find_sta() and finding the ic_vht_cap/vht_cap based on the
found station. This moves the chip's BFEE configuration outside the
rcu_read_lock section and thus prevent "scheduling while atomic" or
"Voluntary context switch within RCU read-side critical section!"
warnings when accessing the registers using an SDIO card (which is
where this issue has been spotted in the real world - but it also
affects USB cards).

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
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


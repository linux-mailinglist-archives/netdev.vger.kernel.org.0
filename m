Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BDD480D3B
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbhL1VP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbhL1VPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:15:22 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17ADDC06173E;
        Tue, 28 Dec 2021 13:15:22 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id a203-20020a1c7fd4000000b003457874263aso13402385wmd.2;
        Tue, 28 Dec 2021 13:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SM7IJAA3tcUmFTUnWjNYesUcXf6+3Mf9PHZAoA83J4U=;
        b=QZ+8HAuXGBgfsak4gck5ckM7OeD3E9/AGDswNzIk917HFY8+h3ct8wFVKyxvdSuNZd
         Ow7IkbGTpEEt4yOp15JDUKFUTHLNwpsPEmKW5T+ccYjwrQAywAitzp5pgmiZ2LEw6qLU
         cmXMawG20NILd1KwaCqmHpjQRxbnWMBdRyLHReDeXUyEVAL+sd5iY95e1w/d22zTfqkV
         EDg7IfiGBhosrRBXIpvRxQNfxi5EtBBRAftkaPasIuEN33LT9Aj43nRHBHZggrL+uyzV
         3qtsYkKivC3s+V0/ml4llPkZMFR4qdQOrgLnJ0QWB4EbwFFsL8qrQpT7G+DGJIBgzhFb
         TFRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SM7IJAA3tcUmFTUnWjNYesUcXf6+3Mf9PHZAoA83J4U=;
        b=ESqvB03OSVk6/XhKEarfRU5Npm/dqgW+Lqb9HW2V0g4cj2HaUA8xtSb6gSAsibUePq
         gJng+YLFNXSgeYbYNqrsDlXMniOThc2bsEGpj926C6Jvg05XKd48vs4kBz1eIHJgYrYb
         xNzAHf9bt87Fid+NHrRvfXvFxQ3vkUndA00rgJsA3qpgPdutSnhMJ2cviUGykKwgGsL5
         9fWOgBys4V49n3UOF0kHnwGmxoHNSM4PIBxwWh+0OIaIR3e+IKc4uZI6jOIDVOBui2G8
         PuiYkbZZGbItuSzVLYQrUjhMFl2sMGx0KQAyej7DkH0ToETGEM9PkTP/rkAfNfFAyhy6
         f1gA==
X-Gm-Message-State: AOAM530q1WsOHWxwbVJ08H8evDKi76TPq1VJ20yHQ1msZtFi1BAA4f+k
        6xA/+nUKz7wB+YyZrdT0uctZSUQvakQ=
X-Google-Smtp-Source: ABdhPJxtQTWB/yWQnfM47HkjuOCWuTBJe2oNf7zVW6g32iRMzXm/TQ7OiZsPScm//M6kKOKFPzTJcQ==
X-Received: by 2002:a05:600c:354c:: with SMTP id i12mr17535444wmq.139.1640726120430;
        Tue, 28 Dec 2021 13:15:20 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c1d2-d400-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:c1d2:d400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id o11sm21939036wmq.15.2021.12.28.13.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 13:15:20 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/9] rtw88: Move rtw_chip_cfg_csi_rate() out of rtw_vif_watch_dog_iter()
Date:   Tue, 28 Dec 2021 22:14:54 +0100
Message-Id: <20211228211501.468981-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtw_bf_cfg_csi_rate() internally access some registers while being
called unter an atomic lock acquired by rtw_iterate_vifs_atomic(). Move
the rtw_bf_cfg_csi_rate() call out of rtw_vif_watch_dog_iter() in
preparation for SDIO support where register access may sleep.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
v1 -> v2:
- this patch is new in v2
- keep rtw_iterate_vifs_atomic() to not undo the fix from commit
  5b0efb4d670c8 ("rtw88: avoid circular locking between
  local->iflist_mtx and rtwdev->mutex") and instead call
  rtw_bf_cfg_csi_rate() from rtw_watch_dog_work() (outside the atomic
  section) as suggested by Ping-Ke.

 drivers/net/wireless/realtek/rtw88/main.c | 35 +++++++++++------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 38252113c4a8..fd02c0b0025a 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -144,26 +144,9 @@ static struct ieee80211_supported_band rtw_band_5ghz = {
 struct rtw_watch_dog_iter_data {
 	struct rtw_dev *rtwdev;
 	struct rtw_vif *rtwvif;
+	bool cfg_csi_rate;
 };
 
-static void rtw_dynamic_csi_rate(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif)
-{
-	struct rtw_bf_info *bf_info = &rtwdev->bf_info;
-	u8 fix_rate_enable = 0;
-	u8 new_csi_rate_idx;
-
-	if (rtwvif->bfee.role != RTW_BFEE_SU &&
-	    rtwvif->bfee.role != RTW_BFEE_MU)
-		return;
-
-	rtw_chip_cfg_csi_rate(rtwdev, rtwdev->dm_info.min_rssi,
-			      bf_info->cur_csi_rpt_rate,
-			      fix_rate_enable, &new_csi_rate_idx);
-
-	if (new_csi_rate_idx != bf_info->cur_csi_rpt_rate)
-		bf_info->cur_csi_rpt_rate = new_csi_rate_idx;
-}
-
 static void rtw_vif_watch_dog_iter(void *data, u8 *mac,
 				   struct ieee80211_vif *vif)
 {
@@ -174,7 +157,8 @@ static void rtw_vif_watch_dog_iter(void *data, u8 *mac,
 		if (vif->bss_conf.assoc)
 			iter_data->rtwvif = rtwvif;
 
-	rtw_dynamic_csi_rate(iter_data->rtwdev, rtwvif);
+	iter_data->cfg_csi_rate = rtwvif->bfee.role == RTW_BFEE_SU ||
+				  rtwvif->bfee.role == RTW_BFEE_MU;
 
 	rtwvif->stats.tx_unicast = 0;
 	rtwvif->stats.rx_unicast = 0;
@@ -241,6 +225,19 @@ static void rtw_watch_dog_work(struct work_struct *work)
 	/* use atomic version to avoid taking local->iflist_mtx mutex */
 	rtw_iterate_vifs_atomic(rtwdev, rtw_vif_watch_dog_iter, &data);
 
+	if (data.cfg_csi_rate) {
+		struct rtw_bf_info *bf_info = &rtwdev->bf_info;
+		u8 fix_rate_enable = 0;
+		u8 new_csi_rate_idx;
+
+		rtw_chip_cfg_csi_rate(rtwdev, rtwdev->dm_info.min_rssi,
+				      bf_info->cur_csi_rpt_rate,
+				      fix_rate_enable, &new_csi_rate_idx);
+
+		if (new_csi_rate_idx != bf_info->cur_csi_rpt_rate)
+			bf_info->cur_csi_rpt_rate = new_csi_rate_idx;
+	}
+
 	/* fw supports only one station associated to enter lps, if there are
 	 * more than two stations associated to the AP, then we can not enter
 	 * lps, because fw does not handle the overlapped beacon interval
-- 
2.34.1


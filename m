Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51A26C138A
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjCTNg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjCTNgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:36:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6E6FF1F;
        Mon, 20 Mar 2023 06:36:16 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so12396030pjt.5;
        Mon, 20 Mar 2023 06:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679319375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F+RBm56r7Y5OPJGGXOR2z5S/kQ8hCSnX0int7hbaQUQ=;
        b=fA8DOloy3mhU7LxaVdax/Xc32quxK5qVmUbWu7Fm8zAjjucLPfRAMCfU+mEfmtmiIv
         75tcdd9mtiYwLBdHtlQw5zGNOSnqtXdaGIFlFI8VM/QaM/EBTiSllcv0b4xLVD86CDbJ
         MqChSdL8ZePSBNMIKgdhZ4GrV1sq0NP5dRfltbrXYADBt3KSijLj7CJCj51oHatMFV5Y
         xa2xFyDZII+YeTJacHAxe53zLEUIMVlxdjMQGJcn2pUVqWGOVVnbjVUgwUop/9hyIh0F
         rFj+eQmjITvuxnsqUKPOPuY+aZ58H3KZ4sY54lYs18vY5oL/eiIUvd8C/Lnyw7Bq7V/x
         jkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679319375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F+RBm56r7Y5OPJGGXOR2z5S/kQ8hCSnX0int7hbaQUQ=;
        b=AdRthPAMiFe2EVqD+R3ARm+K4in2geg+r5KOWz6AJvlQ1Z72Rgs+eTQy/sjAm+4FIb
         pX2h7aYJac95jEIdJEKaeFqYPCjfQAf6qPuzW/mBExDyhkdaZsDlZAuPpdPbnV3dtYxJ
         QyKqx1ddIagwXzpneBJGQO3aopcgNCYVVRv9HCE+6+wPJi7+lCjr3/z5LVgqGaKdU883
         h4jffO1/b264l2zLc+lcGd0ccORVwfm1JrXeQ11XwqgDQJ97SjvQ2mQRiTSpFmAHwoeZ
         8BklOIc3ph4iG6T0czLe2CkGOYKjIKbvC+2vK40fTQ3ijYR7jb2tz7lHDeuZd5JXwe1x
         dgrQ==
X-Gm-Message-State: AO0yUKX+U0Sdc+hlAzGQSEgt2Ps+kOJOx0ELZJws5UTj3jzK2eCddPvM
        IebzPA1V5vGqDTsHTDRjZrs=
X-Google-Smtp-Source: AK7set9bhUrCgAOAUQJPN01zuP80xYcZdGrBxbW1HfRjAEUbmraNxm+IZi6jdT8aCOFS6a6/2Zw2DA==
X-Received: by 2002:a17:90a:3ec1:b0:23d:48a9:3400 with SMTP id k59-20020a17090a3ec100b0023d48a93400mr19050160pjc.31.1679319375495;
        Mon, 20 Mar 2023 06:36:15 -0700 (PDT)
Received: from oslab.. ([106.39.42.159])
        by smtp.gmail.com with ESMTPSA id j19-20020a17090a7e9300b0023d1855e1b7sm9737485pjl.0.2023.03.20.06.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 06:35:41 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <baijiaju@buaa.edu.cn>
Subject: [PATCH] net: mac80211: Add NULL checks for sta->sdata
Date:   Mon, 20 Mar 2023 21:35:33 +0800
Message-Id: <20230320133533.2442889-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a previous commit 69403bad97aa, sta->sdata can be NULL, and thus it
should be checked before being used.

However, in the same call stack, sta->sdata is also used in the
following functions:

ieee80211_ba_session_work()
  ___ieee80211_stop_rx_ba_session(sta)
    ht_dbg(sta->sdata, ...); -> No check
    sdata_info(sta->sdata, ...); -> No check
    ieee80211_send_delba(sta->sdata, ...) -> No check
  ___ieee80211_start_rx_ba_session(sta)
    ht_dbg(sta->sdata, ...); -> No check
    ht_dbg_ratelimited(sta->sdata, ...); -> No check
  ieee80211_tx_ba_session_handle_start(sta)
    sdata = sta->sdata; if (!sdata) -> Add check by previous commit
  ___ieee80211_stop_tx_ba_session(sdata)
    ht_dbg(sta->sdata, ...); -> No check
  ieee80211_start_tx_ba_cb(sdata)
    sdata = sta->sdata; local = sdata->local -> No check
  ieee80211_stop_tx_ba_cb(sdata)
    ht_dbg(sta->sdata, ...); -> No check

Thus, to avoid possible null-pointer dereferences, the related checks
should be added.

These results are reported by a static tool designed by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reported-by: TOTE Robot <baijiaju@buaa.edu.cn>
---
 net/mac80211/agg-rx.c | 68 ++++++++++++++++++++++++++-----------------
 net/mac80211/agg-tx.c | 16 ++++++++--
 2 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index c6fa53230450..6616970785a2 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -80,19 +80,21 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
 	__clear_bit(tid, sta->ampdu_mlme.agg_session_valid);
 
-	ht_dbg(sta->sdata,
-	       "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
-	       sta->sta.addr, tid,
-	       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "initiator",
-	       (int)reason);
+	if (sta->sdata) {
+		ht_dbg(sta->sdata,
+		       "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
+		       sta->sta.addr, tid,
+		       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "initiator",
+		       (int)reason);
+	}
 
-	if (drv_ampdu_action(local, sta->sdata, &params))
+	if (sta->sdata && drv_ampdu_action(local, sta->sdata, &params))
 		sdata_info(sta->sdata,
 			   "HW problem - can not stop rx aggregation for %pM tid %d\n",
 			   sta->sta.addr, tid);
 
 	/* check if this is a self generated aggregation halt */
-	if (initiator == WLAN_BACK_RECIPIENT && tx)
+	if (initiator == WLAN_BACK_RECIPIENT && tx && sta->sdata)
 		ieee80211_send_delba(sta->sdata, sta->sta.addr,
 				     tid, WLAN_BACK_RECIPIENT, reason);
 
@@ -279,17 +281,21 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 
 	if (!sta->sta.deflink.ht_cap.ht_supported &&
 	    !sta->sta.deflink.he_cap.has_he) {
-		ht_dbg(sta->sdata,
-		       "STA %pM erroneously requests BA session on tid %d w/o HT\n",
-		       sta->sta.addr, tid);
+		if (sta->sdata) {
+			ht_dbg(sta->sdata,
+			       "STA %pM erroneously requests BA session on tid %d w/o HT\n",
+			       sta->sta.addr, tid);
+		}
 		/* send a response anyway, it's an error case if we get here */
 		goto end;
 	}
 
 	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
-		ht_dbg(sta->sdata,
-		       "Suspend in progress - Denying ADDBA request (%pM tid %d)\n",
-		       sta->sta.addr, tid);
+		if (sta->sdata) {
+			ht_dbg(sta->sdata,
+			       "Suspend in progress - Denying ADDBA request (%pM tid %d)\n",
+			       sta->sta.addr, tid);
+		}
 		goto end;
 	}
 
@@ -322,8 +328,10 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 		buf_size = sta->sta.max_rx_aggregation_subframes;
 	params.buf_size = buf_size;
 
-	ht_dbg(sta->sdata, "AddBA Req buf_size=%d for %pM\n",
-	       buf_size, sta->sta.addr);
+	if (sta->sdata) {
+		ht_dbg(sta->sdata, "AddBA Req buf_size=%d for %pM\n",
+		       buf_size, sta->sta.addr);
+	}
 
 	/* examine state machine */
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
@@ -332,9 +340,11 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 		if (sta->ampdu_mlme.tid_rx_token[tid] == dialog_token) {
 			struct tid_ampdu_rx *tid_rx;
 
-			ht_dbg_ratelimited(sta->sdata,
-					   "updated AddBA Req from %pM on tid %u\n",
-					   sta->sta.addr, tid);
+			if (sta->sdata) {
+				ht_dbg_ratelimited(sta->sdata,
+						   "updated AddBA Req from %pM on tid %u\n",
+						   sta->sta.addr, tid);
+			}
 			/* We have no API to update the timeout value in the
 			 * driver so reject the timeout update if the timeout
 			 * changed. If it did not change, i.e., no real update,
@@ -350,9 +360,11 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 			goto end;
 		}
 
-		ht_dbg_ratelimited(sta->sdata,
-				   "unexpected AddBA Req from %pM on tid %u\n",
-				   sta->sta.addr, tid);
+		if (sta->sdata) {
+			ht_dbg_ratelimited(sta->sdata,
+					   "unexpected AddBA Req from %pM on tid %u\n",
+					   sta->sta.addr, tid);
+		}
 
 		/* delete existing Rx BA session on the same tid */
 		___ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
@@ -362,9 +374,11 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 
 	if (ieee80211_hw_check(&local->hw, SUPPORTS_REORDERING_BUFFER)) {
 		ret = drv_ampdu_action(local, sta->sdata, &params);
-		ht_dbg(sta->sdata,
-		       "Rx A-MPDU request on %pM tid %d result %d\n",
-		       sta->sta.addr, tid, ret);
+		if (sta->sdata) {
+			ht_dbg(sta->sdata,
+			       "Rx A-MPDU request on %pM tid %d result %d\n",
+			       sta->sta.addr, tid, ret);
+		}
 		if (!ret)
 			status = WLAN_STATUS_SUCCESS;
 		goto end;
@@ -401,8 +415,10 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 		__skb_queue_head_init(&tid_agg_rx->reorder_buf[i]);
 
 	ret = drv_ampdu_action(local, sta->sdata, &params);
-	ht_dbg(sta->sdata, "Rx A-MPDU request on %pM tid %d result %d\n",
-	       sta->sta.addr, tid, ret);
+	if (sta->sdata) {
+		ht_dbg(sta->sdata, "Rx A-MPDU request on %pM tid %d result %d\n",
+		       sta->sta.addr, tid, ret);
+	}
 	if (ret) {
 		kfree(tid_agg_rx->reorder_buf);
 		kfree(tid_agg_rx->reorder_time);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index f9514bacbd4a..03b31b6e7ac7 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -368,8 +368,10 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 
 	spin_unlock_bh(&sta->lock);
 
-	ht_dbg(sta->sdata, "Tx BA session stop requested for %pM tid %u\n",
-	       sta->sta.addr, tid);
+	if (sta->sdata) {
+		ht_dbg(sta->sdata, "Tx BA session stop requested for %pM tid %u\n",
+		       sta->sta.addr, tid);
+	}
 
 	del_timer_sync(&tid_tx->addba_resp_timer);
 	del_timer_sync(&tid_tx->session_timer);
@@ -776,7 +778,12 @@ void ieee80211_start_tx_ba_cb(struct sta_info *sta, int tid,
 			      struct tid_ampdu_tx *tid_tx)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_local *local;
+
+	if (!sdata)
+		return;
+
+	local = sdata->local;
 
 	if (WARN_ON(test_and_set_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state)))
 		return;
@@ -902,6 +909,9 @@ void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
 	bool send_delba = false;
 	bool start_txq = false;
 
+	if (!sdata)
+		return;
+
 	ht_dbg(sdata, "Stopping Tx BA session for %pM tid %d\n",
 	       sta->sta.addr, tid);
 
-- 
2.34.1


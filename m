Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5194E6D6195
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 14:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbjDDMuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 08:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234883AbjDDMu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 08:50:29 -0400
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2318044BF;
        Tue,  4 Apr 2023 05:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=buaa.edu.cn; s=buaa; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=nh81zXQ6nr
        LzWn6GfkPmqlO2pjRmU5VKFGSRCd0pL/c=; b=WWWHWBqdbZaILRyPrJwneKVPVD
        SPHhH+39mjvJvlltbG40kFupoPoTJtBRVQayjc5JKhIhEzfnWp3+6gHogPO1V/r9
        rPqqRFuSi540ynhnqCZ9bB5NtMyxHsquEUNCNmn6XGLwaoH4Volcq6CjIRcf4KaT
        jiFthstyytKJ7b+uo=
Received: from oslab.. (unknown [10.130.159.144])
        by coremail-app1 (Coremail) with SMTP id OCz+CgAnLgpnHCxkLekaAw--.21719S4;
        Tue, 04 Apr 2023 20:47:35 +0800 (CST)
From:   Jia-Ju Bai <baijiaju@buaa.edu.cn>
To:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        simon.horman@corigine.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju@buaa.edu.cn>
Subject: [PATCH v3] net: mac80211: Add NULL checks for sta->sdata
Date:   Tue,  4 Apr 2023 20:47:34 +0800
Message-Id: <20230404124734.201011-1-baijiaju@buaa.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: OCz+CgAnLgpnHCxkLekaAw--.21719S4
X-Coremail-Antispam: 1UD129KBjvJXoWxtF4fZw4rZry7KFWrur1Dtrb_yoWfCFW8pr
        WrGw1jqF4UJa4xZrn7Jr4F9a4Fkr10gF48ur1fCF18u3ZY9wnY9r1kury8ZF9Yyr1xJw1Y
        vF4Uu398Ca1Du37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9F1xkIjI8I6I8E6xAIw20EY4v20xvaj40_JFC_Wr1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK
        6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_Aw1UJr1UMxC20s026xCaFV
        Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
        x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
        1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_
        JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
        sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: yrruji46exttoohg3hdfq/
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a previous commit 69403bad97aa ("wifi: mac80211: sdata can be NULL
during AMPDU start"), sta->sdata can be NULL, and thus it should be
checked before being used.

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

These bugs are reported by a static analysis tool implemented by myself,
and they are found by extending a known bug fixed in the previous commit.
Thus, they could be theoretical bugs.

Signed-off-by: Jia-Ju Bai <baijiaju@buaa.edu.cn>
---
v3:
* Add NULL check about sta->sdata related to local in the function
  ___ieee80211_start_rx_ba_session()
---
v2:
* Fix an error reported by checkpatch.pl, and make the bug finding
  process more clear in the description. Thanks for Simon's advice.
---
 net/mac80211/agg-rx.c | 95 ++++++++++++++++++++++++++-----------------
 net/mac80211/agg-tx.c | 16 ++++++--
 2 files changed, 71 insertions(+), 40 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index c6fa53230450..f2e9dbd7559a 100644
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
 
@@ -256,7 +258,7 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 				      u16 buf_size, bool tx, bool auto_seq,
 				      const struct ieee80211_addba_ext_ie *addbaext)
 {
-	struct ieee80211_local *local = sta->sdata->local;
+	struct ieee80211_local *local = NULL;
 	struct tid_ampdu_rx *tid_agg_rx;
 	struct ieee80211_ampdu_params params = {
 		.sta = &sta->sta,
@@ -270,26 +272,35 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 	u16 status = WLAN_STATUS_REQUEST_DECLINED;
 	u16 max_buf_size;
 
+	if (sta->sdata)
+		local = sta->sdata->local;
+
 	if (tid >= IEEE80211_FIRST_TSPEC_TSID) {
-		ht_dbg(sta->sdata,
-		       "STA %pM requests BA session on unsupported tid %d\n",
-		       sta->sta.addr, tid);
+		if (sta->sdata) {
+			ht_dbg(sta->sdata,
+			       "STA %pM requests BA session on unsupported tid %d\n",
+			       sta->sta.addr, tid);
+		}
 		goto end;
 	}
 
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
 
@@ -308,9 +319,11 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 	     (!(sta->sta.deflink.ht_cap.cap & IEEE80211_HT_CAP_DELAY_BA))) ||
 	    (buf_size > max_buf_size)) {
 		status = WLAN_STATUS_INVALID_QOS_PARAM;
-		ht_dbg_ratelimited(sta->sdata,
-				   "AddBA Req with bad params from %pM on tid %u. policy %d, buffer size %d\n",
-				   sta->sta.addr, tid, ba_policy, buf_size);
+		if (sta->sdata) {
+			ht_dbg_ratelimited(sta->sdata,
+					   "AddBA Req with bad params from %pM on tid %u. policy %d, buffer size %d\n",
+					   sta->sta.addr, tid, ba_policy, buf_size);
+		}
 		goto end;
 	}
 	/* determine default buffer size */
@@ -322,8 +335,10 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
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
@@ -332,9 +347,11 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
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
@@ -350,9 +367,11 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
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
@@ -360,7 +379,7 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 						false);
 	}
 
-	if (ieee80211_hw_check(&local->hw, SUPPORTS_REORDERING_BUFFER)) {
+	if (sta->sdata && ieee80211_hw_check(&local->hw, SUPPORTS_REORDERING_BUFFER)) {
 		ret = drv_ampdu_action(local, sta->sdata, &params);
 		ht_dbg(sta->sdata,
 		       "Rx A-MPDU request on %pM tid %d result %d\n",
@@ -400,14 +419,16 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 	for (i = 0; i < buf_size; i++)
 		__skb_queue_head_init(&tid_agg_rx->reorder_buf[i]);
 
-	ret = drv_ampdu_action(local, sta->sdata, &params);
-	ht_dbg(sta->sdata, "Rx A-MPDU request on %pM tid %d result %d\n",
-	       sta->sta.addr, tid, ret);
-	if (ret) {
-		kfree(tid_agg_rx->reorder_buf);
-		kfree(tid_agg_rx->reorder_time);
-		kfree(tid_agg_rx);
-		goto end;
+	if (sta->sdata) {
+		ret = drv_ampdu_action(local, sta->sdata, &params);
+		ht_dbg(sta->sdata, "Rx A-MPDU request on %pM tid %d result %d\n",
+		       sta->sta.addr, tid, ret);
+		if (ret) {
+			kfree(tid_agg_rx->reorder_buf);
+			kfree(tid_agg_rx->reorder_time);
+			kfree(tid_agg_rx);
+			goto end;
+		}
 	}
 
 	/* update data */
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index f9514bacbd4a..db53dcaccba9 100644
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
+	if (WARN_ON(!sdata))
+		return;
+
+	local = sdata->local;
 
 	if (WARN_ON(test_and_set_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state)))
 		return;
@@ -902,6 +909,9 @@ void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
 	bool send_delba = false;
 	bool start_txq = false;
 
+	if (WARN_ON(!sdata))
+		return;
+
 	ht_dbg(sdata, "Stopping Tx BA session for %pM tid %d\n",
 	       sta->sta.addr, tid);
 
-- 
2.34.1


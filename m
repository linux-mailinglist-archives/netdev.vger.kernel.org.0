Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196F76C2E03
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 10:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjCUJhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 05:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjCUJhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 05:37:40 -0400
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3713F2FCCF;
        Tue, 21 Mar 2023 02:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=buaa.edu.cn; s=buaa; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=VxlKtmtI4M
        Yzuv9XChprrpz83EpEpy3HSQHqnASaJn4=; b=qzVvjmsDwzkpb3d4pcXWljl8Mh
        0AskS7s6LnUZN5Vbt1ncVINyXDAEUBw8OOL3s4m+XlroFNPilAAJrhHQ5fmIXOFm
        /CSe5eWIOWrdh78SvklgpuHTE5bLYHpKLPoaw3GImuvAG9vrSF/37663HwAWvPUa
        dUxV/cNaq/3646qrw=
Received: from oslab.. (unknown [10.130.159.144])
        by coremail-app1 (Coremail) with SMTP id OCz+CgBXCJXBehlk1WW4Ag--.39745S4;
        Tue, 21 Mar 2023 17:37:05 +0800 (CST)
From:   Jia-Ju Bai <baijiaju@buaa.edu.cn>
To:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        simon.horman@corigine.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju@buaa.edu.cn>
Subject: [PATCH v2] net: mac80211: Add NULL checks for sta->sdata
Date:   Tue, 21 Mar 2023 17:31:22 +0800
Message-Id: <20230321093122.2652111-1-baijiaju@buaa.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: OCz+CgBXCJXBehlk1WW4Ag--.39745S4
X-Coremail-Antispam: 1UD129KBjvJXoWxtF4fZw4rZry7KFWrur1Dtrb_yoW3GFyxpr
        WrGw1jqF4UJa4xZrn3Jr1F93yF9r10gF48Cr1fC3W8u3ZY9wnYkr1v9ry8ZF9YyryxJw1Y
        qF4Du398Ca1DC37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU921xkIjI8I6I8E6xAIw20EY4v20xvaj40_JFC_Wr1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
        6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxE
        wVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26F1DJr1UJwCFx2IqxVCFs4
        IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
        MI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
        WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
        6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
        BIdaVFxhVjvjDU0xZFpf9x0JUp6wZUUUUU=
X-CM-SenderInfo: yrruji46exttoohg3hdfq/
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
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
v2:
* Fix an error reported by checkpatch.pl, and make the bug finding
  process more clear in the description. Thanks for Simon's advice.
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


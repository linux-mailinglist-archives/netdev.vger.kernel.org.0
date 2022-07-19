Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95229579F7A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240290AbiGSNUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243683AbiGSNT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:19:29 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447D49C7A6;
        Tue, 19 Jul 2022 05:36:26 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c22so699009wmr.2;
        Tue, 19 Jul 2022 05:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EwCMz9qqrnH8Nt8qCl6GBxcKBN6DmBQJlZeoDH9NWT0=;
        b=N0JtbG7mbs2RDw5hpLepX1IX1wRtM5Ewkt3zHHKW77hXaEOyFA4eByxHRdMiHx6+TV
         BteFrsLRqK1pY1L4+SXYwaAVmV5I0LxziJfk8eAxQNj9bUk4S43Q2SGLVWPfQedvi7hd
         0JOnPHIFw2fEgETTMdP5aAisqaOybs0tfQMNO6XFNSSkJ4+j6RMaCPXgBPXksb4ZcD7L
         6HeVKp+aoAaWBKBsg9uW/cKbhwUSxu6/8CgNfhlGGfqcynrRZP6s2LXrbR6zIkWvQIZj
         X7f2JOINDzrw80aF1chDJK0vXs0gbyU9Z1X1181oKNDXKDT0s5jhv8C3WdRrSID4PAQL
         J2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EwCMz9qqrnH8Nt8qCl6GBxcKBN6DmBQJlZeoDH9NWT0=;
        b=oBapGFfXYkexBho315ufjQVKqkrE/kbOr1hSUFGEcfhNRwP4olIVrQGMvFpWenyh6L
         3Pcr08vIsoRrPULbrU/w3ZcW6/GOJvwdZ8Ax2gSR5TMFOcqLvEZaqrg29XUUPiJAGY3b
         7LArvcf4vGm9VAQ5pU/LYe1sSXtKl2Yrx5fjN2bjQhkBvvkGjDDayr1xn1Zcpf8GVU7h
         05Nc+m8i2EPW9Z30nc+r/KIhFz9nFfo7d5eL8nL7EGUP1Zw2qclH8IMMbVpqZiUJTPlm
         /xgSh/2bvxRL6FZ2bq9uFPmjNAwtIyGoJTUXIyeLmDetNp3IU5kXLEouBUXp8cjdD7bx
         OFDQ==
X-Gm-Message-State: AJIora9e48OwKJmRlSKnvYh6u+LRJbKdbyijEju9h0krLAdNCgUleNuT
        4cHto2kW3P/Spg2oobR8lyM=
X-Google-Smtp-Source: AGRyM1sYN+VBwSIPD7Mcxo2XwuGkEnv86MHQ9OsJk0WMKs/tNG+gPZgAtFXTt9BR8+w6WHLN5lt0Jg==
X-Received: by 2002:a05:600c:3546:b0:3a1:861d:e75a with SMTP id i6-20020a05600c354600b003a1861de75amr37062000wmq.58.1658234184400;
        Tue, 19 Jul 2022 05:36:24 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id bp30-20020a5d5a9e000000b0021e297d6850sm3337522wrb.110.2022.07.19.05.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:36:24 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Linus Lussing <linus.luessing@c0d3.blue>,
        Kalle Valo <kvalo@kernel.org>,
        Baligh Gasmi <gasmibal@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [RFC/RFT v5 1/4] mac80211: use AQL airtime for expected throughput.
Date:   Tue, 19 Jul 2022 14:35:22 +0200
Message-Id: <20220719123525.3448926-2-gasmibal@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719123525.3448926-1-gasmibal@gmail.com>
References: <20220719123525.3448926-1-gasmibal@gmail.com>
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

Since the integration of AQL, packet TX airtime estimation is
calculated and counted to be used for the dequeue limit.

Use this estimated airtime to compute expected throughput for
each station.

It will be a generic mac80211 implementation. that can be used if the
driver do not have get_expected_throughput implementation.

Useful for L2 routing protocols, like B.A.T.M.A.N.

Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
CC: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/driver-ops.h |  2 ++
 net/mac80211/sta_info.c   | 39 +++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h   | 11 +++++++++++
 net/mac80211/status.c     |  2 ++
 net/mac80211/tx.c         |  8 +++++++-
 5 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4e2fc1a08681..fa9952154795 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1142,6 +1142,8 @@ static inline u32 drv_get_expected_throughput(struct ieee80211_local *local,
 	trace_drv_get_expected_throughput(&sta->sta);
 	if (local->ops->get_expected_throughput && sta->uploaded)
 		ret = local->ops->get_expected_throughput(&local->hw, &sta->sta);
+	else
+		ret = ewma_avg_est_tp_read(&sta->deflink.status_stats.avg_est_tp);
 	trace_drv_return_u32(local, ret);
 
 	return ret;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e04a0905e941..201aab465234 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1993,6 +1993,45 @@ void ieee80211_sta_update_pending_airtime(struct ieee80211_local *local,
 			       tx_pending, 0);
 }
 
+void ieee80211_sta_update_tp(struct ieee80211_local *local,
+			     struct sta_info *sta,
+			     struct sk_buff *skb,
+			     u16 tx_time_est,
+			     bool ack, int retry)
+{
+	unsigned long diff;
+	struct rate_control_ref *ref = NULL;
+
+	if (!skb || !sta || !tx_time_est)
+		return;
+
+	if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+		ref = sta->rate_ctrl;
+
+	if (ref && ref->ops->get_expected_throughput)
+		return;
+
+	if (local->ops->get_expected_throughput)
+		return;
+
+	tx_time_est += ack ? 4 : 0;
+	tx_time_est += retry ? retry * 2 : 2;
+
+	sta->deflink.tx_stats.tp_tx_size += (skb->len * 8) * 1000;
+	sta->deflink.tx_stats.tp_tx_time_est += tx_time_est;
+
+	diff = jiffies - sta->deflink.status_stats.last_tp_update;
+	if (diff > HZ / 10) {
+		ewma_avg_est_tp_add(&sta->deflink.status_stats.avg_est_tp,
+				    sta->deflink.tx_stats.tp_tx_size /
+				    sta->deflink.tx_stats.tp_tx_time_est);
+
+		sta->deflink.tx_stats.tp_tx_size = 0;
+		sta->deflink.tx_stats.tp_tx_time_est = 0;
+		sta->deflink.status_stats.last_tp_update = jiffies;
+	}
+}
+
 int sta_info_move_state(struct sta_info *sta,
 			enum ieee80211_sta_state new_state)
 {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 35c390bedfba..4200856fefcd 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -123,6 +123,7 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_STOP_CB		7
 #define HT_AGG_STATE_SENT_ADDBA		8
 
+DECLARE_EWMA(avg_est_tp, 8, 16)
 DECLARE_EWMA(avg_signal, 10, 8)
 enum ieee80211_agg_stop_reason {
 	AGG_STOP_DECLINED,
@@ -157,6 +158,12 @@ void ieee80211_register_airtime(struct ieee80211_txq *txq,
 
 struct sta_info;
 
+void ieee80211_sta_update_tp(struct ieee80211_local *local,
+			     struct sta_info *sta,
+			     struct sk_buff *skb,
+			     u16 tx_time_est,
+			     bool ack, int retry);
+
 /**
  * struct tid_ampdu_tx - TID aggregation information (Tx).
  *
@@ -549,6 +556,8 @@ struct link_sta_info {
 		s8 last_ack_signal;
 		bool ack_signal_filled;
 		struct ewma_avg_signal avg_ack_signal;
+		struct ewma_avg_est_tp avg_est_tp;
+		unsigned long last_tp_update;
 	} status_stats;
 
 	/* Updated from TX path only, no locking requirements */
@@ -558,6 +567,8 @@ struct link_sta_info {
 		struct ieee80211_tx_rate last_rate;
 		struct rate_info last_rate_info;
 		u64 msdu[IEEE80211_NUM_TIDS + 1];
+		u64 tp_tx_size;
+		u64 tp_tx_time_est;
 	} tx_stats;
 
 	enum ieee80211_sta_rx_bandwidth cur_max_bandwidth;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e69272139437..1fb93abc1709 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -1152,6 +1152,8 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 	ack_signal_valid =
 		!!(info->status.flags & IEEE80211_TX_STATUS_ACK_SIGNAL_VALID);
 
+	ieee80211_sta_update_tp(local, sta, skb, tx_time_est, acked, retry_count);
+
 	if (pubsta) {
 		struct ieee80211_sub_if_data *sdata = sta->sdata;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c425f4fb7c2e..beb79b04c287 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3617,6 +3617,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
 	struct ieee80211_vif *vif = txq->vif;
+	struct rate_control_ref *ref = NULL;
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -3775,8 +3776,13 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 encap_out:
 	IEEE80211_SKB_CB(skb)->control.vif = vif;
 
+	if (tx.sta && test_sta_flag(tx.sta, WLAN_STA_RATE_CONTROL))
+		ref = tx.sta->rate_ctrl;
+
 	if (vif &&
-	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) {
+	    ((!local->ops->get_expected_throughput &&
+	     (!ref || !ref->ops->get_expected_throughput)) ||
+	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL))) {
 		bool ampdu = txq->ac != IEEE80211_AC_VO;
 		u32 airtime;
 
-- 
2.37.1


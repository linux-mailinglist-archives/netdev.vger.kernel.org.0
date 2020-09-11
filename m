Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1BB266737
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgIKRkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgIKRjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:39:04 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09A4C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:03 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id d21so2722461pjw.0
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=PC0wsYGP5bCg7zTGEyBEHK9+Hid1KNiLYNsAUdZy+KA=;
        b=h9rx7j0XxrVI/fqLNSCKyBKupfyJiDadWf4AMqW77Iv4EsG9ECx/JyL+U9PGQhKvdR
         +c3uRDz4jeWBpZI7BLoP25Qs1DisQsz2DguErMyJwRBZagUUi9jXYY62GekYGcyz7yGA
         VxS9oUeuwcEjOA8AWxocfvMlhYtfQzujA/RFfW9mGzQDIRsyOT/Ptn4KNyFQcIwWmhPE
         RTi/txDnqeHTViWDk9QJvyc2a2qRtwSwmAtTxU8Y4/AjmiYe2HCiqkmsY9whId0yL9jA
         xvQ3T51IftP/2KpJZny2qclJPkaTcxc/g8FCc09LWyytDLE+itwI4OmAMz5Q75cnM59q
         h3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PC0wsYGP5bCg7zTGEyBEHK9+Hid1KNiLYNsAUdZy+KA=;
        b=dXhgx/N3yX9Ypou7NEEJ6skmiQn0VEYpb7UUwyWfnC+WiXFvZTJZSKejK/3DFxGE6v
         h5Ki8XlX+JU+UVjYZlqExM7jqbeJqbvtrmEwuZxXS2F5RiXMJZRWHoR1T80kQvNfJTY1
         UwQTqP08Vg5Q8YwTYNDaj7cqToVaY4Jgl61Kr9BDOl9s2MHlk+BkYnzJGNiNe7z3mhzB
         x+u6ftFWgbzaBJyPsKdyaIbM1GCN5CBYrQow00peiinN8NMyzXCTEUUMTM5PNdkWBPqP
         vzn0HgQmgnP1ZdD+fAluVPzh4mmRLNPSblNVUPIK2JxWMOOZzbQFG6Xj2tjs+zJjrJcC
         Uoeg==
X-Gm-Message-State: AOAM531Pqo6kLZLs5eIPXQ4/2FPlGXMxt/UaYPgxAEdLTGbkVmdA4kjS
        rzHdAXHwlU2KhU4PGI6nTefvMa0oqSCQaR94YYtqVrSmzOOLi3eDjs6JTlON7AoOd6TYJXAFni2
        7TVTj/XfFBE+ns9siCDr7wGRulUV+yhLmwMqVku0QWtC08OJqrvUTgMqbqPY8zsfWSXHAyHaB
X-Google-Smtp-Source: ABdhPJxp6Lg+ZPbyEijEbOkSxKtDGC629sD5D38Po8pOW5GRYy8pb7tucR9Rabs1bNrqXjg6bL0E/G4BBjaWQW/L
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a62:2c8:0:b029:13e:9ee9:5b25 with SMTP
 id 191-20020a6202c80000b029013e9ee95b25mr3141180pfc.1.1599845943289; Fri, 11
 Sep 2020 10:39:03 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:38:48 -0700
In-Reply-To: <20200911173851.2149095-1-awogbemila@google.com>
Message-Id: <20200911173851.2149095-6-awogbemila@google.com>
Mime-Version: 1.0
References: <20200911173851.2149095-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next v4 5/8] gve: NIC stats for report-stats and for ethtool
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds per queue NIC stats to ethtool stats and to report-stats.
These stats are always exposed to guest whether or not the
report-stats flag is turned on.

Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  4 +
 drivers/net/ethernet/google/gve/gve_adminq.h  |  5 ++
 drivers/net/ethernet/google/gve/gve_ethtool.c | 84 ++++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_main.c    |  4 +-
 4 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 00697d5dcc27..ebb770f955e9 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -34,6 +34,10 @@
 /* Interval to schedule a stats report update, 20000ms. */
 #define GVE_STATS_REPORT_TIMER_PERIOD	20000
 
+/* Numbers of NIC tx/rx stats in stats report. */
+#define NIC_TX_STATS_REPORT_NUM	0
+#define NIC_RX_STATS_REPORT_NUM	4
+
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index b81a3bb76d5e..a6c8c29f0d13 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -205,6 +205,11 @@ enum gve_stat_names {
 	TX_LAST_COMPLETION_PROCESSED	= 5,
 	RX_NEXT_EXPECTED_SEQUENCE	= 6,
 	RX_BUFFERS_POSTED		= 7,
+	// stats from NIC
+	RX_QUEUE_DROP_CNT		= 65,
+	RX_NO_BUFFERS_POSTED		= 66,
+	RX_DROPS_PACKET_OVER_MRU	= 67,
+	RX_DROPS_INVALID_CHECKSUM	= 68,
 };
 
 union gve_adminq_command {
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 67239faa7554..c5bb8846fd26 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -43,6 +43,8 @@ static const char gve_gstrings_main_stats[][ETH_GSTRING_LEN] = {
 static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
 	"rx_posted_desc[%u]", "rx_completed_desc[%u]", "rx_bytes[%u]",
 	"rx_dropped_pkt[%u]", "rx_copybreak_pkt[%u]", "rx_copied_pkt[%u]",
+	"rx_queue_drop_cnt[%u]", "rx_no_buffers_posted[%u]",
+	"rx_drops_packet_over_mru[%u]", "rx_drops_invalid_checksum[%u]",
 };
 
 static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] = {
@@ -138,14 +140,30 @@ gve_get_ethtool_stats(struct net_device *netdev,
 		tmp_rx_desc_err_dropped_pkt, tmp_tx_pkts, tmp_tx_bytes;
 	u64 rx_buf_alloc_fail, rx_desc_err_dropped_pkt, rx_pkts,
 		rx_skb_alloc_fail, rx_bytes, tx_pkts, tx_bytes;
+	int stats_idx, base_stats_idx, max_stats_idx;
+	struct stats *report_stats;
+	int *rx_qid_to_stats_idx;
+	int *tx_qid_to_stats_idx;
 	struct gve_priv *priv;
+	bool skip_nic_stats;
 	unsigned int start;
 	int ring;
-	int i;
+	int i, j;
 
 	ASSERT_RTNL();
 
 	priv = netdev_priv(netdev);
+	report_stats = priv->stats_report->stats;
+	rx_qid_to_stats_idx = kmalloc_array(priv->rx_cfg.num_queues,
+					    sizeof(int), GFP_KERNEL);
+	if (!rx_qid_to_stats_idx)
+		return;
+	tx_qid_to_stats_idx = kmalloc_array(priv->tx_cfg.num_queues,
+					    sizeof(int), GFP_KERNEL);
+	if (!tx_qid_to_stats_idx) {
+		kfree(rx_qid_to_stats_idx);
+		return;
+	}
 	for (rx_pkts = 0, rx_bytes = 0, rx_skb_alloc_fail = 0,
 	     rx_buf_alloc_fail = 0, rx_desc_err_dropped_pkt = 0, ring = 0;
 	     ring < priv->rx_cfg.num_queues; ring++) {
@@ -208,6 +226,25 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = priv->stats_report_trigger_cnt;
 	i = GVE_MAIN_STATS_LEN;
 
+	/* For rx cross-reporting stats, start from nic rx stats in report */
+	base_stats_idx = GVE_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
+		GVE_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues;
+	max_stats_idx = NIC_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues +
+		base_stats_idx;
+	/* Preprocess the stats report for rx, map queue id to start index */
+	skip_nic_stats = false;
+	for (stats_idx = base_stats_idx; stats_idx < max_stats_idx;
+		stats_idx += NIC_RX_STATS_REPORT_NUM) {
+		u32 stat_name = be32_to_cpu(report_stats[stats_idx].stat_name);
+		u32 queue_id = be32_to_cpu(report_stats[stats_idx].queue_id);
+
+		if (stat_name == 0) {
+			/* no stats written by NIC yet */
+			skip_nic_stats = true;
+			break;
+		}
+		rx_qid_to_stats_idx[queue_id] = stats_idx;
+	}
 	/* walk RX rings */
 	if (priv->rx) {
 		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
@@ -232,10 +269,41 @@ gve_get_ethtool_stats(struct net_device *netdev,
 				tmp_rx_desc_err_dropped_pkt;
 			data[i++] = rx->rx_copybreak_pkt;
 			data[i++] = rx->rx_copied_pkt;
+			/* stats from NIC */
+			if (skip_nic_stats) {
+				/* skip NIC rx stats */
+				i += NIC_RX_STATS_REPORT_NUM;
+				continue;
+			}
+			for (j = 0; j < NIC_RX_STATS_REPORT_NUM; j++) {
+				u64 value =
+				be64_to_cpu(report_stats[rx_qid_to_stats_idx[ring] + j].value);
+
+				data[i++] = value;
+			}
 		}
 	} else {
 		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
 	}
+
+	/* For tx cross-reporting stats, start from nic tx stats in report */
+	base_stats_idx = max_stats_idx;
+	max_stats_idx = NIC_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
+		max_stats_idx;
+	/* Preprocess the stats report for tx, map queue id to start index */
+	skip_nic_stats = false;
+	for (stats_idx = base_stats_idx; stats_idx < max_stats_idx;
+		stats_idx += NIC_TX_STATS_REPORT_NUM) {
+		u32 stat_name = be32_to_cpu(report_stats[stats_idx].stat_name);
+		u32 queue_id = be32_to_cpu(report_stats[stats_idx].queue_id);
+
+		if (stat_name == 0) {
+			/* no stats written by NIC yet */
+			skip_nic_stats = true;
+			break;
+		}
+		tx_qid_to_stats_idx[queue_id] = stats_idx;
+	}
 	/* walk TX rings */
 	if (priv->tx) {
 		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
@@ -254,10 +322,24 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			data[i++] = tx->stop_queue;
 			data[i++] = be32_to_cpu(gve_tx_load_event_counter(priv,
 									  tx));
+			/* stats from NIC */
+			if (skip_nic_stats) {
+				/* skip NIC tx stats */
+				i += NIC_TX_STATS_REPORT_NUM;
+				continue;
+			}
+			for (j = 0; j < NIC_TX_STATS_REPORT_NUM; j++) {
+				u64 value =
+				be64_to_cpu(report_stats[tx_qid_to_stats_idx[ring] + j].value);
+				data[i++] = value;
+			}
 		}
 	} else {
 		i += priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS;
 	}
+
+	kfree(rx_qid_to_stats_idx);
+	kfree(tx_qid_to_stats_idx);
 	/* AQ Stats */
 	data[i++] = priv->adminq_prod_cnt;
 	data[i++] = priv->adminq_cmd_fail;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 936ff4c9d250..7c5a11356b1c 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -112,9 +112,9 @@ static int gve_alloc_stats_report(struct gve_priv *priv)
 {
 	int tx_stats_num, rx_stats_num;
 
-	tx_stats_num = (GVE_TX_STATS_REPORT_NUM) *
+	tx_stats_num = (GVE_TX_STATS_REPORT_NUM + NIC_TX_STATS_REPORT_NUM) *
 		       priv->tx_cfg.num_queues;
-	rx_stats_num = (GVE_RX_STATS_REPORT_NUM) *
+	rx_stats_num = (GVE_RX_STATS_REPORT_NUM + NIC_RX_STATS_REPORT_NUM) *
 		       priv->rx_cfg.num_queues;
 	priv->stats_report_len = sizeof(struct gve_stats_report) +
 				 (tx_stats_num + rx_stats_num) *
-- 
2.28.0.618.gf4bc123cb7-goog


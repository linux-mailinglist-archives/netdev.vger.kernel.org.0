Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3F51CE9E8
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgELBAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 21:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbgELBAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 21:00:00 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CE7C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 18:00:00 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q24so8582680pjd.1
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 18:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TeAy/odTSSVNV2s00Q7OVoroSESR2zSM9aJXbAlfp6o=;
        b=cIk0SrMpuuPcFWJlGpbBzA15F48kw58imMVfzzxzwvlZvqBoMYQHwI2BAkDogw+VZI
         bRYUiygM8Jlb7V69DIDJo7GxxuadDam4TWOXz0cSUJs76Z7E57Bn9kTMdU+C53SROIe0
         h2WZuJfGSi85goKO8Z6mPWjrM41GKZgikwZkrWT0+x125OplTDHbCSiuLCT3DV1Vbsdo
         vc3sd96RLXvgFZ7OhjBplOn1s5bQG8jh+MQFkvv5G16k/q9+3LZgg9eVHTuBERAlzRFV
         yeODQjjDkw2+cIunw93iQmg804cLviD9GvjHj2SdJG3p3W+EVI4SSDAh6pDdQI+a7qwK
         3cBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TeAy/odTSSVNV2s00Q7OVoroSESR2zSM9aJXbAlfp6o=;
        b=ccXA8NWNs+I+qBIPpHZtjk+xl/VN+hEU3m80GH7n32qvJhmZAmeTU161s5lfI/+K1X
         x6s+DL0IDenjc66GNo07P6yUOvcp6UKp4YuRG35alUEp8U6WPKr5SQZEuywJC6xPDd6k
         XzulOTXlRjSfNZ4yOpabWq37F/X6RmC5EUtHcvhszKUEY5uAZ3IXkMURNOv0UvpvSzI4
         9EGLDxof8qBuuUGqTFb6VwdNk0du4D2P7z9J5JgOuMpEL9uZYES0WqaAsbCJQfuqwzIi
         W4pp9EVh2FbFWR3vxeC9vJx5aNnfjf9OmfOTJXZzYknoMWw3WmIdcg7oEfYe2YmvNtSR
         8ZOQ==
X-Gm-Message-State: AGi0PuaquAUY9BkXkQrB3vXYHtoRTOuDLFGzsbrdw44vSM7pEe+Ii/I3
        frK2CrL4w/sXpQdo8vloOglBoS4HKzA=
X-Google-Smtp-Source: APiQypLs69oUVCIylY5t8czg3YdJuMmy5H8uQTbXaf90CLgcK+j7wokqKSrKnIThW7vyb51o8JF6lQ==
X-Received: by 2002:a17:90a:c293:: with SMTP id f19mr23506516pjt.96.1589245199608;
        Mon, 11 May 2020 17:59:59 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h17sm10171477pfk.13.2020.05.11.17.59.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:59:58 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 09/10] ionic: add more ethtool stats
Date:   Mon, 11 May 2020 17:59:35 -0700
Message-Id: <20200512005936.14490-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512005936.14490-1-snelson@pensando.io>
References: <20200512005936.14490-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add hardware port stats and a few more driver collected
statistics to the ethtool stats output.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  15 +-
 .../net/ethernet/pensando/ionic/ionic_stats.c | 136 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_stats.h |   6 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  22 ++-
 5 files changed, 170 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4da94c07d1d3..80b4d8332109 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -792,8 +792,8 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	return max(n_work, a_work);
 }
 
-static void ionic_get_stats64(struct net_device *netdev,
-			      struct rtnl_link_stats64 *ns)
+void ionic_get_stats64(struct net_device *netdev,
+		       struct rtnl_link_stats64 *ns)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_lif_stats *ls;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 1a30f0fb20b9..c3428034a17b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -20,11 +20,13 @@ struct ionic_tx_stats {
 	u64 bytes;
 	u64 clean;
 	u64 linearize;
-	u64 no_csum;
+	u64 csum_none;
 	u64 csum;
 	u64 crc32_csum;
 	u64 tso;
+	u64 tso_bytes;
 	u64 frags;
+	u64 vlan_inserted;
 	u64 sg_cntr[IONIC_MAX_NUM_SG_CNTR];
 };
 
@@ -38,6 +40,7 @@ struct ionic_rx_stats {
 	u64 csum_error;
 	u64 buffers_posted;
 	u64 dropped;
+	u64 vlan_stripped;
 };
 
 #define IONIC_QCQ_F_INITED		BIT(0)
@@ -114,11 +117,17 @@ struct ionic_lif_sw_stats {
 	u64 rx_packets;
 	u64 rx_bytes;
 	u64 tx_tso;
-	u64 tx_no_csum;
+	u64 tx_tso_bytes;
+	u64 tx_csum_none;
 	u64 tx_csum;
 	u64 rx_csum_none;
 	u64 rx_csum_complete;
 	u64 rx_csum_error;
+	u64 hw_tx_dropped;
+	u64 hw_rx_dropped;
+	u64 hw_rx_over_errors;
+	u64 hw_rx_missed_errors;
+	u64 hw_tx_aborted_errors;
 };
 
 enum ionic_lif_state_flags {
@@ -240,6 +249,8 @@ static inline u32 ionic_coal_hw_to_usec(struct ionic *ionic, u32 units)
 }
 
 void ionic_link_status_check_request(struct ionic_lif *lif);
+void ionic_get_stats64(struct net_device *netdev,
+		       struct rtnl_link_stats64 *ns);
 void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
 				struct ionic_deferred_work *work);
 int ionic_lifs_alloc(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index 8f2a8fb029f1..2a1885da58a6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -15,11 +15,109 @@ static const struct ionic_stat_desc ionic_lif_stats_desc[] = {
 	IONIC_LIF_STAT_DESC(rx_packets),
 	IONIC_LIF_STAT_DESC(rx_bytes),
 	IONIC_LIF_STAT_DESC(tx_tso),
-	IONIC_LIF_STAT_DESC(tx_no_csum),
+	IONIC_LIF_STAT_DESC(tx_tso_bytes),
+	IONIC_LIF_STAT_DESC(tx_csum_none),
 	IONIC_LIF_STAT_DESC(tx_csum),
 	IONIC_LIF_STAT_DESC(rx_csum_none),
 	IONIC_LIF_STAT_DESC(rx_csum_complete),
 	IONIC_LIF_STAT_DESC(rx_csum_error),
+	IONIC_LIF_STAT_DESC(hw_tx_dropped),
+	IONIC_LIF_STAT_DESC(hw_rx_dropped),
+	IONIC_LIF_STAT_DESC(hw_rx_over_errors),
+	IONIC_LIF_STAT_DESC(hw_rx_missed_errors),
+	IONIC_LIF_STAT_DESC(hw_tx_aborted_errors),
+};
+
+static const struct ionic_stat_desc ionic_port_stats_desc[] = {
+	IONIC_PORT_STAT_DESC(frames_rx_ok),
+	IONIC_PORT_STAT_DESC(frames_rx_all),
+	IONIC_PORT_STAT_DESC(frames_rx_bad_fcs),
+	IONIC_PORT_STAT_DESC(frames_rx_bad_all),
+	IONIC_PORT_STAT_DESC(octets_rx_ok),
+	IONIC_PORT_STAT_DESC(octets_rx_all),
+	IONIC_PORT_STAT_DESC(frames_rx_unicast),
+	IONIC_PORT_STAT_DESC(frames_rx_multicast),
+	IONIC_PORT_STAT_DESC(frames_rx_broadcast),
+	IONIC_PORT_STAT_DESC(frames_rx_pause),
+	IONIC_PORT_STAT_DESC(frames_rx_bad_length),
+	IONIC_PORT_STAT_DESC(frames_rx_undersized),
+	IONIC_PORT_STAT_DESC(frames_rx_oversized),
+	IONIC_PORT_STAT_DESC(frames_rx_fragments),
+	IONIC_PORT_STAT_DESC(frames_rx_jabber),
+	IONIC_PORT_STAT_DESC(frames_rx_pripause),
+	IONIC_PORT_STAT_DESC(frames_rx_stomped_crc),
+	IONIC_PORT_STAT_DESC(frames_rx_too_long),
+	IONIC_PORT_STAT_DESC(frames_rx_vlan_good),
+	IONIC_PORT_STAT_DESC(frames_rx_dropped),
+	IONIC_PORT_STAT_DESC(frames_rx_less_than_64b),
+	IONIC_PORT_STAT_DESC(frames_rx_64b),
+	IONIC_PORT_STAT_DESC(frames_rx_65b_127b),
+	IONIC_PORT_STAT_DESC(frames_rx_128b_255b),
+	IONIC_PORT_STAT_DESC(frames_rx_256b_511b),
+	IONIC_PORT_STAT_DESC(frames_rx_512b_1023b),
+	IONIC_PORT_STAT_DESC(frames_rx_1024b_1518b),
+	IONIC_PORT_STAT_DESC(frames_rx_1519b_2047b),
+	IONIC_PORT_STAT_DESC(frames_rx_2048b_4095b),
+	IONIC_PORT_STAT_DESC(frames_rx_4096b_8191b),
+	IONIC_PORT_STAT_DESC(frames_rx_8192b_9215b),
+	IONIC_PORT_STAT_DESC(frames_rx_other),
+	IONIC_PORT_STAT_DESC(frames_tx_ok),
+	IONIC_PORT_STAT_DESC(frames_tx_all),
+	IONIC_PORT_STAT_DESC(frames_tx_bad),
+	IONIC_PORT_STAT_DESC(octets_tx_ok),
+	IONIC_PORT_STAT_DESC(octets_tx_total),
+	IONIC_PORT_STAT_DESC(frames_tx_unicast),
+	IONIC_PORT_STAT_DESC(frames_tx_multicast),
+	IONIC_PORT_STAT_DESC(frames_tx_broadcast),
+	IONIC_PORT_STAT_DESC(frames_tx_pause),
+	IONIC_PORT_STAT_DESC(frames_tx_pripause),
+	IONIC_PORT_STAT_DESC(frames_tx_vlan),
+	IONIC_PORT_STAT_DESC(frames_tx_less_than_64b),
+	IONIC_PORT_STAT_DESC(frames_tx_64b),
+	IONIC_PORT_STAT_DESC(frames_tx_65b_127b),
+	IONIC_PORT_STAT_DESC(frames_tx_128b_255b),
+	IONIC_PORT_STAT_DESC(frames_tx_256b_511b),
+	IONIC_PORT_STAT_DESC(frames_tx_512b_1023b),
+	IONIC_PORT_STAT_DESC(frames_tx_1024b_1518b),
+	IONIC_PORT_STAT_DESC(frames_tx_1519b_2047b),
+	IONIC_PORT_STAT_DESC(frames_tx_2048b_4095b),
+	IONIC_PORT_STAT_DESC(frames_tx_4096b_8191b),
+	IONIC_PORT_STAT_DESC(frames_tx_8192b_9215b),
+	IONIC_PORT_STAT_DESC(frames_tx_other),
+	IONIC_PORT_STAT_DESC(frames_tx_pri_0),
+	IONIC_PORT_STAT_DESC(frames_tx_pri_1),
+	IONIC_PORT_STAT_DESC(frames_tx_pri_2),
+	IONIC_PORT_STAT_DESC(frames_tx_pri_3),
+	IONIC_PORT_STAT_DESC(frames_tx_pri_4),
+	IONIC_PORT_STAT_DESC(frames_tx_pri_5),
+	IONIC_PORT_STAT_DESC(frames_tx_pri_6),
+	IONIC_PORT_STAT_DESC(frames_tx_pri_7),
+	IONIC_PORT_STAT_DESC(frames_rx_pri_0),
+	IONIC_PORT_STAT_DESC(frames_rx_pri_1),
+	IONIC_PORT_STAT_DESC(frames_rx_pri_2),
+	IONIC_PORT_STAT_DESC(frames_rx_pri_3),
+	IONIC_PORT_STAT_DESC(frames_rx_pri_4),
+	IONIC_PORT_STAT_DESC(frames_rx_pri_5),
+	IONIC_PORT_STAT_DESC(frames_rx_pri_6),
+	IONIC_PORT_STAT_DESC(frames_rx_pri_7),
+	IONIC_PORT_STAT_DESC(tx_pripause_0_1us_count),
+	IONIC_PORT_STAT_DESC(tx_pripause_1_1us_count),
+	IONIC_PORT_STAT_DESC(tx_pripause_2_1us_count),
+	IONIC_PORT_STAT_DESC(tx_pripause_3_1us_count),
+	IONIC_PORT_STAT_DESC(tx_pripause_4_1us_count),
+	IONIC_PORT_STAT_DESC(tx_pripause_5_1us_count),
+	IONIC_PORT_STAT_DESC(tx_pripause_6_1us_count),
+	IONIC_PORT_STAT_DESC(tx_pripause_7_1us_count),
+	IONIC_PORT_STAT_DESC(rx_pripause_0_1us_count),
+	IONIC_PORT_STAT_DESC(rx_pripause_1_1us_count),
+	IONIC_PORT_STAT_DESC(rx_pripause_2_1us_count),
+	IONIC_PORT_STAT_DESC(rx_pripause_3_1us_count),
+	IONIC_PORT_STAT_DESC(rx_pripause_4_1us_count),
+	IONIC_PORT_STAT_DESC(rx_pripause_5_1us_count),
+	IONIC_PORT_STAT_DESC(rx_pripause_6_1us_count),
+	IONIC_PORT_STAT_DESC(rx_pripause_7_1us_count),
+	IONIC_PORT_STAT_DESC(rx_pause_1us_count),
+	IONIC_PORT_STAT_DESC(frames_tx_truncated),
 };
 
 static const struct ionic_stat_desc ionic_tx_stats_desc[] = {
@@ -29,6 +127,11 @@ static const struct ionic_stat_desc ionic_tx_stats_desc[] = {
 	IONIC_TX_STAT_DESC(dma_map_err),
 	IONIC_TX_STAT_DESC(linearize),
 	IONIC_TX_STAT_DESC(frags),
+	IONIC_TX_STAT_DESC(tso),
+	IONIC_TX_STAT_DESC(tso_bytes),
+	IONIC_TX_STAT_DESC(csum_none),
+	IONIC_TX_STAT_DESC(csum),
+	IONIC_TX_STAT_DESC(vlan_inserted),
 };
 
 static const struct ionic_stat_desc ionic_rx_stats_desc[] = {
@@ -40,6 +143,7 @@ static const struct ionic_stat_desc ionic_rx_stats_desc[] = {
 	IONIC_RX_STAT_DESC(csum_complete),
 	IONIC_RX_STAT_DESC(csum_error),
 	IONIC_RX_STAT_DESC(dropped),
+	IONIC_RX_STAT_DESC(vlan_stripped),
 };
 
 static const struct ionic_stat_desc ionic_txq_stats_desc[] = {
@@ -62,6 +166,7 @@ static const struct ionic_stat_desc ionic_dbg_napi_stats_desc[] = {
 };
 
 #define IONIC_NUM_LIF_STATS ARRAY_SIZE(ionic_lif_stats_desc)
+#define IONIC_NUM_PORT_STATS ARRAY_SIZE(ionic_port_stats_desc)
 #define IONIC_NUM_TX_STATS ARRAY_SIZE(ionic_tx_stats_desc)
 #define IONIC_NUM_RX_STATS ARRAY_SIZE(ionic_rx_stats_desc)
 #define IONIC_NUM_TX_Q_STATS ARRAY_SIZE(ionic_txq_stats_desc)
@@ -76,6 +181,7 @@ static void ionic_get_lif_stats(struct ionic_lif *lif,
 {
 	struct ionic_tx_stats *tstats;
 	struct ionic_rx_stats *rstats;
+	struct rtnl_link_stats64 ns;
 	struct ionic_qcq *txqcq;
 	struct ionic_qcq *rxqcq;
 	int q_num;
@@ -89,7 +195,8 @@ static void ionic_get_lif_stats(struct ionic_lif *lif,
 			stats->tx_packets += tstats->pkts;
 			stats->tx_bytes += tstats->bytes;
 			stats->tx_tso += tstats->tso;
-			stats->tx_no_csum += tstats->no_csum;
+			stats->tx_tso_bytes += tstats->tso_bytes;
+			stats->tx_csum_none += tstats->csum_none;
 			stats->tx_csum += tstats->csum;
 		}
 
@@ -103,6 +210,13 @@ static void ionic_get_lif_stats(struct ionic_lif *lif,
 			stats->rx_csum_error += rstats->csum_error;
 		}
 	}
+
+	ionic_get_stats64(lif->netdev, &ns);
+	stats->hw_tx_dropped = ns.tx_dropped;
+	stats->hw_rx_dropped = ns.rx_dropped;
+	stats->hw_rx_over_errors = ns.rx_over_errors;
+	stats->hw_rx_missed_errors = ns.rx_missed_errors;
+	stats->hw_tx_aborted_errors = ns.tx_aborted_errors;
 }
 
 static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
@@ -118,6 +232,9 @@ static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
 	/* rx stats */
 	total += MAX_Q(lif) * IONIC_NUM_RX_STATS;
 
+	/* port stats */
+	total += IONIC_NUM_PORT_STATS;
+
 	if (test_bit(IONIC_LIF_F_UP, lif->state) &&
 	    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
 		/* tx debug stats */
@@ -144,6 +261,13 @@ static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
 		snprintf(*buf, ETH_GSTRING_LEN, ionic_lif_stats_desc[i].name);
 		*buf += ETH_GSTRING_LEN;
 	}
+
+	for (i = 0; i < IONIC_NUM_PORT_STATS; i++) {
+		snprintf(*buf, ETH_GSTRING_LEN,
+			 ionic_port_stats_desc[i].name);
+		*buf += ETH_GSTRING_LEN;
+	}
+
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
 		for (i = 0; i < IONIC_NUM_TX_STATS; i++) {
 			snprintf(*buf, ETH_GSTRING_LEN, "tx_%d_%s",
@@ -225,6 +349,7 @@ static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
 
 static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 {
+	struct ionic_port_stats *port_stats;
 	struct ionic_lif_sw_stats lif_stats;
 	struct ionic_qcq *txqcq, *rxqcq;
 	struct ionic_tx_stats *txstats;
@@ -238,6 +363,13 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 		(*buf)++;
 	}
 
+	port_stats = &lif->ionic->idev.port_info->stats;
+	for (i = 0; i < IONIC_NUM_PORT_STATS; i++) {
+		**buf = IONIC_READ_STAT_LE64(port_stats,
+					     &ionic_port_stats_desc[i]);
+		(*buf)++;
+	}
+
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
 		txstats = &lif_to_txstats(lif, q_num);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.h b/drivers/net/ethernet/pensando/ionic/ionic_stats.h
index d2c1122a2c6e..3f543512616e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.h
@@ -11,6 +11,9 @@
 	.offset = IONIC_STAT_TO_OFFSET(type, stat_name) \
 }
 
+#define IONIC_PORT_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct ionic_port_stats, stat_name)
+
 #define IONIC_LIF_STAT_DESC(stat_name) \
 	IONIC_STAT_DESC(struct ionic_lif_sw_stats, stat_name)
 
@@ -45,6 +48,9 @@ extern const int ionic_num_stats_grps;
 #define IONIC_READ_STAT64(base_ptr, desc_ptr) \
 	(*((u64 *)(((u8 *)(base_ptr)) + (desc_ptr)->offset)))
 
+#define IONIC_READ_STAT_LE64(base_ptr, desc_ptr) \
+	__le64_to_cpu(*((u64 *)(((u8 *)(base_ptr)) + (desc_ptr)->offset)))
+
 struct ionic_stat_desc {
 	char name[ETH_GSTRING_LEN];
 	u64 offset;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 6b14e55a6780..b7f900c11834 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -214,10 +214,11 @@ static void ionic_rx_clean(struct ionic_queue *q,
 		     (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_IP_BAD)))
 		stats->csum_error++;
 
-	if (likely(netdev->features & NETIF_F_HW_VLAN_CTAG_RX)) {
-		if (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_VLAN)
-			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-					       le16_to_cpu(comp->vlan_tci));
+	if (likely(netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	    (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_VLAN)) {
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+				       le16_to_cpu(comp->vlan_tci));
+		stats->vlan_stripped++;
 	}
 
 	if (le16_to_cpu(comp->len) <= q->lif->rx_copybreak)
@@ -860,6 +861,7 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 	stats->pkts += total_pkts;
 	stats->bytes += total_bytes;
 	stats->tso++;
+	stats->tso_bytes += total_bytes;
 
 	return 0;
 
@@ -898,9 +900,12 @@ static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb)
 				  flags, skb_shinfo(skb)->nr_frags, dma_addr);
 	desc->cmd = cpu_to_le64(cmd);
 	desc->len = cpu_to_le16(skb_headlen(skb));
-	desc->vlan_tci = cpu_to_le16(skb_vlan_tag_get(skb));
 	desc->csum_start = cpu_to_le16(skb_checksum_start_offset(skb));
 	desc->csum_offset = cpu_to_le16(skb->csum_offset);
+	if (has_vlan) {
+		desc->vlan_tci = cpu_to_le16(skb_vlan_tag_get(skb));
+		stats->vlan_inserted++;
+	}
 
 	if (skb->csum_not_inet)
 		stats->crc32_csum++;
@@ -935,9 +940,12 @@ static int ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb)
 				  flags, skb_shinfo(skb)->nr_frags, dma_addr);
 	desc->cmd = cpu_to_le64(cmd);
 	desc->len = cpu_to_le16(skb_headlen(skb));
-	desc->vlan_tci = cpu_to_le16(skb_vlan_tag_get(skb));
+	if (has_vlan) {
+		desc->vlan_tci = cpu_to_le16(skb_vlan_tag_get(skb));
+		stats->vlan_inserted++;
+	}
 
-	stats->no_csum++;
+	stats->csum_none++;
 
 	return 0;
 }
-- 
2.17.1


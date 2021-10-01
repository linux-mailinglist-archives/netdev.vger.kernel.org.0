Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCE241F337
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355144AbhJARkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353627AbhJARkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:40:12 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01569C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 10:38:28 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k23so7059108pji.0
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 10:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5xC/opR6TpRG59ZcmZ0wjKfnqJYC3L4YtiZ0U/2bQ8Y=;
        b=5DkocTl3hC93kfwnssI0wr2kPYvPpPvTcMPldIdSk+yviGJe5F0KLrsCbsmodjvB1y
         wYEFuSIi8ABzrG5i+u9bkWcydqcLbs3SX+JSGFkS8fC8u1Nkug25VJhT6fmKvuHiJfV6
         arp8Qc7zjK66yppfgd7nAywqAmXmS/OvluwlfpmOmn83sRZxJlpEicmQn2cX/f3J/cf5
         4Yi4wFVu15NuEWrSLstmIa8k0aPTQvzOtDGZUjQ5EpJ1x1IGyeVQasjoDvCH4xrOGYy7
         YjDTdFIrpmTDSmMMYuyJLdgimlLgdgSmsVyOckHCnFKFAwMILWQGAf6iTEIYHGTHeGKX
         IJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5xC/opR6TpRG59ZcmZ0wjKfnqJYC3L4YtiZ0U/2bQ8Y=;
        b=LwVuRjuTgLF/Ta/nLpDbwKm70n2AUCWBNbOT/dP+jYmypCoKteVw2Im6TgjF47pZ+b
         cwon1OHPVp5lO7i8ysOV6hsE5j7LWhZDd6D/71e0Xi0Bs+7o881Ua8PLqFVrj9/IK8Ft
         7JwwDMSiZqq4tts+I9mpmHf+lgPIg/PTey8TaTSb8AfoSfNjTLokgSI9Jla/M4Wc5kqB
         vkCD+qPQA7ZR2+nM6H+TxZzsUF5ErgiXM976On959YYYbsofhhSTgLUHgqGGiPW8jqVm
         crBb/LGU6VLxJYuKYfxfmbmLGvD04CxbWCS6p+sHuzxnYd2glbGuIQo3sihshmVQDJ0E
         HqqA==
X-Gm-Message-State: AOAM532+KyB4Y+4jEePLvoHfnIASXZQYXPFbuNVkOx45vV/ak4uQFDF/
        OxvQQ5NmJpNv+vedJPP4YzGOJszNpRn3kQ==
X-Google-Smtp-Source: ABdhPJxccpQh7PajMwsdbVqQXhbcpTJe7lvDmW2W9+TW5bpnf6Meyeg/ci6k9VV/xY+S9HnYET+qLQ==
X-Received: by 2002:a17:90a:fc1:: with SMTP id 59mr21254406pjz.233.1633109907463;
        Fri, 01 Oct 2021 10:38:27 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 26sm7854462pgx.72.2021.10.01.10.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:38:27 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/7] ionic: remove debug stats
Date:   Fri,  1 Oct 2021 10:37:52 -0700
Message-Id: <20211001173758.22072-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001173758.22072-1-snelson@pensando.io>
References: <20211001173758.22072-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These debug stats are not really useful, their collection is
likely detrimental to performance, and they suck up a lot
of memory which never gets used if no one ever enables the
priv-flag to print them, so just remove these bits.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_debugfs.c   |   2 -
 .../net/ethernet/pensando/ionic/ionic_dev.c   |   1 -
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   4 -
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  38 -----
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  45 ------
 .../net/ethernet/pensando/ionic/ionic_stats.c | 130 ------------------
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  14 --
 7 files changed, 234 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index 39f59849720d..86b79430c2ad 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -143,8 +143,6 @@ void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	debugfs_create_u32("qid", 0400, q_dentry, &q->hw_index);
 	debugfs_create_u32("qtype", 0400, q_dentry, &q->hw_type);
 	debugfs_create_u64("drop", 0400, q_dentry, &q->drop);
-	debugfs_create_u64("stop", 0400, q_dentry, &q->stop);
-	debugfs_create_u64("wake", 0400, q_dentry, &q->wake);
 
 	debugfs_create_file("tail", 0400, q_dentry, q, &q_tail_fops);
 	debugfs_create_file("head", 0400, q_dentry, q, &q_head_fops);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 0d6858ab511c..d57e80d44c9d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -581,7 +581,6 @@ unsigned int ionic_cq_service(struct ionic_cq *cq, unsigned int work_to_do,
 			cq->done_color = !cq->done_color;
 		cq->tail_idx = (cq->tail_idx + 1) & (cq->num_descs - 1);
 		cq_info = &cq->info[cq->tail_idx];
-		DEBUG_STATS_CQE_CNT(cq);
 
 		if (++work_done >= work_to_do)
 			break;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 8311086fb1f4..e5acf3bd62b2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -220,9 +220,6 @@ struct ionic_queue {
 	unsigned int num_descs;
 	unsigned int max_sg_elems;
 	u64 features;
-	u64 dbell_count;
-	u64 stop;
-	u64 wake;
 	u64 drop;
 	struct ionic_dev *idev;
 	unsigned int type;
@@ -269,7 +266,6 @@ struct ionic_cq {
 	bool done_color;
 	unsigned int num_descs;
 	unsigned int desc_size;
-	u64 compl_count;
 	void *base;
 	dma_addr_t base_pa;
 } ____cacheline_aligned_in_smp;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 3de1a03839e2..6b45cae39a20 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -11,13 +11,6 @@
 #include "ionic_ethtool.h"
 #include "ionic_stats.h"
 
-static const char ionic_priv_flags_strings[][ETH_GSTRING_LEN] = {
-#define IONIC_PRIV_F_SW_DBG_STATS	BIT(0)
-	"sw-dbg-stats",
-};
-
-#define IONIC_PRIV_FLAGS_COUNT ARRAY_SIZE(ionic_priv_flags_strings)
-
 static void ionic_get_stats_strings(struct ionic_lif *lif, u8 *buf)
 {
 	u32 i;
@@ -59,9 +52,6 @@ static int ionic_get_sset_count(struct net_device *netdev, int sset)
 	case ETH_SS_STATS:
 		count = ionic_get_stats_count(lif);
 		break;
-	case ETH_SS_PRIV_FLAGS:
-		count = IONIC_PRIV_FLAGS_COUNT;
-		break;
 	}
 	return count;
 }
@@ -75,10 +65,6 @@ static void ionic_get_strings(struct net_device *netdev,
 	case ETH_SS_STATS:
 		ionic_get_stats_strings(lif, buf);
 		break;
-	case ETH_SS_PRIV_FLAGS:
-		memcpy(buf, ionic_priv_flags_strings,
-		       IONIC_PRIV_FLAGS_COUNT * ETH_GSTRING_LEN);
-		break;
 	}
 }
 
@@ -691,28 +677,6 @@ static int ionic_set_channels(struct net_device *netdev,
 	return err;
 }
 
-static u32 ionic_get_priv_flags(struct net_device *netdev)
-{
-	struct ionic_lif *lif = netdev_priv(netdev);
-	u32 priv_flags = 0;
-
-	if (test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
-		priv_flags |= IONIC_PRIV_F_SW_DBG_STATS;
-
-	return priv_flags;
-}
-
-static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
-{
-	struct ionic_lif *lif = netdev_priv(netdev);
-
-	clear_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state);
-	if (priv_flags & IONIC_PRIV_F_SW_DBG_STATS)
-		set_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state);
-
-	return 0;
-}
-
 static int ionic_get_rxnfc(struct net_device *netdev,
 			   struct ethtool_rxnfc *info, u32 *rules)
 {
@@ -1013,8 +977,6 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_strings		= ionic_get_strings,
 	.get_ethtool_stats	= ionic_get_stats,
 	.get_sset_count		= ionic_get_sset_count,
-	.get_priv_flags		= ionic_get_priv_flags,
-	.set_priv_flags		= ionic_set_priv_flags,
 	.get_rxnfc		= ionic_get_rxnfc,
 	.get_rxfh_indir_size	= ionic_get_rxfh_indir_size,
 	.get_rxfh_key_size	= ionic_get_rxfh_key_size,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 4915184f3efb..41f28154745f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -14,9 +14,6 @@
 #define IONIC_ADMINQ_LENGTH	16	/* must be a power of two */
 #define IONIC_NOTIFYQ_LENGTH	64	/* must be a power of two */
 
-#define IONIC_MAX_NUM_NAPI_CNTR		(NAPI_POLL_WEIGHT + 1)
-#define IONIC_MAX_NUM_SG_CNTR		(IONIC_TX_MAX_SG_ELEMS + 1)
-
 #define ADD_ADDR	true
 #define DEL_ADDR	false
 #define CAN_SLEEP	true
@@ -37,7 +34,6 @@ struct ionic_tx_stats {
 	u64 clean;
 	u64 linearize;
 	u64 crc32_csum;
-	u64 sg_cntr[IONIC_MAX_NUM_SG_CNTR];
 	u64 dma_map_err;
 	u64 hwstamp_valid;
 	u64 hwstamp_invalid;
@@ -48,7 +44,6 @@ struct ionic_rx_stats {
 	u64 bytes;
 	u64 csum_none;
 	u64 csum_complete;
-	u64 buffers_posted;
 	u64 dropped;
 	u64 vlan_stripped;
 	u64 csum_error;
@@ -65,11 +60,6 @@ struct ionic_rx_stats {
 #define IONIC_QCQ_F_RX_STATS		BIT(4)
 #define IONIC_QCQ_F_NOTIFYQ		BIT(5)
 
-struct ionic_napi_stats {
-	u64 poll_count;
-	u64 work_done_cntr[IONIC_MAX_NUM_NAPI_CNTR];
-};
-
 struct ionic_qcq {
 	void *q_base;
 	dma_addr_t q_base_pa;
@@ -85,7 +75,6 @@ struct ionic_qcq {
 	struct ionic_cq cq;
 	struct ionic_intr_info intr;
 	struct napi_struct napi;
-	struct ionic_napi_stats napi_stats;
 	unsigned int flags;
 	struct dentry *dentry;
 };
@@ -142,7 +131,6 @@ struct ionic_lif_sw_stats {
 
 enum ionic_lif_state_flags {
 	IONIC_LIF_F_INITED,
-	IONIC_LIF_F_SW_DEBUG_STATS,
 	IONIC_LIF_F_UP,
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
 	IONIC_LIF_F_FILTER_SYNC_NEEDED,
@@ -350,37 +338,4 @@ int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
 void ionic_lif_rx_mode(struct ionic_lif *lif);
 int ionic_reconfigure_queues(struct ionic_lif *lif,
 			     struct ionic_queue_params *qparam);
-
-static inline void debug_stats_txq_post(struct ionic_queue *q, bool dbell)
-{
-	struct ionic_txq_desc *desc = &q->txq[q->head_idx];
-	u8 num_sg_elems;
-
-	q->dbell_count += dbell;
-
-	num_sg_elems = ((le64_to_cpu(desc->cmd) >> IONIC_TXQ_DESC_NSGE_SHIFT)
-						& IONIC_TXQ_DESC_NSGE_MASK);
-	if (num_sg_elems > (IONIC_MAX_NUM_SG_CNTR - 1))
-		num_sg_elems = IONIC_MAX_NUM_SG_CNTR - 1;
-
-	q->lif->txqstats[q->index].sg_cntr[num_sg_elems]++;
-}
-
-static inline void debug_stats_napi_poll(struct ionic_qcq *qcq,
-					 unsigned int work_done)
-{
-	qcq->napi_stats.poll_count++;
-
-	if (work_done > (IONIC_MAX_NUM_NAPI_CNTR - 1))
-		work_done = IONIC_MAX_NUM_NAPI_CNTR - 1;
-
-	qcq->napi_stats.work_done_cntr[work_done]++;
-}
-
-#define DEBUG_STATS_CQE_CNT(cq)		((cq)->compl_count++)
-#define DEBUG_STATS_RX_BUFF_CNT(q)	((q)->lif->rxqstats[q->index].buffers_posted++)
-#define DEBUG_STATS_TXQ_POST(q, dbell)  debug_stats_txq_post(q, dbell)
-#define DEBUG_STATS_NAPI_POLL(qcq, work_done) \
-	debug_stats_napi_poll(qcq, work_done)
-
 #endif /* _IONIC_LIF_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index 58a854666c62..fd6806b4a1b9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -151,33 +151,11 @@ static const struct ionic_stat_desc ionic_rx_stats_desc[] = {
 	IONIC_RX_STAT_DESC(vlan_stripped),
 };
 
-static const struct ionic_stat_desc ionic_txq_stats_desc[] = {
-	IONIC_TX_Q_STAT_DESC(stop),
-	IONIC_TX_Q_STAT_DESC(wake),
-	IONIC_TX_Q_STAT_DESC(drop),
-	IONIC_TX_Q_STAT_DESC(dbell_count),
-};
-
-static const struct ionic_stat_desc ionic_dbg_cq_stats_desc[] = {
-	IONIC_CQ_STAT_DESC(compl_count),
-};
-
-static const struct ionic_stat_desc ionic_dbg_intr_stats_desc[] = {
-	IONIC_INTR_STAT_DESC(rearm_count),
-};
-
-static const struct ionic_stat_desc ionic_dbg_napi_stats_desc[] = {
-	IONIC_NAPI_STAT_DESC(poll_count),
-};
 
 #define IONIC_NUM_LIF_STATS ARRAY_SIZE(ionic_lif_stats_desc)
 #define IONIC_NUM_PORT_STATS ARRAY_SIZE(ionic_port_stats_desc)
 #define IONIC_NUM_TX_STATS ARRAY_SIZE(ionic_tx_stats_desc)
 #define IONIC_NUM_RX_STATS ARRAY_SIZE(ionic_rx_stats_desc)
-#define IONIC_NUM_TX_Q_STATS ARRAY_SIZE(ionic_txq_stats_desc)
-#define IONIC_NUM_DBG_CQ_STATS ARRAY_SIZE(ionic_dbg_cq_stats_desc)
-#define IONIC_NUM_DBG_INTR_STATS ARRAY_SIZE(ionic_dbg_intr_stats_desc)
-#define IONIC_NUM_DBG_NAPI_STATS ARRAY_SIZE(ionic_dbg_napi_stats_desc)
 
 #define MAX_Q(lif)   ((lif)->netdev->real_num_tx_queues)
 
@@ -253,21 +231,6 @@ static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
 	total += tx_queues * IONIC_NUM_TX_STATS;
 	total += rx_queues * IONIC_NUM_RX_STATS;
 
-	if (test_bit(IONIC_LIF_F_UP, lif->state) &&
-	    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
-		/* tx debug stats */
-		total += tx_queues * (IONIC_NUM_DBG_CQ_STATS +
-				      IONIC_NUM_TX_Q_STATS +
-				      IONIC_NUM_DBG_INTR_STATS +
-				      IONIC_MAX_NUM_SG_CNTR);
-
-		/* rx debug stats */
-		total += rx_queues * (IONIC_NUM_DBG_CQ_STATS +
-				      IONIC_NUM_DBG_INTR_STATS +
-				      IONIC_NUM_DBG_NAPI_STATS +
-				      IONIC_MAX_NUM_NAPI_CNTR);
-	}
-
 	return total;
 }
 
@@ -279,22 +242,6 @@ static void ionic_sw_stats_get_tx_strings(struct ionic_lif *lif, u8 **buf,
 	for (i = 0; i < IONIC_NUM_TX_STATS; i++)
 		ethtool_sprintf(buf, "tx_%d_%s", q_num,
 				ionic_tx_stats_desc[i].name);
-
-	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
-	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
-		return;
-
-	for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++)
-		ethtool_sprintf(buf, "txq_%d_%s", q_num,
-				ionic_txq_stats_desc[i].name);
-	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++)
-		ethtool_sprintf(buf, "txq_%d_cq_%s", q_num,
-				ionic_dbg_cq_stats_desc[i].name);
-	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++)
-		ethtool_sprintf(buf, "txq_%d_intr_%s", q_num,
-				ionic_dbg_intr_stats_desc[i].name);
-	for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++)
-		ethtool_sprintf(buf, "txq_%d_sg_cntr_%d", q_num, i);
 }
 
 static void ionic_sw_stats_get_rx_strings(struct ionic_lif *lif, u8 **buf,
@@ -305,22 +252,6 @@ static void ionic_sw_stats_get_rx_strings(struct ionic_lif *lif, u8 **buf,
 	for (i = 0; i < IONIC_NUM_RX_STATS; i++)
 		ethtool_sprintf(buf, "rx_%d_%s", q_num,
 				ionic_rx_stats_desc[i].name);
-
-	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
-	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
-		return;
-
-	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++)
-		ethtool_sprintf(buf, "rxq_%d_cq_%s", q_num,
-				ionic_dbg_cq_stats_desc[i].name);
-	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++)
-		ethtool_sprintf(buf, "rxq_%d_intr_%s", q_num,
-				ionic_dbg_intr_stats_desc[i].name);
-	for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++)
-		ethtool_sprintf(buf, "rxq_%d_napi_%s", q_num,
-				ionic_dbg_napi_stats_desc[i].name);
-	for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++)
-		ethtool_sprintf(buf, "rxq_%d_napi_work_done_%d", q_num, i);
 }
 
 static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
@@ -350,7 +281,6 @@ static void ionic_sw_stats_get_txq_values(struct ionic_lif *lif, u64 **buf,
 					  int q_num)
 {
 	struct ionic_tx_stats *txstats;
-	struct ionic_qcq *txqcq;
 	int i;
 
 	txstats = &lif->txqstats[q_num];
@@ -359,47 +289,12 @@ static void ionic_sw_stats_get_txq_values(struct ionic_lif *lif, u64 **buf,
 		**buf = IONIC_READ_STAT64(txstats, &ionic_tx_stats_desc[i]);
 		(*buf)++;
 	}
-
-	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
-	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
-		return;
-
-	txqcq = lif->txqcqs[q_num];
-	for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
-		**buf = IONIC_READ_STAT64(&txqcq->q,
-					  &ionic_txq_stats_desc[i]);
-		(*buf)++;
-	}
-	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
-		**buf = IONIC_READ_STAT64(&txqcq->cq,
-					  &ionic_dbg_cq_stats_desc[i]);
-		(*buf)++;
-	}
-	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
-		**buf = IONIC_READ_STAT64(&txqcq->intr,
-					  &ionic_dbg_intr_stats_desc[i]);
-		(*buf)++;
-	}
-	for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
-		**buf = IONIC_READ_STAT64(&txqcq->napi_stats,
-					  &ionic_dbg_napi_stats_desc[i]);
-		(*buf)++;
-	}
-	for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
-		**buf = txqcq->napi_stats.work_done_cntr[i];
-		(*buf)++;
-	}
-	for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
-		**buf = txstats->sg_cntr[i];
-		(*buf)++;
-	}
 }
 
 static void ionic_sw_stats_get_rxq_values(struct ionic_lif *lif, u64 **buf,
 					  int q_num)
 {
 	struct ionic_rx_stats *rxstats;
-	struct ionic_qcq *rxqcq;
 	int i;
 
 	rxstats = &lif->rxqstats[q_num];
@@ -408,31 +303,6 @@ static void ionic_sw_stats_get_rxq_values(struct ionic_lif *lif, u64 **buf,
 		**buf = IONIC_READ_STAT64(rxstats, &ionic_rx_stats_desc[i]);
 		(*buf)++;
 	}
-
-	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
-	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
-		return;
-
-	rxqcq = lif->rxqcqs[q_num];
-	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
-		**buf = IONIC_READ_STAT64(&rxqcq->cq,
-					  &ionic_dbg_cq_stats_desc[i]);
-		(*buf)++;
-	}
-	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
-		**buf = IONIC_READ_STAT64(&rxqcq->intr,
-					  &ionic_dbg_intr_stats_desc[i]);
-		(*buf)++;
-	}
-	for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
-		**buf = IONIC_READ_STAT64(&rxqcq->napi_stats,
-					  &ionic_dbg_napi_stats_desc[i]);
-		(*buf)++;
-	}
-	for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
-		**buf = rxqcq->napi_stats.work_done_cntr[i];
-		(*buf)++;
-	}
 }
 
 static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 37c39581b659..94384f5d2a22 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -14,8 +14,6 @@
 static inline void ionic_txq_post(struct ionic_queue *q, bool ring_dbell,
 				  ionic_desc_cb cb_func, void *cb_arg)
 {
-	DEBUG_STATS_TXQ_POST(q, ring_dbell);
-
 	ionic_q_post(q, ring_dbell, cb_func, cb_arg);
 }
 
@@ -23,8 +21,6 @@ static inline void ionic_rxq_post(struct ionic_queue *q, bool ring_dbell,
 				  ionic_desc_cb cb_func, void *cb_arg)
 {
 	ionic_q_post(q, ring_dbell, cb_func, cb_arg);
-
-	DEBUG_STATS_RX_BUFF_CNT(q);
 }
 
 static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
@@ -507,8 +503,6 @@ int ionic_tx_napi(struct napi_struct *napi, int budget)
 				   work_done, flags);
 	}
 
-	DEBUG_STATS_NAPI_POLL(qcq, work_done);
-
 	return work_done;
 }
 
@@ -546,8 +540,6 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 				   work_done, flags);
 	}
 
-	DEBUG_STATS_NAPI_POLL(qcq, work_done);
-
 	return work_done;
 }
 
@@ -591,9 +583,6 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 				   tx_work_done + rx_work_done, flags);
 	}
 
-	DEBUG_STATS_NAPI_POLL(qcq, rx_work_done);
-	DEBUG_STATS_NAPI_POLL(qcq, tx_work_done);
-
 	return rx_work_done;
 }
 
@@ -735,7 +724,6 @@ static void ionic_tx_clean(struct ionic_queue *q,
 
 	} else if (unlikely(__netif_subqueue_stopped(q->lif->netdev, qi))) {
 		netif_wake_subqueue(q->lif->netdev, qi);
-		q->wake++;
 	}
 
 	desc_info->bytes = skb->len;
@@ -1174,7 +1162,6 @@ static int ionic_maybe_stop_tx(struct ionic_queue *q, int ndescs)
 
 	if (unlikely(!ionic_q_has_space(q, ndescs))) {
 		netif_stop_subqueue(q->lif->netdev, q->index);
-		q->stop++;
 		stopped = 1;
 
 		/* Might race with ionic_tx_clean, check again */
@@ -1269,7 +1256,6 @@ netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 
 err_out_drop:
-	q->stop++;
 	q->drop++;
 	dev_kfree_skb(skb);
 	return NETDEV_TX_OK;
-- 
2.17.1


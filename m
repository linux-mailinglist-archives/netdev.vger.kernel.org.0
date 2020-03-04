Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797F4178978
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgCDEU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:20:29 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39294 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgCDEU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:20:26 -0500
Received: by mail-pg1-f193.google.com with SMTP id s2so351763pgv.6
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 20:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n+tX6FtoNy0xqtHkylnOj8rDMvnTHLoC+mNlcDwGY+A=;
        b=xPglia/gLDotp3ZEuWWE7ujW4/+W1wTW39faU+Mvws1yH2cNUJa9otUnbdm8CwNWoj
         Eif3xzdmK1e9gG0pUFmvvOyGvNslJFF7L4o448DBIEpWeAmiUQZQMnBI4r4DGIL/nVKP
         3bBSPZ7TcNa2HPpnx3vMvRYyPD+zpoLj/3supBum7OE8xCTiqavzsh7438e5pc4WHv7C
         Nf6HHKxDCC+rovHfpwCijhLpQwAeVxlxi+UwWMdvxTAjb5vh+OXL0JylHYjabkR1SJ/8
         EewxUguFJBSUNAKJFMT/umx4kSF7Ki/REz0ePuPEzDZRjsNbH828tPuCGI+dDxk2kwVf
         qAuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n+tX6FtoNy0xqtHkylnOj8rDMvnTHLoC+mNlcDwGY+A=;
        b=LRMwnPoZ0swtTD4seFS+H8fdyjjm8hwzMNkc7tcmBK7sFXHcXcPBV/1n1Jj3lWofoQ
         jmd0WgbJS22DB5n5r8KVoGwmdnxSZFrD0QL7gJIumZ7dQCULGQH8K/ZIJ1NF1r3mrTUd
         uVs8T94Qysstq+K7h/tK+y2GRnoSUiCkmIgz7tc4ne8UrrsFxlLVdINNzjPN8CX5O5gU
         YTKmCdUO+VFm4AQSbfcwu45fUqY35QLajV7G58Zsja7HBFX+MFIYE/xf0OZ+Th8GpmN2
         3948YIdQYdwdHoR2v3xY+nVGfBzQVKrbfwoo+4UDB5Cacvpvw263wXx3AMWEnTYQFfei
         lIFw==
X-Gm-Message-State: ANhLgQ1s9l1CHlwgV7cBGE8V0X5L7/Q2+f6/HO91+YvhD1Bk3a/0NFcz
        TXT5o6qa2MQoZNBw4gLUHlI5bg==
X-Google-Smtp-Source: ADFU+vtIfEOEsU0UftcfBIIdZ9TqEzgEIVumgiHYzsEXaVdGrngfyEswZWYP6Xj8KlP1dXwAHSRbgA==
X-Received: by 2002:aa7:9732:: with SMTP id k18mr1144109pfg.231.1583295625498;
        Tue, 03 Mar 2020 20:20:25 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c2sm671702pjo.28.2020.03.03.20.20.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 20:20:25 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 4/8] ionic: clean up bitflag usage
Date:   Tue,  3 Mar 2020 20:20:09 -0800
Message-Id: <20200304042013.51970-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304042013.51970-1-snelson@pensando.io>
References: <20200304042013.51970-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the unused flags field and and fix the bitflag names
to include the _F_ flag hint.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 24 ++++++++-----------
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 24 +++++++++----------
 .../net/ethernet/pensando/ionic/ionic_lif.h   | 15 ++++++------
 .../net/ethernet/pensando/ionic/ionic_stats.c | 20 ++++++++--------
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  4 ++--
 5 files changed, 41 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index f778fff034f5..acd53e27d1ec 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -462,7 +462,7 @@ static int ionic_set_coalesce(struct net_device *netdev,
 	if (coal != lif->rx_coalesce_hw) {
 		lif->rx_coalesce_hw = coal;
 
-		if (test_bit(IONIC_LIF_UP, lif->state)) {
+		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 			for (i = 0; i < lif->nxqs; i++) {
 				qcq = lif->rxqcqs[i].qcq;
 				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
@@ -509,11 +509,11 @@ static int ionic_set_ringparam(struct net_device *netdev,
 	    ring->rx_pending == lif->nrxq_descs)
 		return 0;
 
-	err = ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET);
+	err = ionic_wait_for_bit(lif, IONIC_LIF_F_QUEUE_RESET);
 	if (err)
 		return err;
 
-	running = test_bit(IONIC_LIF_UP, lif->state);
+	running = test_bit(IONIC_LIF_F_UP, lif->state);
 	if (running)
 		ionic_stop(netdev);
 
@@ -522,7 +522,7 @@ static int ionic_set_ringparam(struct net_device *netdev,
 
 	if (running)
 		ionic_open(netdev);
-	clear_bit(IONIC_LIF_QUEUE_RESET, lif->state);
+	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
 
 	return 0;
 }
@@ -553,11 +553,11 @@ static int ionic_set_channels(struct net_device *netdev,
 	if (ch->combined_count == lif->nxqs)
 		return 0;
 
-	err = ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET);
+	err = ionic_wait_for_bit(lif, IONIC_LIF_F_QUEUE_RESET);
 	if (err)
 		return err;
 
-	running = test_bit(IONIC_LIF_UP, lif->state);
+	running = test_bit(IONIC_LIF_F_UP, lif->state);
 	if (running)
 		ionic_stop(netdev);
 
@@ -565,7 +565,7 @@ static int ionic_set_channels(struct net_device *netdev,
 
 	if (running)
 		ionic_open(netdev);
-	clear_bit(IONIC_LIF_QUEUE_RESET, lif->state);
+	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
 
 	return 0;
 }
@@ -575,7 +575,7 @@ static u32 ionic_get_priv_flags(struct net_device *netdev)
 	struct ionic_lif *lif = netdev_priv(netdev);
 	u32 priv_flags = 0;
 
-	if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state))
+	if (test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
 		priv_flags |= PRIV_F_SW_DBG_STATS;
 
 	return priv_flags;
@@ -584,14 +584,10 @@ static u32 ionic_get_priv_flags(struct net_device *netdev)
 static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	u32 flags = lif->flags;
 
-	clear_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state);
+	clear_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state);
 	if (priv_flags & PRIV_F_SW_DBG_STATS)
-		set_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state);
-
-	if (flags != lif->flags)
-		lif->flags = flags;
+		set_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7df49b433ae5..d1567e477b1f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -84,7 +84,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 		netdev_info(netdev, "Link up - %d Gbps\n",
 			    le32_to_cpu(lif->info->status.link_speed) / 1000);
 
-		if (test_bit(IONIC_LIF_UP, lif->state)) {
+		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 			netif_tx_wake_all_queues(lif->netdev);
 			netif_carrier_on(netdev);
 		}
@@ -93,12 +93,12 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 
 		/* carrier off first to avoid watchdog timeout */
 		netif_carrier_off(netdev);
-		if (test_bit(IONIC_LIF_UP, lif->state))
+		if (test_bit(IONIC_LIF_F_UP, lif->state))
 			netif_tx_stop_all_queues(netdev);
 	}
 
 link_out:
-	clear_bit(IONIC_LIF_LINK_CHECK_REQUESTED, lif->state);
+	clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
 }
 
 static void ionic_link_status_check_request(struct ionic_lif *lif)
@@ -106,7 +106,7 @@ static void ionic_link_status_check_request(struct ionic_lif *lif)
 	struct ionic_deferred_work *work;
 
 	/* we only need one request outstanding at a time */
-	if (test_and_set_bit(IONIC_LIF_LINK_CHECK_REQUESTED, lif->state))
+	if (test_and_set_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
 		return;
 
 	if (in_interrupt()) {
@@ -1579,7 +1579,7 @@ int ionic_open(struct net_device *netdev)
 	netif_set_real_num_tx_queues(netdev, lif->nxqs);
 	netif_set_real_num_rx_queues(netdev, lif->nxqs);
 
-	set_bit(IONIC_LIF_UP, lif->state);
+	set_bit(IONIC_LIF_F_UP, lif->state);
 
 	ionic_link_status_check_request(lif);
 	if (netif_carrier_ok(netdev))
@@ -1599,13 +1599,13 @@ int ionic_stop(struct net_device *netdev)
 	struct ionic_lif *lif = netdev_priv(netdev);
 	int err = 0;
 
-	if (!test_bit(IONIC_LIF_UP, lif->state)) {
+	if (!test_bit(IONIC_LIF_F_UP, lif->state)) {
 		dev_dbg(lif->ionic->dev, "%s: %s state=DOWN\n",
 			__func__, lif->name);
 		return 0;
 	}
 	dev_dbg(lif->ionic->dev, "%s: %s state=UP\n", __func__, lif->name);
-	clear_bit(IONIC_LIF_UP, lif->state);
+	clear_bit(IONIC_LIF_F_UP, lif->state);
 
 	/* carrier off before disabling queues to avoid watchdog timeout */
 	netif_carrier_off(netdev);
@@ -1872,7 +1872,7 @@ int ionic_reset_queues(struct ionic_lif *lif)
 	/* Put off the next watchdog timeout */
 	netif_trans_update(lif->netdev);
 
-	err = ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET);
+	err = ionic_wait_for_bit(lif, IONIC_LIF_F_QUEUE_RESET);
 	if (err)
 		return err;
 
@@ -1882,7 +1882,7 @@ int ionic_reset_queues(struct ionic_lif *lif)
 	if (!err && running)
 		ionic_open(lif->netdev);
 
-	clear_bit(IONIC_LIF_QUEUE_RESET, lif->state);
+	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
 
 	return err;
 }
@@ -2049,10 +2049,10 @@ void ionic_lifs_free(struct ionic *ionic)
 
 static void ionic_lif_deinit(struct ionic_lif *lif)
 {
-	if (!test_bit(IONIC_LIF_INITED, lif->state))
+	if (!test_bit(IONIC_LIF_F_INITED, lif->state))
 		return;
 
-	clear_bit(IONIC_LIF_INITED, lif->state);
+	clear_bit(IONIC_LIF_F_INITED, lif->state);
 
 	ionic_rx_filters_deinit(lif);
 	ionic_lif_rss_deinit(lif);
@@ -2288,7 +2288,7 @@ static int ionic_lif_init(struct ionic_lif *lif)
 
 	lif->rx_copybreak = IONIC_RX_COPYBREAK_DEFAULT;
 
-	set_bit(IONIC_LIF_INITED, lif->state);
+	set_bit(IONIC_LIF_F_INITED, lif->state);
 
 	INIT_WORK(&lif->tx_timeout_work, ionic_tx_timeout_work);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 9c5a7dd45f9d..7c0c6fef8c0b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -121,14 +121,14 @@ struct ionic_lif_sw_stats {
 };
 
 enum ionic_lif_state_flags {
-	IONIC_LIF_INITED,
-	IONIC_LIF_SW_DEBUG_STATS,
-	IONIC_LIF_UP,
-	IONIC_LIF_LINK_CHECK_REQUESTED,
-	IONIC_LIF_QUEUE_RESET,
+	IONIC_LIF_F_INITED,
+	IONIC_LIF_F_SW_DEBUG_STATS,
+	IONIC_LIF_F_UP,
+	IONIC_LIF_F_LINK_CHECK_REQUESTED,
+	IONIC_LIF_F_QUEUE_RESET,
 
 	/* leave this as last */
-	IONIC_LIF_STATE_SIZE
+	IONIC_LIF_F_STATE_SIZE
 };
 
 #define IONIC_LIF_NAME_MAX_SZ		32
@@ -136,7 +136,7 @@ struct ionic_lif {
 	char name[IONIC_LIF_NAME_MAX_SZ];
 	struct list_head list;
 	struct net_device *netdev;
-	DECLARE_BITMAP(state, IONIC_LIF_STATE_SIZE);
+	DECLARE_BITMAP(state, IONIC_LIF_F_STATE_SIZE);
 	struct ionic *ionic;
 	bool registered;
 	unsigned int index;
@@ -179,7 +179,6 @@ struct ionic_lif {
 	u32 rx_coalesce_usecs;		/* what the user asked for */
 	u32 rx_coalesce_hw;		/* what the hw is using */
 
-	u32 flags;
 	struct work_struct tx_timeout_work;
 };
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index a1e9796a660a..8f2a8fb029f1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -118,8 +118,8 @@ static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
 	/* rx stats */
 	total += MAX_Q(lif) * IONIC_NUM_RX_STATS;
 
-	if (test_bit(IONIC_LIF_UP, lif->state) &&
-	    test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+	if (test_bit(IONIC_LIF_F_UP, lif->state) &&
+	    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
 		/* tx debug stats */
 		total += MAX_Q(lif) * (IONIC_NUM_DBG_CQ_STATS +
 				      IONIC_NUM_TX_Q_STATS +
@@ -151,8 +151,8 @@ static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
 			*buf += ETH_GSTRING_LEN;
 		}
 
-		if (test_bit(IONIC_LIF_UP, lif->state) &&
-		    test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
+		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
 			for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
 				snprintf(*buf, ETH_GSTRING_LEN,
 					 "txq_%d_%s",
@@ -190,8 +190,8 @@ static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
 			*buf += ETH_GSTRING_LEN;
 		}
 
-		if (test_bit(IONIC_LIF_UP, lif->state) &&
-		    test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
+		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
 			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
 				snprintf(*buf, ETH_GSTRING_LEN,
 					 "rxq_%d_cq_%s",
@@ -247,8 +247,8 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 			(*buf)++;
 		}
 
-		if (test_bit(IONIC_LIF_UP, lif->state) &&
-		    test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
+		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
 			txqcq = lif_to_txqcq(lif, q_num);
 			for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
 				**buf = IONIC_READ_STAT64(&txqcq->q,
@@ -281,8 +281,8 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 			(*buf)++;
 		}
 
-		if (test_bit(IONIC_LIF_UP, lif->state) &&
-		    test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
+		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
 			rxqcq = lif_to_rxqcq(lif, q_num);
 			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
 				**buf = IONIC_READ_STAT64(&rxqcq->cq,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index e452f4242ba0..a268cead9f50 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -158,7 +158,7 @@ static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_i
 	}
 
 	/* no packet processing while resetting */
-	if (unlikely(test_bit(IONIC_LIF_QUEUE_RESET, q->lif->state))) {
+	if (unlikely(test_bit(IONIC_LIF_F_QUEUE_RESET, q->lif->state))) {
 		stats->dropped++;
 		return;
 	}
@@ -1026,7 +1026,7 @@ netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	int ndescs;
 	int err;
 
-	if (unlikely(!test_bit(IONIC_LIF_UP, lif->state))) {
+	if (unlikely(!test_bit(IONIC_LIF_F_UP, lif->state))) {
 		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
-- 
2.17.1


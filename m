Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C4C25517A
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 01:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgH0XBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 19:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgH0XAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 19:00:52 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB94C061232
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:51 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ds1so3421474pjb.1
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=M+F2NN5KwAkDHOm7RkksQv+1p4O3p5brWIfpVChhBEU=;
        b=4q9vuII/PR/VJ8FeXKUq6W2lMxMSpBg+DwwRcGO+FkQNunx4Ht39rUopYP4GR0wEFl
         GSh+UNrsvC04axK7mefl8haB0EFF4NvSSMWht0bVn/kNwf4PlEsdpbzTkmAgQLl9Ma0D
         ZcTmox0t68NiHWTh9K8AiG78iOkFKnIFvDKq0Umgx39V6/NhhFD1UCp3Z9p+V2Ir4xUc
         zatfG9Cxe2VsU9mAN9lRE8vfB45xRhaSdIDRVCbvosxElvNYvJYKYgc++y1gdqlw6+SJ
         JdRAZEzddOFPyg2upOTkpU3e0l789+23+Iq81+9rKBDj7Sn04kQMhSZJqOm2FyxPzCvd
         /vsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=M+F2NN5KwAkDHOm7RkksQv+1p4O3p5brWIfpVChhBEU=;
        b=YCI9OCOrG1TOkHxZvJi6j18m3s41b7nb9Q6vFgDRB74w9agm402hFnaae0NbnZpSQu
         SMTMZFjyixdo8cEwcwGil1Z5Fl4qK0l2j/rB6xxSIt9WzqP32AuXvYYoEfl2ckD3LetJ
         Tc3H/LXj99i/4nTm81QJk5AYYqrCb8k5SA9q8IttNSJZwJEPlRzBiCtzlYQLKMXqdR+i
         nxjGUlEftNLVWXlr335lnXSMWzAy3UZ+Jkzd97+mUPC3nWZtq6QlWWr2FX+HvPeAZp2k
         rQP40X3HQNXYhlecw4pjQkVrGQXFApWeNHFozlmQiVc4o/eqs94KfMwQUEXet+OnKp8X
         94/A==
X-Gm-Message-State: AOAM531YCtyF0L0a22Zdhd1yCRz7GkmzzMIl1ZgYSPgZVmPrdkkB0iq4
        r73NtKgEUmDSX76k5rOvCbTW7KJxUnvCZA==
X-Google-Smtp-Source: ABdhPJzL3gl0EJcnfMEUJlLTsx/knDy97J+vJYNa0NpW8gN2m7PF7ZsZ5V6IB2xCYgMl6CMjdzzwSw==
X-Received: by 2002:a17:90b:4d10:: with SMTP id mw16mr967801pjb.100.1598569250919;
        Thu, 27 Aug 2020 16:00:50 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n22sm3137534pjq.25.2020.08.27.16.00.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 16:00:49 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 11/12] ionic: change queue count with no reset
Date:   Thu, 27 Aug 2020 16:00:29 -0700
Message-Id: <20200827230030.43343-12-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827230030.43343-1-snelson@pensando.io>
References: <20200827230030.43343-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add to our new ionic_reconfigure_queues() to also be able to change
the number of queues in use, and to change the queue interrupt layout
between split and combined.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  88 ++++---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 216 +++++++++++++-----
 2 files changed, 213 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index adaefa5fe883..00aad7168915 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -561,32 +561,15 @@ static void ionic_get_channels(struct net_device *netdev,
 	}
 }
 
-static void ionic_set_queuecount(struct ionic_lif *lif, void *arg)
-{
-	struct ethtool_channels *ch = arg;
-
-	if (ch->combined_count) {
-		lif->nxqs = ch->combined_count;
-		if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state)) {
-			clear_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
-			lif->tx_coalesce_usecs = lif->rx_coalesce_usecs;
-			lif->tx_coalesce_hw = lif->rx_coalesce_hw;
-			netdev_info(lif->netdev, "Sharing queue interrupts\n");
-		}
-	} else {
-		lif->nxqs = ch->rx_count;
-		if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state)) {
-			set_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
-			netdev_info(lif->netdev, "Splitting queue interrupts\n");
-		}
-	}
-}
-
 static int ionic_set_channels(struct net_device *netdev,
 			      struct ethtool_channels *ch)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	int new_cnt;
+	struct ionic_queue_params qparam;
+	int max_cnt;
+	int err;
+
+	ionic_init_queue_params(lif, &qparam);
 
 	if (ch->rx_count != ch->tx_count) {
 		netdev_info(netdev, "The rx and tx count must be equal\n");
@@ -594,20 +577,63 @@ static int ionic_set_channels(struct net_device *netdev,
 	}
 
 	if (ch->combined_count && ch->rx_count) {
-		netdev_info(netdev, "Use either combined_count or rx/tx_count, not both\n");
+		netdev_info(netdev, "Use either combined or rx and tx, not both\n");
 		return -EINVAL;
 	}
 
-	if (ch->combined_count)
-		new_cnt = ch->combined_count;
-	else
-		new_cnt = ch->rx_count;
+	max_cnt = lif->ionic->ntxqs_per_lif;
+	if (ch->combined_count) {
+		if (ch->combined_count > max_cnt)
+			return -EINVAL;
+
+		if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+			netdev_info(lif->netdev, "Sharing queue interrupts\n");
+		else if (ch->combined_count == lif->nxqs)
+			return 0;
 
-	if (lif->nxqs != new_cnt)
-		netdev_info(netdev, "Changing queue count from %d to %d\n",
-			    lif->nxqs, new_cnt);
+		if (lif->nxqs != ch->combined_count)
+			netdev_info(netdev, "Changing queue count from %d to %d\n",
+				    lif->nxqs, ch->combined_count);
 
-	return ionic_reset_queues(lif, ionic_set_queuecount, ch);
+		qparam.nxqs = ch->combined_count;
+		qparam.intr_split = 0;
+	} else {
+		max_cnt /= 2;
+		if (ch->rx_count > max_cnt)
+			return -EINVAL;
+
+		if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+			netdev_info(lif->netdev, "Splitting queue interrupts\n");
+		else if (ch->rx_count == lif->nxqs)
+			return 0;
+
+		if (lif->nxqs != ch->rx_count)
+			netdev_info(netdev, "Changing queue count from %d to %d\n",
+				    lif->nxqs, ch->rx_count);
+
+		qparam.nxqs = ch->rx_count;
+		qparam.intr_split = 1;
+	}
+
+	/* if we're not running, just set the values and return */
+	if (!netif_running(lif->netdev)) {
+		lif->nxqs = qparam.nxqs;
+
+		if (qparam.intr_split) {
+			set_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+		} else {
+			clear_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+			lif->tx_coalesce_usecs = lif->rx_coalesce_usecs;
+			lif->tx_coalesce_hw = lif->rx_coalesce_hw;
+		}
+		return 0;
+	}
+
+	err = ionic_reconfigure_queues(lif, &qparam);
+	if (err)
+		netdev_info(netdev, "Queue reconfiguration failed, changes canceled: %d\n", err);
+
+	return err;
 }
 
 static u32 ionic_get_priv_flags(struct net_device *netdev)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 345259171265..4b16dbf257d9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -299,6 +299,18 @@ static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	qcq->flags &= ~IONIC_QCQ_F_INITED;
 }
 
+static void ionic_qcq_intr_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
+{
+	if (!(qcq->flags & IONIC_QCQ_F_INTR) || qcq->intr.vector == 0)
+		return;
+
+	irq_set_affinity_hint(qcq->intr.vector, NULL);
+	devm_free_irq(lif->ionic->dev, qcq->intr.vector, &qcq->napi);
+	qcq->intr.vector = 0;
+	ionic_intr_free(lif->ionic, qcq->intr.index);
+	qcq->intr.index = IONIC_INTR_INDEX_NOT_ASSIGNED;
+}
+
 static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
 	struct device *dev = lif->ionic->dev;
@@ -326,12 +338,7 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		qcq->sg_base_pa = 0;
 	}
 
-	if (qcq->flags & IONIC_QCQ_F_INTR) {
-		irq_set_affinity_hint(qcq->intr.vector, NULL);
-		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
-		qcq->intr.vector = 0;
-		ionic_intr_free(lif->ionic, qcq->intr.index);
-	}
+	ionic_qcq_intr_free(lif, qcq);
 
 	if (qcq->cq.info) {
 		devm_kfree(dev, qcq->cq.info);
@@ -341,7 +348,6 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		devm_kfree(dev, qcq->q.info);
 		qcq->q.info = NULL;
 	}
-	devm_kfree(dev, qcq);
 }
 
 static void ionic_qcqs_free(struct ionic_lif *lif)
@@ -350,11 +356,13 @@ static void ionic_qcqs_free(struct ionic_lif *lif)
 
 	if (lif->notifyqcq) {
 		ionic_qcq_free(lif, lif->notifyqcq);
+		devm_kfree(dev, lif->notifyqcq);
 		lif->notifyqcq = NULL;
 	}
 
 	if (lif->adminqcq) {
 		ionic_qcq_free(lif, lif->adminqcq);
+		devm_kfree(dev, lif->adminqcq);
 		lif->adminqcq = NULL;
 	}
 
@@ -385,6 +393,53 @@ static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
 	n_qcq->intr.index = src_qcq->intr.index;
 }
 
+static int ionic_alloc_qcq_interrupt(struct ionic_lif *lif, struct ionic_qcq *qcq)
+{
+	int err;
+
+	if (!(qcq->flags & IONIC_QCQ_F_INTR)) {
+		qcq->intr.index = IONIC_INTR_INDEX_NOT_ASSIGNED;
+		return 0;
+	}
+
+	err = ionic_intr_alloc(lif, &qcq->intr);
+	if (err) {
+		netdev_warn(lif->netdev, "no intr for %s: %d\n",
+			    qcq->q.name, err);
+		goto err_out;
+	}
+
+	err = ionic_bus_get_irq(lif->ionic, qcq->intr.index);
+	if (err < 0) {
+		netdev_warn(lif->netdev, "no vector for %s: %d\n",
+			    qcq->q.name, err);
+		goto err_out_free_intr;
+	}
+	qcq->intr.vector = err;
+	ionic_intr_mask_assert(lif->ionic->idev.intr_ctrl, qcq->intr.index,
+			       IONIC_INTR_MASK_SET);
+
+	err = ionic_request_irq(lif, qcq);
+	if (err) {
+		netdev_warn(lif->netdev, "irq request failed %d\n", err);
+		goto err_out_free_intr;
+	}
+
+	/* try to get the irq on the local numa node first */
+	qcq->intr.cpu = cpumask_local_spread(qcq->intr.index,
+					     dev_to_node(lif->ionic->dev));
+	if (qcq->intr.cpu != -1)
+		cpumask_set_cpu(qcq->intr.cpu, &qcq->intr.affinity_mask);
+
+	netdev_dbg(lif->netdev, "%s: Interrupt index %d\n", qcq->q.name, qcq->intr.index);
+	return 0;
+
+err_out_free_intr:
+	ionic_intr_free(lif->ionic, qcq->intr.index);
+err_out:
+	return err;
+}
+
 static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 			   unsigned int index,
 			   const char *name, unsigned int flags,
@@ -430,39 +485,9 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		goto err_out_free_q_info;
 	}
 
-	if (flags & IONIC_QCQ_F_INTR) {
-		err = ionic_intr_alloc(lif, &new->intr);
-		if (err) {
-			netdev_warn(lif->netdev, "no intr for %s: %d\n",
-				    new->q.name, err);
-			goto err_out;
-		}
-
-		err = ionic_bus_get_irq(lif->ionic, new->intr.index);
-		if (err < 0) {
-			netdev_warn(lif->netdev, "no vector for %s: %d\n",
-				    new->q.name, err);
-			goto err_out_free_intr;
-		}
-		new->intr.vector = err;
-		ionic_intr_mask_assert(idev->intr_ctrl, new->intr.index,
-				       IONIC_INTR_MASK_SET);
-
-		err = ionic_request_irq(lif, new);
-		if (err) {
-			netdev_warn(lif->netdev, "irq request failed for %s: %d\n",
-				    new->q.name, err);
-			goto err_out_free_intr;
-		}
-
-		new->intr.cpu = cpumask_local_spread(new->intr.index,
-						     dev_to_node(dev));
-		if (new->intr.cpu != -1)
-			cpumask_set_cpu(new->intr.cpu,
-					&new->intr.affinity_mask);
-	} else {
-		new->intr.index = IONIC_INTR_INDEX_NOT_ASSIGNED;
-	}
+	err = ionic_alloc_qcq_interrupt(lif, new);
+	if (err)
+		goto err_out;
 
 	new->cq.info = devm_kcalloc(dev, num_descs, sizeof(*new->cq.info),
 				    GFP_KERNEL);
@@ -528,11 +553,10 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 err_out_free_cq_info:
 	devm_kfree(dev, new->cq.info);
 err_out_free_irq:
-	if (flags & IONIC_QCQ_F_INTR)
+	if (flags & IONIC_QCQ_F_INTR) {
 		devm_free_irq(dev, new->intr.vector, &new->napi);
-err_out_free_intr:
-	if (flags & IONIC_QCQ_F_INTR)
 		ionic_intr_free(lif->ionic, new->intr.index);
+	}
 err_out_free_q_info:
 	devm_kfree(dev, new->q.info);
 err_out_free_qcq:
@@ -635,7 +659,7 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	unsigned int intr_index;
 	int err;
 
-	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+	if (qcq->flags & IONIC_QCQ_F_INTR)
 		intr_index = qcq->intr.index;
 	else
 		intr_index = lif->rxqcqs[q->index]->intr.index;
@@ -1539,7 +1563,7 @@ static void ionic_txrx_deinit(struct ionic_lif *lif)
 	unsigned int i;
 
 	if (lif->txqcqs) {
-		for (i = 0; i < lif->nxqs; i++) {
+		for (i = 0; i < lif->nxqs && lif->txqcqs[i]; i++) {
 			ionic_lif_qcq_deinit(lif, lif->txqcqs[i]);
 			ionic_tx_flush(&lif->txqcqs[i]->cq);
 			ionic_tx_empty(&lif->txqcqs[i]->q);
@@ -1547,7 +1571,7 @@ static void ionic_txrx_deinit(struct ionic_lif *lif)
 	}
 
 	if (lif->rxqcqs) {
-		for (i = 0; i < lif->nxqs; i++) {
+		for (i = 0; i < lif->nxqs && lif->rxqcqs[i]; i++) {
 			ionic_lif_qcq_deinit(lif, lif->rxqcqs[i]);
 			ionic_rx_flush(&lif->rxqcqs[i]->cq);
 			ionic_rx_empty(&lif->rxqcqs[i]->q);
@@ -1561,15 +1585,17 @@ static void ionic_txrx_free(struct ionic_lif *lif)
 	unsigned int i;
 
 	if (lif->txqcqs) {
-		for (i = 0; i < lif->nxqs; i++) {
+		for (i = 0; i < lif->ionic->ntxqs_per_lif && lif->txqcqs[i]; i++) {
 			ionic_qcq_free(lif, lif->txqcqs[i]);
+			devm_kfree(lif->ionic->dev, lif->txqcqs[i]);
 			lif->txqcqs[i] = NULL;
 		}
 	}
 
 	if (lif->rxqcqs) {
-		for (i = 0; i < lif->nxqs; i++) {
+		for (i = 0; i < lif->ionic->nrxqs_per_lif && lif->rxqcqs[i]; i++) {
 			ionic_qcq_free(lif, lif->rxqcqs[i]);
+			devm_kfree(lif->ionic->dev, lif->rxqcqs[i]);
 			lif->rxqcqs[i] = NULL;
 		}
 	}
@@ -2088,20 +2114,22 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	unsigned int i;
 
 	/* allocate temporary qcq arrays to hold new queue structs */
-	if (qparam->ntxq_descs != lif->ntxq_descs) {
-		tx_qcqs = devm_kcalloc(lif->ionic->dev, lif->nxqs,
+	if (qparam->nxqs != lif->nxqs || qparam->ntxq_descs != lif->ntxq_descs) {
+		tx_qcqs = devm_kcalloc(lif->ionic->dev, lif->ionic->ntxqs_per_lif,
 				       sizeof(struct ionic_qcq *), GFP_KERNEL);
 		if (!tx_qcqs)
 			goto err_out;
 	}
-	if (qparam->nrxq_descs != lif->nrxq_descs) {
-		rx_qcqs = devm_kcalloc(lif->ionic->dev, lif->nxqs,
+	if (qparam->nxqs != lif->nxqs || qparam->nrxq_descs != lif->nrxq_descs) {
+		rx_qcqs = devm_kcalloc(lif->ionic->dev, lif->ionic->nrxqs_per_lif,
 				       sizeof(struct ionic_qcq *), GFP_KERNEL);
 		if (!rx_qcqs)
 			goto err_out;
 	}
 
-	/* allocate new desc_info and rings with no interrupt flag */
+	/* allocate new desc_info and rings, but leave the interrupt setup
+	 * until later so as to not mess with the still-running queues
+	 */
 	if (lif->qtype_info[IONIC_QTYPE_TXQ].version >= 1 &&
 	    lif->qtype_info[IONIC_QTYPE_TXQ].sg_desc_sz ==
 					  sizeof(struct ionic_txq_sg_desc_v1))
@@ -2110,7 +2138,7 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 		sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
 
 	if (tx_qcqs) {
-		for (i = 0; i < lif->nxqs; i++) {
+		for (i = 0; i < qparam->nxqs; i++) {
 			flags = lif->txqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
 			err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
 					      qparam->ntxq_descs,
@@ -2124,7 +2152,7 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	}
 
 	if (rx_qcqs) {
-		for (i = 0; i < lif->nxqs; i++) {
+		for (i = 0; i < qparam->nxqs; i++) {
 			flags = lif->rxqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
 			err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
 					      qparam->nrxq_descs,
@@ -2140,33 +2168,90 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	/* stop and clean the queues */
 	ionic_stop_queues_reconfig(lif);
 
+	if (qparam->nxqs != lif->nxqs) {
+		err = netif_set_real_num_tx_queues(lif->netdev, qparam->nxqs);
+		if (err)
+			goto err_out_reinit_unlock;
+		err = netif_set_real_num_rx_queues(lif->netdev, qparam->nxqs);
+		if (err) {
+			netif_set_real_num_tx_queues(lif->netdev, lif->nxqs);
+			goto err_out_reinit_unlock;
+		}
+	}
+
 	/* swap new desc_info and rings, keeping existing interrupt config */
 	if (tx_qcqs) {
 		lif->ntxq_descs = qparam->ntxq_descs;
-		for (i = 0; i < lif->nxqs; i++)
+		for (i = 0; i < qparam->nxqs; i++)
 			ionic_swap_queues(lif->txqcqs[i], tx_qcqs[i]);
 	}
 
 	if (rx_qcqs) {
 		lif->nrxq_descs = qparam->nrxq_descs;
-		for (i = 0; i < lif->nxqs; i++)
+		for (i = 0; i < qparam->nxqs; i++)
 			ionic_swap_queues(lif->rxqcqs[i], rx_qcqs[i]);
 	}
 
-	/* re-init the queues */
-	err = ionic_start_queues_reconfig(lif);
+	/* if we need to change the interrupt layout, this is the time */
+	if (qparam->intr_split != test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state) ||
+	    qparam->nxqs != lif->nxqs) {
+		if (qparam->intr_split) {
+			set_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+		} else {
+			clear_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+			lif->tx_coalesce_usecs = lif->rx_coalesce_usecs;
+			lif->tx_coalesce_hw = lif->rx_coalesce_hw;
+		}
+
+		/* clear existing interrupt assignments */
+		for (i = 0; i < lif->ionic->ntxqs_per_lif; i++) {
+			ionic_qcq_intr_free(lif, lif->txqcqs[i]);
+			ionic_qcq_intr_free(lif, lif->rxqcqs[i]);
+		}
+
+		/* re-assign the interrupts */
+		for (i = 0; i < qparam->nxqs; i++) {
+			lif->rxqcqs[i]->flags |= IONIC_QCQ_F_INTR;
+			err = ionic_alloc_qcq_interrupt(lif, lif->rxqcqs[i]);
+			ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
+					     lif->rxqcqs[i]->intr.index,
+					     lif->rx_coalesce_hw);
+
+			if (qparam->intr_split) {
+				lif->txqcqs[i]->flags |= IONIC_QCQ_F_INTR;
+				err = ionic_alloc_qcq_interrupt(lif, lif->txqcqs[i]);
+				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
+						     lif->txqcqs[i]->intr.index,
+						     lif->tx_coalesce_hw);
+			} else {
+				lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+				ionic_link_qcq_interrupts(lif->rxqcqs[i], lif->txqcqs[i]);
+			}
+		}
+	}
+
+	swap(lif->nxqs, qparam->nxqs);
+
+err_out_reinit_unlock:
+	/* re-init the queues, but don't loose an error code */
+	if (err)
+		ionic_start_queues_reconfig(lif);
+	else
+		err = ionic_start_queues_reconfig(lif);
 
 err_out:
 	/* free old allocs without cleaning intr */
-	for (i = 0; i < lif->nxqs; i++) {
+	for (i = 0; i < qparam->nxqs; i++) {
 		if (tx_qcqs && tx_qcqs[i]) {
 			tx_qcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
 			ionic_qcq_free(lif, tx_qcqs[i]);
+			devm_kfree(lif->ionic->dev, tx_qcqs[i]);
 			tx_qcqs[i] = NULL;
 		}
 		if (rx_qcqs && rx_qcqs[i]) {
 			rx_qcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
 			ionic_qcq_free(lif, rx_qcqs[i]);
+			devm_kfree(lif->ionic->dev, rx_qcqs[i]);
 			rx_qcqs[i] = NULL;
 		}
 	}
@@ -2181,6 +2266,17 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 		tx_qcqs = NULL;
 	}
 
+	/* clean the unused dma and info allocations when new set is smaller
+	 * than the full array, but leave the qcq shells in place
+	 */
+	for (i = lif->nxqs; i < lif->ionic->ntxqs_per_lif; i++) {
+		lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+		ionic_qcq_free(lif, lif->txqcqs[i]);
+
+		lif->rxqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+		ionic_qcq_free(lif, lif->rxqcqs[i]);
+	}
+
 	return err;
 }
 
-- 
2.17.1


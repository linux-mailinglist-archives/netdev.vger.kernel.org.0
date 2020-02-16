Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36156160724
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 00:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgBPXMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 18:12:18 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:39861 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBPXMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 18:12:14 -0500
Received: by mail-pf1-f177.google.com with SMTP id 84so7845674pfy.6
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 15:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=551J6nO+NLJXGMhhFwwa3JLMj1JLlK2NnYFMc/DODMw=;
        b=vECKPeNCfWj7FLDx//y14NSzU34015Zc2i8+YcGhl3g+hYljLtb0AtefYXr1do86V4
         Ut7nQbV56a2b8TI4cqX8kc8oDItuTiPgXhan6Y9Z8SXM3ehE/Ns/1AIdZF+gOcsrdIQC
         pQJxLBRSn1Bzpa1H1JkijhmsJLkchfP8Un9nnd+UcEkCZE+MjUzVH7A5ouJD/axqjCHf
         G4zReIxUZi5Uv1eGDcyG1d1Lid7Zkal9d7m5oFpr76LTm9njUabO2h7t0fnfKafd24ou
         FNlRr5plinRChmFFdglRX4csxftpjNyI11khZM66LZ+Ia1GHqpk2eK1wnyYmtbtr+yig
         AlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=551J6nO+NLJXGMhhFwwa3JLMj1JLlK2NnYFMc/DODMw=;
        b=e//7BUyLhcXFpPR9imOqqmKsoTjgw5CJCb+2+rk223Ex34XZIalujQwDZONE0SHNu3
         bkjSFYPHJB0kcqL0Qyl3RmUW605ik9piij2h7LqwGXYPO23/KjBcOAltz7L2gD6dXeRE
         kshfVlD1Idcso6uKbpVyMsT867AGsQn4CVC0t07LC7NV9Pqe9WIShO3tUcvKKorAFU6d
         psp1l3D66XS+/WisQxXY+09VEj40iBokaHTfRjUNox4XBqgc5SULwmDKfNKGm9Bmcff5
         hnAVkpY7+NmLWxP44KifoJ/0vt4lxsSKxq9EyavL7s69DUS1aFm+f65YfKyxeAHsQ/wg
         +fOQ==
X-Gm-Message-State: APjAAAXt90wDfX8jyxDanGEPlDaX6JxuVJscWUs2R9rus5doc6vdOpK3
        bEmMo4VZ9KX2EaV+bCKiwUQNt4bbMzkUDQ==
X-Google-Smtp-Source: APXvYqyRdNswcu0sVL5qGve1sX/Q2OswCFJOa8gxKa6oYXv0Az7oclwVO8ot9Diy46vpChOQe6m9dQ==
X-Received: by 2002:a63:3684:: with SMTP id d126mr14683672pga.380.1581894733462;
        Sun, 16 Feb 2020 15:12:13 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 70sm14074573pgd.28.2020.02.16.15.12.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Feb 2020 15:12:13 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/9] ionic: add functions for setup and tear down event queues
Date:   Sun, 16 Feb 2020 15:11:55 -0800
Message-Id: <20200216231158.5678-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216231158.5678-1-snelson@pensando.io>
References: <20200216231158.5678-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the the Event Queue setup and teardown functions.
We'll link them into the driver setup in the next patch.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  34 ++
 .../ethernet/pensando/ionic/ionic_debugfs.h   |   2 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 323 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   5 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   3 +
 6 files changed, 369 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index bc03cecf80cc..2b2a0019f36b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -43,6 +43,7 @@ static int identity_show(struct seq_file *seq, void *v)
 
 	seq_printf(seq, "nlifs:            %d\n", ident->dev.nlifs);
 	seq_printf(seq, "nintrs:           %d\n", ident->dev.nintrs);
+	seq_printf(seq, "eth_eq_count:     %d\n", ident->dev.eq_count);
 	seq_printf(seq, "ndbpgs_per_lif:   %d\n", ident->dev.ndbpgs_per_lif);
 	seq_printf(seq, "intr_coal_mult:   %d\n", ident->dev.intr_coal_mult);
 	seq_printf(seq, "intr_coal_div:    %d\n", ident->dev.intr_coal_div);
@@ -125,6 +126,7 @@ void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 
 	debugfs_create_x32("total_size", 0400, qcq->dentry, &qcq->total_size);
 	debugfs_create_x64("base_pa", 0400, qcq->dentry, &qcq->base_pa);
+	debugfs_create_bool("armed", 0400, qcq->dentry, &qcq->armed);
 
 	q_dentry = debugfs_create_dir("q", qcq->dentry);
 
@@ -239,6 +241,38 @@ void ionic_debugfs_del_lif(struct ionic_lif *lif)
 	lif->dentry = NULL;
 }
 
+void ionic_debugfs_add_eq(struct ionic_eq *eq)
+{
+	const int ring_bytes = sizeof(struct ionic_eq_comp) * IONIC_EQ_DEPTH;
+	struct device *dev = eq->ionic->dev;
+	struct debugfs_blob_wrapper *blob;
+	struct debugfs_regset32 *regset;
+	struct dentry *ent;
+	char name[40];
+
+	snprintf(name, sizeof(name), "eq%02u", eq->index);
+
+	ent = debugfs_create_dir(name, eq->ionic->dentry);
+	if (IS_ERR_OR_NULL(ent))
+		return;
+
+	blob = devm_kzalloc(dev, sizeof(*blob), GFP_KERNEL);
+	blob->data = eq->ring[0].base;
+	blob->size = ring_bytes;
+	debugfs_create_blob("ring0", 0400, ent, blob);
+
+	blob = devm_kzalloc(dev, sizeof(*blob), GFP_KERNEL);
+	blob->data = eq->ring[1].base;
+	blob->size = ring_bytes;
+	debugfs_create_blob("ring1", 0400, ent, blob);
+
+	regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
+	regset->regs = intr_ctrl_regs;
+	regset->nregs = ARRAY_SIZE(intr_ctrl_regs);
+	regset->base = &eq->ionic->idev.intr_ctrl[eq->intr.index];
+	debugfs_create_regset32("intr_ctrl", 0400, ent, regset);
+}
+
 void ionic_debugfs_del_qcq(struct ionic_qcq *qcq)
 {
 	debugfs_remove_recursive(qcq->dentry);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
index c44ebde170b6..dcff2ebe7bf5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
@@ -14,6 +14,7 @@ void ionic_debugfs_add_dev(struct ionic *ionic);
 void ionic_debugfs_del_dev(struct ionic *ionic);
 void ionic_debugfs_add_ident(struct ionic *ionic);
 void ionic_debugfs_add_sizes(struct ionic *ionic);
+void ionic_debugfs_add_eq(struct ionic_eq *eq);
 void ionic_debugfs_add_lif(struct ionic_lif *lif);
 void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq);
 void ionic_debugfs_del_lif(struct ionic_lif *lif);
@@ -25,6 +26,7 @@ static inline void ionic_debugfs_add_dev(struct ionic *ionic) { }
 static inline void ionic_debugfs_del_dev(struct ionic *ionic) { }
 static inline void ionic_debugfs_add_ident(struct ionic *ionic) { }
 static inline void ionic_debugfs_add_sizes(struct ionic *ionic) { }
+static inline void ionic_debugfs_add_eq(struct ionic_eq *eq) { }
 static inline void ionic_debugfs_add_lif(struct ionic_lif *lif) { }
 static inline void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq) { }
 static inline void ionic_debugfs_del_lif(struct ionic_lif *lif) { }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 87f82f36812f..a1e45f4b0c88 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -8,7 +8,9 @@
 #include <linux/slab.h>
 #include <linux/etherdevice.h>
 #include "ionic.h"
+#include "ionic_bus.h"
 #include "ionic_dev.h"
+#include "ionic_debugfs.h"
 #include "ionic_lif.h"
 
 static void ionic_watchdog_cb(struct timer_list *t)
@@ -406,6 +408,327 @@ int ionic_db_page_num(struct ionic_lif *lif, int pid)
 	return (lif->hw_index * lif->dbid_count) + pid;
 }
 
+static void ionic_txrx_notify(struct ionic *ionic,
+			      int lif_index, int qcq_id, bool is_tx)
+{
+	struct ionic_lif *lif;
+
+	lif = radix_tree_lookup(&ionic->lifs, lif_index);
+	if (!lif)
+		return;
+
+	if (is_tx)
+		lif->txqcqs[qcq_id].qcq->armed = false;
+	else
+		lif->rxqcqs[qcq_id].qcq->armed = false;
+
+	/* We schedule rx napi, it handles both tx and rx */
+	napi_schedule_irqoff(&lif->rxqcqs[qcq_id].qcq->napi);
+}
+
+static bool ionic_next_eq_comp(struct ionic_eq *eq, int ring_index,
+			       struct ionic_eq_comp *comp)
+{
+	struct ionic_eq_ring *ring = &eq->ring[ring_index];
+	struct ionic_eq_comp *qcomp;
+	u8 gen_color;
+
+	qcomp = &ring->base[ring->index];
+	gen_color = qcomp->gen_color;
+
+	if (gen_color == (u8)(ring->gen_color - 1))
+		return false;
+
+	/* Make sure ring descriptor is up-to-date before reading */
+	smp_rmb();
+	*comp = *qcomp;
+	gen_color = comp->gen_color;
+
+	if (gen_color != ring->gen_color) {
+		dev_err(eq->ionic->dev,
+			"eq %u ring %u missed %u events\n",
+			eq->index, ring_index,
+			eq->depth * (gen_color - ring->gen_color));
+
+		ring->gen_color = gen_color;
+	}
+
+	ring->index = (ring->index + 1) & (eq->depth - 1);
+	ring->gen_color += ring->index == 0;
+
+	return true;
+}
+
+static int ionic_poll_eq_ring(struct ionic_eq *eq, int ring_index)
+{
+	struct ionic_eq_comp comp;
+	int budget = eq->depth;
+	int credits = 0;
+	int code;
+
+	while (credits < budget && ionic_next_eq_comp(eq, ring_index, &comp)) {
+		code = le16_to_cpu(comp.code);
+
+		switch (code) {
+		case IONIC_EQ_COMP_CODE_NONE:
+			break;
+		case IONIC_EQ_COMP_CODE_RX_COMP:
+		case IONIC_EQ_COMP_CODE_TX_COMP:
+			ionic_txrx_notify(eq->ionic,
+					  le16_to_cpu(comp.lif_index),
+					  le32_to_cpu(comp.qid),
+					  code == IONIC_EQ_COMP_CODE_TX_COMP);
+			break;
+		default:
+			dev_warn(eq->ionic->dev,
+				 "eq %u ring %u unrecognized event %u\n",
+				 eq->index, ring_index, code);
+			break;
+		}
+
+		credits++;
+	}
+
+	return credits;
+}
+
+static irqreturn_t ionic_eq_isr(int irq, void *data)
+{
+	struct ionic_eq *eq = data;
+	int credits;
+
+	credits = ionic_poll_eq_ring(eq, 0) + ionic_poll_eq_ring(eq, 1);
+	ionic_intr_credits(eq->ionic->idev.intr_ctrl, eq->intr.index,
+			   credits, IONIC_INTR_CRED_UNMASK);
+
+	return IRQ_HANDLED;
+}
+
+static int ionic_request_eq_irq(struct ionic *ionic, struct ionic_eq *eq)
+{
+	struct device *dev = ionic->dev;
+	struct ionic_intr_info *intr = &eq->intr;
+	const char *name = dev_name(dev);
+
+	snprintf(intr->name, sizeof(intr->name),
+		 "%s-%s-eq%d", IONIC_DRV_NAME, name, eq->index);
+
+	return devm_request_irq(dev, intr->vector, ionic_eq_isr,
+				0, intr->name, eq);
+}
+
+static int ionic_eq_alloc(struct ionic *ionic, int index)
+{
+	const int ring_bytes = sizeof(struct ionic_eq_comp) * IONIC_EQ_DEPTH;
+	struct ionic_eq *eq;
+	int err;
+
+	eq = kzalloc(sizeof(*eq), GFP_KERNEL);
+	eq->ionic = ionic;
+	eq->index = index;
+	eq->depth = IONIC_EQ_DEPTH;
+
+	err = ionic_intr_alloc(ionic, &eq->intr);
+	if (err) {
+		dev_warn(ionic->dev, "no intr for eq %u: %d\n", index, err);
+		goto err_out;
+	}
+
+	err = ionic_bus_get_irq(ionic, eq->intr.index);
+	if (err < 0) {
+		dev_warn(ionic->dev, "no vector for eq %u: %d\n", index, err);
+		goto err_out_free_intr;
+	}
+	eq->intr.vector = err;
+
+	ionic_intr_mask_assert(ionic->idev.intr_ctrl, eq->intr.index,
+			       IONIC_INTR_MASK_SET);
+
+	eq->intr.cpu = index % num_online_cpus();
+	if (cpu_online(eq->intr.cpu))
+		cpumask_set_cpu(eq->intr.cpu,
+				&eq->intr.affinity_mask);
+
+	eq->ring[0].gen_color = 1;
+	eq->ring[0].base = dma_alloc_coherent(ionic->dev, ring_bytes,
+					      &eq->ring[0].base_pa,
+					      GFP_KERNEL);
+
+	eq->ring[1].gen_color = 1;
+	eq->ring[1].base = dma_alloc_coherent(ionic->dev, ring_bytes,
+					      &eq->ring[1].base_pa,
+					      GFP_KERNEL);
+
+	ionic->eqs[index] = eq;
+
+	ionic_debugfs_add_eq(eq);
+
+	return 0;
+
+err_out_free_intr:
+	ionic_intr_free(ionic, eq->intr.index);
+err_out:
+	return err;
+}
+
+int ionic_eqs_alloc(struct ionic *ionic)
+{
+	size_t eq_size;
+	int i, err;
+
+	eq_size = sizeof(*ionic->eqs) * ionic->neth_eqs;
+	ionic->eqs = kzalloc(eq_size, GFP_KERNEL);
+	if (!ionic->eqs)
+		return -ENOMEM;
+
+	for (i = 0; i < ionic->neth_eqs; i++) {
+		err = ionic_eq_alloc(ionic, i);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void ionic_eq_free(struct ionic_eq *eq)
+{
+	const int ring_bytes = sizeof(struct ionic_eq_comp) * IONIC_EQ_DEPTH;
+	struct ionic *ionic = eq->ionic;
+
+	eq->ionic->eqs[eq->index] = NULL;
+
+	dma_free_coherent(ionic->dev, ring_bytes,
+			  eq->ring[0].base,
+			  eq->ring[0].base_pa);
+	dma_free_coherent(ionic->dev, ring_bytes,
+			  eq->ring[1].base,
+			  eq->ring[1].base_pa);
+	ionic_intr_free(ionic, eq->intr.index);
+	kfree(eq);
+}
+
+void ionic_eqs_free(struct ionic *ionic)
+{
+	int i;
+
+	if (!ionic->eqs)
+		return;
+
+	for (i = 0; i < ionic->neth_eqs; i++) {
+		if (ionic->eqs[i])
+			ionic_eq_free(ionic->eqs[i]);
+	}
+
+	kfree(ionic->eqs);
+	ionic->eqs = NULL;
+	ionic->neth_eqs = 0;
+}
+
+static void ionic_eq_deinit(struct ionic_eq *eq)
+{
+	struct ionic *ionic = eq->ionic;
+	union ionic_dev_cmd cmd = {
+		.q_control = {
+			.opcode = IONIC_CMD_Q_CONTROL,
+			.type = IONIC_QTYPE_EQ,
+			.index = cpu_to_le32(eq->index),
+			.oper = IONIC_Q_DISABLE,
+		},
+	};
+
+	if (!eq->is_init)
+		return;
+	eq->is_init = false;
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_go(&ionic->idev, &cmd);
+	ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	ionic_intr_mask(ionic->idev.intr_ctrl, eq->intr.index,
+			IONIC_INTR_MASK_SET);
+	synchronize_irq(eq->intr.vector);
+
+	irq_set_affinity_hint(eq->intr.vector, NULL);
+	devm_free_irq(ionic->dev, eq->intr.vector, eq);
+}
+
+void ionic_eqs_deinit(struct ionic *ionic)
+{
+	int i;
+
+	if (!ionic->eqs)
+		return;
+
+	for (i = 0; i < ionic->neth_eqs; i++) {
+		if (ionic->eqs[i])
+			ionic_eq_deinit(ionic->eqs[i]);
+	}
+}
+
+static int ionic_eq_init(struct ionic_eq *eq)
+{
+	struct ionic *ionic = eq->ionic;
+	union ionic_dev_cmd cmd = {
+		.q_init = {
+			.opcode = IONIC_CMD_Q_INIT,
+			.type = IONIC_QTYPE_EQ,
+			.index = cpu_to_le32(eq->index),
+			.intr_index = cpu_to_le16(eq->intr.index),
+			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
+					     IONIC_QINIT_F_ENA),
+			.ring_size = ilog2(eq->depth),
+			.ring_base = cpu_to_le64(eq->ring[0].base_pa),
+			.cq_ring_base = cpu_to_le64(eq->ring[1].base_pa),
+		},
+	};
+	int err;
+
+	ionic_intr_mask(ionic->idev.intr_ctrl, eq->intr.index,
+			IONIC_INTR_MASK_SET);
+	ionic_intr_clean(ionic->idev.intr_ctrl, eq->intr.index);
+
+	err = ionic_request_eq_irq(ionic, eq);
+	if (err) {
+		dev_warn(ionic->dev, "eq %d irq request failed %d\n",
+			 eq->index, err);
+		return err;
+	}
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_go(&ionic->idev, &cmd);
+	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	if (err) {
+		dev_err(ionic->dev, "eq %d init failed %d\n",
+			eq->index, err);
+		return err;
+	}
+
+	ionic_intr_mask(ionic->idev.intr_ctrl, eq->intr.index,
+			IONIC_INTR_MASK_CLEAR);
+
+	eq->is_init = true;
+
+	return 0;
+}
+
+int ionic_eqs_init(struct ionic *ionic)
+{
+	int i, err;
+
+	for (i = 0; i < ionic->neth_eqs; i++) {
+		if (ionic->eqs[i]) {
+			err = ionic_eq_init(ionic->eqs[i]);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
 int ionic_cq_init(struct ionic_lif *lif, struct ionic_cq *cq,
 		  struct ionic_intr_info *intr,
 		  unsigned int num_descs, size_t desc_size)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index d40be30536ae..a9e7249b5680 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -313,6 +313,11 @@ void ionic_dev_cmd_adminq_init(struct ionic_dev *idev, struct ionic_qcq *qcq,
 
 int ionic_db_page_num(struct ionic_lif *lif, int pid);
 
+int ionic_eqs_alloc(struct ionic *ionic);
+void ionic_eqs_free(struct ionic *ionic);
+void ionic_eqs_deinit(struct ionic *ionic);
+int ionic_eqs_init(struct ionic *ionic);
+
 int ionic_cq_init(struct ionic_lif *lif, struct ionic_cq *cq,
 		  struct ionic_intr_info *intr,
 		  unsigned int num_descs, size_t desc_size);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1eb3bd4016ce..9150cca06b77 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -149,7 +149,7 @@ static int ionic_request_napi_irq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 				0, intr->name, &qcq->napi);
 }
 
-static int ionic_intr_alloc(struct ionic *ionic, struct ionic_intr_info *intr)
+int ionic_intr_alloc(struct ionic *ionic, struct ionic_intr_info *intr)
 {
 	int index;
 
@@ -166,7 +166,7 @@ static int ionic_intr_alloc(struct ionic *ionic, struct ionic_intr_info *intr)
 	return 0;
 }
 
-static void ionic_intr_free(struct ionic *ionic, int index)
+void ionic_intr_free(struct ionic *ionic, int index)
 {
 	if (index != INTR_INDEX_NOT_ASSIGNED && index < ionic->nintrs)
 		clear_bit(index, ionic->intrs);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 48d4592c6c9f..bb9202a10ac1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -63,6 +63,7 @@ struct ionic_qcq {
 	void *base;
 	dma_addr_t base_pa;
 	unsigned int total_size;
+	bool armed;
 	struct ionic_queue q;
 	struct ionic_cq cq;
 	struct ionic_intr_info intr;
@@ -236,6 +237,8 @@ int ionic_lifs_size(struct ionic *ionic);
 int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
 			 const u8 *key, const u32 *indir);
 
+int ionic_intr_alloc(struct ionic *ionic, struct ionic_intr_info *intr);
+void ionic_intr_free(struct ionic *ionic, int index);
 int ionic_open(struct net_device *netdev);
 int ionic_stop(struct net_device *netdev);
 int ionic_reset_queues(struct ionic_lif *lif);
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9F3259E06
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbgIASVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730154AbgIASUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:20:35 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C27EC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 11:20:35 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id l9so951794plt.8
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 11:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QEWBmF7mxuFaQTul7NuNZ0DPovAakZ98Qlci7Hu+xmw=;
        b=Xz70qsMP+FziNRJr/Ek55m7EXFd/U9tV0OOPQeYcXFxPjuwR0HYWOCjA9VWSR//j7z
         LieeFuKIO8Cl6fDUlGbyO8pLtinUUN2ldWcj9MoMwd1uRiPBushMpuZ+gUwglpQ42xmP
         kjDsVgtJ8CB88PRWIBqH1QMvIGAKEJMHPkSuVv03Km0r1ob8iy3qrtX9glNQsh8ZZT4X
         GEGWxV1fnMypY6mR5E/DpSeNgL5jnRMRAUn3lRYpoObz4FbQjPRxlxN3Q3aRAkAlN6jR
         RO+Dm7eejsjKBYDhPmhfRF6X5VoOcDlUfFwmh0uewMh7QdCtYyGvVXwSy/duBW4aoLcg
         +g6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QEWBmF7mxuFaQTul7NuNZ0DPovAakZ98Qlci7Hu+xmw=;
        b=JV+fBGNdJkqr/5lxeElw/5W2/lxrj4PIzxEtAfSbogmBa6hPJ2CZs14j6SnSURqLjJ
         frOsfkzayEts3UNjICXW7C08in3UxF0pYukCB/KkmpFyQVhjly/7b7Wvau3fNyq7gBmQ
         eCfBM0Kh7qop/AvtHcEyHLGjTF0H0OezVkgyL4n2b7D6AGzsdxUgm/24casPu0Olxt5a
         gC1H56NtrtxcXdBYxcEH9ybq5/pXPY/16DZwHPL0bE+RsDPkxokAvsNQL+7mdYKtkyW+
         4PHCtMv7el0Ws3b8F14FN14M9sQ1rfyUQgBzKaYVtpDsErMzYR8roF8o6BhJA5GPVeXj
         8Chg==
X-Gm-Message-State: AOAM530E/9nH64ekAz3iuGToQ7TxHG4LIUhQxk+kx8rGxRFT1606rJJg
        ak8O49jVJTcwqXQzGu56g8bfzE+vavibvQ==
X-Google-Smtp-Source: ABdhPJzk+rl7xEWaZOsKsbyaZkWkv/7EY4CkDQyINFi0L0QPyqZZPUi3bipyfcw7OGG8UPWi5vqpmg==
X-Received: by 2002:a17:902:8a85:: with SMTP id p5mr2543498plo.193.1598984434179;
        Tue, 01 Sep 2020 11:20:34 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id j81sm2747086pfd.213.2020.09.01.11.20.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 11:20:33 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 3/6] ionic: clean up desc_info and cq_info structs
Date:   Tue,  1 Sep 2020 11:20:21 -0700
Message-Id: <20200901182024.64101-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901182024.64101-1-snelson@pensando.io>
References: <20200901182024.64101-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove some unnecessary struct fields and related code.

Co-developed-by: Neel Patel <neel@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 33 ++-----------------
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  6 ----
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  8 +++--
 3 files changed, 8 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 3645673b4b18..6068f51a11d9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -467,9 +467,7 @@ int ionic_cq_init(struct ionic_lif *lif, struct ionic_cq *cq,
 		  struct ionic_intr_info *intr,
 		  unsigned int num_descs, size_t desc_size)
 {
-	struct ionic_cq_info *cur;
 	unsigned int ring_size;
-	unsigned int i;
 
 	if (desc_size == 0 || !is_power_of_2(num_descs))
 		return -EINVAL;
@@ -485,19 +483,6 @@ int ionic_cq_init(struct ionic_lif *lif, struct ionic_cq *cq,
 	cq->tail_idx = 0;
 	cq->done_color = 1;
 
-	cur = cq->info;
-
-	for (i = 0; i < num_descs; i++) {
-		if (i + 1 == num_descs) {
-			cur->next = cq->info;
-			cur->last = true;
-		} else {
-			cur->next = cur + 1;
-		}
-		cur->index = i;
-		cur++;
-	}
-
 	return 0;
 }
 
@@ -551,9 +536,7 @@ int ionic_q_init(struct ionic_lif *lif, struct ionic_dev *idev,
 		 unsigned int num_descs, size_t desc_size,
 		 size_t sg_desc_size, unsigned int pid)
 {
-	struct ionic_desc_info *cur;
 	unsigned int ring_size;
-	unsigned int i;
 
 	if (desc_size == 0 || !is_power_of_2(num_descs))
 		return -EINVAL;
@@ -574,18 +557,6 @@ int ionic_q_init(struct ionic_lif *lif, struct ionic_dev *idev,
 
 	snprintf(q->name, sizeof(q->name), "L%d-%s%u", lif->index, name, index);
 
-	cur = q->info;
-
-	for (i = 0; i < num_descs; i++) {
-		if (i + 1 == num_descs)
-			cur->next = q->info;
-		else
-			cur->next = cur + 1;
-		cur->index = i;
-		cur->left = num_descs - i;
-		cur++;
-	}
-
 	return 0;
 }
 
@@ -652,6 +623,7 @@ void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 	struct ionic_desc_info *desc_info;
 	ionic_desc_cb cb;
 	void *cb_arg;
+	u16 index;
 
 	/* check for empty queue */
 	if (q->tail_idx == q->head_idx)
@@ -665,6 +637,7 @@ void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 
 	do {
 		desc_info = &q->info[q->tail_idx];
+		index = q->tail_idx;
 		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 
 		cb = desc_info->cb;
@@ -675,5 +648,5 @@ void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 
 		if (cb)
 			cb(q, desc_info, cq_info, cb_arg);
-	} while (desc_info->index != stop_index);
+	} while (index != stop_index);
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 0641ca2e1780..4a35174e3ff1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -156,9 +156,6 @@ struct ionic_cq_info {
 		struct ionic_admin_comp *admincq;
 		struct ionic_notifyq_event *notifyq;
 	};
-	struct ionic_cq_info *next;
-	unsigned int index;
-	bool last;
 };
 
 struct ionic_queue;
@@ -186,9 +183,6 @@ struct ionic_desc_info {
 		struct ionic_txq_sg_desc *txq_sg_desc;
 		struct ionic_rxq_sg_desc *rxq_sgl_desc;
 	};
-	struct ionic_desc_info *next;
-	unsigned int index;
-	unsigned int left;
 	unsigned int npages;
 	struct ionic_page_info pages[IONIC_RX_MAX_SG_ELEMS + 1];
 	ionic_desc_cb cb;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index bbc926bc3852..060aaf00caed 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -238,10 +238,10 @@ static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	if (q->tail_idx == q->head_idx)
 		return false;
 
-	desc_info = &q->info[q->tail_idx];
-	if (desc_info->index != le16_to_cpu(comp->comp_index))
+	if (q->tail_idx != le16_to_cpu(comp->comp_index))
 		return false;
 
+	desc_info = &q->info[q->tail_idx];
 	q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 
 	/* clean the related q entry, only one per qc completion */
@@ -635,6 +635,7 @@ static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	struct ionic_txq_comp *comp = cq_info->cq_desc;
 	struct ionic_queue *q = cq->bound_q;
 	struct ionic_desc_info *desc_info;
+	u16 index;
 
 	if (!color_match(comp->color, cq->done_color))
 		return false;
@@ -644,11 +645,12 @@ static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	 */
 	do {
 		desc_info = &q->info[q->tail_idx];
+		index = q->tail_idx;
 		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 		ionic_tx_clean(q, desc_info, cq_info, desc_info->cb_arg);
 		desc_info->cb = NULL;
 		desc_info->cb_arg = NULL;
-	} while (desc_info->index != le16_to_cpu(comp->comp_index));
+	} while (index != le16_to_cpu(comp->comp_index));
 
 	return true;
 }
-- 
2.17.1


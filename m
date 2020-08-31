Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657AB258476
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 01:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgHaXgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 19:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgHaXgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 19:36:14 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE96C061755
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:13 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g29so1621269pgl.2
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=V7QfDockLLbnm32/uHygO4bTj+4k1jhtJya2L/zQsc8=;
        b=JRYGBKzY2wpf+8KZBkjIYZdXEXVVOmNEGiLeIGO54kAFaDF27PaYavinTnBOYkZoa6
         3Xgyf+8XwkNkCOxWYY29kxk0KF5SLV5mKv7Wr2naNUTscwn3IrHOH2m3yima2DhcqhvN
         qCt38a+bbz9U7IDiDuOIP/m/+dl5J0ZKUQH5hdtC1U3tLk/w9sr3yjcJRxvVU+M7H8G1
         z7RFTAaKab7yoNIUS8cauefiX5+NighbA/ruCVRzeL5xbeTIhDU8327qrMeJcDwuLLIG
         r5gRsxg7P0W1vZyZd2JyzCcEhzQL22fxlAF+HPv8NfVHS95F+7ewmAHhC7Gjqxrz7vrU
         H3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V7QfDockLLbnm32/uHygO4bTj+4k1jhtJya2L/zQsc8=;
        b=WXuvvqnHKhP0EEGxU9vNqTTDu5ov932l4bIDdKLSQOT52kp07uwLIGp3/DFlP9qlfa
         uYiBapMfMJXjWBtPmtZxJYlv/OCosxLeP2VovT+00Q8Ilmba3luxqu0lW5TjPZKIsC3f
         WhxVAxgMZdflku6BFWfA5zEv1kIEqYTRnbJ8c5TPpVG73I+VNBuEK9bK00wplQV+N3u8
         0KzBagxiG17ybWzTQDB0TjGgXxLEsJSMGHp3kC0UEZBZvYOhjhj6LRs6ru5LdTGNKRTB
         nb/lIqvk1IMOUaGY8V/lOCPNSrcOgq5nIRDzM3ShjsEfKFOZNJG7ZKgr3fDGcblTsrod
         Mzjw==
X-Gm-Message-State: AOAM531+d8rx41MjrnMXZDYuQ3h5wOVVI36MbO8BMyeFnY7P1It2Qk/h
        Cez+sIUGUvpmbsuubaaeVPET7GkBzVmVCw==
X-Google-Smtp-Source: ABdhPJzJkFdGLs6AgmhMOFRh1I5W70NqKdodwEfevJ4HFmX9tbSsodllOHwvoeEenqmKe/z4FVMH4A==
X-Received: by 2002:a63:c343:: with SMTP id e3mr2931097pgd.288.1598916971623;
        Mon, 31 Aug 2020 16:36:11 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 65sm9082651pfx.104.2020.08.31.16.36.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Aug 2020 16:36:11 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>, Neel Patel <neel@pensando.io>
Subject: [PATCH net-next 4/5] ionic: clean up desc_info and cq_info structs
Date:   Mon, 31 Aug 2020 16:35:57 -0700
Message-Id: <20200831233558.71417-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831233558.71417-1-snelson@pensando.io>
References: <20200831233558.71417-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove some unnecessary struct fields and related code.

Signed-off-by: Neel Patel <neel@pensando.io>
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
index 87debc512755..21c3ce9ee446 100644
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
index efc02b366e73..8ba14792616f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -240,10 +240,10 @@ static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	if (q->tail_idx == q->head_idx)
 		return false;
 
-	desc_info = &q->info[q->tail_idx];
-	if (desc_info->index != le16_to_cpu(comp->comp_index))
+	if (q->tail_idx != le16_to_cpu(comp->comp_index))
 		return false;
 
+	desc_info = &q->info[q->tail_idx];
 	q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 
 	/* clean the related q entry, only one per qc completion */
@@ -637,6 +637,7 @@ static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	struct ionic_txq_comp *comp = cq_info->cq_desc;
 	struct ionic_queue *q = cq->bound_q;
 	struct ionic_desc_info *desc_info;
+	u16 index;
 
 	if (!color_match(comp->color, cq->done_color))
 		return false;
@@ -646,11 +647,12 @@ static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
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


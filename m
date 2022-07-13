Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CE7573518
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbiGMLO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiGMLOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:14:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6106BF273D
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657710884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5uTN0iYXNQJ821H3571k1jB4mSJSAImIFfOFFCQD7EA=;
        b=K9HLUn3ztQ9qX1TjXccc5+CExGKfhaFWLijrt07asGmmzU9CwHKAzxH2PMd53webk4EEhs
        RyaEql17RYJvvdg3Y2uthSyj6sdkBOaYKotZVZayv2ahAweQesFKYXt8qUgyJPJ1IuAkqb
        GxmLTSJGURRIgjyVAqk97Dmv6YtAazw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-o_Bn3WeyPpycxCAhvmgjJQ-1; Wed, 13 Jul 2022 07:14:42 -0400
X-MC-Unique: o_Bn3WeyPpycxCAhvmgjJQ-1
Received: by mail-ed1-f71.google.com with SMTP id o13-20020a056402438d00b0043aa846b2d2so8095991edc.8
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5uTN0iYXNQJ821H3571k1jB4mSJSAImIFfOFFCQD7EA=;
        b=hLYoTXnuhd4noHSiOZvDgK+29eCqqroKwN/kL+s0LCaXzHTt3JX3FyYWU1zvo4J9jq
         R5xGUBhQXude94kYlMETFF9FwedfWUhbjfhkLMlBa2O0DUR8etxaSDQ+Gk8IoFpLCNKB
         810gKFsYcE2C2peHA3RUIagZd3O8xZTeWSF8BEQms9NA2/J5gzkYLcApit3dxuxqzga1
         qgfSJfXY313WitF+uDJ/+H1V2ZyyvZqlMKS0QR94/Tad1sARQNQbLVQQGFDEOsw7sD7/
         vEYFtVAcJqDMwisDnBEuE1Sxa5v8IkvQpRMhM1XNvavD4x5M6usEjMTE09qq6naCjcqe
         Rpkw==
X-Gm-Message-State: AJIora9D7eGlLS5YR+GX6KKU98Z0JEZzs8d5WYfo0boBmS2cwB/H73zL
        23uMRV+fywePQi2GNHlCS7CtuGARrT97GVyjvdPLporJEnn/2p2ns9ACOKAsxxvj+2eYMi1ySKO
        j+yhuOF724HccFxWj
X-Received: by 2002:a17:907:96a4:b0:72b:647e:30fd with SMTP id hd36-20020a17090796a400b0072b647e30fdmr2783285ejc.723.1657710879630;
        Wed, 13 Jul 2022 04:14:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s+UMwr1jDtKqGwgGJgq+K7hLtOvFBF7ZuxlDiEr1YBHhUDN+xlRVuVdg/F1JB6u+6X7oIh0g==
X-Received: by 2002:a17:907:96a4:b0:72b:647e:30fd with SMTP id hd36-20020a17090796a400b0072b647e30fdmr2783103ejc.723.1657710877318;
        Wed, 13 Jul 2022 04:14:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p20-20020a056402155400b0043a896048basm7787960edx.85.2022.07.13.04.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:14:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7A6D74D9905; Wed, 13 Jul 2022 13:14:35 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC PATCH 05/17] pifomap: Add queue rotation for continuously increasing rank mode
Date:   Wed, 13 Jul 2022 13:14:13 +0200
Message-Id: <20220713111430.134810-6-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amend the PIFO map so it can operate in a mode that allows the range to
increase continuously. This works by allocating two underlying queues, and
queueing entries into the second one if the first one overflows. When the
primary queue runs empty, if there are entries in the secondary queue, swap
the two queues and shift the operating range of the new secondary queue to
be after the (new) primary. This way the queue can support a continuously
increasing rank, for instance to index by timestamps.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/pifomap.c | 96 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 75 insertions(+), 21 deletions(-)

diff --git a/kernel/bpf/pifomap.c b/kernel/bpf/pifomap.c
index 5040f532e5d8..62633c2c7419 100644
--- a/kernel/bpf/pifomap.c
+++ b/kernel/bpf/pifomap.c
@@ -6,6 +6,7 @@
 #include <linux/bpf.h>
 #include <linux/bitops.h>
 #include <linux/btf_ids.h>
+#include <linux/minmax.h>
 #include <net/xdp.h>
 #include <linux/filter.h>
 #include <trace/events/xdp.h>
@@ -44,7 +45,8 @@ struct bpf_pifo_queue {
 
 struct bpf_pifo_map {
 	struct bpf_map map;
-	struct bpf_pifo_queue *queue;
+	struct bpf_pifo_queue *q_primary;
+	struct bpf_pifo_queue *q_secondary;
 	unsigned long num_queued;
 	spinlock_t lock; /* protects enqueue / dequeue */
 
@@ -71,6 +73,12 @@ static bool pifo_map_is_full(struct bpf_pifo_map *pifo)
 	return pifo->num_queued >= pifo->map.max_entries;
 }
 
+static bool pifo_queue_is_empty(struct bpf_pifo_queue *queue)
+{
+	/* first word in bitmap is always the top-level map */
+	return !queue->bitmap[0];
+}
+
 static void pifo_queue_free(struct bpf_pifo_queue *q)
 {
 	bpf_map_area_free(q->buckets);
@@ -79,7 +87,7 @@ static void pifo_queue_free(struct bpf_pifo_queue *q)
 	kfree(q);
 }
 
-static struct bpf_pifo_queue *pifo_queue_alloc(u32 range, int numa_node)
+static struct bpf_pifo_queue *pifo_queue_alloc(u32 range, u32 min_rank, int numa_node)
 {
 	u32 num_longs = 0, offset = 0, i, lvl, levels;
 	struct bpf_pifo_queue *q;
@@ -112,6 +120,7 @@ static struct bpf_pifo_queue *pifo_queue_alloc(u32 range, int numa_node)
 	}
 	q->levels = levels;
 	q->range = range;
+	q->min_rank = min_rank;
 	return q;
 
 err:
@@ -131,10 +140,14 @@ static int pifo_map_init_map(struct bpf_pifo_map *pifo, union bpf_attr *attr,
 
 	bpf_map_init_from_attr(&pifo->map, attr);
 
-	pifo->queue = pifo_queue_alloc(range, pifo->map.numa_node);
-	if (!pifo->queue)
+	pifo->q_primary = pifo_queue_alloc(range, 0, pifo->map.numa_node);
+	if (!pifo->q_primary)
 		return -ENOMEM;
 
+	pifo->q_secondary = pifo_queue_alloc(range, range, pifo->map.numa_node);
+	if (!pifo->q_secondary)
+		goto err_queue;
+
 	if (attr->map_type == BPF_MAP_TYPE_PIFO_GENERIC) {
 		size_t cache_size;
 		int i;
@@ -144,7 +157,7 @@ static int pifo_map_init_map(struct bpf_pifo_map *pifo, union bpf_attr *attr,
 		pifo->elem_cache = bpf_map_area_alloc(cache_size,
 						      pifo->map.numa_node);
 		if (!pifo->elem_cache)
-			goto err_queue;
+			goto err;
 
 		for (i = 0; i < attr->max_entries; i++)
 			pifo->elem_cache->elements[i] = (void *)&pifo->elements[i * elem_size];
@@ -153,8 +166,10 @@ static int pifo_map_init_map(struct bpf_pifo_map *pifo, union bpf_attr *attr,
 
 	return 0;
 
+err:
+	pifo_queue_free(pifo->q_secondary);
 err_queue:
-	pifo_queue_free(pifo->queue);
+	pifo_queue_free(pifo->q_primary);
 	return err;
 }
 
@@ -238,9 +253,12 @@ static void pifo_map_free(struct bpf_map *map)
 
 	synchronize_rcu();
 
-	if (map->map_type == BPF_MAP_TYPE_PIFO_XDP)
-		pifo_queue_flush(pifo->queue);
-	pifo_queue_free(pifo->queue);
+	if (map->map_type == BPF_MAP_TYPE_PIFO_XDP) {
+		pifo_queue_flush(pifo->q_primary);
+		pifo_queue_flush(pifo->q_secondary);
+	}
+	pifo_queue_free(pifo->q_primary);
+	pifo_queue_free(pifo->q_secondary);
 	bpf_map_area_free(pifo->elem_cache);
 	bpf_map_area_free(pifo);
 }
@@ -249,7 +267,7 @@ static int pifo_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 {
 	struct bpf_pifo_map *pifo = container_of(map, struct bpf_pifo_map, map);
 	u32 index = key ? *(u32 *)key : U32_MAX, offset;
-	struct bpf_pifo_queue *queue = pifo->queue;
+	struct bpf_pifo_queue *queue = pifo->q_primary;
 	unsigned long idx, flags;
 	u32 *next = next_key;
 	int ret = -ENOENT;
@@ -261,15 +279,27 @@ static int pifo_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	else
 		offset = index - queue->min_rank + 1;
 
-	if (offset >= queue->range)
-		goto out;
+	if (offset >= queue->range) {
+		offset -= queue->range;
+		queue = pifo->q_secondary;
+
+		if (offset >= queue->range)
+			goto out;
+	}
 
+search:
 	idx = find_next_bit(queue->lvl_bitmap[queue->levels - 1],
 			    queue->range, offset);
-	if (idx == queue->range)
+	if (idx == queue->range) {
+		if (queue == pifo->q_primary) {
+			queue = pifo->q_secondary;
+			offset = 0;
+			goto search;
+		}
 		goto out;
+	}
 
-	*next = idx;
+	*next = idx + queue->min_rank;
 	ret = 0;
 out:
 	spin_unlock_irqrestore(&pifo->lock, flags);
@@ -316,7 +346,7 @@ static void pifo_item_set_next(union bpf_pifo_item *item, void *next, bool xdp)
 static int __pifo_map_enqueue(struct bpf_pifo_map *pifo, union bpf_pifo_item *item,
 			      u64 rank, bool xdp)
 {
-	struct bpf_pifo_queue *queue = pifo->queue;
+	struct bpf_pifo_queue *queue = pifo->q_primary;
 	struct bpf_pifo_bucket *bucket;
 	u64 q_index;
 
@@ -331,8 +361,16 @@ static int __pifo_map_enqueue(struct bpf_pifo_map *pifo, union bpf_pifo_item *it
 	pifo_item_set_next(item, NULL, xdp);
 
 	q_index = rank - queue->min_rank;
-	if (unlikely(q_index >= queue->range))
-		q_index = queue->range - 1;
+	if (unlikely(q_index >= queue->range)) {
+		/* If we overflow the primary queue, enqueue into secondary, and
+		 * if we overflow that enqueue as the last item
+		 */
+		q_index -= queue->range;
+		queue = pifo->q_secondary;
+
+		if (q_index >= queue->range)
+			q_index = queue->range - 1;
+	}
 
 	bucket = &queue->buckets[q_index];
 	if (likely(!bucket->head)) {
@@ -380,7 +418,7 @@ static unsigned long pifo_find_first_bucket(struct bpf_pifo_queue *queue)
 static union bpf_pifo_item *__pifo_map_dequeue(struct bpf_pifo_map *pifo,
 					       u64 flags, u64 *rank, bool xdp)
 {
-	struct bpf_pifo_queue *queue = pifo->queue;
+	struct bpf_pifo_queue *queue = pifo->q_primary;
 	struct bpf_pifo_bucket *bucket;
 	union bpf_pifo_item *item;
 	unsigned long bucket_idx;
@@ -392,6 +430,17 @@ static union bpf_pifo_item *__pifo_map_dequeue(struct bpf_pifo_map *pifo,
 		return NULL;
 	}
 
+	if (!pifo->num_queued) {
+		*rank = -ENOENT;
+		return NULL;
+	}
+
+	if (unlikely(pifo_queue_is_empty(queue))) {
+		swap(pifo->q_primary, pifo->q_secondary);
+		pifo->q_secondary->min_rank = pifo->q_primary->min_rank + pifo->q_primary->range;
+		queue = pifo->q_primary;
+	}
+
 	bucket_idx = pifo_find_first_bucket(queue);
 	if (bucket_idx == -1) {
 		*rank = -ENOENT;
@@ -437,7 +486,7 @@ struct xdp_frame *pifo_map_dequeue(struct bpf_map *map, u64 flags, u64 *rank)
 static void *pifo_map_lookup_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_pifo_map *pifo = container_of(map, struct bpf_pifo_map, map);
-	struct bpf_pifo_queue *queue = pifo->queue;
+	struct bpf_pifo_queue *queue = pifo->q_primary;
 	struct bpf_pifo_bucket *bucket;
 	u32 rank =  *(u32 *)key, idx;
 
@@ -445,8 +494,13 @@ static void *pifo_map_lookup_elem(struct bpf_map *map, void *key)
 		return NULL;
 
 	idx = rank - queue->min_rank;
-	if (idx >= queue->range)
-		return NULL;
+	if (idx >= queue->range) {
+		idx -= queue->range;
+		queue = pifo->q_secondary;
+
+		if (idx >= queue->range)
+			return NULL;
+	}
 
 	bucket = &queue->buckets[idx];
 	/* FIXME: what happens if this changes while userspace is reading the
-- 
2.37.0


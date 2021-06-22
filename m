Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CFA3B0DEB
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhFVT7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhFVT7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 15:59:34 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21072C061574;
        Tue, 22 Jun 2021 12:57:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c5so408208pfv.8;
        Tue, 22 Jun 2021 12:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=20nb8KzeEaZgj2qUFrSrust+n5BKnA+5y51TvNtOAxI=;
        b=sL7lz1mTWkUhM3H/i96bmNxY1DTlwiahEEQU/VS0571jiPaAxwDj8H0iKLQPOcD5/U
         n4mkhwe6YczjD13vQ3j6AKWz3NSUMEy4jpHrdBpai3bVnDSHhjKX8ZFis0RhCLQq3mIO
         ph89UnZwKw0FCO5jYPnh6DwCW89Zqp+AUs77lmAD2pmMI6qKGuRHaskQ5TMnphyVJP/Q
         B2AeVlE8YoHDFfmeyvdABo+Btmb/oEP6KoMkw91Ud1P7OlV+ehgim0B5LeDdOHKGcYtq
         KC4wZQP+f3jaT8BSudeXtGZ6FDAgmn5K+xAx9nslOFuf6xASZ085+DPxwDlEGEgYF3kU
         x5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=20nb8KzeEaZgj2qUFrSrust+n5BKnA+5y51TvNtOAxI=;
        b=SRe0brC+hE2HxJdCAf3TZckFy2yHvOqpu4N/aLQF8OAftl+nwfqnTPLuqgT99pNmdU
         3dJV974qESkbbBPAVGxUsNccpxPrK28o+1+4dCNLsk45UEt1NA2TmZhDRSHtNTJKP0Vr
         4MJntywljlLUeofCHewTIOIk4X5EkjsZeZX9TuJdELcgg0SWO0Vd4K8ZgNnDhJXvuLXY
         nkoQ1jZPvpbojZED2RoD6cxp0sbknSWl6FqqWXj6/hEmLRXL51nTYa7S7zn7Yk5yoqMr
         NuqW9z+smLFOGzg5MUdpXixDSfzHpG7NPR+mHSlJSLYcUYBVZl7jnw/ZJhFCWkClbJKh
         9xuQ==
X-Gm-Message-State: AOAM5323BtxC8v7RyG+YwBp/eLt/HAdEs7eGbIqym4vBLFM/MNjsvRsw
        a7AANK3HEvz26ojctcsXzSTacjD8H14=
X-Google-Smtp-Source: ABdhPJw4KAHnkibnV2eTiRd62i77XY1KYxGQ0MEAj/xR+hAtLvLdpfuLcfHHGHIHwu0LLG1ujrZfSg==
X-Received: by 2002:a62:3344:0:b029:25e:a0a8:1c51 with SMTP id z65-20020a6233440000b029025ea0a81c51mr5297368pfz.58.1624391837446;
        Tue, 22 Jun 2021 12:57:17 -0700 (PDT)
Received: from localhost ([2402:3a80:11bb:33b3:7f0c:3646:8bde:417e])
        by smtp.gmail.com with ESMTPSA id s42sm140473pfw.184.2021.06.22.12.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 12:57:17 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v2 3/5] bpf: cpumap: implement generic cpumap
Date:   Wed, 23 Jun 2021 01:25:25 +0530
Message-Id: <20210622195527.1110497-4-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622195527.1110497-1-memxor@gmail.com>
References: <20210622195527.1110497-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change implements CPUMAP redirect support for generic XDP programs.
The idea is to reuse the cpu map entry's queue that is used to push
native xdp frames for redirecting skb to a different CPU. This will
match native XDP behavior (in that RPS is invoked again for packet
reinjected into networking stack).

To be able to determine whether the incoming skb is from the driver or
cpumap, we reuse skb->redirected bit that skips generic XDP processing
when it is set. To always make use of this, CONFIG_NET_REDIRECT guard on
it has been lifted and it is always available.

From the redirect side, we add the skb to ptr_ring with its lowest bit
set to 1.  This should be safe as skb is not 1-byte aligned. This allows
kthread to discern between xdp_frames and sk_buff. On consumption of the
ptr_ring item, the lowest bit is unset.

In the end, the skb is simply added to the list that kthread is anyway
going to maintain for xdp_frames converted to skb, and then received
again by using netif_receive_skb_list.

Bulking optimization for generic cpumap is left as an exercise for a
future patch for now.

Since cpumap entry progs are now supported, also remove check in
generic_xdp_install for the cpumap.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h    |   9 +++-
 include/linux/skbuff.h |  10 +---
 kernel/bpf/cpumap.c    | 115 +++++++++++++++++++++++++++++++++++------
 net/core/dev.c         |   3 +-
 net/core/filter.c      |   6 ++-
 5 files changed, 115 insertions(+), 28 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f309fc1509f2..095aaa104c56 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1513,7 +1513,8 @@ bool dev_map_can_have_prog(struct bpf_map *map);
 void __cpu_map_flush(void);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
-bool cpu_map_prog_allowed(struct bpf_map *map);
+int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
+			     struct sk_buff *skb);
 
 /* Return map's numa specified by userspace */
 static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
@@ -1710,6 +1711,12 @@ static inline int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu,
 	return 0;
 }
 
+static inline int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
+					   struct sk_buff *skb)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline bool cpu_map_prog_allowed(struct bpf_map *map)
 {
 	return false;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b2db9cd9a73f..f19190820e63 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -863,8 +863,8 @@ struct sk_buff {
 	__u8			tc_skip_classify:1;
 	__u8			tc_at_ingress:1;
 #endif
-#ifdef CONFIG_NET_REDIRECT
 	__u8			redirected:1;
+#ifdef CONFIG_NET_REDIRECT
 	__u8			from_ingress:1;
 #endif
 #ifdef CONFIG_TLS_DEVICE
@@ -4664,17 +4664,13 @@ static inline __wsum lco_csum(struct sk_buff *skb)
 
 static inline bool skb_is_redirected(const struct sk_buff *skb)
 {
-#ifdef CONFIG_NET_REDIRECT
 	return skb->redirected;
-#else
-	return false;
-#endif
 }
 
 static inline void skb_set_redirected(struct sk_buff *skb, bool from_ingress)
 {
-#ifdef CONFIG_NET_REDIRECT
 	skb->redirected = 1;
+#ifdef CONFIG_NET_REDIRECT
 	skb->from_ingress = from_ingress;
 	if (skb->from_ingress)
 		skb->tstamp = 0;
@@ -4683,9 +4679,7 @@ static inline void skb_set_redirected(struct sk_buff *skb, bool from_ingress)
 
 static inline void skb_reset_redirect(struct sk_buff *skb)
 {
-#ifdef CONFIG_NET_REDIRECT
 	skb->redirected = 0;
-#endif
 }
 
 static inline bool skb_csum_is_sctp(struct sk_buff *skb)
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index a1a0c4e791c6..57f751212a9d 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -16,6 +16,7 @@
  * netstack, and assigning dedicated CPUs for this stage.  This
  * basically allows for 10G wirespeed pre-filtering via bpf.
  */
+#include <linux/bitops.h>
 #include <linux/bpf.h>
 #include <linux/filter.h>
 #include <linux/ptr_ring.h>
@@ -168,6 +169,49 @@ static void put_cpu_map_entry(struct bpf_cpu_map_entry *rcpu)
 	}
 }
 
+static void cpu_map_bpf_prog_run_skb(struct bpf_cpu_map_entry *rcpu,
+				     struct list_head *listp,
+				     struct xdp_cpumap_stats *stats)
+{
+	struct xdp_buff xdp;
+	struct sk_buff *skb;
+	u32 act;
+	int err;
+
+	if (!rcpu->prog)
+		return;
+
+	list_for_each_entry(skb, listp, list) {
+		act = bpf_prog_run_generic_xdp(skb, &xdp, rcpu->prog);
+		switch (act) {
+		case XDP_PASS:
+			break;
+		case XDP_REDIRECT:
+			skb_list_del_init(skb);
+			err = xdp_do_generic_redirect(skb->dev, skb, &xdp,
+						      rcpu->prog);
+			if (unlikely(err)) {
+				kfree_skb(skb);
+				stats->drop++;
+			} else {
+				stats->redirect++;
+			}
+			return;
+		default:
+			bpf_warn_invalid_xdp_action(act);
+			fallthrough;
+		case XDP_ABORTED:
+			trace_xdp_exception(skb->dev, rcpu->prog, act);
+			fallthrough;
+		case XDP_DROP:
+			skb_list_del_init(skb);
+			kfree_skb(skb);
+			stats->drop++;
+			return;
+		}
+	}
+}
+
 static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 				    void **frames, int n,
 				    struct xdp_cpumap_stats *stats)
@@ -179,8 +223,6 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 	if (!rcpu->prog)
 		return n;
 
-	rcu_read_lock_bh();
-
 	xdp_set_return_frame_no_direct();
 	xdp.rxq = &rxq;
 
@@ -227,17 +269,34 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 		}
 	}
 
+	xdp_clear_return_frame_no_direct();
+
+	return nframes;
+}
+
+#define CPUMAP_BATCH 8
+
+static int cpu_map_bpf_prog_run(struct bpf_cpu_map_entry *rcpu, void **frames,
+				int xdp_n, struct xdp_cpumap_stats *stats,
+				struct list_head *list)
+{
+	int nframes;
+
+	rcu_read_lock_bh();
+
+	nframes = cpu_map_bpf_prog_run_xdp(rcpu, frames, xdp_n, stats);
+
 	if (stats->redirect)
-		xdp_do_flush_map();
+		xdp_do_flush();
 
-	xdp_clear_return_frame_no_direct();
+	if (unlikely(!list_empty(list)))
+		cpu_map_bpf_prog_run_skb(rcpu, list, stats);
 
-	rcu_read_unlock_bh(); /* resched point, may call do_softirq() */
+	rcu_read_unlock_bh();
 
 	return nframes;
 }
 
-#define CPUMAP_BATCH 8
 
 static int cpu_map_kthread_run(void *data)
 {
@@ -254,9 +313,9 @@ static int cpu_map_kthread_run(void *data)
 		struct xdp_cpumap_stats stats = {}; /* zero stats */
 		unsigned int kmem_alloc_drops = 0, sched = 0;
 		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
+		int i, n, m, nframes, xdp_n;
 		void *frames[CPUMAP_BATCH];
 		void *skbs[CPUMAP_BATCH];
-		int i, n, m, nframes;
 		LIST_HEAD(list);
 
 		/* Release CPU reschedule checks */
@@ -280,9 +339,20 @@ static int cpu_map_kthread_run(void *data)
 		 */
 		n = __ptr_ring_consume_batched(rcpu->queue, frames,
 					       CPUMAP_BATCH);
-		for (i = 0; i < n; i++) {
+		for (i = 0, xdp_n = 0; i < n; i++) {
 			void *f = frames[i];
-			struct page *page = virt_to_page(f);
+			struct page *page;
+
+			if (unlikely(__ptr_test_bit(0, &f))) {
+				struct sk_buff *skb = f;
+
+				__ptr_clear_bit(0, &skb);
+				list_add_tail(&skb->list, &list);
+				continue;
+			}
+
+			frames[xdp_n++] = f;
+			page = virt_to_page(f);
 
 			/* Bring struct page memory area to curr CPU. Read by
 			 * build_skb_around via page_is_pfmemalloc(), and when
@@ -292,7 +362,7 @@ static int cpu_map_kthread_run(void *data)
 		}
 
 		/* Support running another XDP prog on this CPU */
-		nframes = cpu_map_bpf_prog_run_xdp(rcpu, frames, n, &stats);
+		nframes = cpu_map_bpf_prog_run(rcpu, frames, xdp_n, &stats, &list);
 		if (nframes) {
 			m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, nframes, skbs);
 			if (unlikely(m == 0)) {
@@ -330,12 +400,6 @@ static int cpu_map_kthread_run(void *data)
 	return 0;
 }
 
-bool cpu_map_prog_allowed(struct bpf_map *map)
-{
-	return map->map_type == BPF_MAP_TYPE_CPUMAP &&
-	       map->value_size != offsetofend(struct bpf_cpumap_val, qsize);
-}
-
 static int __cpu_map_load_bpf_program(struct bpf_cpu_map_entry *rcpu, int fd)
 {
 	struct bpf_prog *prog;
@@ -696,6 +760,25 @@ int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 	return 0;
 }
 
+int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
+			     struct sk_buff *skb)
+{
+	int ret;
+
+	__skb_pull(skb, skb->mac_len);
+	skb_set_redirected(skb, false);
+	__ptr_set_bit(0, &skb);
+
+	ret = ptr_ring_produce(rcpu->queue, skb);
+	if (ret < 0)
+		goto trace;
+
+	wake_up_process(rcpu->kthread);
+trace:
+	trace_xdp_cpumap_enqueue(rcpu->map_id, !ret, !!ret, rcpu->cpu);
+	return ret;
+}
+
 void __cpu_map_flush(void)
 {
 	struct list_head *flush_list = this_cpu_ptr(&cpu_map_flush_list);
diff --git a/net/core/dev.c b/net/core/dev.c
index c34ff1dbf6e6..a00421e9ee16 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5642,8 +5642,7 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 		 * have a bpf_prog installed on an entry
 		 */
 		for (i = 0; i < new->aux->used_map_cnt; i++) {
-			if (dev_map_can_have_prog(new->aux->used_maps[i]) ||
-			    cpu_map_prog_allowed(new->aux->used_maps[i])) {
+			if (dev_map_can_have_prog(new->aux->used_maps[i])) {
 				mutex_unlock(&new->aux->used_maps_mutex);
 				return -EINVAL;
 			}
diff --git a/net/core/filter.c b/net/core/filter.c
index 0b13d8157a8f..4a21fde3028f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4038,8 +4038,12 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 			goto err;
 		consume_skb(skb);
 		break;
+	case BPF_MAP_TYPE_CPUMAP:
+		err = cpu_map_generic_redirect(fwd, skb);
+		if (unlikely(err))
+			goto err;
+		break;
 	default:
-		/* TODO: Handle BPF_MAP_TYPE_CPUMAP */
 		err = -EBADRQC;
 		goto err;
 	}
-- 
2.31.1


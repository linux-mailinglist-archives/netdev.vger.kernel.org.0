Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E024B3AE120
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 01:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhFTXfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 19:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhFTXfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 19:35:53 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88B9C061574;
        Sun, 20 Jun 2021 16:33:39 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id t32so906403pfg.2;
        Sun, 20 Jun 2021 16:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sO3YsrDX4yX8hvwGi+ZInST3z6De6MOTZMa36swv7Tw=;
        b=tz+Z5R+N5mo9iK0QmRB8yqaRUVz4llur36Ae+snMBtoDQH0Hg5Lzj5YiaH0a4/vNJS
         RWHlugxDvBO0Tot1haGHY3L1d2i7dF8MrClF1oK4YxdnweykUdZDWqWJjxOb4PzxrMg3
         0wqZUvhL5yWuuGHXBbheV5IcX2j7YNG/c2Z5QSKjpz4q0+kjITkVzieTGIAY7MR8K0AP
         Ngc57+VfMr1jL63M+mV+l1OmWPj1LAFbYoM8xzMQ017IxzZqbSrUrnqGi84FOjtTcTKq
         p+BgGctJ9SJZMysmzozmS8VoxpzPasV1lQ6k5xqLzEuiTgkwEnu51vImBK4ZxxW9ArXX
         1gcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sO3YsrDX4yX8hvwGi+ZInST3z6De6MOTZMa36swv7Tw=;
        b=A3jx4VWG4YI/IKGmhgmZUC04oQtgni0XOdEgOsWkl7LSmUOdeHgfZzNrkm+MR4FLvw
         btnP7egxfTz9R9ze7NEzKqXcicE3qP0IG1rsHP582rBxrG6Py/mnQY/EqFUMvfb6WEJc
         +32BR6rivAKdQ0ystnJSP9AhhWVpvqGnv+aHh02+u/x8pCUCmtFmpIpFbtmcCuRRxJg0
         wsHeVhnIEDJ2AN6qDaSuL4eWHzbBW7vOPz9Q7TxWr3b1iq/Z/7O1uYJFNQ7S4TguQvvi
         eV3LUiYkv/geYucaRHb0pDRppqwRJIl8g4pFWBRBbc2ZTor4xTnQiERtL8OQmB5OdCCg
         mHyw==
X-Gm-Message-State: AOAM530lVdiwpLlnu/p9PCBKwuJnW2/hIAPDv6oAGgyeUfa92WGQ2bOy
        pySLbk5awzsKeoF7pjz0j70y+wwdD7Y=
X-Google-Smtp-Source: ABdhPJxS8bYkPyFdiHMBl7193/1qZXf6TVnn7Jgf3dJkKnvDOf6b6/pKjMhjONUG2GoAa+UbE6h1EA==
X-Received: by 2002:a62:37c2:0:b029:2ff:f7dd:1620 with SMTP id e185-20020a6237c20000b02902fff7dd1620mr15241542pfa.33.1624232019107;
        Sun, 20 Jun 2021 16:33:39 -0700 (PDT)
Received: from localhost ([2409:4063:4d19:cf2b:5167:bcec:f927:8a69])
        by smtp.gmail.com with ESMTPSA id g6sm13853352pfq.110.2021.06.20.16.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 16:33:38 -0700 (PDT)
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
Subject: [PATCH net-next 2/4] net: implement generic cpumap
Date:   Mon, 21 Jun 2021 05:01:58 +0530
Message-Id: <20210620233200.855534-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210620233200.855534-1-memxor@gmail.com>
References: <20210620233200.855534-1-memxor@gmail.com>
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

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h    |   8 +++
 include/linux/skbuff.h |  10 +--
 kernel/bpf/cpumap.c    | 151 +++++++++++++++++++++++++++++++++++++----
 net/core/filter.c      |   6 +-
 4 files changed, 154 insertions(+), 21 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f309fc1509f2..46e6587d3ee6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1513,6 +1513,8 @@ bool dev_map_can_have_prog(struct bpf_map *map);
 void __cpu_map_flush(void);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
+int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
+			     struct sk_buff *skb);
 bool cpu_map_prog_allowed(struct bpf_map *map);
 
 /* Return map's numa specified by userspace */
@@ -1710,6 +1712,12 @@ static inline int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu,
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
index a1a0c4e791c6..f016daf8fdcc 100644
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
@@ -79,6 +80,29 @@ struct bpf_cpu_map {
 
 static DEFINE_PER_CPU(struct list_head, cpu_map_flush_list);
 
+static void *__ptr_set_bit(void *ptr, int bit)
+{
+	unsigned long __ptr = (unsigned long)ptr;
+
+	__ptr |= BIT(bit);
+	return (void *)__ptr;
+}
+
+static void *__ptr_clear_bit(void *ptr, int bit)
+{
+	unsigned long __ptr = (unsigned long)ptr;
+
+	__ptr &= ~BIT(bit);
+	return (void *)__ptr;
+}
+
+static int __ptr_test_bit(void *ptr, int bit)
+{
+	unsigned long __ptr = (unsigned long)ptr;
+
+	return __ptr & BIT(bit);
+}
+
 static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 {
 	u32 value_size = attr->value_size;
@@ -168,6 +192,64 @@ static void put_cpu_map_entry(struct bpf_cpu_map_entry *rcpu)
 	}
 }
 
+static void cpu_map_bpf_prog_run_skb(struct bpf_cpu_map_entry *rcpu,
+				    void **frames, int skb_n,
+				    struct xdp_cpumap_stats *stats,
+				    struct list_head *listp)
+{
+	struct xdp_rxq_info rxq = {};
+	struct xdp_buff xdp;
+	int err, i;
+	u32 act;
+
+	xdp.rxq = &rxq;
+
+	if (!rcpu->prog)
+		goto insert;
+
+	for (i = 0; i < skb_n; i++) {
+		struct sk_buff *skb = frames[i];
+
+		rxq.dev = skb->dev;
+
+		act = bpf_prog_run_generic_xdp(skb, &xdp, rcpu->prog);
+		switch (act) {
+		case XDP_PASS:
+			list_add_tail(&skb->list, listp);
+			break;
+		case XDP_REDIRECT:
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
+			kfree_skb(skb);
+			stats->drop++;
+			return;
+		}
+	}
+
+	return;
+
+insert:
+	for (i = 0; i < skb_n; i++) {
+		struct sk_buff *skb = frames[i];
+
+		list_add_tail(&skb->list, listp);
+	}
+}
+
 static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 				    void **frames, int n,
 				    struct xdp_cpumap_stats *stats)
@@ -179,8 +261,6 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 	if (!rcpu->prog)
 		return n;
 
-	rcu_read_lock_bh();
-
 	xdp_set_return_frame_no_direct();
 	xdp.rxq = &rxq;
 
@@ -227,17 +307,36 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 		}
 	}
 
+	xdp_clear_return_frame_no_direct();
+
+	return nframes;
+}
+
+#define CPUMAP_BATCH 8
+
+static int cpu_map_bpf_prog_run(struct bpf_cpu_map_entry *rcpu,
+				void **frames, int xdp_n, int skb_n,
+				struct xdp_cpumap_stats *stats,
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
+	if (unlikely(skb_n))
+		cpu_map_bpf_prog_run_skb(rcpu, frames + CPUMAP_BATCH, skb_n,
+					 stats, list);
 
-	rcu_read_unlock_bh(); /* resched point, may call do_softirq() */
+	rcu_read_unlock_bh();
 
 	return nframes;
 }
 
-#define CPUMAP_BATCH 8
 
 static int cpu_map_kthread_run(void *data)
 {
@@ -254,9 +353,9 @@ static int cpu_map_kthread_run(void *data)
 		struct xdp_cpumap_stats stats = {}; /* zero stats */
 		unsigned int kmem_alloc_drops = 0, sched = 0;
 		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
-		void *frames[CPUMAP_BATCH];
+		int i, n, m, nframes, xdp_n, skb_n;
+		void *frames[CPUMAP_BATCH * 2];
 		void *skbs[CPUMAP_BATCH];
-		int i, n, m, nframes;
 		LIST_HEAD(list);
 
 		/* Release CPU reschedule checks */
@@ -280,9 +379,17 @@ static int cpu_map_kthread_run(void *data)
 		 */
 		n = __ptr_ring_consume_batched(rcpu->queue, frames,
 					       CPUMAP_BATCH);
-		for (i = 0; i < n; i++) {
+		for (i = 0, xdp_n = 0, skb_n = 0; i < n; i++) {
 			void *f = frames[i];
-			struct page *page = virt_to_page(f);
+			struct page *page;
+
+			if (unlikely(__ptr_test_bit(f, 0))) {
+				frames[CPUMAP_BATCH + skb_n++] = __ptr_clear_bit(f, 0);
+				continue;
+			}
+
+			frames[xdp_n++] = f;
+			page = virt_to_page(f);
 
 			/* Bring struct page memory area to curr CPU. Read by
 			 * build_skb_around via page_is_pfmemalloc(), and when
@@ -292,7 +399,7 @@ static int cpu_map_kthread_run(void *data)
 		}
 
 		/* Support running another XDP prog on this CPU */
-		nframes = cpu_map_bpf_prog_run_xdp(rcpu, frames, n, &stats);
+		nframes = cpu_map_bpf_prog_run(rcpu, frames, xdp_n, skb_n, &stats, &list);
 		if (nframes) {
 			m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, nframes, skbs);
 			if (unlikely(m == 0)) {
@@ -316,6 +423,7 @@ static int cpu_map_kthread_run(void *data)
 
 			list_add_tail(&skb->list, &list);
 		}
+
 		netif_receive_skb_list(&list);
 
 		/* Feedback loop via tracepoint */
@@ -333,7 +441,8 @@ static int cpu_map_kthread_run(void *data)
 bool cpu_map_prog_allowed(struct bpf_map *map)
 {
 	return map->map_type == BPF_MAP_TYPE_CPUMAP &&
-	       map->value_size != offsetofend(struct bpf_cpumap_val, qsize);
+	       map->value_size != offsetofend(struct bpf_cpumap_val, qsize) &&
+	       map->value_size != offsetofend(struct bpf_cpumap_val, bpf_prog.fd);
 }
 
 static int __cpu_map_load_bpf_program(struct bpf_cpu_map_entry *rcpu, int fd)
@@ -696,6 +805,24 @@ int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 	return 0;
 }
 
+int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
+			     struct sk_buff *skb)
+{
+	int ret;
+
+	__skb_pull(skb, skb->mac_len);
+	skb_set_redirected(skb, false);
+
+	ret = ptr_ring_produce(rcpu->queue, __ptr_set_bit(skb, 0));
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


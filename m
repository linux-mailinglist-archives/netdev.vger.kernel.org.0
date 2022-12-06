Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0060644C23
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiLFTAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiLFTAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:00:22 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAB332BBB
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 11:00:20 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id c129so18074384oia.0
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 11:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7gB/zC3m6z18bCMXQvK6wTNUYxsgfiVZcwxTbNoVdos=;
        b=jSdWy/gKx+It09U4YF2P+7xcTqOoHTZQEmqSGvfz9HpmcbbClVtZE1IzBXcVMDNmQh
         /h5mKFAGvqvDXiBofNHhhwRBK8cXilalcdNBwy3k3nycfKb5Qq8XdOTZ/Yv0eMff8lGF
         PTlfpLzpt648yElTTUJ+j9l5P1RWsJwM3C7imX/tozIrGN8qmsVglIuZelLVy8uo9kc1
         XyFSqwU+0gg6mGrzZ48w6PfB/T3bAJ/MwyYLZ2LVOqjWfMd0fxClG5leO3aMSdR75LIQ
         OsqM1DzXnsZN7JMTM+xDMgY+FlV/ibArwPYxMrV/vWC0evdlh4/17g2nr/QvvYw05ezi
         dcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7gB/zC3m6z18bCMXQvK6wTNUYxsgfiVZcwxTbNoVdos=;
        b=7gaXUnC0lq8upF8wbE9tIdgfBk5/nm4F+EM3TIB9rEanQiw/rq7jMOfh0M2nJtd752
         xQ1jUJ82oyXbyEeFg3xDPsdCGiziq+HOKx7dOH3e1u+er6IKvgoE0LoL/h89L7vPLAqe
         WarC+jqlF+xpctc7bmgExfHvG+l0yrMmjx95nd/Er8fxi6ja0qods9vIlHH+WFMEhL3w
         JWbeukRoC+B1wHytjzSO8St5mJT+LcZiysCkqc7ns1wzLo8JV5dvv2vdtN63jSOTe++1
         qOZ/sPVblm1pv67NbkqnXO3a7iVgjy6TLdHp0K9u3Ub41M5yExh6JW6GCuS/cs54k8nT
         G/vA==
X-Gm-Message-State: ANoB5pnERubJt8GAUWcsRJErUlusqpvZWqoydik3IGEgfu/KKJ3A6OAo
        CMtQPYp+Mi/bOILMtSVACUbWiw==
X-Google-Smtp-Source: AA0mqf7WwnFub6n+tLxpktEHW3bX4yd+fxESVtOraSVHeb5gxz1kb/mdwZf60nStByF+LhNeIgOoig==
X-Received: by 2002:aca:4545:0:b0:359:f445:e03e with SMTP id s66-20020aca4545000000b00359f445e03emr33440702oia.180.1670353219576;
        Tue, 06 Dec 2022 11:00:19 -0800 (PST)
Received: from localhost ([107.116.82.99])
        by smtp.gmail.com with ESMTPSA id m6-20020a056870a40600b0012d939eb0bfsm11101496oal.34.2022.12.06.11.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 11:00:19 -0800 (PST)
Date:   Tue, 6 Dec 2022 20:00:14 +0100
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Message-ID: <Y4+RPry2tfbWFdSA@cmpxchg.org>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org>
 <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
 <Y4T43Tc54vlKjTN0@cmpxchg.org>
 <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
 <CABWYdi25hricmGUqaK1K0EB-pAm04vGTg=eiqRF99RJ7hM7Gyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWYdi25hricmGUqaK1K0EB-pAm04vGTg=eiqRF99RJ7hM7Gyg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 04:50:46PM -0800, Ivan Babrou wrote:
> And now I can see plenty of this:
> 
> [  108.156707][ T5175] socket pressure[2]: 4294673429
> [  108.157050][ T5175] socket pressure[2]: 4294673429
> [  108.157301][ T5175] socket pressure[2]: 4294673429
> [  108.157581][ T5175] socket pressure[2]: 4294673429
> [  108.157874][ T5175] socket pressure[2]: 4294673429
> [  108.158254][ T5175] socket pressure[2]: 4294673429
> 
> I think the first result below is to blame:
> 
> $ rg '.->socket_pressure' mm
> mm/memcontrol.c
> 5280: memcg->socket_pressure = jiffies;
> 7198: memcg->socket_pressure = 0;
> 7201: memcg->socket_pressure = 1;
> 7211: memcg->socket_pressure = 0;
> 7215: memcg->socket_pressure = 1;

Hoo boy, that's a silly mistake indeed. Thanks for tracking it down.

> While we set socket_pressure to either zero or one in
> mem_cgroup_charge_skmem, it is still initialized to jiffies on memcg
> creation. Zero seems like a more appropriate starting point. With that
> change I see it working as expected with no TCP speed bumps. My
> ebpf_exporter program also looks happy and reports zero clamps in my
> brief testing.

Excellent, now this behavior makes sense.

> I also think we should downgrade socket_pressure from "unsigned long"
> to "bool", as it only holds zero and one now.

Sounds good to me!

Attaching the updated patch below. If nobody has any objections, I'll
add a proper changelog, reported-bys, sign-off etc and send it out.

---
 include/linux/memcontrol.h |  8 +++---
 include/linux/vmpressure.h |  7 ++---
 mm/memcontrol.c            | 20 +++++++++----
 mm/vmpressure.c            | 58 ++++++--------------------------------
 mm/vmscan.c                | 15 +---------
 5 files changed, 30 insertions(+), 78 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1644a24009c..ef1c388be5b3 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -283,11 +283,11 @@ struct mem_cgroup {
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
 	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
 
-	unsigned long		socket_pressure;
+	/* Socket memory allocations have failed */
+	bool			socket_pressure;
 
 	/* Legacy tcp memory accounting */
 	bool			tcpmem_active;
-	int			tcpmem_pressure;
 
 #ifdef CONFIG_MEMCG_KMEM
 	int kmemcg_id;
@@ -1701,10 +1701,10 @@ void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->socket_pressure)
 		return true;
 	do {
-		if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
+		if (memcg->socket_pressure)
 			return true;
 	} while ((memcg = parent_mem_cgroup(memcg)));
 	return false;
diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index 6a2f51ebbfd3..20d93de37a17 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -11,9 +11,6 @@
 #include <linux/eventfd.h>
 
 struct vmpressure {
-	unsigned long scanned;
-	unsigned long reclaimed;
-
 	unsigned long tree_scanned;
 	unsigned long tree_reclaimed;
 	/* The lock is used to keep the scanned/reclaimed above in sync. */
@@ -30,7 +27,7 @@ struct vmpressure {
 struct mem_cgroup;
 
 #ifdef CONFIG_MEMCG
-extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
+extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 		       unsigned long scanned, unsigned long reclaimed);
 extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
 
@@ -44,7 +41,7 @@ extern int vmpressure_register_event(struct mem_cgroup *memcg,
 extern void vmpressure_unregister_event(struct mem_cgroup *memcg,
 					struct eventfd_ctx *eventfd);
 #else
-static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
+static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 			      unsigned long scanned, unsigned long reclaimed) {}
 static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg,
 				   int prio) {}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2d8549ae1b30..0d4b9dbe775a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5277,7 +5277,6 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->event_list);
 	spin_lock_init(&memcg->event_list_lock);
-	memcg->socket_pressure = jiffies;
 #ifdef CONFIG_MEMCG_KMEM
 	memcg->kmemcg_id = -1;
 	INIT_LIST_HEAD(&memcg->objcg_list);
@@ -7195,10 +7194,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 		struct page_counter *fail;
 
 		if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
-			memcg->tcpmem_pressure = 0;
+			memcg->socket_pressure = false;
 			return true;
 		}
-		memcg->tcpmem_pressure = 1;
+		memcg->socket_pressure = true;
 		if (gfp_mask & __GFP_NOFAIL) {
 			page_counter_charge(&memcg->tcpmem, nr_pages);
 			return true;
@@ -7206,12 +7205,21 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 		return false;
 	}
 
-	if (try_charge(memcg, gfp_mask, nr_pages) == 0) {
-		mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
-		return true;
+	if (try_charge(memcg, gfp_mask & ~__GFP_NOFAIL, nr_pages) == 0) {
+		memcg->socket_pressure = false;
+		goto success;
+	}
+	memcg->socket_pressure = true;
+	if (gfp_mask & __GFP_NOFAIL) {
+		try_charge(memcg, gfp_mask, nr_pages);
+		goto success;
 	}
 
 	return false;
+
+success:
+	mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
+	return true;
 }
 
 /**
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index b52644771cc4..4cec90711cf4 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -219,7 +219,6 @@ static void vmpressure_work_fn(struct work_struct *work)
  * vmpressure() - Account memory pressure through scanned/reclaimed ratio
  * @gfp:	reclaimer's gfp mask
  * @memcg:	cgroup memory controller handle
- * @tree:	legacy subtree mode
  * @scanned:	number of pages scanned
  * @reclaimed:	number of pages reclaimed
  *
@@ -227,16 +226,9 @@ static void vmpressure_work_fn(struct work_struct *work)
  * "instantaneous" memory pressure (scanned/reclaimed ratio). The raw
  * pressure index is then further refined and averaged over time.
  *
- * If @tree is set, vmpressure is in traditional userspace reporting
- * mode: @memcg is considered the pressure root and userspace is
- * notified of the entire subtree's reclaim efficiency.
- *
- * If @tree is not set, reclaim efficiency is recorded for @memcg, and
- * only in-kernel users are notified.
- *
  * This function does not return any value.
  */
-void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
+void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 		unsigned long scanned, unsigned long reclaimed)
 {
 	struct vmpressure *vmpr;
@@ -271,46 +263,14 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 	if (!scanned)
 		return;
 
-	if (tree) {
-		spin_lock(&vmpr->sr_lock);
-		scanned = vmpr->tree_scanned += scanned;
-		vmpr->tree_reclaimed += reclaimed;
-		spin_unlock(&vmpr->sr_lock);
-
-		if (scanned < vmpressure_win)
-			return;
-		schedule_work(&vmpr->work);
-	} else {
-		enum vmpressure_levels level;
-
-		/* For now, no users for root-level efficiency */
-		if (!memcg || mem_cgroup_is_root(memcg))
-			return;
-
-		spin_lock(&vmpr->sr_lock);
-		scanned = vmpr->scanned += scanned;
-		reclaimed = vmpr->reclaimed += reclaimed;
-		if (scanned < vmpressure_win) {
-			spin_unlock(&vmpr->sr_lock);
-			return;
-		}
-		vmpr->scanned = vmpr->reclaimed = 0;
-		spin_unlock(&vmpr->sr_lock);
+	spin_lock(&vmpr->sr_lock);
+	scanned = vmpr->tree_scanned += scanned;
+	vmpr->tree_reclaimed += reclaimed;
+	spin_unlock(&vmpr->sr_lock);
 
-		level = vmpressure_calc_level(scanned, reclaimed);
-
-		if (level > VMPRESSURE_LOW) {
-			/*
-			 * Let the socket buffer allocator know that
-			 * we are having trouble reclaiming LRU pages.
-			 *
-			 * For hysteresis keep the pressure state
-			 * asserted for a second in which subsequent
-			 * pressure events can occur.
-			 */
-			WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
-		}
-	}
+	if (scanned < vmpressure_win)
+		return;
+	schedule_work(&vmpr->work);
 }
 
 /**
@@ -340,7 +300,7 @@ void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio)
 	 * to the vmpressure() basically means that we signal 'critical'
 	 * level.
 	 */
-	vmpressure(gfp, memcg, true, vmpressure_win, 0);
+	vmpressure(gfp, memcg, vmpressure_win, 0);
 }
 
 #define MAX_VMPRESSURE_ARGS_LEN	(strlen("critical") + strlen("hierarchy") + 2)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 04d8b88e5216..d348366d58d4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6035,8 +6035,6 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 	memcg = mem_cgroup_iter(target_memcg, NULL, NULL);
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		unsigned long reclaimed;
-		unsigned long scanned;
 
 		/*
 		 * This loop can become CPU-bound when target memcgs
@@ -6068,20 +6066,9 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 			memcg_memory_event(memcg, MEMCG_LOW);
 		}
 
-		reclaimed = sc->nr_reclaimed;
-		scanned = sc->nr_scanned;
-
 		shrink_lruvec(lruvec, sc);
-
 		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
 			    sc->priority);
-
-		/* Record the group's reclaim efficiency */
-		if (!sc->proactive)
-			vmpressure(sc->gfp_mask, memcg, false,
-				   sc->nr_scanned - scanned,
-				   sc->nr_reclaimed - reclaimed);
-
 	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, NULL)));
 }
 
@@ -6111,7 +6098,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 
 	/* Record the subtree's reclaim efficiency */
 	if (!sc->proactive)
-		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
+		vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
 			   sc->nr_scanned - nr_scanned,
 			   sc->nr_reclaimed - nr_reclaimed);
 
-- 
2.38.1


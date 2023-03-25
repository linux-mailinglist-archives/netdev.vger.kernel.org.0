Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730B96C904C
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 19:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjCYS4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 14:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjCYSz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 14:55:58 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89613AD34;
        Sat, 25 Mar 2023 11:55:37 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id o25-20020a9d4119000000b006a11eb19f8eso1391296ote.5;
        Sat, 25 Mar 2023 11:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679770537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kt1nV0izHo+XQQSqYyOe/0WD7P7tYGip9P1865wg+tY=;
        b=inVz0XSRlLk1W1rbP83ZhW+h6QqSXDsSY6pY0UA+2M654dZyEEwyxBsc+UcnU0AbIW
         2gyMwBud5Ce2EgFauWO8OVuukIalRpQtOm+cmSA/vvkS4nYMqWkjQvKcWgBxMYluSKoe
         6qfl5dwESfE8GBkl8/Kuv6lehXHjAJyUhVcNnf5Ce0foper8jv91w1NqZDjHLA3bI6QR
         uM/TXRhHw8PtPHgVhWqZVG4ggLf0UWsxglfMBp5hEmmgqRI0ie9QTCcD7QEctu9PyZFV
         pfn/OHj4ukowrYLDLE+TkEK4lYqP4Hxxpt+qS9SHOXZW2HAKr1OEng51wzNGIcczxfr7
         RfxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679770537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kt1nV0izHo+XQQSqYyOe/0WD7P7tYGip9P1865wg+tY=;
        b=gtwIwT7ixUDULmDSKQ4tUcPHf+4TQk36yZb9UQ5Xn1u7nyAhEslrhpKZDEBGnigCOw
         1msd82/hjf2Dx7QcGDu8zQXPEVETyfKCF1KcvW1SdpEwKX44Mke0GoO8JnyHRT+uYV+B
         mtOGBTcusY0nf0UnMyoYwEo7k3l0SuxJ+mua2As7tLcrdWLqOV71zfIMASbB3Nq9NrD9
         bSQbRTz8SAFErCrQEDwWGNU/B9JC/njoN11YXMdPUMtPKHdjfJB9gxQXkv95uYFWeSSk
         Nhpfz45RkvjhWPfjHxYP8FfLT0QlVrjnn60eEjYs9T2vw8Pp/Zkf0OwH31TeEDIuH2ej
         U0tg==
X-Gm-Message-State: AO0yUKVlF/igD1w2QCW9iWZJVYLJvDXRcgKRXdFR7P7w53ZlOZcH9n5h
        YpgetIEYx8icSxtwSkhXI4A=
X-Google-Smtp-Source: AK7set8DuAMn4XuyM4v6I2K7igcUyRQD0ffc61fKXKcekRHZN9YR6m9+iwxAdj+HdX5Um/FRDRfm1A==
X-Received: by 2002:a05:6830:10cc:b0:697:a381:a8f8 with SMTP id z12-20020a05683010cc00b00697a381a8f8mr3217617oto.3.1679770536742;
        Sat, 25 Mar 2023 11:55:36 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id p16-20020a9d76d0000000b0068bd922a244sm10121959otl.20.2023.03.25.11.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 11:55:36 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: [RFC PATCH 8/8] sched: drop for_each_numa_hop_mask()
Date:   Sat, 25 Mar 2023 11:55:14 -0700
Message-Id: <20230325185514.425745-9-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230325185514.425745-1-yury.norov@gmail.com>
References: <20230325185514.425745-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have for_each_numa_cpu(), for_each_numa_hop_mask()
and all related code is a deadcode. Drop it.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
This is RFC because despite that the code below is unused, there may be
new users, particularly Intel, and I don't want to cut people on the fly.
Those interested in for_each_numa_hop_mask(), please send NAKs.

 include/linux/topology.h | 25 -------------------------
 kernel/sched/topology.c  | 32 --------------------------------
 lib/test_bitmap.c        | 13 -------------
 3 files changed, 70 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 3d8d486c817d..d2defd59b2d0 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -255,7 +255,6 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 #ifdef CONFIG_NUMA
 int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node);
 int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop);
-extern const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops);
 #else
 static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
 {
@@ -267,32 +266,8 @@ int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsi
 {
 	return cpumask_next(cpu, cpus);
 }
-
-static inline const struct cpumask *
-sched_numa_hop_mask(unsigned int node, unsigned int hops)
-{
-	return ERR_PTR(-EOPNOTSUPP);
-}
 #endif	/* CONFIG_NUMA */
 
-/**
- * for_each_numa_hop_mask - iterate over cpumasks of increasing NUMA distance
- *                          from a given node.
- * @mask: the iteration variable.
- * @node: the NUMA node to start the search from.
- *
- * Requires rcu_lock to be held.
- *
- * Yields cpu_online_mask for @node == NUMA_NO_NODE.
- */
-#define for_each_numa_hop_mask(mask, node)				       \
-	for (unsigned int __hops = 0;					       \
-	     mask = (node != NUMA_NO_NODE || __hops) ?			       \
-		     sched_numa_hop_mask(node, __hops) :		       \
-		     cpu_online_mask,					       \
-	     !IS_ERR_OR_NULL(mask);					       \
-	     __hops++)
-
 /**
  * for_each_numa_cpu - iterate over cpus in increasing order taking into account
  *		       NUMA distances from a given node.
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 5f5f994a56da..2842a4d10624 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2171,38 +2171,6 @@ int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsi
 }
 EXPORT_SYMBOL_GPL(sched_numa_find_next_cpu);
 
-/**
- * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away from
- *                         @node
- * @node: The node to count hops from.
- * @hops: Include CPUs up to that many hops away. 0 means local node.
- *
- * Return: On success, a pointer to a cpumask of CPUs at most @hops away from
- * @node, an error value otherwise.
- *
- * Requires rcu_lock to be held. Returned cpumask is only valid within that
- * read-side section, copy it if required beyond that.
- *
- * Note that not all hops are equal in distance; see sched_init_numa() for how
- * distances and masks are handled.
- * Also note that this is a reflection of sched_domains_numa_masks, which may change
- * during the lifetime of the system (offline nodes are taken out of the masks).
- */
-const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops)
-{
-	struct cpumask ***masks;
-
-	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
-		return ERR_PTR(-EINVAL);
-
-	masks = rcu_dereference(sched_domains_numa_masks);
-	if (!masks)
-		return ERR_PTR(-EBUSY);
-
-	return masks[hops][node];
-}
-EXPORT_SYMBOL_GPL(sched_numa_hop_mask);
-
 #endif /* CONFIG_NUMA */
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 1b5f805f6879..6becb044a66f 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -756,19 +756,6 @@ static void __init test_for_each_numa(void)
 {
 	unsigned int cpu, node;
 
-	for (node = 0; node < sched_domains_numa_levels; node++) {
-		const struct cpumask *m, *p = cpu_none_mask;
-		unsigned int c = 0;
-
-		rcu_read_lock();
-		for_each_numa_hop_mask(m, node) {
-			for_each_cpu_andnot(cpu, m, p)
-				expect_eq_uint(cpumask_local_spread(c++, node), cpu);
-			p = m;
-		}
-		rcu_read_unlock();
-	}
-
 	for (node = 0; node < sched_domains_numa_levels; node++) {
 		unsigned int hop, c = 0;
 
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599F86F29F3
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjD3RTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbjD3RSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:18:30 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD5640FF;
        Sun, 30 Apr 2023 10:18:24 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1aaf91ae451so1275165ad.1;
        Sun, 30 Apr 2023 10:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682875103; x=1685467103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vEDddPK2KWms5ByKjAdqzmWy8wIq0UJSgOARkSGChjw=;
        b=qARWWHh5Z1F1HN0NJ4OBAIUgyrWd2TBqWT7jwQPG802Qm7RkKl2fXPTheFCUR/LWOE
         0Fix0eUh7k/CNsSO+evb6TvFvUQ6f0U539kL8ifXsUSF9YKU0HgojrvYVVGITrInlZ9s
         H8aeEok/HwOX+B31b+LLywyaFRreCk/kj2Mb+XbcZZaTHjrxBDCUxFIiAYoy4AU6WobK
         S0D5cAdWMVLGNkVBzqftauKQa3Uq90U5S8puqiM6aGrql7O+E038H8PEo/FvV3B9WPiT
         3d9eyhnZbYYoe7/y6g1BUbaiQj8AEj7ZEyggWzElcahdLv3AbwpxqMybUtTdUGpFbjY4
         VXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682875103; x=1685467103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vEDddPK2KWms5ByKjAdqzmWy8wIq0UJSgOARkSGChjw=;
        b=WFCno2VGRxLlzn8e14E7clPW19dRsKehB48Nc2/FKPpdetAwqLBS/Ij5xvDrh/7Ynv
         FluWOw8Wn/ySmwZeJry3R6wPy1mfRoyVmixxeNx/RVDSuK2CmUuMXUWejnYmw+pmei0H
         8xflZY7DJpThTvJvztMTxJXiH3rG1fM4s2184bnzlz/vJ4BOIAf1fjM5JkYefhCQcSI8
         KqYuwe8OuDTYJV+Kj9qRLOs/H+BzHjy/N/Or+gMhbWiW6LmiXJuwh7Co4TUckxSYdFJc
         JViXEHu2KMT47afYwxd80dXb5C5HhwF0njAVuIYU+klkCV6aBZt6VWy2igcgKzUjDDTj
         p0fQ==
X-Gm-Message-State: AC+VfDypJ+qJ3Eks2p+FCIWeHIpcL7HGoWTcyIgGHTvAq0ZbilsD+nQz
        b2slwMmttHkubmY5K/KyK9s=
X-Google-Smtp-Source: ACHHUZ4bpfqZTe7GYmq6GwQvlggN26rWdCIRujteRiubrRQHGhf26HGKrbdwLY8vUedmfdNP3XnAuQ==
X-Received: by 2002:a17:903:5cd:b0:1a6:3799:ec2a with SMTP id kf13-20020a17090305cd00b001a63799ec2amr10957581plb.35.1682875102976;
        Sun, 30 Apr 2023 10:18:22 -0700 (PDT)
Received: from localhost ([4.1.102.3])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090282c500b001aaf5dcd772sm532971plz.21.2023.04.30.10.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 10:18:22 -0700 (PDT)
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
Subject: [PATCH v3 7/8] sched: drop for_each_numa_hop_mask()
Date:   Sun, 30 Apr 2023 10:18:08 -0700
Message-Id: <20230430171809.124686-8-yury.norov@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230430171809.124686-1-yury.norov@gmail.com>
References: <20230430171809.124686-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have for_each_numa_cpu(), for_each_numa_hop_mask()
and all related code is a dead code. Drop it.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h | 25 -------------------------
 kernel/sched/topology.c  | 32 --------------------------------
 2 files changed, 57 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 6ed01962878c..808b5dcf6e36 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -252,7 +252,6 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 #ifdef CONFIG_NUMA
 int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node);
 int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop);
-extern const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops);
 #else
 static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
 {
@@ -265,32 +264,8 @@ int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsi
 	return find_next_and_bit(cpumask_bits(cpus), cpumask_bits(cpu_online_mask),
 						small_cpumask_bits, cpu);
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
index fc163e4181e6..bb5ba2c5589a 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2169,38 +2169,6 @@ int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsi
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
-- 
2.37.2


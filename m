Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D48647596
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiLHSbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiLHSbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:31:13 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F547AD335;
        Thu,  8 Dec 2022 10:31:11 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id h132so2259334oif.2;
        Thu, 08 Dec 2022 10:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ecp1Y9KPy+kDAop1/WRITl7b0nkz2WoIf90DV196rk=;
        b=ePknV9D64SAqnSxRHkE514YZtiu5q9r6ovssx1zBnZsDJxmLaWxa9+pvv0qw+Al2tE
         7icHc5bwiDk3Nh278NW1BN6NTObpkWNBsuw4SLzy33uI3jNOTkX3GJcPWXjyICJxc52V
         BrN7yFJ2Xsa7MwRxwsYa8OpinY4jgjm+mae9y2dMIfKcxxZ/wIB7+JK4M5R+9x01V/c8
         R0b+vDqI9s08oTBaXlYnkgxbr1B5BIGwtwNwOXTybh3WFb1LO2cr//CYmmjb1C96h8ys
         LQ9EHbwRMcaZKB0SudjJO2N46odtJxuKV5xEPWLrXB2uOjL6Ah9qYL7H48NmIQt9b2XN
         fo6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ecp1Y9KPy+kDAop1/WRITl7b0nkz2WoIf90DV196rk=;
        b=8F2Rwkwx9Nvc1yzxquflWxn/Yz2UB11MShW85tals2GxqSWTWxCPmjUHIJ0oojR0WV
         FuQAo+tbHS0moClLDca1PYIA14Fwf0ERFnzaakoCUXyqZZ8W5+aF7F9WTOcq+NRaCcby
         DNpPwVo2BaJ1wA8H+lrjhVtFImpNhTSCQ6zdBawFcTQgRV9vGzbc0AJ2vQTUz2Wue0LV
         h5K04/5+bHqsFGUWq0gQ/0GuLG2RByaZMQN9ARWZjV/zWBo1+Fgg0VwoUwWcFP0eiWxi
         v+ugtNKHf4MJ9H/YNvivvLEPfxxZVzGtLqrkAcjuU5U9STfu4FGJivdSrIp20w27O9vK
         p3uA==
X-Gm-Message-State: ANoB5pmJR6mnvmaV6RGFycsqYbLQC8oKYBo8ZlLpZRhuIu+cku7dTklM
        qveTsmohvXnLqz8dJPJgdWOKObxJKFg=
X-Google-Smtp-Source: AA0mqf6CFCCaWhBMhnZIhSSBXCFYdLJlvNU+Ql+n5K14MgA3Lj/YlgpT7Bt6I5rmS1doJMxUiQ7kKQ==
X-Received: by 2002:a05:6808:1804:b0:35e:22a4:883b with SMTP id bh4-20020a056808180400b0035e22a4883bmr1770775oib.38.1670524270213;
        Thu, 08 Dec 2022 10:31:10 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id m11-20020aca3f0b000000b0035a81480ffcsm10766076oia.38.2022.12.08.10.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 10:31:09 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH v3 3/5] sched: add sched_numa_find_nth_cpu()
Date:   Thu,  8 Dec 2022 10:30:59 -0800
Message-Id: <20221208183101.1162006-4-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221208183101.1162006-1-yury.norov@gmail.com>
References: <20221208183101.1162006-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function finds Nth set CPU in a given cpumask starting from a given
node.

Leveraging the fact that each hop in sched_domains_numa_masks includes the
same or greater number of CPUs than the previous one, we can use binary
search on hops instead of linear walk, which makes the overall complexity
of O(log n) in terms of number of cpumask_weight() calls.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h |  8 ++++++
 kernel/sched/topology.c  | 57 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4564faafd0e1..72f264575698 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -245,5 +245,13 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
+#ifdef CONFIG_NUMA
+int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node);
+#else
+static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
+{
+	return cpumask_nth(cpu, cpus);
+}
+#endif	/* CONFIG_NUMA */
 
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8739c2a5a54e..e515dcf44816 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1764,6 +1764,8 @@ bool find_numa_distance(int distance)
  *   there is an intermediary node C, which is < N hops away from both
  *   nodes A and B, the system is a glueless mesh.
  */
+#include <linux/bsearch.h>
+
 static void init_numa_topology_type(int offline_node)
 {
 	int a, b, c, n;
@@ -2067,6 +2069,61 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
 	return found;
 }
 
+struct __cmp_key {
+	const struct cpumask *cpus;
+	struct cpumask ***masks;
+	int node;
+	int cpu;
+	int w;
+};
+
+static int cmp(const void *a, const void *b)
+{
+	struct cpumask **prev_hop = *((struct cpumask ***)b - 1);
+	struct cpumask **cur_hop = *(struct cpumask ***)b;
+	struct __cmp_key *k = (struct __cmp_key *)a;
+
+	if (cpumask_weight_and(k->cpus, cur_hop[k->node]) <= k->cpu)
+		return 1;
+
+	k->w = (b == k->masks) ? 0 : cpumask_weight_and(k->cpus, prev_hop[k->node]);
+	if (k->w <= k->cpu)
+		return 0;
+
+	return -1;
+}
+
+/*
+ * sched_numa_find_nth_cpu() - given the NUMA topology, find the Nth next cpu
+ *                             closest to @cpu from @cpumask.
+ * cpumask: cpumask to find a cpu from
+ * cpu: Nth cpu to find
+ *
+ * returns: cpu, or nr_cpu_ids when nothing found.
+ */
+int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
+{
+	struct __cmp_key k = { .cpus = cpus, .node = node, .cpu = cpu };
+	struct cpumask ***hop_masks;
+	int hop, ret = nr_cpu_ids;
+
+	rcu_read_lock();
+
+	k.masks = rcu_dereference(sched_domains_numa_masks);
+	if (!k.masks)
+		goto unlock;
+
+	hop_masks = bsearch(&k, k.masks, sched_domains_numa_levels, sizeof(k.masks[0]), cmp);
+	hop = hop_masks	- k.masks;
+
+	ret = hop ?
+		cpumask_nth_and_andnot(cpu - k.w, cpus, k.masks[hop][node], k.masks[hop-1][node]) :
+		cpumask_nth_and(cpu, cpus, k.masks[0][node]);
+unlock:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sched_numa_find_nth_cpu);
 #endif /* CONFIG_NUMA */
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
-- 
2.34.1


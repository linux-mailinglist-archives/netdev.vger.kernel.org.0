Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACA66763B9
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 05:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjAUEZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 23:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjAUEYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 23:24:46 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1669150843;
        Fri, 20 Jan 2023 20:24:45 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id g16so3765698qtu.2;
        Fri, 20 Jan 2023 20:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DUfnaBP5lJbCL0GNiMEf+7JU9t1M5MfdDFKLQwINrqk=;
        b=JI2Z5SzD2aaTHlQx9e0J54AC8wdh7+DH+cR5sUi/bLrniSWMzxwFF7NL5awZ/lhqaF
         W5jiQGZPn58mj5hutiwKOHq+LBNCi3NWVqvfhK+3rTeu5C5/1Sebepnnbx7jhWShj2L8
         zzY9N1e4mskl2NwiPSoUBlqA7gfWm/TlWIwTfsJtizaEtNyHPHhkm8A81dYUiOsGmTVA
         aJnEodZO/UHF55Aaa8Ya6ORBgPtXdVloQUbalUekikBiJJMmpUtLNPrT2zxW5KqTuEjD
         fue8rw06THQRNzmYOYEOO8Z0xtSgNrkxC98hJC5KZKNjpcsI8iJw8FdndTEjx9FiRTit
         G/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DUfnaBP5lJbCL0GNiMEf+7JU9t1M5MfdDFKLQwINrqk=;
        b=jCrYIenIYx430tbWCM7t/J9vZUl2+XZkLayYMZkDv9y5nejMWwrFgSxTtJ/i8nOwDG
         Y6TsjIelcVo7jKEx4jT3uI6eDrNbJ0tyrEfOwvrnsUQYHAiB/KVyYAl9dcluiaBblDve
         efD9pQYiW5TgumNKsUFkbKI+bGGLfUMyBo2oVFNc/SBUmehuGD7gaich50+KUtZYL8EW
         M4fczhOf+QriQ6EzZp30Jse26+txG5MzcbVodGzWZj9b6ItN4hhjvTvdUvoXBcB3d88S
         0oP194nKQlza9aydUk41N9BxwNFeMF1uL16Jg0MDHmGPB1sp0jBd7jy7gFIDvZ2m4a+7
         j3Ow==
X-Gm-Message-State: AFqh2kpzi8dRu5pjz0p8aJpps/rnVzepcviFAUGPhDXA8k/esbLbxpky
        ZsOnAp6zVCVJXSLW2Bu+k6zexCu+lck=
X-Google-Smtp-Source: AMrXdXt9sB2DhEnSPL0aU/l8sufY4Q5shgubiddtucBZw0nLxvaQZWo8RQp2UBpsI926pWqBVlpw/Q==
X-Received: by 2002:ac8:6bd2:0:b0:3b2:2195:e2a2 with SMTP id b18-20020ac86bd2000000b003b22195e2a2mr23673991qtt.45.1674275083683;
        Fri, 20 Jan 2023 20:24:43 -0800 (PST)
Received: from localhost (50-242-44-45-static.hfc.comcastbusiness.net. [50.242.44.45])
        by smtp.gmail.com with ESMTPSA id fe13-20020a05622a4d4d00b003a580cd979asm21689174qtb.58.2023.01.20.20.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 20:24:43 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
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
Subject: [PATCH 3/9] sched: add sched_numa_find_nth_cpu()
Date:   Fri, 20 Jan 2023 20:24:30 -0800
Message-Id: <20230121042436.2661843-4-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230121042436.2661843-1-yury.norov@gmail.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
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
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Peter Lafreniere <peter@n8pjl.ca>
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
index 8739c2a5a54e..2bf89186a10f 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -3,6 +3,8 @@
  * Scheduler topology setup/handling methods
  */
 
+#include <linux/bsearch.h>
+
 DEFINE_MUTEX(sched_domains_mutex);
 
 /* Protected by sched_domains_mutex: */
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
+static int hop_cmp(const void *a, const void *b)
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
+	hop_masks = bsearch(&k, k.masks, sched_domains_numa_levels, sizeof(k.masks[0]), hop_cmp);
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


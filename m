Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641E8626B2F
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 20:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbiKLTJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 14:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235010AbiKLTJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 14:09:54 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D4918343;
        Sat, 12 Nov 2022 11:09:53 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id x13so5551917qvn.6;
        Sat, 12 Nov 2022 11:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqEEjsLXHTNbUPsRH66Vwh3/Ffbwf/TAdluZMVix8HU=;
        b=OrIPZw6dnMFquB03z7bujIZ4SI0QmPWeWr/QWFL6/agYtrCvFvJrqwUBpjJDm0chv8
         8fXqSEPeJifaigMJU8OzNcsqScMfwHgsJFmHfvH/WG/gpiopZqbQcWLVtjGGZe1kVfJD
         b9yOfiEWqX7WT/nsRQyydtfK7PBBELrmtMEMy2dP+nNjocxIOi05IR0FovguKKVaSwYj
         +dvVLcb2Vl93FH4WmyqtOC6sEOw1r1/NLDxY7qvylXUvyzy22CDtP9Ip345YFnFdxo8a
         7oEc0R4ujegaVJNhUILMXAKkRjoFYPMFxZJ2lv0nORAvLixe1yR+coZ5UQE7HgI4cCFF
         HV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tqEEjsLXHTNbUPsRH66Vwh3/Ffbwf/TAdluZMVix8HU=;
        b=WaoBRAkNmQE4jYeU19hgsYduj+RqUv3BL9XL5kfIXbf7nRB1JyqkVYE8FzI0Cx6Wdx
         OXMIRVXTv/6lRhTH5/Tr37GTDOICh+rM4EpfGTc8j1/ZSRMW6wXn1gT76uDrNeChK72g
         2a8M1rbGdXUP91u5509iyn7NJ9at3cNfcceMG2VOLcyd7NT0gdN6yt/gLb1kFkpKmMFb
         ZrwsMa3H4bBw1qwFTEyWFc9YS1UZ4s6WNcAkhVSpVMsgGpO9JUMGkqEgsn4XSREYM29N
         gSB0Ir3cA4QH49ufeg60IRQSNsionHR7zK4NDYphg70IcSo1JLshwmv45Nb0X+RbcNAM
         711w==
X-Gm-Message-State: ANoB5pmhQzGhVDCRVAUFf5lo9F9RTG08aSmt5jN+L7d1F8UZb/hy7CTb
        MgQCEeZWmeEnQEhMGHnxm2k45NRY6C0=
X-Google-Smtp-Source: AA0mqf5zShoEJOpwckW97mUU2Be2DzkQdB2sB1bJ8yi9Wk/kCY15bhTOdN9nciVVVaKwzW6uWRIrjQ==
X-Received: by 2002:a05:6214:932:b0:4bb:cb21:df19 with SMTP id dk18-20020a056214093200b004bbcb21df19mr6772654qvb.85.1668280192703;
        Sat, 12 Nov 2022 11:09:52 -0800 (PST)
Received: from localhost (user-24-236-74-177.knology.net. [24.236.74.177])
        by smtp.gmail.com with ESMTPSA id r1-20020a05620a298100b006ecf030ef15sm3570207qkp.65.2022.11.12.11.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 11:09:52 -0800 (PST)
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
Subject: [PATCH v2 3/4] sched: add sched_numa_find_nth_cpu()
Date:   Sat, 12 Nov 2022 11:09:45 -0800
Message-Id: <20221112190946.728270-4-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221112190946.728270-1-yury.norov@gmail.com>
References: <20221112190946.728270-1-yury.norov@gmail.com>
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
 kernel/sched/topology.c  | 55 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4564faafd0e1..b2e87728caea 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -245,5 +245,13 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
+#ifdef CONFIG_NUMA
+int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node);
+#else
+static inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
+{
+	return cpumask_nth(cpu, cpus);
+}
+#endif	/* CONFIG_NUMA */
 
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8739c2a5a54e..024f1da0e941 100644
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
@@ -2067,6 +2069,59 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
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
+	struct __cmp_key k = { cpus, NULL, node, cpu, 0 };
+	int hop, ret = nr_cpu_ids;
+
+	rcu_read_lock();
+	k.masks = rcu_dereference(sched_domains_numa_masks);
+	if (!k.masks)
+		goto unlock;
+
+	hop = (struct cpumask ***)
+		bsearch(&k, k.masks, sched_domains_numa_levels, sizeof(k.masks[0]), cmp) - k.masks;
+
+	ret = hop ?
+		cpumask_nth_and_andnot(cpu - k.w, cpus, k.masks[hop][node], k.masks[hop-1][node]) :
+		cpumask_nth_and(cpu - k.w, cpus, k.masks[0][node]);
+unlock:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sched_numa_find_nth_cpu);
 #endif /* CONFIG_NUMA */
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
-- 
2.34.1


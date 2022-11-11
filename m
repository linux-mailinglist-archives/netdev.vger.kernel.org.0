Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0453262520A
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiKKEAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiKKEAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:00:36 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D34965862;
        Thu, 10 Nov 2022 20:00:35 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id m204so3902408oib.6;
        Thu, 10 Nov 2022 20:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tzRDKkKs+46lV+ntk985L0+P6jvYS0wrm3ecpZliFYs=;
        b=EXI9KlBNRoNAC/HBM2t606C6k+BIKeV0yCiHoTnP+qKe2h/QdHKK058z8mFYDDYIlB
         ifkh+NI5b9E6h2EXFXvU85dmBLejYquO5VlXYt/3sRXdPsArf1afj7+1PSOQc5OJNxeR
         WpViD79eNh7CtAQmQ1AIZVuEQIYhkjGZUBl4ooje1+Dk006Ye6nXJ26TLl7vE19RoxLc
         NUCFe0PwYE2HPYsdwExhlg652eT5hm0Mv+hVE6/jc6eVjKam9IoGSJKONth26M0jCcbv
         9fRQfEUyt1VKN206SefuI3XcTv+uPDvBFHZqYObM3nM0TicHayrNYGhqRaen7IjUlW9s
         HGUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tzRDKkKs+46lV+ntk985L0+P6jvYS0wrm3ecpZliFYs=;
        b=53x5w+Yq+gjxX1P/ZPTBR03t/lxVRyX174TSzf2rlnycEDbZxTe/aykhA9CdDWZBg2
         tHnhQT4mWIFiBBMu9qOoiA6IG7qW392JjWOMT+7/mmvMa9qVw10B5JodpWEzAw7eQJax
         UnMGjY74OH3SLwsunf0I1FHPO/sGr2ZjAoF0EGKYM55NFVmJxgGUDk0exg65DNvXtIm/
         QEr/BJbO5LyHTts4RO087Vz41dFibiLuHj9g6FfgJOi6mfdP48ir6Bga4yBTUOoq8GtT
         q7SY4rtMcgwZq0KPuRCttldh4NMLrPJ8EIWhjQpCM9pPBjc/6M/k/nRfORJ1qi/MlI/6
         1iTQ==
X-Gm-Message-State: ACrzQf1U0xF1UCaIz1xeznoInY09qVdOV2HAj+OnY0oS7xrab9VfS1V6
        W/lmLbcryE2ic1S5TJq8nTgbbSKaPKQ=
X-Google-Smtp-Source: AMsMyM5edoBCgwfjhFXNXfIH8nqgdrdgOPAuv0BCWrlhB7OpA0bg+Z74wF8buizABMtPnDl5vxADeQ==
X-Received: by 2002:aca:dad4:0:b0:359:b842:e383 with SMTP id r203-20020acadad4000000b00359b842e383mr2859251oig.123.1668139234518;
        Thu, 10 Nov 2022 20:00:34 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id f8-20020a056830204800b0066101e9dccdsm591533otp.45.2022.11.10.20.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 20:00:34 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
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
Subject: [PATCH 3/4] sched: add sched_numa_find_nth_cpu()
Date:   Thu, 10 Nov 2022 20:00:26 -0800
Message-Id: <20221111040027.621646-4-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221111040027.621646-1-yury.norov@gmail.com>
References: <20221111040027.621646-1-yury.norov@gmail.com>
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
 include/linux/topology.h |  8 ++++++++
 kernel/sched/topology.c  | 42 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4564faafd0e1..63048ac3207c 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -245,5 +245,13 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
+#ifdef CONFIG_NUMA
+int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node);
+#else
+int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
+{
+	return cpumask_nth(cpu, cpus);
+}
+#endif	/* CONFIG_NUMA */
 
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8739c2a5a54e..c8f56287de46 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2067,6 +2067,48 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
 	return found;
 }
 
+/*
+ * sched_numa_find_nth_cpu() - given the NUMA topology, find the Nth next cpu
+ *                             closest to @cpu from @cpumask.
+ * cpumask: cpumask to find a cpu from
+ * cpu: Nth cpu to find
+ *
+ * returns: cpu, or >= nr_cpu_ids when nothing found.
+ */
+int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
+{
+	unsigned int first = 0, mid, last = sched_domains_numa_levels;
+	struct cpumask ***masks;
+	int w, ret = nr_cpu_ids;
+
+	rcu_read_lock();
+	masks = rcu_dereference(sched_domains_numa_masks);
+	if (!masks)
+		goto out;
+
+	while (last >= first) {
+		mid = (last + first) / 2;
+
+		if (cpumask_weight_and(cpus, masks[mid][node]) <= cpu) {
+			first = mid + 1;
+			continue;
+		}
+
+		w = (mid == 0) ? 0 : cpumask_weight_and(cpus, masks[mid - 1][node]);
+		if (w <= cpu)
+			break;
+
+		last = mid - 1;
+	}
+
+	ret = (mid == 0) ?
+		cpumask_nth_and(cpu - w, cpus, masks[mid][node]) :
+		cpumask_nth_and_andnot(cpu - w, cpus, masks[mid][node], masks[mid - 1][node]);
+out:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sched_numa_find_nth_cpu);
 #endif /* CONFIG_NUMA */
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
-- 
2.34.1


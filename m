Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA466C9038
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 19:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbjCYSzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 14:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjCYSz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 14:55:28 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABDD8A6B;
        Sat, 25 Mar 2023 11:55:26 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id f4-20020a9d0384000000b0069fab3f4cafso2575110otf.9;
        Sat, 25 Mar 2023 11:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679770526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nIVu6CybmYtP37ZaP9bFcl3BmGzC5B9pq4ZT5PiZYvs=;
        b=LgdsFgStEK1Bm6u3wXfL/BQmSTANWjKvvVvs7YZSt49M8B0v2Ydci5Br5fW9VY90nx
         A80b37Ovw9jXD1Um11sveYZskiTuptupJDJy/psutKH7YN/l2KvS3sXotqBzee1gyJKH
         wHItNA5ay054G38i23zMRQp9Ydy4WqfoeacjS4KmY+oN5Fc0BkhyFifEsV3tAxqaDqKw
         eJvj0akYNIjnmO8BM663OcnHUKuSZzGsvRrxpCjjhUEluEVv9ls60eeYlOX9zPTeZe4E
         ZVD54++Ule9GSLDwSzc4otdO/kU5pPyEFErXRINCBx4t5yhDyOJuy7mlarar5Ts2sEQ7
         JBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679770526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nIVu6CybmYtP37ZaP9bFcl3BmGzC5B9pq4ZT5PiZYvs=;
        b=I46a3h0cksOGXxH+ik6XQ5fCTD0ZUIjzs3yiu++Fs4TE3yEYs19vU2jGyWgQTy4TMa
         tNfTs+NK7eJCJpF1k3mt9MUS4LNX223wtdNB5RVQeOWC1Ymc2GRR/6BkwjjOZG93MTKU
         NLHUfkPP+UKq0zXsJkpZiN92qUXbTBSFdXvPp5HdE41aSpgTLOu6zr8Kh2rQt8X+CFxo
         YO/q3FZslSEd1o0XpqquTam6x+8xFsRxcOJStwI8fIM9PIjzfn9eoC74/SW3Gz6bMvO0
         s1ro//PkyyAGG/DUyQpwRZDhU7zJX83Khk+9Q8oBdBQFFr8b3bQea+sY5XQUiprzJOqL
         oB/Q==
X-Gm-Message-State: AO0yUKWwz0RVyOL51BJR2dEOh8KfGUC0hg9OWJxRpkVxw/nRYLepMHj5
        LLj5HVDvwQzxImOQkuYWzIY=
X-Google-Smtp-Source: AK7set90m81EkLeRmjrdLOgpXsKKJzMnuO7cK6zuKoU0enaVY3qZaqiPbgmPLH239WTc/ED2MZoKnQ==
X-Received: by 2002:a05:6830:124e:b0:694:8a0f:644a with SMTP id s14-20020a056830124e00b006948a0f644amr4229340otp.38.1679770526049;
        Sat, 25 Mar 2023 11:55:26 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id k12-20020a0568301bec00b0069f8ff38bcbsm5226781otb.16.2023.03.25.11.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 11:55:25 -0700 (PDT)
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
Subject: [PATCH 2/8] sched/topology: introduce sched_numa_find_next_cpu()
Date:   Sat, 25 Mar 2023 11:55:08 -0700
Message-Id: <20230325185514.425745-3-yury.norov@gmail.com>
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

The function searches for the next CPU in a given cpumask according to
NUMA topology, so that it traverses cpus per-hop.

If the CPU is the last cpu in a given hop, sched_numa_find_next_cpu()
switches to the next hop, and picks the first CPU from there, excluding
those already traversed.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h |  7 +++++++
 kernel/sched/topology.c  | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index fea32377f7c7..4a63154fa036 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -247,6 +247,7 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 
 #ifdef CONFIG_NUMA
 int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node);
+int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop);
 extern const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops);
 #else
 static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
@@ -254,6 +255,12 @@ static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, i
 	return cpumask_nth(cpu, cpus);
 }
 
+static __always_inline
+int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop)
+{
+	return find_next_bit(cpumask_bits(cpus), small_cpumask_bits, cpu);
+}
+
 static inline const struct cpumask *
 sched_numa_hop_mask(unsigned int node, unsigned int hops)
 {
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 051aaf65c749..1860d9487fe1 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2130,6 +2130,45 @@ int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
 }
 EXPORT_SYMBOL_GPL(sched_numa_find_nth_cpu);
 
+/*
+ * sched_numa_find_next_cpu() - given the NUMA topology, find the next cpu
+ * cpumask: cpumask to find a cpu from
+ * cpu: current cpu
+ * node: local node
+ * hop: (in/out) indicates distance order of current CPU to a local node
+ *
+ * The function searches for next cpu at a given NUMA distance, indicated
+ * by hop, and if nothing found, tries to find CPUs at a greater distance,
+ * starting from the beginning.
+ *
+ * returns: cpu, or >= nr_cpu_ids when nothing found.
+ */
+int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop)
+{
+	unsigned long *cur, *prev;
+	struct cpumask ***masks;
+	unsigned int ret;
+
+	if (*hop >= sched_domains_numa_levels)
+		return nr_cpu_ids;
+
+	masks = rcu_dereference(sched_domains_numa_masks);
+	cur = cpumask_bits(masks[*hop][node]);
+	if (*hop == 0)
+		ret = find_next_and_bit(cpumask_bits(cpus), cur, nr_cpu_ids, cpu);
+	else {
+		prev = cpumask_bits(masks[*hop - 1][node]);
+		ret = find_next_and_andnot_bit(cpumask_bits(cpus), cur, prev, nr_cpu_ids, cpu);
+	}
+
+	if (ret < nr_cpu_ids)
+		return ret;
+
+	*hop += 1;
+	return sched_numa_find_next_cpu(cpus, 0, node, hop);
+}
+EXPORT_SYMBOL_GPL(sched_numa_find_next_cpu);
+
 /**
  * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away from
  *                         @node
-- 
2.34.1


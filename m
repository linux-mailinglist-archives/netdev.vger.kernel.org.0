Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7556F29E4
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjD3RSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjD3RS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:18:26 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C023595;
        Sun, 30 Apr 2023 10:18:18 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1a6715ee82fso18149665ad.1;
        Sun, 30 Apr 2023 10:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682875098; x=1685467098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8TFT+ESKwfU7QbMQhW5p+wdCiH0luZnBdTAjBAnH2Fg=;
        b=ke83Ke+83g4oZWBNC3U1aX00laf2hOH8TD69Tz/ZlUHkydQwQRS1g9KeTxEeoX+J8x
         uYblxYNvIflf+Fu+r4ZaDO/s2Q1MeRkMBriys0/OWj72TrfVWCYMFaX+y/69V/hU1K74
         G5L6m7HJUCZOUaHzyauz3hhZ63ODntNV+4yhgWueT1CpXcuLifDiI/i26UP5R5VzDB06
         JGWI8WnUd7Dyi+gU8pyPla2d4u8AjpYRSBv+02yxTEq89z6J82m8aHfqR8CccE1A7vtA
         tqxZYEVSxAqy2ejWmCsWkNyVNDBwu0E4tPDQRxCfL5Bf9y+2hMnQNvkWz5Y8V3/QSyyj
         sesg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682875098; x=1685467098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8TFT+ESKwfU7QbMQhW5p+wdCiH0luZnBdTAjBAnH2Fg=;
        b=i6dsQtTOOK3m+2AWx7ZcMd+BeY+zmv4cABYcJsAaol6q/iBibvsO0FhGlvBDFmamny
         84fE9ekJM4C74m/kD7vto9G2BVxouzrC3DPfrZt2WAut9AJNdXJCG0MvvTF9WL8AEAHU
         23i91rWjOKJNHBe9wjDpVtdSo6Bm2TFnCYRkW4iQ7Gqj1fsvacdwrtnjqgmIN6koLFyu
         H0UA0cdVf/XK7GByoRwE4jJQ2Vj8HcnmJCy9gnVThNv2qobFvJbnUbvxSC5M1Im5mpz0
         mSrVXfoN61MT4CONGcGVlrw9NUvcojXzDxuy1oQ7ZRaB99Q+TP1ZPpDvYCUVMV0kus7V
         ClHw==
X-Gm-Message-State: AC+VfDxbr/wEX6aAiuvXAk9svYnibBrv/WeDuhT/2ioNjFici2SsUMkm
        X9NS0wCpIt77Vycu1xDb5wg=
X-Google-Smtp-Source: ACHHUZ7frQxXvjq2TJpWQpvURgwj288wakVEzbaYwn3v9PW599mlWCVhQWHWq9Txfex7+SrmiThJoQ==
X-Received: by 2002:a17:902:ec92:b0:1a6:9079:2bb3 with SMTP id x18-20020a170902ec9200b001a690792bb3mr16126156plg.33.1682875098056;
        Sun, 30 Apr 2023 10:18:18 -0700 (PDT)
Received: from localhost ([4.1.102.3])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902b28400b001a64851087bsm16447001plr.272.2023.04.30.10.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 10:18:17 -0700 (PDT)
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
Subject: [PATCH v3 4/8] sched/topology: add for_each_numa_{,online}_cpu() macro
Date:   Sun, 30 Apr 2023 10:18:05 -0700
Message-Id: <20230430171809.124686-5-yury.norov@gmail.com>
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

for_each_cpu() is widely used in the kernel, and it's beneficial to
create a NUMA-aware version of the macro.

Recently added for_each_numa_hop_mask() works, but switching existing
codebase to using it is not an easy process.

New for_each_numa_cpu() is designed to be similar to the for_each_cpu().
It allows to convert existing code to NUMA-aware as simple as adding a
hop iterator variable and passing it inside new macro. for_each_numa_cpu()
takes care of the rest.

At the moment, we have 2 users of NUMA-aware enumerators. One is
Melanox's in-tree driver, and another is Intel's in-review driver:

https://lore.kernel.org/lkml/20230216145455.661709-1-pawel.chmielewski@intel.com/

Both real-life examples follow the same pattern:

	for_each_numa_hop_mask(cpus, prev, node) {
 		for_each_cpu_andnot(cpu, cpus, prev) {
 			if (cnt++ == max_num)
 				goto out;
 			do_something(cpu);
 		}
		prev = cpus;
 	}

With the new macro, it would look like this:

	for_each_numa_online_cpu(cpu, hop, node) {
		if (cnt++ == max_num)
			break;
		do_something(cpu);
 	}

Straight conversion of existing for_each_cpu() codebase to NUMA-aware
version with for_each_numa_hop_mask() is difficult because it doesn't
take a user-provided cpu mask, and eventually ends up with open-coded
double loop. With for_each_numa_cpu() it shouldn't be a brainteaser.
Consider the NUMA-ignorant example:

	cpumask_t cpus = get_mask();
	int cnt = 0, cpu;

	for_each_cpu(cpu, cpus) {
		if (cnt++ == max_num)
			break;
		do_something(cpu);
 	}

Converting it to NUMA-aware version would be as simple as:

	cpumask_t cpus = get_mask();
	int node = get_node();
	int cnt = 0, hop, cpu;

	for_each_numa_cpu(cpu, hop, node, cpus) {
		if (cnt++ == max_num)
			break;
		do_something(cpu);
 	}

The latter looks more verbose and avoids from open-coding that annoying
double loop. Another advantage is that it works with a 'hop' parameter with
the clear meaning of NUMA distance, and doesn't make people not familiar
to enumerator internals bothering with current and previous masks machinery.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index da92fea38585..6ed01962878c 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -291,4 +291,23 @@ sched_numa_hop_mask(unsigned int node, unsigned int hops)
 	     !IS_ERR_OR_NULL(mask);					       \
 	     __hops++)
 
+/**
+ * for_each_numa_cpu - iterate over cpus in increasing order taking into account
+ *		       NUMA distances from a given node.
+ * @cpu: the (optionally unsigned) integer iterator
+ * @hop: the iterator variable, must be initialized to a desired minimal hop.
+ * @node: the NUMA node to start the search from.
+ * @mask: the cpumask pointer
+ *
+ * Requires rcu_lock to be held.
+ */
+#define for_each_numa_cpu(cpu, hop, node, mask)					\
+	for ((cpu) = 0, (hop) = 0;						\
+		(cpu) = sched_numa_find_next_cpu((mask), (cpu), (node), &(hop)),\
+		(cpu) < nr_cpu_ids;						\
+		(cpu)++)
+
+#define for_each_numa_online_cpu(cpu, hop, node)				\
+	for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
+
 #endif /* _LINUX_TOPOLOGY_H */
-- 
2.37.2


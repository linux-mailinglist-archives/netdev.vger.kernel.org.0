Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F4A6C903A
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 19:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjCYSzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 14:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjCYSz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 14:55:29 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C19A276;
        Sat, 25 Mar 2023 11:55:28 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-17aaa51a911so5193774fac.5;
        Sat, 25 Mar 2023 11:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679770528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zfxWgKB5aCk68T/R6TGeUwEdD4lRWRfSSIJlLsnGFw=;
        b=BAienO2/ibUVO0Z4YAFHfx3M2quWfEawbFJ+DXnct1BU2jsgxyypiaF2BfYRgCTSeR
         W21P5x+4dfJ+IZNC45wf6AzDKwp+PjNmhe/CQLANkfBiSBe51uugMEhr1hyi/N6hrsn0
         Ld955euqWFwDW5o35hwcavZ8r2LDCkt+hxjysTLrEF7GqZ8esft14n9eaghfKiZj5CaM
         7QQ/bjd4r0sbnWr+4kRG9/CeKTqTDuQteHdd7DdwROpxZH0zwHVxHFFU07kvqgdQ4yq6
         fFUUNcNWFQH41meSzVGMMuJ/CMutrpn6v/Ddq5Ivd+kpYXifQ5aT2/AxcUSoAabt1Wvw
         yg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679770528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zfxWgKB5aCk68T/R6TGeUwEdD4lRWRfSSIJlLsnGFw=;
        b=FVVKLU7sqjO6J9ZF+jCPZcjj01IjBhi3EIuka2cZEBw6xzbhq+PCXTHi/akwyrQotL
         SxNHfUeR9BDVQwFZqeCSvjpYJbhQBPjGDd8z+4qAZE/Rg1SHVVnd/HXwpagaSmpLp3zl
         h3oH8FIcVF/8aRThiHZHVF30RB8weJXMdVZb9O4YA0zOxOySl7k5yqa7Espf3VILMRKi
         PGz2jmZAUan4aoCp1YEgzTvveIxu5+XH91wfZnOo/dpJxynIyYsMiKg92GynBYUu3F0A
         NNBA9UBjAywaM8naWPsh3PhQRLrKfNyPadGebi3Y9f7bOk5Pu4cgSNIGUXo/hE8k2MUB
         mryw==
X-Gm-Message-State: AAQBX9cafsHFhJA0vl7hguVYJQ3xhWmYWSsPj0DHK2dVtwep33fK0IVy
        1nBSEGe1rjLsmwiSjjZZfAU=
X-Google-Smtp-Source: AKy350ZUylzgZXJP+/bps9ubG4lTHaj53Ti/SBgH1G/IyOBLrh7qovnwSLf+0BT8AMiwuDG3n3oBMA==
X-Received: by 2002:a05:6871:401:b0:17e:a4d6:5e18 with SMTP id d1-20020a056871040100b0017ea4d65e18mr5316693oag.45.1679770527848;
        Sat, 25 Mar 2023 11:55:27 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id o9-20020a9d7649000000b00697be532609sm9978293otl.73.2023.03.25.11.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 11:55:27 -0700 (PDT)
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
Subject: [PATCH 3/8] sched/topology: add for_each_numa_cpu() macro
Date:   Sat, 25 Mar 2023 11:55:09 -0700
Message-Id: <20230325185514.425745-4-yury.norov@gmail.com>
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

for_each_cpu() is widely used in the kernel, and it's beneficial to
create a NUMA-aware version of the macro.

Recently added for_each_numa_hop_mask() works, but switching existing
codebase to it is not an easy process.

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

	for_each_numa_cpu(cpu, hop, node, cpu_possible_mask) {
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
 include/linux/topology.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4a63154fa036..62a9dd8edd77 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -286,4 +286,24 @@ sched_numa_hop_mask(unsigned int node, unsigned int hops)
 	     !IS_ERR_OR_NULL(mask);					       \
 	     __hops++)
 
+/**
+ * for_each_numa_cpu - iterate over cpus in increasing order taking into account
+ *		       NUMA distances from a given node.
+ * @cpu: the (optionally unsigned) integer iterator
+ * @hop: the iterator variable, must be initialized to a desired minimal hop.
+ * @node: the NUMA node to start the search from.
+ *
+ * Requires rcu_lock to be held.
+ *
+ * Because it's implemented as double-loop, using 'break' inside the body of
+ * iterator may lead to undefined behaviour. Use 'goto' instead.
+ *
+ * Yields intersection of @mask and cpu_online_mask if @node == NUMA_NO_NODE.
+ */
+#define for_each_numa_cpu(cpu, hop, node, mask)					\
+	for ((cpu) = 0, (hop) = 0;						\
+		(cpu) = sched_numa_find_next_cpu((mask), (cpu), (node), &(hop)),\
+		(cpu) < nr_cpu_ids;						\
+		(cpu)++)
+
 #endif /* _LINUX_TOPOLOGY_H */
-- 
2.34.1


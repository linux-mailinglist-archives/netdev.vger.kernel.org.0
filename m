Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06B8626B30
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 20:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbiKLTKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 14:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235082AbiKLTJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 14:09:55 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E8D17E30;
        Sat, 12 Nov 2022 11:09:55 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id j6so5516358qvn.12;
        Sat, 12 Nov 2022 11:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0/IgShbjb7qZAYWczuxoDmDyDdccuNPQ9P2AVi15HY=;
        b=J0b0MU4lkGEXnXmOdosQFkNAakaHFGH3KxRmUtgL1P2al7Bklhj93oiCUKf2JCUCj5
         oRbpR/1t7PQLl6/UvRLUOTIuyUdncAL5/yE5RvRusGwe3OTAV4bzbqzSIycPc3wgrc7Z
         xXohwCCcy8x686DW6W1DdRdUjMuplkiqSIfgzSohbZUIWCFAFgdMzg2Fu0bwH19bQLQC
         v0Y0RjN2jWDdGlL4XMldpgVLcZnYRtgFTimcVd7fM/3BXXK4SBHfy0G57g8tj+lFZQsy
         WcihYikQiL7hFjGwoCCFyqEVdzC9ha12z8CvTrg44hsq3cE0bPW0IWtS1VHzafkdHlKW
         zv1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d0/IgShbjb7qZAYWczuxoDmDyDdccuNPQ9P2AVi15HY=;
        b=0PDBiMK61JszYBdPZ3HBlmY+KWXSmsD4xDk3/H1eEFossjr4yLBlSqxVnOCyx+esON
         Srj/EiCkSBjzW9nNHcac3g9sy4SVvVxfG+VhIIZQKJ1EwMFv1xU/jU3v/eFbOenifbVn
         eDaf5So4XJUfT2NxKjj7Rkep2AI27De7oR8fy/FPk+9Dwv5NMrJdfZ9jRAIQN63MCr/q
         +dMSSO2964kGoB+Iq1CYb+l3hRispKhCvU3w+9YAvIaA7ttr0OqVfaBt88MmwZF7Lajd
         EVYsii7xXfOm2dhtjoeym/gwjbpu+9C3XjYlhXLGb7OyKdN6UWW4aQTUWkyElgt+F9s7
         jbwQ==
X-Gm-Message-State: ANoB5pkQIsesAllBoUddeUCbMk1Pz9HjsH6OQqp8VF8lcIKEME2THs82
        b5R4rVrDGbZ1uruWYxny0IgsmYbdt80=
X-Google-Smtp-Source: AA0mqf6105pixBNLmobZKxKFU+O3f3FIJRVWP8gdRjg3LLp/ywJgV6u55Uu/uUndEkpCeXzVhu4ktQ==
X-Received: by 2002:a05:6214:102a:b0:4bb:8ef1:b544 with SMTP id k10-20020a056214102a00b004bb8ef1b544mr6871877qvr.99.1668280193936;
        Sat, 12 Nov 2022 11:09:53 -0800 (PST)
Received: from localhost (user-24-236-74-177.knology.net. [24.236.74.177])
        by smtp.gmail.com with ESMTPSA id bp44-20020a05620a45ac00b006f956766f76sm3577980qkb.1.2022.11.12.11.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 11:09:53 -0800 (PST)
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
Subject: [PATCH v2 4/4] cpumask: improve on cpumask_local_spread() locality
Date:   Sat, 12 Nov 2022 11:09:46 -0800
Message-Id: <20221112190946.728270-5-yury.norov@gmail.com>
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

Switch cpumask_local_spread() to use newly added sched_numa_find_nth_cpu(),
which takes into account distances to each node in the system.

For the following NUMA configuration:

root@debian:~# numactl -H
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3
node 0 size: 3869 MB
node 0 free: 3740 MB
node 1 cpus: 4 5
node 1 size: 1969 MB
node 1 free: 1937 MB
node 2 cpus: 6 7
node 2 size: 1967 MB
node 2 free: 1873 MB
node 3 cpus: 8 9 10 11 12 13 14 15
node 3 size: 7842 MB
node 3 free: 7723 MB
node distances:
node   0   1   2   3
  0:  10  50  30  70
  1:  50  10  70  30
  2:  30  70  10  50
  3:  70  30  50  10

The new cpumask_local_spread() traverses cpus for each node like this:

node 0:   0   1   2   3   6   7   4   5   8   9  10  11  12  13  14  15
node 1:   4   5   8   9  10  11  12  13  14  15   0   1   2   3   6   7
node 2:   6   7   0   1   2   3   8   9  10  11  12  13  14  15   4   5
node 3:   8   9  10  11  12  13  14  15   4   5   6   7   0   1   2   3

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/cpumask.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index c7c392514fd3..255974cd6734 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -110,7 +110,7 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 #endif
 
 /**
- * cpumask_local_spread - select the i'th cpu with local numa cpu's first
+ * cpumask_local_spread - select the i'th cpu based on NUMA distances
  * @i: index number
  * @node: local numa_node
  *
@@ -132,15 +132,7 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
 		if (cpu < nr_cpu_ids)
 			return cpu;
 	} else {
-		/* NUMA first. */
-		cpu = cpumask_nth_and(i, cpu_online_mask, cpumask_of_node(node));
-		if (cpu < nr_cpu_ids)
-			return cpu;
-
-		i -= cpumask_weight_and(cpu_online_mask, cpumask_of_node(node));
-
-		/* Skip NUMA nodes, done above. */
-		cpu = cpumask_nth_andnot(i, cpu_online_mask, cpumask_of_node(node));
+		cpu = sched_numa_find_nth_cpu(cpu_online_mask, i, node);
 		if (cpu < nr_cpu_ids)
 			return cpu;
 	}
-- 
2.34.1


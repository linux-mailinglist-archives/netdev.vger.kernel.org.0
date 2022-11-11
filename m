Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DF5625211
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiKKEAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiKKEAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:00:37 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42455D6B5;
        Thu, 10 Nov 2022 20:00:36 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-13ba86b5ac0so4346973fac.1;
        Thu, 10 Nov 2022 20:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rAYwtSDCtMl3bQjs+7iu2M5ENCXGl/6+Ww9pC2GxEs0=;
        b=KR4r6IzzTgskdFP8Rme0Hyk5hPZYO4XY3H0XE01oKcqWfSSxHwOgNQFildSqG7miMu
         yT3JwPbuvWTmFKTkqBKQ3pPoL8Qr1qekp0RBD3sCT5GSt5yT4GagQvb92eg1jLDMJNE9
         mEZVf7PizTyM+S8UBZQU/ZzbNul6uDpvdFs7EgQoQUvTfZjbm0iEM+2jT5IsCcEPHgfZ
         t7eOAWf9iBX7Ta/BCpfo4G3yQNl/tNB7L7b3GrIQiTrSmXz5Y6ZvzjaVb132muydXYjO
         hlbs3i4lcl8LPuiN4zpEdO9/36k7BKO54FszguDYkNX3c5N0QauSjKVImNj9WgjS4YjD
         cp+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rAYwtSDCtMl3bQjs+7iu2M5ENCXGl/6+Ww9pC2GxEs0=;
        b=fF5296gH2wH1A/TEYr6UiAZ936uEmiHUL+pwzqFSJt3/WyGVPjVIr9VGMgie/hQorc
         0JUTMZh34wYiLgFoKbGeH6O1rTjZ2joedQQdb3woGvnHilZ/zTg6tkpGVKW9uL7/DYgV
         TvNg0xSLv5GNzHry9LjivZZOkmLhK5F/T62qoZs/54PZ/NQhfrwSQkpnhiD23ys9/lD9
         rKxpkbZjdBDNOSq+y0pHM+ZZSRZilGmf+wArtpkYrozmWt3Vchlih2DSPHwgVKQRCWw8
         8U2Fw5jQMYsheFcBn1+xZbrJv6VqyazbZikax8OcCQQQVo5OGS2XbjXLT1BDdULqrV27
         h92g==
X-Gm-Message-State: ACrzQf3CKAUVaV/Osj92d35qIscTsaUvaryK+JjsHpU0QlzBpOV0KED4
        ElBiHxoGKmGN/h2nN8r3pbaCvvsOcIA=
X-Google-Smtp-Source: AMsMyM7w0T3Gc5xKhp78M0R9cxJeB1gkaRqv6qQOCQrqpAz1kyY3RoQfByDnA0VaqsZydQZuKSO/oA==
X-Received: by 2002:a05:6870:d3ca:b0:13a:f0e3:cc1f with SMTP id l10-20020a056870d3ca00b0013af0e3cc1fmr2749422oag.164.1668139236062;
        Thu, 10 Nov 2022 20:00:36 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id er10-20020a056870c88a00b0013b911d5960sm709668oab.49.2022.11.10.20.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 20:00:35 -0800 (PST)
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
Subject: [PATCH 4/4] cpumask: improve on cpumask_local_spread() locality
Date:   Thu, 10 Nov 2022 20:00:27 -0800
Message-Id: <20221111040027.621646-5-yury.norov@gmail.com>
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

Switch cpumask_local_spread() to newly added sched_numa_find_nth_cpu(),
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


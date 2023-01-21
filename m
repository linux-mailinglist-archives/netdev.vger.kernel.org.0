Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA2A6763BF
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 05:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjAUEZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 23:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjAUEYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 23:24:47 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665E64FCFF;
        Fri, 20 Jan 2023 20:24:46 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id i12so5213778qvs.2;
        Fri, 20 Jan 2023 20:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PJerbQOhdlxy484c709V9ypFLveYN3mWM3Ilqj2sA+c=;
        b=h1Zx6Bhj5dIG43PbAkkOc/sx/Fw4MABjfDO4NdVNETxZjrABFVi6CcIhSBHShTZ1ey
         7xxCZ7kV52SFvmCDe24u2JxXV88gSDlATevMNCebe9/fGgVnlqVu2wvZxvcf6pkIxFCP
         Yg07TUTUpDY70BypZSjPbfsQfvOYVWOipY5iIChJ9za68UvhDPPrlG5eYi0Czepch6JV
         uAl7svrTw2xooaVcTHmVUrgnseoJyn7NbHCekN0aw0H0QteMyTj2fyS/fVVo1U2ce1iC
         QTrinnJz35pOkMDhXv0YTmwS41BJGrL2TTpQo1T/++7hFZhbVhNO7VYLsxMXjNx2aNYL
         Ilbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PJerbQOhdlxy484c709V9ypFLveYN3mWM3Ilqj2sA+c=;
        b=WHMjiHKMjkx0Dm+w1AdWr7egZKmQCDcoehK/7bhrxDyHI5LmE+sJn0LEJRhO0TUB2c
         Em+aBH0BazK9hilETidP4QthwMok+9HY8cmdzyTSD20R1zA/9eiTn0KjWy+ggDf23FtH
         0oEMmgOWPgVyAlR6GUfkcD7uJErrL+fj0sJGxhPDZbDIrTLREx8BNNZVMOu1mUoe4+ki
         oI6Wq1WQ+zj+BSk+4c2gqNCrT5WVT/3E99ea0AfJZbO9BSpyJbdBySIMmTzrfunqfLxr
         2s/KwbNT9nz0qc+u/E5f8I76Wlmy88xBft31AqzTtY6/1tZrk38gsbypq4pv+zzlV9Cr
         oYjg==
X-Gm-Message-State: AFqh2kq+ceSsP7Bb6N/kSkOL0GD9h0bzajoZqH3km7r3xZyZE+oid70x
        ORm+ouQ4exC5jCwV9shaLtbplSNPaSc=
X-Google-Smtp-Source: AMrXdXvUjjeX22hwx3Dzwkhvkh95BY6VIKvZMy3wWle7vZKGbhEUq/FJQy8JV4EwESVM+4/WQA8UXA==
X-Received: by 2002:a05:6214:57d1:b0:532:1f17:2ce7 with SMTP id lw17-20020a05621457d100b005321f172ce7mr26333198qvb.16.1674275085080;
        Fri, 20 Jan 2023 20:24:45 -0800 (PST)
Received: from localhost (50-242-44-45-static.hfc.comcastbusiness.net. [50.242.44.45])
        by smtp.gmail.com with ESMTPSA id h10-20020a05620a284a00b006feea093006sm27597979qkp.124.2023.01.20.20.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 20:24:44 -0800 (PST)
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
Subject: [PATCH 4/9] cpumask: improve on cpumask_local_spread() locality
Date:   Fri, 20 Jan 2023 20:24:31 -0800
Message-Id: <20230121042436.2661843-5-yury.norov@gmail.com>
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
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Peter Lafreniere <peter@n8pjl.ca>
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


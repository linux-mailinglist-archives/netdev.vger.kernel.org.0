Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E43D6763C4
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 05:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjAUEZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 23:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjAUEZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 23:25:09 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70723530EC;
        Fri, 20 Jan 2023 20:24:53 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id g16so3765838qtu.2;
        Fri, 20 Jan 2023 20:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwRl6AriAxtLsQshG0WLT8xXpSJi+NGIVxpWZYX/6II=;
        b=oYxzuFmr5pVt01gJibPdD5ns77LWVJeQmmVcsoPATQ4AhkNE8Da5wsu9Mc1wJLeNaB
         tehkdeWQw8aXAeGragVTrfuwq647RKKSq23gNAuq9fjHG5+mwpwbdicJcnlrSaljEfQr
         Eb4bFX6NvVp0r5sOxhE2t/7kgma9WzMeWKopGbGj4cFeEf3SghA9EFKoNP2F8ewXDmpg
         1GJMDoD0tN/M476NAiSuwmkMZjRnvs29wvpAoqtHYdA4dhfCJDtFiNT4jD3KDxwhJWJy
         7aVDQmCmdhwT0P+5kyStCHbeHIKIm0dZSkrbfczaE/6i5VUbDGixfB8lbev7Cga34Dh4
         WNOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qwRl6AriAxtLsQshG0WLT8xXpSJi+NGIVxpWZYX/6II=;
        b=wVG6Gd/rAGHQc2rlv9wYu0+LBdmUgtcntNe1rssNUWfZw5j2OSNzHu/4eEiqJ2uNWE
         6RIGnjH147H+VLLT2/YiWJTrT8+wWgGb2Ki+n8IvUpIPxZdDGaou6jyOpuoDK5X2cDhk
         zfJYB53CgMlRqEAp1ggjbDvtI3HvJDCX9vegzal9dTvROZAPt+82jS9AFHZ4bX8grCH9
         jLliBqUQT/UpADEPHWtxJBfiBZ3OaRhrTlgPPN4CP08xqKzjtJOD9LEdo5At0Ap1jkVd
         W+CZLY3VXAG9EY6IQtNaCEPXpVPajuiLcYgDyWZCNMBczHXd+m9+Q1kHsCZ3B4Ib2I8f
         E3Rg==
X-Gm-Message-State: AFqh2kolEj+i1bDZ8BECtUVoBZpNOYxNwwyWHOGyDjE2h+Xl4U2XD8M+
        Z/btl2BBENcohzdoB5giy0VUGH9b2tE=
X-Google-Smtp-Source: AMrXdXuIb83rZuSdHzA4rxpr75oAXNzqP23zVDgdCNSGS7ZxV26QSDHnFK2M21j5vg9ZIdQWGnLVzw==
X-Received: by 2002:ac8:6a0e:0:b0:3ab:7928:526c with SMTP id t14-20020ac86a0e000000b003ab7928526cmr23006426qtr.17.1674275092061;
        Fri, 20 Jan 2023 20:24:52 -0800 (PST)
Received: from localhost (50-242-44-45-static.hfc.comcastbusiness.net. [50.242.44.45])
        by smtp.gmail.com with ESMTPSA id ga15-20020a05622a590f00b003b6325dfc4esm8255304qtb.67.2023.01.20.20.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 20:24:51 -0800 (PST)
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
Subject: [PATCH 9/9] lib/cpumask: update comment for cpumask_local_spread()
Date:   Fri, 20 Jan 2023 20:24:36 -0800
Message-Id: <20230121042436.2661843-10-yury.norov@gmail.com>
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

Now that we have an iterator-based alternative for a very common case
of using cpumask_local_spread for all cpus in a row, it's worth to
mention that in comment to cpumask_local_spread().

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 lib/cpumask.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index 10aa15715c0d..98291b07c756 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -114,11 +114,29 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
  * @i: index number
  * @node: local numa_node
  *
- * This function selects an online CPU according to a numa aware policy;
- * local cpus are returned first, followed by non-local ones, then it
- * wraps around.
+ * Returns online CPU according to a numa aware policy; local cpus are returned
+ * first, followed by non-local ones, then it wraps around.
  *
- * It's not very efficient, but useful for setup.
+ * For those who wants to enumerate all CPUs based on their NUMA distances,
+ * i.e. call this function in a loop, like:
+ *
+ * for (i = 0; i < num_online_cpus(); i++) {
+ *	cpu = cpumask_local_spread(i, node);
+ *	do_something(cpu);
+ * }
+ *
+ * There's a better alternative based on for_each()-like iterators:
+ *
+ *	for_each_numa_hop_mask(mask, node) {
+ *		for_each_cpu_andnot(cpu, mask, prev)
+ *			do_something(cpu);
+ *		prev = mask;
+ *	}
+ *
+ * It's simpler and more verbose than above. Complexity of iterator-based
+ * enumeration is O(sched_domains_numa_levels * nr_cpu_ids), while
+ * cpumask_local_spread() when called for each cpu is
+ * O(sched_domains_numa_levels * nr_cpu_ids * log(nr_cpu_ids)).
  */
 unsigned int cpumask_local_spread(unsigned int i, int node)
 {
-- 
2.34.1


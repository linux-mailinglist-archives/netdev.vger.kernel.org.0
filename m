Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767C8628385
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236063AbiKNPIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbiKNPID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:08:03 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46D12251C;
        Mon, 14 Nov 2022 07:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668438482; x=1699974482;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XIilg+xcj9XZEI47WmKQMEcFk02U54/OcdVtAfGFssM=;
  b=NlmRcsRNizNHspNxsHRrey2wy0U4uhUlMySdqArSwEG/cBmKHLYp3ruN
   B9S+tgkX9DY6lTQmLmeeP28jUDUfUBRSKGFBdhUWOqfDc9kHMPp+EzBEx
   WQz/vT+3fuTjMhjgIYAOIWTb182hbS89uRFIlJtlk/jDTm6sEdZw9h0vl
   OacwYEohfxivP4UW/JRjrluLFltBOsmwiQNW2fKkzwBGfoNvh/rCC8tUg
   mtYVqGXxKH/W+tFkOrSKCtJLHqaad4pdjvSrsKTfgv/FQ6e4VyMV47b4D
   e3HNoJ4OyCqiIAog9x8VvWRMyeE7u+B6AWppaYxB9zw2DziwTKBL0EKem
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="299508128"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="299508128"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 07:02:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702032962"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702032962"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP; 14 Nov 2022 07:02:21 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ouayY-00CDTz-28;
        Mon, 14 Nov 2022 17:02:18 +0200
Date:   Mon, 14 Nov 2022 17:02:18 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
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
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 3/4] sched: add sched_numa_find_nth_cpu()
Message-ID: <Y3JYeld1VJwgFuWD@smile.fi.intel.com>
References: <20221112190946.728270-1-yury.norov@gmail.com>
 <20221112190946.728270-4-yury.norov@gmail.com>
 <Y3JRaSRpDJDUn2br@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3JRaSRpDJDUn2br@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 04:32:10PM +0200, Andy Shevchenko wrote:
> On Sat, Nov 12, 2022 at 11:09:45AM -0800, Yury Norov wrote:
> > The function finds Nth set CPU in a given cpumask starting from a given
> > node.
> > 
> > Leveraging the fact that each hop in sched_domains_numa_masks includes the
> > same or greater number of CPUs than the previous one, we can use binary
> > search on hops instead of linear walk, which makes the overall complexity
> > of O(log n) in terms of number of cpumask_weight() calls.
> 
> ...
> 
> > +struct __cmp_key {
> > +	const struct cpumask *cpus;
> > +	struct cpumask ***masks;
> > +	int node;
> > +	int cpu;
> > +	int w;
> > +};
> > +
> > +static int cmp(const void *a, const void *b)
> 
> Calling them key and pivot (as in the caller), would make more sense.
> 
> > +{
> 
> What about
> 
> 	const (?) struct cpumask ***masks = (...)pivot;
> 
> > +	struct cpumask **prev_hop = *((struct cpumask ***)b - 1);
> 
> 	= masks[-1];
> 
> > +	struct cpumask **cur_hop = *(struct cpumask ***)b;
> 
> 	= masks[0];
> 
> ?
> 
> > +	struct __cmp_key *k = (struct __cmp_key *)a;
> 
> > +	if (cpumask_weight_and(k->cpus, cur_hop[k->node]) <= k->cpu)
> > +		return 1;
> 
> > +	k->w = (b == k->masks) ? 0 : cpumask_weight_and(k->cpus, prev_hop[k->node]);
> > +	if (k->w <= k->cpu)
> > +		return 0;
> 
> Can k->cpu be negative? If no, we can rewrite above as
> 
> 	k->w = 0;
> 	if (b == k->masks)
> 		return 0;
> 
> 	k->w = cpumask_weight_and(k->cpus, prev_hop[k->node]);
> 
> > +	return -1;
> > +}
> 
> ...
> 
> > +int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
> > +{
> > +	struct __cmp_key k = { cpus, NULL, node, cpu, 0 };
> 
> You can drop NULL and 0 while using C99 assignments.
> 
> > +	int hop, ret = nr_cpu_ids;
> 
> > +	rcu_read_lock();
> 
> + Blank line?
> 
> > +	k.masks = rcu_dereference(sched_domains_numa_masks);
> > +	if (!k.masks)
> > +		goto unlock;
> 
> > +	hop = (struct cpumask ***)
> > +		bsearch(&k, k.masks, sched_domains_numa_levels, sizeof(k.masks[0]), cmp) - k.masks;
> 
> Strange indentation. I would rather see the split on parameters and
> maybe '-' operator.
> 
> sizeof(*k.masks) is a bit shorter, right?
> 
> Also we may go with
> 
> 
> 	struct cpumask ***masks;
> 	struct __cmp_key k = { .cpus = cpus, .node = node, .cpu = cpu };
> 
> 
> 
> > +	ret = hop ?
> > +		cpumask_nth_and_andnot(cpu - k.w, cpus, k.masks[hop][node], k.masks[hop-1][node]) :
> > +		cpumask_nth_and(cpu - k.w, cpus, k.masks[0][node]);
> 
> > +unlock:
> 
> out_unlock: shows the intention more clearly, no?
> 
> > +	rcu_read_unlock();
> > +	return ret;
> > +}

Below is a diff I have got on top of your patch, only compile tested:

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 024f1da0e941..e04262578b52 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2070,26 +2070,28 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
 }
 
 struct __cmp_key {
-	const struct cpumask *cpus;
 	struct cpumask ***masks;
+	const struct cpumask *cpus;
 	int node;
 	int cpu;
 	int w;
 };
 
-static int cmp(const void *a, const void *b)
+static int cmp(const void *key, const void *pivot)
 {
-	struct cpumask **prev_hop = *((struct cpumask ***)b - 1);
-	struct cpumask **cur_hop = *(struct cpumask ***)b;
-	struct __cmp_key *k = (struct __cmp_key *)a;
+	struct __cmp_key *k = container_of(key, struct __cmp_key, masks);
+	const struct cpumask ***masks = (const struct cpumask ***)pivot;
+	const struct cpumask **prev = masks[-1];
+	const struct cpumask **cur = masks[0];
 
-	if (cpumask_weight_and(k->cpus, cur_hop[k->node]) <= k->cpu)
+	if (cpumask_weight_and(k->cpus, cur[k->node]) <= k->cpu)
 		return 1;
 
-	k->w = (b == k->masks) ? 0 : cpumask_weight_and(k->cpus, prev_hop[k->node]);
-	if (k->w <= k->cpu)
+	k->w = 0;
+	if (masks == (const struct cpumask ***)k->masks)
 		return 0;
 
+	k->w = cpumask_weight_and(k->cpus, prev[k->node]);
 	return -1;
 }
 
@@ -2103,17 +2105,17 @@ static int cmp(const void *a, const void *b)
  */
 int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
 {
-	struct __cmp_key k = { cpus, NULL, node, cpu, 0 };
+	struct __cmp_key k = { .cpus = cpus, .node = node, .cpu = cpu };
 	int hop, ret = nr_cpu_ids;
+	struct cpumask ***masks;
 
 	rcu_read_lock();
 	k.masks = rcu_dereference(sched_domains_numa_masks);
 	if (!k.masks)
 		goto unlock;
 
-	hop = (struct cpumask ***)
-		bsearch(&k, k.masks, sched_domains_numa_levels, sizeof(k.masks[0]), cmp) - k.masks;
-
+	masks = bsearch(&k.masks, k.masks, sched_domains_numa_levels, sizeof(*k.masks), cmp);
+	hop = masks - k.masks;
 	ret = hop ?
 		cpumask_nth_and_andnot(cpu - k.w, cpus, k.masks[hop][node], k.masks[hop-1][node]) :
 		cpumask_nth_and(cpu - k.w, cpus, k.masks[0][node]);

-- 
With Best Regards,
Andy Shevchenko



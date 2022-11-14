Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4344562829A
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 15:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbiKNOcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 09:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237049AbiKNOcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 09:32:21 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF052A41D;
        Mon, 14 Nov 2022 06:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668436340; x=1699972340;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ltjoxGF7q5aRoJ7sj58+0iGCHn1M5KnR1vkmbFxtNGs=;
  b=ZpYiVVcWjmTNpgMMiAILBg9gxfQQR+5IFzmPukmNZfV+iz0BuZJ5pu90
   7QeVXJkvz/IlBokb073OPMYyOoc7HmlWDaFnIUsCWjWmAn1Pv/1G4Awhv
   cS4LcGGuVtnakfgghCjKyMQCd+G2EeSDhJMNWmxhjL6A8KzvsYrTzgFkF
   IHV4vBzoP+T9hmg6e2t6MxF9EePhR5a3CwYLnlaW1w3LMhr3v7ZbngXcJ
   dOAF1E5G7Voo/hTDfPAisr4eUvvUNIMmXggtSJhDhEBcz83Y+Zjy41Ogc
   YzQjg6SuzdPJuq+WeQ1XVBPQC0b7U1oFDOKFpE/DewnsLwd/5e8elaxdL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="311984936"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="311984936"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 06:32:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="638496515"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="638496515"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP; 14 Nov 2022 06:32:13 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ouaVO-00CCor-0N;
        Mon, 14 Nov 2022 16:32:10 +0200
Date:   Mon, 14 Nov 2022 16:32:09 +0200
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
Message-ID: <Y3JRaSRpDJDUn2br@smile.fi.intel.com>
References: <20221112190946.728270-1-yury.norov@gmail.com>
 <20221112190946.728270-4-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112190946.728270-4-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 12, 2022 at 11:09:45AM -0800, Yury Norov wrote:
> The function finds Nth set CPU in a given cpumask starting from a given
> node.
> 
> Leveraging the fact that each hop in sched_domains_numa_masks includes the
> same or greater number of CPUs than the previous one, we can use binary
> search on hops instead of linear walk, which makes the overall complexity
> of O(log n) in terms of number of cpumask_weight() calls.

...

> +struct __cmp_key {
> +	const struct cpumask *cpus;
> +	struct cpumask ***masks;
> +	int node;
> +	int cpu;
> +	int w;
> +};
> +
> +static int cmp(const void *a, const void *b)

Calling them key and pivot (as in the caller), would make more sense.

> +{

What about

	const (?) struct cpumask ***masks = (...)pivot;

> +	struct cpumask **prev_hop = *((struct cpumask ***)b - 1);

	= masks[-1];

> +	struct cpumask **cur_hop = *(struct cpumask ***)b;

	= masks[0];

?

> +	struct __cmp_key *k = (struct __cmp_key *)a;

> +	if (cpumask_weight_and(k->cpus, cur_hop[k->node]) <= k->cpu)
> +		return 1;

> +	k->w = (b == k->masks) ? 0 : cpumask_weight_and(k->cpus, prev_hop[k->node]);
> +	if (k->w <= k->cpu)
> +		return 0;

Can k->cpu be negative? If no, we can rewrite above as

	k->w = 0;
	if (b == k->masks)
		return 0;

	k->w = cpumask_weight_and(k->cpus, prev_hop[k->node]);

> +	return -1;
> +}

...

> +int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
> +{
> +	struct __cmp_key k = { cpus, NULL, node, cpu, 0 };

You can drop NULL and 0 while using C99 assignments.

> +	int hop, ret = nr_cpu_ids;

> +	rcu_read_lock();

+ Blank line?

> +	k.masks = rcu_dereference(sched_domains_numa_masks);
> +	if (!k.masks)
> +		goto unlock;

> +	hop = (struct cpumask ***)
> +		bsearch(&k, k.masks, sched_domains_numa_levels, sizeof(k.masks[0]), cmp) - k.masks;

Strange indentation. I would rather see the split on parameters and
maybe '-' operator.

sizeof(*k.masks) is a bit shorter, right?

Also we may go with


	struct cpumask ***masks;
	struct __cmp_key k = { .cpus = cpus, .node = node, .cpu = cpu };



> +	ret = hop ?
> +		cpumask_nth_and_andnot(cpu - k.w, cpus, k.masks[hop][node], k.masks[hop-1][node]) :
> +		cpumask_nth_and(cpu - k.w, cpus, k.masks[0][node]);

> +unlock:

out_unlock: shows the intention more clearly, no?

> +	rcu_read_unlock();
> +	return ret;
> +}

-- 
With Best Regards,
Andy Shevchenko



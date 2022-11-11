Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7FF6259AC
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 12:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiKKLmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 06:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbiKKLml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 06:42:41 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA8F293;
        Fri, 11 Nov 2022 03:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668166960; x=1699702960;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=124+lIYjUM+GMbJrh07c3Hmq7RwI2uO23bDDOBcYH8A=;
  b=aagjEUbPjNTEda7sEzNZguqxSmdc2FzoirdaF4wJSHFDsdr2Yi/Z2JyE
   T9kBr5XiPpp60Rs09+oZWbaUi47bvpqkZ18KjdvcvOe2BkYgHD9xmH1Cw
   IjvdiEg4jydldh2LiNQYY543zZGHgoZtypumHHat046zVpq226vLzqaxE
   E7CFBW4bktE76oRNOTlgj0aLVulS3gxIYhZH2iR1mhmAfCaELYplN40qi
   Lm/FstDY1erKKXo9c8TPDejoZA/O91z7jiIApDxFBrXkLCbetYk7i+A6w
   tvPsrT7VHDlCrn/9q9l5Fu8GPb4JFEjmpVEXSRqCeJ5+1Ke4SOrWrPUXv
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="294940955"
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="294940955"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 03:42:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="882740444"
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="882740444"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 11 Nov 2022 03:42:33 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1otSQX-00Afyh-3D;
        Fri, 11 Nov 2022 13:42:30 +0200
Date:   Fri, 11 Nov 2022 13:42:29 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
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
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 3/4] sched: add sched_numa_find_nth_cpu()
Message-ID: <Y241Jd+27r/ZIiji@smile.fi.intel.com>
References: <20221111040027.621646-1-yury.norov@gmail.com>
 <20221111040027.621646-4-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111040027.621646-4-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 08:00:26PM -0800, Yury Norov wrote:
> The function finds Nth set CPU in a given cpumask starting from a given
> node.
> 
> Leveraging the fact that each hop in sched_domains_numa_masks includes the
> same or greater number of CPUs than the previous one, we can use binary
> search on hops instead of linear walk, which makes the overall complexity
> of O(log n) in terms of number of cpumask_weight() calls.

...

> +int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
> +{
> +	unsigned int first = 0, mid, last = sched_domains_numa_levels;
> +	struct cpumask ***masks;

*** ?
Hmm... Do we really need such deep indirection?

> +	int w, ret = nr_cpu_ids;
> +
> +	rcu_read_lock();
> +	masks = rcu_dereference(sched_domains_numa_masks);
> +	if (!masks)
> +		goto out;
> +
> +	while (last >= first) {
> +		mid = (last + first) / 2;
> +
> +		if (cpumask_weight_and(cpus, masks[mid][node]) <= cpu) {
> +			first = mid + 1;
> +			continue;
> +		}
> +
> +		w = (mid == 0) ? 0 : cpumask_weight_and(cpus, masks[mid - 1][node]);

See below.

> +		if (w <= cpu)
> +			break;
> +
> +		last = mid - 1;
> +	}

We have lib/bsearch.h. I haven't really looked deeply into the above, but my
gut feelings that that might be useful here. Can you check that?

> +	ret = (mid == 0) ?
> +		cpumask_nth_and(cpu - w, cpus, masks[mid][node]) :
> +		cpumask_nth_and_andnot(cpu - w, cpus, masks[mid][node], masks[mid - 1][node]);

You can also shorten this by inversing the conditional:

	ret = mid ? ...not 0... : ...for 0...;

> +out:

out_unlock: ?

> +	rcu_read_unlock();
> +	return ret;
> +}

-- 
With Best Regards,
Andy Shevchenko



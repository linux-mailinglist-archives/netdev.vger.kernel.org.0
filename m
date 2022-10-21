Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4544960781A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 15:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiJUNR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 09:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiJUNRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 09:17:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95425A15C;
        Fri, 21 Oct 2022 06:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666358233; x=1697894233;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=67TEJpud3tBGYj0e5MnovwOYbbICjK4y1xG4dR2yYi0=;
  b=JSYW4dpHngrcegdk8AZLnsRos+91tnLMDlRdnSTKbRdPmNxdiFPU4lzW
   9U5elHUjC8vg2LS0PskXXC6hgJGnIK1doYvbDTnzgZVWjxEUhzkoV+KEP
   y0QDgqSQQU2hs3cB3Gad2FcjWo+g4HwuKW+Qagj7NMe5zzyzDjew/+/tK
   iKo7TUAWSZwfsYGl3rp1RQqwP8outde+9u/7sITKtZUWD1X/6S1hoxhxr
   NIIpku2y5hyH+jXzoFxgp6SzhNbaGAksTZ0vrCyvFqtiUGk+uitru3zUC
   gHcIB+9kH6gWPfm+GFLgUvna05nYU5O1fQ8jAr54MPbj43HL6ZwncmPXa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="305736330"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="305736330"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 06:16:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="699338736"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="699338736"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004.fm.intel.com with ESMTP; 21 Oct 2022 06:16:20 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1olrsn-00BAgP-0n;
        Fri, 21 Oct 2022 16:16:17 +0300
Date:   Fri, 21 Oct 2022 16:16:17 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v5 2/3] sched/topology: Introduce for_each_numa_hop_mask()
Message-ID: <Y1KboXN0f8dLjqit@smile.fi.intel.com>
References: <20221021121927.2893692-1-vschneid@redhat.com>
 <20221021121927.2893692-3-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021121927.2893692-3-vschneid@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 01:19:26PM +0100, Valentin Schneider wrote:
> The recently introduced sched_numa_hop_mask() exposes cpumasks of CPUs
> reachable within a given distance budget, wrap the logic for iterating over
> all (distance, mask) values inside an iterator macro.

...

>  #ifdef CONFIG_NUMA
> -extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
> +extern const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops);
>  #else
> -static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
> +static inline const struct cpumask *
> +sched_numa_hop_mask(unsigned int node, unsigned int hops)
>  {
> -	if (node == NUMA_NO_NODE && !hops)
> -		return cpu_online_mask;
> -
>  	return ERR_PTR(-EOPNOTSUPP);
>  }
>  #endif	/* CONFIG_NUMA */

I didn't get how the above two changes are related to the 3rd one which
introduces a for_each type of macro.

If you need change int --> unsigned int, perhaps it can be done in a separate
patch.

The change inside inliner I dunno about. Not an expert.

...

> +#define for_each_numa_hop_mask(mask, node)				     \
> +	for (unsigned int __hops = 0;					     \
> +	     /*								     \
> +	      * Unsightly trickery required as we can't both initialize	     \
> +	      * @mask and declare __hops in for()'s first clause	     \
> +	      */							     \
> +	     mask = __hops > 0 ? mask :					     \
> +		    node == NUMA_NO_NODE ?				     \
> +		    cpu_online_mask : sched_numa_hop_mask(node, 0),	     \
> +	     !IS_ERR_OR_NULL(mask);					     \

> +	     __hops++,							     \
> +	     mask = sched_numa_hop_mask(node, __hops))

This can be unified with conditional, see for_each_gpio_desc_with_flag() as
example how.

-- 
With Best Regards,
Andy Shevchenko



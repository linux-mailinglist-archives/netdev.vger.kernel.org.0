Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AD8607893
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 15:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiJUNfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 09:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiJUNfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 09:35:01 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645253FEF1;
        Fri, 21 Oct 2022 06:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666359299; x=1697895299;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=osQLTHLjWVpHUs3ch1GfhTTRewL1usATqGUUi7FJVFk=;
  b=XtqGkpZVvifKaq7GKt2shMcMqNeQVmJUjGM9s2GB+iqqjkV3nN4fUj5K
   vB9z/TIRtjGnpNN+UhmgXEECcEpBBNv7LBBwA3TtLgIKQr+m3ZmV0ZWB5
   MvIuZ9uD+0husmgyRZRvayrXwW8y4hRLbrbtPax2BtFCtn12Xv7/E32CN
   mOmL/Swn7HXERqPkDJeqG9ngwZK02ScH3vIy2j4l8AdiYIgfTGDIw11ld
   99eE7RW015UH6RHNKYQikUqvv1RIazqEe8wXP+sGad4MtTRHbMASrmMPN
   c1RfeqmYgGEShQH/uvq2TuWhBY2gLeYG5cW3vqzzYzsLbuWggX8oGdyzH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="306995586"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="306995586"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 06:34:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="661605500"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="661605500"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008.jf.intel.com with ESMTP; 21 Oct 2022 06:34:52 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1olsAj-00BBvj-22;
        Fri, 21 Oct 2022 16:34:49 +0300
Date:   Fri, 21 Oct 2022 16:34:49 +0300
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
Message-ID: <Y1Kf+aZPIxGCbksM@smile.fi.intel.com>
References: <20221021121927.2893692-1-vschneid@redhat.com>
 <20221021121927.2893692-3-vschneid@redhat.com>
 <Y1KboXN0f8dLjqit@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1KboXN0f8dLjqit@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 04:16:17PM +0300, Andy Shevchenko wrote:
> On Fri, Oct 21, 2022 at 01:19:26PM +0100, Valentin Schneider wrote:

...

> > +#define for_each_numa_hop_mask(mask, node)				     \
> > +	for (unsigned int __hops = 0;					     \
> > +	     /*								     \
> > +	      * Unsightly trickery required as we can't both initialize	     \
> > +	      * @mask and declare __hops in for()'s first clause	     \
> > +	      */							     \
> > +	     mask = __hops > 0 ? mask :					     \
> > +		    node == NUMA_NO_NODE ?				     \
> > +		    cpu_online_mask : sched_numa_hop_mask(node, 0),	     \
> > +	     !IS_ERR_OR_NULL(mask);					     \
> 
> > +	     __hops++,							     \
> > +	     mask = sched_numa_hop_mask(node, __hops))
> 
> This can be unified with conditional, see for_each_gpio_desc_with_flag() as
> example how.

Something like

	mask = (__hops || node != NUMA_NO_NODE) ? sched_numa_hop_mask(node, __hops) : cpu_online_mask

-- 
With Best Regards,
Andy Shevchenko



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3367D6260F1
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 19:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiKKSPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 13:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbiKKSO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 13:14:58 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57555682AB;
        Fri, 11 Nov 2022 10:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668190496; x=1699726496;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rLc5Ixga1hS37ddV0n0/E/iWK+ZYtrwFO7ML+W9DUPo=;
  b=d1zxWujy/UzRUkKilJL4qgSxC4wQj7E3ZAmJoRqf/pWhi3L0CgvZhy0V
   bYgcjzlj1mCFvE2OZQrDVqrxTT8NCl3w+XdrXf/QMquEPUcWDD5aT3cTY
   gVfkWhefLmAh8UvM77DWWrAhMcKdx5c+yKFopqCct1UXefEA2X5uVcJV7
   hGG0jadyH9kXllyPRH1UyTY5F0j0iRLVHgxRkO08Fnaz1rRPzIHLX320x
   bbL8jRDjGGE5sa5PZGGur9Tr5HUr3MXFkeHqN78NJTHp2GY7bjGQiBbW5
   O1IZGcCkSr5Ih7zB7gCRwHl86fVZsckUmTqedcmUnD8XcJgiOlz2rtCng
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="312792388"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="312792388"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 10:14:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="812512249"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="812512249"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005.jf.intel.com with ESMTP; 11 Nov 2022 10:14:48 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1otYY8-00Aq5e-35;
        Fri, 11 Nov 2022 20:14:44 +0200
Date:   Fri, 11 Nov 2022 20:14:44 +0200
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
Message-ID: <Y26RFIt33n7khJZp@smile.fi.intel.com>
References: <20221111040027.621646-1-yury.norov@gmail.com>
 <20221111040027.621646-4-yury.norov@gmail.com>
 <Y241Jd+27r/ZIiji@smile.fi.intel.com>
 <Y26BQ92l9xWKaz2z@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y26BQ92l9xWKaz2z@yury-laptop>
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

On Fri, Nov 11, 2022 at 09:07:15AM -0800, Yury Norov wrote:
> On Fri, Nov 11, 2022 at 01:42:29PM +0200, Andy Shevchenko wrote:
> > On Thu, Nov 10, 2022 at 08:00:26PM -0800, Yury Norov wrote:

...

> > > +out:
> > 
> > out_unlock: ?
> 
> Do you think it's better?

Yes. It shows what will happen at goto.

So when one reads the "goto out;" it's something like "return ret;".
But "goto out_unlock;" immediately pictures "unlock; return ret;".

P.S. That's basically the way how we name labels.

> > > +	rcu_read_unlock();
> > > +	return ret;

-- 
With Best Regards,
Andy Shevchenko



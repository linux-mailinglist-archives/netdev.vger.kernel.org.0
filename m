Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BCB69AA03
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBQLNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjBQLNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:13:35 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A72453ED6;
        Fri, 17 Feb 2023 03:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676632382; x=1708168382;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+QB7bJBNf4B00FliCasmuX9iTJnGkOIN//OmJgFuQGE=;
  b=nvOpk67BGcxoG9VYHTJVqRQSqQNdsQHnIwZJUpkRRDPShVeeKTHenila
   SMtNa16fI9VV/Awv3/2WoNTFa8EI3s72eqmsq88LCavDnipuqGaB7ElDH
   vCy99FXQ757lObD4Ky1ydEX11h6oJip6Mn8d5BVvwsFsba6wCWZihPPI1
   16WAZ9MTUSsweiFMdWZKIpEAfVdNUwQz2Hw61YX1gc7PhN7pCNbBXMSFU
   XHBmcQAyJTFaFXM87MirDrZiRgrf3B20aNQhQPVjeQtsn7HYw+x84U0O5
   rvCcabk8xdK91fXOL5wCKMDyxquM7+HtxyRZTmrjICG7Qb5tdhEOxcy/9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="333324013"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="333324013"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 03:11:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="700867270"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="700867270"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008.jf.intel.com with ESMTP; 17 Feb 2023 03:11:50 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pSyeZ-008AvD-0d;
        Fri, 17 Feb 2023 13:11:47 +0200
Date:   Fri, 17 Feb 2023 13:11:46 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Bruno Goncalves <bgoncalv@redhat.com>,
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
        Kees Cook <kees@kernel.org>,
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
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 3/9] sched: add sched_numa_find_nth_cpu()
Message-ID: <Y+9g8lKZ86KK39Nh@smile.fi.intel.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
 <20230121042436.2661843-4-yury.norov@gmail.com>
 <Y+7avK6V9SyAWsXi@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+7avK6V9SyAWsXi@yury-laptop>
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

On Thu, Feb 16, 2023 at 05:39:08PM -0800, Yury Norov wrote:

> From: Yury Norov <yury.norov@gmail.com>
> Date: Thu, 16 Feb 2023 17:03:30 -0800
> Subject: [PATCH] sched/topology: fix KASAN warning in hop_cmp()
> 
> Despite that prev_hop is used conditionally on curr_hop is not the

curr --> cur

> first hop, it's initialized unconditionally.
> 
> Because initialization implies dereferencing, it might happen that
> the code dereferences uninitialized memory, which has been spotted by
> KASAN. Fix it by reorganizing hop_cmp() logic.

Nice catch! I guess it deserves for a comment inside the code
(IIRC I was puzzled of the logic behind and it was changed due
 to lack of this knowledge.)


-- 
With Best Regards,
Andy Shevchenko



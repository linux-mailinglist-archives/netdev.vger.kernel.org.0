Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269506CA15B
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjC0K07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbjC0K0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:26:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40430524A;
        Mon, 27 Mar 2023 03:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679912797; x=1711448797;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FDkJTIknpo1O0+dtID0O/BKWTRjLmtO8zZFy9jx/EcU=;
  b=Gk0eq/CkYtrS+KgeJDinXWfuGG32+k9G5z5lgflxclMNB6KnH90VjfZz
   8+UvdESdFdd8Hzu26gU4nq6qZM3xONcjhj8+wGTrDoTv4kvEx/qFQCAzX
   UhqsG/DcO2z3qw+WejdZGsaISRIzGqtFRT4Yc5cw3iHm6WgsJaiL54FAK
   /uzc+Zj66bN80X9QqB0rIdj2WyHfcqLCkZyr+n17nprgR9SKN31pevHG7
   w4ZjSWNd1pygPtJxwtds9YwYjw+ef3QIj4wUgfWB1tQEbV/0VSE+EBJqP
   sIn0AnjWhjfGc3fJ5VS7hSV+Cwa/AnXQD/OkhZPf7a6e7uE/G16pNeFzz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="341804700"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="341804700"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 03:26:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="660789036"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="660789036"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006.jf.intel.com with ESMTP; 27 Mar 2023 03:26:25 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pgk3R-009Auo-2y;
        Mon, 27 Mar 2023 13:26:21 +0300
Date:   Mon, 27 Mar 2023 13:26:21 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 1/8] lib/find: add find_next_and_andnot_bit()
Message-ID: <ZCFvTWg8YAhp7AbR@smile.fi.intel.com>
References: <20230325185514.425745-1-yury.norov@gmail.com>
 <20230325185514.425745-2-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325185514.425745-2-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 11:55:07AM -0700, Yury Norov wrote:
> Similarly to find_nth_and_andnot_bit(), find_next_and_andnot_bit() is
> a convenient helper that allows traversing bitmaps without storing
> intermediate results in a temporary bitmap.
> 
> In the following patches the function is used to implement NUMA-aware
> CPUs enumeration.

...

> +/**
> + * find_next_and_andnot_bit - find the next bit set in *addr1 and *addr2,
> + *			      excluding all the bits in *addr3
> + * @addr1: The first address to base the search on
> + * @addr2: The second address to base the search on
> + * @addr3: The third address to base the search on
> + * @size: The bitmap size in bits
> + * @offset: The bitnumber to start searching at

> + * Returns the bit number for the next set bit
> + * If no bits are set, returns @size.

`kernel-doc -v` nowadays complains about absence of the Return: section.
Can we start providing it in the expected format?

Ditto for other documentation excerpts (old and new).

> + */

-- 
With Best Regards,
Andy Shevchenko



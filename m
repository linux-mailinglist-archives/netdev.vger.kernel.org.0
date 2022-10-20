Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1251A60616D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiJTNVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiJTNU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:20:56 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F60050FA2;
        Thu, 20 Oct 2022 06:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666272018; x=1697808018;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ewoveUVcyLZWJbZ5SJjjx/Djc1RxaB7J+7ehKi/xDS8=;
  b=DWHtENPS1lVtvJTXMH8kmHijE1cBjZnN/DVwiTBXqek3tR4ld41mzGvR
   tlu1pExIg0CuwaHh3p2wzBqNI4hJob9CPOT223PhaOCOLmxD5ILBA3U3y
   aFiI938+zCPTlSQdwn0nKUHfQ7NaECnaWtbof5XmTxrYUVdZ4K9mnQa/r
   rnCQCMgA1WvIfxB8JO9+QFbUu/8t0yu8JFNOBQdof3JBjo63q2cbhQ1Y6
   qE5HwcNUktfArWm4pPNcaBgFmlvYBU228PbwmLa5NqxrCjnCsQK09/f/u
   iEZec1xXHOZQ49wXqEWLH+X1P0FfFjT+3f3qT0Fd37ah4VEOt5CwrySGg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="306695425"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="306695425"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 06:18:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="663039275"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="663039275"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 20 Oct 2022 06:18:10 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1olVR2-00AYb7-2K;
        Thu, 20 Oct 2022 16:18:08 +0300
Date:   Thu, 20 Oct 2022 16:18:08 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/6] bitmap: add a couple more helpers to
 work with arrays of u32s
Message-ID: <Y1FKkHEtc80wVWw3@smile.fi.intel.com>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com>
 <20221018140027.48086-3-alexandr.lobakin@intel.com>
 <Y1CUbRA6hC6PO3IH@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1CUbRA6hC6PO3IH@yury-laptop>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 05:21:01PM -0700, Yury Norov wrote:
> On Tue, Oct 18, 2022 at 04:00:23PM +0200, Alexander Lobakin wrote:

...

> > +static inline size_t bitmap_arr32_size(size_t nbits)
> > +{
> > +	return array_size(BITS_TO_U32(nbits), sizeof(u32));
> 
> To me this looks simpler: round_up(nbits, 32) / BITS_PER_BYTE.
> Can you check which generates better code?

It's not only about better code, but also about overflow protection, which your
proposal is missing.

> > +}

-- 
With Best Regards,
Andy Shevchenko



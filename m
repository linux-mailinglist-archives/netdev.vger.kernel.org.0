Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A9C649A1B
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 09:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiLLIgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 03:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiLLIgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 03:36:02 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAFCDFAA;
        Mon, 12 Dec 2022 00:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670834161; x=1702370161;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bFYTa27LxNC965Nl6ptrEOem3ftkvwtR2lcZjjhuh7w=;
  b=Ctpcli0Qu5gkHgOCOhBib4kAIwQyDbs9RvQiX3xGNTUYi3eEQQ7U3Nuh
   0dNICWlhMfnaQYPoU6fK7JzSMFJDDJmY7r/cQed6pd5h25++CSYhvj4/I
   tyiGi6964uzL1ir573stEVlhaVjcIh9rKbD1oLqgsOG9ZxlnyASN5wcm+
   iBMv4ly/I6ElKrv0u23X4YzRGAckMGAUnRWiXK+E2CSXwQ03CEUQCI2P8
   vBQNkmWz8CxDxJBaJfeVp/XUnYPcnsQXXPi/I3k+A76sheagMOzPYamGM
   Xg519DOI/27uQeUYXxixZD14ABPLZRnRsO7Yy89Iwn9bnfMlD0/aPSUZ9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="380011023"
X-IronPort-AV: E=Sophos;i="5.96,237,1665471600"; 
   d="scan'208";a="380011023"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 00:36:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="822407894"
X-IronPort-AV: E=Sophos;i="5.96,237,1665471600"; 
   d="scan'208";a="822407894"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005.jf.intel.com with ESMTP; 12 Dec 2022 00:35:56 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1p4eHx-008Nh5-28;
        Mon, 12 Dec 2022 10:35:53 +0200
Date:   Mon, 12 Dec 2022 10:35:53 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     david.keisarschm@mail.huji.ac.il
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/5] Renaming weak prng invocations -
 prandom_bytes_state, prandom_u32_state
Message-ID: <Y5bn6XcozgjbcSkf@smile.fi.intel.com>
References: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
 <b3caaa5ac5fca4b729bf1ecd0d01968c09e6d083.1670778652.git.david.keisarschm@mail.huji.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3caaa5ac5fca4b729bf1ecd0d01968c09e6d083.1670778652.git.david.keisarschm@mail.huji.ac.il>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 12:16:04AM +0200, david.keisarschm@mail.huji.ac.il wrote:
> From: David <david.keisarschm@mail.huji.ac.il>
> 
> Since the two functions
>  prandom_byte_state and prandom_u32_state
>  use the weak prng prandom_u32,
>  we added the prefix predictable_rng,
>  to their signatures so it is clear they are weak.

It's fancy indentation.

...

>  		/* Fisher-Yates shuffle */
>  		for (i = count - 1; i > 0; i--) {
> -			rand = prandom_u32_state(&state.rnd_state);
> +			rand = predictable_rng_prandom_u32_state(&state.rnd_state);

Isn't it too many "random":s encoded in the name?

I would leave either "rng" or "[p]random".

>  			rand %= (i + 1);
>  			swap_free_obj(slab, i, rand);
>  		}

-- 
With Best Regards,
Andy Shevchenko



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFC7578C82
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiGRVMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbiGRVL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:11:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C88A31DD8;
        Mon, 18 Jul 2022 14:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658178718; x=1689714718;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=B8FiBLFp5csoUvFgk1WR/dfs+8dLITXSfuetGEHiUoY=;
  b=CEB2EwYfH7GxYV40MJKQETf1mxGKLaW4O4FSayfCf4MjpDgqKE8PEbBQ
   JbqOhvVEE+XlI1LlkL5EJdN+QDk+m2IefH3FLjPTsaR17pFFXy/8x3phX
   gK2YV3Dx1o07PGEujgvmEc5a1b4csz9BzdI75ynV4E2KLhenpocdIswFK
   bAg0VB3Ox4/ITmnU0l0kqzVkgbRTi9ZE5rUW5OreH2HBza3Q5EoujWNRc
   XZrAHrsKO8KoajaQarJqBv+6LOdlFnLVahsC4ZKahA1UzmrdWoI4xIoiw
   fT0q5+dWHJvIWDctfpxulclt/U+DKWKJStk/UzvkanyoYO5tm3J3wEFxH
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="350284486"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="350284486"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 14:11:58 -0700
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="739614852"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 14:11:48 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oDY1n-001OYv-2P;
        Tue, 19 Jul 2022 00:11:43 +0300
Date:   Tue, 19 Jul 2022 00:11:43 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Klimov <aklimov@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ingo Molnar <mingo@redhat.com>,
        Isabella Basso <isabbasso@riseup.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>, Miroslav Benes <mbenes@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 06/16] lib/test_bitmap: delete meaningless test for
 bitmap_cut
Message-ID: <YtXMjwXnRIT+YHg7@smile.fi.intel.com>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-7-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718192844.1805158-7-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:28:34PM -0700, Yury Norov wrote:
> One of bitmap_cut() tests passed it with:
> 	nbits = BITS_PER_LONG;
> 	first = BITS_PER_LONG;
> 	cut = BITS_PER_LONG;
> 
> This test is useless because the range to cut is not inside the
> bitmap. This should normally raise an error, but bitmap_cut() is
> void and returns nothing.
> 
> To check if the test is passed, it just tests that the memory is
> not touched by bitmap_cut(), which is probably not correct, because
> if a function is passed with wrong parameters, it's too optimistic 
> to expect a correct, or even sane behavior.
> 
> Now that we have bitmap_check_params(), there's a tool to detect such
> things in real code, and we can drop the test.

There are no "useless" tests. Same comments as per a couple of previous
patches.

-- 
With Best Regards,
Andy Shevchenko



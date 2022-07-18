Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8113578C54
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbiGRVBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236123AbiGRVBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:01:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812313244B;
        Mon, 18 Jul 2022 14:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658178107; x=1689714107;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UQvO2SGkmfD9hjqb37rGZKMgLdkMhJ/GnFkJAWX9FrE=;
  b=fjwH4FRQzpNGmNOpln1zXlFEZzIQY/JgGT9JJEhakn1KHStDPDVgtwid
   RGoUUpCfoYYunRylVctZff5K1o3Dec3dEpYEFid3p7Llw91IU5sTQz/ur
   wFjI9h6FK9wFLa6NN4i+KvfWdqplClt7ZUPU5lCUIGqMlRDIPOvK1vESi
   OD/pd5yW8XvQpN80OCjmfX0qlJEE9ZLavU8CyhyEZFK9jtSFtIPttmnTq
   3yETCFKEis/sj4MrgcJ8BBjph2Fz2LHkMZ9Q26SeNAhmeTfLpMRJ8sUhD
   UDU1L0nS2u4al7MsCTt/QTcjh4fKnB2xQ2JTJGxuqsBOJaWREYlT9C8/S
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="283885982"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="283885982"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 14:01:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="655450280"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 14:01:37 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oDXrw-001OYG-1f;
        Tue, 19 Jul 2022 00:01:32 +0300
Date:   Tue, 19 Jul 2022 00:01:32 +0300
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
Subject: Re: [PATCH 01/16] lib/bitmap: add bitmap_check_params()
Message-ID: <YtXKLOJDzin6LeRA@smile.fi.intel.com>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-2-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718192844.1805158-2-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:28:29PM -0700, Yury Norov wrote:
> bitmap_check_params() takes all arguments passed into bitmap functions
> and runs sanity checks. bitmap_check(), bitmap_check_op() and
> bitmap_check_move() are convenient wrappers for frequent cases.
> 
> The following patches of this series clear all warnings found with
> bitmap_check_params() for x86_64, arm64 and powerpc64.
> 
> The last patch introduces CONFIG_DEBUG_BITMAP option to let user enable
> bitmap_check_params().
> 
> No functional changes for existing kernel users, and for the following
> functions inline parameters checks removed:
>  - bitmap_pos_to_ord;
>  - bitmap_remap;
>  - bitmap_onto;
>  - bitmap_fold.

...

> +#define bitmap_check_params(b1, b2, b3, nbits, start, off, flags)		\
> +	do {									\
> +		if (__bitmap_check_params((b1), (b2), (b3), (nbits),		\
> +						(start), (off), (flags))) {	\
> +			pr_warn("Bitmap: parameters check failed");		\
> +			pr_warn("%s [%d]: %s\n", __FILE__, __LINE__, __func__);	\
> +		}								\
> +	} while (0)

Why printk() and not trace points?

Also, try to avoid WARN() / etc in the generic code, it may be easily converted
to the BUG() (by kernel command line option, no recompilation needed), and
hence make all WARN() effectively reboot machine. Can you guarantee that in all
cases the functionality is critical to continue only with correct parameters?

-- 
With Best Regards,
Andy Shevchenko



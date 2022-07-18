Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DF4578CF3
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbiGRVii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbiGRVie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:38:34 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4754832DB3;
        Mon, 18 Jul 2022 14:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658180305; x=1689716305;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rWXYDKxVPXg4e3PYB2fvhJbVOl7JEUozCmhPRc0BwnI=;
  b=jRdI3XpO/JiJmgKn/7o34KRqGl8yOSXG/eUOEFqQ65+qOgOZ7AC46Zum
   r3tKtmhsXkqYvXL0ZDpO4JJJ+QptLXwIUNwWX1XbGw6mfKgEkQO6NWyvH
   g58VEgao/A10M7C+UA78kIP8Lsxnr8W1l0b1/EPpQx8vopOyG5l1scS/n
   y4/bQ5oAZiF1RNx6IDt3Vxa/d+YwNjxKQeRT2/0G4NMO7hkiOrULgBVLe
   TdPQZ651lQ6PAxM66IoyMYH+bM3FgEKY/0/78Q8gTRqApo1sYeJOcgRX+
   HwwDM+R5B80kUzZ6eByVML6xAFTqkDVzhNbsnDT0SmTqzI7nkgfWnRryZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="372633137"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="372633137"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 14:38:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="686881800"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 14:38:00 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oDYRA-001OZv-0f;
        Tue, 19 Jul 2022 00:37:56 +0300
Date:   Tue, 19 Jul 2022 00:37:55 +0300
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
Subject: Re: [PATCH 08/16] smp: optimize smp_call_function_many_cond() for
 more
Message-ID: <YtXSs9HNGZ/WZEXd@smile.fi.intel.com>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-9-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718192844.1805158-9-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:28:36PM -0700, Yury Norov wrote:
> smp_call_function_many_cond() is often passed with cpu_online_mask.
> If it's the case, we can use cpumask_copy instead of cpumask_and, which
> is faster.
> 
> Caught with CONFIG_DEBUG_BITMAP:
> [    7.830337] Call trace:
> [    7.830397]  __bitmap_check_params+0x1d8/0x260
> [    7.830499]  smp_call_function_many_cond+0x1e8/0x45c
> [    7.830607]  kick_all_cpus_sync+0x44/0x80
> [    7.830698]  bpf_int_jit_compile+0x34c/0x5cc
> [    7.830796]  bpf_prog_select_runtime+0x118/0x190
> [    7.830900]  bpf_prepare_filter+0x3dc/0x51c
> [    7.830995]  __get_filter+0xd4/0x170
> [    7.831145]  sk_attach_filter+0x18/0xb0
> [    7.831236]  sock_setsockopt+0x5b0/0x1214
> [    7.831330]  __sys_setsockopt+0x144/0x170
> [    7.831431]  __arm64_sys_setsockopt+0x2c/0x40
> [    7.831541]  invoke_syscall+0x48/0x114
> [    7.831634]  el0_svc_common.constprop.0+0x44/0xfc
> [    7.831745]  do_el0_svc+0x30/0xc0
> [    7.831825]  el0_svc+0x2c/0x84
> [    7.831899]  el0t_64_sync_handler+0xbc/0x140
> [    7.831999]  el0t_64_sync+0x18c/0x190
> [    7.832086] ---[ end trace 0000000000000000 ]---
> [    7.832375] b1:		ffff24d1ffd98a48
> [    7.832385] b2:		ffffa65533a29a38
> [    7.832393] b3:		ffffa65533a29a38
> [    7.832400] nbits:	256
> [    7.832407] start:	0
> [    7.832412] off:	0
> [    7.832418] smp: Bitmap: parameters check failed
> [    7.832432] smp: include/linux/bitmap.h [363]: bitmap_and

Same for long commit message noise.

-- 
With Best Regards,
Andy Shevchenko



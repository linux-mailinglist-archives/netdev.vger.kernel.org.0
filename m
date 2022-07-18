Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381B6578C6D
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiGRVGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236278AbiGRVGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:06:39 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073BB3192A;
        Mon, 18 Jul 2022 14:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658178399; x=1689714399;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AZnZ+ju1Gy0QlCJrVsdsFb6+tvlthvRhSGGs0i/zWLc=;
  b=iy0EAzg920HSJ8VBl0FZbYZepMGryLiZBiJZ8Fv3rK3hOFnjZ+KVjnqb
   yyPqvo0320J5bg5P8S42waWafcpi1VR8DbRTVWpsBnQwevUf9gQaKF1Ej
   8byGnPPLm2WQLw7ij2aQ7z37dR6JyjQMoqcqI3OxpeP+ZnDnEhnw7+8qI
   yNy+ANma9vkVxvCeXd9kEJCsQXy4ZBgLGTAMZlNynfA/AKC65gOM6TYpK
   iaMdN8LP73H7pNckLA5F4TOR/IHKL9DLK2ip7+rMgMY/hLiXx9rK7vBuX
   DB4WMBrcvL8wcEFQtg/fAYQTKBZwf9UJNwhozzBjWpKQ2H790BxSxtIHZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="312007385"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="312007385"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 14:06:38 -0700
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="700173485"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 14:06:29 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oDXwe-001OYR-1W;
        Tue, 19 Jul 2022 00:06:24 +0300
Date:   Tue, 19 Jul 2022 00:06:24 +0300
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
Subject: Re: [PATCH 02/16] lib/bitmap: don't call bitmap_set() with len == 0
Message-ID: <YtXLUHQKIpMjoJna@smile.fi.intel.com>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-3-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718192844.1805158-3-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:28:30PM -0700, Yury Norov wrote:
> bitmap_parselist() format allows passing 0-length regions, but because
> len == 0 is not covered by small_const_nbits() macro, we have to call
> __bitmap_set() and do some prologue calculations just for nothing.

...

>  static void bitmap_set_region(const struct region *r, unsigned long *bitmap)
>  {
> -	unsigned int start;
> +	unsigned int start, len;
>  
> -	for (start = r->start; start <= r->end; start += r->group_len)
> -		bitmap_set(bitmap, start, min(r->end - start + 1, r->off));
> +	for (start = r->start; start <= r->end; start += r->group_len) {
> +		len = min(r->end - start + 1, r->off);
> +		if (len > 0)
> +			bitmap_set(bitmap, start, len);

Maybe I'm missing something, but how small_const_nbits() can possible be useful
here? I mean in which cases the compiler would be able to prove that len is a
const with < sizeof(unsigned long) bits?

> +	}
>  }

-- 
With Best Regards,
Andy Shevchenko



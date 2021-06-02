Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4EE398D99
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhFBPBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhFBPBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 11:01:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B95E7613B4;
        Wed,  2 Jun 2021 14:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622645976;
        bh=lULBTNw8ShimVVrtBYDbb5vhV5dQ9U6lx3o98b0hW5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQiBvXalcmFDhP4VUJkLfFfjUL+AdCowcIIHtwCBDEqTOBmz1OdBU6rrODvuN+9rD
         mOLZKyuSS6i9EOd55gn+hVr2qB4URf3FK/46utTh8Mh1nd3yfAS9gC2T8qY5RT3IQY
         b4rlXGea5BqIi+sm9FltOrrnryu0LA5VhApDTgyH63PLiPiZ2y0qibL1ECCDe/bn4n
         SELGuhZLGN0WPbHVxREPrkTVpEWesEuUbZ+F7OzJ3FIIUPCtX92osJVk5KljY297eg
         yycYme0OjJHY2hdQ/MWGMhjJv0YWgp66DxbyRygrcbb6F9I+DfNX1xA1IgwfjJU0xb
         xfBJRIrGQb7lw==
Date:   Wed, 2 Jun 2021 15:59:21 +0100
From:   Will Deacon <will@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
        rcu@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/6] sched: Introduce task_is_running()
Message-ID: <20210602145921.GB31179@willie-the-truck>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.334970485@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602133040.334970485@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:12:27PM +0200, Peter Zijlstra wrote:
> Replace a bunch of 'p->state == TASK_RUNNING' with a new helper:
> task_is_running(p).
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/x86/kernel/process.c |    4 ++--
>  block/blk-mq.c            |    2 +-
>  include/linux/sched.h     |    2 ++
>  kernel/locking/lockdep.c  |    2 +-
>  kernel/rcu/tree_plugin.h  |    2 +-
>  kernel/sched/core.c       |    6 +++---
>  kernel/sched/stats.h      |    2 +-
>  kernel/signal.c           |    2 +-
>  kernel/softirq.c          |    3 +--
>  mm/compaction.c           |    2 +-
>  10 files changed, 14 insertions(+), 13 deletions(-)
> 
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -931,7 +931,7 @@ unsigned long get_wchan(struct task_stru
>  	unsigned long start, bottom, top, sp, fp, ip, ret = 0;
>  	int count = 0;
>  
> -	if (p == current || p->state == TASK_RUNNING)
> +	if (p == current || task_is_running(p))

Looks like this one in get_wchan() has been cargo-culted across most of
arch/ so they'll need fixing up before you rename the struct member.

There's also a weird one in tools/bpf/runqslower/runqslower.bpf.c (!)

Will

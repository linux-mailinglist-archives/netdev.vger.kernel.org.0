Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734F7399049
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhFBQsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhFBQsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:48:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140ABC061574;
        Wed,  2 Jun 2021 09:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7tohifuv5JYW3E7Hk1sVQuIjPI/C8MKSY3MQl5vvB4s=; b=kdu4BwlchYINw3C+EcBocsHDUy
        a91P+WO2n/ztNAZpC4i1gw7tqOKUFzwWu58suQdLAjM2YXFikv/5/oaqPmf99JVYKCNj2WJKpDQ0i
        S0c8GI0OlAIisTgxakan8G10HFtH5HuNw7Hqdqi3RHiYYq3zdmBzXy5lsDnRzF3TJVEtdO68TnpgS
        8K25eJH4v8dAAo7rswaiwcEE8nXrQyqHEIrzfWlp7ORDwYUd2bEDZxmNSuwBFuW4xEFDNeWs3Yg6U
        o+Kb0+cIMahvxPwVt/nlQwL5AtLXT/J6J+qePZba4xfUkA84xt+DhB39swRCy3609n/Mv+E85Mgmt
        FcuTDgEw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1loU0X-00BKKW-No; Wed, 02 Jun 2021 16:46:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A7E12300299;
        Wed,  2 Jun 2021 18:46:16 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8A73D2016D6DD; Wed,  2 Jun 2021 18:46:16 +0200 (CEST)
Date:   Wed, 2 Jun 2021 18:46:16 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Will Deacon <will@kernel.org>
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
Message-ID: <YLe12Ba4CrvhMhFI@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.334970485@infradead.org>
 <20210602145921.GB31179@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602145921.GB31179@willie-the-truck>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:59:21PM +0100, Will Deacon wrote:
> On Wed, Jun 02, 2021 at 03:12:27PM +0200, Peter Zijlstra wrote:
> > Replace a bunch of 'p->state == TASK_RUNNING' with a new helper:
> > task_is_running(p).
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  arch/x86/kernel/process.c |    4 ++--
> >  block/blk-mq.c            |    2 +-
> >  include/linux/sched.h     |    2 ++
> >  kernel/locking/lockdep.c  |    2 +-
> >  kernel/rcu/tree_plugin.h  |    2 +-
> >  kernel/sched/core.c       |    6 +++---
> >  kernel/sched/stats.h      |    2 +-
> >  kernel/signal.c           |    2 +-
> >  kernel/softirq.c          |    3 +--
> >  mm/compaction.c           |    2 +-
> >  10 files changed, 14 insertions(+), 13 deletions(-)
> > 
> > --- a/arch/x86/kernel/process.c
> > +++ b/arch/x86/kernel/process.c
> > @@ -931,7 +931,7 @@ unsigned long get_wchan(struct task_stru
> >  	unsigned long start, bottom, top, sp, fp, ip, ret = 0;
> >  	int count = 0;
> >  
> > -	if (p == current || p->state == TASK_RUNNING)
> > +	if (p == current || task_is_running(p))
> 
> Looks like this one in get_wchan() has been cargo-culted across most of
> arch/ so they'll need fixing up before you rename the struct member.

Yeah, this was x86_64 allmodconfig driven, I've already got a bunch of
robot mail telling me other archs need help, I'll fix it iup.

> There's also a weird one in tools/bpf/runqslower/runqslower.bpf.c (!)

I'm tempted to let the bpf people sort their own gunk. This is not an
ABI. I so don't care breaking every script out there.

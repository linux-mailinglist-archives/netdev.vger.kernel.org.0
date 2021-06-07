Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255D539DAD1
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhFGLMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhFGLMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:12:46 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60354C061766;
        Mon,  7 Jun 2021 04:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NLj4NYDQW6SbenCIcbS9QrwkO4aohp/HPEuCGPuaREs=; b=cPnEKquwt970ZOfmptV8ZPqMgA
        nDKIN3sS9ih9nuu8IzgPQnkE+3vwyvAnDc2ZrMU9wmERzTb3IGMYGi4WE6+4lUgqF2JtL/lM/I5kJ
        eiHF9IMB2d+Y9lTFFFVOwPJJI9S76oa/nkFLOGjGCPqHZTpDXHEuTaeqYbLfHC8bQodhRsFoh+Qy8
        dTHV3vTaUZfqdQXrfYxuM6d63mJeyrNKoQ2Zm8n4XPuwlvYtbjKQlZwLanaf8FCczQxwMbK2aY9KZ
        5ZBbcHBMtWS/MR3PhHmCJk3dhHVW0UT+bEq4donFnJVNzTVZUBUUF9jUBREUKuzW6aCVhr/V5xCxL
        LVjMXPEw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lqD9Y-004Mvp-0K; Mon, 07 Jun 2021 11:10:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C9BD33002A6;
        Mon,  7 Jun 2021 13:10:49 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A8BB82CF3852B; Mon,  7 Jun 2021 13:10:49 +0200 (CEST)
Date:   Mon, 7 Jun 2021 13:10:49 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Daniel Thompson <daniel.thompson@linaro.org>
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
        Douglas Anderson <dianders@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
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
Subject: Re: [PATCH 6/6] sched: Change task_struct::state
Message-ID: <YL3+ucpG/LOcO35G@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.587042016@infradead.org>
 <20210607104500.sopvslejuoxwzhrs@maple.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607104500.sopvslejuoxwzhrs@maple.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 11:45:00AM +0100, Daniel Thompson wrote:
> On Wed, Jun 02, 2021 at 03:12:31PM +0200, Peter Zijlstra wrote:
> > Change the type and name of task_struct::state. Drop the volatile and
> > shrink it to an 'unsigned int'. Rename it in order to find all uses
> > such that we can use READ_ONCE/WRITE_ONCE as appropriate.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  ...
> >  kernel/debug/kdb/kdb_support.c |   18 +++++++------
> >  ...
> > --- a/kernel/debug/kdb/kdb_support.c
> > +++ b/kernel/debug/kdb/kdb_support.c
> > @@ -609,23 +609,25 @@ unsigned long kdb_task_state_string(cons
> >   */
> >  char kdb_task_state_char (const struct task_struct *p)
> >  {
> > -	int cpu;
> > -	char state;
> > +	unsigned int p_state;
> >  	unsigned long tmp;
> > +	char state;
> > +	int cpu;
> >  
> >  	if (!p ||
> >  	    copy_from_kernel_nofault(&tmp, (char *)p, sizeof(unsigned long)))
> >  		return 'E';
> >  
> >  	cpu = kdb_process_cpu(p);
> > -	state = (p->state == 0) ? 'R' :
> > -		(p->state < 0) ? 'U' :
> > -		(p->state & TASK_UNINTERRUPTIBLE) ? 'D' :
> > -		(p->state & TASK_STOPPED) ? 'T' :
> > -		(p->state & TASK_TRACED) ? 'C' :
> > +	p_state = READ_ONCE(p->__state);
> > +	state = (p_state == 0) ? 'R' :
> > +		(p_state < 0) ? 'U' :
> 
> Looks like the U here stands for Unreachable since this patch makes it
> more obvious that this clause is (and previously was) exactly that!
> 
> Dropping the U state would be good since I guess this will show up as a
> "new" warning in some tools. However it was a preexisting problem so with
> or without this cleaned up:
> Acked-by: Daniel Thompson <daniel.thompson@linaro.org>

Thanks!

Note that there's a second instance of this exact code in
arch/powerpc/xmon/xmon.c, with the same 'U' issue.

I'll repost this soon, as it seems I've fixed all robot failout (fingers
crossed).

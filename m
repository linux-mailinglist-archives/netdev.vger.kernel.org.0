Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5AA398BDC
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 16:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhFBOKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:10:42 -0400
Received: from mail.efficios.com ([167.114.26.124]:37898 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbhFBOIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 10:08:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 03FAA302C40;
        Wed,  2 Jun 2021 10:07:03 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 3QMH2CT0qLws; Wed,  2 Jun 2021 10:06:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 79BFA302868;
        Wed,  2 Jun 2021 10:06:58 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 79BFA302868
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1622642818;
        bh=GwH0GdcKUFmXjwdSc5PC6qayNfPYEbeSfo7iFd8LGlc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=IzY7rj9bG67qO5MhQCvNkTZ6NmKLl+j7CGAPSRZx3M3VXN4GE9cW/xiqKbb0lMrag
         set1cTsKpmrC3scRLhvadBwRFL0ucET03FgN+RYhAetywU7SMjz4Jzot43Al7b42/w
         wRf/j9ODOuM7qSvP03brlcfNA9m+dmMrwW5plmJFJwkQAs2hFyj/Dx0kstoADKFw0s
         PShGdCuiX9KikFibuSZcET8LNklvf4YN8WFNh0QHjOaoJ5JxioNYTizyl5WrJqstOz
         gIo6cZK3qsMar7jMzCrxaFOM5us8879gVttQyPgo4y+VuhrGp7sB3x4o9l+rwPGYzG
         yQHn8ljzHTpmw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6Uyf8mgW0DhK; Wed,  2 Jun 2021 10:06:58 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 548823029F3;
        Wed,  2 Jun 2021 10:06:58 -0400 (EDT)
Date:   Wed, 2 Jun 2021 10:06:58 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, bristot <bristot@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86 <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        dm-devel <dm-devel@redhat.com>,
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
        acme <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        paulmck <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cgroups <cgroups@vger.kernel.org>,
        kgdb-bugreport <kgdb-bugreport@lists.sourceforge.net>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, rcu <rcu@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, KVM list <kvm@vger.kernel.org>
Message-ID: <896642516.5866.1622642818225.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210602133040.587042016@infradead.org>
References: <20210602131225.336600299@infradead.org> <20210602133040.587042016@infradead.org>
Subject: Re: [PATCH 6/6] sched: Change task_struct::state
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: sched: Change task_struct::state
Thread-Index: DzXPoSkxk24gPNa4OEu5k5Jl7651YA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:

> Change the type and name of task_struct::state. Drop the volatile and
> shrink it to an 'unsigned int'. Rename it in order to find all uses
> such that we can use READ_ONCE/WRITE_ONCE as appropriate.
> 
[...]
> 
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c

[...]
> @@ -1559,7 +1560,8 @@ static int fill_psinfo(struct elf_prpsin
> 	psinfo->pr_pgrp = task_pgrp_vnr(p);
> 	psinfo->pr_sid = task_session_vnr(p);
> 
> -	i = p->state ? ffz(~p->state) + 1 : 0;
> +	state = READ_ONCE(p->__state);
> +	i = state ? ffz(~state) + 1 : 0;
> 	psinfo->pr_state = i;
> 	psinfo->pr_sname = (i > 5) ? '.' : "RSDTZW"[i];
> 	psinfo->pr_zomb = psinfo->pr_sname == 'Z';

[...]

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -113,13 +113,13 @@ struct task_group;
> 					 __TASK_TRACED | EXIT_DEAD | EXIT_ZOMBIE | \
> 					 TASK_PARKED)
> 
> -#define task_is_running(task)		(READ_ONCE((task)->state) == TASK_RUNNING)
> +#define task_is_running(task)		(READ_ONCE((task)->__state) == TASK_RUNNING)
> 
> -#define task_is_traced(task)		((task->state & __TASK_TRACED) != 0)
> +#define task_is_traced(task)		((READ_ONCE(task->__state) & __TASK_TRACED) != 0)
> 
> -#define task_is_stopped(task)		((task->state & __TASK_STOPPED) != 0)
> +#define task_is_stopped(task)		((READ_ONCE(task->__state) & __TASK_STOPPED) !=
> 0)
> 
> -#define task_is_stopped_or_traced(task)	((task->state & (__TASK_STOPPED |
> __TASK_TRACED)) != 0)
> +#define task_is_stopped_or_traced(task)	((READ_ONCE(task->__state) &
> (__TASK_STOPPED | __TASK_TRACED)) != 0)
> 
> #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
> 
> @@ -134,14 +134,14 @@ struct task_group;
> 	do {							\
> 		WARN_ON_ONCE(is_special_task_state(state_value));\
> 		current->task_state_change = _THIS_IP_;		\
> -		current->state = (state_value);			\
> +		WRITE_ONCE(current->__state, (state_value));	\
> 	} while (0)

Why not introduce set_task_state(p) and get_task_state(p) rather than sprinkle
READ_ONCE() and WRITE_ONCE() all over the kernel ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

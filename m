Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84574398B43
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhFBOA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:00:56 -0400
Received: from mail.efficios.com ([167.114.26.124]:35170 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhFBOAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 10:00:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id BC760302ADD;
        Wed,  2 Jun 2021 09:59:08 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 0NlAF8aaNhCD; Wed,  2 Jun 2021 09:59:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 2A108302BA9;
        Wed,  2 Jun 2021 09:59:08 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 2A108302BA9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1622642348;
        bh=3NQkpeJ7B+hKtKJgR6oI37w8WcTETaBafQ5/DPMEWwI=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=ZlLvrNpb7FSQdBC5tIEKb93seCOYMQlGgXqNDCt4mx931pzNw8PkQPGTIAknvIKON
         NpDSBJXZebM5bdDBEXJUhkVKv214RxCfD9cnMAu+E9jlJUbxCT0sSH9pfYpV4sduq4
         x3/Ha4HOzhfJ5u6uVpyJg0D3SZEpnzu++L3CaXS5k4TUIGuZ+VTcOcX9C3+gYxGHL4
         vP87muDZtj763iw70P68DkCsJf/o77PvwVPhmezDZ6qbVfVNe7D4w95pMohMEmylCc
         wLPLpR4HOsL54+3PlAjOEK3N1Uw5WtMxdLnoo8ef/7RMfiFuOK3kBtQodyzCCa6QyK
         u+WAXvtkoLOCw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6rM4q68lPaCz; Wed,  2 Jun 2021 09:59:08 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 00C463028D6;
        Wed,  2 Jun 2021 09:59:08 -0400 (EDT)
Date:   Wed, 2 Jun 2021 09:59:07 -0400 (EDT)
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
        linux-block@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cgroups <cgroups@vger.kernel.org>,
        kgdb-bugreport@lists.sourceforge.net,
        linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
        rcu <rcu@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        KVM list <kvm@vger.kernel.org>
Message-ID: <1873020549.5854.1622642347895.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210602133040.398289363@infradead.org>
References: <20210602131225.336600299@infradead.org> <20210602133040.398289363@infradead.org>
Subject: Re: [PATCH 3/6] sched,perf,kvm: Fix preemption condition
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: sched,perf,kvm: Fix preemption condition
Thread-Index: r+iuleOU2QevO+uazLhH122pXkMx7g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:

> When ran from the sched-out path (preempt_notifier or perf_event),
> p->state is irrelevant to determine preemption. You can get preempted
> with !task_is_running() just fine.
> 
> The right indicator for preemption is if the task is still on the
> runqueue in the sched-out path.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
> kernel/events/core.c |    7 +++----
> virt/kvm/kvm_main.c  |    2 +-
> 2 files changed, 4 insertions(+), 5 deletions(-)
> 
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -8568,13 +8568,12 @@ static void perf_event_switch(struct tas
> 		},
> 	};
> 
> -	if (!sched_in && task->state == TASK_RUNNING)
> +	if (!sched_in && current->on_rq) {

This changes from checking task->state to current->on_rq, but this change
from "task" to "current" is not described in the commit message, which is odd.

Are we really sure that task == current here ?

Thanks,

Mathieu

> 		switch_event.event_id.header.misc |=
> 				PERF_RECORD_MISC_SWITCH_OUT_PREEMPT;
> +	}
> 
> -	perf_iterate_sb(perf_event_switch_output,
> -		       &switch_event,
> -		       NULL);
> +	perf_iterate_sb(perf_event_switch_output, &switch_event, NULL);
> }
> 
> /*
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4869,7 +4869,7 @@ static void kvm_sched_out(struct preempt
> {
> 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
> 
> -	if (current->state == TASK_RUNNING) {
> +	if (current->on_rq) {
> 		WRITE_ONCE(vcpu->preempted, true);
> 		WRITE_ONCE(vcpu->ready, true);
>  	}

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

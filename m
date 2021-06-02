Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCB8398C88
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 16:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhFBOTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:19:32 -0400
Received: from mail.efficios.com ([167.114.26.124]:40610 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbhFBORB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 10:17:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 2C430302C5A;
        Wed,  2 Jun 2021 10:15:17 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id MFUulvWoU4e4; Wed,  2 Jun 2021 10:15:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 935A5302C57;
        Wed,  2 Jun 2021 10:15:16 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 935A5302C57
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1622643316;
        bh=wTS/crR/26N4BDTiNFNNZoqsETfUenagK9Jc/umukAM=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=HjuuxeCx/W0ucWdgkdPe4Ltmueov6LEz9QoWVQ9n275sUH5V2BfBx2uLemee8nOgV
         iEPOUdYsPm3Mmmkxyd2M/xe2NzuiK0lte25kNJqF/D6aBdMudEsd6+/AvYnVI3XvQB
         I3eKlxdMnA/4sIrtiEyziYHBHFsURA8x1tU1usHbZhQ+Nqw4zpB4HKNzuSQ6QLswXS
         8VevSWMXfGVlYdJrwg5WBPwEe4w0fAdx0pE768+FRtKKL3etA75RfRjkypdxFoVZY5
         KUm3EJy+oFxv1WaIjL0MV00CLSuspl8VcSBxV1CpXr+Or5zRpRWJvt+/OT6gN/Sqjt
         hvtczOpS4cKPQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id toHMU-3uXU92; Wed,  2 Jun 2021 10:15:16 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 702A6302A65;
        Wed,  2 Jun 2021 10:15:16 -0400 (EDT)
Date:   Wed, 2 Jun 2021 10:15:16 -0400 (EDT)
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
Message-ID: <1524365960.5868.1622643316351.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210602133040.398289363@infradead.org>
References: <20210602131225.336600299@infradead.org> <20210602133040.398289363@infradead.org>
Subject: Re: [PATCH 3/6] sched,perf,kvm: Fix preemption condition
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: sched,perf,kvm: Fix preemption condition
Thread-Index: NELkknquBPwUAC7hR8bH+DhrqDwz1A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:
[...]
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -8568,13 +8568,12 @@ static void perf_event_switch(struct tas
> 		},
> 	};
> 
> -	if (!sched_in && task->state == TASK_RUNNING)
> +	if (!sched_in && current->on_rq) {
> 		switch_event.event_id.header.misc |=
> 				PERF_RECORD_MISC_SWITCH_OUT_PREEMPT;
> +	}
> 
> -	perf_iterate_sb(perf_event_switch_output,
> -		       &switch_event,
> -		       NULL);
> +	perf_iterate_sb(perf_event_switch_output, &switch_event, NULL);
> }

There is a lot of code cleanup going on here which does not seem to belong
to a "Fix" patch.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

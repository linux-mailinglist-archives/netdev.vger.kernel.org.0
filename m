Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DCF398B50
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 16:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhFBODU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:03:20 -0400
Received: from mail.efficios.com ([167.114.26.124]:36030 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFBODO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 10:03:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 7AB6F302B32;
        Wed,  2 Jun 2021 10:01:30 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id sk-FLnSPp3e6; Wed,  2 Jun 2021 10:01:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 72BA4302C27;
        Wed,  2 Jun 2021 10:01:29 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 72BA4302C27
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1622642489;
        bh=ildkMTk0vYSZK39yeI6C0NluRoGntZ1yA5EuqMA4g8k=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=L/w8o2fJN3kmP73a2vMCtFWwO5YPeIOe9ZmTydEyFWmyEaOlcyFybIdRWoe8hmy34
         bHqWF5FDpTTdDr9jNR/6ossgQUg8/lo1uSvmOEMQI+8PvcMWXQjFHlESOaJErckXTB
         oIuIBEBiJQ9FvKa8qYSLXZLHpWnciBfTelSzOSmbORnUr52zBvJXfWQpx94UqNlbmY
         Y6yF4/4xX5ToklNVtEYeJ+rmH/TXxAzWx0JJ6vQD3FMua0nJmkIgpXS7yGiTDiDM65
         T6y687zdG38LDyLZ4Slpb06ysgcGN+OXRe4bfPmRBCeqmhnbNwAWPu5258Lpn1Ta7C
         10t9Cfwl8X+bQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id PBfpDWQ1MDaF; Wed,  2 Jun 2021 10:01:29 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 44D173029E9;
        Wed,  2 Jun 2021 10:01:29 -0400 (EDT)
Date:   Wed, 2 Jun 2021 10:01:29 -0400 (EDT)
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
Message-ID: <1731339790.5856.1622642489232.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210602133040.461908001@infradead.org>
References: <20210602131225.336600299@infradead.org> <20210602133040.461908001@infradead.org>
Subject: Re: [PATCH 4/6] sched: Add get_current_state()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: sched: Add get_current_state()
Thread-Index: E1ntXBdpTHBBRaSFxkm2wa7EtTrnhg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:

> Remove yet another few p->state accesses.

[...]

> 
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -212,6 +212,8 @@ struct task_group;
> 
> #endif
> 
> +#define get_current_state()	READ_ONCE(current->state)

Why use a macro rather than a static inline here ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

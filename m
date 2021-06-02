Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC0A398DC4
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhFBPER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232054AbhFBPEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 11:04:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 407C1613BF;
        Wed,  2 Jun 2021 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622646144;
        bh=iqy0WVYDEpl3OEqiwYR2vHlixZDZNAuGOuMgnWDXeR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O+pqG+GrEcw9WVS8/OW/fQfSxSijYrBV2XZxysaVScijAUnd0cVcWSF4nom6VYF7/
         Xyj4yQuXkrrTuHJnUpufQZyClixRruRrV6dddsrZRqOQc+UgpG4vsSCBUy91HBwhfj
         S4qt9rHniezYWqyJmpYVr3rEugD00r4pGxG9asyrSW0y4cnvEcyeHwtxVwtOD0WKZZ
         CxVeWNbOBJkHO0H7W+0s6rOxAZoTcR6qnwXcmM/nQ5icf4zBj8IsluJAeqSZ9roUcx
         S4+extTRu1FhJzpL0fTK8fMnTglu0lQMSa9EV3Tq/LcFiaa96LORrcAJlT/uJ7FgCX
         ZTIEp+h3YHIzg==
Date:   Wed, 2 Jun 2021 16:02:11 +0100
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
Subject: Re: [PATCH 4/6] sched: Add get_current_state()
Message-ID: <20210602150211.GC31179@willie-the-truck>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.461908001@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602133040.461908001@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:12:29PM +0200, Peter Zijlstra wrote:
> Remove yet another few p->state accesses.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  block/blk-mq.c        |    2 +-
>  include/linux/sched.h |    2 ++
>  kernel/freezer.c      |    2 +-
>  kernel/sched/core.c   |    6 +++---
>  4 files changed, 7 insertions(+), 5 deletions(-)

I think you can include kernel/kcsan/report.c here too.

With that:

Acked-by: Will Deacon <will@kernel.org>

Will

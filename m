Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8606D398E02
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhFBPMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230456AbhFBPML (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 11:12:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73C1A61182;
        Wed,  2 Jun 2021 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622646628;
        bh=MmmB5edNPbRN/+c+2On4lV0BgwteW7Cw405ip5Z8YuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eoW8oxXoywj95HF19beDzh3Wa+WhWkiyj9FjvvSEw7ScJ8OuGQbEy6+2TGjP0xVYN
         XSSJAJXvhI5MOj1+GRdHIbg46k9rJSpJMlo/HDJefXpEwJPCDFcYn8COIR/VQO5DZl
         47yzM30C6QaWLqEpy6LeVNCLBHEk+aKjfkrC6CQ5ViDR3bMQ0fCKMIt+zFjJNZMY+v
         SNl2CwOo9QKvwQF6AUEFLQH9ccSyIziiULTl3YApDUWutkiYOLv0+Q04TM9wwWdkfx
         bdsysjlbcoFBsmj9C1l84fr+oHwMhBsnHonyI6jC2MFd17CoX0BlIS16/UkYyFRS6U
         MochfZ+/mAepQ==
Date:   Wed, 2 Jun 2021 16:10:11 +0100
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
Subject: Re: [PATCH 6/6] sched: Change task_struct::state
Message-ID: <20210602151010.GE31179@willie-the-truck>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.587042016@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602133040.587042016@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:12:31PM +0200, Peter Zijlstra wrote:
> Change the type and name of task_struct::state. Drop the volatile and
> shrink it to an 'unsigned int'. Rename it in order to find all uses
> such that we can use READ_ONCE/WRITE_ONCE as appropriate.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  block/blk-mq.c                 |    2 -
>  drivers/md/dm.c                |    6 ++--
>  fs/binfmt_elf.c                |    8 +++---
>  fs/userfaultfd.c               |    4 +--
>  include/linux/sched.h          |   31 +++++++++++------------
>  include/linux/sched/debug.h    |    2 -
>  include/linux/sched/signal.h   |    2 -
>  init/init_task.c               |    2 -
>  kernel/cgroup/cgroup-v1.c      |    2 -
>  kernel/debug/kdb/kdb_support.c |   18 +++++++------
>  kernel/fork.c                  |    4 +--
>  kernel/hung_task.c             |    2 -
>  kernel/kthread.c               |    4 +--
>  kernel/locking/mutex.c         |    6 ++--
>  kernel/locking/rtmutex.c       |    4 +--
>  kernel/locking/rwsem.c         |    2 -
>  kernel/ptrace.c                |   12 ++++-----
>  kernel/rcu/rcutorture.c        |    4 +--
>  kernel/rcu/tree_stall.h        |   12 ++++-----
>  kernel/sched/core.c            |   53 +++++++++++++++++++++--------------------
>  kernel/sched/deadline.c        |   10 +++----
>  kernel/sched/fair.c            |   11 +++++---
>  lib/syscall.c                  |    4 +--
>  net/core/dev.c                 |    2 -
>  24 files changed, 108 insertions(+), 99 deletions(-)

I think this makes the code a _lot_ easier to understand, so:

Acked-by: Will Deacon <will@kernel.org>

on the assumption that you'll fix get_wchan() for !x86 as well.

Cheers,

Will

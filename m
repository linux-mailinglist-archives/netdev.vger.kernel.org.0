Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 346626763D
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 23:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfGLVgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 17:36:04 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40866 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbfGLVgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 17:36:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so5085937pgj.7
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 14:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f1OhDpjzDD7S0+COFpFd965N8mxlYpQZP4b4JR0VTV8=;
        b=lZCvyn5n8owKQ3JyeYzt9+z6iXWkLSpYG3eAl8ccauBAjpAsmohxfuQbcSnqrAuKVo
         EhJuv2vWWbTPd0eO0fNUhuM6JbViOUOUf/4BwXkUGXtZsJcQX4/U66ACGCFiWUk//WdV
         Q8H3IUlKRvwTyqp0yyd7gnCEfVZU4qo6+E1Lc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f1OhDpjzDD7S0+COFpFd965N8mxlYpQZP4b4JR0VTV8=;
        b=j67cJmuTEyePRDr5AYM2/3JlDjV3hSO9NFySkEr7dbCFgpkB2QluLJU11aOUEy7ENC
         IDEQiQf255axWpWkn8H54+F9GuOqYK/OuK3eRtnSYIAhxQH5x/jd9d0zc5OXJ40fB3ea
         uVcYKSu4fajeO8gzxcNRI7O92zbUBYyhDQCj1hylhybdMI44BUTQOqiLqBTUiLvGzdcH
         x2xhowqSlN+eNpl0+gEiZmWod/QLPjJALWxapk3YTBAcmyJdb7mcihT2usN6Ss2uAF8c
         np29kDyYBg75BSLGo4XSWPWyCoQttzOGogMsyzEjSz4FxXgUS7sBs7xqDmzP9Qb+pKwu
         lxrw==
X-Gm-Message-State: APjAAAWEeneCoIgYVlw3OsUHwodk72O6NxinCqqKxlgUcUBzFSnr8vGw
        dUIh8ao77LULhyrGRz09vBI=
X-Google-Smtp-Source: APXvYqx3LWL3QaQQ5ksHJJX+2CaAAhVLBJ5JupxNkJ3WyB6ER0uWKW+WGxkHpK2VFCITfOz69qvV7g==
X-Received: by 2002:a63:fb4b:: with SMTP id w11mr13352876pgj.415.1562967362076;
        Fri, 12 Jul 2019 14:36:02 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id o32sm9047532pje.9.2019.07.12.14.36.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 14:36:01 -0700 (PDT)
Date:   Fri, 12 Jul 2019 17:35:59 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v2 3/9] rcu/sync: Remove custom check for reader-section
Message-ID: <20190712213559.GA175138@google.com>
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-4-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712170024.111093-4-joel@joelfernandes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 01:00:18PM -0400, Joel Fernandes (Google) wrote:
> The rcu/sync code was doing its own check whether we are in a reader
> section. With RCU consolidating flavors and the generic helper added in
> this series, this is no longer need. We can just use the generic helper
> and it results in a nice cleanup.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Hi Oleg,
Slightly unrelated to the patch,
I tried hard to understand this comment below in percpu_down_read() but no dice.

I do understand how rcu sync and percpu rwsem works, however the comment
below didn't make much sense to me. For one, there's no readers_fast anymore
so I did not follow what readers_fast means. Could the comment be updated to
reflect latest changes?
Also could you help understand how is a writer not able to change
sem->state and count the per-cpu read counters at the same time as the
comment tries to say?

	/*
	 * We are in an RCU-sched read-side critical section, so the writer
	 * cannot both change sem->state from readers_fast and start checking
	 * counters while we are here. So if we see !sem->state, we know that
	 * the writer won't be checking until we're past the preempt_enable()
	 * and that once the synchronize_rcu() is done, the writer will see
	 * anything we did within this RCU-sched read-size critical section.
	 */

Also,
I guess we could get rid of all of the gp_ops struct stuff now that since all
the callbacks are the same now. I will post that as a follow-up patch to this
series.

thanks!

 - Joel


> ---
> Please note: Only build and boot tested this particular patch so far.
> 
>  include/linux/rcu_sync.h |  5 ++---
>  kernel/rcu/sync.c        | 22 ----------------------
>  2 files changed, 2 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> index 6fc53a1345b3..c954f1efc919 100644
> --- a/include/linux/rcu_sync.h
> +++ b/include/linux/rcu_sync.h
> @@ -39,9 +39,8 @@ extern void rcu_sync_lockdep_assert(struct rcu_sync *);
>   */
>  static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
>  {
> -#ifdef CONFIG_PROVE_RCU
> -	rcu_sync_lockdep_assert(rsp);
> -#endif
> +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
> +			 "suspicious rcu_sync_is_idle() usage");
>  	return !rsp->gp_state; /* GP_IDLE */
>  }
>  
> diff --git a/kernel/rcu/sync.c b/kernel/rcu/sync.c
> index a8304d90573f..535e02601f56 100644
> --- a/kernel/rcu/sync.c
> +++ b/kernel/rcu/sync.c
> @@ -10,37 +10,25 @@
>  #include <linux/rcu_sync.h>
>  #include <linux/sched.h>
>  
> -#ifdef CONFIG_PROVE_RCU
> -#define __INIT_HELD(func)	.held = func,
> -#else
> -#define __INIT_HELD(func)
> -#endif
> -
>  static const struct {
>  	void (*sync)(void);
>  	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
>  	void (*wait)(void);
> -#ifdef CONFIG_PROVE_RCU
> -	int  (*held)(void);
> -#endif
>  } gp_ops[] = {
>  	[RCU_SYNC] = {
>  		.sync = synchronize_rcu,
>  		.call = call_rcu,
>  		.wait = rcu_barrier,
> -		__INIT_HELD(rcu_read_lock_held)
>  	},
>  	[RCU_SCHED_SYNC] = {
>  		.sync = synchronize_rcu,
>  		.call = call_rcu,
>  		.wait = rcu_barrier,
> -		__INIT_HELD(rcu_read_lock_sched_held)
>  	},
>  	[RCU_BH_SYNC] = {
>  		.sync = synchronize_rcu,
>  		.call = call_rcu,
>  		.wait = rcu_barrier,
> -		__INIT_HELD(rcu_read_lock_bh_held)
>  	},
>  };
>  
> @@ -49,16 +37,6 @@ enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
>  
>  #define	rss_lock	gp_wait.lock
>  
> -#ifdef CONFIG_PROVE_RCU
> -void rcu_sync_lockdep_assert(struct rcu_sync *rsp)
> -{
> -	RCU_LOCKDEP_WARN(!gp_ops[rsp->gp_type].held(),
> -			 "suspicious rcu_sync_is_idle() usage");
> -}
> -
> -EXPORT_SYMBOL_GPL(rcu_sync_lockdep_assert);
> -#endif
> -
>  /**
>   * rcu_sync_init() - Initialize an rcu_sync structure
>   * @rsp: Pointer to rcu_sync structure to be initialized
> -- 
> 2.22.0.510.g264f2c817a-goog
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B7F18E4C3
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 22:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgCUVVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 17:21:52 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38464 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgCUVVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 17:21:49 -0400
Received: by mail-qk1-f195.google.com with SMTP id h14so11183431qke.5
        for <netdev@vger.kernel.org>; Sat, 21 Mar 2020 14:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PQyvyFjXI63PMGXy8SBC5cS2K83uInabnKI/SkfPNac=;
        b=GrJM1mkH9Twh9MhDThkRNjlO8JFVFIfqgVbHkVArMxygCuz6v0YScBI5cpWg2WyTcX
         i3ADiKfNOPlIWM0NTPthFLfMYDm6VTg0j5oiCRmiRxNy5SAzNBD6ZBzXexv8G/EvzFJH
         rI1J6l8GdJdqcEQfA0ioYtYYvwFmhofpX5N8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PQyvyFjXI63PMGXy8SBC5cS2K83uInabnKI/SkfPNac=;
        b=fEkWW4tCZrL7/F/gur/mws/ET4BJnigCeOv2NKLDrZWF3K+VhDfspti5EgyoU97uus
         WoKO+S6uTbS520+mVKLu7gAiTtlDq7O+oq9gc8mJS6xu91h+MGWxVW44B5XlGHvjWZuB
         OlTn4l88Zg5yxNjyx72N/u9C0ux69uT9tcvL0Z2e0J2CBRaQhqoWjhlmhQG9BiCKawCO
         RA3gTdwGvQ7WugPgxOrH8elKkodjY6XDNkRa4ySA90YKfev24D0gjR50HGp5gtgm76om
         fxbXXZvLa45udPB2SZVrRppnHQaFoC1b+DaTYjvOi0zh8PFql7xaPo565naeBjdF17/D
         pKKg==
X-Gm-Message-State: ANhLgQ1tDue/O+AKd8FrupQKQJNaHLvSLejtFi0A92BY8L0NQPeP6bt0
        G6Ymy66ZoaWQhiGciow7NBRuXA==
X-Google-Smtp-Source: ADFU+vsWIwvhSbl0TRAZIMRGT+Umkk0LHhrP9kNSc5qfdjByg3zU6JAyPlZ7aWyG42y6MWEPys6fpQ==
X-Received: by 2002:a37:27cd:: with SMTP id n196mr15092133qkn.144.1584825706147;
        Sat, 21 Mar 2020 14:21:46 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id x6sm7815736qke.43.2020.03.21.14.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2020 14:21:45 -0700 (PDT)
Date:   Sat, 21 Mar 2020 17:21:44 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 08/15] Documentation: Add lock ordering and nesting
 documentation
Message-ID: <20200321212144.GA6475@google.com>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.211530902@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318204408.211530902@linutronix.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

Just a few comments:

[...]
> +rtmutex
> +=======
> +
> +RT-mutexes are mutexes with support for priority inheritance (PI).
> +
> +PI has limitations on non PREEMPT_RT enabled kernels due to preemption and
> +interrupt disabled sections.
> +
> +On a PREEMPT_RT enabled kernel most of these sections are fully
> +preemptible. This is possible because PREEMPT_RT forces most executions
> +into task context, especially interrupt handlers and soft interrupts, which
> +allows to substitute spinlock_t and rwlock_t with RT-mutex based
> +implementations.
> +
> +
> +raw_spinlock_t and spinlock_t
> +=============================
> +
> +raw_spinlock_t
> +--------------
> +
> +raw_spinlock_t is a strict spinning lock implementation regardless of the
> +kernel configuration including PREEMPT_RT enabled kernels.
> +
> +raw_spinlock_t is to be used only in real critical core code, low level
> +interrupt handling and places where protecting (hardware) state is required
> +to be safe against preemption and eventually interrupts.
> +
> +Another reason to use raw_spinlock_t is when the critical section is tiny
> +to avoid the overhead of spinlock_t on a PREEMPT_RT enabled kernel in the
> +contended case.
> +
> +spinlock_t
> +----------
> +
> +The semantics of spinlock_t change with the state of CONFIG_PREEMPT_RT.
> +
> +On a non PREEMPT_RT enabled kernel spinlock_t is mapped to raw_spinlock_t
> +and has exactly the same semantics.
> +
> +spinlock_t and PREEMPT_RT
> +-------------------------
> +
> +On a PREEMPT_RT enabled kernel spinlock_t is mapped to a separate
> +implementation based on rt_mutex which changes the semantics:
> +
> + - Preemption is not disabled
> +
> + - The hard interrupt related suffixes for spin_lock / spin_unlock
> +   operations (_irq, _irqsave / _irqrestore) do not affect the CPUs
> +   interrupt disabled state
> +
> + - The soft interrupt related suffix (_bh()) is still disabling the
> +   execution of soft interrupts, but contrary to a non PREEMPT_RT enabled
> +   kernel, which utilizes the preemption count, this is achieved by a per
> +   CPU bottom half locking mechanism.
> +
> +All other semantics of spinlock_t are preserved:
> +
> + - Migration of tasks which hold a spinlock_t is prevented. On a non
> +   PREEMPT_RT enabled kernel this is implicit due to preemption disable.
> +   PREEMPT_RT has a separate mechanism to achieve this. This ensures that
> +   pointers to per CPU variables stay valid even if the task is preempted.
> +
> + - Task state preservation. The task state is not affected when a lock is
> +   contended and the task has to schedule out and wait for the lock to
> +   become available. The lock wake up restores the task state unless there
> +   was a regular (not lock related) wake up on the task. This ensures that
> +   the task state rules are always correct independent of the kernel
> +   configuration.
> +
> +rwlock_t
> +========
> +
> +rwlock_t is a multiple readers and single writer lock mechanism.
> +
> +On a non PREEMPT_RT enabled kernel rwlock_t is implemented as a spinning
> +lock and the suffix rules of spinlock_t apply accordingly. The
> +implementation is fair and prevents writer starvation.
>

You mentioned writer starvation, but I think it would be good to also mention
that rwlock_t on a non-PREEMPT_RT kernel also does not have _reader_
starvation problem, since it uses queued implementation.  This fact is worth
mentioning here, since further below you explain that an rwlock in PREEMPT_RT
does have reader starvation problem.

> +rwlock_t and PREEMPT_RT
> +-----------------------
> +
> +On a PREEMPT_RT enabled kernel rwlock_t is mapped to a separate
> +implementation based on rt_mutex which changes the semantics:
> +
> + - Same changes as for spinlock_t
> +
> + - The implementation is not fair and can cause writer starvation under
> +   certain circumstances. The reason for this is that a writer cannot grant
> +   its priority to multiple readers. Readers which are blocked on a writer
> +   fully support the priority inheritance protocol.

Is it hard to give priority to multiple readers because the number of readers
to give priority to could be unbounded?

> +
> +
> +PREEMPT_RT caveats
> +==================
> +
> +spinlock_t and rwlock_t
> +-----------------------
> +
> +The substitution of spinlock_t and rwlock_t on PREEMPT_RT enabled kernels
> +with RT-mutex based implementations has a few implications.
> +
> +On a non PREEMPT_RT enabled kernel the following code construct is
> +perfectly fine::
> +
> +   local_irq_disable();
> +   spin_lock(&lock);
> +
> +and fully equivalent to::
> +
> +   spin_lock_irq(&lock);
> +
> +Same applies to rwlock_t and the _irqsave() suffix variant.
> +
> +On a PREEMPT_RT enabled kernel this breaks because the RT-mutex
> +substitution expects a fully preemptible context.
> +
> +The preferred solution is to use :c:func:`spin_lock_irq()` or
> +:c:func:`spin_lock_irqsave()` and their unlock counterparts.
> +
> +PREEMPT_RT also offers a local_lock mechanism to substitute the
> +local_irq_disable/save() constructs in cases where a separation of the
> +interrupt disabling and the locking is really unavoidable. This should be
> +restricted to very rare cases.

It would also be nice to mention where else local_lock() can be used, such as
protecting per-cpu variables without disabling preemption. Could we add a
section on protecting per-cpu data? (Happy to do that and send a patch if you
prefer).

> +raw_spinlock_t
> +--------------
> +
> +Locking of a raw_spinlock_t disables preemption and eventually interrupts.
> +Therefore code inside the critical region has to be careful to avoid calls
> +into code which takes a regular spinlock_t or rwlock_t. A prime example is
> +memory allocation.
> +
> +On a non PREEMPT_RT enabled kernel the following code construct is
> +perfectly fine code::
> +
> +  raw_spin_lock(&lock);
> +  p = kmalloc(sizeof(*p), GFP_ATOMIC);
> +
> +On a PREEMPT_RT enabled kernel this breaks because the memory allocator is
> +fully preemptible and therefore does not support allocations from truly
> +atomic contexts.
> +
> +Contrary to that the following code construct is perfectly fine on
> +PREEMPT_RT as spin_lock() does not disable preemption::
> +
> +  spin_lock(&lock);
> +  p = kmalloc(sizeof(*p), GFP_ATOMIC);
> +
> +Most places which use GFP_ATOMIC allocations are safe on PREEMPT_RT as the
> +execution is forced into thread context and the lock substitution is
> +ensuring preemptibility.
> +
> +
> +bit spinlocks
> +-------------
> +
> +Bit spinlocks are problematic for PREEMPT_RT as they cannot be easily
> +substituted by an RT-mutex based implementation for obvious reasons.
> +
> +The semantics of bit spinlocks are preserved on a PREEMPT_RT enabled kernel
> +and the caveats vs. raw_spinlock_t apply.
> +
> +Some bit spinlocks are substituted by regular spinlock_t for PREEMPT_RT but
> +this requires conditional (#ifdef'ed) code changes at the usage side while
> +the spinlock_t substitution is simply done by the compiler and the
> +conditionals are restricted to header files and core implementation of the
> +locking primitives and the usage sites do not require any changes.
> +
> +
> +Lock type nesting rules
> +=======================
> +
> +The most basic rules are:
> +
> +  - Lock types of the same lock category (sleeping, spinning) can nest
> +    arbitrarily as long as they respect the general lock ordering rules to
> +    prevent deadlocks.
> +
> +  - Sleeping lock types cannot nest inside spinning lock types.
> +
> +  - Spinning lock types can nest inside sleeping lock types.
> +
> +These rules apply in general independent of CONFIG_PREEMPT_RT.
> +
> +As PREEMPT_RT changes the lock category of spinlock_t and rwlock_t from
> +spinning to sleeping this has obviously restrictions how they can nest with
> +raw_spinlock_t.
> +
> +This results in the following nest ordering:
> +
> +  1) Sleeping locks
> +  2) spinlock_t and rwlock_t
> +  3) raw_spinlock_t and bit spinlocks
> +
> +Lockdep is aware of these constraints to ensure that they are respected.
> +
> +
> +Owner semantics
> +===============
> +
> +Most lock types in the Linux kernel have strict owner semantics, i.e. the
> +context (task) which acquires a lock has to release it.
> +
> +There are two exceptions:
> +
> +  - semaphores
> +  - rwsems
> +
> +semaphores have no strict owner semantics for historical reasons. They are
> +often used for both serialization and waiting purposes. That's generally
> +discouraged and should be replaced by separate serialization and wait
> +mechanisms.
> +
> +rwsems have grown interfaces which allow non owner release for special
> +purposes. This usage is problematic on PREEMPT_RT because PREEMPT_RT
> +substitutes all locking primitives except semaphores with RT-mutex based
> +implementations to provide priority inheritance for all lock types except
> +the truly spinning ones. Priority inheritance on ownerless locks is
> +obviously impossible.
> +
> +For now the rwsem non-owner release excludes code which utilizes it from
> +being used on PREEMPT_RT enabled kernels.

I could not parse the last sentence here, but I think you meant "For now,
PREEMPT_RT enabled kernels disable code that perform a non-owner release of
an rwsem". Correct me if I'm wrong.

Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>

thanks,

 - Joel


> In same cases this can be
> +mitigated by disabling portions of the code, in other cases the complete
> +functionality has to be disabled until a workable solution has been found.
> 

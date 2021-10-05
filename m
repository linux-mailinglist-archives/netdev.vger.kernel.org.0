Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7062F422D83
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbhJEQM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbhJEQM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 12:12:28 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E99C061749;
        Tue,  5 Oct 2021 09:10:37 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id e66-20020a9d2ac8000000b0054da8bdf2aeso24296708otb.12;
        Tue, 05 Oct 2021 09:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mdad5kectEFueATtTuufSb/GlfpWelTpGajeRlov/y0=;
        b=m4W5ZJGJ0PbOuvTFxvFfitu8en7V2cvEr7BMgE+N4Y9+51AAvEAHTRoYL6/zimD3RW
         cPyiWD0GKY9bo+WJLAYJyi77nqT3fy7d1fm8LrdyWlZFVof7LWVRk1ukLwDrXh1fyW2x
         GT+CX9jM6xv54XBIom/2ki2dB3wWKAXEnf5uDELTg6mHhUjHXRg5OTtoP2HWWHS0iiXb
         KT5Y891uL5PVeOi+qHh7U3SAmK1oEWTJsVy9sZMeRTiuiZna09bn/g3ISjuUroGwMR+f
         bCrvkRYh9wAN/O/Wo10aUXF3K44YGnsNH6aoaX6fuouGLj9A1HlTPuZ2PnGFFPykieOn
         0Bew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mdad5kectEFueATtTuufSb/GlfpWelTpGajeRlov/y0=;
        b=iT940lmo9q8Tr3EXEZy9WZht2P6Y39kwnf/3mdmTCpCU3F5hTTn9F+oB+TjhIMl5Cg
         3eLa6sJEdZQYor6j7gDymj07iPdQe7wswkIcdk7Aku6WAPFJBsT4G2sc86cUtznq9W+y
         4pwIKquuCzBLlGS4f62oJFWrYePF8ZEk4X0A0Ic/mqqwd9eap4PxY7+CP/OKARGaiDKC
         ZfvwNUDzJK1ZcOS1wdhbtrkGFVla2zRlSesjKIRnVb4U527p4MceFvWMDER6fNvluHet
         +Nir3VdMpdOmf6I0z7YArYkqOoOlOX8JgPocQ6RYMbe5R6tnJF+o0vySGUFNYpz2SFI2
         m9sQ==
X-Gm-Message-State: AOAM532zJdzfIXS8ccCIk8bNAuVRe4739unqDMWKDBQ68vzXNs+A0KMN
        Z72KvUU+21gy/y+f7FxQz8TIq4gs0cbZOOe5B0A=
X-Google-Smtp-Source: ABdhPJxwcWxaY/0nTeNNl5vnC+6Ept5G7W/s0mSRHOPdhaZN54AnXKQk/vPCP85OoeE0KoqIaYbiGPMvNTtT0wbZXGE=
X-Received: by 2002:a9d:6396:: with SMTP id w22mr14821640otk.26.1633450236900;
 Tue, 05 Oct 2021 09:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210723034928.GE4397@paulmck-ThinkPad-P17-Gen-1>
 <CAOzhvcOLFzFGZAptOTrP9Xne1-LiO8jka1sPF6+0=WiLh-cQUA@mail.gmail.com>
 <20210723172512.GH4397@paulmck-ThinkPad-P17-Gen-1> <CAOzhvcMaTsJTS3y1FVtSOpXfG8EecYp8bKOQ0KOjCOKYJ-UerA@mail.gmail.com>
 <20210723190614.GJ4397@paulmck-ThinkPad-P17-Gen-1> <CAOzhvcMwTzHSbrkPv9DXVAdUcddHEJazz_6p6tzXiJht43RMYg@mail.gmail.com>
 <20210725004823.GN4397@paulmck-ThinkPad-P17-Gen-1> <CAOzhvcMcMY057uJNM9oMsKJubSpQ_yKwHtVEpJkATqumkNebXQ@mail.gmail.com>
 <20210728001010.GF4397@paulmck-ThinkPad-P17-Gen-1> <CAOzhvcO3a-GiipELoztmGWOmABuSC=b5vcBu8bC_Q-aT=Fe5ng@mail.gmail.com>
 <20211005005908.GR880162@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20211005005908.GR880162@paulmck-ThinkPad-P17-Gen-1>
From:   donghai qiao <donghai.w.qiao@gmail.com>
Date:   Tue, 5 Oct 2021 12:10:25 -0400
Message-ID: <CAOzhvcPLjH_qh4-PEA-MukiRhzkYHQ0UnE21Un+UP9dgpQV3zw@mail.gmail.com>
Subject: Re: RCU: rcu stall issues and an approach to the fix
To:     paulmck@kernel.org
Cc:     Boqun Feng <boqun.feng@gmail.com>, rcu@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 4, 2021 at 8:59 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Mon, Oct 04, 2021 at 05:22:52PM -0400, donghai qiao wrote:
> > Hello Paul,
> > Sorry it has been long..
>
> On this problem, your schedule is my schedule.  At least as long as your
> are not expecting instantaneous response.  ;-)
>
> > > > Because I am dealing with this issue in multiple kernel versions, sometimes
> > > > the configurations in these kernels may different. Initially the
> > > > problem I described
> > > > originated to rhel-8 on which the problem occurs more often and is a bit easier
> > > > to reproduce than others.
> > >
> > > Understood, that does make things more difficult.
> > >
> > > > Regarding these dynticks* parameters, I collected the data for CPU 0 as below :
> > > >    - dynticks = 0x6eab02    which indicated the CPU was not in eqs.
> > > >    - dynticks_nesting = 1    which is in its initial state, so it said
> > > > it was not in eqs either.
> > > >    - dynticks_nmi_nesting = 4000000000000004    which meant that this
> > > > CPU had been
> > > >      interrupted when it was in the middle of the first interrupt.
> > > > And this is true: the first
> > > >      interrupt was the sched_timer interrupt, and the second was a NMI
> > > > when another
> > > >     CPU detected the RCU stall on CPU 0.  So it looks all identical.
> > > > If the kernel missed
> > > >     a rcu_user_enter or rcu_user_exit, would these items remain
> > > > identical ?  But I'll
> > > >     investigate that possibility seriously as you pointed out.
> > >
> > > So is the initial state non-eqs because it was interrupted from kernel
> > > mode?  Or because a missing rcu_user_enter() left ->dynticks_nesting
> > > incorrectly equal to the value of 1?  Or something else?
> >
> > As far as the original problem is concerned, the user thread was interrupted by
> > the timer, so the CPU was not working in the nohz mode. But I saw the similar
> > problems on CPUs working in nohz mode with different configurations.
>
> OK.
>
> > > > > There were some issues of this sort around the v5.8 timeframe.  Might
> > > > > there be another patch that needs to be backported?  Or a patch that
> > > > > was backported, but should not have been?
> > > >
> > > > Good to know that clue. I'll take a look into the log history.
> > > >
> > > > > Is it possible to bisect this?
> > > > >
> > > > > Or, again, to run with CONFIG_RCU_EQS_DEBUG=y?
> > > >
> > > > I am building the latest 5.14 kernel with this config and give it a try when the
> > > > machine is set up, see how much it can help.
> > >
> > > Very good, as that will help determine whether or not the problem is
> > > due to backporting issues.
> >
> > I enabled CONFIG_RCU_EQS_DEBUG=y as you suggested and
> > tried it for both the latest rhel8 and a later upstream version 5.15.0-r1,
> > turns out no new warning messages related to this came out. So,
> > rcu_user_enter/rcu_user_exit() should be paired right.
>
> OK, good.
>
> > > > > Either way, what should happen is that dyntick_save_progress_counter() or
> > > > > rcu_implicit_dynticks_qs() should see the rdp->dynticks field indicating
> > > > > nohz_full user execution, and then the quiescent state will be supplied
> > > > > on behalf of that CPU.
> > > >
> > > > Agreed. But the counter rdp->dynticks of the CPU can only be updated
> > > > by rcu_dynticks_eqs_enter() or rcu_dynticks_exit() when rcu_eqs_enter()
> > > > or rcu_eqs_exit() is called, which in turn depends on the context switch.
> > > > So, when the context switch never happens, the counter rdp->dynticks
> > > > never advances. That's the thing I try to fix here.
> > >
> > > First, understand the problem.  Otherwise, your fix is not so likely
> > > to actually fix anything.  ;-)
> > >
> > > If kernel mode was interrupted, there is probably a missing cond_resched().
> > > But in sufficiently old kernels, cond_resched() doesn't do anything for
> > > RCU unless a context switch actually happened.  In some of those kernels,
> > > you can use cond_resched_rcu_qs() instead to get RCU's attention.  In
> > > really old kernels, life is hard and you will need to do some backporting.
> > > Or move to newer kernels.
> > >
> > > In short, if an in-kernel code path runs for long enough without hitting
> > > a cond_resched() or similar, that is a bug.  The RCU CPU stall warning
> > > that you will get is your diagnostic.
> >
> > Probably this is the case. With the test for 5.15.0-r1, I have seen different
> > scenarios, among them the most frequent ones were caused by the networking
> > in which a bunch of networking threads were spinning on the same rwlock.
> >
> > For instance in one of them, the ticks_this_gp of a rcu_data could go as
> > large as 12166 (ticks) which is 12+ seconds. The thread on this cpu was
> > doing networking work and finally it was spinning as a writer on a rwlock
> > which had been locked by 16 readers.  By the way, there were 70 this
> > kinds of writers were blocked on the same rwlock.
>
> OK, a lock-contention problem.  The networking folks have fixed a
> very large number of these over the years, though, so I wonder what is
> special about this one so that it is just now showing up.  I have added
> a networking list on CC for their thoughts.

Thanks for pulling the networking in. If they need the coredump, I can
forward it to them.  It's definitely worth analyzing it as this contention
might be a performance issue.  Or we can discuss this further in this
email thread if they are fine, or we can discuss it over with a separate
email thread with netdev@ only.

So back to my original problem, this might be one of the possibilities that
led to RCU stall panic.  Just imagining this type of contention might have
occurred and lasted long enough. When it finally came to the end, the
timer interrupt occurred, therefore rcu_sched_clock_irq detected the RCU
stall on the CPU and panic.

So definitely we need to understand these networking activities here as
to why the readers could hold the rwlock too long.

>
> > When examining the readers of the lock, except the following code,
> > don't see any other obvious problems: e.g
> >  #5 [ffffad3987254df8] __sock_queue_rcv_skb at ffffffffa49cd2ee
> >  #6 [ffffad3987254e18] raw_rcv at ffffffffa4ac75c8
> >  #7 [ffffad3987254e38] raw_local_deliver at ffffffffa4ac7819
> >  #8 [ffffad3987254e88] ip_protocol_deliver_rcu at ffffffffa4a8dea4
> >  #9 [ffffad3987254ea8] ip_local_deliver_finish at ffffffffa4a8e074
> > #10 [ffffad3987254eb0] __netif_receive_skb_one_core at ffffffffa49f3057
> > #11 [ffffad3987254ed0] process_backlog at ffffffffa49f3278
> > #12 [ffffad3987254f08] __napi_poll at ffffffffa49f2aba
> > #13 [ffffad3987254f30] net_rx_action at ffffffffa49f2f33
> > #14 [ffffad3987254fa0] __softirqentry_text_start at ffffffffa50000d0
> > #15 [ffffad3987254ff0] do_softirq at ffffffffa40e12f6
> >
> > In the function ip_local_deliver_finish() of this stack, a lot of the work needs
> > to be done with ip_protocol_deliver_rcu(). But this function is invoked from
> > a rcu reader side section.
> >
> > static int ip_local_deliver_finish(struct net *net, struct sock *sk,
> > struct sk_buff *skb)
> > {
> >         __skb_pull(skb, skb_network_header_len(skb));
> >
> >         rcu_read_lock();
> >         ip_protocol_deliver_rcu(net, skb, ip_hdr(skb)->protocol);
> >         rcu_read_unlock();
> >
> >         return 0;
> > }
> >
> > Actually there are multiple chances that this code path can hit
> > spinning locks starting from ip_protocol_deliver_rcu(). This kind
> > usage looks not quite right. But I'd like to know your opinion on this first ?
>
> It is perfectly legal to acquire spinlocks in RCU read-side critical
> sections.  In fact, this is one of the few ways to safely acquire a
> per-object lock while still maintaining good performance and
> scalability.

Sure, understand. But the RCU related docs said that anything causing
the reader side to block must be avoided.

>
> My guess is that the thing to track down is the cause of the high contention
> on that reader-writer spinlock.  Missed patches, misconfiguration, etc.

Actually, the test was against a recent upstream 5.15.0-r1  But I can try
the latest r4.  Regarding the network configure, I believe I didn't do anything
special, just use the default.

Thanks
Donghai

>
>                                                         Thanx, Paul

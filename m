Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4762D4328FA
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhJRVVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbhJRVVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 17:21:06 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D25C06161C;
        Mon, 18 Oct 2021 14:18:54 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id t9so2687539lfd.1;
        Mon, 18 Oct 2021 14:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ndZNyV+JL807fPvlsvnrEfsziQfS3pGYsGuIfTtOrak=;
        b=hdhSWv0PSQNcy2YTNLuo2veIQI5uarEAzUwAGouhOikIIpP6hOBKso8w3UBXC14TBj
         krsmbHecMnJbOhQ4Rx/TL7co6S3ivSMonpnLp/EFoFBwXArkSsZlxMYfW3XS0ZTxzLyU
         aypXiKRqNLG4M8Lvu0OpatSGaIhKuQyQ5PsPEn3L3tScYweSPpze6zbR6MoEc8El6m3F
         507DMnxm2ClJX0Pi+pHRg21HtvghoXcgQxXEvW3WwUvcLQ3G3In07SSKOZvwWa9AnpJC
         BZ1W2+62BeAJ11O+vllp4fdnmEJS4xUPGbrzE9oa8wTEVeIPUrlW5vF3ApwkTvkAlG46
         lYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ndZNyV+JL807fPvlsvnrEfsziQfS3pGYsGuIfTtOrak=;
        b=fS2jSbyIK42C418ItO0SpFAu1BXuaH5mi47gUkE2x9jCSd/P1J5mWj2GqvVf6rA1ru
         GLBHxCkm0vz7RXVRjgdha+zMx9xfFtrnkrPKVV+FSsvWJfxrQTu2BMlw6suLQV7OPamB
         dmId5En0ifrHEcxXmfD0l4va9+8OtJnpFMWwcWSqNJlkgUdZpNhJWRXxD2bHydzapuWs
         /MkQCn6WHobzQVJxdV0Z+24otHQVUttDpiOueqBgoImB+tAdyz8DQ0lQUvtPwAtvR82P
         54/kpK9tIOXubM5LcNbXHq6kxlVIR18rOjF6SmXVf5ATSIZIxgdegNl/e2KUZPGa5zcO
         uigg==
X-Gm-Message-State: AOAM532tmJ57oQkSOeE9fe692OH8O7yTNUUkvBIC+/Ixi65t4zqYpZ6I
        AfbTkmex6ZnlJyT9NmntQ25lBzWqpQzyy83v5R4=
X-Google-Smtp-Source: ABdhPJzU2lYDXDetdxFTBkBncw1xjdLS3xC+wz5sNju1S+LxSDO3Q0mSEDhznfYvKk7/J07n2JEpyhDg9b8fhsNNBAs=
X-Received: by 2002:a05:6512:21cb:: with SMTP id d11mr2081850lft.579.1634591932270;
 Mon, 18 Oct 2021 14:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210723172512.GH4397@paulmck-ThinkPad-P17-Gen-1>
 <CAOzhvcMaTsJTS3y1FVtSOpXfG8EecYp8bKOQ0KOjCOKYJ-UerA@mail.gmail.com>
 <20210723190614.GJ4397@paulmck-ThinkPad-P17-Gen-1> <CAOzhvcMwTzHSbrkPv9DXVAdUcddHEJazz_6p6tzXiJht43RMYg@mail.gmail.com>
 <20210725004823.GN4397@paulmck-ThinkPad-P17-Gen-1> <CAOzhvcMcMY057uJNM9oMsKJubSpQ_yKwHtVEpJkATqumkNebXQ@mail.gmail.com>
 <20210728001010.GF4397@paulmck-ThinkPad-P17-Gen-1> <CAOzhvcO3a-GiipELoztmGWOmABuSC=b5vcBu8bC_Q-aT=Fe5ng@mail.gmail.com>
 <20211005005908.GR880162@paulmck-ThinkPad-P17-Gen-1> <CAOzhvcPLjH_qh4-PEA-MukiRhzkYHQ0UnE21Un+UP9dgpQV3zw@mail.gmail.com>
 <20211005163956.GV880162@paulmck-ThinkPad-P17-Gen-1> <CAOzhvcPv59zwq26a9wKbFudLBdxd8tDr6OVDvKwzje2cm2woJw@mail.gmail.com>
In-Reply-To: <CAOzhvcPv59zwq26a9wKbFudLBdxd8tDr6OVDvKwzje2cm2woJw@mail.gmail.com>
From:   donghai qiao <donghai.w.qiao@gmail.com>
Date:   Mon, 18 Oct 2021 17:18:40 -0400
Message-ID: <CAOzhvcOt1gaLiOKFOAYutfDLZy3xyZMPo1N6T+1HYYXzsCpxTw@mail.gmail.com>
Subject: Re: RCU: rcu stall issues and an approach to the fix
To:     paulmck@kernel.org
Cc:     Boqun Feng <boqun.feng@gmail.com>, rcu@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just want to follow up this discussion. First off, the latest issue
I mentioned in the email of Oct 4th which
exhibited a symptom of networking appeared to be a problem in
qrwlock.c. Particularly the problem is
caused by the 'if' statement in the function queued_read_lock_slowpath() below :

void queued_read_lock_slowpath(struct qrwlock *lock)
{
        /*
         * Readers come here when they cannot get the lock without waiting
         */
        if (unlikely(in_interrupt())) {
                /*
                 * Readers in interrupt context will get the lock immediately
                 * if the writer is just waiting (not holding the lock yet),
                 * so spin with ACQUIRE semantics until the lock is available
                 * without waiting in the queue.
                 */
                atomic_cond_read_acquire(&lock->cnts, !(VAL & _QW_LOCKED));
                return;
        }
        ...
}

That 'if' statement said, if we are in an interrupt context and we are
a reader, then
we will be allowed to enter the lock as a reader no matter if there
are writers waiting
for it or not. So, in the circumstance when the network packets steadily come in
and the intervals are relatively small enough, then the writers will
have no chance to
acquire the lock. This should be the root cause for that case.

I have verified it by removing the 'if' and rerun the test multiple
times. The same
symptom hasn't been reproduced.  As far as rcu stall is concerned as a
broader range
of problems,  this is absolutely not the only root cause I have seen.
Actually too many
things can delay context switching.  Do you have a long term plan to
fix this issue,
or just want to treat it case by case?

Secondly, back to the following code I brought up that day. Actually
it is not as simple
as spinlock.

      rcu_read_lock();
      ip_protocol_deliver_rcu(net, skb, ip_hdr(skb)->protocol);
      rcu_read_unlock();

Are you all aware of all the potential functions that
ip_protocol_deliver_rcu will call?
As I can see, there is a code path from ip_protocol_deliver_rcu to
kmem_cache_alloc
which will end up a call to cond_resched().  Because the operations in memory
allocation are too complicated, we cannot alway expect a prompt return
with success.
When the system is running out of memory, then rcu cannot close the
current gp, then
great number of callbacks will be delayed and the freeing of the
memory they held
will be delayed as well. This sounds like a deadlock in the resource flow.


Thanks
Donghai


On Tue, Oct 5, 2021 at 8:25 PM donghai qiao <donghai.w.qiao@gmail.com> wrote:
>
> On Tue, Oct 5, 2021 at 12:39 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Tue, Oct 05, 2021 at 12:10:25PM -0400, donghai qiao wrote:
> > > On Mon, Oct 4, 2021 at 8:59 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > > >
> > > > On Mon, Oct 04, 2021 at 05:22:52PM -0400, donghai qiao wrote:
> > > > > Hello Paul,
> > > > > Sorry it has been long..
> > > >
> > > > On this problem, your schedule is my schedule.  At least as long as your
> > > > are not expecting instantaneous response.  ;-)
> > > >
> > > > > > > Because I am dealing with this issue in multiple kernel versions, sometimes
> > > > > > > the configurations in these kernels may different. Initially the
> > > > > > > problem I described
> > > > > > > originated to rhel-8 on which the problem occurs more often and is a bit easier
> > > > > > > to reproduce than others.
> > > > > >
> > > > > > Understood, that does make things more difficult.
> > > > > >
> > > > > > > Regarding these dynticks* parameters, I collected the data for CPU 0 as below :
> > > > > > >    - dynticks = 0x6eab02    which indicated the CPU was not in eqs.
> > > > > > >    - dynticks_nesting = 1    which is in its initial state, so it said
> > > > > > > it was not in eqs either.
> > > > > > >    - dynticks_nmi_nesting = 4000000000000004    which meant that this
> > > > > > > CPU had been
> > > > > > >      interrupted when it was in the middle of the first interrupt.
> > > > > > > And this is true: the first
> > > > > > >      interrupt was the sched_timer interrupt, and the second was a NMI
> > > > > > > when another
> > > > > > >     CPU detected the RCU stall on CPU 0.  So it looks all identical.
> > > > > > > If the kernel missed
> > > > > > >     a rcu_user_enter or rcu_user_exit, would these items remain
> > > > > > > identical ?  But I'll
> > > > > > >     investigate that possibility seriously as you pointed out.
> > > > > >
> > > > > > So is the initial state non-eqs because it was interrupted from kernel
> > > > > > mode?  Or because a missing rcu_user_enter() left ->dynticks_nesting
> > > > > > incorrectly equal to the value of 1?  Or something else?
> > > > >
> > > > > As far as the original problem is concerned, the user thread was interrupted by
> > > > > the timer, so the CPU was not working in the nohz mode. But I saw the similar
> > > > > problems on CPUs working in nohz mode with different configurations.
> > > >
> > > > OK.
> > > >
> > > > > > > > There were some issues of this sort around the v5.8 timeframe.  Might
> > > > > > > > there be another patch that needs to be backported?  Or a patch that
> > > > > > > > was backported, but should not have been?
> > > > > > >
> > > > > > > Good to know that clue. I'll take a look into the log history.
> > > > > > >
> > > > > > > > Is it possible to bisect this?
> > > > > > > >
> > > > > > > > Or, again, to run with CONFIG_RCU_EQS_DEBUG=y?
> > > > > > >
> > > > > > > I am building the latest 5.14 kernel with this config and give it a try when the
> > > > > > > machine is set up, see how much it can help.
> > > > > >
> > > > > > Very good, as that will help determine whether or not the problem is
> > > > > > due to backporting issues.
> > > > >
> > > > > I enabled CONFIG_RCU_EQS_DEBUG=y as you suggested and
> > > > > tried it for both the latest rhel8 and a later upstream version 5.15.0-r1,
> > > > > turns out no new warning messages related to this came out. So,
> > > > > rcu_user_enter/rcu_user_exit() should be paired right.
> > > >
> > > > OK, good.
> > > >
> > > > > > > > Either way, what should happen is that dyntick_save_progress_counter() or
> > > > > > > > rcu_implicit_dynticks_qs() should see the rdp->dynticks field indicating
> > > > > > > > nohz_full user execution, and then the quiescent state will be supplied
> > > > > > > > on behalf of that CPU.
> > > > > > >
> > > > > > > Agreed. But the counter rdp->dynticks of the CPU can only be updated
> > > > > > > by rcu_dynticks_eqs_enter() or rcu_dynticks_exit() when rcu_eqs_enter()
> > > > > > > or rcu_eqs_exit() is called, which in turn depends on the context switch.
> > > > > > > So, when the context switch never happens, the counter rdp->dynticks
> > > > > > > never advances. That's the thing I try to fix here.
> > > > > >
> > > > > > First, understand the problem.  Otherwise, your fix is not so likely
> > > > > > to actually fix anything.  ;-)
> > > > > >
> > > > > > If kernel mode was interrupted, there is probably a missing cond_resched().
> > > > > > But in sufficiently old kernels, cond_resched() doesn't do anything for
> > > > > > RCU unless a context switch actually happened.  In some of those kernels,
> > > > > > you can use cond_resched_rcu_qs() instead to get RCU's attention.  In
> > > > > > really old kernels, life is hard and you will need to do some backporting.
> > > > > > Or move to newer kernels.
> > > > > >
> > > > > > In short, if an in-kernel code path runs for long enough without hitting
> > > > > > a cond_resched() or similar, that is a bug.  The RCU CPU stall warning
> > > > > > that you will get is your diagnostic.
> > > > >
> > > > > Probably this is the case. With the test for 5.15.0-r1, I have seen different
> > > > > scenarios, among them the most frequent ones were caused by the networking
> > > > > in which a bunch of networking threads were spinning on the same rwlock.
> > > > >
> > > > > For instance in one of them, the ticks_this_gp of a rcu_data could go as
> > > > > large as 12166 (ticks) which is 12+ seconds. The thread on this cpu was
> > > > > doing networking work and finally it was spinning as a writer on a rwlock
> > > > > which had been locked by 16 readers.  By the way, there were 70 this
> > > > > kinds of writers were blocked on the same rwlock.
> > > >
> > > > OK, a lock-contention problem.  The networking folks have fixed a
> > > > very large number of these over the years, though, so I wonder what is
> > > > special about this one so that it is just now showing up.  I have added
> > > > a networking list on CC for their thoughts.
> > >
> > > Thanks for pulling the networking in. If they need the coredump, I can
> > > forward it to them.  It's definitely worth analyzing it as this contention
> > > might be a performance issue.  Or we can discuss this further in this
> > > email thread if they are fine, or we can discuss it over with a separate
> > > email thread with netdev@ only.
> > >
> > > So back to my original problem, this might be one of the possibilities that
> > > led to RCU stall panic.  Just imagining this type of contention might have
> > > occurred and lasted long enough. When it finally came to the end, the
> > > timer interrupt occurred, therefore rcu_sched_clock_irq detected the RCU
> > > stall on the CPU and panic.
> > >
> > > So definitely we need to understand these networking activities here as
> > > to why the readers could hold the rwlock too long.
> >
> > I strongly suggest that you also continue to do your own analysis on this.
> > So please see below.
>
> This is just a brief of my analysis and the stack info below is not enough
> for other people to figure out anything useful. I meant if they are really
> interested, I can upload the core file. I think this is fair.
>
> >
> > > > > When examining the readers of the lock, except the following code,
> > > > > don't see any other obvious problems: e.g
> > > > >  #5 [ffffad3987254df8] __sock_queue_rcv_skb at ffffffffa49cd2ee
> > > > >  #6 [ffffad3987254e18] raw_rcv at ffffffffa4ac75c8
> > > > >  #7 [ffffad3987254e38] raw_local_deliver at ffffffffa4ac7819
> > > > >  #8 [ffffad3987254e88] ip_protocol_deliver_rcu at ffffffffa4a8dea4
> > > > >  #9 [ffffad3987254ea8] ip_local_deliver_finish at ffffffffa4a8e074
> > > > > #10 [ffffad3987254eb0] __netif_receive_skb_one_core at ffffffffa49f3057
> > > > > #11 [ffffad3987254ed0] process_backlog at ffffffffa49f3278
> > > > > #12 [ffffad3987254f08] __napi_poll at ffffffffa49f2aba
> > > > > #13 [ffffad3987254f30] net_rx_action at ffffffffa49f2f33
> > > > > #14 [ffffad3987254fa0] __softirqentry_text_start at ffffffffa50000d0
> > > > > #15 [ffffad3987254ff0] do_softirq at ffffffffa40e12f6
> > > > >
> > > > > In the function ip_local_deliver_finish() of this stack, a lot of the work needs
> > > > > to be done with ip_protocol_deliver_rcu(). But this function is invoked from
> > > > > a rcu reader side section.
> > > > >
> > > > > static int ip_local_deliver_finish(struct net *net, struct sock *sk,
> > > > > struct sk_buff *skb)
> > > > > {
> > > > >         __skb_pull(skb, skb_network_header_len(skb));
> > > > >
> > > > >         rcu_read_lock();
> > > > >         ip_protocol_deliver_rcu(net, skb, ip_hdr(skb)->protocol);
> > > > >         rcu_read_unlock();
> > > > >
> > > > >         return 0;
> > > > > }
> > > > >
> > > > > Actually there are multiple chances that this code path can hit
> > > > > spinning locks starting from ip_protocol_deliver_rcu(). This kind
> > > > > usage looks not quite right. But I'd like to know your opinion on this first ?
> > > >
> > > > It is perfectly legal to acquire spinlocks in RCU read-side critical
> > > > sections.  In fact, this is one of the few ways to safely acquire a
> > > > per-object lock while still maintaining good performance and
> > > > scalability.
> > >
> > > Sure, understand. But the RCU related docs said that anything causing
> > > the reader side to block must be avoided.
> >
> > True.  But this is the Linux kernel, where "block" means something
> > like "invoke schedule()" or "sleep" instead of the academic-style
> > non-blocking-synchronization definition.  So it is perfectly legal to
> > acquire spinlocks within RCU read-side critical sections.
> >
> > And before you complain that practitioners are not following the academic
> > definitions, please keep in mind that our definitions were here first.  ;-)
> >
> > > > My guess is that the thing to track down is the cause of the high contention
> > > > on that reader-writer spinlock.  Missed patches, misconfiguration, etc.
> > >
> > > Actually, the test was against a recent upstream 5.15.0-r1  But I can try
> > > the latest r4.  Regarding the network configure, I believe I didn't do anything
> > > special, just use the default.
> >
> > Does this occur on older mainline kernels?  If not, I strongly suggest
> > bisecting, as this often quickly and easily finds the problem.
>
> Actually It does. But let's focus on the latest upstream and the latest rhel8.
> This way, we will not worry about missing the needed rcu patches.
> However, in rhel8, the kernel stack running on the rcu-stalled CPU is not
> networking related, which I am still working on.  So, there might be
> multiple root causes.
>
> > Bisection can also help you find the patch to be backported if a later
> > release fixes the bug, though things like gitk can also be helpful.
>
> Unfortunately, this is reproducible on the latest bit.
>
> Thanks
> Donghai
> >
> >                                                         Thanx, Paul

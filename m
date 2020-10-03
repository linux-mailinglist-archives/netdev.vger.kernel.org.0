Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDB7281F9B
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 02:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgJCAKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 20:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJCAKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 20:10:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA75EC0613D0;
        Fri,  2 Oct 2020 17:10:10 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601683808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XTmNQU4mWz8t/0MS6mVEN8nOAMp2jm2RxipOE03ens8=;
        b=2ksbfA9BVis5iBMK3wB9ygQURxhz6xHw5jU2Qp61CRHqSW99ojoGUJjyj0Naa5rmGY6evQ
        ZBvRqh9+e3YihczvWJgLdsHLb+IHyzJOReXmYIBXFCpBaQry1gulqxNTBcTCow9tpXk+/O
        HRCkNxZYFtxlm5T+dsz5DSIs9fFpiKez0cbASVbkhqEIvQoy68tNNF3YaoLYQiI/teEvQE
        zZhbG0/HoDxJAroCzY/8L3CRTkJISbe9lEsreezoxRswFRLptUcu+0pd60o4J9+qF6DxjB
        /pJA+AEAUr4tURoAwqpmWb54svj25h7UMGTx3Tqiy4Ttkj2UF0AWvricfOe3Dw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601683808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XTmNQU4mWz8t/0MS6mVEN8nOAMp2jm2RxipOE03ens8=;
        b=HV2OiNvSvzxGdm1GYBB6UiG55JPgtjIcebOlyl1Vo5GuQ2Phcbwr7P4OOPQ0yybrDHjHlc
        85bsp93xMFjSezDQ==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Andreas Bucher <andreas.bucher@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andreas Zirkler <andreas.zirkler@siemens.com>,
        Ermin Sakic <ermin.sakic@siemens.com>,
        An Ninh Nguyen <anninh.nguyen@siemens.com>,
        Michael Saenger <michael.saenger@siemens.com>,
        Bernd Maehringer <bernd.maehringer@siemens.com>,
        Gisela Greinert <gisela.greinert@siemens.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Subject: Re: [PATCH 0/7] TC-ETF support PTP clocks series
In-Reply-To: <87eemg5u5i.fsf@intel.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com> <87eemg5u5i.fsf@intel.com>
Date:   Sat, 03 Oct 2020 02:10:08 +0200
Message-ID: <87tuvccgpr.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vinicius,

On Fri, Oct 02 2020 at 12:01, Vinicius Costa Gomes wrote:
> I think that there's an underlying problem/limitation that is the cause
> of the issue (or at least a step in the right direction) you are trying
> to solve: the issue is that PTP clocks can't be used as hrtimers.

That's only an issue if PTP time != CLOCK_TAI, which is insane to begin
with.

As I know that these insanities exists in real world setups, e.g. grand
clock masters which start at the epoch which causes complete disaster
when any of the slave devices booted earlier. Obviously people came
up with system designs which are even more insane.

> I didn't spend a lot of time thinking about how to solve this (the only
> thing that comes to mind is having a timecounter, or similar, "software
> view" over the PHC clock).

There are two aspects:

 1) What's the overall time coordination especially for applications?

    PTP is for a reason based on TAI which allows a universal
    representation of time. Strict monotonic, no time zones, no leap
    seconds, no bells and whistels.

    Using TAI in distributed systems solved a gazillion of hard problems
    in one go.

    TSN depends on PTP and that obviously makes CLOCK_TAI _the_ clock of
    choice for schedules and whatever is needed. It just solves the
    problem nicely and we spent a great amount of time to make
    application development for TSN reasonable and hardware agnostic.

    Now industry comes along and decides to introducde independent time
    universes. The result is a black hole for programmers because they
    now have to waste effort - again - on solving the incredibly hard
    problems of warping space and time.

    The amount of money saved by not having properly coordinated time
    bases in such systems is definitely marginal compared to the amount
    of non-sensical work required to fix it in software.

 2) How can an OS provide halfways usable interfaces to handle this
    trainwreck?

    Access to the various time universes is already available through
    the dynamic POSIX clocks. But these interfaces have been designed
    for the performance insensitive work of PTP daemons and not for the
    performance critical work of applications dealing with real-time
    requirements of all sorts.

    As these raw PTP clocks are hardware dependend and only known at
    boot / device discovery time they cannot be exposed to the kernel
    internaly in any sane way. Also the user space interface has to be
    dynamic which rules out the ability to assign fixed CLOCK_* ids.

    As a consequence these clocks cannot provide timers like the regular
    CLOCK_* variants do, which makes it insanely hard to develop sane
    and portable applications.

    What comes to my mind (without spending much thought on it) is:

       1) Utilize and extend the existing PTP mechanisms to calculate
          the time relationship between the system wide CLOCK_TAI and
          the uncoordinated time universe. As offset is a constant and
          frequency drift is not a high speed problem this can be done
          with a userspace daemon of some sorts.

        2) Provide CLOCK_TAI_PRIVATE which defaults to CLOCK_TAI,
           i.e. offset = 0 and frequency ratio = 1 : 1

        3) (Ab)use the existing time namespace to provide a mechanism to
           adjust the offset and frequency ratio of CLOCK_TAI_PRIVATE
           which is calculated by #1

           This is the really tricky part and comes with severe
           limitations:

             - We can't walk task list to find tasks which have their
               CLOCK_TAI_PRIVATE associated with a particular
               incarnation of PCH/PTP universe, so some sane referencing
               of the underlying parameters to convert TAI to
               TAI_PRIVATE and vice versa has to be found. Life time
               problems are going to be interesting to deal with.

             - An application cannot coordinate multiple PCH/PTP domains
               and has to restrict itself to pick ONE disjunct time
               universe.

               Whether that's a reasonable limitation I don't know
               simply because the information provided in this patch
               series is close to zero.

             - Preventing early timer expiration caused by frequency
               drift is not trivial either.

      TBH, just thinking about all of that makes me shudder and my knee
      jerk reaction is: NO WAY!

Why the heck can't hardware people and system designers finally
understand that time is not something they can define at their
own peril?

The "Let's solve it in software so I don't have to think about it"
design approach strikes again. This caused headaches for the past five
decades, but people obviously never learn.

That said, I'm open for solutions which are at least in the proximity of
sane, but that needs a lot more information about the use cases and the
implications and not just some handwavy 'we screwed up our system design
and therefore we need to inflict insanity on everyone' blurb.

Thanks,

        tglx



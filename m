Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4249561FEE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbiF3QH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbiF3QH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:07:56 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284881AF0F
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 09:07:52 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id i15so34660954ybp.1
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 09:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZYpRpqYmpLHtSZ4UZWrh/TDPBDXwHd9fuFtqbGJNp8=;
        b=BuX4qA5++m+OrJvsOaRfSJjyTNROnqnd/mCvs1fJFZLG3AYi/V7Afuuc+DxYwklGe2
         8TTd0CJJFfjl5KQwwQlWyyn84g40XaWyHt0y/uDsKjx7TBMs1SIJTniaOuT4nRFnWCOW
         4mUH+1+M0E2Hw+WrjJvpBSvc9OZcerbYjFVpotYfn/oy5PZSMjbx3PKSOeuirVFFjRiH
         I6i0pWr1Bm26YHBfmj8Q4KWnzxx/b/1IT3Gf1o4kxilrc9UXbFRwcGcIsyEFpW80Uq+m
         CW0xXsP0zwXdpH8cWyDpSNce0LE26o0TO+q1YcwIDpeXgStFfhRqHawz8szkHxHYixXX
         RWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZYpRpqYmpLHtSZ4UZWrh/TDPBDXwHd9fuFtqbGJNp8=;
        b=net2KOmv8LyybnaPRB3DA+1vE4Nv+PQTmvC0HsBnM7nSX61W5x20wRQBFeMV4dTUlR
         olKoxpTeCWjrM5j/4wQjqp6YpQrPSe9b5PPz/gqqnIu0CIvya5fvyaHXo6GrXk8t85Lr
         KT2pLnMpNkxzvowv6twQIE1B7PcY25NU+3Vh8ZZVvTelRkGj9H7KlgGW/1Q8kcSpRqFL
         hMXx/LVae6NmHJALzqTD06lA4w8FexCYfIWG6W84b6YmsQ5T07AyPao93XG02u9feKHX
         +cCVcsucXpCV2PnL9J6aXSoZlKN4tMGQ2xhFBsDJQywt1vxihkCg025RGqklHq5ql4Gq
         /xeg==
X-Gm-Message-State: AJIora8afmhnZRN0SY8vdecDDhBBwtarI5D4jNqmVoFChqqEH/2p9KMD
        WWzheaiavBT0RsUHBqpSBXMDJ/WwKdbdEjBD7rU9vA==
X-Google-Smtp-Source: AGRyM1veIK5oqkXm9Jh6FafjYaMA6RaYT2l9Mbn0Rx3j6oD+QxIsrfxzOTk4yC6i7GZ5Uj5bAoLxk+SS6q5Fa7uvISQ=
X-Received: by 2002:a25:e211:0:b0:669:9cf9:bac7 with SMTP id
 h17-20020a25e211000000b006699cf9bac7mr9710834ybe.407.1656605271052; Thu, 30
 Jun 2022 09:07:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220630143842.24906-1-duoming@zju.edu.cn> <CANn89iLda2oxoPQaGd9r8frAaOu1LqxmWYm2O8W4HXaGRN8tcQ@mail.gmail.com>
 <bed69ee.1e8d9.181b528391c.Coremail.duoming@zju.edu.cn> <CANn89iKo-uuF-iQWrfL=pgMu7bEakWHPDAVuLvT-TZ4AujiD=w@mail.gmail.com>
 <55ffc892.1ea21.181b54f4b2f.Coremail.duoming@zju.edu.cn>
In-Reply-To: <55ffc892.1ea21.181b54f4b2f.Coremail.duoming@zju.edu.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Jun 2022 18:07:39 +0200
Message-ID: <CANn89iLBE_kdnznsURLHVuaKqvzJ2nyuzKxz2y8G_29WjccsOA@mail.gmail.com>
Subject: Re: [PATCH net] net: rose: fix UAF bug caused by rose_t0timer_expiry
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 5:51 PM <duoming@zju.edu.cn> wrote:
>
> Hello,
>
> On Thu, 30 Jun 2022 17:17:10 +0200 Eric Dumazet wrote:
>
> > > > > There are UAF bugs caused by rose_t0timer_expiry(). The
> > > > > root cause is that del_timer() could not stop the timer
> > > > > handler that is running and there is no synchronization.
> > > > > One of the race conditions is shown below:
> > > > >
> > > > >     (thread 1)             |        (thread 2)
> > > > >                            | rose_device_event
> > > > >                            |   rose_rt_device_down
> > > > >                            |     rose_remove_neigh
> > > > > rose_t0timer_expiry        |       rose_stop_t0timer(rose_neigh)
> > > > >   ...                      |         del_timer(&neigh->t0timer)
> > > > >                            |         kfree(rose_neigh) //[1]FREE
> > > > >   neigh->dce_mode //[2]USE |
> > > > >
> > > > > The rose_neigh is deallocated in position [1] and use in
> > > > > position [2].
> > > > >
> > > > > The crash trace triggered by POC is like below:
> > > > >
> > > > > BUG: KASAN: use-after-free in expire_timers+0x144/0x320
> > > > > Write of size 8 at addr ffff888009b19658 by task swapper/0/0
> > > > > ...
> > > > > Call Trace:
> > > > >  <IRQ>
> > > > >  dump_stack_lvl+0xbf/0xee
> > > > >  print_address_description+0x7b/0x440
> > > > >  print_report+0x101/0x230
> > > > >  ? expire_timers+0x144/0x320
> > > > >  kasan_report+0xed/0x120
> > > > >  ? expire_timers+0x144/0x320
> > > > >  expire_timers+0x144/0x320
> > > > >  __run_timers+0x3ff/0x4d0
> > > > >  run_timer_softirq+0x41/0x80
> > > > >  __do_softirq+0x233/0x544
> > > > >  ...
> > > > >
> > > > > This patch changes del_timer() in rose_stop_t0timer() and
> > > > > rose_stop_ftimer() to del_timer_sync() in order that the
> > > > > timer handler could be finished before the resources such as
> > > > > rose_neigh and so on are deallocated. As a result, the UAF
> > > > > bugs could be mitigated.
> > > > >
> > > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > > Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> > > > > ---
> > > > >  net/rose/rose_link.c | 4 ++--
> > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
> > > > > index 8b96a56d3a4..9734d1264de 100644
> > > > > --- a/net/rose/rose_link.c
> > > > > +++ b/net/rose/rose_link.c
> > > > > @@ -54,12 +54,12 @@ static void rose_start_t0timer(struct rose_neigh *neigh)
> > > > >
> > > > >  void rose_stop_ftimer(struct rose_neigh *neigh)
> > > > >  {
> > > > > -       del_timer(&neigh->ftimer);
> > > > > +       del_timer_sync(&neigh->ftimer);
> > > > >  }
> > > >
> > > > Are you sure this is safe ?
> > > >
> > > > del_timer_sync() could hang if the caller holds a lock that the timer
> > > > function would need to acquire.
> > >
> > > I think this is safe. The rose_ftimer_expiry() is an empty function that is
> > > shown below:
> > >
> > > static void rose_ftimer_expiry(struct timer_list *t)
> > > {
> > > }
> > >
> > > > >
> > > > >  void rose_stop_t0timer(struct rose_neigh *neigh)
> > > > >  {
> > > > > -       del_timer(&neigh->t0timer);
> > > > > +       del_timer_sync(&neigh->t0timer);
> > > > >  }
> > > >
> > > > Same here, please explain why it is safe.
> > >
> > > The rose_stop_t0timer() may hold "rose_node_list_lock" and "rose_neigh_list_lock",
> > > but the timer handler rose_t0timer_expiry() that is shown below does not need
> > > these two locks.
> > >
> > > static void rose_t0timer_expiry(struct timer_list *t)
> > > {
> > >         struct rose_neigh *neigh = from_timer(neigh, t, t0timer);
> > >
> > >         rose_transmit_restart_request(neigh);
> > >
> > >         neigh->dce_mode = 0;
> > >
> > >         rose_start_t0timer(neigh);
> >
> > This will rearm the timer.  del_timer_sync() will not help.
>
> Thank you for your time, but I don't think so.
>
> > Please read the comment in front of del_timer_sync(), in kernel/time/timer.c
>
> I wrote a kernel module to test whether del_timer_sync() could finish a timer handler
> that use mod_timer() to rewind itself. The following is the result.
>
> # insmod del_timer_sync.ko
> [  929.374405] my_timer will be create.
> [  929.374738] the jiffies is :4295595572
> [  930.411581] In my_timer_function
> [  930.411956] the jiffies is 4295596609
> [  935.466643] In my_timer_function
> [  935.467505] the jiffies is 4295601665
> [  940.586538] In my_timer_function
> [  940.586916] the jiffies is 4295606784
> [  945.706579] In my_timer_function
> [  945.706885] the jiffies is 4295611904
>
> #
> # rmmod del_timer_sync.ko
> [  948.507692] the del_timer_sync is :1
> [  948.507692]
> #
> #
>
> The result of the experiment shows that the timer handler could
> be killed after we execute del_timer_sync(), even if the timer could
> rewind itself.


This is not enough to run an experiment to determine a comment is obsolete.

Especially if you are not running the code from interrupts, like rose
protocol might...

If you think the comment is obsolete, please send a patch to amend it.

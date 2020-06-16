Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAB41FAE1C
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgFPKiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 06:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgFPKiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:38:50 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC02C08C5C2
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 03:38:48 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l27so20990212ejc.1
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 03:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Xb1FtyUd494DV8GZHUUbYDS03n6IxJTN/T5iS9xx3M=;
        b=U+N7xVUYfQtkBTdZm/eaGk2oxgXwldKCD3gkiRi5JUUcstqyY5xABfeuwKOXTWnpaL
         YtlQoggHVL3R/0i08O3gjSpsMf6CHEyjWZAyyEy/rqlyXgdFldqRPsSnbuOG4CmSpAr2
         mdI3Dzpz8x0rbhk/A3RpcJqtcbZ6cNZNDLjh6Q2AHUL0fmeGtyaF6tWG/dsPMzoalLrx
         cq20jwLgNUtRB6opwEd8ucX9ApBHxmdZoIjgC8tTMRnaubMlrvDK4MXdNQ/xgHcCzRDG
         2nkNTw8v8cJX0YzqgTHanV2VwnHn8J4mfwGWyjWo23+ToVOEZ3X/Xn2/G/NSmDnzCSeY
         sDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Xb1FtyUd494DV8GZHUUbYDS03n6IxJTN/T5iS9xx3M=;
        b=dEJJNjtrt4nu0XMsFatUAaGSleqikwuvTdrRtYcsJ0TOQ5CsGUfpPXuIrFw76NCVf2
         i4CQUdQCPJtIBT2Ql50By6kVPbZiO4cNF8i+KjRd5HXP6EHDgN4eDJyj6BwHso2DF8Jl
         IcSeUAwCiFFE3UxuKuZncu9Q9C9eW9NJNooerd8R7lm/MX/VxrDskdeqCsLZqd72pt7z
         XA4uCc8dsHmWj/Tr5xw5oHA5UXh6Tpf2anRehh5uHrN8N5kd0t/7QYL8L+xyEqDjlGsI
         IT6MFZrs1E0FiUmJhTMTdSAAzPXTuReRCoBt5v1vk/VSYrLHtCVUXoy3mkAAevVdcn7s
         H7cA==
X-Gm-Message-State: AOAM532uc+Wko+6Zam1pVS+vIIi5+PGZ0PL28+QVphWIUFFEndsAfqAs
        XnCOJ9xs62T4tYbVu3w+cLGK6bfedKbAv8tG62c=
X-Google-Smtp-Source: ABdhPJwaznKfmOxTLtAveZyBQZYs3wmQsxoswe+ADE4Q8C7khBExdTD01MPDzeI4NIKZCyDMEP1v1G9dPBVaeCkbeqQ=
X-Received: by 2002:a17:906:1149:: with SMTP id i9mr2250211eja.100.1592303926918;
 Tue, 16 Jun 2020 03:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592247564.git.dcaratti@redhat.com> <4a4a840333d6ba06042b9faf7e181048d5dc2433.1592247564.git.dcaratti@redhat.com>
 <CA+h21ho1x1-N+HyFXcy+pqdWcQioFWgRs0C+1h+kn6w8zHVUwQ@mail.gmail.com> <fd20899c60d96695060ecb782421133829f09bc2.camel@redhat.com>
In-Reply-To: <fd20899c60d96695060ecb782421133829f09bc2.camel@redhat.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 16 Jun 2020 13:38:35 +0300
Message-ID: <CA+h21hrCScMMA9cm0fhF+eLRWda403pX=t3PKRoBhkE8rrR-rw@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] net/sched: act_gate: fix configuration of the
 periodic timer
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Davide,

On Tue, 16 Jun 2020 at 13:13, Davide Caratti <dcaratti@redhat.com> wrote:
>
> hello Vladimir,
>
> thanks a lot for reviewing this.
>
> On Tue, 2020-06-16 at 00:55 +0300, Vladimir Oltean wrote:
>
> [...]
>
> > > diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> > > index 6775ccf355b0..3c529a4bcca5 100644
> > > --- a/net/sched/act_gate.c
> > > +++ b/net/sched/act_gate.c
> > > @@ -272,6 +272,27 @@ static int parse_gate_list(struct nlattr *list_attr,
> > >         return err;
> > >  }
> > >
> > > +static void gate_setup_timer(struct tcf_gate *gact, u64 basetime,
> > > +                            enum tk_offsets tko, s32 clockid,
> > > +                            bool do_init)
> > > +{
> > > +       if (!do_init) {
> > > +               if (basetime == gact->param.tcfg_basetime &&
> > > +                   tko == gact->tk_offset &&
> > > +                   clockid == gact->param.tcfg_clockid)
> > > +                       return;
> > > +
> > > +               spin_unlock_bh(&gact->tcf_lock);
> > > +               hrtimer_cancel(&gact->hitimer);
> > > +               spin_lock_bh(&gact->tcf_lock);
> >
> > I think it's horrible to do this just to get out of atomic context.
> > What if you split the "replace" functionality of gate_setup_timer into
> > a separate gate_cancel_timer function, which you could call earlier
> > (before taking the spin lock)?
>
> I think it would introduce the following 2 problems:
>
> problem #1) a race condition, see below:
>

I must have been living under a stone since I missed the entire
unlocked tc filter rework done by Vlad Buslov, I thought that
tcf_action_init always runs under rtnl. So it is clear now.

> > That change would look like this:
> > diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> > index 3c529a4bcca5..47c625a0e70c 100644
> > --- a/net/sched/act_gate.c
> > +++ b/net/sched/act_gate.c
> > @@ -273,19 +273,8 @@ static int parse_gate_list(struct nlattr *list_attr,
> >  }
> >
> >  static void gate_setup_timer(struct tcf_gate *gact, u64 basetime,
> > -                 enum tk_offsets tko, s32 clockid,
> > -                 bool do_init)
> > +                 enum tk_offsets tko, s32 clockid)
> >  {
> > -    if (!do_init) {
> > -        if (basetime == gact->param.tcfg_basetime &&
> > -            tko == gact->tk_offset &&
> > -            clockid == gact->param.tcfg_clockid)
> > -            return;
> > -
> > -        spin_unlock_bh(&gact->tcf_lock);
> > -        hrtimer_cancel(&gact->hitimer);
> > -        spin_lock_bh(&gact->tcf_lock);
> > -    }
> >      gact->param.tcfg_basetime = basetime;
> >      gact->param.tcfg_clockid = clockid;
> >      gact->tk_offset = tko;
> > @@ -293,6 +282,17 @@ static void gate_setup_timer(struct tcf_gate
> > *gact, u64 basetime,
> >      gact->hitimer.function = gate_timer_func;
> >  }
> >
> > +static void gate_cancel_timer(struct tcf_gate *gact, u64 basetime,
> > +                  enum tk_offsets tko, s32 clockid)
> > +{
> > +    if (basetime == gact->param.tcfg_basetime &&
> > +        tko == gact->tk_offset &&
> > +        clockid == gact->param.tcfg_clockid)
> > +        return;
> > +
> > +    hrtimer_cancel(&gact->hitimer);
> > +}
> > +
>
> the above function either cancels a timer, or does nothing: it depends on
> the value of the 3-ple {tcfg_basetime, tk_offset, tcfg_clockid}. If we run
> this function without holding tcf_lock, nobody will guarantee that
> {tcfg_basetime, tk_offset, tcfg_clockid} is not being concurrently
> rewritten by some other command like:
>
> # tc action replace action gate <parameters> index <x>
>
> >  static int tcf_gate_init(struct net *net, struct nlattr *nla,
> >               struct nlattr *est, struct tc_action **a,
> >               int ovr, int bind, bool rtnl_held,
> > @@ -381,6 +381,8 @@ static int tcf_gate_init(struct net *net, struct
> > nlattr *nla,
> >      gact = to_gate(*a);
> >      if (ret == ACT_P_CREATED)
> >          INIT_LIST_HEAD(&gact->param.entries);
> > +    else
> > +        gate_cancel_timer(gact, basetime, tk_offset, clockid);
> >
>
> IOW, the above line is racy unless we do spin_lock()/spin_unlock() around
> the
>
> if (<expression depending on gact-> members>)
>         return;
>
> statement before hrtimer_cancel(), which does not seem much different
> than what I did in gate_setup_timer().
>
> [...]
>
> > @@ -433,6 +448,11 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
> > >         if (goto_ch)
> > >                 tcf_chain_put_by_act(goto_ch);
> > >  release_idr:
> > > +       /* action is not in: hitimer can be inited without taking tcf_lock */
> > > +       if (ret == ACT_P_CREATED)
> > > +               gate_setup_timer(gact, gact->param.tcfg_basetime,
> > > +                                gact->tk_offset, gact->param.tcfg_clockid,
> > > +                                true);
>
> please note, here I felt the need to add a comment, because when ret ==
> ACT_P_CREATED the action is not inserted in any list, so there is no
> concurrent writer of gact-> members for that action.
>

Then please rephrase the comment. I had read it and it still wasn't
clear at all for me what you were talking about.

> > >         tcf_idr_release(*a, bind);
> > >         return err;
> > >  }
>
> problem #2) a functional issue that originates in how 'cycle_time' and
> 'entries' are validated (*). See below:
>
> On Tue, 2020-06-16 at 00:55 +0300, Vladimir Oltean wrote:
>
> > static int tcf_gate_init(struct net *net, struct nlattr *nla,
> >               struct nlattr *est, struct tc_action **a,
> >               int ovr, int bind, bool rtnl_held,
> > @@ -381,6 +381,8 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
> >      gact = to_gate(*a);
> >      if (ret == ACT_P_CREATED)
> >          INIT_LIST_HEAD(&gact->param.entries);
> > +    else
> > +        gate_cancel_timer(gact, basetime, tk_offset, clockid);
>
> here you propose to cancel the timer, but few lines after we have this:
>
> 385         err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
> 386         if (err < 0)
> 387                 goto release_idr;
> 388
>
> so, when users try the following commands:
>
> # tc action add action gate <good parameters> index 2
> # tc action replace action gate <other good parameters> goto chain 42 index 2
>
> and chain 42 does not exist, the second command will fail. But the timer
> is erroneously stopped, and never started again. So, the first rule is
> correctly inserted but it becomes no more functional after users try to
> replace it with another one having invalid control action.
>

Yes, correct.

> Moving the call to gate_cancel_timer() after the validation of the control
> action will not fix this problem, because 'cycle_time' and 'entries' are
> validated together, and with the spinlock taken. Because of this, we need
> to cancel that timer only when we know that we will not do
> tcf_idr_release() and return some error to the user.
>
> please let me know if you think my doubts are not well-founded.
>
> --
> davide
>
> (*) now that I see parse_gate_list() again, I noticed another potential
> issue with replace (that I need to verify first): apparently the list is
> not replaced, it's just "updated" with new entries appended at the end. I
> will try to write a fix for that (separate from this series).
>
>

I wonder, could you call tcf_gate_cleanup instead of just canceling the hrtimer?

Thanks,
-Vladimir

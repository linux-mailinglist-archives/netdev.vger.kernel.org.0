Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3082200BE
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 00:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgGNWeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 18:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgGNWeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 18:34:37 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F39C061755;
        Tue, 14 Jul 2020 15:34:36 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id j11so370127ljo.7;
        Tue, 14 Jul 2020 15:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vXZrLQFtz5v2+suQrG5NfcJNsztPODoreKLpAWy6NFg=;
        b=mtO5P/E9TDnkP6xog0ozP6YVVywTGS7uJuacD8e5+PUdTNBMwjdHZtRWlZ/rRJ25lQ
         eRKcTR9C5PSB02weeaaDe/h20yWzHKF/xjT5fV8ELPqw7gDnotG0BmHT8PwEzNY2iUWE
         WYm6O22R/LTkRBETp5jbn5euGUxBuJ2WpsO50FULHnjzdLPyvDvRaj8+H3Hea2tld/BU
         QafpY5oyOgyY9S1s5ppf+iBxiGVW10/MH0hP6iHzaBX0KfbfOckfdDuS3t1VLxJlswR5
         Th5tyLTFmTUqXgN/fV4lLBg70ptQNgTndsqhwlKOi9QCyfb4/3LL+MWpBCREwq28cdda
         wb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vXZrLQFtz5v2+suQrG5NfcJNsztPODoreKLpAWy6NFg=;
        b=Wdyp8WlVWrv98JqbNTMO2J6FCYKK8SNEL7dO0jh78aOFRUQktzwfkRnKSEN3Mblg2c
         ZeKun3SI8Hln61IiKjOeYwbki5DEK5uO/pKvp1pa7+spEmEBQzhViq7srydLGXynJvbQ
         TO8pOF4H/SnudZ6OVtbifQehqQg1ddUlxTevz0IEwy7LL1dyalmraE7Bp3EELy0dUYOY
         RlYLk5+/FJQz4cJhoOduDDheFMczFqYANrYnE8F/pjjPdNfncPLCbtfHJ/ZoGxnviChf
         fe3H/m2p8QMsafA9FkVQ8Z0WX/sDh3nProNLZMBAbOg9ANWMM1+DRnXGauYeaTReN61G
         qfSw==
X-Gm-Message-State: AOAM531OVjsXROvfSZZlLOrvFjQCqLArjS9VE6azfN15oJVC9UxdiGws
        bVDDuAU49KAwj0Pbr/tsj2aKkB35WJBh48ee6uw=
X-Google-Smtp-Source: ABdhPJw5ZWlAk0dAqCuNvTaOomLn7hq7+QABLIYcmKvdlxNjP1e2Wd7qczdHA1+xTLqF3cBC9Rr5WY3XNvCQwZK96Ok=
X-Received: by 2002:a2e:8357:: with SMTP id l23mr3098656ljh.290.1594766075296;
 Tue, 14 Jul 2020 15:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
 <20200702134930.4717-5-maciej.fijalkowski@intel.com> <20200710235632.lhn6edwf4a2l3kiz@ast-mbp.dhcp.thefacebook.com>
 <CAADnVQJhhQnjQdrQgMCsx2EDDwELkCvY7Zpfdi_SJUmH6VzZYw@mail.gmail.com>
 <CAADnVQ+AD0T_xqwk-fhoWV25iANs-FMCMVnn2-PALDxdODfepA@mail.gmail.com>
 <20200714010045.GB2435@ranger.igk.intel.com> <20200714033630.2fw5wzljbkkfle3j@ast-mbp.dhcp.thefacebook.com>
 <20200714205035.GA4423@ranger.igk.intel.com>
In-Reply-To: <20200714205035.GA4423@ranger.igk.intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Jul 2020 15:34:23 -0700
Message-ID: <CAADnVQ+Fma88nvHuk12UXc9SQGW4BwEe+phjw2B9Up0CgxcV8A@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 4/5] bpf, x64: rework pro/epilogue and
 tailcall handling in JIT
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 1:55 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Mon, Jul 13, 2020 at 08:36:30PM -0700, Alexei Starovoitov wrote:
> > On Tue, Jul 14, 2020 at 03:00:45AM +0200, Maciej Fijalkowski wrote:
> > > On Fri, Jul 10, 2020 at 08:25:20PM -0700, Alexei Starovoitov wrote:
> > > > On Fri, Jul 10, 2020 at 8:20 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > Of course you are right.
> > > > > pop+nop+push is incorrect.
> > > > >
> > > > > How about the following instead:
> > > > > - during JIT:
> > > > > emit_jump(to_skip_below)  <- poke->tailcall_bypass
> > >
> > > That's the jump to the instruction right after the poke->tailcall_target.
> >
> > right. Mainly looking for better names than ip and ip_aux.
> >
> > > > > pop_callee_regs
> > > > > emit_jump(to_tailcall_target) <- poke->tailcall_target
> > >
> > > During JIT there's no tailcall_target so this will be nop5, right?
> >
> > I thought it will be always jmp, but with new info I agree that
> > it will start with nop.
> >
> > >
> > > > >
> > > > > - Transition from one target to another:
> > > > > text_poke(poke->tailcall_target, MOD_JMP, old_jmp, new_jmp)
> > > > > if (new_jmp != NULL)
> > > > >   text_poke(poke->tailcall_bypass, MOD jmp into nop);
> > > > > else
> > > > >   text_poke(poke->tailcall_bypass, MOD nop into jmp);
> > > >
> > > > One more correction. I meant:
> > > >
> > > > if (new_jmp != NULL) {
> > > >   text_poke(poke->tailcall_target, MOD_JMP, old_jmp, new_jmp)
> > >
> > > Problem with having the old_jmp here is that you could have the
> > > tailcall_target removed followed by the new program being inserted. So for
> > > that case old_jmp is NULL but we decided to not poke the
> > > poke->tailcall_target when removing the program, only the tailcall_bypass
> > > is poked back to jmp from nop. IOW old_jmp is not equal to what
> > > poke->tailcall_target currently stores. This means that
> > > bpf_arch_text_poke() would not be successful for this update and that is
> > > the reason of faking it in this patch.
> >
> > got it.
> > I think it can be solved two ways:
> > 1. add synchronize_rcu() after poking of tailcall_bypass into jmp
> > and then update tailcall_target into nop.
> > so the race you've described in cover letter won't happen.
> > In the future with sleepable progs we'd need to call sync_rcu_tasks_trace too.
> > Which will make poke_run even slower.
> >
> > 2. add a flag to bpf_arch_text_poke() to ignore 5 bytes in there
> > and update tailcall_target to new jmp.
> > The speed of poke_run will be faster,
> > but considering the speed of text_poke_bp() it's starting to feel like
> > premature optimization.
> >
> > I think approach 1 is cleaner.
> > Then the pseudo code will be:
> > if (new_jmp != NULL) {
> >    text_poke(poke->tailcall_target, MOD_JMP, old ? old_jmp : NULL, new_jmp);
> >    if (!old)
> >      text_poke(poke->tailcall_bypass, MOD_JMP, bypass_addr, NULL /* into nop */);
> > } else {
> >    text_poke(poke->tailcall_bypass, MOD_JMP, NULL /* from nop */, bypass_addr);
> >    sync_rcu(); /* let progs finish */
> >    text_poke(poke->tailcall_target, MOD_JMP, old_jmp, NULL /* into nop */)
> > }
>
> Seems like this does the job :) clever stuff with sync_rcu.
> I tried this approach and one last thing that needs to be covered
> separately is the case of nop->nop update. We should simply avoid poking
> in this case. With this in place everything is functional.
>
> I will update the patch and descriptions and send the non-RFC revision, if
> you don't mind of course.

Yes. Please. Cannot wait actually :)

Please think through Daniel's comment in prog_array_map_poke_run().
Especially points 3 and 4. The new logic will be hitting the same cases,
but in a more elaborate way.
That comment also makes clear why memcmp(poke->ip, nop5...);
was not the correct approach... poke->ip address can be gone at that time.

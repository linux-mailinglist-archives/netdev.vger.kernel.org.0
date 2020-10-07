Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5D42857DE
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 06:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgJGEmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 00:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgJGEmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 00:42:32 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16892C061755;
        Tue,  6 Oct 2020 21:42:31 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x8so837178ybe.12;
        Tue, 06 Oct 2020 21:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ER3n4y5l+BIR7COGZq3W4AhY/HZv97oMqIkAEHsJQ0M=;
        b=XW6y6MH4AfHt8gLG/heOmCPwKGJ96C3ry3ZZN45Eh42jjwe8STuem7CbsbyAftZb7v
         GsJwOTdP3OydfULNM4RFn4Y+HCE8hiS7JacpQ4v3Q/8D18NwgNlHROAlhZWZxn/Xutl0
         Fd1UXHTPz5xGcxgl4VdcC2byhHV8Mb21QcQk4a/aTXwoyudk4N1zFmKCGsL+KOmZdYdO
         xIh6AJPGflI8I4lNX/pHopXf/1Njbwp/BFmhHGVR6Y5C+VZulKp9rpx1GBR+OUvSXLKx
         aFXlJ65Tn+/UUtHvx4A/koHADM79vBaQX1Ymype5cGxMcUWVyNfVWSA4aYfctZzw95Z2
         wv/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ER3n4y5l+BIR7COGZq3W4AhY/HZv97oMqIkAEHsJQ0M=;
        b=JurDaPnj2R3ICYZ8GoT3Sy6Rxwwjwf2hHmfVz3HtDEHJHc/9hc83fdJhss8tdjnQoz
         WtjfsqgLFBFYvT3KbUkwTPQDUhQEJSM5m89ZYKUC8XQZlotY1pIIEUq71AWkyiVhMaRi
         BiqMoQnXBdG3XqzFkMU4DieOfrxOqCInNOSOWs6Flsa89/PGPiBpBOdxCco6nLc5+tyI
         TzR17waHjqHCG2Z1RpbcNFnyiwX9u16FBg1iyc7moP1KUvgrFal+ekDjFx826n01zQTC
         U/kyUjalx9Vs5drkD5M/MqK1yy1SfgN57Aar0Zqw2EZMtVQn0iq1Xtv7jTkZg0AvtgGD
         7QTA==
X-Gm-Message-State: AOAM531O7gA8I0ycgIlmTv/0DRhlk+wKmnaSxplNZJw9glwIGc1R4u0J
        vqh1oGHqmIZmYvZ6djblHKZl8gd6vF6o1yfaA6OyUHmUMzjD2A==
X-Google-Smtp-Source: ABdhPJwLKpSvEz6xnehRQTsGUlVrdUYdkuw/X4/B0/VRYgdMJTgWH39T+YQJC/L1Hv1bpRuehrq8YQoqe0rTM1CB/xs=
X-Received: by 2002:a25:cbc4:: with SMTP id b187mr2056709ybg.260.1602045750305;
 Tue, 06 Oct 2020 21:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
 <20201006200955.12350-2-alexei.starovoitov@gmail.com> <CAEf4BzbRLLJ=r3LJfQbkkXtXgNqQL3Sr01ibhOaxNN-QDqiXdw@mail.gmail.com>
 <20201007021842.2lwngvsvj2hbuzh5@ast-mbp> <CAEf4Bza=7GzvXJinkwO1XcASg7ahHranmNRmXEzU-KzOg9wVCw@mail.gmail.com>
 <20201007041517.6wperlh6dqrk7xjc@ast-mbp>
In-Reply-To: <20201007041517.6wperlh6dqrk7xjc@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Oct 2020 21:42:18 -0700
Message-ID: <CAEf4BzY1kKrB-GRmMCvEVy64KhpT=jao7voQuvXkKw4woMe8cA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Propagate scalar ranges through
 register assignments.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 9:15 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Oct 06, 2020 at 08:31:23PM -0700, Andrii Nakryiko wrote:
> >
> > > 'linked' is also wrong. The regs are exactly equal.
> > > In case of pkt and other pointers two regs will have the same id
> > > as well, but they will not be equal. Here these two scalars are equal
> > > otherwise doing *reg = *known_reg would be wrong.
> >
> > Ok, I guess it also means that "reg->type == SCALAR_VALUE" checks
> > below are unnecessary as well, because if known_reg->id matches, that
> > means register states are exactly the same.
> > > > > +               for (j = 0; j < MAX_BPF_REG; j++) {
> > > > > +                       reg = &state->regs[j];
> > > > > +                       if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
>
> Right. The type check is technically unnecessary. It's a safety net in case id
> assignment goes wrong plus it makes it easier to understand the logic.
>
> > > > Even if yes, it probably would be more
> > > > straightforward to call appropriate updates in the respective if
> > > > branches (it's just a single line for each register, so not like it's
> > > > duplicating tons of code).
> > >
> > > You mean inside reg_set_min_max() and inside reg_combine_min_max() ?
> > > That won't work because find_equal_scalars() needs access to the whole
> > > bpf_verifier_state and not just bpf_reg_state.
> >
> > No, I meant something like this, few lines above:
> >
> > if (BPF_SRC(insn->code) == BPF_X) {
> >
> >     if (dst_reg->type == SCALAR_VALUE && src_reg->type == SCALAR_VALUE) {
> >         if (...)
> >         else if (...)
> >         else
> >
> >         /* both src/dst regs in both this/other branches could have
> > been updated */
> >         find_equal_scalars(this_branch, src_reg);
> >         find_equal_scalars(this_branch, dst_reg);
> >         find_equal_scalars(other_branch, &other_branch_regs[insn->src_reg])
> >         find_equal_scalars(other_branch, &other_branch_regs[insn->dst_reg])
> >     }
> > } else if (dst_reg->type == SCALAR_VALUE) {
> >     reg_set_min_max(...);
> >
> >     /* only dst_reg in both branches could have been updated */
> >     find_equal_scalars(this_branch, dst_reg);
> >     find_equal_scalars(other_branch, &other_branch_regs[insn->dst_reg]);
> > }
> >
> >
> > This keeps find_equal_scalars() for relevant registers very close to
> > places where those registers are updated, instead of jumping back and
> > forth between the complicated if  after it, and double-checking under
> > which circumstances dst_reg can be updated, for example.
>
> I see it differently.
> I don't like moving if (reg->id) into find_equal_scalars(). Otherwise it would
> have to be named something like try_find_equal_scalars(). And even with such
> "try_" prefix it's still not clean. It's my general dislike of defensive
> programming. I prefer all functions to be imperative: "do" vs "try_do".
> There are exception from the rule, of course. Like kfree() that accepts NULL.
> That's fine.
> In this case I think if (type == SCALAR && id != 0) should be done by the caller.

There is no need to do (type == SCALAR) check, see pseudo-code above.
In all cases where find_equal_scalars() is called we know already that
register is SCALAR.

As for `if (reg->id)` being moved inside find_equal_scalars(). I
didn't mean it as a defensive measure. It just allows to keep
higher-level logic in check_cond_jmp_op() a bit more linear.

Also, regarding "try_find_equal_scalars". It's not try/attempt to do
this, it's do it, similarly to __update_reg_bounds() you explained
below. It's just known_reg->id == 0 is a guarantee that there are no
other equal registers, so we can skip the work. But of course one can
look at this differently. I just prefer less nested ifs, if it's
possible to avoid them.

But all this is not that important. I suggested, you declined, let's move on.

> Note that's different from __update_reg_bounds().
> There the bounds may or may not change, but the action is performed.
> What you're proposing it to make find_equal_scalars() accept any kind
> of register and do the action only if argument is actual scalar
> and its "id != 0". That's exactly the defensive programming
> that I feel make programmers sloppier.

:) I see a little bit of an irony between this anti-defensive
programming manifesto and "safety net in case id assignment goes
wrong" above.

> Note that's not the same as mark_reg_unknown() doing
> if (WARN_ON(regno >= MAX_BPF_REG)) check. I hope the difference is clear.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FEA1E66FC
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404756AbgE1QAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 12:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404631AbgE1QAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 12:00:53 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B024AC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 09:00:52 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z6so33999876ljm.13
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 09:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V7dp6rzS6x1O2KraArYND1YNYDSnPlKvj/l9q8ANW2M=;
        b=dDyRT4i8r+B/Gn+xjS0J91srQt7Zklc6lRAuthOMgcJlBbNs8eRhgtKvN4qbuUAvmL
         EcgKk8u76clLN0MvXOWsNxPAikrDtUikTvbFeym5OCnEEN5CSd62tHc34KOCisnyDfK7
         41dLuT+iAJygsQy/zyVz1y958H+pJJ/s5KP5JN2A8c9CvYDE2Qk/Usy0srUtLpyeuv3a
         CK+m/kwSdQR8t7UrWiwGeINiDNhHLzeKQmr689fKeQZiu0J35/58kT2Y0LOY4pnG+q8+
         m5f7oEHN+wAOe79qnzRbgNuUkdqfpNlJnFv8s9t+viNj0vZrQXPfiMN3PAq3REWLjWVX
         DX1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V7dp6rzS6x1O2KraArYND1YNYDSnPlKvj/l9q8ANW2M=;
        b=hmeE53sK5FNs6IIswN7FFoW++trBihh0hF1mIexew8DA4GwHxDglTIV8k5w5NPxaGi
         Wz7CsiFQ52wQd1ItNh+EmzbzO7rFju6IgOXjoodIVrDexDcXT8JynsXb49MQRutVn3xh
         +gk7TCsUV4Bnb6Gu3eT+P3E5a/v15QN6vv/6AFYB1yvcqel+7oL3wUBSmbPVSXV/JwrL
         vhlqtoJI+FKLpFq8A9yLR7CdAgwIO6LoA8VT6HAPBl+V09is1Djk6cASJVVHKDn0cJNs
         0cmoezMExXNZRx6eVFK02pF/tNeqQruZy/y1mzQVwC2QFMuO7/2XQzjbs9qxZ/osk86l
         6MWw==
X-Gm-Message-State: AOAM532A9M6IKiDUJRfEgg8dILD1v9yEaHw01d0noeEdVr/u7jt3ym2E
        8MS2X0+tdPskStXU4A0+Nk1rl1vQiABO0ln7vNo=
X-Google-Smtp-Source: ABdhPJx6wbGnZO7HmGnB01FQsGpb/Szz9By832vy5x1WjaSDJzE7GzSdD1RFmibDwbL87Urr2wpDk8vl4GXhPP7bSsA=
X-Received: by 2002:a2e:87d2:: with SMTP id v18mr1944513ljj.121.1590681650965;
 Thu, 28 May 2020 09:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=W55uuPbpvjzCphgiMbmhnFmmWY=KcOGvmUv14_JOGc5g@mail.gmail.com>
 <20181213115936.GG21324@unicorn.suse.cz> <20181213122004.GH21324@unicorn.suse.cz>
 <CAG_fn=VSEw2NvrE=GE4f4H6CAD-6BjUQvz3W06nLmF8tg7CfBA@mail.gmail.com>
 <def5d586-3a8c-01b7-c6dd-bc284336b76e@iogearbox.net> <7bf9e46f-93a1-b6ff-7e75-53ace009c77c@iogearbox.net>
 <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com>
 <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
 <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
 <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
 <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com> <CAG_fn=Uvp2HmqHUZqEHtAWj8dG4j5ifqbGFQ2A3Jzv10bf-b9Q@mail.gmail.com>
In-Reply-To: <CAG_fn=Uvp2HmqHUZqEHtAWj8dG4j5ifqbGFQ2A3Jzv10bf-b9Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 28 May 2020 09:00:39 -0700
Message-ID: <CAADnVQ+2eLKh-s34ciNue-Jt5yL1MrS=LL8Zjfo0gkUkk8dDug@mail.gmail.com>
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Alexander Potapenko <glider@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 2:54 AM Alexander Potapenko <glider@google.com> wrote:
>
> On Wed, May 27, 2020 at 7:15 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, May 27, 2020 at 10:12 AM Alexander Potapenko <glider@google.com> wrote:
> > >
> > > On Wed, May 27, 2020 at 6:58 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Wed, May 27, 2020 at 8:52 AM Alexander Potapenko <glider@google.com> wrote:
> > > > >
> > > > > This basically means that BPF's output register was uninitialized when
> > > > > ___bpf_prog_run() returned.
> > > > >
> > > > > When I replace the lines initializing registers A and X in net/core/filter.c:
> > > > >
> > > > > -               *new_insn++ = BPF_ALU32_REG(BPF_XOR, BPF_REG_A, BPF_REG_A);
> > > > > -               *new_insn++ = BPF_ALU32_REG(BPF_XOR, BPF_REG_X, BPF_REG_X);
> > > > >
> > > > > with
> > > > >
> > > > > +               *new_insn++ = BPF_MOV32_IMM(BPF_REG_A, 0);
> > > > > +               *new_insn++ = BPF_MOV32_IMM(BPF_REG_X, 0);
> > > > >
> > > > > , the bug goes away, therefore I think it's being caused by XORing the
> > > > > initially uninitialized registers with themselves.
> > > > >
> > > > > kernel/bpf/core.c:1408, where the uninitialized value was stored to
> > > > > memory, points to the "ALU(ADD,  +)" macro in ___bpf_prog_run().
> > > > > But the debug info seems to be incorrect here: if I comment this line
> > > > > out and unroll the macro manually, KMSAN points to "ALU(SUB,  -)".
> > > > > Most certainly it's actually one of the XOR instruction declarations.
> > > > >
> > > > > Do you think it makes sense to use the UB-proof BPF_MOV32_IMM
> > > > > instructions to initialize the registers?
> > > >
> > > > I think it's better for UBsan to get smarter about xor-ing.
> > >
> > > Could you please elaborate on this? How exactly should KMSAN handle
> > > this situation?
> > > Note that despite the source says "BPF_ALU32_REG(BPF_XOR, BPF_REG_A,
> > > BPF_REG_A);", it doesn't necessarily boil down to an expression like A
> > > = A ^ A. It's more likely that temporary values will be involved,
> > > making it quite hard to figure out whether the two operands are really
> > > the same.
> >
> > I really don't know who to make it smarter. It's your area of expertise.
>
> The point I am trying to make is that BPF is relying on undefined
> behavior (see the quotations from C89 standard) here for no apparent
> reason.
> This code might be working with the current set of
> compilers/optimizations, but will it pay off to debug it when
> something breaks?

xoring of two identical values is undefined in standard?
If that's really true such standard worth nothing.

> The C implementation for BPF_XOR in kernel/bpf/core.c is translated to:
>   regs[insn->dst_reg] = regs[insn->dst_reg] ^ regs[insn->src_reg];
> , at which point the compiler already can't tell whether dst_reg and
> src_reg are the same.

of course. compile can use different cpu regs.

> In fact Clang may already generate unexpected code for such cases: see
> the assembly for foo3() in https://godbolt.org/z/VoMHaC.

"unexpected" meaning that xor has different regs?

> I therefore think it's better to fix the buggy code unless there are
> strong reasons not to do so, rather than teach the tool how to work
> around this particular bug.

The tool needs to do data flow analysis to realize that the source
data in different regs is the same, hence xoring them will produce zero.
That could be super hard to achieve in practice and will take years
of work to implement KMSAN, but that's what you have to do.

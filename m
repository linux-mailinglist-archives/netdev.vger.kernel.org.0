Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454041E5C72
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 11:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbgE1Jya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 05:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387440AbgE1Jy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 05:54:29 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B18EC05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 02:54:29 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s8so27138519wrt.9
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 02:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sFH6EFWO9TyfCB5KYu+ApiY1xDDQgbNzGUBQSX2bMWI=;
        b=m3k+3pm/hqBAZeyID/NRe5ev9q6pJb6VEtgZpaX1lilxml4wFXV8S1qsnwm1EzuBZJ
         ogRpfplXf641/XhpyyFfZoKGgonOUvMsbxcEWl/SKRHu/D6f813jEsyn33Jnx+CyzIiZ
         7l7NvsdrVyek5aAJY9MZnKlHtUP69xxncWiOgZVcS9GQRnXP2wYL7jOImwpIfD5iP3L9
         8ZsypOYF2oSzPoVa61UkInx9rK8jqn+mrTxciC7qUjrlhByN17MfdG+A1X+OCPY1d0TC
         Fh6Qj3BFCLtCsBe6CsFhJBwjE0EWk76KbwbwnMmciStEkc/54vR/Y1HTkQMfQOr4gXWh
         Ac/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sFH6EFWO9TyfCB5KYu+ApiY1xDDQgbNzGUBQSX2bMWI=;
        b=JmHvuC3sj4/J8k0X/0OakO+Q0IHoQVDr3tuBrEjXrp5JO6BTIwMILHByRs3YgINcbZ
         H6Q4mhg9lTjRr1Eyn3SnLxQ+4PzNMVy2dRDo8WCzKVDr3UJN3HVnFx4FzJ7K/qkWwJij
         End2JDR5/akhgP50bVJuA611a2eaHqUlYO+24LcbDPSiyhGskwTIO4xuefjAUBSS466N
         79nJg42Dm0XqPdIvkfOMdM/Fb5XMn0EXEfFT/Kv429FBdZGZXfMoThvlC1yVAzX51Ct0
         ij5UxBgFqzIe8s6bt6EhYECBf6691JeCdxyBZMWBE3+vmUMT09wjcLHujUR/A7qw2SUd
         OgWw==
X-Gm-Message-State: AOAM5328Cxhb9SQpRMUlJKrdcrr99HG1ARtWpy7yv+rgN9oipz2oSNgL
        iZehCjQNQdg7KQVI2lZETFpulqLwC0RNh9QugZ4mTw==
X-Google-Smtp-Source: ABdhPJydOFBNNBkqL/LBB5dtlhK64vOrFFvzS5bdkyZYtjZR7m+EJntGFnHmCdtQh/rzZlEIvWEa4euqKagYI6AjiG0=
X-Received: by 2002:adf:9b9e:: with SMTP id d30mr2807066wrc.345.1590659667756;
 Thu, 28 May 2020 02:54:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=W55uuPbpvjzCphgiMbmhnFmmWY=KcOGvmUv14_JOGc5g@mail.gmail.com>
 <20181213115936.GG21324@unicorn.suse.cz> <20181213122004.GH21324@unicorn.suse.cz>
 <CAG_fn=VSEw2NvrE=GE4f4H6CAD-6BjUQvz3W06nLmF8tg7CfBA@mail.gmail.com>
 <def5d586-3a8c-01b7-c6dd-bc284336b76e@iogearbox.net> <7bf9e46f-93a1-b6ff-7e75-53ace009c77c@iogearbox.net>
 <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com>
 <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
 <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
 <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com> <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com>
In-Reply-To: <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Thu, 28 May 2020 11:54:16 +0200
Message-ID: <CAG_fn=Uvp2HmqHUZqEHtAWj8dG4j5ifqbGFQ2A3Jzv10bf-b9Q@mail.gmail.com>
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 7:15 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, May 27, 2020 at 10:12 AM Alexander Potapenko <glider@google.com> =
wrote:
> >
> > On Wed, May 27, 2020 at 6:58 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, May 27, 2020 at 8:52 AM Alexander Potapenko <glider@google.co=
m> wrote:
> > > >
> > > > This basically means that BPF's output register was uninitialized w=
hen
> > > > ___bpf_prog_run() returned.
> > > >
> > > > When I replace the lines initializing registers A and X in net/core=
/filter.c:
> > > >
> > > > -               *new_insn++ =3D BPF_ALU32_REG(BPF_XOR, BPF_REG_A, B=
PF_REG_A);
> > > > -               *new_insn++ =3D BPF_ALU32_REG(BPF_XOR, BPF_REG_X, B=
PF_REG_X);
> > > >
> > > > with
> > > >
> > > > +               *new_insn++ =3D BPF_MOV32_IMM(BPF_REG_A, 0);
> > > > +               *new_insn++ =3D BPF_MOV32_IMM(BPF_REG_X, 0);
> > > >
> > > > , the bug goes away, therefore I think it's being caused by XORing =
the
> > > > initially uninitialized registers with themselves.
> > > >
> > > > kernel/bpf/core.c:1408, where the uninitialized value was stored to
> > > > memory, points to the "ALU(ADD,  +)" macro in ___bpf_prog_run().
> > > > But the debug info seems to be incorrect here: if I comment this li=
ne
> > > > out and unroll the macro manually, KMSAN points to "ALU(SUB,  -)".
> > > > Most certainly it's actually one of the XOR instruction declaration=
s.
> > > >
> > > > Do you think it makes sense to use the UB-proof BPF_MOV32_IMM
> > > > instructions to initialize the registers?
> > >
> > > I think it's better for UBsan to get smarter about xor-ing.
> >
> > Could you please elaborate on this? How exactly should KMSAN handle
> > this situation?
> > Note that despite the source says "BPF_ALU32_REG(BPF_XOR, BPF_REG_A,
> > BPF_REG_A);", it doesn't necessarily boil down to an expression like A
> > =3D A ^ A. It's more likely that temporary values will be involved,
> > making it quite hard to figure out whether the two operands are really
> > the same.
>
> I really don't know who to make it smarter. It's your area of expertise.

The point I am trying to make is that BPF is relying on undefined
behavior (see the quotations from C89 standard) here for no apparent
reason.
This code might be working with the current set of
compilers/optimizations, but will it pay off to debug it when
something breaks?

The C implementation for BPF_XOR in kernel/bpf/core.c is translated to:
  regs[insn->dst_reg] =3D regs[insn->dst_reg] ^ regs[insn->src_reg];
, at which point the compiler already can't tell whether dst_reg and
src_reg are the same.

In fact Clang may already generate unexpected code for such cases: see
the assembly for foo3() in https://godbolt.org/z/VoMHaC.

I therefore think it's better to fix the buggy code unless there are
strong reasons not to do so, rather than teach the tool how to work
around this particular bug.

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF911E4B9A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387708AbgE0RM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387476AbgE0RM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:12:58 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E15C03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:12:58 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l10so2058536wrr.10
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WqY7cizXXGsMVaJroiLPzVUybPi9E2RhTXUhz7jhHk0=;
        b=rhsHAfKbP502QjgpgDbEkj61Pl15Mnx+N+Opubpu5E3/8vk4ut48ixR8HFOj40H84w
         h6tM+s0vVW9iwNUzPbD7dVV9VwBIpXPf/0LRCmXtQzJRYffvMTOWCXNbgkv3VjHEzy6A
         bsmIPwAKzPjQanX5aQhvnFjIUMfDLzHKjZMrvDtz0/tIyVENn5myXb0eWBY7PWZrsEmB
         WTXpzoZO68vlLRzNMYL7mziwc69QHkFVIDdEsg3p6Bwf0vYYo+jpbhl5i/tdpQ9jZLB6
         l6uL+Vvq9fceKvjV+0wFVl0CPnWg1OdsJ+cjyyOgYx6wTmXb2SNad5jO5D609ENx2f6S
         zKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WqY7cizXXGsMVaJroiLPzVUybPi9E2RhTXUhz7jhHk0=;
        b=WQfxu9QXW1g6w9+HMukJ1AdVb60uSeZi8DztY28h3ZQuX9k2eMe8+BRpeBlND+f/ef
         VuVZRVNgKA829e7PfjdyTXWwZVovcPrh2sCHeYh0oiRR0JDRUCF9lB00hZlvkh2AEFUg
         yKozesYQcsTZk/+j7K1S+fpPIde8Y9YfzO7IiB70QoI0v97dIOQNqBSDe8sCMSPfcEbQ
         0OokxsrL/FiXk5mSWBIbVG9QFiSGKDWl7lLrB6oxRaYk4JwjMov/rdmRrDm6+5eU0DuC
         zlcIfWPDFoxVUK5abW1gVURoUw6o9NBxUGsuLAgmawDOi226Qvc73D28sB5+PPqCNKK4
         2FVA==
X-Gm-Message-State: AOAM532XEYzT/S0aETMlWdlNLLBDWX28dWk9HbN+x/nN88yE8I4SuCdb
        xv/uLzJeg/m+D8k6dbJnzAtOPL/KaOHvz+e7DubAXX7kl1o=
X-Google-Smtp-Source: ABdhPJyTlDgHHNfoaIxbU8IbM5uMbpJA27aUqHT2fmwPO/FKwY1XyxONVG+HPc7BE6mdKDtY4vHeBP7E/JzTek+YYWU=
X-Received: by 2002:a5d:4282:: with SMTP id k2mr18901506wrq.196.1590599576856;
 Wed, 27 May 2020 10:12:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=W55uuPbpvjzCphgiMbmhnFmmWY=KcOGvmUv14_JOGc5g@mail.gmail.com>
 <20181213115936.GG21324@unicorn.suse.cz> <20181213122004.GH21324@unicorn.suse.cz>
 <CAG_fn=VSEw2NvrE=GE4f4H6CAD-6BjUQvz3W06nLmF8tg7CfBA@mail.gmail.com>
 <def5d586-3a8c-01b7-c6dd-bc284336b76e@iogearbox.net> <7bf9e46f-93a1-b6ff-7e75-53ace009c77c@iogearbox.net>
 <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com>
 <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com> <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
In-Reply-To: <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 27 May 2020 19:12:45 +0200
Message-ID: <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
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

On Wed, May 27, 2020 at 6:58 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, May 27, 2020 at 8:52 AM Alexander Potapenko <glider@google.com> w=
rote:
> >
> > This basically means that BPF's output register was uninitialized when
> > ___bpf_prog_run() returned.
> >
> > When I replace the lines initializing registers A and X in net/core/fil=
ter.c:
> >
> > -               *new_insn++ =3D BPF_ALU32_REG(BPF_XOR, BPF_REG_A, BPF_R=
EG_A);
> > -               *new_insn++ =3D BPF_ALU32_REG(BPF_XOR, BPF_REG_X, BPF_R=
EG_X);
> >
> > with
> >
> > +               *new_insn++ =3D BPF_MOV32_IMM(BPF_REG_A, 0);
> > +               *new_insn++ =3D BPF_MOV32_IMM(BPF_REG_X, 0);
> >
> > , the bug goes away, therefore I think it's being caused by XORing the
> > initially uninitialized registers with themselves.
> >
> > kernel/bpf/core.c:1408, where the uninitialized value was stored to
> > memory, points to the "ALU(ADD,  +)" macro in ___bpf_prog_run().
> > But the debug info seems to be incorrect here: if I comment this line
> > out and unroll the macro manually, KMSAN points to "ALU(SUB,  -)".
> > Most certainly it's actually one of the XOR instruction declarations.
> >
> > Do you think it makes sense to use the UB-proof BPF_MOV32_IMM
> > instructions to initialize the registers?
>
> I think it's better for UBsan to get smarter about xor-ing.

Could you please elaborate on this? How exactly should KMSAN handle
this situation?
Note that despite the source says "BPF_ALU32_REG(BPF_XOR, BPF_REG_A,
BPF_REG_A);", it doesn't necessarily boil down to an expression like A
=3D A ^ A. It's more likely that temporary values will be involved,
making it quite hard to figure out whether the two operands are really
the same.
For an expression like A =3D B ^ C, KMSAN just calculates A's shadow
bits based on the values and the shadow bits of B and C. If either B
or C is uninitialized, the result will be uninitialized as well, even
if both B and C contain the same values. It's therefore strange to
expect the tool to behave differently if B and C are the same
variable.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

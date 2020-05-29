Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA9A1E7D32
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgE2M3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgE2M3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 08:29:03 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C9AC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 05:29:02 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r15so3236639wmh.5
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 05:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yxrQ2UP0oEnu1k3J5ESX+oC77Elnrf5ioiNHQESPeNw=;
        b=aQtRq7CCZAv8h5cjnrdzQ3E18EdiNJnG2Xo3m1dfEslqlfCyAA/CvVcwz9wH0SsZ1R
         hoQ/A5yJts3COwwTiX0JGsj4UdR/rh+zxhvdYZF2mflTFaaXp7Z1jH9eQQmgT8y/pXYr
         2ZRdsbHIhC8u4O9+KaVNrQijYLV+2ZkxNO9U/CwX/a85JsfzZco9RDY3cerDBPKbiTMs
         5JmimnqFtz5AQ9KQMHgHy5yO201v4x4A/teFRkde02K25pNiSjboxNRkUdB3t7UOsIMR
         u1RdjmDMZXiOOiZ4S6jSCfZX9iY4kqFrClaCYy0qo0ucDjuyMleAbtobX+UTARuBf/2Z
         S/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yxrQ2UP0oEnu1k3J5ESX+oC77Elnrf5ioiNHQESPeNw=;
        b=cdvh0zZAA6mvhEnZlrCLL/eu2qOICi8PgW2SbzU2WgQ/skUJtIv5FMQvbKRS3/IU45
         xvNj5lwfUDH9L3IxMmAQrn41rkeGANLkObqzP6d30Q+0hhm2silZdli1wpsdUubKuT3+
         OWqEM7fxN9sVcvFiuqvIfY/PjA698WnsZoRho+Rxo9PNrCTcf7orT0rmh0wYQzaEjbx3
         LDOEJrDjPXFEcxM32xh7DNdVFZQq70KlZy6WV9k5PGZl4rtsrvpuKYLw6qtYkTjKZWBy
         Si7yrAruEXyMv8oJ9DxGtmPU1+iKGPY4fhuWl7cqPDrvyXIO0LdCNHx5948n/Jexq5mf
         uw3A==
X-Gm-Message-State: AOAM530eEbEZ3y1z5MaSc3Neu0N4ryTPQ+g8aujIZGnXXgr178H6U2I/
        OPdr41tnkIFLJUsaMTFkXXA9hihz94M6w2pGbYaeoQ==
X-Google-Smtp-Source: ABdhPJxQbbTuUtDUbR4sMZsS3EyDdxoSmRvhaDevYGlvd+ug6X0C4BhZ+miwCcQLihDb1dxga0t9fEYUMyTJKAIw5d8=
X-Received: by 2002:a1c:64c1:: with SMTP id y184mr8227609wmb.175.1590755340832;
 Fri, 29 May 2020 05:29:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=W55uuPbpvjzCphgiMbmhnFmmWY=KcOGvmUv14_JOGc5g@mail.gmail.com>
 <20181213115936.GG21324@unicorn.suse.cz> <20181213122004.GH21324@unicorn.suse.cz>
 <CAG_fn=VSEw2NvrE=GE4f4H6CAD-6BjUQvz3W06nLmF8tg7CfBA@mail.gmail.com>
 <def5d586-3a8c-01b7-c6dd-bc284336b76e@iogearbox.net> <7bf9e46f-93a1-b6ff-7e75-53ace009c77c@iogearbox.net>
 <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com>
 <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
 <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
 <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
 <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com>
 <CAG_fn=Uvp2HmqHUZqEHtAWj8dG4j5ifqbGFQ2A3Jzv10bf-b9Q@mail.gmail.com>
 <CAADnVQ+2eLKh-s34ciNue-Jt5yL1MrS=LL8Zjfo0gkUkk8dDug@mail.gmail.com> <984adc13-568e-8195-da1a-05135dbf954f@solarflare.com>
In-Reply-To: <984adc13-568e-8195-da1a-05135dbf954f@solarflare.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 29 May 2020 14:28:48 +0200
Message-ID: <CAG_fn=WaYz5LOyuteF5LAkgFbj8cpgNQyO1ReORTAiCbyGuNQg@mail.gmail.com>
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Fri, May 29, 2020 at 2:17 AM Edward Cree <ecree@solarflare.com> wrote:
>
> On 28/05/2020 17:00, Alexei Starovoitov wrote:
> > xoring of two identical values is undefined in standard?
> I believe it is in this case, yes; even without the complication
>  of array references that happen to alias, Alexander's foo1() is
>  undefined behaviour under C89 (and also C99 which handles the
>  case differently).
>
> From the definitions section (1.6) of the C89 draft [1]:
> > * Undefined behavior --- behavior, upon use of a nonportable or
> > erroneous program construct, of erroneous data, or of
> > indeterminately-valued objects, for which the Standard imposes
> > no requirements.
> And from 3.5.7 'Initialization':
> > If an object that has automatic storage duration is not
> > initialized explicitly, its value is indeterminate.
> Since the standard doesn't say anything about self-XORing that
>  could make it 'special' in this regard, the compiler isn't
>  required to notice that it's a self-XOR, and (in the tradition
>  of compiler-writers the world over) is entitled to optimise the
>  program based on the assumption that the programmer has not
>  committed UB, so in the foo1() example would be strictly within
>  its rights to generate a binary that contained no XOR
>  instruction at all.  UB, as you surely know, isn't guaranteed to
>  do something 'sensible'.
> And in the BPF example, if the compiler at some point manages to
>  statically figure out that regs[insn->dst_reg] is uninitialised,
>  it might say "hey, I can just grab any old free register and
>  declare that that's now regs[insn->dst_reg] without filling it.
>  And then it can do the same for regs[insn->src_reg], or heck,
>  even choose to fill that one (this is now legal even though the
>  pointers alias, because you already committed UB), and do a xor
>  with different regs and produce garbage results.

Thanks for this writeup!

> Is this annoying?  Extremely; the XOR-clearing _would_ be fine
>  if the standard had chosen to define things differently (e.g.
>  it's fine under a hypothetical 'C99 but uninitialised auto
>  variables have unspecified rather than indeterminate values').

I wouldn't call this particular use case "extremely annoying". I think
so far this is the only case of initializing something by XOR we've
seen with both MSan and KMSAN.

> I can't see a way to work around it that doesn't have a possible
>  performance cost (alternatives to Alexander's MOV_IMM 0 include
>  initialising regs[BPF_REG_A] and regs[BPF_REG_X] in PROG_NAME
>  and PROG_NAME_ARGS), although there is the question of whether
>  anyone who cares about performance (or security) will be using
>  BPF without the JIT anyway.

If I understand correctly, these two instructions are only executed
once per program.
Are they really expected to impact performance that much?

It's also an interesting question whether the JIT compiler emits
consistently better code for BPF_XOR than for MOV_IMM 0 on every
architecture - while "xorl %rax, %rax" is probably shorter and faster
on X86, on ARM a better alternative would be "mov w0, wzr".
If the performance is really critical here, perhaps a better
alternative is to introduce a BPF instruction (which could be an alias
of BPF_XOR REG, REG) for zeroing out a register? Then different
architectures may choose more efficient implementations for it, and
the interpreter will be just assigning zero to the register without
violating the C standard.

> But I don't think "Alexandar has to do the data-flow analysis in
>  KMSAN" is the right answer; KMSAN's diagnostic here is _correct_
>  in that ___bpf_prog_run() invokes UB on this XOR.
> Now, since it would be rather difficult and pointless for the
>  compiler to statically prove that the reg is uninitialised (it
>  would need to generate a special code-path just for this one
>  case)

The godbolt link above actually shows a case (foo3()) in which Clang
knows that a local is uninitialized and transforms it into a special
`undef` value that can be then e.g. passed around and take part in
various optimizations, making them more efficient.
I don't have evidence that such a transformation is currently possible
for the BPF code in question, but all the building blocks are there,
so it's probably just a matter of time.

>, maybe the best thing to do is to get GCC folks to bless
>  this usage (perhaps defining uninitialised variables to have
>  what C99 would call an unspecified value), at which point it
>  becomes defined under the "gnu89" pseudo-standard which is what
>  we compile the kernel with.

Given the increased popularity of Clang in the kernel these days, I
don't think it's a good idea for a single compiler to further diverge
from the standard. Again, this code pattern doesn't really seem to be
popular enough to justify such a change.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

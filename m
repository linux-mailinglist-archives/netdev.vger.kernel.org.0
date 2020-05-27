Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B461E4BA2
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731279AbgE0RPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731267AbgE0RPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:15:04 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372D6C03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:15:04 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id c11so27728659ljn.2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UNIt43rX3PyXlyMFdSJ0pcmmMD82HyVF3m6TOY3t6UA=;
        b=KPOUujfXSj8NaoCr7ikIzOosknSsvSK31in2KwDs2lOJ8y1ievjNZzH2gtjHsrI1yS
         aL1P2Y3es+77MtZNghfegkngIpXxQbzgDSeQ0zk/mfunUjCEVxVWJS68UDEf8bF/peyx
         ta1Emm0duPh1Pc/gJ+WCsVT7jmnmauIOkfgi5txcwnpMGYNlZdMuFlls4uBk6czmI8bW
         MGYX6QcM6K9q702lv7b4OWaxhl1i5a7WULSjLtzdYs7JoO30Y6dvQ3u6x2Zfej39JKdq
         3lm8xXVBVeiUYCJy0ta2/rhXCtZR5d7ElqMldTC9dUfhnLNkleeDBQfMDF/Bt3kTGyvF
         cZaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UNIt43rX3PyXlyMFdSJ0pcmmMD82HyVF3m6TOY3t6UA=;
        b=JvRG1gpRVhi5uTUK5hW5aj4xFwZW9Pb6vbN3qvVHSIJzxKyvUj79GScmGy5eDXCSkz
         AhICMVyXRSzIGSAjhz20FibYhbrfuJwZJgPtaWtS+NS4ExT4JK6QWOoM5eSkbbl4w0NX
         ODhVMPvZ4C2algoENYNR+mm9d6UJueVa7w767bmEmNOtYMf6VM1XLfbLxvt97jglDw00
         GI0ipUdGWViUZgy+wgydArBTkfyMC7DA0By9JCnlY+whuPEwEKwFMnkF/wst0LTZysV/
         V4kGDF8PBl5Bht/Si2m0cxusQIJyzqStclMylaSPQyW+Ll0cPIn1jz0UuQvTQrhyzatA
         2prQ==
X-Gm-Message-State: AOAM533ov0PoU0s40Ffho/rExHvqSsFGlECcPaskFHyqFHtwfDD/AYjt
        XilqMv56HDO3FYcCiGVkiHse57AGDcFdjda4Oj8=
X-Google-Smtp-Source: ABdhPJxn3ss3qDrpaym4Gt27SDVHfdDYfL9V+Tizp3f/paeEZpFlwwDEYWWEWWuvVd4eFGgYtkhsogKaExl9ova8sIU=
X-Received: by 2002:a2e:9b89:: with SMTP id z9mr3291194lji.51.1590599702607;
 Wed, 27 May 2020 10:15:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=W55uuPbpvjzCphgiMbmhnFmmWY=KcOGvmUv14_JOGc5g@mail.gmail.com>
 <20181213115936.GG21324@unicorn.suse.cz> <20181213122004.GH21324@unicorn.suse.cz>
 <CAG_fn=VSEw2NvrE=GE4f4H6CAD-6BjUQvz3W06nLmF8tg7CfBA@mail.gmail.com>
 <def5d586-3a8c-01b7-c6dd-bc284336b76e@iogearbox.net> <7bf9e46f-93a1-b6ff-7e75-53ace009c77c@iogearbox.net>
 <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com>
 <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
 <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com> <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
In-Reply-To: <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 May 2020 10:14:51 -0700
Message-ID: <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com>
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

On Wed, May 27, 2020 at 10:12 AM Alexander Potapenko <glider@google.com> wrote:
>
> On Wed, May 27, 2020 at 6:58 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, May 27, 2020 at 8:52 AM Alexander Potapenko <glider@google.com> wrote:
> > >
> > > This basically means that BPF's output register was uninitialized when
> > > ___bpf_prog_run() returned.
> > >
> > > When I replace the lines initializing registers A and X in net/core/filter.c:
> > >
> > > -               *new_insn++ = BPF_ALU32_REG(BPF_XOR, BPF_REG_A, BPF_REG_A);
> > > -               *new_insn++ = BPF_ALU32_REG(BPF_XOR, BPF_REG_X, BPF_REG_X);
> > >
> > > with
> > >
> > > +               *new_insn++ = BPF_MOV32_IMM(BPF_REG_A, 0);
> > > +               *new_insn++ = BPF_MOV32_IMM(BPF_REG_X, 0);
> > >
> > > , the bug goes away, therefore I think it's being caused by XORing the
> > > initially uninitialized registers with themselves.
> > >
> > > kernel/bpf/core.c:1408, where the uninitialized value was stored to
> > > memory, points to the "ALU(ADD,  +)" macro in ___bpf_prog_run().
> > > But the debug info seems to be incorrect here: if I comment this line
> > > out and unroll the macro manually, KMSAN points to "ALU(SUB,  -)".
> > > Most certainly it's actually one of the XOR instruction declarations.
> > >
> > > Do you think it makes sense to use the UB-proof BPF_MOV32_IMM
> > > instructions to initialize the registers?
> >
> > I think it's better for UBsan to get smarter about xor-ing.
>
> Could you please elaborate on this? How exactly should KMSAN handle
> this situation?
> Note that despite the source says "BPF_ALU32_REG(BPF_XOR, BPF_REG_A,
> BPF_REG_A);", it doesn't necessarily boil down to an expression like A
> = A ^ A. It's more likely that temporary values will be involved,
> making it quite hard to figure out whether the two operands are really
> the same.

I really don't know who to make it smarter. It's your area of expertise.

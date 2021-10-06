Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0483424518
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 19:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237771AbhJFRrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238765AbhJFRrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 13:47:08 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E317C061798;
        Wed,  6 Oct 2021 10:45:06 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id z5so7303744ybj.2;
        Wed, 06 Oct 2021 10:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yUAhWWREq+KTPxTHjWP93XTvKmvn8zB+TkkHmXcIk7Y=;
        b=BFSxqjjaLTV/i8fuipePV35wuls0Wf1qwh9pBWovLyyDIqXeveg2cKTO9k1moOb7jY
         cLYtI/8BouMk/NTXUsQOU56g9nXKXN4OfCyBn3qugBx2eBjUx6w8npy/Z2PjEbdEaicc
         ocd2XngVI42Jip+yhYBo7uJg4WzgqJQfyENLTVTkQA5bhobJeXamPmpyPBLbhQ6fKGuP
         /DfGAxxjuX54a3RvUej6rEw1ONvJjIFRY3OquJM3/G7LlvOhvF0Rf+8GTqvaa0LPIpBH
         5RIExihGA41FEUCny+Eoc0hxmxW6Vu6O/sKYQvWqzrmVA3nUn6XKP/mIjvYcuBedwm5D
         Setw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yUAhWWREq+KTPxTHjWP93XTvKmvn8zB+TkkHmXcIk7Y=;
        b=GWAiF3pduNlgTw/ZUR1O2FDZ+KnmGSrhFuYPOziNpa8EMiB5vPTMjgZOZuEeirwHsx
         WuuGBN2NTOCrB8QyEgbAppabHZNRv3UAb9TEomh9BDN32Dvc5ueK9xr7s0F2m+nC4fvz
         KRlRmSXjSaHhwNPg7FWJ4J2aXoaYoIt7ptYPZlcTC+NlQaYHT7CmRb3NzDQcCRt5tlUE
         Dvsd3cf4QUJRqN2KZorLFSsighG5dUlYcs0gKjuw+Xo6c3ttcln+Izb0qFT8XWHJ1gzS
         07YpULYlNKA/roQM+r9wUoNB4rffSSlRlCXGlU8WmE6LGkB84cQRcZ2eXe/+lLo1C5PO
         nBIQ==
X-Gm-Message-State: AOAM5314Cggbg/M4WF6aVdCD7fwWgET6uLz6lDUawdIZWRQCnydq5u5d
        gZtHizpvCSnCAMVgIIZPtzs8AfsHof35WiOq4oB3tHdg2a/orw==
X-Google-Smtp-Source: ABdhPJzi/Dzb2RvxChglQD1B5hEIO02tySEuasHROV+b1p8NF1RH2LC8QD6G1hr5QAbfobFaLyXQ9ePtAeQ7F3ILFIk=
X-Received: by 2002:a25:7c42:: with SMTP id x63mr32260967ybc.225.1633542305804;
 Wed, 06 Oct 2021 10:45:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <20211001110856.14730-7-quentin@isovalent.com>
 <CAEf4BzYm_QTq+u5tUp71+wY+JAaiUApv35tSqFUEyc81yOeUzw@mail.gmail.com>
 <CACdoK4LL91u-JK1fZ3XvkrTXsKBVsN-y1Js4QSPkWyS51KPB8Q@mail.gmail.com>
 <CACdoK4K4-x4+ZWXyB697Kn8RK5AyoCST+V7Lhtk_Kaqm5uQ6wg@mail.gmail.com>
 <CAEf4Bzb=jP3kU6O6QhZR6pcYn-7bkP8fr5ZDirWzf46WKEWA8Q@mail.gmail.com>
 <CACdoK4JpgKyeFAwwY=8V-WQO405-xkW+yS2qnfVv2tgoF-F3JA@mail.gmail.com> <CACdoK4KC2Y69Sj2KmEFHtZctWeZfvUnckRY4Q1hpomHHr0CfDA@mail.gmail.com>
In-Reply-To: <CACdoK4KC2Y69Sj2KmEFHtZctWeZfvUnckRY4Q1hpomHHr0CfDA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 10:44:54 -0700
Message-ID: <CAEf4BzaG5Xs9Z3JC3e3fZORnkxByNd0_-MbjDWx1qNr9eBZGOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/9] bpf: iterators: install libbpf headers
 when building
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 1:03 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On Mon, 4 Oct 2021 at 22:30, Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > On Mon, 4 Oct 2021 at 20:11, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Sat, Oct 2, 2021 at 3:12 PM Quentin Monnet <quentin@isovalent.com> wrote:
> > > >
> > > > On Sat, 2 Oct 2021 at 21:27, Quentin Monnet <quentin@isovalent.com> wrote:
> > > > >
> > > > > On Sat, 2 Oct 2021 at 00:20, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > > > >
> > > > > > On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
> > > > > > >
> > > > > > > API headers from libbpf should not be accessed directly from the
> > > > > > > library's source directory. Instead, they should be exported with "make
> > > > > > > install_headers". Let's make sure that bpf/preload/iterators/Makefile
> > > > > > > installs the headers properly when building.
> > > > >
> > > > > > >
> > > > > > > -$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
> > > > > > > +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)            \
> > > > > > > +          | $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE)
> > > > > >
> > > > > > Would it make sense for libbpf's Makefile to create include and output
> > > > > > directories on its own? We wouldn't need to have these order-only
> > > > > > dependencies everywhere, right?
> > > > >
> > > > > Good point, I'll have a look at it.
> > > > > Quentin
> > > >
> > > > So libbpf already creates the include (and parent $(DESTDIR))
> > > > directory, so I can get rid of the related dependencies. But I don't
> > > > see an easy solution for the output directory for the object files.
> > > > The issue is that libbpf's Makefile includes
> > > > tools/scripts/Makefile.include, which checks $(OUTPUT) and errors out
> > >
> > > Did you check what benefits the use of tools/scripts/Makefile.include
> > > brings? Last time I had to deal with some non-trivial Makefile
> > > problem, this extra dance with tools/scripts/Makefile.include and some
> > > related complexities didn't seem very justified. So unless there are
> > > some very big benefits to having tool's Makefile.include included, I'd
> > > rather simplify libbpf's in-kernel Makefile and make it more
> > > straightforward. We have a completely independent separate Makefile
> > > for libbpf in Github, and I think it's more straightforward. Doesn't
> > > have to be done in this change, of course, but I was curious to hear
> > > your thoughts given you seem to have spent tons of time on this
> > > already.
> >
> > No, I haven't checked in details so far. I remember that several
> > elements defined in the Makefile.include are used in libbpf's
> > Makefile, and I stopped at that, because I thought that a refactoring
> > of the latter would be beyond the current set. But yes, I can have a
> > look at it and see if it's worth changing in a follow-up.
>
> Looking more at tools/scripts/Makefile.include: It's 160-line long and
> does not include any other Makefile, so there's nothing in it that we
> couldn't re-implement in libbpf's Makefile if necessary. This being
> said, it has a number of items that, I think, are good to keep there
> and share with the other tools. For example:
>
> - The $(EXTRA_WARNINGS) definitions
> - QUIET_GEN, QUIET_LINK, QUIET_CLEAN, which are not mandatory to have
> but integrate nicely with the way other tools (or kernel components)
> are built
> - Some overwrites for the toolchain, if $(LLVM) or $(CROSS_COMPILE) are set
>

I looked at Makefile again, I had bigger reservations about
tools/build/Makefile.include actually, as it causes some round-about
ways to do the actual build, e.g.:

$(Q)$(MAKE) $(build)=libbpf OUTPUT=$(SHARED_OBJDIR) CFLAGS="$(CFLAGS)
$(SHLIB_FLAGS)"

Like, what's going on here? What's $(build)? Everything can be
deciphered, but a simple operation of compiling one file at a time
becomes some maze of indirect make invocations... But that's a problem
for another day. So never mind.


> Thinking more about this, if we want to create the $(OUTPUT) directory
> in libbpf itself, we could maybe just enclose the check on its
> pre-existence in tools/scripts/Makefile.include with a dedicated
> variable ("ifneq ($(_skip_output_check),) ...") and set the latter in
> Makefile.include. This way we wouldn't have to change the current
> Makefile infra too much, and can keep the include.

_skip_output_check to bifurcate the behavior? I'd rather not.

>
> Quentin

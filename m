Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2261742313E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 22:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhJEUF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 16:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbhJEUF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 16:05:27 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50ADC06174E
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 13:03:35 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id y14so496091vsm.9
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 13:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UUkXRCv5i94LaT1bKu68VJnO8Ng6U39KvQpxaI5oMis=;
        b=VnBAcWCOEFshe2ikd3LGdzGwkowOOOx0e+HQ8J6uZaTfWsDIEdro0peWHE0Mt68rRp
         0wl8GYPnPoO9luisuZdXR1csL6ydx/WYsxMaLTkqiedTfTu3x+97p7KpTnr/mBBd/k/x
         GRy7PmkhnuAGPAG6BnwEUN2ytss3y+xVH4DffHiYq90fc+vavfK4LV6QL8TQsT80wLJn
         hHvPO2B3tyn1Xvvmp0oGNaTMVWP72xo3w/6bJBLk5InSnjJ5kQbq3q2KGkl56DXuhkmA
         0/bybzIOsZ54xdHy8/wSCUAIgQ0mZu5O4iUD7ffJIFX5ETS33kZPEeBYT4eajbfRo4im
         UbQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UUkXRCv5i94LaT1bKu68VJnO8Ng6U39KvQpxaI5oMis=;
        b=8GSag4VcJXbdsD+MVxM90ml0YeGT30jzAjggKBu1mZmKOAZUR3b3CteqYy90Y4nHkD
         DOTKd1JrrnNFxUQmuE+bW2zd0U/h/7WXolaxyfMwm8YDzLotv6bJMlkAYP1zzyvv+ATi
         oU0rLEAyyLJhq17CYUiX8VsgFPacdBP2F2cQQV6uZ2JzLuasA8l4Bhgbwt6k2uSeWGoJ
         cdt1JFMmmvCmidi7EpxapvRRviz8WnlJbNHTZy8RMU6fzVZ7aHlPPSTR2lTvFlVz7OFI
         pA8dTwOZbTbKQsYBddXB6ocITgw88jBl65K95swSv/zAB6SuABmM/kSBFxCL1QTFiDqe
         Yw4Q==
X-Gm-Message-State: AOAM530Xj+WuU6vkkQtkH4EfXcXp5MQ/Ot+Hr53cufV6mk00++wwxNTG
        wZiYa0OO4xbZTn0VzuYpqW7iVaa3tLJ9VCPYGwi/BiASev7QoA==
X-Google-Smtp-Source: ABdhPJxlirsRB/ttYrKnjt0r3awHnCZi40aESR/AROiJYpZ3iDs8iGF5jLAaoOAUVK7YouqYF0TlJYvj/JQn8+lUuDM=
X-Received: by 2002:a67:d08f:: with SMTP id s15mr21422546vsi.54.1633464214840;
 Tue, 05 Oct 2021 13:03:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <20211001110856.14730-7-quentin@isovalent.com>
 <CAEf4BzYm_QTq+u5tUp71+wY+JAaiUApv35tSqFUEyc81yOeUzw@mail.gmail.com>
 <CACdoK4LL91u-JK1fZ3XvkrTXsKBVsN-y1Js4QSPkWyS51KPB8Q@mail.gmail.com>
 <CACdoK4K4-x4+ZWXyB697Kn8RK5AyoCST+V7Lhtk_Kaqm5uQ6wg@mail.gmail.com>
 <CAEf4Bzb=jP3kU6O6QhZR6pcYn-7bkP8fr5ZDirWzf46WKEWA8Q@mail.gmail.com> <CACdoK4JpgKyeFAwwY=8V-WQO405-xkW+yS2qnfVv2tgoF-F3JA@mail.gmail.com>
In-Reply-To: <CACdoK4JpgKyeFAwwY=8V-WQO405-xkW+yS2qnfVv2tgoF-F3JA@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Tue, 5 Oct 2021 21:03:23 +0100
Message-ID: <CACdoK4KC2Y69Sj2KmEFHtZctWeZfvUnckRY4Q1hpomHHr0CfDA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/9] bpf: iterators: install libbpf headers
 when building
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Oct 2021 at 22:30, Quentin Monnet <quentin@isovalent.com> wrote:
>
> On Mon, 4 Oct 2021 at 20:11, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sat, Oct 2, 2021 at 3:12 PM Quentin Monnet <quentin@isovalent.com> wrote:
> > >
> > > On Sat, 2 Oct 2021 at 21:27, Quentin Monnet <quentin@isovalent.com> wrote:
> > > >
> > > > On Sat, 2 Oct 2021 at 00:20, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
> > > > > >
> > > > > > API headers from libbpf should not be accessed directly from the
> > > > > > library's source directory. Instead, they should be exported with "make
> > > > > > install_headers". Let's make sure that bpf/preload/iterators/Makefile
> > > > > > installs the headers properly when building.
> > > >
> > > > > >
> > > > > > -$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
> > > > > > +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)            \
> > > > > > +          | $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE)
> > > > >
> > > > > Would it make sense for libbpf's Makefile to create include and output
> > > > > directories on its own? We wouldn't need to have these order-only
> > > > > dependencies everywhere, right?
> > > >
> > > > Good point, I'll have a look at it.
> > > > Quentin
> > >
> > > So libbpf already creates the include (and parent $(DESTDIR))
> > > directory, so I can get rid of the related dependencies. But I don't
> > > see an easy solution for the output directory for the object files.
> > > The issue is that libbpf's Makefile includes
> > > tools/scripts/Makefile.include, which checks $(OUTPUT) and errors out
> >
> > Did you check what benefits the use of tools/scripts/Makefile.include
> > brings? Last time I had to deal with some non-trivial Makefile
> > problem, this extra dance with tools/scripts/Makefile.include and some
> > related complexities didn't seem very justified. So unless there are
> > some very big benefits to having tool's Makefile.include included, I'd
> > rather simplify libbpf's in-kernel Makefile and make it more
> > straightforward. We have a completely independent separate Makefile
> > for libbpf in Github, and I think it's more straightforward. Doesn't
> > have to be done in this change, of course, but I was curious to hear
> > your thoughts given you seem to have spent tons of time on this
> > already.
>
> No, I haven't checked in details so far. I remember that several
> elements defined in the Makefile.include are used in libbpf's
> Makefile, and I stopped at that, because I thought that a refactoring
> of the latter would be beyond the current set. But yes, I can have a
> look at it and see if it's worth changing in a follow-up.

Looking more at tools/scripts/Makefile.include: It's 160-line long and
does not include any other Makefile, so there's nothing in it that we
couldn't re-implement in libbpf's Makefile if necessary. This being
said, it has a number of items that, I think, are good to keep there
and share with the other tools. For example:

- The $(EXTRA_WARNINGS) definitions
- QUIET_GEN, QUIET_LINK, QUIET_CLEAN, which are not mandatory to have
but integrate nicely with the way other tools (or kernel components)
are built
- Some overwrites for the toolchain, if $(LLVM) or $(CROSS_COMPILE) are set

Thinking more about this, if we want to create the $(OUTPUT) directory
in libbpf itself, we could maybe just enclose the check on its
pre-existence in tools/scripts/Makefile.include with a dedicated
variable ("ifneq ($(_skip_output_check),) ...") and set the latter in
Makefile.include. This way we wouldn't have to change the current
Makefile infra too much, and can keep the include.

Quentin

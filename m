Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69ED42194D
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 23:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbhJDVcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 17:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235594AbhJDVcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 17:32:02 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5B7C061749
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 14:30:13 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id n17so21338086vsr.10
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 14:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NgQR2dfyLeA9sPp6DpyEFSlglVVbtqhbisC5/s7oPPc=;
        b=5/Dh3fXXlJTU03MaHYQIdS9MZV0i2c71iqqtgSoQqFVC4OorNLINN69XCVFWzZ7ldB
         aXw9MVjDYbRu761FvScwJSO8xQYophmhAu0II2Zhx6vs8tKoIAxDwl7Ivtpl3tkASOPh
         j+viOp6JIP7VjZs/DXmky03gg5yAfMgr/qK/CQ3rhWWWnYlmah7mh71LJsP5lyai1cUy
         NHN9hV/O6kqtC3zV/F9K78hiuIudXLDROj9iUPXppjY7jfSML2tkWLQ1zr/B1SCFwXJh
         MsIrJGz9Zrvxdof9ksaHS3vf3ye+PAAD1hzbJ+GHgYldBwUyKGgCWxO9ZBfhETouaHRw
         nhfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NgQR2dfyLeA9sPp6DpyEFSlglVVbtqhbisC5/s7oPPc=;
        b=oufUwb8y58HJJuI2MYKVWe4E/DduNgz5SIePlEvDK0lamV56hIkn/0fl8Ms3hERBci
         g26Hrcgc1qNtNVkTb47jhSwo8eLOXdyfOZSZOQqR8tgYsa/+t0hgBuTsEboJY4wKfWxs
         YIpIDAH5vYdpPByXK78wQr0dddaG4TBQUQ0JQ8agGTndYqejOWS3UoW0SytnN5YGxP90
         3YW25c3me/ZSTq/IQNpL52VZgOwAVj8JHfkUj91wKvb4DrjCEVilm9aIRJzwEE1BPyTz
         dQSrnYT8xEC82+4PdrBtFSkwdT86it0MVJoOUNCYa8yYJugyTTb9asb+zGBltWm0Dfty
         RRzQ==
X-Gm-Message-State: AOAM531sfabAH1lHN9/OkMeekc4lau7ik+Xfp1ymAISSa3lzYoBr9a8U
        bB2nHRerIJz/fy64RPjf54KW/sqnkbAW5bg6EJZYSGF5BSD1XVl/
X-Google-Smtp-Source: ABdhPJz6YW1TiLRAHp8byoOqZTMDdGJHLbulNLKUgO0eSJbtkoYqZzYxhnOd+oULpIbx05nWrvcOapviqEPkkUYVcDo=
X-Received: by 2002:a05:6102:192:: with SMTP id r18mr15926964vsq.0.1633383012420;
 Mon, 04 Oct 2021 14:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <20211001110856.14730-7-quentin@isovalent.com>
 <CAEf4BzYm_QTq+u5tUp71+wY+JAaiUApv35tSqFUEyc81yOeUzw@mail.gmail.com>
 <CACdoK4LL91u-JK1fZ3XvkrTXsKBVsN-y1Js4QSPkWyS51KPB8Q@mail.gmail.com>
 <CACdoK4K4-x4+ZWXyB697Kn8RK5AyoCST+V7Lhtk_Kaqm5uQ6wg@mail.gmail.com> <CAEf4Bzb=jP3kU6O6QhZR6pcYn-7bkP8fr5ZDirWzf46WKEWA8Q@mail.gmail.com>
In-Reply-To: <CAEf4Bzb=jP3kU6O6QhZR6pcYn-7bkP8fr5ZDirWzf46WKEWA8Q@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Mon, 4 Oct 2021 22:30:00 +0100
Message-ID: <CACdoK4JpgKyeFAwwY=8V-WQO405-xkW+yS2qnfVv2tgoF-F3JA@mail.gmail.com>
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

On Mon, 4 Oct 2021 at 20:11, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Oct 2, 2021 at 3:12 PM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > On Sat, 2 Oct 2021 at 21:27, Quentin Monnet <quentin@isovalent.com> wrote:
> > >
> > > On Sat, 2 Oct 2021 at 00:20, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
> > > > >
> > > > > API headers from libbpf should not be accessed directly from the
> > > > > library's source directory. Instead, they should be exported with "make
> > > > > install_headers". Let's make sure that bpf/preload/iterators/Makefile
> > > > > installs the headers properly when building.
> > >
> > > > >
> > > > > -$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
> > > > > +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)            \
> > > > > +          | $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE)
> > > >
> > > > Would it make sense for libbpf's Makefile to create include and output
> > > > directories on its own? We wouldn't need to have these order-only
> > > > dependencies everywhere, right?
> > >
> > > Good point, I'll have a look at it.
> > > Quentin
> >
> > So libbpf already creates the include (and parent $(DESTDIR))
> > directory, so I can get rid of the related dependencies. But I don't
> > see an easy solution for the output directory for the object files.
> > The issue is that libbpf's Makefile includes
> > tools/scripts/Makefile.include, which checks $(OUTPUT) and errors out
>
> Did you check what benefits the use of tools/scripts/Makefile.include
> brings? Last time I had to deal with some non-trivial Makefile
> problem, this extra dance with tools/scripts/Makefile.include and some
> related complexities didn't seem very justified. So unless there are
> some very big benefits to having tool's Makefile.include included, I'd
> rather simplify libbpf's in-kernel Makefile and make it more
> straightforward. We have a completely independent separate Makefile
> for libbpf in Github, and I think it's more straightforward. Doesn't
> have to be done in this change, of course, but I was curious to hear
> your thoughts given you seem to have spent tons of time on this
> already.

No, I haven't checked in details so far. I remember that several
elements defined in the Makefile.include are used in libbpf's
Makefile, and I stopped at that, because I thought that a refactoring
of the latter would be beyond the current set. But yes, I can have a
look at it and see if it's worth changing in a follow-up.

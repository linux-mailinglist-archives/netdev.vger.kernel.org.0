Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC83C369DB2
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 02:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244120AbhDXASm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 20:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244084AbhDXASS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 20:18:18 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A50C06175F;
        Fri, 23 Apr 2021 17:13:22 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id g38so57577008ybi.12;
        Fri, 23 Apr 2021 17:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0rMCHL6FhL0cRI7haJbi7D3hHx41tCkYnbMlZuh3+ro=;
        b=r7mRAU0ArBON6XlMDQkBd6OKG2kot+f3LU4NAcpML+Yj8EGxjtQXxRjprsFKN+Ry1R
         0rQHJ4ov53B7ra85g/TowademdZoN/tDBZ44s6K/QDZ3GOIZgTlEqGAkbdj9NcZ5yHJD
         YOWT5WeTsGewZEzdjnm7JYcbVPcTeb03fg89vTDLMMuqfgHKaub3/oL5dsCACFO8k8qC
         D/KppoB2q6met5vg/sfYsHwvWw3eoYR7RuZ+f4/C8JxT1eKA4s9fSjkhWjI5nfRj+BFt
         0nEl6R64Hid3xcRUcpBagO7L3Oj6w5oLLHZG3njc2IJRVtvWpJwB2yGTDAvOV2wNvBGU
         IBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0rMCHL6FhL0cRI7haJbi7D3hHx41tCkYnbMlZuh3+ro=;
        b=Rii1pVAf+gnD777NfvtmJ0PDAIxe4aKsFGcoAYnyXj42VFDEUDb+dLARSFjA5xrFaL
         77c1xoQpv1RCAoay0jkEzZeIimzS4ZhDZ3wwZ8LmgY1V2J0/fHtRqHoaTenAeGgjcDwu
         WO7IZwbtQkoZqICWmXMEnqe5oh0lqLOiCYKrYekcK1tBFF4yVWaINemfzy5vX2vClg4G
         rQfpzf14jEuqG+yjTI7S0v0EabE80S9KAkfLcMjGZt43Lon8TqMBX9ZSRX3gIQkZ3psY
         eI8jwCoQyrbtk66HUPai4ImmkrC5Izd+F0CO5RdpTKkYSBhKEVs9KbueTHxo2tRyGFi2
         eDug==
X-Gm-Message-State: AOAM5322l7gnWcv8I9l/lxl3Nbm9FsoddXjGc5WU2vhK+YqU2G1KAfcc
        lInm7yM8ZQWxkg2WFQhXsgoF5qc1TbZJhaZ89tznDiKy
X-Google-Smtp-Source: ABdhPJzLNM3ps+Cq0z02sLCBNNaL89VdlkZwB39z/jHZDaNfvf0TWoBIETJpGmnUdLiYgyJ41g/AXlt4ACNUSe4lAxc=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr9164139ybf.425.1619223201813;
 Fri, 23 Apr 2021 17:13:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210423185357.1992756-1-andrii@kernel.org> <20210423185357.1992756-3-andrii@kernel.org>
 <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com> <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
 <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com> <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
 <CAEf4BzadCR+QFy4UY8NSVFjGJF4CszhjjZ48XeeqrfX3aYTnkA@mail.gmail.com> <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com>
In-Reply-To: <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Apr 2021 17:13:10 -0700
Message-ID: <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during linking
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 4:48 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Apr 23, 2021 at 4:35 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Apr 23, 2021 at 4:06 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Apr 23, 2021 at 2:56 PM Yonghong Song <yhs@fb.com> wrote:
> > > > >>>
> > > > >>> -static volatile const __u32 print_len;
> > > > >>> -static volatile const __u32 ret1;
> > > > >>> +volatile const __u32 print_len = 0;
> > > > >>> +volatile const __u32 ret1 = 0;
> > > > >>
> > > > >> I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think
> > > > >> this is not in a static link test, right? The same for a few tests below.
> > > > >
> > > > > All the selftests are passed through a static linker, so it will
> > > > > append obj_name to each static variable. So I just minimized use of
> > > > > static variables to avoid too much code churn. If this variable was
> > > > > static, it would have to be accessed as
> > > > > skel->rodata->bpf_iter_test_kern4__print_len, for example.
> > > >
> > > > Okay this should be fine. selftests/bpf specific. I just feel that
> > > > some people may get confused if they write/see a single program in
> > > > selftest and they have to use obj_varname format and thinking this
> > > > is a new standard, but actually it is due to static linking buried
> > > > in Makefile. Maybe add a note in selftests/README.rst so we
> > > > can point to people if there is confusion.
> > >
> > > I'm not sure I understand.
> > > Are you saying that
> > > bpftool gen object out_file.o in_file.o
> > > is no longer equivalent to llvm-strip ?
> > > Since during that step static vars will get their names mangled?
> >
> > Yes. Static vars and static maps. We don't allow (yet?) static
> > entry-point BPF programs, so those don't change.
> >
> > > So a good chunk of code that uses skeleton right now should either
> > > 1. don't do the linking step
> > > or
> > > 2. adjust their code to use global vars
> > > or
> > > 3. adjust the usage of skel.h in their corresponding user code
> > >   to accommodate mangled static names?
> > > Did it get it right?
> >
> > Yes, you are right. But so far most cases outside of selftest that
> > I've seen don't use static variables (partially because they need
> > pesky volatile to be visible from user-space at all), global vars are
> > much nicer in that regard.
>
> Right.
> but wait...
> why linker is mangling them at all and why they appear in the skeleton?
> static vars without volatile should not be in a skeleton, since changing
> them from user space might have no meaning on the bpf program.
> The behavior of the bpf prog is unpredictable.

It's up to the compiler. If compiler decides that it shouldn't inline
all the uses (or e.g. if static variable is an array accessed with
index known only at runtime, or many other cases where compiler can't
just deduce constant value), then compiler will emit ELF symbols, will
allocate storage, and code will use that storage. static volatile just
forces the compiler to not assume anything at all.

If the compiler does inline all the uses of static, then we won't have
storage allocated for it and it won't be even present in BTF. So for
libbpf, linker and skeleton statics are no different than globals.

Static maps are slightly different, because we use SEC() which marks
them as used, so they should always be present.

Sub-skeleton will present those statics to the BPF library without
name mangling, but for the final linked BPF object file we need to
handle statics. Definitely for maps, because static means that library
or library user shouldn't be able to just extern that definition and
update/lookup/corrupt its state. But I think for static variables it
should be the same. Both are visible to user-space, but invisible
between linked BPF compilation units.

> Only volatile static can theoretically be in the skeleton, but as you said
> probably no one is using them yet, so we can omit them from skeleton too.

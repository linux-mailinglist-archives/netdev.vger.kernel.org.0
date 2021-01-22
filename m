Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA972FF972
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 01:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbhAVA0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 19:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbhAVA0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 19:26:22 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79829C06174A;
        Thu, 21 Jan 2021 16:25:42 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q129so7866099iod.0;
        Thu, 21 Jan 2021 16:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=ykOiitFyiN0YSC/lJm0MiGgBb0JXAdtJs/AnjN6QPxY=;
        b=QDG0JJplOoNQz84k3mYR476kQh5U3VxQVzKvtt1e8CSfdDU8M8xdbIuGJjcZXrNbNC
         lcmBx6MWm8ACOAF38UaCM0rT4//qt8cBuoS1xm1X1P3lngLnpJkcvTBbZBrjhmYfhhvZ
         +DnawjDsJC0prF+exWXZexUH/WsmtUz9/xjVXxoO/XDC+sMpahwchcDb1nMJ2sLzWhN1
         DHUDnHgm1p0HAexyYuRHLyzsQsfBt5ZpaqwkewmCA60fsHURrjAhbJPqcyJBBV0DDi24
         sgSmuySVd8NFBRSNt3fRdKlZICvGbnyrgaamfofcoQm94m9dkgfBbHYmSc3ADcHm9TDl
         Fx0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=ykOiitFyiN0YSC/lJm0MiGgBb0JXAdtJs/AnjN6QPxY=;
        b=CBqDKjjDjEQnfzFc7R6V9TvJXPEo6IYppZjEB7JbM9DcdXzlVZ8tXwcZXBPwQ0tzd4
         UIwccIR4GgvKdsdPzPZTw5syOjQ30Ka3FfgyrURDIyjRSF5Wv3JwD6W+mATGHUu7z6I6
         rHhhW3It/sRhyjfdfUJCzJla3cmSYUNMYczEPM4Z5Sjp+MeIuPHFJvJmatE0RWBU6LWh
         tdDlITWQfwuBvLAPdLZA7IQNiSrNPlxVG984JScnvQvNh1KUiiZEUxbGKq3w2XjadggS
         aTPcmvp8w47fLfUQkOPiNN/kJvAj6QvCV0Re5dRPnZSumj+8y4sFNS2ek77h+3DEIX+b
         CSnQ==
X-Gm-Message-State: AOAM532Q62iHmFyoiXfHCdyNK15u4mo9B64rxAAcgQooNcrC8vIqQUxP
        kWMWzb4gbugtmThMfD5POUFKitK9DL9gDZ5MGmw=
X-Google-Smtp-Source: ABdhPJwA9IQtExG+5RlQWaPI0YodAZOnsMrpJLghO7Nv6S4fYgKHUyyRllGljUmIxkyy2DcFr61UVjM4KqztO1BDJcc=
X-Received: by 2002:a6b:6a0e:: with SMTP id x14mr1540463iog.57.1611275141850;
 Thu, 21 Jan 2021 16:25:41 -0800 (PST)
MIME-Version: 1.0
References: <20210116095413.72820-1-sedat.dilek@gmail.com> <20210120223546.GF1798087@krava>
 <CAEf4Bza2W061YpxtUx9ZKQUtE0-tS6gf4yg2Le_2g4kyi3FhnQ@mail.gmail.com>
 <CA+icZUUGKn4DiBGN8Tq3yrh0NH2Fqboaigwm4Q3yceDJVe9dAA@mail.gmail.com> <CA+icZUX_DsEi+k5kpko5fxrG2+-oL8H4gVRq93fXHjN6ny9K=Q@mail.gmail.com>
In-Reply-To: <CA+icZUX_DsEi+k5kpko5fxrG2+-oL8H4gVRq93fXHjN6ny9K=Q@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 22 Jan 2021 01:25:30 +0100
Message-ID: <CA+icZUW11s-rmu+hw4ue44cn4FDBLoJWSrZ78qpdfk-CSYHYHQ@mail.gmail.com>
Subject: Re: [PATCH RFC] tools: Factor Clang, LLC and LLVM utils definitions
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yulia Kartseva <hex@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Thomas Hebb <tommyhebb@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Briana Oursler <briana.oursler@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 1:21 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Fri, Jan 22, 2021 at 1:12 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > On Fri, Jan 22, 2021 at 1:04 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Wed, Jan 20, 2021 at 2:36 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > On Sat, Jan 16, 2021 at 10:54:04AM +0100, Sedat Dilek wrote:
> > > > > When dealing with BPF/BTF/pahole and DWARF v5 I wanted to build bpftool.
> > > > >
> > > > > While looking into the source code I found duplicate assignments
> > > > > in misc tools for the LLVM eco system, e.g. clang and llvm-objcopy.
> > > > >
> > > > > Move the Clang, LLC and/or LLVM utils definitions to
> > > > > tools/scripts/Makefile.include file and add missing
> > > > > includes where needed.
> > > > > Honestly, I was inspired by commit c8a950d0d3b9
> > > > > ("tools: Factor HOSTCC, HOSTLD, HOSTAR definitions").
> > > > >
> > > > > I tested with bpftool and perf on Debian/testing AMD64 and
> > > > > LLVM/Clang v11.1.0-rc1.
> > > > >
> > > > > Build instructions:
> > > > >
> > > > > [ make and make-options ]
> > > > > MAKE="make V=1"
> > > > > MAKE_OPTS="HOSTCC=clang HOSTCXX=clang++ HOSTLD=ld.lld CC=clang LD=ld.lld LLVM=1 LLVM_IAS=1"
> > > > > MAKE_OPTS="$MAKE_OPTS PAHOLE=/opt/pahole/bin/pahole"
> > > > >
> > > > > [ clean-up ]
> > > > > $MAKE $MAKE_OPTS -C tools/ clean
> > > > >
> > > > > [ bpftool ]
> > > > > $MAKE $MAKE_OPTS -C tools/bpf/bpftool/
> > > > >
> > > > > [ perf ]
> > > > > PYTHON=python3 $MAKE $MAKE_OPTS -C tools/perf/
> > > > >
> > > > > I was careful with respecting the user's wish to override custom compiler,
> > > > > linker, GNU/binutils and/or LLVM utils settings.
> > > > >
> > > > > Some personal notes:
> > > > > 1. I have NOT tested with cross-toolchain for other archs (cross compiler/linker etc.).
> > > > > 2. This patch is on top of Linux v5.11-rc3.
> > > > >
> > > > > I hope to get some feedback from especially Linux-bpf folks.
> > > > >
> > > > > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> > > > > ---
> > > > >  tools/bpf/bpftool/Makefile                  | 2 --
> > > > >  tools/bpf/runqslower/Makefile               | 3 ---
> > > > >  tools/build/feature/Makefile                | 4 ++--
> > > > >  tools/perf/Makefile.perf                    | 1 -
> > > >
> > > > for tools/build and tools/perf
> > > >
> > > > Acked-by: Jiri Olsa <jolsa@redhat.com>
> > > >
> > >
> > > It's pretty straightforward and looks good for bpftool and runqslower,
> > > but I couldn't apply directly to test due to merge conflicts.
> > >
> > > Also, which tree this should go through, given it touches multiple
> > > parts under tools/?
> > >
> >
> > Sorry, for the conflicts.
> > AFAICS I should do this again against Linux v5.11-rc4 vanilla?
> > Is this OK to you?
> >
>
> I re-checked:
> This patch was on top of Linux v5.11-rc3 and applies cleanly against
> Linux v5.11-rc.
>

Bullshit.

I will send out a v2 against Linux v5.11-rc4 - was on the wrong local
Git branch.

- Sedat -

> Please let me know if I should adapt to a different Git tree.
>
> - Sedat -
>
> > Good hint, cannot say through which tree this should go through.
> >
> > - Sedat -
> >
> > > > jirka
> > > >
> > > > >  tools/scripts/Makefile.include              | 7 +++++++
> > > > >  tools/testing/selftests/bpf/Makefile        | 3 +--
> > > > >  tools/testing/selftests/tc-testing/Makefile | 3 +--
> > > > >  7 files changed, 11 insertions(+), 12 deletions(-)
> > > > >
> > > > > diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> > > > > index f897cb5fb12d..71c14efa6e91 100644
> > > > > --- a/tools/bpf/bpftool/Makefile
> > > > > +++ b/tools/bpf/bpftool/Makefile
> > > >
> > > > SNIP
> > > >

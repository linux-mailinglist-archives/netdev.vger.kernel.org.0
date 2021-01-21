Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256772FDFDB
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 04:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393240AbhAUCvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbhAUCjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 21:39:22 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66A7C061795;
        Wed, 20 Jan 2021 18:36:39 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id y19so1196351iov.2;
        Wed, 20 Jan 2021 18:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=g72wU/e2+tUMN8rrYgJKmfgNJZa+U65gluRGUeFny/w=;
        b=NnQsZ32aK4Wsq9BJ1UAOChepviWpvo0EVt8Is3i8V+zU2wHuYXhkRKVqTDkqtvYAcX
         irS/zZgFuI37mfKLJvazJCnWyePPqkztbleSxE0MHV8UNHpeJy45JYdT1NONTAGrUWZ3
         PmvopvnlEXIauSzpGxEYJC50R79rLhHpyvTgRrYvTcFum6wY6n3Kp4liA0C6m13z1obA
         QGLJETolj3MKF18oBaGUcsqZ1AuwXyaKpKzYK2FwLEBxt3mAcvg3/OOtLvWZh7o44XKP
         TB39za4cRBzPp5hKNBeueMWfgwJQpoKgooP90up4umA/w3bRib6hlD41BUA2hN+RlhRj
         h65Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=g72wU/e2+tUMN8rrYgJKmfgNJZa+U65gluRGUeFny/w=;
        b=qPtuSUHjn1Vk9WD4K13w0anJlsUI8/joC/xV0JDZ66Q+ZUynwiThW7/g1atxOEktvH
         aXn7Ifl8jQtIM20gMJCFpiiqF3QYicvNsHsYTCpCtWKD9FXcjTK0t7lrUV6iMlTFIofx
         tbWbv/0cFg+XrJl9JteexLnJpfx6jWJJFBLN2uXeu3OcceshVwHds2zyTavNe/GVUNmx
         xSNi8vXA2k97cQdvpsZ2zubFssNIroAmtSW2zsPHJTETXOB+igOGYm0amW9s/QEvjMEO
         llBhFTeiLIJd+Qqx6QBeBhUJT7Rw3U9YS4jIhz9O2wkIrotPIHYtlFqNvI+OmL3BZ7gN
         umKA==
X-Gm-Message-State: AOAM530+yfNrGeyXcQXoenNQ0XXnvYlfZjGCriulSd5vtiOnDqaD2J77
        b7e7udqqjrWKtHVtadQD2XxHSmeDI3j7tKcE098=
X-Google-Smtp-Source: ABdhPJzTja6a9DNn3K26Qf91jp1IMxAppFM3Kbkqi/Z7/kVG3gtk23ypo2ANcj04gHF12/kjuEe3JfV6RWr0FAUKfgg=
X-Received: by 2002:a6b:90c4:: with SMTP id s187mr8980048iod.75.1611196599235;
 Wed, 20 Jan 2021 18:36:39 -0800 (PST)
MIME-Version: 1.0
References: <20210116095413.72820-1-sedat.dilek@gmail.com> <20210120223546.GF1798087@krava>
In-Reply-To: <20210120223546.GF1798087@krava>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 21 Jan 2021 03:36:28 +0100
Message-ID: <CA+icZUU=nVxcQpfVR6s9fGomY0zEx22a8Ge4Uw8rL84JNu+0oA@mail.gmail.com>
Subject: Re: [PATCH RFC] tools: Factor Clang, LLC and LLVM utils definitions
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 11:36 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Sat, Jan 16, 2021 at 10:54:04AM +0100, Sedat Dilek wrote:
> > When dealing with BPF/BTF/pahole and DWARF v5 I wanted to build bpftool.
> >
> > While looking into the source code I found duplicate assignments
> > in misc tools for the LLVM eco system, e.g. clang and llvm-objcopy.
> >
> > Move the Clang, LLC and/or LLVM utils definitions to
> > tools/scripts/Makefile.include file and add missing
> > includes where needed.
> > Honestly, I was inspired by commit c8a950d0d3b9
> > ("tools: Factor HOSTCC, HOSTLD, HOSTAR definitions").
> >
> > I tested with bpftool and perf on Debian/testing AMD64 and
> > LLVM/Clang v11.1.0-rc1.
> >
> > Build instructions:
> >
> > [ make and make-options ]
> > MAKE="make V=1"
> > MAKE_OPTS="HOSTCC=clang HOSTCXX=clang++ HOSTLD=ld.lld CC=clang LD=ld.lld LLVM=1 LLVM_IAS=1"
> > MAKE_OPTS="$MAKE_OPTS PAHOLE=/opt/pahole/bin/pahole"
> >
> > [ clean-up ]
> > $MAKE $MAKE_OPTS -C tools/ clean
> >
> > [ bpftool ]
> > $MAKE $MAKE_OPTS -C tools/bpf/bpftool/
> >
> > [ perf ]
> > PYTHON=python3 $MAKE $MAKE_OPTS -C tools/perf/
> >
> > I was careful with respecting the user's wish to override custom compiler,
> > linker, GNU/binutils and/or LLVM utils settings.
> >
> > Some personal notes:
> > 1. I have NOT tested with cross-toolchain for other archs (cross compiler/linker etc.).
> > 2. This patch is on top of Linux v5.11-rc3.
> >
> > I hope to get some feedback from especially Linux-bpf folks.
> >
> > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> > ---
> >  tools/bpf/bpftool/Makefile                  | 2 --
> >  tools/bpf/runqslower/Makefile               | 3 ---
> >  tools/build/feature/Makefile                | 4 ++--
> >  tools/perf/Makefile.perf                    | 1 -
>
> for tools/build and tools/perf
>
> Acked-by: Jiri Olsa <jolsa@redhat.com>
>

Thanks Jiri for your feedback and ACK.

- Sedat -

> jirka
>
> >  tools/scripts/Makefile.include              | 7 +++++++
> >  tools/testing/selftests/bpf/Makefile        | 3 +--
> >  tools/testing/selftests/tc-testing/Makefile | 3 +--
> >  7 files changed, 11 insertions(+), 12 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> > index f897cb5fb12d..71c14efa6e91 100644
> > --- a/tools/bpf/bpftool/Makefile
> > +++ b/tools/bpf/bpftool/Makefile
>
> SNIP
>

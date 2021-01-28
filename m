Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF18306A97
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhA1BnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhA1Bmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:42:36 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901FBC061573;
        Wed, 27 Jan 2021 17:41:54 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id b11so3929257ybj.9;
        Wed, 27 Jan 2021 17:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=levWwdmNnK0CrUKkgeazFotHMRfPFFjLuGXoNcWWnk4=;
        b=Kx6l4kSzTgkuB2jfC0liiJLrDkvg6j0aYZnI1FRXPwCB57JhTXm3++vc7L2IB+SdDE
         uFQE67X/0Qo6o/5aWXzNddJxoBe4QddNq4k7jqSUSBb22ywardf5+F0cKyiqq6RcG0LP
         YbT4kP4IHCrNuS08id6KFv6XnGRN6BdFHPnlk4HkAdE5G3X92ebeZNOO3S23pXEpUTyH
         feMD8aYSCBYYtLiJjBNLo9xF797s9pVENsLMt99bsOMRxB9H8hrU9Rhqt6N1mil9Kx+A
         kdhnb4XOzxjZKsu4UXaH6eSDjNEsD1SPbUSS043jxNGy/oba6LVnVjDY4NzJoHsrzQEY
         2Xxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=levWwdmNnK0CrUKkgeazFotHMRfPFFjLuGXoNcWWnk4=;
        b=BEjX89qzk8ClfQ9cUiCs83Ogh63257613rgwUSgiqTvTqG4xitL7f6oOcioA5qhP2P
         ZMXyIvB8w3EDS8+AIvow+1BODiBqTqT9j/A8fSjv6UTdSrDEbitU7BYqc+tQnc/xAZ4/
         Xj6UB1M/OD9u1Y6Nt7SgW1CQfKjTAbmjztxBRAfbFiKvewpLSQ2sPjnUl4bc79bwv/gv
         YuFl++RnHLsOjJKvM6QDu5MDTkds8IZ3422uRk+bxtFqGW3o9hZq532cqxqP6tJN//he
         cT8/K376DKbpqb0e/oyT43md85w9NruZoGM7Ri/++GGbsR+pOarEJg0ENhdF8cknG7U+
         p7AA==
X-Gm-Message-State: AOAM5316prbTDXfOTGsO91hrOYMIaibJUd5P5T1cMI8Ev6O4Qo1t4SgL
        FflvpJIzq4QSFQlu51pxl/m54ruE7oj+hbXhnUE=
X-Google-Smtp-Source: ABdhPJyI5E67V6EvxOqHQAV1wAtMqjq197vKQpMFslcn3wRVR2OQgtT9elgHLB7afmx0GIdKAJznkY8r2c9kDl76+M4=
X-Received: by 2002:a25:4605:: with SMTP id t5mr7683661yba.260.1611798113726;
 Wed, 27 Jan 2021 17:41:53 -0800 (PST)
MIME-Version: 1.0
References: <20210122003235.77246-1-sedat.dilek@gmail.com> <CAEf4Bzb+fXZy1+337zRFA9v8x+Mt7E3YOZRhG8xnXeRN4_oCRA@mail.gmail.com>
 <CA+icZUWVGHqM00qd7-+Hrb9=rkL6AvEQ7Aj8zBK=VPpEi+LTmg@mail.gmail.com>
In-Reply-To: <CA+icZUWVGHqM00qd7-+Hrb9=rkL6AvEQ7Aj8zBK=VPpEi+LTmg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Jan 2021 17:41:42 -0800
Message-ID: <CAEf4BzZ0S-SzVy=Ym0x27Ab2QS8vwA66OzX4KjC88nSg7wD9SQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] tools: Factor Clang, LLC and LLVM utils definitions
To:     Sedat Dilek <sedat.dilek@gmail.com>
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
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrey Ignatov <rdna@fb.com>,
        Stephane Eranian <eranian@google.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Thomas Hebb <tommyhebb@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Briana Oursler <briana.oursler@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 5:30 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Thu, Jan 28, 2021 at 2:27 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Jan 21, 2021 at 4:32 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > >
> > > When dealing with BPF/BTF/pahole and DWARF v5 I wanted to build bpftool.
> > >
> > > While looking into the source code I found duplicate assignments
> > > in misc tools for the LLVM eco system, e.g. clang and llvm-objcopy.
> > >
> > > Move the Clang, LLC and/or LLVM utils definitions to
> > > tools/scripts/Makefile.include file and add missing
> > > includes where needed.
> > > Honestly, I was inspired by commit c8a950d0d3b9
> > > ("tools: Factor HOSTCC, HOSTLD, HOSTAR definitions").
> > >
> > > I tested with bpftool and perf on Debian/testing AMD64 and
> > > LLVM/Clang v11.1.0-rc1.
> > >
> > > Build instructions:
> > >
> > > [ make and make-options ]
> > > MAKE="make V=1"
> > > MAKE_OPTS="HOSTCC=clang HOSTCXX=clang++ HOSTLD=ld.lld CC=clang LD=ld.lld LLVM=1 LLVM_IAS=1"
> > > MAKE_OPTS="$MAKE_OPTS PAHOLE=/opt/pahole/bin/pahole"
> > >
> > > [ clean-up ]
> > > $MAKE $MAKE_OPTS -C tools/ clean
> > >
> > > [ bpftool ]
> > > $MAKE $MAKE_OPTS -C tools/bpf/bpftool/
> > >
> > > [ perf ]
> > > PYTHON=python3 $MAKE $MAKE_OPTS -C tools/perf/
> > >
> > > I was careful with respecting the user's wish to override custom compiler,
> > > linker, GNU/binutils and/or LLVM utils settings.
> > >
> > > Some personal notes:
> > > 1. I have NOT tested with cross-toolchain for other archs (cross compiler/linker etc.).
> > > 2. This patch is on top of Linux v5.11-rc4.
> > >
> > > I hope to get some feedback from especially Linux-bpf folks.
> > >
> > > Acked-by: Jiri Olsa <jolsa@redhat.com> # tools/build and tools/perf
> > > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> > > ---
> >
> > Hi Sedat,
> >
> > If no one objects, we'll take this through bpf-next tree. Can you
> > please re-send this as a non-RFC patch against the bpf-next tree? Feel
> > free to add my ack. Thanks.
> >
>
> I am OK with that and will add your ACK.
> Is [1] bpf-next Git?

Yes, please use [PATCH bpf-next] subject prefix and cc
bpf@vger.kernel.org as well.

>
> - Sedat -
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/
>
> > > Changelog RFC v1->v2:
> > > - Add Jiri's ACK
> > > - Adapt to fit Linux v5.11-rc4
> > >
> >
> > [...]

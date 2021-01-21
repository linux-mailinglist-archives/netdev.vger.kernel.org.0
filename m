Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26ED2FE836
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 11:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbhAUK6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 05:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730048AbhAUKzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 05:55:19 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF58DC061575;
        Thu, 21 Jan 2021 02:54:38 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id y19so3123276iov.2;
        Thu, 21 Jan 2021 02:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=eHh9bl/LcH3CTdV9ko4oi/XPeB06sWntbeOZiEwFMXM=;
        b=L1lxUFr/7nt1CWNamLeQTcY5LzLE7yyW3CFHVxulBhN2bN10B1Qh7rP6b6iUW8Jgud
         xZmfL0kHSwQlsx/rjqOsguvKuzPGwXHcTUlCMN+XuoXUj5Z9/u/02KRub1cNAnYaSaRP
         yGJYOsIRTxYu6Enzd0r1t0zToX9MMFGeuqpFZx9u5yXyd9qsfVKFE+R5dP0I2RKmG1oS
         5beb3UXxz35t9V7WbLmMsCgy+pCuhXnc0QrZjADD2q9ls3CieQSV86Vk42F+HDR1AlSi
         q5BE05JgZ386QFQYR7oVaC6x/19PN4KWUYGn0T1T2PYNQUg7ElzoVFsaHuhg70sLzO83
         9GAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=eHh9bl/LcH3CTdV9ko4oi/XPeB06sWntbeOZiEwFMXM=;
        b=mJuC61yVhzeCXK1A1LbDNRmBJt78XQ6sxVvUYUJ1P+SYCKI5wu95ZQ9Q2Qf+7kLOzC
         8xyz491ubYystZz4Rc9Nil/WD3kQOUXYlV2FudY4KX2Pu+XE4Q5kvWRhbXI263Xp7Dx8
         sSy+tvtyHX57iGuwSp+HOjiwPxel2/zwBbU4VOAw9MTY8HbvDP4wKXmbcJzmq42q7T+F
         qFDaomvXRG80HLfNb2ORoabiwLzGPxg5NTHqXH52Hjyki7EGswXqIyR3CkHQ/mbAX+u5
         A4rtPEGo8JXfQ4dyxOgZ8/T/QzqVn4LFAoMxI2xY1rQN43RUAFHDGRjiSQaSEn7QxcRn
         RzQQ==
X-Gm-Message-State: AOAM530gjXeuLXTpAiJYEepp0PXI75IbyRtM1Afg+duq/h2LYn+ZLRnb
        S3PSiZqJKNxNgXmD0niFHVzgbQQJFbYR8BR1XgU=
X-Google-Smtp-Source: ABdhPJzP6l+ghGWAyhRMogOVXl11n2XWUvKQhiefdX5n3Xb/IWcHz00KN0qrBHFdHgmHQZ5md7UIJrTGvliDSOheLyE=
X-Received: by 2002:a6b:6a0e:: with SMTP id x14mr9850452iog.57.1611226478174;
 Thu, 21 Jan 2021 02:54:38 -0800 (PST)
MIME-Version: 1.0
References: <1611206855-22555-1-git-send-email-yangtiezhu@loongson.cn>
 <20210121053627.GA1680146@ubuntu-m3-large-x86> <CAEf4BzbZxuy8LRmngRzLZ3VTnrDw=Rf70Ghkbu1a5+fNpQud5Q@mail.gmail.com>
 <CA+icZUWNu1JaS+m+Ne1ZB+tCARRUaiVh2KbqarnGEtM46PD1NA@mail.gmail.com>
In-Reply-To: <CA+icZUWNu1JaS+m+Ne1ZB+tCARRUaiVh2KbqarnGEtM46PD1NA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 21 Jan 2021 11:54:26 +0100
Message-ID: <CA+icZUXD6jsAcd4pnbALYYbOq7-z+TRfvEkNRB+_i0BTgiWOyw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] samples/bpf: Update build procedure for
 manually compiling LLVM and Clang
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        open list <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Fangrui Song <maskray@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 9:55 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Thu, Jan 21, 2021 at 9:08 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Jan 20, 2021 at 9:36 PM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > >
> > > On Thu, Jan 21, 2021 at 01:27:35PM +0800, Tiezhu Yang wrote:
> > > > The current LLVM and Clang build procedure in samples/bpf/README.rst is
> > > > out of date. See below that the links are not accessible any more.
> > > >
> > > > $ git clone http://llvm.org/git/llvm.git
> > > > Cloning into 'llvm'...
> > > > fatal: unable to access 'http://llvm.org/git/llvm.git/': Maximum (20) redirects followed
> > > > $ git clone --depth 1 http://llvm.org/git/clang.git
> > > > Cloning into 'clang'...
> > > > fatal: unable to access 'http://llvm.org/git/clang.git/': Maximum (20) redirects followed
> > > >
> > > > The LLVM community has adopted new ways to build the compiler. There are
> > > > different ways to build LLVM and Clang, the Clang Getting Started page [1]
> > > > has one way. As Yonghong said, it is better to copy the build procedure
> > > > in Documentation/bpf/bpf_devel_QA.rst to keep consistent.
> > > >
> > > > I verified the procedure and it is proved to be feasible, so we should
> > > > update README.rst to reflect the reality. At the same time, update the
> > > > related comment in Makefile.
> > > >
> > > > Additionally, as Fangrui said, the dir llvm-project/llvm/build/install is
> > > > not used, BUILD_SHARED_LIBS=OFF is the default option [2], so also change
> > > > Documentation/bpf/bpf_devel_QA.rst together.
> > > >
> > > > [1] https://clang.llvm.org/get_started.html
> > > > [2] https://www.llvm.org/docs/CMake.html
> > > >
> > > > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > > > Acked-by: Yonghong Song <yhs@fb.com>
> > >
> > > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> > >
> > > Small comment below.
> > >
> > > > ---
> > > >
> > > > v2: Update the commit message suggested by Yonghong,
> > > >     thank you very much.
> > > >
> > > > v3: Remove the default option BUILD_SHARED_LIBS=OFF
> > > >     and just mkdir llvm-project/llvm/build suggested
> > > >     by Fangrui.
> > > >
> > > >  Documentation/bpf/bpf_devel_QA.rst |  3 +--
> > > >  samples/bpf/Makefile               |  2 +-
> > > >  samples/bpf/README.rst             | 16 +++++++++-------
> > > >  3 files changed, 11 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
> > > > index 5b613d2..18788bb 100644
> > > > --- a/Documentation/bpf/bpf_devel_QA.rst
> > > > +++ b/Documentation/bpf/bpf_devel_QA.rst
> > > > @@ -506,11 +506,10 @@ that set up, proceed with building the latest LLVM and clang version
> > > >  from the git repositories::
> > > >
> > > >       $ git clone https://github.com/llvm/llvm-project.git
> > > > -     $ mkdir -p llvm-project/llvm/build/install
> > > > +     $ mkdir -p llvm-project/llvm/build
> > > >       $ cd llvm-project/llvm/build
> > > >       $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
> > > >                  -DLLVM_ENABLE_PROJECTS="clang"    \
> > > > -                -DBUILD_SHARED_LIBS=OFF           \
> > > >                  -DCMAKE_BUILD_TYPE=Release        \
> > > >                  -DLLVM_BUILD_RUNTIME=OFF
> > > >       $ ninja
> > > > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > > > index 26fc96c..d061446 100644
> > > > --- a/samples/bpf/Makefile
> > > > +++ b/samples/bpf/Makefile
> > > > @@ -208,7 +208,7 @@ TPROGLDLIBS_xdpsock               += -pthread -lcap
> > > >  TPROGLDLIBS_xsk_fwd          += -pthread
> > > >
> > > >  # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
> > > > -#  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
> > > > +# make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
> > > >  LLC ?= llc
> > > >  CLANG ?= clang
> > > >  OPT ?= opt
> > > > diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
> > > > index dd34b2d..23006cb 100644
> > > > --- a/samples/bpf/README.rst
> > > > +++ b/samples/bpf/README.rst
> > > > @@ -65,17 +65,19 @@ To generate a smaller llc binary one can use::
> > > >  Quick sniplet for manually compiling LLVM and clang
> > > >  (build dependencies are cmake and gcc-c++)::
> > >
> > > Technically, ninja is now a build dependency as well, it might be worth
> > > mentioning that here (usually the package is ninja or ninja-build).
> >
> > it's possible to generate Makefile by passing `-g "Unix Makefiles"`,
> > which would avoid dependency on ninja, no?
> >
>
> AFAICS, cmake is now the default and "Unix Makefiles" deprecated with
> newer versions of LLVM/Clang.
>

Hmm, I mixed it up...
This is about the cmake-generator (GNU/make was deprecated/abandoned).
Cannot say I use "ninja" - it's fast.

Just as a hint for a fast build of LLVM/Clang:
Use tc-build together with stage1-only (build and install) options.

- Sedat -

[1] https://github.com/ClangBuiltLinux/tc-build

>
> > >
> > > Regardless of whether that is addressed or not (because it is small),
> > > feel free to carry forward my tag in any future revisions unless they
> > > drastically change.
> > >
> > > > - $ git clone http://llvm.org/git/llvm.git
> > > > - $ cd llvm/tools
> > > > - $ git clone --depth 1 http://llvm.org/git/clang.git
> > > > - $ cd ..; mkdir build; cd build
> > > > - $ cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86"
> > > > - $ make -j $(getconf _NPROCESSORS_ONLN)
> > > > + $ git clone https://github.com/llvm/llvm-project.git
> > > > + $ mkdir -p llvm-project/llvm/build
> > > > + $ cd llvm-project/llvm/build
> > > > + $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
> > > > +            -DLLVM_ENABLE_PROJECTS="clang"    \
> > > > +            -DCMAKE_BUILD_TYPE=Release        \
> > > > +            -DLLVM_BUILD_RUNTIME=OFF
> > > > + $ ninja
> > > >
> > > >  It is also possible to point make to the newly compiled 'llc' or
> > > >  'clang' command via redefining LLC or CLANG on the make command line::
> > > >
> > > > - make M=samples/bpf LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
> > > > + make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
> > > >
> > > >  Cross compiling samples
> > > >  -----------------------
> > > > --
> > > > 2.1.0
> > > >
> >
> > --
> > You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CAEf4BzbZxuy8LRmngRzLZ3VTnrDw%3DRf70Ghkbu1a5%2BfNpQud5Q%40mail.gmail.com.

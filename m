Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE41E2FECD1
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 15:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbhAUOYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 09:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbhAUOYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 09:24:03 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBB9C0613C1;
        Thu, 21 Jan 2021 06:23:06 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id j26so1584209qtq.8;
        Thu, 21 Jan 2021 06:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w3fw0nXMRMWboT6HRhuDOZbyDuSIlRWZhktoQjQ5hhQ=;
        b=jC4IVgUHCLnG4+nLw2LB1EReIoMReml/OSrPyUvvh6uljN6y3Js7zYxB9w7YG9wPPS
         uMyQi1GnliTA6a3OvK6aivxBav+5ajgTZ5LGDJ+4obwlbTxq828an8B/JGN4HQei2LAl
         QAs527jZbmYf0D4N3VW3fBtmRAxoGIyeoHIWkZdJwbp6u9SdjElj+Dl06l8mOByN8r/2
         6GemXdV9wAo3HuyVPhDN/0N+3rQwABVvsaRo3iWo+1lgPTurAR0DFB0nBx9+IbIWRU5U
         RBztgsMyVDmMV8S10VcHMsnf+olTqW+O6qWhmOWff0cdYFpOAHvbH6Xvaseb42YTevhO
         mGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w3fw0nXMRMWboT6HRhuDOZbyDuSIlRWZhktoQjQ5hhQ=;
        b=E21HQm7JiDFUAb9xbYm7pVxJvoivPwy9Nn8FxnrnPeGt3iEMIugUJlng/t7FczDKYZ
         KeqS8Dr0owv8Wbhla4xyFqWDE6D+ZJaCePzpoRKV9nkafAqz4/2MteGCdKRXpwtPOxDq
         cFbd+HYFMSSQAG9hS9re7LPCVBgAZscGNytoew1azxbf6QtF2hCXj/sVqppCW22wZR+j
         Sne9pXMD/BOrhsmRqro13UXdX9UGjJfcRgexsQlSzQH6VV+1VmrvWefhmtOuDD359Cdi
         n1sl9L9Z7JSm4SQdMCn2IzzCCAhVRYOK0fRawluyjE8hOHbqiMnqOldEbxy7PCan6QZC
         N2Kw==
X-Gm-Message-State: AOAM532hLFAKAokHPc/rwl9sJKTrLqCs+n76Oom9s0YfG6Lqpntf5Y98
        l3W9kPOoqJjcTH+PrNIZkX4=
X-Google-Smtp-Source: ABdhPJyOR8dIagWMAd48F7/lqO9zZIb3cZeL6GOT3FOT3gSGzynhyofPoZSmmB/nQdRsVxxNMxVL5Q==
X-Received: by 2002:ac8:57ca:: with SMTP id w10mr13739504qta.12.1611238985422;
        Thu, 21 Jan 2021 06:23:05 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id 38sm3528072qtb.67.2021.01.21.06.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 06:23:04 -0800 (PST)
Date:   Thu, 21 Jan 2021 07:23:03 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
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
Subject: Re: [PATCH bpf-next v3] samples/bpf: Update build procedure for
 manually compiling LLVM and Clang
Message-ID: <20210121142303.GA3346833@ubuntu-m3-large-x86>
References: <1611206855-22555-1-git-send-email-yangtiezhu@loongson.cn>
 <20210121053627.GA1680146@ubuntu-m3-large-x86>
 <CAEf4BzbZxuy8LRmngRzLZ3VTnrDw=Rf70Ghkbu1a5+fNpQud5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbZxuy8LRmngRzLZ3VTnrDw=Rf70Ghkbu1a5+fNpQud5Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 12:08:31AM -0800, Andrii Nakryiko wrote:
> On Wed, Jan 20, 2021 at 9:36 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > On Thu, Jan 21, 2021 at 01:27:35PM +0800, Tiezhu Yang wrote:
> > > The current LLVM and Clang build procedure in samples/bpf/README.rst is
> > > out of date. See below that the links are not accessible any more.
> > >
> > > $ git clone http://llvm.org/git/llvm.git
> > > Cloning into 'llvm'...
> > > fatal: unable to access 'http://llvm.org/git/llvm.git/': Maximum (20) redirects followed
> > > $ git clone --depth 1 http://llvm.org/git/clang.git
> > > Cloning into 'clang'...
> > > fatal: unable to access 'http://llvm.org/git/clang.git/': Maximum (20) redirects followed
> > >
> > > The LLVM community has adopted new ways to build the compiler. There are
> > > different ways to build LLVM and Clang, the Clang Getting Started page [1]
> > > has one way. As Yonghong said, it is better to copy the build procedure
> > > in Documentation/bpf/bpf_devel_QA.rst to keep consistent.
> > >
> > > I verified the procedure and it is proved to be feasible, so we should
> > > update README.rst to reflect the reality. At the same time, update the
> > > related comment in Makefile.
> > >
> > > Additionally, as Fangrui said, the dir llvm-project/llvm/build/install is
> > > not used, BUILD_SHARED_LIBS=OFF is the default option [2], so also change
> > > Documentation/bpf/bpf_devel_QA.rst together.
> > >
> > > [1] https://clang.llvm.org/get_started.html
> > > [2] https://www.llvm.org/docs/CMake.html
> > >
> > > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > > Acked-by: Yonghong Song <yhs@fb.com>
> >
> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> >
> > Small comment below.
> >
> > > ---
> > >
> > > v2: Update the commit message suggested by Yonghong,
> > >     thank you very much.
> > >
> > > v3: Remove the default option BUILD_SHARED_LIBS=OFF
> > >     and just mkdir llvm-project/llvm/build suggested
> > >     by Fangrui.
> > >
> > >  Documentation/bpf/bpf_devel_QA.rst |  3 +--
> > >  samples/bpf/Makefile               |  2 +-
> > >  samples/bpf/README.rst             | 16 +++++++++-------
> > >  3 files changed, 11 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
> > > index 5b613d2..18788bb 100644
> > > --- a/Documentation/bpf/bpf_devel_QA.rst
> > > +++ b/Documentation/bpf/bpf_devel_QA.rst
> > > @@ -506,11 +506,10 @@ that set up, proceed with building the latest LLVM and clang version
> > >  from the git repositories::
> > >
> > >       $ git clone https://github.com/llvm/llvm-project.git
> > > -     $ mkdir -p llvm-project/llvm/build/install
> > > +     $ mkdir -p llvm-project/llvm/build
> > >       $ cd llvm-project/llvm/build
> > >       $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
> > >                  -DLLVM_ENABLE_PROJECTS="clang"    \
> > > -                -DBUILD_SHARED_LIBS=OFF           \
> > >                  -DCMAKE_BUILD_TYPE=Release        \
> > >                  -DLLVM_BUILD_RUNTIME=OFF
> > >       $ ninja
> > > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > > index 26fc96c..d061446 100644
> > > --- a/samples/bpf/Makefile
> > > +++ b/samples/bpf/Makefile
> > > @@ -208,7 +208,7 @@ TPROGLDLIBS_xdpsock               += -pthread -lcap
> > >  TPROGLDLIBS_xsk_fwd          += -pthread
> > >
> > >  # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
> > > -#  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
> > > +# make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
> > >  LLC ?= llc
> > >  CLANG ?= clang
> > >  OPT ?= opt
> > > diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
> > > index dd34b2d..23006cb 100644
> > > --- a/samples/bpf/README.rst
> > > +++ b/samples/bpf/README.rst
> > > @@ -65,17 +65,19 @@ To generate a smaller llc binary one can use::
> > >  Quick sniplet for manually compiling LLVM and clang
> > >  (build dependencies are cmake and gcc-c++)::
> >
> > Technically, ninja is now a build dependency as well, it might be worth
> > mentioning that here (usually the package is ninja or ninja-build).
> 
> it's possible to generate Makefile by passing `-g "Unix Makefiles"`,
> which would avoid dependency on ninja, no?

Yes, although I am fairly certain that building with ninja is quicker so
I would recommend keeping it. One small extra dependency never killed
anyone plus ninja is becoming more common nowadays :)

> > Regardless of whether that is addressed or not (because it is small),
> > feel free to carry forward my tag in any future revisions unless they
> > drastically change.
> >
> > > - $ git clone http://llvm.org/git/llvm.git
> > > - $ cd llvm/tools
> > > - $ git clone --depth 1 http://llvm.org/git/clang.git
> > > - $ cd ..; mkdir build; cd build
> > > - $ cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86"
> > > - $ make -j $(getconf _NPROCESSORS_ONLN)
> > > + $ git clone https://github.com/llvm/llvm-project.git
> > > + $ mkdir -p llvm-project/llvm/build
> > > + $ cd llvm-project/llvm/build
> > > + $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
> > > +            -DLLVM_ENABLE_PROJECTS="clang"    \
> > > +            -DCMAKE_BUILD_TYPE=Release        \
> > > +            -DLLVM_BUILD_RUNTIME=OFF
> > > + $ ninja
> > >
> > >  It is also possible to point make to the newly compiled 'llc' or
> > >  'clang' command via redefining LLC or CLANG on the make command line::
> > >
> > > - make M=samples/bpf LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
> > > + make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
> > >
> > >  Cross compiling samples
> > >  -----------------------
> > > --
> > > 2.1.0
> > >

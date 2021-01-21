Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850F02FE1DC
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbhAUFiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbhAUFhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 00:37:11 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECA7C061575;
        Wed, 20 Jan 2021 21:36:31 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id 2so411868qvd.0;
        Wed, 20 Jan 2021 21:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YRumJLD36i/i0I1RZRrB7ojtk55MHsfJgYolCaTHYUM=;
        b=D4q9HrglSGGYD73X9szs+mKvlVLAdxnG1mS/YF+ZHg5KKX7cHDORZSbPfA18BMpsYe
         CNmXdMwAvhczLcF8vJVqE6xao9K5t/lGWKnFtkt1LojdN/YOjd8AR+iYrDtwW6Cd8uwh
         iug5lnkEHc9nPpDucvSHLGIcDDF/NPOqTeppnhqRjn1rNzmEMxYYSyfDPXgeh9gI4qH4
         hoJP70Q4dVbUzeLxX+ejnPry5qZF0t3JZjk/wCyoc66DZs94JF4NcNT7e3RGXLMTLXta
         8itkrO2GNes/Y7c7BjiTHq3K9MszGwMAlB1tn0D00zLFrp0PZoiW48UvuBTxfGd3cBpv
         IHTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YRumJLD36i/i0I1RZRrB7ojtk55MHsfJgYolCaTHYUM=;
        b=AyGehEmgQf+adxl/S+6gEusjcLKvJnhhTNPIJxEYIaCuv8fhS9t2I60YaubKmASKvX
         74vbyPkKcyqjvGUrO8yELqAa3QWShfP4PTo4foR0880rq1N8kpjRHlSVngyBTibz3Wb8
         IBQ9UQlajzT2gJiJ2RXAwvXltd4ect5YX/iEx/Um+l32Ivw0SAbk2ZEv4vZCrR13fY9T
         hBbAP6/6lK+Wy8gLAe7eKqKR82gjDliSvod0ds3XZdd/cppyYLttyY4kCWXYreTk7JHM
         XabPPyD6qXSM2ekN2nU5IRqZLvcs+iOwZfP0KAYBr/oVH3rG/ooqEWOYTJvgiRsAx6s3
         OvrQ==
X-Gm-Message-State: AOAM533/+BEqR7g39v7VNZyYHZvLE63eGMYp9GFbDbCYWTye5jmalFTq
        xnPP2ahqtrLjttvZReXmmgM=
X-Google-Smtp-Source: ABdhPJzWJDvmwpq8g9YwRKYQM2T1d9jbCuu+tQR+JC4UyTO9am54518roaqlEoqfrxPWtLEr8DlDGQ==
X-Received: by 2002:ad4:452f:: with SMTP id l15mr13110024qvu.49.1611207390223;
        Wed, 20 Jan 2021 21:36:30 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id a206sm3003810qkc.30.2021.01.20.21.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 21:36:29 -0800 (PST)
Date:   Wed, 20 Jan 2021 22:36:27 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Fangrui Song <maskray@google.com>
Subject: Re: [PATCH bpf-next v3] samples/bpf: Update build procedure for
 manually compiling LLVM and Clang
Message-ID: <20210121053627.GA1680146@ubuntu-m3-large-x86>
References: <1611206855-22555-1-git-send-email-yangtiezhu@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611206855-22555-1-git-send-email-yangtiezhu@loongson.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 01:27:35PM +0800, Tiezhu Yang wrote:
> The current LLVM and Clang build procedure in samples/bpf/README.rst is
> out of date. See below that the links are not accessible any more.
> 
> $ git clone http://llvm.org/git/llvm.git
> Cloning into 'llvm'...
> fatal: unable to access 'http://llvm.org/git/llvm.git/': Maximum (20) redirects followed
> $ git clone --depth 1 http://llvm.org/git/clang.git
> Cloning into 'clang'...
> fatal: unable to access 'http://llvm.org/git/clang.git/': Maximum (20) redirects followed
> 
> The LLVM community has adopted new ways to build the compiler. There are
> different ways to build LLVM and Clang, the Clang Getting Started page [1]
> has one way. As Yonghong said, it is better to copy the build procedure
> in Documentation/bpf/bpf_devel_QA.rst to keep consistent.
> 
> I verified the procedure and it is proved to be feasible, so we should
> update README.rst to reflect the reality. At the same time, update the
> related comment in Makefile.
> 
> Additionally, as Fangrui said, the dir llvm-project/llvm/build/install is
> not used, BUILD_SHARED_LIBS=OFF is the default option [2], so also change
> Documentation/bpf/bpf_devel_QA.rst together.
> 
> [1] https://clang.llvm.org/get_started.html
> [2] https://www.llvm.org/docs/CMake.html
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> Acked-by: Yonghong Song <yhs@fb.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

Small comment below.

> ---
> 
> v2: Update the commit message suggested by Yonghong,
>     thank you very much.
> 
> v3: Remove the default option BUILD_SHARED_LIBS=OFF
>     and just mkdir llvm-project/llvm/build suggested
>     by Fangrui.
> 
>  Documentation/bpf/bpf_devel_QA.rst |  3 +--
>  samples/bpf/Makefile               |  2 +-
>  samples/bpf/README.rst             | 16 +++++++++-------
>  3 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
> index 5b613d2..18788bb 100644
> --- a/Documentation/bpf/bpf_devel_QA.rst
> +++ b/Documentation/bpf/bpf_devel_QA.rst
> @@ -506,11 +506,10 @@ that set up, proceed with building the latest LLVM and clang version
>  from the git repositories::
>  
>       $ git clone https://github.com/llvm/llvm-project.git
> -     $ mkdir -p llvm-project/llvm/build/install
> +     $ mkdir -p llvm-project/llvm/build
>       $ cd llvm-project/llvm/build
>       $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
>                  -DLLVM_ENABLE_PROJECTS="clang"    \
> -                -DBUILD_SHARED_LIBS=OFF           \
>                  -DCMAKE_BUILD_TYPE=Release        \
>                  -DLLVM_BUILD_RUNTIME=OFF
>       $ ninja
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 26fc96c..d061446 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -208,7 +208,7 @@ TPROGLDLIBS_xdpsock		+= -pthread -lcap
>  TPROGLDLIBS_xsk_fwd		+= -pthread
>  
>  # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
> -#  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
> +# make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
>  LLC ?= llc
>  CLANG ?= clang
>  OPT ?= opt
> diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
> index dd34b2d..23006cb 100644
> --- a/samples/bpf/README.rst
> +++ b/samples/bpf/README.rst
> @@ -65,17 +65,19 @@ To generate a smaller llc binary one can use::
>  Quick sniplet for manually compiling LLVM and clang
>  (build dependencies are cmake and gcc-c++)::

Technically, ninja is now a build dependency as well, it might be worth
mentioning that here (usually the package is ninja or ninja-build).

Regardless of whether that is addressed or not (because it is small),
feel free to carry forward my tag in any future revisions unless they
drastically change.

> - $ git clone http://llvm.org/git/llvm.git
> - $ cd llvm/tools
> - $ git clone --depth 1 http://llvm.org/git/clang.git
> - $ cd ..; mkdir build; cd build
> - $ cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86"
> - $ make -j $(getconf _NPROCESSORS_ONLN)
> + $ git clone https://github.com/llvm/llvm-project.git
> + $ mkdir -p llvm-project/llvm/build
> + $ cd llvm-project/llvm/build
> + $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
> +            -DLLVM_ENABLE_PROJECTS="clang"    \
> +            -DCMAKE_BUILD_TYPE=Release        \
> +            -DLLVM_BUILD_RUNTIME=OFF
> + $ ninja
>  
>  It is also possible to point make to the newly compiled 'llc' or
>  'clang' command via redefining LLC or CLANG on the make command line::
>  
> - make M=samples/bpf LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
> + make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
>  
>  Cross compiling samples
>  -----------------------
> -- 
> 2.1.0
> 

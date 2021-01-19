Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F58B2FC2E4
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbhASV7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 16:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728420AbhASV7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 16:59:02 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C29C061757
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 13:58:19 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id v19so13799640pgj.12
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 13:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OFfub22SWSVkVrjpbdutuEU3cmHlEtcZeAWzURJZldA=;
        b=byWAnMtOBUGykkl0kVkQ6CQf0S8r8iH9Dmayu8mQxBp+45awWTtaLWZK+sCctNvNi6
         OQcM7YzgvoQP7vFoUOPAdHcq0Exc8A5qIltWrORr5GlbQu7OpEUlsRIIsRjOPMNEu8MM
         KJkJ9h2pBNSl3gpKFS1mHwd4Yh8pSmhLhQ+xsdSRbNG79hRNaoSkn4x7kFpQa70zpOTD
         2baF8bh7XZpGPB+vYEpB3YYp5CA8M37nZpiDjsHG2HM5Q0fM//zJbXVyQcJhoGFY2/US
         z2kIqi+reocUHP+UQdZF0D/NV28zsna2hcDSgpI8gW4EXq2SmBmeLi6f+WraBCQVK6ZK
         87OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OFfub22SWSVkVrjpbdutuEU3cmHlEtcZeAWzURJZldA=;
        b=R00YLxPPrLLJjMmcTud/qC6dLrPPV0MoPdEhZTkqpKuLa9FKXF06I6r1feDD687AqC
         6CtpDUMa/dFATELaUCLJhETbiKjc6yldTm5zIy8QgIGqPD21QcyyG1VUqBgI7N0NdFQi
         qWJ0aEVFu8XQN/5AV8tT9/eo8ZU1qpBWIDZBEOCJcMFlDyKTB20AzDT2FCvkmScm0kP4
         dZLhotkSOFPFnGqlFDpLy2XS103Dl/PY+RQ9D1GcvXjTanqouXZasTLImmEn9AeR29J6
         kbj726yyDY83DsBcgiOEozp5SN1AuYN6Ain+ulDgQ/Wpp70M50WkbNwwDbnd5hDaRsRS
         73uQ==
X-Gm-Message-State: AOAM531SsfHXyfZYYEULGVVs7gjOzOb/p+5H10A7KQv9weZj8hhdbWL2
        GIWGRKTBQH5GaFJDQvmRlzs1fA==
X-Google-Smtp-Source: ABdhPJzExoHgzCqXecb1f0EjKl//W+yhWbxdATLzYoDeYSbylPsBXmpqSv8BG01cnkxtHt/nHoKAEw==
X-Received: by 2002:a63:1f18:: with SMTP id f24mr6316123pgf.133.1611093499079;
        Tue, 19 Jan 2021 13:58:19 -0800 (PST)
Received: from google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
        by smtp.gmail.com with ESMTPSA id z29sm91002pfk.67.2021.01.19.13.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 13:58:18 -0800 (PST)
Date:   Tue, 19 Jan 2021 13:58:15 -0800
From:   Fangrui Song <maskray@google.com>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
Subject: Re: [PATCH bpf-next v2] samples/bpf: Update README.rst and Makefile
 for manually compiling LLVM and clang
Message-ID: <20210119215815.efyerbwwq5x2o26q@google.com>
References: <1611042978-21473-1-git-send-email-yangtiezhu@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1611042978-21473-1-git-send-email-yangtiezhu@loongson.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-19, Tiezhu Yang wrote:
>The current llvm/clang build procedure in samples/bpf/README.rst is
>out of date. See below that the links are not accessible any more.
>
>$ git clone http://llvm.org/git/llvm.git
>Cloning into 'llvm'...
>fatal: unable to access 'http://llvm.org/git/llvm.git/': Maximum (20) redirects followed
>$ git clone --depth 1 http://llvm.org/git/clang.git
>Cloning into 'clang'...
>fatal: unable to access 'http://llvm.org/git/clang.git/': Maximum (20) redirects followed
>
>The llvm community has adopted new ways to build the compiler. There are
>different ways to build llvm/clang, the Clang Getting Started page [1] has
>one way. As Yonghong said, it is better to just copy the build procedure
>in Documentation/bpf/bpf_devel_QA.rst to keep consistent.
>
>I verified the procedure and it is proved to be feasible, so we should
>update README.rst to reflect the reality. At the same time, update the
>related comment in Makefile.
>
>[1] https://clang.llvm.org/get_started.html
>
>Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>Acked-by: Yonghong Song <yhs@fb.com>
>---
>
>v2: Update the commit message suggested by Yonghong,
>    thank you very much.
>
> samples/bpf/Makefile   |  2 +-
> samples/bpf/README.rst | 17 ++++++++++-------
> 2 files changed, 11 insertions(+), 8 deletions(-)
>
>diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>index 26fc96c..d061446 100644
>--- a/samples/bpf/Makefile
>+++ b/samples/bpf/Makefile
>@@ -208,7 +208,7 @@ TPROGLDLIBS_xdpsock		+= -pthread -lcap
> TPROGLDLIBS_xsk_fwd		+= -pthread
>
> # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
>-#  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
>+# make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
> LLC ?= llc
> CLANG ?= clang
> OPT ?= opt
>diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
>index dd34b2d..d1be438 100644
>--- a/samples/bpf/README.rst
>+++ b/samples/bpf/README.rst
>@@ -65,17 +65,20 @@ To generate a smaller llc binary one can use::
> Quick sniplet for manually compiling LLVM and clang
> (build dependencies are cmake and gcc-c++)::
>
>- $ git clone http://llvm.org/git/llvm.git
>- $ cd llvm/tools
>- $ git clone --depth 1 http://llvm.org/git/clang.git
>- $ cd ..; mkdir build; cd build
>- $ cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86"
>- $ make -j $(getconf _NPROCESSORS_ONLN)
>+ $ git clone https://github.com/llvm/llvm-project.git
>+ $ mkdir -p llvm-project/llvm/build/install

llvm-project/llvm/build/install is not used.

>+ $ cd llvm-project/llvm/build
>+ $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
>+            -DLLVM_ENABLE_PROJECTS="clang"    \
>+            -DBUILD_SHARED_LIBS=OFF           \

-DBUILD_SHARED_LIBS=OFF is the default. It can be omitted.

>+            -DCMAKE_BUILD_TYPE=Release        \
>+            -DLLVM_BUILD_RUNTIME=OFF

-DLLVM_BUILD_RUNTIME=OFF can be omitted if none of
compiler-rt/libc++/libc++abi is built.

>+ $ ninja
>
> It is also possible to point make to the newly compiled 'llc' or
> 'clang' command via redefining LLC or CLANG on the make command line::
>
>- make M=samples/bpf LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
>+ make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
>
> Cross compiling samples
> -----------------------
>-- 
>2.1.0
>
>-- 
>You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
>To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
>To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/1611042978-21473-1-git-send-email-yangtiezhu%40loongson.cn.

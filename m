Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A612347E799
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349822AbhLWSVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbhLWSVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:21:51 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F37AC061401;
        Thu, 23 Dec 2021 10:21:51 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id f17so4843159ilj.11;
        Thu, 23 Dec 2021 10:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oRUs2l6ZeMJEDsITkS4VxxkYh4G2HLR8PEyMwu7ux5Y=;
        b=Z+oqpgoSb+vRReCCj+8rAPO1e/AxPHDRGYHVvJI5IgOFc8u9L4mzvJq2U2gcVlFWCV
         FNApvBRKv2YHQr58Y9TpjzCgWw2vclhF15mfGpkWRseX12nzr4sL5+apxo6RqgX/ZWnn
         z5u9rxvlEHRMskEWLVshOKBmr7AXln/ZhG3P4xurOzLPiJ7Ntqm/nIx9KTWmhzwrKU8V
         niysS/W7bG9Zjtf2cPWgS3UymJMI5W3znLPKpjSrn6+LVWf97QAX5zmMtBEUhKMzJPPF
         1UY1kYV7j9BZ91/dj7zCWN9siKq3Epa3ccycr2khMbJmYzmiLLapHNPUWixnBdHY4Kgj
         0Vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oRUs2l6ZeMJEDsITkS4VxxkYh4G2HLR8PEyMwu7ux5Y=;
        b=x2q7Nu3oZMSG9HPvzqg47WJI95bR7t8P4NgGYlQtk/pE7F+8C0FamYIe/cU5WhKWfG
         KjYdAhRRVfJ5xYmi7ozYBB5YZ9ST84Op3WBAopJPYA3YpkOgVvzliGsF+nsGrXRr72Iq
         9PKGKSmSIqOkSH/MtT2NUURlH2N+x6jPFjQiu+IRvW8hEx4P4WSwYSZQ+ZZ6L/xM2wST
         klHneajHmcCPr79LAIB92a2ZMqltkt3WqO0obZ3SUm7tlnGyq5IJAcToeCKmkYdBLkEr
         09Byf9GDeMAb/s4pgP3pO456aXI0GBnb3cUu0HGcq6zHh5VVeYfa84uImP3YMVWf/pSi
         7M4w==
X-Gm-Message-State: AOAM530Bcgf2yvZpHipzaNxClp6aRreQAyvNExTwDtTMQBtutuPaQoSH
        h4dMirWWZrbwCmb6ief9qXY2la1uRQ9hyb+PlJw=
X-Google-Smtp-Source: ABdhPJzppK8OQBJ8UFCCzqGUOU1/JpKognXqs+kdRlyz7hMf3MeFWh170Hw579k8dBLqZyDBJ7zuEHBlKqN56k5nKMk=
X-Received: by 2002:a05:6e02:1a21:: with SMTP id g1mr1640062ile.71.1640283710886;
 Thu, 23 Dec 2021 10:21:50 -0800 (PST)
MIME-Version: 1.0
References: <20211223052007.4111674-1-pulehui@huawei.com>
In-Reply-To: <20211223052007.4111674-1-pulehui@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 23 Dec 2021 10:21:39 -0800
Message-ID: <CAEf4BzY29kWicH0fdh9NnYu4nn1E4odL2ES2EYTGkyvHbo2c4g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Fix cross compiling error when
 using userspace pt_regs
To:     Pu Lehui <pulehui@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 8:56 PM Pu Lehui <pulehui@huawei.com> wrote:
>
> When cross compiling arm64 bpf selftests in x86_64 host, the following
> error occur:
>
> progs/loop2.c:20:7: error: incomplete definition of type 'struct
> user_pt_regs'
>
> Some archs, like arm64 and riscv, use userspace pt_regs in bpf_tracing.h.
> When arm64 bpf selftests cross compiling in x86_64 host, clang cannot
> find the arch specific uapi ptrace.h. We can add arch specific header
> file directory to fix this issue.
>
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
> v1->v2:
> - use vmlinux.h directly might lead to verifier fail.
> - use source arch header file directory suggested by Andrii Nakryiko.
>
>  tools/testing/selftests/bpf/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 42ffc24e9e71..1ecb6d192953 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -12,6 +12,7 @@ BPFDIR := $(LIBDIR)/bpf
>  TOOLSINCDIR := $(TOOLSDIR)/include
>  BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
>  APIDIR := $(TOOLSINCDIR)/uapi
> +ARCH_APIDIR := $(abspath ../../../../arch/$(SRCARCH)/include/uapi)
>  GENDIR := $(abspath ../../../../include/generated)
>  GENHDR := $(GENDIR)/autoconf.h
>
> @@ -294,7 +295,8 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
>  CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
>  BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)                  \
>              -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
> -            -I$(abspath $(OUTPUT)/../usr/include)
> +            -I$(abspath $(OUTPUT)/../usr/include)                      \
> +            -I$(ARCH_APIDIR)
>

This causes compilation error, see [0]. I think we'll have to wait for
my patch ([1]) to land and then add kernel-side variants for accessing
pt_regs.

  [0] https://github.com/kernel-patches/bpf/runs/4614606900?check_suite_focus=true
  [1] https://patchwork.kernel.org/project/netdevbpf/patch/20211222213924.1869758-1-andrii@kernel.org/


>  CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
>                -Wno-compare-distinct-pointer-types
> --
> 2.25.1
>

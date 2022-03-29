Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CC94EB71B
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 01:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241240AbiC2Xxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 19:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241256AbiC2Xx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 19:53:26 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE9A214043;
        Tue, 29 Mar 2022 16:51:34 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id h63so22937976iof.12;
        Tue, 29 Mar 2022 16:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=74O0cY+bOP3wHBSafmTjrdQXSiGpOdiTWDZVtBoQYXc=;
        b=WvcbotgBYKiLC714YGuezgXnN5lhQOgSKqIhHWIcs9SJ/TjZ4qDiqztKVhq/c/fbb7
         CRtEocnpbz+n+n5R4BSUrwuS9w0k9zSF+7f5EXq/mk6amSJaPcWyoRv3RhXelFYfeMxL
         6E82rTdvv4aC+vwPLUB3zQkanX7p8PkgSR49eK6jlxnnT+JBe4fF1F6F4YILiHIQ1Dfo
         YThyrVAbT2ezC4Vir9buU/Cc4wEcqylttF1i8ZPdMSV2rVOD8XZluQqt4Tq9JsLSMwr6
         /TK8qSeBHIm8gGPHU96piNQ1TWROyWk1JGmJNBYf3RhsSgpygDw04QQq8iXLcNuXa1/n
         SfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=74O0cY+bOP3wHBSafmTjrdQXSiGpOdiTWDZVtBoQYXc=;
        b=ctgEN0VYGSzWUpZBYk8xpBz6+KGrgfPifmjeplkjaCFzdX2NfL+WOxoyR7DElhQp6t
         ni3I/f4t9C9ano7pv5ChiXce3E2dWA7CHUfVpGyi7ylC+oIMICN9kgAH9/iqfXCBOOyK
         Jn2P6XdiCrsRfn9bTZea3nmO0v4skSPvJUfisFJxEnSMYCCAG+atOnYfjUqvLDCXNCS/
         +/9Axpp4ZfP+nf3rR7ZJ+f/il0BYa42udAvsMWAhApcOTN7+6lPEBtM+kFq1hXa/YKX3
         o3A0H5peqs7ZL/+pU8WpyfhHoLczTtsM3ZdJBI3Xzf+qv4j/eu8+n+tp6vL8azJZ8Lxx
         Tz2A==
X-Gm-Message-State: AOAM530qBxKDak1eHcileEbi12ctd84yA5YCmTNwdiWKhDZk79RN7KrA
        ghXP3oWGJ9B8GRkZqpaOtozm88jlkya0+paPhVM=
X-Google-Smtp-Source: ABdhPJwS9Fg+z09Kw/RcFYy3K93hJ67At+Bq0ikjVOdBE5T/1iZTAgYq3sbL/9qW5x19tnSgSohTJSUxFCaVijVlhWg=
X-Received: by 2002:a05:6638:148e:b0:321:6b54:d966 with SMTP id
 j14-20020a056638148e00b003216b54d966mr17338496jak.103.1648597893376; Tue, 29
 Mar 2022 16:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
In-Reply-To: <20220328175033.2437312-1-roberto.sassu@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Mar 2022 16:51:22 -0700
Message-ID: <CAEf4BzZNs-DYzQcE5LPxNzXDa+9A7QFszw99fnd2=cq9SuWsLg@mail.gmail.com>
Subject: Re: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF programs
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        Mimi Zohar <zohar@linux.ibm.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 10:51 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> eBPF already allows programs to be preloaded and kept running without
> intervention from user space. There is a dedicated kernel module called
> bpf_preload, which contains the light skeleton of the iterators_bpf eBPF
> program. If this module is enabled in the kernel configuration, its loading
> will be triggered when the bpf filesystem is mounted (unless the module is
> built-in), and the links of iterators_bpf are pinned in that filesystem
> (they will appear as the progs.debug and maps.debug files).
>
> However, the current mechanism, if used to preload an LSM, would not offer
> the same security guarantees of LSMs integrated in the security subsystem.
> Also, it is not generic enough to be used for preloading arbitrary eBPF
> programs, unless the bpf_preload code is heavily modified.
>
> More specifically, the security problems are:
> - any program can be pinned to the bpf filesystem without limitations
>   (unless a MAC mechanism enforces some restrictions);
> - programs being executed can be terminated at any time by deleting the
>   pinned objects or unmounting the bpf filesystem.
>
> The usability problems are:
> - only a fixed amount of links can be pinned;
> - only links can be pinned, other object types are not supported;
> - code to pin objects has to be written manually;
> - preloading multiple eBPF programs is not practical, bpf_preload has to be
>   modified to include additional light skeletons.
>
> Solve the security problems by mounting the bpf filesystem from the kernel,
> by preloading authenticated kernel modules (e.g. with module.sig_enforce)
> and by pinning objects to that filesystem. This particular filesystem
> instance guarantees that desired eBPF programs run until the very end of
> the kernel lifecycle, since even root cannot interfere with it.
>
> Solve the usability problems by generalizing the pinning function, to
> handle not only links but also maps and progs. Also increment the object
> reference count and call the pinning function directly from the preload
> method (currently in the bpf_preload kernel module) rather than from the
> bpf filesystem code itself, so that a generic eBPF program can do those
> operations depending on its objects (this also avoids the limitation of the
> fixed-size array for storing the objects to pin).
>
> Then, simplify the process of pinning objects defined by a generic eBPF
> program by automatically generating the required methods in the light
> skeleton. Also, generate a separate kernel module for each eBPF program to
> preload, so that existing ones don't have to be modified. Finally, support
> preloading multiple eBPF programs by allowing users to specify a list from
> the kernel configuration, at build time, or with the new kernel option
> bpf_preload_list=, at run-time.
>
> To summarize, this patch set makes it possible to plug in out-of-tree LSMs
> matching the security guarantees of their counterpart in the security
> subsystem, without having to modify the kernel itself. The same benefits
> are extended to other eBPF program types.
>
> Only one remaining problem is how to support auto-attaching eBPF programs
> with LSM type. It will be solved with a separate patch set.
>
> Patches 1-2 export some definitions, to build out-of-tree kernel modules
> with eBPF programs to preload. Patches 3-4 allow eBPF programs to pin
> objects by themselves. Patches 5-10 automatically generate the methods for
> preloading in the light skeleton. Patches 11-14 make it possible to preload
> multiple eBPF programs. Patch 15 automatically generates the kernel module
> for preloading an eBPF program, patch 16 does a kernel mount of the bpf
> filesystem, and finally patches 17-18 test the functionality introduced.
>

This approach of moving tons of pretty generic code into codegen of
lskel seems suboptimal. Why so much code has to be codegenerated?
Especially that tiny module code?

Can you please elaborate on why it can't be done in a way that doesn't
require such extensive light skeleton codegen changes?


> Roberto Sassu (18):
>   bpf: Export bpf_link_inc()
>   bpf-preload: Move bpf_preload.h to include/linux
>   bpf-preload: Generalize object pinning from the kernel
>   bpf-preload: Export and call bpf_obj_do_pin_kernel()
>   bpf-preload: Generate static variables
>   bpf-preload: Generate free_objs_and_skel()
>   bpf-preload: Generate preload()
>   bpf-preload: Generate load_skel()
>   bpf-preload: Generate code to pin non-internal maps
>   bpf-preload: Generate bpf_preload_ops
>   bpf-preload: Store multiple bpf_preload_ops structures in a linked
>     list
>   bpf-preload: Implement new registration method for preloading eBPF
>     programs
>   bpf-preload: Move pinned links and maps to a dedicated directory in
>     bpffs
>   bpf-preload: Switch to new preload registration method
>   bpf-preload: Generate code of kernel module to preload
>   bpf-preload: Do kernel mount to ensure that pinned objects don't
>     disappear
>   bpf-preload/selftests: Add test for automatic generation of preload
>     methods
>   bpf-preload/selftests: Preload a test eBPF program and check pinned
>     objects

please use proper prefixes: bpf (for kernel-side changes), libbpf,
bpftool, selftests/bpf, etc


>
>  .../admin-guide/kernel-parameters.txt         |   8 +
>  fs/namespace.c                                |   1 +
>  include/linux/bpf.h                           |   5 +
>  include/linux/bpf_preload.h                   |  37 ++
>  init/main.c                                   |   2 +
>  kernel/bpf/inode.c                            | 295 +++++++++--
>  kernel/bpf/preload/Kconfig                    |  25 +-
>  kernel/bpf/preload/bpf_preload.h              |  16 -
>  kernel/bpf/preload/bpf_preload_kern.c         |  85 +---
>  kernel/bpf/preload/iterators/Makefile         |   9 +-
>  .../bpf/preload/iterators/iterators.lskel.h   | 466 +++++++++++-------
>  kernel/bpf/syscall.c                          |   1 +
>  .../bpf/bpftool/Documentation/bpftool-gen.rst |  13 +
>  tools/bpf/bpftool/bash-completion/bpftool     |   6 +-
>  tools/bpf/bpftool/gen.c                       | 331 +++++++++++++
>  tools/bpf/bpftool/main.c                      |   7 +-
>  tools/bpf/bpftool/main.h                      |   1 +
>  tools/testing/selftests/bpf/Makefile          |  32 +-
>  .../bpf/bpf_testmod_preload/.gitignore        |   7 +
>  .../bpf/bpf_testmod_preload/Makefile          |  20 +
>  .../gen_preload_methods.expected.diff         |  97 ++++
>  .../bpf/prog_tests/test_gen_preload_methods.c |  27 +
>  .../bpf/prog_tests/test_preload_methods.c     |  69 +++
>  .../selftests/bpf/progs/gen_preload_methods.c |  23 +
>  24 files changed, 1246 insertions(+), 337 deletions(-)
>  create mode 100644 include/linux/bpf_preload.h
>  delete mode 100644 kernel/bpf/preload/bpf_preload.h
>  create mode 100644 tools/testing/selftests/bpf/bpf_testmod_preload/.gitignore
>  create mode 100644 tools/testing/selftests/bpf/bpf_testmod_preload/Makefile
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/gen_preload_methods.expected.diff
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_gen_preload_methods.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_preload_methods.c
>  create mode 100644 tools/testing/selftests/bpf/progs/gen_preload_methods.c
>
> --
> 2.32.0
>

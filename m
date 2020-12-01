Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A025B2CAF28
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 22:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgLAVvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 16:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728570AbgLAVvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:51:03 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0659C0613D6;
        Tue,  1 Dec 2020 13:50:22 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id v92so3291639ybi.4;
        Tue, 01 Dec 2020 13:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L9kVU2PJ20lL5ClGhEXuFi7VUk8Bcbp846sfmyeL6Ec=;
        b=MdCNept8o8xZa+YZ+5KEe20NddHCrcmXLLVzjjst8psguhXoSBIm9vuBT7vCkRDWVd
         053lQxTmzwUPYPuLHnFa5uPWJBLX69QKVA4us3uSsQO2kxsOZ0IYv7qrsnNvtSYlOMff
         f2122IuDujWELgY+PhVv/uOo36Qj7rJWyDhBWjrGoynHvnmYP0SlooqI3AE5XosZOgdO
         I/KeFzOmElMTfhMMrfmhbMcuAXk4K1bKq8+lTjYdAleGi+1E2BFWurgXI6KilU6Ekgwv
         CgrOM97vQh8HzKG70vjXHERqKCp2rNg3mxScelPk6JHaVwTu0qMrJcU5El56/goBNgKt
         dv6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L9kVU2PJ20lL5ClGhEXuFi7VUk8Bcbp846sfmyeL6Ec=;
        b=Kj3yxqQMh/Lubn9WaASxI5G5M9/Ko9wK+8ea4r3ajsl77Uv59rw5Iw22xciqRppyDh
         i56W7h03KM7HxRA8LAM7xfGKghFXD0qczjGyx7ci5zs86fG2vFHCYlCacqnhTUHjkU9D
         yCUZA2DSx2nuWZzf1mUWnFn+uL/PYSKdeWd2gZEh2vboG0dmVYqYOLH2H+XY9mdrp51T
         lFsnM0nwRM4qsCGp5vqevhB3815+B6fyEnm0Jcvdsr2BNYjtlJQaX9ZiaROtAvSRUGWS
         d/gUgi/8C4jqEIioJh+7pHJSmHdieZV3w+dMNcigsRbpm3a1goNIrioOErGWrjr1oL5o
         Htxw==
X-Gm-Message-State: AOAM531GJxXwlpcdXat/CK1IrW+On1j7kzylCjDdAPSXcoqamYYMV7bT
        5dUNSoODWNFLPaBt6ExbvKTJtPfwHVi3No056xc=
X-Google-Smtp-Source: ABdhPJyhNPVuJUg/iLnEQE39lL8iRw36CPabfhfxdgAGr+t1aiDyBQAcMb2IYzg53bD3l8PwgJiu3Pa89hBdzRcnN0I=
X-Received: by 2002:a25:585:: with SMTP id 127mr6283745ybf.425.1606859422320;
 Tue, 01 Dec 2020 13:50:22 -0800 (PST)
MIME-Version: 1.0
References: <20201201035545.3013177-1-andrii@kernel.org> <b29b91dd-a69c-30d3-59ca-4fa15b86492b@fb.com>
In-Reply-To: <b29b91dd-a69c-30d3-59ca-4fa15b86492b@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Dec 2020 13:50:11 -0800
Message-ID: <CAEf4BzYdHuB=utnxH0kWMorHwfRxakdwA27hqq90bDAbwS7+ew@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/8] Support BTF-powered BPF tracing programs
 for kernel modules
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/30/20 7:55 PM, Andrii Nakryiko wrote:
> > Building on top of two previous patch sets ([0] and not yet landed [1]), this
> > patch sets extends kernel and libbpf with support for attaching BTF-powered
> > raw tracepoint (tp_btf) and tracing (fentry/fexit/fmod_ret/lsm) BPF programs
> > to BPF hooks defined in kernel modules.
> >
> > Kernel UAPI for BPF_PROG_LOAD is extended with extra parameter
> > (attach_btf_obj_id) which allows to specify kernel module BTF in which the BTF
> > type is identifed by attach_btf_id.
> >
> >  From end user perspective there are no extra actions that need to happen.
> > Libbpf will continue searching across all kernel module BTFs, if desired
> > attach BTF type is not found in vmlinux. That way it doesn't matter if BPF
> > hook that user is trying to attach to is built-in into vmlinux image or is
> > loaded in kernel module.
> >
> > Currently pahole doesn't generate BTF_KIND_FUNC info for ftrace-able static
> > functions in kernel modules, so expose traced function in bpf_sidecar.ko. Once
>
> bpf_sidecar.ko => bpf_testmod.ko
>

will fix, thanks!

> > pahole is enhanced, we can go back to static function.
> >
> >    [0] https://patchwork.kernel.org/project/netdevbpf/list/?series=380759&state=*
> >    [1] https://patchwork.kernel.org/project/netdevbpf/list/?series=393677&state=*
> >
> > v1->v2:
> >    - avoid increasing bpf_reg_state by reordering fields (Alexei);
> >    - preserve btf_data_size in struct module;
> >    - rebase on top of v3 of patch [1].
> >
> > Andrii Nakryiko (8):
> >    bpf: keep module's btf_data_size intact after load
> >    bpf: remove hard-coded btf_vmlinux assumption from BPF verifier
> >    bpf: allow to specify kernel module BTFs when attaching BPF programs
> >    libbpf: factor out low-level BPF program loading helper
> >    libbpf: support attachment of BPF tracing programs to kernel modules
> >    selftests/bpf: add tp_btf CO-RE reloc test for modules
> >    selftests/bpf: make bpf_testmod's traceable function global
> >    selftests/bpf: add fentry/fexit/fmod_ret selftest for kernel module
> >
> >   include/linux/bpf.h                           |  13 +-
> >   include/linux/bpf_verifier.h                  |  28 +++-
> >   include/linux/btf.h                           |   7 +-
> >   include/uapi/linux/bpf.h                      |   1 +
> >   kernel/bpf/btf.c                              |  90 +++++++----
> >   kernel/bpf/syscall.c                          |  44 +++++-
> >   kernel/bpf/verifier.c                         |  77 ++++++----
> >   kernel/module.c                               |   1 -
> >   net/ipv4/bpf_tcp_ca.c                         |   3 +-
> >   tools/include/uapi/linux/bpf.h                |   1 +
> >   tools/lib/bpf/bpf.c                           | 101 ++++++++----
> >   tools/lib/bpf/libbpf.c                        | 145 +++++++++++++-----
> >   tools/lib/bpf/libbpf_internal.h               |  30 ++++
> >   .../selftests/bpf/bpf_testmod/bpf_testmod.c   |   3 +-
> >   .../selftests/bpf/prog_tests/core_reloc.c     |   3 +-
> >   .../selftests/bpf/prog_tests/module_attach.c  |  53 +++++++
> >   .../bpf/progs/test_core_reloc_module.c        |  32 +++-
> >   .../selftests/bpf/progs/test_module_attach.c  |  66 ++++++++
> >   18 files changed, 546 insertions(+), 152 deletions(-)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/module_attach.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_module_attach.c
> >

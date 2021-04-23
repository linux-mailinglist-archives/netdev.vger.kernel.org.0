Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9EC3698B7
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbhDWRz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhDWRz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 13:55:59 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52219C061574;
        Fri, 23 Apr 2021 10:55:22 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id i4so19036255ybe.2;
        Fri, 23 Apr 2021 10:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0/T8IlC4eTaPf6xmgmi85RESqkq77sy+2DF2148hbeY=;
        b=JniMiAhuLNjUtdizs6i1wQrZ82fzB5wKKPRxm4eii9HZMPKMaByWcgT8jYstmy2hCo
         tmASjAuSuI1pCRZV6u3TLqsoUNDHxmHeMjPGCuM+RlsN6loJd3kSBVgmrpyFHU95bjWD
         wRyXTEJkFBh6bkjcGArRUxCp9KP8u6kz4eMArvPrk1PG5bOkydkfrWB3Snt3xvcYysms
         2kl709EUUZYfZKalp+UQsd0CoVcr2BUwSbpEc/5MXzAb0JZGWcXeifIpG2SIKN3tff47
         Ao1vVi3A7ywJxmh1J348upQWkDax1xLGZnhrWNCIZE/i5Vf0FEIcAF2D+3Zcuw2gUaFS
         FpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0/T8IlC4eTaPf6xmgmi85RESqkq77sy+2DF2148hbeY=;
        b=krshbX1btVXKHlTQMFIaNXzPpK6y7YVFu8Qkc+BvutFpTlCvKMRXAAytDUMDpexVCg
         QtZ+LnpsW0QyPnHPplznmcdL6GQmuwwt6pzXNn49Weyxn+D6neNq2JIfjCTQDCVdpw4M
         Ywi+hYVONN7B+F12BSEMqYUUf8n+IWkR5EOMb7PolAXreNmyhAOI6oe9c6zacvlsuFSX
         dn1/+REMeTiU+esNm8zlr9mQ4cjx94yIK9JsfViprngkuy2266HmXUnJq5r6cugpdIIo
         V/MOKVEAca6Ixk3EwRb1wR/i6AF4KD/1y1Dihf6LbRlfgJwwe8+Pyx84WPPk6LLuyAJS
         wtFw==
X-Gm-Message-State: AOAM530WIs7gpP9hn4e20xaQkEbaX38DchFhhX65Roo16eJ5ij2xaJi1
        ++22azkWpfO8r1fQn8I+GEd4RGg7G8AFmvv8JEo=
X-Google-Smtp-Source: ABdhPJxo62G6/2EyHgSf2jC7Mxx5DGs5DSn8byaAm6FZ7H+TuEGOoXyETJRfPcHx+jp3shh9fxt8swA/OeYDtrdbXU0=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr6582299ybg.459.1619200520868;
 Fri, 23 Apr 2021 10:55:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-16-andrii@kernel.org>
 <3947e6ff-0b73-995e-630f-4a1252f8694b@fb.com> <CAEf4BzasVszkBCA0Ra2NsU+0ixoR65khF2E6h7CG_P3FOyamFQ@mail.gmail.com>
 <b49042fc-0af8-11f4-4316-39b0d6f0e6e4@fb.com>
In-Reply-To: <b49042fc-0af8-11f4-4316-39b0d6f0e6e4@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Apr 2021 10:55:09 -0700
Message-ID: <CAEf4BzbP+trfjW-_AwcLsmS=79jqXWoRbQJnSH2xkE=MOxN2Gg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 15/17] selftests/bpf: add function linking selftest
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

On Fri, Apr 23, 2021 at 10:35 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/23/21 10:18 AM, Andrii Nakryiko wrote:
> > On Thu, Apr 22, 2021 at 5:50 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 4/16/21 1:24 PM, Andrii Nakryiko wrote:
> >>> Add selftest validating various aspects of statically linking functions:
> >>>     - no conflicts and correct resolution for name-conflicting static funcs;
> >>>     - correct resolution of extern functions;
> >>>     - correct handling of weak functions, both resolution itself and libbpf's
> >>>       handling of unused weak function that "lost" (it leaves gaps in code with
> >>>       no ELF symbols);
> >>>     - correct handling of hidden visibility to turn global function into
> >>>       "static" for the purpose of BPF verification.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >>
> >> Ack with a small nit below.
> >>
> >> Acked-by: Yonghong Song <yhs@fb.com>
> >>
> >>> ---
> >>>    tools/testing/selftests/bpf/Makefile          |  3 +-
> >>>    .../selftests/bpf/prog_tests/linked_funcs.c   | 42 +++++++++++
> >>>    .../selftests/bpf/progs/linked_funcs1.c       | 73 +++++++++++++++++++
> >>>    .../selftests/bpf/progs/linked_funcs2.c       | 73 +++++++++++++++++++
> >>>    4 files changed, 190 insertions(+), 1 deletion(-)
> >>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_funcs.c
> >>>    create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs1.c
> >>>    create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs2.c
> >>>
> >>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> >>> index 666b462c1218..427ccfec1a6a 100644
> >>> --- a/tools/testing/selftests/bpf/Makefile
> >>> +++ b/tools/testing/selftests/bpf/Makefile
> >>> @@ -308,9 +308,10 @@ endef
> >>>
> >>>    SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
> >>>
> >>> -LINKED_SKELS := test_static_linked.skel.h
> >>> +LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h
> >>>
> >>>    test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
> >>> +linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
> >>>
> >>>    LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
> >>>
> >>> diff --git a/tools/testing/selftests/bpf/prog_tests/linked_funcs.c b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
> >>> new file mode 100644
> >>> index 000000000000..03bf8ef131ce
> >>> --- /dev/null
> >>> +++ b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
> >>> @@ -0,0 +1,42 @@
> >>> +// SPDX-License-Identifier: GPL-2.0
> >>> +/* Copyright (c) 2021 Facebook */
> >>> +
> >>> +#include <test_progs.h>
> >>> +#include <sys/syscall.h>
> >>> +#include "linked_funcs.skel.h"
> >>> +
> >>> +void test_linked_funcs(void)
> >>> +{
> >>> +     int err;
> >>> +     struct linked_funcs *skel;
> >>> +
> >>> +     skel = linked_funcs__open();
> >>> +     if (!ASSERT_OK_PTR(skel, "skel_open"))
> >>> +             return;
> >>> +
> >>> +     skel->rodata->my_tid = syscall(SYS_gettid);
> >>> +     skel->rodata->syscall_id = SYS_getpgid;
> >>> +
> >>> +     err = linked_funcs__load(skel);
> >>> +     if (!ASSERT_OK(err, "skel_load"))
> >>> +             goto cleanup;
> >>> +
> >>> +     err = linked_funcs__attach(skel);
> >>> +     if (!ASSERT_OK(err, "skel_attach"))
> >>> +             goto cleanup;
> >>> +
> >>> +     /* trigger */
> >>> +     syscall(SYS_getpgid);
> >>> +
> >>> +     ASSERT_EQ(skel->bss->output_val1, 2000 + 2000, "output_val1");
> >>> +     ASSERT_EQ(skel->bss->output_ctx1, SYS_getpgid, "output_ctx1");
> >>> +     ASSERT_EQ(skel->bss->output_weak1, 42, "output_weak1");
> >>> +
> >>> +     ASSERT_EQ(skel->bss->output_val2, 2 * 1000 + 2 * (2 * 1000), "output_val2");
> >>> +     ASSERT_EQ(skel->bss->output_ctx2, SYS_getpgid, "output_ctx2");
> >>> +     /* output_weak2 should never be updated */
> >>> +     ASSERT_EQ(skel->bss->output_weak2, 0, "output_weak2");
> >>> +
> >>> +cleanup:
> >>> +     linked_funcs__destroy(skel);
> >>> +}
> >>> diff --git a/tools/testing/selftests/bpf/progs/linked_funcs1.c b/tools/testing/selftests/bpf/progs/linked_funcs1.c
> >>> new file mode 100644
> >>> index 000000000000..cc621d4e4d82
> >>> --- /dev/null
> >>> +++ b/tools/testing/selftests/bpf/progs/linked_funcs1.c
> >>> @@ -0,0 +1,73 @@
> >>> +// SPDX-License-Identifier: GPL-2.0
> >>> +/* Copyright (c) 2021 Facebook */
> >>> +
> >>> +#include "vmlinux.h"
> >>> +#include <bpf/bpf_helpers.h>
> >>> +#include <bpf/bpf_tracing.h>
> >>> +
> >>> +/* weak and shared between two files */
> >>> +const volatile int my_tid __weak = 0;
> >>> +const volatile long syscall_id __weak = 0;
> >>
> >> Since the new compiler (llvm13) is recommended for this patch set.
> >> We can simplify the above two definition with
> >>     int my_tid __weak;
> >>     long syscall_id __weak;
> >> The same for the other file.
> >
> > This is not about old vs new compilers. I wanted to use .rodata
> > variables, but I'll switch to .bss, no problem.
>
> I see. You can actually hone one "const volatile ing my_tid __weak = 0"
> and another "long syscall_id __weak". This way, you will be able to
> test both .rodata and .bss section.

I wonder if you meant to have one my_tid __weak in .bss and another
my_tid __weak in .rodata. Or just my_tid in .bss and syscall_id in
.rodata?

If the former (mixing ELF sections across definitions of the same
symbol), then it's disallowed right now. libbpf will error out on
mismatched sections. I tested this with normal compilation, it does
work and the final section is the section of the winner.

But I think that's quite confusing, actually, so I'm going to leave it
disallowed for now. E.g., if one file expects a read-write variable
and another expects that same variable to be read-only, and the winner
ends up being read-only one, then the file expecting read-write will
essentially have incorrect code (and will be rejected by BPF verifier,
if anything attempts to write). So I think it's better to reject it at
the linking time.

But I'll do one (my_tid) as .bss, and another (syscall_id) as .rodata.

>
> >
> >>
> >> But I am also okay with the current form
> >> to *satisfy* llvm10 some people may still use.
> >>
> >>> +
> >>> +int output_val1 = 0;
> >>> +int output_ctx1 = 0;
> >>> +int output_weak1 = 0;
> >>> +
> >>> +/* same "subprog" name in all files, but it's ok because they all are static */
> >>> +static __noinline int subprog(int x)
> >>> +{
> >>> +     /* but different formula */
> >>> +     return x * 1;
> >>> +}
> >>> +
> >>> +/* Global functions can't be void */
> >>> +int set_output_val1(int x)
> >>> +{
> >>> +     output_val1 = x + subprog(x);
> >>> +     return x;
> >>> +}
> >>> +
> >>> +/* This function can't be verified as global, as it assumes raw_tp/sys_enter
> >>> + * context and accesses syscall id (second argument). So we mark it as
> >>> + * __hidden, so that libbpf will mark it as static in the final object file,
> >>> + * right before verifying it in the kernel.
> >>> + *
> >>> + * But we don't mark it as __hidden here, rather at extern site. __hidden is
> >>> + * "contaminating" visibility, so it will get propagated from either extern or
> >>> + * actual definition (including from the losing __weak definition).
> >>> + */
> >>> +void set_output_ctx1(__u64 *ctx)
> >>> +{
> >>> +     output_ctx1 = ctx[1]; /* long id, same as in BPF_PROG below */
> >>> +}
> >>> +
> >>> +/* this weak instance should win because it's the first one */
> >>> +__weak int set_output_weak(int x)
> >>> +{
> >>> +     output_weak1 = x;
> >>> +     return x;
> >>> +}
> >>> +
> >>> +extern int set_output_val2(int x);
> >>> +
> >>> +/* here we'll force set_output_ctx2() to be __hidden in the final obj file */
> >>> +__hidden extern void set_output_ctx2(__u64 *ctx);
> >>> +
> >> [...]

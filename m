Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B81B35FECD
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhDOAWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhDOAWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 20:22:11 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ADEC061574;
        Wed, 14 Apr 2021 17:21:46 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id x8so19022954ybx.2;
        Wed, 14 Apr 2021 17:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P3/xOUNpULi87onx5b5cTOUCJPGDoOi3gsuT3VQH+pQ=;
        b=MBPdVsdL+DNfiIWOeYMCYZXSd8y6oHShXZRpgxGztxnRp3mBz9/MW891FYMZR+ZIwx
         yERAlE7qwQNO0ES5VAR+kJz60TZzMVj8iPCOK62kDXv5KKpUw23OtpKAzuP4gyZi9nd+
         AuWKIseiMaMokpvj6uG2MFFTnvkQ3wCngD8ZuIGFbcXkXmCqQ7dJy7FSFdVnkDorLfAc
         tAjBMfCzr/V7e+3qBWpBAPLdXEGhveYgZlSPTaC7BZCZbWv5mJb9joVSEOnCRxALbgLJ
         PvkIi7jsycVB0xxeTX0zMZU1nnNqQbF/S1EqSgocJoW8x8PYVLoQLBeE7aC0SDnO6dZf
         XQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P3/xOUNpULi87onx5b5cTOUCJPGDoOi3gsuT3VQH+pQ=;
        b=esWmiNxlnxrlndkmVIupUAcAPDdi9Xh6gXoaCOkNLMTU5coprHO365WDyam50ezo53
         7gmlgObdqn2LOps80H5CMCcWgbLdPY44vPlVq9SV+BUcmYZFpqurOkuGcGgp9/uTknbm
         ywDxfXDZJCzlgPVq/QqG7sfWW8lg6VeDiKbNGGoTXIsM+hHNT95t7Z/ZriPhvBRqYZbP
         pG8GH1J80eUAfztxhpNP/VDTDth0Tpadr/tkmxjR0h9KVlZnaRIgor29dOKMWy2+Ny+d
         SBJMOPkSsC+9TOVZ/SsZ3jBZibO3NcvuIkxzL9GXi21rpWfcrQEzPQfoiqZC46uFev68
         pypQ==
X-Gm-Message-State: AOAM530InJ1tPO9Wuqei/CWzyPzg552Oi8cPtb51mxihMb1KtYkdf/MT
        pxndOYSIhznRmHeVXQiGHtzRZhwxfHHTCJ8uycu4pOAMPtI=
X-Google-Smtp-Source: ABdhPJw6jvE+l1F9k+caHHsMr1q85N2L38ztC+hHNUQCPWEcljNmkwPzlhcc4Dg/6ZtQzM2wm032ZUzFFhTBGmsixYA=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr789670ybf.425.1618446105945;
 Wed, 14 Apr 2021 17:21:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210414200146.2663044-1-andrii@kernel.org>
In-Reply-To: <20210414200146.2663044-1-andrii@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Apr 2021 17:21:35 -0700
Message-ID: <CAEf4BzaR5WyZ8h_6-0D91wvu2OOHAFAsWTMKEHkUbVqducLy_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/17] BPF static linker: support externs
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 1:02 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Add BPF static linker support for extern resolution of global variables,
> functions, and BTF-defined maps.
>
> This patch set consists of 4 parts:
>   - few patches are extending bpftool to simplify working with BTF dump;
>   - libbpf object loading logic is extended to support __hidden functions and
>     overriden (unused) __weak functions; also BTF-defined map parsing logic is
>     refactored to be re-used by linker;
>   - the crux of the patch set is BPF static linker logic extension to perform
>     extern resolution for three categories: global variables, BPF
>     sub-programs, BTF-defined maps;
>   - a set of selftests that validate that all the combinations of
>     extern/weak/__hidden are working as expected.
>
> See respective patches for more details.
>
> One aspect hasn't been addressed yet and is going to be resolved in the next
> patch set, but is worth mentioning. With BPF static linking of multiple .o
> files, dealing with static everything becomes more problematic for BPF
> skeleton and in general for any by name look up APIs. This is due to static
> entities are allowed to have non-unique name. Historically this was never
> a problem due to BPF programs were always confined to a single C file. That
> changes now and needs to be addressed. The thinking so far is for BPF static
> linker to prepend filename to each static variable and static map (which is
> currently not supported by libbpf, btw), so that they can be unambiguously
> resolved by (mostly) unique name. Mostly, because even filenames can be
> duplicated, but that should be rare and easy to address by wiser choice of
> filenames by users. Fortunately, static BPF subprograms don't suffer from this
> issues, as they are not independent entities and are neither exposed in BPF
> skeleton, nor is lookup-able by any of libbpf APIs (and there is little reason
> to do that anyways).
>
> This and few other things will be the topic of the next set of patches.
>

I forgot to mention that selftests are relying on Clang fix [0], which
is not yet in nightly builds, so kernel-patches CI is currently
failing a test. So, when/if testing locally, please make sure to build
Clang from latest main.

  [0] https://reviews.llvm.org/D100362

> Andrii Nakryiko (17):
>   bpftool: support dumping BTF VAR's "extern" linkage
>   bpftool: dump more info about DATASEC members
>   libbpf: suppress compiler warning when using SEC() macro with externs
>   libbpf: mark BPF subprogs with hidden visibility as static for BPF
>     verifier
>   libbpf: allow gaps in BPF program sections to support overriden weak
>     functions
>   libbpf: refactor BTF map definition parsing
>   libbpf: factor out symtab and relos sanity checks
>   libbpf: make few internal helpers available outside of libbpf.c
>   libbpf: extend sanity checking ELF symbols with externs validation
>   libbpf: tighten BTF type ID rewriting with error checking
>   libbpf: add linker extern resolution support for functions and global
>     variables
>   libbpf: support extern resolution for BTF-defined maps in .maps
>     section
>   selftests/bpf: use -O0 instead of -Og in selftests builds
>   selftests/bpf: omit skeleton generation for multi-linked BPF object
>     files
>   selftests/bpf: add function linking selftest
>   selftests/bpf: add global variables linking selftest
>   sleftests/bpf: add map linking selftest
>
>  tools/bpf/bpftool/btf.c                       |   30 +-
>  tools/lib/bpf/bpf_helpers.h                   |   19 +-
>  tools/lib/bpf/btf.c                           |    5 -
>  tools/lib/bpf/libbpf.c                        |  370 +++--
>  tools/lib/bpf/libbpf_internal.h               |   45 +
>  tools/lib/bpf/linker.c                        | 1292 ++++++++++++++---
>  tools/testing/selftests/bpf/Makefile          |   18 +-
>  .../selftests/bpf/prog_tests/linked_funcs.c   |   42 +
>  .../selftests/bpf/prog_tests/linked_maps.c    |   33 +
>  .../selftests/bpf/prog_tests/linked_vars.c    |   43 +
>  .../selftests/bpf/progs/linked_funcs1.c       |   73 +
>  .../selftests/bpf/progs/linked_funcs2.c       |   73 +
>  .../selftests/bpf/progs/linked_maps1.c        |  102 ++
>  .../selftests/bpf/progs/linked_maps2.c        |  112 ++
>  .../selftests/bpf/progs/linked_vars1.c        |   60 +
>  .../selftests/bpf/progs/linked_vars2.c        |   61 +
>  16 files changed, 2028 insertions(+), 350 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_funcs.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_maps.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_vars.c
>  create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/linked_maps1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/linked_maps2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/linked_vars1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/linked_vars2.c
>
> --
> 2.30.2
>

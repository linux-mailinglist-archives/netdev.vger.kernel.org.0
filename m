Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD60F4F0D5C
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 03:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376845AbiDDBQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 21:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245744AbiDDBQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 21:16:52 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B9F33365;
        Sun,  3 Apr 2022 18:14:55 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id g21so9509965iom.13;
        Sun, 03 Apr 2022 18:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2/vSmgn2rkgXSKZivb3tZX1ZeCMHbabU/7wAB0YlsNU=;
        b=IQv05/xW+7+82+8NSjHNP0vRP0uagTkUwYuCgDk8h7XUEmEU5ioOWFIH43fxFrCjkI
         b+hmKk2Y4+EVjUlBBVGJaLeoWanJapDngWWH5OzK+2rjW4JXzc4+nGKThjI0oxl7i8Sh
         2b5gUMwSY/RLMr6O6aat8EUiggDW8P8c4a0idx4n2GTX9Qxg4CbW5H1hlWJEuSbNeMb+
         pEK1jN/OHDUKi6edmEWyaW2KAItus6q+n5xTPJj/qwqtY95zg29tphdW6az1KofSXD3O
         77N612dpjQ6azdSrsgcZdUQFlDt0a+vEfCxV0qeGJWIuA7EY3m6UM7Pxt8uCOM9jbZ5d
         KOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2/vSmgn2rkgXSKZivb3tZX1ZeCMHbabU/7wAB0YlsNU=;
        b=Rga1Thzjbuk6Y7y5DCJj0DbvSh0UuhSuv9wGzLftR7Od5M750o4/sHZvB76DLiwUk3
         c43FHNyUiNBtlFhqawSqxiWwmYk8YvisrDFagbBHyGAkwKsbqtYCZPUqvTEB4fw6yGn1
         YplsfaPCuCLp91N1crs59NooxNTDquXVsYfMt0JWzRmyIbcL3sXWb8tCidKRqy4pwQUf
         55RYlCzGLyEDyff2M3Ad72sr49/1VIKAVdznN92mL8/XwhZi+9MtFlt+VCmlkHqttiM7
         g/dmTpXEs2YOQ38P7JNRflCWtHFrIVHoA6TzYEMQPYFlxjS97LKE6OseNcbp0NFd+S0c
         XPcw==
X-Gm-Message-State: AOAM530MSZNtGiiZGffUJuIlkLf2hadW41Q7qJIzpu9QsUK6wwbQebAW
        6rfPqQAm7KQPIpxOpKoON1WAhznDwLCd12rGIjk=
X-Google-Smtp-Source: ABdhPJzegAshy8tGgKyy2/ezLWHGvlKC+7rN/u5m9rAT1dy/fRb1z5jeonWoe6++cXieWzuUkGBZhG1fOL7l5hOQZqk=
X-Received: by 2002:a05:6638:3395:b0:323:8a00:7151 with SMTP id
 h21-20020a056638339500b003238a007151mr10615995jav.93.1649034894163; Sun, 03
 Apr 2022 18:14:54 -0700 (PDT)
MIME-Version: 1.0
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 18:14:43 -0700
Message-ID: <CAEf4BzZdV60ZeNt1YfS8qoB69pggSe+=gjnDZ1tZy00L4Quazw@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/5] libbpf: name-based u[ret]probe attach
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Wed, Mar 30, 2022 at 8:27 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> This patch series focuses on supporting name-based attach - similar
> to that supported for kprobes - for uprobe BPF programs.
>
> Currently attach for such probes is done by determining the offset
> manually, so the aim is to try and mimic the simplicity of kprobe
> attach, making use of uprobe opts to specify a name string.
> Patch 1 supports expansion of the binary_path argument used for
> bpf_program__attach_uprobe_opts(), allowing it to determine paths
> for programs and shared objects automatically, allowing for
> specification of "libc.so.6" rather than the full path
> "/usr/lib64/libc.so.6".
>
> Patch 2 adds the "func_name" option to allow uprobe attach by
> name; the mechanics are described there.
>
> Having name-based support allows us to support auto-attach for
> uprobes; patch 3 adds auto-attach support while attempting
> to handle backwards-compatibility issues that arise.  The format
> supported is
>
> u[ret]probe/binary_path:[raw_offset|function[+offset]]
>
> For example, to attach to libc malloc:
>
> SEC("uprobe//usr/lib64/libc.so.6:malloc")
>
> ..or, making use of the path computation mechanisms introduced in patch 1
>
> SEC("uprobe/libc.so.6:malloc")
>
> Finally patch 4 add tests to the attach_probe selftests covering
> attach by name, with patch 5 covering skeleton auto-attach.
>
> Changes since v4 [1]:
> - replaced strtok_r() usage with copying segments from static char *; avoids
>   unneeded string allocation (Andrii, patch 1)
> - switched to using access() instead of stat() when checking path-resolved
>   binary (Andrii, patch 1)
> - removed computation of .plt offset for instrumenting shared library calls
>   within binaries.  Firstly it proved too brittle, and secondly it was somewhat
>   unintuitive in that this form of instrumentation did not support function+offset
>   as the "local function in binary" and "shared library function in shared library"
>   cases did.  We can still instrument library calls, just need to do it in the
>   library .so (patch 2)

ah, that's too bad, it seemed like a nice and clever idea. What was
brittle? Curious to learn for the future.

The fact that function+offset isn't supported int this "mode" seems
totally fine to me, we can provide a nice descriptive error in this
case anyways.

Anyways, all the added functionality makes sense and we can further
improve on it if necessary and possible. I've found a few small issues
with your patches and fixed some of them while applying, please do a
follow up for the rest. Thanks, great work and great addition to
libbpf!


> - added binary path logging in cases where it was missing (Andrii, patch 2)
> - avoid strlen() calcuation in checking name match (Andrii, patch 2)
> - reword comments for func_name option (Andrii, patch 2)
> - tightened SEC() name validation to support "u[ret]probe" and fail on other
>   permutations that do not support auto-attach (i.e. have u[ret]probe/binary_path:func
>   format (Andrii, patch 3)
> - fixed selftests to fail independently rather than skip remainder on failure
>   (Andrii, patches 4,5)
> Changes since v3 [2]:
> - reworked variable naming to fit better with libbpf conventions
>   (Andrii, patch 2)
> - use quoted binary path in log messages (Andrii, patch 2)
> - added path determination mechanisms using LD_LIBRARY_PATH/PATH and
>   standard locations (patch 1, Andrii)
> - changed section lookup to be type+name (if name is specified) to
>   simplify use cases (patch 2, Andrii)
> - fixed .plt lookup scheme to match symbol table entries with .plt
>   index via the .rela.plt table; also fix the incorrect assumption
>   that the code in the .plt that does library linking is the same
>   size as .plt entries (it just happens to be on x86_64)
> - aligned with pluggable section support such that uprobe SEC() names
>   that do not conform to auto-attach format do not cause skeleton load
>   failure (patch 3, Andrii)
> - no longer need to look up absolute path to libraries used by test_progs
>   since we have mechanism to determine path automatically
> - replaced CHECK()s with ASSERT*()s for attach_probe test (Andrii, patch 4)
> - added auto-attach selftests also (Andrii, patch 5)
> Changes since RFC [3]:
> - used "long" for addresses instead of ssize_t (Andrii, patch 1).
> - used gelf_ interfaces to avoid assumptions about 64-bit
>   binaries (Andrii, patch 1)
> - clarified string matching in symbol table lookups
>   (Andrii, patch 1)
> - added support for specification of shared object functions
>   in a non-shared object binary.  This approach instruments
>   the Procedure Linking Table (PLT) - malloc@PLT.
> - changed logic in symbol search to check dynamic symbol table
>   first, then fall back to symbol table (Andrii, patch 1).
> - modified auto-attach string to require "/" separator prior
>   to path prefix i.e. uprobe//path/to/binary (Andrii, patch 2)
> - modified auto-attach string to use ':' separator (Andrii,
>   patch 2)
> - modified auto-attach to support raw offset (Andrii, patch 2)
> - modified skeleton attach to interpret -ESRCH errors as
>   a non-fatal "unable to auto-attach" (Andrii suggested
>   -EOPNOTSUPP but my concern was it might collide with other
>   instances where that value is returned and reflects a
>   failure to attach a to-be-expected attachment rather than
>   skip a program that does not present an auto-attachable
>   section name. Admittedly -EOPNOTSUPP seems a more natural
>   value here).
> - moved library path retrieval code to trace_helpers (Andrii,
>   patch 3)
>
> [1] https://lore.kernel.org/bpf/1647000658-16149-1-git-send-email-alan.maguire@oracle.com/
> [2] https://lore.kernel.org/bpf/1643645554-28723-1-git-send-email-alan.maguire@oracle.com/
> [3] https://lore.kernel.org/bpf/1642678950-19584-1-git-send-email-alan.maguire@oracle.com/
>
> Alan Maguire (5):
>   libbpf: bpf_program__attach_uprobe_opts() should determine paths for
>     programs/libraries where possible
>   libbpf: support function name-based attach uprobes
>   libbpf: add auto-attach for uprobes based on section name
>   selftests/bpf: add tests for u[ret]probe attach by name
>   selftests/bpf: add tests for uprobe auto-attach via skeleton
>
>  tools/lib/bpf/libbpf.c                             | 330 ++++++++++++++++++++-
>  tools/lib/bpf/libbpf.h                             |  10 +-
>  .../selftests/bpf/prog_tests/attach_probe.c        |  85 +++++-
>  .../selftests/bpf/prog_tests/uprobe_autoattach.c   |  38 +++
>  .../selftests/bpf/progs/test_attach_probe.c        |  41 ++-
>  .../selftests/bpf/progs/test_uprobe_autoattach.c   |  52 ++++
>  6 files changed, 535 insertions(+), 21 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
>
> --
> 1.8.3.1
>

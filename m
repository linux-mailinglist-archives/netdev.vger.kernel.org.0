Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCC8412AD0
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239212AbhIUB60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238300AbhIUB5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:57:20 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2328AC08EA3B;
        Mon, 20 Sep 2021 17:29:35 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id a10so48856786qka.12;
        Mon, 20 Sep 2021 17:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9WYHA1ADIeAF/q+IrRzT7f6TG2iOmFIT5qhHb1WD4SY=;
        b=n52RGfSr/euWak3WMYkjsIVhjNPZlL9PHi0lVToVGqRB2zIGd5xZEbbo4eN5eNyVV1
         BB5QBycs/Av78KwofVqFEm8uilNBCCUvoAAF2ejT2TzwQ361DtmNMHZpSv6iyI2He2Ar
         moypjbo9kIFZqd7U7aJuCF0ouBI7AyeHnbsAx/blG5soI8zlrvdkc3tpClwoHogUNWwZ
         7qP8myAm0jQ6x/PcnhBwB4vrnCE3H8JTXsut8LKuUkZ2ZYbhazGF6lggC40dPeTk2IJs
         R/NytqG7cL14YBgGIBj2fie0l15I2OI+dfCPBluQvvRt+7OhhvFObRlTVbirjHKU3pur
         Bmqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9WYHA1ADIeAF/q+IrRzT7f6TG2iOmFIT5qhHb1WD4SY=;
        b=GPzn7saM/04n927WGGOvn9QxbY0lj4GLkFBjYq56E2Nt+QwxE8wfBvIHb/YaeEuAFn
         giz2BMqDztoJ2h0KthlojXkyi69lAR2WW2BcfHQ7YXKpsYLUU37/oYjboNrW/COlvpc6
         E5+Ddpl2gaXcbxpHuoR0PlyV78feADi985ioCuX6bKHqiX7sqY62A8kSHamRGkKr6zpM
         QkQ6n7Bd36KkOL2KxlmVHy8QMEXHr+0DLAop7ZVrBFPB/CChSPu7ii+RfFaRQWfuVWGm
         i5Qw12Dh/4ajq0gqGbLO+WfjCqvueWuDUYPpaJj7tHaSfJ6jFxEpj4reUf6JomUzTK5e
         XrQg==
X-Gm-Message-State: AOAM530UEUD9dwxbPV81UA9D5iQpDPvFsnrxt0ECF0xIJrvApK9rBIt1
        dbxRobeEtRPvCtiXE2r5WOFCRgAQqObP2opkbzw=
X-Google-Smtp-Source: ABdhPJxhi2CU0vH8WHBEzspNdMxMDmR2S+HWuaOF+Bv4B3Rv/eYkTGup5dhDdUKEqSk76GqZxi5OpnwLkJaYt5CB6eI=
X-Received: by 2002:a25:1bc5:: with SMTP id b188mr34253077ybb.267.1632184173982;
 Mon, 20 Sep 2021 17:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210920141526.3940002-1-memxor@gmail.com>
In-Reply-To: <20210920141526.3940002-1-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 20 Sep 2021 17:29:22 -0700
Message-ID: <CAEf4Bzb1zRX1=VsMtQF9Kee=OGbtcgSrvPT3UhoAz5vsvL=WOA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 00/11] Support kernel module function calls
 from eBPF
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This set enables kernel module function calls, and also modifies verifier logic
> to permit invalid kernel function calls as long as they are pruned as part of
> dead code elimination. This is done to provide better runtime portability for
> BPF objects, which can conditionally disable parts of code that are pruned later
> by the verifier (e.g. const volatile vars, kconfig options). libbpf
> modifications are made along with kernel changes to support module function
> calls. The set includes gen_loader support for emitting kfunc relocations.
>
> It also converts TCP congestion control objects to use the module kfunc support
> instead of relying on IS_BUILTIN ifdef.
>
> Changelog:
> ----------
> v3 -> v4

Please use vmtest.sh locally to test everything. That should help to
avoid breaking our CI ([0]):

  test_ksyms_module_libbpf:PASS:test_ksyms_module_libbpf__open 0 nsec
  test_ksyms_module_libbpf:PASS:bpf_program__set_autoload false
load_fail1 0 nsec
  test_ksyms_module_libbpf:PASS:bpf_program__set_autoload false
load_fail2 0 nsec
  libbpf: load bpf program failed: Invalid argument
  libbpf: -- BEGIN DUMP LOG ---
  libbpf:
  kernel btf_id 81786 is not a function
  processed 0 insns (limit 1000000) max_states_per_insn 0 total_states
0 peak_states 0 mark_read 0

  libbpf: -- END LOG --
  libbpf: failed to load program 'handler'
  libbpf: failed to load object 'test_ksyms_module_libbpf'
  libbpf: failed to load BPF skeleton 'test_ksyms_module_libbpf': -4007
  test_ksyms_module_libbpf:FAIL:test_ksyms_module_libbpf__load
unexpected error: -4007 (errno 4007)
  #66 ksyms_module_libbpf:FAIL

  test_module_attach:PASS:skel_open 0 nsec
  test_module_attach:PASS:set_attach_target 0 nsec
  libbpf: load bpf program failed: Invalid argument
  libbpf: -- BEGIN DUMP LOG ---
  libbpf:
  attach_btf_id 81768 is invalid
  processed 0 insns (limit 1000000) max_states_per_insn 0 total_states
0 peak_states 0 mark_read 0

  libbpf: -- END LOG --
  libbpf: failed to load program 'handle_tp_btf'
  libbpf: failed to load object 'test_module_attach'
  libbpf: failed to load BPF skeleton 'test_module_attach': -4007
  test_module_attach:FAIL:skel_load failed to load skeleton
  #81 module_attach:FAIL

  [0] https://github.com/kernel-patches/bpf/pull/1807/checks?check_run_id=3652765027


> v3: https://lore.kernel.org/bpf/20210915050943.679062-1-memxor@gmail.com
>
>  * Address comments from Alexei
>    * Drop MAX_BPF_STACK change, instead move map_fd and BTF fd to BPF array map
>      and pass fd_array using BPF_PSEUDO_MAP_IDX_VALUE
>  * Address comments from Andrii
>    * Fix selftest to store to variable for observing function call instead of
>      printk and polluting CI logs
>  * Drop use of raw_tp for testing, instead reuse classifier based prog_test_run
>  * Drop index + 1 based insn->off convention for kfunc module calls
>  * Expand selftests to cover more corner cases
>  * Misc cleanups
>
> v2 -> v3
> v2: https://lore.kernel.org/bpf/20210914123750.460750-1-memxor@gmail.com
>
>  * Fix issues pointed out by Kernel Test Robot
>  * Fix find_kfunc_desc to also take offset into consideration when comparing
>
> RFC v1 -> v2
> v1: https://lore.kernel.org/bpf/20210830173424.1385796-1-memxor@gmail.com
>
>  * Address comments from Alexei
>    * Reuse fd_array instead of introducing kfunc_btf_fds array
>    * Take btf and module reference as needed, instead of preloading
>    * Add BTF_KIND_FUNC relocation support to gen_loader infrastructure
>  * Address comments from Andrii
>    * Drop hashmap in libbpf for finding index of existing BTF in fd_array
>    * Preserve invalid kfunc calls only when the symbol is weak
>  * Adjust verifier selftests
>
> Kumar Kartikeya Dwivedi (11):
>   bpf: Introduce BPF support for kernel module function calls
>   bpf: Be conservative while processing invalid kfunc calls
>   bpf: btf: Introduce helpers for dynamic BTF set registration
>   tools: Allow specifying base BTF file in resolve_btfids
>   bpf: Enable TCP congestion control kfunc from modules
>   libbpf: Support kernel module function calls
>   libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
>   libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
>   tools: bpftool: Add separate fd_array map support for light skeleton
>   libbpf: Fix skel_internal.h to set errno on loader retval < 0
>   bpf: selftests: Add selftests for module kfunc support
>
>  include/linux/bpf.h                           |   8 +-
>  include/linux/bpf_verifier.h                  |   2 +
>  include/linux/bpfptr.h                        |   1 +
>  include/linux/btf.h                           |  37 +++
>  kernel/bpf/btf.c                              |  56 +++++
>  kernel/bpf/core.c                             |   4 +
>  kernel/bpf/verifier.c                         | 220 ++++++++++++++---
>  net/bpf/test_run.c                            |   7 +-
>  net/ipv4/bpf_tcp_ca.c                         |  36 +--
>  net/ipv4/tcp_bbr.c                            |  28 ++-
>  net/ipv4/tcp_cubic.c                          |  26 +-
>  net/ipv4/tcp_dctcp.c                          |  26 +-
>  scripts/Makefile.modfinal                     |   1 +
>  tools/bpf/bpftool/gen.c                       |   3 +-
>  tools/bpf/bpftool/prog.c                      |   1 +
>  tools/bpf/resolve_btfids/main.c               |  19 +-
>  tools/lib/bpf/bpf.c                           |   1 +
>  tools/lib/bpf/bpf_gen_internal.h              |  16 +-
>  tools/lib/bpf/gen_loader.c                    | 222 +++++++++++++++---
>  tools/lib/bpf/libbpf.c                        |  83 +++++--
>  tools/lib/bpf/libbpf.h                        |   1 +
>  tools/lib/bpf/libbpf_internal.h               |   1 +
>  tools/lib/bpf/skel_internal.h                 |  33 ++-
>  tools/testing/selftests/bpf/Makefile          |   5 +-
>  .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  26 +-
>  .../selftests/bpf/prog_tests/ksyms_module.c   |  52 ++--
>  .../bpf/prog_tests/ksyms_module_libbpf.c      |  44 ++++
>  .../selftests/bpf/progs/test_ksyms_module.c   |  41 +++-
>  .../bpf/progs/test_ksyms_module_fail.c        |  29 +++
>  .../progs/test_ksyms_module_fail_toomany.c    |  19 ++
>  .../bpf/progs/test_ksyms_module_libbpf.c      |  71 ++++++
>  .../bpf/progs/test_ksyms_module_util.h        |  48 ++++
>  32 files changed, 1014 insertions(+), 153 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_fail.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_fail_toomany.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_util.h
>
> --
> 2.33.0
>

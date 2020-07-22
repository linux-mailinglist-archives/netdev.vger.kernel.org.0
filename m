Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39086228EA0
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 05:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731879AbgGVD3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 23:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731793AbgGVD3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 23:29:36 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01237C061794;
        Tue, 21 Jul 2020 20:29:35 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x9so288399plr.2;
        Tue, 21 Jul 2020 20:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gWIqjRx1ydkKXt2vRC3hk7iQ52o0Y4NnSXWYajSS8to=;
        b=ByJADRlfWVQggS3lOeBVoTyQX74KfGvQmXfmDxm/h0Ubg18nQ7drdOmUWSySUTRuPa
         f6OcsPlc9Uqg17Uda6cYs2FQoUxp4b8evipyZzw0iIIX5uZBm+w6GFsiSx/GkaCaryU1
         M81VLb2HHCPdp1WHq2NyMloJZztst7Fz4PCxBupmh9gBQhrpTUkRMUE/K9IAqqqfWpMN
         6F6/XDoLZP8/R5OmnSfvXhfB0FigsnEgQsD1HCRQpABlXsO7VmaXTP/WncN+nDU7LQUA
         7HuiYHUIhWVJDde0Ox0fHoiaxICXYKvsyJMjhiJ4D5tKSbCwvfP2tRXjMJ+e5Ve7EdBN
         403A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gWIqjRx1ydkKXt2vRC3hk7iQ52o0Y4NnSXWYajSS8to=;
        b=LmmfHR91cSkvzvQzWgZebw8INT41FuDgJNez7G1hZ28+Nck9J+tnj355xIiDiO7xKr
         1FM5MEIbRAp/DzC36cN3gWUk7IDwtkQErC4S9d+jINwo2JMoo7cgB+afqtUtHKpPvgaN
         rc4+StUF+WiF3evbbL7xeMZlV0Ur/fAHRuyxz2XUxGThd9ZPYXbLzBvckvr87ygK8EPx
         uGnWZyjFywxiH5ObGuyg+3z3aFwLssdey4f2ttNP2mgUbsl7oQK2fg24+1O+tuQfnzL9
         93HemxVUo9vhavsGSxflS0nUU4oSEiLIngAli6UUnAJXMEKt3GV2zH6vvXLMq0XcBKiM
         EQ9g==
X-Gm-Message-State: AOAM530lypLYRJ5IJCbzP+0XGhA8wH9WuNokP2sEflnXwKKHtZBPbpJz
        BhquoQsb50Loh6MGgCkb/Eg=
X-Google-Smtp-Source: ABdhPJxLfD6w3I/cmImYbXJVfXTDGSLeW7pWnrSuYelMGhE4+P882psWJg0+EGMZBuOBZfqY/77How==
X-Received: by 2002:a17:90a:e50c:: with SMTP id t12mr7836408pjy.209.1595388575335;
        Tue, 21 Jul 2020 20:29:35 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id ga7sm4526386pjb.50.2020.07.21.20.29.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 20:29:34 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf-next 2020-07-21
Date:   Tue, 21 Jul 2020 20:29:32 -0700
Message-Id: <20200722032932.62060-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 46 non-merge commits during the last 6 day(s) which contain
a total of 68 files changed, 4929 insertions(+), 526 deletions(-).

The main changes are:

1) Run BPF program on socket lookup, from Jakub.

2) Introduce cpumap, from Lorenzo.

3) s390 JIT fixes, from Ilya.

4) teach riscv JIT to emit compressed insns, from Luke.

5) use build time computed BTF ids in bpf iter, from Yonghong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Ilya Leoshkevich, Jakub Sitnicki, Jesper Dangaard 
Brouer, Jiri Olsa, Quentin Monnet, Randy Dunlap, Seth Forshee, Stephen 
Rothwell

----------------------------------------------------------------

The following changes since commit 9b74ebb2b0f259474da65fa0178c657e5fa5c640:

  cpumap: Use non-locked version __ptr_ring_consume_batched (2020-07-16 17:00:31 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 9165e1d70fb34ce438e78aad90408cfa86e4c2d0:

  bpftool: Use only nftw for file tree parsing (2020-07-21 23:42:56 +0200)

----------------------------------------------------------------
Alexei Starovoitov (3):
      Merge branch 'bpf-socket-lookup'
      Merge branch 'compressed-JITed-insn'
      Merge branch 'bpf_iter-BTF_ID-at-build-time'

David Ahern (1):
      net: Refactor xdp_convert_buff_to_frame

Ian Rogers (1):
      libbpf bpf_helpers: Use __builtin_offsetof for offsetof

Ilya Leoshkevich (7):
      selftests: bpf: test_kmod.sh: Fix running out of srctree
      s390/bpf: Fix sign extension in branch_ku
      s390/bpf: Use brcl for jumping to exit_ip if necessary
      s390/bpf: Tolerate not converging code shrinking
      s390/bpf: Use bpf_skip() in bpf_jit_prologue()
      selftests/bpf: Fix test_lwt_seg6local.sh hangs
      samples/bpf, selftests/bpf: Use bpf_probe_read_kernel

Jakub Sitnicki (16):
      bpf, netns: Handle multiple link attachments
      bpf: Introduce SK_LOOKUP program type with a dedicated attach point
      inet: Extract helper for selecting socket from reuseport group
      inet: Run SK_LOOKUP BPF program on socket lookup
      inet6: Extract helper for selecting socket from reuseport group
      inet6: Run SK_LOOKUP BPF program on socket lookup
      udp: Extract helper for selecting socket from reuseport group
      udp: Run SK_LOOKUP BPF program on socket lookup
      udp6: Extract helper for selecting socket from reuseport group
      udp6: Run SK_LOOKUP BPF program on socket lookup
      bpf: Sync linux/bpf.h to tools/
      libbpf: Add support for SK_LOOKUP program type
      tools/bpftool: Add name mappings for SK_LOOKUP prog and attach type
      selftests/bpf: Add verifier tests for bpf_sk_lookup context access
      selftests/bpf: Tests for BPF_SK_LOOKUP attach point
      bpf, netns: Fix build without CONFIG_INET

Lorenzo Bianconi (8):
      samples/bpf: xdp_redirect_cpu_user: Do not update bpf maps in option loop
      cpumap: Formalize map value as a named struct
      bpf: cpumap: Add the possibility to attach an eBPF program to cpumap
      bpf: cpumap: Implement XDP_REDIRECT for eBPF programs attached to map entries
      libbpf: Add SEC name for xdp programs attached to CPUMAP
      samples/bpf: xdp_redirect_cpu: Load a eBPF program on cpumap
      selftest: Add tests for XDP programs in CPUMAP entries
      bpf: cpumap: Fix possible rcpu kthread hung

Luke Nelson (3):
      bpf, riscv: Modify JIT ctx to support compressed instructions
      bpf, riscv: Add encodings for compressed instructions
      bpf, riscv: Use compressed instructions in the rv64 JIT

Randy Dunlap (1):
      bpf: Drop duplicated words in uapi helper comments

Seth Forshee (1):
      bpf: revert "test_bpf: Flag tests that cannot be jited on s390"

Stanislav Fomichev (1):
      selftests/bpf: Fix possible hang in sockopt_inherit

Tony Ambardar (1):
      bpftool: Use only nftw for file tree parsing

Yonghong Song (5):
      bpf: Compute bpf_skc_to_*() helper socket btf ids at build time
      tools/bpf: Sync btf_ids.h to tools
      bpf: Add BTF_ID_LIST_GLOBAL in btf_ids.h
      bpf: Make btf_sock_ids global
      bpf: net: Use precomputed btf_id for bpf iterators

YueHaibing (1):
      tools/bpftool: Fix error handing in do_skeleton()

 arch/riscv/net/bpf_jit.h                           |  483 +++++++-
 arch/riscv/net/bpf_jit_comp32.c                    |   14 +-
 arch/riscv/net/bpf_jit_comp64.c                    |  293 ++---
 arch/riscv/net/bpf_jit_core.c                      |    6 +-
 arch/s390/net/bpf_jit_comp.c                       |   63 +-
 include/linux/bpf-netns.h                          |    3 +
 include/linux/bpf.h                                |   15 +-
 include/linux/bpf_types.h                          |    2 +
 include/linux/btf_ids.h                            |   40 +-
 include/linux/filter.h                             |  147 +++
 include/net/xdp.h                                  |   41 +-
 include/trace/events/xdp.h                         |   16 +-
 include/uapi/linux/bpf.h                           |   97 +-
 kernel/bpf/btf.c                                   |    6 +-
 kernel/bpf/core.c                                  |   55 +
 kernel/bpf/cpumap.c                                |  167 ++-
 kernel/bpf/map_iter.c                              |    7 +-
 kernel/bpf/net_namespace.c                         |  131 +-
 kernel/bpf/syscall.c                               |    9 +
 kernel/bpf/task_iter.c                             |   12 +-
 kernel/bpf/verifier.c                              |   13 +-
 lib/test_bpf.c                                     |   20 -
 net/core/dev.c                                     |    9 +
 net/core/filter.c                                  |  228 +++-
 net/ipv4/inet_hashtables.c                         |   60 +-
 net/ipv4/tcp_ipv4.c                                |    4 +-
 net/ipv4/udp.c                                     |   97 +-
 net/ipv6/inet6_hashtables.c                        |   66 +-
 net/ipv6/route.c                                   |    7 +-
 net/ipv6/udp.c                                     |   97 +-
 net/netlink/af_netlink.c                           |    7 +-
 samples/bpf/offwaketime_kern.c                     |    7 +-
 samples/bpf/test_overhead_kprobe_kern.c            |   12 +-
 samples/bpf/tracex1_kern.c                         |    9 +-
 samples/bpf/tracex5_kern.c                         |    4 +-
 samples/bpf/xdp_redirect_cpu_kern.c                |   25 +-
 samples/bpf/xdp_redirect_cpu_user.c                |  209 +++-
 scripts/bpf_helpers_doc.py                         |    9 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |    2 +-
 tools/bpf/bpftool/bash-completion/bpftool          |    2 +-
 tools/bpf/bpftool/common.c                         |  138 ++-
 tools/bpf/bpftool/gen.c                            |    5 +-
 tools/bpf/bpftool/main.h                           |    4 +-
 tools/bpf/bpftool/prog.c                           |    3 +-
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c          |    3 +-
 tools/include/linux/btf_ids.h                      |   51 +-
 tools/include/uapi/linux/bpf.h                     |   97 +-
 tools/lib/bpf/bpf_helpers.h                        |    2 +-
 tools/lib/bpf/libbpf.c                             |    5 +
 tools/lib/bpf/libbpf.h                             |    2 +
 tools/lib/bpf/libbpf.map                           |    2 +
 tools/lib/bpf/libbpf_probes.c                      |    3 +
 tools/testing/selftests/bpf/network_helpers.c      |   58 +-
 tools/testing/selftests/bpf/network_helpers.h      |    2 +
 .../selftests/bpf/prog_tests/resolve_btfids.c      |   34 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 1282 ++++++++++++++++++++
 .../selftests/bpf/prog_tests/sockopt_inherit.c     |    3 +-
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |   70 ++
 .../testing/selftests/bpf/progs/bpf_iter_netlink.c |    6 +-
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  |    2 +-
 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c  |    2 +-
 tools/testing/selftests/bpf/progs/bpf_iter_udp4.c  |    2 +-
 tools/testing/selftests/bpf/progs/bpf_iter_udp6.c  |    2 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |  641 ++++++++++
 .../bpf/progs/test_xdp_with_cpumap_helpers.c       |   36 +
 tools/testing/selftests/bpf/test_kmod.sh           |   12 +-
 tools/testing/selftests/bpf/test_lwt_seg6local.sh  |    2 +-
 .../testing/selftests/bpf/verifier/ctx_sk_lookup.c |  492 ++++++++
 68 files changed, 4929 insertions(+), 526 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
 create mode 100644 tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c

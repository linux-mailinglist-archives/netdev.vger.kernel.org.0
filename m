Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592221D435A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 04:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgEOCD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 22:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgEOCDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 22:03:25 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8ABC061A0C;
        Thu, 14 May 2020 19:03:25 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f4so247316pgi.10;
        Thu, 14 May 2020 19:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=atYh4vCwWfnf9BLzEqKma4xEX8cln0qVXg/y8Armhrg=;
        b=I4vu5MWTdF7ZaToFmfQzYC+4QlYcE9ZgSFTU2J6VTTSTgF1PnfCJuhUTpSvAGnca+K
         6ar8Ww9POQSc+V/EqqMY33WxCP8FcmVmCXvdKHAB4F9GkBClB8NhimKvAdFHLZ01hmyW
         H0Iy9pokkb541WZ9bg0Xx7brv0Ktb3zpPeN9/jLYOBSsvjHDqe+OpvSO40jO+yHbba10
         EB3JleOC+HWo7WMDf7hlN9yyi2VimJN1Qi5OmvU9OltW4jjQvuVCLKLjJrALWnVhThSX
         KtE8lqHWJv58E9O8rwqQZw4Cwdsyrjlb1J76RzYpBwBpHOAAhFzC0eN0bfmoDhkZt37M
         M+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=atYh4vCwWfnf9BLzEqKma4xEX8cln0qVXg/y8Armhrg=;
        b=cGLMnK9NOzLBvB93Xfr42lTfxi2XEonsn32Z6QAS5DVH6BwWluxMqYGkWuyWWr49F+
         pCg6p49npdpk24YI738yiCKKOdUUaUTUSPkdllNFWGUKq8wcJysoO32HUX2YhZI3o6jj
         7gnL8SlDBAKbR/WA55i1E93MFCqV7Aj02v0nY7T+5oaYH48ND1zKGORRBHQVVcMD7caW
         4IFVqbBNOBPPv1Yu7nw2rfz9/RCqOXelmGi+TYolPLVykcPXzF441eIn4TNlFu9D87tJ
         oiUcp5t8py/Ebo+XW4+EO+2dbMxqZVhmnCqxHvEHzXTi2xTHnq0Sw+BGoDB9oHo2ih4Y
         d4jA==
X-Gm-Message-State: AOAM533YCExGLjARIoChD7haxuNbrn84lvhbvQAMI9IB3iBXJDCA+SRV
        WE//Foj7XUL8cIQguv0itXc=
X-Google-Smtp-Source: ABdhPJxLBcKuL5o1a/8OSTGl1adViiFs8TygX3uL8Q4xxoC+kYXlIN57PA6KRA0iJLpaSDr+sJtPYQ==
X-Received: by 2002:a63:5d24:: with SMTP id r36mr997339pgb.426.1589508204668;
        Thu, 14 May 2020 19:03:24 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.5])
        by smtp.gmail.com with ESMTPSA id m12sm403320pgj.46.2020.05.14.19.03.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 May 2020 19:03:23 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: pull-request: bpf-next 2020-05-14
Date:   Thu, 14 May 2020 19:03:21 -0700
Message-Id: <20200515020321.31979-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

The main changes are:

1) Merged tag 'perf-for-bpf-2020-05-06' from tip tree that includes CAP_PERFMON.

2) support for narrow loads in bpf_sock_addr progs and additional
   helpers in cg-skb progs, from Andrey.

3) bpf benchmark runner, from Andrii.

4) arm and riscv JIT optimizations, from Luke.

5) bpf iterator infrastructure, from Yonghong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 60bcbc41ffb35572288681f41d1d8ab8bdb98841:

  Merge branch 'net-smc-add-and-delete-link-processing' (2020-05-03 16:08:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to b92d44b5c2efe70dbe7fc44fdd2ad46f8612418a:

  Merge branch 'expand-cg_skb-helpers' (2020-05-14 18:42:02 -0700)

----------------------------------------------------------------
Alexei Starovoitov (5):
      Merge tag 'perf-for-bpf-2020-05-06' of git://git.kernel.org/.../tip/tip into bpf-next
      Merge branch 'bpf_iter'
      Merge branch 'benchmark-runner'
      Merge branch 'bpf_iter-fixes'
      Merge branch 'expand-cg_skb-helpers'

Alexey Budankov (1):
      capabilities: Introduce CAP_PERFMON to kernel and user space

Andrey Ignatov (7):
      bpf: Support narrow loads from bpf_sock_addr.user_port
      selftests/bpf: Test narrow loads for bpf_sock_addr.user_port
      bpf: Allow sk lookup helpers in cgroup skb
      bpf: Allow skb_ancestor_cgroup_id helper in cgroup skb
      bpf: Introduce bpf_sk_{, ancestor_}cgroup_id helpers
      selftests/bpf: Add connect_fd_to_fd, connect_wait net helpers
      selftests/bpf: Test for sk helpers in cgroup skb

Andrii Nakryiko (5):
      selftests/bpf: Extract parse_num_list into generic testing_helpers.c
      selftests/bpf: Add benchmark runner infrastructure
      selftest/bpf: Fmod_ret prog and implement test_overhead as part of bench
      selftest/bpf: Add BPF triggering benchmark
      bpf: Fix bpf_iter's task iterator logic

Arnaldo Carvalho de Melo (1):
      perf stat: Honour --timeout for forked workloads

Arnd Bergmann (2):
      bpf: Avoid gcc-10 stringop-overflow warning in struct bpf_prog
      sysctl: Fix unused function warning

Colin Ian King (1):
      selftest/bpf: Fix spelling mistake "SIGALARM" -> "SIGALRM"

Daniel Borkmann (1):
      Merge branch 'bpf-rv64-jit'

Eelco Chaudron (1):
      libbpf: Fix probe code to return EPERM if encountered

Gustavo A. R. Silva (1):
      bpf, libbpf: Replace zero-length array with flexible-array

Jason Yan (1):
      bpf, i386: Remove unneeded conversion to bool

Jiri Olsa (3):
      perf tools: Synthesize bpf_trampoline/dispatcher ksymbol event
      perf machine: Set ksymbol dso as loaded on arrival
      perf annotate: Add basic support for bpf_image

Lorenzo Bianconi (1):
      samples/bpf: xdp_redirect_cpu: Set MAX_CPUS according to NR_CPUS

Luke Nelson (6):
      bpf, arm: Optimize ALU64 ARSH X using orrpl conditional instruction
      bpf, arm: Optimize ALU ARSH K using asr immediate instruction
      bpf, riscv: Enable missing verifier_zext optimizations on RV64
      bpf, riscv: Optimize FROM_LE using verifier_zext on RV64
      bpf, riscv: Optimize BPF_JMP BPF_K when imm == 0 on RV64
      bpf, riscv: Optimize BPF_JSET BPF_K using andi on RV64

Magnus Karlsson (2):
      xsk: Change two variable names for increased clarity
      xsk: Remove unnecessary member in xdp_umem

Quentin Monnet (4):
      tools, bpftool: Poison and replace kernel integer typedefs
      tools, bpftool: Minor fixes for documentation
      bpf: Minor fixes to BPF helpers documentation
      tools, bpf: Synchronise BPF UAPI header with tools

Song Liu (1):
      bpf, runqslower: include proper uapi/bpf.h

Stanislav Fomichev (4):
      selftests/bpf: Generalize helpers to control background listener
      selftests/bpf: Move existing common networking parts into network_helpers
      net: Refactor arguments of inet{,6}_bind
      bpf: Allow any port in bpf_bind helper

Yauheni Kaliuta (1):
      selftests/bpf: Install generated test progs

Yonghong Song (28):
      bpf: Implement an interface to register bpf_iter targets
      bpf: Allow loading of a bpf_iter program
      bpf: Support bpf tracing/iter programs for BPF_LINK_CREATE
      bpf: Support bpf tracing/iter programs for BPF_LINK_UPDATE
      bpf: Implement bpf_seq_read() for bpf iterator
      bpf: Create anonymous bpf iterator
      bpf: Create file bpf iterator
      bpf: Implement common macros/helpers for target iterators
      bpf: Add bpf_map iterator
      net: bpf: Add netlink and ipv6_route bpf_iter targets
      bpf: Add task and task/file iterator targets
      bpf: Add PTR_TO_BTF_ID_OR_NULL support
      bpf: Add bpf_seq_printf and bpf_seq_write helpers
      bpf: Handle spilled PTR_TO_BTF_ID properly when checking stack_boundary
      bpf: Support variable length array in tracing programs
      tools/libbpf: Add bpf_iter support
      tools/libpf: Add offsetof/container_of macro in bpf_helpers.h
      tools/bpftool: Add bpf_iter support for bptool
      tools/bpf: selftests: Add iterator programs for ipv6_route and netlink
      tools/bpf: selftests: Add iter progs for bpf_map/task/task_file
      tools/bpf: selftests: Add bpf_iter selftests
      tools/bpf: selftests : Explain bpf_iter test failures with llvm 10.0.0
      bpf: Change btf_iter func proto prefix to "bpf_iter_"
      bpf: Add comments to interpret bpf_prog return values
      bpf: net: Refactor bpf_iter target registration
      bpf: Change func bpf_iter_unreg_target() signature
      bpf: Enable bpf_iter targets registering ctx argument types
      samples/bpf: Remove compiler warnings

 arch/arm/net/bpf_jit_32.c                          |  14 +-
 arch/arm/net/bpf_jit_32.h                          |   3 +
 arch/riscv/net/bpf_jit_comp64.c                    |  64 ++-
 arch/x86/net/bpf_jit_comp32.c                      |   4 +-
 fs/proc/proc_net.c                                 |  19 +
 include/linux/bpf.h                                |  46 ++
 include/linux/bpf_types.h                          |   1 +
 include/linux/capability.h                         |   4 +
 include/linux/filter.h                             |   6 +-
 include/linux/proc_fs.h                            |   3 +
 include/net/inet_common.h                          |   8 +-
 include/net/ip6_fib.h                              |   7 +
 include/net/ipv6_stubs.h                           |   2 +-
 include/net/xdp_sock.h                             |   5 +-
 include/uapi/linux/bpf.h                           | 173 +++++--
 include/uapi/linux/capability.h                    |   8 +-
 kernel/bpf/Makefile                                |   2 +-
 kernel/bpf/bpf_iter.c                              | 539 +++++++++++++++++++++
 kernel/bpf/btf.c                                   |  47 +-
 kernel/bpf/inode.c                                 |   5 +-
 kernel/bpf/map_iter.c                              | 102 ++++
 kernel/bpf/queue_stack_maps.c                      |   2 +-
 kernel/bpf/syscall.c                               |  59 +++
 kernel/bpf/task_iter.c                             | 353 ++++++++++++++
 kernel/bpf/verifier.c                              |  41 +-
 kernel/sysctl.c                                    |   2 +-
 kernel/trace/bpf_trace.c                           | 214 ++++++++
 net/core/filter.c                                  | 101 +++-
 net/ipv4/af_inet.c                                 |  20 +-
 net/ipv6/af_inet6.c                                |  22 +-
 net/ipv6/ip6_fib.c                                 |  60 ++-
 net/ipv6/route.c                                   |  42 ++
 net/netlink/af_netlink.c                           |  92 +++-
 net/xdp/xdp_umem.c                                 |  21 +-
 net/xdp/xsk.c                                      |   8 +-
 net/xdp/xsk_queue.c                                |   4 +-
 net/xdp/xsk_queue.h                                |   8 +-
 samples/bpf/offwaketime_kern.c                     |   4 +-
 samples/bpf/sockex2_kern.c                         |   4 +-
 samples/bpf/sockex3_kern.c                         |   4 +-
 samples/bpf/xdp_redirect_cpu_kern.c                |   2 +-
 samples/bpf/xdp_redirect_cpu_user.c                |  29 +-
 scripts/bpf_helpers_doc.py                         |   8 +
 security/selinux/include/classmap.h                |   4 +-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |  11 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |  12 +-
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |  12 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |  21 +-
 tools/bpf/bpftool/Documentation/bpftool-iter.rst   |  81 ++++
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |   9 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |  37 +-
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |  12 +-
 tools/bpf/bpftool/Documentation/bpftool-perf.rst   |  12 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |  23 +-
 .../bpftool/Documentation/bpftool-struct_ops.rst   |  11 +-
 tools/bpf/bpftool/Documentation/bpftool.rst        |  11 +-
 tools/bpf/bpftool/bash-completion/bpftool          |  13 +
 tools/bpf/bpftool/btf_dumper.c                     |   4 +-
 tools/bpf/bpftool/cfg.c                            |   4 +-
 tools/bpf/bpftool/iter.c                           |  88 ++++
 tools/bpf/bpftool/link.c                           |   1 +
 tools/bpf/bpftool/main.c                           |   3 +-
 tools/bpf/bpftool/main.h                           |   4 +
 tools/bpf/bpftool/map.c                            |   3 +-
 tools/bpf/bpftool/map_perf_ring.c                  |   2 +-
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/bpf/runqslower/Makefile                      |   3 +-
 tools/include/uapi/linux/bpf.h                     | 173 +++++--
 tools/lib/bpf/bpf.c                                |  10 +
 tools/lib/bpf/bpf.h                                |   2 +
 tools/lib/bpf/bpf_helpers.h                        |  14 +
 tools/lib/bpf/bpf_tracing.h                        |  16 +
 tools/lib/bpf/libbpf.c                             |  90 +++-
 tools/lib/bpf/libbpf.h                             |   9 +
 tools/lib/bpf/libbpf.map                           |   2 +
 tools/lib/bpf/libbpf_internal.h                    |   2 +-
 tools/perf/builtin-stat.c                          |   5 +-
 tools/perf/util/annotate.c                         |  20 +
 tools/perf/util/bpf-event.c                        |  93 ++++
 tools/perf/util/dso.c                              |   1 +
 tools/perf/util/dso.h                              |   1 +
 tools/perf/util/machine.c                          |  12 +
 tools/perf/util/symbol.c                           |   1 +
 tools/testing/selftests/bpf/.gitignore             |   1 +
 tools/testing/selftests/bpf/Makefile               |  19 +-
 tools/testing/selftests/bpf/README.rst             |  43 ++
 tools/testing/selftests/bpf/bench.c                | 449 +++++++++++++++++
 tools/testing/selftests/bpf/bench.h                |  81 ++++
 tools/testing/selftests/bpf/benchs/bench_count.c   |  91 ++++
 tools/testing/selftests/bpf/benchs/bench_rename.c  | 195 ++++++++
 tools/testing/selftests/bpf/benchs/bench_trigger.c | 167 +++++++
 .../selftests/bpf/benchs/run_bench_rename.sh       |   9 +
 .../selftests/bpf/benchs/run_bench_trigger.sh      |   9 +
 tools/testing/selftests/bpf/network_helpers.c      | 158 ++++++
 tools/testing/selftests/bpf/network_helpers.h      |  41 ++
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 409 ++++++++++++++++
 .../bpf/prog_tests/cgroup_skb_sk_lookup.c          |  95 ++++
 .../selftests/bpf/prog_tests/connect_force_port.c  | 115 +++++
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   1 +
 .../selftests/bpf/prog_tests/flow_dissector.c      |   1 +
 .../bpf/prog_tests/flow_dissector_load_bytes.c     |   1 +
 .../testing/selftests/bpf/prog_tests/global_data.c |   1 +
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |   1 +
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |   1 +
 tools/testing/selftests/bpf/prog_tests/map_lock.c  |  14 +
 .../testing/selftests/bpf/prog_tests/pkt_access.c  |   1 +
 .../selftests/bpf/prog_tests/pkt_md_access.c       |   1 +
 .../selftests/bpf/prog_tests/prog_run_xattr.c      |   1 +
 .../selftests/bpf/prog_tests/queue_stack_map.c     |   1 +
 .../selftests/bpf/prog_tests/signal_pending.c      |   1 +
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |   1 +
 tools/testing/selftests/bpf/prog_tests/spinlock.c  |  14 +
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   | 116 +----
 .../selftests/bpf/prog_tests/test_overhead.c       |  14 +-
 tools/testing/selftests/bpf/prog_tests/xdp.c       |   1 +
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |   1 +
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   1 +
 .../selftests/bpf/prog_tests/xdp_noinline.c        |   1 +
 .../testing/selftests/bpf/progs/bpf_iter_bpf_map.c |  28 ++
 .../selftests/bpf/progs/bpf_iter_ipv6_route.c      |  62 +++
 .../testing/selftests/bpf/progs/bpf_iter_netlink.c |  66 +++
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |  25 +
 .../selftests/bpf/progs/bpf_iter_task_file.c       |  26 +
 .../selftests/bpf/progs/bpf_iter_test_kern1.c      |   4 +
 .../selftests/bpf/progs/bpf_iter_test_kern2.c      |   4 +
 .../selftests/bpf/progs/bpf_iter_test_kern3.c      |  18 +
 .../selftests/bpf/progs/bpf_iter_test_kern4.c      |  52 ++
 .../bpf/progs/bpf_iter_test_kern_common.h          |  22 +
 .../bpf/progs/cgroup_skb_sk_lookup_kern.c          |  97 ++++
 .../selftests/bpf/progs/connect_force_port4.c      |  28 ++
 .../selftests/bpf/progs/connect_force_port6.c      |  28 ++
 .../testing/selftests/bpf/progs/core_reloc_types.h |   2 +-
 tools/testing/selftests/bpf/progs/test_overhead.c  |   6 +
 tools/testing/selftests/bpf/progs/trigger_bench.c  |  47 ++
 tools/testing/selftests/bpf/test_progs.c           |  97 +---
 tools/testing/selftests/bpf/test_progs.h           |  24 +-
 tools/testing/selftests/bpf/test_sock_addr.c       |  38 +-
 tools/testing/selftests/bpf/testing_helpers.c      |  66 +++
 tools/testing/selftests/bpf/testing_helpers.h      |   5 +
 139 files changed, 5253 insertions(+), 544 deletions(-)
 create mode 100644 kernel/bpf/bpf_iter.c
 create mode 100644 kernel/bpf/map_iter.c
 create mode 100644 kernel/bpf/task_iter.c
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-iter.rst
 create mode 100644 tools/bpf/bpftool/iter.c
 create mode 100644 tools/testing/selftests/bpf/README.rst
 create mode 100644 tools/testing/selftests/bpf/bench.c
 create mode 100644 tools/testing/selftests/bpf/bench.h
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_count.c
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_rename.c
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_trigger.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_rename.sh
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_trigger.sh
 create mode 100644 tools/testing/selftests/bpf/network_helpers.c
 create mode 100644 tools/testing/selftests/bpf/network_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_skb_sk_lookup.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_force_port.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_file.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern1.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern2.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_skb_sk_lookup_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port4.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port6.c
 create mode 100644 tools/testing/selftests/bpf/progs/trigger_bench.c
 create mode 100644 tools/testing/selftests/bpf/testing_helpers.c
 create mode 100644 tools/testing/selftests/bpf/testing_helpers.h

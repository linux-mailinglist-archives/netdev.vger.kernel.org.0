Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FCC56C562
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbiGHXby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiGHXbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:31:50 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D65419AA;
        Fri,  8 Jul 2022 16:31:48 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o9xRp-0009PV-Sl; Sat, 09 Jul 2022 01:31:45 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-07-09
Date:   Sat,  9 Jul 2022 01:31:45 +0200
Message-Id: <20220708233145.32365-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26596/Thu Jul  7 09:53:54 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 94 non-merge commits during the last 19 day(s) which contain
a total of 125 files changed, 5141 insertions(+), 6701 deletions(-).

The main changes are:

1) Add new way for performing BTF type queries to BPF, from Daniel Müller.

2) Add inlining of calls to bpf_loop() helper when its function callback is
   statically known, from Eduard Zingerman.

3) Implement BPF TCP CC framework usability improvements, from Jörn-Thorben Hinz.

4) Add LSM flavor for attaching per-cgroup BPF programs to existing LSM
   hooks, from Stanislav Fomichev.

5) Remove all deprecated libbpf APIs in prep for 1.0 release, from Andrii Nakryiko.

6) Add benchmarks around local_storage to BPF selftests, from Dave Marchevsky.

7) AF_XDP sample removal (given move to libxdp) and various improvements around AF_XDP
   selftests, from Magnus Karlsson & Maciej Fijalkowski.

8) Add bpftool improvements for memcg probing and bash completion, from Quentin Monnet.

9) Add arm64 JIT support for BPF-2-BPF coupled with tail calls, from Jakub Sitnicki.

10) Sockmap optimizations around throughput of UDP transmissions which have been
    improved by 61%, from Cong Wang.

11) Rework perf's BPF prologue code to remove deprecated functions, from Jiri Olsa.

12) Fix sockmap teardown path to avoid sleepable sk_psock_stop, from John Fastabend.

13) Fix libbpf's cleanup around legacy kprobe/uprobe on error case, from Chuang Wang.

14) Fix libbpf's bpf_helpers.h to work with gcc for the case of its sec/pragma
    macro, from James Hilliard.

15) Fix libbpf's pt_regs macros for riscv to use a0 for RC register, from Yixun Lan.

16) Fix bpftool to show the name of type BPF_OBJ_LINK, from Yafang Shao.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Amjad OULED-AMEUR, Andrii Nakryiko, Arnaldo Carvalho de Melo, Björn 
Töpel, Dan Carpenter, Daniel Müller, Eric Dumazet, Hao Luo, Jakub 
Sitnicki, Jesper Dangaard Brouer, Jiri Olsa, John Fastabend, Lorenzo 
Bianconi, Lukas Bulwahn, Maciej Fijalkowski, Magnus Karlsson, Martin 
KaFai Lau, Paul E. McKenney, Quentin Monnet, Randy Dunlap, Song Liu, 
Stanislav Fomichev, Toke Høiland-Jørgensen, Yafang Shao, Yauheni 
Kaliuta, Yonghong Song

----------------------------------------------------------------

The following changes since commit 4336487e30c37a2e82a1fed2370d3134cc5b6505:

  Merge branch 'mlxsw-unified-bridge-conversion-part-1' (2022-06-20 10:03:34 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 24bdfdd2ec343c94adf38fb5bc699f12e543713b:

  selftests/bpf: Fix xdp_synproxy build failure if CONFIG_NF_CONNTRACK=m/n (2022-07-08 15:58:45 -0700)

----------------------------------------------------------------
Alexei Starovoitov (4):
      Merge branch 'bpf_loop inlining'
      Merge branch 'Align BPF TCP CCs implementing cong_control() with non-BPF CCs'
      Merge branch 'libbpf: remove deprecated APIs'
      Merge branch 'bpf: cgroup_sock lsm flavor'

Andrii Nakryiko (22):
      Merge branch 'perf tools: Fix prologue generation'
      libbpf: move xsk.{c,h} into selftests/bpf
      libbpf: remove deprecated low-level APIs
      libbpf: remove deprecated XDP APIs
      libbpf: remove deprecated probing APIs
      libbpf: remove deprecated BTF APIs
      libbpf: clean up perfbuf APIs
      libbpf: remove prog_info_linear APIs
      libbpf: remove most other deprecated high-level APIs
      libbpf: remove multi-instance and custom private data APIs
      libbpf: cleanup LIBBPF_DEPRECATED_SINCE supporting macros for v0.x
      libbpf: remove internal multi-instance prog support
      libbpf: clean up SEC() handling
      selftests/bpf: remove last tests with legacy BPF map definitions
      libbpf: enforce strict libbpf 1.0 behaviors
      libbpf: fix up few libbpf.map problems
      libbpf: add bpf_core_type_matches() helper macro
      Merge branch 'Introduce type match support'
      Merge branch 'cleanup the legacy probe_event on failed scenario'
      selftests/bpf: Fix bogus uninitialized variable warning
      selftests/bpf: Fix few more compiler warnings
      libbpf: Remove unnecessary usdt_rel_ip assignments

Andy Gospodarek (1):
      samples/bpf: fixup some tools to be able to support xdp multibuffer

Chuang Wang (3):
      libbpf: Cleanup the legacy kprobe_event on failed add/attach_event()
      libbpf: Fix wrong variable used in perf_event_uprobe_open_legacy()
      libbpf: Cleanup the legacy uprobe_event on failed add/attach_event()

Cong Wang (4):
      tcp: Introduce tcp_read_skb()
      net: Introduce a new proto_ops ->read_skb()
      skmsg: Get rid of skb_clone()
      skmsg: Get rid of unncessary memset()

Daniel Müller (11):
      bpf: Merge "types_are_compat" logic into relo_core.c
      bpf: Introduce TYPE_MATCH related constants/macros
      bpftool: Honor BPF_CORE_TYPE_MATCHES relocation
      bpf, libbpf: Add type match support
      selftests/bpf: Add type-match checks to type-based tests
      selftests/bpf: Add test checking more characteristics
      selftests/bpf: Add nested type to type based tests
      selftests/bpf: Add type match test against kernel's task_struct
      bpftool: Add support for KIND_RESTRICT to gen min_core_btf command
      selftests/bpf: Add test involving restrict type qualifier
      bpf: Correctly propagate errors up from bpf_core_composites_match

Dave Marchevsky (2):
      selftests/bpf: Add benchmark for local_storage get
      selftests/bpf: Add benchmark for local_storage RCU Tasks Trace usage

Delyan Kratunov (1):
      uprobe: gate bpf call behind BPF_EVENTS

Eduard Zingerman (7):
      selftests/bpf: specify expected instructions in test_verifier tests
      selftests/bpf: allow BTF specs and func infos in test_verifier tests
      bpf: Inline calls to bpf_loop when callback is known
      selftests/bpf: BPF test_verifier selftests for bpf_loop inlining
      selftests/bpf: BPF test_prog selftests for bpf_loop inlining
      bpf: Fix for use-after-free bug in inline_bpf_loop
      selftest/bpf: Test for use-after-free bug fix in inline_bpf_loop

Jakub Sitnicki (1):
      bpf, arm64: Keep tail call count across bpf2bpf calls

James Hilliard (1):
      libbpf: Disable SEC pragma macro on GCC

Jian Shen (1):
      test_bpf: fix incorrect netdev features

Jiri Olsa (1):
      perf tools: Rework prologue generation code

John Fastabend (1):
      bpf: Fix sockmap calling sleepable function in teardown path

Jörn-Thorben Hinz (6):
      bpf: Allow a TCP CC to write sk_pacing_rate and sk_pacing_status
      bpf: Require only one of cong_avoid() and cong_control() from a TCP CC
      selftests/bpf: Test a BPF CC writing sk_pacing_*
      selftests/bpf: Test an incomplete BPF CC
      selftests/bpf: Test a BPF CC implementing the unsupported get_info()
      selftests/bpf: Fix rare segfault in sock_fields prog test

Maciej Fijalkowski (6):
      selftests/xsk: Avoid bpf_link probe for existing xsk
      selftests/xsk: Introduce XDP prog load based on existing AF_XDP socket
      selftests/xsk: Verify correctness of XDP prog attach point
      selftests/xsk: Destroy BPF resources only when ctx refcount drops to 0
      selftests, xsk: Rename AF_XDP testing app
      MAINTAINERS: Add entry for AF_XDP selftests files

Magnus Karlsson (1):
      bpf, samples: Remove AF_XDP samples

Maxim Mikityanskiy (2):
      selftests/bpf: Enable config options needed for xdp_synproxy test
      selftests/bpf: Fix xdp_synproxy build failure if CONFIG_NF_CONNTRACK=m/n

Pu Lehui (1):
      bpf, docs: Remove deprecated xsk libbpf APIs description

Quentin Monnet (5):
      bpftool: Probe for memcg-based accounting before bumping rlimit
      bpftool: Add feature list (prog/map/link/attach types, helpers)
      bpftool: Use feature list in bash completion
      bpftool: Rename "bpftool feature list" into "... feature list_builtins"
      bpftool: Remove zlib feature test from Makefile

Shahab Vahedi (1):
      bpf, docs: Fix the code formatting in instruction-set

Simon Wang (1):
      bpf: Replace hard-coded 0 with BPF_K in check_alu_op

Stanislav Fomichev (13):
      bpf: add bpf_func_t and trampoline helpers
      bpf: convert cgroup_bpf.progs to hlist
      bpf: per-cgroup lsm flavor
      bpf: minimize number of allocated lsm slots per program
      bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
      bpf: expose bpf_{g,s}etsockopt to lsm cgroup
      tools/bpf: Sync btf_ids.h to tools
      libbpf: add lsm_cgoup_sock type
      libbpf: implement bpf_prog_query_opts
      bpftool: implement cgroup tree for BPF_LSM_CGROUP
      selftests/bpf: lsm_cgroup functional test
      selftests/bpf: Skip lsm_cgroup when we don't have trampolines
      bpf: Check attach_func_proto more carefully in check_return_code

Tobias Klauser (2):
      bpftool: Remove attach_type_name forward declaration
      bpf: Omit superfluous address family check in __bpf_skc_lookup

Tony Ambardar (1):
      bpf, x64: Add predicate for bpf2bpf with tailcalls support in JIT

Yafang Shao (1):
      bpftool: Show also the name of type BPF_OBJ_LINK

Yixun Lan (1):
      libbpf, riscv: Use a0 for RC register

 Documentation/bpf/instruction-set.rst              |    2 +-
 .../bpf/libbpf/libbpf_naming_convention.rst        |   13 +-
 MAINTAINERS                                        |    3 +-
 arch/arm64/net/bpf_jit_comp.c                      |    9 +-
 arch/x86/net/bpf_jit_comp.c                        |   30 +-
 include/linux/bpf-cgroup-defs.h                    |   13 +-
 include/linux/bpf-cgroup.h                         |    9 +-
 include/linux/bpf.h                                |   47 +-
 include/linux/bpf_lsm.h                            |    7 +
 include/linux/bpf_verifier.h                       |   12 +
 include/linux/btf_ids.h                            |    3 +-
 include/linux/filter.h                             |    1 +
 include/linux/net.h                                |    4 +
 include/net/tcp.h                                  |    1 +
 include/net/udp.h                                  |    3 +-
 include/uapi/linux/bpf.h                           |    5 +
 kernel/bpf/bpf_iter.c                              |    9 +-
 kernel/bpf/bpf_lsm.c                               |   81 +
 kernel/bpf/bpf_struct_ops.c                        |    7 +-
 kernel/bpf/btf.c                                   |   94 +-
 kernel/bpf/cgroup.c                                |  350 +++-
 kernel/bpf/core.c                                  |   15 +
 kernel/bpf/syscall.c                               |   18 +-
 kernel/bpf/trampoline.c                            |  262 ++-
 kernel/bpf/verifier.c                              |  238 ++-
 kernel/trace/trace_uprobe.c                        |    2 +
 lib/test_bpf.c                                     |    4 +-
 net/core/filter.c                                  |   65 +-
 net/core/skmsg.c                                   |   48 +-
 net/core/sock_map.c                                |    2 +-
 net/ipv4/af_inet.c                                 |    3 +-
 net/ipv4/bpf_tcp_ca.c                              |   39 +-
 net/ipv4/tcp.c                                     |   44 +
 net/ipv4/udp.c                                     |   11 +-
 net/ipv6/af_inet6.c                                |    3 +-
 net/unix/af_unix.c                                 |   23 +-
 samples/bpf/Makefile                               |    9 -
 samples/bpf/xdp1_kern.c                            |   11 +-
 samples/bpf/xdp2_kern.c                            |   11 +-
 samples/bpf/xdp_tx_iptunnel_kern.c                 |    2 +-
 samples/bpf/xdpsock.h                              |   19 -
 samples/bpf/xdpsock_ctrl_proc.c                    |  190 --
 samples/bpf/xdpsock_kern.c                         |   24 -
 samples/bpf/xdpsock_user.c                         | 2019 --------------------
 samples/bpf/xsk_fwd.c                              | 1085 -----------
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |   12 +
 tools/bpf/bpftool/Makefile                         |   11 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   28 +-
 tools/bpf/bpftool/cgroup.c                         |  109 +-
 tools/bpf/bpftool/common.c                         |   72 +-
 tools/bpf/bpftool/feature.c                        |   59 +-
 tools/bpf/bpftool/gen.c                            |  109 ++
 tools/bpf/bpftool/main.h                           |    2 -
 tools/include/linux/btf_ids.h                      |   35 +-
 tools/include/uapi/linux/bpf.h                     |    5 +
 tools/lib/bpf/Build                                |    2 +-
 tools/lib/bpf/Makefile                             |    2 +-
 tools/lib/bpf/bpf.c                                |  200 +-
 tools/lib/bpf/bpf.h                                |   98 +-
 tools/lib/bpf/bpf_core_read.h                      |   11 +
 tools/lib/bpf/bpf_helpers.h                        |   13 +
 tools/lib/bpf/bpf_tracing.h                        |    2 +-
 tools/lib/bpf/btf.c                                |  183 +-
 tools/lib/bpf/btf.h                                |   86 +-
 tools/lib/bpf/btf_dump.c                           |   23 +-
 tools/lib/bpf/libbpf.c                             | 1537 ++-------------
 tools/lib/bpf/libbpf.h                             |  469 +----
 tools/lib/bpf/libbpf.map                           |  114 +-
 tools/lib/bpf/libbpf_common.h                      |   16 +-
 tools/lib/bpf/libbpf_internal.h                    |   24 +-
 tools/lib/bpf/libbpf_legacy.h                      |   28 +-
 tools/lib/bpf/libbpf_probes.c                      |  125 +-
 tools/lib/bpf/netlink.c                            |   62 +-
 tools/lib/bpf/relo_core.c                          |  366 +++-
 tools/lib/bpf/relo_core.h                          |    6 +
 tools/lib/bpf/usdt.c                               |    6 +-
 tools/perf/util/bpf-loader.c                       |  204 +-
 tools/testing/selftests/bpf/.gitignore             |    2 +-
 tools/testing/selftests/bpf/Makefile               |   10 +-
 tools/testing/selftests/bpf/bench.c                |   97 +
 tools/testing/selftests/bpf/bench.h                |   16 +
 .../selftests/bpf/benchs/bench_local_storage.c     |  287 +++
 .../benchs/bench_local_storage_rcu_tasks_trace.c   |  281 +++
 .../bpf/benchs/run_bench_local_storage.sh          |   24 +
 .../run_bench_local_storage_rcu_tasks_trace.sh     |   11 +
 tools/testing/selftests/bpf/benchs/run_common.sh   |   17 +
 tools/testing/selftests/bpf/bpf_legacy.h           |    9 -
 tools/testing/selftests/bpf/config                 |    6 +
 tools/testing/selftests/bpf/network_helpers.c      |    2 +-
 tools/testing/selftests/bpf/prog_tests/bpf_loop.c  |   62 +
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |   61 +
 tools/testing/selftests/bpf/prog_tests/btf.c       |    2 -
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   75 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |    4 +-
 .../testing/selftests/bpf/prog_tests/lsm_cgroup.c  |  313 +++
 .../selftests/bpf/prog_tests/resolve_btfids.c      |    2 +-
 .../testing/selftests/bpf/prog_tests/sock_fields.c |    1 -
 tools/testing/selftests/bpf/prog_tests/usdt.c      |    2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        |    2 +-
 tools/testing/selftests/bpf/progs/bpf_loop.c       |  114 ++
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |    1 +
 .../bpf/progs/btf__core_reloc_type_based___diff.c  |    3 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |  112 +-
 .../selftests/bpf/progs/local_storage_bench.c      |  104 +
 .../progs/local_storage_rcu_tasks_trace_bench.c    |   67 +
 tools/testing/selftests/bpf/progs/lsm_cgroup.c     |  180 ++
 .../selftests/bpf/progs/lsm_cgroup_nonvoid.c       |   14 +
 .../selftests/bpf/progs/tcp_ca_incompl_cong_ops.c  |   35 +
 .../selftests/bpf/progs/tcp_ca_unsupp_cong_op.c    |   21 +
 .../selftests/bpf/progs/tcp_ca_write_sk_pacing.c   |   60 +
 tools/testing/selftests/bpf/progs/test_btf_haskv.c |   51 -
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |   18 -
 .../selftests/bpf/progs/test_core_reloc_kernel.c   |   19 +
 .../bpf/progs/test_core_reloc_type_based.c         |   49 +-
 .../selftests/bpf/progs/xdp_synproxy_kern.c        |   24 +-
 .../selftests/bpf/test_bpftool_synctypes.py        |   20 +-
 tools/testing/selftests/bpf/test_btf.h             |    2 +
 tools/testing/selftests/bpf/test_verifier.c        |  367 +++-
 tools/testing/selftests/bpf/test_xsk.sh            |    6 +-
 .../selftests/bpf/verifier/bpf_loop_inline.c       |  263 +++
 tools/{lib => testing/selftests}/bpf/xsk.c         |   92 +-
 tools/{lib => testing/selftests}/bpf/xsk.h         |   30 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh         |    4 +-
 .../selftests/bpf/{xdpxceiver.c => xskxceiver.c}   |   25 +-
 .../selftests/bpf/{xdpxceiver.h => xskxceiver.h}   |    6 +-
 125 files changed, 5141 insertions(+), 6701 deletions(-)
 delete mode 100644 samples/bpf/xdpsock.h
 delete mode 100644 samples/bpf/xdpsock_ctrl_proc.c
 delete mode 100644 samples/bpf/xdpsock_kern.c
 delete mode 100644 samples/bpf/xdpsock_user.c
 delete mode 100644 samples/bpf/xsk_fwd.c
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_local_storage.c
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_local_storage_rcu_tasks_trace.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_local_storage.sh
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_local_storage_rcu_tasks_trace.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___diff.c
 create mode 100644 tools/testing/selftests/bpf/progs/local_storage_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/local_storage_rcu_tasks_trace_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup_nonvoid.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_ca_incompl_cong_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_ca_unsupp_cong_op.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
 delete mode 100644 tools/testing/selftests/bpf/progs/test_btf_haskv.c
 create mode 100644 tools/testing/selftests/bpf/verifier/bpf_loop_inline.c
 rename tools/{lib => testing/selftests}/bpf/xsk.c (94%)
 rename tools/{lib => testing/selftests}/bpf/xsk.h (84%)
 rename tools/testing/selftests/bpf/{xdpxceiver.c => xskxceiver.c} (98%)
 rename tools/testing/selftests/bpf/{xdpxceiver.h => xskxceiver.h} (98%)

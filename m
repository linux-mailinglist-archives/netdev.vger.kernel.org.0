Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C8A41F880
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 02:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhJBAPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 20:15:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:57094 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbhJBAPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 20:15:19 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mWSed-000Dxf-Qn; Sat, 02 Oct 2021 02:13:27 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2021-10-02
Date:   Sat,  2 Oct 2021 02:13:27 +0200
Message-Id: <20211002001327.15169-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26309/Fri Oct  1 11:03:53 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 85 non-merge commits during the last 15 day(s) which contain
a total of 132 files changed, 13779 insertions(+), 6724 deletions(-).

The main changes are:

1) Massive update on test_bpf.ko coverage for JITs as preparatory work for
   an upcoming MIPS eBPF JIT, from Johan Almbladh.

2) Add a batched interface for RX buffer allocation in AF_XDP buffer pool,
   with driver support for i40e and ice from Magnus Karlsson.

3) Add legacy uprobe support to libbpf to complement recently merged legacy
   kprobe support, from Andrii Nakryiko.

4) Add bpf_trace_vprintk() as variadic printk helper, from Dave Marchevsky.

5) Support saving the register state in verifier when spilling <8byte bounded
   scalar to the stack, from Martin Lau.

6) Add libbpf opt-in for stricter BPF program section name handling as part
   of libbpf 1.0 effort, from Andrii Nakryiko.

7) Add a document to help clarifying BPF licensing, from Alexei Starovoitov.

8) Fix skel_internal.h to propagate errno if the loader indicates an internal
   error, from Kumar Kartikeya Dwivedi.

9) Fix build warnings with -Wcast-function-type so that the option can later
   be enabled by default for the kernel, from Kees Cook.

10) Fix libbpf to ignore STT_SECTION symbols in legacy map definitions as it
    otherwise errors out when encountering them, from Toke Høiland-Jørgensen.

11) Teach libbpf to recognize specialized maps (such as for perf RB) and
    internally remove BTF type IDs when creating them, from Hengqi Chen.

12) Various fixes and improvements to BPF selftests.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Andrii Nakryiko, Daniel Borkmann, Dave Marchevsky, Dave 
Thaler, Gustavo A. R. Silva, Jesper Dangaard Brouer, Joe Stringer, KP 
Singh, Lorenz Bauer, Maciej Fijalkowski, Nathan Chancellor, Paul 
Chaignon, Simon Horman, Song Liu, Stephen Hemminger, Tiezhu Yang, Toke 
Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit af54faab84f754ebd42ecdda871f8d71940ae40b:

  Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2021-09-17 12:40:21 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to d636c8da2d60cc4841ebd7b6e6a02db5c33e11e4:

  Merge branch 'libbpf: Support uniform BTF-defined key/value specification across all BPF maps' (2021-10-01 15:31:51 -0700)

----------------------------------------------------------------
Alexei Starovoitov (7):
      Merge branch 'bpf: implement variadic printk helper'
      Merge branch 'libbpf: add legacy uprobe support'
      bpf: Document BPF licensing.
      Merge branch 'bpf: Support <8-byte scalar spill and refill'
      Merge branch 'libbpf: stricter BPF program section name handling'
      Merge branch 'bpf: Build with -Wcast-function-type'
      libbpf: Make gen_loader data aligned.

Andrii Nakryiko (15):
      libbpf: Fix memory leak in legacy kprobe attach logic
      selftests/bpf: Adopt attach_probe selftest to work on old kernels
      libbpf: Refactor and simplify legacy kprobe code
      libbpf: Add legacy uprobe attaching support
      libbpf: Add "tc" SEC_DEF which is a better name for "classifier"
      selftests/bpf: Normalize XDP section names in selftests
      selftests/bpf: Switch SEC("classifier*") usage to a strict SEC("tc")
      selftests/bpf: Normalize all the rest SEC() uses
      libbpf: Refactor internal sec_def handling to enable pluggability
      libbpf: Reduce reliance of attach_fns on sec_def internals
      libbpf: Refactor ELF section handler definitions
      libbpf: Complete SEC() table unification for BPF_APROG_SEC/BPF_EAPROG_SEC
      libbpf: Add opt-in strict BPF program section name handling logic
      selftests/bpf: Switch sk_lookup selftests to strict SEC("sk_lookup") use
      Merge branch 'libbpf: Support uniform BTF-defined key/value specification across all BPF maps'

Daniel Borkmann (1):
      Merge branch 'bpf-xsk-rx-batch'

Dave Marchevsky (9):
      bpf: Merge printk and seq_printf VARARG max macros
      selftests/bpf: Stop using bpf_program__load
      bpf: Add bpf_trace_vprintk helper
      libbpf: Modify bpf_printk to choose helper based on arg count
      libbpf: Use static const fmt string in __bpf_printk
      bpftool: Only probe trace_vprintk feature in 'full' mode
      selftests/bpf: Migrate prog_tests/trace_printk CHECKs to ASSERTs
      selftests/bpf: Add trace_vprintk test prog
      bpf: Clarify data_len param in bpf_snprintf and bpf_seq_printf comments

Gokul Sivakumar (2):
      samples: bpf: Convert route table network order fields into readable format
      samples: bpf: Convert ARP table network order fields into readable format

Grant Seltzer (1):
      libbpf: Add doc comments in libbpf.h

Hengqi Chen (2):
      libbpf: Support uniform BTF-defined key/value specification across all BPF maps
      selftests/bpf: Use BTF-defined key/value for map definitions

Jiri Benc (1):
      seltests: bpf: test_tunnel: Use ip neigh

Johan Almbladh (24):
      bpf/tests: Allow different number of runs per test case
      bpf/tests: Reduce memory footprint of test suite
      bpf/tests: Add exhaustive tests of ALU shift values
      bpf/tests: Add exhaustive tests of ALU operand magnitudes
      bpf/tests: Add exhaustive tests of JMP operand magnitudes
      bpf/tests: Add staggered JMP and JMP32 tests
      bpf/tests: Add exhaustive test of LD_IMM64 immediate magnitudes
      bpf/tests: Add test case flag for verifier zero-extension
      bpf/tests: Add JMP tests with small offsets
      bpf/tests: Add JMP tests with degenerate conditional
      bpf/tests: Expand branch conversion JIT test
      bpf/tests: Add more BPF_END byte order conversion tests
      bpf/tests: Fix error in tail call limit tests
      bpf/tests: Add tail call limit test with external function call
      bpf/tests: Add tests of BPF_LDX and BPF_STX with small sizes
      bpf/tests: Add zero-extension checks in BPF_ATOMIC tests
      bpf/tests: Add exhaustive tests of BPF_ATOMIC magnitudes
      bpf/tests: Add tests to check source register zero-extension
      bpf/tests: Add more tests for ALU and ATOMIC register clobbering
      bpf/tests: Minor restructuring of ALU tests
      bpf/tests: Add exhaustive tests of ALU register combinations
      bpf/tests: Add exhaustive tests of BPF_ATOMIC register combinations
      bpf/tests: Add test of ALU shifts with operand register aliasing
      bpf/tests: Add test of LDX_MEM with operand aliasing

Kees Cook (2):
      bpf: Replace "want address" users of BPF_CAST_CALL with BPF_CALL_IMM
      bpf: Replace callers of BPF_CAST_CALL with proper function typedef

Kev Jackson (1):
      bpf, xdp, docs: Correct some English grammar and spelling

Kumar Kartikeya Dwivedi (2):
      bpf: selftests: Fix fd cleanup in get_branch_snapshot
      libbpf: Fix skel_internal.h to set errno on loader retval < 0

Lorenz Bauer (1):
      bpf: Do not invoke the XDP dispatcher for PROG_RUN with single repeat

Magnus Karlsson (14):
      xsk: Get rid of unused entry in struct xdp_buff_xsk
      xsk: Batched buffer allocation for the pool
      ice: Use xdp_buf instead of rx_buf for xsk zero-copy
      ice: Use the xsk batched rx allocation interface
      i40e: Use the xsk batched rx allocation interface
      xsk: Optimize for aligned case
      selftests: xsk: Fix missing initialization
      selftests: xsk: Put the same buffer only once in the fill ring
      selftests: xsk: Fix socket creation retry
      selftests: xsk: Introduce pacing of traffic
      selftests: xsk: Add single packet test
      selftests: xsk: Change interleaving of packets in unaligned mode
      selftests: xsk: Add frame_headroom test
      xsk: Fix clang build error in __xp_alloc

Martin KaFai Lau (4):
      bpf: Check the other end of slot_type for STACK_SPILL
      bpf: Support <8-byte scalar spill and refill
      bpf: selftest: A bpf prog that has a 32bit scalar spill
      bpf: selftest: Add verifier tests for <8-byte scalar spill and refill

Po-Hsu Lin (1):
      selftests/bpf: Use kselftest skip code for skipped tests

Toke Høiland-Jørgensen (2):
      libbpf: Ignore STT_SECTION symbols in 'maps' section
      libbpf: Properly ignore STT_SECTION symbols in legacy map definitions

Yonghong Song (2):
      selftests/bpf: Fix btf_dump __int128 test failure with clang build kernel
      selftests/bpf: Fix probe_user test failure with clang build kernel

Yucong Sun (1):
      bpftool: Avoid using "?: " in generated code

 Documentation/bpf/bpf_licensing.rst                |    92 +
 Documentation/bpf/index.rst                        |     9 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |    52 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |    16 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |    92 +-
 include/linux/bpf.h                                |     7 +-
 include/linux/filter.h                             |     7 +-
 include/net/xdp.h                                  |     8 +-
 include/net/xdp_sock_drv.h                         |    22 +
 include/net/xsk_buff_pool.h                        |    48 +-
 include/uapi/linux/bpf.h                           |    16 +-
 kernel/bpf/arraymap.c                              |     7 +-
 kernel/bpf/core.c                                  |     5 +
 kernel/bpf/hashtab.c                               |    13 +-
 kernel/bpf/helpers.c                               |    11 +-
 kernel/bpf/verifier.c                              |   123 +-
 kernel/trace/bpf_trace.c                           |    54 +-
 lib/test_bpf.c                                     | 17181 ++++++++++++-------
 net/bpf/test_run.c                                 |     6 +-
 net/xdp/xsk.c                                      |    15 -
 net/xdp/xsk_buff_pool.c                            |   132 +-
 net/xdp/xsk_queue.h                                |    12 +-
 samples/bpf/xdp_router_ipv4_user.c                 |    39 +-
 tools/bpf/bpftool/feature.c                        |     1 +
 tools/bpf/bpftool/gen.c                            |     5 +-
 tools/include/uapi/linux/bpf.h                     |    16 +-
 tools/lib/bpf/bpf_helpers.h                        |    51 +-
 tools/lib/bpf/gen_loader.c                         |     7 +-
 tools/lib/bpf/libbpf.c                             |   846 +-
 tools/lib/bpf/libbpf.h                             |    67 +-
 tools/lib/bpf/libbpf_internal.h                    |     7 +
 tools/lib/bpf/libbpf_legacy.h                      |     9 +
 tools/lib/bpf/skel_internal.h                      |     6 +-
 tools/testing/selftests/bpf/Makefile               |     3 +-
 tools/testing/selftests/bpf/README.rst             |    13 +
 .../selftests/bpf/prog_tests/attach_probe.c        |    24 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |    27 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |     4 +-
 .../selftests/bpf/prog_tests/get_branch_snapshot.c |     5 +-
 .../testing/selftests/bpf/prog_tests/probe_user.c  |     4 +-
 .../selftests/bpf/prog_tests/reference_tracking.c  |    52 +-
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |     2 +-
 .../selftests/bpf/prog_tests/sockopt_multi.c       |    30 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |    58 +-
 .../selftests/bpf/prog_tests/trace_printk.c        |    24 +-
 .../selftests/bpf/prog_tests/trace_vprintk.c       |    68 +
 tools/testing/selftests/bpf/prog_tests/xdpwall.c   |    15 +
 tools/testing/selftests/bpf/progs/bpf_flow.c       |     3 +-
 .../bpf/progs/cg_storage_multi_isolated.c          |     4 +-
 .../selftests/bpf/progs/cg_storage_multi_shared.c  |     4 +-
 .../selftests/bpf/progs/for_each_array_map_elem.c  |     2 +-
 .../selftests/bpf/progs/for_each_hash_map_elem.c   |     2 +-
 tools/testing/selftests/bpf/progs/kfree_skb.c      |     4 +-
 .../testing/selftests/bpf/progs/kfunc_call_test.c  |     4 +-
 .../selftests/bpf/progs/kfunc_call_test_subprog.c  |     2 +-
 .../selftests/bpf/progs/perf_event_stackmap.c      |     4 +-
 tools/testing/selftests/bpf/progs/skb_pkt_end.c    |     2 +-
 .../selftests/bpf/progs/sockmap_verdict_prog.c     |    12 +-
 tools/testing/selftests/bpf/progs/sockopt_multi.c  |     5 +-
 tools/testing/selftests/bpf/progs/tailcall1.c      |     7 +-
 tools/testing/selftests/bpf/progs/tailcall2.c      |    23 +-
 tools/testing/selftests/bpf/progs/tailcall3.c      |     7 +-
 tools/testing/selftests/bpf/progs/tailcall4.c      |     7 +-
 tools/testing/selftests/bpf/progs/tailcall5.c      |     7 +-
 tools/testing/selftests/bpf/progs/tailcall6.c      |     6 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf1.c        |     7 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c        |     7 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c        |    11 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |    15 +-
 .../selftests/bpf/progs/test_btf_map_in_map.c      |    14 +-
 .../selftests/bpf/progs/test_btf_skc_cls_ingress.c |     2 +-
 .../testing/selftests/bpf/progs/test_cgroup_link.c |     4 +-
 tools/testing/selftests/bpf/progs/test_check_mtu.c |    12 +-
 .../selftests/bpf/progs/test_cls_redirect.c        |     2 +-
 .../testing/selftests/bpf/progs/test_global_data.c |     2 +-
 .../selftests/bpf/progs/test_global_func1.c        |     2 +-
 .../selftests/bpf/progs/test_global_func3.c        |     2 +-
 .../selftests/bpf/progs/test_global_func5.c        |     2 +-
 .../selftests/bpf/progs/test_global_func6.c        |     2 +-
 .../selftests/bpf/progs/test_global_func7.c        |     2 +-
 .../testing/selftests/bpf/progs/test_map_in_map.c  |    12 +-
 .../selftests/bpf/progs/test_map_in_map_invalid.c  |     2 +-
 .../bpf/progs/test_misc_tcp_hdr_options.c          |     2 +-
 .../selftests/bpf/progs/test_pe_preserve_elems.c   |     8 +-
 .../testing/selftests/bpf/progs/test_perf_buffer.c |     4 +-
 .../testing/selftests/bpf/progs/test_pkt_access.c  |     2 +-
 .../selftests/bpf/progs/test_pkt_md_access.c       |     4 +-
 .../testing/selftests/bpf/progs/test_probe_user.c  |    28 +-
 .../bpf/progs/test_select_reuseport_kern.c         |     4 +-
 tools/testing/selftests/bpf/progs/test_sk_assign.c |     3 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |    44 +-
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |    37 +-
 .../testing/selftests/bpf/progs/test_skb_helpers.c |     2 +-
 .../selftests/bpf/progs/test_sockmap_listen.c      |     2 +-
 .../bpf/progs/test_sockmap_skb_verdict_attach.c    |     2 +-
 .../selftests/bpf/progs/test_sockmap_update.c      |     2 +-
 .../selftests/bpf/progs/test_stacktrace_build_id.c |     4 +-
 .../selftests/bpf/progs/test_stacktrace_map.c      |     4 +-
 tools/testing/selftests/bpf/progs/test_tc_bpf.c    |     2 +-
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |     6 +-
 .../selftests/bpf/progs/test_tc_neigh_fib.c        |     6 +-
 tools/testing/selftests/bpf/progs/test_tc_peer.c   |    10 +-
 .../bpf/progs/test_tcp_check_syncookie_kern.c      |     4 +-
 .../selftests/bpf/progs/test_tcp_hdr_options.c     |     2 +-
 .../selftests/bpf/progs/test_tcpnotify_kern.c      |     4 +-
 tools/testing/selftests/bpf/progs/test_xdp.c       |     2 +-
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |     2 +-
 .../bpf/progs/test_xdp_adjust_tail_shrink.c        |     4 +-
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |     4 +-
 .../selftests/bpf/progs/test_xdp_devmap_helpers.c  |     2 +-
 tools/testing/selftests/bpf/progs/test_xdp_link.c  |     2 +-
 tools/testing/selftests/bpf/progs/test_xdp_loop.c  |     2 +-
 .../selftests/bpf/progs/test_xdp_noinline.c        |     4 +-
 .../bpf/progs/test_xdp_with_cpumap_helpers.c       |     4 +-
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |     4 +-
 tools/testing/selftests/bpf/progs/trace_vprintk.c  |    33 +
 tools/testing/selftests/bpf/progs/xdp_dummy.c      |     2 +-
 .../selftests/bpf/progs/xdp_redirect_multi_kern.c  |     4 +-
 tools/testing/selftests/bpf/progs/xdping_kern.c    |     4 +-
 tools/testing/selftests/bpf/progs/xdpwall.c        |   365 +
 tools/testing/selftests/bpf/test_bpftool.py        |    22 +-
 .../selftests/bpf/test_tcp_check_syncookie.sh      |     4 +-
 tools/testing/selftests/bpf/test_tunnel.sh         |     5 +-
 tools/testing/selftests/bpf/test_xdp_meta.sh       |     5 +-
 tools/testing/selftests/bpf/test_xdp_redirect.sh   |     4 +-
 .../selftests/bpf/test_xdp_redirect_multi.sh       |     2 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh       |     4 +-
 tools/testing/selftests/bpf/test_xdp_vlan.sh       |     7 +-
 tools/testing/selftests/bpf/verifier/spill_fill.c  |   161 +
 tools/testing/selftests/bpf/xdping.c               |     5 +-
 tools/testing/selftests/bpf/xdpxceiver.c           |   133 +-
 tools/testing/selftests/bpf/xdpxceiver.h           |    11 +-
 132 files changed, 13779 insertions(+), 6724 deletions(-)
 create mode 100644 Documentation/bpf/bpf_licensing.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdpwall.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_vprintk.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdpwall.c

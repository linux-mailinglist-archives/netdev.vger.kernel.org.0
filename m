Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AB9531EA8
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiEWWiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiEWWiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:38:11 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397C19CF62;
        Mon, 23 May 2022 15:38:09 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ntGgf-000EZR-TT; Tue, 24 May 2022 00:38:06 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-05-23
Date:   Tue, 24 May 2022 00:38:05 +0200
Message-Id: <20220523223805.27931-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26550/Mon May 23 10:05:39 2022)
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

We've added 113 non-merge commits during the last 26 day(s) which contain
a total of 121 files changed, 7425 insertions(+), 1586 deletions(-).

There is a trivial merge conflict in net/core/sysctl_net_core.c between
commits 4c7f24f857c7 ("net: sysctl: introduce sysctl SYSCTL_THREE") from
net-next and f922c8972fb5 ("net: sysctl: Use SYSCTL_TWO instead of &two")
from bpf-next. To resolve it, just remove the 'static int three = 3;'.

The main changes are:

1) Speed up symbol resolution for kprobes multi-link attachments, from Jiri Olsa.

2) Add BPF dynamic pointer infrastructure e.g. to allow for dynamically sized ringbuf
   reservations without extra memory copies, from Joanne Koong.

3) Big batch of libbpf improvements towards libbpf 1.0 release, from Andrii Nakryiko.

4) Add BPF link iterator to traverse links via seq_file ops, from Dmitrii Dolgov.

5) Add source IP address to BPF tunnel key infrastructure, from Kaixi Fan.

6) Refine unprivileged BPF to disable only object-creating commands, from Alan Maguire.

7) Fix JIT blinding of ld_imm64 when they point to subprogs, from Alexei Starovoitov.

8) Add BPF access to mptcp_sock structures and their meta data, from Geliang Tang.

9) Add new BPF helper for access to remote CPU's BPF map elements, from Feng Zhou.

10) Allow attaching 64-bit cookie to BPF link of fentry/fexit/fmod_ret, from Kui-Feng Lee.

11) Follow-ups to typed pointer support in BPF maps, from Kumar Kartikeya Dwivedi.

12) Add busy-poll test cases to the XSK selftest suite, from Magnus Karlsson.

13) Improvements in BPF selftest test_progs subtest output, from Mykola Lysenko.

14) Fill bpf_prog_pack allocator areas with illegal instructions, from Song Liu.

15) Add generic batch operations for BPF map-in-map cases, from Takshak Chahande.

16) Make bpf_jit_enable more user friendly when permanently on 1, from Tiezhu Yang.

17) Fix an array overflow in bpf_trampoline_get_progs(), from Yuntao Wang.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexander Lobakin, Andrii Nakryiko, Björn Töpel, CKI Project, Daniel 
Müller, David Vernet, Ilya Leoshkevich, John Fastabend, kernel test 
robot, KP Singh, Kumar Kartikeya Dwivedi, Linus Torvalds, Maciej 
Fijalkowski, Martin KaFai Lau, Masami Hiramatsu, Matthieu Baerts, Mykola 
Lysenko, Nathan Chancellor, Peter Zijlstra (Intel), Shung-Hsi Yu, Song 
Liu, Veronika Kabatova, Yonghong Song

----------------------------------------------------------------

The following changes since commit 50c6afabfd2ae91a4ff0e2feb14fe702b0688ec5:

  Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2022-04-27 17:09:32 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 608b638ebf368f18431f47bbbd0d93828cbbdf83:

  Merge branch 'Dynamic pointers' (2022-05-23 14:31:29 -0700)

----------------------------------------------------------------
Alan Maguire (2):
      bpf: refine kernel.unprivileged_bpf_disabled behaviour
      selftests/bpf: add tests verifying unprivileged bpf behaviour

Alexei Starovoitov (11):
      Merge branch 'libbpf: allow to opt-out from BPF map creation'
      Merge branch 'Add source ip in bpf tunnel key'
      Merge branch 'bpf: bpf link iterator'
      Merge branch 'bpf: Speed up symbol resolving in kprobe multi link'
      Merge branch 'selftests: xsk: add busy-poll testing plus various fixes'
      Merge branch 'Follow ups for kptr series'
      Merge branch 'Introduce access remote cpu elem support in BPF percpu map'
      bpf: Fix combination of jit blinding and pointers to bpf subprogs.
      selftests/bpf: Check combination of jit blinding and pointers to bpf subprogs.
      Merge branch 'Start libbpf 1.0 dev cycle'
      Merge branch 'bpf: refine kernel.unprivileged_bpf_disabled behaviour'

Andrii Nakryiko (29):
      libbpf: Allow "incomplete" basic tracing SEC() definitions
      libbpf: Support target-less SEC() definitions for BTF-backed programs
      selftests/bpf: Use target-less SEC() definitions in various tests
      libbpf: Append "..." in fixed up log if CO-RE spec is truncated
      libbpf: Use libbpf_mem_ensure() when allocating new map
      libbpf: Allow to opt-out from creating BPF maps
      selftests/bpf: Test bpf_map__set_autocreate() and related log fixup logic
      selftests/bpf: Prevent skeleton generation race
      libbpf: Make __kptr and __kptr_ref unconditionally use btf_type_tag() attr
      libbpf: Improve usability of field-based CO-RE helpers
      selftests/bpf: Use both syntaxes for field-based CO-RE helpers
      libbpf: Complete field-based CO-RE helpers with field offset helper
      selftests/bpf: Add bpf_core_field_offset() tests
      libbpf: Provide barrier() and barrier_var() in bpf_helpers.h
      libbpf: Automatically fix up BPF_MAP_TYPE_RINGBUF size, if necessary
      selftests/bpf: Test libbpf's ringbuf size fix up logic
      Merge branch 'bpftool: fix feature output when helper probes fail'
      Merge branch 'Attach a cookie to a tracing program.'
      libbpf: Clean up ringbuf size adjustment implementation
      selftests/bpf: make fexit_stress test run in serial mode
      libbpf: Add safer high-level wrappers for map operations
      selftests/bpf: Convert some selftests to high-level BPF map APIs
      selftests/bpf: Fix usdt_400 test case
      libbpf: fix memory leak in attach_tp for target-less tracepoint program
      libbpf: fix up global symbol counting logic
      libbpf: start 1.0 development cycle
      libbpf: remove bpf_create_map*() APIs
      Merge branch 'bpf: mptcp: Support for mptcp_sock'
      Merge branch 'Dynamic pointers'

Benjamin Tissoires (1):
      bpf: Allow kfunc in tracing and syscall programs.

Colin Ian King (1):
      selftests/bpf: Fix spelling mistake: "unpriviliged" -> "unprivileged"

Daniel Müller (1):
      selftests/bpf: Enable CONFIG_FPROBE for self tests

Dmitrii Dolgov (4):
      bpf: Add bpf_link iterator
      selftests/bpf: Fix result check for test_bpf_hash_map
      selftests/bpf: Use ASSERT_* instead of CHECK
      selftests/bpf: Add bpf link iter test

Feng Zhou (3):
      bpf: add bpf_map_lookup_percpu_elem for percpu map
      selftests/bpf: add test case for bpf_map_lookup_percpu_elem
      selftests/bpf: Fix some bugs in map_lookup_percpu_elem testcase

Geliang Tang (6):
      bpf: Add bpf_skc_to_mptcp_sock_proto
      selftests/bpf: Enable CONFIG_IKCONFIG_PROC in config
      selftests/bpf: Test bpf_skc_to_mptcp_sock
      selftests/bpf: Verify token of struct mptcp_sock
      selftests/bpf: Verify ca_name of struct mptcp_sock
      selftests/bpf: Verify first of struct mptcp_sock

Hangbin Liu (1):
      selftests/bpf: Add missed ima_setup.sh in Makefile

Jason Wang (1):
      bpftool: Declare generator name

Jerome Marchand (1):
      samples: bpf: Don't fail for a missing VMLINUX_BTF when VMLINUX_H is provided

Jiri Olsa (6):
      kallsyms: Make kallsyms_on_each_symbol generally available
      ftrace: Add ftrace_lookup_symbols function
      fprobe: Resolve symbols with ftrace_lookup_symbols
      bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link
      selftests/bpf: Add attach bench test
      libbpf: Add bpf_program__set_insns function

Joanne Koong (7):
      bpf: Add MEM_UNINIT as a bpf_type_flag
      bpf: Add verifier support for dynptrs
      bpf: Add bpf_dynptr_from_mem for local dynptrs
      bpf: Dynptr support for ring buffers
      bpf: Add bpf_dynptr_read and bpf_dynptr_write
      bpf: Add dynptr data slices
      selftests/bpf: Dynptr tests

Julia Lawall (2):
      libbpf: Fix typo in comment
      s390/bpf: Fix typo in comment

KP Singh (1):
      bpftool: bpf_link_get_from_fd support for LSM programs in lskel

Kaixi Fan (3):
      bpf: Add source ip in "struct bpf_tunnel_key"
      selftests/bpf: Move vxlan tunnel testcases to test_progs
      selftests/bpf: Replace bpf_trace_printk in tunnel kernel code

Kui-Feng Lee (5):
      bpf, x86: Generate trampolines from bpf_tramp_links
      bpf, x86: Create bpf_tramp_run_ctx on the caller thread's stack
      bpf, x86: Attach a cookie to fentry/fexit/fmod_ret/lsm.
      libbpf: Assign cookies to links in libbpf.
      selftest/bpf: The test cases of BPF cookie for fentry/fexit/fmod_ret/lsm.

Kumar Kartikeya Dwivedi (5):
      bpf: Fix sparse warning for bpf_kptr_xchg_proto
      bpf: Prepare prog_test_struct kfuncs for runtime tests
      selftests/bpf: Add negative C tests for kptrs
      selftests/bpf: Add tests for kptr_ref refcounting
      bpf: Suppress 'passing zero to PTR_ERR' warning

Larysa Zaremba (1):
      bpftool: Use sysfs vmlinux when dumping BTF by ID

Liu Jian (1):
      bpf, sockmap: Call skb_linearize only when required in sk_psock_skb_ingress_enqueue

Magnus Karlsson (10):
      selftests: xsk: cleanup bash scripts
      selftests: xsk: do not send zero-length packets
      selftests: xsk: run all tests for busy-poll
      selftests: xsk: fix reporting of failed tests
      selftests: xsk: add timeout to tests
      selftests: xsk: cleanup veth pair at ctrl-c
      selftests: xsk: introduce validation functions
      selftests: xsk: make the stats tests normal tests
      selftests: xsk: make stat tests not spin on getsockopt
      MAINTAINERS: Add maintainer to AF_XDP

Milan Landaverde (2):
      bpftool: Adjust for error codes from libbpf probes
      bpftool: Output message if no helpers found in feature probing

Mykola Lysenko (4):
      bpf/selftests: Add granular subtest output for prog_test
      selftests/bpf: Fix two memory leaks in prog_tests
      selftests/bpf: Fix subtest number formatting in test_progs
      selftests/bpf: Remove filtered subtests from output

Nicolas Rybowski (1):
      selftests/bpf: Add MPTCP test base

Song Liu (3):
      bpf: Fill new bpf_prog_pack with illegal instructions
      x86/alternative: Introduce text_poke_set
      bpf: Introduce bpf_arch_text_invalidate for bpf_prog_pack

Takshak Chahande (2):
      bpf: Extend batch operations for map-in-map bpf-maps
      selftests/bpf: Handle batch operations for map-in-map bpf-maps

Tiezhu Yang (5):
      bpf, docs: Remove duplicated word "instructions"
      bpf, docs: BPF_FROM_BE exists as alias for BPF_TO_BE
      bpf, docs: Fix typo "respetively" to "respectively"
      net: sysctl: Use SYSCTL_TWO instead of &two
      bpf: Print some info if disable bpf_jit_enable failed

Yonghong Song (2):
      selftests/bpf: fix a few clang compilation errors
      selftests/bpf: fix btf_dump/btf_dump due to recent clang change

Yosry Ahmed (1):
      selftests/bpf: Fix building bpf selftests statically

Yuntao Wang (3):
      bpf: Remove unused parameter from find_kfunc_desc_btf()
      bpf: Fix potential array overflow in bpf_trampoline_get_progs()
      selftests/bpf: Add missing trampoline program type to trampoline_count test

Zhengchao Shao (1):
      samples/bpf: Detach xdp prog when program exits unexpectedly in xdp_rxq_info_user

 Documentation/bpf/instruction-set.rst              |   4 +-
 MAINTAINERS                                        |   2 +
 arch/s390/net/bpf_jit_comp.c                       |   2 +-
 arch/x86/include/asm/text-patching.h               |   1 +
 arch/x86/kernel/alternative.c                      |  67 ++-
 arch/x86/net/bpf_jit_comp.c                        |  79 ++-
 include/linux/bpf.h                                | 122 +++-
 include/linux/bpf_types.h                          |   1 +
 include/linux/bpf_verifier.h                       |  20 +
 include/linux/btf_ids.h                            |   3 +-
 include/linux/ftrace.h                             |   6 +
 include/linux/kallsyms.h                           |   7 +-
 include/net/mptcp.h                                |   6 +
 include/uapi/linux/bpf.h                           | 113 ++++
 kernel/bpf/Makefile                                |   2 +-
 kernel/bpf/arraymap.c                              |  17 +
 kernel/bpf/bpf_lsm.c                               |  17 +
 kernel/bpf/bpf_struct_ops.c                        |  71 ++-
 kernel/bpf/btf.c                                   |   6 +
 kernel/bpf/core.c                                  |  29 +-
 kernel/bpf/hashtab.c                               |  45 +-
 kernel/bpf/helpers.c                               | 199 ++++++-
 kernel/bpf/link_iter.c                             | 107 ++++
 kernel/bpf/ringbuf.c                               |  78 +++
 kernel/bpf/syscall.c                               |  75 ++-
 kernel/bpf/trampoline.c                            | 118 ++--
 kernel/bpf/verifier.c                              | 324 +++++++++--
 kernel/kallsyms.c                                  |   3 +-
 kernel/trace/bpf_trace.c                           | 133 +++--
 kernel/trace/fprobe.c                              |  32 +-
 kernel/trace/ftrace.c                              |  62 ++
 net/bpf/bpf_dummy_struct_ops.c                     |  24 +-
 net/bpf/test_run.c                                 |  23 +-
 net/core/filter.c                                  |  27 +
 net/core/skmsg.c                                   |  22 +-
 net/core/sysctl_net_core.c                         |  13 +-
 net/mptcp/Makefile                                 |   2 +
 net/mptcp/bpf.c                                    |  21 +
 samples/bpf/Makefile                               |   9 +-
 samples/bpf/xdp_rxq_info_user.c                    |  22 +-
 scripts/bpf_doc.py                                 |   4 +
 tools/bpf/bpftool/btf.c                            |  62 +-
 tools/bpf/bpftool/feature.c                        |  22 +-
 tools/bpf/bpftool/gen.c                            |   5 +-
 tools/bpf/bpftool/link.c                           |   1 +
 tools/include/uapi/linux/bpf.h                     | 113 ++++
 tools/lib/bpf/Makefile                             |   2 +-
 tools/lib/bpf/bpf.c                                | 102 +---
 tools/lib/bpf/bpf.h                                |  46 +-
 tools/lib/bpf/bpf_core_read.h                      |  37 +-
 tools/lib/bpf/bpf_helpers.h                        |  29 +-
 tools/lib/bpf/libbpf.c                             | 475 ++++++++++++---
 tools/lib/bpf/libbpf.h                             | 156 +++++
 tools/lib/bpf/libbpf.map                           |  16 +-
 tools/lib/bpf/libbpf_version.h                     |   4 +-
 tools/testing/selftests/bpf/Makefile               |  18 +-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |  13 +
 tools/testing/selftests/bpf/config                 |   4 +
 .../selftests/bpf/map_tests/map_in_map_batch_ops.c | 252 ++++++++
 tools/testing/selftests/bpf/network_helpers.c      |  40 +-
 tools/testing/selftests/bpf/network_helpers.h      |   2 +
 .../selftests/bpf/prog_tests/attach_probe.c        |  10 +
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |  89 +++
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 261 ++++-----
 .../selftests/bpf/prog_tests/core_autosize.c       |   2 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  13 +-
 .../testing/selftests/bpf/prog_tests/core_retro.c  |  17 +-
 tools/testing/selftests/bpf/prog_tests/dynptr.c    | 137 +++++
 .../selftests/bpf/prog_tests/fexit_stress.c        |   2 +-
 tools/testing/selftests/bpf/prog_tests/for_each.c  |  30 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   | 159 ++++-
 tools/testing/selftests/bpf/prog_tests/log_fixup.c |  37 +-
 .../selftests/bpf/prog_tests/lookup_and_delete.c   |  15 +-
 tools/testing/selftests/bpf/prog_tests/map_kptr.c  | 131 ++++-
 .../bpf/prog_tests/map_lookup_percpu_elem.c        |  58 ++
 tools/testing/selftests/bpf/prog_tests/mptcp.c     | 174 ++++++
 .../selftests/bpf/prog_tests/ringbuf_multi.c       |  12 -
 .../selftests/bpf/prog_tests/stacktrace_build_id.c |   8 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |  11 +-
 .../testing/selftests/bpf/prog_tests/test_tunnel.c | 423 ++++++++++++++
 tools/testing/selftests/bpf/prog_tests/timer_mim.c |   2 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    | 134 ++---
 .../selftests/bpf/prog_tests/unpriv_bpf_disabled.c | 312 ++++++++++
 tools/testing/selftests/bpf/prog_tests/usdt.c      |   6 +-
 tools/testing/selftests/bpf/progs/bpf_iter.h       |   7 +
 .../selftests/bpf/progs/bpf_iter_bpf_link.c        |  21 +
 .../bpf/progs/btf__core_reloc_size___diff_offs.c   |   3 +
 .../bpf/progs/btf_dump_test_case_syntax.c          |   2 +-
 .../testing/selftests/bpf/progs/core_reloc_types.h |  18 +
 tools/testing/selftests/bpf/progs/dynptr_fail.c    | 588 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/dynptr_success.c | 164 ++++++
 tools/testing/selftests/bpf/progs/exhandler_kern.c |   2 -
 tools/testing/selftests/bpf/progs/kprobe_multi.c   |  14 +
 .../selftests/bpf/progs/kprobe_multi_empty.c       |  12 +
 tools/testing/selftests/bpf/progs/loop5.c          |   1 -
 tools/testing/selftests/bpf/progs/map_kptr.c       | 106 +++-
 tools/testing/selftests/bpf/progs/map_kptr_fail.c  | 418 +++++++++++++
 tools/testing/selftests/bpf/progs/mptcp_sock.c     |  88 +++
 tools/testing/selftests/bpf/progs/profiler1.c      |   1 -
 tools/testing/selftests/bpf/progs/pyperf.h         |   2 -
 .../selftests/bpf/progs/test_attach_probe.c        |  23 +-
 .../testing/selftests/bpf/progs/test_bpf_cookie.c  |  52 +-
 .../bpf/progs/test_core_reloc_existence.c          |  11 +-
 .../selftests/bpf/progs/test_core_reloc_size.c     |  31 +-
 tools/testing/selftests/bpf/progs/test_log_fixup.c |  26 +
 .../bpf/progs/test_map_lookup_percpu_elem.c        |  76 +++
 .../selftests/bpf/progs/test_module_attach.c       |   2 +-
 .../testing/selftests/bpf/progs/test_pkt_access.c  |   2 -
 .../selftests/bpf/progs/test_ringbuf_multi.c       |   2 +
 tools/testing/selftests/bpf/progs/test_subprogs.c  |   8 +
 .../selftests/bpf/progs/test_trampoline_count.c    |  16 +-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c | 371 +++++++-----
 .../selftests/bpf/progs/test_unpriv_bpf_disabled.c |  83 +++
 tools/testing/selftests/bpf/test_progs.c           | 647 +++++++++++++++------
 tools/testing/selftests/bpf/test_progs.h           |  37 +-
 tools/testing/selftests/bpf/test_tunnel.sh         | 124 +---
 tools/testing/selftests/bpf/test_xsk.sh            |  53 +-
 tools/testing/selftests/bpf/verifier/map_kptr.c    |   4 +-
 tools/testing/selftests/bpf/xdpxceiver.c           | 547 +++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h           |  42 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh         |  47 +-
 121 files changed, 7425 insertions(+), 1586 deletions(-)
 create mode 100644 kernel/bpf/link_iter.c
 create mode 100644 net/mptcp/bpf.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/dynptr.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tunnel.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/unpriv_bpf_disabled.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_size___diff_offs.c
 create mode 100644 tools/testing/selftests/bpf/progs/dynptr_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/dynptr_success.c
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_kptr_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_unpriv_bpf_disabled.c

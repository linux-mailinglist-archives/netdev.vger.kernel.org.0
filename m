Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2830F5F36AD
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 21:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJCTt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 15:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiJCTt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 15:49:27 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05CC4A110;
        Mon,  3 Oct 2022 12:49:18 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ofRRE-000FzD-86; Mon, 03 Oct 2022 21:49:16 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-10-03
Date:   Mon,  3 Oct 2022 21:49:15 +0200
Message-Id: <20221003194915.11847-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26678/Mon Oct  3 09:56:12 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 143 non-merge commits during the last 27 day(s) which contain
a total of 151 files changed, 8321 insertions(+), 1402 deletions(-).

The main changes are:

1) Add kfuncs for PKCS#7 signature verification from BPF programs, from Roberto Sassu.

2) Add support for struct-based arguments for trampoline based BPF programs,
   from Yonghong Song.

3) Fix entry IP for kprobe-multi and trampoline probes under IBT enabled, from Jiri Olsa.

4) Batch of improvements to veristat selftest tool in particular to add CSV output,
   a comparison mode for CSV outputs and filtering, from Andrii Nakryiko.

5) Add preparatory changes needed for the BPF core for upcoming BPF HID support,
   from Benjamin Tissoires.

6) Support for direct writes to nf_conn's mark field from tc and XDP BPF program
   types, from Daniel Xu.

7) Initial batch of documentation improvements for BPF insn set spec, from Dave Thaler.

8) Add a new BPF_MAP_TYPE_USER_RINGBUF map which provides single-user-space-producer /
   single-kernel-consumer semantics for BPF ring buffer, from David Vernet.

9) Follow-up fixes to BPF allocator under RT to always use raw spinlock for the BPF
   hashtab's bucket lock, from Hou Tao.

10) Allow creating an iterator that loops through only the resources of one
    task/thread instead of all, from Kui-Feng Lee.

11) Add support for kptrs in the per-CPU arraymap, from Kumar Kartikeya Dwivedi.

12) Add a new kfunc helper for nf to set src/dst NAT IP/port in a newly allocated CT
    entry which is not yet inserted, from Lorenzo Bianconi.

13) Remove invalid recursion check for struct_ops for TCP congestion control BPF
    programs, from Martin KaFai Lau.

14) Fix W^X issue with BPF trampoline and BPF dispatcher, from Song Liu.

15) Fix percpu_counter leakage in BPF hashtab allocation error path, from Tetsuo Handa.

16) Various cleanups in BPF selftests to use preferred ASSERT_* macros, from Wang Yufen.

17) Add invocation for cgroup/connect{4,6} BPF programs for ICMP pings, from YiFei Zhu.

18) Lift blinding decision under bpf_jit_harden = 1 to bpf_capable(), from Yauheni Kaliuta.

19) Various libbpf fixes and cleanups including a libbpf NULL pointer deref, from Xin Liu.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Daniel Müller, Eric Dumazet, Grant Seltzer Richman, 
Jarkko Sakkinen, Joanne Koong, John Fastabend, kernel test robot, KP 
Singh, Kumar Kartikeya Dwivedi, Maciej Fijalkowski, Martin KaFai Lau, 
Martynas Pumputis, Masami Hiramatsu (Google), Nathan Chancellor, Peter 
Zijlstra (Intel), Quentin Monnet, Song Liu, Stanislav Fomichev, Stephen 
Rothwell, syzbot, Toke Høiland-Jørgensen, Yauheni Kaliuta, Yonghong Song

----------------------------------------------------------------

The following changes since commit 2786bcff28bd88955fc61adf9cb7370fbc182bad:

  Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2022-09-06 23:21:18 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 820dc0523e05c12810bb6bf4e56ce26e4c1948a2:

  net: netfilter: move bpf_ct_set_nat_info kfunc in nf_nat_bpf.c (2022-10-03 09:17:32 -0700)

----------------------------------------------------------------
Alexei Starovoitov (12):
      bpf: Replace __ksize with ksize.
      Merge branch 'bpf: Support struct argument for trampoline base progs'
      Merge branch 'bpf-core changes for preparation of HID-bpf'
      Merge branch 'Support direct writes to nf_conn:mark'
      Merge branch 'bpf: Add kfuncs for PKCS#7 signature verification'
      Merge branch 'Introduce bpf_ct_set_nat_info kfunc helper'
      Merge branch 'veristat: CSV output, comparison mode, filtering'
      Merge branch 'veristat: further usability improvements'
      Merge branch 'bpf: Fixes for CONFIG_X86_KERNEL_IBT'
      Merge branch 'enforce W^X for trampoline and dispatcher'
      Merge branch 'bpf: Remove recursion check for struct_ops prog'
      bpf, docs: Delete misformatted table.

Andrii Nakryiko (18):
      selftests/bpf: Fix test_verif_scale{1,3} SEC() annotations
      libbpf: Fix crash if SEC("freplace") programs don't have attach_prog_fd set
      selftests/bpf: Add veristat tool for mass-verifying BPF object files
      Merge branch 'bpf: Add user-space-publisher ring buffer map type'
      selftests/bpf: fix double bpf_object__close() in veristate
      selftests/bpf: add CSV output mode for veristat
      selftests/bpf: add comparison mode to veristat
      selftests/bpf: add ability to filter programs in veristat
      libbpf: restore memory layout of bpf_object_open_opts
      selftests/bpf: add sign-file to .gitignore
      selftests/bpf: make veristat's verifier log parsing faster and more robust
      selftests/bpf: make veristat skip non-BPF and failing-to-open BPF objects
      selftests/bpf: emit processing progress and add quiet mode to veristat
      selftests/bpf: allow to adjust BPF verifier log level in veristat
      libbpf: Don't require full struct enum64 in UAPI headers
      Merge branch 'Parameterize task iterators.'
      Merge branch 'bpf/selftests: convert some tests to ASSERT_* macros'
      Merge branch 'tools: bpftool: Remove unused struct'

Bagas Sanjaya (1):
      Documentation: bpf: Add implementation notes documentations to table of contents

Benjamin Tissoires (7):
      selftests/bpf: regroup and declare similar kfuncs selftests in an array
      bpf: split btf_check_subprog_arg_match in two
      bpf/verifier: allow all functions to read user provided context
      selftests/bpf: add test for accessing ctx from syscall program type
      bpf/btf: bump BTF_KFUNC_SET_MAX_CNT
      bpf/verifier: allow kfunc to return an allocated mem
      selftests/bpf: Add tests for kfunc returning a memory pointer

Colin Ian King (1):
      selftests/bpf: Fix spelling mistake "unpriviledged" -> "unprivileged"

Daniel Borkmann (1):
      libbpf: Remove gcc support for bpf_tail_call_static for now

Daniel Xu (9):
      bpf: Remove duplicate PTR_TO_BTF_ID RO check
      bpf: Add stub for btf_struct_access()
      bpf: Use 0 instead of NOT_INIT for btf_struct_access() writes
      bpf: Export btf_type_by_id() and bpf_log()
      bpf: Add support for writing to nf_conn:mark
      selftests/bpf: Add tests for writing to nf_conn:mark
      bpf: Remove unused btf_struct_access stub
      bpf: Rename nfct_bsa to nfct_btf_struct_access
      bpf: Move nf_conn extern declarations to filter.h

Dave Marchevsky (2):
      bpf: Add verifier support for custom callback return range
      bpf: Add verifier check for BPF_PTR_POISON retval and arg

Dave Thaler (5):
      bpf, docs: Move legacy packet instructions to a separate file
      bpf, docs: Linux byteswap note
      bpf, docs: Move Clang notes to a separate file
      bpf, docs: Add Clang note about BPF_ALU
      bpf, docs: Add TOC and fix formatting.

David Vernet (4):
      bpf: Define new BPF_MAP_TYPE_USER_RINGBUF map type
      bpf: Add bpf_user_ringbuf_drain() helper
      bpf: Add libbpf logic for user-space ring buffer
      selftests/bpf: Add selftests validating the user ringbuf

Deming Wang (1):
      samples/bpf: Fix typo in xdp_router_ipv4 sample

Hou Tao (5):
      selftests/bpf: Add test result messages for test_task_storage_map_stress_lookup
      bpf: Check whether or not node is NULL before free it in free_bulk
      bpf: Always use raw spinlock for hash bucket lock
      selftests/bpf: Destroy the skeleton when CONFIG_PREEMPT is off
      selftests/bpf: Free the allocated resources after test case succeeds

Jiri Olsa (8):
      bpf: Move bpf_dispatcher function out of ftrace locations
      bpf: Prevent bpf program recursion for raw tracepoint probes
      kprobes: Add new KPROBE_FLAG_ON_FUNC_ENTRY kprobe flag
      ftrace: Keep the resolved addr in kallsyms_callback
      bpf: Use given function address for trampoline ip arg
      bpf: Adjust kprobe_multi entry_ip for CONFIG_X86_KERNEL_IBT
      bpf: Return value in kprobe get_func_ip only for entry address
      selftests/bpf: Fix get_func_ip offset test for CONFIG_X86_KERNEL_IBT

Jon Doron (1):
      libbpf: Fix the case of running as non-root with capabilities

Jules Irenge (1):
      bpf: Fix resetting logic for unreferenced kptrs

KP Singh (1):
      bpf: Allow kfuncs to be used in LSM programs

Kui-Feng Lee (5):
      bpf: Parameterize task iterators.
      bpf: Handle bpf_link_info for the parameterized task BPF iterators.
      bpf: Handle show_fdinfo for the parameterized task BPF iterators
      selftests/bpf: Test parameterized task BPF iterators.
      bpftool: Show parameters of BPF task iterators.

Kumar Kartikeya Dwivedi (5):
      bpf: Add copy_map_value_long to copy to remote percpu memory
      bpf: Support kptrs in percpu arraymap
      bpf: Add zero_map_value to zero map value with special fields
      bpf: Add helper macro bpf_for_each_reg_in_vstate
      bpf: Tweak definition of KF_TRUSTED_ARGS

Liu Jian (3):
      net: If sock is dead don't access sock's sk_wq in sk_stream_wait_memory
      selftests/bpf: Add wait send memory test for sockmap redirect
      skmsg: Schedule psock work if the cached skb exists on the psock

Lorenzo Bianconi (4):
      selftests/bpf: fix ct status check in bpf_nf selftests
      net: netfilter: add bpf_ct_set_nat_info kfunc helper
      selftests/bpf: add tests for bpf_ct_set_nat_info kfunc
      net: netfilter: move bpf_ct_set_nat_info kfunc in nf_nat_bpf.c

Magnus Karlsson (1):
      selftests/xsk: Fix double free

Martin KaFai Lau (8):
      Merge branch 'cgroup/connect{4,6} programs for unprivileged ICMP ping'
      Merge branch 'bpf: Small nf_conn cleanups'
      Merge branch 'Fix resource leaks in test_maps'
      bpf: Add __bpf_prog_{enter,exit}_struct_ops for struct_ops trampoline
      bpf: Move the "cdg" tcp-cc check to the common sol_tcp_sockopt()
      bpf: Refactor bpf_setsockopt(TCP_CONGESTION) handling into another function
      bpf: tcp: Stop bpf_setsockopt(TCP_CONGESTION) in init ops to recur itself
      selftests/bpf: Check -EBUSY for the recurred bpf_setsockopt(TCP_CONGESTION)

Peilin Ye (1):
      bpf/btf: Use btf_type_str() whenever possible

Peter Zijlstra (Intel) (1):
      ftrace: Add HAVE_DYNAMIC_FTRACE_NO_PATCHABLE

Punit Agrawal (1):
      bpf: Simplify code by using for_each_cpu_wrap()

Roberto Sassu (12):
      btf: Export bpf_dynptr definition
      bpf: Move dynptr type check to is_dynptr_type_expected()
      btf: Allow dynamic pointer parameters in kfuncs
      bpf: Export bpf_dynptr_get_size()
      KEYS: Move KEY_LOOKUP_ to include/linux/key.h and define KEY_LOOKUP_ALL
      bpf: Add bpf_lookup_*_key() and bpf_key_put() kfuncs
      bpf: Add bpf_verify_pkcs7_signature() kfunc
      selftests/bpf: Compile kernel with everything as built-in
      selftests/bpf: Add verifier tests for bpf_lookup_*_key() and bpf_key_put()
      selftests/bpf: Add additional tests for bpf_lookup_*_key()
      selftests/bpf: Add test for bpf_verify_pkcs7_signature() kfunc
      selftests/bpf: Add tests for dynamic pointers parameters in kfuncs

Rong Tao (1):
      samples/bpf: Replace blk_account_io_done() with __blk_account_io_done()

Song Liu (2):
      bpf: use bpf_prog_pack for bpf_dispatcher
      bpf: Enforce W^X for bpf trampoline

Tao Chen (1):
      libbpf: Support raw BTF placed in the default search path

Tetsuo Handa (1):
      bpf: add missing percpu_counter_destroy() in htab_map_alloc()

Tianyi Liu (1):
      bpftool: Fix error message of strerror

Wang Yufen (13):
      bpf: use kvmemdup_bpfptr helper
      libbpf: Add pathname_concat() helper
      selftests/bpf: Convert sockmap_basic test to ASSERT_* macros
      selftests/bpf: Convert sockmap_ktls test to ASSERT_* macros
      selftests/bpf: Convert sockopt test to ASSERT_* macros
      selftests/bpf: Convert sockopt_inherit test to ASSERT_* macros
      selftests/bpf: Convert sockopt_multi test to ASSERT_* macros
      selftests/bpf: Convert sockopt_sk test to ASSERT_* macros
      selftests/bpf: Convert tcp_estats test to ASSERT_* macros
      selftests/bpf: Convert tcp_hdr_options test to ASSERT_* macros
      selftests/bpf: Convert tcp_rtt test to ASSERT_* macros
      selftests/bpf: Convert tcpbpf_user test to ASSERT_* macros
      selftests/bpf: Convert udp_limit test to ASSERT_* macros

William Dean (1):
      bpf: simplify code in btf_parse_hdr

Xin Liu (3):
      libbpf: Clean up legacy bpf maps declaration in bpf_helpers
      libbpf: Fix NULL pointer exception in API btf_dump__dump_type_data
      libbpf: Fix overrun in netlink attribute iteration

Yauheni Kaliuta (4):
      bpf: Use bpf_capable() instead of CAP_SYS_ADMIN for blinding decision
      selftests: bpf: test_kmod.sh: Pass parameters to the module
      selftests/bpf: Add liburandom_read.so to TEST_GEN_FILES
      selftests/bpf: Fix passing arguments via function in test_kmod.sh

YiFei Zhu (3):
      bpf: Invoke cgroup/connect{4,6} programs for unprivileged ICMP ping
      selftests/bpf: Deduplicate write_sysctl() to test_progs.c
      selftests/bpf: Ensure cgroup/connect{4,6} programs can bind unpriv ICMP ping

Yonghong Song (9):
      bpf: Allow struct argument in trampoline based programs
      bpf: x86: Support in-register struct arguments in trampoline programs
      bpf: Update descriptions for helpers bpf_get_func_arg[_cnt]()
      bpf: arm64: No support of struct argument in trampoline programs
      libbpf: Add new BPF_PROG2 macro
      selftests/bpf: Add struct argument tests with fentry/fexit programs.
      selftests/bpf: Use BPF_PROG2 for some fentry programs without struct arguments
      selftests/bpf: Add tracing_struct test in DENYLIST.s390x
      libbpf: Improve BPF_PROG2 macro code quality and description

Yosry Ahmed (1):
      selftests/bpf: Simplify cgroup_hierarchical_stats selftest

Yuan Can (2):
      bpftool: Remove unused struct btf_attach_point
      bpftool: Remove unused struct event_ring_info

 Documentation/admin-guide/sysctl/net.rst           |    3 +
 Documentation/bpf/clang-notes.rst                  |   30 +
 Documentation/bpf/index.rst                        |    2 +
 Documentation/bpf/instruction-set.rst              |  316 ++---
 Documentation/bpf/kfuncs.rst                       |   24 +-
 Documentation/bpf/linux-notes.rst                  |   53 +
 arch/arm64/net/bpf_jit_comp.c                      |    8 +-
 arch/x86/Kconfig                                   |    1 +
 arch/x86/net/bpf_jit_comp.c                        |   98 +-
 include/asm-generic/vmlinux.lds.h                  |   11 +-
 include/linux/bpf.h                                |  161 ++-
 include/linux/bpf_types.h                          |    1 +
 include/linux/bpf_verifier.h                       |   29 +
 include/linux/btf.h                                |   19 +
 include/linux/filter.h                             |   13 +-
 include/linux/key.h                                |    6 +
 include/linux/kprobes.h                            |    1 +
 include/linux/poison.h                             |    3 +
 include/linux/tcp.h                                |    6 +
 include/linux/verification.h                       |    8 +
 include/net/netfilter/nf_conntrack_bpf.h           |   25 +-
 include/uapi/linux/bpf.h                           |   59 +-
 kernel/bpf/arraymap.c                              |   33 +-
 kernel/bpf/btf.c                                   |  269 +++-
 kernel/bpf/core.c                                  |    9 +-
 kernel/bpf/dispatcher.c                            |   27 +-
 kernel/bpf/hashtab.c                               |   68 +-
 kernel/bpf/helpers.c                               |   12 +-
 kernel/bpf/memalloc.c                              |    5 +-
 kernel/bpf/percpu_freelist.c                       |   48 +-
 kernel/bpf/ringbuf.c                               |  243 +++-
 kernel/bpf/syscall.c                               |   29 +-
 kernel/bpf/task_iter.c                             |  224 +++-
 kernel/bpf/trampoline.c                            |   60 +-
 kernel/bpf/verifier.c                              |  339 ++---
 kernel/kprobes.c                                   |    6 +-
 kernel/trace/Kconfig                               |    6 +
 kernel/trace/bpf_trace.c                           |  211 +++-
 kernel/trace/ftrace.c                              |    3 +-
 net/bpf/test_run.c                                 |   37 +
 net/core/filter.c                                  |  124 +-
 net/core/skmsg.c                                   |   12 +-
 net/core/stream.c                                  |    3 +-
 net/ipv4/bpf_tcp_ca.c                              |    2 +-
 net/ipv4/ping.c                                    |   15 +
 net/ipv4/tcp_minisocks.c                           |    1 +
 net/ipv6/ping.c                                    |   16 +
 net/netfilter/Makefile                             |    6 +
 net/netfilter/nf_conntrack_bpf.c                   |   74 +-
 net/netfilter/nf_conntrack_core.c                  |    1 +
 net/netfilter/nf_nat_bpf.c                         |   79 ++
 net/netfilter/nf_nat_core.c                        |    4 +-
 samples/bpf/task_fd_query_kern.c                   |    2 +-
 samples/bpf/task_fd_query_user.c                   |    2 +-
 samples/bpf/tracex3_kern.c                         |    2 +-
 samples/bpf/xdp_router_ipv4_user.c                 |    2 +-
 security/keys/internal.h                           |    2 -
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |    2 +-
 tools/bpf/bpftool/btf.c                            |   16 +-
 tools/bpf/bpftool/gen.c                            |    4 +-
 tools/bpf/bpftool/link.c                           |   19 +
 tools/bpf/bpftool/map.c                            |    2 +-
 tools/bpf/bpftool/map_perf_ring.c                  |   14 +-
 tools/include/uapi/linux/bpf.h                     |   59 +-
 tools/lib/bpf/bpf_helpers.h                        |   31 +-
 tools/lib/bpf/bpf_tracing.h                        |  107 ++
 tools/lib/bpf/btf.c                                |   32 +-
 tools/lib/bpf/btf.h                                |   25 +-
 tools/lib/bpf/btf_dump.c                           |    2 +-
 tools/lib/bpf/libbpf.c                             |  106 +-
 tools/lib/bpf/libbpf.h                             |  111 +-
 tools/lib/bpf/libbpf.map                           |   10 +
 tools/lib/bpf/libbpf_probes.c                      |    1 +
 tools/lib/bpf/libbpf_version.h                     |    2 +-
 tools/lib/bpf/nlattr.c                             |    2 +-
 tools/lib/bpf/ringbuf.c                            |  271 ++++
 tools/lib/bpf/usdt.c                               |    2 +-
 tools/objtool/check.c                              |    3 +-
 tools/testing/selftests/bpf/.gitignore             |    2 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |    5 +
 tools/testing/selftests/bpf/Makefile               |   27 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |   48 +
 tools/testing/selftests/bpf/config                 |   33 +-
 tools/testing/selftests/bpf/config.x86_64          |    7 +-
 .../selftests/bpf/map_tests/array_map_batch_ops.c  |    2 +
 .../selftests/bpf/map_tests/htab_map_batch_ops.c   |    2 +
 .../bpf/map_tests/lpm_trie_map_batch_ops.c         |    2 +
 .../selftests/bpf/map_tests/task_storage_map.c     |    7 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  282 ++++-
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |   13 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |    4 +
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |    2 +-
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c |   20 -
 .../bpf/prog_tests/cgroup_hierarchical_stats.c     |  170 ++-
 .../selftests/bpf/prog_tests/connect_ping.c        |  178 +++
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |    2 +-
 .../selftests/bpf/prog_tests/get_func_ip_test.c    |   59 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |  227 +++-
 .../selftests/bpf/prog_tests/kfunc_dynptr_param.c  |  164 +++
 .../testing/selftests/bpf/prog_tests/lookup_key.c  |  112 ++
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   87 +-
 .../selftests/bpf/prog_tests/sockmap_ktls.c        |   39 +-
 tools/testing/selftests/bpf/prog_tests/sockopt.c   |    4 +-
 .../selftests/bpf/prog_tests/sockopt_inherit.c     |   30 +-
 .../selftests/bpf/prog_tests/sockopt_multi.c       |   10 +-
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |    2 +-
 .../testing/selftests/bpf/prog_tests/tcp_estats.c  |    4 +-
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |  100 +-
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   |   13 +-
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   32 +-
 .../selftests/bpf/prog_tests/tracing_struct.c      |   63 +
 tools/testing/selftests/bpf/prog_tests/udp_limit.c |   18 +-
 .../selftests/bpf/prog_tests/user_ringbuf.c        |  754 +++++++++++
 .../selftests/bpf/prog_tests/verify_pkcs7_sig.c    |  399 ++++++
 tools/testing/selftests/bpf/progs/bpf_dctcp.c      |   25 +-
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |    9 +
 .../selftests/bpf/progs/bpf_iter_task_file.c       |    9 +-
 .../selftests/bpf/progs/bpf_iter_task_vma.c        |    7 +-
 .../selftests/bpf/progs/bpf_iter_vma_offset.c      |   37 +
 .../bpf/progs/cgroup_hierarchical_stats.c          |  181 +--
 tools/testing/selftests/bpf/progs/connect_ping.c   |   53 +
 .../testing/selftests/bpf/progs/get_func_ip_test.c |   25 +-
 .../testing/selftests/bpf/progs/kfunc_call_fail.c  |  160 +++
 .../testing/selftests/bpf/progs/kfunc_call_test.c  |   71 ++
 tools/testing/selftests/bpf/progs/kprobe_multi.c   |    4 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |   43 +-
 .../testing/selftests/bpf/progs/test_bpf_nf_fail.c |   14 +
 .../selftests/bpf/progs/test_kfunc_dynptr_param.c  |   94 ++
 .../testing/selftests/bpf/progs/test_lookup_key.c  |   46 +
 .../selftests/bpf/progs/test_user_ringbuf.h        |   35 +
 .../selftests/bpf/progs/test_verif_scale1.c        |    2 +-
 .../selftests/bpf/progs/test_verif_scale3.c        |    2 +-
 .../selftests/bpf/progs/test_verify_pkcs7_sig.c    |   90 ++
 tools/testing/selftests/bpf/progs/timer.c          |    4 +-
 tools/testing/selftests/bpf/progs/tracing_struct.c |  120 ++
 .../selftests/bpf/progs/user_ringbuf_fail.c        |  177 +++
 .../selftests/bpf/progs/user_ringbuf_success.c     |  218 ++++
 tools/testing/selftests/bpf/test_kmod.sh           |   20 +-
 tools/testing/selftests/bpf/test_maps.c            |   26 +-
 tools/testing/selftests/bpf/test_maps.h            |    2 +
 tools/testing/selftests/bpf/test_progs.c           |   17 +
 tools/testing/selftests/bpf/test_progs.h           |    1 +
 tools/testing/selftests/bpf/test_sockmap.c         |   42 +
 tools/testing/selftests/bpf/test_verifier.c        |    3 +-
 tools/testing/selftests/bpf/verifier/calls.c       |    2 +-
 .../testing/selftests/bpf/verifier/ref_tracking.c  |  139 ++
 tools/testing/selftests/bpf/verifier/var_off.c     |    2 +-
 tools/testing/selftests/bpf/verify_sig_setup.sh    |  104 ++
 tools/testing/selftests/bpf/veristat.c             | 1322 ++++++++++++++++++++
 tools/testing/selftests/bpf/veristat.cfg           |   17 +
 tools/testing/selftests/bpf/xskxceiver.c           |    3 -
 151 files changed, 8321 insertions(+), 1402 deletions(-)
 create mode 100644 Documentation/bpf/clang-notes.rst
 create mode 100644 Documentation/bpf/linux-notes.rst
 create mode 100644 net/netfilter/nf_nat_bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_ping.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfunc_dynptr_param.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lookup_key.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tracing_struct.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_vma_offset.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_ping.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_kfunc_dynptr_param.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_lookup_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_user_ringbuf.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/tracing_struct.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_ringbuf_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_ringbuf_success.c
 create mode 100755 tools/testing/selftests/bpf/verify_sig_setup.sh
 create mode 100644 tools/testing/selftests/bpf/veristat.c
 create mode 100644 tools/testing/selftests/bpf/veristat.cfg

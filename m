Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F306AD36C
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 01:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCGAnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 19:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCGAnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 19:43:52 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EABC3E61C;
        Mon,  6 Mar 2023 16:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=ZxuEu5LD9liE9XA2oDCZf0PTGd2pmO9hj/lksy+ePgI=; b=gx8yJ5/kCkxbQWMeixM6hz/qEy
        JoJmXZ36abi+EsWCC0IDQhI4kVhYumByqiinHe8vaOzdNKop8X67XaceAux4RbsLoVvwECK0eV8pF
        x9Uvk26nREdY81YSUxHKlbcmpnT5mCEBav2p3cEvGeNCVPFDeb4yQ7yNbGxlUMGqEVXIv5G8RO/IY
        xDhcg1TTNCDToKVlVXHMCMIdC5Bs51swFpC8u1dzhlq/Vup1UFpaM7EPSsMoEr0uOSbpA4CNx3VcU
        UWtpv02gh/tVgvbrcgmCEM8ujz3eFguwod1hW1kRvMveZskq7/TeYGabXGLji3EoY/BI/W9R+fY3j
        gmuRuKdw==;
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pZLQg-000PAC-L6; Tue, 07 Mar 2023 01:43:46 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2023-03-06
Date:   Tue,  7 Mar 2023 01:43:46 +0100
Message-Id: <20230307004346.27578-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26833/Mon Mar  6 09:22:59 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

There is a small conflict once net tree gets merged into net-next
between commit b7abcd9c656b ("bpf, doc: Link to submitting-patches.rst
for general patch submission info") from the bpf tree and commit
d56b0c461d19 ("bpf, docs: Fix link to netdev-FAQ target") from the
bpf-next tree. Follow Stephen's resolution:
https://lore.kernel.org/bpf/20230307095812.236eb1be@canb.auug.org.au/

We've added 85 non-merge commits during the last 13 day(s) which contain
a total of 131 files changed, 7102 insertions(+), 1792 deletions(-).

The main changes are:

1) Add skb and XDP typed dynptrs which allow BPF programs for more ergonomic and
   less brittle iteration through data and variable-sized accesses, from Joanne Koong.

2) Bigger batch of BPF verifier improvements to prepare for upcoming BPF open-coded
   iterators allowing for less restrictive looping capabilities, from Andrii Nakryiko.

3) Rework RCU enforcement in the verifier, add kptr_rcu and enforce BPF programs
   to NULL-check before passing such pointers into kfunc, from Alexei Starovoitov.

4) Add support for kptrs in percpu hashmaps, percpu LRU hashmaps and in local
   storage maps, from Kumar Kartikeya Dwivedi.

5) Add BPF verifier support for ST instructions in convert_ctx_access() which will
   help new -mcpu=v4 clang flag to start emitting them, from Eduard Zingerman.

6) Make uprobe attachment Android APK aware by supporting attachment to functions
   inside ELF objects contained in APKs via function names, from Daniel Müller.

7) Add a new flag BPF_F_TIMER_ABS flag for bpf_timer_start() helper to start the
   timer with absolute expiration value instead of relative one, from Tero Kristo.

8) Add a new kfunc bpf_cgroup_from_id() to look up cgroups via id, from Tejun Heo.

9) Extend libbpf to support users manually attaching kprobes/uprobes in the
   legacy/perf/link mode, from Menglong Dong.

10) Implement workarounds in the mips BPF JIT for DADDI/R4000, from Jiaxun Yang.

11) Enable mixing bpf2bpf and tailcalls for the loongarch BPF JIT, from Hengqi Chen.

12) Extend BPF instruction set doc with describing the encoding of BPF instructions
    in terms of how bytes are stored under big/little endian, from Jose E. Marchesi.

13) Follow-up to enable kfunc support for riscv BPF JIT, from Pu Lehui.

14) Fix bpf_xdp_query() backwards compatibility on old kernels, from Yonghong Song.

15) Fix BPF selftest cross compilation with CLANG_CROSS_FLAGS, from Florent Revest.

16) Improve bpf_cpumask_ma to only allocate one bpf_mem_cache, from Hou Tao.

17) Fix BPF verifier's check_subprogs to not unnecessarily mark a subprogram
    with has_tail_call, from Ilya Leoshkevich.

18) Fix arm syscall regs spec in libbpf's bpf_tracing.h, from Puranjay Mohan.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Biao Jiang, Björn Töpel, David Vernet, Jiri Olsa, Johan 
Almbladh, kernel test robot, Matthieu Baerts, Michał Gregorczyk, 
Philippe Mathieu-Daudé, Quentin Monnet, Stanislav Fomichev, Tejun Heo, 
Willem de Bruijn, Yonghong Song

----------------------------------------------------------------

The following changes since commit 5b7c4cabbb65f5c469464da6c5f614cbd7f730f2:

  Merge tag 'net-next-6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2023-02-21 18:24:12 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 8f4c92f0024ff2a30f002e85f87e531d49dc023c:

  Merge branch 'libbpf: allow users to set kprobe/uprobe attach mode' (2023-03-06 09:38:08 -0800)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (10):
      Merge branch 'bpf: Allow reads from uninit stack'
      Merge branch 'Add skb + xdp dynptrs'
      Merge branch 'Add support for kptrs in more BPF maps'
      bpf: Rename __kptr_ref -> __kptr and __kptr -> __kptr_untrusted.
      bpf: Mark cgroups and dfl_cgrp fields as trusted.
      bpf: Introduce kptr_rcu.
      selftests/bpf: Add a test case for kptr_rcu.
      selftests/bpf: Tweak cgroup kfunc test.
      bpf: Refactor RCU enforcement in the verifier.
      Merge branch 'bpf: allow ctx writes using BPF_ST_MEM instruction'

Andrii Nakryiko (17):
      Merge branch 'libbpf: fix several issues reported by static analysers'
      selftests/bpf: Support custom per-test flags and multiple expected messages
      Merge branch 'selftests/bpf: support custom per-test flags and multiple expected messages'
      Merge branch 'Make uprobe attachment APK aware'
      bpf: improve stack slot state printing
      bpf: improve regsafe() checks for PTR_TO_{MEM,BUF,TP_BUFFER}
      selftests/bpf: enhance align selftest's expected log matching
      bpf: honor env->test_state_freq flag in is_state_visited()
      selftests/bpf: adjust log_fixup's buffer size for proper truncation
      bpf: clean up visit_insn()'s instruction processing
      bpf: fix visit_insn()'s detection of BPF_FUNC_timer_set_callback helper
      bpf: ensure that r0 is marked scratched after any function call
      bpf: move kfunc_call_arg_meta higher in the file
      bpf: mark PTR_TO_MEM as non-null register type
      bpf: generalize dynptr_get_spi to be usable for iters
      bpf: add support for fixed-size memory pointer returns for kfuncs
      Merge branch 'libbpf: allow users to set kprobe/uprobe attach mode'

Daniel Borkmann (1):
      Merge branch 'bpf-kptr-rcu'

Daniel Müller (3):
      libbpf: Implement basic zip archive parsing support
      libbpf: Introduce elf_find_func_offset_from_file() function
      libbpf: Add support for attaching uprobes to shared objects in APKs

Dave Marchevsky (1):
      selftests/bpf: Add -Wuninitialized flag to bpf prog flags

Dave Thaler (1):
      bpf, docs: Add explanation of endianness

David Vernet (5):
      bpf: Fix bpf_cgroup_from_id() doxygen header
      bpf: Fix doxygen comments for dynptr slice kfuncs
      bpf, docs: Fix __uninit kfunc doc section
      bpf, docs: Fix link to netdev-FAQ target
      bpf, docs: Fix final bpf docs build failure

Eduard Zingerman (5):
      bpf: Allow reads from uninit stack
      selftests/bpf: Tests for uninitialized stack reads
      bpf: allow ctx writes using BPF_ST_MEM instruction
      selftests/bpf: test if pointer type is tracked for BPF_ST_MEM
      selftests/bpf: Disassembler tests for verifier.c:convert_ctx_access()

Florent Revest (1):
      selftests/bpf: Fix cross compilation with CLANG_CROSS_FLAGS

Hangbin Liu (2):
      selftests/bpf: move SYS() macro into the test_progs.h
      selftests/bpf: run mptcp in a dedicated netns

Hengqi Chen (1):
      LoongArch: BPF: Support mixing bpf2bpf and tailcalls

Hou Tao (1):
      bpf: Only allocate one bpf_mem_cache for bpf_cpumask_ma

Ilya Leoshkevich (2):
      bpf: Check for helper calls in check_subprogs()
      libbpf: Document bpf_{btf,link,map,prog}_get_info_by_fd()

Jiaxun Yang (2):
      bpf, mips: Implement DADDI workarounds for JIT
      bpf, mips: Implement R4000 workarounds for JIT

Joanne Koong (11):
      bpf: Support "sk_buff" and "xdp_buff" as valid kfunc arg types
      bpf: Refactor process_dynptr_func
      bpf: Allow initializing dynptrs in kfuncs
      bpf: Define no-ops for externally called bpf dynptr functions
      bpf: Refactor verifier dynptr into get_dynptr_arg_reg
      bpf: Add __uninit kfunc annotation
      bpf: Add skb dynptrs
      bpf: Add xdp dynptrs
      bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
      selftests/bpf: tests for using dynptrs to parse skb and xdp buffers
      bpf: Fix bpf_dynptr_slice{_rdwr} to return NULL instead of 0

Jose E. Marchesi (1):
      bpf, docs: Document BPF insn encoding in term of stored bytes

Kumar Kartikeya Dwivedi (8):
      bpf: Annotate data races in bpf_local_storage
      bpf: Remove unused MEM_ALLOC | PTR_TRUSTED checks
      bpf: Fix check_reg_type for PTR_TO_BTF_ID
      bpf: Wrap register invalidation with a helper
      bpf: Support kptrs in percpu hashmap and percpu LRU hashmap
      bpf: Support kptrs in local storage maps
      selftests/bpf: Add more tests for kptrs in maps
      bpf: Use separate RCU callbacks for freeing selem

Luis Gerhorst (1):
      tools: bpftool: Remove invalid \' json escape

Martin KaFai Lau (1):
      Merge branch 'move SYS() macro to test_progs.h and run mptcp in a dedicated netns'

Menglong Dong (3):
      libbpf: Add support to set kprobe/uprobe attach mode
      selftests/bpf: Split test_attach_probe into multi subtests
      selftests/bpf: Add test for legacy/perf kprobe/uprobe attach mode

Pu Lehui (1):
      riscv, bpf: Add kfunc support for RV64

Puranjay Mohan (1):
      libbpf: Fix arm syscall regs spec in bpf_tracing.h

Rong Tao (2):
      selftests/bpf: Fix compilation errors: Assign a value to a constant
      tools/resolve_btfids: Add /libsubcmd to .gitignore

Stanislav Fomichev (1):
      selftests/bpf: Fix BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL for empty flow label

Tejun Heo (3):
      bpf: Add bpf_cgroup_from_id() kfunc
      selftests/bpf: Add a test case for bpf_cgroup_from_id()
      bpf: Make bpf_get_current_[ancestor_]cgroup_id() available for all program types

Tero Kristo (2):
      bpf: Add support for absolute value BPF timers
      selftests/bpf: Add absolute timer test

Tiezhu Yang (4):
      selftests/bpf: Remove not used headers
      libbpf: Use struct user_pt_regs to define __PT_REGS_CAST() for LoongArch
      selftests/bpf: Use __NR_prlimit64 instead of __NR_getrlimit in user_ringbuf test
      selftests/bpf: Set __BITS_PER_LONG if target is bpf for LoongArch

Viktor Malik (3):
      libbpf: Remove unnecessary ternary operator
      libbpf: Remove several dead assignments
      libbpf: Cleanup linker_append_elf_relos

Yonghong Song (1):
      libbpf: Fix bpf_xdp_query() in old kernels

 Documentation/bpf/bpf_design_QA.rst                |   4 +-
 Documentation/bpf/bpf_devel_QA.rst                 |  14 +-
 Documentation/bpf/cpumasks.rst                     |   4 +-
 Documentation/bpf/instruction-set.rst              |  40 +-
 Documentation/bpf/kfuncs.rst                       |  41 +-
 Documentation/bpf/maps.rst                         |   7 +-
 arch/loongarch/net/bpf_jit.c                       |   6 +
 arch/mips/Kconfig                                  |   5 +-
 arch/mips/net/bpf_jit_comp.c                       |   4 +
 arch/mips/net/bpf_jit_comp64.c                     |   3 +
 arch/riscv/net/bpf_jit_comp64.c                    |   5 +
 include/linux/bpf.h                                |  97 +-
 include/linux/bpf_mem_alloc.h                      |   7 +
 include/linux/bpf_verifier.h                       |   4 -
 include/linux/btf.h                                |   2 +-
 include/linux/filter.h                             |  46 +
 include/uapi/linux/bpf.h                           |  33 +-
 kernel/bpf/bpf_local_storage.c                     |  85 +-
 kernel/bpf/btf.c                                   |  42 +-
 kernel/bpf/cgroup.c                                |  53 +-
 kernel/bpf/cpumask.c                               |  46 +-
 kernel/bpf/hashtab.c                               |  59 +-
 kernel/bpf/helpers.c                               | 257 +++++-
 kernel/bpf/syscall.c                               |   8 +-
 kernel/bpf/verifier.c                              | 974 +++++++++++++-------
 kernel/trace/bpf_trace.c                           |   4 -
 net/bpf/test_run.c                                 |   3 +-
 net/core/filter.c                                  | 193 +++-
 tools/arch/arm64/include/uapi/asm/bpf_perf_event.h |   9 -
 tools/arch/s390/include/uapi/asm/bpf_perf_event.h  |   9 -
 tools/arch/s390/include/uapi/asm/ptrace.h          | 458 ----------
 tools/bpf/bpftool/json_writer.c                    |   3 -
 tools/bpf/resolve_btfids/.gitignore                |   1 +
 tools/include/uapi/linux/bpf.h                     |  33 +-
 tools/lib/bpf/Build                                |   2 +-
 tools/lib/bpf/bpf.h                                |  69 +-
 tools/lib/bpf/bpf_helpers.h                        |   2 +-
 tools/lib/bpf/bpf_tracing.h                        |   3 +
 tools/lib/bpf/btf.c                                |   2 -
 tools/lib/bpf/libbpf.c                             | 197 ++++-
 tools/lib/bpf/libbpf.h                             |  50 +-
 tools/lib/bpf/linker.c                             |  11 +-
 tools/lib/bpf/netlink.c                            |   8 +-
 tools/lib/bpf/relo_core.c                          |   3 -
 tools/lib/bpf/zip.c                                | 328 +++++++
 tools/lib/bpf/zip.h                                |  47 +
 tools/scripts/Makefile.include                     |   2 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |   2 +
 tools/testing/selftests/bpf/Makefile               |   7 +-
 tools/testing/selftests/bpf/bpf_kfuncs.h           |  38 +
 tools/testing/selftests/bpf/disasm.c               |   1 +
 tools/testing/selftests/bpf/disasm.h               |   1 +
 tools/testing/selftests/bpf/prog_tests/align.c     |  18 +-
 .../selftests/bpf/prog_tests/attach_probe.c        | 291 ++++--
 .../testing/selftests/bpf/prog_tests/cgrp_kfunc.c  |   1 +
 .../selftests/bpf/prog_tests/cgrp_local_storage.c  |  14 +-
 .../selftests/bpf/prog_tests/cls_redirect.c        |  25 +
 .../testing/selftests/bpf/prog_tests/ctx_rewrite.c | 917 +++++++++++++++++++
 .../selftests/bpf/prog_tests/decap_sanity.c        |  16 +-
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |  74 +-
 tools/testing/selftests/bpf/prog_tests/empty_skb.c |  25 +-
 .../testing/selftests/bpf/prog_tests/fib_lookup.c  |  28 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |  24 +
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |   2 +
 tools/testing/selftests/bpf/prog_tests/log_fixup.c |   2 +-
 tools/testing/selftests/bpf/prog_tests/map_kptr.c  | 136 ++-
 tools/testing/selftests/bpf/prog_tests/mptcp.c     |  19 +-
 .../selftests/bpf/prog_tests/parse_tcp_hdr_opt.c   |  93 ++
 .../selftests/bpf/prog_tests/rcu_read_lock.c       |  16 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c | 100 +--
 .../testing/selftests/bpf/prog_tests/test_tunnel.c |  71 +-
 tools/testing/selftests/bpf/prog_tests/timer.c     |   3 +
 .../selftests/bpf/prog_tests/uninit_stack.c        |   9 +
 .../selftests/bpf/prog_tests/user_ringbuf.c        |   2 +-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |  11 +-
 .../testing/selftests/bpf/prog_tests/xdp_bonding.c |  40 +-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |  30 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c        |  23 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        |  41 +-
 tools/testing/selftests/bpf/prog_tests/xfrm_info.c |  67 +-
 tools/testing/selftests/bpf/progs/bpf_flow.c       |   2 +-
 tools/testing/selftests/bpf/progs/bpf_misc.h       |  23 +
 tools/testing/selftests/bpf/progs/cb_refs.c        |   2 +-
 .../selftests/bpf/progs/cgrp_kfunc_common.h        |   3 +-
 .../selftests/bpf/progs/cgrp_kfunc_failure.c       |   2 +-
 .../selftests/bpf/progs/cgrp_kfunc_success.c       |  54 +-
 .../selftests/bpf/progs/cgrp_ls_sleepable.c        |   4 +-
 tools/testing/selftests/bpf/progs/cpumask_common.h |   2 +-
 .../testing/selftests/bpf/progs/cpumask_failure.c  |   2 +-
 tools/testing/selftests/bpf/progs/dynptr_fail.c    | 287 +++++-
 tools/testing/selftests/bpf/progs/dynptr_success.c |  55 +-
 tools/testing/selftests/bpf/progs/find_vma_fail1.c |   2 +-
 tools/testing/selftests/bpf/progs/jit_probe_mem.c  |   2 +-
 tools/testing/selftests/bpf/progs/lru_bug.c        |   2 +-
 tools/testing/selftests/bpf/progs/map_kptr.c       | 360 +++++++-
 tools/testing/selftests/bpf/progs/map_kptr_fail.c  |  10 +-
 .../selftests/bpf/progs/nested_trust_failure.c     |   2 +-
 tools/testing/selftests/bpf/progs/rbtree.c         |   2 +-
 tools/testing/selftests/bpf/progs/rbtree_fail.c    |   7 +-
 tools/testing/selftests/bpf/progs/rcu_read_lock.c  |   6 +-
 .../selftests/bpf/progs/rcu_tasks_trace_gp.c       |  36 +
 .../selftests/bpf/progs/task_kfunc_common.h        |   2 +-
 .../bpf/progs/test_attach_kprobe_sleepable.c       |  23 +
 .../selftests/bpf/progs/test_attach_probe.c        |  35 +-
 .../selftests/bpf/progs/test_attach_probe_manual.c |  53 ++
 .../selftests/bpf/progs/test_cls_redirect_dynptr.c | 980 +++++++++++++++++++++
 .../selftests/bpf/progs/test_global_func10.c       |   8 +-
 .../selftests/bpf/progs/test_kfunc_dynptr_param.c  |   2 +-
 .../bpf/progs/test_l4lb_noinline_dynptr.c          | 487 ++++++++++
 .../selftests/bpf/progs/test_parse_tcp_hdr_opt.c   | 119 +++
 .../bpf/progs/test_parse_tcp_hdr_opt_dynptr.c      | 114 +++
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |   2 +-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |  10 +-
 .../testing/selftests/bpf/progs/test_xdp_dynptr.c  | 257 ++++++
 tools/testing/selftests/bpf/progs/timer.c          |  45 +
 tools/testing/selftests/bpf/progs/uninit_stack.c   |  87 ++
 .../selftests/bpf/progs/user_ringbuf_success.c     |   2 +-
 tools/testing/selftests/bpf/test_loader.c          |  69 +-
 tools/testing/selftests/bpf/test_progs.h           |  16 +
 tools/testing/selftests/bpf/test_tcp_hdr_options.h |   1 +
 tools/testing/selftests/bpf/test_verifier.c        |  22 +-
 tools/testing/selftests/bpf/verifier/calls.c       |  17 +-
 tools/testing/selftests/bpf/verifier/ctx.c         |  11 -
 .../selftests/bpf/verifier/helper_access_var_len.c | 104 ++-
 tools/testing/selftests/bpf/verifier/int_ptr.c     |   9 +-
 tools/testing/selftests/bpf/verifier/map_kptr.c    |   2 +-
 .../selftests/bpf/verifier/search_pruning.c        |  13 +-
 tools/testing/selftests/bpf/verifier/sock.c        |  27 -
 tools/testing/selftests/bpf/verifier/spill_fill.c  |   7 +-
 tools/testing/selftests/bpf/verifier/unpriv.c      |  23 +
 tools/testing/selftests/bpf/verifier/var_off.c     |  52 --
 131 files changed, 7102 insertions(+), 1792 deletions(-)
 delete mode 100644 tools/arch/arm64/include/uapi/asm/bpf_perf_event.h
 delete mode 100644 tools/arch/s390/include/uapi/asm/bpf_perf_event.h
 delete mode 100644 tools/arch/s390/include/uapi/asm/ptrace.h
 create mode 100644 tools/lib/bpf/zip.c
 create mode 100644 tools/lib/bpf/zip.h
 create mode 100644 tools/testing/selftests/bpf/bpf_kfuncs.h
 create mode 120000 tools/testing/selftests/bpf/disasm.c
 create mode 120000 tools/testing/selftests/bpf/disasm.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ctx_rewrite.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/uninit_stack.c
 create mode 100644 tools/testing/selftests/bpf/progs/rcu_tasks_trace_gp.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_attach_kprobe_sleepable.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_attach_probe_manual.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/uninit_stack.c

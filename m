Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500D24AFF16
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiBIVQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:16:55 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiBIVQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:16:54 -0500
X-Greylist: delayed 961 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 13:16:55 PST
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759F2C014F32;
        Wed,  9 Feb 2022 13:16:55 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nHu55-0005ht-D0; Wed, 09 Feb 2022 22:00:51 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-02-09
Date:   Wed,  9 Feb 2022 22:00:50 +0100
Message-Id: <20220209210050.8425-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26448/Wed Feb  9 10:31:19 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 126 non-merge commits during the last 16 day(s) which contain
a total of 201 files changed, 4049 insertions(+), 2215 deletions(-).

The main changes are:

1) Add custom BPF allocator for JITs that pack multiple programs into a huge
   page to reduce iTLB pressure, from Song Liu.

2) Add __user tagging support in vmlinux BTF and utilize it from BPF verifier
   when generating loads, from Yonghong Song.

3) Add per-socket fast path check guarding from cgroup/BPF overhead when
   used by only some sockets, from Pavel Begunkov.

4) Continued libbpf deprecation work of APIs/features and removal of their
   usage from samples, selftests, libbpf & bpftool, from Andrii Nakryiko and
   various others.

5) Improve BPF instruction set documentation by adding byte swap instructions
   and cleaning up load/store section, from Christoph Hellwig.

6) Switch BPF preload infra to light skeleton and remove libbpf dependency
   from it, from Alexei Starovoitov.

7) Fix architecture-agnostic macros in libbpf for accessing syscall arguments
   from BPF progs for non-x86 architectures, from Ilya Leoshkevich.

8) Rework port members in struct bpf_sk_lookup and struct bpf_sock to be
   of 16-bit field with anonymous zero padding, from Jakub Sitnicki.

9) Add new bpf_copy_from_user_task() helper to read memory from a different task
   than current. Add ability to create sleepable BPF iterator progs, from Kenny Yu.

10) Implement XSK batching for ice's zero-copy driver used by AF_XDP and
    utilize TX batching API from XSK buffer pool, from Maciej Fijalkowski.

11) Generate temporary netns names for BPF selftests to avoid naming
    collisions, from Hangbin Liu.

12) Implement bpf_core_types_are_compat() with limited recursion for
    in-kernel usage, from Matteo Croce.

13) Simplify pahole version detection and finally enable CONFIG_DEBUG_INFO_DWARF5
    to be selected with CONFIG_DEBUG_INFO_BTF, from Nathan Chancellor.

14) Misc minor fixes to libbpf and selftests from various folks.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexander Lobakin, Andrii Nakryiko, Brendan Jackman, Delyan Kratunov, 
Heiko Carstens, John Fastabend, kernel test robot, Kumar Kartikeya 
Dwivedi, Lorenz Bauer, Lorenzo Bianconi, Maciej Fijalkowski, Magnus 
Karlsson, Martin KaFai Lau, Menglong Dong, Naveen N. Rao, Peter Zijlstra 
(Intel), Quentin Monnet, Stanislav Fomichev, syzbot, William Tu, 
Yonghong Song

----------------------------------------------------------------

The following changes since commit caaba96131b3a132590316c49887af85e07930b6:

  Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2022-01-24 15:42:29 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to e5313968c41ba890a91344773a0474d0246d20a3:

  Merge branch 'Split bpf_sk_lookup remote_port field' (2022-02-09 11:40:46 -0800)

----------------------------------------------------------------
Alexei Starovoitov (15):
      Merge branch 'Add bpf_copy_from_user_task helper and sleepable bpf iterator programs'
      Merge branch 'libbpf: deprecate some setter and getter APIs'
      Merge branch 'bpf: add __user tagging support in vmlinux BTF'
      Merge branch 'selftests/bpf: use temp netns for testing'
      Merge branch 'Split bpf_sock dst_port field'
      libbpf: Add support for bpf iter in light skeleton.
      libbpf: Open code low level bpf commands.
      libbpf: Open code raw_tp_open and link_create commands.
      bpf: Remove unnecessary setrlimit from bpf preload.
      bpf: Convert bpf preload to light skeleton.
      bpf: Open code obj_get_info_by_fd in bpf preload.
      bpf: Drop libbpf, libelf, libz dependency from bpf preload.
      Merge branch 'bpf_prog_pack allocator'
      Merge branch 'fix bpf_prog_pack build errors'
      Merge branch 'Split bpf_sk_lookup remote_port field'

Andrii Nakryiko (23):
      Merge branch 'deprecate bpf_object__open_buffer() API'
      Merge branch 'Fix the incorrect register read for syscalls on x86_64'
      libbpf: hide and discourage inconsistently named getters
      libbpf: deprecate bpf_map__resize()
      libbpf: deprecate bpf_program__is_<type>() and bpf_program__set_<type>() APIs
      bpftool: use preferred setters/getters instead of deprecated ones
      selftests/bpf: use preferred setter/getter APIs instead of deprecated ones
      samples/bpf: use preferred getters/setters instead of deprecated ones
      perf: use generic bpf_program__set_type() to set BPF prog type
      selftests/bpf: fix uprobe offset calculation in selftests
      Merge branch 'libbpf: deprecate xdp_cpumap, xdp_devmap and classifier sec definitions'
      Merge branch 'migrate from bpf_prog_test_run{,_xattr}'
      libbpf: Stop using deprecated bpf_map__is_offload_neutral()
      bpftool: Stop supporting BPF offload-enabled feature probing
      bpftool: Fix uninit variable compilation warning
      selftests/bpf: Remove usage of deprecated feature probing APIs
      selftests/bpf: Redo the switch to new libbpf XDP APIs
      samples/bpf: Get rid of bpf_prog_load_xattr() use
      libbpf: Deprecate forgotten btf__get_map_kv_tids()
      Merge branch 'bpf: Fix strict mode calculation'
      Merge branch 'Fix accessing syscall arguments'
      Merge branch 'libbpf: Add syscall-specific variant of BPF_KPROBE'
      libbpf: Fix compilation warning due to mismatched printf format

Christoph Hellwig (5):
      bpf, docs: Document the byte swapping instructions
      bpf, docs: Better document the regular load and store instructions
      bpf, docs: Better document the legacy packet access instruction
      bpf, docs: Better document the extended instruction format
      bpf, docs: Better document the atomic instructions

Christy Lee (3):
      libbpf: Mark bpf_object__open_buffer() API deprecated
      perf: Stop using bpf_object__open_buffer() API
      libbpf: Mark bpf_object__open_xattr() deprecated

Dan Carpenter (1):
      libbpf: Fix signedness bug in btf_dump_array_data()

Daniel Borkmann (4):
      Merge branch 'xsk-batching'
      Merge branch 'bpf-drop-libbpf-from-preload'
      Merge branch 'bpf-btf-dwarf5'
      Merge branch 'bpf-libbpf-deprecated-cleanup'

Dave Marchevsky (1):
      libbpf: Deprecate btf_ext rec_size APIs

Delyan Kratunov (5):
      selftests/bpf: Migrate from bpf_prog_test_run
      selftests/bpf: Migrate from bpf_prog_test_run_xattr
      bpftool: Migrate from bpf_prog_test_run_xattr
      libbpf: Deprecate bpf_prog_test_run_xattr and bpf_prog_test_run
      libbpf: Deprecate priv/set_priv storage

Felix Maurer (1):
      selftests: bpf: Less strict size check in sockopt_sk

Hangbin Liu (7):
      selftests/bpf/test_xdp_redirect_multi: use temp netns for testing
      selftests/bpf/test_xdp_veth: use temp netns for testing
      selftests/bpf/test_xdp_vlan: use temp netns for testing
      selftests/bpf/test_lwt_seg6local: use temp netns for testing
      selftests/bpf/test_tcp_check_syncookie: use temp netns for testing
      selftests/bpf/test_xdp_meta: use temp netns for testing
      selftests/bpf/test_xdp_redirect: use temp netns for testing

Hengqi Chen (2):
      libbpf: Add BPF_KPROBE_SYSCALL macro
      selftests/bpf: Test BPF_KPROBE_SYSCALL macro

Hou Tao (3):
      bpf, x86: Remove unnecessary handling of BPF_SUB atomic op
      bpf, arm64: Enable kfunc call
      selftests/bpf: Do not export subtest as standalone test

Ilya Leoshkevich (10):
      selftests/bpf: Fix an endianness issue in bpf_syscall_macro test
      libbpf: Add PT_REGS_SYSCALL_REGS macro
      selftests/bpf: Use PT_REGS_SYSCALL_REGS in bpf_syscall_macro
      libbpf: Fix accessing syscall arguments on powerpc
      libbpf: Fix riscv register names
      libbpf: Fix accessing syscall arguments on riscv
      selftests/bpf: Skip test_bpf_syscall_macro's syscall_arg1 on arm64 and s390
      libbpf: Allow overriding PT_REGS_PARM1{_CORE}_SYSCALL
      libbpf: Fix accessing the first syscall argument on arm64
      libbpf: Fix accessing the first syscall argument on s390

Jakub Kicinski (1):
      bpf: remove unused static inlines

Jakub Sitnicki (4):
      bpf: Make dst_port field in struct bpf_sock 16-bit wide
      selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads
      bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide
      selftests/bpf: Cover 4-byte load from remote_port in bpf_sk_lookup

Kenny Yu (4):
      bpf: Add support for bpf iterator programs to use sleepable helpers
      bpf: Add bpf_copy_from_user_task() helper
      libbpf: Add "iter.s" section for sleepable bpf iterator programs
      selftests/bpf: Add test for sleepable bpf iterator programs

Kenta Tada (4):
      selftests/bpf: Extract syscall wrapper
      libbpf: Fix the incorrect register read for syscalls on x86_64
      selftests/bpf: Add a test to confirm PT_REGS_PARM4_SYSCALL
      bpf: make bpf_copy_from_user_task() gpl only

Lorenzo Bianconi (4):
      libbpf: Deprecate xdp_cpumap, xdp_devmap and classifier sec definitions
      selftests/bpf: Update cpumap/devmap sec_name
      samples/bpf: Update cpumap/devmap sec_name
      bpf: test_run: Fix OOB access in bpf_prog_test_run_xdp

Maciej Fijalkowski (7):
      ice: Remove likely for napi_complete_done
      ice: xsk: Force rings to be sized to power of 2
      ice: xsk: Handle SW XDP ring wrap and bump tail more often
      ice: Make Tx threshold dependent on ring length
      ice: xsk: Avoid potential dead AF_XDP Tx processing
      ice: xsk: Improve AF_XDP ZC Tx and use batching API
      ice: xsk: Borrow xdp_tx_active logic from i40e

Magnus Karlsson (2):
      i40e: xsk: Move tmp desc array from driver to pool
      selftests, xsk: Fix bpf_res cleanup test

Matteo Croce (2):
      bpf: Implement bpf_core_types_are_compat().
      selftests/bpf: Test bpf_core_types_are_compat() functionality.

Mauricio Vásquez (3):
      libbpf: Remove mode check in libbpf_set_strict_mode()
      bpftool: Fix strict mode calculation
      selftests/bpf: Fix strict mode calculation

Nathan Chancellor (5):
      MAINTAINERS: Add scripts/pahole-flags.sh to BPF section
      kbuild: Add CONFIG_PAHOLE_VERSION
      scripts/pahole-flags.sh: Use pahole-version.sh
      lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
      lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+

Naveen N. Rao (2):
      selftests/bpf: Use "__se_" prefix on architectures without syscall wrapper
      selftests/bpf: Fix tests to use arch-dependent syscall entry points

Pavel Begunkov (1):
      cgroup/bpf: fast path skb BPF filtering

Song Liu (12):
      x86/Kconfig: Select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
      bpf: Use bytes instead of pages for bpf_jit_[charge|uncharge]_modmem
      bpf: Use size instead of pages in bpf_binary_header
      bpf: Use prog->jited_len in bpf_prog_ksym_set_addr()
      x86/alternative: Introduce text_poke_copy
      bpf: Introduce bpf_arch_text_copy
      bpf: Introduce bpf_prog_pack allocator
      bpf: Introduce bpf_jit_binary_pack_[alloc|finalize|free]
      bpf, x86_64: Use bpf_jit_binary_pack_alloc
      bpf, x86_64: Fail gracefully on bpf_jit_binary_pack_finalize failures
      bpf: Fix leftover header->pages in sparc and powerpc code.
      bpf: Fix bpf_prog_pack build HPAGE_PMD_SIZE

Stanislav Fomichev (3):
      bpf: fix register_btf_kfunc_id_set for !CONFIG_DEBUG_INFO_BTF
      bpf: test_run: Fix overflow in xdp frags parsing
      bpf: test_run: Fix overflow in bpf_test_finish frags parsing

Yonghong Song (11):
      selftests/bpf: Fix a clang compilation error
      selftests/bpf: fix a clang compilation error
      compiler_types: define __user as __attribute__((btf_type_tag("user")))
      bpf: reject program if a __user tagged memory accessed in kernel way
      selftests/bpf: rename btf_decl_tag.c to test_btf_decl_tag.c
      selftests/bpf: add a selftest with __user tag
      selftests/bpf: specify pahole version requirement for btf_tag test
      docs/bpf: clarify how btf_type_tag gets encoded in the type chain
      bpf: Fix a btf decl_tag bug when tagging a function
      selftests/bpf: Add a selftest for invalid func btf with btf decl_tag
      libbpf: Fix build issue with llvm-readelf

 Documentation/bpf/btf.rst                          |  13 +
 Documentation/bpf/instruction-set.rst              | 215 ++++++++---
 MAINTAINERS                                        |   2 +
 arch/arm64/net/bpf_jit_comp.c                      |   5 +
 arch/powerpc/net/bpf_jit_comp.c                    |   2 +-
 arch/sparc/net/bpf_jit_comp_64.c                   |   2 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/include/asm/text-patching.h               |   1 +
 arch/x86/kernel/alternative.c                      |  34 ++
 arch/x86/net/bpf_jit_comp.c                        |  70 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  11 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |   1 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   6 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |  10 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |  15 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           | 374 ++++++++++++------
 drivers/net/ethernet/intel/ice/ice_xsk.h           |  27 +-
 include/linux/bpf-cgroup.h                         |  24 +-
 include/linux/bpf.h                                |  40 +-
 include/linux/btf.h                                |  10 +
 include/linux/compiler_types.h                     |   3 +
 include/linux/filter.h                             |  27 +-
 include/linux/skmsg.h                              |   5 -
 include/net/xdp_sock_drv.h                         |   5 +-
 include/net/xsk_buff_pool.h                        |   1 +
 include/uapi/linux/bpf.h                           |  17 +-
 init/Kconfig                                       |   4 +
 kernel/bpf/bpf_iter.c                              |  20 +-
 kernel/bpf/btf.c                                   | 183 ++++++++-
 kernel/bpf/cgroup.c                                |  30 --
 kernel/bpf/core.c                                  | 289 ++++++++++++--
 kernel/bpf/helpers.c                               |  34 ++
 kernel/bpf/preload/Makefile                        |  28 +-
 kernel/bpf/preload/iterators/Makefile              |   6 +-
 kernel/bpf/preload/iterators/iterators.c           |  28 +-
 kernel/bpf/preload/iterators/iterators.lskel.h     | 428 +++++++++++++++++++++
 kernel/bpf/preload/iterators/iterators.skel.h      | 412 --------------------
 kernel/bpf/trampoline.c                            |   6 +-
 kernel/bpf/verifier.c                              |  36 +-
 kernel/trace/bpf_trace.c                           |   2 +
 lib/Kconfig.debug                                  |  12 +-
 net/bpf/bpf_dummy_struct_ops.c                     |   6 +-
 net/bpf/test_run.c                                 |  18 +-
 net/core/filter.c                                  |  13 +-
 net/ipv4/bpf_tcp_ca.c                              |   6 +-
 net/xdp/xsk.c                                      |  13 +-
 net/xdp/xsk_buff_pool.c                            |   7 +
 net/xdp/xsk_queue.h                                |  19 +-
 samples/bpf/map_perf_test_user.c                   |   2 +-
 samples/bpf/xdp1_user.c                            |  16 +-
 samples/bpf/xdp_adjust_tail_user.c                 |  17 +-
 samples/bpf/xdp_fwd_user.c                         |  15 +-
 samples/bpf/xdp_redirect_cpu.bpf.c                 |   8 +-
 samples/bpf/xdp_redirect_cpu_user.c                |   2 +-
 samples/bpf/xdp_redirect_map.bpf.c                 |   2 +-
 samples/bpf/xdp_redirect_map_multi.bpf.c           |   2 +-
 samples/bpf/xdp_router_ipv4_user.c                 |  17 +-
 samples/bpf/xdp_rxq_info_user.c                    |  16 +-
 samples/bpf/xdp_sample_user.c                      |   2 +-
 samples/bpf/xdp_sample_user.h                      |   2 +-
 samples/bpf/xdp_tx_iptunnel_user.c                 |  17 +-
 scripts/pahole-flags.sh                            |   2 +-
 scripts/pahole-version.sh                          |  13 +
 tools/bpf/bpftool/common.c                         |   2 +-
 tools/bpf/bpftool/feature.c                        |  29 +-
 tools/bpf/bpftool/gen.c                            |   9 +-
 tools/bpf/bpftool/main.c                           |   5 +-
 tools/bpf/bpftool/prog.c                           |  13 +-
 tools/include/uapi/linux/bpf.h                     |  17 +-
 tools/lib/bpf/Makefile                             |   4 +-
 tools/lib/bpf/bpf.h                                |   4 +-
 tools/lib/bpf/bpf_tracing.h                        | 103 ++++-
 tools/lib/bpf/btf.h                                |  12 +-
 tools/lib/bpf/btf_dump.c                           |   6 +-
 tools/lib/bpf/libbpf.c                             |  51 +--
 tools/lib/bpf/libbpf.h                             |  41 +-
 tools/lib/bpf/libbpf.map                           |   2 +
 tools/lib/bpf/libbpf_internal.h                    |   3 +
 tools/lib/bpf/libbpf_legacy.h                      |  17 +
 tools/lib/bpf/skel_internal.h                      |  70 +++-
 tools/perf/tests/llvm.c                            |   2 +-
 tools/perf/util/bpf-loader.c                       |  10 +-
 tools/testing/selftests/bpf/Makefile               |   2 +-
 tools/testing/selftests/bpf/README.rst             |   2 +
 .../testing/selftests/bpf/benchs/bench_ringbufs.c  |   2 +-
 tools/testing/selftests/bpf/benchs/bench_trigger.c |   6 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |  25 ++
 tools/testing/selftests/bpf/prog_tests/atomics.c   |  72 ++--
 .../selftests/bpf/prog_tests/attach_probe.c        |  18 +-
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |  16 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  20 +
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |  10 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |  21 +-
 tools/testing/selftests/bpf/prog_tests/btf_tag.c   | 101 ++++-
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |  40 +-
 .../selftests/bpf/prog_tests/cls_redirect.c        |  10 +-
 tools/testing/selftests/bpf/prog_tests/core_kern.c |  16 +-
 .../selftests/bpf/prog_tests/core_kern_overflow.c  |  13 +
 .../selftests/bpf/prog_tests/dummy_st_ops.c        |  27 +-
 .../selftests/bpf/prog_tests/fentry_fexit.c        |  24 +-
 .../testing/selftests/bpf/prog_tests/fentry_test.c |   7 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  34 +-
 .../selftests/bpf/prog_tests/fexit_stress.c        |  22 +-
 .../testing/selftests/bpf/prog_tests/fexit_test.c  |   7 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |  31 +-
 .../bpf/prog_tests/flow_dissector_load_bytes.c     |  24 +-
 tools/testing/selftests/bpf/prog_tests/for_each.c  |  32 +-
 .../selftests/bpf/prog_tests/get_func_args_test.c  |  12 +-
 .../selftests/bpf/prog_tests/get_func_ip_test.c    |  10 +-
 .../bpf/prog_tests/get_stackid_cannot_attach.c     |   2 +-
 .../testing/selftests/bpf/prog_tests/global_data.c |  24 +-
 .../selftests/bpf/prog_tests/global_func_args.c    |  14 +-
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |  16 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |  46 ++-
 .../selftests/bpf/prog_tests/ksyms_module.c        |  27 +-
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |  35 +-
 tools/testing/selftests/bpf/prog_tests/log_buf.c   |   2 +-
 tools/testing/selftests/bpf/prog_tests/map_lock.c  |  15 +-
 tools/testing/selftests/bpf/prog_tests/map_ptr.c   |  16 +-
 .../selftests/bpf/prog_tests/modify_return.c       |  33 +-
 .../testing/selftests/bpf/prog_tests/pkt_access.c  |  26 +-
 .../selftests/bpf/prog_tests/pkt_md_access.c       |  14 +-
 .../selftests/bpf/prog_tests/prog_run_opts.c       |  77 ++++
 .../selftests/bpf/prog_tests/prog_run_xattr.c      |  83 ----
 .../selftests/bpf/prog_tests/queue_stack_map.c     |  46 ++-
 .../selftests/bpf/prog_tests/raw_tp_test_run.c     |  64 ++-
 .../bpf/prog_tests/raw_tp_writable_test_run.c      |  16 +-
 .../selftests/bpf/prog_tests/signal_pending.c      |  23 +-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |  81 ++--
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |  16 +-
 .../testing/selftests/bpf/prog_tests/sock_fields.c |  58 ++-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |  20 +-
 tools/testing/selftests/bpf/prog_tests/spinlock.c  |  14 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |   2 +-
 tools/testing/selftests/bpf/prog_tests/syscall.c   |  10 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c | 238 ++++++------
 .../selftests/bpf/prog_tests/task_pt_regs.c        |  16 +-
 .../bpf/prog_tests/test_bpf_syscall_macro.c        |  73 ++++
 .../selftests/bpf/prog_tests/test_profiler.c       |  14 +-
 .../selftests/bpf/prog_tests/test_skb_pkt_end.c    |  15 +-
 tools/testing/selftests/bpf/prog_tests/timer.c     |   7 +-
 tools/testing/selftests/bpf/prog_tests/timer_mim.c |   7 +-
 tools/testing/selftests/bpf/prog_tests/trace_ext.c |  28 +-
 tools/testing/selftests/bpf/prog_tests/xdp.c       |  34 +-
 .../selftests/bpf/prog_tests/xdp_adjust_frags.c    |  34 +-
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     | 126 +++---
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |  29 +-
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |  14 +-
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |  12 +-
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |  10 +-
 tools/testing/selftests/bpf/prog_tests/xdp_info.c  |  14 +-
 tools/testing/selftests/bpf/prog_tests/xdp_link.c  |  26 +-
 .../selftests/bpf/prog_tests/xdp_noinline.c        |  44 ++-
 tools/testing/selftests/bpf/prog_tests/xdp_perf.c  |  19 +-
 .../selftests/bpf/progs/bloom_filter_bench.c       |   7 +-
 .../testing/selftests/bpf/progs/bloom_filter_map.c |   5 +-
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |  54 +++
 tools/testing/selftests/bpf/progs/bpf_loop.c       |   9 +-
 tools/testing/selftests/bpf/progs/bpf_loop_bench.c |   3 +-
 tools/testing/selftests/bpf/progs/bpf_misc.h       |  19 +
 .../selftests/bpf/progs/bpf_syscall_macro.c        |  84 ++++
 .../selftests/bpf/progs/btf_type_tag_user.c        |  40 ++
 tools/testing/selftests/bpf/progs/core_kern.c      |  16 +
 .../selftests/bpf/progs/core_kern_overflow.c       |  22 ++
 tools/testing/selftests/bpf/progs/fexit_sleep.c    |   9 +-
 tools/testing/selftests/bpf/progs/perfbuf_bench.c  |   3 +-
 tools/testing/selftests/bpf/progs/ringbuf_bench.c  |   3 +-
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |   3 +-
 .../progs/{btf_decl_tag.c => test_btf_decl_tag.c}  |   0
 .../testing/selftests/bpf/progs/test_probe_user.c  |  15 +-
 tools/testing/selftests/bpf/progs/test_ringbuf.c   |   3 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |   6 +
 .../testing/selftests/bpf/progs/test_sock_fields.c |  41 ++
 .../bpf/progs/test_xdp_with_cpumap_frags_helpers.c |   2 +-
 .../bpf/progs/test_xdp_with_cpumap_helpers.c       |   2 +-
 .../bpf/progs/test_xdp_with_devmap_frags_helpers.c |   2 +-
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |   2 +-
 tools/testing/selftests/bpf/progs/trace_printk.c   |   3 +-
 tools/testing/selftests/bpf/progs/trace_vprintk.c  |   3 +-
 tools/testing/selftests/bpf/progs/trigger_bench.c  |   9 +-
 .../selftests/bpf/progs/xdp_redirect_multi_kern.c  |   2 +-
 tools/testing/selftests/bpf/test_lru_map.c         |  11 +-
 tools/testing/selftests/bpf/test_lwt_seg6local.sh  | 170 ++++----
 tools/testing/selftests/bpf/test_maps.c            |   2 +-
 .../selftests/bpf/test_tcp_check_syncookie.sh      |   5 +-
 tools/testing/selftests/bpf/test_verifier.c        |  20 +-
 tools/testing/selftests/bpf/test_xdp_meta.sh       |  38 +-
 tools/testing/selftests/bpf/test_xdp_redirect.sh   |  30 +-
 .../selftests/bpf/test_xdp_redirect_multi.sh       |  60 +--
 tools/testing/selftests/bpf/test_xdp_veth.sh       |  39 +-
 tools/testing/selftests/bpf/test_xdp_vlan.sh       |  66 ++--
 tools/testing/selftests/bpf/trace_helpers.c        |  70 ++--
 tools/testing/selftests/bpf/trace_helpers.h        |   3 +-
 tools/testing/selftests/bpf/verifier/sock.c        |  81 +++-
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |   8 +-
 tools/testing/selftests/bpf/xdping.c               |   4 +-
 tools/testing/selftests/bpf/xdpxceiver.c           |  80 ++--
 tools/testing/selftests/bpf/xdpxceiver.h           |   2 +-
 201 files changed, 4049 insertions(+), 2215 deletions(-)
 create mode 100644 kernel/bpf/preload/iterators/iterators.lskel.h
 delete mode 100644 kernel/bpf/preload/iterators/iterators.skel.h
 create mode 100755 scripts/pahole-version.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_kern_overflow.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/prog_run_opts.c
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_bpf_syscall_macro.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_misc.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_syscall_macro.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_type_tag_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/core_kern_overflow.c
 rename tools/testing/selftests/bpf/progs/{btf_decl_tag.c => test_btf_decl_tag.c} (100%)

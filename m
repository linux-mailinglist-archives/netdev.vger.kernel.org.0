Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADF9615C31
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 07:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiKBGWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 02:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiKBGWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 02:22:17 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C291125C7B;
        Tue,  1 Nov 2022 23:22:13 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1oq77o-000Fva-Bh; Wed, 02 Nov 2022 07:21:20 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-11-02
Date:   Wed,  2 Nov 2022 07:21:20 +0100
Message-Id: <20221102062120.5724-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26297/Thu Sep 16 15:59:37 2021)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 70 non-merge commits during the last 14 day(s) which contain
a total of 96 files changed, 3203 insertions(+), 640 deletions(-).

The main changes are:

1) Make cgroup local storage available to non-cgroup attached BPF programs such
   as tc BPF ones, from Yonghong Song.

2) Avoid unnecessary deadlock detection and failures wrt BPF task storage helpers,
   from Martin KaFai Lau.

3) Add LLVM disassembler as default library for dumping JITed code in bpftool,
   from Quentin Monnet.

4) Various kprobe_multi_link fixes related to kernel modules, from Jiri Olsa.

5) Optimize x86-64 JIT with emitting BMI2-based shift instructions, from Jie Meng.

6) Improve BPF verifier's memory type compatibility for map key/value arguments,
   from Dave Marchevsky.

7) Only create mmap-able data section maps in libbpf when data is exposed via
   skeletons, from Andrii Nakryiko.

8) Add an autoattach option for bpftool to load all object assets, from Wang Yufen.

9) Various memory handling fixes for libbpf and BPF selftests, from Xu Kuohai.

10) Initial support for BPF selftest's vmtest.sh on arm64, from Manu Bretelle.

11) Improve libbpf's BTF handling to dedup identical structs, from Alan Maguire.

12) Add BPF CI and denylist documentation for BPF selftests, from Daniel Müller.

13) Check BPF cpumap max_entries before doing allocation work, from Florian Lehner.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Andy Gospodarek, Dave Marchevsky, David Vernet, 
Martynas Pumputis, Niklas Söderlund, Peter Zijlstra (Intel), Quentin 
Monnet, Song Liu, Stanislav Fomichev, Yonghong Song

----------------------------------------------------------------

The following changes since commit a526a3cc9c8d426713f8bebc18ebbe39a8495d82:

  net: ethernet: adi: adin1110: Fix SPI transfers (2022-10-19 14:20:37 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 3a07dcf8f57b9a90b1c07df3e9091fd04baa3036:

  samples/bpf: Fix typo in README (2022-11-01 15:25:21 +0100)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alan Maguire (1):
      libbpf: Btf dedup identical struct test needs check for nested structs/arrays

Alexei Starovoitov (7):
      Merge branch 'libbpf: support non-mmap()'able data sections'
      Merge branch 'bpf,x64: Use BMI2 for shifts'
      Merge branch 'bpftool: Add autoattach for bpf prog load|loadall'
      Merge branch 'bpftool: Add LLVM as default library for disassembling JIT-ed programs'
      Merge branch 'bpf: Fixes for kprobe multi on kernel modules'
      Merge branch 'bpf: Avoid unnecessary deadlock detection and failure in task storage'
      Merge branch 'bpf: Implement cgroup local storage available to non-cgroup-attached bpf progs'

Andrii Nakryiko (4):
      libbpf: clean up and refactor BTF fixup step
      libbpf: only add BPF_F_MMAPABLE flag for data maps with global vars
      libbpf: add non-mmapable data section selftest
      Merge branch 'Add support for aarch64 to selftests/bpf/vmtest.sh'

Colin Ian King (1):
      bpftool: Fix spelling mistake "disasembler" -> "disassembler"

Daniel Müller (3):
      samples/bpf: Fix typos in README
      bpf/docs: Summarize CI system and deny lists
      selftests/bpf: Panic on hard/soft lockup

Dave Marchevsky (4):
      bpf: Allow ringbuf memory to be used as map key
      bpf: Consider all mem_types compatible for map_{key,value} args
      selftests/bpf: Add test verifying bpf_ringbuf_reserve retval use in map ops
      selftests/bpf: Add write to hashmap to array_map iter test

Delyan Kratunov (1):
      selftests/bpf: fix task_local_storage/exit_creds rcu usage

Donald Hunter (1):
      bpf, docs: Reformat BPF maps page to be more readable

Florian Lehner (1):
      bpf: check max_entries before allocating memory

Gerhard Engleder (2):
      samples/bpf: Fix map iteration in xdp1_user
      samples/bpf: Fix MAC address swapping in xdp2_kern

Jie Meng (3):
      bpf,x64: avoid unnecessary instructions when shift dest is ecx
      bpf,x64: use shrx/sarx/shlx when available
      bpf: add selftests for lsh, rsh, arsh with reg operand

Jiri Olsa (8):
      kallsyms: Make module_kallsyms_on_each_symbol generally available
      ftrace: Add support to resolve module symbols in ftrace_lookup_symbols
      bpf: Rename __bpf_kprobe_multi_cookie_cmp to bpf_kprobe_multi_addrs_cmp
      bpf: Take module reference on kprobe_multi link
      selftests/bpf: Add load_kallsyms_refresh function
      selftests/bpf: Add bpf_testmod_fentry_* functions
      selftests/bpf: Add kprobe_multi check to module attach test
      selftests/bpf: Add kprobe_multi kmod attach api tests

Kang Minchul (1):
      samples/bpf: Fix typo in README

Manu Bretelle (4):
      selftests/bpf: Remove entries from config.s390x already present in config
      selftests/bpf: Add config.aarch64
      selftests/bpf: Update vmtests.sh to support aarch64
      selftests/bpf: Initial DENYLIST for aarch64

Martin KaFai Lau (9):
      bpf: Remove prog->active check for bpf_lsm and bpf_iter
      bpf: Append _recur naming to the bpf_task_storage helper proto
      bpf: Refactor the core bpf_task_storage_get logic into a new function
      bpf: Avoid taking spinlock in bpf_task_storage_get if potential deadlock is detected
      bpf: Add new bpf_task_storage_get proto with no deadlock detection
      bpf: bpf_task_storage_delete_recur does lookup first before the deadlock check
      bpf: Add new bpf_task_storage_delete proto with no deadlock detection
      selftests/bpf: Ensure no task storage failure for bpf_lsm.s prog due to deadlock detection
      selftests/bpf: Tracing prog can still do lookup under busy lock

Quentin Monnet (10):
      bpftool: Set binary name to "bpftool" in help and version output
      bpftool: Add "bootstrap" feature to version output
      bpftool: Define _GNU_SOURCE only once
      bpftool: Remove asserts from JIT disassembler
      bpftool: Split FEATURE_TESTS/FEATURE_DISPLAY definitions in Makefile
      bpftool: Group libbfd defs in Makefile, only pass them if we use libbfd
      bpftool: Refactor disassembler for JIT-ed programs
      bpftool: Add LLVM as default library for disassembling JIT-ed programs
      bpftool: Support setting alternative arch for JIT disasm with LLVM
      bpftool: Add llvm feature to "bpftool version"

Shaomin Deng (1):
      samples/bpf: Fix double word in comments

Thomas Gleixner (1):
      bpf: Remove the obsolte u64_stats_fetch_*_irq() users.

Wang Yufen (4):
      selftests/bpf: fix missing BPF object files
      bpftool: Add autoattach for bpf prog load|loadall
      bpftool: Update doc (add autoattach to prog load)
      bpftool: Update the bash completion(add autoattach to prog load)

Xu Kuohai (2):
      libbpf: Avoid allocating reg_name with sscanf in parse_usdt_arg()
      bpf: Fix a typo in comment for DFS algorithm

Yonghong Song (10):
      bpf: Make struct cgroup btf id global
      bpf: Refactor some inode/task/sk storage functions for reuse
      bpf: Implement cgroup storage available to non-cgroup-attached bpf progs
      libbpf: Support new cgroup local storage
      bpftool: Support new cgroup local storage
      selftests/bpf: Fix test test_libbpf_str/bpf_map_type_str
      selftests/bpf: Add selftests for new cgroup local storage
      selftests/bpf: Add test cgrp_local_storage to DENYLIST.s390x
      docs/bpf: Add documentation for new cgroup local storage
      selftests/bpf: Fix bpftool synctypes checking failure

 Documentation/bpf/map_cgrp_storage.rst             | 109 +++++++++
 Documentation/bpf/maps.rst                         | 101 +++++---
 arch/arm64/net/bpf_jit_comp.c                      |   9 +-
 arch/x86/net/bpf_jit_comp.c                        | 125 +++++++---
 include/linux/bpf.h                                |  33 +--
 include/linux/bpf_local_storage.h                  |  17 +-
 include/linux/bpf_types.h                          |   1 +
 include/linux/bpf_verifier.h                       |  15 +-
 include/linux/btf_ids.h                            |   1 +
 include/linux/cgroup-defs.h                        |   4 +
 include/linux/module.h                             |   9 +
 include/uapi/linux/bpf.h                           |  50 +++-
 kernel/bpf/Makefile                                |   2 +-
 kernel/bpf/bpf_cgrp_storage.c                      | 247 +++++++++++++++++++
 kernel/bpf/bpf_inode_storage.c                     |  38 +--
 kernel/bpf/bpf_local_storage.c                     | 191 +++++++++------
 kernel/bpf/bpf_task_storage.c                      | 157 ++++++++-----
 kernel/bpf/cgroup_iter.c                           |   2 +-
 kernel/bpf/cpumap.c                                |  20 +-
 kernel/bpf/helpers.c                               |   6 +
 kernel/bpf/syscall.c                               |  12 +-
 kernel/bpf/trampoline.c                            |  80 ++++++-
 kernel/bpf/verifier.c                              |  29 +--
 kernel/cgroup/cgroup.c                             |   1 +
 kernel/module/kallsyms.c                           |   2 -
 kernel/trace/bpf_trace.c                           | 107 ++++++++-
 kernel/trace/ftrace.c                              |  16 +-
 net/core/bpf_sk_storage.c                          |  35 +--
 samples/bpf/README.rst                             |   6 +-
 samples/bpf/hbm_edt_kern.c                         |   2 +-
 samples/bpf/xdp1_user.c                            |   2 +-
 samples/bpf/xdp2_kern.c                            |   4 +
 scripts/bpf_doc.py                                 |   2 +
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |  15 +-
 tools/bpf/bpftool/Documentation/common_options.rst |   8 +-
 tools/bpf/bpftool/Makefile                         |  74 ++++--
 tools/bpf/bpftool/bash-completion/bpftool          |   1 +
 tools/bpf/bpftool/common.c                         |  12 +-
 tools/bpf/bpftool/iter.c                           |   2 +
 tools/bpf/bpftool/jit_disasm.c                     | 261 +++++++++++++++++----
 tools/bpf/bpftool/main.c                           |  90 ++++---
 tools/bpf/bpftool/main.h                           |  32 +--
 tools/bpf/bpftool/map.c                            |   3 +-
 tools/bpf/bpftool/net.c                            |   2 +
 tools/bpf/bpftool/perf.c                           |   2 +
 tools/bpf/bpftool/prog.c                           |  99 +++++++-
 tools/bpf/bpftool/xlated_dumper.c                  |   2 +
 tools/include/uapi/linux/bpf.h                     |  50 +++-
 tools/lib/bpf/btf.c                                |   8 +-
 tools/lib/bpf/libbpf.c                             | 178 +++++++++-----
 tools/lib/bpf/libbpf_probes.c                      |   1 +
 tools/lib/bpf/usdt.c                               |  16 +-
 tools/testing/selftests/bpf/DENYLIST.aarch64       |  81 +++++++
 tools/testing/selftests/bpf/DENYLIST.s390x         |   1 +
 tools/testing/selftests/bpf/Makefile               |   8 +-
 tools/testing/selftests/bpf/README.rst             |  42 +++-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |  24 ++
 tools/testing/selftests/bpf/config                 |   2 +
 tools/testing/selftests/bpf/config.aarch64         | 181 ++++++++++++++
 tools/testing/selftests/bpf/config.s390x           |   3 -
 tools/testing/selftests/bpf/config.x86_64          |   1 -
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  20 +-
 .../selftests/bpf/prog_tests/cgrp_local_storage.c  | 171 ++++++++++++++
 .../bpf/prog_tests/kprobe_multi_testmod_test.c     |  89 +++++++
 .../testing/selftests/bpf/prog_tests/libbpf_str.c  |   8 +
 .../selftests/bpf/prog_tests/module_attach.c       |   7 +
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |  66 +++++-
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |  11 +-
 .../selftests/bpf/prog_tests/task_local_storage.c  | 164 ++++++++++++-
 .../selftests/bpf/progs/bpf_iter_bpf_array_map.c   |  21 +-
 .../selftests/bpf/progs/cgrp_ls_attach_cgroup.c    | 101 ++++++++
 .../testing/selftests/bpf/progs/cgrp_ls_negative.c |  26 ++
 .../selftests/bpf/progs/cgrp_ls_recursion.c        |  70 ++++++
 tools/testing/selftests/bpf/progs/cgrp_ls_tp_btf.c |  88 +++++++
 tools/testing/selftests/bpf/progs/kprobe_multi.c   |  50 ++++
 .../bpf/progs/task_local_storage_exit_creds.c      |   3 +
 .../selftests/bpf/progs/task_ls_recursion.c        |  43 +++-
 .../selftests/bpf/progs/task_storage_nodeadlock.c  |  47 ++++
 .../selftests/bpf/progs/test_module_attach.c       |   6 +
 .../selftests/bpf/progs/test_ringbuf_map_key.c     |  70 ++++++
 tools/testing/selftests/bpf/progs/test_skeleton.c  |  17 ++
 .../testing/selftests/bpf/test_bpftool_metadata.sh |   7 +-
 .../selftests/bpf/test_bpftool_synctypes.py        |   8 +
 tools/testing/selftests/bpf/test_flow_dissector.sh |   6 +-
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh   |  17 +-
 tools/testing/selftests/bpf/test_lwt_seg6local.sh  |   9 +-
 tools/testing/selftests/bpf/test_tc_edt.sh         |   3 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |   5 +-
 tools/testing/selftests/bpf/test_tunnel.sh         |   5 +-
 tools/testing/selftests/bpf/test_xdp_meta.sh       |   9 +-
 tools/testing/selftests/bpf/test_xdp_vlan.sh       |   8 +-
 tools/testing/selftests/bpf/trace_helpers.c        |  20 +-
 tools/testing/selftests/bpf/trace_helpers.h        |   2 +
 tools/testing/selftests/bpf/verifier/jit.c         |  24 ++
 tools/testing/selftests/bpf/vmtest.sh              |   6 +
 96 files changed, 3203 insertions(+), 640 deletions(-)
 create mode 100644 Documentation/bpf/map_cgrp_storage.rst
 create mode 100644 kernel/bpf/bpf_cgrp_storage.c
 create mode 100644 tools/testing/selftests/bpf/DENYLIST.aarch64
 create mode 100644 tools/testing/selftests/bpf/config.aarch64
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgrp_local_storage.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_testmod_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_ls_attach_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_ls_negative.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_ls_recursion.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_ls_tp_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_storage_nodeadlock.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ringbuf_map_key.c

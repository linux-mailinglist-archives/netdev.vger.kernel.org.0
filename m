Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3880057E98B
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 00:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbiGVWMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 18:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiGVWMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 18:12:23 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D4DAF705;
        Fri, 22 Jul 2022 15:12:22 -0700 (PDT)
Received: from [2a01:118f:505:3400:57f9:d43a:5622:24a8] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oF0sd-000G1A-Fm; Sat, 23 Jul 2022 00:12:19 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-07-22
Date:   Sat, 23 Jul 2022 00:12:18 +0200
Message-Id: <20220722221218.29943-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26609/Fri Jul 22 09:56:47 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 73 non-merge commits during the last 12 day(s) which contain
a total of 88 files changed, 3458 insertions(+), 860 deletions(-).

The main changes are:

1) Implement BPF trampoline for arm64 JIT, from Xu Kuohai.

2) Add ksyscall/kretsyscall section support to libbpf to simplify tracing kernel
   syscalls through kprobe mechanism, from Andrii Nakryiko.

3) Allow for livepatch (KLP) and BPF trampolines to attach to the same kernel
   function, from Song Liu & Jiri Olsa.

4) Add new kfunc infrastructure for netfilter's CT e.g. to insert and change
   entries, from Kumar Kartikeya Dwivedi & Lorenzo Bianconi.

5) Add a ksym BPF iterator to allow for more flexible and efficient interactions
   with kernel symbols, from Alan Maguire.

6) Bug fixes in libbpf e.g. for uprobe binary path resolution, from Dan Carpenter.

7) Fix BPF subprog function names in stack traces, from Alexei Starovoitov.

8) libbpf support for writing custom perf event readers, from Jon Doron.

9) Switch to use SPDX tag for BPF helper man page, from Alejandro Colomar.

10) Fix xsk send-only sockets when in busy poll mode, from Maciej Fijalkowski.

11) Reparent BPF maps and their charging on memcg offlining, from Roman Gushchin.

12) Multiple follow-up fixes around BPF lsm cgroup infra, from Stanislav Fomichev.

13) Use bootstrap version of bpftool where possible to speed up builds, from Pu Lehui.

14) Cleanup BPF verifier's check_func_arg() handling, from Joanne Koong.

15) Make non-prealloced BPF map allocations low priority to play better with
    memcg limits, from Yafang Shao.

16) Fix BPF test runner to reject zero-length data for skbs, from Zhengchao Shao.

17) Various smaller cleanups and improvements all over the place.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Alexei Starovoitov, Andrii Nakryiko, Hao Luo, Jakub 
Sitnicki, Jean-Philippe Brucker, Jiri Olsa, John Fastabend, Jon Hunter, 
kernel test robot, KP Singh, Magnus Karlsson, Martin KaFai Lau, Quentin 
Monnet, Shakeel Butt, Song Liu, Stanislav Fomichev, Stephen Rothwell, 
Steven Rostedt (Google), Tejun Heo, Will Deacon, Yonghong Song

----------------------------------------------------------------

The following changes since commit edb2c3476db9898a63fb5d0011ecaa43ebf46c9b:

  fddi/skfp: fix repeated words in comments (2022-07-11 14:12:54 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to ea2babac63d40e59926dc5de4550dac94cc3c6d2:

  bpf: Simplify bpf_prog_pack_[size|mask] (2022-07-22 22:08:27 +0200)

----------------------------------------------------------------
Alan Maguire (2):
      bpf: add a ksym BPF iterator
      selftests/bpf: add a ksym iter subtest

Alejandro Colomar (1):
      bpf, docs: Use SPDX license identifier in bpf_doc.py

Alexei Starovoitov (5):
      Merge branch 'bpf: add a ksym BPF iterator'
      bpf: Fix subprog names in stack traces.
      Merge branch 'Add SEC("ksyscall") support'
      Merge branch 'BPF array map fixes and improvements'
      Merge branch 'New nf_conntrack kfuncs for insertion, changing timeout, status'

Andrii Nakryiko (13):
      Merge branch 'Use lightweigt version of bpftool'
      libbpf: generalize virtual __kconfig externs and use it for USDT
      selftests/bpf: add test of __weak unknown virtual __kconfig extern
      libbpf: improve BPF_KPROBE_SYSCALL macro and rename it to BPF_KSYSCALL
      libbpf: add ksyscall/kretsyscall sections support for syscall kprobes
      selftests/bpf: use BPF_KSYSCALL and SEC("ksyscall") in selftests
      bpf: fix potential 32-bit overflow when accessing ARRAY map element
      bpf: make uniform use of array->elem_size everywhere in arraymap.c
      bpf: remove obsolete KMALLOC_MAX_SIZE restriction on array map value size
      selftests/bpf: validate .bss section bigger than 8MB is possible now
      libbpf: fallback to tracefs mount point if debugfs is not mounted
      libbpf: make RINGBUF map size adjustments more eagerly
      selftests/bpf: test eager BPF ringbuf size adjustment logic

Anquan Wu (1):
      libbpf: Fix the name of a reused map

Ben Dooks (2):
      bpf: Add endian modifiers to fix endian warnings
      bpf: Fix check against plain integer v 'NULL'

Dan Carpenter (4):
      selftests/bpf: fix a test for snprintf() overflow
      libbpf: fix an snprintf() overflow check
      libbpf: Fix sign expansion bug in btf_dump_get_enum_value()
      libbpf: Fix str_has_sfx()'s return value

Donald Hunter (1):
      bpf, docs: document BPF_MAP_TYPE_HASH and variants

Hengqi Chen (1):
      libbpf: Error out when binary_path is NULL for uprobe and USDT

Indu Bhagat (1):
      docs/bpf: Update documentation for BTF_KIND_FUNC

Jesper Dangaard Brouer (1):
      samples/bpf: Fix xdp_redirect_map egress devmap prog

Jie2x Zhou (1):
      bpf/selftests: Fix couldn't retrieve pinned program in xdp veth test

Jiri Olsa (2):
      selftests/bpf: Do not attach kprobe_multi bench to bpf_dispatcher_xdp_func
      bpf, x64: Allow to use caller address from stack

Joanne Koong (2):
      bpf: Tidy up verifier check_func_arg()
      bpf: fix bpf_skb_pull_data documentation

Jon Doron (1):
      libbpf: perfbuf: Add API to get the ring buffer

Kumar Kartikeya Dwivedi (11):
      bpf: Introduce 8-byte BTF set
      tools/resolve_btfids: Add support for 8-byte BTF sets
      bpf: Switch to new kfunc flags infrastructure
      bpf: Add support for forcing kfunc args to be trusted
      bpf: Add documentation for kfuncs
      net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup
      net: netfilter: Add kfuncs to set and change CT timeout
      selftests/bpf: Add verifier tests for trusted kfunc args
      selftests/bpf: Add negative tests for new nf_conntrack kfuncs
      selftests/bpf: Fix test_verifier failed test in unprivileged mode
      bpf: Fix build error in case of !CONFIG_DEBUG_INFO_BTF

Linkui Xiao (2):
      samples: bpf: Replace sizeof(arr)/sizeof(arr[0]) with ARRAY_SIZE
      selftests/bpf: Return true/false (not 1/0) from bool functions

Liu Jian (1):
      skmsg: Fix invalid last sg check in sk_msg_recvmsg()

Lorenzo Bianconi (3):
      net: netfilter: Add kfuncs to allocate and insert CT
      net: netfilter: Add kfuncs to set and change CT status
      selftests/bpf: Add tests for new nf_conntrack kfuncs

Maciej Fijalkowski (1):
      xsk: Mark napi_id on sendmsg()

Matthieu Baerts (1):
      bpf: Fix 'dubious one-bit signed bitfield' warnings

Nathan Chancellor (1):
      bpf, arm64: Mark dummy_tramp as global

Pu Lehui (3):
      samples: bpf: Fix cross-compiling error by using bootstrap bpftool
      tools: runqslower: Build and use lightweight bootstrap version of bpftool
      bpf: iterators: Build and use lightweight bootstrap version of bpftool

Roman Gushchin (1):
      bpf: reparent bpf maps on memcg offlining

Song Liu (5):
      bpf, x86: fix freeing of not-finalized bpf_prog_pack
      ftrace: Add modify_ftrace_direct_multi_nolock
      ftrace: Allow IPMODIFY and DIRECT ops on the same function
      bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)
      bpf: Simplify bpf_prog_pack_[size|mask]

Stanislav Fomichev (3):
      bpf: fix lsm_cgroup build errors on esoteric configs
      bpf: Fix bpf_trampoline_{,un}link_cgroup_shim ifdef guards
      bpf: Check attach_func_proto more carefully in check_helper_call

Xu Kuohai (5):
      bpf: Remove is_valid_bpf_tramp_flags()
      arm64: Add LDR (literal) instruction
      bpf, arm64: Implement bpf_arch_text_poke() for arm64
      bpf, arm64: Add bpf trampoline for arm64
      bpf, arm64: Fix compile error in dummy_tramp()

Yafang Shao (2):
      bpf: Make non-preallocated allocation low priority
      bpf: Warn on non-preallocated case for BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE

Zhengchao Shao (1):
      bpf: Don't redirect packets with invalid pkt_len

 Documentation/bpf/btf.rst                          |   6 +-
 Documentation/bpf/index.rst                        |   1 +
 Documentation/bpf/kfuncs.rst                       | 170 +++++
 Documentation/bpf/map_hash.rst                     | 185 ++++++
 arch/arm64/include/asm/insn.h                      |   3 +
 arch/arm64/lib/insn.c                              |  30 +-
 arch/arm64/net/bpf_jit.h                           |   7 +
 arch/arm64/net/bpf_jit_comp.c                      | 715 ++++++++++++++++++++-
 arch/x86/net/bpf_jit_comp.c                        |  58 +-
 include/linux/bpf.h                                |  29 +-
 include/linux/bpf_verifier.h                       |   8 +-
 include/linux/btf.h                                |  65 +-
 include/linux/btf_ids.h                            |  68 +-
 include/linux/filter.h                             |   8 +
 include/linux/ftrace.h                             |  43 ++
 include/linux/skbuff.h                             |   8 +
 include/net/netfilter/nf_conntrack_core.h          |  19 +
 include/net/xdp_sock_drv.h                         |  14 +
 include/uapi/linux/bpf.h                           |   3 +-
 kernel/bpf/arraymap.c                              |  40 +-
 kernel/bpf/bpf_lsm.c                               |   8 +-
 kernel/bpf/bpf_struct_ops.c                        |   3 +
 kernel/bpf/btf.c                                   | 126 ++--
 kernel/bpf/core.c                                  | 100 +--
 kernel/bpf/devmap.c                                |   2 +-
 kernel/bpf/hashtab.c                               |   6 +-
 kernel/bpf/local_storage.c                         |   2 +-
 kernel/bpf/lpm_trie.c                              |   2 +-
 kernel/bpf/preload/iterators/Makefile              |  10 +-
 kernel/bpf/syscall.c                               |  36 +-
 kernel/bpf/trampoline.c                            | 163 ++++-
 kernel/bpf/verifier.c                              |  89 +--
 kernel/kallsyms.c                                  |  91 +++
 kernel/trace/ftrace.c                              | 328 ++++++++--
 net/bpf/test_run.c                                 |  78 +--
 net/core/dev.c                                     |   1 +
 net/core/filter.c                                  |   4 +-
 net/core/skmsg.c                                   |   4 +-
 net/ipv4/bpf_tcp_ca.c                              |  18 +-
 net/ipv4/tcp_bbr.c                                 |  24 +-
 net/ipv4/tcp_cubic.c                               |  20 +-
 net/ipv4/tcp_dctcp.c                               |  20 +-
 net/netfilter/nf_conntrack_bpf.c                   | 365 ++++++++---
 net/netfilter/nf_conntrack_core.c                  |  62 ++
 net/netfilter/nf_conntrack_netlink.c               |  54 +-
 net/xdp/xsk.c                                      |   5 +-
 samples/bpf/Makefile                               |  10 +-
 samples/bpf/fds_example.c                          |   3 +-
 samples/bpf/sock_example.c                         |   3 +-
 samples/bpf/test_cgrp2_attach.c                    |   3 +-
 samples/bpf/test_lru_dist.c                        |   2 +-
 samples/bpf/test_map_in_map_user.c                 |   4 +-
 samples/bpf/tracex5_user.c                         |   3 +-
 samples/bpf/xdp_redirect_map.bpf.c                 |   6 +-
 samples/bpf/xdp_redirect_map_user.c                |   9 +
 scripts/bpf_doc.py                                 |  22 +-
 tools/bpf/resolve_btfids/main.c                    |  40 +-
 tools/bpf/runqslower/Makefile                      |   7 +-
 tools/include/uapi/linux/bpf.h                     |   3 +-
 tools/lib/bpf/bpf_tracing.h                        |  51 +-
 tools/lib/bpf/btf_dump.c                           |   2 +-
 tools/lib/bpf/gen_loader.c                         |   2 +-
 tools/lib/bpf/libbpf.c                             | 390 ++++++++---
 tools/lib/bpf/libbpf.h                             |  62 ++
 tools/lib/bpf/libbpf.map                           |   2 +
 tools/lib/bpf/libbpf_internal.h                    |   8 +-
 tools/lib/bpf/usdt.bpf.h                           |  16 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |  10 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  16 +
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |  64 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   2 +-
 .../testing/selftests/bpf/prog_tests/core_extern.c |  17 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |   2 +
 .../selftests/bpf/prog_tests/ringbuf_multi.c       |  11 +
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |   2 +
 tools/testing/selftests/bpf/progs/bpf_iter.h       |   7 +
 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c  |  74 +++
 .../selftests/bpf/progs/bpf_syscall_macro.c        |   6 +-
 .../selftests/bpf/progs/test_attach_probe.c        |  15 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |  85 ++-
 .../testing/selftests/bpf/progs/test_bpf_nf_fail.c | 134 ++++
 .../testing/selftests/bpf/progs/test_core_extern.c |   3 +
 .../testing/selftests/bpf/progs/test_probe_user.c  |  27 +-
 tools/testing/selftests/bpf/progs/test_skeleton.c  |   4 +
 .../selftests/bpf/progs/test_xdp_noinline.c        |  30 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh       |   6 +-
 .../selftests/bpf/verifier/bpf_loop_inline.c       |   1 +
 tools/testing/selftests/bpf/verifier/calls.c       |  53 ++
 88 files changed, 3458 insertions(+), 860 deletions(-)
 create mode 100644 Documentation/bpf/kfuncs.rst
 create mode 100644 Documentation/bpf/map_hash.rst
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c

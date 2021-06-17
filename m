Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B7F3AB4DC
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 15:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhFQNiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 09:38:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:46862 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbhFQNiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 09:38:00 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltsBR-000CN5-QE; Thu, 17 Jun 2021 15:35:50 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2021-06-17
Date:   Thu, 17 Jun 2021 15:35:49 +0200
Message-Id: <20210617133549.26128-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26204/Thu Jun 17 13:19:00 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 50 non-merge commits during the last 25 day(s) which contain
a total of 148 files changed, 4779 insertions(+), 1248 deletions(-).

The main changes are:

1) BPF infrastructure to migrate TCP child sockets from a listener to another
   in the same reuseport group/map, from Kuniyuki Iwashima.

2) Add a provably sound, faster and more precise algorithm for tnum_mul() as
   noted in https://arxiv.org/abs/2105.05398, from Harishankar Vishwanathan.

3) Streamline error reporting changes in libbpf as planned out in the
   'libbpf: the road to v1.0' effort, from Andrii Nakryiko.

4) Add broadcast support to xdp_redirect_map(), from Hangbin Liu.

5) Extends bpf_map_lookup_and_delete_elem() functionality to 4 more map
   types, that is, {LRU_,PERCPU_,LRU_PERCPU_,}HASH, from Denis Salopek.

6) Support new LLVM relocations in libbpf to make them more linker friendly,
   also add a doc to describe the BPF backend relocations, from Yonghong Song.

7) Silence long standing KUBSAN complaints on register-based shifts in
   interpreter, from Daniel Borkmann and Eric Biggers.

8) Add dummy PT_REGS macros in libbpf to fail BPF program compilation when
   target arch cannot be determined, from Lorenz Bauer.

9) Extend AF_XDP to support large umems with 1M+ pages, from Magnus Karlsson.

10) Fix two minor libbpf tc BPF API issues, from Kumar Kartikeya Dwivedi.

11) Move libbpf BPF_SEQ_PRINTF/BPF_SNPRINTF macros that can be used by BPF
    programs to bpf_helpers.h header, from Florent Revest.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Benjamin Herrenschmidt, Björn 
Töpel, Colin Ian King, Dan Siemon, Edward Cree, Eric Dumazet, Hulk 
Robot, Jesper Dangaard Brouer, John Fastabend, Kuniyuki Iwashima, Kurt 
Manucredo, Martin KaFai Lau, Quentin Monnet, Randy Dunlap, Toke 
Høiland-Jørgensen, Yonghong Song

----------------------------------------------------------------

The following changes since commit ec7d6dd870d421a853ffa692d4bce5783a519342:

  ethernet: ucc_geth: Use kmemdup() rather than kmalloc+memcpy (2021-05-23 18:51:42 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to f20792d425d2efd2680f2855c1e3fec01c2e569e:

  selftests/bpf: Fix selftests build with old system-wide headers (2021-06-17 13:05:10 +0200)

----------------------------------------------------------------
Aditya Srivastava (1):
      samples: bpf: Ix kernel-doc syntax in file header

Alexei Starovoitov (1):
      Merge branch 'libbpf: error reporting changes for v1.0'

Andrii Nakryiko (11):
      Merge branch 'Add lookup_and_delete_elem support to BPF hash map types'
      libbpf: Add libbpf_set_strict_mode() API to turn on libbpf 1.0 behaviors
      selftests/bpf: Turn on libbpf 1.0 mode and fix all IS_ERR checks
      libbpf: Streamline error reporting for low-level APIs
      libbpf: Streamline error reporting for high-level APIs
      bpftool: Set errno on skeleton failures and propagate errors
      libbpf: Move few APIs from 0.4 to 0.5 version
      libbpf: Refactor header installation portions of Makefile
      libbpf: Install skel_internal.h header used from light skeletons
      selftests/bpf: Add xdp_redirect_multi into .gitignore
      selftests/bpf: Fix selftests build with old system-wide headers

Daniel Borkmann (3):
      Merge branch 'bpf-xdp-bcast'
      Merge branch 'bpf-sock-migration'
      bpf: Fix up register-based shifts in interpreter to silence KUBSAN

Daniel Xu (1):
      selftests/bpf: Whitelist test_progs.h from .gitignore

Denis Salopek (3):
      bpf: Add lookup_and_delete_elem support to hashtab
      bpf: Extend libbpf with bpf_map_lookup_and_delete_elem_flags
      selftests/bpf: Add bpf_lookup_and_delete_elem tests

Florent Revest (1):
      libbpf: Move BPF_SEQ_PRINTF and BPF_SNPRINTF to bpf_helpers.h

Hangbin Liu (4):
      xdp: Extend xdp_redirect_map with broadcast support
      sample/bpf: Add xdp_redirect_map_multi for redirect_map broadcast test
      selftests/bpf: Add xdp_redirect_multi test
      bpf, devmap: Remove drops variable from bq_xmit_all()

Harishankar Vishwanathan (1):
      bpf, tnums: Provably sound, faster, and more precise algorithm for tnum_mul

Jean-Philippe Brucker (1):
      tools/bpftool: Fix cross-build

Jesper Dangaard Brouer (1):
      bpf: Run devmap xdp_prog on flush instead of bulk enqueue

Joe Stringer (1):
      selftests, bpf: Make docs tests fail more reliably

Kumar Kartikeya Dwivedi (2):
      libbpf: Remove unneeded check for flags during tc detach
      libbpf: Set NLM_F_EXCL when creating qdisc

Kuniyuki Iwashima (11):
      net: Introduce net.ipv4.tcp_migrate_req.
      tcp: Add num_closed_socks to struct sock_reuseport.
      tcp: Keep TCP_CLOSE sockets in the reuseport group.
      tcp: Add reuseport_migrate_sock() to select a new listener.
      tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
      tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.
      tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.
      bpf: Support BPF_FUNC_get_socket_cookie() for BPF_PROG_TYPE_SK_REUSEPORT.
      bpf: Support socket migration by eBPF.
      libbpf: Set expected_attach_type for BPF_PROG_TYPE_SK_REUSEPORT.
      bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.

Lorenz Bauer (1):
      libbpf: Fail compilation if target arch is missing

Magnus Karlsson (1):
      xsk: Use kvcalloc to support large umems

Michal Suchanek (1):
      libbpf: Fix pr_warn type warnings on 32bit

Shuyi Cheng (1):
      bpf: Fix typo in kernel/bpf/bpf_lsm.c

Stanislav Fomichev (1):
      libbpf: Skip bpf_object__probe_loading for light skeleton

Wang Hai (3):
      libbpf: Simplify the return expression of bpf_object__init_maps function
      samples/bpf: Add missing option to xdp_fwd usage
      samples/bpf: Add missing option to xdp_sample_pkts usage

Yonghong Song (2):
      libbpf: Add support for new llvm bpf relocations
      bpf, docs: Add llvm_reloc.rst to explain llvm bpf relocations

Zhen Lei (1):
      bpf: Fix spelling mistakes

Zhihao Cheng (1):
      tools/bpftool: Fix error return code in do_batch()

 Documentation/bpf/index.rst                        |   1 +
 Documentation/bpf/llvm_reloc.rst                   | 240 +++++++++
 Documentation/networking/ip-sysctl.rst             |  25 +
 include/linux/bpf.h                                |  23 +
 include/linux/bpf_local_storage.h                  |   4 +-
 include/linux/filter.h                             |  21 +-
 include/net/netns/ipv4.h                           |   1 +
 include/net/sock_reuseport.h                       |   9 +-
 include/net/xdp.h                                  |   1 +
 include/trace/events/xdp.h                         |   6 +-
 include/uapi/linux/bpf.h                           |  43 +-
 kernel/bpf/bpf_inode_storage.c                     |   2 +-
 kernel/bpf/bpf_lsm.c                               |   2 +-
 kernel/bpf/btf.c                                   |   6 +-
 kernel/bpf/core.c                                  |  61 ++-
 kernel/bpf/cpumap.c                                |   3 +-
 kernel/bpf/devmap.c                                | 305 +++++++++--
 kernel/bpf/hashtab.c                               | 102 +++-
 kernel/bpf/preload/iterators/iterators.bpf.c       |   1 -
 kernel/bpf/reuseport_array.c                       |   2 +-
 kernel/bpf/syscall.c                               |  47 +-
 kernel/bpf/tnum.c                                  |  41 +-
 kernel/bpf/trampoline.c                            |   2 +-
 kernel/bpf/verifier.c                              |  12 +-
 net/core/filter.c                                  |  60 ++-
 net/core/sock_reuseport.c                          | 359 +++++++++++--
 net/core/xdp.c                                     |  28 ++
 net/ipv4/inet_connection_sock.c                    | 191 ++++++-
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/sysctl_net_ipv4.c                         |   9 +
 net/ipv4/tcp_ipv4.c                                |  20 +-
 net/ipv4/tcp_minisocks.c                           |   4 +-
 net/ipv6/tcp_ipv6.c                                |  14 +-
 net/xdp/xdp_umem.c                                 |   7 +-
 net/xdp/xskmap.c                                   |   3 +-
 samples/bpf/Makefile                               |   3 +
 samples/bpf/ibumad_kern.c                          |   2 +-
 samples/bpf/ibumad_user.c                          |   2 +-
 samples/bpf/xdp_fwd_user.c                         |   2 +
 samples/bpf/xdp_redirect_map_multi_kern.c          |  88 ++++
 samples/bpf/xdp_redirect_map_multi_user.c          | 302 +++++++++++
 samples/bpf/xdp_sample_pkts_user.c                 |   3 +-
 tools/bpf/bpftool/Makefile                         |   5 +-
 tools/bpf/bpftool/gen.c                            |  27 +-
 tools/bpf/bpftool/main.c                           |   4 +-
 tools/include/uapi/linux/bpf.h                     |  43 +-
 tools/lib/bpf/Makefile                             |  18 +-
 tools/lib/bpf/bpf.c                                | 179 +++++--
 tools/lib/bpf/bpf.h                                |   2 +
 tools/lib/bpf/bpf_helpers.h                        |  66 +++
 tools/lib/bpf/bpf_prog_linfo.c                     |  18 +-
 tools/lib/bpf/bpf_tracing.h                        | 108 ++--
 tools/lib/bpf/btf.c                                | 302 +++++------
 tools/lib/bpf/btf_dump.c                           |  14 +-
 tools/lib/bpf/libbpf.c                             | 535 +++++++++++---------
 tools/lib/bpf/libbpf.h                             |   1 +
 tools/lib/bpf/libbpf.map                           |  10 +-
 tools/lib/bpf/libbpf_errno.c                       |   7 +-
 tools/lib/bpf/libbpf_internal.h                    |  59 +++
 tools/lib/bpf/libbpf_legacy.h                      |  59 +++
 tools/lib/bpf/linker.c                             |  25 +-
 tools/lib/bpf/netlink.c                            |  85 ++--
 tools/lib/bpf/ringbuf.c                            |  26 +-
 tools/testing/selftests/bpf/.gitignore             |   3 +
 tools/testing/selftests/bpf/Makefile               |   3 +-
 tools/testing/selftests/bpf/Makefile.docs          |   3 +-
 tools/testing/selftests/bpf/README.rst             |  19 +
 tools/testing/selftests/bpf/bench.c                |   1 +
 tools/testing/selftests/bpf/benchs/bench_rename.c  |   2 +-
 .../testing/selftests/bpf/benchs/bench_ringbufs.c  |   6 +-
 tools/testing/selftests/bpf/benchs/bench_trigger.c |   2 +-
 tools/testing/selftests/bpf/network_helpers.c      |   2 +-
 tools/testing/selftests/bpf/network_helpers.h      |   1 +
 .../selftests/bpf/prog_tests/attach_probe.c        |  12 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  31 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |   8 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |  93 ++--
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |   8 +-
 tools/testing/selftests/bpf/prog_tests/btf_write.c |   4 +-
 .../selftests/bpf/prog_tests/cg_storage_multi.c    |  84 ++--
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |   2 +-
 .../testing/selftests/bpf/prog_tests/cgroup_link.c |  14 +-
 .../bpf/prog_tests/cgroup_skb_sk_lookup.c          |   2 +-
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |   2 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  15 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  25 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |   2 +-
 .../bpf/prog_tests/flow_dissector_reattach.c       |  10 +-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |  10 +-
 .../bpf/prog_tests/get_stackid_cannot_attach.c     |   9 +-
 tools/testing/selftests/bpf/prog_tests/hashmap.c   |   9 +-
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |  19 +-
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |   3 +-
 .../selftests/bpf/prog_tests/link_pinning.c        |   7 +-
 .../selftests/bpf/prog_tests/lookup_and_delete.c   | 288 +++++++++++
 .../selftests/bpf/prog_tests/migrate_reuseport.c   | 559 +++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/obj_name.c  |   8 +-
 .../selftests/bpf/prog_tests/perf_branches.c       |   4 +-
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |   2 +-
 .../selftests/bpf/prog_tests/perf_event_stackmap.c |   3 +-
 .../testing/selftests/bpf/prog_tests/probe_user.c  |   7 +-
 .../selftests/bpf/prog_tests/prog_run_xattr.c      |   4 +-
 .../selftests/bpf/prog_tests/raw_tp_test_run.c     |   4 +-
 .../testing/selftests/bpf/prog_tests/rdonly_maps.c |   7 +-
 .../selftests/bpf/prog_tests/reference_tracking.c  |   2 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c      |   2 +-
 .../selftests/bpf/prog_tests/ringbuf_multi.c       |   2 +-
 .../selftests/bpf/prog_tests/select_reuseport.c    |  53 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   3 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |   2 +-
 .../testing/selftests/bpf/prog_tests/sock_fields.c |  14 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   8 +-
 .../selftests/bpf/prog_tests/sockmap_ktls.c        |   2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  10 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |   3 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c      |   2 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c         |   5 +-
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |  15 +-
 .../selftests/bpf/prog_tests/test_overhead.c       |  12 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    |  14 +-
 tools/testing/selftests/bpf/prog_tests/udp_limit.c |   7 +-
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_link.c  |   8 +-
 .../selftests/bpf/progs/bpf_iter_bpf_hash_map.c    |   1 -
 .../testing/selftests/bpf/progs/bpf_iter_bpf_map.c |   1 -
 .../selftests/bpf/progs/bpf_iter_ipv6_route.c      |   1 -
 .../testing/selftests/bpf/progs/bpf_iter_netlink.c |   1 -
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |   1 -
 .../selftests/bpf/progs/bpf_iter_task_btf.c        |   1 -
 .../selftests/bpf/progs/bpf_iter_task_file.c       |   1 -
 .../selftests/bpf/progs/bpf_iter_task_stack.c      |   1 -
 .../selftests/bpf/progs/bpf_iter_task_vma.c        |   1 -
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  |   1 -
 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c  |   1 -
 tools/testing/selftests/bpf/progs/bpf_iter_udp4.c  |   1 -
 tools/testing/selftests/bpf/progs/bpf_iter_udp6.c  |   1 -
 .../selftests/bpf/progs/test_lookup_and_delete.c   |  26 +
 .../selftests/bpf/progs/test_migrate_reuseport.c   | 135 +++++
 tools/testing/selftests/bpf/progs/test_snprintf.c  |   1 -
 .../selftests/bpf/progs/xdp_redirect_multi_kern.c  |  94 ++++
 tools/testing/selftests/bpf/test_doc_build.sh      |   1 +
 tools/testing/selftests/bpf/test_lru_map.c         |   8 +
 tools/testing/selftests/bpf/test_maps.c            | 185 ++++---
 tools/testing/selftests/bpf/test_progs.c           |   3 +
 tools/testing/selftests/bpf/test_progs.h           |   9 +-
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |   7 +-
 .../selftests/bpf/test_xdp_redirect_multi.sh       | 204 ++++++++
 tools/testing/selftests/bpf/xdp_redirect_multi.c   | 226 +++++++++
 148 files changed, 4779 insertions(+), 1248 deletions(-)
 create mode 100644 Documentation/bpf/llvm_reloc.rst
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/lib/bpf/libbpf_legacy.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lookup_and_delete.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_lookup_and_delete.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

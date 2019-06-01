Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A16EA31967
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfFADiU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 31 May 2019 23:38:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46234 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbfFADiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 23:38:19 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x513XlPo015381
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 20:38:18 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2suad2h73p-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 20:38:17 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 31 May 2019 20:38:13 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 2836B760D10; Fri, 31 May 2019 20:38:13 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf-next 2019-05-31
Date:   Fri, 31 May 2019 20:38:13 -0700
Message-ID: <20190601033813.2166995-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-01_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906010025
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

Lots of exciting new features in the first PR of this developement cycle!
The main changes are:

1) misc verifier improvements, from Alexei.

2) bpftool can now convert btf to valid C, from Andrii.

3) verifier can insert explicit ZEXT insn when requested by 32-bit JITs.
   This feature greatly improves BPF speed on 32-bit architectures. From Jiong.

4) cgroups will now auto-detach bpf programs. This fixes issue of thousands
   bpf programs got stuck in dying cgroups. From Roman.

5) new bpf_send_signal() helper, from Yonghong.

6) cgroup inet skb programs can signal CN to the stack, from Lawrence.

7) miscellaneous cleanups, from many developers.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 14a1eaa8820e8f3715f0cb3c1790edab67a751e9:

  hv_sock: perf: loop in send() to maximize bandwidth (2019-05-22 18:00:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to cd5385029f1d2e6879b78fff1a7b15514004af17:

  selftests/bpf: measure RTT from xdp using xdping (2019-05-31 19:53:45 -0700)

----------------------------------------------------------------
Alan Maguire (2):
      selftests/bpf: fix compilation error for flow_dissector.c
      selftests/bpf: measure RTT from xdp using xdping

Alexei Starovoitov (11):
      bpf: bump jmp sequence limit
      selftests/bpf: adjust verifier scale test
      selftests/bpf: add pyperf scale test
      bpf: cleanup explored_states
      bpf: split explored_states
      bpf: convert explored_states to hash table
      Merge branch 'btf2c-converter'
      Merge branch 'optimize-zext'
      Merge branch 'cgroup-auto-detach'
      Merge branch 'propagate-cn-to-tcp'
      Merge branch 'map-charge-cleanup'

Andrii Nakryiko (23):
      libbpf: emit diff of mismatched public API, if any
      libbpf: ensure libbpf.h is included along libbpf_internal.h
      libbpf: add btf__parse_elf API to load .BTF and .BTF.ext
      bpftool: use libbpf's btf__parse_elf API
      selftests/bpf: use btf__parse_elf to check presence of BTF/BTF.ext
      libbpf: add resizable non-thread safe internal hashmap
      selftests/bpf: add tests for libbpf's hashmap
      libbpf: switch btf_dedup() to hashmap for dedup table
      libbpf: add btf_dump API for BTF-to-C conversion
      selftests/bpf: add btf_dump BTF-to-C conversion tests
      bpftool: add C output format option to btf dump subcommand
      bpftool/docs: add description of btf dump C option
      bpftool: update bash-completion w/ new c option for btf dump
      bpftool: auto-complete BTF IDs for btf dump
      libbpf: fix detection of corrupted BPF instructions section
      libbpf: preserve errno before calling into user callback
      libbpf: simplify endianness check
      libbpf: check map name retrieved from ELF
      libbpf: fix error code returned on corrupted ELF
      libbpf: use negative fd to specify missing BTF
      libbpf: simplify two pieces of logic
      libbpf: typo and formatting fixes
      libbpf: reduce unnecessary line wrapping

Chang-Hsien Tsai (1):
      bpf: style fix in while(!feof()) loop

Daniel Borkmann (4):
      Merge branch 'bpf-jmp-seq-limit'
      Merge branch 'bpf-explored-states'
      Merge branch 'bpf-send-sig'
      Merge branch 'bpf-bpftool-dbg-output'

Daniel T. Lee (1):
      samples/bpf: fix a couple of style issues in bpf_load

Hariprasad Kelam (1):
      libbpf: fix warning that PTR_ERR_OR_ZERO can be used

Jiong Wang (18):
      bpf: verifier: mark verified-insn with sub-register zext flag
      bpf: verifier: mark patched-insn with sub-register zext flag
      bpf: introduce new mov32 variant for doing explicit zero extension
      bpf: verifier: insert zero extension according to analysis result
      bpf: introduce new bpf prog load flags "BPF_F_TEST_RND_HI32"
      tools: bpf: sync uapi header bpf.h
      bpf: verifier: randomize high 32-bit when BPF_F_TEST_RND_HI32 is set
      libbpf: add "prog_flags" to bpf_program/bpf_prog_load_attr/bpf_load_program_attr
      selftests: bpf: adjust several test_verifier helpers for insn insertion
      selftests: bpf: enable hi32 randomization for all tests
      arm: bpf: eliminate zero extension code-gen
      powerpc: bpf: eliminate zero extension code-gen
      s390: bpf: eliminate zero extension code-gen
      sparc: bpf: eliminate zero extension code-gen
      x32: bpf: eliminate zero extension code-gen
      riscv: bpf: eliminate zero extension code-gen
      nfp: bpf: eliminate zero extension code-gen
      bpf: doc: update answer for 32-bit subregister question

Matteo Croce (1):
      samples: bpf: add ibumad sample to .gitignore

Michal Rostecki (2):
      selftests: bpf: Move bpf_printk to bpf_helpers.h
      samples: bpf: Do not define bpf_printk macro

Quentin Monnet (4):
      tools: bpftool: add -d option to get debug output from libbpf
      libbpf: add bpf_object__load_xattr() API function to pass log_level
      tools: bpftool: make -d option print debug output from verifier
      libbpf: prevent overwriting of log_level in bpf_object__load_progs()

Roman Gushchin (9):
      bpf: decouple the lifetime of cgroup_bpf from cgroup itself
      selftests/bpf: convert test_cgrp2_attach2 example into kselftest
      selftests/bpf: enable all available cgroup v2 controllers
      selftests/bpf: add auto-detach test
      bpf: add memlock precharge check for cgroup_local_storage
      bpf: add memlock precharge for socket local storage
      bpf: group memory related fields in struct bpf_map_memory
      bpf: rework memlock-based memory accounting for maps
      bpf: move memory size checks to bpf_map_charge_init()

Stanislav Fomichev (5):
      selftests/bpf: fail test_tunnel.sh if subtests fail
      bpf: remove __rcu annotations from bpf_prog_array
      bpf: media: properly use bpf_prog_array api
      bpf: cgroup: properly use bpf_prog_array api
      bpf: tracing: properly use bpf_prog_array api

Yonghong Song (4):
      bpf: implement bpf_send_signal() helper
      tools/bpf: sync bpf uapi header bpf.h to tools directory
      tools/bpf: add selftest in test_progs for bpf_send_signal() helper
      bpf: check signal validity in nmi for bpf_send_signal() helper

brakmo (6):
      bpf: Create BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY
      bpf: cgroup inet skb programs can return 0 to 3
      bpf: Update __cgroup_bpf_run_filter_skb with cn
      bpf: Update BPF_CGROUP_RUN_PROG_INET_EGRESS calls
      bpf: Add cn support to hbm_out_kern.c
      bpf: Add more stats to HBM

 Documentation/bpf/bpf_design_QA.rst                |   30 +-
 arch/arm/net/bpf_jit_32.c                          |   42 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |   36 +-
 arch/riscv/net/bpf_jit_comp.c                      |   43 +-
 arch/s390/net/bpf_jit_comp.c                       |   41 +-
 arch/sparc/net/bpf_jit_comp_64.c                   |   29 +-
 arch/x86/net/bpf_jit_comp32.c                      |   83 +-
 drivers/media/rc/bpf-lirc.c                        |   30 +-
 drivers/net/ethernet/netronome/nfp/bpf/jit.c       |  115 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.h      |    2 +
 drivers/net/ethernet/netronome/nfp/bpf/verifier.c  |   12 +
 include/linux/bpf-cgroup.h                         |   13 +-
 include/linux/bpf.h                                |   78 +-
 include/linux/bpf_verifier.h                       |   16 +-
 include/linux/cgroup.h                             |   18 +
 include/linux/filter.h                             |   18 +-
 include/uapi/linux/bpf.h                           |   35 +-
 kernel/bpf/arraymap.c                              |   18 +-
 kernel/bpf/cgroup.c                                |   94 +-
 kernel/bpf/core.c                                  |   46 +-
 kernel/bpf/cpumap.c                                |    9 +-
 kernel/bpf/devmap.c                                |   14 +-
 kernel/bpf/hashtab.c                               |   14 +-
 kernel/bpf/local_storage.c                         |   13 +-
 kernel/bpf/lpm_trie.c                              |    8 +-
 kernel/bpf/queue_stack_maps.c                      |   13 +-
 kernel/bpf/reuseport_array.c                       |   17 +-
 kernel/bpf/stackmap.c                              |   28 +-
 kernel/bpf/syscall.c                               |  103 +-
 kernel/bpf/verifier.c                              |  397 +++++-
 kernel/bpf/xskmap.c                                |   10 +-
 kernel/cgroup/cgroup.c                             |   11 +-
 kernel/trace/bpf_trace.c                           |   96 +-
 net/core/bpf_sk_storage.c                          |   12 +-
 net/core/sock_map.c                                |    9 +-
 net/ipv4/ip_output.c                               |   34 +-
 net/ipv6/ip6_output.c                              |   26 +-
 samples/bpf/.gitignore                             |    1 +
 samples/bpf/Makefile                               |    2 -
 samples/bpf/bpf_load.c                             |    8 +-
 samples/bpf/do_hbm_test.sh                         |   10 +-
 samples/bpf/hbm.c                                  |   51 +-
 samples/bpf/hbm.h                                  |    9 +-
 samples/bpf/hbm_kern.h                             |   77 +-
 samples/bpf/hbm_out_kern.c                         |   48 +-
 samples/bpf/tcp_basertt_kern.c                     |    7 -
 samples/bpf/tcp_bufs_kern.c                        |    7 -
 samples/bpf/tcp_clamp_kern.c                       |    7 -
 samples/bpf/tcp_cong_kern.c                        |    7 -
 samples/bpf/tcp_iw_kern.c                          |    7 -
 samples/bpf/tcp_rwnd_kern.c                        |    7 -
 samples/bpf/tcp_synrto_kern.c                      |    7 -
 samples/bpf/tcp_tos_reflect_kern.c                 |    7 -
 samples/bpf/xdp_sample_pkts_kern.c                 |    7 -
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |   39 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |    4 +
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |    4 +
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |    4 +
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |    4 +
 tools/bpf/bpftool/Documentation/bpftool-perf.rst   |    4 +
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |    5 +
 tools/bpf/bpftool/Documentation/bpftool.rst        |    4 +
 tools/bpf/bpftool/bash-completion/bpftool          |   32 +-
 tools/bpf/bpftool/btf.c                            |  162 +--
 tools/bpf/bpftool/main.c                           |   16 +-
 tools/bpf/bpftool/main.h                           |    1 +
 tools/bpf/bpftool/prog.c                           |   27 +-
 tools/bpf/bpftool/xlated_dumper.c                  |    4 +-
 tools/include/uapi/linux/bpf.h                     |   35 +-
 tools/include/uapi/linux/if_tun.h                  |  114 ++
 tools/lib/bpf/Build                                |    4 +-
 tools/lib/bpf/Makefile                             |   12 +-
 tools/lib/bpf/bpf.c                                |    1 +
 tools/lib/bpf/bpf.h                                |    1 +
 tools/lib/bpf/btf.c                                |  329 +++--
 tools/lib/bpf/btf.h                                |   19 +
 tools/lib/bpf/btf_dump.c                           | 1336 ++++++++++++++++++++
 tools/lib/bpf/hashmap.c                            |  229 ++++
 tools/lib/bpf/hashmap.h                            |  173 +++
 tools/lib/bpf/libbpf.c                             |  175 ++-
 tools/lib/bpf/libbpf.h                             |    7 +
 tools/lib/bpf/libbpf.map                           |    9 +
 tools/lib/bpf/libbpf_internal.h                    |    2 +
 tools/testing/selftests/bpf/.gitignore             |    4 +
 tools/testing/selftests/bpf/Makefile               |   17 +-
 tools/testing/selftests/bpf/bpf_helpers.h          |    9 +
 tools/testing/selftests/bpf/cgroup_helpers.c       |   57 +
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |   32 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |  198 +++
 .../bpf/progs/btf_dump_test_case_bitfields.c       |   92 ++
 .../bpf/progs/btf_dump_test_case_multidim.c        |   35 +
 .../bpf/progs/btf_dump_test_case_namespacing.c     |   73 ++
 .../bpf/progs/btf_dump_test_case_ordering.c        |   63 +
 .../bpf/progs/btf_dump_test_case_packing.c         |   75 ++
 .../bpf/progs/btf_dump_test_case_padding.c         |  111 ++
 .../bpf/progs/btf_dump_test_case_syntax.c          |  229 ++++
 tools/testing/selftests/bpf/progs/pyperf.h         |  268 ++++
 tools/testing/selftests/bpf/progs/pyperf100.c      |    4 +
 tools/testing/selftests/bpf/progs/pyperf180.c      |    4 +
 tools/testing/selftests/bpf/progs/pyperf50.c       |    4 +
 .../selftests/bpf/progs/sockmap_parse_prog.c       |    7 -
 .../selftests/bpf/progs/sockmap_tcp_msg_prog.c     |    7 -
 .../selftests/bpf/progs/sockmap_verdict_prog.c     |    7 -
 .../selftests/bpf/progs/test_lwt_seg6local.c       |    7 -
 .../selftests/bpf/progs/test_send_signal_kern.c    |   51 +
 .../selftests/bpf/progs/test_xdp_noinline.c        |    7 -
 tools/testing/selftests/bpf/progs/xdping_kern.c    |  184 +++
 tools/testing/selftests/bpf/test_btf.c             |   71 +-
 tools/testing/selftests/bpf/test_btf_dump.c        |  143 +++
 .../testing/selftests/bpf/test_cgroup_attach.c     |  146 ++-
 tools/testing/selftests/bpf/test_hashmap.c         |  382 ++++++
 tools/testing/selftests/bpf/test_sock_addr.c       |    1 +
 tools/testing/selftests/bpf/test_sock_fields.c     |    1 +
 tools/testing/selftests/bpf/test_socket_cookie.c   |    1 +
 tools/testing/selftests/bpf/test_sockmap_kern.h    |    7 -
 tools/testing/selftests/bpf/test_stub.c            |   40 +
 tools/testing/selftests/bpf/test_tunnel.sh         |   32 +
 tools/testing/selftests/bpf/test_verifier.c        |   62 +-
 tools/testing/selftests/bpf/test_xdping.sh         |   99 ++
 tools/testing/selftests/bpf/trace_helpers.c        |    4 +-
 tools/testing/selftests/bpf/xdping.c               |  258 ++++
 tools/testing/selftests/bpf/xdping.h               |   13 +
 122 files changed, 6430 insertions(+), 1013 deletions(-)
 create mode 100644 tools/include/uapi/linux/if_tun.h
 create mode 100644 tools/lib/bpf/btf_dump.c
 create mode 100644 tools/lib/bpf/hashmap.c
 create mode 100644 tools/lib/bpf/hashmap.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/send_signal.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_namespacing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_ordering.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf.h
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf100.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf180.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf50.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_send_signal_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdping_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_btf_dump.c
 rename samples/bpf/test_cgrp2_attach2.c => tools/testing/selftests/bpf/test_cgroup_attach.c (79%)
 create mode 100644 tools/testing/selftests/bpf/test_hashmap.c
 create mode 100644 tools/testing/selftests/bpf/test_stub.c
 create mode 100755 tools/testing/selftests/bpf/test_xdping.sh
 create mode 100644 tools/testing/selftests/bpf/xdping.c
 create mode 100644 tools/testing/selftests/bpf/xdping.h

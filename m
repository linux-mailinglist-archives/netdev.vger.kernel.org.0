Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79AA7198982
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 03:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgCaB22 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Mar 2020 21:28:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37512 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729089AbgCaB22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 21:28:28 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02V1NkNG031891
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 18:28:26 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 302pkpggr5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 18:28:26 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 30 Mar 2020 18:28:25 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 16FFC761012; Mon, 30 Mar 2020 18:28:15 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf-next 2020-03-30
Date:   Mon, 30 Mar 2020 18:28:15 -0700
Message-ID: <20200331012815.3258314-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-30_07:2020-03-30,2020-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003310010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 73 non-merge commits during the last 14 day(s) which contain
a total of 107 files changed, 6086 insertions(+), 1728 deletions(-).

The main changes are:

1) drgn tool document, from Andrey.

2) bpf_link for cgroup-bpf, from Andrii.

3) new helpers for cgroup-bpf and netns cookie, from Daniel.

4) verifier fixes, from Jann and Daniel.

5) bpf_sk_assign, from Joe.

6) tracking of subregister bounds in the verifier, from John.

7) bpf-lsm, from KP.

8) bpf_sk_storage for bpf_tcp_ca, from Martin.

9) ifla_xdp_expected_fd, from Toke.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Anatoly Trosinenko, Andrii Nakryiko, Brendan 
Jackman, Casey Schaufler, Florent Revest, Hulk Robot, Jakub Kicinski, 
Jakub Sitnicki, James Morris, Jann Horn, John Fastabend, kbuild test 
robot, Kees Cook, Lorenz Bauer, Magnus Karlsson, Martin KaFai Lau, 
Michael Ellerman, Nathan Chancellor, Quentin Monnet, Randy Dunlap, Roman 
Gushchin, Stanislav Fomichev, Thomas Garnier, Yonghong Song

----------------------------------------------------------------

The following changes since commit 86e85bf6981c0c265c427d6bfe9e2a0111797444:

  sfc: fix XDP-redirect in this driver (2020-03-16 18:22:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 8596a75f6c830a693ec86e6467a58b225713a7f1:

  Merge branch 'cgroup-bpf_link' (2020-03-30 17:36:41 -0700)

----------------------------------------------------------------
Alexei Starovoitov (5):
      Merge branch 'cgroup-helpers'
      Merge branch 'ifla_xdp_expected_fd'
      Merge branch 'bpf_sk_assign'
      Merge branch 'subreg-bounds'
      Merge branch 'cgroup-bpf_link'

Andrey Ignatov (1):
      bpf: Document bpf_inspect drgn tool

Andrii Nakryiko (11):
      selftest/bpf: Fix compilation warning in sockmap_parse_prog.c
      selftests/bpf: Fix nanosleep for real this time
      selftests/bpf: Fix race in tcp_rtt test
      selftests/bpf: Fix test_progs's parsing of test numbers
      selftests/bpf: Reset process and thread affinity after each test/sub-test
      bpf: Factor out cgroup storages operations
      bpf: Factor out attach_type to prog_type mapping for attach/detach
      bpf: Implement bpf_link-based cgroup BPF program attachment
      bpf: Implement bpf_prog replacement for an active bpf_cgroup_link
      libbpf: Add support for bpf_link-based cgroup attachment
      selftests/bpf: Test FD-based cgroup attachment

Bill Wendling (1):
      selftests/bpf: Fix mix of tabs and spaces

Daniel Borkmann (11):
      bpf: Enable retrieval of socket cookie for bind/post-bind hook
      bpf: Enable perf event rb output for bpf cgroup progs
      bpf: Add netns cookie and enable it for bpf cgroup hooks
      bpf: Allow to retrieve cgroup v1 classid from v2 hooks
      bpf: Enable bpf cgroup hooks to retrieve cgroup v2 and ancestor id
      bpf: Enable retrival of pid/tgid/comm from bpf cgroup hooks
      bpf: Add selftest cases for ctx_or_null argument type
      bpf, net: Fix build issue when net ns not configured
      Merge branch 'bpf-lsm'
      bpf: Undo incorrect __reg_bound_offset32 handling
      bpf, doc: Add John as official reviewer to BPF subsystem

Daniel T. Lee (2):
      samples, bpf: Move read_trace_pipe to trace_helpers
      samples, bpf: Refactor perf_event user program with libbpf bpf_link

Fangrui Song (1):
      bpf: Support llvm-objcopy for vmlinux BTF

Fletcher Dunn (1):
      libbpf, xsk: Init all ring members in xsk_umem__create and xsk_socket__create

Jann Horn (2):
      bpf: Fix tnum constraints for 32-bit comparisons
      bpf: Simplify reg_set_min_max_inv handling

Jean-Philippe Menil (1):
      bpf: Fix build warning regarding missing prototypes

Joe Stringer (4):
      bpf: Add socket assign support
      net: Track socket refcounts in skb_steal_sock()
      bpf: Don't refcount LISTEN sockets in sk_assign()
      selftests: bpf: Extend sk_assign tests for UDP

John Fastabend (10):
      bpf: Verifer, refactor adjust_scalar_min_max_vals
      bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()
      bpf: Test_verifier, #70 error message updates for 32-bit right shift
      bpf: Verifier, do_refine_retval_range may clamp umin to 0 incorrectly
      bpf: Verifier, do explicit ALU32 bounds tracking
      bpf: Verifier, refine 32bit bound in do_refine_retval_range
      bpf: Test_progs, add test to catch retval refine error handling
      bpf: Test_verifier, bpf_get_stack return value add <0
      bpf: Test_verifier, #65 error message updates for trunc of boundary-cross
      bpf: Test_verifier, add alu32 bounds tracking tests

KP Singh (10):
      bpf: Introduce BPF_PROG_TYPE_LSM
      security: Refactor declaration of LSM hooks
      bpf: lsm: Provide attachment points for BPF LSM programs
      bpf: lsm: Implement attach, detach and execution
      bpf: lsm: Initialize the BPF LSM hooks
      tools/libbpf: Add support for BPF_PROG_TYPE_LSM
      bpf: lsm: Add selftests for BPF_PROG_TYPE_LSM
      bpf: lsm: Add Documentation
      bpf: btf: Fix arg verification in btf_ctx_access()
      bpf, lsm: Make BPF_LSM depend on BPF_EVENTS

Lorenz Bauer (1):
      selftests: bpf: Add test for sk_assign

Martin KaFai Lau (6):
      bpftool: Print the enum's name instead of value
      bpftool: Print as a string for char array
      bpftool: Translate prog_id to its bpf prog_name
      bpftool: Add struct_ops support
      bpf: Add bpf_sk_storage support to bpf_tcp_ca
      bpf: Add tests for bpf_sk_storage to bpf_tcp_ca

Stanislav Fomichev (1):
      libbpf: Don't allocate 16M for log buffer by default

Tobias Klauser (1):
      libbpf: Remove unused parameter `def` to get_map_field_int

Toke Høiland-Jørgensen (6):
      xdp: Support specifying expected existing program when attaching XDP
      tools: Add EXPECTED_FD-related definitions in if_link.h
      libbpf: Add function to set link XDP fd while specifying old program
      selftests/bpf: Add tests for attaching XDP programs
      libbpf: Add setter for initial value for internal maps
      selftests: Add test for overriding global data value before load

Wenbo Zhang (1):
      bpf, libbpf: Fix ___bpf_kretprobe_args1(x) macro definition

YueHaibing (3):
      bpf, tcp: Fix unused function warnings
      bpf, tcp: Make tcp_bpf_recvmsg static
      bpf: Remove unused vairable 'bpf_xdp_link_lops'

 Documentation/bpf/bpf_lsm.rst                      |  142 ++
 Documentation/bpf/drgn.rst                         |  213 +++
 Documentation/bpf/index.rst                        |    6 +-
 MAINTAINERS                                        |    2 +
 arch/powerpc/kernel/vmlinux.lds.S                  |    6 -
 include/asm-generic/vmlinux.lds.h                  |   15 +
 include/linux/bpf-cgroup.h                         |   41 +-
 include/linux/bpf.h                                |   15 +-
 include/linux/bpf_lsm.h                            |   33 +
 include/linux/bpf_types.h                          |    4 +
 include/linux/bpf_verifier.h                       |    4 +
 include/linux/limits.h                             |    1 +
 include/linux/lsm_hook_defs.h                      |  381 +++++
 include/linux/lsm_hooks.h                          |  628 +-------
 include/linux/netdevice.h                          |    2 +-
 include/linux/tnum.h                               |   12 +
 include/net/cls_cgroup.h                           |    7 +-
 include/net/inet6_hashtables.h                     |    3 +-
 include/net/inet_hashtables.h                      |    3 +-
 include/net/net_namespace.h                        |    5 +
 include/net/sock.h                                 |   46 +-
 include/net/tcp.h                                  |    2 -
 include/uapi/linux/bpf.h                           |   82 +-
 include/uapi/linux/if_link.h                       |    4 +-
 init/Kconfig                                       |   13 +
 kernel/bpf/Makefile                                |    1 +
 kernel/bpf/bpf_lsm.c                               |   54 +
 kernel/bpf/btf.c                                   |   45 +-
 kernel/bpf/cgroup.c                                |  505 +++++--
 kernel/bpf/core.c                                  |    1 +
 kernel/bpf/helpers.c                               |   18 +
 kernel/bpf/syscall.c                               |  330 ++--
 kernel/bpf/sysfs_btf.c                             |   11 +-
 kernel/bpf/tnum.c                                  |   15 +
 kernel/bpf/trampoline.c                            |   17 +-
 kernel/bpf/verifier.c                              | 1570 ++++++++++++++------
 kernel/cgroup/cgroup.c                             |   41 +-
 kernel/trace/bpf_trace.c                           |   12 +-
 net/bpf/test_run.c                                 |    4 +
 net/core/dev.c                                     |   26 +-
 net/core/filter.c                                  |  141 +-
 net/core/net_namespace.c                           |   15 +
 net/core/rtnetlink.c                               |   14 +
 net/core/sock.c                                    |   12 +
 net/ipv4/bpf_tcp_ca.c                              |   33 +
 net/ipv4/ip_input.c                                |    3 +-
 net/ipv4/tcp_bpf.c                                 |  152 +-
 net/ipv4/udp.c                                     |    6 +-
 net/ipv6/ip6_input.c                               |    3 +-
 net/ipv6/udp.c                                     |    9 +-
 net/sched/act_bpf.c                                |    3 +
 samples/bpf/Makefile                               |    8 +-
 samples/bpf/bpf_load.c                             |   20 -
 samples/bpf/bpf_load.h                             |    1 -
 samples/bpf/sampleip_user.c                        |   98 +-
 samples/bpf/trace_event_user.c                     |  139 +-
 samples/bpf/tracex1_user.c                         |    1 +
 samples/bpf/tracex5_user.c                         |    1 +
 scripts/link-vmlinux.sh                            |   24 +-
 security/Kconfig                                   |   10 +-
 security/Makefile                                  |    2 +
 security/bpf/Makefile                              |    5 +
 security/bpf/hooks.c                               |   26 +
 security/security.c                                |   41 +-
 .../bpftool/Documentation/bpftool-struct_ops.rst   |  116 ++
 tools/bpf/bpftool/bash-completion/bpftool          |   28 +
 tools/bpf/bpftool/btf_dumper.c                     |  199 ++-
 tools/bpf/bpftool/main.c                           |    3 +-
 tools/bpf/bpftool/main.h                           |    2 +
 tools/bpf/bpftool/struct_ops.c                     |  596 ++++++++
 tools/include/uapi/linux/bpf.h                     |   82 +-
 tools/include/uapi/linux/if_link.h                 |    4 +-
 tools/lib/bpf/bpf.c                                |   37 +-
 tools/lib/bpf/bpf.h                                |   19 +
 tools/lib/bpf/bpf_tracing.h                        |    2 +-
 tools/lib/bpf/btf.c                                |   20 +-
 tools/lib/bpf/libbpf.c                             |  134 +-
 tools/lib/bpf/libbpf.h                             |   22 +-
 tools/lib/bpf/libbpf.map                           |    9 +
 tools/lib/bpf/libbpf_probes.c                      |    1 +
 tools/lib/bpf/netlink.c                            |   34 +-
 tools/lib/bpf/xsk.c                                |   16 +-
 tools/testing/selftests/bpf/config                 |    2 +
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |   39 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |    2 +-
 .../testing/selftests/bpf/prog_tests/cgroup_link.c |  244 +++
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |    5 +
 .../selftests/bpf/prog_tests/global_data_init.c    |   61 +
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |  309 ++++
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   |    4 +-
 tools/testing/selftests/bpf/prog_tests/test_lsm.c  |   86 ++
 tools/testing/selftests/bpf/prog_tests/vmlinux.c   |    2 +-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |   62 +
 tools/testing/selftests/bpf/progs/bpf_dctcp.c      |   16 +
 tools/testing/selftests/bpf/progs/lsm.c            |   48 +
 .../selftests/bpf/progs/sockmap_parse_prog.c       |    1 -
 .../testing/selftests/bpf/progs/test_cgroup_link.c |   24 +
 .../selftests/bpf/progs/test_get_stack_rawtp_err.c |   26 +
 .../testing/selftests/bpf/progs/test_global_data.c |    2 +-
 tools/testing/selftests/bpf/progs/test_sk_assign.c |  204 +++
 tools/testing/selftests/bpf/test_progs.c           |   71 +-
 tools/testing/selftests/bpf/test_progs.h           |    1 +
 tools/testing/selftests/bpf/trace_helpers.c        |   23 +
 tools/testing/selftests/bpf/trace_helpers.h        |    1 +
 tools/testing/selftests/bpf/verifier/bounds.c      |   57 +-
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |    8 +-
 tools/testing/selftests/bpf/verifier/ctx.c         |  105 ++
 107 files changed, 6086 insertions(+), 1728 deletions(-)
 create mode 100644 Documentation/bpf/bpf_lsm.rst
 create mode 100644 Documentation/bpf/drgn.rst
 create mode 100644 include/linux/bpf_lsm.h
 create mode 100644 include/linux/lsm_hook_defs.h
 create mode 100644 kernel/bpf/bpf_lsm.c
 create mode 100644 security/bpf/Makefile
 create mode 100644 security/bpf/hooks.c
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
 create mode 100644 tools/bpf/bpftool/struct_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_link.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/global_data_init.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_assign.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_lsm.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cgroup_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c

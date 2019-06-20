Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCED4C5F8
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 05:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731390AbfFTD5d convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jun 2019 23:57:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52084 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726419AbfFTD5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 23:57:32 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5K3vUVQ015476
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 20:57:31 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t7wwcgunp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 20:57:31 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 19 Jun 2019 20:57:27 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id B20D3760CC1; Wed, 19 Jun 2019 20:57:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf-next 2019-06-19
Date:   Wed, 19 Jun 2019 20:57:26 -0700
Message-ID: <20190620035726.3942971-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-20_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200030
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

The main changes are:

1) new SO_REUSEPORT_DETACH_BPF setsocktopt, from Martin.

2) BTF based map definition, from Andrii.

3) support bpf_map_lookup_elem for xskmap, from Jonathan.

4) bounded loops and scalar precision logic in the verifier, from Alexei.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 0462eaacee493f7e2d87551a35d38be93ca723f8:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2019-05-31 21:21:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 94079b64255fe40b9b53fd2e4081f68b9b14f54a:

  Merge branch 'bpf-bounded-loops' (2019-06-19 02:22:53 +0200)

----------------------------------------------------------------
Alexei Starovoitov (10):
      Merge branch 'xskmap-lookup'
      bpf: track spill/fill of constants
      selftests/bpf: fix tests due to const spill/fill
      bpf: extend is_branch_taken to registers
      bpf: introduce bounded loops
      bpf: fix callees pruning callers
      selftests/bpf: fix tests
      selftests/bpf: add basic verifier tests for loops
      selftests/bpf: add realistic loop tests
      bpf: precise scalar_value tracking

Andrii Nakryiko (13):
      selftests/bpf: fix constness of source arg for bpf helpers
      libbpf: fix check for presence of associated BTF for map creation
      libbpf: add common min/max macro to libbpf_internal.h
      libbpf: extract BTF loading logic
      libbpf: streamline ELF parsing error-handling
      libbpf: refactor map initialization
      libbpf: identify maps by section index in addition to offset
      libbpf: split initialization and loading of BTF
      libbpf: allow specifying map definitions using BTF
      selftests/bpf: add test for BTF-defined maps
      selftests/bpf: switch BPF_ANNOTATE_KV_PAIR tests to BTF-defined maps
      selftests/bpf: convert tests w/ custom values to BTF-defined maps
      libbpf: constify getter APIs

Colin Ian King (2):
      bpf: hbm: fix spelling mistake "notifcations" -> "notificiations"
      bpf: remove redundant assignment to err

Dan Carpenter (1):
      selftests/bpf: signedness bug in enable_all_controllers()

Daniel Borkmann (3):
      Merge branch 'bpf-libbpf-num-cpus'
      Merge branch 'bpf-libbpf-btf-defined-maps'
      Merge branch 'bpf-bounded-loops'

Daniel T. Lee (2):
      samples: bpf: remove unnecessary include options in Makefile
      samples: bpf: refactor header include path

Hechao Li (4):
      selftests/bpf : clean up feature/ when make clean
      bpf: add a new API libbpf_num_possible_cpus()
      selftests/bpf: remove bpf_util.h from BPF C progs
      bpf: use libbpf_num_possible_cpus internally

Jakub Kicinski (2):
      samples: bpf: print a warning about headers_install
      samples: bpf: don't run probes at the local make stage

Jonathan Lemon (4):
      bpf: Allow bpf_map_lookup_elem() on an xskmap
      bpf/tools: sync bpf.h
      tools/bpf: Add bpf_map_lookup_elem selftest for xskmap
      libbpf: remove qidconf and better support external bpf programs.

Martin KaFai Lau (3):
      bpf: net: Add SO_DETACH_REUSEPORT_BPF
      bpf: Sync asm-generic/socket.h to tools/
      bpf: Add test for SO_REUSEPORT_DETACH_BPF

Prashant Bhole (1):
      samples/bpf: fix include path in Makefile

Roman Gushchin (1):
      bpf: allow CGROUP_SKB programs to use bpf_skb_cgroup_id() helper

Stanislav Fomichev (4):
      bpf: export bpf_sock for BPF_PROG_TYPE_CGROUP_SOCK_ADDR prog type
      bpf: export bpf_sock for BPF_PROG_TYPE_SOCK_OPS prog type
      bpf/tools: sync bpf.h
      selftests/bpf: convert socket_cookie test to sk storage

Valdis Kletnieks (1):
      bpf: silence warning messages in core

YueHaibing (1):
      bpf: Fix build error without CONFIG_INET

 arch/alpha/include/uapi/asm/socket.h               |   2 +
 arch/mips/include/uapi/asm/socket.h                |   2 +
 arch/parisc/include/uapi/asm/socket.h              |   2 +
 arch/sparc/include/uapi/asm/socket.h               |   2 +
 include/linux/bpf.h                                |  25 +
 include/linux/bpf_verifier.h                       |  69 +-
 include/net/sock_reuseport.h                       |   2 +
 include/net/xdp_sock.h                             |   4 +-
 include/uapi/asm-generic/socket.h                  |   2 +
 include/uapi/linux/bpf.h                           |   6 +
 kernel/bpf/Makefile                                |   1 +
 kernel/bpf/devmap.c                                |   2 +-
 kernel/bpf/verifier.c                              | 793 ++++++++++++++++--
 kernel/bpf/xskmap.c                                |   9 +-
 net/core/filter.c                                  |  86 ++
 net/core/sock.c                                    |   4 +
 net/core/sock_reuseport.c                          |  24 +
 samples/bpf/Makefile                               |  23 +-
 samples/bpf/fds_example.c                          |   2 +-
 samples/bpf/hbm.c                                  |   6 +-
 samples/bpf/ibumad_user.c                          |   2 +-
 samples/bpf/sockex1_user.c                         |   2 +-
 samples/bpf/sockex2_user.c                         |   2 +-
 samples/bpf/xdp1_user.c                            |   4 +-
 samples/bpf/xdp_adjust_tail_user.c                 |   4 +-
 samples/bpf/xdp_fwd_user.c                         |   2 +-
 samples/bpf/xdp_redirect_cpu_user.c                |   2 +-
 samples/bpf/xdp_redirect_map_user.c                |   2 +-
 samples/bpf/xdp_redirect_user.c                    |   2 +-
 samples/bpf/xdp_router_ipv4_user.c                 |   2 +-
 samples/bpf/xdp_rxq_info_user.c                    |   4 +-
 samples/bpf/xdp_tx_iptunnel_user.c                 |   2 +-
 samples/bpf/xdpsock_user.c                         |   4 +-
 tools/bpf/bpftool/common.c                         |  53 +-
 tools/include/uapi/asm-generic/socket.h            | 147 ++++
 tools/include/uapi/linux/bpf.h                     |   6 +
 tools/lib/bpf/bpf.c                                |   7 +-
 tools/lib/bpf/bpf_prog_linfo.c                     |   5 +-
 tools/lib/bpf/btf.c                                |   3 -
 tools/lib/bpf/btf.h                                |   1 +
 tools/lib/bpf/btf_dump.c                           |   3 -
 tools/lib/bpf/libbpf.c                             | 927 +++++++++++++++------
 tools/lib/bpf/libbpf.h                             |  78 +-
 tools/lib/bpf/libbpf.map                           |   1 +
 tools/lib/bpf/libbpf_internal.h                    |   7 +
 tools/lib/bpf/xsk.c                                | 103 +--
 tools/testing/selftests/bpf/Makefile               |   3 +-
 tools/testing/selftests/bpf/bpf_endian.h           |   1 +
 tools/testing/selftests/bpf/bpf_helpers.h          |   4 +-
 tools/testing/selftests/bpf/bpf_util.h             |  37 +-
 tools/testing/selftests/bpf/cgroup_helpers.c       |   2 +-
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |  67 +-
 tools/testing/selftests/bpf/progs/bpf_flow.c       |  18 +-
 tools/testing/selftests/bpf/progs/loop1.c          |  28 +
 tools/testing/selftests/bpf/progs/loop2.c          |  28 +
 tools/testing/selftests/bpf/progs/loop3.c          |  22 +
 tools/testing/selftests/bpf/progs/netcnt_prog.c    |  22 +-
 tools/testing/selftests/bpf/progs/pyperf.h         |   6 +-
 tools/testing/selftests/bpf/progs/pyperf600.c      |   9 +
 .../selftests/bpf/progs/pyperf600_nounroll.c       |   8 +
 .../selftests/bpf/progs/socket_cookie_prog.c       |  49 +-
 .../selftests/bpf/progs/sockmap_parse_prog.c       |   1 -
 .../selftests/bpf/progs/sockmap_tcp_msg_prog.c     |   2 +-
 .../selftests/bpf/progs/sockmap_verdict_prog.c     |   1 -
 tools/testing/selftests/bpf/progs/strobemeta.c     |  10 +
 tools/testing/selftests/bpf/progs/strobemeta.h     | 528 ++++++++++++
 .../selftests/bpf/progs/strobemeta_nounroll1.c     |   9 +
 .../selftests/bpf/progs/strobemeta_nounroll2.c     |   9 +
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |  73 ++
 .../selftests/bpf/progs/test_get_stack_rawtp.c     |  27 +-
 .../testing/selftests/bpf/progs/test_global_data.c |  27 +-
 tools/testing/selftests/bpf/progs/test_l4lb.c      |  45 +-
 .../selftests/bpf/progs/test_l4lb_noinline.c       |  45 +-
 tools/testing/selftests/bpf/progs/test_map_lock.c  |  22 +-
 tools/testing/selftests/bpf/progs/test_seg6_loop.c | 261 ++++++
 .../bpf/progs/test_select_reuseport_kern.c         |  45 +-
 .../selftests/bpf/progs/test_send_signal_kern.c    |  22 +-
 .../selftests/bpf/progs/test_sock_fields_kern.c    |  60 +-
 tools/testing/selftests/bpf/progs/test_spin_lock.c |  33 +-
 .../selftests/bpf/progs/test_stacktrace_build_id.c |  44 +-
 .../selftests/bpf/progs/test_stacktrace_map.c      |  40 +-
 .../selftests/bpf/progs/test_sysctl_loop1.c        |  71 ++
 .../selftests/bpf/progs/test_sysctl_loop2.c        |  72 ++
 .../testing/selftests/bpf/progs/test_sysctl_prog.c |   5 +-
 .../testing/selftests/bpf/progs/test_tcp_estats.c  |   9 +-
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |  18 +-
 .../selftests/bpf/progs/test_tcpnotify_kern.c      |  18 +-
 tools/testing/selftests/bpf/progs/test_xdp.c       |  18 +-
 tools/testing/selftests/bpf/progs/test_xdp_loop.c  | 231 +++++
 .../selftests/bpf/progs/test_xdp_noinline.c        |  60 +-
 tools/testing/selftests/bpf/test_btf.c             |  10 +-
 .../testing/selftests/bpf/test_select_reuseport.c  |  54 ++
 tools/testing/selftests/bpf/test_socket_cookie.c   |  24 +-
 tools/testing/selftests/bpf/test_verifier.c        |  11 +-
 tools/testing/selftests/bpf/verifier/calls.c       |  22 +-
 tools/testing/selftests/bpf/verifier/cfg.c         |  11 +-
 .../selftests/bpf/verifier/direct_packet_access.c  |   3 +-
 .../selftests/bpf/verifier/helper_access_var_len.c |  28 +-
 tools/testing/selftests/bpf/verifier/loops1.c      | 161 ++++
 .../selftests/bpf/verifier/prevent_map_lookup.c    |  15 -
 tools/testing/selftests/bpf/verifier/sock.c        |  18 +
 101 files changed, 4048 insertions(+), 860 deletions(-)
 create mode 100644 tools/include/uapi/asm-generic/socket.h
 create mode 100644 tools/testing/selftests/bpf/progs/loop1.c
 create mode 100644 tools/testing/selftests/bpf/progs/loop2.c
 create mode 100644 tools/testing/selftests/bpf/progs/loop3.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf600.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf600_nounroll.c
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta.c
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta.h
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta_nounroll1.c
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta_nounroll2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_btf_newkv.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_seg6_loop.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_loop.c
 create mode 100644 tools/testing/selftests/bpf/verifier/loops1.c

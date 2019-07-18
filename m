Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A13476D62A
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 23:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391510AbfGRVBE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jul 2019 17:01:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37750 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727780AbfGRVAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 17:00:32 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6IKuebv021941
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 14:00:31 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2ttxnygc85-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 14:00:31 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 18 Jul 2019 14:00:26 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 4981B7609BF; Thu, 18 Jul 2019 14:00:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf 2019-07-18
Date:   Thu, 18 Jul 2019 14:00:25 -0700
Message-ID: <20190718210025.21557-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-18_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907180215
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) verifier precision propagation fix, from Andrii.

2) BTF size fix for typedefs, from Andrii.

3) a bunch of big endian fixes, from Ilya.

4) wide load from bpf_sock_addr fixes, from Stanislav.

5) a bunch of misc fixes from a number of developers.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 114a5c3240155fdb01bf821c9d326d7bb05bd464:

  Merge tag 'mlx5-fixes-2019-07-11' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2019-07-11 15:06:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 59fd3486c3dd5678bc2fcac75e14466775465c3e:

  selftests/bpf: fix test_xdp_noinline on s390 (2019-07-18 13:54:54 -0700)

----------------------------------------------------------------
Andrii Nakryiko (9):
      bpf: fix precision bit propagation for BPF_ST instructions
      libbpf: fix ptr to u64 conversion warning on 32-bit platforms
      bpf: fix BTF verifier size resolution logic
      selftests/bpf: add trickier size resolution tests
      selftests/bpf: use typedef'ed arrays as map values
      selftests/bpf: remove logic duplication in test_verifier
      libbpf: fix another GCC8 warning for strncpy
      selftests/bpf: fix test_verifier/test_maps make dependencies
      selftests/bpf: structure test_{progs, maps, verifier} test runners uniformly

Daniel Borkmann (2):
      Merge branch 'bpf-btf-size-verification-fix'
      Merge branch 'bpf-fix-wide-loads-sockaddr'

Daniel T. Lee (1):
      tools: bpftool: add raw_tracepoint_writable prog type to header

Gustavo A. R. Silva (1):
      bpf: verifier: avoid fall-through warnings

Ilya Leoshkevich (15):
      selftests/bpf: fix bpf_target_sparc check
      selftests/bpf: do not ignore clang failures
      selftests/bpf: compile progs with -D__TARGET_ARCH_$(SRCARCH)
      selftests/bpf: fix s930 -> s390 typo
      selftests/bpf: make PT_REGS_* work in userspace
      selftests/bpf: fix compiling loop{1, 2, 3}.c on s390
      selftests/bpf: fix attach_probe on s390
      selftests/bpf: make directory prerequisites order-only
      selftests/bpf: put test_stub.o into $(OUTPUT)
      samples/bpf: build with -D__TARGET_ARCH_$(SRCARCH)
      selftests/bpf: fix "alu with different scalars 1" on s390
      selftests/bpf: skip nmi test when perf hw events are disabled
      selftests/bpf: fix perf_buffer on s390
      selftests/bpf: fix "valid read map access into a read-only array 1" on s390
      selftests/bpf: fix test_xdp_noinline on s390

Ilya Maximets (2):
      xdp: fix possible cq entry leak
      xdp: fix potential deadlock on socket mutex

Stanislav Fomichev (5):
      bpf: rename bpf_ctx_wide_store_ok to bpf_ctx_wide_access_ok
      bpf: allow wide aligned loads for bpf_sock_addr user_ip6 and msg_src_ip6
      selftests/bpf: rename verifier/wide_store.c to verifier/wide_access.c
      selftests/bpf: add selftests for wide loads
      bpf: sync bpf.h to tools/

Vasily Gorbik (1):
      MAINTAINERS: update BPF JIT S390 maintainers

 MAINTAINERS                                        |  2 +-
 include/linux/filter.h                             |  2 +-
 include/uapi/linux/bpf.h                           |  4 +-
 kernel/bpf/btf.c                                   | 19 +++--
 kernel/bpf/verifier.c                              | 13 ++--
 net/core/filter.c                                  | 24 ++++--
 net/xdp/xdp_umem.c                                 | 16 ++--
 net/xdp/xsk.c                                      | 13 ++--
 samples/bpf/Makefile                               |  2 +-
 tools/bpf/bpftool/main.h                           |  1 +
 tools/include/uapi/linux/bpf.h                     |  4 +-
 tools/lib/bpf/libbpf.c                             |  4 +-
 tools/lib/bpf/xsk.c                                |  3 +-
 tools/testing/selftests/bpf/Makefile               | 64 ++++++++--------
 tools/testing/selftests/bpf/bpf_helpers.h          | 89 +++++++++++++++-------
 .../selftests/bpf/prog_tests/attach_probe.c        | 10 +--
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |  8 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c | 33 +++++++-
 tools/testing/selftests/bpf/progs/loop1.c          |  2 +-
 tools/testing/selftests/bpf/progs/loop2.c          |  2 +-
 tools/testing/selftests/bpf/progs/loop3.c          |  2 +-
 .../selftests/bpf/progs/test_get_stack_rawtp.c     |  3 +-
 .../selftests/bpf/progs/test_stacktrace_build_id.c |  3 +-
 .../selftests/bpf/progs/test_stacktrace_map.c      |  2 +-
 .../selftests/bpf/progs/test_xdp_noinline.c        | 17 +++--
 tools/testing/selftests/bpf/test_btf.c             | 88 +++++++++++++++++++++
 tools/testing/selftests/bpf/test_progs.h           |  8 ++
 tools/testing/selftests/bpf/test_verifier.c        | 35 ++++-----
 .../testing/selftests/bpf/verifier/array_access.c  |  2 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |  2 +-
 tools/testing/selftests/bpf/verifier/wide_access.c | 73 ++++++++++++++++++
 tools/testing/selftests/bpf/verifier/wide_store.c  | 36 ---------
 32 files changed, 391 insertions(+), 195 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/wide_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/wide_store.c

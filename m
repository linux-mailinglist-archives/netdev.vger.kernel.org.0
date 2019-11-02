Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3953ED08B
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 21:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfKBU0i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 Nov 2019 16:26:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52790 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbfKBU0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 16:26:37 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA2KOSYP019032
        for <netdev@vger.kernel.org>; Sat, 2 Nov 2019 13:26:36 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w17hpssyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 13:26:36 -0700
Received: from 2401:db00:2050:5076:face:0:7:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 2 Nov 2019 13:26:34 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id C51AA760F52; Sat,  2 Nov 2019 13:26:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf-next 2019-11-02
Date:   Sat, 2 Nov 2019 13:26:32 -0700
Message-ID: <20191102202632.2108287-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-02_12:2019-11-01,2019-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 spamscore=0 suspectscore=1 bulkscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1911020202
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 30 non-merge commits during the last 7 day(s) which contain
a total of 41 files changed, 1864 insertions(+), 474 deletions(-).

The main changes are:

1) Fix long standing user vs kernel access issue by introducing
   bpf_probe_read_user() and bpf_probe_read_kernel() helpers, from Daniel.

2) Accelerated xskmap lookup, from Björn and Maciej.

3) Support for automatic map pinning in libbpf, from Toke.

4) Cleanup of BTF-enabled raw tracepoints, from Alexei.

5) Various fixes to libbpf and selftests.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrey Ignatov, Andrii Nakryiko, Björn Töpel, Eloy 
Degen, Ilya Leoshkevich, Jiri Olsa, Jonathan Lemon, Martin KaFai Lau

----------------------------------------------------------------

The following changes since commit 5b7fe93db008ff013db24239136a25f3ac5142ac:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2019-10-26 22:57:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 358fdb456288d48874d44a064a82bfb0d9963fa0:

  Merge branch 'bpf_probe_read_user' (2019-11-02 12:45:15 -0700)

----------------------------------------------------------------
Alexei Starovoitov (6):
      bpf: Enforce 'return 0' in BTF-enabled raw_tp programs
      bpf: Fix bpf jit kallsym access
      bpf: Replace prog_raw_tp+btf_id with prog_tracing
      libbpf: Add support for prog_tracing
      Merge branch 'map-pinning'
      Merge branch 'bpf_probe_read_user'

Andrii Nakryiko (2):
      libbpf: Fix off-by-one error in ELF sanity check
      libbpf: Don't use kernel-side u32 type in xsk.c

Björn Töpel (2):
      xsk: Store struct xdp_sock as a flexible array member of the XSKMAP
      xsk: Restructure/inline XSKMAP lookup/redirect/flush

Daniel Borkmann (10):
      Merge branch 'bpf-cleanup-btf-raw-tp'
      Merge branch 'bpf-xskmap-perf-improvements'
      uaccess: Add non-pagefault user-space write function
      uaccess: Add strict non-pagefault kernel-space read function
      bpf: Make use of probe_user_write in probe write helper
      bpf: Add probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers
      bpf: Switch BPF probe insns to bpf_probe_read_kernel
      bpf, samples: Use bpf_probe_read_user where appropriate
      bpf, testing: Convert prog tests to probe_read_{user, kernel}{, _str} helper
      bpf, testing: Add selftest to read/write sockaddr from user space

Ilya Leoshkevich (4):
      selftest/bpf: Use -m{little, big}-endian for clang
      selftests/bpf: Restore $(OUTPUT)/test_stub.o rule
      selftests/bpf: Test narrow load from bpf_sysctl.write
      bpf: Add s390 testing documentation

Jakub Kicinski (1):
      Revert "selftests: bpf: Don't try to read files without read permission"

Maciej Fijalkowski (1):
      bpf: Implement map_gen_lookup() callback for XSKMAP

Magnus Karlsson (1):
      libbpf: Fix compatibility for kernels without need_wakeup

Shmulik Ladkani (2):
      bpf, testing: Refactor test_skb_segment() for testing skb_segment() on different skbs
      bpf, testing: Introduce 'gso_linear_no_head_frag' skb_segment test

Toke Høiland-Jørgensen (5):
      libbpf: Fix error handling in bpf_map__reuse_fd()
      libbpf: Store map pin path and status in struct bpf_map
      libbpf: Move directory creation into _pin() functions
      libbpf: Add auto-pinning of maps when loading BPF objects
      selftests: Add tests for automatic map pinning

 Documentation/bpf/index.rst                        |   9 +
 Documentation/bpf/s390.rst                         | 205 +++++++++
 arch/x86/mm/Makefile                               |   2 +-
 arch/x86/mm/maccess.c                              |  43 ++
 include/linux/bpf.h                                |  30 +-
 include/linux/bpf_types.h                          |   1 +
 include/linux/uaccess.h                            |  16 +
 include/net/xdp_sock.h                             |  51 ++-
 include/uapi/linux/bpf.h                           | 124 ++++--
 kernel/bpf/core.c                                  |  12 +-
 kernel/bpf/syscall.c                               |   6 +-
 kernel/bpf/verifier.c                              |  39 +-
 kernel/bpf/xskmap.c                                | 112 ++---
 kernel/trace/bpf_trace.c                           | 231 +++++++---
 lib/test_bpf.c                                     | 112 ++++-
 mm/maccess.c                                       |  70 +++-
 net/xdp/xsk.c                                      |  33 +-
 samples/bpf/map_perf_test_kern.c                   |   4 +-
 samples/bpf/test_map_in_map_kern.c                 |   4 +-
 samples/bpf/test_probe_write_user_kern.c           |   2 +-
 tools/include/uapi/linux/bpf.h                     | 124 ++++--
 tools/lib/bpf/bpf.c                                |   8 +-
 tools/lib/bpf/bpf.h                                |   5 +-
 tools/lib/bpf/bpf_helpers.h                        |   6 +
 tools/lib/bpf/libbpf.c                             | 466 ++++++++++++++++-----
 tools/lib/bpf/libbpf.h                             |  23 +-
 tools/lib/bpf/libbpf.map                           |   5 +
 tools/lib/bpf/libbpf_probes.c                      |   1 +
 tools/lib/bpf/xsk.c                                |  83 +++-
 tools/testing/selftests/bpf/Makefile               |  16 +-
 tools/testing/selftests/bpf/prog_tests/pinning.c   | 210 ++++++++++
 .../testing/selftests/bpf/prog_tests/probe_user.c  |  78 ++++
 tools/testing/selftests/bpf/progs/kfree_skb.c      |   4 +-
 tools/testing/selftests/bpf/progs/pyperf.h         |  67 +--
 tools/testing/selftests/bpf/progs/strobemeta.h     |  36 +-
 tools/testing/selftests/bpf/progs/test_pinning.c   |  31 ++
 .../selftests/bpf/progs/test_pinning_invalid.c     |  16 +
 .../testing/selftests/bpf/progs/test_probe_user.c  |  26 ++
 .../testing/selftests/bpf/progs/test_tcp_estats.c  |   2 +-
 tools/testing/selftests/bpf/test_offload.py        |   2 +-
 tools/testing/selftests/bpf/test_sysctl.c          |  23 +
 41 files changed, 1864 insertions(+), 474 deletions(-)
 create mode 100644 Documentation/bpf/s390.rst
 create mode 100644 arch/x86/mm/maccess.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pinning.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/probe_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pinning.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pinning_invalid.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_probe_user.c

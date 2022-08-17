Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BA9597960
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 23:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242288AbiHQV5K convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Aug 2022 17:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241904AbiHQV5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 17:57:09 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F181AA927B
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 14:57:07 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27HHsDUg031268
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 14:57:07 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3j0npgxkur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 14:57:06 -0700
Received: from twshared18213.14.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 17 Aug 2022 14:57:05 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id E17D91DC1B0A3; Wed, 17 Aug 2022 14:56:56 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <andrii@kernel.org>, <kernel-team@fb.com>
Subject: pull-request: bpf-next 2022-08-17
Date:   Wed, 17 Aug 2022 14:56:56 -0700
Message-ID: <20220817215656.1180215-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset="UTF-8"
X-FB-Internal: Safe
X-Proofpoint-GUID: rpZdNGOzDMQl7ut1OBA_69suIOPzUOhQ
X-Proofpoint-ORIG-GUID: rpZdNGOzDMQl7ut1OBA_69suIOPzUOhQ
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-17_15,2022-08-16_02,2022-06-22_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 45 non-merge commits during the last 14 day(s) which contain
a total of 61 files changed, 986 insertions(+), 372 deletions(-).

The main changes are:

1) New bpf_ktime_get_tai_ns() BPF helper to access CLOCK_TAI, from Kurt
   Kanzenbach and Jesper Dangaard Brouer.

2) Few clean ups and improvements for libbpf 1.0, from Andrii Nakryiko.

3) Expose crash_kexec() as kfunc for BPF programs, from Artem Savkov.

4) Add ability to define sleepable-only kfuncs, from Benjamin Tissoires.

5) Teach libbpf's bpf_prog_load() and bpf_map_create() to gracefully handle
   unsupported names on old kernels, from Hangbin Liu.

6) Allow opting out from auto-attaching BPF programs by libbpf's BPF skeleton,
   from Hao Luo.

7) Relax libbpf's requirement for shared libs to be marked executable, from
   Henqgi Chen.

8) Improve bpf_iter internals handling of error returns, from Hao Luo.

9) Few accommodations in libbpf to support GCC-BPF quirks, from James Hilliard.

10) Fix BPF verifier logic around tracking dynptr ref_obj_id, from Joanne Koong.

11) bpftool improvements to handle full BPF program names better, from Manu
    Bretelle.

12) bpftool fixes around libcap use, from Quentin Monnet.

13) BPF map internals clean ups and improvements around memory allocations,
    from Yafang Shao.

14) Allow to use cgroup_get_from_file() on cgroupv1, allowing BPF cgroup
    iterator to work on cgroupv1, from Yosry Ahmed.

15) BPF verifier internal clean ups, from Dave Marchevsky and Joanne Koong.

16) Various fixes and clean ups for selftests/bpf and vmtest.sh, from Daniel
    Xu, Artem Savkov, Joanne Koong, Andrii Nakryiko, Shibin Koikkara Reeny.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Daniel Müller, David Vernet, Goro Fuji, Hao Luo, Jiri Olsa, Joanne 
Koong, Kumar Kartikeya Dwivedi, Maciej Fijalkowski, Martin KaFai Lau, 
Quentin Monnet, Rumen Telbizov, Tejun Heo, Yonghong Song

----------------------------------------------------------------

The following changes since commit f86d1fbbe7858884d6754534a0afbb74fc30bc26:

  Merge tag 'net-next-6.0' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-08-03 16:29:08 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to df78da27260c915039b348b164bbc53fa372ba70:

  selftests/bpf: Few fixes for selftests/bpf built in release mode (2022-08-17 22:43:58 +0200)

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'Add BPF-helper for accessing CLOCK_TAI'
      Merge branch 'destructive bpf_kfuncs'

Andrii Nakryiko (6):
      libbpf: Reject legacy 'maps' ELF section
      libbpf: preserve errno across pr_warn/pr_info/pr_debug
      libbpf: Fix potential NULL dereference when parsing ELF
      libbpf: Streamline bpf_attr and perf_event_attr initialization
      libbpf: Clean up deprecated and legacy aliases
      selftests/bpf: Few fixes for selftests/bpf built in release mode

Artem Savkov (4):
      bpf: add destructive kfunc flag
      bpf: export crash_kexec() as destructive kfunc
      selftests/bpf: add destructive kfunc test
      selftests/bpf: Fix attach point for non-x86 arches in test_progs/lsm

Benjamin Tissoires (1):
      btf: Add a new kfunc flag which allows to mark a function to be sleepable

Daniel Xu (5):
      selftests/bpf: Fix vmtest.sh -h to not require root
      selftests/bpf: Fix vmtest.sh getopts optstring
      selftests/bpf: Add existing connection bpf_*_ct_lookup() test
      selftests/bpf: Add connmark read test
      selftests/bpf: Update CI kconfig

Dave Marchevsky (2):
      bpf: Improve docstring for BPF_F_USER_BUILD_ID flag
      bpf: Cleanup check_refcount_ok

Florian Fainelli (1):
      libbpf: Initialize err in probe_map_create

Hangbin Liu (2):
      libbpf: Add names for auxiliary maps
      libbpf: Making bpf_prog_load() ignore name if kernel doesn't support

Hao Luo (3):
      bpf, iter: Fix the condition on p when calling stop.
      libbpf: Allows disabling auto attach
      selftests/bpf: Tests libbpf autoattach APIs

Hengqi Chen (1):
      libbpf: Do not require executable permission for shared libraries

James Hilliard (2):
      libbpf: Skip empty sections in bpf_object__init_global_data_maps
      libbpf: Ensure functions with always_inline attribute are inline

Jesper Dangaard Brouer (1):
      bpf: Add BPF-helper for accessing CLOCK_TAI

Joanne Koong (4):
      selftests/bpf: Clean up sys_nanosleep uses
      bpf: Verifier cleanups
      bpf: Fix ref_obj_id for dynptr data slices in verifier
      selftests/bpf: add extra test for using dynptr data slice after release

Kumar Kartikeya Dwivedi (1):
      net: netfilter: Remove ifdefs for code shared by BPF and ctnetlink

Kurt Kanzenbach (1):
      selftests/bpf: Add BPF-helper test for CLOCK_TAI access

Manu Bretelle (1):
      bpftool: Remove BPF_OBJ_NAME_LEN restriction when looking up bpf program by name

Quentin Monnet (3):
      bpftool: Fix a typo in a comment
      bpf: Clear up confusion in bpf_skb_adjust_room()'s documentation
      bpftool: Clear errno after libcap's checks

Shibin Koikkara Reeny (1):
      selftests/xsk: Update poll test cases

Yafang Shao (4):
      bpf: Remove unneeded memset in queue_stack_map creation
      bpf: Use bpf_map_area_free instread of kvfree
      bpf: Make __GFP_NOWARN consistent in bpf map creation
      bpf: Use bpf_map_area_alloc consistently on bpf map creation

Yonghong Song (1):
      bpf: Always return corresponding btf_type in __get_type_size()

Yosry Ahmed (1):
      cgroup: enable cgroup_get_from_file() on cgroup1

 Documentation/bpf/kfuncs.rst                       |  15 ++
 include/linux/bpf.h                                |   1 +
 include/linux/btf.h                                |   2 +
 include/net/netfilter/nf_conntrack_core.h          |   6 -
 include/uapi/linux/bpf.h                           |  33 +++-
 kernel/bpf/bpf_iter.c                              |   5 +
 kernel/bpf/bpf_local_storage.c                     |   6 +-
 kernel/bpf/btf.c                                   |  18 +-
 kernel/bpf/core.c                                  |   1 +
 kernel/bpf/cpumap.c                                |   6 +-
 kernel/bpf/devmap.c                                |   6 +-
 kernel/bpf/hashtab.c                               |   6 +-
 kernel/bpf/helpers.c                               |  32 ++++
 kernel/bpf/local_storage.c                         |   5 +-
 kernel/bpf/lpm_trie.c                              |   4 +-
 kernel/bpf/offload.c                               |   6 +-
 kernel/bpf/queue_stack_maps.c                      |   2 -
 kernel/bpf/ringbuf.c                               |  10 +-
 kernel/bpf/verifier.c                              | 159 +++++++++---------
 kernel/cgroup/cgroup.c                             |   5 -
 net/bpf/test_run.c                                 |   5 +
 net/core/sock_map.c                                |  12 +-
 net/netfilter/nf_conntrack_core.c                  |   6 -
 tools/bpf/bpftool/common.c                         |  15 +-
 tools/bpf/bpftool/feature.c                        |   2 +-
 tools/bpf/bpftool/main.c                           |  10 ++
 tools/include/uapi/linux/bpf.h                     |  33 +++-
 tools/lib/bpf/bpf.c                                | 186 ++++++++++++---------
 tools/lib/bpf/bpf_tracing.h                        |  14 +-
 tools/lib/bpf/btf.c                                |   2 -
 tools/lib/bpf/btf.h                                |   1 -
 tools/lib/bpf/libbpf.c                             | 104 ++++++++----
 tools/lib/bpf/libbpf.h                             |   2 +
 tools/lib/bpf/libbpf.map                           |   2 +
 tools/lib/bpf/libbpf_internal.h                    |   3 +
 tools/lib/bpf/libbpf_legacy.h                      |   2 +
 tools/lib/bpf/libbpf_probes.c                      |   2 +-
 tools/lib/bpf/netlink.c                            |   3 +-
 tools/lib/bpf/skel_internal.h                      |  10 +-
 tools/lib/bpf/usdt.bpf.h                           |   4 +-
 tools/testing/selftests/bpf/DENYLIST.s390x         |   2 +-
 tools/testing/selftests/bpf/config                 |   2 +
 .../selftests/bpf/prog_tests/attach_probe.c        |   6 +-
 .../testing/selftests/bpf/prog_tests/autoattach.c  |  30 ++++
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |  60 +++++++
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |   3 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |  36 ++++
 .../selftests/bpf/prog_tests/task_pt_regs.c        |   2 +-
 tools/testing/selftests/bpf/prog_tests/time_tai.c  |  74 ++++++++
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |  94 +++++++----
 .../selftests/bpf/progs/kfunc_call_destructive.c   |  14 ++
 tools/testing/selftests/bpf/progs/lsm.c            |   3 +-
 .../testing/selftests/bpf/progs/test_autoattach.c  |  23 +++
 .../testing/selftests/bpf/progs/test_bpf_cookie.c  |   4 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |  21 +++
 .../selftests/bpf/progs/test_helper_restricted.c   |   4 +-
 tools/testing/selftests/bpf/progs/test_time_tai.c  |  24 +++
 tools/testing/selftests/bpf/vmtest.sh              |  34 ++--
 tools/testing/selftests/bpf/xskxceiver.c           | 166 +++++++++++++-----
 tools/testing/selftests/bpf/xskxceiver.h           |   8 +-
 61 files changed, 986 insertions(+), 372 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/autoattach.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/time_tai.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_destructive.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_autoattach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_time_tai.c

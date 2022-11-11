Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA4E62653C
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 00:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbiKKXQf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Nov 2022 18:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbiKKXQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 18:16:34 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E791006C
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 15:16:33 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2ABJO71n018847
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 15:16:33 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3ksaseg7pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 15:16:32 -0800
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub101.TheFacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 15:16:31 -0800
Received: from twshared24130.14.prn3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 15:16:31 -0800
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id 18E6B218EE36C; Fri, 11 Nov 2022 15:16:24 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <andrii@kernel.org>, <kernel-team@fb.com>
Subject: pull-request: bpf 2022-11-11
Date:   Fri, 11 Nov 2022 15:16:24 -0800
Message-ID: <20221111231624.938829-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset="UTF-8"
X-FB-Internal: Safe
X-Proofpoint-GUID: 5SspYes5lS6rU6TmQq_B3X5Dg-xwHSvf
X-Proofpoint-ORIG-GUID: 5SspYes5lS6rU6TmQq_B3X5Dg-xwHSvf
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_11,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 11 non-merge commits during the last 8 day(s) which contain
a total of 11 files changed, 83 insertions(+), 74 deletions(-).

The main changes are:

1) Fix strncpy_from_kernel_nofault() to prevent out-of-bounds writes,
   from Alban Crequy.

2) Fix for bpf_prog_test_run_skb() to prevent wrong alignment,
   from Baisong Zhong.

3) Switch BPF_DISPATCHER to static_call() instead of ftrace infra, with
   a small build fix on top, from Peter Zijlstra and Nathan Chancellor.

4) Fix memory leak in BPF verifier in some error cases, from Wang Yufen.

5) 32-bit compilation error fixes for BPF selftests, from Pu Lehui and
   Yang Jihong.

6) Ensure even distribution of per-CPU free list elements, from Xu Kuohai.

7) Fix copy_map_value() to track special zeroed out areas properly,
   from Xu Kuohai.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrew Morton, Björn Töpel, David Laight, Francis Laniel, Jiri Olsa, 
"kernelci.org bot", kernel test robot, Kumar Kartikeya Dwivedi, Yonghong 
Song

----------------------------------------------------------------

The following changes since commit 1118b2049d77ca0b505775fc1a8d1909cf19a7ec:

  net: tun: Fix memory leaks of napi_get_frags (2022-11-04 10:56:22 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 1f6e04a1c7b85da3b765ca9f46029e5d1826d839:

  bpf: Fix offset calculation error in __copy_map_value and zero_map_value (2022-11-11 12:35:07 -0800)

----------------------------------------------------------------
Alban Crequy (2):
      maccess: Fix writing offset in case of fault in strncpy_from_kernel_nofault()
      selftests: bpf: Add a test when bpf_probe_read_kernel_str() returns EFAULT

Andrii Nakryiko (1):
      Merge branch 'Fix offset when fault occurs in strncpy_from_kernel_nofault()'

Baisong Zhong (1):
      bpf, test_run: Fix alignment problem in bpf_prog_test_run_skb()

Nathan Chancellor (1):
      bpf: Add explicit cast to 'void *' for __BPF_DISPATCHER_UPDATE()

Peter Zijlstra (2):
      bpf: Revert ("Fix dispatcher patchable function entry to 5 bytes nop")
      bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)

Pu Lehui (1):
      selftests/bpf: Fix casting error when cross-compiling test_verifier for 32-bit platforms

Wang Yufen (1):
      bpf: Fix memory leaks in __check_func_call

Xu Kuohai (2):
      bpf: Initialize same number of free nodes for each pcpu_freelist
      bpf: Fix offset calculation error in __copy_map_value and zero_map_value

Yang Jihong (1):
      selftests/bpf: Fix test_progs compilation failure in 32-bit arch

 arch/x86/net/bpf_jit_comp.c                     | 13 ------
 include/linux/bpf.h                             | 60 ++++++++++++++++---------
 kernel/bpf/dispatcher.c                         | 28 ++++--------
 kernel/bpf/percpu_freelist.c                    | 23 +++++-----
 kernel/bpf/verifier.c                           | 14 +++---
 mm/maccess.c                                    |  2 +-
 net/bpf/test_run.c                              |  1 +
 tools/testing/selftests/bpf/prog_tests/varlen.c |  7 +++
 tools/testing/selftests/bpf/progs/test_varlen.c |  5 +++
 tools/testing/selftests/bpf/test_progs.c        |  2 +-
 tools/testing/selftests/bpf/test_verifier.c     |  2 +-
 11 files changed, 83 insertions(+), 74 deletions(-)

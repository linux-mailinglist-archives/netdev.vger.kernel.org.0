Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300CB1B82E7
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgDYAxl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Apr 2020 20:53:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35030 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbgDYAxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 20:53:40 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03P0pHL7020431
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 17:53:40 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30kkpe8668-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 17:53:40 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 24 Apr 2020 17:53:38 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 22B57760F17; Fri, 24 Apr 2020 17:53:33 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf 2020-04-24
Date:   Fri, 24 Apr 2020 17:53:33 -0700
Message-ID: <20200425005333.3305925-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_13:2020-04-24,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 suspectscore=1 mlxscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 malwarescore=0 clxscore=1034 mlxlogscore=719
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004250004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 17 non-merge commits during the last 5 day(s) which contain
a total of 19 files changed, 203 insertions(+), 85 deletions(-).

The main changes are:

1) link_update fix, from Andrii.

2) libbpf get_xdp_id fix, from David.

3) xadd verifier fix, from Jann.

4) x86-32 JIT fixes, from Luke and Wang.

5) test_btf fix, from Stanislav.

6) freplace verifier fix, from Toke.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrey Ignatov, Andrii Nakryiko, H. Peter Anvin (Intel), Hulk Robot, 
Jesper Dangaard Brouer, Quentin Monnet, Song Liu, Wang YanQing, Xiumei Mu

----------------------------------------------------------------

The following changes since commit a460fc5d4c170806a31e590df37ead3ab951315c:

  Merge tag 'mlx5-fixes-2020-04-20' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2020-04-20 16:17:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to e1cebd841b0aa1ceda771706d54a0501986a3c88:

  selftests/bpf: Fix a couple of broken test_btf cases (2020-04-24 17:47:40 -0700)

----------------------------------------------------------------
Andrii Nakryiko (2):
      bpf: Fix leak in LINK_UPDATE and enforce empty old_prog_fd
      tools/runqslower: Ensure own vmlinux.h is picked up first

David Ahern (1):
      libbpf: Only check mode flags in get_xdp_id

Jakub Wilk (1):
      bpf: Fix reStructuredText markup

Jann Horn (2):
      bpf: Forbid XADD on spilled pointers for unprivileged users
      bpf: Fix handling of XADD on BTF memory

Luke Nelson (4):
      bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B
      bpf, selftests: Add test for BPF_STX BPF_B storing R10
      bpf, x86_32: Fix incorrect encoding in BPF_LDX zero-extension
      bpf, x86_32: Fix clobbering of dst for BPF_JSET

Martin KaFai Lau (1):
      bpftool: Respect the -d option in struct_ops cmd

Stanislav Fomichev (1):
      selftests/bpf: Fix a couple of broken test_btf cases

Toke Høiland-Jørgensen (3):
      cpumap: Avoid warning when CONFIG_DEBUG_PER_CPU_MAPS is enabled
      bpf: Propagate expected_attach_type when verifying freplace programs
      selftests/bpf: Add test for freplace program with expected_attach_type

Wang YanQing (1):
      bpf, x86_32: Fix logic error in BPF_LDX zero-extension

Zou Wei (1):
      bpf: Make bpf_link_fops static

 arch/x86/net/bpf_jit_comp.c                        | 18 ++++++++--
 arch/x86/net/bpf_jit_comp32.c                      | 28 +++++++++++----
 include/uapi/linux/bpf.h                           |  2 +-
 kernel/bpf/cpumap.c                                |  2 +-
 kernel/bpf/syscall.c                               | 13 +++++--
 kernel/bpf/verifier.c                              | 38 ++++++++++++++------
 tools/bpf/bpftool/struct_ops.c                     |  8 ++++-
 tools/bpf/runqslower/Makefile                      |  2 +-
 tools/include/uapi/linux/bpf.h                     |  2 +-
 tools/lib/bpf/netlink.c                            |  2 ++
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       | 30 ++++++++++++----
 tools/testing/selftests/bpf/progs/connect4_prog.c  | 28 ++++++++-------
 .../selftests/bpf/progs/freplace_connect4.c        | 18 ++++++++++
 tools/testing/selftests/bpf/progs/test_btf_haskv.c | 18 +++-------
 tools/testing/selftests/bpf/progs/test_btf_newkv.c | 18 +++-------
 tools/testing/selftests/bpf/progs/test_btf_nokv.c  | 18 +++-------
 tools/testing/selftests/bpf/test_btf.c             |  2 +-
 tools/testing/selftests/bpf/verifier/stack_ptr.c   | 40 ++++++++++++++++++++++
 .../selftests/bpf/verifier/value_illegal_alu.c     |  1 +
 19 files changed, 203 insertions(+), 85 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_connect4.c

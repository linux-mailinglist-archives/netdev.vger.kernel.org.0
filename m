Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F17211C0A0
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfLKXfD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Dec 2019 18:35:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727059AbfLKXfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 18:35:02 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBNYpcH028098
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 15:35:01 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wtk8wny9b-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 15:35:01 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 11 Dec 2019 15:34:40 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id DC3CE760E47; Wed, 11 Dec 2019 15:34:39 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf 2019-12-11
Date:   Wed, 11 Dec 2019 15:34:39 -0800
Message-ID: <20191211233439.1535862-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_07:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 suspectscore=1 impostorscore=0 malwarescore=0
 phishscore=0 adultscore=0 priorityscore=1501 mlxlogscore=876 bulkscore=0
 clxscore=1034 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 8 non-merge commits during the last 1 day(s) which contain
a total of 10 files changed, 126 insertions(+), 18 deletions(-).

The main changes are:

1) Make BPF trampoline co-exist with ftrace-based tracers, from Alexei.

2) Fix build in minimal configurations, from Arnd.

3) Fix mips, riscv bpf_tail_call limit, from Paul.

4) Fix bpftool segfault, from Toke.

5) Fix samples/bpf, from Daniel.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Björn Töpel, Daniel Borkmann, Mahshid Khezri, Martin KaFai Lau

----------------------------------------------------------------

The following changes since commit 24dee0c7478d1a1e00abdf5625b7f921467325dc:

  net: ena: fix napi handler misbehavior when the napi budget is zero (2019-12-10 17:54:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to fe3300897cbfd76c6cb825776e5ac0ca50a91ca4:

  samples: bpf: fix syscall_tp due to unused syscall (2019-12-11 15:28:06 -0800)

----------------------------------------------------------------
Alexei Starovoitov (2):
      bpf: Make BPF trampoline use register_ftrace_direct() API
      selftests/bpf: Test function_graph tracer and bpf trampoline together

Arnd Bergmann (1):
      bpf: Fix build in minimal configurations, again

Daniel T. Lee (2):
      samples: bpf: Replace symbol compare of trace_event
      samples: bpf: fix syscall_tp due to unused syscall

Paul Chaignon (2):
      bpf, riscv: Limit to 33 tail calls
      bpf, mips: Limit to 33 tail calls

Toke Høiland-Jørgensen (1):
      bpftool: Don't crash on missing jited insns or ksyms

 arch/mips/net/ebpf_jit.c                   |  9 +++--
 arch/riscv/net/bpf_jit_comp.c              |  4 +-
 include/linux/bpf.h                        |  1 +
 kernel/bpf/btf.c                           |  1 +
 kernel/bpf/trampoline.c                    | 64 +++++++++++++++++++++++++++---
 samples/bpf/syscall_tp_kern.c              | 18 ++++++++-
 samples/bpf/trace_event_user.c             |  4 +-
 tools/bpf/bpftool/prog.c                   |  2 +-
 tools/bpf/bpftool/xlated_dumper.c          |  2 +-
 tools/testing/selftests/bpf/test_ftrace.sh | 39 ++++++++++++++++++
 10 files changed, 126 insertions(+), 18 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_ftrace.sh

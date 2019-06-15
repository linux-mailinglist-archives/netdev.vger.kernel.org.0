Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A4E47292
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 01:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfFOXln convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 15 Jun 2019 19:41:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51664 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbfFOXln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 19:41:43 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5FNcxxK015538
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 16:41:42 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t4xdfhbdt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 16:41:41 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 15 Jun 2019 16:41:40 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 84B06760C4D; Sat, 15 Jun 2019 16:41:38 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf 2019-06-15
Date:   Sat, 15 Jun 2019 16:41:38 -0700
Message-ID: <20190615234138.3313038-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-15_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906150225
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) fix stack layout of JITed x64 bpf code, from Alexei.

2) fix out of bounds memory access in bpf_sk_storage, from Arthur.

3) fix lpm trie walk, from Jonathan.

4) fix nested bpf_perf_event_output, from Matt.

5) and several other fixes.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit dce5ccccd1231c6eaec5ede80bce85f2ae536826:

  nfp: ensure skb network header is set for packet redirect (2019-06-09 20:08:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 9594dc3c7e71b9f52bee1d7852eb3d4e3aea9e99:

  bpf: fix nested bpf tracepoints with per-cpu data (2019-06-15 16:33:35 -0700)

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf, x64: fix stack layout of JITed bpf code

Arthur Fabre (1):
      bpf: Fix out of bounds memory access in bpf_sk_storage

Daniel Borkmann (1):
      Merge branch 'bpf-ppc-div-fix'

Ilya Maximets (1):
      xdp: check device pointer before clearing

Jonathan Lemon (1):
      bpf: lpm_trie: check left child of last leftmost node for NULL

Martin KaFai Lau (1):
      bpf: net: Set sk_bpf_storage back to NULL for cloned sk

Martynas Pumputis (2):
      bpf: simplify definition of BPF_FIB_LOOKUP related flags
      bpf: sync BPF_FIB_LOOKUP flag changes with BPF uapi

Matt Mullins (1):
      bpf: fix nested bpf tracepoints with per-cpu data

Naveen N. Rao (2):
      bpf: fix div64 overflow tests to properly detect errors
      powerpc/bpf: use unsigned division instruction for 64-bit operations

Toshiaki Makita (3):
      bpf, devmap: Fix premature entry free on destroying map
      bpf, devmap: Add missing bulk queue free
      bpf, devmap: Add missing RCU read lock on flush

 arch/powerpc/include/asm/ppc-opcode.h              |   1 +
 arch/powerpc/net/bpf_jit.h                         |   2 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |   8 +-
 arch/x86/net/bpf_jit_comp.c                        |  74 +++++----------
 include/uapi/linux/bpf.h                           |   4 +-
 kernel/bpf/devmap.c                                |   9 +-
 kernel/bpf/lpm_trie.c                              |   9 +-
 kernel/trace/bpf_trace.c                           | 100 +++++++++++++++++----
 net/core/bpf_sk_storage.c                          |   3 +-
 net/core/sock.c                                    |   3 +
 net/xdp/xdp_umem.c                                 |  11 +--
 tools/include/uapi/linux/bpf.h                     |   4 +-
 tools/testing/selftests/bpf/test_lpm_map.c         |  41 ++++++++-
 .../testing/selftests/bpf/verifier/div_overflow.c  |  14 ++-
 14 files changed, 188 insertions(+), 95 deletions(-)

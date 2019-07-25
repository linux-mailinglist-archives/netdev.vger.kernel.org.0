Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2040755D6
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 19:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbfGYRgB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jul 2019 13:36:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39238 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728019AbfGYRgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 13:36:00 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6PFw9RM001481
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 10:35:59 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tye7a0scv-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 10:35:59 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 25 Jul 2019 10:35:41 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 1012E760922; Thu, 25 Jul 2019 10:35:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf 2019-07-25
Date:   Thu, 25 Jul 2019 10:35:41 -0700
Message-ID: <20190725173541.2413580-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-25_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907250188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) fix segfault in libbpf, from Andrii.

2) fix gso_segs access, from Eric.

3) tls/sockmap fixes, from Jakub and John.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 8d650cdedaabb33e85e9b7c517c0c71fcecc1de9:

  tcp: fix tcp_set_congestion_control() use from bpf hook (2019-07-18 20:33:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to cb8ffde5694ae5fffb456eae932aac442aa3a207:

  libbpf: silence GCC8 warning about string truncation (2019-07-25 10:13:31 -0700)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'fix-gso_segs'

Andrii Nakryiko (3):
      libbpf: fix SIGSEGV when BTF loading fails, but .BTF.ext exists
      libbpf: sanitize VAR to conservative 1-byte INT
      libbpf: silence GCC8 warning about string truncation

Arnaldo Carvalho de Melo (2):
      libbpf: Fix endianness macro usage for some compilers
      libbpf: Avoid designated initializers for unnamed union members

Daniel Borkmann (1):
      Merge branch 'bpf-sockmap-tls-fixes'

Eric Dumazet (2):
      bpf: fix access to skb_shared_info->gso_segs
      selftests/bpf: add another gso_segs access

Ilya Leoshkevich (2):
      selftests/bpf: fix sendmsg6_prog on s390
      bpf: fix narrower loads on s390

Ilya Maximets (1):
      libbpf: fix using uninitialized ioctl results

Jakub Kicinski (7):
      net/tls: don't arm strparser immediately in tls_set_sw_offload()
      net/tls: don't call tls_sk_proto_close for hw record offload
      selftests/tls: add a test for ULP but no keys
      selftests/tls: test error codes around TLS ULP installation
      selftests/tls: add a bidirectional test
      selftests/tls: close the socket with open record
      selftests/tls: add shutdown tests

John Fastabend (7):
      net/tls: remove close callback sock unlock/lock around TX work flush
      net/tls: remove sock unlock/lock around strp_done()
      net/tls: fix transition through disconnect with close
      bpf: sockmap, sock_map_delete needs to use xchg
      bpf: sockmap, synchronize_rcu before free'ing map
      bpf: sockmap, only create entry if ulp is not already enabled
      bpf: sockmap/tls, close can race with map free

 Documentation/networking/tls-offload.rst          |   6 +
 include/linux/filter.h                            |  13 ++
 include/linux/skmsg.h                             |   8 +-
 include/net/tcp.h                                 |   3 +
 include/net/tls.h                                 |  15 +-
 kernel/bpf/verifier.c                             |   4 +-
 net/core/filter.c                                 |   6 +-
 net/core/skmsg.c                                  |   4 +-
 net/core/sock_map.c                               |  19 ++-
 net/ipv4/tcp_ulp.c                                |  13 ++
 net/tls/tls_main.c                                | 142 ++++++++++++----
 net/tls/tls_sw.c                                  |  83 ++++++---
 tools/lib/bpf/btf.c                               |   5 +-
 tools/lib/bpf/libbpf.c                            |  34 ++--
 tools/lib/bpf/xsk.c                               |  11 +-
 tools/testing/selftests/bpf/progs/sendmsg6_prog.c |   3 +-
 tools/testing/selftests/bpf/verifier/ctx_skb.c    |  11 ++
 tools/testing/selftests/net/tls.c                 | 194 ++++++++++++++++++++++
 18 files changed, 480 insertions(+), 94 deletions(-)

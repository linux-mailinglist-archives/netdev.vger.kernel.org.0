Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD5B1CF9CA
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbgELPwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:52:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730464AbgELPwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:52:42 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04CFmGHu014697
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PvfIhdWfOZOrtP16E1ASSKrtM4pY3Vhw9fXC3Qn8mEM=;
 b=dC+KubkUYHPuEsQaYrSAQYtq1w8jRs4j6wfIphJrjuor30tOf650x/zI8aphTGRLpTFS
 sDtf2hzp0YRePGTyZL4UvUi5VjmFeHNsut2UYN21GRngr6/TXm1kvv7DvC/qLk3cFTyQ
 1mdAJjnIlvb6X9mp6RPpq1Nda6IqCBe71sw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30ws55rpq6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:41 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 08:52:40 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 59F7E370085B; Tue, 12 May 2020 08:52:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/8] tools/bpf: selftests : explain bpf_iter test failures with llvm 10.0.0
Date:   Tue, 12 May 2020 08:52:32 -0700
Message-ID: <20200512155232.1080225-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200512155232.1080167-1-yhs@fb.com>
References: <20200512155232.1080167-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_05:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 clxscore=1015 mlxscore=0 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120119
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 6879c042e105 ("tools/bpf: selftests: Add bpf_iter selftests")
added self tests for bpf_iter feature. But two subtests
ipv6_route and netlink needs llvm latest 10.x release branch
or trunk due to a bug in llvm BPF backend. This patch added
the file README.rst to document these two failures
so people using llvm 10.0.0 can be aware of them.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/README.rst | 43 ++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/README.rst

diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selft=
ests/bpf/README.rst
new file mode 100644
index 000000000000..0f67f1b470b0
--- /dev/null
+++ b/tools/testing/selftests/bpf/README.rst
@@ -0,0 +1,43 @@
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+BPF Selftest Notes
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Additional information about selftest failures are
+documented here.
+
+bpf_iter test failures with clang/llvm 10.0.0
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+With clang/llvm 10.0.0, the following two bpf_iter tests failed:
+  * ``bpf_iter/ipv6_route``
+  * ``bpf_iter/netlink``
+
+The symptom for ``bpf_iter/ipv6_route`` looks like
+
+.. code-block:: c
+
+  2: (79) r8 =3D *(u64 *)(r1 +8)
+  ...
+  14: (bf) r2 =3D r8
+  15: (0f) r2 +=3D r1
+  ; BPF_SEQ_PRINTF(seq, "%pi6 %02x ", &rt->fib6_dst.addr, rt->fib6_dst.p=
len);
+  16: (7b) *(u64 *)(r8 +64) =3D r2
+  only read is supported
+
+The symptom for ``bpf_iter/netlink`` looks like
+
+.. code-block:: c
+
+  ; struct netlink_sock *nlk =3D ctx->sk;
+  2: (79) r7 =3D *(u64 *)(r1 +8)
+  ...
+  15: (bf) r2 =3D r7
+  16: (0f) r2 +=3D r1
+  ; BPF_SEQ_PRINTF(seq, "%pK %-3d ", s, s->sk_protocol);
+  17: (7b) *(u64 *)(r7 +0) =3D r2
+  only read is supported
+
+This is due to a llvm BPF backend bug. The fix=20
+  https://reviews.llvm.org/D78466
+has been pushed to llvm 10.x release branch and will be
+available in 10.0.1. The fix is available in llvm 11.0.0 trunk.
--=20
2.24.1


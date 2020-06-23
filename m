Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5AE2067FD
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388685AbgFWXI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:08:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388649AbgFWXIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:08:25 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05NN8KGM019008
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:08:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/4xDhPiy5fzC1wpjtRxTtpWlYLIeY22qDd3lpwsSDNI=;
 b=kYVw59Uet6YAIxjMqndU4XhExiEUnTEpm7jksh9z4CxKau1fXOV8VMh/+Nm0b+AdGum+
 dPVHlZl0FiJJCygXh51rfXsTtqJgj5oao0qIxb5dwMGRiesnzvlMxH3EavTeXJt83ORQ
 6EpfK05t0V/RLQ7nqfci4QzIo5N5PJu56eE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 31utqhr3vq-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:08:24 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 16:08:20 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 013753704F8E; Tue, 23 Jun 2020 16:08:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v5 11/15] selftests/bpf: refactor some net macros to bpf_tracing_net.h
Date:   Tue, 23 Jun 2020 16:08:17 -0700
Message-ID: <20200623230817.3988962-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623230803.3987674-1-yhs@fb.com>
References: <20200623230803.3987674-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_14:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 cotscore=-2147483648 mlxscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 clxscore=1015 spamscore=0
 malwarescore=0 impostorscore=0 suspectscore=8 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor bpf_iter_ipv6_route.c and bpf_iter_netlink.c
so net macros, originally from various include/linux header
files, are moved to a new header file
bpf_tracing_net.h. The goal is to improve reuse so
networking tracing programs do not need to
copy these macros every time they use them.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/progs/bpf_iter_ipv6_route.c    |  7 +------
 .../selftests/bpf/progs/bpf_iter_netlink.c       |  4 +---
 .../selftests/bpf/progs/bpf_tracing_net.h        | 16 ++++++++++++++++
 3 files changed, 18 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_tracing_net.h

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
index 93a452d1d136..d58d9f1642b5 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
 #include "bpf_iter.h"
+#include "bpf_tracing_net.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
@@ -8,12 +9,6 @@ char _license[] SEC("license") =3D "GPL";
=20
 extern bool CONFIG_IPV6_SUBTREES __kconfig __weak;
=20
-#define RTF_GATEWAY		0x0002
-#define IFNAMSIZ		16
-#define fib_nh_gw_family	nh_common.nhc_gw_family
-#define fib_nh_gw6		nh_common.nhc_gw.ipv6
-#define fib_nh_dev		nh_common.nhc_dev
-
 SEC("iter/ipv6_route")
 int dump_ipv6_route(struct bpf_iter__ipv6_route *ctx)
 {
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c b/tools=
/testing/selftests/bpf/progs/bpf_iter_netlink.c
index fda5036fdf75..cec82a419800 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
@@ -1,14 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
 #include "bpf_iter.h"
+#include "bpf_tracing_net.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
 char _license[] SEC("license") =3D "GPL";
=20
-#define sk_rmem_alloc	sk_backlog.rmem_alloc
-#define sk_refcnt	__sk_common.skc_refcnt
-
 static inline struct inode *SOCK_INODE(struct socket *socket)
 {
 	return &container_of(socket, struct socket_alloc, socket)->vfs_inode;
diff --git a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h b/tools/=
testing/selftests/bpf/progs/bpf_tracing_net.h
new file mode 100644
index 000000000000..1f38a1098727
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+#ifndef __BPF_TRACING_NET_H__
+#define __BPF_TRACING_NET_H__
+
+#define IFNAMSIZ		16
+
+#define RTF_GATEWAY		0x0002
+
+#define fib_nh_dev		nh_common.nhc_dev
+#define fib_nh_gw_family	nh_common.nhc_gw_family
+#define fib_nh_gw6		nh_common.nhc_gw.ipv6
+
+#define sk_rmem_alloc		sk_backlog.rmem_alloc
+#define sk_refcnt		__sk_common.skc_refcnt
+
+#endif
--=20
2.24.1


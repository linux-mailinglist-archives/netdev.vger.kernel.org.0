Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0DF1D8BC1
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgERXpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:45:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34818 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726407AbgERXpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 19:45:46 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04INjiw8006593
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 16:45:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=rxDM1LiWgcvD+qiqMH2cCL9PMAEApjWmsVyyCa2bZKE=;
 b=kD1dcMsEv6bhtGhtIe1sL03qyfQsvDAyEfSj2q6c2SyljTEm1hmBlZ7GIgm9Zl/E5QjB
 taMoVhmLNP4lCBvnLpQIdsRDv1BQldLaJrUNkmfNRrul2kr6rBkcJ/U848nFaSVN0HaC
 yKszmA6En+6t0mYmRkSjAZno5b95GKrHEyY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3130euj8p5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 16:45:44 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 18 May 2020 16:45:23 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 576B02EC3778; Mon, 18 May 2020 16:45:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftest/bpf: make bpf_iter selftest compilable against old vmlinux.h
Date:   Mon, 18 May 2020 16:45:16 -0700
Message-ID: <20200518234516.3915052-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 bulkscore=0 suspectscore=8 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 cotscore=-2147483648 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180202
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's good to be able to compile bpf_iter selftest even on systems that do=
n't
have the very latest vmlinux.h, e.g., for libbpf tests against older kern=
els in
Travis CI. To that extent, re-define bpf_iter_meta and corresponding bpf_=
iter
context structs in each selftest. To avoid type clashes with vmlinux.h, r=
ename
vmlinux.h's definitions to get them out of the way.

Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/progs/bpf_iter_bpf_map.c     | 16 ++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_ipv6_route.c  | 16 ++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_netlink.c     | 16 ++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_task.c        | 16 ++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_task_file.c   | 18 ++++++++++++++++++
 .../bpf/progs/bpf_iter_test_kern_common.h      | 16 ++++++++++++++++
 6 files changed, 98 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c b/tools=
/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
index 4867cd3445c8..b57bd6fef208 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
@@ -1,11 +1,27 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
+/* "undefine" structs in vmlinux.h, because we "override" them below */
+#define bpf_iter_meta bpf_iter_meta___not_used
+#define bpf_iter__bpf_map bpf_iter__bpf_map___not_used
 #include "vmlinux.h"
+#undef bpf_iter_meta
+#undef bpf_iter__bpf_map
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
 char _license[] SEC("license") =3D "GPL";
=20
+struct bpf_iter_meta {
+	struct seq_file *seq;
+	__u64 session_id;
+	__u64 seq_num;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__bpf_map {
+	struct bpf_iter_meta *meta;
+	struct bpf_map *map;
+} __attribute__((preserve_access_index));
+
 SEC("iter/bpf_map")
 int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
 {
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
index ab9e2650e021..c8e9ca74c87b 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
@@ -1,9 +1,25 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
+/* "undefine" structs in vmlinux.h, because we "override" them below */
+#define bpf_iter_meta bpf_iter_meta___not_used
+#define bpf_iter__ipv6_route bpf_iter__ipv6_route___not_used
 #include "vmlinux.h"
+#undef bpf_iter_meta
+#undef bpf_iter__ipv6_route
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
+struct bpf_iter_meta {
+	struct seq_file *seq;
+	__u64 session_id;
+	__u64 seq_num;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__ipv6_route {
+	struct bpf_iter_meta *meta;
+	struct fib6_info *rt;
+} __attribute__((preserve_access_index));
+
 char _license[] SEC("license") =3D "GPL";
=20
 extern bool CONFIG_IPV6_SUBTREES __kconfig __weak;
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c b/tools=
/testing/selftests/bpf/progs/bpf_iter_netlink.c
index 6b40a233d4e0..e7b8753eac0b 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
@@ -1,6 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
+/* "undefine" structs in vmlinux.h, because we "override" them below */
+#define bpf_iter_meta bpf_iter_meta___not_used
+#define bpf_iter__netlink bpf_iter__netlink___not_used
 #include "vmlinux.h"
+#undef bpf_iter_meta
+#undef bpf_iter__netlink
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
@@ -9,6 +14,17 @@ char _license[] SEC("license") =3D "GPL";
 #define sk_rmem_alloc	sk_backlog.rmem_alloc
 #define sk_refcnt	__sk_common.skc_refcnt
=20
+struct bpf_iter_meta {
+	struct seq_file *seq;
+	__u64 session_id;
+	__u64 seq_num;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__netlink {
+	struct bpf_iter_meta *meta;
+	struct netlink_sock *sk;
+} __attribute__((preserve_access_index));
+
 static inline struct inode *SOCK_INODE(struct socket *socket)
 {
 	return &container_of(socket, struct socket_alloc, socket)->vfs_inode;
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task.c b/tools/te=
sting/selftests/bpf/progs/bpf_iter_task.c
index 90f9011c57ca..ee754021f98e 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_task.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task.c
@@ -1,11 +1,27 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
+/* "undefine" structs in vmlinux.h, because we "override" them below */
+#define bpf_iter_meta bpf_iter_meta___not_used
+#define bpf_iter__task bpf_iter__task___not_used
 #include "vmlinux.h"
+#undef bpf_iter_meta
+#undef bpf_iter__task
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
 char _license[] SEC("license") =3D "GPL";
=20
+struct bpf_iter_meta {
+	struct seq_file *seq;
+	__u64 session_id;
+	__u64 seq_num;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__task {
+	struct bpf_iter_meta *meta;
+	struct task_struct *task;
+} __attribute__((preserve_access_index));
+
 SEC("iter/task")
 int dump_task(struct bpf_iter__task *ctx)
 {
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_file.c b/too=
ls/testing/selftests/bpf/progs/bpf_iter_task_file.c
index c6ced38f0880..0f0ec3db20ba 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_task_file.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_file.c
@@ -1,11 +1,29 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
+/* "undefine" structs in vmlinux.h, because we "override" them below */
+#define bpf_iter_meta bpf_iter_meta___not_used
+#define bpf_iter__task_file bpf_iter__task_file___not_used
 #include "vmlinux.h"
+#undef bpf_iter_meta
+#undef bpf_iter__task_file
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
 char _license[] SEC("license") =3D "GPL";
=20
+struct bpf_iter_meta {
+	struct seq_file *seq;
+	__u64 session_id;
+	__u64 seq_num;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__task_file {
+	struct bpf_iter_meta *meta;
+	struct task_struct *task;
+	__u32 fd;
+	struct file *file;
+} __attribute__((preserve_access_index));
+
 SEC("iter/task_file")
 int dump_task_file(struct bpf_iter__task_file *ctx)
 {
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.=
h b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
index bdd51cf14b54..dee1339e6905 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
@@ -1,11 +1,27 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (c) 2020 Facebook */
+/* "undefine" structs in vmlinux.h, because we "override" them below */
+#define bpf_iter_meta bpf_iter_meta___not_used
+#define bpf_iter__task bpf_iter__task___not_used
 #include "vmlinux.h"
+#undef bpf_iter_meta
+#undef bpf_iter__task
 #include <bpf/bpf_helpers.h>
=20
 char _license[] SEC("license") =3D "GPL";
 int count =3D 0;
=20
+struct bpf_iter_meta {
+	struct seq_file *seq;
+	__u64 session_id;
+	__u64 seq_num;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__task {
+	struct bpf_iter_meta *meta;
+	struct task_struct *task;
+} __attribute__((preserve_access_index));
+
 SEC("iter/task")
 int dump_task(struct bpf_iter__task *ctx)
 {
--=20
2.24.1


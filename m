Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0841DA0F5
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgESTYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:24:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46720 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbgESTYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:24:08 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04JJNcZ7008119
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 12:24:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=JYvQGkyd0h1cyUW1PFBkm37Q7xBmDjShcSctWenRTDU=;
 b=EQG+QR8Z9QRdlD3ei6zAJOdpJTcToIq+G2y2ugvoYt30FQyFXFJhOWnXKcjZEUIjrP1O
 FOwmh+KBJNRqyU+M6riGMCFxp0hQqddF72hnxs04a7BXRdLX/I2o971ikzmlOSFBnIPH
 V56YW+VejZzP37o4j/HhurGiqdVTiI5fnOo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3130euwwur-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 12:24:07 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 19 May 2020 12:23:45 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DBED02EC2A0B; Tue, 19 May 2020 12:23:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: convert bpf_iter_test_kern{3,4}.c to define own bpf_iter_meta
Date:   Tue, 19 May 2020 12:23:41 -0700
Message-ID: <20200519192341.134360-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-19_08:2020-05-19,2020-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 bulkscore=0 suspectscore=8 mlxlogscore=982
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 cotscore=-2147483648 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

b9f4c01f3e0b ("selftest/bpf: Make bpf_iter selftest compilable against ol=
d vmlinux.h")
missed the fact that bpf_iter_test_kern{3,4}.c are not just including
bpf_iter_test_kern_common.h and need similar bpf_iter_meta re-definition
explicitly.

Fixes: b9f4c01f3e0b ("selftest/bpf: Make bpf_iter selftest compilable aga=
inst old vmlinux.h")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/progs/bpf_iter_test_kern3.c     | 15 +++++++++++++++
 .../selftests/bpf/progs/bpf_iter_test_kern4.c     | 15 +++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
index 636a00fa074d..13c2c90c835f 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
@@ -1,10 +1,25 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
+#define bpf_iter_meta bpf_iter_meta___not_used
+#define bpf_iter__task bpf_iter__task___not_used
 #include "vmlinux.h"
+#undef bpf_iter_meta
+#undef bpf_iter__task
 #include <bpf/bpf_helpers.h>
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
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
index b18dc0471d07..0aa71b333cf3 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
@@ -1,10 +1,25 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
+#define bpf_iter_meta bpf_iter_meta___not_used
+#define bpf_iter__bpf_map bpf_iter__bpf_map___not_used
 #include "vmlinux.h"
+#undef bpf_iter_meta
+#undef bpf_iter__bpf_map
 #include <bpf/bpf_helpers.h>
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
 __u32 map1_id =3D 0, map2_id =3D 0;
 __u32 map1_accessed =3D 0, map2_accessed =3D 0;
 __u64 map1_seqnum =3D 0, map2_seqnum1 =3D 0, map2_seqnum2 =3D 0;
--=20
2.24.1


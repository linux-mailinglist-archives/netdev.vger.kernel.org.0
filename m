Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D089D1B6E00
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 08:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgDXGSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 02:18:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56058 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726613AbgDXGSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 02:18:12 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O6GV7R019402
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 23:18:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=bjveWCdDXoEAAMheK+U9dz/xeUB0LejzHFo0PpTJyPI=;
 b=OB+7BelTcRCUqJJ2qfRhZTW3ZZloM9kgyeFICpTrGQYeRdejVJxJ/ebIhyoUURFNtp15
 8EQLTjHtcFCogbs5HUyTxtay/kmeCUM9HldaVjbVeK843EmegFWG+u0H97++fITYKpL/
 dHVuCJr2aJv4GMoIy1SSHm2MDqNBbigSem8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30keb14m96-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 23:18:11 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 23 Apr 2020 23:18:08 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id A9C8662E4C20; Thu, 23 Apr 2020 23:18:04 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Date:   Thu, 23 Apr 2020 23:17:55 -0700
Message-ID: <20200424061755.436559-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200424061755.436559-1-songliubraving@fb.com>
References: <20200424061755.436559-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_01:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004240047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test for  BPF_ENABLE_STATS, which should enable run_time_ns stats.

~/selftests/bpf# ./test_progs -t enable_stats  -v
test_enable_stats:PASS:skel_open_and_load 0 nsec
test_enable_stats:PASS:get_stats_fd 0 nsec
test_enable_stats:PASS:attach_raw_tp 0 nsec
test_enable_stats:PASS:get_prog_info 0 nsec
test_enable_stats:PASS:check_stats_enabled 0 nsec
Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/enable_stats.c   | 45 +++++++++++++++++++
 .../selftests/bpf/progs/test_enable_stats.c   | 28 ++++++++++++
 2 files changed, 73 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c

diff --git a/tools/testing/selftests/bpf/prog_tests/enable_stats.c b/tool=
s/testing/selftests/bpf/prog_tests/enable_stats.c
new file mode 100644
index 000000000000..987fc743ab75
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <sys/mman.h>
+#include "test_enable_stats.skel.h"
+
+void test_enable_stats(void)
+{
+	struct test_enable_stats *skel;
+	struct bpf_prog_info info =3D {};
+	__u32 info_len =3D sizeof(info);
+	int stats_fd, err, prog_fd;
+	int duration =3D 0;
+
+	skel =3D test_enable_stats__open_and_load();
+
+	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
+		return;
+
+	stats_fd =3D bpf_enable_stats(BPF_STATS_RUNTIME_CNT);
+
+	if (CHECK(stats_fd < 0, "get_stats_fd", "failed %d\n", errno))
+		goto cleanup;
+
+	err =3D test_enable_stats__attach(skel);
+
+	if (CHECK(err, "attach_raw_tp", "err %d\n", err))
+		goto cleanup;
+
+	usleep(1000);
+
+	prog_fd =3D bpf_program__fd(skel->progs.test_enable_stats);
+	err =3D bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
+
+	if (CHECK(err, "get_prog_info",
+		  "failed to get bpf_prog_info for fd %d\n", prog_fd))
+		goto cleanup;
+
+	CHECK(info.run_time_ns =3D=3D 0, "check_stats_enabled",
+	      "failed to enable run_time_ns stats\n");
+
+cleanup:
+	test_enable_stats__destroy(skel);
+	if (stats_fd >=3D 0)
+		close(stats_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_enable_stats.c b/tool=
s/testing/selftests/bpf/progs/test_enable_stats.c
new file mode 100644
index 000000000000..f95ac0c94639
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_enable_stats.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} count SEC(".maps");
+
+SEC("raw_tracepoint/sys_enter")
+int test_enable_stats(void *ctx)
+{
+	__u32 key =3D 0;
+	__u64 *val;
+
+	val =3D bpf_map_lookup_elem(&count, &key);
+	if (val)
+		*val +=3D 1;
+
+	return 0;
+}
--=20
2.24.1


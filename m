Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB6C1BD4F1
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgD2Gpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:45:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726484AbgD2Gpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:45:53 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03T6gDk3021868
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 23:45:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=DKBxrfP7QrFLMaAvW/P1IAweGTUE0GViVi3cNidjq/Y=;
 b=LuQZsJTa5fsTSaMpTZLJYFffNbqoi6B1NPtL96Ttcfg95700W/2AWG1u6mrzDlKHkM7A
 Yua/AOUPbeJwJkS5pu6pFRBg/YqoHRKuvqlCeiLZsXkRR9HmUhNpCQ9KDiY8ktjgehKY
 6xHiZ+3DqPyEKRdIBE1s0M0gV63STZjTmMA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30mgvnsv49-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 23:45:52 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 23:45:51 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 688C862E4C2D; Tue, 28 Apr 2020 23:45:51 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v8 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Date:   Tue, 28 Apr 2020 23:45:43 -0700
Message-ID: <20200429064543.634465-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429064543.634465-1-songliubraving@fb.com>
References: <20200429064543.634465-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_02:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=8 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test for BPF_ENABLE_STATS, which should enable run_time_ns stats.

~/selftests/bpf# ./test_progs -t enable_stats  -v
test_enable_stats:PASS:skel_open_and_load 0 nsec
test_enable_stats:PASS:get_stats_fd 0 nsec
test_enable_stats:PASS:attach_raw_tp 0 nsec
test_enable_stats:PASS:get_prog_info 0 nsec
test_enable_stats:PASS:check_stats_enabled 0 nsec
test_enable_stats:PASS:check_run_cnt_valid 0 nsec
Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/enable_stats.c   | 46 +++++++++++++++++++
 .../selftests/bpf/progs/test_enable_stats.c   | 18 ++++++++
 2 files changed, 64 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c

diff --git a/tools/testing/selftests/bpf/prog_tests/enable_stats.c b/tool=
s/testing/selftests/bpf/prog_tests/enable_stats.c
new file mode 100644
index 000000000000..cb5e34dcfd42
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <sys/mman.h>
+#include "test_enable_stats.skel.h"
+
+void test_enable_stats(void)
+{
+	struct test_enable_stats *skel;
+	int stats_fd, err, prog_fd;
+	struct bpf_prog_info info;
+	__u32 info_len =3D sizeof(info);
+	int duration =3D 0;
+
+	skel =3D test_enable_stats__open_and_load();
+	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
+		return;
+
+	stats_fd =3D bpf_enable_stats(BPF_STATS_RUN_TIME);
+	if (CHECK(stats_fd < 0, "get_stats_fd", "failed %d\n", errno)) {
+		test_enable_stats__destroy(skel);
+		return;
+	}
+
+	err =3D test_enable_stats__attach(skel);
+	if (CHECK(err, "attach_raw_tp", "err %d\n", err))
+		goto cleanup;
+
+	test_enable_stats__detach(skel);
+
+	prog_fd =3D bpf_program__fd(skel->progs.test_enable_stats);
+	memset(&info, 0, info_len);
+	err =3D bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
+	if (CHECK(err, "get_prog_info",
+		  "failed to get bpf_prog_info for fd %d\n", prog_fd))
+		goto cleanup;
+	if (CHECK(info.run_time_ns =3D=3D 0, "check_stats_enabled",
+		  "failed to enable run_time_ns stats\n"))
+		goto cleanup;
+
+	CHECK(info.run_cnt !=3D skel->bss->count, "check_run_cnt_valid",
+	      "invalid run_cnt stats\n");
+
+cleanup:
+	test_enable_stats__destroy(skel);
+	close(stats_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_enable_stats.c b/tool=
s/testing/selftests/bpf/progs/test_enable_stats.c
new file mode 100644
index 000000000000..dfd987e4ede4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_enable_stats.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <linux/types.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+static __u64 count;
+
+SEC("raw_tracepoint/sys_enter")
+int test_enable_stats(void *ctx)
+{
+	count +=3D 1;
+	return 0;
+}
--=20
2.24.1


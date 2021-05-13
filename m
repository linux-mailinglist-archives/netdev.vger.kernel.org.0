Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4747D3800EE
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhEMXiB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 May 2021 19:38:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33292 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230003AbhEMXh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 19:37:59 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14DNUJ76004062
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 16:36:49 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38gj9r19q1-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 16:36:49 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 13 May 2021 16:36:47 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5CF122ED8CFC; Thu, 13 May 2021 16:36:45 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 1/2] selftests/bpf: validate skeleton gen handles skipped fields
Date:   Thu, 13 May 2021 16:36:42 -0700
Message-ID: <20210513233643.194711-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: b_zah8CquqCnQR5bwE1OHyL0_zKhVimk
X-Proofpoint-ORIG-GUID: b_zah8CquqCnQR5bwE1OHyL0_zKhVimk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_16:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=997 suspectscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130166
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust static_linked selftests to test a mix of global and static variables
and their handling of bpftool's skeleton generation code.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/static_linked.c  | 4 ++--
 tools/testing/selftests/bpf/progs/linked_maps1.c        | 2 +-
 tools/testing/selftests/bpf/progs/test_static_linked1.c | 2 +-
 tools/testing/selftests/bpf/progs/test_static_linked2.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/static_linked.c b/tools/testing/selftests/bpf/prog_tests/static_linked.c
index ab6acbaf9d8c..5c4e3014e063 100644
--- a/tools/testing/selftests/bpf/prog_tests/static_linked.c
+++ b/tools/testing/selftests/bpf/prog_tests/static_linked.c
@@ -27,8 +27,8 @@ void test_static_linked(void)
 	/* trigger */
 	usleep(1);
 
-	ASSERT_EQ(skel->bss->var1, 1 * 2 + 2 + 3, "var1");
-	ASSERT_EQ(skel->bss->var2, 4 * 3 + 5 + 6, "var2");
+	ASSERT_EQ(skel->data->var1, 1 * 2 + 2 + 3, "var1");
+	ASSERT_EQ(skel->data->var2, 4 * 3 + 5 + 6, "var2");
 
 cleanup:
 	test_static_linked__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/linked_maps1.c b/tools/testing/selftests/bpf/progs/linked_maps1.c
index 52291515cc72..00bf1ca95986 100644
--- a/tools/testing/selftests/bpf/progs/linked_maps1.c
+++ b/tools/testing/selftests/bpf/progs/linked_maps1.c
@@ -75,7 +75,7 @@ int BPF_PROG(handler_exit1)
 	val = bpf_map_lookup_elem(&map_weak, &key);
 	if (val)
 		output_weak1 = *val;
-	
+
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/test_static_linked1.c b/tools/testing/selftests/bpf/progs/test_static_linked1.c
index cae304045d9c..4f0b612e1661 100644
--- a/tools/testing/selftests/bpf/progs/test_static_linked1.c
+++ b/tools/testing/selftests/bpf/progs/test_static_linked1.c
@@ -7,7 +7,7 @@
 /* 8-byte aligned .data */
 static volatile long static_var1 = 2;
 static volatile int static_var2 = 3;
-int var1 = 0;
+int var1 = -1;
 /* 4-byte aligned .rodata */
 const volatile int rovar1;
 
diff --git a/tools/testing/selftests/bpf/progs/test_static_linked2.c b/tools/testing/selftests/bpf/progs/test_static_linked2.c
index c54c4e865ed8..766ebd502a60 100644
--- a/tools/testing/selftests/bpf/progs/test_static_linked2.c
+++ b/tools/testing/selftests/bpf/progs/test_static_linked2.c
@@ -7,7 +7,7 @@
 /* 4-byte aligned .data */
 static volatile int static_var1 = 5;
 static volatile int static_var2 = 6;
-int var2 = 0;
+int var2 = -1;
 /* 8-byte aligned .rodata */
 const volatile long rovar2;
 
-- 
2.30.2


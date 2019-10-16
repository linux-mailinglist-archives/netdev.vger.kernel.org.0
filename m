Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C572ED883A
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 07:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387750AbfJPFuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 01:50:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23012 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387651AbfJPFuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 01:50:08 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9G5o4gX016639
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 22:50:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=oizi4oVIdlxaidx2VLVSt4SmZFSNCs4V5hewPc/PFkc=;
 b=Ns3lG3caIcE60WnSpycj7zLYPDxa6N9X+aLJ65svs3ugZdoWkgFF7xka7ggAZKUdftxo
 wNOMZWIGt6+ExcV2TFcfzio0lm2dgPnLS5jzxKP8MnXpmC59sjP9CWA0IwUDw56vTKe2
 yI1yG31gqi/D3oydVbkKHSULly1q/JVCltA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnf1wm20m-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 22:50:07 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 15 Oct 2019 22:49:55 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 98DA286193C; Tue, 15 Oct 2019 22:49:54 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 3/7] selftests/bpf: switch test_maps to test_progs' test.h format
Date:   Tue, 15 Oct 2019 22:49:41 -0700
Message-ID: <20191016054945.1988387-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016054945.1988387-1-andriin@fb.com>
References: <20191016054945.1988387-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_02:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=949 priorityscore=1501 suspectscore=8 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make test_maps use tests.h header format consistent with the one used by
test_progs, to facilitate unification.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile    | 8 +-------
 tools/testing/selftests/bpf/test_maps.c | 8 ++++----
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 00d05c5e2d57..5f97262e5fcb 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -249,14 +249,8 @@ $(OUTPUT)/test_maps: test_maps.c $(MAP_TESTS_FILES) | $(MAP_TESTS_H)
 $(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
 	$(shell ( cd map_tests/; \
 		  echo '/* Generated header, do not edit */'; \
-		  echo '#ifdef DECLARE'; \
 		  ls *.c 2> /dev/null | \
-			sed -e 's@\([^\.]*\)\.c@extern void test_\1(void);@'; \
-		  echo '#endif'; \
-		  echo '#ifdef CALL'; \
-		  ls *.c 2> /dev/null | \
-			sed -e 's@\([^\.]*\)\.c@test_\1();@'; \
-		  echo '#endif' \
+			sed -e 's@\([^\.]*\)\.c@DEFINE_TEST(\1)@'; \
 		 ) > $(MAP_TESTS_H))
 
 VERIFIER_TESTS_DIR = $(OUTPUT)/verifier
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index e1f1becda529..806b298397d3 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -1717,9 +1717,9 @@ static void run_all_tests(void)
 	test_map_in_map();
 }
 
-#define DECLARE
+#define DEFINE_TEST(name) extern void test_##name(void);
 #include <map_tests/tests.h>
-#undef DECLARE
+#undef DEFINE_TEST
 
 int main(void)
 {
@@ -1731,9 +1731,9 @@ int main(void)
 	map_flags = BPF_F_NO_PREALLOC;
 	run_all_tests();
 
-#define CALL
+#define DEFINE_TEST(name) test_##name();
 #include <map_tests/tests.h>
-#undef CALL
+#undef DEFINE_TEST
 
 	printf("test_maps: OK, %d SKIPPED\n", skips);
 	return 0;
-- 
2.17.1


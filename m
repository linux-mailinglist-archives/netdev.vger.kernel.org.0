Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45BD6AFF8
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388697AbfGPTit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:38:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44262 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728518AbfGPTis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 15:38:48 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GJc8Gm003557
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 12:38:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=jse4qdAs8+qPCz3lu4vB+jWsVxQyuRw+JMdBkNPQvQE=;
 b=bPhDyUnnUoxw0cLzYiblh+7QpSFdEj0IeJO51A6nkx1TULL7wDEkrBdFJ4GeDcNFN5du
 RurRvvNJAOVtOGMk8yp9F5DfQlrOcyV4aimzTkMCNa3PkLt5A/cADSwfcgbzeyTPf5xB
 rTmb3sHUMfSpgBSX3mIy1SRPIHCAg2YgTK0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tsj89rn9e-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 12:38:47 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 16 Jul 2019 12:38:46 -0700
Received: by devvm1662.vll1.facebook.com (Postfix, from userid 137359)
        id 114A713432D6; Tue, 16 Jul 2019 12:38:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devvm1662.vll1.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH bpf 1/2] selftests/bpf: fix test_verifier/test_maps make dependencies
Date:   Tue, 16 Jul 2019 12:38:36 -0700
Message-ID: <20190716193837.2808971-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=958 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160240
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

e46fc22e60a4 ("selftests/bpf: make directory prerequisites order-only")
exposed existing problem in Makefile for test_verifier and test_maps tests:
their dependency on auto-generated header file with a list of all tests wasn't
recorded explicitly. This patch fixes these issues.

Fixes: 51a0e301a563 ("bpf: Add BPF_MAP_TYPE_SK_STORAGE test to test_maps")
Fixes: 6b7b6995c43e ("selftests: bpf: tests.h should depend on .c files, not the output")
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1296253b3422..9bc68d8abc5f 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -86,8 +86,6 @@ $(OUTPUT)/urandom_read: $(OUTPUT)/%: %.c
 $(OUTPUT)/test_stub.o: test_stub.c
 	$(CC) $(TEST_PROGS_CFLAGS) $(CFLAGS) -c -o $@ $<
 
-$(OUTPUT)/test_maps: map_tests/*.c
-
 BPFOBJ := $(OUTPUT)/libbpf.a
 
 $(TEST_GEN_PROGS): $(OUTPUT)/test_stub.o $(BPFOBJ)
@@ -257,9 +255,10 @@ MAP_TESTS_DIR = $(OUTPUT)/map_tests
 $(MAP_TESTS_DIR):
 	mkdir -p $@
 MAP_TESTS_H := $(MAP_TESTS_DIR)/tests.h
+MAP_TESTS_FILES := $(wildcard map_tests/*.c)
 test_maps.c: $(MAP_TESTS_H)
 $(OUTPUT)/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
-MAP_TESTS_FILES := $(wildcard map_tests/*.c)
+$(OUTPUT)/test_maps: test_maps.c $(MAP_TESTS_H) $(MAP_TESTS_FILES)
 $(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
 	$(shell ( cd map_tests/; \
 		  echo '/* Generated header, do not edit */'; \
@@ -276,6 +275,7 @@ $(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
 VERIFIER_TESTS_H := $(OUTPUT)/verifier/tests.h
 test_verifier.c: $(VERIFIER_TESTS_H)
 $(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)
+$(OUTPUT)/test_verifier: test_verifier.c $(VERIFIER_TESTS_H)
 
 VERIFIER_TESTS_DIR = $(OUTPUT)/verifier
 $(VERIFIER_TESTS_DIR):
-- 
2.17.1


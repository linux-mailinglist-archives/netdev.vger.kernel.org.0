Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FE825CAE7
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgICUgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:36:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11690 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729173AbgICUgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 16:36:11 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 083KYptm010245
        for <netdev@vger.kernel.org>; Thu, 3 Sep 2020 13:36:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0gj9ZEeX+SuwYYReXFv2KjTWVNIWQdZGMmhlRg5e800=;
 b=XvZFMhs2dZ+Nc2Mb9AM5ayzUJDhoeybW8IM97qjZUEIwXLhPctktSyuhaA290EEnR1wh
 dG/KPLCHL+RkrgxoyuFzF/TClGnVPHfsTNppPHhThNSCWfU3041dFe/NnGz+0/C3G2ui
 1IkctOd54/hbtHoQF/k0uVB4BCfTZtUlKzY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33b2hesy1n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 13:36:10 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Sep 2020 13:36:07 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4E2282EC6814; Thu,  3 Sep 2020 13:36:07 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v3 bpf-next 11/14] selftests/bpf: turn fexit_bpf2bpf into test with subtests
Date:   Thu, 3 Sep 2020 13:35:39 -0700
Message-ID: <20200903203542.15944-12-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200903203542.15944-1-andriin@fb.com>
References: <20200903203542.15944-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_13:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 mlxlogscore=864 mlxscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are clearly 4 subtests, so make it official.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/too=
ls/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index a550dab9ba7a..eda682727787 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -208,11 +208,18 @@ static void test_func_map_prog_compatibility(void)
=20
 void test_fexit_bpf2bpf(void)
 {
-	test_target_no_callees();
-	test_target_yes_callees();
-	test_func_replace();
-	test_func_replace_verify();
-	test_func_sockmap_update();
-	test_func_replace_return_code();
-	test_func_map_prog_compatibility();
+	if (test__start_subtest("target_no_callees"))
+		test_target_no_callees();
+	if (test__start_subtest("target_yes_callees"))
+		test_target_yes_callees();
+	if (test__start_subtest("func_replace"))
+		test_func_replace();
+	if (test__start_subtest("func_replace_verify"))
+		test_func_replace_verify();
+	if (test__start_subtest("func_sockmap_update"))
+		test_func_sockmap_update();
+	if (test__start_subtest("func_replace_return_code"))
+		test_func_replace_return_code();
+	if (test__start_subtest("func_map_prog_compatibility"))
+		test_func_map_prog_compatibility();
 }
--=20
2.24.1


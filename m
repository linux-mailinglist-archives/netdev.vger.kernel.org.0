Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098ED258570
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 03:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgIABuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 21:50:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32534 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726501AbgIABuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 21:50:35 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0811n4GI000624
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0gj9ZEeX+SuwYYReXFv2KjTWVNIWQdZGMmhlRg5e800=;
 b=Q7hPdgXV1M4dj+paWgbuIAuKiDcGLsze3M+Qb4C+zngLyd9DTJ0V92vcNUGgzvb6+tYY
 LT3wCH4wy361cTTIQjVMD+Deg+qfWNNBitJdEWoKsEwDtzd/1Vg/0adwnRE2mpZ+Ke4t
 qEdPATlJPVIluE9/eg4kP64So9eKMIOOs3E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3386ukg2e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:34 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 18:50:33 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 634C72EC663B; Mon, 31 Aug 2020 18:50:29 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 11/14] selftests/bpf: turn fexit_bpf2bpf into test with subtests
Date:   Mon, 31 Aug 2020 18:50:00 -0700
Message-ID: <20200901015003.2871861-12-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200901015003.2871861-1-andriin@fb.com>
References: <20200901015003.2871861-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_01:2020-08-31,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 mlxlogscore=868 suspectscore=8 clxscore=1015
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010014
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


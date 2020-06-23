Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED48F20570C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733080AbgFWQSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:18:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40608 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733067AbgFWQSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:18:30 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05NG8JpA010630
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=GvZxXTAJ14WkX/SiXlPuXYHlUeACjSRc+0ivmicJW7c=;
 b=KwcVSCau5n8uy/NXHGdrlQ0R+JCjE934Ry6u3Y7Lrm1aY/gDRX6EPk6l3cWU0KbkxkkX
 CrpU56WFU2p41i0fW8meTJDfdZRATavLdXjFhZtts/9fcaPBUiefyz7mU2Vfi/UTHgQK
 iyENde3vA+C1je6JZmixAMj/mO3/8dZ0yK0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 31uk100qnu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:29 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 09:18:13 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 0FEB93701557; Tue, 23 Jun 2020 09:18:08 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 15/15] selftests/bpf: add tcp/udp iterator programs to selftests
Date:   Tue, 23 Jun 2020 09:18:08 -0700
Message-ID: <20200623161808.2502077-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623161749.2500196-1-yhs@fb.com>
References: <20200623161749.2500196-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_10:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added tcp{4,6} and udp{4,6} bpf programs into test_progs
selftest so that they at least can load successfully.
  $ ./test_progs -n 3
  ...
  #3/7 tcp4:OK
  #3/8 tcp6:OK
  #3/9 udp4:OK
  #3/10 udp6:OK
  ...
  #3 bpf_iter:OK
  Summary: 1/16 PASSED, 0 SKIPPED, 0 FAILED

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
index 87c29dde1cf9..1e2e0fced6e8 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -6,6 +6,10 @@
 #include "bpf_iter_bpf_map.skel.h"
 #include "bpf_iter_task.skel.h"
 #include "bpf_iter_task_file.skel.h"
+#include "bpf_iter_tcp4.skel.h"
+#include "bpf_iter_tcp6.skel.h"
+#include "bpf_iter_udp4.skel.h"
+#include "bpf_iter_udp6.skel.h"
 #include "bpf_iter_test_kern1.skel.h"
 #include "bpf_iter_test_kern2.skel.h"
 #include "bpf_iter_test_kern3.skel.h"
@@ -120,6 +124,62 @@ static void test_task_file(void)
 	bpf_iter_task_file__destroy(skel);
 }
=20
+static void test_tcp4(void)
+{
+	struct bpf_iter_tcp4 *skel;
+
+	skel =3D bpf_iter_tcp4__open_and_load();
+	if (CHECK(!skel, "bpf_iter_tcp4__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_tcp4);
+
+	bpf_iter_tcp4__destroy(skel);
+}
+
+static void test_tcp6(void)
+{
+	struct bpf_iter_tcp6 *skel;
+
+	skel =3D bpf_iter_tcp6__open_and_load();
+	if (CHECK(!skel, "bpf_iter_tcp6__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_tcp6);
+
+	bpf_iter_tcp6__destroy(skel);
+}
+
+static void test_udp4(void)
+{
+	struct bpf_iter_udp4 *skel;
+
+	skel =3D bpf_iter_udp4__open_and_load();
+	if (CHECK(!skel, "bpf_iter_udp4__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_udp4);
+
+	bpf_iter_udp4__destroy(skel);
+}
+
+static void test_udp6(void)
+{
+	struct bpf_iter_udp6 *skel;
+
+	skel =3D bpf_iter_udp6__open_and_load();
+	if (CHECK(!skel, "bpf_iter_udp6__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_udp6);
+
+	bpf_iter_udp6__destroy(skel);
+}
+
 /* The expected string is less than 16 bytes */
 static int do_read_with_fd(int iter_fd, const char *expected,
 			   bool read_one_char)
@@ -394,6 +454,14 @@ void test_bpf_iter(void)
 		test_task();
 	if (test__start_subtest("task_file"))
 		test_task_file();
+	if (test__start_subtest("tcp4"))
+		test_tcp4();
+	if (test__start_subtest("tcp6"))
+		test_tcp6();
+	if (test__start_subtest("udp4"))
+		test_udp4();
+	if (test__start_subtest("udp6"))
+		test_udp6();
 	if (test__start_subtest("anon"))
 		test_anon_iter(false);
 	if (test__start_subtest("anon-read-one-char"))
--=20
2.24.1


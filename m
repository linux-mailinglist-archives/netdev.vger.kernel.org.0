Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347CD25CAE8
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbgICUga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:36:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48430 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729544AbgICUgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 16:36:16 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 083KYpCV010265
        for <netdev@vger.kernel.org>; Thu, 3 Sep 2020 13:36:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Us9yAaCT4hpzumcOhTKpzAwbr2VYiTQNPgezAz9tOik=;
 b=HYR8dFzJQ5JIh3xW7v4bBd+h5J/foHPcwmwzydmWQLsFX3H28+EEGBmKbBc2a77pa9GH
 A7m0YIG2rOndnyOjWwxD9o20nW02BYK8Qyxlw+xBHOWd9BplNg4i6LzTlLyjckMUdZu8
 0+Tam4azrJeseNnLtEhN3dP0LoxM+EY97v0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33b2hesy1j-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 13:36:15 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Sep 2020 13:36:10 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E37E82EC6814; Thu,  3 Sep 2020 13:36:02 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v3 bpf-next 09/14] selftests/bpf: don't use deprecated libbpf APIs
Date:   Thu, 3 Sep 2020 13:35:37 -0700
Message-ID: <20200903203542.15944-10-andriin@fb.com>
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
 mlxlogscore=999 mlxscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove all uses of bpf_program__title() and
bpf_program__find_program_by_title().

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/flow_dissector_load.h         | 8 +++++++-
 .../testing/selftests/bpf/prog_tests/reference_tracking.c | 2 +-
 tools/testing/selftests/bpf/test_socket_cookie.c          | 2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/flow_dissector_load.h b/tools/te=
sting/selftests/bpf/flow_dissector_load.h
index daeaeb518894..7290401ec172 100644
--- a/tools/testing/selftests/bpf/flow_dissector_load.h
+++ b/tools/testing/selftests/bpf/flow_dissector_load.h
@@ -23,7 +23,13 @@ static inline int bpf_flow_load(struct bpf_object **ob=
j,
 	if (ret)
 		return ret;
=20
-	main_prog =3D bpf_object__find_program_by_title(*obj, section_name);
+	main_prog =3D NULL;
+	bpf_object__for_each_program(prog, *obj) {
+		if (strcmp(section_name, bpf_program__section_name(prog)) =3D=3D 0) {
+			main_prog =3D prog;
+			break;
+		}
+	}
 	if (!main_prog)
 		return -1;
=20
diff --git a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c =
b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
index fc0d7f4f02cf..ac1ee10cffd8 100644
--- a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
+++ b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
@@ -27,7 +27,7 @@ void test_reference_tracking(void)
 		const char *title;
=20
 		/* Ignore .text sections */
-		title =3D bpf_program__title(prog, false);
+		title =3D bpf_program__section_name(prog);
 		if (strstr(title, ".text") !=3D NULL)
 			continue;
=20
diff --git a/tools/testing/selftests/bpf/test_socket_cookie.c b/tools/tes=
ting/selftests/bpf/test_socket_cookie.c
index 154a8fd2a48d..ca7ca87e91aa 100644
--- a/tools/testing/selftests/bpf/test_socket_cookie.c
+++ b/tools/testing/selftests/bpf/test_socket_cookie.c
@@ -151,7 +151,7 @@ static int run_test(int cgfd)
 	}
=20
 	bpf_object__for_each_program(prog, pobj) {
-		prog_name =3D bpf_program__title(prog, /*needs_copy*/ false);
+		prog_name =3D bpf_program__section_name(prog);
=20
 		if (libbpf_attach_type_by_name(prog_name, &attach_type))
 			goto err;
--=20
2.24.1


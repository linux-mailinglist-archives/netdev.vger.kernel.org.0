Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7457014FC04
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 07:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgBBGwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 01:52:12 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65016 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726550AbgBBGwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 01:52:12 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0126nDrU006640
        for <netdev@vger.kernel.org>; Sat, 1 Feb 2020 22:52:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=6RlqJId2gCEvf7lAyFLxjnPyGOhROSpW91nDclclOEo=;
 b=nipHvFPbZt/xFHISoiHlhU58TCGDMIchSWgZ480e8Hd1R2Y9NvcAmXL/eDCqRUqMhrkp
 1GwG3aLZIk/XRg2dmARvueIzPNRcucZottVlQNcqBxby5LDOPUjATRhAp1+o4vdrNW/x
 yjVIuQmTgb/cKcTdzLz3TGvEYuwtjqR1q2Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xw9h02ayy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 22:52:11 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 1 Feb 2020 22:52:10 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A9AE42EC2504; Sat,  1 Feb 2020 22:51:59 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] selftests/bpf: fix trampoline_count.c selftest compilation warning
Date:   Sat, 1 Feb 2020 22:51:52 -0800
Message-ID: <20200202065152.2718142-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-01_08:2020-01-31,2020-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 suspectscore=8 spamscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 bulkscore=0 mlxlogscore=900
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002020055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix missing braces compilation warning in trampoline_count test:

  .../prog_tests/trampoline_count.c: In function =E2=80=98test_trampoline=
_count=E2=80=99:
  .../prog_tests/trampoline_count.c:49:9: warning: missing braces around =
initializer [-Wmissing-braces]
  struct inst inst[MAX_TRAMP_PROGS] =3D { 0 };
         ^
  .../prog_tests/trampoline_count.c:49:9: warning: (near initialization f=
or =E2=80=98inst[0]=E2=80=99) [-Wmissing-braces]

Fixes: d633d57902a5 ("selftest/bpf: Add test for allowed trampolines coun=
t")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/trampoline_count.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/=
tools/testing/selftests/bpf/prog_tests/trampoline_count.c
index 1235f3d1cc50..1f6ccdaed1ac 100644
--- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
+++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
@@ -46,7 +46,7 @@ void test_trampoline_count(void)
 	const char *fentry_name =3D "fentry/__set_task_comm";
 	const char *fexit_name =3D "fexit/__set_task_comm";
 	const char *object =3D "test_trampoline_count.o";
-	struct inst inst[MAX_TRAMP_PROGS] =3D { 0 };
+	struct inst inst[MAX_TRAMP_PROGS] =3D {};
 	int err, i =3D 0, duration =3D 0;
 	struct bpf_object *obj;
 	struct bpf_link *link;
--=20
2.17.1


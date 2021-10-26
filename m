Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4404F43A91C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 02:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbhJZAKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 20:10:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4578 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235472AbhJZAKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 20:10:03 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 19PMiU7Y027675
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 17:07:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Boibk+L3fz3EqHA4e82wKA53nXYv+eNyHk8OhI+7NIk=;
 b=UnZ8pOW0r1gWApKHySsZq4zAKX4TG3Y1AYsD3yCpXiuAFz+i2lSxhdiVWFIhKbudPjQq
 TlAjSRVaA23UY2P5cdkPtveb+3n6Mg/EXkoV9VRWn5oUkmskNQ4kGDWwUZ2YY7BF0HUe
 YaArbDAEA0FwrvAqWT4W1TFOmrRS2U9s66E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3bx4fcgxrv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 17:07:40 -0700
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 25 Oct 2021 17:07:38 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id A92631ADA6825; Mon, 25 Oct 2021 17:07:36 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next] selftests/bpf: Skip all serial_test_get_branch_snapshot in vm
Date:   Mon, 25 Oct 2021 17:07:33 -0700
Message-ID: <20211026000733.477714-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: tMAr9bCXe2spRqPBwhd_MpDMMeqTOC5u
X-Proofpoint-GUID: tMAr9bCXe2spRqPBwhd_MpDMMeqTOC5u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_07,2021-10-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 impostorscore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=985 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110250138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Skipping the second half of the test is not enough to silent the warning
in dmesg. Skip the whole test before we can either properly silent the
warning in kernel, or fix LBR snapshot for VM.

Fixes: 025bd7c753aa ("selftests/bpf: Add test for bpf_get_branch_snapshot=
")
Fixes: aa67fdb46436 ("selftests/bpf: Skip the second half of get_branch_s=
napshot in vm")
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../bpf/prog_tests/get_branch_snapshot.c         | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c=
 b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
index d6d70a359aeb5..81402e4439844 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
@@ -78,6 +78,12 @@ void serial_test_get_branch_snapshot(void)
 	struct get_branch_snapshot *skel =3D NULL;
 	int err;
=20
+	/* Skip the test before we fix LBR snapshot for hypervisor. */
+	if (is_hypervisor()) {
+		test__skip();
+		return;
+	}
+
 	if (create_perf_events()) {
 		test__skip();  /* system doesn't support LBR */
 		goto cleanup;
@@ -107,16 +113,6 @@ void serial_test_get_branch_snapshot(void)
 		goto cleanup;
 	}
=20
-	if (is_hypervisor()) {
-		/* As of today, LBR in hypervisor cannot be stopped before
-		 * too many entries are flushed. Skip the hit/waste test
-		 * for now in hypervisor until we optimize the LBR in
-		 * hypervisor.
-		 */
-		test__skip();
-		goto cleanup;
-	}
-
 	ASSERT_GT(skel->bss->test1_hits, 6, "find_looptest_in_lbr");
=20
 	/* Given we stop LBR in software, we will waste a few entries.
--=20
2.30.2


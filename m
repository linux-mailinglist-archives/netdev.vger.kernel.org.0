Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3CB24AF1E
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgHTGOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:14:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55044 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725780AbgHTGOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 02:14:21 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07K6EEdq015705
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 23:14:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=6wkY8oLVKReQbWbty4Ltplt7Cjhv7qGnQ2phhQsn93k=;
 b=Re+lm2AoKtI4EPz1gwMxRMnSRu94mSClaeZPrGeS+rT5VFS03gqAHFPBUQb7YbMNRdKC
 ZbxwhzTlD1wlTR42yd4c+1v8wLPXcUF5cpRdS+PopNiVGqLNYsg+oYt0jlNlo1/C6gRV
 odgHDHMK6QWe4uJMwuUYzz/pUm+R3ONFd1A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3304jjcekv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 23:14:20 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 23:14:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1BA892EC5ED6; Wed, 19 Aug 2020 23:14:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/4] selftests/bpf: fix two minor compilation warnings reported by GCC 4.9
Date:   Wed, 19 Aug 2020 23:14:10 -0700
Message-ID: <20200820061411.1755905-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820061411.1755905-1-andriin@fb.com>
References: <20200820061411.1755905-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=805 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 4.9 seems to be more strict in some regards. Fix two minor issue it
reported.

Fixes: 1c1052e0140a ("tools/testing/selftests/bpf: Add self-tests for new=
 helper bpf_get_ns_current_pid_tgid.")
Fixes: 2d7824ffd25c ("selftests: bpf: Add test for sk_assign")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/sk_assign.c         | 3 ++-
 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_assign.c b/tools/t=
esting/selftests/bpf/prog_tests/sk_assign.c
index 47fa04adc147..d43038d2b9e1 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_assign.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
@@ -268,6 +268,7 @@ void test_sk_assign(void)
 	int server =3D -1;
 	int server_map;
 	int self_net;
+	int i;
=20
 	self_net =3D open(NS_SELF, O_RDONLY);
 	if (CHECK_FAIL(self_net < 0)) {
@@ -286,7 +287,7 @@ void test_sk_assign(void)
 		goto cleanup;
 	}
=20
-	for (int i =3D 0; i < ARRAY_SIZE(tests) && !READ_ONCE(stop); i++) {
+	for (i =3D 0; i < ARRAY_SIZE(tests) && !READ_ONCE(stop); i++) {
 		struct test_sk_cfg *test =3D &tests[i];
 		const struct sockaddr *addr;
 		const int zero =3D 0;
diff --git a/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c b=
/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
index ed253f252cd0..ec53b1ef90d2 100644
--- a/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
+++ b/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
@@ -156,4 +156,5 @@ int main(int argc, char **argv)
 			bpf_object__close(obj);
 		}
 	}
+	return 0;
 }
--=20
2.24.1


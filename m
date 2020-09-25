Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A394D277CA4
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgIYAEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:04:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16264 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbgIYAEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:04:34 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P00t5m009992
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=4i3CyqHr6EmC/uBkUjhT8AkVH2DVlNzRJXWkAXGiW1A=;
 b=SLAkBv9ZV8wIwzrUlPS4Q9Q5mCRQjlyKCnhyQbtcQow/tPDW3fOmTmY62nV1IBzTArMa
 8Qy6d8UcHWuGcMZfz0wVpDWZurzqjib9UYWB6O9x8RIgVzYaHK3eWBNhDykV1Y9SM2zT
 P3F+J2A/IoOmGAKL/IYUnRfiTkoUoWX+Cmc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp6vsqw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:34 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 17:04:32 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id C09F12946606; Thu, 24 Sep 2020 17:04:27 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 08/13] bpf: selftest: Move sock_fields test into test_progs
Date:   Thu, 24 Sep 2020 17:04:27 -0700
Message-ID: <20200925000427.3857814-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 mlxlogscore=999 suspectscore=13 lowpriorityscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240174
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a mechanical change to
1. move test_sock_fields.c to prog_tests/sock_fields.c
2. rename progs/test_sock_fields_kern.c to progs/test_sock_fields.c

Minimal change is made to the code itself.  Next patch will make
changes to use new ways of writing test, e.g. use skel and global
variables.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/.gitignore                      | 1 -
 tools/testing/selftests/bpf/Makefile                        | 2 +-
 .../bpf/{test_sock_fields.c =3D> prog_tests/sock_fields.c}    | 6 ++----
 .../progs/{test_sock_fields_kern.c =3D> test_sock_fields.c}   | 0
 4 files changed, 3 insertions(+), 6 deletions(-)
 rename tools/testing/selftests/bpf/{test_sock_fields.c =3D> prog_tests/s=
ock_fields.c} (99%)
 rename tools/testing/selftests/bpf/progs/{test_sock_fields_kern.c =3D> t=
est_sock_fields.c} (100%)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selft=
ests/bpf/.gitignore
index e8fed558b8b8..3ab1200e172f 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -13,7 +13,6 @@ test_verifier_log
 feature
 test_sock
 test_sock_addr
-test_sock_fields
 urandom_read
 test_sockmap
 test_lirc_mode2_user
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 59a5fa5fe837..bdbeafec371b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -35,7 +35,7 @@ TEST_GEN_PROGS =3D test_verifier test_tag test_maps tes=
t_lru_map test_lpm_map test
 	test_verifier_log test_dev_cgroup test_tcpbpf_user \
 	test_sock test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
-	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
+	test_netcnt test_tcpnotify_user test_sysctl \
 	test_progs-no_alu32 \
 	test_current_pid_tgid_new_ns
=20
diff --git a/tools/testing/selftests/bpf/test_sock_fields.c b/tools/testi=
ng/selftests/bpf/prog_tests/sock_fields.c
similarity index 99%
rename from tools/testing/selftests/bpf/test_sock_fields.c
rename to tools/testing/selftests/bpf/prog_tests/sock_fields.c
index 6c9f269c396d..1138223780fc 100644
--- a/tools/testing/selftests/bpf/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
@@ -409,10 +409,10 @@ static void test(void)
 	check_result();
 }
=20
-int main(int argc, char **argv)
+void test_sock_fields(void)
 {
 	struct bpf_prog_load_attr attr =3D {
-		.file =3D "test_sock_fields_kern.o",
+		.file =3D "test_sock_fields.o",
 		.prog_type =3D BPF_PROG_TYPE_CGROUP_SKB,
 		.prog_flags =3D BPF_F_TEST_RND_HI32,
 	};
@@ -477,6 +477,4 @@ int main(int argc, char **argv)
 	cleanup_cgroup_environment();
=20
 	printf("PASS\n");
-
-	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c b/=
tools/testing/selftests/bpf/progs/test_sock_fields.c
similarity index 100%
rename from tools/testing/selftests/bpf/progs/test_sock_fields_kern.c
rename to tools/testing/selftests/bpf/progs/test_sock_fields.c
--=20
2.24.1


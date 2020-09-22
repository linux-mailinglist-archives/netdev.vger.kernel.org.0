Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCD2273C1A
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgIVHhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:37:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729906AbgIVHhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:37:45 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08M72Jv0004738
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:05:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8PjCHnYFiQjJNH+sNUSTVkLi5+NuALn5mgExeiFipc4=;
 b=iHpN0Snd/hlFDz9OFsmUUvFrSU7eX5HUHV15kXnQ1V2xhUo3xiyJzMneqlQXqznkpfyH
 U0hAy3WpzqCnDbptbb8mdDQ5g+UlWwzPtrwnLkmZiH5ZxejryEyA+k1awOj5BCkJhEjl
 QM2SV6Jcv1d0rRE8Lped+i33Xj3GJxRnuic= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33ndnnvgs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:05:02 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 00:05:00 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 940CF294641C; Tue, 22 Sep 2020 00:04:59 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v3 bpf-next 08/11] bpf: selftest: Move sock_fields test into test_progs
Date:   Tue, 22 Sep 2020 00:04:59 -0700
Message-ID: <20200922070459.1922443-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200922070409.1914988-1-kafai@fb.com>
References: <20200922070409.1914988-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_05:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=13
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220056
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
 tools/testing/selftests/bpf/Makefile                        | 2 +-
 .../bpf/{test_sock_fields.c =3D> prog_tests/sock_fields.c}    | 6 ++----
 .../progs/{test_sock_fields_kern.c =3D> test_sock_fields.c}   | 0
 3 files changed, 3 insertions(+), 5 deletions(-)
 rename tools/testing/selftests/bpf/{test_sock_fields.c =3D> prog_tests/s=
ock_fields.c} (99%)
 rename tools/testing/selftests/bpf/progs/{test_sock_fields_kern.c =3D> t=
est_sock_fields.c} (100%)

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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C957A77B64
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 21:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388232AbfG0TCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 15:02:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53314 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388224AbfG0TCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 15:02:17 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RIwtpw025313
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 12:02:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=yzxTynDIIFgtCF8uruhjsyg/NJqPgdUMI7zuaIXwfKc=;
 b=iZI6ogrsEwU6UsoM4GGSYkI/Ulm+ncxR0RTUmxDdZMl/olFcIvIhfvheWAZheqzim4Is
 XNGLitwuswZCIf5Yj1e6aD4RLSJJL5slgRllmrHnh9xKYNDvsJXSugXkDq2ExDt8r/L8
 0k3+TitK5yndzeDaXgU4zqQ8HOWZqJvYfNA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0me8s4eh-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 12:02:15 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 27 Jul 2019 12:02:12 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 1B6B5861672; Sat, 27 Jul 2019 12:02:10 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@fomichev.me>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 8/9] selftests/bpf: convert bpf_verif_scale.c to sub-tests API
Date:   Sat, 27 Jul 2019 12:01:49 -0700
Message-ID: <20190727190150.649137-9-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190727190150.649137-1-andriin@fb.com>
References: <20190727190150.649137-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270237
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose each BPF verifier scale test as individual sub-test to allow
independent results output and test selection.

Test run results now look like this:

  $ sudo ./test_progs -t verif/
  #3/1 loop3.o:OK
  #3/2 test_verif_scale1.o:OK
  #3/3 test_verif_scale2.o:OK
  #3/4 test_verif_scale3.o:OK
  #3/5 pyperf50.o:OK
  #3/6 pyperf100.o:OK
  #3/7 pyperf180.o:OK
  #3/8 pyperf600.o:OK
  #3/9 pyperf600_nounroll.o:OK
  #3/10 loop1.o:OK
  #3/11 loop2.o:OK
  #3/12 strobemeta.o:OK
  #3/13 strobemeta_nounroll1.o:OK
  #3/14 strobemeta_nounroll2.o:OK
  #3/15 test_sysctl_loop1.o:OK
  #3/16 test_sysctl_loop2.o:OK
  #3/17 test_xdp_loop.o:OK
  #3/18 test_seg6_loop.o:OK
  #3 bpf_verif_scale:OK

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/prog_tests/bpf_verif_scale.c          | 77 ++++++++++---------
 1 file changed, 40 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index b59017279e0b..b4be96162ff4 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -33,14 +33,25 @@ static int check_load(const char *file, enum bpf_prog_type type)
 	return err;
 }
 
+struct scale_test_def {
+	const char *file;
+	enum bpf_prog_type attach_type;
+	bool fails;
+};
+
 void test_bpf_verif_scale(void)
 {
-	const char *sched_cls[] = {
-		"./test_verif_scale1.o", "./test_verif_scale2.o", "./test_verif_scale3.o",
-	};
-	const char *raw_tp[] = {
+	struct scale_test_def tests[] = {
+		{ "loop3.o", BPF_PROG_TYPE_RAW_TRACEPOINT, true /* fails */ },
+
+		{ "test_verif_scale1.o", BPF_PROG_TYPE_SCHED_CLS },
+		{ "test_verif_scale2.o", BPF_PROG_TYPE_SCHED_CLS },
+		{ "test_verif_scale3.o", BPF_PROG_TYPE_SCHED_CLS },
+
 		/* full unroll by llvm */
-		"./pyperf50.o",	"./pyperf100.o", "./pyperf180.o",
+		{ "pyperf50.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
+		{ "pyperf100.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
+		{ "pyperf180.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 
 		/* partial unroll. llvm will unroll loop ~150 times.
 		 * C loop count -> 600.
@@ -48,7 +59,7 @@ void test_bpf_verif_scale(void)
 		 * 16k insns in loop body.
 		 * Total of 5 such loops. Total program size ~82k insns.
 		 */
-		"./pyperf600.o",
+		{ "pyperf600.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 
 		/* no unroll at all.
 		 * C loop count -> 600.
@@ -56,22 +67,26 @@ void test_bpf_verif_scale(void)
 		 * ~110 insns in loop body.
 		 * Total of 5 such loops. Total program size ~1500 insns.
 		 */
-		"./pyperf600_nounroll.o",
+		{ "pyperf600_nounroll.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 
-		"./loop1.o", "./loop2.o",
+		{ "loop1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
+		{ "loop2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 
 		/* partial unroll. 19k insn in a loop.
 		 * Total program size 20.8k insn.
 		 * ~350k processed_insns
 		 */
-		"./strobemeta.o",
+		{ "strobemeta.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 
 		/* no unroll, tiny loops */
-		"./strobemeta_nounroll1.o",
-		"./strobemeta_nounroll2.o",
-	};
-	const char *cg_sysctl[] = {
-		"./test_sysctl_loop1.o", "./test_sysctl_loop2.o",
+		{ "strobemeta_nounroll1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
+		{ "strobemeta_nounroll2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
+
+		{ "test_sysctl_loop1.o", BPF_PROG_TYPE_CGROUP_SYSCTL },
+		{ "test_sysctl_loop2.o", BPF_PROG_TYPE_CGROUP_SYSCTL },
+
+		{ "test_xdp_loop.o", BPF_PROG_TYPE_XDP },
+		{ "test_seg6_loop.o", BPF_PROG_TYPE_LWT_SEG6LOCAL },
 	};
 	libbpf_print_fn_t old_print_fn = NULL;
 	int err, i;
@@ -81,33 +96,21 @@ void test_bpf_verif_scale(void)
 		old_print_fn = libbpf_set_print(libbpf_debug_print);
 	}
 
-	err = check_load("./loop3.o", BPF_PROG_TYPE_RAW_TRACEPOINT);
-	test__printf("test_scale:loop3:%s\n",
-		     err ? (error_cnt--, "OK") : "FAIL");
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		const struct scale_test_def *test = &tests[i];
 
-	for (i = 0; i < ARRAY_SIZE(sched_cls); i++) {
-		err = check_load(sched_cls[i], BPF_PROG_TYPE_SCHED_CLS);
-		test__printf("test_scale:%s:%s\n", sched_cls[i],
-			     err ? "FAIL" : "OK");
-	}
+		if (!test__start_subtest(test->file))
+			continue;
 
-	for (i = 0; i < ARRAY_SIZE(raw_tp); i++) {
-		err = check_load(raw_tp[i], BPF_PROG_TYPE_RAW_TRACEPOINT);
-		test__printf("test_scale:%s:%s\n", raw_tp[i],
-			     err ? "FAIL" : "OK");
+		err = check_load(test->file, test->attach_type);
+		if (test->fails) { /* expected to fail */
+			if (err)
+				error_cnt--;
+			else
+				error_cnt++;
+		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(cg_sysctl); i++) {
-		err = check_load(cg_sysctl[i], BPF_PROG_TYPE_CGROUP_SYSCTL);
-		test__printf("test_scale:%s:%s\n", cg_sysctl[i],
-			     err ? "FAIL" : "OK");
-	}
-	err = check_load("./test_xdp_loop.o", BPF_PROG_TYPE_XDP);
-	test__printf("test_scale:test_xdp_loop:%s\n", err ? "FAIL" : "OK");
-
-	err = check_load("./test_seg6_loop.o", BPF_PROG_TYPE_LWT_SEG6LOCAL);
-	test__printf("test_scale:test_seg6_loop:%s\n", err ? "FAIL" : "OK");
-
 	if (env.verifier_stats)
 		libbpf_set_print(old_print_fn);
 }
-- 
2.17.1


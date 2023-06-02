Return-Path: <netdev+bounces-7322-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C0F71FA93
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:03:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51DE22816F3
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E79F5226;
	Fri,  2 Jun 2023 07:03:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B21D3D6D;
	Fri,  2 Jun 2023 07:03:44 +0000 (UTC)
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B06EC0;
	Fri,  2 Jun 2023 00:03:42 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 41be03b00d2f7-5428f63c73aso519262a12.1;
        Fri, 02 Jun 2023 00:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685689422; x=1688281422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u3BWlTPsObidXDtzIHPCXFfZL0M03uXUfgADlN6lrcg=;
        b=TXk2/MwUqulJx/q8I0vNt8DC69PD/dyJKYb4kGXCNUwgsYo95gxZUVCyNIHcqrpggE
         EL2SJmCCyQIgLzhBW/XTLEjgucx0l105f9m2zXrjsUQsdr9Hf/HpuO+d5z1AEwB6z+vV
         uDLuf9WLJc4Es259+K9sQdrsXPqKBbMDKKA5YGLd6JuMTpMF0AQPCpiIQZE4vlpd8Rzv
         YI1tflOl4RIwHFqGHofbO0flRXf+i37QHKvBZ2zAiVJDjsEmGdvAS2GMhiqJNNPA5naX
         gPVKo6l/KZZYuDS75QURcUhVnIsQ/VeVb5MrCMPMnjkSqkgQe73j/nnnZJ6UYRmmL3Wz
         JWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685689422; x=1688281422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u3BWlTPsObidXDtzIHPCXFfZL0M03uXUfgADlN6lrcg=;
        b=GNpGUo9mxfL4WUjlOonyTjgEa05BgCwQTlXF5TAjH7ThDF23Wq4eYz7frVivUPGZlX
         kK52WLlTwyb8C01Hbb6wWIm35PIX/CDVUJQEOuYIM766wh5wZm4QBm1HC4XpuPh7SjEa
         WqunuIpGvk3U9D/yv7sQ9SN1CVLBsI/4zV7keYS3vP/NIRXhUJEHQCxuy08POpMuCNLm
         aPJNngx9Rq0VontItTEYG3DW2BelcbyprX7Kmq1GCVkQ8cAsZ7049gj4JsVo8ZqAOP8R
         i2ry9d2tQmkap9p86YtNQqtRVT8u5qrFLQqtvb1NSrHKWGwyjC3p+sLxYC55JH6hITVb
         HHBw==
X-Gm-Message-State: AC+VfDwnln696chL2sDUx0Zuzwv8ph6K/k/1Dhf+3/pKT7Kejux8Eo+Y
	AMsk7ztkbqh0pebngcIMnVk=
X-Google-Smtp-Source: ACHHUZ60WPIftH8KK8U9r7WrDhwPgFfK0MPgDpZGN2WWP2cXFtgmJ21UTbDQSerSEU9peFElOySexQ==
X-Received: by 2002:a17:903:64e:b0:1ad:fcdc:2a9f with SMTP id kh14-20020a170903064e00b001adfcdc2a9fmr921370plb.51.1685689421937;
        Fri, 02 Jun 2023 00:03:41 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id jk11-20020a170903330b00b001ac7c725c1asm572716plb.6.2023.06.02.00.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 00:03:41 -0700 (PDT)
From: menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To: olsajiri@gmail.com
Cc: davem@davemloft.net,
	dsahern@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	song@kernel.org,
	yhs@fb.com,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	mykolal@fb.com,
	shuah@kernel.org,
	benbjiang@tencent.com,
	iii@linux.ibm.com,
	imagedong@tencent.com,
	xukuohai@huawei.com,
	chantr4@gmail.com,
	zwisler@google.com,
	eddyz87@gmail.com,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 5/5] selftests/bpf: add testcase for FENTRY/FEXIT with 6+ arguments
Date: Fri,  2 Jun 2023 14:59:58 +0800
Message-Id: <20230602065958.2869555-6-imagedong@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602065958.2869555-1-imagedong@tencent.com>
References: <20230602065958.2869555-1-imagedong@tencent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Menglong Dong <imagedong@tencent.com>

Add test7/test12/test14 in fexit_test.c and fentry_test.c to test the
fentry and fexit whose target function have 7/12/14 arguments.

And the testcases passed:

./test_progs -t fexit
$71      fentry_fexit:OK
$73/1    fexit_bpf2bpf/target_no_callees:OK
$73/2    fexit_bpf2bpf/target_yes_callees:OK
$73/3    fexit_bpf2bpf/func_replace:OK
$73/4    fexit_bpf2bpf/func_replace_verify:OK
$73/5    fexit_bpf2bpf/func_sockmap_update:OK
$73/6    fexit_bpf2bpf/func_replace_return_code:OK
$73/7    fexit_bpf2bpf/func_map_prog_compatibility:OK
$73/8    fexit_bpf2bpf/func_replace_multi:OK
$73/9    fexit_bpf2bpf/fmod_ret_freplace:OK
$73/10   fexit_bpf2bpf/func_replace_global_func:OK
$73/11   fexit_bpf2bpf/fentry_to_cgroup_bpf:OK
$73/12   fexit_bpf2bpf/func_replace_progmap:OK
$73      fexit_bpf2bpf:OK
$74      fexit_sleep:OK
$75      fexit_stress:OK
$76      fexit_test:OK
Summary: 5/12 PASSED, 0 SKIPPED, 0 FAILED

./test_progs -t fentry
$71      fentry_fexit:OK
$72      fentry_test:OK
$140     module_fentry_shadow:OK
Summary: 3/0 PASSED, 0 SKIPPED, 0 FAILED

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/bpf/test_run.c                            | 30 +++++++++++++++-
 .../testing/selftests/bpf/progs/fentry_test.c | 34 ++++++++++++++++++
 .../testing/selftests/bpf/progs/fexit_test.c  | 35 +++++++++++++++++++
 3 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index c73f246a706f..e12a72311eca 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -536,6 +536,27 @@ int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
 	return a + (long)b + c + d + (long)e + f;
 }
 
+noinline int bpf_fentry_test7(u64 a, void *b, short c, int d, void *e,
+			      u64 f, u64 g)
+{
+	return a + (long)b + c + d + (long)e + f + g;
+}
+
+noinline int bpf_fentry_test12(u64 a, void *b, short c, int d, void *e,
+			       u64 f, u64 g, u64 h, u64 i, u64 j,
+			       u64 k, u64 l)
+{
+	return a + (long)b + c + d + (long)e + f + g + h + i + j + k + l;
+}
+
+noinline int bpf_fentry_test14(u64 a, void *b, short c, int d, void *e,
+			       u64 f, u64 g, u64 h, u64 i, u64 j,
+			       u64 k, u64 l, u64 m, u64 n)
+{
+	return a + (long)b + c + d + (long)e + f + g + h + i + j + k + l +
+	       m + n;
+}
+
 struct bpf_fentry_test_t {
 	struct bpf_fentry_test_t *a;
 };
@@ -657,7 +678,14 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
 		    bpf_fentry_test6(16, (void *)17, 18, 19, (void *)20, 21) != 111 ||
 		    bpf_fentry_test_ptr1((struct bpf_fentry_test_t *)0) != 0 ||
 		    bpf_fentry_test_ptr2(&arg) != 0 ||
-		    bpf_fentry_test_ptr3(&retval) != 0)
+		    bpf_fentry_test_ptr3(&retval) != 0 ||
+		    bpf_fentry_test7(16, (void *)17, 18, 19, (void *)20,
+				     21, 22) != 133 ||
+		    bpf_fentry_test12(16, (void *)17, 18, 19, (void *)20,
+				      21, 22, 23, 24, 25, 26, 27) != 258 ||
+		    bpf_fentry_test14(16, (void *)17, 18, 19, (void *)20,
+				      21, 22, 23, 24, 25, 26, 27, 28,
+				      29) != 315)
 			goto out;
 		break;
 	case BPF_MODIFY_RETURN:
diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
index 558a5f1d3d5c..0666a907f7ea 100644
--- a/tools/testing/selftests/bpf/progs/fentry_test.c
+++ b/tools/testing/selftests/bpf/progs/fentry_test.c
@@ -56,6 +56,40 @@ int BPF_PROG(test6, __u64 a, void *b, short c, int d, void * e, __u64 f)
 	return 0;
 }
 
+__u64 test7_result = 0;
+SEC("fentry/bpf_fentry_test7")
+int BPF_PROG(test7, __u64 a, void *b, short c, int d, void *e, __u64 f,
+	     __u64 g)
+{
+	test7_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21 && g == 22;
+	return 0;
+}
+
+__u64 test12_result = 0;
+SEC("fentry/bpf_fentry_test12")
+int BPF_PROG(test12, __u64 a, void *b, short c, int d, void *e, __u64 f,
+	     __u64 g, __u64 h, __u64 i, __u64 j, __u64 k, __u64 l)
+{
+	test12_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21 && g == 22 && h == 23 &&
+		i == 24 && j == 25 && k == 26 && l == 27;
+	return 0;
+}
+
+__u64 test14_result = 0;
+SEC("fentry/bpf_fentry_test14")
+int BPF_PROG(test14, __u64 a, void *b, short c, int d, void *e, __u64 f,
+	     __u64 g, __u64 h, __u64 i, __u64 j, __u64 k, __u64 l,
+	     __u64 m, __u64 n)
+{
+	test14_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21 && g == 22 && h == 23 &&
+		i == 24 && j == 25 && k == 26 && l == 27 && m == 28 &&
+		n == 29;
+	return 0;
+}
+
 struct bpf_fentry_test_t {
 	struct bpf_fentry_test_t *a;
 };
diff --git a/tools/testing/selftests/bpf/progs/fexit_test.c b/tools/testing/selftests/bpf/progs/fexit_test.c
index f57886e6d918..1b9102ad1418 100644
--- a/tools/testing/selftests/bpf/progs/fexit_test.c
+++ b/tools/testing/selftests/bpf/progs/fexit_test.c
@@ -57,6 +57,41 @@ int BPF_PROG(test6, __u64 a, void *b, short c, int d, void *e, __u64 f, int ret)
 	return 0;
 }
 
+__u64 test7_result = 0;
+SEC("fexit/bpf_fentry_test7")
+int BPF_PROG(test7, __u64 a, void *b, short c, int d, void *e, __u64 f,
+	     __u64 g, int ret)
+{
+	test7_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21 && g == 22 && ret == 133;
+	return 0;
+}
+
+__u64 test12_result = 0;
+SEC("fexit/bpf_fentry_test12")
+int BPF_PROG(test12, __u64 a, void *b, short c, int d, void *e, __u64 f,
+	     __u64 g, __u64 h, __u64 i, __u64 j, __u64 k, __u64 l,
+	     int ret)
+{
+	test12_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21 && g == 22 && h == 23 &&
+		i == 24 && j == 25 && k == 26 && l == 27 && ret == 258;
+	return 0;
+}
+
+__u64 test14_result = 0;
+SEC("fexit/bpf_fentry_test14")
+int BPF_PROG(test14, __u64 a, void *b, short c, int d, void *e, __u64 f,
+	     __u64 g, __u64 h, __u64 i, __u64 j, __u64 k, __u64 l,
+	     __u64 m, __u64 n, int ret)
+{
+	test14_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21 && g == 22 && h == 23 &&
+		i == 24 && j == 25 && k == 26 && l == 27 && m == 28 &&
+		n == 29 && ret == 315;
+	return 0;
+}
+
 struct bpf_fentry_test_t {
 	struct bpf_fentry_test *a;
 };
-- 
2.40.1



Return-Path: <netdev+bounces-8848-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 191A1726037
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C913A2811AF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1B535B2D;
	Wed,  7 Jun 2023 12:59:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C96C8D6;
	Wed,  7 Jun 2023 12:59:39 +0000 (UTC)
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F28C1BE3;
	Wed,  7 Jun 2023 05:59:35 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d2e1a72fcca58-654f8b56807so4681504b3a.1;
        Wed, 07 Jun 2023 05:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686142775; x=1688734775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LzyAUqPi0jCD511bOtwtey50eQwPuKWR3npw9bDqb6s=;
        b=eXjk7uzRW7Of8O6cUG5k95c7/5m/nYTodODseD+vU+rqsAeUVthPCH9EHL9M25jXl2
         cfV4t7eB++R4CMxoJ6MHbi8CUw+z5HQUxCZeqFYgOvE/5udqhI4OG+lkaW2vVqcZ3sTu
         hOy5ARtmg798zw3XLkdNe2QgoZDh/d8mN1IT5FsvoaXF7cBws4j4TZeF0Fz7BtN+P6sf
         gyglZkUTp6lBQOABgzajmYoszm2h8qecIT8kYeT+sDuErrmOh2IfKyYc7ghTLPbjH2NI
         uD1k/kB75gz7bH2xiyb4LjLw1YC4c26Pv7tl2v3YsDSZeKcMXGctGNXNY1uJ4bXeuSto
         T85w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686142775; x=1688734775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LzyAUqPi0jCD511bOtwtey50eQwPuKWR3npw9bDqb6s=;
        b=bxi3tb9jGp7Troz429HKHyoK97gS+B3PRR/Y0M+RjJtRSBS4E53ExoZVzXnoZPdypM
         PYS8nXRAcp75V4XoBftOj8ZjdM+2iEDfJiAc3HaEg28Q4UQ0uU+6OajQFFcepz4NhBap
         zuz/A2HmYi7k1t9YsQXyz16yy/W5kuuX6qV7LM6IW5VAgg9Y9NDffAezZ4Hln9yxCRjP
         rLSmeBs3+pzZ00ewq2+ZVXHeVKQTubh4GUlgkLD1DMmWU30Hrna0feG7Gcq+y88O+DPQ
         twGuJJF5cvTnnCo3M+1QoduEM2MZav8hNPJxv24ghRZsZxxjg3qCv6mISKufc0cJhHNq
         7K8Q==
X-Gm-Message-State: AC+VfDwceD6r4ocA7a3dJsmlhizbKvQjK9Fazy0AAG56WCzWV6cYUEnx
	LKT8dJhXQkwZztKCusr8GBw=
X-Google-Smtp-Source: ACHHUZ66nwg1AoocarqbRIVSR1BtzVHpjtfPeiIiDaXmxfUJ7/Q+QqeBiyRHBLnlhn9QHOjvbfSUKQ==
X-Received: by 2002:a05:6a20:1456:b0:10a:e9ff:808d with SMTP id a22-20020a056a20145600b0010ae9ff808dmr3555119pzi.0.1686142775311;
        Wed, 07 Jun 2023 05:59:35 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.83])
        by smtp.gmail.com with ESMTPSA id p1-20020a62ab01000000b0065434edd521sm7094982pff.196.2023.06.07.05.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 05:59:34 -0700 (PDT)
From: menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To: alexei.starovoitov@gmail.com
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
	x86@kernel.org,
	imagedong@tencent.com,
	benbjiang@tencent.com,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v3 3/3] selftests/bpf: add testcase for FENTRY/FEXIT with 6+ arguments
Date: Wed,  7 Jun 2023 20:59:11 +0800
Message-Id: <20230607125911.145345-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607125911.145345-1-imagedong@tencent.com>
References: <20230607125911.145345-1-imagedong@tencent.com>
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

Add test9/test10 in fexit_test.c and fentry_test.c to test the fentry
and fexit whose target function have 7/12 arguments.

Correspondingly, add bpf_testmod_fentry_test7() and
bpf_testmod_fentry_test12() to bpf_testmod.c

And the testcases passed:

./test_progs -t fexit
Summary: 5/12 PASSED, 0 SKIPPED, 0 FAILED

./test_progs -t fentry
Summary: 3/0 PASSED, 0 SKIPPED, 0 FAILED

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v3:
- move bpf_fentry_test{7,12} to bpf_testmod.c and rename them to
  bpf_testmod_fentry_test{7,12} meanwhile
- get return value by bpf_get_func_ret() in
  "fexit/bpf_testmod_fentry_test12", as we don't change ___bpf_ctx_cast()
  in this version
---
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 19 ++++++++++-
 .../selftests/bpf/prog_tests/fentry_fexit.c   |  4 ++-
 .../selftests/bpf/prog_tests/fentry_test.c    |  2 ++
 .../selftests/bpf/prog_tests/fexit_test.c     |  2 ++
 .../testing/selftests/bpf/progs/fentry_test.c | 21 ++++++++++++
 .../testing/selftests/bpf/progs/fexit_test.c  | 33 +++++++++++++++++++
 6 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index cf216041876c..66615fdbe3df 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -191,6 +191,19 @@ noinline int bpf_testmod_fentry_test3(char a, int b, u64 c)
 	return a + b + c;
 }
 
+noinline int bpf_testmod_fentry_test7(u64 a, void *b, short c, int d,
+				      void *e, u64 f, u64 g)
+{
+	return a + (long)b + c + d + (long)e + f + g;
+}
+
+noinline int bpf_testmod_fentry_test12(u64 a, void *b, short c, int d,
+				       void *e, u64 f, u64 g, u64 h,
+				       u64 i, u64 j, u64 k, u64 l)
+{
+	return a + (long)b + c + d + (long)e + f + g + h + i + j + k + l;
+}
+
 __diag_pop();
 
 int bpf_testmod_fentry_ok;
@@ -245,7 +258,11 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 
 	if (bpf_testmod_fentry_test1(1) != 2 ||
 	    bpf_testmod_fentry_test2(2, 3) != 5 ||
-	    bpf_testmod_fentry_test3(4, 5, 6) != 15)
+	    bpf_testmod_fentry_test3(4, 5, 6) != 15 ||
+	    bpf_testmod_fentry_test7(16, (void *)17, 18, 19, (void *)20,
+				     21, 22) != 133 ||
+	    bpf_testmod_fentry_test12(16, (void *)17, 18, 19, (void *)20,
+				      21, 22, 23, 24, 25, 26, 27) != 258)
 		goto out;
 
 	bpf_testmod_fentry_ok = 1;
diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
index 130f5b82d2e6..5b99e6ce7dd2 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
@@ -31,10 +31,12 @@ void test_fentry_fexit(void)
 	ASSERT_OK(err, "ipv6 test_run");
 	ASSERT_OK(topts.retval, "ipv6 test retval");
 
+	ASSERT_OK(trigger_module_test_read(1), "trigger_read");
+
 	fentry_res = (__u64 *)fentry_skel->bss;
 	fexit_res = (__u64 *)fexit_skel->bss;
 	printf("%lld\n", fentry_skel->bss->test1_result);
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < 10; i++) {
 		ASSERT_EQ(fentry_res[i], 1, "fentry result");
 		ASSERT_EQ(fexit_res[i], 1, "fexit result");
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
index c0d1d61d5f66..e1c0ce40febf 100644
--- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
@@ -24,6 +24,8 @@ static int fentry_test(struct fentry_test_lskel *fentry_skel)
 	ASSERT_OK(err, "test_run");
 	ASSERT_EQ(topts.retval, 0, "test_run");
 
+	ASSERT_OK(trigger_module_test_read(1), "trigger_read");
+
 	result = (__u64 *)fentry_skel->bss;
 	for (i = 0; i < sizeof(*fentry_skel->bss) / sizeof(__u64); i++) {
 		if (!ASSERT_EQ(result[i], 1, "fentry_result"))
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
index 101b7343036b..ea81fa913ec6 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
@@ -24,6 +24,8 @@ static int fexit_test(struct fexit_test_lskel *fexit_skel)
 	ASSERT_OK(err, "test_run");
 	ASSERT_EQ(topts.retval, 0, "test_run");
 
+	ASSERT_OK(trigger_module_test_read(1), "trigger_read");
+
 	result = (__u64 *)fexit_skel->bss;
 	for (i = 0; i < sizeof(*fexit_skel->bss) / sizeof(__u64); i++) {
 		if (!ASSERT_EQ(result[i], 1, "fexit_result"))
diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
index 52a550d281d9..e5fb79e4a147 100644
--- a/tools/testing/selftests/bpf/progs/fentry_test.c
+++ b/tools/testing/selftests/bpf/progs/fentry_test.c
@@ -77,3 +77,24 @@ int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
 		test8_result = 1;
 	return 0;
 }
+
+__u64 test9_result = 0;
+SEC("fentry/bpf_testmod_fentry_test7")
+int BPF_PROG(test9, __u64 a, void *b, short c, int d, void *e, __u64 f,
+	     __u64 g)
+{
+	test9_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21 && g == 22;
+	return 0;
+}
+
+__u64 test10_result = 0;
+SEC("fentry/bpf_testmod_fentry_test12")
+int BPF_PROG(test10, __u64 a, void *b, short c, int d, void *e, __u64 f,
+	     __u64 g, __u64 h, __u64 i, __u64 j, __u64 k, __u64 l)
+{
+	test10_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21 && g == 22 && h == 23 &&
+		i == 24 && j == 25 && k == 26 && l == 27;
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/fexit_test.c b/tools/testing/selftests/bpf/progs/fexit_test.c
index 8f1ccb7302e1..6279c535a1e8 100644
--- a/tools/testing/selftests/bpf/progs/fexit_test.c
+++ b/tools/testing/selftests/bpf/progs/fexit_test.c
@@ -78,3 +78,36 @@ int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
 		test8_result = 1;
 	return 0;
 }
+
+__u64 test9_result = 0;
+SEC("fexit/bpf_testmod_fentry_test7")
+int BPF_PROG(test9, __u64 a, void *b, short c, int d, void *e, __u64 f,
+	     __u64 g, int ret)
+{
+	test9_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21 && g == 22 && ret == 133;
+	return 0;
+}
+
+__u64 test10_result = 0;
+SEC("fexit/bpf_testmod_fentry_test12")
+int BPF_PROG(test10, __u64 a, void *b, short c, int d, void *e, __u64 f,
+	     __u64 g, __u64 h, __u64 i, __u64 j, __u64 k, __u64 l)
+{
+	__u64 ret;
+	int err;
+
+	/* BPF_PROG() don't support 14 arguments, and ctx[12] can't be
+	 * accessed yet. So we get the return value by bpf_get_func_ret()
+	 * for now.
+	 */
+	err = bpf_get_func_ret(ctx, &ret);
+	if (err)
+		return 0;
+
+	test10_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21 && g == 22 && h == 23 &&
+		i == 24 && j == 25 && k == 26 && l == 27 &&
+		(int)ret == 258;
+	return 0;
+}
-- 
2.40.1



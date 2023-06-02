Return-Path: <netdev+bounces-7321-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8200071FA8C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37504281602
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F5D4C9E;
	Fri,  2 Jun 2023 07:03:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E549291C;
	Fri,  2 Jun 2023 07:03:07 +0000 (UTC)
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AC2C0;
	Fri,  2 Jun 2023 00:03:04 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id ada2fe7eead31-4392f532cdaso472861137.3;
        Fri, 02 Jun 2023 00:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685689383; x=1688281383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIXI02zixY6EsiTaHFGNM2ccUEUsIDcKDYkgASQ6QgM=;
        b=ZwjXseJPcuvy30yQiFwevoIlY1cANqOz74spOTCFSu2ZehDMf6SnEw+eNyvV1LU0C7
         +/RLe1PfCrvBaji5wEssKSrrMBMhnA9YoakaG9WtMtmuCej0QPwuIliIcyQZa8lu+UKK
         mRqqU2DEdf3VvtQiUW8oLgub/2v0YEIbllO862FMFsixSQOAZpjQQ5gm+raBzcKtbqPo
         KxRLO3C6txEZvg6Su3yDaGO5nRkgI90ke7YjSb4KcQh1/vSR0KwoRH9rUzUiQrFXcdQn
         IwLCG/SF8TPKnFA4JCKd9M5EAdaeYmh3hwI3EV8l5b/0uKUBTtVIUEPuZQjo55YNUuDi
         9F4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685689383; x=1688281383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wIXI02zixY6EsiTaHFGNM2ccUEUsIDcKDYkgASQ6QgM=;
        b=UWUkyFOOy0US257RETGm0nOS+IV/cUWudDPunNEsxjfCtj0mbC3PM9qh+BUU5EOkxl
         AQjzL5xvouw+68yPeY7lKvUKoZz30fBxffZCZ1I1ZRdecBLiusyxt4A9WlAyJ/ZmWdOK
         nY2FJIpIaBVhqKXzsrKYqn2MOTZcLdRt1erPeKOfrQCH4Vijv+WDDNau7TqHz05tjpNv
         o7MHwG8rdUBxaXGRKJjOQ/9cLAdr8+xBqsJyRq+oGhGXCftQL1PC2EzWarfacO99ev2O
         WVXn+0qa8lpvFhY/ZgRyg1OhYX5rmnrpcubKGgSeIFhEHYFDqI+xhO1efC9kioHDk79d
         xDCg==
X-Gm-Message-State: AC+VfDxzIMckcH5BGqVEMI2Tg5NZXJX9QstPw3qY4yk0aZvoN6mQk8bI
	YprkTit45sF6iNIUXF3SaZ8=
X-Google-Smtp-Source: ACHHUZ7PXnqqc5a+MB1G9AlYJNXTAYbK2p962rQ/ccRRiOcWjz9p1RWS6auUkapSrBQj4yAGm1a+AA==
X-Received: by 2002:a67:fa90:0:b0:439:49f1:bb4d with SMTP id f16-20020a67fa90000000b0043949f1bb4dmr5186464vsq.7.1685689383024;
        Fri, 02 Jun 2023 00:03:03 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id jk11-20020a170903330b00b001ac7c725c1asm572716plb.6.2023.06.02.00.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 00:03:02 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 4/5] selftests/bpf: rename bpf_fentry_test{7,8,9} to bpf_fentry_test_ptr*
Date: Fri,  2 Jun 2023 14:59:57 +0800
Message-Id: <20230602065958.2869555-5-imagedong@tencent.com>
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

To make it more clear, let's make the N in bpf_fentry_testN as the count
of target function arguments. Therefore, let's rename
bpf_fentry_test{7,8,9} to bpf_fentry_test_ptr{1,2,3}.

Meanwhile, to stop the checkpatch complaining, move the "noinline" ahead
of "int".

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/bpf/test_run.c                            | 12 +++++-----
 .../selftests/bpf/prog_tests/bpf_cookie.c     | 24 +++++++++----------
 .../bpf/prog_tests/kprobe_multi_test.c        | 16 ++++++-------
 .../testing/selftests/bpf/progs/fentry_test.c | 16 ++++++-------
 .../testing/selftests/bpf/progs/fexit_test.c  | 16 ++++++-------
 .../selftests/bpf/progs/get_func_ip_test.c    |  2 +-
 .../selftests/bpf/progs/kprobe_multi.c        | 12 +++++-----
 .../bpf/progs/verifier_btf_ctx_access.c       |  2 +-
 .../selftests/bpf/verifier/atomic_fetch_add.c |  4 ++--
 9 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2321bd2f9964..c73f246a706f 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -540,17 +540,17 @@ struct bpf_fentry_test_t {
 	struct bpf_fentry_test_t *a;
 };
 
-int noinline bpf_fentry_test7(struct bpf_fentry_test_t *arg)
+noinline int bpf_fentry_test_ptr1(struct bpf_fentry_test_t *arg)
 {
 	return (long)arg;
 }
 
-int noinline bpf_fentry_test8(struct bpf_fentry_test_t *arg)
+noinline int bpf_fentry_test_ptr2(struct bpf_fentry_test_t *arg)
 {
 	return (long)arg->a;
 }
 
-__bpf_kfunc u32 bpf_fentry_test9(u32 *a)
+__bpf_kfunc u32 bpf_fentry_test_ptr3(u32 *a)
 {
 	return *a;
 }
@@ -655,9 +655,9 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
 		    bpf_fentry_test4((void *)7, 8, 9, 10) != 34 ||
 		    bpf_fentry_test5(11, (void *)12, 13, 14, 15) != 65 ||
 		    bpf_fentry_test6(16, (void *)17, 18, 19, (void *)20, 21) != 111 ||
-		    bpf_fentry_test7((struct bpf_fentry_test_t *)0) != 0 ||
-		    bpf_fentry_test8(&arg) != 0 ||
-		    bpf_fentry_test9(&retval) != 0)
+		    bpf_fentry_test_ptr1((struct bpf_fentry_test_t *)0) != 0 ||
+		    bpf_fentry_test_ptr2(&arg) != 0 ||
+		    bpf_fentry_test_ptr3(&retval) != 0)
 			goto out;
 		break;
 	case BPF_MODIFY_RETURN:
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
index 26b2d1bffdfd..320003b96c86 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
@@ -125,9 +125,9 @@ static void kprobe_multi_link_api_subtest(void)
 	GET_ADDR("bpf_fentry_test4", addrs[2]);
 	GET_ADDR("bpf_fentry_test5", addrs[3]);
 	GET_ADDR("bpf_fentry_test6", addrs[4]);
-	GET_ADDR("bpf_fentry_test7", addrs[5]);
+	GET_ADDR("bpf_fentry_test_ptr1", addrs[5]);
 	GET_ADDR("bpf_fentry_test2", addrs[6]);
-	GET_ADDR("bpf_fentry_test8", addrs[7]);
+	GET_ADDR("bpf_fentry_test_ptr2", addrs[7]);
 
 #undef GET_ADDR
 
@@ -136,9 +136,9 @@ static void kprobe_multi_link_api_subtest(void)
 	cookies[2] = 3; /* bpf_fentry_test4 */
 	cookies[3] = 4; /* bpf_fentry_test5 */
 	cookies[4] = 5; /* bpf_fentry_test6 */
-	cookies[5] = 6; /* bpf_fentry_test7 */
+	cookies[5] = 6; /* bpf_fentry_test_ptr1 */
 	cookies[6] = 7; /* bpf_fentry_test2 */
-	cookies[7] = 8; /* bpf_fentry_test8 */
+	cookies[7] = 8; /* bpf_fentry_test_ptr2 */
 
 	opts.kprobe_multi.addrs = (const unsigned long *) &addrs;
 	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
@@ -154,9 +154,9 @@ static void kprobe_multi_link_api_subtest(void)
 	cookies[2] = 6; /* bpf_fentry_test4 */
 	cookies[3] = 5; /* bpf_fentry_test5 */
 	cookies[4] = 4; /* bpf_fentry_test6 */
-	cookies[5] = 3; /* bpf_fentry_test7 */
+	cookies[5] = 3; /* bpf_fentry_test_ptr1 */
 	cookies[6] = 2; /* bpf_fentry_test2 */
-	cookies[7] = 1; /* bpf_fentry_test8 */
+	cookies[7] = 1; /* bpf_fentry_test_ptr2 */
 
 	opts.kprobe_multi.flags = BPF_F_KPROBE_MULTI_RETURN;
 	prog_fd = bpf_program__fd(skel->progs.test_kretprobe);
@@ -185,9 +185,9 @@ static void kprobe_multi_attach_api_subtest(void)
 		"bpf_fentry_test4",
 		"bpf_fentry_test5",
 		"bpf_fentry_test6",
-		"bpf_fentry_test7",
+		"bpf_fentry_test_ptr1",
 		"bpf_fentry_test2",
-		"bpf_fentry_test8",
+		"bpf_fentry_test_ptr2",
 	};
 	__u64 cookies[8];
 
@@ -203,9 +203,9 @@ static void kprobe_multi_attach_api_subtest(void)
 	cookies[2] = 3; /* bpf_fentry_test4 */
 	cookies[3] = 4; /* bpf_fentry_test5 */
 	cookies[4] = 5; /* bpf_fentry_test6 */
-	cookies[5] = 6; /* bpf_fentry_test7 */
+	cookies[5] = 6; /* bpf_fentry_test_ptr1 */
 	cookies[6] = 7; /* bpf_fentry_test2 */
-	cookies[7] = 8; /* bpf_fentry_test8 */
+	cookies[7] = 8; /* bpf_fentry_test_ptr2 */
 
 	opts.syms = syms;
 	opts.cnt = ARRAY_SIZE(syms);
@@ -221,9 +221,9 @@ static void kprobe_multi_attach_api_subtest(void)
 	cookies[2] = 6; /* bpf_fentry_test4 */
 	cookies[3] = 5; /* bpf_fentry_test5 */
 	cookies[4] = 4; /* bpf_fentry_test6 */
-	cookies[5] = 3; /* bpf_fentry_test7 */
+	cookies[5] = 3; /* bpf_fentry_test_ptr1 */
 	cookies[6] = 2; /* bpf_fentry_test2 */
-	cookies[7] = 1; /* bpf_fentry_test8 */
+	cookies[7] = 1; /* bpf_fentry_test_ptr2 */
 
 	opts.retprobe = true;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index 2173c4bb555e..15c77fe9fc16 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -105,8 +105,8 @@ static void test_link_api_addrs(void)
 	GET_ADDR("bpf_fentry_test4", addrs[3]);
 	GET_ADDR("bpf_fentry_test5", addrs[4]);
 	GET_ADDR("bpf_fentry_test6", addrs[5]);
-	GET_ADDR("bpf_fentry_test7", addrs[6]);
-	GET_ADDR("bpf_fentry_test8", addrs[7]);
+	GET_ADDR("bpf_fentry_test_ptr1", addrs[6]);
+	GET_ADDR("bpf_fentry_test_ptr2", addrs[7]);
 
 	opts.kprobe_multi.addrs = (const unsigned long*) addrs;
 	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
@@ -123,8 +123,8 @@ static void test_link_api_syms(void)
 		"bpf_fentry_test4",
 		"bpf_fentry_test5",
 		"bpf_fentry_test6",
-		"bpf_fentry_test7",
-		"bpf_fentry_test8",
+		"bpf_fentry_test_ptr1",
+		"bpf_fentry_test_ptr2",
 	};
 
 	opts.kprobe_multi.syms = syms;
@@ -183,8 +183,8 @@ static void test_attach_api_addrs(void)
 	GET_ADDR("bpf_fentry_test4", addrs[3]);
 	GET_ADDR("bpf_fentry_test5", addrs[4]);
 	GET_ADDR("bpf_fentry_test6", addrs[5]);
-	GET_ADDR("bpf_fentry_test7", addrs[6]);
-	GET_ADDR("bpf_fentry_test8", addrs[7]);
+	GET_ADDR("bpf_fentry_test_ptr1", addrs[6]);
+	GET_ADDR("bpf_fentry_test_ptr2", addrs[7]);
 
 	opts.addrs = (const unsigned long *) addrs;
 	opts.cnt = ARRAY_SIZE(addrs);
@@ -201,8 +201,8 @@ static void test_attach_api_syms(void)
 		"bpf_fentry_test4",
 		"bpf_fentry_test5",
 		"bpf_fentry_test6",
-		"bpf_fentry_test7",
-		"bpf_fentry_test8",
+		"bpf_fentry_test_ptr1",
+		"bpf_fentry_test_ptr2",
 	};
 
 	opts.syms = syms;
diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
index 52a550d281d9..558a5f1d3d5c 100644
--- a/tools/testing/selftests/bpf/progs/fentry_test.c
+++ b/tools/testing/selftests/bpf/progs/fentry_test.c
@@ -60,20 +60,20 @@ struct bpf_fentry_test_t {
 	struct bpf_fentry_test_t *a;
 };
 
-__u64 test7_result = 0;
-SEC("fentry/bpf_fentry_test7")
-int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
+__u64 test_ptr1_result = 0;
+SEC("fentry/bpf_fentry_test_ptr1")
+int BPF_PROG(test_ptr1, struct bpf_fentry_test_t *arg)
 {
 	if (!arg)
-		test7_result = 1;
+		test_ptr1_result = 1;
 	return 0;
 }
 
-__u64 test8_result = 0;
-SEC("fentry/bpf_fentry_test8")
-int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
+__u64 test_ptr2_result = 0;
+SEC("fentry/bpf_fentry_test_ptr2")
+int BPF_PROG(test_ptr2, struct bpf_fentry_test_t *arg)
 {
 	if (arg->a == 0)
-		test8_result = 1;
+		test_ptr2_result = 1;
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/fexit_test.c b/tools/testing/selftests/bpf/progs/fexit_test.c
index 8f1ccb7302e1..f57886e6d918 100644
--- a/tools/testing/selftests/bpf/progs/fexit_test.c
+++ b/tools/testing/selftests/bpf/progs/fexit_test.c
@@ -61,20 +61,20 @@ struct bpf_fentry_test_t {
 	struct bpf_fentry_test *a;
 };
 
-__u64 test7_result = 0;
-SEC("fexit/bpf_fentry_test7")
-int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
+__u64 test_ptr1_result = 0;
+SEC("fexit/bpf_fentry_test_ptr1")
+int BPF_PROG(test_ptr1, struct bpf_fentry_test_t *arg)
 {
 	if (!arg)
-		test7_result = 1;
+		test_ptr1_result = 1;
 	return 0;
 }
 
-__u64 test8_result = 0;
-SEC("fexit/bpf_fentry_test8")
-int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
+__u64 test_ptr2_result = 0;
+SEC("fexit/bpf_fentry_test_ptr2")
+int BPF_PROG(test_ptr2, struct bpf_fentry_test_t *arg)
 {
 	if (!arg->a)
-		test8_result = 1;
+		test_ptr2_result = 1;
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
index 8559e698b40d..7fffe2b563fa 100644
--- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
+++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
@@ -12,7 +12,7 @@ extern const void bpf_fentry_test3 __ksym;
 extern const void bpf_fentry_test4 __ksym;
 extern const void bpf_modify_return_test __ksym;
 extern const void bpf_fentry_test6 __ksym;
-extern const void bpf_fentry_test7 __ksym;
+extern const void bpf_fentry_test_ptr1 __ksym;
 
 extern bool CONFIG_X86_KERNEL_IBT __kconfig __weak;
 
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi.c b/tools/testing/selftests/bpf/progs/kprobe_multi.c
index 9e1ca8e34913..e676fb195595 100644
--- a/tools/testing/selftests/bpf/progs/kprobe_multi.c
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi.c
@@ -12,8 +12,8 @@ extern const void bpf_fentry_test3 __ksym;
 extern const void bpf_fentry_test4 __ksym;
 extern const void bpf_fentry_test5 __ksym;
 extern const void bpf_fentry_test6 __ksym;
-extern const void bpf_fentry_test7 __ksym;
-extern const void bpf_fentry_test8 __ksym;
+extern const void bpf_fentry_test_ptr1 __ksym;
+extern const void bpf_fentry_test_ptr2 __ksym;
 
 int pid = 0;
 bool test_cookie = false;
@@ -57,8 +57,8 @@ static void kprobe_multi_check(void *ctx, bool is_return)
 		SET(kretprobe_test4_result, &bpf_fentry_test4, 6);
 		SET(kretprobe_test5_result, &bpf_fentry_test5, 5);
 		SET(kretprobe_test6_result, &bpf_fentry_test6, 4);
-		SET(kretprobe_test7_result, &bpf_fentry_test7, 3);
-		SET(kretprobe_test8_result, &bpf_fentry_test8, 1);
+		SET(kretprobe_test7_result, &bpf_fentry_test_ptr1, 3);
+		SET(kretprobe_test8_result, &bpf_fentry_test_ptr2, 1);
 	} else {
 		SET(kprobe_test1_result, &bpf_fentry_test1, 1);
 		SET(kprobe_test2_result, &bpf_fentry_test2, 7);
@@ -66,8 +66,8 @@ static void kprobe_multi_check(void *ctx, bool is_return)
 		SET(kprobe_test4_result, &bpf_fentry_test4, 3);
 		SET(kprobe_test5_result, &bpf_fentry_test5, 4);
 		SET(kprobe_test6_result, &bpf_fentry_test6, 5);
-		SET(kprobe_test7_result, &bpf_fentry_test7, 6);
-		SET(kprobe_test8_result, &bpf_fentry_test8, 8);
+		SET(kprobe_test7_result, &bpf_fentry_test_ptr1, 6);
+		SET(kprobe_test8_result, &bpf_fentry_test_ptr2, 8);
 	}
 
 #undef SET
diff --git a/tools/testing/selftests/bpf/progs/verifier_btf_ctx_access.c b/tools/testing/selftests/bpf/progs/verifier_btf_ctx_access.c
index a570e48b917a..b90b8a3bf169 100644
--- a/tools/testing/selftests/bpf/progs/verifier_btf_ctx_access.c
+++ b/tools/testing/selftests/bpf/progs/verifier_btf_ctx_access.c
@@ -17,7 +17,7 @@ __naked void btf_ctx_access_accept(void)
 "	::: __clobber_all);
 }
 
-SEC("fentry/bpf_fentry_test9")
+SEC("fentry/bpf_fentry_test_ptr3")
 __description("btf_ctx_access u32 pointer accept")
 __success __retval(0)
 __naked void ctx_access_u32_pointer_accept(void)
diff --git a/tools/testing/selftests/bpf/verifier/atomic_fetch_add.c b/tools/testing/selftests/bpf/verifier/atomic_fetch_add.c
index a91de8cd9def..23d70b11ab80 100644
--- a/tools/testing/selftests/bpf/verifier/atomic_fetch_add.c
+++ b/tools/testing/selftests/bpf/verifier/atomic_fetch_add.c
@@ -88,7 +88,7 @@
 		 * kernel function being called. Load first arg into R2.
 		 */
 		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 0),
-		/* First arg of bpf_fentry_test7 is a pointer to a struct.
+		/* First arg of bpf_fentry_test_ptr1 is a pointer to a struct.
 		 * Attempt to modify that struct. Verifier shouldn't let us
 		 * because it's kernel memory.
 		 */
@@ -100,7 +100,7 @@
 	},
 	.prog_type = BPF_PROG_TYPE_TRACING,
 	.expected_attach_type = BPF_TRACE_FENTRY,
-	.kfunc = "bpf_fentry_test7",
+	.kfunc = "bpf_fentry_test_ptr1",
 	.result = REJECT,
 	.errstr = "only read is supported",
 },
-- 
2.40.1



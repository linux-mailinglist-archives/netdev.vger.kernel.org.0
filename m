Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4E154C748
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 13:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbiFOLVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 07:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243644AbiFOLVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 07:21:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170A141635;
        Wed, 15 Jun 2022 04:21:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AC09FCE1EB2;
        Wed, 15 Jun 2022 11:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D1DC3411F;
        Wed, 15 Jun 2022 11:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655292095;
        bh=gQpvTJizsykqpbNvB/Wa1n2xAu4qKYCH5GGTeAUbDw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axS9izJyO+watvCot6rWPqHJfPSP0SdlbZNofSbnJVMosbjEV+MAx3e4pF7DRWpGR
         DnA9oHI/lUdMhoZKQmsmaM/19jZ57R1DkXGYhkdRv3HTMWdsogAwvtyU/tPj0RHPKc
         I25TwsM9SPMYslbciVjYQFLkTPSQVvyrU/qoH5KgHI7oSUIoMUOtqrAZcl7NU3Z6SG
         ziJSOYCkxUUs3X46qFCUo4K5NLuJfHwB8cw5rkVlRr6uEOeyAumDXPdrkOhP4sibeY
         +iijx0BwgNtdojdP0fpGbBXk/nEISp2p+S0cwU6qUDOl4AZ3Ky/QtJQIoVI//CFA5Z
         YMRd0s3XPdILA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCHv3 bpf 1/4] selftests/bpf: Shuffle cookies symbols in kprobe multi test
Date:   Wed, 15 Jun 2022 13:21:15 +0200
Message-Id: <20220615112118.497303-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220615112118.497303-1-jolsa@kernel.org>
References: <20220615112118.497303-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a kernel bug that causes cookies to be misplaced and
the reason we did not catch this with this test is that we
provide bpf_fentry_test* functions already sorted by name.

Shuffling function bpf_fentry_test2 deeper in the list and
keeping the current cookie values as before will trigger
the bug.

The kernel fix is coming in following changes.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/bpf_cookie.c     | 78 +++++++++----------
 .../selftests/bpf/progs/kprobe_multi.c        | 24 +++---
 2 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
index 83ef55e3caa4..2974b44f80fa 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
@@ -121,24 +121,24 @@ static void kprobe_multi_link_api_subtest(void)
 })
 
 	GET_ADDR("bpf_fentry_test1", addrs[0]);
-	GET_ADDR("bpf_fentry_test2", addrs[1]);
-	GET_ADDR("bpf_fentry_test3", addrs[2]);
-	GET_ADDR("bpf_fentry_test4", addrs[3]);
-	GET_ADDR("bpf_fentry_test5", addrs[4]);
-	GET_ADDR("bpf_fentry_test6", addrs[5]);
-	GET_ADDR("bpf_fentry_test7", addrs[6]);
+	GET_ADDR("bpf_fentry_test3", addrs[1]);
+	GET_ADDR("bpf_fentry_test4", addrs[2]);
+	GET_ADDR("bpf_fentry_test5", addrs[3]);
+	GET_ADDR("bpf_fentry_test6", addrs[4]);
+	GET_ADDR("bpf_fentry_test7", addrs[5]);
+	GET_ADDR("bpf_fentry_test2", addrs[6]);
 	GET_ADDR("bpf_fentry_test8", addrs[7]);
 
 #undef GET_ADDR
 
-	cookies[0] = 1;
-	cookies[1] = 2;
-	cookies[2] = 3;
-	cookies[3] = 4;
-	cookies[4] = 5;
-	cookies[5] = 6;
-	cookies[6] = 7;
-	cookies[7] = 8;
+	cookies[0] = 1; /* bpf_fentry_test1 */
+	cookies[1] = 2; /* bpf_fentry_test3 */
+	cookies[2] = 3; /* bpf_fentry_test4 */
+	cookies[3] = 4; /* bpf_fentry_test5 */
+	cookies[4] = 5; /* bpf_fentry_test6 */
+	cookies[5] = 6; /* bpf_fentry_test7 */
+	cookies[6] = 7; /* bpf_fentry_test2 */
+	cookies[7] = 8; /* bpf_fentry_test8 */
 
 	opts.kprobe_multi.addrs = (const unsigned long *) &addrs;
 	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
@@ -149,14 +149,14 @@ static void kprobe_multi_link_api_subtest(void)
 	if (!ASSERT_GE(link1_fd, 0, "link1_fd"))
 		goto cleanup;
 
-	cookies[0] = 8;
-	cookies[1] = 7;
-	cookies[2] = 6;
-	cookies[3] = 5;
-	cookies[4] = 4;
-	cookies[5] = 3;
-	cookies[6] = 2;
-	cookies[7] = 1;
+	cookies[0] = 8; /* bpf_fentry_test1 */
+	cookies[1] = 7; /* bpf_fentry_test3 */
+	cookies[2] = 6; /* bpf_fentry_test4 */
+	cookies[3] = 5; /* bpf_fentry_test5 */
+	cookies[4] = 4; /* bpf_fentry_test6 */
+	cookies[5] = 3; /* bpf_fentry_test7 */
+	cookies[6] = 2; /* bpf_fentry_test2 */
+	cookies[7] = 1; /* bpf_fentry_test8 */
 
 	opts.kprobe_multi.flags = BPF_F_KPROBE_MULTI_RETURN;
 	prog_fd = bpf_program__fd(skel->progs.test_kretprobe);
@@ -181,12 +181,12 @@ static void kprobe_multi_attach_api_subtest(void)
 	struct kprobe_multi *skel = NULL;
 	const char *syms[8] = {
 		"bpf_fentry_test1",
-		"bpf_fentry_test2",
 		"bpf_fentry_test3",
 		"bpf_fentry_test4",
 		"bpf_fentry_test5",
 		"bpf_fentry_test6",
 		"bpf_fentry_test7",
+		"bpf_fentry_test2",
 		"bpf_fentry_test8",
 	};
 	__u64 cookies[8];
@@ -198,14 +198,14 @@ static void kprobe_multi_attach_api_subtest(void)
 	skel->bss->pid = getpid();
 	skel->bss->test_cookie = true;
 
-	cookies[0] = 1;
-	cookies[1] = 2;
-	cookies[2] = 3;
-	cookies[3] = 4;
-	cookies[4] = 5;
-	cookies[5] = 6;
-	cookies[6] = 7;
-	cookies[7] = 8;
+	cookies[0] = 1; /* bpf_fentry_test1 */
+	cookies[1] = 2; /* bpf_fentry_test3 */
+	cookies[2] = 3; /* bpf_fentry_test4 */
+	cookies[3] = 4; /* bpf_fentry_test5 */
+	cookies[4] = 5; /* bpf_fentry_test6 */
+	cookies[5] = 6; /* bpf_fentry_test7 */
+	cookies[6] = 7; /* bpf_fentry_test2 */
+	cookies[7] = 8; /* bpf_fentry_test8 */
 
 	opts.syms = syms;
 	opts.cnt = ARRAY_SIZE(syms);
@@ -216,14 +216,14 @@ static void kprobe_multi_attach_api_subtest(void)
 	if (!ASSERT_OK_PTR(link1, "bpf_program__attach_kprobe_multi_opts"))
 		goto cleanup;
 
-	cookies[0] = 8;
-	cookies[1] = 7;
-	cookies[2] = 6;
-	cookies[3] = 5;
-	cookies[4] = 4;
-	cookies[5] = 3;
-	cookies[6] = 2;
-	cookies[7] = 1;
+	cookies[0] = 8; /* bpf_fentry_test1 */
+	cookies[1] = 7; /* bpf_fentry_test3 */
+	cookies[2] = 6; /* bpf_fentry_test4 */
+	cookies[3] = 5; /* bpf_fentry_test5 */
+	cookies[4] = 4; /* bpf_fentry_test6 */
+	cookies[5] = 3; /* bpf_fentry_test7 */
+	cookies[6] = 2; /* bpf_fentry_test2 */
+	cookies[7] = 1; /* bpf_fentry_test8 */
 
 	opts.retprobe = true;
 
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi.c b/tools/testing/selftests/bpf/progs/kprobe_multi.c
index 93510f4f0f3a..08f95a8155d1 100644
--- a/tools/testing/selftests/bpf/progs/kprobe_multi.c
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi.c
@@ -54,21 +54,21 @@ static void kprobe_multi_check(void *ctx, bool is_return)
 
 	if (is_return) {
 		SET(kretprobe_test1_result, &bpf_fentry_test1, 8);
-		SET(kretprobe_test2_result, &bpf_fentry_test2, 7);
-		SET(kretprobe_test3_result, &bpf_fentry_test3, 6);
-		SET(kretprobe_test4_result, &bpf_fentry_test4, 5);
-		SET(kretprobe_test5_result, &bpf_fentry_test5, 4);
-		SET(kretprobe_test6_result, &bpf_fentry_test6, 3);
-		SET(kretprobe_test7_result, &bpf_fentry_test7, 2);
+		SET(kretprobe_test2_result, &bpf_fentry_test2, 2);
+		SET(kretprobe_test3_result, &bpf_fentry_test3, 7);
+		SET(kretprobe_test4_result, &bpf_fentry_test4, 6);
+		SET(kretprobe_test5_result, &bpf_fentry_test5, 5);
+		SET(kretprobe_test6_result, &bpf_fentry_test6, 4);
+		SET(kretprobe_test7_result, &bpf_fentry_test7, 3);
 		SET(kretprobe_test8_result, &bpf_fentry_test8, 1);
 	} else {
 		SET(kprobe_test1_result, &bpf_fentry_test1, 1);
-		SET(kprobe_test2_result, &bpf_fentry_test2, 2);
-		SET(kprobe_test3_result, &bpf_fentry_test3, 3);
-		SET(kprobe_test4_result, &bpf_fentry_test4, 4);
-		SET(kprobe_test5_result, &bpf_fentry_test5, 5);
-		SET(kprobe_test6_result, &bpf_fentry_test6, 6);
-		SET(kprobe_test7_result, &bpf_fentry_test7, 7);
+		SET(kprobe_test2_result, &bpf_fentry_test2, 7);
+		SET(kprobe_test3_result, &bpf_fentry_test3, 2);
+		SET(kprobe_test4_result, &bpf_fentry_test4, 3);
+		SET(kprobe_test5_result, &bpf_fentry_test5, 4);
+		SET(kprobe_test6_result, &bpf_fentry_test6, 5);
+		SET(kprobe_test7_result, &bpf_fentry_test7, 6);
 		SET(kprobe_test8_result, &bpf_fentry_test8, 8);
 	}
 
-- 
2.35.3


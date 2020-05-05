Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347F31C6260
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgEEUvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728569AbgEEUvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:51:47 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C3CC061A0F;
        Tue,  5 May 2020 13:51:47 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w4so3488274ioc.6;
        Tue, 05 May 2020 13:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=05uEoFAoVbEeJ1tTIX0W7kdA7fKvFHeuhtHhq/q3C6s=;
        b=FIQYDoVTLCL3hjn4j0R+hu7GW3elA5OR8ScLlUkfiqVuFw1zBwTtmY3xdRI8zuF+S1
         MfHrl4cS+LwyQ89NbsIM9fk9GYL8ct+SjbAXwha2ta2Xef7H6yeZlO6Df+5EzVO/FibF
         /WkTGF3PXgDyQtXclortUl1Uc2f8zGEVu7fHWNty3g9sApV5KL5Qa1oI+hgW5a4ZdXdc
         BBZTI+Occ5OYNqXQHP2Xqs3kama1WydozTEb7n9e7gPcQhYR25M3Ap1HVkSj8e6LwJq2
         EE7bXuADioEglAPZ2GvDRTZ5jvw2CKk4+hlYhPDYlTIjZ+7wJBD/xnLff5YZmEJTwrPW
         UN3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=05uEoFAoVbEeJ1tTIX0W7kdA7fKvFHeuhtHhq/q3C6s=;
        b=FmAS+msZMs9m78DtmPkgLzAxMB5jxFECJgHxKGwAU2kCsQVaY7qcwLOlTqoXqmwayF
         VrftBsYoC2TtNiI6ngmPGOod+hhNzSSUb0hHeTwq23CFNNvPbPfi5tegli+sjwnOOZ09
         TJMsimTMBqAxY1tVIp2o9FmRcKRu0Z267FNUMh+u8GJ4EV1d3X0Eu56xp2motRSGDjyK
         0d9Q4jRJ/MoXx/CV6Y6yOoCXLapxDbEn1uo1tNrsNVGdT8GRPsv4UG+SPID2V5SNF1EH
         K9j9jlPA8GzWk/nEH1G4XSIZZZHhWPh1B6XIlBEYmq+cV4+vRI2CAC0Vg64RbThzKfga
         GJ6Q==
X-Gm-Message-State: AGi0PubWszl/UJeDApPcWtmG6q4fs6rOf/OfeX5Q7z1UFfgpibaiMypR
        aSoe26UpKanqzlz88/eFnRA=
X-Google-Smtp-Source: APiQypJsx8WAN8t/ZU8GYPLKSZz7t8VlBBvPhJJVPb83AXmU4M6dUOPDY7kXDQbJugxA90OqvpdGlg==
X-Received: by 2002:a6b:2b94:: with SMTP id r142mr5458979ior.27.1588711906305;
        Tue, 05 May 2020 13:51:46 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s5sm2373949ili.59.2020.05.05.13.51.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 13:51:45 -0700 (PDT)
Subject: [bpf-next PATCH 06/10] bpf: selftests,
 break down test_sockmap into subtests
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Tue, 05 May 2020 13:51:33 -0700
Message-ID: <158871189325.7537.857131657299618224.stgit@john-Precision-5820-Tower>
In-Reply-To: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment test_sockmap runs all 800+ tests ungrouped which is not
ideal because it makes it hard to see what is failing but also more
importantly its hard to confirm all cases are tested. Additionally,
after inspecting we noticed the runtime is bloated because we run
many duplicate tests. Worse some of these tests are known error cases
that wait for the recvmsg handler to timeout which creats long delays.
Also we noted some tests were not clearing their options and as a
result the following tests would run with extra and incorrect options.

Fix this by reorganizing test code so its clear what tests are running
and when. Then it becomes easy to remove duplication and run tests with
only the set of send/recv patterns that are relavent.

To accomplish this break test_sockmap into subtests and remove
unnecessary duplication. The output is more readable now and
the runtime reduced.

Now default output prints subtests like this,

 $ ./test_sockmap
 # 1/ 6  sockmap:txmsg test passthrough:OK
 ...
 #22/ 1 sockhash:txmsg test push/pop data:OK
 Pass: 22 Fail: 0

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |  723 +++++++++++++---------------
 1 file changed, 348 insertions(+), 375 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 36aca86..6782d51 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -54,7 +54,7 @@ static void running_handler(int a);
 #define S1_PORT 10000
 #define S2_PORT 10001
 
-#define BPF_SOCKMAP_FILENAME "test_sockmap_kern.o"
+#define BPF_SOCKMAP_FILENAME  "test_sockmap_kern.o"
 #define BPF_SOCKHASH_FILENAME "test_sockhash_kern.o"
 #define CG_PATH "/sockmap"
 
@@ -110,6 +110,76 @@ static const struct option long_options[] = {
 	{0, 0, NULL, 0 }
 };
 
+struct test_env {
+	const char *type;
+	const char *subtest;
+
+	int test_num;
+	int subtest_num;
+
+	int succ_cnt;
+	int fail_cnt;
+	int fail_last;
+};
+
+struct test_env env;
+
+static void test_start(void)
+{
+	env.subtest_num++;
+}
+
+static void test_fail(void)
+{
+	env.fail_cnt++;
+}
+
+static void test_pass(void)
+{
+	env.succ_cnt++;
+}
+
+static void test_reset(void)
+{
+	txmsg_start = txmsg_end = 0;
+	txmsg_start_pop = txmsg_pop = 0;
+	txmsg_start_push = txmsg_end_push = 0;
+	txmsg_pass = txmsg_drop = txmsg_redir = 0;
+	txmsg_apply = txmsg_cork = 0;
+	txmsg_ingress = txmsg_skb = 0;
+}
+
+static int test_start_subtest(const char *name, const char *type)
+{
+	env.type = type;
+	env.subtest = name;
+	env.test_num++;
+	env.subtest_num = 0;
+	env.fail_last = env.fail_cnt;
+	test_reset();
+	return 0;
+}
+
+static void test_end_subtest(void)
+{
+	int error = env.fail_cnt - env.fail_last;
+	int type = strcmp(env.type, BPF_SOCKMAP_FILENAME);
+
+	if (!error)
+		test_pass();
+
+	fprintf(stdout, "#%2d/%2d %8s:%s:%s\n",
+		env.test_num, env.subtest_num,
+		!type ? "sockmap" : "sockhash",
+		env.subtest, error ? "FAIL" : "OK");
+}
+
+static void test_print_results(void)
+{
+	fprintf(stdout, "Pass: %d Fail: %d\n",
+		env.succ_cnt, env.fail_cnt);
+}
+
 static void usage(char *argv[])
 {
 	int i;
@@ -316,6 +386,7 @@ struct sockmap_options {
 	int iov_count;
 	int iov_length;
 	int rate;
+	char *map;
 };
 
 static int msg_loop_sendpage(int fd, int iov_length, int cnt,
@@ -1169,416 +1240,305 @@ static int __test_exec(int cgrp, int test, struct sockmap_options *opt)
 
 	test_options(options);
 
-	fprintf(stdout,
-		"[TEST %i]: (%i, %i, %i, %s, %s): ",
-		test_cnt, opt->rate, opt->iov_count, opt->iov_length,
-		test_to_str(test), options);
-	fflush(stdout);
+	if (opt->verbose) {
+		fprintf(stdout,
+			"[TEST %i]: (%i, %i, %i, %s, %s): ",
+			test_cnt, opt->rate, opt->iov_count, opt->iov_length,
+			test_to_str(test), options);
+		fflush(stdout);
+	}
 	err = run_options(opt, cgrp, test);
-	fprintf(stdout, "%s\n", !err ? "PASS" : "FAILED");
+	if (opt->verbose)
+		fprintf(stdout, "%s\n", !err ? "PASS" : "FAILED");
 	test_cnt++;
 	!err ? passed++ : failed++;
 	free(options);
 	return err;
 }
 
-static int test_exec(int cgrp, struct sockmap_options *opt)
-{
-	int err = __test_exec(cgrp, SENDMSG, opt);
-
-	if (err)
-		goto out;
-
-	err = __test_exec(cgrp, SENDPAGE, opt);
-out:
-	return err;
-}
-
-static int test_loop(int cgrp)
-{
-	struct sockmap_options opt;
-
-	int err, i, l, r;
-
-	opt.verbose = 0;
-	opt.base = false;
-	opt.sendpage = false;
-	opt.data_test = false;
-	opt.drop_expected = false;
-	opt.iov_count = 0;
-	opt.iov_length = 0;
-	opt.rate = 0;
-
-	r = 1;
-	for (i = 1; i < 100; i += 33) {
-		for (l = 1; l < 100; l += 33) {
-			opt.rate = r;
-			opt.iov_count = i;
-			opt.iov_length = l;
-			err = test_exec(cgrp, &opt);
-			if (err)
-				goto out;
-		}
-	}
-	sched_yield();
-out:
-	return err;
-}
-
-static int test_txmsg(int cgrp)
+static void test_exec(int cgrp, struct sockmap_options *opt)
 {
+	int type = strcmp(opt->map, BPF_SOCKMAP_FILENAME);
 	int err;
 
-	txmsg_pass = txmsg_drop = 0;
-	txmsg_apply = txmsg_cork = 0;
-	txmsg_ingress = txmsg_skb = 0;
-
-	txmsg_pass = 1;
-	err = test_loop(cgrp);
-	txmsg_pass = 0;
-	if (err)
-		goto out;
-
-	txmsg_redir = 1;
-	err = test_loop(cgrp);
-	txmsg_redir = 0;
-	if (err)
-		goto out;
-
-	txmsg_drop = 1;
-	err = test_loop(cgrp);
-	txmsg_drop = 0;
-	if (err)
-		goto out;
-
-	txmsg_redir = 1;
-	txmsg_ingress = 1;
-	err = test_loop(cgrp);
-	txmsg_redir = 0;
-	txmsg_ingress = 0;
-	if (err)
-		goto out;
-out:
-	txmsg_pass = 0;
-	txmsg_redir = 0;
-	txmsg_drop = 0;
-	return err;
+	if (type == 0) {
+		test_start();
+		err = __test_exec(cgrp, SENDMSG, opt);
+		if (err)
+			test_fail();
+	} else {
+		test_start();
+		err = __test_exec(cgrp, SENDPAGE, opt);
+		if (err)
+			test_fail();
+	}
 }
 
-static int test_send(struct sockmap_options *opt, int cgrp)
+static void test_send_one(struct sockmap_options *opt, int cgrp)
 {
-	int err;
-
 	opt->iov_length = 1;
 	opt->iov_count = 1;
 	opt->rate = 1;
-	err = test_exec(cgrp, opt);
-	if (err)
-		goto out;
+	test_exec(cgrp, opt);
 
 	opt->iov_length = 1;
 	opt->iov_count = 1024;
 	opt->rate = 1;
-	err = test_exec(cgrp, opt);
-	if (err)
-		goto out;
+	test_exec(cgrp, opt);
 
 	opt->iov_length = 1024;
 	opt->iov_count = 1;
 	opt->rate = 1;
-	err = test_exec(cgrp, opt);
-	if (err)
-		goto out;
+	test_exec(cgrp, opt);
 
-	opt->iov_length = 1;
+}
+
+static void test_send_many(struct sockmap_options *opt, int cgrp)
+{
+	opt->iov_length = 3;
 	opt->iov_count = 1;
 	opt->rate = 512;
-	err = test_exec(cgrp, opt);
-	if (err)
-		goto out;
+	test_exec(cgrp, opt);
+
+	opt->rate = 100;
+	opt->iov_count = 1;
+	opt->iov_length = 5;
+	test_exec(cgrp, opt);
+}
 
+static void test_send_large(struct sockmap_options *opt, int cgrp)
+{
 	opt->iov_length = 256;
 	opt->iov_count = 1024;
 	opt->rate = 2;
-	err = test_exec(cgrp, opt);
-	if (err)
-		goto out;
+	test_exec(cgrp, opt);
+}
 
-	opt->rate = 100;
-	opt->iov_count = 1;
-	opt->iov_length = 5;
-	err = test_exec(cgrp, opt);
-	if (err)
-		goto out;
-out:
+static void test_send(struct sockmap_options *opt, int cgrp)
+{
+	test_send_one(opt, cgrp);
+	test_send_many(opt, cgrp);
+	test_send_large(opt, cgrp);
 	sched_yield();
-	return err;
 }
 
-static int test_mixed(int cgrp)
+static void test_txmsg_pass(int cgrp, char *map)
 {
-	struct sockmap_options opt = {0};
-	int err;
-
-	txmsg_pass = txmsg_drop = 0;
-	txmsg_apply = txmsg_cork = 0;
-	txmsg_start = txmsg_end = 0;
-	txmsg_start_push = txmsg_end_push = 0;
-	txmsg_start_pop = txmsg_pop = 0;
+	struct sockmap_options opt = {.map = map};
 
 	/* Test small and large iov_count values with pass/redir/apply/cork */
 	txmsg_pass = 1;
-	txmsg_redir = 0;
-	txmsg_apply = 1;
-	txmsg_cork = 0;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
+	test_send(&opt, cgrp);
+}
 
-	txmsg_pass = 1;
-	txmsg_redir = 0;
-	txmsg_apply = 0;
-	txmsg_cork = 1;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
+static void test_txmsg_redir(int cgrp, char *map)
+{
+	struct sockmap_options opt = {.map = map};
 
-	txmsg_pass = 1;
-	txmsg_redir = 0;
-	txmsg_apply = 1;
-	txmsg_cork = 1;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
+	txmsg_redir = 1;
+	test_send(&opt, cgrp);
+}
 
-	txmsg_pass = 1;
-	txmsg_redir = 0;
-	txmsg_apply = 1024;
-	txmsg_cork = 0;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
+static void test_txmsg_drop(int cgrp, char *map)
+{
+	struct sockmap_options opt = {.map = map};
 
-	txmsg_pass = 1;
-	txmsg_redir = 0;
-	txmsg_apply = 0;
-	txmsg_cork = 1024;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
+	txmsg_drop = 1;
+	test_send(&opt, cgrp);
+}
 
-	txmsg_pass = 1;
-	txmsg_redir = 0;
-	txmsg_apply = 1024;
-	txmsg_cork = 1024;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
+static void test_txmsg_ingress_redir(int cgrp, char *map)
+{
+	struct sockmap_options opt = {.map = map};
+
+	txmsg_pass = txmsg_drop = 0;
+	txmsg_ingress = txmsg_redir = 1;
+	test_send(&opt, cgrp);
+}
+
+/* Test cork with hung data. This tests poor usage patterns where
+ * cork can leave data on the ring if user program is buggy and
+ * doesn't flush them somehow. They do take some time however
+ * because they wait for a timeout. Test pass, redir and cork with
+ * apply logic. Use cork size of 4097 with send_large to avoid
+ * aligning cork size with send size.
+ */
+static void test_txmsg_cork_hangs(int cgrp, char *map)
+{
+	struct sockmap_options opt = {.map = map};
 
 	txmsg_pass = 1;
 	txmsg_redir = 0;
-	txmsg_cork = 4096;
-	txmsg_apply = 4096;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
-
-	txmsg_pass = 0;
-	txmsg_redir = 1;
-	txmsg_apply = 1;
-	txmsg_cork = 0;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
+	txmsg_cork = 4097;
+	txmsg_apply = 4097;
+	test_send_large(&opt, cgrp);
 
 	txmsg_pass = 0;
 	txmsg_redir = 1;
 	txmsg_apply = 0;
-	txmsg_cork = 1;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
+	txmsg_cork = 4097;
+	test_send_large(&opt, cgrp);
 
 	txmsg_pass = 0;
 	txmsg_redir = 1;
-	txmsg_apply = 1024;
-	txmsg_cork = 0;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
+	txmsg_apply = 4097;
+	txmsg_cork = 4097;
+	test_send_large(&opt, cgrp);
+}
 
-	txmsg_pass = 0;
+static void test_txmsg_pull(int cgrp, char *map)
+{
+	struct sockmap_options opt = {.map = map};
+
+	/* Test basic start/end */
+	txmsg_start = 1;
+	txmsg_end = 2;
+	test_send(&opt, cgrp);
+
+	/* Test >4k pull */
+	txmsg_start = 4096;
+	txmsg_end = 9182;
+	test_send_large(&opt, cgrp);
+
+	/* Test pull + redirect */
+	txmsg_redir = 0;
+	txmsg_start = 1;
+	txmsg_end = 2;
+	test_send(&opt, cgrp);
+
+	/* Test pull + cork */
+	txmsg_redir = 0;
+	txmsg_cork = 512;
+	txmsg_start = 1;
+	txmsg_end = 2;
+	test_send_many(&opt, cgrp);
+
+	/* Test pull + cork + redirect */
 	txmsg_redir = 1;
-	txmsg_apply = 0;
-	txmsg_cork = 1024;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
+	txmsg_cork = 512;
+	txmsg_start = 1;
+	txmsg_end = 2;
+	test_send_many(&opt, cgrp);
+}
 
-	txmsg_pass = 0;
+static void test_txmsg_pop(int cgrp, char *map)
+{
+	struct sockmap_options opt = {.map = map};
+
+	/* Test basic pop */
+	txmsg_start_pop = 1;
+	txmsg_pop = 2;
+	test_send_many(&opt, cgrp);
+
+	/* Test pop with >4k */
+	txmsg_start_pop = 4096;
+	txmsg_pop = 4096;
+	test_send_large(&opt, cgrp);
+
+	/* Test pop + redirect */
 	txmsg_redir = 1;
-	txmsg_apply = 1024;
-	txmsg_cork = 1024;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
+	txmsg_start_pop = 1;
+	txmsg_pop = 2;
+	test_send_many(&opt, cgrp);
 
-	txmsg_pass = 0;
+	/* Test pop + cork */
+	txmsg_redir = 0;
+	txmsg_cork = 512;
+	txmsg_start_pop = 1;
+	txmsg_pop = 2;
+	test_send_many(&opt, cgrp);
+
+	/* Test pop + redirect + cork */
 	txmsg_redir = 1;
-	txmsg_cork = 4096;
-	txmsg_apply = 4096;
-	err = test_send(&opt, cgrp);
-	if (err)
-		goto out;
-out:
-	return err;
+	txmsg_cork = 4;
+	txmsg_start_pop = 1;
+	txmsg_pop = 2;
+	test_send_many(&opt, cgrp);
 }
 
-static int test_start_end(int cgrp)
+static void test_txmsg_push(int cgrp, char *map)
 {
-	struct sockmap_options opt = {0};
-	int err, i;
+	struct sockmap_options opt = {.map = map};
 
-	/* Test basic start/end with lots of iov_count and iov_lengths */
-	txmsg_start = 1;
-	txmsg_end = 2;
+	/* Test basic push */
+	txmsg_start_push = 1;
+	txmsg_end_push = 1;
+	test_send(&opt, cgrp);
+
+	/* Test push 4kB >4k */
+	txmsg_start_push = 4096;
+	txmsg_end_push = 4096;
+	test_send_large(&opt, cgrp);
+
+	/* Test push + redirect */
+	txmsg_redir = 1;
 	txmsg_start_push = 1;
 	txmsg_end_push = 2;
-	txmsg_start_pop = 1;
-	txmsg_pop = 1;
-	err = test_txmsg(cgrp);
-	if (err)
-		goto out;
+	test_send_many(&opt, cgrp);
 
-	/* Cut a byte of pushed data but leave reamining in place */
-	txmsg_start = 1;
-	txmsg_end = 2;
+	/* Test push + cork */
+	txmsg_redir = 0;
+	txmsg_cork = 512;
 	txmsg_start_push = 1;
-	txmsg_end_push = 3;
-	txmsg_start_pop = 1;
-	txmsg_pop = 1;
-	err = test_txmsg(cgrp);
-	if (err)
-		goto out;
+	txmsg_end_push = 2;
+	test_send_many(&opt, cgrp);
+}
 
-	/* Test start/end with cork */
-	opt.rate = 16;
-	opt.iov_count = 1;
-	opt.iov_length = 100;
-	txmsg_cork = 1600;
-
-	txmsg_start_pop = 0;
-	txmsg_pop = 0;
-
-	for (i = 99; i <= 1600; i += 500) {
-		txmsg_start = 0;
-		txmsg_end = i;
-		txmsg_start_push = 0;
-		txmsg_end_push = i;
-		err = test_exec(cgrp, &opt);
-		if (err)
-			goto out;
-	}
+static void test_txmsg_push_pop(int cgrp, char *map)
+{
+	struct sockmap_options opt = {.map = map};
 
-	/* Test pop data in middle of cork */
-	for (i = 99; i <= 1600; i += 500) {
-		txmsg_start_pop = 10;
-		txmsg_pop = i;
-		err = test_exec(cgrp, &opt);
-		if (err)
-			goto out;
-	}
-	txmsg_start_pop = 0;
-	txmsg_pop = 0;
-
-	/* Test start/end with cork but pull data in middle */
-	for (i = 199; i <= 1600; i += 500) {
-		txmsg_start = 100;
-		txmsg_end = i;
-		txmsg_start_push = 100;
-		txmsg_end_push = i;
-		err = test_exec(cgrp, &opt);
-		if (err)
-			goto out;
-	}
+	txmsg_start_push = 1;
+	txmsg_end_push = 10;
+	txmsg_start_pop = 5;
+	txmsg_pop = 4;
+	test_send_large(&opt, cgrp);
+}
 
-	/* Test start/end with cork pulling last sg entry */
-	txmsg_start = 1500;
-	txmsg_end = 1600;
-	txmsg_start_push = 1500;
-	txmsg_end_push = 1600;
-	err = test_exec(cgrp, &opt);
-	if (err)
-		goto out;
+static void test_txmsg_apply(int cgrp, char *map)
+{
+	struct sockmap_options opt = {.map = map};
 
-	/* Test pop with cork pulling last sg entry */
-	txmsg_start_pop = 1500;
-	txmsg_pop = 1600;
-	err = test_exec(cgrp, &opt);
-	if (err)
-		goto out;
-	txmsg_start_pop = 0;
-	txmsg_pop = 0;
-
-	/* Test start/end pull of single byte in last page */
-	txmsg_start = 1111;
-	txmsg_end = 1112;
-	txmsg_start_push = 1111;
-	txmsg_end_push = 1112;
-	err = test_exec(cgrp, &opt);
-	if (err)
-		goto out;
+	txmsg_pass = 1;
+	txmsg_redir = 0;
+	txmsg_apply = 1;
+	txmsg_cork = 0;
+	test_send_one(&opt, cgrp);
 
-	/* Test pop of single byte in last page */
-	txmsg_start_pop = 1111;
-	txmsg_pop = 1112;
-	err = test_exec(cgrp, &opt);
-	if (err)
-		goto out;
+	txmsg_pass = 0;
+	txmsg_redir = 1;
+	txmsg_apply = 1;
+	txmsg_cork = 0;
+	test_send_one(&opt, cgrp);
 
-	/* Test start/end with end < start */
-	txmsg_start = 1111;
-	txmsg_end = 0;
-	txmsg_start_push = 1111;
-	txmsg_end_push = 0;
-	err = test_exec(cgrp, &opt);
-	if (err)
-		goto out;
+	txmsg_pass = 1;
+	txmsg_redir = 0;
+	txmsg_apply = 1024;
+	txmsg_cork = 0;
+	test_send_large(&opt, cgrp);
 
-	/* Test start/end with end > data */
-	txmsg_start = 0;
-	txmsg_end = 1601;
-	txmsg_start_push = 0;
-	txmsg_end_push = 1601;
-	err = test_exec(cgrp, &opt);
-	if (err)
-		goto out;
+	txmsg_pass = 0;
+	txmsg_redir = 1;
+	txmsg_apply = 1024;
+	txmsg_cork = 0;
+	test_send_large(&opt, cgrp);
+}
 
-	/* Test start/end with start > data */
-	txmsg_start = 1601;
-	txmsg_end = 1600;
-	txmsg_start_push = 1601;
-	txmsg_end_push = 1600;
-	err = test_exec(cgrp, &opt);
-	if (err)
-		goto out;
+static void test_txmsg_cork(int cgrp, char *map)
+{
+	struct sockmap_options opt = {.map = map};
 
-	/* Test pop with start > data */
-	txmsg_start_pop = 1601;
-	txmsg_pop = 1;
-	err = test_exec(cgrp, &opt);
-	if (err)
-		goto out;
+	txmsg_pass = 1;
+	txmsg_redir = 0;
+	txmsg_apply = 0;
+	txmsg_cork = 1;
+	test_send(&opt, cgrp);
 
-	/* Test pop with pop range > data */
-	txmsg_start_pop = 1599;
-	txmsg_pop = 10;
-	err = test_exec(cgrp, &opt);
-out:
-	txmsg_start = 0;
-	txmsg_end = 0;
-	sched_yield();
-	return err;
+	txmsg_pass = 1;
+	txmsg_redir = 0;
+	txmsg_apply = 1;
+	txmsg_cork = 1;
+	test_send(&opt, cgrp);
 }
 
 char *map_names[] = {
@@ -1663,16 +1623,59 @@ static int populate_progs(char *bpf_file)
 	return 0;
 }
 
-static int __test_suite(int cg_fd, char *bpf_file)
+struct _test {
+	char *title;
+	void (*tester)(int cg_fd, char *map);
+};
+
+struct _test test[] = {
+	{"txmsg test passthrough", test_txmsg_pass},
+	{"txmsg test redirect", test_txmsg_redir},
+	{"txmsg test drop", test_txmsg_drop},
+	{"txmsg test ingress redirect", test_txmsg_ingress_redir},
+	{"txmsg test apply", test_txmsg_apply},
+	{"txmsg test cork", test_txmsg_cork},
+	{"txmsg test hanging corks", test_txmsg_cork_hangs},
+	{"txmsg test push_data", test_txmsg_push},
+	{"txmsg test pull-data", test_txmsg_pull},
+	{"txmsg test pop-data", test_txmsg_pop},
+	{"txmsg test push/pop data", test_txmsg_push_pop},
+};
+
+static int __test_selftests(int cg_fd, char *map)
 {
-	int err, cleanup = cg_fd;
+	int i, err;
 
-	err = populate_progs(bpf_file);
+	err = populate_progs(map);
 	if (err < 0) {
 		fprintf(stderr, "ERROR: (%i) load bpf failed\n", err);
 		return err;
 	}
 
+	/* Tests basic commands and APIs */
+	for (i = 0; i < sizeof(test)/sizeof(struct _test); i++) {
+		struct _test t = test[i];
+
+		test_start_subtest(t.title, map);
+		t.tester(cg_fd, map);
+		test_end_subtest();
+	}
+
+	return err;
+}
+
+static void test_selftests_sockmap(int cg_fd)
+{
+	__test_selftests(cg_fd, BPF_SOCKMAP_FILENAME);
+}
+
+static void test_selftests_sockhash(int cg_fd)
+{
+	__test_selftests(cg_fd, BPF_SOCKHASH_FILENAME);
+}
+
+static int test_selftest(int cg_fd)
+{
 	if (cg_fd < 0) {
 		if (setup_cgroup_environment()) {
 			fprintf(stderr, "ERROR: cgroup env failed\n");
@@ -1693,43 +1696,12 @@ static int __test_suite(int cg_fd, char *bpf_file)
 		}
 	}
 
-	/* Tests basic commands and APIs with range of iov values */
-	txmsg_start = txmsg_end = txmsg_start_push = txmsg_end_push = 0;
-	err = test_txmsg(cg_fd);
-	if (err)
-		goto out;
-
-	/* Tests interesting combinations of APIs used together */
-	err = test_mixed(cg_fd);
-	if (err)
-		goto out;
-
-	/* Tests pull_data API using start/end API */
-	err = test_start_end(cg_fd);
-	if (err)
-		goto out;
-
-out:
-	printf("Summary: %i PASSED %i FAILED\n", passed, failed);
-	if (cleanup < 0) {
-		cleanup_cgroup_environment();
-		close(cg_fd);
-	}
-	return err;
-}
-
-static int test_suite(int cg_fd)
-{
-	int err;
-
-	err = __test_suite(cg_fd, BPF_SOCKMAP_FILENAME);
-	if (err)
-		goto out;
-	err = __test_suite(cg_fd, BPF_SOCKHASH_FILENAME);
-out:
-	if (cg_fd > -1)
-		close(cg_fd);
-	return err;
+	test_selftests_sockmap(cg_fd);
+	test_selftests_sockhash(cg_fd);
+	cleanup_cgroup_environment();
+	close(cg_fd);
+	test_print_results();
+	return 0;
 }
 
 int main(int argc, char **argv)
@@ -1741,8 +1713,9 @@ int main(int argc, char **argv)
 	int test = PING_PONG;
 	bool cg_created = 0;
 
-	if (argc < 2)
-		return test_suite(-1);
+	if (argc < 2) {
+		return test_selftest(-1);
+	}
 
 	while ((opt = getopt_long(argc, argv, ":dhvc:r:i:l:t:p:q:",
 				  long_options, &longindex)) != -1) {


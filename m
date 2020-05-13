Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED861D1ECB
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390512AbgEMTPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390350AbgEMTPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:15:19 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D356C061A0C;
        Wed, 13 May 2020 12:15:19 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t12so804983ile.9;
        Wed, 13 May 2020 12:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=GAAByVTJNqiXLpzbxW3ab2zi8RC0W1HYCHDXkoGhblQ=;
        b=FiJZ6zRAPjJycKxUqNJpy9Tr1CwNsUzhQYhKZ0fVwWDNF3OPdXIEO+5hsF7R45/ZGy
         VFE5UY+HxeRzo74jAcTS8BamnyGdeLRKkfEEOvuJ4QW/xz2MM81Rv7dkJvSrYfk6IZu7
         tNKVbnBTlTBh75Grk7oMJ8QhhjYYerZvQUqhfYGmXU78E05thPJ5HVR9laetqygscfrx
         WI6hIh+wpCCTm5kWpRvuGvROVAw2ZShxUFHEiSitCZdVviu7x6R2G2563g4shHvATi7x
         mkmdAJubV6x2dmeAh8uf6eaICeW6SLFXByloUWT2evI1bwRro3HLhWUwEl+Ec0p6IbRb
         rgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GAAByVTJNqiXLpzbxW3ab2zi8RC0W1HYCHDXkoGhblQ=;
        b=XCae5pO9LBENTQDLDKZKtiaNh+XhMayhytlYidyq8GQkLvzw7cjg+smNxI2cK1pKrx
         aetCNKB5EvCQAierz05gt/bbmY0YsZMNy53PAnXoQxl0wJDJA8+6EpUmlQXNJU6esAqw
         n/TGdOAcxGhWA4CLl+F2wWYlPBuHozu7/XN3iZvDEplSjiTzJbZCzTiLmqqmu3i03A8I
         1tdQTLvtAfXNCY19TDJY4pZfM2DCBSMtWX1QAhw4wf4U+gtr9yhRlJ7SXh/j7rNRkJXv
         eTfHze1bmiBa4dPdCBJFgA7D7ggL7DayZ6yJaqundlHLBaLgSpZjTqy0iWO9H/W6U4Ex
         v56g==
X-Gm-Message-State: AOAM530kBxDGr0CikVttkkuLtRYL/jiQ3uEmSQ1Wats8s4o+msGvHhRE
        9phLq80KS7sEJBMtyYcs/gw=
X-Google-Smtp-Source: ABdhPJweikmwaZKdJmUBVLRh5Cq2QpSe/uxv27EIQwyH/MmtWvHT1OOQMr2Pb9StkqZZGN/JW75vLg==
X-Received: by 2002:a92:cd01:: with SMTP id z1mr934627iln.182.1589397318796;
        Wed, 13 May 2020 12:15:18 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l13sm163744ils.8.2020.05.13.12.15.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:15:18 -0700 (PDT)
Subject: [bpf-next PATCH v2 09/12] bpf: selftests,
 provide verbose option for selftests execution
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Wed, 13 May 2020 12:15:04 -0700
Message-ID: <158939730412.15176.1975675235035143367.stgit@john-Precision-5820-Tower>
In-Reply-To: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
References: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass options from command line args into individual tests which allows us
to use verbose option from command line with selftests. Now when verbose
option is set individual subtest details will be printed. Also we can
consolidate cgroup bring up and tear down.

Additionally just setting verbose is very noisy so introduce verbose=1
and verbose=2. Really verbose=2 is only useful when developing tests
or debugging some specific issue.

For example now we get output like this with --verbose,

#20/17 sockhash:txmsg test pull-data:OK
 [TEST 160]: (512, 1, 3, sendpage, pop (1,3),): msg_loop_rx: iov_count 1 iov_buf 1 cnt 512 err 0
 [TEST 161]: (100, 1, 5, sendpage, pop (1,3),): msg_loop_rx: iov_count 1 iov_buf 3 cnt 100 err 0
 [TEST 162]: (2, 1024, 256, sendpage, pop (4096,8192),): msg_loop_rx: iov_count 1 iov_buf 255 cnt 2 err 0
 [TEST 163]: (512, 1, 3, sendpage, redir,pop (1,3),): msg_loop_rx: iov_count 1 iov_buf 1 cnt 512 err 0
 [TEST 164]: (100, 1, 5, sendpage, redir,pop (1,3),): msg_loop_rx: iov_count 1 iov_buf 3 cnt 100 err 0
 [TEST 165]: (512, 1, 3, sendpage, cork 512,pop (1,3),): msg_loop_rx: iov_count 1 iov_buf 1 cnt 512 err 0
 [TEST 166]: (100, 1, 5, sendpage, cork 512,pop (1,3),): msg_loop_rx: iov_count 1 iov_buf 3 cnt 100 err 0
 [TEST 167]: (512, 1, 3, sendpage, redir,cork 4,pop (1,3),): msg_loop_rx: iov_count 1 iov_buf 1 cnt 512 err 0
 [TEST 168]: (100, 1, 5, sendpage, redir,cork 4,pop (1,3),): msg_loop_rx: iov_count 1 iov_buf 3 cnt 100 err 0

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |  179 +++++++++++-----------------
 1 file changed, 71 insertions(+), 108 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index ad0540a..2be8d9d 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -87,7 +87,7 @@ static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
 	{"cgroup",	required_argument,	NULL, 'c' },
 	{"rate",	required_argument,	NULL, 'r' },
-	{"verbose",	no_argument,		NULL, 'v' },
+	{"verbose",	optional_argument,	NULL, 'v' },
 	{"iov_count",	required_argument,	NULL, 'i' },
 	{"length",	required_argument,	NULL, 'l' },
 	{"test",	required_argument,	NULL, 't' },
@@ -362,7 +362,7 @@ static int sockmap_init_sockets(int verbose)
 		return errno;
 	}
 
-	if (verbose) {
+	if (verbose > 1) {
 		printf("connected sockets: c1 <-> p1, c2 <-> p2\n");
 		printf("cgroups binding: c1(%i) <-> s1(%i) - - - c2(%i) <-> s2(%i)\n",
 			c1, s1, c2, s2);
@@ -721,7 +721,7 @@ static int sendmsg_test(struct sockmap_options *opt)
 			iov_count = 1;
 		err = msg_loop(rx_fd, iov_count, iov_buf,
 			       cnt, &s, false, opt);
-		if (opt->verbose)
+		if (opt->verbose > 1)
 			fprintf(stderr,
 				"msg_loop_rx: iov_count %i iov_buf %i cnt %i err %i\n",
 				iov_count, iov_buf, cnt, err);
@@ -729,7 +729,7 @@ static int sendmsg_test(struct sockmap_options *opt)
 			sent_Bps = sentBps(s);
 			recvd_Bps = recvdBps(s);
 		}
-		if (opt->verbose)
+		if (opt->verbose > 1)
 			fprintf(stdout,
 				"rx_sendmsg: TX: %zuB %fB/s %fGB/s RX: %zuB %fB/s %fGB/s %s\n",
 				s.bytes_sent, sent_Bps, sent_Bps/giga,
@@ -759,7 +759,7 @@ static int sendmsg_test(struct sockmap_options *opt)
 			sent_Bps = sentBps(s);
 			recvd_Bps = recvdBps(s);
 		}
-		if (opt->verbose)
+		if (opt->verbose > 1)
 			fprintf(stdout,
 				"tx_sendmsg: TX: %zuB %fB/s %f GB/s RX: %zuB %fB/s %fGB/s\n",
 				s.bytes_sent, sent_Bps, sent_Bps/giga,
@@ -864,6 +864,7 @@ static int forever_ping_pong(int rate, struct sockmap_options *opt)
 }
 
 enum {
+	SELFTESTS,
 	PING_PONG,
 	SENDMSG,
 	BASE,
@@ -1242,14 +1243,14 @@ static int __test_exec(int cgrp, int test, struct sockmap_options *opt)
 
 	if (opt->verbose) {
 		fprintf(stdout,
-			"[TEST %i]: (%i, %i, %i, %s, %s): ",
+			" [TEST %i]: (%i, %i, %i, %s, %s): ",
 			test_cnt, opt->rate, opt->iov_count, opt->iov_length,
 			test_to_str(test), options);
 		fflush(stdout);
 	}
 	err = run_options(opt, cgrp, test);
 	if (opt->verbose)
-		fprintf(stdout, "%s\n", !err ? "PASS" : "FAILED");
+		fprintf(stdout, " %s\n", !err ? "PASS" : "FAILED");
 	test_cnt++;
 	!err ? passed++ : failed++;
 	free(options);
@@ -1322,38 +1323,30 @@ static void test_send(struct sockmap_options *opt, int cgrp)
 	sched_yield();
 }
 
-static void test_txmsg_pass(int cgrp, char *map)
+static void test_txmsg_pass(int cgrp, struct sockmap_options *opt)
 {
-	struct sockmap_options opt = {.map = map};
-
 	/* Test small and large iov_count values with pass/redir/apply/cork */
 	txmsg_pass = 1;
-	test_send(&opt, cgrp);
+	test_send(opt, cgrp);
 }
 
-static void test_txmsg_redir(int cgrp, char *map)
+static void test_txmsg_redir(int cgrp, struct sockmap_options *opt)
 {
-	struct sockmap_options opt = {.map = map};
-
 	txmsg_redir = 1;
-	test_send(&opt, cgrp);
+	test_send(opt, cgrp);
 }
 
-static void test_txmsg_drop(int cgrp, char *map)
+static void test_txmsg_drop(int cgrp, struct sockmap_options *opt)
 {
-	struct sockmap_options opt = {.map = map};
-
 	txmsg_drop = 1;
-	test_send(&opt, cgrp);
+	test_send(opt, cgrp);
 }
 
-static void test_txmsg_ingress_redir(int cgrp, char *map)
+static void test_txmsg_ingress_redir(int cgrp, struct sockmap_options *opt)
 {
-	struct sockmap_options opt = {.map = map};
-
 	txmsg_pass = txmsg_drop = 0;
 	txmsg_ingress = txmsg_redir = 1;
-	test_send(&opt, cgrp);
+	test_send(opt, cgrp);
 }
 
 /* Test cork with hung data. This tests poor usage patterns where
@@ -1363,182 +1356,168 @@ static void test_txmsg_ingress_redir(int cgrp, char *map)
  * apply logic. Use cork size of 4097 with send_large to avoid
  * aligning cork size with send size.
  */
-static void test_txmsg_cork_hangs(int cgrp, char *map)
+static void test_txmsg_cork_hangs(int cgrp, struct sockmap_options *opt)
 {
-	struct sockmap_options opt = {.map = map};
-
 	txmsg_pass = 1;
 	txmsg_redir = 0;
 	txmsg_cork = 4097;
 	txmsg_apply = 4097;
-	test_send_large(&opt, cgrp);
+	test_send_large(opt, cgrp);
 
 	txmsg_pass = 0;
 	txmsg_redir = 1;
 	txmsg_apply = 0;
 	txmsg_cork = 4097;
-	test_send_large(&opt, cgrp);
+	test_send_large(opt, cgrp);
 
 	txmsg_pass = 0;
 	txmsg_redir = 1;
 	txmsg_apply = 4097;
 	txmsg_cork = 4097;
-	test_send_large(&opt, cgrp);
+	test_send_large(opt, cgrp);
 }
 
-static void test_txmsg_pull(int cgrp, char *map)
+static void test_txmsg_pull(int cgrp, struct sockmap_options *opt)
 {
-	struct sockmap_options opt = {.map = map};
-
 	/* Test basic start/end */
 	txmsg_start = 1;
 	txmsg_end = 2;
-	test_send(&opt, cgrp);
+	test_send(opt, cgrp);
 
 	/* Test >4k pull */
 	txmsg_start = 4096;
 	txmsg_end = 9182;
-	test_send_large(&opt, cgrp);
+	test_send_large(opt, cgrp);
 
 	/* Test pull + redirect */
 	txmsg_redir = 0;
 	txmsg_start = 1;
 	txmsg_end = 2;
-	test_send(&opt, cgrp);
+	test_send(opt, cgrp);
 
 	/* Test pull + cork */
 	txmsg_redir = 0;
 	txmsg_cork = 512;
 	txmsg_start = 1;
 	txmsg_end = 2;
-	test_send_many(&opt, cgrp);
+	test_send_many(opt, cgrp);
 
 	/* Test pull + cork + redirect */
 	txmsg_redir = 1;
 	txmsg_cork = 512;
 	txmsg_start = 1;
 	txmsg_end = 2;
-	test_send_many(&opt, cgrp);
+	test_send_many(opt, cgrp);
 }
 
-static void test_txmsg_pop(int cgrp, char *map)
+static void test_txmsg_pop(int cgrp, struct sockmap_options *opt)
 {
-	struct sockmap_options opt = {.map = map};
-
 	/* Test basic pop */
 	txmsg_start_pop = 1;
 	txmsg_pop = 2;
-	test_send_many(&opt, cgrp);
+	test_send_many(opt, cgrp);
 
 	/* Test pop with >4k */
 	txmsg_start_pop = 4096;
 	txmsg_pop = 4096;
-	test_send_large(&opt, cgrp);
+	test_send_large(opt, cgrp);
 
 	/* Test pop + redirect */
 	txmsg_redir = 1;
 	txmsg_start_pop = 1;
 	txmsg_pop = 2;
-	test_send_many(&opt, cgrp);
+	test_send_many(opt, cgrp);
 
 	/* Test pop + cork */
 	txmsg_redir = 0;
 	txmsg_cork = 512;
 	txmsg_start_pop = 1;
 	txmsg_pop = 2;
-	test_send_many(&opt, cgrp);
+	test_send_many(opt, cgrp);
 
 	/* Test pop + redirect + cork */
 	txmsg_redir = 1;
 	txmsg_cork = 4;
 	txmsg_start_pop = 1;
 	txmsg_pop = 2;
-	test_send_many(&opt, cgrp);
+	test_send_many(opt, cgrp);
 }
 
-static void test_txmsg_push(int cgrp, char *map)
+static void test_txmsg_push(int cgrp, struct sockmap_options *opt)
 {
-	struct sockmap_options opt = {.map = map};
-
 	/* Test basic push */
 	txmsg_start_push = 1;
 	txmsg_end_push = 1;
-	test_send(&opt, cgrp);
+	test_send(opt, cgrp);
 
 	/* Test push 4kB >4k */
 	txmsg_start_push = 4096;
 	txmsg_end_push = 4096;
-	test_send_large(&opt, cgrp);
+	test_send_large(opt, cgrp);
 
 	/* Test push + redirect */
 	txmsg_redir = 1;
 	txmsg_start_push = 1;
 	txmsg_end_push = 2;
-	test_send_many(&opt, cgrp);
+	test_send_many(opt, cgrp);
 
 	/* Test push + cork */
 	txmsg_redir = 0;
 	txmsg_cork = 512;
 	txmsg_start_push = 1;
 	txmsg_end_push = 2;
-	test_send_many(&opt, cgrp);
+	test_send_many(opt, cgrp);
 }
 
-static void test_txmsg_push_pop(int cgrp, char *map)
+static void test_txmsg_push_pop(int cgrp, struct sockmap_options *opt)
 {
-	struct sockmap_options opt = {.map = map};
-
 	txmsg_start_push = 1;
 	txmsg_end_push = 10;
 	txmsg_start_pop = 5;
 	txmsg_pop = 4;
-	test_send_large(&opt, cgrp);
+	test_send_large(opt, cgrp);
 }
 
-static void test_txmsg_apply(int cgrp, char *map)
+static void test_txmsg_apply(int cgrp, struct sockmap_options *opt)
 {
-	struct sockmap_options opt = {.map = map};
-
 	txmsg_pass = 1;
 	txmsg_redir = 0;
 	txmsg_apply = 1;
 	txmsg_cork = 0;
-	test_send_one(&opt, cgrp);
+	test_send_one(opt, cgrp);
 
 	txmsg_pass = 0;
 	txmsg_redir = 1;
 	txmsg_apply = 1;
 	txmsg_cork = 0;
-	test_send_one(&opt, cgrp);
+	test_send_one(opt, cgrp);
 
 	txmsg_pass = 1;
 	txmsg_redir = 0;
 	txmsg_apply = 1024;
 	txmsg_cork = 0;
-	test_send_large(&opt, cgrp);
+	test_send_large(opt, cgrp);
 
 	txmsg_pass = 0;
 	txmsg_redir = 1;
 	txmsg_apply = 1024;
 	txmsg_cork = 0;
-	test_send_large(&opt, cgrp);
+	test_send_large(opt, cgrp);
 }
 
-static void test_txmsg_cork(int cgrp, char *map)
+static void test_txmsg_cork(int cgrp, struct sockmap_options *opt)
 {
-	struct sockmap_options opt = {.map = map};
-
 	txmsg_pass = 1;
 	txmsg_redir = 0;
 	txmsg_apply = 0;
 	txmsg_cork = 1;
-	test_send(&opt, cgrp);
+	test_send(opt, cgrp);
 
 	txmsg_pass = 1;
 	txmsg_redir = 0;
 	txmsg_apply = 1;
 	txmsg_cork = 1;
-	test_send(&opt, cgrp);
+	test_send(opt, cgrp);
 }
 
 char *map_names[] = {
@@ -1625,7 +1604,7 @@ static int populate_progs(char *bpf_file)
 
 struct _test {
 	char *title;
-	void (*tester)(int cg_fd, char *map);
+	void (*tester)(int cg_fd, struct sockmap_options *opt);
 };
 
 struct _test test[] = {
@@ -1642,11 +1621,11 @@ struct _test test[] = {
 	{"txmsg test push/pop data", test_txmsg_push_pop},
 };
 
-static int __test_selftests(int cg_fd, char *map)
+static int __test_selftests(int cg_fd, struct sockmap_options *opt)
 {
 	int i, err;
 
-	err = populate_progs(map);
+	err = populate_progs(opt->map);
 	if (err < 0) {
 		fprintf(stderr, "ERROR: (%i) load bpf failed\n", err);
 		return err;
@@ -1656,50 +1635,31 @@ static int __test_selftests(int cg_fd, char *map)
 	for (i = 0; i < sizeof(test)/sizeof(struct _test); i++) {
 		struct _test t = test[i];
 
-		test_start_subtest(t.title, map);
-		t.tester(cg_fd, map);
+		test_start_subtest(t.title, opt->map);
+		t.tester(cg_fd, opt);
 		test_end_subtest();
 	}
 
 	return err;
 }
 
-static void test_selftests_sockmap(int cg_fd)
+static void test_selftests_sockmap(int cg_fd, struct sockmap_options *opt)
 {
-	__test_selftests(cg_fd, BPF_SOCKMAP_FILENAME);
+	opt->map = BPF_SOCKMAP_FILENAME;
+	__test_selftests(cg_fd, opt);
 }
 
-static void test_selftests_sockhash(int cg_fd)
+static void test_selftests_sockhash(int cg_fd, struct sockmap_options *opt)
 {
-	__test_selftests(cg_fd, BPF_SOCKHASH_FILENAME);
+	opt->map = BPF_SOCKHASH_FILENAME;
+	__test_selftests(cg_fd, opt);
 }
 
-static int test_selftest(int cg_fd)
+static int test_selftest(int cg_fd, struct sockmap_options *opt)
 {
-	if (cg_fd < 0) {
-		if (setup_cgroup_environment()) {
-			fprintf(stderr, "ERROR: cgroup env failed\n");
-			return -EINVAL;
-		}
-
-		cg_fd = create_and_get_cgroup(CG_PATH);
-		if (cg_fd < 0) {
-			fprintf(stderr,
-				"ERROR: (%i) open cg path failed: %s\n",
-				cg_fd, optarg);
-			return cg_fd;
-		}
 
-		if (join_cgroup(CG_PATH)) {
-			fprintf(stderr, "ERROR: failed to join cgroup\n");
-			return -EINVAL;
-		}
-	}
-
-	test_selftests_sockmap(cg_fd);
-	test_selftests_sockhash(cg_fd);
-	cleanup_cgroup_environment();
-	close(cg_fd);
+	test_selftests_sockmap(cg_fd, opt);
+	test_selftests_sockhash(cg_fd, opt);
 	test_print_results();
 	return 0;
 }
@@ -1710,14 +1670,10 @@ int main(int argc, char **argv)
 	struct sockmap_options options = {0};
 	int opt, longindex, err, cg_fd = 0;
 	char *bpf_file = BPF_SOCKMAP_FILENAME;
-	int test = PING_PONG;
+	int test = SELFTESTS;
 	bool cg_created = 0;
 
-	if (argc < 2) {
-		return test_selftest(-1);
-	}
-
-	while ((opt = getopt_long(argc, argv, ":dhvc:r:i:l:t:p:q:",
+	while ((opt = getopt_long(argc, argv, ":dhv:c:r:i:l:t:p:q:",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 's':
@@ -1758,6 +1714,8 @@ int main(int argc, char **argv)
 			break;
 		case 'v':
 			options.verbose = 1;
+			if (optarg)
+				options.verbose = atoi(optarg);
 			break;
 		case 'i':
 			iov_count = atoi(optarg);
@@ -1814,6 +1772,11 @@ int main(int argc, char **argv)
 		cg_created = 1;
 	}
 
+	if (test == SELFTESTS) {
+		err = test_selftest(cg_fd, &options);
+		goto out;
+	}
+
 	err = populate_progs(bpf_file);
 	if (err) {
 		fprintf(stderr, "populate program: (%s) %s\n",
@@ -1830,7 +1793,7 @@ int main(int argc, char **argv)
 	options.rate = rate;
 
 	err = run_options(&options, cg_fd, test);
-
+out:
 	if (cg_created)
 		cleanup_cgroup_environment();
 	close(cg_fd);


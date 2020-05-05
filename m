Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3762F1C626F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgEEUxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727785AbgEEUxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:53:07 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2FEC061A0F;
        Tue,  5 May 2020 13:53:06 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id w11so2928154iov.8;
        Tue, 05 May 2020 13:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VRIXaUvzFPSOdFHC+ldRJVck0ud8usH+FekI/9yOpJQ=;
        b=YSCXNLmOr2tp5L6W9qabzQvgrXx8fePIxeRjwPrFMEQOyXmDMbI7EnIQNbtVtp2Cb/
         RA0KaSyhlCTdRxXKNmYLr1aAhX7obU9naMBCGdpmANneS6+Bp1DqUVYUR4nrO6gZA4kS
         /MJYXGFZ71KEiM5WzKJQMaYwkPm74jlNDO2FL9xyyWjk6TzRPtefQLT8KiT4/o4lh4sj
         0Zc0cFYi8IuBRJeVq1WNvVTP5ucMor40f8mFut3xhw9JxWZKmss0Q9qOchslmrO2QI0k
         dSakOOPfI/eLpTGFQZvd0K1JbZF5uofhhjEL4JPCYkrsgZaShnxDniPCeTxxQETvWWvj
         hbig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VRIXaUvzFPSOdFHC+ldRJVck0ud8usH+FekI/9yOpJQ=;
        b=aN9+N6E2GRHkhIctNwyMXnKndi4VVNXZpDflB036pTWRkpbMB66MZ4O9MBe6xJjXQT
         e2e/lh/Ft+qw5IaJb38ZsruqhxrTsvI5vCSv0uUyPJqZJtudrWBbJZbMZkzbMSKcLXw8
         hbTEdTfYtiZzkvIM1nVgF7j3TPt7rtFlx2PR3dWseXD9JKx0Yh4n0FsRcmTfwmd8a+EH
         TKGNLatkSYtWhNIT1wo05gx5OQWCqIoniLEjajeHJIcddnwYV2fpgHnNqnzKBW3Vp3r+
         loAVX9og8Bn89ddlcaRXDW1yuZgG+0SZ8nPzYZ+5LgOBAWnjn5WGX8L99xW4kYdhTebx
         cDuw==
X-Gm-Message-State: AGi0PuY8aIGD5+exuerD4us/tA8rxJSBrhA6b1ZBmsRfeHbGC9lztUQz
        pRh+odXccpXEzyRh+tTESxwl+HI748g=
X-Google-Smtp-Source: APiQypLhl3JkKAcc5z41mEayIyzuEiZ3IeTcLdgq7F7XhnMbVWpJ6fibzXi4GA0CeNborQ3cAReV4g==
X-Received: by 2002:a05:6602:2f8a:: with SMTP id u10mr5300041iow.83.1588711985746;
        Tue, 05 May 2020 13:53:05 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s5sm2375840ili.59.2020.05.05.13.52.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 13:53:05 -0700 (PDT)
Subject: [bpf-next PATCH 10/10] bpf: selftests,
 add ktls tests to test_sockmap
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Tue, 05 May 2020 13:52:52 -0700
Message-ID: <158871197261.7537.5110096753450826009.stgit@john-Precision-5820-Tower>
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

Until now we have only had minimal ktls+sockmap testing when being
used with helpers and different sendmsg/sendpage patterns. Add a
pass with ktls here.

To run just ktls tests,

 $ ./test_sockmap --whitelist="ktls"

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   70 ++++++++++++++++++----------
 1 file changed, 44 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 154bcdb..a80ecc4 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -115,6 +115,7 @@ static const struct option long_options[] = {
 struct test_env {
 	const char *type;
 	const char *subtest;
+	const char *prepend;
 
 	int test_num;
 	int subtest_num;
@@ -126,6 +127,26 @@ struct test_env {
 
 struct test_env env;
 
+struct sockmap_options {
+	int verbose;
+	bool base;
+	bool sendpage;
+	bool data_test;
+	bool drop_expected;
+	int iov_count;
+	int iov_length;
+	int rate;
+	char *map;
+	char *whitelist;
+	char *blacklist;
+	char *prepend;
+};
+
+struct _test {
+	char *title;
+	void (*tester)(int cg_fd, struct sockmap_options *opt);
+};
+
 static void test_start(void)
 {
 	env.subtest_num++;
@@ -151,10 +172,11 @@ static void test_reset(void)
 	txmsg_ingress = txmsg_skb = 0;
 }
 
-static int test_start_subtest(const char *name, const char *type)
+static int test_start_subtest(const struct _test *t, struct sockmap_options *o)
 {
-	env.type = type;
-	env.subtest = name;
+	env.type = o->map;
+	env.subtest = t->title;
+	env.prepend = o->prepend;
 	env.test_num++;
 	env.subtest_num = 0;
 	env.fail_last = env.fail_cnt;
@@ -170,9 +192,10 @@ static void test_end_subtest(void)
 	if (!error)
 		test_pass();
 
-	fprintf(stdout, "#%2d/%2d %8s:%s:%s\n",
+	fprintf(stdout, "#%2d/%2d %8s:%s:%s:%s\n",
 		env.test_num, env.subtest_num,
 		!type ? "sockmap" : "sockhash",
+		env.prepend ? : "",
 		env.subtest, error ? "FAIL" : "OK");
 }
 
@@ -379,20 +402,6 @@ struct msg_stats {
 	struct timespec end;
 };
 
-struct sockmap_options {
-	int verbose;
-	bool base;
-	bool sendpage;
-	bool data_test;
-	bool drop_expected;
-	int iov_count;
-	int iov_length;
-	int rate;
-	char *map;
-	char *whitelist;
-	char *blacklist;
-};
-
 static int msg_loop_sendpage(int fd, int iov_length, int cnt,
 			     struct msg_stats *s,
 			     struct sockmap_options *opt)
@@ -1606,11 +1615,6 @@ static int populate_progs(char *bpf_file)
 	return 0;
 }
 
-struct _test {
-	char *title;
-	void (*tester)(int cg_fd, struct sockmap_options *opt);
-};
-
 struct _test test[] = {
 	{"txmsg test passthrough", test_txmsg_pass},
 	{"txmsg test redirect", test_txmsg_redir},
@@ -1636,7 +1640,9 @@ static int check_whitelist(struct _test *t, struct sockmap_options *opt)
 		return -ENOMEM;
 	entry = strtok(ptr, ",");
 	while (entry) {
-		if (strstr(opt->map, entry) != 0 || strstr(t->title, entry) != 0)
+		if ((opt->prepend && strstr(opt->prepend, entry) != 0) ||
+		    strstr(opt->map, entry) != 0 ||
+		    strstr(t->title, entry) != 0)
 			return 0;
 		entry = strtok(NULL, ",");
 	}
@@ -1654,7 +1660,9 @@ static int check_blacklist(struct _test *t, struct sockmap_options *opt)
 		return -ENOMEM;
 	entry = strtok(ptr, ",");
 	while (entry) {
-		if (strstr(opt->map, entry) != 0 || strstr(t->title, entry) != 0)
+		if ((opt->prepend && strstr(opt->prepend, entry) != 0) ||
+		    strstr(opt->map, entry) != 0 ||
+		    strstr(t->title, entry) != 0)
 			return 0;
 		entry = strtok(NULL, ",");
 	}
@@ -1680,7 +1688,7 @@ static int __test_selftests(int cg_fd, struct sockmap_options *opt)
 		if (check_blacklist(&t, opt) == 0)
 			continue;
 
-		test_start_subtest(t.title, opt->map);
+		test_start_subtest(&t, opt);
 		t.tester(cg_fd, opt);
 		test_end_subtest();
 	}
@@ -1700,11 +1708,21 @@ static void test_selftests_sockhash(int cg_fd, struct sockmap_options *opt)
 	__test_selftests(cg_fd, opt);
 }
 
+static void test_selftests_ktls(int cg_fd, struct sockmap_options *opt)
+{
+	opt->map = BPF_SOCKHASH_FILENAME;
+	opt->prepend = "ktls";
+	ktls = 1;
+	__test_selftests(cg_fd, opt);
+	ktls = 0;
+}
+
 static int test_selftest(int cg_fd, struct sockmap_options *opt)
 {
 
 	test_selftests_sockmap(cg_fd, opt);
 	test_selftests_sockhash(cg_fd, opt);
+	test_selftests_ktls(cg_fd, opt);
 	test_print_results();
 	return 0;
 }


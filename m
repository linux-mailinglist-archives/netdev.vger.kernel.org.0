Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15B31D1ED6
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390603AbgEMTQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390252AbgEMTQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:16:18 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDD0C061A0C;
        Wed, 13 May 2020 12:16:18 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id w18so783630ilm.13;
        Wed, 13 May 2020 12:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ZGiAeQKCqi9bVp8cca2McaZEzzsGwxAU0BJeWRDdpOw=;
        b=RwVYEzUHBkSTBuflfQvoVbEs89ZNLp38AXU+brchbTELDg3iaaHIio9wYTQVamtlIG
         EDyY1ND2s263S1/S6o9nFiszSbrh36ZBVLQzwoWQr7Y7zVpSHByZ5z4TfkO2pSbsQNDj
         PXNj5nrVzPiyEJ4O/8lQMFxTQmGZjfFUN8B2n+GWof6FMchSjr1j3cbJvyD3hRiivy0u
         XdNV5u2fvt4xXypYze0d5MZZdCQmatRaNJU9hMnKV7cdUxU/dbwzpc5fKBTPfreh68F/
         jL0O8t4vE9vg5zzMDAIzFQ8SIMDGNVVYdVhT70GNO0PRMWZoaD3GFYrbeUbp112clClF
         yiiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZGiAeQKCqi9bVp8cca2McaZEzzsGwxAU0BJeWRDdpOw=;
        b=NE+yKcIJgZ0mTX7a+KcBmH2DjHKJUSm4RW9VgKm2JHyhSlDE5jz7oOCYmTtaz8GKaf
         iu0gh8xxcVR/OVXqkvi2fJ+c9C9wpFkxKgGI+LpNHy3S7XZUZWDIoH5phb3cpbKBQ/fd
         vv6ueFM1KWq21ZqtqW55oF8oz8PMdxwjALaHMUwGdJkcVO89ubLq43aURUDGZGN7WEcq
         dTurZ1LyqyZSyW21vf/nm1t2AhbZeI8QpQC8IQjABkb6gF1ffdHeoSlS8fg+XgUOF770
         omQvOsWutDwlarnnu2H1Fg/VEA78yKvsda0FjepkOns8N1FR3t8tNjjDJ+VwQER07laK
         9lTg==
X-Gm-Message-State: AOAM530JxO80r6dwT8NP0VJeZu+yFv+ddmpoF53ASdNb26slNhswrZiw
        R73/z4bJ3g5y30CzhrI96LE=
X-Google-Smtp-Source: ABdhPJyWJMK3X/U4gjyGnQvP+hRtwBKqsAxjH241Mhs8kS99oS9EGt676KgVQdIzQ05z+oQRvImE7Q==
X-Received: by 2002:a92:d18f:: with SMTP id z15mr1004236ilz.226.1589397378186;
        Wed, 13 May 2020 12:16:18 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z16sm217089ioz.13.2020.05.13.12.16.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:16:17 -0700 (PDT)
Subject: [bpf-next PATCH v2 12/12] bpf: selftests,
 add ktls tests to test_sockmap
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Wed, 13 May 2020 12:16:02 -0700
Message-ID: <158939736278.15176.5435314315563203761.stgit@john-Precision-5820-Tower>
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

Until now we have only had minimal ktls+sockmap testing when being
used with helpers and different sendmsg/sendpage patterns. Add a
pass with ktls here.

To run just ktls tests,

 $ ./test_sockmap --whitelist="ktls"

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   70 ++++++++++++++++++----------
 1 file changed, 44 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 2ed2db6..c806438 100644
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


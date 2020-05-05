Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9893A1C6267
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgEEUw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727785AbgEEUw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:52:27 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67C4C061A0F;
        Tue,  5 May 2020 13:52:25 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x2so2391720ilp.13;
        Tue, 05 May 2020 13:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=sHkSlhv/VqeaYEChvENlOOqbO1In5zI74heFDEfA2Rk=;
        b=VHJV+9ZPuz5GKD6svFoitu3VcNPXb4r1Uv6rA8LafnPTxiD9IQIeVTBh4xqkNG97rR
         Z4rlqCiqaKhniDRZt5/eiPfhpKkWelb30GxnVJVh5vLslhFiS6SrqtjSZBQaKYGCIFcc
         IbI2VK2Lj5oAslMC5zhZw9mwKTZW4f9izCTR08TaazH9+g4yqloVFYMHaRSqbfBa8tpz
         /xrAJ6s9iBp7qSNNqM0u6XiNdwd+dl6h84vWARgZJNtSHlVSQE50PwI3RRg87MPivRJ+
         anKU5JhmH7Ds/mwSZFlLnXVjIXU7kJlzX28BxEfPGjmq4Sdg2Xk75ip7eqAMWjAi+5Md
         eytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sHkSlhv/VqeaYEChvENlOOqbO1In5zI74heFDEfA2Rk=;
        b=ELl9jembnIdiFdeoO9KDIARSXvoYuW8/m1ivmfWInjKmh75o5pCE/0cY3yZIrGs66T
         rh2sKMwMIP+QF8oQ6CoK693VSICdqMoMthCYHHKoKUGb7I982ry6imXZL6Y3HB9UDG0J
         XQsE0cthGeJZHaC8cbJx5DTqQXxkFCWh2N2C6uXU/gv+TCdNlnauc/J0jH/eukvcG1ik
         73KLMKLqVg/EkMGO2FhDj8jj2HfPQXKZRzdI0S6qAOsUeq4eA9ukZCRx4xj+hPzB9DG1
         p1CJpHp+dhHSRrR4ch96l6mIRYDMtwvR0neSvIiwasK/rOGN9Xb7epcefzxekQWuYtBA
         cIkw==
X-Gm-Message-State: AGi0Pub9GIi6NNLvQCWdFrEKUg/lNdwOTf73LU41iawskEoDUuBXuWp2
        PZicOPIwk4C0dBxZ3Q34fMSdJNQdajk=
X-Google-Smtp-Source: APiQypLI9DviznULpY3ORGfyMPIpnR+Y57kVxefhsyU/xUQ5S0R1FPm/KmS/DqxqewStedNjWrZnLw==
X-Received: by 2002:a05:6e02:4cd:: with SMTP id f13mr5798752ils.300.1588711945338;
        Tue, 05 May 2020 13:52:25 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u197sm2405927ilc.0.2020.05.05.13.52.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 13:52:24 -0700 (PDT)
Subject: [bpf-next PATCH 08/10] bpf: selftests,
 add whitelist option to test_sockmap
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Tue, 05 May 2020 13:52:12 -0700
Message-ID: <158871193193.7537.12660746912338132424.stgit@john-Precision-5820-Tower>
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

Allow running specific tests with a comma deliminated whitelist. For example
to run all apply and cork tests.

 $ ./test_sockmap --whitelist="cork,apply"

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   31 +++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 0f944c3..5e0ab7e 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -107,6 +107,7 @@ static const struct option long_options[] = {
 	{"txmsg_skb", no_argument,		&txmsg_skb, 1 },
 	{"ktls", no_argument,			&ktls, 1 },
 	{"peek", no_argument,			&peek_flag, 1 },
+	{"whitelist", required_argument,	NULL, 'n' },
 	{0, 0, NULL, 0 }
 };
 
@@ -387,6 +388,7 @@ struct sockmap_options {
 	int iov_length;
 	int rate;
 	char *map;
+	char *whitelist;
 };
 
 static int msg_loop_sendpage(int fd, int iov_length, int cnt,
@@ -1621,6 +1623,24 @@ struct _test test[] = {
 	{"txmsg test push/pop data", test_txmsg_push_pop},
 };
 
+static int check_whitelist(struct _test *t, struct sockmap_options *opt)
+{
+	char *entry, *ptr;
+
+	if (!opt->whitelist)
+		return 0;
+	ptr = strdup(opt->whitelist);
+	if (!ptr)
+		return -ENOMEM;
+	entry = strtok(ptr, ",");
+	while (entry) {
+		if (strstr(opt->map, entry) != 0 || strstr(t->title, entry) != 0)
+			return 0;
+		entry = strtok(NULL, ",");
+	}
+	return -EINVAL;
+}
+
 static int __test_selftests(int cg_fd, struct sockmap_options *opt)
 {
 	int i, err;
@@ -1635,6 +1655,9 @@ static int __test_selftests(int cg_fd, struct sockmap_options *opt)
 	for (i = 0; i < sizeof(test)/sizeof(struct _test); i++) {
 		struct _test t = test[i];
 
+		if (check_whitelist(&t, opt) < 0)
+			continue;
+
 		test_start_subtest(t.title, opt->map);
 		t.tester(cg_fd, opt);
 		test_end_subtest();
@@ -1673,7 +1696,7 @@ int main(int argc, char **argv)
 	int test = SELFTESTS;
 	bool cg_created = 0;
 
-	while ((opt = getopt_long(argc, argv, ":dhv:c:r:i:l:t:p:q:",
+	while ((opt = getopt_long(argc, argv, ":dhv:c:r:i:l:t:p:q:n:",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 's':
@@ -1742,6 +1765,10 @@ int main(int argc, char **argv)
 				return -1;
 			}
 			break;
+		case 'n':
+			options.whitelist = strdup(optarg);
+			if (!options.whitelist)
+				return -ENOMEM;
 		case 0:
 			break;
 		case 'h':
@@ -1794,6 +1821,8 @@ int main(int argc, char **argv)
 
 	err = run_options(&options, cg_fd, test);
 out:
+	if (options.whitelist)
+		free(options.whitelist);
 	if (cg_created)
 		cleanup_cgroup_environment();
 	close(cg_fd);


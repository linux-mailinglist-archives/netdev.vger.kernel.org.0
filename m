Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306921D1ECD
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390502AbgEMTPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:15:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D3FC061A0C;
        Wed, 13 May 2020 12:15:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k6so327275iob.3;
        Wed, 13 May 2020 12:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=tP0mMmtZV9OZQ8Wp+2UGBDurZ54ypVqPRDlluFyL1Kw=;
        b=m5ZsloYHtNFxeRGFZdrPCgSWUBOzx2HVVzpI5z5HzwzaTAV+tvkZAV7benr2wCOOSY
         7ACwl3/Zf7B/2OFKPj3PVJ/tmOgeYgYH84NcMMo2S7swNFAtgitjxMuKfp9RFkVoDSuY
         Bq56SPZcHEx+y5Ij3hoEgiikc5XL2BNzTJ6VsC5+6TxgVHVsLfhtE/KtvZSVF4qLF7Z4
         Wv3eZ6vDmNS4pMjVT0+m6++K+4VsiyLP1liVxGJq5VIdpNkVSGLKJ8MSrtJ67/AJrVsY
         0FH5IJR6JQaK7P9Pf4EXapNJG8nr2pn8W+Qsz4B4eid9F/H7Iod4Xk6cDW3/dYSERR6u
         hsXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tP0mMmtZV9OZQ8Wp+2UGBDurZ54ypVqPRDlluFyL1Kw=;
        b=TD4wEzI1UV9gCBLR0Pqh6/tIJTJCZ07CXKFkl73wWuIfa+M2U+6A9n6hWf5fYcUOoQ
         6vXCGbdY5vrNPioYGcN0DbAKk4sXVLZ+as9lC0v7aYoRkpxbxOeym0tQt6jm44t+AAWf
         JKrQa7PeBfIGNbg5+pT1aM7MUc7fGGQYpeha+BCowcsrycTu678lGUBF0MVb9N1ILmI6
         4o1eLZ4P8VH10zNeis0dJDQXCtDoa3mDWGJKBfzBtpOxS56n8BYLRt79ykwXVlAyBd2J
         34L/bSwvbMQG98EEnaAW8BYMITcbzCTXzBWpcHbbtoV42ysujIyflEUQlduSukD6hF+T
         q7FQ==
X-Gm-Message-State: AGi0PuZ0LQplIj70dhZTBha4EMK5rCMevcLFy4R16nxzp7cvGP6UTrP6
        LrObcnkbI7lQrGn4mFd8JlQAB5an
X-Google-Smtp-Source: APiQypLO4qD0KL3jddd39rfXuuGiC+fBT8SSlhsCw1mABPTu96i6p2cm2dvEejlnJusaDUQQy7r7ww==
X-Received: by 2002:a02:7113:: with SMTP id n19mr949128jac.113.1589397337673;
        Wed, 13 May 2020 12:15:37 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 23sm155144ilv.58.2020.05.13.12.15.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:15:37 -0700 (PDT)
Subject: [bpf-next PATCH v2 10/12] bpf: selftests,
 add whitelist option to test_sockmap
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Wed, 13 May 2020 12:15:24 -0700
Message-ID: <158939732464.15176.1959113294944564542.stgit@john-Precision-5820-Tower>
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

Allow running specific tests with a comma deliminated whitelist. For example
to run all apply and cork tests.

 $ ./test_sockmap --whitelist="cork,apply"

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   31 +++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 2be8d9d..1b98e92 100644
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


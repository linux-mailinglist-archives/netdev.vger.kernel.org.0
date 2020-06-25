Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBBD20A8AB
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407737AbgFYXNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406631AbgFYXNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:13:52 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BF4C08C5C1;
        Thu, 25 Jun 2020 16:13:52 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e64so2985922iof.12;
        Thu, 25 Jun 2020 16:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=2dDp4wdTOXkTlMfK+S1sLZUdmr8B+CfJrwoh3NxWVt8=;
        b=e/5wXZyNhEhlZ5rpDWJ2/3vVtIupUKHBD/sDdHvqFyE+Bt2HefyUme/ogAM/y9cXYC
         +8xGgC44veimAb0dTz0SNFhk9Dr6GJzY087XRqtPvmqIOJcs+ecRnjUQQMFjvpDk6JgD
         w7BLdP8rQoxlFSVSR5vIyZvpi3tMPlovb3cVQj3/+NqDMWaLI/OSQe2cuay7Az7XoSyw
         LZ1ED3UaSiWAG8pd7LxwG1NET81umigHarqt0BdYkJXwurkZ6RtpKhxza2APssgoj18Y
         asPGcJ1aPKRb/b4WLXz6tSQdWUMjgO46v+CBT31njbD+coCMkh9aMHgWs7CGybl4lEbo
         S9LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=2dDp4wdTOXkTlMfK+S1sLZUdmr8B+CfJrwoh3NxWVt8=;
        b=bhME/MMILqjvL0zkive0yvH04EazZt6GuvvwVR4T7/qvy+71JTS8b7PRUQy0yDeQCU
         n4VGn6K/IQv59g0G8a7UWNeZjRiJ7fK2ehepQ6Oo5Jmttz5oQqY297XqDW5Io0/xyR+Z
         0xdzOC+TBkm1PZOcWX9UPgDatUixR4ctE4bRScyujgylaYQxgQ6frupmRIlvaPiWAg5O
         TT83C4TauZmo0mLJyHyzbGpuB8vG1HxvLQMPJ2N6x4UQepOJiAcBRbCm6Kzc5ysb+ic8
         sgAZed4copV6/Y1vEYAYEaryIMfc1YbXjUNaBiniDFabBf1ewTThVsi5TUzAg3acJyg/
         Wq1Q==
X-Gm-Message-State: AOAM533TC5Hz5oEysMTfZnpnHp0l3Z2p2M3M8J7/VFVvxSiqFjMqnY6u
        8NUVC8cnqqqJsBig6RwnOBE=
X-Google-Smtp-Source: ABdhPJyeAHc7ZaCtUtouKsmYR+vIfTgTh+QRzXwQoaMUp9ppuRgtnlOCho+dG7XIv7hvcdkuAczElA==
X-Received: by 2002:a05:6602:2dd4:: with SMTP id l20mr502009iow.13.1593126831515;
        Thu, 25 Jun 2020 16:13:51 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e12sm13744538ili.68.2020.06.25.16.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 16:13:50 -0700 (PDT)
Subject: [bpf PATCH v2 3/3] bpf,
 sockmap: Add ingres skb tests that utilize merge skbs
From:   John Fastabend <john.fastabend@gmail.com>
To:     kafai@fb.com, jakub@cloudflare.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 25 Jun 2020 16:13:38 -0700
Message-ID: <159312681884.18340.4922800172600252370.stgit@john-XPS-13-9370>
In-Reply-To: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370>
References: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test to check strparser merging skbs is working.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/progs/test_sockmap_kern.h        |    8 +++++++-
 tools/testing/selftests/bpf/test_sockmap.c         |   18 ++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
index 057036ca1111..3dca4c2e2418 100644
--- a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
@@ -79,7 +79,7 @@ struct {
 
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 2);
+	__uint(max_entries, 3);
 	__type(key, int);
 	__type(value, int);
 } sock_skb_opts SEC(".maps");
@@ -94,6 +94,12 @@ struct {
 SEC("sk_skb1")
 int bpf_prog1(struct __sk_buff *skb)
 {
+	int *f, two = 2;
+
+	f = bpf_map_lookup_elem(&sock_skb_opts, &two);
+	if (f && *f) {
+		return *f;
+	}
 	return skb->len;
 }
 
diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 37695fc8096a..78789b27e573 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -85,6 +85,7 @@ int txmsg_ktls_skb_drop;
 int txmsg_ktls_skb_redir;
 int ktls;
 int peek_flag;
+int skb_use_parser;
 
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
@@ -174,6 +175,7 @@ static void test_reset(void)
 	txmsg_apply = txmsg_cork = 0;
 	txmsg_ingress = txmsg_redir_skb = 0;
 	txmsg_ktls_skb = txmsg_ktls_skb_drop = txmsg_ktls_skb_redir = 0;
+	skb_use_parser = 0;
 }
 
 static int test_start_subtest(const struct _test *t, struct sockmap_options *o)
@@ -1211,6 +1213,11 @@ static int run_options(struct sockmap_options *options, int cg_fd,  int test)
 		}
 	}
 
+	if (skb_use_parser) {
+		i = 2;
+		err = bpf_map_update_elem(map_fd[7], &i, &skb_use_parser, BPF_ANY);
+	}
+
 	if (txmsg_drop)
 		options->drop_expected = true;
 
@@ -1650,6 +1657,16 @@ static void test_txmsg_cork(int cgrp, struct sockmap_options *opt)
 	test_send(opt, cgrp);
 }
 
+static void test_txmsg_ingress_parser(int cgrp, struct sockmap_options *opt)
+{
+	txmsg_pass = 1;
+	skb_use_parser = 512;
+	opt->iov_length = 256;
+	opt->iov_count = 1;
+	opt->rate = 2;
+	test_exec(cgrp, opt);
+}
+
 char *map_names[] = {
 	"sock_map",
 	"sock_map_txmsg",
@@ -1748,6 +1765,7 @@ struct _test test[] = {
 	{"txmsg test pull-data", test_txmsg_pull},
 	{"txmsg test pop-data", test_txmsg_pop},
 	{"txmsg test push/pop data", test_txmsg_push_pop},
+	{"txmsg text ingress parser", test_txmsg_ingress_parser},
 };
 
 static int check_whitelist(struct _test *t, struct sockmap_options *opt)


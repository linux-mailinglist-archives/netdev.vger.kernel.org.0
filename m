Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3591C42E2F8
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 22:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhJNU7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 16:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbhJNU7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 16:59:16 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798D9C061570;
        Thu, 14 Oct 2021 13:57:11 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so6163404pjq.0;
        Thu, 14 Oct 2021 13:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EMo7pDATAES3BNatEM2URhLDnK6LT9ubeVWANphHkdE=;
        b=d+okwcQsMPl8JHpnxVr3AT7+50xCHm0M+VIAKoL4bCFb4St4QIgCM+LxT/9np3/dL1
         A1BxbBblbvGTXQxoTvXeJ/ncabwaDVa1HuQ+Au3pla7cpktszi8qStCtceS/pDDYNlr+
         ilievR8UHVcvKT3hhFcvCaVvCkzAB+qDwea9OZuZyg2J2J8doNWxz71sDZr3gaEnM7kN
         hVA+RLfGiPiKzRNnm+u2KaBqOnBWKKF5l25lvu0ksNXc9Tjj1Yt8Wp4lkt19RpvMP89J
         gSvG5jDFn8aTC+8ZXzjy34xq547UlU4hcmbsgnSvOsXyiGQPTYg0aUBsSb2D/USme7+0
         BGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EMo7pDATAES3BNatEM2URhLDnK6LT9ubeVWANphHkdE=;
        b=qt8L+qzvXaYkYi9R2bUCeoYiUe2Gvp6mNdyZxfNc5X3EowZY82S7MqGM+xtX7qscW4
         jQM474B97b5g9cIlLCtC+80M+vwvv931+ug3oC9QaUo2FTJvClrn/uBjcoe8KXw4gohr
         CzxZBOfgNXoS2f9Rf1VW7RBUKBQe9sHzLQv5pO9ueNs6STheRc7UnQl4A3p2TS07gGHi
         VwFpTXyiRDWnM1hd9Gf/rVf0fyI/H/IA6tP7x4pxNcE4N6s14cWJRujtJk5EcUN/225B
         C2DN2OPWeop1CZwrLhkcGpndhPvv0tjKkOA2ZVHPE4voGc1+FCm4g6dqc/PSkNS5OLKI
         Zf6Q==
X-Gm-Message-State: AOAM533BjMplXrshI8TMDq/qtXQFYpnFwFN8E/HUUnAgnPzZ5a7c2zp0
        Tt98WfiSV4E+DL7iCxSxFRHbNGXadZA=
X-Google-Smtp-Source: ABdhPJw0o6CTEHLrqg4UWImusoWc00JcPvQk5Le/fvkFtM3PW5JKXzYWE1gdlOMb1EKSs0bLoL6B0A==
X-Received: by 2002:a17:90b:4b4d:: with SMTP id mi13mr8511756pjb.187.1634245030873;
        Thu, 14 Oct 2021 13:57:10 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id p16sm220879pgd.78.2021.10.14.13.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 13:57:10 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 7/8] selftests/bpf: Fix fd cleanup in sk_lookup test
Date:   Fri, 15 Oct 2021 02:26:43 +0530
Message-Id: <20211014205644.1837280-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014205644.1837280-1-memxor@gmail.com>
References: <20211014205644.1837280-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2422; h=from:subject; bh=Bu5So/JXoqVM207wD93/7Gz5WB5cEBI0sQdmm7wPOVA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhaJk/yMjwhQv7b9eg1M18dkgR/77Xq1LbV+rDtagO 1PBywBmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWiZPwAKCRBM4MiGSL8RykFoEA CovVk7BgQev0AKe5VGwrxOJE70ivlSCvR+1oQz9oPg4UCattMlCwLeJxn2+kH/HwXyW+fNOGqv4G2U sRra7TNTMSJLdGjLRQfQ+iOhIMWrJcPDhW4dFt/6q/bCojS4q7BIdluA6mwL70WsOpN+CD70f7mE4O yE0GeUs3nB14rX48z6EY8uqIKt0RBZVqhbJMoyDgZpHuKSnUek3O4jgcRnBxty070+gVJkm3q0cn2c +VDZnu0S75yIUckrWk2Jrdm7uqKUh/HNrK/mDCxzMG64koEPzTartieKgU1KFW5s5dU8vPI35tE97q ZJyV0YFo4W4fZKZCntRUDVo166tyIY7zBrVOiiXfEZnDermnpZsIvua0QeicJH6+5cWoxTDsyxbfdK TQhHSiEWWEyUnbWZMAFq6EFCE14mn74ImKIhV5c0Kztc6e1EyFTs9Yi3w5OzOeJBDCf4FhhwqzWugY R8jGr4iszAlIxNWDMSvIhLqYdH/bSyrRL3GLO3j3PpfZPop9bxeIs7/2pQieQv5C3acT5YqJeTQHZl YiO47ROlngCvys89bX/njR0Lv4n3T9VNDxKS9tF4wcr+d7yFOjBhWcb3zKZsB7bNfJroM8LJPyD5lW 1Y3WuKot0Of/nmsMzOahqTxZOVzMgc7UtXJMuCvGKZ8ArgwyVLiwr/ioryUw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the fix in commit:
e31eec77e4ab ("bpf: selftests: Fix fd cleanup in get_branch_snapshot")

We use designated initializer to set fds to -1 without breaking on
future changes to MAX_SERVER constant denoting the array size.

The particular close(0) occurs on non-reuseport tests, so it can be seen
with -n 115/{2,3} but not 115/4. This can cause problems with future
tests if they depend on BTF fd never being acquired as fd 0, breaking
internal libbpf assumptions.

Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index aee41547e7f4..cbee46d2d525 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -598,7 +598,7 @@ static void query_lookup_prog(struct test_sk_lookup *skel)
 
 static void run_lookup_prog(const struct test *t)
 {
-	int server_fds[MAX_SERVERS] = { -1 };
+	int server_fds[] = { [0 ... MAX_SERVERS - 1] = -1 };
 	int client_fd, reuse_conn_fd = -1;
 	struct bpf_link *lookup_link;
 	int i, err;
@@ -663,8 +663,9 @@ static void run_lookup_prog(const struct test *t)
 	if (reuse_conn_fd != -1)
 		close(reuse_conn_fd);
 	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
-		if (server_fds[i] != -1)
-			close(server_fds[i]);
+		if (server_fds[i] == -1)
+			break;
+		close(server_fds[i]);
 	}
 	bpf_link__destroy(lookup_link);
 }
@@ -1053,7 +1054,7 @@ static void run_sk_assign(struct test_sk_lookup *skel,
 			  struct bpf_program *lookup_prog,
 			  const char *remote_ip, const char *local_ip)
 {
-	int server_fds[MAX_SERVERS] = { -1 };
+	int server_fds[] = { [0 ... MAX_SERVERS - 1] = -1 };
 	struct bpf_sk_lookup ctx;
 	__u64 server_cookie;
 	int i, err;
@@ -1097,8 +1098,9 @@ static void run_sk_assign(struct test_sk_lookup *skel,
 
 close_servers:
 	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
-		if (server_fds[i] != -1)
-			close(server_fds[i]);
+		if (server_fds[i] == -1)
+			break;
+		close(server_fds[i]);
 	}
 }
 
-- 
2.33.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEB44353AA
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 21:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhJTTSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 15:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbhJTTSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 15:18:05 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E3AC06161C;
        Wed, 20 Oct 2021 12:15:50 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r2so23376888pgl.10;
        Wed, 20 Oct 2021 12:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Iql+9A8axPzsGfBUOVVTBV5EY0AXW6GJqidF/pmlglU=;
        b=FBdu7N9WAhqQi1N9GvMyj1kE5YXLS36v6qNKw+mdalGODXMgo0j3iw7IaUGcImrgqC
         oad7Q/wbE2/4keyzxLgs21VyF3w8S/4UR40zGefWKzP2mmHt70ci1syAaAxHPaCD0ssq
         CEirmesorRkThZVQ7gHn/O27WZnKj8LKgPSeaRQ4O4M1f5TUwcnUPD7sY5O10CPeYjsV
         l4zS3Bb/No3WPrfpc9d3obmgSa1jhhreNdl9P1oQSNEJe2AOqORrzn3bACBE5MnjZcsS
         DMGLm9oBHIUD2hRgkG34OLPQygzN/oHAL1ug+ViXyXpumcJv63IgOAOcGfPsfunbTHR2
         5Siw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Iql+9A8axPzsGfBUOVVTBV5EY0AXW6GJqidF/pmlglU=;
        b=srdeE8DKwm5UTOPK5wZK7VgYbh/0gIHriZDtQJrKL7QmqoYiWARobPuOcoRc490Ypv
         MBzwMvXUsY5/roEuy9vAZQ4s4baJ5A2c1hN8J59/XYBufzbCVAM1wxJSQElxsg7QFeYo
         txeTW89ap1yoJ4EWkcb8RIBLvZlTn0aU/i9MyGdws1MJeLLYcirHujR0XO+P8azKk4m4
         31iosw02OcEdxcxtMW2+9T2kvLIH67lvIDkmSBrw9TymLxmmMB086cwpv1Beq547lzOs
         Hb7o7jW8h1v4ZiqCWbLLFTg237lbZOtl2SKRd1d9zU3cmG4SMrD2aKmkVEjdl2pDUGOl
         C/0w==
X-Gm-Message-State: AOAM533F8U1UFI0mja0ZRTLxOinSvaFreiB9g5K57RXRpd4fpFbptkmp
        8smIxRj3fvKWg+tLafT4Oeo9SJwo6ZARDA==
X-Google-Smtp-Source: ABdhPJyCeEnNsLOgV+5ENnQWJ3n+Ql7dWiIOBTtK144YFQlKHJJUZ6mfGtujP/FWro5W1BDCRFwpYg==
X-Received: by 2002:aa7:88cb:0:b0:44d:4b3f:36c1 with SMTP id k11-20020aa788cb000000b0044d4b3f36c1mr853580pff.76.1634757349648;
        Wed, 20 Oct 2021 12:15:49 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id i127sm3001908pgc.40.2021.10.20.12.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:15:49 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 7/8] selftests/bpf: Fix fd cleanup in sk_lookup test
Date:   Thu, 21 Oct 2021 00:45:25 +0530
Message-Id: <20211020191526.2306852-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020191526.2306852-1-memxor@gmail.com>
References: <20211020191526.2306852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2422; h=from:subject; bh=RYbasI0MNW8+5rf9vqnH2E9N7AqCRHjXGDnVu1Y4DQU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhcGoeasC32ROy6i53YQUQfMVFLBSdPGMT1cnGNj1h FS6wT0OJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXBqHgAKCRBM4MiGSL8Ryk2uD/ 4pac3UunqZPoKWPNwd7TJ/OyRLq1VQtayjs+00AWjGFhHehf1nIU04HSPv/tzw73w9hJ1cXz2wBRF8 x00OCcs8jcas0WMPgEK1V+GO532VP6r3Rsc642j+UkNVUgAKyoRZsktiks56bUVq4TXVkrpwrye6rb sO7sA2uV7+I3yRjsJtngH1eIWioPwrFAsDqzADQX39Qgz8XBWcuRDYFSK4IY9ss4QOP1nvHVuBlYJY 6UmAGNL2+1m8mHZtaJJkUZlHhdSJYioov8feLxRJMEvJUdyfVGe5NSrwIbpJdWbWmZzi0bG+QSKtfL obE5/U9Gf0HStlhuM1hbdaE6IsrUrJFU1DYqkEdpV0zAOtP+f4pKIDSA0U+46WyIFrKZo2meA6YPS8 S9LqvdY+DcWyZckUXw8QUDRHr64Z+//PQstD2OLEFoPcAaJH80IsvNv9wkxdlBBgkt3NhN5IYjznAn MOeSRHGsqZfrbNLItW8q+vUMFRcjgkaTb16NqAWjyZCIH9Jyx23Hb4nCH5AQmQKFNz2CkqjSy8Yn7g 5S8i9r90ZIooepIEfbdoq72I6unYHfNIiTysvoTAN0VNJMmTiXLgq9jjqphJJ1vXfcJ/DBWgb/Tqfn 8Zng+U1hcwED83RxXlCkJnWOCF2EV8GEEq73EY0wNdpkOMQJXaV9RL337ErA==
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
2.33.1


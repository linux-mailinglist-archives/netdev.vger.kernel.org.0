Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7BC29DA83
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733103AbgJ1XYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729360AbgJ1XKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:10:52 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D98C0613CF;
        Wed, 28 Oct 2020 16:10:52 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id s1so595240qvm.13;
        Wed, 28 Oct 2020 16:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=cRfSQUYS268mMkMdpuJD7g3guRW6OCmdfQPtqkCWnpU=;
        b=n8Vc74UqdI/YeHoTm62iXVn0PvblfBRU+46Q82PQqHCs6re5G9TnYx334jGiMJPUM9
         rQee7dOBddbSgBcsT0O1LxuHrmerrQyrJw/l/sjjk6xmmNa7wXDq2La7mtBu2osVP9ZU
         4XOG+Wr/RamzEhycvjJ1THDTWP37yiQEqUdNQSpKF53J+bw8Pq1qA6fEpUS9tkG2vWqT
         t3ow+IcC57WRO0L0dPTTZTt2Iw5i62+/7kfa422czopXy2WivOQlmTZBG5p9pH1kUwBy
         OpI+9FHeVGvRAIQ5Avhr9G8UfRfikYXn7AHc54jtXppTPjTeqxBn+Jx2Zwy4XrQny7Hi
         tbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cRfSQUYS268mMkMdpuJD7g3guRW6OCmdfQPtqkCWnpU=;
        b=Q1bD7uHMmBv4ItzYsSz19W4vsueqgLI9Gz2jZOLZr7r5ncbXuNv9O/V/ink8zVLaOI
         FdbThO6YXEyVjPxR/EaBPvdcJdlNrZ4ppNNcu4tmEdyXiFXvgvN+qOOOKFyGiM1HBsf2
         NINtRj871tcg33CyOgDn20u6xRqSvnsR+/tudad3L4L7Mon12oWThbLrpT9rfZ3gQKY2
         NWx+3/xYMw9Z50rIKG3AY0APU4m0rHVBsFPrLtqPLFWD9ECNMkqqmOfOHwTs1jIbD/my
         PclvwTsFcn6FJVnlsNUeP0PMCSaM47Rx99B232G1ghF3Mdfcmlt1c2bEVRgxNNF/Wx4m
         e4lQ==
X-Gm-Message-State: AOAM533IKAEyRsYIJhmwotLfzlnlAeoqz+18FrZlni0Ln1i2gptd1qSD
        oJbeA2CHASiHeScuyxkyDic0JR2Ity26ew==
X-Google-Smtp-Source: ABdhPJzMkPwhmgHMRvZPZwx03cinaxgWHj1FYsMWP41zZeQipwbZNpH8nvMN/gwhK+wzIR8geQOGuQ==
X-Received: by 2002:a05:6214:d42:: with SMTP id 2mr5666442qvr.29.1603849650218;
        Tue, 27 Oct 2020 18:47:30 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id x6sm2120649qti.77.2020.10.27.18.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 18:47:29 -0700 (PDT)
Subject: [bpf-next PATCH 4/4] selftests/bpf: Migrate tcpbpf_user.c to use BPF
 skeleton
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        alexanderduyck@fb.com
Date:   Tue, 27 Oct 2020 18:47:28 -0700
Message-ID: <160384964803.698509.11020605670605638967.stgit@localhost.localdomain>
In-Reply-To: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Update tcpbpf_user.c to make use of the BPF skeleton. Doing this we can
simplify test_tcpbpf_user and reduce the overhead involved in setting up
the test.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   48 +++++++++-----------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index 4e1190894e1e..7e92c37976ac 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -5,6 +5,7 @@
 
 #include "test_tcpbpf.h"
 #include "cgroup_helpers.h"
+#include "test_tcpbpf_kern.skel.h"
 
 #define LO_ADDR6 "::1"
 #define CG_NAME "/tcpbpf-user-test"
@@ -162,39 +163,32 @@ static void run_test(int map_fd, int sock_map_fd)
 
 void test_tcpbpf_user(void)
 {
-	const char *file = "test_tcpbpf_kern.o";
-	int prog_fd, map_fd, sock_map_fd;
-	struct bpf_object *obj;
+	struct test_tcpbpf_kern *skel;
+	int map_fd, sock_map_fd;
+	struct bpf_link *link;
 	int cg_fd = -1;
-	int rv;
-
-	cg_fd = cgroup_setup_and_join(CG_NAME);
-	if (CHECK_FAIL(cg_fd < 0))
-		goto err;
 
-	if (CHECK_FAIL(bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd))) {
-		fprintf(stderr, "FAILED: load_bpf_file failed for: %s\n", file);
-		goto err;
-	}
+	skel = test_tcpbpf_kern__open_and_load();
+	if (CHECK(!skel, "open and load skel", "failed"))
+		return;
 
-	rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
-	if (CHECK_FAIL(rv)) {
-		fprintf(stderr, "FAILED: bpf_prog_attach: %d (%s)\n",
-		       errno, strerror(errno));
-		goto err;
-	}
+	cg_fd = test__join_cgroup(CG_NAME);
+	if (CHECK_FAIL(cg_fd < 0))
+		goto cleanup_skel;
 
-	map_fd = bpf_find_map(__func__, obj, "global_map");
-	if (CHECK_FAIL(map_fd < 0))
-		goto err;
+	map_fd = bpf_map__fd(skel->maps.global_map);
+	sock_map_fd = bpf_map__fd(skel->maps.sockopt_results);
 
-	sock_map_fd = bpf_find_map(__func__, obj, "sockopt_results");
-	if (CHECK_FAIL(sock_map_fd < 0))
-		goto err;
+	link = bpf_program__attach_cgroup(skel->progs.bpf_testcb, cg_fd);
+	if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
+		  PTR_ERR(link)))
+		goto cleanup_namespace;
 
 	run_test(map_fd, sock_map_fd);
-err:
-	bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
+
+	bpf_link__destroy(link);
+cleanup_namespace:
 	close(cg_fd);
-	cleanup_cgroup_environment();
+cleanup_skel:
+	test_tcpbpf_kern__destroy(skel);
 }



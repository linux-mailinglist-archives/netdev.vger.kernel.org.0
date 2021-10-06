Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4B84234F8
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 02:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbhJFAbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 20:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237089AbhJFAbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 20:31:03 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA492C061749;
        Tue,  5 Oct 2021 17:29:11 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id q201so860095pgq.12;
        Tue, 05 Oct 2021 17:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lJuMPGCG6/YTXwopHoyLaCt3/oTqYL0QNWlBCFoiYPE=;
        b=HopOb8htRn3ReOz6IidivDTexuxMJRcPgFYbHeEWMsZy6H56yqEXEVMFJJZ63WJU6O
         mW4fancKmjDT7S3Jk/hyxcMCVBpsQjBdQ4G0cbq305zslNZmY0PWPKWPntdztJZbGp8Q
         1ZiAAriYqlJ8CCMf9im2mcJ3fWO1AZaxmivSqFYRnijCK4kzVFY7Kew92f/o7QMDLR2o
         ZYM83VeCbW9ru6Ag0v0qydiGL9flrt9Ac6XUL/aosKaLk3Rk7Sd3vv+nsHPUoeIdDCQI
         H7lFD/yiz8hQtEVw1mZ8aBOdz7P+6Xahdq+oLeHC0eSKipYEPDvaiistg6GFu/rHVSo0
         eVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lJuMPGCG6/YTXwopHoyLaCt3/oTqYL0QNWlBCFoiYPE=;
        b=ms8UdOVHu9im7lqzO12bEzNRycXM6EdaKBCqysxp5O2aWlvYEsMuRas85FPW97m0YX
         Ed5VTtgN/VEHsdibneBlIY29IluBH4uXC4crkHbpHW/CSf61wIXK3HP3GmUJvn3xvu3e
         fSTlQnsiZV+S0C/IvYkWRc2EXLjSvdaimLinZ4oahvIdPzvvFTbHBGQwgY6CgnuCH6FW
         KDRmNv/wYYMoT8iW2lfJ62/LQkMTglok8F4D9vG6UmaWSWviygiVOm66g4J8n3glN63J
         Kuei1Fooit/LFG1vxF+yA9Tue5CFwBcvEmwQprRBKdV7cMED8FxyN//lNsKWyuVF5tJn
         ONfQ==
X-Gm-Message-State: AOAM532KabGxk2UC0qJ9cPSmfyO3IQk/y3719LNDjmoeIXWsBSitZbkY
        0coZw50NkMI0F45xn5/zk8lkeGLPDek=
X-Google-Smtp-Source: ABdhPJxN3bdlX5x0/6SsTpIRyn3CaonHA06YuNwgtUnXJCfYVifL0PI5LGpxhkQZ0EzqEqnB8vdgDA==
X-Received: by 2002:a62:770f:0:b0:44c:4bea:6f89 with SMTP id s15-20020a62770f000000b0044c4bea6f89mr18969106pfc.57.1633480151233;
        Tue, 05 Oct 2021 17:29:11 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id 4sm2983960pjb.21.2021.10.05.17.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 17:29:11 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 5/6] bpf: selftests: Fix fd cleanup in sk_lookup test
Date:   Wed,  6 Oct 2021 05:58:52 +0530
Message-Id: <20211006002853.308945-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006002853.308945-1-memxor@gmail.com>
References: <20211006002853.308945-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2664; h=from:subject; bh=sgdsNBMusMzMKjmE0dNfyjREBKA+EEfPwKHfnCJm1hg=; b=owEBbAKT/ZANAwAIAUzgyIZIvxHKAcsmYgBhXOxQEHLhwSlTj4oi9HPDnomVV0Mp18+3yh9lWx8u TbxeCAaJAjIEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVzsUAAKCRBM4MiGSL8RyvjRD/ jzrvD54e/4V6XoPzS626AmyOvFS9F7n4SK7nSvz3J4OYKy617twNKr40P5zZdyrc96zPXhPpOs01SI i/vKqUx2df2MxrfFpiSIWCraQrK/NP0JwJ3tN/aIGOZAAcdAAo+8eGaO5zDShObQtUJ+8D+gzKBewr rtfrtNyziuLtxFpHGfSOU1l1Y9hsKHi+7nWW34VxVsHWOWRUaeZMNIw9t4Tw9OdtCwQ6zh1Mkl8y7I CxF2/qJPGQaac1tVVS7C2UAbVCUA5Q3Oj9fC0oyfkSgPEur2QzFUJt15jHHR7sDOy+bvsL+RqKabnn 5fXSXsIqaFHYSSoqjYbBGetnv/avFI+WXVpnwFTj0ivdHZF1lrH9mad9azUQ0WorR90f8aanOL0dy2 cQL4UYtuvIAMZcO4bTrbEAvFH1eNVN4xCuXd/bdDfR7Qh1hzFQoqKO4iXvaqoeLgvRjkTw6SwIEd3O vKJLluvr1scLLm8ZFiRvK+vzgY0Jq7p+Ejacjbiq8WGIUfHDv2PBzzJAbKK4kakFP/BNxlh2Y+jThC gplS8adhflxqqU7AuTtbFVr0nyivYbhgff7HS65lBohJHBa07HegJu6TSwKnFUrw61WOlth9kwA/PD hnlJHcJHmVMwVZAgttIS9GE45eTbax6NIA9QWBdUmIA4TbCPsNaj/f7tfQ
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the fix in commit:
e31eec77e4ab (bpf: selftests: Fix fd cleanup in get_branch_snapshot)

We use memset to set fds to -1 without breaking on future changes to
the array size (when MAX_SERVER constant is bumped).

The particular close(0) occurs on non-reuseport tests, so it can be seen
with -n 115/{2,3} but not 115/4. This can cause problems with future
tests if they depend on BTF fd never being acquired as fd 0, breaking
internal libbpf assumptions.

Cc: Jakub Sitnicki <jakub@cloudflare.com>
Fixes: 0ab5539f8584 (selftests/bpf: Tests for BPF_SK_LOOKUP attach point)
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/sk_lookup.c      | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index aee41547e7f4..572220065bdf 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -598,11 +598,14 @@ static void query_lookup_prog(struct test_sk_lookup *skel)
 
 static void run_lookup_prog(const struct test *t)
 {
-	int server_fds[MAX_SERVERS] = { -1 };
 	int client_fd, reuse_conn_fd = -1;
 	struct bpf_link *lookup_link;
+	int server_fds[MAX_SERVERS];
 	int i, err;
 
+	/* set all fds to -1 */
+	memset(server_fds, 0xFF, sizeof(server_fds));
+
 	lookup_link = attach_lookup_prog(t->lookup_prog);
 	if (!lookup_link)
 		return;
@@ -663,8 +666,9 @@ static void run_lookup_prog(const struct test *t)
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
@@ -1053,11 +1057,14 @@ static void run_sk_assign(struct test_sk_lookup *skel,
 			  struct bpf_program *lookup_prog,
 			  const char *remote_ip, const char *local_ip)
 {
-	int server_fds[MAX_SERVERS] = { -1 };
+	int server_fds[MAX_SERVERS];
 	struct bpf_sk_lookup ctx;
 	__u64 server_cookie;
 	int i, err;
 
+	/* set all fds to -1 */
+	memset(server_fds, 0xFF, sizeof(server_fds));
+
 	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
 		.ctx_in = &ctx,
 		.ctx_size_in = sizeof(ctx),
@@ -1097,8 +1104,9 @@ static void run_sk_assign(struct test_sk_lookup *skel,
 
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


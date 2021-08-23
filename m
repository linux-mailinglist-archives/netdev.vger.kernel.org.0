Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2DB3F5310
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhHWVyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbhHWVyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 17:54:09 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46383C061575;
        Mon, 23 Aug 2021 14:53:26 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id jz1so10585045qvb.13;
        Mon, 23 Aug 2021 14:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=rREGuTwP1+4wHWH12BihyPoN4oNvTOi9vc36dumglaA=;
        b=KnOj592NG8kxPiKFyAauX9fW0ixlq6hDevUHSfdIHfisAt5oQwG+lpSsCGv/cwUfR/
         zW9wWNq+ee1CkHSlw34kEt4jGuN+3iykI4o7X3ERCg3mDHcc3+IycxmLcUQQGyLhu6FD
         BCoM8eGK+I+Obs95RI8lb3LIRvhRkKiuMVYCXG7KMM5vdWUFTfPnoRIbkPjOZYAzpf9n
         cmTitojjfhXhx/1w21B2CU9g25WavcffDG+lT86ecD6KqnlGlWJsIvDnsvYTsXsEdNmb
         xF8sMzcL8d4gZhcO6SlO7eFtV8mVczGBgmOXc1ho5DOY5EhKSTgdZHVMge1Ae4iRkvBL
         gFaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=rREGuTwP1+4wHWH12BihyPoN4oNvTOi9vc36dumglaA=;
        b=dV0WVXPiFoAGJGCmhFp7JmOQqo0LJI6JnPKZ5nBmHpXnDmz0OyuXx05kT8P/c2Y3vK
         mchV2QIM5E7mmlvDMT4BvnhlYCHt1Bw60U33G7qkvlX/uz72X8w4DBQOSfmpNZtXJ7zd
         LOeP25lrM5TyNmruRtPmhILky5uYF/TSvBQCLZanZXkfaOzXsUccnzBOtEtqUdUroDw8
         ySQihJxqS024NMgfRBGYZuTI1CU7k8mQ5z3TnQX2OuALsPl0wsJ2XHuYd5reZnkhMhSS
         s4nXRhJIngiYCthFOWX5OrkfSmT4RoG0mlri8Ktby/ZsLhg6J7Hwa/mc0IIuyHXIN62K
         nunQ==
X-Gm-Message-State: AOAM533YaWUMG4dZi0EMzaouMD8JKgRRrYK/ND3xSGF62VWmGAZl5KSE
        iMcz4iU4AaxO+V2aFuPDjLwUz2SfDOvrlPka
X-Google-Smtp-Source: ABdhPJxIeDU7xKYoM2EBiIlmFqQ7QSdktNRL1/+1b5JkzlJ4M11FFCdE77916H4NreYoNX1fnMF0eA==
X-Received: by 2002:a0c:a702:: with SMTP id u2mr34178648qva.62.1629755605251;
        Mon, 23 Aug 2021 14:53:25 -0700 (PDT)
Received: from localhost.localdomain (cpe-74-65-249-7.nyc.res.rr.com. [74.65.249.7])
        by smtp.gmail.com with ESMTPSA id 18sm7004261qtx.76.2021.08.23.14.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 14:53:24 -0700 (PDT)
From:   Hans Montero <hansmontero99@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     hjm2133@columbia.edu, sdf@google.com, ppenkov@google.com
Subject: [RFC PATCH bpf-next 2/2] selftests/bpf: Extend tests for shared sk_storage
Date:   Mon, 23 Aug 2021 17:52:52 -0400
Message-Id: <20210823215252.15936-3-hansmontero99@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823215252.15936-1-hansmontero99@gmail.com>
References: <20210823215252.15936-1-hansmontero99@gmail.com>
Reply-To: hjm2133@columbia.edu
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Montero <hjm2133@columbia.edu>

Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Hans Montero <hjm2133@columbia.edu>
---
 tools/testing/selftests/bpf/config            |  1 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 31 +++++++++++++++++--
 .../bpf/prog_tests/test_local_storage.c       |  3 ++
 .../progs/bpf_iter_bpf_sk_storage_helpers.c   | 27 ++++++++++++++--
 .../selftests/bpf/progs/local_storage.c       | 30 ++++++++++++++++++
 5 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 5192305159ec..f2d614ab744c 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -1,5 +1,6 @@
 CONFIG_BPF=y
 CONFIG_BPF_SYSCALL=y
+CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE=8
 CONFIG_NET_CLS_BPF=m
 CONFIG_BPF_EVENTS=y
 CONFIG_TEST_BPF=m
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 77ac24b191d4..c768cf6c399a 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -943,7 +943,7 @@ static void test_bpf_sk_storage_delete(void)
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
 	struct bpf_iter_bpf_sk_storage_helpers *skel;
 	union bpf_iter_link_info linfo;
-	int err, len, map_fd, iter_fd;
+	int err, len, map_fd, dummy_map_fd, iter_fd;
 	struct bpf_link *link;
 	int sock_fd = -1;
 	__u32 val = 42;
@@ -955,6 +955,7 @@ static void test_bpf_sk_storage_delete(void)
 		return;
 
 	map_fd = bpf_map__fd(skel->maps.sk_stg_map);
+	dummy_map_fd = bpf_map__fd(skel->maps.dummy_sk_stg_map);
 
 	sock_fd = socket(AF_INET6, SOCK_STREAM, 0);
 	if (CHECK(sock_fd < 0, "socket", "errno: %d\n", errno))
@@ -962,6 +963,10 @@ static void test_bpf_sk_storage_delete(void)
 	err = bpf_map_update_elem(map_fd, &sock_fd, &val, BPF_NOEXIST);
 	if (CHECK(err, "map_update", "map_update failed\n"))
 		goto out;
+	err = bpf_map_update_elem(dummy_map_fd, &sock_fd, &val, BPF_NOEXIST);
+	if (CHECK(err, "(shared local storage) map_update",
+		  "map_update failed\n"))
+		goto out;
 
 	memset(&linfo, 0, sizeof(linfo));
 	linfo.map.map_fd = map_fd;
@@ -987,6 +992,12 @@ static void test_bpf_sk_storage_delete(void)
 	if (CHECK(!err || errno != ENOENT, "bpf_map_lookup_elem",
 		  "map value wasn't deleted (err=%d, errno=%d)\n", err, errno))
 		goto close_iter;
+	err = bpf_map_lookup_elem(dummy_map_fd, &sock_fd, &val);
+	if (CHECK(
+	    err || val != 0, "(shared local storage) bpf_map_lookup_elem",
+	    "map value wasn't deleted (expected val=0, got val=%d, err=%d)\n",
+	    val, err))
+		goto close_iter;
 
 close_iter:
 	close(iter_fd);
@@ -1007,7 +1018,7 @@ static void test_bpf_sk_storage_delete(void)
 static void test_bpf_sk_storage_get(void)
 {
 	struct bpf_iter_bpf_sk_storage_helpers *skel;
-	int err, map_fd, val = -1;
+	int err, map_fd, dummy_map_fd, val = -1;
 	int sock_fd = -1;
 
 	skel = bpf_iter_bpf_sk_storage_helpers__open_and_load();
@@ -1024,10 +1035,15 @@ static void test_bpf_sk_storage_get(void)
 		goto close_socket;
 
 	map_fd = bpf_map__fd(skel->maps.sk_stg_map);
+	dummy_map_fd = bpf_map__fd(skel->maps.dummy_sk_stg_map);
 
 	err = bpf_map_update_elem(map_fd, &sock_fd, &val, BPF_NOEXIST);
 	if (CHECK(err, "bpf_map_update_elem", "map_update_failed\n"))
 		goto close_socket;
+	err = bpf_map_update_elem(dummy_map_fd, &sock_fd, &val, BPF_NOEXIST);
+	if (CHECK(err, "(shared socket storage) bpf_map_update_elem",
+		  "map_update_failed\n"))
+		goto close_socket;
 
 	do_dummy_read(skel->progs.fill_socket_owner);
 
@@ -1036,6 +1052,12 @@ static void test_bpf_sk_storage_get(void)
 	    "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
 	    getpid(), val, err))
 		goto close_socket;
+	err = bpf_map_lookup_elem(dummy_map_fd, &sock_fd, &val);
+	if (CHECK(err || val != getpid(),
+	    "(shared local storage) bpf_map_lookup_elem",
+	    "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
+	    getpid(), val, err))
+		goto close_socket;
 
 	do_dummy_read(skel->progs.negate_socket_local_storage);
 
@@ -1043,6 +1065,11 @@ static void test_bpf_sk_storage_get(void)
 	CHECK(err || val != -getpid(), "bpf_map_lookup_elem",
 	      "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
 	      -getpid(), val, err);
+	err = bpf_map_lookup_elem(dummy_map_fd, &sock_fd, &val);
+	CHECK(err || val != -getpid(),
+	      "(shared local storage) bpf_map_lookup_elem",
+	      "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
+	      -getpid(), val, err);
 
 close_socket:
 	close(sock_fd);
diff --git a/tools/testing/selftests/bpf/prog_tests/test_local_storage.c b/tools/testing/selftests/bpf/prog_tests/test_local_storage.c
index d2c16eaae367..2cb24b38447b 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_local_storage.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_local_storage.c
@@ -189,6 +189,9 @@ void test_test_local_storage(void)
 				      serv_sk))
 		goto close_prog_rmdir;
 
+	CHECK(skel->data->fast_sk_storage_result != 0, "fast_sk_storage_result",
+	      "fast_sk_local_storage not set\n");
+
 close_prog_rmdir:
 	snprintf(cmd, sizeof(cmd), "rm -rf %s", tmp_dir_path);
 	system(cmd);
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
index 6cecab2b32ba..f124dc22a7cc 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
@@ -13,11 +13,22 @@ struct {
 	__type(value, int);
 } sk_stg_map SEC(".maps");
 
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC | BPF_F_SHARED_LOCAL_STORAGE);
+	__type(key, int);
+	__type(value, int);
+} dummy_sk_stg_map SEC(".maps");
+
 SEC("iter/bpf_sk_storage_map")
 int delete_bpf_sk_storage_map(struct bpf_iter__bpf_sk_storage_map *ctx)
 {
-	if (ctx->sk)
-		bpf_sk_storage_delete(&sk_stg_map, ctx->sk);
+	struct sock *sk = ctx->sk;
+
+	if (sk) {
+		bpf_sk_storage_delete(&sk_stg_map, sk);
+		bpf_sk_storage_delete(&dummy_sk_stg_map, sk);
+	}
 
 	return 0;
 }
@@ -43,6 +54,12 @@ int fill_socket_owner(struct bpf_iter__task_file *ctx)
 
 	*sock_tgid = task->tgid;
 
+	sock_tgid = bpf_sk_storage_get(&dummy_sk_stg_map, sock->sk, 0, 0);
+	if (!sock_tgid)
+		return 0;
+
+	*sock_tgid = task->tgid;
+
 	return 0;
 }
 
@@ -61,5 +78,11 @@ int negate_socket_local_storage(struct bpf_iter__tcp *ctx)
 
 	*sock_tgid = -*sock_tgid;
 
+	sock_tgid = bpf_sk_storage_get(&dummy_sk_stg_map, sk_common, 0, 0);
+	if (!sock_tgid)
+		return 0;
+
+	*sock_tgid = -*sock_tgid;
+
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/local_storage.c b/tools/testing/selftests/bpf/progs/local_storage.c
index 95868bc7ada9..502a118f57ed 100644
--- a/tools/testing/selftests/bpf/progs/local_storage.c
+++ b/tools/testing/selftests/bpf/progs/local_storage.c
@@ -16,6 +16,7 @@ char _license[] SEC("license") = "GPL";
 int monitored_pid = 0;
 int inode_storage_result = -1;
 int sk_storage_result = -1;
+int fast_sk_storage_result = -1;
 
 struct local_storage {
 	struct inode *exec_inode;
@@ -23,6 +24,10 @@ struct local_storage {
 	struct bpf_spin_lock lock;
 };
 
+struct fast_storage {
+	__u32 value;
+};
+
 struct {
 	__uint(type, BPF_MAP_TYPE_INODE_STORAGE);
 	__uint(map_flags, BPF_F_NO_PREALLOC);
@@ -37,6 +42,14 @@ struct {
 	__type(value, struct local_storage);
 } sk_storage_map SEC(".maps");
 
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC | BPF_F_CLONE |
+			  BPF_F_SHARED_LOCAL_STORAGE);
+	__type(key, int);
+	__type(value, struct fast_storage);
+} dummy_sk_storage_map SEC(".maps");
+
 struct {
 	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
 	__uint(map_flags, BPF_F_NO_PREALLOC);
@@ -107,6 +120,7 @@ int BPF_PROG(socket_bind, struct socket *sock, struct sockaddr *address,
 {
 	__u32 pid = bpf_get_current_pid_tgid() >> 32;
 	struct local_storage *storage;
+	struct fast_storage *fast_storage;
 	int err;
 
 	if (pid != monitored_pid)
@@ -126,6 +140,14 @@ int BPF_PROG(socket_bind, struct socket *sock, struct sockaddr *address,
 	if (!err)
 		sk_storage_result = err;
 
+	fast_storage =
+		bpf_sk_storage_get(&dummy_sk_storage_map, sock->sk, 0, 0);
+	if (!fast_storage)
+		return 0;
+
+	fast_sk_storage_result =
+		fast_storage->value == DUMMY_STORAGE_VALUE ? 0 : -1;
+
 	return 0;
 }
 
@@ -135,6 +157,7 @@ int BPF_PROG(socket_post_create, struct socket *sock, int family, int type,
 {
 	__u32 pid = bpf_get_current_pid_tgid() >> 32;
 	struct local_storage *storage;
+	struct fast_storage *fast_storage;
 
 	if (pid != monitored_pid)
 		return 0;
@@ -148,6 +171,13 @@ int BPF_PROG(socket_post_create, struct socket *sock, int family, int type,
 	storage->value = DUMMY_STORAGE_VALUE;
 	bpf_spin_unlock(&storage->lock);
 
+	fast_storage =
+		bpf_sk_storage_get(&dummy_sk_storage_map, sock->sk, 0, 0);
+	if (!fast_storage || fast_storage != sock->sk->bpf_shared_local_storage)
+		return 0;
+
+	fast_storage->value = DUMMY_STORAGE_VALUE;
+
 	return 0;
 }
 
-- 
2.30.2


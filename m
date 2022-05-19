Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC9152C726
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiERW6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiERW4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:56:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58B336322
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j2-20020a2597c2000000b0064b3e54191aso2876443ybo.20
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bUN5nTvJ5fe2keogfUb591JO1C7K/LDTQ3be3Xbh7e8=;
        b=M+P92lIJBuUtgmDaSIOrf49MMLsotpwUabv/OG7Xv2HAVEwwUROxgqnNfFnm4VYBn/
         oSRlRFiITarU1CBFEZcyFzX1j2PwLRnR5zvILB/9bwzTDL4NGOGAR9b3KQsI1f6aaP/D
         WAb2J+BOXcLFmmL8qigd6DFSwLqa//Pf07fvawInhbFzYvzNr0ucRELkrCjAQFMC2rUL
         mcIYU/d5hY4x+UBZk4OsZkJR2oVRNUkgf3SqVBDBvnncL8cm1suWdMm3ldl5aUtx1a/9
         zHYq5u5O/3ASvqZekXaaALwvjR8sZct3m0i/Ul/T+maRFS4vOCjhXqm+DYXAkf/zqWsO
         rkVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bUN5nTvJ5fe2keogfUb591JO1C7K/LDTQ3be3Xbh7e8=;
        b=kfp1ys8oJF+LutKuVJqltQFi8WH71Nn7wsjZPgc2KC8ZFo+7EL8exZMBVTyLi8pfrk
         4y36q261U3rfxHmjGQn5DNh4TSYln9jeBtF//A1tawg6LRcO3c7XyBDWGfyhIhw0UyNs
         8NDzek1pTvZ9kDpNEIL7YQO5tSf5WVv6KSVBWvdKr5cSpLvDJsJwK21gQwUM70trluor
         ERIKUD570ofyMXiKT+emRwtled1NDbqeh06hdXPq7k7ShPluj28Z6NzTfyur8Zq2z0mt
         erpuOrfJcW05P6gHL3Qi5FI0Y4jrnlfaFYBxfO/C/M+1dnFmxBGy7Lm6l6SLBIGss7nR
         Ujmg==
X-Gm-Message-State: AOAM53233ChfDzLbQEhYMaRvKe8apu4ie8yELd8eH7nURCmd9MxiHQ75
        9/4UyEaePB935XQqDlb8apLK9OU/Zmu10xna7/0FD+uOPAQ8/ceUFui8bmWn4a9Vw1LGPJkzVb6
        rqt4yxVfZ3ZzpyZc4P2woaCYJRO0383qCBn6rJdDIYHRWVfWSNjnQRQ==
X-Google-Smtp-Source: ABdhPJz+HHD4Fx/CkKD6O5/sO7Lvw5YYhbuzJhPqpeAI7DNIPSa3dpTYgqhFQps+Vp2ynRSCkHfb200=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f763:3448:2567:bf00])
 (user=sdf job=sendgmr) by 2002:a81:1288:0:b0:2fe:f595:26b1 with SMTP id
 130-20020a811288000000b002fef59526b1mr1896071yws.32.1652914554850; Wed, 18
 May 2022 15:55:54 -0700 (PDT)
Date:   Wed, 18 May 2022 15:55:30 -0700
In-Reply-To: <20220518225531.558008-1-sdf@google.com>
Message-Id: <20220518225531.558008-11-sdf@google.com>
Mime-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v7 10/11] selftests/bpf: lsm_cgroup functional test
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functional test that exercises the following:

1. apply default sk_priority policy
2. permit TX-only AF_PACKET socket
3. cgroup attach/detach/replace
4. reusing trampoline shim

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/lsm_cgroup.c     | 277 ++++++++++++++++++
 .../testing/selftests/bpf/progs/lsm_cgroup.c  | 160 ++++++++++
 2 files changed, 437 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c

diff --git a/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
new file mode 100644
index 000000000000..29292ec40343
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <test_progs.h>
+#include <bpf/btf.h>
+
+#include "lsm_cgroup.skel.h"
+#include "cgroup_helpers.h"
+#include "network_helpers.h"
+
+static __u32 query_prog_cnt(int cgroup_fd, const char *attach_func)
+{
+	LIBBPF_OPTS(bpf_prog_query_opts, p);
+	static struct btf *btf;
+	int cnt = 0;
+	int i;
+
+	ASSERT_OK(bpf_prog_query_opts(cgroup_fd, BPF_LSM_CGROUP, &p), "prog_query");
+
+	if (!attach_func)
+		return p.prog_cnt;
+
+	/* When attach_func is provided, count the number of progs that
+	 * attach to the given symbol.
+	 */
+
+	if (!btf)
+		btf = btf__load_vmlinux_btf();
+	if (!ASSERT_OK(libbpf_get_error(btf), "btf_vmlinux"))
+		return -1;
+
+	p.prog_ids = malloc(sizeof(u32) * p.prog_cnt);
+	p.prog_attach_flags = malloc(sizeof(u32) * p.prog_cnt);
+	ASSERT_OK(bpf_prog_query_opts(cgroup_fd, BPF_LSM_CGROUP, &p), "prog_query");
+
+	for (i = 0; i < p.prog_cnt; i++) {
+		struct bpf_prog_info info = {};
+		__u32 info_len = sizeof(info);
+		int fd;
+
+		fd = bpf_prog_get_fd_by_id(p.prog_ids[i]);
+		ASSERT_GE(fd, 0, "prog_get_fd_by_id");
+		ASSERT_OK(bpf_obj_get_info_by_fd(fd, &info, &info_len), "prog_info_by_fd");
+		close(fd);
+
+		if (info.attach_btf_func_id ==
+		    btf__find_by_name_kind(btf, attach_func, BTF_KIND_FUNC))
+			cnt++;
+	}
+
+	return cnt;
+}
+
+static void test_lsm_cgroup_functional(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_prog_attach_opts, attach_opts);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
+	int cgroup_fd, cgroup_fd2, err, fd, prio;
+	int listen_fd, client_fd, accepted_fd;
+	struct lsm_cgroup *skel = NULL;
+	int post_create_prog_fd2 = -1;
+	int post_create_prog_fd = -1;
+	int bind_link_fd2 = -1;
+	int bind_prog_fd2 = -1;
+	int alloc_prog_fd = -1;
+	int bind_prog_fd = -1;
+	int bind_link_fd = -1;
+	int clone_prog_fd = -1;
+	socklen_t socklen;
+
+	cgroup_fd = test__join_cgroup("/sock_policy");
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		goto close_skel;
+
+	cgroup_fd2 = create_and_get_cgroup("/sock_policy2");
+	if (!ASSERT_GE(cgroup_fd2, 0, "create second cgroup"))
+		goto close_skel;
+
+	skel = lsm_cgroup__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto close_cgroup;
+
+	post_create_prog_fd = bpf_program__fd(skel->progs.socket_post_create);
+	post_create_prog_fd2 = bpf_program__fd(skel->progs.socket_post_create2);
+	bind_prog_fd = bpf_program__fd(skel->progs.socket_bind);
+	bind_prog_fd2 = bpf_program__fd(skel->progs.socket_bind2);
+	alloc_prog_fd = bpf_program__fd(skel->progs.socket_alloc);
+	clone_prog_fd = bpf_program__fd(skel->progs.socket_clone);
+
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_sk_alloc_security"), 0, "prog count");
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 0, "total prog count");
+	err = bpf_prog_attach(alloc_prog_fd, cgroup_fd, BPF_LSM_CGROUP, 0);
+	if (!ASSERT_OK(err, "attach alloc_prog_fd"))
+		goto detach_cgroup;
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_sk_alloc_security"), 1, "prog count");
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 1, "total prog count");
+
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_inet_csk_clone"), 0, "prog count");
+	err = bpf_prog_attach(clone_prog_fd, cgroup_fd, BPF_LSM_CGROUP, 0);
+	if (!ASSERT_OK(err, "attach clone_prog_fd"))
+		goto detach_cgroup;
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_inet_csk_clone"), 1, "prog count");
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 2, "total prog count");
+
+	/* Make sure replacing works. */
+
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_post_create"), 0, "prog count");
+	err = bpf_prog_attach(post_create_prog_fd, cgroup_fd,
+			      BPF_LSM_CGROUP, 0);
+	if (!ASSERT_OK(err, "attach post_create_prog_fd"))
+		goto close_cgroup;
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_post_create"), 1, "prog count");
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 3, "total prog count");
+
+	attach_opts.replace_prog_fd = post_create_prog_fd;
+	err = bpf_prog_attach_opts(post_create_prog_fd2, cgroup_fd,
+				   BPF_LSM_CGROUP, &attach_opts);
+	if (!ASSERT_OK(err, "prog replace post_create_prog_fd"))
+		goto detach_cgroup;
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_post_create"), 1, "prog count");
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 3, "total prog count");
+
+	/* Try the same attach/replace via link API. */
+
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 0, "prog count");
+	bind_link_fd = bpf_link_create(bind_prog_fd, cgroup_fd,
+				       BPF_LSM_CGROUP, NULL);
+	if (!ASSERT_GE(bind_link_fd, 0, "link create bind_prog_fd"))
+		goto detach_cgroup;
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 1, "prog count");
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 4, "total prog count");
+
+	update_opts.old_prog_fd = bind_prog_fd;
+	update_opts.flags = BPF_F_REPLACE;
+
+	err = bpf_link_update(bind_link_fd, bind_prog_fd2, &update_opts);
+	if (!ASSERT_OK(err, "link update bind_prog_fd"))
+		goto detach_cgroup;
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 1, "prog count");
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 4, "total prog count");
+
+	/* Attach another instance of bind program to another cgroup.
+	 * This should trigger the reuse of the trampoline shim (two
+	 * programs attaching to the same btf_id).
+	 */
+
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 1, "prog count");
+	ASSERT_EQ(query_prog_cnt(cgroup_fd2, "bpf_lsm_socket_bind"), 0, "prog count");
+	bind_link_fd2 = bpf_link_create(bind_prog_fd2, cgroup_fd2,
+					BPF_LSM_CGROUP, NULL);
+	if (!ASSERT_GE(bind_link_fd2, 0, "link create bind_prog_fd2"))
+		goto detach_cgroup;
+	ASSERT_EQ(query_prog_cnt(cgroup_fd2, "bpf_lsm_socket_bind"), 1, "prog count");
+	ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 4, "total prog count");
+	ASSERT_EQ(query_prog_cnt(cgroup_fd2, NULL), 1, "total prog count");
+
+	/* AF_UNIX is prohibited. */
+
+	fd = socket(AF_UNIX, SOCK_STREAM, 0);
+	ASSERT_LT(fd, 0, "socket(AF_UNIX)");
+
+	/* AF_INET6 gets default policy (sk_priority). */
+
+	fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (!ASSERT_GE(fd, 0, "socket(SOCK_STREAM)"))
+		goto detach_cgroup;
+
+	prio = 0;
+	socklen = sizeof(prio);
+	ASSERT_GE(getsockopt(fd, SOL_SOCKET, SO_PRIORITY, &prio, &socklen), 0,
+		  "getsockopt");
+	ASSERT_EQ(prio, 123, "sk_priority");
+
+	close(fd);
+
+	/* TX-only AF_PACKET is allowed. */
+
+	ASSERT_LT(socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL)), 0,
+		  "socket(AF_PACKET, ..., ETH_P_ALL)");
+
+	fd = socket(AF_PACKET, SOCK_RAW, 0);
+	ASSERT_GE(fd, 0, "socket(AF_PACKET, ..., 0)");
+
+	/* TX-only AF_PACKET can not be rebound. */
+
+	struct sockaddr_ll sa = {
+		.sll_family = AF_PACKET,
+		.sll_protocol = htons(ETH_P_ALL),
+	};
+	ASSERT_LT(bind(fd, (struct sockaddr *)&sa, sizeof(sa)), 0,
+		  "bind(ETH_P_ALL)");
+
+	close(fd);
+
+	/* Trigger passive open. */
+
+	listen_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
+	ASSERT_GE(listen_fd, 0, "start_server");
+	client_fd = connect_to_fd(listen_fd, 0);
+	ASSERT_GE(client_fd, 0, "connect_to_fd");
+	accepted_fd = accept(listen_fd, NULL, NULL);
+	ASSERT_GE(accepted_fd, 0, "accept");
+
+	prio = 0;
+	socklen = sizeof(prio);
+	ASSERT_GE(getsockopt(accepted_fd, SOL_SOCKET, SO_PRIORITY, &prio, &socklen), 0,
+		  "getsockopt");
+	ASSERT_EQ(prio, 234, "sk_priority");
+
+	/* These are replaced and never called. */
+	ASSERT_EQ(skel->bss->called_socket_post_create, 0, "called_create");
+	ASSERT_EQ(skel->bss->called_socket_bind, 0, "called_bind");
+
+	/* AF_INET6+SOCK_STREAM
+	 * AF_PACKET+SOCK_RAW
+	 * listen_fd
+	 * client_fd
+	 * accepted_fd
+	 */
+	ASSERT_EQ(skel->bss->called_socket_post_create2, 5, "called_create2");
+
+	/* start_server
+	 * bind(ETH_P_ALL)
+	 */
+	ASSERT_EQ(skel->bss->called_socket_bind2, 2, "called_bind2");
+	/* Single accept(). */
+	ASSERT_EQ(skel->bss->called_socket_clone, 1, "called_clone");
+
+	/* AF_UNIX+SOCK_STREAM (failed)
+	 * AF_INET6+SOCK_STREAM
+	 * AF_PACKET+SOCK_RAW (failed)
+	 * AF_PACKET+SOCK_RAW
+	 * listen_fd
+	 * client_fd
+	 * accepted_fd
+	 */
+	ASSERT_EQ(skel->bss->called_socket_alloc, 7, "called_alloc");
+
+	/* Make sure other cgroup doesn't trigger the programs. */
+
+	if (!ASSERT_OK(join_cgroup(""), "join root cgroup"))
+		goto detach_cgroup;
+
+	fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (!ASSERT_GE(fd, 0, "socket(SOCK_STREAM)"))
+		goto detach_cgroup;
+
+	prio = 0;
+	socklen = sizeof(prio);
+	ASSERT_GE(getsockopt(fd, SOL_SOCKET, SO_PRIORITY, &prio, &socklen), 0,
+		  "getsockopt");
+	ASSERT_EQ(prio, 0, "sk_priority");
+
+	close(fd);
+
+detach_cgroup:
+	ASSERT_GE(bpf_prog_detach2(post_create_prog_fd2, cgroup_fd,
+				   BPF_LSM_CGROUP), 0, "detach_create");
+	close(bind_link_fd);
+	/* Don't close bind_link_fd2, exercise cgroup release cleanup. */
+	ASSERT_GE(bpf_prog_detach2(alloc_prog_fd, cgroup_fd,
+				   BPF_LSM_CGROUP), 0, "detach_alloc");
+	ASSERT_GE(bpf_prog_detach2(clone_prog_fd, cgroup_fd,
+				   BPF_LSM_CGROUP), 0, "detach_clone");
+
+close_cgroup:
+	close(cgroup_fd);
+close_skel:
+	lsm_cgroup__destroy(skel);
+}
+
+void test_lsm_cgroup(void)
+{
+	if (test__start_subtest("functional"))
+		test_lsm_cgroup_functional();
+}
diff --git a/tools/testing/selftests/bpf/progs/lsm_cgroup.c b/tools/testing/selftests/bpf/progs/lsm_cgroup.c
new file mode 100644
index 000000000000..a263830900e2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/lsm_cgroup.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#ifndef AF_PACKET
+#define AF_PACKET 17
+#endif
+
+#ifndef AF_UNIX
+#define AF_UNIX 1
+#endif
+
+#ifndef EPERM
+#define EPERM 1
+#endif
+
+struct {
+	__uint(type, BPF_MAP_TYPE_CGROUP_STORAGE);
+	__type(key, __u64);
+	__type(value, __u64);
+} cgroup_storage SEC(".maps");
+
+int called_socket_post_create;
+int called_socket_post_create2;
+int called_socket_bind;
+int called_socket_bind2;
+int called_socket_alloc;
+int called_socket_clone;
+
+static __always_inline int test_local_storage(void)
+{
+	__u64 *val;
+
+	val = bpf_get_local_storage(&cgroup_storage, 0);
+	if (!val)
+		return 0;
+	*val += 1;
+
+	return 1;
+}
+
+static __always_inline int real_create(struct socket *sock, int family,
+				       int protocol)
+{
+	struct sock *sk;
+
+	/* Reject non-tx-only AF_PACKET. */
+	if (family == AF_PACKET && protocol != 0)
+		return 0; /* EPERM */
+
+	sk = sock->sk;
+	if (!sk)
+		return 1;
+
+	/* The rest of the sockets get default policy. */
+	sk->sk_priority = 123;
+
+	/* Can access cgroup local storage. */
+	if (!test_local_storage())
+		return 0; /* EPERM */
+
+	return 1;
+}
+
+/* __cgroup_bpf_run_lsm_socket */
+SEC("lsm_cgroup/socket_post_create")
+int BPF_PROG(socket_post_create, struct socket *sock, int family,
+	     int type, int protocol, int kern)
+{
+	called_socket_post_create++;
+	return real_create(sock, family, protocol);
+}
+
+/* __cgroup_bpf_run_lsm_socket */
+SEC("lsm_cgroup/socket_post_create")
+int BPF_PROG(socket_post_create2, struct socket *sock, int family,
+	     int type, int protocol, int kern)
+{
+	called_socket_post_create2++;
+	return real_create(sock, family, protocol);
+}
+
+static __always_inline int real_bind(struct socket *sock,
+				     struct sockaddr *address,
+				     int addrlen)
+{
+	struct sockaddr_ll sa = {};
+
+	if (sock->sk->__sk_common.skc_family != AF_PACKET)
+		return 1;
+
+	if (sock->sk->sk_kern_sock)
+		return 1;
+
+	bpf_probe_read_kernel(&sa, sizeof(sa), address);
+	if (sa.sll_protocol)
+		return 0; /* EPERM */
+
+	/* Can access cgroup local storage. */
+	if (!test_local_storage())
+		return 0; /* EPERM */
+
+	return 1;
+}
+
+/* __cgroup_bpf_run_lsm_socket */
+SEC("lsm_cgroup/socket_bind")
+int BPF_PROG(socket_bind, struct socket *sock, struct sockaddr *address,
+	     int addrlen)
+{
+	called_socket_bind++;
+	return real_bind(sock, address, addrlen);
+}
+
+/* __cgroup_bpf_run_lsm_socket */
+SEC("lsm_cgroup/socket_bind")
+int BPF_PROG(socket_bind2, struct socket *sock, struct sockaddr *address,
+	     int addrlen)
+{
+	called_socket_bind2++;
+	return real_bind(sock, address, addrlen);
+}
+
+/* __cgroup_bpf_run_lsm_current (via bpf_lsm_current_hooks) */
+SEC("lsm_cgroup/sk_alloc_security")
+int BPF_PROG(socket_alloc, struct sock *sk, int family, gfp_t priority)
+{
+	called_socket_alloc++;
+	if (family == AF_UNIX)
+		return 0; /* EPERM */
+
+	/* Can access cgroup local storage. */
+	if (!test_local_storage())
+		return 0; /* EPERM */
+
+	return 1;
+}
+
+/* __cgroup_bpf_run_lsm_sock */
+SEC("lsm_cgroup/inet_csk_clone")
+int BPF_PROG(socket_clone, struct sock *newsk, const struct request_sock *req)
+{
+	called_socket_clone++;
+
+	if (!newsk)
+		return 1;
+
+	/* Accepted request sockets get a different priority. */
+	newsk->sk_priority = 234;
+
+	/* Can access cgroup local storage. */
+	if (!test_local_storage())
+		return 0; /* EPERM */
+
+	return 1;
+}
-- 
2.36.1.124.g0e6072fb45-goog


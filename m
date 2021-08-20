Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E363F2789
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238830AbhHTHSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbhHTHSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 03:18:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D24C06175F;
        Fri, 20 Aug 2021 00:17:31 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so6638873pjb.3;
        Fri, 20 Aug 2021 00:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4rVLqSimv7UuIZrRmP3KLf98LVIiiHsRms8VmtPDtqw=;
        b=L8Id37/04OusMzLb1gDwbEBbbBQwm+obf0L8FN892kPqxlPjCV7/IqtyanEWZzazRU
         l8hZPrKcY3U2QkaX+WxjlyIRZYCVoNk/l6scXNl2ALjz1VNzpgqUqnG0ooy5wHtyvR/3
         rA31OX/kDjl/MYdFKuLPocaABBYDmnO6SkOGgNfdfulvg2Q4qPl6wC7Xi1AbSmZ/k6zq
         FIunXYffGewa/XQhB0sNbCijV1N4R3GrPJkdRtTacVXxW78/MRVyCTpIK9TS64xwno89
         vK/txJqSh+rL+x1Ex0B22jWqLDNe6m7hIdnhEIaGhLECPUFboT0sU942t3wyNH18Q7fc
         +gUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4rVLqSimv7UuIZrRmP3KLf98LVIiiHsRms8VmtPDtqw=;
        b=LkmSgZP+zs0FK9lfmpJbLmpGaK6zvahZbGmSGBCEp7Uwc6KBCac91l1wXKabSWaBmH
         XKNaHjE4wKIdGccN505AaaSsUN3pFQj2b2IhJDmQt7T4LbPnl93JfGmZxwGhkNu6qGjO
         T1M6mvE7o/Ji/geeI7hgEVSWbNzIQt397I1N8/AMKCAVWNNFmy0T//WZ82W2ncL1ktqu
         qdL8CHeSooxHV2LwkSN79G2pDP419g7dFJMmXMPPOD3nbRwF6s5ol94vwzXeDp7sUICe
         C/Q23RI4xuTucj9+376qJDy92T0fllXoRSj7kDOm1uUK62fsFEobW8LYr6YCPOnN4Xck
         2EWA==
X-Gm-Message-State: AOAM530JmlUcrUmNAli19JBQId86lz7HKLngNTkrtcPDcoWNo1DYR7Yf
        05XPaklxCQ4oSyeKZGWM0nQ=
X-Google-Smtp-Source: ABdhPJx4L5kYE1blgtCT2GaPpIx+ra8mSSHZoKMsi0Z968iTab5tOPLX3XNGT75e7MDVJl8ClBh0fQ==
X-Received: by 2002:a17:90a:7848:: with SMTP id y8mr3085125pjl.223.1629443850620;
        Fri, 20 Aug 2021 00:17:30 -0700 (PDT)
Received: from IRVINGLIU-MB0.tencent.com ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id u21sm5717544pfh.163.2021.08.20.00.17.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Aug 2021 00:17:30 -0700 (PDT)
From:   Xu Liu <liuxu623@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Liu <liuxu623@gmail.com>
Subject: [PATCH bpf-next 2/2] selftests/bpf: Test for get_netns_cookie
Date:   Fri, 20 Aug 2021 15:17:12 +0800
Message-Id: <20210820071712.52852-3-liuxu623@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210820071712.52852-1-liuxu623@gmail.com>
References: <20210820071712.52852-1-liuxu623@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test to use get_netns_cookie() from BPF_PROG_TYPE_SK_MSG.

Signed-off-by: Xu Liu <liuxu623@gmail.com>
---
 .../selftests/bpf/prog_tests/netns_cookie.c   | 57 ++++++++++++-------
 .../selftests/bpf/progs/netns_cookie_prog.c   | 55 ++++++++++++++++--
 2 files changed, 88 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/netns_cookie.c b/tools/testing/selftests/bpf/prog_tests/netns_cookie.c
index 6f3cd472fb65..71d8f3ba7d6b 100644
--- a/tools/testing/selftests/bpf/prog_tests/netns_cookie.c
+++ b/tools/testing/selftests/bpf/prog_tests/netns_cookie.c
@@ -12,10 +12,12 @@ static int duration;
 
 void test_netns_cookie(void)
 {
-	int server_fd = 0, client_fd = 0, cgroup_fd = 0, err = 0, val = 0;
+	int server_fd = -1, client_fd = -1, cgroup_fd = -1;
+	int err, val, ret, map, verdict;
 	struct netns_cookie_prog *skel;
 	uint64_t cookie_expected_value;
 	socklen_t vallen = sizeof(cookie_expected_value);
+	static const char send_msg[] = "message";
 
 	skel = netns_cookie_prog__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "skel_open"))
@@ -23,39 +25,56 @@ void test_netns_cookie(void)
 
 	cgroup_fd = test__join_cgroup("/netns_cookie");
 	if (CHECK(cgroup_fd < 0, "join_cgroup", "cgroup creation failed\n"))
-		goto out;
+		goto done;
 
 	skel->links.get_netns_cookie_sockops = bpf_program__attach_cgroup(
 		skel->progs.get_netns_cookie_sockops, cgroup_fd);
 	if (!ASSERT_OK_PTR(skel->links.get_netns_cookie_sockops, "prog_attach"))
-		goto close_cgroup_fd;
+		goto done;
+
+	verdict = bpf_program__fd(skel->progs.get_netns_cookie_sk_msg);
+	map = bpf_map__fd(skel->maps.sock_map);
+	err = bpf_prog_attach(verdict, map, BPF_SK_MSG_VERDICT, 0);
+	if (!ASSERT_OK(err, "prog_attach"))
+		goto done;
 
 	server_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
 	if (CHECK(server_fd < 0, "start_server", "errno %d\n", errno))
-		goto close_cgroup_fd;
+		goto done;
 
 	client_fd = connect_to_fd(server_fd, 0);
 	if (CHECK(client_fd < 0, "connect_to_fd", "errno %d\n", errno))
-		goto close_server_fd;
+		goto done;
+
+	ret = send(client_fd, send_msg, sizeof(send_msg), 0);
+	if (CHECK(ret != sizeof(send_msg), "send(msg)", "ret:%d\n", ret))
+		goto done;
 
-	err = bpf_map_lookup_elem(bpf_map__fd(skel->maps.netns_cookies),
-				&client_fd, &val);
-	if (!ASSERT_OK(err, "map_lookup(socket_cookies)"))
-		goto close_client_fd;
+	err = bpf_map_lookup_elem(bpf_map__fd(skel->maps.sockops_netns_cookies),
+				  &client_fd, &val);
+	if (!ASSERT_OK(err, "map_lookup(sockops_netns_cookies)"))
+		goto done;
 
 	err = getsockopt(client_fd, SOL_SOCKET, SO_NETNS_COOKIE,
-				&cookie_expected_value, &vallen);
-	if (!ASSERT_OK(err, "getsockopt)"))
-		goto close_client_fd;
+			 &cookie_expected_value, &vallen);
+	if (!ASSERT_OK(err, "getsockopt"))
+		goto done;
+
+	ASSERT_EQ(val, cookie_expected_value, "cookie_value");
+
+	err = bpf_map_lookup_elem(bpf_map__fd(skel->maps.sk_msg_netns_cookies),
+				  &client_fd, &val);
+	if (!ASSERT_OK(err, "map_lookup(sk_msg_netns_cookies)"))
+		goto done;
 
 	ASSERT_EQ(val, cookie_expected_value, "cookie_value");
 
-close_client_fd:
-	close(client_fd);
-close_server_fd:
-	close(server_fd);
-close_cgroup_fd:
-	close(cgroup_fd);
-out:
+done:
+	if (server_fd != -1)
+		close(server_fd);
+	if (client_fd != -1)
+		close(client_fd);
+	if (cgroup_fd != -1)
+		close(cgroup_fd);
 	netns_cookie_prog__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/netns_cookie_prog.c b/tools/testing/selftests/bpf/progs/netns_cookie_prog.c
index 4ed8d75aa299..aeff3a4f9287 100644
--- a/tools/testing/selftests/bpf/progs/netns_cookie_prog.c
+++ b/tools/testing/selftests/bpf/progs/netns_cookie_prog.c
@@ -11,29 +11,74 @@ struct {
 	__uint(map_flags, BPF_F_NO_PREALLOC);
 	__type(key, int);
 	__type(value, int);
-} netns_cookies SEC(".maps");
+} sockops_netns_cookies SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, int);
+} sk_msg_netns_cookies SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 2);
+	__type(key, __u32);
+	__type(value, __u64);
+} sock_map SEC(".maps");
 
 SEC("sockops")
 int get_netns_cookie_sockops(struct bpf_sock_ops *ctx)
 {
 	struct bpf_sock *sk = ctx->sk;
 	int *cookie;
+	__u32 key = 0;
 
 	if (ctx->family != AF_INET6)
 		return 1;
 
-	if (ctx->op != BPF_SOCK_OPS_TCP_CONNECT_CB)
+	if (!sk)
+		return 1;
+
+	switch (ctx->op) {
+	case BPF_SOCK_OPS_TCP_CONNECT_CB:
+		cookie = bpf_sk_storage_get(&sockops_netns_cookies, sk, 0,
+					    BPF_SK_STORAGE_GET_F_CREATE);
+		if (!cookie)
+			return 1;
+
+		*cookie = bpf_get_netns_cookie(ctx);
+		break;
+	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
+		bpf_sock_map_update(ctx, &sock_map, &key, BPF_NOEXIST);
+		break;
+	default:
+		break;
+	}
+
+	return 1;
+}
+
+SEC("sk_msg")
+int get_netns_cookie_sk_msg(struct sk_msg_md *msg)
+{
+	struct bpf_sock *sk = msg->sk;
+	int *cookie;
+
+	if (msg->family != AF_INET6)
 		return 1;
 
 	if (!sk)
 		return 1;
 
-	cookie = bpf_sk_storage_get(&netns_cookies, sk, 0,
-				BPF_SK_STORAGE_GET_F_CREATE);
+	cookie = bpf_sk_storage_get(&sk_msg_netns_cookies, sk, 0,
+				    BPF_SK_STORAGE_GET_F_CREATE);
 	if (!cookie)
 		return 1;
 
-	*cookie = bpf_get_netns_cookie(ctx);
+	*cookie = bpf_get_netns_cookie(msg);
 
 	return 1;
 }
+
+char _license[] SEC("license") = "GPL";
-- 
2.28.0


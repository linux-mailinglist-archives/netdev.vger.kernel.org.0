Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4384590861
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 23:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbiHKVzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 17:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiHKVzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 17:55:47 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A883F205EF;
        Thu, 11 Aug 2022 14:55:46 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 405513200A0B;
        Thu, 11 Aug 2022 17:55:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 11 Aug 2022 17:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660254944; x=1660341344; bh=Vq
        TrSm+ya66oiGwyuUz91JD64VsI4fFY3wbADjNL3Fk=; b=DRk25ikKXNXo/32qX9
        xSDBVzQt5n4uz74u7ZhFdm7NVEjO+wL0m6Mex7U+QIE9kUjORU/nhD2UGFb8oD5o
        xg6v9RQd1LKChoEMY0bUj85xrvLhXz5t6Wqzmpvm19F2Fv6D8ohX/q2gQbt9MPdn
        E41VaNGFoTBxPz1SUmAbWypCmYxs3/rNmURfOdvGIB3BHVYIntm3+iLKV48c8vOe
        tE33GLYdJgzQF5GdJM9GawDqJHciAhW1b35C1EiJT1gLtvCa1NhTooy64MZfnmEw
        SCONzel0LGpq/wkQckrWxjqHE5SsNiCQhzfCGKreuNN+6W/ulyeemk+EEL63uxEx
        VOpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660254944; x=1660341344; bh=VqTrSm+ya66oi
        GwyuUz91JD64VsI4fFY3wbADjNL3Fk=; b=KOxToTnw0HYsvsqonkiFMqDa9+Hbn
        4iDe4lnCJTtucF/HCx4QTHUfONOPWUtazE+4LA8qwjDHRkukbtMvkKMnnl9+4j63
        Dk/qYWZ57KyNISDoHJkuyzbIW+EKsGwZfH7W+Z/eZK+e3cpy9B84HwpQxFgkO679
        +e1bLVoEhzGNZtxELnMh+1v0L/wTKXQZ6Lo+eP/RFhFdbXgiBFRCXxVSFFSPrsMH
        WXZHBoN/wD1eKUwVUTMFhBIwKS/gEYuX0Dn+UuUSzp3QpkZM7p4ANRxtXkMd+f3S
        3y+Ei5gB3Jx5qteYVPodD6kJ4Qx34EcmuB/PgE353wJ9DZ5Z0xGm2yb5Q==
X-ME-Sender: <xms:4Hr1YlDw7wqN1T9pwikt8GfLvWowhlljRyp_0N3UlGizF2p6FU2WXg>
    <xme:4Hr1YjhOx2vsVnigQMzVbEnYe4xm-5TYghyilw0vb1HIBwyE66uYp8z9K6_q3_OVC
    aRYKo8DL_rPMsjrSw>
X-ME-Received: <xmr:4Hr1Ygn2IpeF72lMcmbcktW0J68-bcfrbbGI1QCKc8wmD7hYfUAJzscXQ3RAsC5B0Mh7vNqdKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeghedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfeehmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhephfejheejleejtdelie
    efudejvdeutdetueevkeehudeuheelteethfeukedtieefnecuffhomhgrihhnpehiphhv
    gedrshhpohhrthenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:4Hr1YvxDHqY0rLcy-3K_C2qbOoHfeVuHW5qvXbWSBofxh4xCtndWQQ>
    <xmx:4Hr1YqQei1zBt9zE56S7cIrW7XLvOKoO7LiSNoi3dcJSAkdVFAHS0w>
    <xmx:4Hr1YiYA2lyGVJ8i4WvzXGITWVU5GNohzEzxMR5B9p_AMFda0BInVA>
    <xmx:4Hr1Yr9bfNWQqN8-x_TExZlOdQN2ns8IriHiFC6iyfo5iHzA8ax3gQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Aug 2022 17:55:42 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 1/3] selftests/bpf: Add existing connection bpf_*_ct_lookup() test
Date:   Thu, 11 Aug 2022 15:55:25 -0600
Message-Id: <de5a617832f38f8b5631cc87e2a836da7c94d497.1660254747.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660254747.git.dxu@dxuuu.xyz>
References: <cover.1660254747.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test where we do a conntrack lookup on an existing connection.
This is nice because it's a more realistic test than artifically
creating a ct entry and looking it up afterwards.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/bpf_nf.c | 59 +++++++++++++++++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 18 ++++++
 2 files changed, 77 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index 7a74a1579076..88a2c0bdefec 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -24,10 +24,34 @@ enum {
 	TEST_TC_BPF,
 };
 
+#define TIMEOUT_MS 3000
+
+static int connect_to_server(int srv_fd)
+{
+	int fd = -1;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (!ASSERT_GE(fd, 0, "socket"))
+		goto out;
+
+	if (!ASSERT_EQ(connect_fd_to_fd(fd, srv_fd, TIMEOUT_MS), 0, "connect_fd_to_fd")) {
+		close(fd);
+		fd = -1;
+	}
+out:
+	return fd;
+}
+
 static void test_bpf_nf_ct(int mode)
 {
+	const char *iptables = "iptables -t raw %s PREROUTING -j CT";
+	int srv_fd = -1, client_fd = -1, srv_client_fd = -1;
+	struct sockaddr_in peer_addr = {};
 	struct test_bpf_nf *skel;
 	int prog_fd, err;
+	socklen_t len;
+	u16 srv_port;
+	char cmd[64];
 	LIBBPF_OPTS(bpf_test_run_opts, topts,
 		.data_in = &pkt_v4,
 		.data_size_in = sizeof(pkt_v4),
@@ -38,6 +62,32 @@ static void test_bpf_nf_ct(int mode)
 	if (!ASSERT_OK_PTR(skel, "test_bpf_nf__open_and_load"))
 		return;
 
+	/* Enable connection tracking */
+	snprintf(cmd, sizeof(cmd), iptables, "-A");
+	if (!ASSERT_OK(system(cmd), "iptables"))
+		goto end;
+
+	srv_port = (mode == TEST_XDP) ? 5005 : 5006;
+	srv_fd = start_server(AF_INET, SOCK_STREAM, "127.0.0.1", srv_port, TIMEOUT_MS);
+	if (!ASSERT_GE(srv_fd, 0, "start_server"))
+		goto end;
+
+	client_fd = connect_to_server(srv_fd);
+	if (!ASSERT_GE(client_fd, 0, "connect_to_server"))
+		goto end;
+
+	len = sizeof(peer_addr);
+	srv_client_fd = accept(srv_fd, (struct sockaddr *)&peer_addr, &len);
+	if (!ASSERT_GE(srv_client_fd, 0, "accept"))
+		goto end;
+	if (!ASSERT_EQ(len, sizeof(struct sockaddr_in), "sockaddr len"))
+		goto end;
+
+	skel->bss->saddr = peer_addr.sin_addr.s_addr;
+	skel->bss->sport = peer_addr.sin_port;
+	skel->bss->daddr = peer_addr.sin_addr.s_addr;
+	skel->bss->dport = htons(srv_port);
+
 	if (mode == TEST_XDP)
 		prog_fd = bpf_program__fd(skel->progs.nf_xdp_ct_test);
 	else
@@ -63,7 +113,16 @@ static void test_bpf_nf_ct(int mode)
 	ASSERT_LE(skel->bss->test_delta_timeout, 10, "Test for max ct timeout update");
 	/* expected status is IPS_SEEN_REPLY */
 	ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
+	ASSERT_EQ(skel->data->test_exist_lookup, 0, "Test existing connection lookup");
 end:
+	if (srv_client_fd != -1)
+		close(srv_client_fd);
+	if (client_fd != -1)
+		close(client_fd);
+	if (srv_fd != -1)
+		close(srv_fd);
+	snprintf(cmd, sizeof(cmd), iptables, "-D");
+	system(cmd);
 	test_bpf_nf__destroy(skel);
 }
 
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index 196cd8dfe42a..84e0fd479794 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -23,6 +23,11 @@ int test_insert_entry = -EAFNOSUPPORT;
 int test_succ_lookup = -ENOENT;
 u32 test_delta_timeout = 0;
 u32 test_status = 0;
+__be32 saddr = 0;
+__be16 sport = 0;
+__be32 daddr = 0;
+__be16 dport = 0;
+int test_exist_lookup = -ENOENT;
 
 struct nf_conn;
 
@@ -160,6 +165,19 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 		}
 		test_alloc_entry = 0;
 	}
+
+	bpf_tuple.ipv4.saddr = saddr;
+	bpf_tuple.ipv4.daddr = daddr;
+	bpf_tuple.ipv4.sport = sport;
+	bpf_tuple.ipv4.dport = dport;
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def));
+	if (ct) {
+		test_exist_lookup = 0;
+		bpf_ct_release(ct);
+	} else {
+		test_exist_lookup = opts_def.error;
+	}
 }
 
 SEC("xdp")
-- 
2.37.1


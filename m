Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945D963BA50
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiK2HJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiK2HJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:09:30 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CF654B39;
        Mon, 28 Nov 2022 23:09:21 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669705760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//zKZ0Noqsu9iGtXCTKTDc+x5DdRB6HefxFQ/T9NHTw=;
        b=isidMuC2MPBrsAfswDDm+CyJ50W5OAMW67SaOktceGpawWtEFIiA3cRACBbUJXLA5wE715
        z2UUXybQsYmymy+G/ncrfAvxgb6n/H0PiMLQ2ilpY6EjpNcGtpmxNkYQnLlmXbTUqrsVlX
        3vdNHvSuMoaoObMzNC4zyE6OA0gfWq4=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 6/7] selftests/bpf: Remove serial from tests using {open,close}_netns
Date:   Mon, 28 Nov 2022 23:08:59 -0800
Message-Id: <20221129070900.3142427-7-martin.lau@linux.dev>
In-Reply-To: <20221129070900.3142427-1-martin.lau@linux.dev>
References: <20221129070900.3142427-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

After removing the mount/umount dance from {open,close}_netns()
in the pervious patch, "serial_" can be removed from
the tests using {open,close}_netns().

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/empty_skb.c       | 2 +-
 tools/testing/selftests/bpf/prog_tests/tc_redirect.c     | 2 +-
 tools/testing/selftests/bpf/prog_tests/test_tunnel.c     | 2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c | 2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/empty_skb.c b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
index 0613f3bb8b5e..32dd731e9070 100644
--- a/tools/testing/selftests/bpf/prog_tests/empty_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
@@ -9,7 +9,7 @@
 		goto out; \
 })
 
-void serial_test_empty_skb(void)
+void test_empty_skb(void)
 {
 	LIBBPF_OPTS(bpf_test_run_opts, tattr);
 	struct empty_skb *bpf_obj = NULL;
diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index 6f800381f924..bca5e6839ac4 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -1138,7 +1138,7 @@ static void *test_tc_redirect_run_tests(void *arg)
 	return NULL;
 }
 
-void serial_test_tc_redirect(void)
+void test_tc_redirect(void)
 {
 	pthread_t test_thread;
 	int err;
diff --git a/tools/testing/selftests/bpf/prog_tests/test_tunnel.c b/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
index eea274110267..07ad457f3370 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
@@ -421,7 +421,7 @@ static void *test_tunnel_run_tests(void *arg)
 	return NULL;
 }
 
-void serial_test_tunnel(void)
+void test_tunnel(void)
 {
 	pthread_t test_thread;
 	int err;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index 9ac6f6a268db..a50971c6cf4a 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -85,7 +85,7 @@ static void test_max_pkt_size(int fd)
 }
 
 #define NUM_PKTS 10000
-void serial_test_xdp_do_redirect(void)
+void test_xdp_do_redirect(void)
 {
 	int err, xdp_prog_fd, tc_prog_fd, ifindex_src, ifindex_dst;
 	char data[sizeof(pkt_udp) + sizeof(__u32)];
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
index 13daa3746064..c72083885b6d 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
@@ -174,7 +174,7 @@ static void test_synproxy(bool xdp)
 	system("ip netns del synproxy");
 }
 
-void serial_test_xdp_synproxy(void)
+void test_xdp_synproxy(void)
 {
 	if (test__start_subtest("xdp"))
 		test_synproxy(true);
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC8140240F
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241504AbhIGHV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240049AbhIGHVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:13 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5EEC061575;
        Tue,  7 Sep 2021 00:20:07 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id z4so12910733wrr.6;
        Tue, 07 Sep 2021 00:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oAGNrcNQYB84HhuUPlRuztgCCKVcBp6IrQtcuLVdXys=;
        b=HotHQjJdSvYjz8hppfp4HbtjnlcsI283cCTpkZEErS7U4XvXMQmKXmvUItPT6CjSMv
         HzLNQMBzI+Xq52ASq1JFk5xRo7Nx4Pj5eNjZO0BUzN5ozIu5+8aPYdtjZ5xB4lh2Xlg9
         obA1DJERjg1b1s+derBm1WeVT6w4LV0zHdUOWvxwGI5cYLCCnfpOrHHlvOUY6YAeEOkb
         eq6XhjmNj7HOLYD47MTI+ffOw4Rh8SGo9t0vtdP7IOm48nw96CjUs+iCSx51wDeZerEs
         eAo4EF/FJTxpjw/1cbopB9dB45lv+IqQzzsANIrlIiIE5A5zAMJANoXOfnte1ixto1kr
         9HnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oAGNrcNQYB84HhuUPlRuztgCCKVcBp6IrQtcuLVdXys=;
        b=VSRj1U/rYFQxYijVTztjtZnzgWSbXO0GpckVvf/JtdZcF9oViVNbsTqE84L2gSQLUL
         CB/DTT0765q7XvAsKOi+/2O/CDUY+c22Wh78erUTfQcU4UZRzkewijzf8D/mGNxznD8T
         Sisp3k0KpJG5sKJLuQ73rufLIM3kBhsFxFH8StNS52+FMH7Y6poU03jcpBonvtBQiuRg
         PRLcr9Xu2uaEePa9pWHmOjwLDyDmcJGvfsSSlRpVDW4WafGGpG6s9VjVpScRQmj2+Rt0
         40QI6vhDVg2fR9zr9CCqq5pDpmHAf4NKtgQzzsFhUkm8fO1mHiiuc/QJbAU0F+DcYKQC
         9PmA==
X-Gm-Message-State: AOAM5316sTIK50+nKkhqSyGT6yaVHZDD4npQf+BuOjZ6LV8eeTe0ULSl
        ovP0TNInP4tVi1vo1RBQagg=
X-Google-Smtp-Source: ABdhPJwhnIpBJQIeVCy1maMGVmBsOMmtslBi+T/WCMg95ZLlv2tUQRb29gi0CDY00d54/D9trcj3yw==
X-Received: by 2002:a5d:5263:: with SMTP id l3mr6807691wrc.159.1630999205992;
        Tue, 07 Sep 2021 00:20:05 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.20.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:20:05 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 11/20] selftests: xsk: specify number of sockets to create
Date:   Tue,  7 Sep 2021 09:19:19 +0200
Message-Id: <20210907071928.9750-12-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add the ability in the test specification to specify numbers of
sockets to create. The default is one socket. This is then used to
remove test specific if-statements around the bpf_res tests.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 59 +++++++++++-------------
 tools/testing/selftests/bpf/xdpxceiver.h |  2 +-
 2 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 0a3e28c9e2a9..06fa767191af 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -231,7 +231,7 @@ static void gen_udp_csum(struct udphdr *udp_hdr, struct iphdr *ip_hdr)
 	    udp_csum(ip_hdr->saddr, ip_hdr->daddr, UDP_PKT_SIZE, IPPROTO_UDP, (u16 *)udp_hdr);
 }
 
-static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size, int idx)
+static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size)
 {
 	struct xsk_umem_config cfg = {
 		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
@@ -410,6 +410,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 	test->ifobj_rx = ifobj_rx;
 	test->current_step = 0;
 	test->total_steps = 1;
+	test->nb_sockets = 1;
 }
 
 static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
@@ -770,46 +771,37 @@ static void tx_stats_validate(struct ifobject *ifobject)
 
 static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 {
-	u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
-	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
-	size_t mmap_sz = umem_sz;
-	int ctr = 0, ret;
-	void *bufs;
+	u32 i;
 
 	ifobject->ns_fd = switch_namespace(ifobject->nsname);
 
-	if (test_type == TEST_TYPE_BPF_RES)
-		mmap_sz *= 2;
-
-	bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
-	if (bufs == MAP_FAILED)
-		exit_with_error(errno);
+	for (i = 0; i < test->nb_sockets; i++) {
+		u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
+		int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
+		u32 ctr = 0;
+		void *bufs;
 
-	while (ctr++ < SOCK_RECONF_CTR) {
-		ret = xsk_configure_umem(&ifobject->umem_arr[0], bufs, umem_sz, 0);
-		if (ret)
-			exit_with_error(-ret);
+		bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
+		if (bufs == MAP_FAILED)
+			exit_with_error(errno);
 
-		ret = xsk_configure_socket(&ifobject->xsk_arr[0], &ifobject->umem_arr[0],
-					   ifobject, 0);
-		if (!ret)
-			break;
+		while (ctr++ < SOCK_RECONF_CTR) {
+			int ret;
 
-		/* Retry Create Socket if it fails as xsk_socket__create() is asynchronous */
-		if (ctr >= SOCK_RECONF_CTR)
-			exit_with_error(-ret);
-		usleep(USLEEP_MAX);
-	}
+			ret = xsk_configure_umem(&ifobject->umem_arr[i], bufs, umem_sz);
+			if (ret)
+				exit_with_error(-ret);
 
-	if (test_type == TEST_TYPE_BPF_RES) {
-		ret = xsk_configure_umem(&ifobject->umem_arr[1], (u8 *)bufs + umem_sz, umem_sz, 1);
-		if (ret)
-			exit_with_error(-ret);
+			ret = xsk_configure_socket(&ifobject->xsk_arr[i], &ifobject->umem_arr[i],
+						   ifobject, i);
+			if (!ret)
+				break;
 
-		ret = xsk_configure_socket(&ifobject->xsk_arr[1], &ifobject->umem_arr[1],
-					   ifobject, 1);
-		if (ret)
-			exit_with_error(-ret);
+			/* Retry if it fails as xsk_socket__create() is asynchronous */
+			if (ctr >= SOCK_RECONF_CTR)
+				exit_with_error(-ret);
+			usleep(USLEEP_MAX);
+		}
 	}
 
 	ifobject->umem = &ifobject->umem_arr[0];
@@ -959,6 +951,7 @@ static void testapp_bpf_res(struct test_spec *test)
 {
 	test_spec_set_name(test, "BPF_RES");
 	test->total_steps = 2;
+	test->nb_sockets = 2;
 	testapp_validate_traffic(test);
 
 	swap_xsk_resources(test->ifobj_tx, test->ifobj_rx);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index ea505a4cb8c0..c09b73fd9878 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -24,7 +24,6 @@
 #define MAX_SOCKETS 2
 #define MAX_TEST_NAME_SIZE 32
 #define MAX_TEARDOWN_ITER 10
-#define MAX_BPF_ITER 2
 #define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
 			sizeof(struct udphdr))
 #define MIN_PKT_SIZE 64
@@ -137,6 +136,7 @@ struct test_spec {
 	struct ifobject *ifobj_rx;
 	u16 total_steps;
 	u16 current_step;
+	u16 nb_sockets;
 	char name[MAX_TEST_NAME_SIZE];
 };
 
-- 
2.29.0


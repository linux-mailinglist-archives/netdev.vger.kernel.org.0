Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC6C3FD815
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238735AbhIAKt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238369AbhIAKtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:49:13 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94923C061575;
        Wed,  1 Sep 2021 03:48:16 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q11so3759151wrr.9;
        Wed, 01 Sep 2021 03:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oAGNrcNQYB84HhuUPlRuztgCCKVcBp6IrQtcuLVdXys=;
        b=g0gPYrAjEn/k9T34vrgJ+84475LkGmGMxziz3pbvQPaSLtv76lDJ0GleWfS3055dEl
         TOHtrMxS37EsJ+RmDA9QiUlJM2J/ySWeMKC8/mqvSGhpTktVvMyODtnOHzy7mYAMxbgC
         yhUrLtHVZyIrWlvIEEy9jaytqyqNiPy1KyHjENScNw6/xMqVEHWCesUxBCWrM4yj4NzW
         nTJGBj8HaLE6q7zevYCwhU4G5jsu1E3tFjlEIA4jIAJphkI7pA/0v9qk48E1Rua2MVTE
         AOOO3UUVHzhS3VWP589++NmMJBmWgDO8l6i02XaA1Tmezz5OgZVcOYywQHpIUMEb2HqV
         k3aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oAGNrcNQYB84HhuUPlRuztgCCKVcBp6IrQtcuLVdXys=;
        b=KNjjPKDxob5FkCt+ciHBrXagZ6SbWsrVmU2ItiWWouq8giWj8ZiRJh4AArPF0FNLUC
         9oVksIlSfxN+iNafuFJaALmkPtb9O1TUwGPbDZhUJ1iMWRDJ49huMG8QsNkqZUwofLP7
         Ifhl8oSb7qSGM8/w+fm7DHGD8emfdX30D21gU6koOdx0hTWHvqTdLZ5CZLpioFejSdge
         GuSDW/JOFLj/BRFZt1K6cPf6cowFUdNTgRav/OvSTn6dPwN84aoersOYwwj+1Ot3f2c2
         B/mLm6WbI66dqdxLRcurO+LKlyI/JlLiDPcYZGCxee/UTDAWX0/gGz2TdL/5yXvPX/9O
         ulTA==
X-Gm-Message-State: AOAM531lqpFMg59oolwAg3Mu8U1CR+CIKgnrOvtPL78ZYPn/XvDkfehv
        dta3cvv5wLDQifbfT9sDCpA=
X-Google-Smtp-Source: ABdhPJySM4erWAWwCOFzvGXEiLMIqUlFLRnf1BQQZcNEr37bwYfNgzbXL2XRWioMfm9WEqPvwh09pw==
X-Received: by 2002:a05:6000:1248:: with SMTP id j8mr37869580wrx.97.1630493295218;
        Wed, 01 Sep 2021 03:48:15 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:14 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 11/20] selftests: xsk: specify number of sockets to create
Date:   Wed,  1 Sep 2021 12:47:23 +0200
Message-Id: <20210901104732.10956-12-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
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


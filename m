Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA4B3FD81B
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbhIAKte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238489AbhIAKtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:49:15 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12357C061575;
        Wed,  1 Sep 2021 03:48:18 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x6so3719080wrv.13;
        Wed, 01 Sep 2021 03:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NNBaqyo/7ZhbzjZjrYIN9gMRh6tHWawhWi2LjamABiA=;
        b=pljGBccuUErt3ueRXybMYmgik9fQ7/tphhojO49FYyUjMf36/z5X+3mg8RHjq+nRXS
         VU4sFaEQxsRDhF5NCuH4gj1krDO6seeR2EfpI2OSTtpQ0PGTSyNtzsep2Sx7zb570bwI
         e5mvd6OfkLN8MpYGywI5uI4qzDAnfxY1YKW4BKiuFQsAwFJUNr59ziItsmu6VZWgIUD1
         SNPzLqQwbIpZNvCw5IlHEfqi6SRXQ3lN00ER6l2DqB9NFNKmGUO9R/mRbRs/S4PtSKMk
         oUUe6B5PlAkqYy3opVn2aZFvChLM0KEj+m9MXcIv5PuhfJGEO5x+eTyauU+DajssVWmc
         EfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NNBaqyo/7ZhbzjZjrYIN9gMRh6tHWawhWi2LjamABiA=;
        b=Va1S9OB5P7MTenLBiT5BK8OkoMD3C5aZ93573+5Ttl6XWqoh1ZrReFNQG5Eo9X9EWf
         9kX6jig/TYrNIxb/DXiLxBHNLTw0jVs7UaMPsUa3YxazQMVBybhSdfq2QYe2C8JnOicv
         XewTvWj5bARXmpS+RelRCXtkaOoTzqSySpM/ySutCawjjmqgOxvstPPUEcqWkYkz4Csm
         IsjTk1Veuf6vbE6gMTH57je+1UJ3Kd/0Ejysb0mI/dT/CcslrLDn4nyaLRBQ+t/RkOMj
         0ro2q5r6VC0GGmj9ez82RcHnKeNb2aaaEF/D+jqaqhjM4w+phyByZcNGArkqpK+8o2Vk
         oehA==
X-Gm-Message-State: AOAM530Oj9URQSXUWhPqljuun/F4UdSFzhIuAn4DQnggxnmQj/opfgND
        mrMUjETEt0oan2kKPLqdVFI=
X-Google-Smtp-Source: ABdhPJzff36FiR1lyxEGLYDbVtmdcICN7U2yHFiuq8Mdgil7N4JHN52YTCjF/e2kza+Pwo/zidtoQw==
X-Received: by 2002:a5d:44ca:: with SMTP id z10mr9534364wrr.298.1630493296676;
        Wed, 01 Sep 2021 03:48:16 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:16 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 12/20] selftests: xsk: make xdp_flags and bind_flags local
Date:   Wed,  1 Sep 2021 12:47:24 +0200
Message-Id: <20210901104732.10956-13-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make xdp_flags and bind_flags local instead of global by moving them
into the interface object. These flags decide if the socket should be
created in SKB mode or in DRV mode and therefore they are sticky and
will survive a test_spec_reset. Since every test is first run in SKB
mode then in DRV mode, this change only happens once. With this
change, the configured_mode global variable can also be
erradicated. The first test_spec_init() also becomes superfluous and
can be eliminated.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 57 ++++++++++++------------
 tools/testing/selftests/bpf/xdpxceiver.h |  6 +--
 2 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 06fa767191af..3a1afece7c2c 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -112,9 +112,10 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
-#define print_ksft_result(test)\
-	(ksft_test_result_pass("PASS: %s %s\n", configured_mode ? "DRV" : "SKB", \
-			       (test)->name))
+#define mode_string(test) (test)->ifobj_tx->xdp_flags & XDP_FLAGS_SKB_MODE ? "SKB" : "DRV"
+
+#define print_ksft_result(test)						\
+	(ksft_test_result_pass("PASS: %s %s\n", mode_string(test), (test)->name))
 
 static void memset32_htonl(void *dest, u32 val, u32 size)
 {
@@ -275,8 +276,8 @@ static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_inf
 	cfg.rx_size = xsk->rxqsize;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
 	cfg.libbpf_flags = 0;
-	cfg.xdp_flags = xdp_flags;
-	cfg.bind_flags = xdp_bind_flags;
+	cfg.xdp_flags = ifobject->xdp_flags;
+	cfg.bind_flags = ifobject->bind_flags;
 
 	txr = ifobject->tx_on ? &xsk->tx : NULL;
 	rxr = ifobject->rx_on ? &xsk->rx : NULL;
@@ -333,7 +334,8 @@ static bool validate_interface(struct ifobject *ifobj)
 	return true;
 }
 
-static void parse_command_line(struct test_spec *test, int argc, char **argv)
+static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj_rx, int argc,
+			       char **argv)
 {
 	struct ifobject *ifobj;
 	u32 interface_nb = 0;
@@ -351,9 +353,9 @@ static void parse_command_line(struct test_spec *test, int argc, char **argv)
 		switch (c) {
 		case 'i':
 			if (interface_nb == 0)
-				ifobj = test->ifobj_tx;
+				ifobj = ifobj_tx;
 			else if (interface_nb == 1)
-				ifobj = test->ifobj_rx;
+				ifobj = ifobj_rx;
 			else
 				break;
 
@@ -414,9 +416,24 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 }
 
 static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
-			   struct ifobject *ifobj_rx)
+			   struct ifobject *ifobj_rx, enum test_mode mode)
 {
+	u32 i;
+
 	memset(test, 0, sizeof(*test));
+
+	for (i = 0; i < MAX_INTERFACES; i++) {
+		struct ifobject *ifobj = i ? ifobj_rx : ifobj_tx;
+
+		ifobj->xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+		if (mode == TEST_MODE_SKB)
+			ifobj->xdp_flags |= XDP_FLAGS_SKB_MODE;
+		else
+			ifobj->xdp_flags |= XDP_FLAGS_DRV_MODE;
+
+		ifobj->bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
+	}
+
 	__test_spec_init(test, ifobj_tx, ifobj_rx);
 }
 
@@ -1011,27 +1028,13 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
 	ifobj->func_ptr = func_ptr;
 }
 
-static void run_pkt_test(struct test_spec *test, int mode, int type)
+static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
 {
 	test_type = type;
 
 	/* reset defaults after potential previous test */
-	xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 	stat_test_type = -1;
 
-	configured_mode = mode;
-
-	switch (mode) {
-	case (TEST_MODE_SKB):
-		xdp_flags |= XDP_FLAGS_SKB_MODE;
-		break;
-	case (TEST_MODE_DRV):
-		xdp_flags |= XDP_FLAGS_DRV_MODE;
-		break;
-	default:
-		break;
-	}
-
 	switch (test_type) {
 	case TEST_TYPE_STATS:
 		testapp_stats(test);
@@ -1111,11 +1114,9 @@ int main(int argc, char **argv)
 	if (!ifobj_rx)
 		exit_with_error(ENOMEM);
 
-	test_spec_init(&test, ifobj_tx, ifobj_rx);
-
 	setlocale(LC_ALL, "");
 
-	parse_command_line(&test, argc, argv);
+	parse_command_line(ifobj_tx, ifobj_rx, argc, argv);
 
 	if (!validate_interface(ifobj_tx) || !validate_interface(ifobj_rx)) {
 		usage(basename(argv[0]));
@@ -1131,7 +1132,7 @@ int main(int argc, char **argv)
 
 	for (i = 0; i < TEST_MODE_MAX; i++)
 		for (j = 0; j < TEST_TYPE_MAX; j++) {
-			test_spec_init(&test, ifobj_tx, ifobj_rx);
+			test_spec_init(&test, ifobj_tx, ifobj_rx, i);
 			run_pkt_test(&test, i, j);
 			usleep(USLEEP_MAX);
 		}
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index c09b73fd9878..7ed16128f2ad 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -68,14 +68,10 @@ enum stat_test_type {
 	STAT_TEST_TYPE_MAX
 };
 
-static int configured_mode;
 static bool opt_pkt_dump;
 static int test_type;
 
 static bool opt_verbose;
-
-static u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
-static u32 xdp_bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
 static int stat_test_type;
 
 struct xsk_umem_info {
@@ -122,6 +118,8 @@ struct ifobject {
 	int ns_fd;
 	u32 dst_ip;
 	u32 src_ip;
+	u32 xdp_flags;
+	u32 bind_flags;
 	u16 src_port;
 	u16 dst_port;
 	bool tx_on;
-- 
2.29.0


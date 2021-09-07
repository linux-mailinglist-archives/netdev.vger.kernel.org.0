Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AA4402411
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbhIGHVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240215AbhIGHVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:14 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0117C061575;
        Tue,  7 Sep 2021 00:20:08 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q26so11982928wrc.7;
        Tue, 07 Sep 2021 00:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NNBaqyo/7ZhbzjZjrYIN9gMRh6tHWawhWi2LjamABiA=;
        b=NdIobtEOwiA0bJAbZKXsHRIsk2a0PdQIv52cZeZKg/FCqfH6Qg43qhJfloM0FKEZP5
         yQ/K2+y9ZR9wKU/K6LbT52Y7JXhK2LdiYcaR9ZKLsFuK0RvlOvJ+R2rhl8aPHsV1bpWz
         OtexN8c/wQ+fN/5vG75qYjuU6QSPxWyZkls4aITrwY/o2YCH+TpsgBJX+aWqqN49AaY5
         67TuTkgERvroNA7/GQwzL5iOClLNMRpiivKqekcW7r3E9evhyrFEiMIoUOVcSV5v1WUA
         aNxfjMkcPT7lrtMM9TgBvlYcu5XT0uE2HPDSCbBcTgKmUrRulmNgOB6y9aqjEppqzIZL
         VoDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NNBaqyo/7ZhbzjZjrYIN9gMRh6tHWawhWi2LjamABiA=;
        b=aCElKTp7s5xBMckiLdYUZTkdXrIfSdukwEiELBSoGTZzWSY7WfwhVctz/iOFLzFy6y
         f+auRv14PujD6S9Yz+YdwXMU4QnR2PQRhwfo48uE49vvplXNgRUjQD3CAVIm4TuHW9zr
         R+aoSBpnHJRUEI335UGj+DGNYFCgc23hMvW4taoc/GQ2h4XjvlL7J7ppLLwwS//nSneZ
         EaCI1NRSeGyypN3WI1IO+8y2VivzvvTx/e4OIThRa/PPVbV4kQ0ZtmAGbIP+TFDYtkDO
         b9ninwgPhfedpx5xOpoWPAZeFKJxwu6PhcG7PqDJS5/Q+6kG2ci6g8qXczAZZqUFm/HF
         l+8Q==
X-Gm-Message-State: AOAM533C4sOK6u7wcsrYtoOLmTPl8GyK/lb2xGNu8NdaUKO4RoSSlswQ
        2feq/Q2jLA2aqDWgV0g97KOP9NgJD7D1UMGRo8g=
X-Google-Smtp-Source: ABdhPJyKwsfOM28IVaI8aSwVJ/aokFCmT1/KjuQHUAabRWdXCfd5W++RHcaMfFl0HJ/XLqRW3tlKyA==
X-Received: by 2002:a5d:464c:: with SMTP id j12mr17511825wrs.27.1630999207426;
        Tue, 07 Sep 2021 00:20:07 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.20.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:20:07 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 12/20] selftests: xsk: make xdp_flags and bind_flags local
Date:   Tue,  7 Sep 2021 09:19:20 +0200
Message-Id: <20210907071928.9750-13-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
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


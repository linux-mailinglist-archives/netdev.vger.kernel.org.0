Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F47765D26B
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbjADMUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239283AbjADMUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:20:13 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F15395CF;
        Wed,  4 Jan 2023 04:19:07 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id g10so11615653wmo.1;
        Wed, 04 Jan 2023 04:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TJwF2wT8bEE8PI7Jql5/KZVMtCXg8FywH2DjIuGKI0Q=;
        b=jHxDkGa1pO3PjmeWUpNITxQb43J7Jd5bH/GBB+rmxehFxiOR8bXl1NRMeR22QQWxyK
         VEmBurvtciIzs7vw/ucsMW7wlHCNaPa00vboePNGcFb18a7pYFmpieGjXXor27dmNSNN
         st5sz5/Y4W0WE+VodseEzHpv6YgYmgxwnP/ls7Pjke1X6SvmsmG3OiTgWR5mK3R3mcY9
         OAiXSQDix1xF4L9Dv7t7nq1b5SNc7hiAmsN1Kgvejm9rfKrLc7Y/ex2xqO+MDmOlx7LI
         soZtvQa0M1U/TqvNh7yGyujldA0wMpPbjOIKUJLjuxntRMzfpzq/qEwX3qtcSKvgNiET
         BEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TJwF2wT8bEE8PI7Jql5/KZVMtCXg8FywH2DjIuGKI0Q=;
        b=GrgL2e8T57/Fd4a2e5OQQNWkOok7uCMey5Foat5LsYWcyOSAzkBKGZ6cDrB87iyt7b
         P4HHwDVd3D5Jy7KW3K6nVlWFO7OkUZZ5+o1s4m2dizX7MIPq8rXOIkkamfofUqbAO7vn
         OzqPNYvvAnroGUKL1qH8XSHSkb+KH4w/KWcxSozbh+0DjEUscGRFC7VWZWT90HUy9baJ
         L/Z2SzrJk8lBoxixnvyzWf+fy+dyDJduKS/zDb5oWtRdC7QsfLvOL5P5D4Zm3aKmEfXV
         R14IFkA2CG5NKG90J98CGFtDT37rWUEzqUJBT71xrM6dxQHz9wzm9BoSHtgjrqNItzdE
         iESg==
X-Gm-Message-State: AFqh2kpdNJH1zPdCixBdyryTBzZd5gKAJN917MxXc3IXNK/YRRH7mRzX
        doKCf0NMMCiZFNhocF/An7E=
X-Google-Smtp-Source: AMrXdXsiNVsvVSYKUNkTaxR55tIOj/AHM3hPZTBNvGBspkhioj6VV3Rp9vrvHz2GX5b8gcgh7/1vtw==
X-Received: by 2002:a05:600c:2207:b0:3d2:24d2:d02b with SMTP id z7-20020a05600c220700b003d224d2d02bmr34186401wml.29.1672834745729;
        Wed, 04 Jan 2023 04:19:05 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.19.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:19:05 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 15/15] selftests/xsk: automatically switch XDP programs
Date:   Wed,  4 Jan 2023 13:17:44 +0100
Message-Id: <20230104121744.2820-16-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104121744.2820-1-magnus.karlsson@gmail.com>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Implement automatic switching of XDP programs and execution modes if
needed by a test. This makes it much simpler to write a test as it
only has to say what XDP program it needs if it is not the default
one. This also makes it possible to remove the initial explicit
attachment of the XDP program as well as the explicit mode switch in
the code. These are now handled by the same code that just checks if a
switch is necessary, so no special cases are needed.

The default XDP program for all tests is one that sends all packets to
the AF_XDP socket. If you need another one, please use the new
function test_spec_set_xdp_prog() to specify what XDP programs and
maps to use for this test.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xsk.c        |  14 +++
 tools/testing/selftests/bpf/xsk.h        |   1 +
 tools/testing/selftests/bpf/xskxceiver.c | 137 ++++++++++++-----------
 tools/testing/selftests/bpf/xskxceiver.h |   7 +-
 4 files changed, 91 insertions(+), 68 deletions(-)

diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index dc6b47280ec4..d9d44a29c7cc 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -267,6 +267,20 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area,
 	return err;
 }
 
+bool xsk_is_in_drv_mode(u32 ifindex)
+{
+	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
+	int ret;
+
+	ret = bpf_xdp_query(ifindex, XDP_FLAGS_DRV_MODE, &opts);
+	if (ret) {
+		printf("DRV mode query returned error %s\n", strerror(errno));
+		return false;
+	}
+
+	return opts.attach_mode == XDP_ATTACHED_DRV;
+}
+
 int xsk_attach_xdp_program(struct bpf_program *prog, int ifindex, u32 xdp_flags)
 {
 	int prog_fd;
diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
index 5624d31b8db7..3cb9d69589b8 100644
--- a/tools/testing/selftests/bpf/xsk.h
+++ b/tools/testing/selftests/bpf/xsk.h
@@ -201,6 +201,7 @@ int xsk_attach_xdp_program(struct bpf_program *prog, int ifindex, u32 xdp_flags)
 void xsk_detach_xdp_program(int ifindex, u32 xdp_flags);
 int xsk_update_xskmap(struct bpf_map *map, struct xsk_socket *xsk);
 void xsk_clear_xskmap(struct bpf_map *map);
+bool xsk_is_in_drv_mode(u32 ifindex);
 
 struct xsk_socket_config {
 	__u32 rx_size;
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 66863504c76a..9af0f8240a59 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -96,6 +96,8 @@
 #include <time.h>
 #include <unistd.h>
 #include <stdatomic.h>
+
+#include "xsk_xdp_progs.skel.h"
 #include "xsk.h"
 #include "xskxceiver.h"
 #include <bpf/bpf.h>
@@ -356,7 +358,6 @@ static bool ifobj_zc_avail(struct ifobject *ifobject)
 	xsk = calloc(1, sizeof(struct xsk_socket_info));
 	if (!xsk)
 		goto out;
-	ifobject->xdp_flags = XDP_FLAGS_DRV_MODE;
 	ifobject->bind_flags = XDP_USE_NEED_WAKEUP | XDP_ZEROCOPY;
 	ifobject->rx_on = true;
 	xsk->rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
@@ -493,6 +494,10 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 	test->total_steps = 1;
 	test->nb_sockets = 1;
 	test->fail = false;
+	test->xdp_prog_rx = ifobj_rx->xdp_progs->progs.xsk_def_prog;
+	test->xskmap_rx = ifobj_rx->xdp_progs->maps.xsk;
+	test->xdp_prog_tx = ifobj_tx->xdp_progs->progs.xsk_def_prog;
+	test->xskmap_tx = ifobj_tx->xdp_progs->maps.xsk;
 }
 
 static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
@@ -532,6 +537,16 @@ static void test_spec_set_name(struct test_spec *test, const char *name)
 	strncpy(test->name, name, MAX_TEST_NAME_SIZE);
 }
 
+static void test_spec_set_xdp_prog(struct test_spec *test, struct bpf_program *xdp_prog_rx,
+				   struct bpf_program *xdp_prog_tx, struct bpf_map *xskmap_rx,
+				   struct bpf_map *xskmap_tx)
+{
+	test->xdp_prog_rx = xdp_prog_rx;
+	test->xdp_prog_tx = xdp_prog_tx;
+	test->xskmap_rx = xskmap_rx;
+	test->xskmap_tx = xskmap_tx;
+}
+
 static void pkt_stream_reset(struct pkt_stream *pkt_stream)
 {
 	if (pkt_stream)
@@ -1356,6 +1371,47 @@ static void handler(int signum)
 	pthread_exit(NULL);
 }
 
+static bool xdp_prog_changed(struct test_spec *test, struct ifobject *ifobj)
+{
+	return ifobj->xdp_prog != test->xdp_prog_rx || ifobj->mode != test->mode;
+}
+
+static void xsk_reattach_xdp(struct ifobject *ifobj, struct bpf_program *xdp_prog,
+			     struct bpf_map *xskmap, enum test_mode mode)
+{
+	int err;
+
+	xsk_detach_xdp_program(ifobj->ifindex, mode_to_xdp_flags(ifobj->mode));
+	err = xsk_attach_xdp_program(xdp_prog, ifobj->ifindex, mode_to_xdp_flags(mode));
+	if (err) {
+		printf("Error attaching XDP program\n");
+		exit_with_error(-err);
+	}
+
+	if (ifobj->mode != mode && (mode == TEST_MODE_DRV || mode == TEST_MODE_ZC))
+		if (!xsk_is_in_drv_mode(ifobj->ifindex)) {
+			ksft_print_msg("ERROR: XDP prog not in DRV mode\n");
+			exit_with_error(EINVAL);
+		}
+
+	ifobj->xdp_prog = xdp_prog;
+	ifobj->xskmap = xskmap;
+	ifobj->mode = mode;
+}
+
+static void xsk_attach_xdp_progs(struct test_spec *test, struct ifobject *ifobj_rx,
+				 struct ifobject *ifobj_tx)
+{
+	if (xdp_prog_changed(test, ifobj_rx))
+		xsk_reattach_xdp(ifobj_rx, test->xdp_prog_rx, test->xskmap_rx, test->mode);
+
+	if (!ifobj_tx || ifobj_tx->shared_umem)
+		return;
+
+	if (xdp_prog_changed(test, ifobj_tx))
+		xsk_reattach_xdp(ifobj_tx, test->xdp_prog_tx, test->xskmap_tx, test->mode);
+}
+
 static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *ifobj1,
 				      struct ifobject *ifobj2)
 {
@@ -1403,7 +1459,11 @@ static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *i
 
 static int testapp_validate_traffic(struct test_spec *test)
 {
-	return __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
+	struct ifobject *ifobj_rx = test->ifobj_rx;
+	struct ifobject *ifobj_tx = test->ifobj_tx;
+
+	xsk_attach_xdp_progs(test, ifobj_rx, ifobj_tx);
+	return __testapp_validate_traffic(test, ifobj_rx, ifobj_tx);
 }
 
 static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj)
@@ -1446,7 +1506,7 @@ static void testapp_bidi(struct test_spec *test)
 
 	print_verbose("Switching Tx/Rx vectors\n");
 	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
-	testapp_validate_traffic(test);
+	__testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
 
 	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
 }
@@ -1615,29 +1675,15 @@ static void testapp_invalid_desc(struct test_spec *test)
 
 static void testapp_xdp_drop(struct test_spec *test)
 {
-	struct ifobject *ifobj = test->ifobj_rx;
-	int err;
+	struct xsk_xdp_progs *skel_rx = test->ifobj_rx->xdp_progs;
+	struct xsk_xdp_progs *skel_tx = test->ifobj_tx->xdp_progs;
 
 	test_spec_set_name(test, "XDP_DROP_HALF");
-	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
-	err = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_xdp_drop, ifobj->ifindex,
-				     ifobj->xdp_flags);
-	if (err) {
-		printf("Error attaching XDP_DROP program\n");
-		test->fail = true;
-		return;
-	}
+	test_spec_set_xdp_prog(test, skel_rx->progs.xsk_xdp_drop, skel_tx->progs.xsk_xdp_drop,
+			       skel_rx->maps.xsk, skel_tx->maps.xsk);
 
 	pkt_stream_receive_half(test);
 	testapp_validate_traffic(test);
-
-	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
-	err = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_def_prog, ifobj->ifindex,
-				     ifobj->xdp_flags);
-	if (err) {
-		printf("Error restoring default XDP program\n");
-		exit_with_error(-err);
-	}
 }
 
 static void testapp_poll_txq_tmout(struct test_spec *test)
@@ -1674,7 +1720,7 @@ static void xsk_unload_xdp_programs(struct ifobject *ifobj)
 
 static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
 		       const char *dst_ip, const char *src_ip, const u16 dst_port,
-		       const u16 src_port, thread_func_t func_ptr, bool load_xdp)
+		       const u16 src_port, thread_func_t func_ptr)
 {
 	struct in_addr ip;
 	int err;
@@ -1693,23 +1739,11 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
 
 	ifobj->func_ptr = func_ptr;
 
-	if (!load_xdp)
-		return;
-
 	err = xsk_load_xdp_programs(ifobj);
 	if (err) {
 		printf("Error loading XDP program\n");
 		exit_with_error(err);
 	}
-
-	ifobj->xdp_flags = mode_to_xdp_flags(TEST_MODE_SKB);
-	err = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_def_prog, ifobj->ifindex,
-				     ifobj->xdp_flags);
-	if (err) {
-		printf("Error attaching XDP program\n");
-		exit_with_error(-err);
-	}
-	ifobj->xskmap = ifobj->xdp_progs->maps.xsk;
 }
 
 static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
@@ -1871,31 +1905,6 @@ static bool is_xdp_supported(int ifindex)
 	return true;
 }
 
-static void change_to_drv_mode(struct ifobject *ifobj)
-{
-	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
-	int ret;
-
-	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
-	ifobj->xdp_flags = XDP_FLAGS_DRV_MODE;
-	ret = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_def_prog, ifobj->ifindex,
-				     ifobj->xdp_flags);
-	if (ret) {
-		ksft_print_msg("Error attaching XDP program\n");
-		exit_with_error(-ret);
-	}
-	ifobj->xskmap = ifobj->xdp_progs->maps.xsk;
-
-	ret = bpf_xdp_query(ifobj->ifindex, XDP_FLAGS_DRV_MODE, &opts);
-	if (ret)
-		exit_with_error(errno);
-
-	if (opts.attach_mode != XDP_ATTACHED_DRV) {
-		ksft_print_msg("ERROR: XDP prog not in DRV mode\n");
-		exit_with_error(EINVAL);
-	}
-}
-
 int main(int argc, char **argv)
 {
 	struct pkt_stream *rx_pkt_stream_default;
@@ -1936,9 +1945,9 @@ int main(int argc, char **argv)
 	}
 
 	init_iface(ifobj_rx, MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2,
-		   worker_testapp_validate_rx, true);
+		   worker_testapp_validate_rx);
 	init_iface(ifobj_tx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
-		   worker_testapp_validate_tx, !shared_netdev);
+		   worker_testapp_validate_tx);
 
 	test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
 	tx_pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
@@ -1951,12 +1960,6 @@ int main(int argc, char **argv)
 	ksft_set_plan(modes * TEST_TYPE_MAX);
 
 	for (i = 0; i < modes; i++) {
-		if (i == TEST_MODE_DRV) {
-			change_to_drv_mode(ifobj_rx);
-			if (!shared_netdev)
-				change_to_drv_mode(ifobj_tx);
-		}
-
 		for (j = 0; j < TEST_TYPE_MAX; j++) {
 			test_spec_init(&test, ifobj_tx, ifobj_rx, i);
 			run_pkt_test(&test, i, j);
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index a4daa5134fc0..3e8ec7d8ec32 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -143,10 +143,11 @@ struct ifobject {
 	struct pkt_stream *pkt_stream;
 	struct xsk_xdp_progs *xdp_progs;
 	struct bpf_map *xskmap;
+	struct bpf_program *xdp_prog;
+	enum test_mode mode;
 	int ifindex;
 	u32 dst_ip;
 	u32 src_ip;
-	u32 xdp_flags;
 	u32 bind_flags;
 	u16 src_port;
 	u16 dst_port;
@@ -166,6 +167,10 @@ struct test_spec {
 	struct ifobject *ifobj_rx;
 	struct pkt_stream *tx_pkt_stream_default;
 	struct pkt_stream *rx_pkt_stream_default;
+	struct bpf_program *xdp_prog_rx;
+	struct bpf_program *xdp_prog_tx;
+	struct bpf_map *xskmap_rx;
+	struct bpf_map *xskmap_tx;
 	u16 total_steps;
 	u16 current_step;
 	u16 nb_sockets;
-- 
2.34.1


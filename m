Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC87F643F77
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiLFJKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbiLFJJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:46 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0204E1F2FC;
        Tue,  6 Dec 2022 01:09:34 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id q7so22521801wrr.8;
        Tue, 06 Dec 2022 01:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPCGJrkm1uEr7buMlDbCqp90dnNiehBtko04AUrHRmk=;
        b=MU2wPegodBByb5eFZZltNOby6hDnqC91yV0EDerBUBHEQCVKXT12tg/FSzAjsF5KJ+
         lpTuNypmAVNof7UxRzHuevUCq5U31tvugaWJpnB7ZFwu4QP6gpdtE4tbtUhkWUEbMvnv
         bGfZvWGcYVHwNP0hW2+noabfaxFatWqUheURQhTew6ESL3v+JfY85CappGoqQ42jmpTQ
         UjOpxNEnj3H+edGFAE/pnaSWocTNV+8Gy0JzkCpLgU0SX1FXcIEMhkbAtg2bcTJjLznp
         J1EuhrgW06g8OtHbVQ4cw06SYh3D3my3p3Kr1gbCQdCH3xjmu7SNRfXSX80CbLotuoHr
         QevQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OPCGJrkm1uEr7buMlDbCqp90dnNiehBtko04AUrHRmk=;
        b=3j+UH7lBcstHeeLh++QOvRgGyTDKyGH5igwRiNodxU0g8cor2NE0ZEoSMKKJOTHAvV
         eFo7MHweBRaluLRRx/F4ecdXtmzEUXYys/nxgrblCrZuNsn1Y5mcYsA0GBfbUjV5hbcx
         Ec3rFujj+BsZYzkCizM9tbOWk0YuIoESzuouE71xYTP2XUZkoWHUASFrmJKA32KVKYFX
         tJqj1j9C80GOPbM1mRAekJnrSQ4KtUphq94QX6QQNqcFOwDmKWdBSX7NNiUS6ztIfOnq
         P9HQgm08TH4i3Uq4f0nilG+jdeTaXCufVol1Ofn1G+I5AGi2wdBPxNpzWZlxRHx/L0yH
         BIXg==
X-Gm-Message-State: ANoB5pk1B4zw+1yo9zWAPySvzWw7Pg1c3mvd/XufmKU3W7yAdvM/ig5t
        EN21G1wYuP8pacqn8zYxKaU=
X-Google-Smtp-Source: AA0mqf7kYg0TatoFvn3UBsgBkINlSl4Vbjk20maT1sR2V7GJ1TVdW0bMoHrXGfWqucth9uSWRxgjCA==
X-Received: by 2002:a5d:4143:0:b0:242:1551:9759 with SMTP id c3-20020a5d4143000000b0024215519759mr24773436wrq.476.1670317772251;
        Tue, 06 Dec 2022 01:09:32 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.09.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:09:31 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 15/15] selftests/xsk: automatically switch XDP programs
Date:   Tue,  6 Dec 2022 10:08:26 +0100
Message-Id: <20221206090826.2957-16-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206090826.2957-1-magnus.karlsson@gmail.com>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
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
 tools/testing/selftests/bpf/xskxceiver.c | 150 ++++++++++++-----------
 tools/testing/selftests/bpf/xskxceiver.h |   7 +-
 4 files changed, 102 insertions(+), 70 deletions(-)

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
index 26cd64d4209f..ae9370f7145e 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -96,6 +96,9 @@
 #include <time.h>
 #include <unistd.h>
 #include <stdatomic.h>
+
+#include "xsk_def_prog.skel.h"
+#include "xsk_xdp_drop.skel.h"
 #include "xsk.h"
 #include "xskxceiver.h"
 #include <bpf/bpf.h>
@@ -362,7 +365,6 @@ static bool ifobj_zc_avail(struct ifobject *ifobject)
 	xsk = calloc(1, sizeof(struct xsk_socket_info));
 	if (!xsk)
 		goto out;
-	ifobject->xdp_flags = XDP_FLAGS_DRV_MODE;
 	ifobject->bind_flags = XDP_USE_NEED_WAKEUP | XDP_ZEROCOPY;
 	ifobject->rx_on = true;
 	xsk->rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
@@ -501,6 +503,10 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 	test->total_steps = 1;
 	test->nb_sockets = 1;
 	test->fail = false;
+	test->xdp_prog_rx = ifobj_rx->def_prog->progs.xsk_def_prog;
+	test->xskmap_rx = ifobj_rx->def_prog->maps.xsk;
+	test->xdp_prog_tx = ifobj_tx->def_prog->progs.xsk_def_prog;
+	test->xskmap_tx = ifobj_tx->def_prog->maps.xsk;
 }
 
 static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
@@ -540,6 +546,16 @@ static void test_spec_set_name(struct test_spec *test, const char *name)
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
@@ -1364,6 +1380,57 @@ static void handler(int signum)
 	pthread_exit(NULL);
 }
 
+static bool xdp_prog_changed(struct test_spec *test, struct ifobject *ifobj)
+{
+	return ifobj->xdp_prog != test->xdp_prog_rx || ifobj->mode != test->mode;
+}
+
+static void xsk_attach_xdp_progs(struct test_spec *test, struct ifobject *ifobj_rx,
+				 struct ifobject *ifobj_tx)
+{
+	int err;
+
+	if (xdp_prog_changed(test, ifobj_rx)) {
+		xsk_detach_xdp_program(ifobj_rx->ifindex, mode_to_xdp_flags(ifobj_rx->mode));
+		err = xsk_attach_xdp_program(test->xdp_prog_rx, ifobj_rx->ifindex,
+					     mode_to_xdp_flags(test->mode));
+		if (err) {
+			printf("Error attaching XDP program\n");
+			exit_with_error(-err);
+		}
+
+		if (ifobj_rx->mode != test->mode && test->mode == TEST_MODE_DRV)
+			if (!xsk_is_in_drv_mode(ifobj_rx->ifindex)) {
+				ksft_print_msg("ERROR: XDP prog not in DRV mode\n");
+				exit_with_error(EINVAL);
+			}
+
+		ifobj_rx->xdp_prog = test->xdp_prog_rx;
+		ifobj_rx->xskmap = test->xskmap_rx;
+		ifobj_rx->mode = test->mode;
+	}
+
+	if (ifobj_tx && !ifobj_tx->shared_umem && xdp_prog_changed(test, ifobj_tx)) {
+		xsk_detach_xdp_program(ifobj_tx->ifindex, mode_to_xdp_flags(ifobj_tx->mode));
+		err = xsk_attach_xdp_program(test->xdp_prog_tx, ifobj_tx->ifindex,
+					     mode_to_xdp_flags(test->mode));
+		if (err) {
+			printf("Error attaching XDP program\n");
+			exit_with_error(-err);
+		}
+
+		if (ifobj_rx->mode != test->mode && test->mode == TEST_MODE_DRV)
+			if (!xsk_is_in_drv_mode(ifobj_tx->ifindex)) {
+				ksft_print_msg("ERROR: XDP prog not in DRV mode\n");
+				exit_with_error(EINVAL);
+			}
+
+		ifobj_tx->xdp_prog = test->xdp_prog_tx;
+		ifobj_tx->xskmap = test->xskmap_tx;
+		ifobj_tx->mode = test->mode;
+	}
+}
+
 static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *ifobj_rx,
 				      struct ifobject *ifobj_tx)
 {
@@ -1411,7 +1478,11 @@ static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *i
 
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
@@ -1454,7 +1525,7 @@ static void testapp_bidi(struct test_spec *test)
 
 	print_verbose("Switching Tx/Rx vectors\n");
 	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
-	testapp_validate_traffic(test);
+	__testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
 
 	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
 }
@@ -1623,31 +1694,15 @@ static void testapp_invalid_desc(struct test_spec *test)
 
 static void testapp_xdp_drop(struct test_spec *test)
 {
-	struct ifobject *ifobj = test->ifobj_rx;
-	int err;
+	struct xsk_xdp_drop *skel_rx = test->ifobj_rx->xdp_drop;
+	struct xsk_xdp_drop *skel_tx = test->ifobj_tx->xdp_drop;
 
 	test_spec_set_name(test, "XDP_CONSUMES_SOME_PACKETS");
-	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
-	err = xsk_attach_xdp_program(ifobj->xdp_drop->progs.xsk_xdp_drop, ifobj->ifindex,
-				     ifobj->xdp_flags);
-	if (err) {
-		printf("Error attaching XDP_DROP program\n");
-		test->fail = true;
-		return;
-	}
-	ifobj->xskmap = ifobj->xdp_drop->maps.xsk;
+	test_spec_set_xdp_prog(test, skel_rx->progs.xsk_xdp_drop, skel_tx->progs.xsk_xdp_drop,
+			       skel_rx->maps.xsk, skel_tx->maps.xsk);
 
 	pkt_stream_receive_half(test);
 	testapp_validate_traffic(test);
-
-	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
-	err = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
-				     ifobj->xdp_flags);
-	if (err) {
-		printf("Error restoring default XDP program\n");
-		exit_with_error(-err);
-	}
-	ifobj->xskmap = ifobj->def_prog->maps.xsk;
 }
 
 static void testapp_poll_txq_tmout(struct test_spec *test)
@@ -1689,7 +1744,7 @@ static void xsk_unload_xdp_programs(struct ifobject *ifobj)
 
 static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
 		       const char *dst_ip, const char *src_ip, const u16 dst_port,
-		       const u16 src_port, thread_func_t func_ptr, bool load_xdp)
+		       const u16 src_port, thread_func_t func_ptr)
 {
 	struct in_addr ip;
 	int err;
@@ -1708,23 +1763,11 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
 
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
-	err = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
-				     ifobj->xdp_flags);
-	if (err) {
-		printf("Error attaching XDP program\n");
-		exit_with_error(-err);
-	}
-	ifobj->xskmap = ifobj->def_prog->maps.xsk;
 }
 
 static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
@@ -1886,31 +1929,6 @@ static bool is_xdp_supported(int ifindex)
 	return true;
 }
 
-static void change_to_drv_mode(struct ifobject *ifobj)
-{
-	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
-	int ret;
-
-	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
-	ifobj->xdp_flags = XDP_FLAGS_DRV_MODE;
-	ret = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
-				     ifobj->xdp_flags);
-	if (ret) {
-		printf("Error attaching XDP program\n");
-		exit_with_error(-ret);
-	}
-	ifobj->xskmap = ifobj->def_prog->maps.xsk;
-
-	ret = bpf_xdp_query(ifobj->ifindex, XDP_FLAGS_DRV_MODE, &opts);
-	if (ret)
-		exit_with_error(errno);
-
-	if (opts.attach_mode != XDP_ATTACHED_DRV) {
-		ksft_print_msg("ERROR: [%s] XDP prog not in DRV mode\n");
-		exit_with_error(EINVAL);
-	}
-}
-
 int main(int argc, char **argv)
 {
 	struct pkt_stream *rx_pkt_stream_default;
@@ -1951,9 +1969,9 @@ int main(int argc, char **argv)
 	}
 
 	init_iface(ifobj_rx, MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2,
-		   worker_testapp_validate_rx, true);
+		   worker_testapp_validate_rx);
 	init_iface(ifobj_tx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
-		   worker_testapp_validate_tx, !shared_netdev);
+		   worker_testapp_validate_tx);
 
 	test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
 	tx_pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
@@ -1966,12 +1984,6 @@ int main(int argc, char **argv)
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
index 3483ac240b2e..5c66908577ef 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -145,10 +145,11 @@ struct ifobject {
 	struct xsk_def_prog *def_prog;
 	struct xsk_xdp_drop *xdp_drop;
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
@@ -168,6 +169,10 @@ struct test_spec {
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


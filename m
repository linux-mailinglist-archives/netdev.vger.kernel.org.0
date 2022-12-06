Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727F6643F6F
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbiLFJJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbiLFJJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:27 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD31F1EEC7;
        Tue,  6 Dec 2022 01:09:23 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so631772wms.2;
        Tue, 06 Dec 2022 01:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cO2BNe9Oh8S2UiCN8//zi5X+IV1rt7JxKLo2UXSfEBY=;
        b=bqqc3eBS5M4+q8nKXg8ybXy2fq534j+1A0X7nqGF5Xw0pmWLiO6XlzrGlyoQ2TQ+SZ
         Age1FJlGmYoM0Mb6ZfJyKRf7VmON9zTWHbrNIwxmiSp8vSMu2xVhFfyER6gog9aWrVgZ
         of0mFmHB5kMCstI3gQTYjO23nZvd1r5MKo1nin3Ud271orMCZVu6YY9NXI9PSr6UG19W
         8CG4K6drh1g7DOfyLl+PzHp+bIY6tLlj4O9DBzInlo5PFsP2OchqesL4ZF4A8gg4Zx68
         5dIR9VN0PTAnSDO+zVyrQY5P6lIgYqQSvhixAMKJnKHGg4WkWdMt4Scteb93SOLkxX3W
         OyIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cO2BNe9Oh8S2UiCN8//zi5X+IV1rt7JxKLo2UXSfEBY=;
        b=NnqJZF2DNjRWXc9ZevkhzVAH+Z6d+udp9WObnAxV3LDnddvxhQdAkH5crrAe3J3fnY
         fScrxJuq+plwBHP3whKoeGn8bImgK5oXR5hR+xj702d4ER9AruSrJKuw/ZpSyp9PDdM4
         CS3peq+E1GuxyqIVe0KcakM3ca3ls16Hn+WkxlpQfUkVJF2H7x+E3+JuBeCQ2VTroku1
         S2JjqZdxmeWIhtC7FfQjARikkQBh5TiyoftQ0LuckT85kXtMWCtQRsYPjztzDfvJXumY
         nA2fJh99zoDbnHU5bDY7em7NkkOGCEVTmgr2vwAPS4ZBYPqnOWKIARQUr1jxr7ip62D3
         Ue/g==
X-Gm-Message-State: ANoB5plTS4ej+6cC8pwc7PMfjs9z+AMpd/p+BrD+4VU3PCp+bgz1z7XT
        ZL2sm4KpVN6ygoPVjHgJLgQ=
X-Google-Smtp-Source: AA0mqf6nDlw/VaOTMGudr7G3nbXgScjEvP83uauPK7XUyWJpws61WvRuilqhAC7XCFdOc7bopTV1sQ==
X-Received: by 2002:a05:600c:a11:b0:3cf:8b53:747f with SMTP id z17-20020a05600c0a1100b003cf8b53747fmr51020761wmp.192.1670317762244;
        Tue, 06 Dec 2022 01:09:22 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.09.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:09:21 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 11/15] selftests/xsk: get rid of built-in XDP program
Date:   Tue,  6 Dec 2022 10:08:22 +0100
Message-Id: <20221206090826.2957-12-magnus.karlsson@gmail.com>
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

Get rid of the built-in XDP program that was part of the old libbpf
code in xsk.c and replace it with an eBPF program build using the
framework by all the other bpf selftests. This will form the base for
adding more programs in later commits.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/Makefile          |  2 +-
 .../selftests/bpf/progs/xsk_def_prog.c        | 19 ++++
 tools/testing/selftests/bpf/xsk.c             | 88 ++++---------------
 tools/testing/selftests/bpf/xsk.h             |  6 +-
 tools/testing/selftests/bpf/xskxceiver.c      | 72 ++++++++-------
 tools/testing/selftests/bpf/xskxceiver.h      |  7 +-
 6 files changed, 88 insertions(+), 106 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xsk_def_prog.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 6a0f043dc410..42e15b5a34a7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -240,7 +240,7 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
 $(OUTPUT)/test_maps: $(TESTING_HELPERS)
 $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
 $(OUTPUT)/xsk.o: $(BPFOBJ)
-$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
+$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_def_prog.skel.h
 
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
diff --git a/tools/testing/selftests/bpf/progs/xsk_def_prog.c b/tools/testing/selftests/bpf/progs/xsk_def_prog.c
new file mode 100644
index 000000000000..698176882ac6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xsk_def_prog.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Intel */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_XSKMAP);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+} xsk SEC(".maps");
+
+SEC("xdp") int xsk_def_prog(struct xdp_md *xdp)
+{
+	return bpf_redirect_map(&xsk, 0, XDP_DROP);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index 9ed31d280e48..dc6b47280ec4 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -267,87 +267,37 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area,
 	return err;
 }
 
-static int __xsk_load_xdp_prog(int xsk_map_fd)
+int xsk_attach_xdp_program(struct bpf_program *prog, int ifindex, u32 xdp_flags)
 {
-	static const int log_buf_size = 16 * 1024;
-	char log_buf[log_buf_size];
 	int prog_fd;
 
-	/* This is the post-5.3 kernel C-program:
-	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
-	 * {
-	 *     return bpf_redirect_map(&xsks_map, ctx->rx_queue_index, XDP_PASS);
-	 * }
-	 */
-	struct bpf_insn prog[] = {
-		/* r2 = *(u32 *)(r1 + 16) */
-		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 16),
-		/* r1 = xskmap[] */
-		BPF_LD_MAP_FD(BPF_REG_1, xsk_map_fd),
-		/* r3 = XDP_PASS */
-		BPF_MOV64_IMM(BPF_REG_3, 2),
-		/* call bpf_redirect_map */
-		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
-		BPF_EXIT_INSN(),
-	};
-	size_t insns_cnt = ARRAY_SIZE(prog);
-	LIBBPF_OPTS(bpf_prog_load_opts, opts,
-		.log_buf = log_buf,
-		.log_size = log_buf_size,
-	);
-
-	prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "LGPL-2.1 or BSD-2-Clause",
-				prog, insns_cnt, &opts);
-	if (prog_fd < 0)
-		pr_warn("BPF log buffer:\n%s", log_buf);
-
-	return prog_fd;
+	prog_fd = bpf_program__fd(prog);
+	return bpf_xdp_attach(ifindex, prog_fd, xdp_flags, NULL);
 }
 
-int xsk_attach_xdp_program(int ifindex, int prog_fd, u32 xdp_flags)
+void xsk_detach_xdp_program(int ifindex, u32 xdp_flags)
 {
-	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
-	__u32 prog_id = 0;
-	int link_fd;
-	int err;
-
-	err = bpf_xdp_query_id(ifindex, xdp_flags, &prog_id);
-	if (err) {
-		pr_warn("getting XDP prog id failed\n");
-		return err;
-	}
-
-	/* If there's a netlink-based XDP prog loaded on interface, bail out
-	 * and ask user to do the removal by himself
-	 */
-	if (prog_id) {
-		pr_warn("Netlink-based XDP prog detected, please unload it in order to launch AF_XDP prog\n");
-		return -EINVAL;
-	}
-
-	opts.flags = xdp_flags & ~(XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_REPLACE);
+	bpf_xdp_detach(ifindex, xdp_flags, NULL);
+}
 
-	link_fd = bpf_link_create(prog_fd, ifindex, BPF_XDP, &opts);
-	if (link_fd < 0)
-		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
+void xsk_clear_xskmap(struct bpf_map *map)
+{
+	u32 index = 0;
+	int map_fd;
 
-	return link_fd;
+	map_fd = bpf_map__fd(map);
+	bpf_map_delete_elem(map_fd, &index);
 }
 
-int xsk_load_xdp_program(int *xsk_map_fd, int *prog_fd)
+int xsk_update_xskmap(struct bpf_map *map, struct xsk_socket *xsk)
 {
-	*xsk_map_fd = bpf_map_create(BPF_MAP_TYPE_XSKMAP, "xsks_map", sizeof(int), sizeof(int),
-				     XSKMAP_SIZE, NULL);
-	if (*xsk_map_fd < 0)
-		return *xsk_map_fd;
-
-	*prog_fd = __xsk_load_xdp_prog(*xsk_map_fd);
-	if (*prog_fd < 0) {
-		close(*xsk_map_fd);
-		return *prog_fd;
-	}
+	int map_fd, sock_fd;
+	u32 index = 0;
 
-	return 0;
+	map_fd = bpf_map__fd(map);
+	sock_fd = xsk_socket__fd(xsk);
+
+	return bpf_map_update_elem(map_fd, &index, &sock_fd, 0);
 }
 
 static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
index bd5b55ad9f8a..5624d31b8db7 100644
--- a/tools/testing/selftests/bpf/xsk.h
+++ b/tools/testing/selftests/bpf/xsk.h
@@ -197,8 +197,10 @@ struct xsk_umem_config {
 	__u32 flags;
 };
 
-int xsk_load_xdp_program(int *xsk_map_fd, int *prog_fd);
-int xsk_attach_xdp_program(int ifindex, int prog_fd, u32 xdp_flags);
+int xsk_attach_xdp_program(struct bpf_program *prog, int ifindex, u32 xdp_flags);
+void xsk_detach_xdp_program(int ifindex, u32 xdp_flags);
+int xsk_update_xskmap(struct bpf_map *map, struct xsk_socket *xsk);
+void xsk_clear_xskmap(struct bpf_map *map);
 
 struct xsk_socket_config {
 	__u32 rx_size;
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 81b0a3ca05a6..0cda4e3f1871 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1215,7 +1215,7 @@ static void thread_common_ops_tx(struct test_spec *test, struct ifobject *ifobje
 {
 	xsk_configure_socket(test, ifobject, test->ifobj_rx->umem, true);
 	ifobject->xsk = &ifobject->xsk_arr[0];
-	ifobject->xsk_map_fd = test->ifobj_rx->xsk_map_fd;
+	ifobject->xskmap = test->ifobj_rx->xskmap;
 	memcpy(ifobject->umem, test->ifobj_rx->umem, sizeof(struct xsk_umem_info));
 }
 
@@ -1255,9 +1255,8 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
 	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
 	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
-	u32 queue_id = 0;
-	int ret, fd;
 	void *bufs;
+	int ret;
 
 	if (ifobject->umem->unaligned_mode)
 		mmap_flags |= MAP_HUGETLB;
@@ -1282,8 +1281,7 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (!ifobject->rx_on)
 		return;
 
-	fd = xsk_socket__fd(ifobject->xsk->xsk);
-	ret = bpf_map_update_elem(ifobject->xsk_map_fd, &queue_id, &fd, 0);
+	ret = xsk_update_xskmap(ifobject->xskmap, ifobject->xsk->xsk);
 	if (ret)
 		exit_with_error(errno);
 }
@@ -1317,18 +1315,17 @@ static void *worker_testapp_validate_rx(void *arg)
 {
 	struct test_spec *test = (struct test_spec *)arg;
 	struct ifobject *ifobject = test->ifobj_rx;
-	int id = 0, err, fd = xsk_socket__fd(ifobject->xsk->xsk);
 	struct pollfd fds = { };
-	u32 queue_id = 0;
+	int err;
 
 	if (test->current_step == 1) {
 		thread_common_ops(test, ifobject);
 	} else {
-		bpf_map_delete_elem(ifobject->xsk_map_fd, &id);
-		err = bpf_map_update_elem(ifobject->xsk_map_fd, &queue_id, &fd, 0);
+		xsk_clear_xskmap(ifobject->xskmap);
+		err = xsk_update_xskmap(ifobject->xskmap, ifobject->xsk->xsk);
 		if (err) {
-			printf("Error: Failed to update xskmap, error %s\n", strerror(err));
-			exit_with_error(err);
+			printf("Error: Failed to update xskmap, error %s\n", strerror(-err));
+			exit_with_error(-err);
 		}
 	}
 
@@ -1398,10 +1395,8 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
 	pthread_join(t0, NULL);
 
 	if (test->total_steps == test->current_step || test->fail) {
-		u32 queue_id = 0;
-
 		xsk_socket__delete(ifobj->xsk->xsk);
-		bpf_map_delete_elem(ifobj->xsk_map_fd, &queue_id);
+		xsk_clear_xskmap(ifobj->xskmap);
 		testapp_clean_xsk_umem(ifobj);
 	}
 
@@ -1490,14 +1485,14 @@ static void testapp_bidi(struct test_spec *test)
 
 static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj_rx)
 {
-	int ret, queue_id = 0, fd = xsk_socket__fd(ifobj_rx->xsk->xsk);
+	int ret;
 
 	xsk_socket__delete(ifobj_tx->xsk->xsk);
 	xsk_socket__delete(ifobj_rx->xsk->xsk);
 	ifobj_tx->xsk = &ifobj_tx->xsk_arr[1];
 	ifobj_rx->xsk = &ifobj_rx->xsk_arr[1];
 
-	ret = bpf_map_update_elem(ifobj_rx->xsk_map_fd, &queue_id, &fd, 0);
+	ret = xsk_update_xskmap(ifobj_rx->xskmap, ifobj_rx->xsk->xsk);
 	if (ret)
 		exit_with_error(errno);
 }
@@ -1659,12 +1654,26 @@ static void testapp_invalid_desc(struct test_spec *test)
 	pkt_stream_restore_default(test);
 }
 
+static int xsk_load_xdp_program(struct ifobject *ifobj)
+{
+	ifobj->def_prog = xsk_def_prog__open_and_load();
+	if (libbpf_get_error(ifobj->def_prog))
+		return libbpf_get_error(ifobj->def_prog);
+
+	return 0;
+}
+
+static void xsk_unload_xdp_program(struct ifobject *ifobj)
+{
+	xsk_def_prog__destroy(ifobj->def_prog);
+}
+
 static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
 		       const char *dst_ip, const char *src_ip, const u16 dst_port,
 		       const u16 src_port, thread_func_t func_ptr, bool load_xdp)
 {
-	int xsk_map_fd, prog_fd, err;
 	struct in_addr ip;
+	int err;
 
 	memcpy(ifobj->dst_mac, dst_mac, ETH_ALEN);
 	memcpy(ifobj->src_mac, src_mac, ETH_ALEN);
@@ -1683,20 +1692,20 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
 	if (!load_xdp)
 		return;
 
-	err = xsk_load_xdp_program(&xsk_map_fd, &prog_fd);
+	err = xsk_load_xdp_program(ifobj);
 	if (err) {
 		printf("Error loading XDP program\n");
 		exit_with_error(err);
 	}
 
-	ifobj->xsk_map_fd = xsk_map_fd;
-	ifobj->prog_fd = prog_fd;
 	ifobj->xdp_flags = mode_to_xdp_flags(TEST_MODE_SKB);
-	ifobj->link_fd = xsk_attach_xdp_program(ifobj->ifindex, prog_fd, ifobj->xdp_flags);
-	if (ifobj->link_fd < 0) {
+	err = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
+				     ifobj->xdp_flags);
+	if (err) {
 		printf("Error attaching XDP program\n");
-		exit_with_error(ifobj->link_fd);
+		exit_with_error(-err);
 	}
+	ifobj->xskmap = ifobj->def_prog->maps.xsk;
 }
 
 static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
@@ -1831,9 +1840,6 @@ static struct ifobject *ifobject_create(void)
 
 static void ifobject_delete(struct ifobject *ifobj)
 {
-	close(ifobj->prog_fd);
-	close(ifobj->xsk_map_fd);
-
 	free(ifobj->umem);
 	free(ifobj->xsk_arr);
 	free(ifobj);
@@ -1872,13 +1878,15 @@ static void change_to_drv_mode(struct ifobject *ifobj)
 	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
 	int ret;
 
-	close(ifobj->link_fd);
-	ifobj->link_fd = xsk_attach_xdp_program(ifobj->ifindex, ifobj->prog_fd,
-						XDP_FLAGS_DRV_MODE);
-	if (ifobj->link_fd < 0) {
+	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
+	ifobj->xdp_flags = XDP_FLAGS_DRV_MODE;
+	ret = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
+				     ifobj->xdp_flags);
+	if (ret) {
 		printf("Error attaching XDP program\n");
-		exit_with_error(-ifobj->link_fd);
+		exit_with_error(-ret);
 	}
+	ifobj->xskmap = ifobj->def_prog->maps.xsk;
 
 	ret = bpf_xdp_query(ifobj->ifindex, XDP_FLAGS_DRV_MODE, &opts);
 	if (ret)
@@ -1963,6 +1971,8 @@ int main(int argc, char **argv)
 
 	pkt_stream_delete(tx_pkt_stream_default);
 	pkt_stream_delete(rx_pkt_stream_default);
+	xsk_unload_xdp_program(ifobj_tx);
+	xsk_unload_xdp_program(ifobj_rx);
 	ifobject_delete(ifobj_tx);
 	ifobject_delete(ifobj_rx);
 
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index b2ba877b1966..eb6355bcc143 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -5,6 +5,8 @@
 #ifndef XSKXCEIVER_H_
 #define XSKXCEIVER_H_
 
+#include "xsk_def_prog.skel.h"
+
 #ifndef SOL_XDP
 #define SOL_XDP 283
 #endif
@@ -138,9 +140,8 @@ struct ifobject {
 	thread_func_t func_ptr;
 	validation_func_t validation_func;
 	struct pkt_stream *pkt_stream;
-	int xsk_map_fd;
-	int prog_fd;
-	int link_fd;
+	struct xsk_def_prog *def_prog;
+	struct bpf_map *xskmap;
 	int ifindex;
 	u32 dst_ip;
 	u32 src_ip;
-- 
2.34.1


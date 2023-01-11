Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CED6657C2
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbjAKJjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbjAKJhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:33 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D7663F9;
        Wed, 11 Jan 2023 01:36:21 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id z5so13357334wrt.6;
        Wed, 11 Jan 2023 01:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O5FOgu3TVbkvMn82B3909R8GXGHIxsoIWw8qmByLNmM=;
        b=oj3BFwHmHyAxxXnC9Npqb1p3HpN771VCNAa0b1Kc8cYTGRjVWJcGbYUOVSeXm2vn6R
         A8Mqw2MTChCWaVrJLqgtAvhM4H9/Aj8IAWkJj7t6lPFR8jpreYZqP4oUcIgaV3TelPWs
         8wbETsZ1zzaRd3/XXqKJBZIqYzfAsVl2KR3Ktx2JqC+KWx2OAwpM+2te9h8eVuLV+je7
         zLTgGgclBZ5o5s2uuONntB0IDl64zuxD9JO8osbRAPgdIT4YHwAnxeN5ZBwoMCaqd8O6
         AIewcd2sAJHnWKWkAj1eeqsy0XUh6C/bJ0YgMEqXVyEdTgOeoY9ngukjeJUyPfVVz36C
         /xwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O5FOgu3TVbkvMn82B3909R8GXGHIxsoIWw8qmByLNmM=;
        b=IGptqDAFOYRJXfIumEQKNqyGrsxchSFqCVmg5YxRsn5uW8treRxPv+y81wA1/m+1ks
         4Dc6zb2wV87P47PNK23pi78rwmIDA+4rjv8hmBmYV2yLIz/yZXUVNPTTuWqShpk/dLgi
         8qc+7zvuBP9QL1jK8WSPgAowCBB5xv1sdxNLbUuczVRUVxETb+eo4IRgDmYbPN51hJb1
         5ImOuWfOh12eLisJl3nGw/m2OEJ9dVqF7kwDs+KGJhYN8+srCRsdY5ybQQZNgFotnuei
         eCg9uZxTKqdyyhPYbsyuLn/hfL7Y3vNoK6QFWPyndAEqAhOe4XqAvjQ+FYhJuRukzo3y
         M+1g==
X-Gm-Message-State: AFqh2kqk74zd2WFFukkQ7Z139BKx+D3vKuJnDhBGo//6nVE8bmx/708L
        HLX9ACbAxzCcmHO+ZcBT8xrIouJCkM/6d8u1
X-Google-Smtp-Source: AMrXdXt7BXWMX9EqLXTMZVVOV8ShvPnuNjKuwigWOecCTA3ePr7OQZpKOEvYrgFZMaiQy7i3/h/QPw==
X-Received: by 2002:adf:fac2:0:b0:2bb:3290:2548 with SMTP id a2-20020adffac2000000b002bb32902548mr12428906wrs.55.1673429779642;
        Wed, 11 Jan 2023 01:36:19 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.36.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:36:19 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 11/15] selftests/xsk: get rid of built-in XDP program
Date:   Wed, 11 Jan 2023 10:35:22 +0100
Message-Id: <20230111093526.11682-12-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111093526.11682-1-magnus.karlsson@gmail.com>
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
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

Get rid of the built-in XDP program that was part of the old libbpf
code in xsk.c and replace it with an eBPF program build using the
framework by all the other bpf selftests. This will form the base for
adding more programs in later commits.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/Makefile          |  6 +-
 .../selftests/bpf/progs/xsk_xdp_progs.c       | 19 ++++
 tools/testing/selftests/bpf/xsk.c             | 88 ++++---------------
 tools/testing/selftests/bpf/xsk.h             |  6 +-
 tools/testing/selftests/bpf/xskxceiver.c      | 72 ++++++++-------
 tools/testing/selftests/bpf/xskxceiver.h      |  7 +-
 6 files changed, 92 insertions(+), 106 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 205e8c3c346a..22533a18705e 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -240,7 +240,6 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
 $(OUTPUT)/test_maps: $(TESTING_HELPERS)
 $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
 $(OUTPUT)/xsk.o: $(BPFOBJ)
-$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
 
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
@@ -383,6 +382,7 @@ linked_maps.skel.h-deps := linked_maps1.bpf.o linked_maps2.bpf.o
 test_subskeleton.skel.h-deps := test_subskeleton_lib2.bpf.o test_subskeleton_lib.bpf.o test_subskeleton.bpf.o
 test_subskeleton_lib.skel.h-deps := test_subskeleton_lib2.bpf.o test_subskeleton_lib.bpf.o
 test_usdt.skel.h-deps := test_usdt.bpf.o test_usdt_multispec.bpf.o
+xsk_xdp_progs.skel.h-deps := xsk_xdp_progs.bpf.o
 
 LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
@@ -576,6 +576,10 @@ $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
 
+$(OUTPUT)/xskxceiver: xskxceiver.c $(OUTPUT)/xsk.o $(OUTPUT)/xsk_xdp_progs.skel.h $(BPFOBJ) | $(OUTPUT)
+	$(call msg,BINARY,,$@)
+	$(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
+
 # Make sure we are able to include and link libbpf against c++.
 $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPFOBJ)
 	$(call msg,CXX,,$@)
diff --git a/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c b/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
new file mode 100644
index 000000000000..698176882ac6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
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
index 693f8a63f718..d69100267f70 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1207,7 +1207,7 @@ static void thread_common_ops_tx(struct test_spec *test, struct ifobject *ifobje
 {
 	xsk_configure_socket(test, ifobject, test->ifobj_rx->umem, true);
 	ifobject->xsk = &ifobject->xsk_arr[0];
-	ifobject->xsk_map_fd = test->ifobj_rx->xsk_map_fd;
+	ifobject->xskmap = test->ifobj_rx->xskmap;
 	memcpy(ifobject->umem, test->ifobj_rx->umem, sizeof(struct xsk_umem_info));
 }
 
@@ -1247,9 +1247,8 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
 	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
 	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
-	u32 queue_id = 0;
-	int ret, fd;
 	void *bufs;
+	int ret;
 
 	if (ifobject->umem->unaligned_mode)
 		mmap_flags |= MAP_HUGETLB;
@@ -1274,8 +1273,7 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (!ifobject->rx_on)
 		return;
 
-	fd = xsk_socket__fd(ifobject->xsk->xsk);
-	ret = bpf_map_update_elem(ifobject->xsk_map_fd, &queue_id, &fd, 0);
+	ret = xsk_update_xskmap(ifobject->xskmap, ifobject->xsk->xsk);
 	if (ret)
 		exit_with_error(errno);
 }
@@ -1309,18 +1307,17 @@ static void *worker_testapp_validate_rx(void *arg)
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
 
@@ -1390,10 +1387,8 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
 	pthread_join(t0, NULL);
 
 	if (test->total_steps == test->current_step || test->fail) {
-		u32 queue_id = 0;
-
 		xsk_socket__delete(ifobj->xsk->xsk);
-		bpf_map_delete_elem(ifobj->xsk_map_fd, &queue_id);
+		xsk_clear_xskmap(ifobj->xskmap);
 		testapp_clean_xsk_umem(ifobj);
 	}
 
@@ -1482,14 +1477,14 @@ static void testapp_bidi(struct test_spec *test)
 
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
@@ -1651,12 +1646,26 @@ static void testapp_invalid_desc(struct test_spec *test)
 	pkt_stream_restore_default(test);
 }
 
+static int xsk_load_xdp_programs(struct ifobject *ifobj)
+{
+	ifobj->xdp_progs = xsk_xdp_progs__open_and_load();
+	if (libbpf_get_error(ifobj->xdp_progs))
+		return libbpf_get_error(ifobj->xdp_progs);
+
+	return 0;
+}
+
+static void xsk_unload_xdp_programs(struct ifobject *ifobj)
+{
+	xsk_xdp_progs__destroy(ifobj->xdp_progs);
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
@@ -1675,20 +1684,20 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
 	if (!load_xdp)
 		return;
 
-	err = xsk_load_xdp_program(&xsk_map_fd, &prog_fd);
+	err = xsk_load_xdp_programs(ifobj);
 	if (err) {
 		printf("Error loading XDP program\n");
 		exit_with_error(err);
 	}
 
-	ifobj->xsk_map_fd = xsk_map_fd;
-	ifobj->prog_fd = prog_fd;
 	ifobj->xdp_flags = mode_to_xdp_flags(TEST_MODE_SKB);
-	ifobj->link_fd = xsk_attach_xdp_program(ifobj->ifindex, prog_fd, ifobj->xdp_flags);
-	if (ifobj->link_fd < 0) {
+	err = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_def_prog, ifobj->ifindex,
+				     ifobj->xdp_flags);
+	if (err) {
 		printf("Error attaching XDP program\n");
-		exit_with_error(ifobj->link_fd);
+		exit_with_error(-err);
 	}
+	ifobj->xskmap = ifobj->xdp_progs->maps.xsk;
 }
 
 static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
@@ -1823,9 +1832,6 @@ static struct ifobject *ifobject_create(void)
 
 static void ifobject_delete(struct ifobject *ifobj)
 {
-	close(ifobj->prog_fd);
-	close(ifobj->xsk_map_fd);
-
 	free(ifobj->umem);
 	free(ifobj->xsk_arr);
 	free(ifobj);
@@ -1864,13 +1870,15 @@ static void change_to_drv_mode(struct ifobject *ifobj)
 	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
 	int ret;
 
-	close(ifobj->link_fd);
-	ifobj->link_fd = xsk_attach_xdp_program(ifobj->ifindex, ifobj->prog_fd,
-						XDP_FLAGS_DRV_MODE);
-	if (ifobj->link_fd < 0) {
+	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
+	ifobj->xdp_flags = XDP_FLAGS_DRV_MODE;
+	ret = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_def_prog, ifobj->ifindex,
+				     ifobj->xdp_flags);
+	if (ret) {
 		ksft_print_msg("Error attaching XDP program\n");
-		exit_with_error(-ifobj->link_fd);
+		exit_with_error(-ret);
 	}
+	ifobj->xskmap = ifobj->xdp_progs->maps.xsk;
 
 	ret = bpf_xdp_query(ifobj->ifindex, XDP_FLAGS_DRV_MODE, &opts);
 	if (ret)
@@ -1955,6 +1963,8 @@ int main(int argc, char **argv)
 
 	pkt_stream_delete(tx_pkt_stream_default);
 	pkt_stream_delete(rx_pkt_stream_default);
+	xsk_unload_xdp_programs(ifobj_tx);
+	xsk_unload_xdp_programs(ifobj_rx);
 	ifobject_delete(ifobj_tx);
 	ifobject_delete(ifobj_rx);
 
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index b2ba877b1966..70b3e5d1d40c 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -5,6 +5,8 @@
 #ifndef XSKXCEIVER_H_
 #define XSKXCEIVER_H_
 
+#include "xsk_xdp_progs.skel.h"
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
+	struct xsk_xdp_progs *xdp_progs;
+	struct bpf_map *xskmap;
 	int ifindex;
 	u32 dst_ip;
 	u32 src_ip;
-- 
2.34.1


Return-Path: <netdev+bounces-10199-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FBED72CC71
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 987231C20B5E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A88422D75;
	Mon, 12 Jun 2023 17:23:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5D522D70
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:23:21 +0000 (UTC)
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5C21A5
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:19 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-653a1cfb819so2830890b3a.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686590599; x=1689182599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EzTWWwhyhMVAvehkvr05ND69njUUlkEoFhtpXawONGA=;
        b=N+Q3gS9PnTA6vkhXJ5pIx7qDXSbWCamAVwfIzEIOGBYXW1OK6c9nSmT4KBM4dJHiic
         0a3eE9bvll7CjD3pyuYdvBEvTA+auNUoK9FUbpnmSdoSbsrGaNBFrKyFDrmavtM3qxPd
         9IScRF31hW1M1NAmh8Vi188zYZiJuTa+nPcAPvEBqfpqelqsi+zEE2RhqsZFzWbuDu/J
         7bJ1kXRi9cv48RDQDMxINDf7SoNfZ9cHIsdRTA1Pg9X9NPMR+ZELYmcS4eYMiGRkHuT8
         E9NvlJT8muNHg/e2iSvVOFsObtbDXZu7aHCR4K6NY8laEg/bpol2VtYutKf48K5kAmxp
         hE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686590599; x=1689182599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EzTWWwhyhMVAvehkvr05ND69njUUlkEoFhtpXawONGA=;
        b=FJTL/XWn2lpK4HvV8lKN7kKZ+njwq10A0s4XgIY/ruZSxbxtgrFWUcCgZRPOWYL0do
         79eAvNsxTh9OBvoMGv83ahag0T6knYCqbF/HME/vjRNZQ5XVoJFBllim8oRRJgKo5Eo2
         Svs2m2vitciz+tPnEGqCpZkZ8/bU4IcAxsSlcrAVzZdgJl0Nz9Jo9u2qErIF59GsQXWx
         KRw+cbJGEzyCL9IUk5sfsAIqQSeRwnBXSYZulwJYS13HwSDeAfEzlVdpR9qL59CxF5SG
         AE/Vr/dyUlW7U6oXkz8BvBp73v11gdgECgsPu6c0tOBozTEhdED17lstelRd5nhAxLJK
         dRkA==
X-Gm-Message-State: AC+VfDxFdIQft8j1MUmxkyP1naWLmUHJ/TtExJIpwQF6YOPrCpQ9Gq14
	qxNaHObrbulPzh6JCowAaUHnT/M=
X-Google-Smtp-Source: ACHHUZ68oYd1EKaptDeVMbxut9jn71wqbcYY0bIC7n4FliseC87SSjP9dZbRuhTlPGmzMYcex1tpjng=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:2e97:b0:665:b0bb:3f17 with SMTP id
 fd23-20020a056a002e9700b00665b0bb3f17mr422001pfb.1.1686590599002; Mon, 12 Jun
 2023 10:23:19 -0700 (PDT)
Date: Mon, 12 Jun 2023 10:23:06 -0700
In-Reply-To: <20230612172307.3923165-1-sdf@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230612172307.3923165-7-sdf@google.com>
Subject: [RFC bpf-next 6/7] selftests/bpf: extend xdp_metadata with devtx kfuncs
From: Stanislav Fomichev <sdf@google.com>
To: bpf@vger.kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, 
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Attach kfuncs that request and report TX timestamp via ringbuf.
Confirm on the userspace side that the program has triggered
and the timestamp is non-zero.

Also make sure devtx_frame has a sensible pointers and data.

Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/xdp_metadata.c   |  82 +++++++++++++-
 .../selftests/bpf/progs/xdp_metadata.c        | 101 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_metadata.h    |  13 +++
 3 files changed, 194 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
index 626c461fa34d..ebaa50293f85 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
@@ -42,6 +42,9 @@ struct xsk {
 	struct xsk_ring_prod tx;
 	struct xsk_ring_cons rx;
 	struct xsk_socket *socket;
+	int tx_completions;
+	u32 last_tx_timestamp_retval;
+	u64 last_tx_timestamp;
 };
 
 static int open_xsk(int ifindex, struct xsk *xsk)
@@ -192,7 +195,8 @@ static int generate_packet(struct xsk *xsk, __u16 dst_port)
 	return 0;
 }
 
-static void complete_tx(struct xsk *xsk)
+static void complete_tx(struct xsk *xsk, struct xdp_metadata *bpf_obj,
+			struct ring_buffer *ringbuf)
 {
 	__u32 idx;
 	__u64 addr;
@@ -202,6 +206,13 @@ static void complete_tx(struct xsk *xsk)
 
 		printf("%p: complete tx idx=%u addr=%llx\n", xsk, idx, addr);
 		xsk_ring_cons__release(&xsk->comp, 1);
+
+		ring_buffer__poll(ringbuf, 1000);
+
+		ASSERT_EQ(bpf_obj->bss->pkts_fail_tx, 0, "pkts_fail_tx");
+		ASSERT_GE(xsk->tx_completions, 1, "tx_completions");
+		ASSERT_EQ(xsk->last_tx_timestamp_retval, 0, "last_tx_timestamp_retval");
+		ASSERT_GE(xsk->last_tx_timestamp, 0, "last_tx_timestamp");
 	}
 }
 
@@ -276,8 +287,24 @@ static int verify_xsk_metadata(struct xsk *xsk)
 	return 0;
 }
 
+static int process_sample(void *ctx, void *data, size_t len)
+{
+	struct devtx_sample *sample = data;
+	struct xsk *xsk = ctx;
+
+	printf("%p: got tx timestamp sample %u %llu\n",
+	       xsk, sample->timestamp_retval, sample->timestamp);
+
+	xsk->tx_completions++;
+	xsk->last_tx_timestamp_retval = sample->timestamp_retval;
+	xsk->last_tx_timestamp = sample->timestamp;
+
+	return 0;
+}
+
 void test_xdp_metadata(void)
 {
+	struct ring_buffer *tx_compl_ringbuf = NULL;
 	struct xdp_metadata2 *bpf_obj2 = NULL;
 	struct xdp_metadata *bpf_obj = NULL;
 	struct bpf_program *new_prog, *prog;
@@ -290,6 +317,7 @@ void test_xdp_metadata(void)
 	int retries = 10;
 	int rx_ifindex;
 	int tx_ifindex;
+	int syscall_fd;
 	int sock_fd;
 	int ret;
 
@@ -323,6 +351,16 @@ void test_xdp_metadata(void)
 	if (!ASSERT_OK_PTR(bpf_obj, "open skeleton"))
 		goto out;
 
+	prog = bpf_object__find_program_by_name(bpf_obj->obj, "devtx_sb");
+	bpf_program__set_ifindex(prog, tx_ifindex);
+	bpf_program__set_flags(prog, BPF_F_XDP_DEV_BOUND_ONLY);
+	bpf_program__set_autoattach(prog, false);
+
+	prog = bpf_object__find_program_by_name(bpf_obj->obj, "devtx_cp");
+	bpf_program__set_ifindex(prog, tx_ifindex);
+	bpf_program__set_flags(prog, BPF_F_XDP_DEV_BOUND_ONLY);
+	bpf_program__set_autoattach(prog, false);
+
 	prog = bpf_object__find_program_by_name(bpf_obj->obj, "rx");
 	bpf_program__set_ifindex(prog, rx_ifindex);
 	bpf_program__set_flags(prog, BPF_F_XDP_DEV_BOUND_ONLY);
@@ -330,6 +368,15 @@ void test_xdp_metadata(void)
 	if (!ASSERT_OK(xdp_metadata__load(bpf_obj), "load skeleton"))
 		goto out;
 
+	ret = xdp_metadata__attach(bpf_obj);
+	if (!ASSERT_OK(ret, "xdp_metadata__attach"))
+		goto out;
+
+	tx_compl_ringbuf = ring_buffer__new(bpf_map__fd(bpf_obj->maps.tx_compl_buf),
+					    process_sample, &tx_xsk, NULL);
+	if (!ASSERT_OK_PTR(tx_compl_ringbuf, "ring_buffer__new"))
+		goto out;
+
 	/* Make sure we can't add dev-bound programs to prog maps. */
 	prog_arr = bpf_object__find_map_by_name(bpf_obj->obj, "prog_arr");
 	if (!ASSERT_OK_PTR(prog_arr, "no prog_arr map"))
@@ -341,6 +388,26 @@ void test_xdp_metadata(void)
 			"update prog_arr"))
 		goto out;
 
+	/* Attach egress BPF programs to interface. */
+	struct devtx_attach_args args = {
+		.ifindex = tx_ifindex,
+		.devtx_sb_prog_fd = bpf_program__fd(bpf_obj->progs.devtx_sb),
+		.devtx_cp_prog_fd = bpf_program__fd(bpf_obj->progs.devtx_cp),
+		.devtx_sb_retval = -1,
+		.devtx_cp_retval = -1,
+	};
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, tattr,
+		.ctx_in = &args,
+		.ctx_size_in = sizeof(args),
+	);
+
+	syscall_fd = bpf_program__fd(bpf_obj->progs.attach_prog);
+	ret = bpf_prog_test_run_opts(syscall_fd, &tattr);
+	if (!ASSERT_GE(ret, 0, "bpf_prog_test_run_opts(attach_prog)"))
+		goto out;
+	ASSERT_GE(args.devtx_sb_retval, 0, "bpf_prog_test_run_opts(attach_prog) devtx_sb_retval");
+	ASSERT_GE(args.devtx_cp_retval, 0, "bpf_prog_test_run_opts(attach_prog) devtx_cp_retval");
+
 	/* Attach BPF program to RX interface. */
 
 	ret = bpf_xdp_attach(rx_ifindex,
@@ -364,7 +431,16 @@ void test_xdp_metadata(void)
 		       "verify_xsk_metadata"))
 		goto out;
 
-	complete_tx(&tx_xsk);
+	/* Verify AF_XDP TX packet has completion event with a timestamp. */
+	complete_tx(&tx_xsk, bpf_obj, tx_compl_ringbuf);
+
+	/* Detach egress program. */
+	syscall_fd = bpf_program__fd(bpf_obj->progs.detach_prog);
+	ret = bpf_prog_test_run_opts(syscall_fd, &tattr);
+	if (!ASSERT_GE(ret, 0, "bpf_prog_test_run_opts(detach_prog)"))
+		goto out;
+	ASSERT_GE(args.devtx_sb_retval, 0, "bpf_prog_test_run_opts(detach_prog) devtx_sb_retval");
+	ASSERT_GE(args.devtx_cp_retval, 0, "bpf_prog_test_run_opts(detach_prog) devtx_cp_retval");
 
 	/* Make sure freplace correctly picks up original bound device
 	 * and doesn't crash.
@@ -402,5 +478,7 @@ void test_xdp_metadata(void)
 	xdp_metadata__destroy(bpf_obj);
 	if (tok)
 		close_netns(tok);
+	if (tx_compl_ringbuf)
+		ring_buffer__free(tx_compl_ringbuf);
 	SYS_NOFAIL("ip netns del xdp_metadata");
 }
diff --git a/tools/testing/selftests/bpf/progs/xdp_metadata.c b/tools/testing/selftests/bpf/progs/xdp_metadata.c
index d151d406a123..5b815bd03fe7 100644
--- a/tools/testing/selftests/bpf/progs/xdp_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_metadata.c
@@ -4,6 +4,11 @@
 #include "xdp_metadata.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
+#include <bpf/bpf_tracing.h>
+
+#ifndef ETH_P_IP
+#define ETH_P_IP 0x0800
+#endif
 
 struct {
 	__uint(type, BPF_MAP_TYPE_XSKMAP);
@@ -19,10 +24,22 @@ struct {
 	__type(value, __u32);
 } prog_arr SEC(".maps");
 
+struct {
+	__uint(type, BPF_MAP_TYPE_RINGBUF);
+	__uint(max_entries, 10);
+} tx_compl_buf SEC(".maps");
+
+__u64 pkts_fail_tx = 0;
+
 extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
 					 __u64 *timestamp) __ksym;
 extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, __u32 *hash,
 				    enum xdp_rss_hash_type *rss_type) __ksym;
+extern int bpf_devtx_sb_request_timestamp(const struct devtx_frame *ctx) __ksym;
+extern int bpf_devtx_cp_timestamp(const struct devtx_frame *ctx, __u64 *timestamp) __ksym;
+
+extern int bpf_devtx_sb_attach(int ifindex, int prog_fd) __ksym;
+extern int bpf_devtx_cp_attach(int ifindex, int prog_fd) __ksym;
 
 SEC("xdp")
 int rx(struct xdp_md *ctx)
@@ -61,4 +78,88 @@ int rx(struct xdp_md *ctx)
 	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
 }
 
+static inline int verify_frame(const struct devtx_frame *frame)
+{
+	struct ethhdr eth = {};
+
+	/* all the pointers are set up correctly */
+	if (!frame->data)
+		return -1;
+	if (!frame->sinfo)
+		return -1;
+
+	/* can get to the frags */
+	if (frame->sinfo->nr_frags != 0)
+		return -1;
+	if (frame->sinfo->frags[0].bv_page != 0)
+		return -1;
+	if (frame->sinfo->frags[0].bv_len != 0)
+		return -1;
+	if (frame->sinfo->frags[0].bv_offset != 0)
+		return -1;
+
+	/* the data has something that looks like ethernet */
+	if (frame->len != 46)
+		return -1;
+	bpf_probe_read_kernel(&eth, sizeof(eth), frame->data);
+
+	if (eth.h_proto != bpf_htons(ETH_P_IP))
+		return -1;
+
+	return 0;
+}
+
+SEC("fentry/devtx_sb")
+int BPF_PROG(devtx_sb, const struct devtx_frame *frame)
+{
+	int ret;
+
+	ret = verify_frame(frame);
+	if (ret < 0)
+		__sync_add_and_fetch(&pkts_fail_tx, 1);
+
+	ret = bpf_devtx_sb_request_timestamp(frame);
+	if (ret < 0)
+		__sync_add_and_fetch(&pkts_fail_tx, 1);
+
+	return 0;
+}
+
+SEC("fentry/devtx_cp")
+int BPF_PROG(devtx_cp, const struct devtx_frame *frame)
+{
+	struct devtx_sample *sample;
+	int ret;
+
+	ret = verify_frame(frame);
+	if (ret < 0)
+		__sync_add_and_fetch(&pkts_fail_tx, 1);
+
+	sample = bpf_ringbuf_reserve(&tx_compl_buf, sizeof(*sample), 0);
+	if (!sample)
+		return 0;
+
+	sample->timestamp_retval = bpf_devtx_cp_timestamp(frame, &sample->timestamp);
+
+	bpf_ringbuf_submit(sample, 0);
+
+	return 0;
+}
+
+SEC("syscall")
+int attach_prog(struct devtx_attach_args *ctx)
+{
+	ctx->devtx_sb_retval = bpf_devtx_sb_attach(ctx->ifindex, ctx->devtx_sb_prog_fd);
+	ctx->devtx_cp_retval = bpf_devtx_cp_attach(ctx->ifindex, ctx->devtx_cp_prog_fd);
+	return 0;
+}
+
+SEC("syscall")
+int detach_prog(struct devtx_attach_args *ctx)
+{
+	ctx->devtx_sb_retval = bpf_devtx_sb_attach(ctx->ifindex, -1);
+	ctx->devtx_cp_retval = bpf_devtx_cp_attach(ctx->ifindex, -1);
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/xdp_metadata.h b/tools/testing/selftests/bpf/xdp_metadata.h
index 938a729bd307..add900c9035c 100644
--- a/tools/testing/selftests/bpf/xdp_metadata.h
+++ b/tools/testing/selftests/bpf/xdp_metadata.h
@@ -18,3 +18,16 @@ struct xdp_meta {
 		__s32 rx_hash_err;
 	};
 };
+
+struct devtx_sample {
+	int timestamp_retval;
+	__u64 timestamp;
+};
+
+struct devtx_attach_args {
+	int ifindex;
+	int devtx_sb_prog_fd;
+	int devtx_cp_prog_fd;
+	int devtx_sb_retval;
+	int devtx_cp_retval;
+};
-- 
2.41.0.162.gfafddb0af9-goog



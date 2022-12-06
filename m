Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6ABA643F6D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiLFJJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiLFJJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:25 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371A91EED7;
        Tue,  6 Dec 2022 01:09:21 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bs21so22528906wrb.4;
        Tue, 06 Dec 2022 01:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xWuKce24dRN+/katnxcmMmnOVvV7gujozyqezyBbvc=;
        b=erStWh5fcttuS68bc6nvCeYB1T3OEicVayNX5NPvuCpIhW1dNU5dm3ek2FjhTo0nGf
         EEBNqddHlMhExs5wWqzNaPuL+kl3h7pFllGdYZegDg1XpGy81ykhQQ5lkAA4+2/Drmds
         W7EQinHjPiw0t7qjEtoHHL6OOj6T+JlnfQ2WsoSHysekD180xRcpayjlivunZDd5f9qL
         n6dw9SfRBetFR9uUQrZYk5DXTAwmpRdfMfFkSZntzt4yOY1rofP0Q+kbNLgwAGu0Kf7d
         1LyElpgMgomCV8gmDbZ+/YjvoNaGdMFv9dL5Gu8FxHLg6Av7hIc8RMjEuaSlhqmECXWf
         FH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0xWuKce24dRN+/katnxcmMmnOVvV7gujozyqezyBbvc=;
        b=hmzmeGMZ37YAjVMAZ/VHvQnVL56Yh5dy81RTwN9WU91Z96o5AkoJFPU6jSYr8fPjpr
         efaOzW1zAMeXjdJRynQtTV1UkvLQq/z1VwUOgWkf0IQshL8CkjOg5xQqP9UYCWPqOgcI
         AFbm+hglb3MurMeU/LdqaBTWp0wDfk4brVflXtZlvRE6gqwtMFuJzmYANtW5XbTkm2wU
         OIXkFgdQpq6vAc3l5xbUdBRhyY1yyZegfJ8XZ6noqfl2HoFUx/x9jV36KoFwV6tkwVqi
         y5lD7DaY4dR9F75k50EBIVx1kwe4i7TC3YNJwvYYlf6Tq3f3T/PvGky0zBsK6KzqTYxq
         eG9Q==
X-Gm-Message-State: ANoB5pmTxAUCwFus1Km07H6qg2E0dxjvzKvAEr7u1NE5PW1TfSD+tarC
        J5vukpgMah4cW9ywFVV8S9Q=
X-Google-Smtp-Source: AA0mqf4wi2TowASwmEdFEU9F3H6h1EQNZCJ+HbSr8z3NY7rbohNmoWUOFFkAjvpfJJs53+usJaikSw==
X-Received: by 2002:adf:f990:0:b0:242:3353:26ef with SMTP id f16-20020adff990000000b00242335326efmr13681375wrr.248.1670317759336;
        Tue, 06 Dec 2022 01:09:19 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.09.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:09:18 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 10/15] selftests/xsk: remove unnecessary code in control path
Date:   Tue,  6 Dec 2022 10:08:21 +0100
Message-Id: <20221206090826.2957-11-magnus.karlsson@gmail.com>
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

Remove unnecessary code in the control path. This is located in the
file xsk.c that was moved from libbpf when the xsk support there was
deprecated. Some of the code there is not needed anymore as the
selftests are only guaranteed to run on the kernel it is shipped
with. Therefore, all the code that has to deal with compatibility of
older kernels can be dropped and also any other function that is not
of any use for the tests.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xsk.c        | 617 +----------------------
 tools/testing/selftests/bpf/xsk.h        |   9 -
 tools/testing/selftests/bpf/xskxceiver.c |   2 -
 3 files changed, 3 insertions(+), 625 deletions(-)

diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index 1dd953541812..9ed31d280e48 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -35,8 +35,6 @@
 #include "xsk.h"
 #include "bpf_util.h"
 
-#define FD_NOT_USED (-1)
-
 #ifndef SOL_XDP
  #define SOL_XDP 283
 #endif
@@ -53,11 +51,6 @@
 
 #define XSKMAP_SIZE 1
 
-enum xsk_prog {
-	XSK_PROG_FALLBACK,
-	XSK_PROG_REDIRECT_FLAGS,
-};
-
 struct xsk_umem {
 	struct xsk_ring_prod *fill_save;
 	struct xsk_ring_cons *comp_save;
@@ -78,11 +71,6 @@ struct xsk_ctx {
 	int refcount;
 	int ifindex;
 	struct list_head list;
-	int prog_fd;
-	int link_fd;
-	int xsks_map_fd;
-	char ifname[IFNAMSIZ];
-	bool has_bpf_link;
 };
 
 struct xsk_socket {
@@ -93,27 +81,6 @@ struct xsk_socket {
 	int fd;
 };
 
-struct xsk_nl_info {
-	bool xdp_prog_attached;
-	int ifindex;
-	int fd;
-};
-
-/* Up until and including Linux 5.3 */
-struct xdp_ring_offset_v1 {
-	__u64 producer;
-	__u64 consumer;
-	__u64 desc;
-};
-
-/* Up until and including Linux 5.3 */
-struct xdp_mmap_offsets_v1 {
-	struct xdp_ring_offset_v1 rx;
-	struct xdp_ring_offset_v1 tx;
-	struct xdp_ring_offset_v1 fr;
-	struct xdp_ring_offset_v1 cr;
-};
-
 int xsk_umem__fd(const struct xsk_umem *umem)
 {
 	return umem ? umem->fd : -EINVAL;
@@ -156,55 +123,17 @@ static int xsk_set_xdp_socket_config(struct xsk_socket_config *cfg,
 	if (!usr_cfg) {
 		cfg->rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 		cfg->tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
-		cfg->libbpf_flags = 0;
-		cfg->xdp_flags = 0;
 		cfg->bind_flags = 0;
 		return 0;
 	}
 
-	if (usr_cfg->libbpf_flags & ~XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)
-		return -EINVAL;
-
 	cfg->rx_size = usr_cfg->rx_size;
 	cfg->tx_size = usr_cfg->tx_size;
-	cfg->libbpf_flags = usr_cfg->libbpf_flags;
-	cfg->xdp_flags = usr_cfg->xdp_flags;
 	cfg->bind_flags = usr_cfg->bind_flags;
 
 	return 0;
 }
 
-static void xsk_mmap_offsets_v1(struct xdp_mmap_offsets *off)
-{
-	struct xdp_mmap_offsets_v1 off_v1;
-
-	/* getsockopt on a kernel <= 5.3 has no flags fields.
-	 * Copy over the offsets to the correct places in the >=5.4 format
-	 * and put the flags where they would have been on that kernel.
-	 */
-	memcpy(&off_v1, off, sizeof(off_v1));
-
-	off->rx.producer = off_v1.rx.producer;
-	off->rx.consumer = off_v1.rx.consumer;
-	off->rx.desc = off_v1.rx.desc;
-	off->rx.flags = off_v1.rx.consumer + sizeof(__u32);
-
-	off->tx.producer = off_v1.tx.producer;
-	off->tx.consumer = off_v1.tx.consumer;
-	off->tx.desc = off_v1.tx.desc;
-	off->tx.flags = off_v1.tx.consumer + sizeof(__u32);
-
-	off->fr.producer = off_v1.fr.producer;
-	off->fr.consumer = off_v1.fr.consumer;
-	off->fr.desc = off_v1.fr.desc;
-	off->fr.flags = off_v1.fr.consumer + sizeof(__u32);
-
-	off->cr.producer = off_v1.cr.producer;
-	off->cr.consumer = off_v1.cr.consumer;
-	off->cr.desc = off_v1.cr.desc;
-	off->cr.flags = off_v1.cr.consumer + sizeof(__u32);
-}
-
 static int xsk_get_mmap_offsets(int fd, struct xdp_mmap_offsets *off)
 {
 	socklen_t optlen;
@@ -218,11 +147,6 @@ static int xsk_get_mmap_offsets(int fd, struct xdp_mmap_offsets *off)
 	if (optlen == sizeof(*off))
 		return 0;
 
-	if (optlen == sizeof(struct xdp_mmap_offsets_v1)) {
-		xsk_mmap_offsets_v1(off);
-		return 0;
-	}
-
 	return -EINVAL;
 }
 
@@ -343,122 +267,19 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area,
 	return err;
 }
 
-struct xsk_umem_config_v1 {
-	__u32 fill_size;
-	__u32 comp_size;
-	__u32 frame_size;
-	__u32 frame_headroom;
-};
-
-static enum xsk_prog get_xsk_prog(void)
-{
-	enum xsk_prog detected = XSK_PROG_FALLBACK;
-	char data_in = 0, data_out;
-	struct bpf_insn insns[] = {
-		BPF_LD_MAP_FD(BPF_REG_1, 0),
-		BPF_MOV64_IMM(BPF_REG_2, 0),
-		BPF_MOV64_IMM(BPF_REG_3, XDP_PASS),
-		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
-		BPF_EXIT_INSN(),
-	};
-	LIBBPF_OPTS(bpf_test_run_opts, opts,
-		.data_in = &data_in,
-		.data_size_in = 1,
-		.data_out = &data_out,
-	);
-
-	int prog_fd, map_fd, ret, insn_cnt = ARRAY_SIZE(insns);
-
-	map_fd = bpf_map_create(BPF_MAP_TYPE_XSKMAP, NULL, sizeof(int), sizeof(int), 1, NULL);
-	if (map_fd < 0)
-		return detected;
-
-	insns[0].imm = map_fd;
-
-	prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "GPL", insns, insn_cnt, NULL);
-	if (prog_fd < 0) {
-		close(map_fd);
-		return detected;
-	}
-
-	ret = bpf_prog_test_run_opts(prog_fd, &opts);
-	if (!ret && opts.retval == XDP_PASS)
-		detected = XSK_PROG_REDIRECT_FLAGS;
-	close(prog_fd);
-	close(map_fd);
-	return detected;
-}
-
 static int __xsk_load_xdp_prog(int xsk_map_fd)
 {
 	static const int log_buf_size = 16 * 1024;
 	char log_buf[log_buf_size];
 	int prog_fd;
 
-	/* This is the fallback C-program:
-	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
-	 * {
-	 *     int ret, index = ctx->rx_queue_index;
-	 *
-	 *     // A set entry here means that the correspnding queue_id
-	 *     // has an active AF_XDP socket bound to it.
-	 *     ret = bpf_redirect_map(&xsks_map, index, XDP_PASS);
-	 *     if (ret > 0)
-	 *         return ret;
-	 *
-	 *     // Fallback for pre-5.3 kernels, not supporting default
-	 *     // action in the flags parameter.
-	 *     if (bpf_map_lookup_elem(&xsks_map, &index))
-	 *         return bpf_redirect_map(&xsks_map, index, 0);
-	 *     return XDP_PASS;
-	 * }
-	 */
-	struct bpf_insn prog[] = {
-		/* r2 = *(u32 *)(r1 + 16) */
-		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 16),
-		/* *(u32 *)(r10 - 4) = r2 */
-		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_2, -4),
-		/* r1 = xskmap[] */
-		BPF_LD_MAP_FD(BPF_REG_1, xsk_map_fd),
-		/* r3 = XDP_PASS */
-		BPF_MOV64_IMM(BPF_REG_3, 2),
-		/* call bpf_redirect_map */
-		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
-		/* if w0 != 0 goto pc+13 */
-		BPF_JMP32_IMM(BPF_JSGT, BPF_REG_0, 0, 13),
-		/* r2 = r10 */
-		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-		/* r2 += -4 */
-		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
-		/* r1 = xskmap[] */
-		BPF_LD_MAP_FD(BPF_REG_1, xsk_map_fd),
-		/* call bpf_map_lookup_elem */
-		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
-		/* r1 = r0 */
-		BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
-		/* r0 = XDP_PASS */
-		BPF_MOV64_IMM(BPF_REG_0, 2),
-		/* if r1 == 0 goto pc+5 */
-		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 5),
-		/* r2 = *(u32 *)(r10 - 4) */
-		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_10, -4),
-		/* r1 = xskmap[] */
-		BPF_LD_MAP_FD(BPF_REG_1, xsk_map_fd),
-		/* r3 = 0 */
-		BPF_MOV64_IMM(BPF_REG_3, 0),
-		/* call bpf_redirect_map */
-		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
-		/* The jumps are to this instruction */
-		BPF_EXIT_INSN(),
-	};
-
 	/* This is the post-5.3 kernel C-program:
 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
 	 * {
 	 *     return bpf_redirect_map(&xsks_map, ctx->rx_queue_index, XDP_PASS);
 	 * }
 	 */
-	struct bpf_insn prog_redirect_flags[] = {
+	struct bpf_insn prog[] = {
 		/* r2 = *(u32 *)(r1 + 16) */
 		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 16),
 		/* r1 = xskmap[] */
@@ -469,18 +290,14 @@ static int __xsk_load_xdp_prog(int xsk_map_fd)
 		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
 		BPF_EXIT_INSN(),
 	};
-	size_t insns_cnt[] = {ARRAY_SIZE(prog),
-			      ARRAY_SIZE(prog_redirect_flags),
-	};
-	struct bpf_insn *progs[] = {prog, prog_redirect_flags};
-	enum xsk_prog option = get_xsk_prog();
+	size_t insns_cnt = ARRAY_SIZE(prog);
 	LIBBPF_OPTS(bpf_prog_load_opts, opts,
 		.log_buf = log_buf,
 		.log_size = log_buf_size,
 	);
 
 	prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "LGPL-2.1 or BSD-2-Clause",
-				progs[option], insns_cnt[option], &opts);
+				prog, insns_cnt, &opts);
 	if (prog_fd < 0)
 		pr_warn("BPF log buffer:\n%s", log_buf);
 
@@ -517,388 +334,6 @@ int xsk_attach_xdp_program(int ifindex, int prog_fd, u32 xdp_flags)
 	return link_fd;
 }
 
-static int xsk_create_bpf_link(struct xsk_socket *xsk)
-{
-	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
-	struct xsk_ctx *ctx = xsk->ctx;
-	__u32 prog_id = 0;
-	int link_fd;
-	int err;
-
-	err = bpf_xdp_query_id(ctx->ifindex, xsk->config.xdp_flags, &prog_id);
-	if (err) {
-		pr_warn("getting XDP prog id failed\n");
-		return err;
-	}
-
-	/* if there's a netlink-based XDP prog loaded on interface, bail out
-	 * and ask user to do the removal by himself
-	 */
-	if (prog_id) {
-		pr_warn("Netlink-based XDP prog detected, please unload it in order to launch AF_XDP prog\n");
-		return -EINVAL;
-	}
-
-	opts.flags = xsk->config.xdp_flags & ~(XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_REPLACE);
-
-	link_fd = bpf_link_create(ctx->prog_fd, ctx->ifindex, BPF_XDP, &opts);
-	if (link_fd < 0) {
-		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
-		return link_fd;
-	}
-
-	ctx->link_fd = link_fd;
-	return 0;
-}
-
-static int xsk_get_max_queues(struct xsk_socket *xsk)
-{
-	struct ethtool_channels channels = { .cmd = ETHTOOL_GCHANNELS };
-	struct xsk_ctx *ctx = xsk->ctx;
-	struct ifreq ifr = {};
-	int fd, err, ret;
-
-	fd = socket(AF_LOCAL, SOCK_DGRAM | SOCK_CLOEXEC, 0);
-	if (fd < 0)
-		return -errno;
-
-	ifr.ifr_data = (void *)&channels;
-	bpf_strlcpy(ifr.ifr_name, ctx->ifname, IFNAMSIZ);
-	err = ioctl(fd, SIOCETHTOOL, &ifr);
-	if (err && errno != EOPNOTSUPP) {
-		ret = -errno;
-		goto out;
-	}
-
-	if (err) {
-		/* If the device says it has no channels, then all traffic
-		 * is sent to a single stream, so max queues = 1.
-		 */
-		ret = 1;
-	} else {
-		/* Take the max of rx, tx, combined. Drivers return
-		 * the number of channels in different ways.
-		 */
-		ret = max(channels.max_rx, channels.max_tx);
-		ret = max(ret, (int)channels.max_combined);
-	}
-
-out:
-	close(fd);
-	return ret;
-}
-
-static int xsk_create_bpf_maps(struct xsk_socket *xsk)
-{
-	struct xsk_ctx *ctx = xsk->ctx;
-	int max_queues;
-	int fd;
-
-	max_queues = xsk_get_max_queues(xsk);
-	if (max_queues < 0)
-		return max_queues;
-
-	fd = bpf_map_create(BPF_MAP_TYPE_XSKMAP, "xsks_map",
-			    sizeof(int), sizeof(int), max_queues, NULL);
-	if (fd < 0)
-		return fd;
-
-	ctx->xsks_map_fd = fd;
-
-	return 0;
-}
-
-static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
-{
-	struct xsk_ctx *ctx = xsk->ctx;
-
-	if (ctx->xsks_map_fd == FD_NOT_USED)
-		return;
-
-	bpf_map_delete_elem(ctx->xsks_map_fd, &ctx->queue_id);
-	close(ctx->xsks_map_fd);
-}
-
-static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
-{
-	__u32 i, *map_ids, num_maps, prog_len = sizeof(struct bpf_prog_info);
-	__u32 map_len = sizeof(struct bpf_map_info);
-	struct bpf_prog_info prog_info = {};
-	struct xsk_ctx *ctx = xsk->ctx;
-	struct bpf_map_info map_info;
-	int fd, err;
-
-	err = bpf_obj_get_info_by_fd(ctx->prog_fd, &prog_info, &prog_len);
-	if (err)
-		return err;
-
-	num_maps = prog_info.nr_map_ids;
-
-	map_ids = calloc(prog_info.nr_map_ids, sizeof(*map_ids));
-	if (!map_ids)
-		return -ENOMEM;
-
-	memset(&prog_info, 0, prog_len);
-	prog_info.nr_map_ids = num_maps;
-	prog_info.map_ids = (__u64)(unsigned long)map_ids;
-
-	err = bpf_obj_get_info_by_fd(ctx->prog_fd, &prog_info, &prog_len);
-	if (err)
-		goto out_map_ids;
-
-	ctx->xsks_map_fd = -1;
-
-	for (i = 0; i < prog_info.nr_map_ids; i++) {
-		fd = bpf_map_get_fd_by_id(map_ids[i]);
-		if (fd < 0)
-			continue;
-
-		memset(&map_info, 0, map_len);
-		err = bpf_obj_get_info_by_fd(fd, &map_info, &map_len);
-		if (err) {
-			close(fd);
-			continue;
-		}
-
-		if (!strncmp(map_info.name, "xsks_map", sizeof(map_info.name))) {
-			ctx->xsks_map_fd = fd;
-			break;
-		}
-
-		close(fd);
-	}
-
-	if (ctx->xsks_map_fd == -1)
-		err = -ENOENT;
-
-out_map_ids:
-	free(map_ids);
-	return err;
-}
-
-static int xsk_set_bpf_maps(struct xsk_socket *xsk)
-{
-	struct xsk_ctx *ctx = xsk->ctx;
-
-	return bpf_map_update_elem(ctx->xsks_map_fd, &ctx->queue_id,
-				   &xsk->fd, 0);
-}
-
-static int xsk_link_lookup(int ifindex, __u32 *prog_id, int *link_fd)
-{
-	struct bpf_link_info link_info;
-	__u32 link_len;
-	__u32 id = 0;
-	int err;
-	int fd;
-
-	while (true) {
-		err = bpf_link_get_next_id(id, &id);
-		if (err) {
-			if (errno == ENOENT) {
-				err = 0;
-				break;
-			}
-			pr_warn("can't get next link: %s\n", strerror(errno));
-			break;
-		}
-
-		fd = bpf_link_get_fd_by_id(id);
-		if (fd < 0) {
-			if (errno == ENOENT)
-				continue;
-			pr_warn("can't get link by id (%u): %s\n", id, strerror(errno));
-			err = -errno;
-			break;
-		}
-
-		link_len = sizeof(struct bpf_link_info);
-		memset(&link_info, 0, link_len);
-		err = bpf_obj_get_info_by_fd(fd, &link_info, &link_len);
-		if (err) {
-			pr_warn("can't get link info: %s\n", strerror(errno));
-			close(fd);
-			break;
-		}
-		if (link_info.type == BPF_LINK_TYPE_XDP) {
-			if (link_info.xdp.ifindex == ifindex) {
-				*link_fd = fd;
-				if (prog_id)
-					*prog_id = link_info.prog_id;
-				break;
-			}
-		}
-		close(fd);
-	}
-
-	return err;
-}
-
-static bool xsk_probe_bpf_link(void)
-{
-	LIBBPF_OPTS(bpf_link_create_opts, opts, .flags = XDP_FLAGS_SKB_MODE);
-	struct bpf_insn insns[2] = {
-		BPF_MOV64_IMM(BPF_REG_0, XDP_PASS),
-		BPF_EXIT_INSN()
-	};
-	int prog_fd, link_fd = -1, insn_cnt = ARRAY_SIZE(insns);
-	int ifindex_lo = 1;
-	bool ret = false;
-	int err;
-
-	err = xsk_link_lookup(ifindex_lo, NULL, &link_fd);
-	if (err)
-		return ret;
-
-	if (link_fd >= 0)
-		return true;
-
-	prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "GPL", insns, insn_cnt, NULL);
-	if (prog_fd < 0)
-		return ret;
-
-	link_fd = bpf_link_create(prog_fd, ifindex_lo, BPF_XDP, &opts);
-	close(prog_fd);
-
-	if (link_fd >= 0) {
-		ret = true;
-		close(link_fd);
-	}
-
-	return ret;
-}
-
-static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
-{
-	char ifname[IFNAMSIZ];
-	struct xsk_ctx *ctx;
-	char *interface;
-
-	ctx = calloc(1, sizeof(*ctx));
-	if (!ctx)
-		return -ENOMEM;
-
-	interface = if_indextoname(ifindex, &ifname[0]);
-	if (!interface) {
-		free(ctx);
-		return -errno;
-	}
-
-	ctx->ifindex = ifindex;
-	bpf_strlcpy(ctx->ifname, ifname, IFNAMSIZ);
-
-	xsk->ctx = ctx;
-	xsk->ctx->has_bpf_link = xsk_probe_bpf_link();
-
-	return 0;
-}
-
-static int xsk_init_xdp_res(struct xsk_socket *xsk,
-			    int *xsks_map_fd)
-{
-	struct xsk_ctx *ctx = xsk->ctx;
-	int err;
-
-	err = xsk_create_bpf_maps(xsk);
-	if (err)
-		return err;
-
-	err = __xsk_load_xdp_prog(*xsks_map_fd);
-	if (err)
-		goto err_load_xdp_prog;
-
-	if (ctx->has_bpf_link)
-		err = xsk_create_bpf_link(xsk);
-	else
-		err = bpf_xdp_attach(xsk->ctx->ifindex, ctx->prog_fd,
-				     xsk->config.xdp_flags, NULL);
-
-	if (err)
-		goto err_attach_xdp_prog;
-
-	if (!xsk->rx)
-		return err;
-
-	err = xsk_set_bpf_maps(xsk);
-	if (err)
-		goto err_set_bpf_maps;
-
-	return err;
-
-err_set_bpf_maps:
-	if (ctx->has_bpf_link)
-		close(ctx->link_fd);
-	else
-		bpf_xdp_detach(ctx->ifindex, 0, NULL);
-err_attach_xdp_prog:
-	close(ctx->prog_fd);
-err_load_xdp_prog:
-	xsk_delete_bpf_maps(xsk);
-	return err;
-}
-
-static int xsk_lookup_xdp_res(struct xsk_socket *xsk, int *xsks_map_fd, int prog_id)
-{
-	struct xsk_ctx *ctx = xsk->ctx;
-	int err;
-
-	ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
-	if (ctx->prog_fd < 0) {
-		err = -errno;
-		goto err_prog_fd;
-	}
-	err = xsk_lookup_bpf_maps(xsk);
-	if (err)
-		goto err_lookup_maps;
-
-	if (!xsk->rx)
-		return err;
-
-	err = xsk_set_bpf_maps(xsk);
-	if (err)
-		goto err_set_maps;
-
-	return err;
-
-err_set_maps:
-	close(ctx->xsks_map_fd);
-err_lookup_maps:
-	close(ctx->prog_fd);
-err_prog_fd:
-	if (ctx->has_bpf_link)
-		close(ctx->link_fd);
-	return err;
-}
-
-static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp, int *xsks_map_fd)
-{
-	struct xsk_socket *xsk = _xdp;
-	struct xsk_ctx *ctx = xsk->ctx;
-	__u32 prog_id = 0;
-	int err;
-
-	if (ctx->has_bpf_link)
-		err = xsk_link_lookup(ctx->ifindex, &prog_id, &ctx->link_fd);
-	else
-		err = bpf_xdp_query_id(ctx->ifindex, xsk->config.xdp_flags, &prog_id);
-
-	if (err)
-		return err;
-
-	err = !prog_id ? xsk_init_xdp_res(xsk, xsks_map_fd) :
-			 xsk_lookup_xdp_res(xsk, xsks_map_fd, prog_id);
-
-	if (!err && xsks_map_fd)
-		*xsks_map_fd = ctx->xsks_map_fd;
-
-	return err;
-}
-
-int xsk_setup_xdp_prog_xsk(struct xsk_socket *xsk, int *xsks_map_fd)
-{
-	return __xsk_setup_xdp_prog(xsk, xsks_map_fd);
-}
-
 int xsk_load_xdp_program(int *xsk_map_fd, int *prog_fd)
 {
 	*xsk_map_fd = bpf_map_create(BPF_MAP_TYPE_XSKMAP, "xsks_map", sizeof(int), sizeof(int),
@@ -988,51 +423,13 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
 	ctx->refcount = 1;
 	ctx->umem = umem;
 	ctx->queue_id = queue_id;
-	ctx->prog_fd = FD_NOT_USED;
-	ctx->link_fd = FD_NOT_USED;
-	ctx->xsks_map_fd = FD_NOT_USED;
 
 	ctx->fill = fill;
 	ctx->comp = comp;
 	list_add(&ctx->list, &umem->ctx_list);
-	ctx->has_bpf_link = xsk_probe_bpf_link();
 	return ctx;
 }
 
-static void xsk_destroy_xsk_struct(struct xsk_socket *xsk)
-{
-	free(xsk->ctx);
-	free(xsk);
-}
-
-int xsk_socket__update_xskmap(struct xsk_socket *xsk, int fd)
-{
-	xsk->ctx->xsks_map_fd = fd;
-	return xsk_set_bpf_maps(xsk);
-}
-
-int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd)
-{
-	struct xsk_socket *xsk;
-	int res;
-
-	xsk = calloc(1, sizeof(*xsk));
-	if (!xsk)
-		return -ENOMEM;
-
-	res = xsk_create_xsk_struct(ifindex, xsk);
-	if (res) {
-		free(xsk);
-		return -EINVAL;
-	}
-
-	res = __xsk_setup_xdp_prog(xsk, xsks_map_fd);
-
-	xsk_destroy_xsk_struct(xsk);
-
-	return res;
-}
-
 int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			      int ifindex,
 			      __u32 queue_id, struct xsk_umem *umem,
@@ -1255,14 +652,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 	ctx = xsk->ctx;
 	umem = ctx->umem;
 
-	if (ctx->refcount == 1) {
-		xsk_delete_bpf_maps(xsk);
-		if (ctx->prog_fd != FD_NOT_USED)
-			close(ctx->prog_fd);
-		if (ctx->has_bpf_link && ctx->link_fd != FD_NOT_USED)
-			close(ctx->link_fd);
-	}
-
 	xsk_put_ctx(ctx, true);
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
index 7a5aeacd261b..bd5b55ad9f8a 100644
--- a/tools/testing/selftests/bpf/xsk.h
+++ b/tools/testing/selftests/bpf/xsk.h
@@ -197,21 +197,12 @@ struct xsk_umem_config {
 	__u32 flags;
 };
 
-int xsk_setup_xdp_prog_xsk(struct xsk_socket *xsk, int *xsks_map_fd);
-int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd);
-int xsk_socket__update_xskmap(struct xsk_socket *xsk, int xsks_map_fd);
-
-/* Flags for the libbpf_flags field. */
-#define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
-
 int xsk_load_xdp_program(int *xsk_map_fd, int *prog_fd);
 int xsk_attach_xdp_program(int ifindex, int prog_fd, u32 xdp_flags);
 
 struct xsk_socket_config {
 	__u32 rx_size;
 	__u32 tx_size;
-	__u32 libbpf_flags;
-	__u32 xdp_flags;
 	__u16 bind_flags;
 };
 
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 5f22ee88a523..81b0a3ca05a6 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -326,8 +326,6 @@ static int __xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_i
 	xsk->umem = umem;
 	cfg.rx_size = xsk->rxqsize;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
-	cfg.libbpf_flags = XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD;
-	cfg.xdp_flags = ifobject->xdp_flags;
 	cfg.bind_flags = ifobject->bind_flags;
 	if (shared)
 		cfg.bind_flags |= XDP_SHARED_UMEM;
-- 
2.34.1


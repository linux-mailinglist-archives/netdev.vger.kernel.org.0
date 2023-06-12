Return-Path: <netdev+bounces-10200-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D1D72CC78
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9E081C20BD2
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2357C2340A;
	Mon, 12 Jun 2023 17:23:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1848717AB7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:23:23 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D95DB
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:21 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b3e2394342so2224855ad.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686590600; x=1689182600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QinrNp91VGgxDgv0vB00Zn5PtTuK217dsIffIBOl1/c=;
        b=gH+1FBDJQ3LSSBKS+kVCh4qzFceRiXyVzbS1RnLCUN+OMZZlCpW0vz30TfHRtaXxeL
         mR8svbrelRsmHnT0Wksf9VNl/ibM1mTrJS6VEDw0eIBb7k/d4dqORzFPA7eHHB0y9j30
         3IbwJkUmEkVbyyRWUEXTci3JwbTM0sRqln9e2Y7Z18Otmdzp+zCNcHmYmrpdGcRIuEOu
         SS7Hd0TMbBwh5sHEErRmW6tBQX3bThxR1O+yr1H0QQnfu+4hVQAmT2GncUsxefj7ilBY
         egzyk5uSjxAqEkmL/XSVVX4wRbOicmbklQBIkaCLcH7hhTXI+gVHnd7i8Rnws8cKX+0D
         JQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686590600; x=1689182600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QinrNp91VGgxDgv0vB00Zn5PtTuK217dsIffIBOl1/c=;
        b=k90SL0jxJez50mOnjb31w6J3rhSQ2ZHfi4TGRIlA/dBACpCul4zwEdC7B01s7cg423
         NBELlG8JvLbDn+Cl48MUI9UmmnQvRcgTIRvyT6fo8cner22dP8vUmtX98ebjhynvvKIQ
         rwzqXcrdhfFxgtv+XDMc6fp4e2Douhy1YgsBhdZb3J/I60jSXefVlMKsYZI0FHNStzpK
         KGBr2KpNGV1UutYI0eUXAeapSbYy4xmxENbY3h6WnkMNt5h49YwSLIuU+gmSlCzD0oMk
         JNbhaIIJS7uMFbkcGDORRxq1NLtHtfV5jbwieEPf8kB26Mp9QrABy+ScWC35b5+bWqav
         3K6A==
X-Gm-Message-State: AC+VfDwqVb3sSg/m1WZAfN3RU5JJ91KKpFNHPoa5gNmkW6oNKbAadV9v
	ucvCwT58xop5vbDH+LRakZ7Wr2Y=
X-Google-Smtp-Source: ACHHUZ5aFSuCUC2xqESgbeK7GtiyMCRrjswwYNuL4ck19JhSF0kT5V2oYWDEHlWPGpmW2ImWcu17V1g=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:b18a:b0:1ae:50cc:457 with SMTP id
 s10-20020a170902b18a00b001ae50cc0457mr1314399plr.10.1686590600591; Mon, 12
 Jun 2023 10:23:20 -0700 (PDT)
Date: Mon, 12 Jun 2023 10:23:07 -0700
In-Reply-To: <20230612172307.3923165-1-sdf@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230612172307.3923165-8-sdf@google.com>
Subject: [RFC bpf-next 7/7] selftests/bpf: extend xdp_hw_metadata with devtx kfuncs
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

When we get packets on port 9091, we swap src/dst and send it out.
At this point, we also request the timestamp and plumb it back
to the userspace. The userspace simply prints the timestamp.

Haven't really tested, still working on mlx5 patches...

Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/progs/xdp_hw_metadata.c     |  59 +++++++
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 160 +++++++++++++++++-
 2 files changed, 214 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
index b2dfd7066c6e..e27823b755ef 100644
--- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
@@ -4,6 +4,7 @@
 #include "xdp_metadata.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
+#include <bpf/bpf_tracing.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_XSKMAP);
@@ -12,14 +13,26 @@ struct {
 	__type(value, __u32);
 } xsk SEC(".maps");
 
+struct {
+	__uint(type, BPF_MAP_TYPE_RINGBUF);
+	__uint(max_entries, 10);
+} tx_compl_buf SEC(".maps");
+
 __u64 pkts_skip = 0;
 __u64 pkts_fail = 0;
 __u64 pkts_redir = 0;
+__u64 pkts_fail_tx = 0;
+__u64 pkts_ringbuf_full = 0;
 
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
@@ -90,4 +103,50 @@ int rx(struct xdp_md *ctx)
 	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
 }
 
+SEC("fentry/devtx_sb")
+int BPF_PROG(devtx_sb, const struct devtx_frame *frame)
+{
+	int ret;
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
+
+	sample = bpf_ringbuf_reserve(&tx_compl_buf, sizeof(*sample), 0);
+	if (!sample) {
+		__sync_add_and_fetch(&pkts_ringbuf_full, 1);
+		return 0;
+	}
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
diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 613321eb84c1..6cc364c2af8a 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -10,7 +10,8 @@
  *   - rx_hash
  *
  * TX:
- * - TBD
+ * - UDP 9091 packets trigger TX reply
+ * - TX HW timestamp is requested and reported back upon completion
  */
 
 #include <test_progs.h>
@@ -228,7 +229,83 @@ static void verify_skb_metadata(int fd)
 	printf("skb hwtstamp is not found!\n");
 }
 
-static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd, clockid_t clock_id)
+static void complete_tx(struct xsk *xsk, struct ring_buffer *ringbuf)
+{
+	__u32 idx;
+	__u64 addr;
+
+	ring_buffer__poll(ringbuf, 1000);
+
+	if (xsk_ring_cons__peek(&xsk->comp, 1, &idx)) {
+		addr = *xsk_ring_cons__comp_addr(&xsk->comp, idx);
+
+		printf("%p: complete tx idx=%u addr=%llx\n", xsk, idx, addr);
+		xsk_ring_cons__release(&xsk->comp, 1);
+	}
+}
+
+#define swap(a, b, len) do { \
+	for (int i = 0; i < len; i++) { \
+		__u8 tmp = ((__u8 *)a)[i]; \
+		((__u8 *)a)[i] = ((__u8 *)b)[i]; \
+		((__u8 *)b)[i] = tmp; \
+	} \
+} while (0)
+
+static void ping_pong(struct xsk *xsk, void *rx_packet)
+{
+	struct ipv6hdr *ip6h = NULL;
+	struct iphdr *iph = NULL;
+	struct xdp_desc *tx_desc;
+	struct udphdr *udph;
+	struct ethhdr *eth;
+	void *data;
+	__u32 idx;
+	int ret;
+	int len;
+
+	ret = xsk_ring_prod__reserve(&xsk->tx, 1, &idx);
+	if (ret != 1) {
+		printf("%p: failed to reserve tx slot\n", xsk);
+		return;
+	}
+
+	tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx);
+	tx_desc->addr = idx % (UMEM_NUM / 2) * UMEM_FRAME_SIZE;
+	data = xsk_umem__get_data(xsk->umem_area, tx_desc->addr);
+
+	eth = data;
+
+	if (eth->h_proto == htons(ETH_P_IP)) {
+		iph = (void *)(eth + 1);
+		udph = (void *)(iph + 1);
+	} else if (eth->h_proto == htons(ETH_P_IPV6)) {
+		ip6h = (void *)(eth + 1);
+		udph = (void *)(ip6h + 1);
+	} else {
+		xsk_ring_prod__cancel(&xsk->tx, 1);
+		return;
+	}
+
+	len = ETH_HLEN;
+	if (ip6h)
+		len += ntohs(ip6h->payload_len);
+	if (iph)
+		len += ntohs(iph->tot_len);
+
+	memcpy(data, rx_packet, len);
+	swap(eth->h_dest, eth->h_source, ETH_ALEN);
+	if (iph)
+		swap(&iph->saddr, &iph->daddr, 4);
+	else
+		swap(&ip6h->saddr, &ip6h->daddr, 16);
+	swap(&udph->source, &udph->dest, 2);
+
+	xsk_ring_prod__submit(&xsk->tx, 1);
+}
+
+static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd, clockid_t clock_id,
+			   struct ring_buffer *ringbuf)
 {
 	const struct xdp_desc *rx_desc;
 	struct pollfd fds[rxq + 1];
@@ -280,6 +357,11 @@ static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd, clockid_t
 			       xsk, idx, rx_desc->addr, addr, comp_addr);
 			verify_xdp_metadata(xsk_umem__get_data(xsk->umem_area, addr),
 					    clock_id);
+
+			/* mirror packet back */
+			ping_pong(xsk, xsk_umem__get_data(xsk->umem_area, addr));
+			complete_tx(xsk, ringbuf);
+
 			xsk_ring_cons__release(&xsk->rx, 1);
 			refill_rx(xsk, comp_addr);
 		}
@@ -370,6 +452,7 @@ static void hwtstamp_enable(const char *ifname)
 static void cleanup(void)
 {
 	LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
+	int syscall_fd;
 	int ret;
 	int i;
 
@@ -379,8 +462,26 @@ static void cleanup(void)
 			printf("detaching bpf program....\n");
 			ret = bpf_xdp_detach(ifindex, XDP_FLAGS, &opts);
 			if (ret)
-				printf("failed to detach XDP program: %d\n", ret);
+				printf("failed to detach RX XDP program: %d\n", ret);
 		}
+
+		struct devtx_attach_args args = {
+			.ifindex = ifindex,
+			.devtx_sb_prog_fd = bpf_program__fd(bpf_obj->progs.devtx_sb),
+			.devtx_cp_prog_fd = bpf_program__fd(bpf_obj->progs.devtx_cp),
+			.devtx_sb_retval = -1,
+			.devtx_cp_retval = -1,
+		};
+		DECLARE_LIBBPF_OPTS(bpf_test_run_opts, tattr,
+			.ctx_in = &args,
+			.ctx_size_in = sizeof(args),
+		);
+
+		syscall_fd = bpf_program__fd(bpf_obj->progs.detach_prog);
+		ret = bpf_prog_test_run_opts(syscall_fd, &tattr);
+		if (ret < 0 || args.devtx_sb_retval < 0 || args.devtx_cp_retval < 0)
+			printf("failed to detach TX XDP programs: %d %d %d\n",
+			       ret, args.devtx_sb_retval, args.devtx_cp_retval);
 	}
 
 	for (i = 0; i < rxq; i++)
@@ -404,10 +505,22 @@ static void timestamping_enable(int fd, int val)
 		error(1, errno, "setsockopt(SO_TIMESTAMPING)");
 }
 
+static int process_sample(void *ctx, void *data, size_t len)
+{
+	struct devtx_sample *sample = data;
+
+	printf("got tx timestamp sample %u %llu\n",
+	       sample->timestamp_retval, sample->timestamp);
+
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
+	struct ring_buffer *tx_compl_ringbuf = NULL;
 	clockid_t clock_id = CLOCK_TAI;
 	int server_fd = -1;
+	int syscall_fd;
 	int ret;
 	int i;
 
@@ -448,11 +561,26 @@ int main(int argc, char *argv[])
 	bpf_program__set_ifindex(prog, ifindex);
 	bpf_program__set_flags(prog, BPF_F_XDP_DEV_BOUND_ONLY);
 
+	prog = bpf_object__find_program_by_name(bpf_obj->obj, "devtx_sb");
+	bpf_program__set_ifindex(prog, ifindex);
+	bpf_program__set_flags(prog, BPF_F_XDP_DEV_BOUND_ONLY);
+	bpf_program__set_autoattach(prog, false);
+
+	prog = bpf_object__find_program_by_name(bpf_obj->obj, "devtx_cp");
+	bpf_program__set_ifindex(prog, ifindex);
+	bpf_program__set_flags(prog, BPF_F_XDP_DEV_BOUND_ONLY);
+	bpf_program__set_autoattach(prog, false);
+
 	printf("load bpf program...\n");
 	ret = xdp_hw_metadata__load(bpf_obj);
 	if (ret)
 		error(1, -ret, "xdp_hw_metadata__load");
 
+	tx_compl_ringbuf = ring_buffer__new(bpf_map__fd(bpf_obj->maps.tx_compl_buf),
+					    process_sample, NULL, NULL);
+	if (libbpf_get_error(tx_compl_ringbuf))
+		error(1, -libbpf_get_error(tx_compl_ringbuf), "ring_buffer__new");
+
 	printf("prepare skb endpoint...\n");
 	server_fd = start_server(AF_INET6, SOCK_DGRAM, NULL, 9092, 1000);
 	if (server_fd < 0)
@@ -472,15 +600,37 @@ int main(int argc, char *argv[])
 			error(1, -ret, "bpf_map_update_elem");
 	}
 
-	printf("attach bpf program...\n");
+	printf("attach rx bpf program...\n");
 	ret = bpf_xdp_attach(ifindex,
 			     bpf_program__fd(bpf_obj->progs.rx),
 			     XDP_FLAGS, NULL);
 	if (ret)
 		error(1, -ret, "bpf_xdp_attach");
 
+	printf("attach tx bpf programs...\n");
+	struct devtx_attach_args args = {
+		.ifindex = ifindex,
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
+	if (ret)
+		error(1, -ret, "bpf_prog_test_run_opts");
+	if (args.devtx_sb_retval < 0)
+		error(1, args.devtx_sb_retval, "devtx_sb_retval");
+	if (args.devtx_cp_retval < 0)
+		error(1, args.devtx_cp_retval, "devtx_cp_retval");
+
 	signal(SIGINT, handle_signal);
-	ret = verify_metadata(rx_xsk, rxq, server_fd, clock_id);
+	ret = verify_metadata(rx_xsk, rxq, server_fd, clock_id, tx_compl_ringbuf);
 	close(server_fd);
 	cleanup();
 	if (ret)
-- 
2.41.0.162.gfafddb0af9-goog



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B834833F6
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 16:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbiACPId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 10:08:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233889AbiACPIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 10:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641222511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4GGO6N4bCUKxV1eNBvyBL2tJVvDzjOAuLukvcKL/rog=;
        b=QVDs4tnQeiYkA5Dt3J8qdCT+/XCdoJZnZTYRy5dqoXYiS9gjfG+h5BFPpjvpFs//3KajII
        Wno3dng8DJD6YCcm4+EZv8OyAWwWEe2VSnE6wzJyODnW5tLI9+84PQILOrPblq5iNcYE+a
        l8Afh97mJLtjENTOOTzjFba57aLWGuk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-wOYoJp6lNUyJxhraW1exHg-1; Mon, 03 Jan 2022 10:08:30 -0500
X-MC-Unique: wOYoJp6lNUyJxhraW1exHg-1
Received: by mail-ed1-f72.google.com with SMTP id dz8-20020a0564021d4800b003f897935eb3so23099777edb.12
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 07:08:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4GGO6N4bCUKxV1eNBvyBL2tJVvDzjOAuLukvcKL/rog=;
        b=yy5lpdXGVt/dCYcRl2RHTGLpSIvzWs3gfpP5Ct/kV1rMr8h9ZOTWRoFizKWsVy1rre
         QvXf3vwBw+DCkWmIbhQaJYvESHaufu3cj3Svao/qk2nTFjtzcwOGl0MH1kUHwADvogA0
         YjQcd3rIvZ8Cdfpzq7FIJTUDzGQ89UQDbN39bw8F8iNRXOJmFEkZx+R2zrFCv5EI3AMk
         fF9FUXLPWtcVuGZ/4gCu4teTLOenJUCqjoQ41QLUtB2WBA48NuGwnOpPAm/t1Gv4/ogt
         9/3VKXqFykGUYa4ZFdVL5ipcwizf+JyPwGD4QRfVXY5CUiMYCRzHJmQrN+k5HZnZQn3V
         sIzw==
X-Gm-Message-State: AOAM533rqi4yvNFP0XovYKnf/8Tle6q04TagOUqwM7wzS8xq2FkMEyu4
        t4AcE6ODJbF6mCkg7yzQDxPpZ+x72xaEiSE2FoeYupp5UwwiVQ6j8QjrKaAxPZMAHNsoH1TiKwF
        2VMDO7zEwOjH6kTW1
X-Received: by 2002:a05:6402:2787:: with SMTP id b7mr38870203ede.362.1641222506596;
        Mon, 03 Jan 2022 07:08:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzK+Txc8/Bne8wUO9SrV2TpsZ6gBn95YOiYiW4pA8MfClahNUVAJoKxvZ1ns/l09jzqHm+S7Q==
X-Received: by 2002:a05:6402:2787:: with SMTP id b7mr38870098ede.362.1641222505169;
        Mon, 03 Jan 2022 07:08:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id oz20sm10660127ejc.60.2022.01.03.07.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 07:08:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 389CA180300; Mon,  3 Jan 2022 16:08:22 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v5 6/7] bpf: Add "live packet" mode for XDP in bpf_prog_run()
Date:   Mon,  3 Jan 2022 16:08:11 +0100
Message-Id: <20220103150812.87914-7-toke@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103150812.87914-1-toke@redhat.com>
References: <20220103150812.87914-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for running XDP programs through bpf_prog_run() in a mode
that enables live packet processing of the resulting frames. Previous uses
of bpf_prog_run() for XDP returned the XDP program return code and the
modified packet data to userspace, which is useful for unit testing of XDP
programs.

This patch adds a new mode with different semantics. When enabled through
the new BPF_F_TEST_XDP_LIVE_FRAMES flag, the XDP program return codes will
be honoured: returning XDP_PASS will result in the frame being injected
into the networking stack as if it came from the selected networking
interface, while returning XDP_TX and XDP_REDIRECT will result in the frame
being transmitted out an egress interface. XDP_TX is translated into an
XDP_REDIRECT operation, since the real XDP_TX action is only possible from
within the network drivers themselves, not from the process context where
bpf_prog_run() is executed.

To achieve this new mode of operation, we create a page pool instance while
setting up the test run, and feed pages from that into the XDP program. The
setup cost of this is amortised over the number of repetitions specified by
userspace.

To support performance testing use case, we further optimise the setup step
so that all pages in the pool are pre-initialised with the packet data, and
pre-computed context and xdp_frame objects stored at the start of each
page. This makes it possible to entirely avoid touching the page content on
each XDP program invocation, and enables sending up to 11.5 Mpps/core on my
test box.

Because the data pages are recycled by the page pool, and the test runner
doesn't re-initialise them for each run, subsequent invocations of the XDP
program will see the packet data in the state it was after the last time it
ran on that particular page. This means that an XDP program that modifies
the packet before redirecting it has to be careful about which assumptions
it makes about the packet content, but that is only an issue for the most
naively written programs.

Enabling the new flag is only allowed when not setting ctx_out and data_out
in the test specification, since using it means frames will be redirected
somewhere else, so they can't be returned.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/uapi/linux/bpf.h       |   2 +
 kernel/bpf/Kconfig             |   1 +
 net/bpf/test_run.c             | 287 ++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |   2 +
 4 files changed, 284 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b0383d371b9a..5ef20deaf49f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1225,6 +1225,8 @@ enum {
 
 /* If set, run the test on the cpu specified by bpf_attr.test.cpu */
 #define BPF_F_TEST_RUN_ON_CPU	(1U << 0)
+/* If set, XDP frames will be transmitted after processing */
+#define BPF_F_TEST_XDP_LIVE_FRAMES	(1U << 1)
 
 /* type for BPF_ENABLE_STATS */
 enum bpf_stats_type {
diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index d24d518ddd63..c8c920020d11 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -30,6 +30,7 @@ config BPF_SYSCALL
 	select TASKS_TRACE_RCU
 	select BINARY_PRINTF
 	select NET_SOCK_MSG if NET
+	select PAGE_POOL if NET
 	default n
 	help
 	  Enable the bpf() system call that allows to manipulate BPF programs
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 46dd95755967..11543819f0ef 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -14,6 +14,7 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 #include <net/net_namespace.h>
+#include <net/page_pool.h>
 #include <linux/error-injection.h>
 #include <linux/smp.h>
 #include <linux/sock_diag.h>
@@ -52,10 +53,11 @@ static void bpf_test_timer_leave(struct bpf_test_timer *t)
 	rcu_read_unlock();
 }
 
-static bool bpf_test_timer_continue(struct bpf_test_timer *t, u32 repeat, int *err, u32 *duration)
+static bool bpf_test_timer_continue(struct bpf_test_timer *t, int iterations,
+				    u32 repeat, int *err, u32 *duration)
 	__must_hold(rcu)
 {
-	t->i++;
+	t->i += iterations;
 	if (t->i >= repeat) {
 		/* We're done. */
 		t->time_spent += ktime_get_ns() - t->time_start;
@@ -87,6 +89,267 @@ static bool bpf_test_timer_continue(struct bpf_test_timer *t, u32 repeat, int *e
 	return false;
 }
 
+/* We put this struct at the head of each page with a context and frame
+ * initialised when the page is allocated, so we don't have to do this on each
+ * repetition of the test run.
+ */
+struct xdp_page_head {
+	struct xdp_buff orig_ctx;
+	struct xdp_buff ctx;
+	struct xdp_frame frm;
+	u8 data[];
+};
+
+struct xdp_test_data {
+	struct xdp_buff *orig_ctx;
+	struct xdp_rxq_info rxq;
+	struct net_device *dev;
+	struct page_pool *pp;
+	u32 frame_cnt;
+};
+
+#define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head)	\
+			     - sizeof(struct skb_shared_info))
+#define TEST_XDP_BATCH 64
+
+static void xdp_test_run_init_page(struct page *page, void *arg)
+{
+	struct xdp_page_head *head = phys_to_virt(page_to_phys(page));
+	struct xdp_buff *new_ctx, *orig_ctx;
+	u32 headroom = XDP_PACKET_HEADROOM;
+	struct xdp_test_data *xdp = arg;
+	size_t frm_len, meta_len;
+	struct xdp_frame *frm;
+	void *data;
+
+	orig_ctx = xdp->orig_ctx;
+	frm_len = orig_ctx->data_end - orig_ctx->data_meta;
+	meta_len = orig_ctx->data - orig_ctx->data_meta;
+	headroom -= meta_len;
+
+	new_ctx = &head->ctx;
+	frm = &head->frm;
+	data = &head->data;
+	memcpy(data + headroom, orig_ctx->data_meta, frm_len);
+
+	xdp_init_buff(new_ctx, TEST_XDP_FRAME_SIZE, &xdp->rxq);
+	xdp_prepare_buff(new_ctx, data, headroom, frm_len, true);
+	new_ctx->data_meta = new_ctx->data + meta_len;
+
+	xdp_update_frame_from_buff(new_ctx, frm);
+	frm->mem = new_ctx->rxq->mem;
+
+	memcpy(&head->orig_ctx, new_ctx, sizeof(head->orig_ctx));
+}
+
+static int xdp_test_run_setup(struct xdp_test_data *xdp, struct xdp_buff *orig_ctx)
+{
+	struct xdp_mem_info mem = {};
+	struct page_pool *pp;
+	int err;
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = 0,
+		.pool_size = NAPI_POLL_WEIGHT * 2,
+		.nid = NUMA_NO_NODE,
+		.max_len = TEST_XDP_FRAME_SIZE,
+		.init_callback = xdp_test_run_init_page,
+		.init_arg = xdp,
+	};
+
+	pp = page_pool_create(&pp_params);
+	if (IS_ERR(pp))
+		return PTR_ERR(pp);
+
+	/* will copy 'mem.id' into pp->xdp_mem_id */
+	err = xdp_reg_mem_model(&mem, MEM_TYPE_PAGE_POOL, pp);
+	if (err) {
+		page_pool_destroy(pp);
+		return err;
+	}
+	xdp->pp = pp;
+
+	/* We create a 'fake' RXQ referencing the original dev, but with an
+	 * xdp_mem_info pointing to our page_pool
+	 */
+	xdp_rxq_info_reg(&xdp->rxq, orig_ctx->rxq->dev, 0, 0);
+	xdp->rxq.mem.type = MEM_TYPE_PAGE_POOL;
+	xdp->rxq.mem.id = pp->xdp_mem_id;
+	xdp->dev = orig_ctx->rxq->dev;
+	xdp->orig_ctx = orig_ctx;
+
+	return 0;
+}
+
+static void xdp_test_run_teardown(struct xdp_test_data *xdp)
+{
+	struct xdp_mem_info mem = {
+		.id = xdp->pp->xdp_mem_id,
+		.type = MEM_TYPE_PAGE_POOL,
+	};
+
+	xdp_unreg_mem_model(&mem);
+}
+
+static bool ctx_was_changed(struct xdp_page_head *head)
+{
+	return head->orig_ctx.data != head->ctx.data ||
+		head->orig_ctx.data_meta != head->ctx.data_meta ||
+		head->orig_ctx.data_end != head->ctx.data_end;
+}
+
+static void reset_ctx(struct xdp_page_head *head)
+{
+	if (likely(!ctx_was_changed(head)))
+		return;
+
+	head->ctx.data = head->orig_ctx.data;
+	head->ctx.data_meta = head->orig_ctx.data_meta;
+	head->ctx.data_end = head->orig_ctx.data_end;
+	xdp_update_frame_from_buff(&head->ctx, &head->frm);
+}
+
+static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
+			   struct net_device *dev)
+{
+	gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
+	void *skbs[TEST_XDP_BATCH];
+	int i, n;
+	LIST_HEAD(list);
+
+	n = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, nframes, skbs);
+	if (unlikely(n == 0)) {
+		for (i = 0; i < nframes; i++)
+			xdp_return_frame(frames[i]);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < nframes; i++) {
+		struct xdp_frame *xdpf = frames[i];
+		struct sk_buff *skb = skbs[i];
+
+		skb = __xdp_build_skb_from_frame(xdpf, skb, dev);
+		if (!skb) {
+			xdp_return_frame(xdpf);
+			continue;
+		}
+
+		list_add_tail(&skb->list, &list);
+	}
+	netif_receive_skb_list(&list);
+	return 0;
+}
+
+static int xdp_test_run_batch(struct xdp_test_data *xdp, struct bpf_prog *prog,
+			      u32 repeat)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	int err = 0, act, ret, i, nframes = 0, batch_sz;
+	struct xdp_frame *frames[TEST_XDP_BATCH];
+	struct xdp_page_head *head;
+	struct xdp_frame *frm;
+	bool redirect = false;
+	struct xdp_buff *ctx;
+	struct page *page;
+
+	batch_sz = min_t(u32, repeat, TEST_XDP_BATCH);
+	xdp_set_return_frame_no_direct();
+
+	for (i = 0; i < batch_sz; i++) {
+		page = page_pool_dev_alloc_pages(xdp->pp);
+		if (!page) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		head = phys_to_virt(page_to_phys(page));
+		reset_ctx(head);
+		ctx = &head->ctx;
+		frm = &head->frm;
+		xdp->frame_cnt++;
+
+		act = bpf_prog_run_xdp(prog, ctx);
+
+		/* if program changed pkt bounds we need to update the xdp_frame */
+		if (unlikely(ctx_was_changed(head))) {
+			err = xdp_update_frame_from_buff(ctx, frm);
+			if (err) {
+				xdp_return_buff(ctx);
+				goto out;
+			}
+		}
+
+		switch (act) {
+		case XDP_TX:
+			/* we can't do a real XDP_TX since we're not in the
+			 * driver, so turn it into a REDIRECT back to the same
+			 * index
+			 */
+			ri->tgt_index = xdp->dev->ifindex;
+			ri->map_id = INT_MAX;
+			ri->map_type = BPF_MAP_TYPE_UNSPEC;
+			fallthrough;
+		case XDP_REDIRECT:
+			redirect = true;
+			err = xdp_do_redirect_frame(xdp->dev, ctx, frm, prog);
+			if (err) {
+				xdp_return_buff(ctx);
+				goto out;
+			}
+			break;
+		case XDP_PASS:
+			frames[nframes++] = frm;
+			break;
+		default:
+			bpf_warn_invalid_xdp_action(NULL, prog, act);
+			fallthrough;
+		case XDP_DROP:
+			xdp_return_buff(ctx);
+			break;
+		}
+	}
+
+out:
+	if (redirect)
+		xdp_do_flush();
+	if (nframes) {
+		ret = xdp_recv_frames(frames, nframes, xdp->dev);
+		if (ret)
+			err = ret;
+	}
+
+	xdp_clear_return_frame_no_direct();
+	return err;
+}
+
+static int bpf_test_run_xdp_live(struct bpf_prog *prog, struct xdp_buff *ctx,
+				 u32 repeat, u32 *time)
+
+{
+	struct bpf_test_timer t = { .mode = NO_MIGRATE };
+	struct xdp_test_data xdp = {};
+	int ret;
+
+	if (!repeat)
+		repeat = 1;
+
+	ret = xdp_test_run_setup(&xdp, ctx);
+	if (ret)
+		return ret;
+
+	bpf_test_timer_enter(&t);
+	do {
+		xdp.frame_cnt = 0;
+		ret = xdp_test_run_batch(&xdp, prog, repeat - t.i);
+		if (unlikely(ret < 0))
+			break;
+	} while (bpf_test_timer_continue(&t, xdp.frame_cnt, repeat, &ret, time));
+	bpf_test_timer_leave(&t);
+
+	xdp_test_run_teardown(&xdp);
+	return ret;
+}
+
 static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 			u32 *retval, u32 *time, bool xdp)
 {
@@ -118,7 +381,7 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 			*retval = bpf_prog_run_xdp(prog, ctx);
 		else
 			*retval = bpf_prog_run(prog, ctx);
-	} while (bpf_test_timer_continue(&t, repeat, &ret, time));
+	} while (bpf_test_timer_continue(&t, 1, repeat, &ret, time));
 	bpf_reset_run_ctx(old_ctx);
 	bpf_test_timer_leave(&t);
 
@@ -757,13 +1020,14 @@ static void xdp_convert_buff_to_md(struct xdp_buff *xdp, struct xdp_md *xdp_md)
 int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
+	bool do_live = (kattr->test.flags & BPF_F_TEST_XDP_LIVE_FRAMES);
 	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	u32 headroom = XDP_PACKET_HEADROOM;
 	u32 size = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	struct netdev_rx_queue *rxqueue;
 	struct xdp_buff xdp = {};
-	u32 retval, duration;
+	u32 retval = 0, duration;
 	struct xdp_md *ctx;
 	u32 max_data_sz;
 	void *data;
@@ -773,6 +1037,9 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	    prog->expected_attach_type == BPF_XDP_CPUMAP)
 		return -EINVAL;
 
+	if (kattr->test.flags & ~BPF_F_TEST_XDP_LIVE_FRAMES)
+		return -EINVAL;
+
 	ctx = bpf_ctx_init(kattr, sizeof(struct xdp_md));
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
@@ -781,7 +1048,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		/* There can't be user provided data before the meta data */
 		if (ctx->data_meta || ctx->data_end != size ||
 		    ctx->data > ctx->data_end ||
-		    unlikely(xdp_metalen_invalid(ctx->data)))
+		    unlikely(xdp_metalen_invalid(ctx->data)) ||
+		    (do_live && (kattr->test.data_out || kattr->test.ctx_out)))
 			goto free_ctx;
 		/* Meta data is allocated from the headroom */
 		headroom -= ctx->data;
@@ -807,7 +1075,10 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	if (repeat > 1)
 		bpf_prog_change_xdp(NULL, prog);
-	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
+	if (do_live)
+		ret = bpf_test_run_xdp_live(prog, &xdp, repeat, &duration);
+	else
+		ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	/* We convert the xdp_buff back to an xdp_md before checking the return
 	 * code so the reference count of any held netdevice will be decremented
 	 * even if the test run failed.
@@ -905,7 +1176,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	do {
 		retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
 					  size, flags);
-	} while (bpf_test_timer_continue(&t, repeat, &ret, &duration));
+	} while (bpf_test_timer_continue(&t, 1, repeat, &ret, &duration));
 	bpf_test_timer_leave(&t);
 
 	if (ret < 0)
@@ -1000,7 +1271,7 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 	do {
 		ctx.selected_sk = NULL;
 		retval = BPF_PROG_SK_LOOKUP_RUN_ARRAY(progs, ctx, bpf_prog_run);
-	} while (bpf_test_timer_continue(&t, repeat, &ret, &duration));
+	} while (bpf_test_timer_continue(&t, 1, repeat, &ret, &duration));
 	bpf_test_timer_leave(&t);
 
 	if (ret < 0)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b0383d371b9a..5ef20deaf49f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1225,6 +1225,8 @@ enum {
 
 /* If set, run the test on the cpu specified by bpf_attr.test.cpu */
 #define BPF_F_TEST_RUN_ON_CPU	(1U << 0)
+/* If set, XDP frames will be transmitted after processing */
+#define BPF_F_TEST_XDP_LIVE_FRAMES	(1U << 1)
 
 /* type for BPF_ENABLE_STATS */
 enum bpf_stats_type {
-- 
2.34.1


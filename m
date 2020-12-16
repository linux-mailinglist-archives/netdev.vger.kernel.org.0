Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6EB72DC233
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 15:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgLPObj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 09:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgLPObj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 09:31:39 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BE2C0617A6;
        Wed, 16 Dec 2020 06:30:58 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id hk16so1706155pjb.4;
        Wed, 16 Dec 2020 06:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uDGzZrwaFErNtNIsPs1ybtzqRdKD5oPPG000GGXZziE=;
        b=tFTvRZg0f37D0V7XFgU5CF+mtAYQ71jDf/U5Ou8hm8HsuSr2MNa+9Yprpe0doGWfFQ
         awvWD/adRJF7KjmAITChj5Oxm0VxwouK4EXu2GLo4wr48Zt/dKmoT+EwnV5/q+OSotjb
         x/YKFu/5aKrcWKoHPPitk0a5Y3VsyAy327+7E4lm8kFi5tv47WBEspgBx+/CFXvFW1I6
         eB65J6GJM9BjESkY7hRLDmnQehRDuAevmhHt2nTnyFM2Rhv2NccDbBHMCiZVmjk7U1EG
         whSk5Yc8c+HB3d+s8HzYVIsAjtUGi3u+NbqBFavGcqSJhamQrSWDCWXnUFjUR9B22Lqv
         FRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uDGzZrwaFErNtNIsPs1ybtzqRdKD5oPPG000GGXZziE=;
        b=UP5Q1HC5WZjzyowabHt+hrZdW2wKEJE9Nl1+H1opmTnA+qpTQp0c22LaAcpj73LB1M
         10oMZeEXDyir/HjHXs8hTbKenFT9u2fZnZxZDTzD/fz/+kqXPOhXjsZarreUipTzRtSg
         6jnmWxPsjUdYerdviYaDAWwrhgLlGdgOHXAWKTJ5hZGLDR4f9B+EuWkc5aq7xVd576rK
         Aw27IzCHH916YgY8KZdpRte1YZTpZxZ8eePMCKJCoyuo7ZlUeISeg7pJVkyk6zZ7Iw9L
         wlzPfPGdRwn7d4LmxDwHXHtHEGH9U0yGCk2wqj/HWYbSP8TnoHOCqSU80KdQypEKw3Yi
         hDkA==
X-Gm-Message-State: AOAM533Dg0SUjJSBorvzyxb+9PMOztIpPqZRfP5XeeRixijy/x05j6Zs
        DGfxqpDUEVAdER9jwzyEydNihmaFSCZDiBbt
X-Google-Smtp-Source: ABdhPJzeoJVbJK4q5AmGtmNQMAf+khBQRwgW3WIeU4OInrt/FT+usb8YAWjh/tzGpGJ3/eTlnx5Hcg==
X-Received: by 2002:a17:90a:6705:: with SMTP id n5mr3315475pjj.215.1608129058091;
        Wed, 16 Dec 2020 06:30:58 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a141sm2858802pfa.189.2020.12.16.06.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 06:30:57 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCHv12 bpf-next 1/6] bpf: run devmap xdp_prog on flush instead of bulk enqueue
Date:   Wed, 16 Dec 2020 22:30:31 +0800
Message-Id: <20201216143036.2296568-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216143036.2296568-1-liuhangbin@gmail.com>
References: <20200907082724.1721685-1-liuhangbin@gmail.com>
 <20201216143036.2296568-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

This changes the devmap XDP program support to run the program when the
bulk queue is flushed instead of before the frame is enqueued. This has
a couple of benefits:

- It "sorts" the packets by destination devmap entry, and then runs the
  same BPF program on all the packets in sequence. This ensures that we
  keep the XDP program and destination device properties hot in I-cache.

- It makes the multicast implementation simpler because it can just
  enqueue packets using bq_enqueue() without having to deal with the
  devmap program at all.

The drawback is that if the devmap program drops the packet, the enqueue
step is redundant. However, arguably this is mostly visible in a
micro-benchmark, and with more mixed traffic the I-cache benefit should
win out. The performance impact of just this patch is as follows:

Using xdp_redirect_map(with a 2nd xdp_prog patch[1]) in sample/bpf and send
pkts via pktgen cmd:
./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64

There are about +/- 0.1M deviation for native testing, the performance
improved for the base-case, but some drop back with xdp devmap prog attached.

Version          | Test                           | Generic | Native | Native + 2nd xdp_prog
5.10 rc6         | xdp_redirect_map   i40e->i40e  |    2.0M |   9.1M |  8.0M
5.10 rc6         | xdp_redirect_map   i40e->veth  |    1.7M |  11.0M |  9.7M
5.10 rc6 + patch | xdp_redirect_map   i40e->i40e  |    2.0M |   9.5M |  7.5M
5.10 rc6 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  11.6M |  9.1M

[1] https://patchwork.ozlabs.org/project/netdev/patch/20201208120159.2278277-1-liuhangbin@gmail.com/

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Hangbin Liu <haliu@redhat.com>
---
 kernel/bpf/devmap.c | 116 ++++++++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 43 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f6e9c68afdd4..2a83232cf63a 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -57,6 +57,7 @@ struct xdp_dev_bulk_queue {
 	struct list_head flush_node;
 	struct net_device *dev;
 	struct net_device *dev_rx;
+	struct bpf_prog *xdp_prog;
 	unsigned int count;
 };
 
@@ -327,40 +328,92 @@ bool dev_map_can_have_prog(struct bpf_map *map)
 	return false;
 }
 
+static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
+				struct xdp_frame **frames, int n,
+				struct net_device *dev)
+{
+	struct xdp_txq_info txq = { .dev = dev };
+	struct xdp_buff xdp;
+	int i, nframes = 0;
+
+	for (i = 0; i < n; i++) {
+		struct xdp_frame *xdpf = frames[i];
+		u32 act;
+		int err;
+
+		xdp_convert_frame_to_buff(xdpf, &xdp);
+		xdp.txq = &txq;
+
+		act = bpf_prog_run_xdp(xdp_prog, &xdp);
+		switch (act) {
+		case XDP_PASS:
+			err = xdp_update_frame_from_buff(&xdp, xdpf);
+			if (unlikely(err < 0))
+				xdp_return_frame_rx_napi(xdpf);
+			else
+				frames[nframes++] = xdpf;
+			break;
+		default:
+			bpf_warn_invalid_xdp_action(act);
+			fallthrough;
+		case XDP_ABORTED:
+			trace_xdp_exception(dev, xdp_prog, act);
+			fallthrough;
+		case XDP_DROP:
+			xdp_return_frame_rx_napi(xdpf);
+			break;
+		}
+	}
+	return n - nframes; /* dropped frames count */
+}
+
 static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 {
 	struct net_device *dev = bq->dev;
 	int sent = 0, drops = 0, err = 0;
+	unsigned int cnt = bq->count;
+	unsigned int xdp_drop;
 	int i;
 
-	if (unlikely(!bq->count))
+	if (unlikely(!cnt))
 		return;
 
-	for (i = 0; i < bq->count; i++) {
+	for (i = 0; i < cnt; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
 
 		prefetch(xdpf);
 	}
 
-	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
+	if (unlikely(bq->xdp_prog)) {
+		xdp_drop = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
+		cnt -= xdp_drop;
+		if (!cnt) {
+			sent = 0;
+			drops = xdp_drop;
+			goto out;
+		}
+	}
+
+	sent = dev->netdev_ops->ndo_xdp_xmit(dev, cnt, bq->q, flags);
 	if (sent < 0) {
 		err = sent;
 		sent = 0;
 		goto error;
 	}
-	drops = bq->count - sent;
+	drops = (cnt - sent) + xdp_drop;
 out:
 	bq->count = 0;
 
 	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
 	bq->dev_rx = NULL;
+	bq->xdp_prog = NULL;
 	__list_del_clearprev(&bq->flush_node);
 	return;
 error:
 	/* If ndo_xdp_xmit fails with an errno, no frames have been
 	 * xmit'ed and it's our responsibility to them free all.
 	 */
-	for (i = 0; i < bq->count; i++) {
+	for (i = 0; i < cnt; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
 
 		xdp_return_frame_rx_napi(xdpf);
@@ -408,7 +461,8 @@ struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
  * Thus, safe percpu variable access.
  */
 static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
-		       struct net_device *dev_rx)
+		       struct net_device *dev_rx,
+		       struct bpf_dtab_netdev *dst)
 {
 	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
 	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
@@ -423,6 +477,14 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 	if (!bq->dev_rx)
 		bq->dev_rx = dev_rx;
 
+	/* Store (potential) xdp_prog that run before egress to dev as
+	 * part of bulk_queue.  This will be same xdp_prog for all
+	 * xdp_frame's in bulk_queue, because this per-CPU store must
+	 * be flushed from net_device drivers NAPI func end.
+	 */
+	if (dst && dst->xdp_prog && !bq->xdp_prog)
+		bq->xdp_prog = dst->xdp_prog;
+
 	bq->q[bq->count++] = xdpf;
 
 	if (!bq->flush_node.prev)
@@ -430,7 +492,8 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 }
 
 static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
-			       struct net_device *dev_rx)
+				struct net_device *dev_rx,
+				struct bpf_dtab_netdev *dst)
 {
 	struct xdp_frame *xdpf;
 	int err;
@@ -446,42 +509,14 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 	if (unlikely(!xdpf))
 		return -EOVERFLOW;
 
-	bq_enqueue(dev, xdpf, dev_rx);
+	bq_enqueue(dev, xdpf, dev_rx, dst);
 	return 0;
 }
 
-static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
-					 struct xdp_buff *xdp,
-					 struct bpf_prog *xdp_prog)
-{
-	struct xdp_txq_info txq = { .dev = dev };
-	u32 act;
-
-	xdp_set_data_meta_invalid(xdp);
-	xdp->txq = &txq;
-
-	act = bpf_prog_run_xdp(xdp_prog, xdp);
-	switch (act) {
-	case XDP_PASS:
-		return xdp;
-	case XDP_DROP:
-		break;
-	default:
-		bpf_warn_invalid_xdp_action(act);
-		fallthrough;
-	case XDP_ABORTED:
-		trace_xdp_exception(dev, xdp_prog, act);
-		break;
-	}
-
-	xdp_return_buff(xdp);
-	return NULL;
-}
-
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx)
 {
-	return __xdp_enqueue(dev, xdp, dev_rx);
+	return __xdp_enqueue(dev, xdp, dev_rx, NULL);
 }
 
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
@@ -489,12 +524,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 {
 	struct net_device *dev = dst->dev;
 
-	if (dst->xdp_prog) {
-		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
-		if (!xdp)
-			return 0;
-	}
-	return __xdp_enqueue(dev, xdp, dev_rx);
+	return __xdp_enqueue(dev, xdp, dev_rx, dst);
 }
 
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
-- 
2.26.2


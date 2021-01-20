Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEF92FC99E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730738AbhATDyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730864AbhATC2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 21:28:43 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE7BC0613D6;
        Tue, 19 Jan 2021 18:28:03 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id l23so1193511pjg.1;
        Tue, 19 Jan 2021 18:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8fQEO4QO5/RGui7aesEyuwSZ1P0QlTC8wEfVD39fdmc=;
        b=LPpGHcSFCYi21TtMW1mevZ8bLQc07PZEJhKofXsLVgxaakmUtgZ4idH9gG0vXZWWhU
         hE7XCyPvQ8/f2+PO6enXvmCHMVCP3soVCqhhPtoqLglEPIVYJdhTFJYiRjGXXNAUAoTw
         lDYlYLa5uyCpQUNGf4yNN2yWbhYmxajlWlCd8QcI+YGb1LVw9vCfbA5UEGcep7mg2pcU
         wbmYrXwaPLEfrDvi+lZ49IG5Q/CZPBEblBSSwAwycW48zybT0x6M+w7+ZHJFnFnFysXu
         WKyvr+ns2xd8Rdy/vG+2KnkjyhGtvGOFQw9TwYJMI6/tLKWemJi9abbFzGD39AGjqWxb
         IX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8fQEO4QO5/RGui7aesEyuwSZ1P0QlTC8wEfVD39fdmc=;
        b=cx9SpK/Xqnh9qXXKlqRCq1pe4vdAMFE47JcLak4izz979z9n7ZO2imMZDufFpaqJWR
         J/SRjF617nHfGnR3QTHFOzJ6wlj2RyTFA1s+y6hjTSAoARBvQ60IAUGDPAaCyo5TfoI8
         M17T0M3c1UCT8M674f9CLmh/Wm+av5ofQsARssucBReq5NOo77WuxJ3GqqwJYlS2JEkd
         bNH9DXMr1gbVVFh9MWRoNmjAxTaHB9edwycR/7O82VrXlB6tVCtiIA/5pWF0JolAatYU
         tDGacYMXezd/DNVmRZtV5WvjCd7YGohNR0BcaU17NJQDoHSGgXoDKp64dRggFZ5ZmKCa
         KfZA==
X-Gm-Message-State: AOAM5323fmdL3C2Z57pfIsSLe7bEKw5QBVwrlB+nSFhTMgia0Ti7X3+6
        JoMPG8/fwKtVLsY8DgQlrGusqcnHa9jjHHOO
X-Google-Smtp-Source: ABdhPJxMRO96oTaDZpsNY2y6AwNd70qtk9DvrpkSHhJUSdUYqHzYuBzZOnsqMCxB4dM66epLZZX2Yw==
X-Received: by 2002:a17:902:be11:b029:da:ba30:5791 with SMTP id r17-20020a170902be11b02900daba305791mr7683371pls.13.1611109682746;
        Tue, 19 Jan 2021 18:28:02 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 124sm378976pfd.59.2021.01.19.18.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 18:28:02 -0800 (PST)
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
        John Fastabend <john.fastabend@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv15 bpf-next 1/6] bpf: run devmap xdp_prog on flush instead of bulk enqueue
Date:   Wed, 20 Jan 2021 10:25:09 +0800
Message-Id: <20210120022514.2862872-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210120022514.2862872-1-liuhangbin@gmail.com>
References: <20210114142321.2594697-1-liuhangbin@gmail.com>
 <20210120022514.2862872-1-liuhangbin@gmail.com>
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
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v15:
a) do not use unlikely when checking bq->xdp_prog
b) return sent frames for dev_map_bpf_prog_run()

v14: no update, only rebase the code
v13: pass in xdp_prog through __xdp_enqueue()
v2-v12: no this patch
---
 kernel/bpf/devmap.c | 116 +++++++++++++++++++++++++++-----------------
 1 file changed, 71 insertions(+), 45 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f6e9c68afdd4..13ed68c24aad 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -57,6 +57,7 @@ struct xdp_dev_bulk_queue {
 	struct list_head flush_node;
 	struct net_device *dev;
 	struct net_device *dev_rx;
+	struct bpf_prog *xdp_prog;
 	unsigned int count;
 };
 
@@ -327,44 +328,93 @@ bool dev_map_can_have_prog(struct bpf_map *map)
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
+	return nframes; /* sent frames count */
+}
+
 static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 {
 	struct net_device *dev = bq->dev;
 	int sent = 0, drops = 0, err = 0;
+	unsigned int cnt = bq->count;
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
+	/* Init sent to cnt in case there is no xdp_prog */
+	sent = cnt;
+	if (bq->xdp_prog) {
+		sent = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
+		if (!sent)
+			goto out;
+	}
+
+	/* Backup drops value before xmit as we may need it in error label */
+	drops = cnt - sent;
+	sent = dev->netdev_ops->ndo_xdp_xmit(dev, sent, bq->q, flags);
 	if (sent < 0) {
 		err = sent;
 		sent = 0;
 		goto error;
 	}
-	drops = bq->count - sent;
 out:
+	drops = cnt - sent;
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
+	for (i = 0; i < cnt - drops; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
-
 		xdp_return_frame_rx_napi(xdpf);
-		drops++;
 	}
 	goto out;
 }
@@ -408,7 +458,7 @@ struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
  * Thus, safe percpu variable access.
  */
 static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
-		       struct net_device *dev_rx)
+		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
 {
 	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
 	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
@@ -423,6 +473,14 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 	if (!bq->dev_rx)
 		bq->dev_rx = dev_rx;
 
+	/* Store (potential) xdp_prog that run before egress to dev as
+	 * part of bulk_queue.  This will be same xdp_prog for all
+	 * xdp_frame's in bulk_queue, because this per-CPU store must
+	 * be flushed from net_device drivers NAPI func end.
+	 */
+	if (!bq->xdp_prog)
+		bq->xdp_prog = xdp_prog;
+
 	bq->q[bq->count++] = xdpf;
 
 	if (!bq->flush_node.prev)
@@ -430,7 +488,8 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 }
 
 static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
-			       struct net_device *dev_rx)
+				struct net_device *dev_rx,
+				struct bpf_prog *xdp_prog)
 {
 	struct xdp_frame *xdpf;
 	int err;
@@ -446,42 +505,14 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 	if (unlikely(!xdpf))
 		return -EOVERFLOW;
 
-	bq_enqueue(dev, xdpf, dev_rx);
+	bq_enqueue(dev, xdpf, dev_rx, xdp_prog);
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
@@ -489,12 +520,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 {
 	struct net_device *dev = dst->dev;
 
-	if (dst->xdp_prog) {
-		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
-		if (!xdp)
-			return 0;
-	}
-	return __xdp_enqueue(dev, xdp, dev_rx);
+	return __xdp_enqueue(dev, xdp, dev_rx, dst->xdp_prog);
 }
 
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
-- 
2.26.2


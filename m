Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ACF35F3BD
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 14:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350923AbhDNM0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 08:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350915AbhDNM0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 08:26:53 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284FAC061574;
        Wed, 14 Apr 2021 05:26:32 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id k8so14280762pgf.4;
        Wed, 14 Apr 2021 05:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/0sfh7GVqgUxY3f5MSx0Gyl1f/wuAMxVtw7tZG1KjsI=;
        b=h/L6u3jnbKCVlS1QHVJjCJaQ9V0VooBMzb2YipmWhWg4DU0Xl+Plo67/0FcQatSwrc
         ps9WWpoLAK/v5/lGMGRJbnueAt3NBt6/SzVZFOjrZgQdwGptBFYXEXElU0qArkQ/sf3g
         3pVcSO/6BNgpJvDKdOuTTXJvJA5VweEGj1Wz2mVr93aj3I5mOYHE1VTxc6h4po3lngCD
         Dg0QV66oHaQCbiWOAcLLhcfmeBYIxHMDYWr7voHPtEepJH7Ii0/bN5GNpD7M90fbntdY
         +f3od79MReAGuRGUumdv84SMK0pZnc052S9hqLwX5rLdf5ati+srg2ShJOsZYXBeZtzL
         JjCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/0sfh7GVqgUxY3f5MSx0Gyl1f/wuAMxVtw7tZG1KjsI=;
        b=LdPzR8YAITWP/xXrB3eE4c+Mi2/9hQCIdtO1dSWdFb/vt+QeySxLexxmB/snBZTvDz
         DKpR5dfJn+c2atF5Vh/JRSi6VHunJtsJtMYw61XXHBgLa4LlTtMzIKPwdK4sdk3vasSH
         rnKm0hNSnQaao5Fse8KqqqV4vl1hY7CK+VA26cnnGJohXlQBxFUv+5sk7OcGZXJESOJL
         O/gmLQQgWETodyi9TJPovMsKwRX1JurYXupJTYkAN99eLVdLPH0RQvLC09071Y5B/Dyr
         4KmqhQjvXcJnWd8lQujxel8Sb26+JuIdSephrOg/Wz72MA/fSC9j4DKrPlF+TgYDWVVY
         3GFQ==
X-Gm-Message-State: AOAM533qUxOUmEGgwpnu29ZY/amfSUeNVrJN0PcTEl35xU0NVKkchJuq
        50DsEBC97lqYLkYWF2atwhNJe0uiioxTYA==
X-Google-Smtp-Source: ABdhPJz7nmSeOcEjBFEknEL0Hyu/hPuGypP3vRqZVO7tlrakquQLRVdMD1rRO6muShDnEogrBdfnjA==
X-Received: by 2002:aa7:97ae:0:b029:24b:3b0f:b2c2 with SMTP id d14-20020aa797ae0000b029024b3b0fb2c2mr16868662pfq.38.1618403191479;
        Wed, 14 Apr 2021 05:26:31 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b23sm4789308pju.0.2021.04.14.05.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 05:26:31 -0700 (PDT)
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
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush instead of bulk enqueue
Date:   Wed, 14 Apr 2021 20:26:07 +0800
Message-Id: <20210414122610.4037085-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210414122610.4037085-1-liuhangbin@gmail.com>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
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

When bq_xmit_all() is called from bq_enqueue(), another packet will
always be enqueued immediately after, so clearing dev_rx, xdp_prog and
flush_node in bq_xmit_all() is redundant. Move the clear to __dev_flush(),
and only check them once in bq_enqueue() since they are all modified
together.

Using 10Gb i40e NIC, do XDP_DROP on veth peer, with xdp_redirect_map in
sample/bpf, send pkts via pktgen cmd:
./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64

There are about +/- 0.1M deviation for native testing, the performance
improved for the base-case, but some drop back with xdp devmap prog attached.

Version          | Test                           | Generic | Native | Native + 2nd xdp_prog
5.12 rc4         | xdp_redirect_map   i40e->i40e  |    1.9M |   9.6M |  8.4M
5.12 rc4         | xdp_redirect_map   i40e->veth  |    1.7M |  11.7M |  9.8M
5.12 rc4 + patch | xdp_redirect_map   i40e->i40e  |    1.9M |   9.8M |  8.0M
5.12 rc4 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  12.0M |  9.4M

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v3: rebase the code based on Lorenzo's "Move drop error path to devmap
    for XDP_REDIRECT"
v2: no update
---
 kernel/bpf/devmap.c | 127 ++++++++++++++++++++++++++------------------
 1 file changed, 76 insertions(+), 51 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index aa516472ce46..3980fb3bfb09 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -57,6 +57,7 @@ struct xdp_dev_bulk_queue {
 	struct list_head flush_node;
 	struct net_device *dev;
 	struct net_device *dev_rx;
+	struct bpf_prog *xdp_prog;
 	unsigned int count;
 };
 
@@ -326,22 +327,71 @@ bool dev_map_can_have_prog(struct bpf_map *map)
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
-	int sent = 0, err = 0;
+	int sent = 0, drops = 0, err = 0;
+	unsigned int cnt = bq->count;
+	int to_send = cnt;
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
+	if (bq->xdp_prog) {
+		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
+		if (!to_send)
+			goto out;
+
+		drops = cnt - to_send;
+	}
+
+	sent = dev->netdev_ops->ndo_xdp_xmit(dev, to_send, bq->q, flags);
 	if (sent < 0) {
 		/* If ndo_xdp_xmit fails with an errno, no frames have
 		 * been xmit'ed.
@@ -353,13 +403,13 @@ static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 	/* If not all frames have been transmitted, it is our
 	 * responsibility to free them
 	 */
-	for (i = sent; unlikely(i < bq->count); i++)
+	for (i = sent; unlikely(i < to_send); i++)
 		xdp_return_frame_rx_napi(bq->q[i]);
 
-	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, bq->count - sent, err);
-	bq->dev_rx = NULL;
+out:
+	drops = cnt - sent;
 	bq->count = 0;
-	__list_del_clearprev(&bq->flush_node);
+	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
 }
 
 /* __dev_flush is called from xdp_do_flush() which _must_ be signaled
@@ -377,8 +427,12 @@ void __dev_flush(void)
 	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
 	struct xdp_dev_bulk_queue *bq, *tmp;
 
-	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
+	list_for_each_entry_safe(bq, tmp, flush_list, flush_node) {
 		bq_xmit_all(bq, XDP_XMIT_FLUSH);
+		bq->dev_rx = NULL;
+		bq->xdp_prog = NULL;
+		__list_del_clearprev(&bq->flush_node);
+	}
 }
 
 /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or
@@ -401,7 +455,7 @@ static void *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
  * Thus, safe percpu variable access.
  */
 static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
-		       struct net_device *dev_rx)
+		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
 {
 	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
 	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
@@ -412,18 +466,22 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 	/* Ingress dev_rx will be the same for all xdp_frame's in
 	 * bulk_queue, because bq stored per-CPU and must be flushed
 	 * from net_device drivers NAPI func end.
+	 *
+	 * Do the same with xdp_prog and flush_list since these fields
+	 * are only ever modified together.
 	 */
-	if (!bq->dev_rx)
+	if (!bq->dev_rx) {
 		bq->dev_rx = dev_rx;
+		bq->xdp_prog = xdp_prog;
+		list_add(&bq->flush_node, flush_list);
+	}
 
 	bq->q[bq->count++] = xdpf;
-
-	if (!bq->flush_node.prev)
-		list_add(&bq->flush_node, flush_list);
 }
 
 static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
-			       struct net_device *dev_rx)
+				struct net_device *dev_rx,
+				struct bpf_prog *xdp_prog)
 {
 	struct xdp_frame *xdpf;
 	int err;
@@ -439,42 +497,14 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
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
@@ -482,12 +512,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
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
2.26.3


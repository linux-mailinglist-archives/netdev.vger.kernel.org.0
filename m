Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FDF6C7212
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 22:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjCWVCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 17:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCWVCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 17:02:13 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E2F46B6
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 14:02:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y4so397246edo.2
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 14:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fr24.com; s=google; t=1679605328;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V4ZmO35qTQPfyZjSIRHs+EQr66f7xUa5vRniaAVKOUU=;
        b=OWuSK7pOmjWXjTCOHwuzVN4s4BMwm3Nq9k+FPa9z8hyhzv23GT2/tyyFPVmBwHITRr
         YMARrilCI0wKuub0JwIFckBK8abS/jTuULIXSOvuuRByWUGpjWrmr66WxrIkWXjwXYAv
         F+UggTgs9ERadUe2tWNKHIy1CMtH0L2PtVHu/Pp4KdehPEm9S8P3oO4C75eKhUU2tNpD
         jiklE3Cil8Ld/CPtP1MCD3RCDbamMv1HQhI1FeuCbes61B4JmtNgSMBpkYeyq81lc5Kl
         bxgaBkVqfj2q/JcO7UxODHP1Ar/DcJ9qJVHTOdU/FxRLPHOEi8vW0jAqZzVHyAaT6NbH
         rPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679605328;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V4ZmO35qTQPfyZjSIRHs+EQr66f7xUa5vRniaAVKOUU=;
        b=Ngz3tx7RihGtVcEQVjXHWrEVvmAL8LotYrTtIa2HqO1qVocwDgrd/ihgZQEEMkrVSC
         66FjXsYvS55HLUZnxxQXqxdhWpjICNfXwh9qWD1uO7o0kABi+UYRbzglMabn4tG3KPdp
         CZYp7RpHYnjGOs+20p26jhWTMzxmdzpS0ISVlNrDeGOsZ3CvGuhC011VTs5r2HtTKGUr
         a/f2y9/402MV2vgDKUxoi9pYTy7XPdkd3+h81I8jX15myyxUTgQJ9Rv0pfYsKxYCWS7t
         c6hINvIzND80XXsCyl5R2hUqvooHgiLkpoBKf6VFgPAb8k9OQDa3tRQI/nQDN21iMdI2
         ul3w==
X-Gm-Message-State: AAQBX9dQ4XXNpnFAm9rkLPXL4MLL9aYO8vNXiVaui7OM40nBOfmuwk3L
        1VQSkajutNyrEP+LWuCMkC7exOwRo9YUi/C+mSwNVQ==
X-Google-Smtp-Source: AKy350Yu5LjEF4SU6TPfME5H9yLHZ9pD5t1g7ZHHFiJWD5M1jiu0U7M41pt6loerSuoyLpQrNxCvLw==
X-Received: by 2002:a17:907:6e04:b0:930:3916:df17 with SMTP id sd4-20020a1709076e0400b009303916df17mr615774ejc.0.1679605325492;
        Thu, 23 Mar 2023 14:02:05 -0700 (PDT)
Received: from sky20.lan (bl20-118-143.dsl.telepac.pt. [2.81.118.143])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170906924500b0092be625d981sm9155546ejx.91.2023.03.23.14.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 14:02:04 -0700 (PDT)
From:   =?UTF-8?q?Nuno=20Gon=C3=A7alves?= <nunog@fr24.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?q?Nuno=20Gon=C3=A7alves?= <nunog@fr24.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next V3] xsk: allow remap of fill and/or completion rings
Date:   Thu, 23 Mar 2023 21:01:24 +0000
Message-Id: <20230323210125.10880-1-nunog@fr24.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The remap of fill and completion rings was frowned upon as they
control the usage of UMEM which does not support concurrent use.
At the same time this would disallow the remap of these rings
into another process.

A possible use case is that the user wants to transfer the socket/
UMEM ownership to another process (via SYS_pidfd_getfd) and so
would need to also remap these rings.

This will have no impact on current usages and just relaxes the
remap limitation.

Signed-off-by: Nuno Gonçalves <nunog@fr24.com>
---
 net/xdp/xsk.c | 166 +++++++++++++++++++++++++-------------------------
 1 file changed, 84 insertions(+), 82 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 2ac58b282b5eb..1878ae6a6db3b 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -122,8 +122,7 @@ void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id)
 int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
 			u16 queue_id)
 {
-	if (queue_id >= max_t(unsigned int,
-			      dev->real_num_rx_queues,
+	if (queue_id >= max_t(unsigned int, dev->real_num_rx_queues,
 			      dev->real_num_tx_queues))
 		return -EINVAL;
 
@@ -344,7 +343,8 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 }
 EXPORT_SYMBOL(xsk_tx_peek_desc);
 
-static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, u32 max_entries)
+static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool,
+					u32 max_entries)
 {
 	struct xdp_desc *descs = pool->tx_descs;
 	u32 nb_pkts = 0;
@@ -367,7 +367,8 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 nb_pkts)
 		return xsk_tx_peek_release_fallback(pool, nb_pkts);
 	}
 
-	xs = list_first_or_null_rcu(&pool->xsk_tx_list, struct xdp_sock, tx_list);
+	xs = list_first_or_null_rcu(&pool->xsk_tx_list, struct xdp_sock,
+				    tx_list);
 	if (!xs) {
 		nb_pkts = 0;
 		goto out;
@@ -469,8 +470,7 @@ static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 	return skb;
 }
 
-static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
-				     struct xdp_desc *desc)
+static struct sk_buff *xsk_build_skb(struct xdp_sock *xs, struct xdp_desc *desc)
 {
 	struct net_device *dev = xs->dev;
 	struct sk_buff *skb;
@@ -561,7 +561,7 @@ static int __xsk_generic_xmit(struct sock *sk)
 		}
 
 		err = __dev_direct_xmit(skb, xs->queue_id);
-		if  (err == NETDEV_TX_BUSY) {
+		if (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
 			skb->destructor = sock_wfree;
 			spin_lock_irqsave(&xs->pool->cq_lock, flags);
@@ -612,8 +612,9 @@ static bool xsk_no_wakeup(struct sock *sk)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	/* Prefer busy-polling, skip the wakeup. */
-	return READ_ONCE(sk->sk_prefer_busy_poll) && READ_ONCE(sk->sk_ll_usec) &&
-		READ_ONCE(sk->sk_napi_id) >= MIN_NAPI_ID;
+	return READ_ONCE(sk->sk_prefer_busy_poll) &&
+	       READ_ONCE(sk->sk_ll_usec) &&
+	       READ_ONCE(sk->sk_napi_id) >= MIN_NAPI_ID;
 #else
 	return false;
 #endif
@@ -629,7 +630,8 @@ static int xsk_check_common(struct xdp_sock *xs)
 	return 0;
 }
 
-static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
+static int __xsk_sendmsg(struct socket *sock, struct msghdr *m,
+			 size_t total_len)
 {
 	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
 	struct sock *sk = sock->sk;
@@ -647,7 +649,8 @@ static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len
 
 	if (sk_can_busy_loop(sk)) {
 		if (xs->zc)
-			__sk_mark_napi_id_once(sk, xsk_pool_get_napi_id(xs->pool));
+			__sk_mark_napi_id_once(sk,
+					       xsk_pool_get_napi_id(xs->pool));
 		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
 	}
 
@@ -674,7 +677,8 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	return ret;
 }
 
-static int __xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
+static int __xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len,
+			 int flags)
 {
 	bool need_wait = !(flags & MSG_DONTWAIT);
 	struct sock *sk = sock->sk;
@@ -700,7 +704,8 @@ static int __xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int
 	return 0;
 }
 
-static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
+static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len,
+		       int flags)
 {
 	int ret;
 
@@ -712,7 +717,7 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
 }
 
 static __poll_t xsk_poll(struct file *file, struct socket *sock,
-			     struct poll_table_struct *wait)
+			 struct poll_table_struct *wait)
 {
 	__poll_t mask = 0;
 	struct sock *sk = sock->sk;
@@ -777,8 +782,8 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 	dev_put(dev);
 }
 
-static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
-					      struct xdp_sock __rcu ***map_entry)
+static struct xsk_map *
+xsk_get_map_list_entry(struct xdp_sock *xs, struct xdp_sock __rcu ***map_entry)
 {
 	struct xsk_map *map = NULL;
 	struct xsk_map_node *node;
@@ -895,8 +900,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		return -EINVAL;
 
 	flags = sxdp->sxdp_flags;
-	if (flags & ~(XDP_SHARED_UMEM | XDP_COPY | XDP_ZEROCOPY |
-		      XDP_USE_NEED_WAKEUP))
+	if (flags &
+	    ~(XDP_SHARED_UMEM | XDP_COPY | XDP_ZEROCOPY | XDP_USE_NEED_WAKEUP))
 		return -EINVAL;
 
 	rtnl_lock();
@@ -953,16 +958,14 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			/* Share the umem with another socket on another qid
 			 * and/or device.
 			 */
-			xs->pool = xp_create_and_assign_umem(xs,
-							     umem_xs->umem);
+			xs->pool = xp_create_and_assign_umem(xs, umem_xs->umem);
 			if (!xs->pool) {
 				err = -ENOMEM;
 				sockfd_put(sock);
 				goto out_unlock;
 			}
 
-			err = xp_assign_dev_shared(xs->pool, umem_xs, dev,
-						   qid);
+			err = xp_assign_dev_shared(xs->pool, umem_xs, dev, qid);
 			if (err) {
 				xp_destroy(xs->pool);
 				xs->pool = NULL;
@@ -1061,8 +1064,7 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case XDP_RX_RING:
-	case XDP_TX_RING:
-	{
+	case XDP_TX_RING: {
 		struct xsk_queue **q;
 		int entries;
 
@@ -1084,8 +1086,7 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 		mutex_unlock(&xs->mutex);
 		return err;
 	}
-	case XDP_UMEM_REG:
-	{
+	case XDP_UMEM_REG: {
 		size_t mr_size = sizeof(struct xdp_umem_reg);
 		struct xdp_umem_reg mr = {};
 		struct xdp_umem *umem;
@@ -1117,8 +1118,7 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 		return 0;
 	}
 	case XDP_UMEM_FILL_RING:
-	case XDP_UMEM_COMPLETION_RING:
-	{
+	case XDP_UMEM_COMPLETION_RING: {
 		struct xsk_queue **q;
 		int entries;
 
@@ -1131,8 +1131,7 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			return -EBUSY;
 		}
 
-		q = (optname == XDP_UMEM_FILL_RING) ? &xs->fq_tmp :
-			&xs->cq_tmp;
+		q = (optname == XDP_UMEM_FILL_RING) ? &xs->fq_tmp : &xs->cq_tmp;
 		err = xsk_init_queue(entries, q, true);
 		mutex_unlock(&xs->mutex);
 		return err;
@@ -1180,8 +1179,7 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 		return -EINVAL;
 
 	switch (optname) {
-	case XDP_STATISTICS:
-	{
+	case XDP_STATISTICS: {
 		struct xdp_statistics stats = {};
 		bool extra_stats = true;
 		size_t stats_size;
@@ -1200,8 +1198,11 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 		if (extra_stats) {
 			stats.rx_ring_full = xs->rx_queue_full;
 			stats.rx_fill_ring_empty_descs =
-				xs->pool ? xskq_nb_queue_empty_descs(xs->pool->fq) : 0;
-			stats.tx_ring_empty_descs = xskq_nb_queue_empty_descs(xs->tx);
+				xs->pool ? xskq_nb_queue_empty_descs(
+						   xs->pool->fq) :
+					   0;
+			stats.tx_ring_empty_descs =
+				xskq_nb_queue_empty_descs(xs->tx);
 		} else {
 			stats.rx_dropped += xs->rx_queue_full;
 		}
@@ -1216,8 +1217,7 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 
 		return 0;
 	}
-	case XDP_MMAP_OFFSETS:
-	{
+	case XDP_MMAP_OFFSETS: {
 		struct xdp_mmap_offsets off;
 		struct xdp_mmap_offsets_v1 off_v1;
 		bool flags_supported = true;
@@ -1232,22 +1232,22 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 			/* xdp_ring_offset is identical to xdp_ring_offset_v1
 			 * except for the flags field added to the end.
 			 */
-			xsk_enter_rxtx_offsets((struct xdp_ring_offset_v1 *)
-					       &off.rx);
-			xsk_enter_rxtx_offsets((struct xdp_ring_offset_v1 *)
-					       &off.tx);
-			xsk_enter_umem_offsets((struct xdp_ring_offset_v1 *)
-					       &off.fr);
-			xsk_enter_umem_offsets((struct xdp_ring_offset_v1 *)
-					       &off.cr);
-			off.rx.flags = offsetof(struct xdp_rxtx_ring,
-						ptrs.flags);
-			off.tx.flags = offsetof(struct xdp_rxtx_ring,
-						ptrs.flags);
-			off.fr.flags = offsetof(struct xdp_umem_ring,
-						ptrs.flags);
-			off.cr.flags = offsetof(struct xdp_umem_ring,
-						ptrs.flags);
+			xsk_enter_rxtx_offsets(
+				(struct xdp_ring_offset_v1 *)&off.rx);
+			xsk_enter_rxtx_offsets(
+				(struct xdp_ring_offset_v1 *)&off.tx);
+			xsk_enter_umem_offsets(
+				(struct xdp_ring_offset_v1 *)&off.fr);
+			xsk_enter_umem_offsets(
+				(struct xdp_ring_offset_v1 *)&off.cr);
+			off.rx.flags =
+				offsetof(struct xdp_rxtx_ring, ptrs.flags);
+			off.tx.flags =
+				offsetof(struct xdp_rxtx_ring, ptrs.flags);
+			off.fr.flags =
+				offsetof(struct xdp_umem_ring, ptrs.flags);
+			off.cr.flags =
+				offsetof(struct xdp_umem_ring, ptrs.flags);
 
 			len = sizeof(off);
 			to_copy = &off;
@@ -1268,8 +1268,7 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 
 		return 0;
 	}
-	case XDP_OPTIONS:
-	{
+	case XDP_OPTIONS: {
 		struct xdp_options opts = {};
 
 		if (len < sizeof(opts))
@@ -1301,9 +1300,10 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	loff_t offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long size = vma->vm_end - vma->vm_start;
 	struct xdp_sock *xs = xdp_sk(sock->sk);
+	int state = READ_ONCE(xs->state);
 	struct xsk_queue *q = NULL;
 
-	if (READ_ONCE(xs->state) != XSK_READY)
+	if (state != XSK_READY && state != XSK_BOUND)
 		return -EBUSY;
 
 	if (offset == XDP_PGOFF_RX_RING) {
@@ -1314,9 +1314,11 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 		/* Matches the smp_wmb() in XDP_UMEM_REG */
 		smp_rmb();
 		if (offset == XDP_UMEM_PGOFF_FILL_RING)
-			q = READ_ONCE(xs->fq_tmp);
+			q = state == XSK_READY ? READ_ONCE(xs->fq_tmp) :
+						 READ_ONCE(xs->pool->fq);
 		else if (offset == XDP_UMEM_PGOFF_COMPLETION_RING)
-			q = READ_ONCE(xs->cq_tmp);
+			q = state == XSK_READY ? READ_ONCE(xs->cq_tmp) :
+						 READ_ONCE(xs->pool->cq);
 	}
 
 	if (!q)
@@ -1330,8 +1332,8 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	return remap_vmalloc_range(vma, q->ring, 0);
 }
 
-static int xsk_notifier(struct notifier_block *this,
-			unsigned long msg, void *ptr)
+static int xsk_notifier(struct notifier_block *this, unsigned long msg,
+			void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct net *net = dev_net(dev);
@@ -1363,30 +1365,30 @@ static int xsk_notifier(struct notifier_block *this,
 }
 
 static struct proto xsk_proto = {
-	.name =		"XDP",
-	.owner =	THIS_MODULE,
-	.obj_size =	sizeof(struct xdp_sock),
+	.name = "XDP",
+	.owner = THIS_MODULE,
+	.obj_size = sizeof(struct xdp_sock),
 };
 
 static const struct proto_ops xsk_proto_ops = {
-	.family		= PF_XDP,
-	.owner		= THIS_MODULE,
-	.release	= xsk_release,
-	.bind		= xsk_bind,
-	.connect	= sock_no_connect,
-	.socketpair	= sock_no_socketpair,
-	.accept		= sock_no_accept,
-	.getname	= sock_no_getname,
-	.poll		= xsk_poll,
-	.ioctl		= sock_no_ioctl,
-	.listen		= sock_no_listen,
-	.shutdown	= sock_no_shutdown,
-	.setsockopt	= xsk_setsockopt,
-	.getsockopt	= xsk_getsockopt,
-	.sendmsg	= xsk_sendmsg,
-	.recvmsg	= xsk_recvmsg,
-	.mmap		= xsk_mmap,
-	.sendpage	= sock_no_sendpage,
+	.family = PF_XDP,
+	.owner = THIS_MODULE,
+	.release = xsk_release,
+	.bind = xsk_bind,
+	.connect = sock_no_connect,
+	.socketpair = sock_no_socketpair,
+	.accept = sock_no_accept,
+	.getname = sock_no_getname,
+	.poll = xsk_poll,
+	.ioctl = sock_no_ioctl,
+	.listen = sock_no_listen,
+	.shutdown = sock_no_shutdown,
+	.setsockopt = xsk_setsockopt,
+	.getsockopt = xsk_getsockopt,
+	.sendmsg = xsk_sendmsg,
+	.recvmsg = xsk_recvmsg,
+	.mmap = xsk_mmap,
+	.sendpage = sock_no_sendpage,
 };
 
 static void xsk_destruct(struct sock *sk)
@@ -1450,11 +1452,11 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 static const struct net_proto_family xsk_family_ops = {
 	.family = PF_XDP,
 	.create = xsk_create,
-	.owner	= THIS_MODULE,
+	.owner = THIS_MODULE,
 };
 
 static struct notifier_block xsk_netdev_notifier = {
-	.notifier_call	= xsk_notifier,
+	.notifier_call = xsk_notifier,
 };
 
 static int __net_init xsk_net_init(struct net *net)
-- 
2.40.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1362FBB70
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391400AbhASPkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391111AbhASPhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:37:55 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D8EC0613CF;
        Tue, 19 Jan 2021 07:37:15 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id o19so29677881lfo.1;
        Tue, 19 Jan 2021 07:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hKHQ7CC2Aqb3EGPtFGFCct7hw0qM/zuO1T/NQ4/vMXM=;
        b=YmFh2Mgg7ocyHp4cdqXLKziP9QIc9Ds10XTsGaoLgRTIG4ZMpKXhQjKlIqHmBJlkpS
         /b6G1rh4LmX7B8d6VTxuXax/ZSeSlKsIRp/DIgkAzGCNPMCQxMvv6LBFE9sUDkkJz8Dk
         CuuWIodDa/gMn3AxdjbmvEq7Mv+qtR6I4ohTcHawsiefn/t0LVc9TPdxRAQ3m1yeDeWg
         XodISSUPmFGsiFIblAaHZfy2yRMajbZSRo4f5Gw1jPTVxoku/O3Nh/3OJHw5mf8o2/ke
         vPByw5rxmZp3BuyXIG5lnarR5zp+QNExz3Uq8w4nZXEies9G2l+sTlnqTKWx1BaSgbcE
         f0Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hKHQ7CC2Aqb3EGPtFGFCct7hw0qM/zuO1T/NQ4/vMXM=;
        b=ARUOYmQIMtoIWQo79cdwwx+tsbOPLEktZkCcaEYk7BAfOh2aESXF4SUGYCWEEk8hwe
         bf/rm+2HqB4Gl1Aom3X7ra+akk3ghzfXVcquJdJUYecIJ6X2y5rl9Y65fZ7EBi00Zn/d
         NxtDgvF20mLCu82XnphMz7xtcwXKM7r1oN+6SRkApvnnwMpTWUDIT9yc+QUz3bWnS+vB
         H19WWtn3Q02wkhLx9UvW8tdPahucR5gywlRGx+K33nw3usm3oouyMWOIo2Qw0pXYYsVe
         DgxJPEgYy3o2F2pEaJUtBN/2/PeLcnr1j/LKVFGcps+koYSvq3ywAkCaES9GNTP5wFrL
         KEIQ==
X-Gm-Message-State: AOAM531GiKH9lTVoNbeVl4UQLjMkhXvPvKU7HX+QAbhiWD0aKmsa/0p+
        PvhotNeXABYAaJYz9h+Z9oU=
X-Google-Smtp-Source: ABdhPJwme9lbOQyHFLHG99aa7GU4zVo4Z4ECMdjZXWmBpXE9qojLT89IDYYQTRXfdZ7EYGOmCu8ndg==
X-Received: by 2002:ac2:5dd1:: with SMTP id x17mr2046584lfq.252.1611070633585;
        Tue, 19 Jan 2021 07:37:13 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id z2sm2309075lfd.142.2021.01.19.07.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:37:12 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 4/8] xsk: register XDP sockets at bind(), and add new AF_XDP BPF helper
Date:   Tue, 19 Jan 2021 16:36:51 +0100
Message-Id: <20210119153655.153999-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210119153655.153999-1-bjorn.topel@gmail.com>
References: <20210119153655.153999-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Extend bind() for XDP sockets, so that the bound socket is added to
the netdev_rx_queue _rx array in the netdevice. We call this to
register an XDP socket. To redirect packets to a registered socket, a
new BPF helper is used: bpf_redirect_xsk().

For shared XDP sockets, only the first bound socket is
registered. Users that require more advanced setups, continue to the
XSKMAP and bpf_redirect_map().

Now, why would one use bpf_redirect_xsk() over the regular
bpf_redirect_map() helper? First: Slightly better performance. Second:
Convenience. Most user use one socket per queue. This scenario is what
registered sockets support. There is no need to create an XSKMAP. This
can also reduce complexity from containerized setups, where users
might what to use XDP sockets without CAP_SYS_ADMIN capabilities.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/filter.h         |  1 +
 include/linux/netdevice.h      |  1 +
 include/net/xdp_sock.h         | 12 +++++
 include/net/xsk_buff_pool.h    |  2 +-
 include/uapi/linux/bpf.h       |  7 +++
 net/core/filter.c              | 49 ++++++++++++++++--
 net/xdp/xsk.c                  | 93 ++++++++++++++++++++++++++++------
 net/xdp/xsk_buff_pool.c        |  4 +-
 tools/include/uapi/linux/bpf.h |  7 +++
 9 files changed, 153 insertions(+), 23 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 5fc336a271c2..3f9efbd08cba 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -648,6 +648,7 @@ enum xdp_redirect_type {
 	XDP_REDIR_DEV_MAP,
 	XDP_REDIR_CPU_MAP,
 	XDP_REDIR_XSK_MAP,
+	XDP_REDIR_XSK,
 };
 
 DECLARE_PER_CPU(struct bpf_redirect_info, bpf_redirect_info);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5b949076ed23..cb0e215e981c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -749,6 +749,7 @@ struct netdev_rx_queue {
 	struct xdp_rxq_info		xdp_rxq;
 #ifdef CONFIG_XDP_SOCKETS
 	struct xsk_buff_pool            *pool;
+	struct xdp_sock			*xsk;
 #endif
 } ____cacheline_aligned_in_smp;
 
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index cc17bc957548..97b21c483baf 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -77,8 +77,10 @@ struct xdp_sock {
 #ifdef CONFIG_XDP_SOCKETS
 
 int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
+int xsk_generic_redirect(struct net_device *dev, struct xdp_buff *xdp);
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp);
 void __xsk_map_flush(void);
+int xsk_redirect(struct xdp_sock *xs, struct xdp_buff *xdp);
 
 static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
 						     u32 key)
@@ -100,6 +102,11 @@ static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	return -ENOTSUPP;
 }
 
+static inline int xsk_generic_redirect(struct net_device *dev, struct xdp_buff *xdp)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	return -EOPNOTSUPP;
@@ -115,6 +122,11 @@ static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
 	return NULL;
 }
 
+static inline int xsk_redirect(struct net_device *dev, struct xdp_buff *xdp)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_XDP_SOCKETS */
 
 #endif /* _LINUX_XDP_SOCK_H */
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index eaa8386dbc63..bd531d561c60 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -84,7 +84,7 @@ struct xsk_buff_pool {
 /* AF_XDP core. */
 struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 						struct xdp_umem *umem);
-int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
+int xp_assign_dev(struct xdp_sock *xs, struct xsk_buff_pool *pool, struct net_device *dev,
 		  u16 queue_id, u16 flags);
 int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
 			 struct net_device *dev, u16 queue_id);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c001766adcbc..bbc7d9a57262 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3836,6 +3836,12 @@ union bpf_attr {
  *	Return
  *		A pointer to a struct socket on success or NULL if the file is
  *		not a socket.
+ *
+ * long bpf_redirect_xsk(struct xdp_buff *xdp_md, u64 action)
+ *	Description
+ *		Redirect to the registered AF_XDP socket.
+ *	Return
+ *		**XDP_REDIRECT** on success, otherwise the action parameter is returned.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4001,6 +4007,7 @@ union bpf_attr {
 	FN(ktime_get_coarse_ns),	\
 	FN(ima_inode_hash),		\
 	FN(sock_from_file),		\
+	FN(redirect_xsk),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 5f31e21be531..b457c83fba70 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3977,6 +3977,9 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	case XDP_REDIR_XSK_MAP:
 		err = __xsk_map_redirect(fwd, xdp);
 		break;
+	case XDP_REDIR_XSK:
+		err = xsk_redirect(fwd, xdp);
+		break;
 	default:
 		err = -EBADRQC;
 	}
@@ -4044,25 +4047,33 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 	ri->tgt_type = XDP_REDIR_UNSET;
 	ri->tgt_value = NULL;
 
-	if (type == XDP_REDIR_DEV_IFINDEX) {
+	switch (type) {
+	case XDP_REDIR_DEV_IFINDEX: {
 		fwd = dev_get_by_index_rcu(dev_net(dev), (u32)(long)fwd);
 		if (unlikely(!fwd)) {
 			err = -EINVAL;
-			goto err;
+			break;
 		}
 
 		err = xdp_ok_fwd_dev(fwd, skb->len);
 		if (unlikely(err))
-			goto err;
+			break;
 
 		skb->dev = fwd;
 		_trace_xdp_redirect(dev, xdp_prog, index);
 		generic_xdp_tx(skb, xdp_prog);
 		return 0;
 	}
+	case XDP_REDIR_XSK:
+		err = xsk_generic_redirect(dev, xdp);
+		if (err)
+			break;
+		consume_skb(skb);
+		break;
+	default:
+		return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog, fwd, type);
+	}
 
-	return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog, fwd, type);
-err:
 	_trace_xdp_redirect_err(dev, xdp_prog, index, err);
 	return err;
 }
@@ -4144,6 +4155,32 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
 	.arg3_type      = ARG_ANYTHING,
 };
 
+BPF_CALL_2(bpf_xdp_redirect_xsk, struct xdp_buff *, xdp, u64, action)
+{
+	struct net_device *dev = xdp->rxq->dev;
+	u32 queue_id = xdp->rxq->queue_index;
+	struct bpf_redirect_info *ri;
+	struct xdp_sock *xs;
+
+	xs = READ_ONCE(dev->_rx[queue_id].xsk);
+	if (!xs)
+		return action;
+
+	ri = this_cpu_ptr(&bpf_redirect_info);
+	ri->tgt_type = XDP_REDIR_XSK;
+	ri->tgt_value = xs;
+
+	return XDP_REDIRECT;
+}
+
+static const struct bpf_func_proto bpf_xdp_redirect_xsk_proto = {
+	.func           = bpf_xdp_redirect_xsk,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+};
+
 static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
 				  unsigned long off, unsigned long len)
 {
@@ -7260,6 +7297,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
 #endif
+	case BPF_FUNC_redirect_xsk:
+		return &bpf_xdp_redirect_xsk_proto;
 	default:
 		return bpf_sk_base_func_proto(func_id);
 	}
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 5820de65060b..79f1492e71e2 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -134,6 +134,28 @@ int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
 	return 0;
 }
 
+static struct xdp_sock *xsk_get_at_qid(struct net_device *dev, u16 queue_id)
+{
+	return READ_ONCE(dev->_rx[queue_id].xsk);
+}
+
+static void xsk_clear(struct xdp_sock *xs)
+{
+	struct net_device *dev = xs->dev;
+	u16 queue_id = xs->queue_id;
+
+	if (queue_id < dev->num_rx_queues)
+		WRITE_ONCE(dev->_rx[queue_id].xsk, NULL);
+}
+
+static void xsk_reg(struct xdp_sock *xs)
+{
+	struct net_device *dev = xs->dev;
+	u16 queue_id = xs->queue_id;
+
+	WRITE_ONCE(dev->_rx[queue_id].xsk, xs);
+}
+
 void xp_release(struct xdp_buff_xsk *xskb)
 {
 	xskb->pool->free_heads[xskb->pool->free_heads_cnt++] = xskb;
@@ -184,7 +206,7 @@ static void xsk_copy_xdp(struct xdp_buff *to, struct xdp_buff *from, u32 len)
 	memcpy(to_buf, from_buf, len + metalen);
 }
 
-static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
+static int ____xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	struct xdp_buff *xsk_xdp;
 	int err;
@@ -211,6 +233,22 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	return 0;
 }
 
+static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
+{
+	int err;
+	u32 len;
+
+	if (likely(xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL)) {
+		len = xdp->data_end - xdp->data;
+		return __xsk_rcv_zc(xs, xdp, len);
+	}
+
+	err = ____xsk_rcv(xs, xdp);
+	if (!err)
+		xdp_return_buff(xdp);
+	return err;
+}
+
 static bool xsk_tx_writeable(struct xdp_sock *xs)
 {
 	if (xskq_cons_present_entries(xs->tx) > xs->tx->nentries / 2)
@@ -248,6 +286,39 @@ static void xsk_flush(struct xdp_sock *xs)
 	sock_def_readable(&xs->sk);
 }
 
+int xsk_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
+{
+	struct list_head *flush_list = this_cpu_ptr(&xskmap_flush_list);
+	int err;
+
+	sk_mark_napi_id_once_xdp(&xs->sk, xdp);
+	err = __xsk_rcv(xs, xdp);
+	if (err)
+		return err;
+
+	if (!xs->flush_node.prev)
+		list_add(&xs->flush_node, flush_list);
+	return 0;
+}
+
+int xsk_generic_redirect(struct net_device *dev, struct xdp_buff *xdp)
+{
+	struct xdp_sock *xs;
+	u32 queue_id;
+	int err;
+
+	queue_id = xdp->rxq->queue_index;
+	xs = xsk_get_at_qid(dev, queue_id);
+	if (!xs)
+		return -EINVAL;
+
+	spin_lock_bh(&xs->rx_lock);
+	err = ____xsk_rcv(xs, xdp);
+	xsk_flush(xs);
+	spin_unlock_bh(&xs->rx_lock);
+	return err;
+}
+
 int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	int err;
@@ -255,7 +326,7 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	spin_lock_bh(&xs->rx_lock);
 	err = xsk_rcv_check(xs, xdp);
 	if (!err) {
-		err = __xsk_rcv(xs, xdp);
+		err = ____xsk_rcv(xs, xdp);
 		xsk_flush(xs);
 	}
 	spin_unlock_bh(&xs->rx_lock);
@@ -264,22 +335,12 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 
 static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
-	int err;
-	u32 len;
+	int err = xsk_rcv_check(xs, xdp);
 
-	err = xsk_rcv_check(xs, xdp);
 	if (err)
 		return err;
 
-	if (xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL) {
-		len = xdp->data_end - xdp->data;
-		return __xsk_rcv_zc(xs, xdp, len);
-	}
-
-	err = __xsk_rcv(xs, xdp);
-	if (!err)
-		xdp_return_buff(xdp);
-	return err;
+	return __xsk_rcv(xs, xdp);
 }
 
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
@@ -661,6 +722,7 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 
 	if (xs->state != XSK_BOUND)
 		return;
+	xsk_clear(xs);
 	WRITE_ONCE(xs->state, XSK_UNBOUND);
 
 	/* Wait for driver to stop using the xdp socket. */
@@ -892,7 +954,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			goto out_unlock;
 		}
 
-		err = xp_assign_dev(xs->pool, dev, qid, flags);
+		err = xp_assign_dev(xs, xs->pool, dev, qid, flags);
 		if (err) {
 			xp_destroy(xs->pool);
 			xs->pool = NULL;
@@ -918,6 +980,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		 */
 		smp_wmb();
 		WRITE_ONCE(xs->state, XSK_BOUND);
+		xsk_reg(xs);
 	}
 out_release:
 	mutex_unlock(&xs->mutex);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 8de01aaac4a0..af02a69d0bf7 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -119,7 +119,7 @@ static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
 	}
 }
 
-int xp_assign_dev(struct xsk_buff_pool *pool,
+int xp_assign_dev(struct xdp_sock *xs, struct xsk_buff_pool *pool,
 		  struct net_device *netdev, u16 queue_id, u16 flags)
 {
 	bool force_zc, force_copy;
@@ -204,7 +204,7 @@ int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
 	if (pool->uses_need_wakeup)
 		flags |= XDP_USE_NEED_WAKEUP;
 
-	return xp_assign_dev(pool, dev, queue_id, flags);
+	return xp_assign_dev(NULL, pool, dev, queue_id, flags);
 }
 
 void xp_clear_dev(struct xsk_buff_pool *pool)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c001766adcbc..bbc7d9a57262 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3836,6 +3836,12 @@ union bpf_attr {
  *	Return
  *		A pointer to a struct socket on success or NULL if the file is
  *		not a socket.
+ *
+ * long bpf_redirect_xsk(struct xdp_buff *xdp_md, u64 action)
+ *	Description
+ *		Redirect to the registered AF_XDP socket.
+ *	Return
+ *		**XDP_REDIRECT** on success, otherwise the action parameter is returned.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4001,6 +4007,7 @@ union bpf_attr {
 	FN(ktime_get_coarse_ns),	\
 	FN(ima_inode_hash),		\
 	FN(sock_from_file),		\
+	FN(redirect_xsk),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.27.0


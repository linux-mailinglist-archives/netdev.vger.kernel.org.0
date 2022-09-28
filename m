Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6085EE938
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 00:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiI1WPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 18:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiI1WPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 18:15:37 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605B0760FD;
        Wed, 28 Sep 2022 15:15:31 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id u6-20020a056830118600b006595e8f9f3fso9075868otq.1;
        Wed, 28 Sep 2022 15:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=YNnXwYkGoMMSkuWxjgjL/NZE5tYy3hOPh6uxIwhTUTo=;
        b=qXZgqej23lx2NV42EBAT82h+Wh4XhrR8I/m3/jws3ylKCcXTTAGHZjq3BpWOzzzBw1
         SwyZFGToeJTArLxvRU5mka96HLiHuEcgpf9GbMviTOARSg8KuUe3+CXx9EXsntTgntZa
         6fIdgXLgpGEl9c3Yyr3RQbVHohmJDmVhcwX6vyxd/kj6WWx7+3h5zo7VvvcI5bp+ZDEG
         czg3+OFCelC0d915805j/OwZqKdHJNb+S99LleeWbDBZkHm4njS9rgRdb20idM9sUwB5
         pxh3iyquPZ4HwHI9I1nApiDcHZxVXDHbcQDI+RQFw0QEkXM1OWC7QUDZw1dIOobU0JQ7
         6xBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=YNnXwYkGoMMSkuWxjgjL/NZE5tYy3hOPh6uxIwhTUTo=;
        b=AXXkq7RlD+jMKc52DvaK9gJXItO9ey6PdRCk1PP2opy7tdqD5hbwauYwCb5FtBHMrT
         dbMYu7pE1pCFS7rjb/FMoM0xlCfSlEaEhJJVSNBrm9ZJFak7jFB/NQv73s89yymMPKLR
         RBn8W15MxVWapBwsGF1IlBTwXRetYX5LmNGsQPPc9xjZKqaR393l8mjIb0HjkOe8+9sr
         ofXvh8khLDiLGS3Px6P+0wYsjnYchuIWSnIbz/aC4HAzOYVdcA3DEaHfjeZT3D5p33wR
         u2d7kn75rCMLAvsyHskIc8zdrD53hHjFOiz+i4dMWBVdt3rFYnZOIAIkmSZBlmOfaSOq
         RL1Q==
X-Gm-Message-State: ACrzQf2bTBBUJ44xOzr7ib/d9hcTRMYiGZTkWUJ30yJgZOmFSXnQAO0x
        ClKOmNs5Bgns6CIW/91JsA==
X-Google-Smtp-Source: AMsMyM5Jtz1sXaTYOjnVPeijQe1d+uB5rMFqsAYgJj20atA48ISFY7+rDuj8BAfmSamrmgdoFVlv9g==
X-Received: by 2002:a9d:6016:0:b0:65b:f5d0:613d with SMTP id h22-20020a9d6016000000b0065bf5d0613dmr12675548otj.384.1664403330614;
        Wed, 28 Sep 2022 15:15:30 -0700 (PDT)
Received: from bytedance.bytedance.net ([74.199.177.246])
        by smtp.gmail.com with ESMTPSA id bl4-20020a056830370400b006394756c04fsm2675141otb.0.2022.09.28.15.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 15:15:29 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next] net/sock: Introduce trace_sk_data_ready()
Date:   Wed, 28 Sep 2022 15:15:14 -0700
Message-Id: <20220928221514.27350-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: Peilin Ye <peilin.ye@bytedance.com>

As suggested by Cong, introduce a tracepoint for all ->sk_data_ready()
and ->saved_data_ready() call sites.  For example:

<...>
  cat-7011    [005] .....    92.018695: sk_data_ready: family=16 protocol=17 func=sock_def_readable
  cat-7012    [005] .....    93.612922: sk_data_ready: family=16 protocol=16 func=sock_def_readable
  cat-7013    [005] .....    94.653854: sk_data_ready: family=16 protocol=16 func=sock_def_readable
<...>

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 drivers/infiniband/sw/siw/siw_cm.c            |  6 ++++-
 .../chelsio/inline_crypto/chtls/chtls_cm.c    |  4 +++
 drivers/net/tun.c                             | 27 +++++++++++++------
 include/linux/skmsg.h                         |  8 ++++--
 include/trace/events/sock.h                   | 25 +++++++++++++++++
 net/atm/clip.c                                |  2 ++
 net/atm/lec.c                                 |  6 +++++
 net/atm/mpc.c                                 |  4 +++
 net/atm/raw.c                                 |  2 ++
 net/atm/signaling.c                           |  9 +++++--
 net/ax25/ax25_in.c                            |  5 +++-
 net/bluetooth/iso.c                           |  3 +++
 net/bluetooth/l2cap_sock.c                    | 10 +++++--
 net/bluetooth/rfcomm/sock.c                   |  3 +++
 net/bluetooth/sco.c                           |  2 ++
 net/caif/caif_socket.c                        |  7 +++--
 net/core/skmsg.c                              |  1 +
 net/core/sock.c                               |  4 ++-
 net/dccp/input.c                              |  2 ++
 net/dccp/minisocks.c                          |  5 +++-
 net/ipv4/tcp_input.c                          | 12 +++++++--
 net/ipv4/tcp_minisocks.c                      |  5 +++-
 net/ipv4/udp.c                                |  5 +++-
 net/iucv/af_iucv.c                            |  3 +++
 net/kcm/kcmsock.c                             |  5 +++-
 net/key/af_key.c                              |  2 ++
 net/mptcp/protocol.c                          |  6 ++++-
 net/mptcp/subflow.c                           |  2 ++
 net/netlink/af_netlink.c                      |  2 ++
 net/netrom/af_netrom.c                        |  5 +++-
 net/nfc/llcp_core.c                           |  2 ++
 net/packet/af_packet.c                        |  5 ++++
 net/phonet/pep.c                              | 13 ++++++---
 net/rose/af_rose.c                            |  5 +++-
 net/rxrpc/recvmsg.c                           |  2 ++
 net/sctp/stream_interleave.c                  |  3 +++
 net/sctp/ulpqueue.c                           |  3 +++
 net/smc/smc_close.c                           |  2 ++
 net/tipc/socket.c                             |  2 ++
 net/tipc/topsrv.c                             |  2 ++
 net/tls/tls_sw.c                              |  9 +++++--
 net/unix/af_unix.c                            |  6 +++++
 net/vmw_vsock/af_vsock.c                      |  5 +++-
 net/vmw_vsock/hyperv_transport.c              |  5 +++-
 net/vmw_vsock/virtio_transport_common.c       |  2 ++
 net/vmw_vsock/vmci_transport.c                |  2 ++
 net/x25/af_x25.c                              |  5 +++-
 net/x25/x25_in.c                              |  5 +++-
 net/xfrm/espintcp.c                           |  2 ++
 49 files changed, 225 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index f88d2971c2c6..cd58af4785f2 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -16,6 +16,7 @@
 #include <net/tcp.h>
 #include <linux/inet.h>
 #include <linux/tcp.h>
+#include <trace/events/sock.h>
 
 #include <rdma/iw_cm.h>
 #include <rdma/ib_verbs.h>
@@ -998,6 +999,7 @@ static void siw_cm_work_handler(struct work_struct *w)
 	struct siw_cm_work *work;
 	struct siw_cep *cep;
 	int release_cep = 0, rv = 0;
+	struct sock *sk;
 
 	work = container_of(w, struct siw_cm_work, work.work);
 	cep = work->cep;
@@ -1042,7 +1044,9 @@ static void siw_cm_work_handler(struct work_struct *w)
 			 * silently ignore the mpa packet.
 			 */
 			if (cep->state == SIW_EPSTATE_RDMA_MODE) {
-				cep->sock->sk->sk_data_ready(cep->sock->sk);
+				sk = cep->sock->sk;
+				trace_sk_data_ready(sk, sk->sk_data_ready);
+				sk->sk_data_ready(sk);
 				siw_dbg_cep(cep, "already in RDMA mode");
 			} else {
 				siw_dbg_cep(cep, "out of state: %d\n",
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index f90bfba4b303..0a7c7a9e5d0b 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -28,6 +28,7 @@
 #include <net/tls.h>
 #include <net/addrconf.h>
 #include <net/secure_seq.h>
+#include <trace/events/sock.h>
 
 #include "chtls.h"
 #include "chtls_cm.h"
@@ -1555,6 +1556,7 @@ static void add_pass_open_to_parent(struct sock *child, struct sock *lsk,
 	} else {
 		refcount_set(&oreq->rsk_refcnt, 1);
 		inet_csk_reqsk_queue_add(lsk, oreq, child);
+		trace_sk_data_ready(lsk, lsk->sk_data_ready);
 		lsk->sk_data_ready(lsk);
 	}
 }
@@ -1719,6 +1721,7 @@ static void chtls_recv_data(struct sock *sk, struct sk_buff *skb)
 
 	if (!sock_flag(sk, SOCK_DEAD)) {
 		check_sk_callbacks(csk);
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	}
 }
@@ -1840,6 +1843,7 @@ static void chtls_rx_hdr(struct sock *sk, struct sk_buff *skb)
 
 	if (!sock_flag(sk, SOCK_DEAD)) {
 		check_sk_callbacks(csk);
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	}
 }
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3732e51b5ad8..ec9428a8903d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -77,6 +77,7 @@
 #include <net/ax25.h>
 #include <net/rose.h>
 #include <net/6lowpan.h>
+#include <trace/events/sock.h>
 
 #include <linux/uaccess.h>
 #include <linux/proc_fs.h>
@@ -709,19 +710,24 @@ static void tun_detach_all(struct net_device *dev)
 	struct tun_struct *tun = netdev_priv(dev);
 	struct tun_file *tfile, *tmp;
 	int i, n = tun->numqueues;
+	struct sock *sk;
 
 	for (i = 0; i < n; i++) {
 		tfile = rtnl_dereference(tun->tfiles[i]);
 		BUG_ON(!tfile);
 		tun_napi_disable(tfile);
-		tfile->socket.sk->sk_shutdown = RCV_SHUTDOWN;
-		tfile->socket.sk->sk_data_ready(tfile->socket.sk);
+		sk = tfile->socket.sk;
+		sk->sk_shutdown = RCV_SHUTDOWN;
+		trace_sk_data_ready(sk, sk->sk_data_ready);
+		sk->sk_data_ready(sk);
 		RCU_INIT_POINTER(tfile->tun, NULL);
 		--tun->numqueues;
 	}
 	list_for_each_entry(tfile, &tun->disabled, next) {
-		tfile->socket.sk->sk_shutdown = RCV_SHUTDOWN;
-		tfile->socket.sk->sk_data_ready(tfile->socket.sk);
+		sk = tfile->socket.sk;
+		sk->sk_shutdown = RCV_SHUTDOWN;
+		trace_sk_data_ready(sk, sk->sk_data_ready);
+		sk->sk_data_ready(sk);
 		RCU_INIT_POINTER(tfile->tun, NULL);
 	}
 	BUG_ON(tun->numqueues != 0);
@@ -1073,6 +1079,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netdev_queue *queue;
 	struct tun_file *tfile;
 	int len = skb->len;
+	struct sock *sk;
 
 	rcu_read_lock();
 	tfile = rcu_dereference(tun->tfiles[txq]);
@@ -1096,8 +1103,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto drop;
 	}
 
-	if (tfile->socket.sk->sk_filter &&
-	    sk_filter(tfile->socket.sk, skb)) {
+	sk = tfile->socket.sk;
+	if (sk->sk_filter && sk_filter(sk, skb)) {
 		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto drop;
 	}
@@ -1139,7 +1146,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Notify and wake up reader process */
 	if (tfile->flags & TUN_FASYNC)
 		kill_fasync(&tfile->fasync, SIGIO, POLL_IN);
-	tfile->socket.sk->sk_data_ready(tfile->socket.sk);
+	trace_sk_data_ready(sk, sk->sk_data_ready);
+	sk->sk_data_ready(sk);
 
 	rcu_read_unlock();
 	return NETDEV_TX_OK;
@@ -1260,10 +1268,13 @@ static const struct net_device_ops tun_netdev_ops = {
 
 static void __tun_xdp_flush_tfile(struct tun_file *tfile)
 {
+	struct sock *sk = tfile->socket.sk;
+
 	/* Notify and wake up reader process */
 	if (tfile->flags & TUN_FASYNC)
 		kill_fasync(&tfile->fasync, SIGIO, POLL_IN);
-	tfile->socket.sk->sk_data_ready(tfile->socket.sk);
+	trace_sk_data_ready(sk, sk->sk_data_ready);
+	sk->sk_data_ready(sk);
 }
 
 static int tun_xdp_xmit(struct net_device *dev, int n,
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 48f4b645193b..ccf4e1b94828 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -12,6 +12,7 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 #include <net/strparser.h>
+#include <trace/events/sock.h>
 
 #define MAX_MSG_FRAGS			MAX_SKB_FRAGS
 #define NR_MSG_FRAG_IDS			(MAX_MSG_FRAGS + 1)
@@ -454,10 +455,13 @@ static inline void sk_psock_put(struct sock *sk, struct sk_psock *psock)
 
 static inline void sk_psock_data_ready(struct sock *sk, struct sk_psock *psock)
 {
-	if (psock->saved_data_ready)
+	if (psock->saved_data_ready) {
+		trace_sk_data_ready(sk, psock->saved_data_ready);
 		psock->saved_data_ready(sk);
-	else
+	} else {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 }
 
 static inline void psock_set_prog(struct bpf_prog **pprog,
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 777ee6cbe933..22ed9065d874 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -263,6 +263,31 @@ TRACE_EVENT(inet_sk_error_report,
 		  __entry->error)
 );
 
+TRACE_EVENT(sk_data_ready,
+
+	TP_PROTO(const struct sock *sk,
+		 const void (*data_ready)(struct sock *)),
+
+	TP_ARGS(sk, data_ready),
+
+	TP_STRUCT__entry(
+		__field(const void *, skaddr)
+		__field(__u16, family)
+		__field(__u16, protocol)
+		__field(const void *, func)
+	),
+
+	TP_fast_assign(
+		__entry->skaddr = sk;
+		__entry->family = sk->sk_family;
+		__entry->protocol = sk->sk_protocol;
+		__entry->func = data_ready;
+	),
+
+	TP_printk("family=%u protocol=%u func=%ps", __entry->family,
+		  __entry->protocol, __entry->func)
+);
+
 #endif /* _TRACE_SOCK_H */
 
 /* This part must be outside protection */
diff --git a/net/atm/clip.c b/net/atm/clip.c
index 294cb9efe3d3..78b251fd5273 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -39,6 +39,7 @@
 #include <linux/uaccess.h>
 #include <asm/byteorder.h> /* for htons etc. */
 #include <linux/atomic.h>
+#include <trace/events/sock.h>
 
 #include "common.h"
 #include "resources.h"
@@ -69,6 +70,7 @@ static int to_atmarpd(enum atmarp_ctrl_type type, int itf, __be32 ip)
 
 	sk = sk_atm(atmarpd);
 	skb_queue_tail(&sk->sk_receive_queue, skb);
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 	return 0;
 }
diff --git a/net/atm/lec.c b/net/atm/lec.c
index 6257bf12e5a0..8dd3036c1c20 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -26,6 +26,7 @@
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/seq_file.h>
+#include <trace/events/sock.h>
 
 /* And atm device */
 #include <linux/atmdev.h>
@@ -156,6 +157,7 @@ static void lec_handle_bridge(struct sk_buff *skb, struct net_device *dev)
 		atm_force_charge(priv->lecd, skb2->truesize);
 		sk = sk_atm(priv->lecd);
 		skb_queue_tail(&sk->sk_receive_queue, skb2);
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	}
 }
@@ -450,6 +452,7 @@ static int lec_atm_send(struct atm_vcc *vcc, struct sk_buff *skb)
 			atm_force_charge(priv->lecd, skb2->truesize);
 			sk = sk_atm(priv->lecd);
 			skb_queue_tail(&sk->sk_receive_queue, skb2);
+			trace_sk_data_ready(sk, sk->sk_data_ready);
 			sk->sk_data_ready(sk);
 		}
 	}
@@ -533,12 +536,14 @@ send_to_lecd(struct lec_priv *priv, atmlec_msg_type type,
 	atm_force_charge(priv->lecd, skb->truesize);
 	sk = sk_atm(priv->lecd);
 	skb_queue_tail(&sk->sk_receive_queue, skb);
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 
 	if (data != NULL) {
 		pr_debug("about to send %d bytes of data\n", data->len);
 		atm_force_charge(priv->lecd, data->truesize);
 		skb_queue_tail(&sk->sk_receive_queue, data);
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	}
 
@@ -609,6 +614,7 @@ static void lec_push(struct atm_vcc *vcc, struct sk_buff *skb)
 
 		pr_debug("%s: To daemon\n", dev->name);
 		skb_queue_tail(&sk->sk_receive_queue, skb);
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	} else {		/* Data frame, queue to protocol handlers */
 		struct lec_arp_table *entry;
diff --git a/net/atm/mpc.c b/net/atm/mpc.c
index 033871e718a3..074abe53feb6 100644
--- a/net/atm/mpc.c
+++ b/net/atm/mpc.c
@@ -23,6 +23,7 @@
 #include <net/arp.h>
 #include <net/dst.h>
 #include <linux/proc_fs.h>
+#include <trace/events/sock.h>
 
 /* And atm device */
 #include <linux/atmdev.h>
@@ -706,6 +707,7 @@ static void mpc_push(struct atm_vcc *vcc, struct sk_buff *skb)
 		dprintk("(%s) control packet arrived\n", dev->name);
 		/* Pass control packets to daemon */
 		skb_queue_tail(&sk->sk_receive_queue, skb);
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 		return;
 	}
@@ -991,6 +993,7 @@ int msg_to_mpoad(struct k_message *mesg, struct mpoa_client *mpc)
 
 	sk = sk_atm(mpc->mpoad_vcc);
 	skb_queue_tail(&sk->sk_receive_queue, skb);
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 
 	return 0;
@@ -1273,6 +1276,7 @@ static void purge_egress_shortcut(struct atm_vcc *vcc, eg_cache_entry *entry)
 
 	sk = sk_atm(vcc);
 	skb_queue_tail(&sk->sk_receive_queue, skb);
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 	dprintk("exiting\n");
 }
diff --git a/net/atm/raw.c b/net/atm/raw.c
index 2b5f78a7ec3e..b98d0d17e420 100644
--- a/net/atm/raw.c
+++ b/net/atm/raw.c
@@ -12,6 +12,7 @@
 #include <linux/skbuff.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <trace/events/sock.h>
 
 #include "common.h"
 #include "protocols.h"
@@ -26,6 +27,7 @@ static void atm_push_raw(struct atm_vcc *vcc, struct sk_buff *skb)
 		struct sock *sk = sk_atm(vcc);
 
 		skb_queue_tail(&sk->sk_receive_queue, skb);
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	}
 }
diff --git a/net/atm/signaling.c b/net/atm/signaling.c
index 5de06ab8ed75..b38feb812eb8 100644
--- a/net/atm/signaling.c
+++ b/net/atm/signaling.c
@@ -16,6 +16,7 @@
 #include <linux/atmdev.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
+#include <trace/events/sock.h>
 
 #include "resources.h"
 #include "signaling.h"
@@ -24,14 +25,18 @@ struct atm_vcc *sigd = NULL;
 
 static void sigd_put_skb(struct sk_buff *skb)
 {
+	struct sock *sk;
+
 	if (!sigd) {
 		pr_debug("atmsvc: no signaling daemon\n");
 		kfree_skb(skb);
 		return;
 	}
 	atm_force_charge(sigd, skb->truesize);
-	skb_queue_tail(&sk_atm(sigd)->sk_receive_queue, skb);
-	sk_atm(sigd)->sk_data_ready(sk_atm(sigd));
+	sk = sk_atm(sigd);
+	skb_queue_tail(&sk->sk_receive_queue, skb);
+	trace_sk_data_ready(sk, sk->sk_data_ready);
+	sk->sk_data_ready(sk);
 }
 
 static void modify_qos(struct atm_vcc *vcc, struct atmsvc_msg *msg)
diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index 1cac25aca637..a8288735f96a 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -26,6 +26,7 @@
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
+#include <trace/events/sock.h>
 
 /*
  *	Given a fragment, queue it on the fragment queue and if the fragment
@@ -417,8 +418,10 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 	ax25_start_idletimer(ax25);
 
 	if (sk) {
-		if (!sock_flag(sk, SOCK_DEAD))
+		if (!sock_flag(sk, SOCK_DEAD)) {
+			trace_sk_data_ready(sk, sk->sk_data_ready);
 			sk->sk_data_ready(sk);
+		}
 		sock_put(sk);
 	} else {
 free:
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 613039ba5dbf..cf4395873524 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -9,6 +9,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/sched/signal.h>
+#include <trace/events/sock.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -161,6 +162,7 @@ static void iso_chan_del(struct sock *sk, int err)
 	parent = bt_sk(sk)->parent;
 	if (parent) {
 		bt_accept_unlink(sk);
+		trace_sk_data_ready(parent, parent->sk_data_ready);
 		parent->sk_data_ready(parent);
 	} else {
 		sk->sk_state_change(sk);
@@ -1469,6 +1471,7 @@ static void iso_conn_ready(struct iso_conn *conn)
 			sk->sk_state = BT_CONNECTED;
 
 		/* Wake up parent */
+		trace_sk_data_ready(parent, parent->sk_data_ready);
 		parent->sk_data_ready(parent);
 
 		release_sock(parent);
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index ca8f07f3542b..7fc4c86b1e06 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -31,6 +31,7 @@
 #include <linux/export.h>
 #include <linux/filter.h>
 #include <linux/sched/signal.h>
+#include <trace/events/sock.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -1584,6 +1585,7 @@ static void l2cap_sock_teardown_cb(struct l2cap_chan *chan, int err)
 
 		if (parent) {
 			bt_accept_unlink(sk);
+			trace_sk_data_ready(parent, parent->sk_data_ready);
 			parent->sk_data_ready(parent);
 		} else {
 			sk->sk_state_change(sk);
@@ -1645,8 +1647,10 @@ static void l2cap_sock_ready_cb(struct l2cap_chan *chan)
 	sk->sk_state = BT_CONNECTED;
 	sk->sk_state_change(sk);
 
-	if (parent)
+	if (parent) {
+		trace_sk_data_ready(parent, parent->sk_data_ready);
 		parent->sk_data_ready(parent);
+	}
 
 	release_sock(sk);
 }
@@ -1658,8 +1662,10 @@ static void l2cap_sock_defer_cb(struct l2cap_chan *chan)
 	lock_sock(sk);
 
 	parent = bt_sk(sk)->parent;
-	if (parent)
+	if (parent) {
+		trace_sk_data_ready(parent, parent->sk_data_ready);
 		parent->sk_data_ready(parent);
+	}
 
 	release_sock(sk);
 }
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 4bf4ea6cbb5e..d6af9bb8da1e 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -28,6 +28,7 @@
 #include <linux/export.h>
 #include <linux/debugfs.h>
 #include <linux/sched/signal.h>
+#include <trace/events/sock.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -55,6 +56,7 @@ static void rfcomm_sk_data_ready(struct rfcomm_dlc *d, struct sk_buff *skb)
 
 	atomic_add(skb->len, &sk->sk_rmem_alloc);
 	skb_queue_tail(&sk->sk_receive_queue, skb);
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 
 	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf)
@@ -83,6 +85,7 @@ static void rfcomm_sk_state_change(struct rfcomm_dlc *d, int err)
 			sock_set_flag(sk, SOCK_ZAPPED);
 			bt_accept_unlink(sk);
 		}
+		trace_sk_data_ready(parent, parent->sk_data_ready);
 		parent->sk_data_ready(parent);
 	} else {
 		if (d->state == BT_CONNECTED)
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 1111da4e2f2b..7d611364952b 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -28,6 +28,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/sched/signal.h>
+#include <trace/events/sock.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -1316,6 +1317,7 @@ static void sco_conn_ready(struct sco_conn *conn)
 			sk->sk_state = BT_CONNECTED;
 
 		/* Wake up parent */
+		trace_sk_data_ready(parent, parent->sk_data_ready);
 		parent->sk_data_ready(parent);
 
 		release_sock(parent);
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 748be7253248..99addf07125a 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -26,6 +26,7 @@
 #include <net/caif/caif_layer.h>
 #include <net/caif/caif_dev.h>
 #include <net/caif/cfpkt.h>
+#include <trace/events/sock.h>
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(AF_CAIF);
@@ -150,10 +151,12 @@ static void caif_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		__skb_queue_tail(list, skb);
 	spin_unlock_irqrestore(&list->lock, flags);
 out:
-	if (queued)
+	if (queued) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
-	else
+	} else {
 		kfree_skb(skb);
+	}
 }
 
 /* Packet Receive Callback function called from CAIF Stack */
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 188f8558d27d..68ea92ef147d 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1114,6 +1114,7 @@ static void sk_psock_strp_data_ready(struct sock *sk)
 	psock = sk_psock(sk);
 	if (likely(psock)) {
 		if (tls_sw_has_ctx_rx(sk)) {
+			trace_sk_data_ready(sk, psock->saved_data_ready);
 			psock->saved_data_ready(sk);
 		} else {
 			write_lock_bh(&sk->sk_callback_lock);
diff --git a/net/core/sock.c b/net/core/sock.c
index eeb6cbac6f49..9a0ede730a7b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -502,8 +502,10 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	__skb_queue_tail(list, skb);
 	spin_unlock_irqrestore(&list->lock, flags);
 
-	if (!sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_DEAD)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 	return 0;
 }
 EXPORT_SYMBOL(__sock_queue_rcv_skb);
diff --git a/net/dccp/input.c b/net/dccp/input.c
index 2cbb757a894f..5c42c6a4a356 100644
--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 
 #include <net/sock.h>
+#include <trace/events/sock.h>
 
 #include "ackvec.h"
 #include "ccid.h"
@@ -24,6 +25,7 @@ static void dccp_enqueue_skb(struct sock *sk, struct sk_buff *skb)
 	__skb_pull(skb, dccp_hdr(skb)->dccph_doff * 4);
 	__skb_queue_tail(&sk->sk_receive_queue, skb);
 	skb_set_owner_r(skb, sk);
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 }
 
diff --git a/net/dccp/minisocks.c b/net/dccp/minisocks.c
index 64d805b27add..663f07576a52 100644
--- a/net/dccp/minisocks.c
+++ b/net/dccp/minisocks.c
@@ -15,6 +15,7 @@
 #include <net/sock.h>
 #include <net/xfrm.h>
 #include <net/inet_timewait_sock.h>
+#include <trace/events/sock.h>
 
 #include "ackvec.h"
 #include "ccid.h"
@@ -229,8 +230,10 @@ int dccp_child_process(struct sock *parent, struct sock *child,
 					     skb->len);
 
 		/* Wakeup parent, send SIGIO */
-		if (state == DCCP_RESPOND && child->sk_state != state)
+		if (state == DCCP_RESPOND && child->sk_state != state) {
+			trace_sk_data_ready(parent, parent->sk_data_ready);
 			parent->sk_data_ready(parent);
+		}
 	} else {
 		/* Alas, it is possible again, because we do lookup
 		 * in main socket hash table and lock on listening
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bc2ea12221f9..86e44250affc 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -76,6 +76,7 @@
 #include <linux/ipsec.h>
 #include <asm/unaligned.h>
 #include <linux/errqueue.h>
+#include <trace/events/sock.h>
 #include <trace/events/tcp.h>
 #include <linux/jump_label_ratelimit.h>
 #include <net/busy_poll.h>
@@ -4795,6 +4796,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 		tcp_drop_reason(sk, skb, SKB_DROP_REASON_PROTO_MEM);
 		return;
@@ -5000,8 +5002,10 @@ int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
 
 void tcp_data_ready(struct sock *sk)
 {
-	if (tcp_epollin_ready(sk, sk->sk_rcvlowat) || sock_flag(sk, SOCK_DONE))
+	if (tcp_epollin_ready(sk, sk->sk_rcvlowat) || sock_flag(sk, SOCK_DONE)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 }
 
 static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
@@ -5047,6 +5051,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
 			reason = SKB_DROP_REASON_PROTO_MEM;
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP);
+			trace_sk_data_ready(sk, sk->sk_data_ready);
 			sk->sk_data_ready(sk);
 			goto drop;
 		}
@@ -5664,8 +5669,10 @@ static void tcp_urg(struct sock *sk, struct sk_buff *skb, const struct tcphdr *t
 			if (skb_copy_bits(skb, ptr, &tmp, 1))
 				BUG();
 			WRITE_ONCE(tp->urg_data, TCP_URG_VALID | tmp);
-			if (!sock_flag(sk, SOCK_DEAD))
+			if (!sock_flag(sk, SOCK_DEAD)) {
+				trace_sk_data_ready(sk, sk->sk_data_ready);
 				sk->sk_data_ready(sk);
+			}
 		}
 	}
 }
@@ -7018,6 +7025,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			sock_put(fastopen_sk);
 			goto drop_and_free;
 		}
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 		bh_unlock_sock(fastopen_sk);
 		sock_put(fastopen_sk);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 442838ab0253..fe528da25d78 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -22,6 +22,7 @@
 #include <net/tcp.h>
 #include <net/xfrm.h>
 #include <net/busy_poll.h>
+#include <trace/events/sock.h>
 
 static bool tcp_in_window(u32 seq, u32 end_seq, u32 s_win, u32 e_win)
 {
@@ -855,8 +856,10 @@ int tcp_child_process(struct sock *parent, struct sock *child,
 	if (!sock_owned_by_user(child)) {
 		ret = tcp_rcv_state_process(child, skb);
 		/* Wakeup parent, send SIGIO */
-		if (state == TCP_SYN_RECV && child->sk_state != state)
+		if (state == TCP_SYN_RECV && child->sk_state != state) {
+			trace_sk_data_ready(parent, parent->sk_data_ready);
 			parent->sk_data_ready(parent);
+		}
 	} else {
 		/* Alas, it is possible again, because we do lookup
 		 * in main socket hash table and lock on listening
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d63118ce5900..3092962129f2 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -108,6 +108,7 @@
 #include <linux/static_key.h>
 #include <linux/btf_ids.h>
 #include <trace/events/skb.h>
+#include <trace/events/sock.h>
 #include <net/busy_poll.h>
 #include "udp_impl.h"
 #include <net/sock_reuseport.h>
@@ -1582,8 +1583,10 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 	__skb_queue_tail(list, skb);
 	spin_unlock(&list->lock);
 
-	if (!sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_DEAD)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 
 	busylock_release(busy);
 	return 0;
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 498a0c35b7bb..7edc3890b9c1 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -31,6 +31,7 @@
 #include <asm/ebcdic.h>
 #include <asm/cpcmd.h>
 #include <linux/kmod.h>
+#include <trace/events/sock.h>
 
 #include <net/iucv/af_iucv.h>
 
@@ -1665,6 +1666,7 @@ static int iucv_callback_connreq(struct iucv_path *path,
 
 	/* Wake up accept */
 	nsk->sk_state = IUCV_CONNECTED;
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 	err = 0;
 fail:
@@ -1885,6 +1887,7 @@ static int afiucv_hs_callback_syn(struct sock *sk, struct sk_buff *skb)
 	if (!err) {
 		iucv_accept_enqueue(sk, nsk);
 		nsk->sk_state = IUCV_CONNECTED;
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	} else
 		iucv_sock_kill(nsk);
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 1215c863e1c4..3b1a5807a449 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -28,6 +28,7 @@
 #include <net/netns/generic.h>
 #include <net/sock.h>
 #include <uapi/linux/kcm.h>
+#include <trace/events/sock.h>
 
 unsigned int kcm_net_id;
 
@@ -206,8 +207,10 @@ static int kcm_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	skb_queue_tail(list, skb);
 
-	if (!sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_DEAD)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 
 	return 0;
 }
diff --git a/net/key/af_key.c b/net/key/af_key.c
index c85df5b958d2..17e3295945a3 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -28,6 +28,7 @@
 #include <net/xfrm.h>
 
 #include <net/sock.h>
+#include <trace/events/sock.h>
 
 #define _X2KEY(x) ((x) == XFRM_INF ? 0 : (x))
 #define _KEY2X(x) ((x) == 0 ? XFRM_INF : (x))
@@ -201,6 +202,7 @@ static int pfkey_broadcast_one(struct sk_buff *skb, gfp_t allocation,
 	if (skb) {
 		skb_set_owner_r(skb, sk);
 		skb_queue_tail(&sk->sk_receive_queue, skb);
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 		err = 0;
 	}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 866dfad3cde6..27a62209ee68 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -26,6 +26,7 @@
 #include "protocol.h"
 #include "mib.h"
 
+#include <trace/events/sock.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/mptcp.h>
 
@@ -815,8 +816,10 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 
 	/* Wake-up the reader only for in-sequence data */
 	mptcp_data_lock(sk);
-	if (move_skbs_to_msk(msk, ssk))
+	if (move_skbs_to_msk(msk, ssk)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 
 	mptcp_data_unlock(sk);
 }
@@ -910,6 +913,7 @@ static void mptcp_check_for_eof(struct mptcp_sock *msk)
 		sk->sk_shutdown |= RCV_SHUTDOWN;
 
 		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	}
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index c7d49fb6e7bd..8409e46c58d8 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -26,6 +26,7 @@
 #include "mib.h"
 
 #include <trace/events/mptcp.h>
+#include <trace/events/sock.h>
 
 static void mptcp_subflow_ops_undo_override(struct sock *ssk);
 
@@ -1382,6 +1383,7 @@ static void subflow_data_ready(struct sock *sk)
 		if (reqsk_queue_empty(&inet_csk(sk)->icsk_accept_queue))
 			return;
 
+		trace_sk_data_ready(parent, parent->sk_data_ready);
 		parent->sk_data_ready(parent);
 		return;
 	}
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index a662e8a5ff84..0532cb50701f 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -69,6 +69,7 @@
 #include <net/sock.h>
 #include <net/scm.h>
 #include <net/netlink.h>
+#include <trace/events/sock.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/netlink.h>
 
@@ -1263,6 +1264,7 @@ static int __netlink_sendskb(struct sock *sk, struct sk_buff *skb)
 	netlink_deliver_tap(sock_net(sk), skb);
 
 	skb_queue_tail(&sk->sk_receive_queue, skb);
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 	return len;
 }
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 6f7f4392cffb..5998464f832b 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -40,6 +40,7 @@
 #include <net/tcp_states.h>
 #include <net/arp.h>
 #include <linux/init.h>
+#include <trace/events/sock.h>
 
 static int nr_ndevs = 4;
 
@@ -1015,8 +1016,10 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	sk_acceptq_added(sk);
 	skb_queue_head(&sk->sk_receive_queue, skb);
 
-	if (!sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_DEAD)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 
 	bh_unlock_sock(sk);
 	sock_put(sk);
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 3364caabef8b..3e7ff57a8c65 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/nfc.h>
+#include <trace/events/sock.h>
 
 #include "nfc.h"
 #include "llcp.h"
@@ -973,6 +974,7 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 	new_sk->sk_state = LLCP_CONNECTED;
 
 	/* Wake the listening processes */
+	trace_sk_data_ready(parent, parent->sk_data_ready);
 	parent->sk_data_ready(parent);
 
 	/* Send CC */
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d3f6db350de7..5925b58cb5de 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -93,6 +93,7 @@
 #include <linux/bpf.h>
 #include <net/compat.h>
 #include <linux/netfilter_netdev.h>
+#include <trace/events/sock.h>
 
 #include "internal.h"
 
@@ -829,6 +830,7 @@ static void prb_close_block(struct tpacket_kbdq_core *pkc1,
 	/* Flush the block */
 	prb_flush_block(pkc1, pbd1, status);
 
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 
 	pkc1->kactive_blk_num = GET_NEXT_PRB_BLK_NUM(pkc1);
@@ -2212,6 +2214,7 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb_clear_delivery_time(skb);
 	__skb_queue_tail(&sk->sk_receive_queue, skb);
 	spin_unlock(&sk->sk_receive_queue.lock);
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 	return 0;
 
@@ -2485,6 +2488,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 		__packet_set_status(po, h.raw, status);
 		__clear_bit(slot_id, po->rx_ring.rx_owner_map);
 		spin_unlock(&sk->sk_receive_queue.lock);
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	} else if (po->tp_version == TPACKET_V3) {
 		prb_clear_blk_fill_status(&po->rx_ring);
@@ -2507,6 +2511,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	atomic_inc(&po->tp_drops);
 	is_drop_n_account = true;
 
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 	kfree_skb(copy_skb);
 	goto drop_n_restore;
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 83ea13a50690..8bfa1b6b9420 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -22,6 +22,7 @@
 #include <net/phonet/phonet.h>
 #include <net/phonet/pep.h>
 #include <net/phonet/gprs.h>
+#include <trace/events/sock.h>
 
 /* sk_state values:
  * TCP_CLOSE		sock not in use yet
@@ -451,8 +452,10 @@ static int pipe_do_rcv(struct sock *sk, struct sk_buff *skb)
 	skb->dev = NULL;
 	skb_set_owner_r(skb, sk);
 	skb_queue_tail(queue, skb);
-	if (!sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_DEAD)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 	return NET_RX_SUCCESS;
 }
 
@@ -575,8 +578,10 @@ static int pipe_handler_do_rcv(struct sock *sk, struct sk_buff *skb)
 		skb->dev = NULL;
 		skb_set_owner_r(skb, sk);
 		skb_queue_tail(&sk->sk_receive_queue, skb);
-		if (!sock_flag(sk, SOCK_DEAD))
+		if (!sock_flag(sk, SOCK_DEAD)) {
+			trace_sk_data_ready(sk, sk->sk_data_ready);
 			sk->sk_data_ready(sk);
+		}
 		return NET_RX_SUCCESS;
 
 	case PNS_PEP_CONNECT_RESP:
@@ -683,8 +688,10 @@ static int pep_do_rcv(struct sock *sk, struct sk_buff *skb)
 		}
 		skb_queue_head(&sk->sk_receive_queue, skb);
 		sk_acceptq_added(sk);
-		if (!sock_flag(sk, SOCK_DEAD))
+		if (!sock_flag(sk, SOCK_DEAD)) {
+			trace_sk_data_ready(sk, sk->sk_data_ready);
 			sk->sk_data_ready(sk);
+		}
 		return NET_RX_SUCCESS;
 
 	case PNS_PEP_DISCONNECT_REQ:
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 36fefc3957d7..c063d639f1c5 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -43,6 +43,7 @@
 #include <net/tcp_states.h>
 #include <net/ip.h>
 #include <net/arp.h>
+#include <trace/events/sock.h>
 
 static int rose_ndevs = 10;
 
@@ -1055,8 +1056,10 @@ int rose_rx_call_request(struct sk_buff *skb, struct net_device *dev, struct ros
 
 	rose_start_heartbeat(make);
 
-	if (!sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_DEAD)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 
 	return 1;
 }
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 7e39c262fd79..90138ac63d94 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -14,6 +14,7 @@
 
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
+#include <trace/events/sock.h>
 #include "ar-internal.h"
 
 /*
@@ -49,6 +50,7 @@ void rxrpc_notify_socket(struct rxrpc_call *call)
 
 			if (!sock_flag(sk, SOCK_DEAD)) {
 				_debug("call %ps", sk->sk_data_ready);
+				trace_sk_data_ready(sk, sk->sk_data_ready);
 				sk->sk_data_ready(sk);
 			}
 		}
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index bb22b71df7a3..497d37ef0c43 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -20,6 +20,7 @@
 #include <net/sctp/sm.h>
 #include <net/sctp/ulpevent.h>
 #include <linux/sctp.h>
+#include <trace/events/sock.h>
 
 static struct sctp_chunk *sctp_make_idatafrag_empty(
 					const struct sctp_association *asoc,
@@ -498,6 +499,7 @@ static int sctp_enqueue_event(struct sctp_ulpq *ulpq,
 
 	if (!sp->data_ready_signalled) {
 		sp->data_ready_signalled = 1;
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	}
 
@@ -1000,6 +1002,7 @@ static void sctp_intl_stream_abort_pd(struct sctp_ulpq *ulpq, __u16 sid,
 
 		if (!sp->data_ready_signalled) {
 			sp->data_ready_signalled = 1;
+			trace_sk_data_ready(sk, sk->sk_data_ready);
 			sk->sk_data_ready(sk);
 		}
 	}
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 0a8510a0c5e6..ba2b9c4e0095 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -27,6 +27,7 @@
 #include <net/sctp/structs.h>
 #include <net/sctp/sctp.h>
 #include <net/sctp/sm.h>
+#include <trace/events/sock.h>
 
 /* Forward declarations for internal helpers.  */
 static struct sctp_ulpevent *sctp_ulpq_reasm(struct sctp_ulpq *ulpq,
@@ -254,6 +255,7 @@ int sctp_ulpq_tail_event(struct sctp_ulpq *ulpq, struct sk_buff_head *skb_list)
 	if (queue == &sk->sk_receive_queue && !sp->data_ready_signalled) {
 		if (!sock_owned_by_user(sk))
 			sp->data_ready_signalled = 1;
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	}
 	return 1;
@@ -1127,6 +1129,7 @@ void sctp_ulpq_abort_pd(struct sctp_ulpq *ulpq, gfp_t gfp)
 	/* If there is data waiting, send it up the socket now. */
 	if ((sctp_ulpq_clear_pd(ulpq) || ev) && !sp->data_ready_signalled) {
 		sp->data_ready_signalled = 1;
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	}
 }
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 31db7438857c..9eb5c52eefef 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -14,6 +14,7 @@
 
 #include <net/sock.h>
 #include <net/tcp.h>
+#include <trace/events/sock.h>
 
 #include "smc.h"
 #include "smc_tx.h"
@@ -425,6 +426,7 @@ static void smc_close_passive_work(struct work_struct *work)
 	}
 
 wakeup:
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk); /* wakeup blocked rcvbuf consumers */
 	sk->sk_write_space(sk); /* wakeup blocked sndbuf producers */
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index f1c3b8eb4b3d..7db9cf1c5948 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -37,6 +37,7 @@
 
 #include <linux/rhashtable.h>
 #include <linux/sched/signal.h>
+#include <trace/events/sock.h>
 
 #include "core.h"
 #include "name_table.h"
@@ -2385,6 +2386,7 @@ static void tipc_sk_filter_rcv(struct sock *sk, struct sk_buff *skb,
 		skb_set_owner_r(skb, sk);
 		trace_tipc_sk_overlimit2(sk, skb, TIPC_DUMP_ALL,
 					 "rcvq >90% allocated!");
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
 	}
 }
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 5522865deae9..4e138081f01a 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -43,6 +43,7 @@
 #include "bearer.h"
 #include <net/sock.h>
 #include <linux/module.h>
+#include <trace/events/sock.h>
 
 /* Number of messages to send before rescheduling */
 #define MAX_SEND_MSG_COUNT	25
@@ -476,6 +477,7 @@ static void tipc_topsrv_accept(struct work_struct *work)
 		write_unlock_bh(&newsk->sk_callback_lock);
 
 		/* Wake up receive process in case of 'SYN+' message */
+		trace_sk_data_ready(newsk, newsk->sk_data_ready);
 		newsk->sk_data_ready(newsk);
 	}
 }
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 264cf367e265..0667891f2fcd 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -43,6 +43,7 @@
 
 #include <net/strparser.h>
 #include <net/tls.h>
+#include <trace/events/sock.h>
 
 #include "tls.h"
 
@@ -2271,9 +2272,11 @@ int tls_rx_msg_size(struct tls_strparser *strp, struct sk_buff *skb)
 void tls_rx_msg_ready(struct tls_strparser *strp)
 {
 	struct tls_sw_context_rx *ctx;
+	struct sock *sk = strp->sk;
 
 	ctx = container_of(strp, struct tls_sw_context_rx, strp);
-	ctx->saved_data_ready(strp->sk);
+	trace_sk_data_ready(sk, ctx->saved_data_ready);
+	ctx->saved_data_ready(sk);
 }
 
 static void tls_data_ready(struct sock *sk)
@@ -2286,8 +2289,10 @@ static void tls_data_ready(struct sock *sk)
 
 	psock = sk_psock_get(sk);
 	if (psock) {
-		if (!list_empty(&psock->ingress_msg))
+		if (!list_empty(&psock->ingress_msg)) {
+			trace_sk_data_ready(sk, ctx->saved_data_ready);
 			ctx->saved_data_ready(sk);
+		}
 		sk_psock_put(sk, psock);
 	}
 }
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c955c7253d4b..bdd140138c19 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -115,6 +115,7 @@
 #include <linux/freezer.h>
 #include <linux/file.h>
 #include <linux/btf_ids.h>
+#include <trace/events/sock.h>
 
 #include "scm.h"
 
@@ -1627,6 +1628,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	__skb_queue_tail(&other->sk_receive_queue, skb);
 	spin_unlock(&other->sk_receive_queue.lock);
 	unix_state_unlock(other);
+	trace_sk_data_ready(other, other->sk_data_ready);
 	other->sk_data_ready(other);
 	sock_put(other);
 	return 0;
@@ -2072,6 +2074,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	scm_stat_add(other, skb);
 	skb_queue_tail(&other->sk_receive_queue, skb);
 	unix_state_unlock(other);
+	trace_sk_data_ready(other, other->sk_data_ready);
 	other->sk_data_ready(other);
 	sock_put(other);
 	scm_destroy(&scm);
@@ -2136,6 +2139,7 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	skb_queue_tail(&other->sk_receive_queue, skb);
 	sk_send_sigurg(other);
 	unix_state_unlock(other);
+	trace_sk_data_ready(other, other->sk_data_ready);
 	other->sk_data_ready(other);
 
 	return err;
@@ -2228,6 +2232,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		scm_stat_add(other, skb);
 		skb_queue_tail(&other->sk_receive_queue, skb);
 		unix_state_unlock(other);
+		trace_sk_data_ready(other, other->sk_data_ready);
 		other->sk_data_ready(other);
 		sent += size;
 	}
@@ -2356,6 +2361,7 @@ static ssize_t unix_stream_sendpage(struct socket *socket, struct page *page,
 	unix_state_unlock(other);
 	mutex_unlock(&unix_sk(other)->iolock);
 
+	trace_sk_data_ready(other, other->sk_data_ready);
 	other->sk_data_ready(other);
 	scm_destroy(&scm);
 	return size;
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ee418701cdee..1ad731eb1482 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -110,6 +110,7 @@
 #include <linux/workqueue.h>
 #include <net/sock.h>
 #include <net/af_vsock.h>
+#include <trace/events/sock.h>
 
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
 static void vsock_sk_destruct(struct sock *sk);
@@ -887,8 +888,10 @@ void vsock_data_ready(struct sock *sk)
 	struct vsock_sock *vsk = vsock_sk(sk);
 
 	if (vsock_stream_has_data(vsk) >= sk->sk_rcvlowat ||
-	    sock_flag(sk, SOCK_DONE))
+	    sock_flag(sk, SOCK_DONE)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 }
 EXPORT_SYMBOL_GPL(vsock_data_ready);
 
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 59c3e2697069..dfb753261440 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -14,6 +14,7 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
 #include <asm/hyperv-tlfs.h>
+#include <trace/events/sock.h>
 
 /* Older (VMBUS version 'VERSION_WIN10' or before) Windows hosts have some
  * stricter requirements on the hv_sock ring buffer size of six 4K pages.
@@ -251,8 +252,10 @@ static void hvs_channel_cb(void *ctx)
 	struct hvsock *hvs = vsk->trans;
 	struct vmbus_channel *chan = hvs->chan;
 
-	if (hvs_channel_readable(chan))
+	if (hvs_channel_readable(chan)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 
 	if (hv_get_bytes_to_write(&chan->outbound) > 0)
 		sk->sk_write_space(sk);
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 35863132f4f1..c7eb4771b9c0 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -17,6 +17,7 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
 
+#include <trace/events/sock.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/vsock_virtio_transport_common.h>
 
@@ -1223,6 +1224,7 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
 
 	release_sock(child);
 
+	trace_sk_data_ready(sk, sk->sk_data_ready);
 	sk->sk_data_ready(sk);
 	return 0;
 }
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 842c94286d31..d79506d53009 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -26,6 +26,7 @@
 #include <linux/workqueue.h>
 #include <net/sock.h>
 #include <net/af_vsock.h>
+#include <trace/events/sock.h>
 
 #include "vmci_transport_notify.h"
 
@@ -1254,6 +1255,7 @@ vmci_transport_recv_connecting_server(struct sock *listener,
 	/* Callers of accept() will be waiting on the listening socket, not
 	 * the pending socket.
 	 */
+	trace_sk_data_ready(listener, listener->sk_data_ready);
 	listener->sk_data_ready(listener);
 
 	return 0;
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 3b55502b2965..3f252226c241 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -53,6 +53,7 @@
 #include <linux/init.h>
 #include <linux/compat.h>
 #include <linux/ctype.h>
+#include <trace/events/sock.h>
 
 #include <net/x25.h>
 #include <net/compat.h>
@@ -1080,8 +1081,10 @@ int x25_rx_call_request(struct sk_buff *skb, struct x25_neigh *nb,
 
 	x25_start_heartbeat(make);
 
-	if (!sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_DEAD)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 	rc = 1;
 	sock_put(sk);
 out:
diff --git a/net/x25/x25_in.c b/net/x25/x25_in.c
index b981a4828d08..7eb444723633 100644
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -28,6 +28,7 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/x25.h>
+#include <trace/events/sock.h>
 
 static int x25_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 {
@@ -73,8 +74,10 @@ static int x25_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 
 	skb_set_owner_r(skbn, sk);
 	skb_queue_tail(&sk->sk_receive_queue, skbn);
-	if (!sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_DEAD)) {
+		trace_sk_data_ready(sk, sk->sk_data_ready);
 		sk->sk_data_ready(sk);
+	}
 
 	return 0;
 }
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 974eb97b77d2..2f81405b4e05 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -6,6 +6,7 @@
 #include <net/espintcp.h>
 #include <linux/skmsg.h>
 #include <net/inet_common.h>
+#include <trace/events/sock.h>
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6_stubs.h>
 #endif
@@ -24,6 +25,7 @@ static void handle_nonesp(struct espintcp_ctx *ctx, struct sk_buff *skb,
 
 	memset(skb->cb, 0, sizeof(skb->cb));
 	skb_queue_tail(&ctx->ike_queue, skb);
+	trace_sk_data_ready(sk, ctx->saved_data_ready);
 	ctx->saved_data_ready(sk);
 }
 
-- 
2.20.1


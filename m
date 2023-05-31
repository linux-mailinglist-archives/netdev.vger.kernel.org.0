Return-Path: <netdev+bounces-6641-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FAD77172A6
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7EF928139C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3B51390;
	Wed, 31 May 2023 00:36:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BA0184C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:36:02 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CCAE56
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:35:35 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64d2f99c8c3so3768042b3a.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685493315; x=1688085315;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ECEbv8WYzN/7p66VtzzgcychOH+xVXi7C32sAHEpkUg=;
        b=cSxv4xZ3iyeDtJPCHK+5eFfBjk4oHfP/YX1GnGNqvWz/3sxU/rkvCs1zsC2XMBOyww
         p+9KYwNrQeHUacfPEAdN5lSGiWtDk6dawZJu/WV0RYj198qOoZyKVv7vwrTEGBEkYIpZ
         wN/ix13XsaKPPYPK8Pb+Nfo0lpxzolCdIqhNMtNcR4X4QWuh0NQqkTJlyhEQlI4R/Upc
         3kwODGnzdKqS5xJspCPq3Z3jxAW8K0DBjVHG+cmJYPTXbfmyfTUkYbCIH8RNK5eHp48a
         8EB7rOaPI0znjHJAgcmMJoeoPjDe1ckODc5VANQFXEA4ILFhtJxOyB/53QdEdYF9Ep95
         pZvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685493315; x=1688085315;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ECEbv8WYzN/7p66VtzzgcychOH+xVXi7C32sAHEpkUg=;
        b=V9FmoeBg8IiFnpmqHDay7ZdqLoQlyFvDaQaybWo1AU2BgF0wUQWwRoh8cmYl4CozFU
         dXqWrwHcFkkHJW4c6PuO1QDSG0hf5EIicbXWQ/q9i9TViigXbT5PMwyrF/H8ElB6YaxF
         ABzbd1aEX0oLC5e6OSH27EbIIFQtObRJToYAuS/JT1I2OepYGDwGeuG7QMNT5mG8Cs49
         iSoPqduicV9AdiPTcF3LnMEx2mQEFl6Ik6L3De61NYtPa0wB7nFRxfaHa3yZEo0FfHS5
         LN5Iq86SCpl6bnXOO+SFTvWU63Kk7N94IJby0qyypKeo3AvWbJDmFN0bChvls4qXhm5l
         LZhA==
X-Gm-Message-State: AC+VfDxcYioa+1pH7/AosLm5irDg+3gLrslCqBY3cnZXkI2vOsXTvvfJ
	2Y9U98TWK6FwFplmwcwvhhatyA==
X-Google-Smtp-Source: ACHHUZ4pNNKVMK6cw7cM4l42GC/yDOixgoGS9RPcY8GbQyUrt3BVJA0pvBHcegLCZOxkajr2q4lE2w==
X-Received: by 2002:a05:6a00:1491:b0:62a:4503:53ba with SMTP id v17-20020a056a00149100b0062a450353bamr4930371pfu.26.1685493315348;
        Tue, 30 May 2023 17:35:15 -0700 (PDT)
Received: from [172.17.0.2] (c-67-170-131-147.hsd1.wa.comcast.net. [67.170.131.147])
        by smtp.gmail.com with ESMTPSA id j12-20020a62b60c000000b0064cb0845c77sm2151340pff.122.2023.05.30.17.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 17:35:15 -0700 (PDT)
From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Date: Wed, 31 May 2023 00:35:10 +0000
Subject: [PATCH RFC net-next v3 6/8] virtio/vsock: support dgrams
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v3-6-c2414413ef6a@bytedance.com>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryantan@vmware.com>, 
 Vishnu Dasa <vdasa@vmware.com>, 
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This commit adds support for datagrams over virtio/vsock.

Message boundaries are preserved on a per-skb and per-vq entry basis.
Messages are copied in whole from the user to an SKB, which in turn is
added to the scatterlist for the virtqueue in whole for the device.
Messages do not straddle skbs and they do not straddle packets.
Messages may be truncated by the receiving user if their buffer is
shorter than the message.

Other properties of vsock datagrams:
- Datagrams self-throttle at the per-socket sk_sndbuf threshold.
- The same virtqueue is used as is used for streams and seqpacket flows
- Credits are not used for datagrams
- Packets are dropped silently by the device, which means the virtqueue
  will still get kicked even during high packet loss, so long as the
  socket does not exceed sk_sndbuf.

Future work might include finding a way to reduce the virtqueue kick
rate for datagram flows with high packet loss.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c                   |  27 +++-
 include/linux/virtio_vsock.h            |   5 +-
 include/net/af_vsock.h                  |   1 +
 include/uapi/linux/virtio_vsock.h       |   1 +
 net/vmw_vsock/af_vsock.c                |  41 ++++++-
 net/vmw_vsock/virtio_transport.c        |  23 +++-
 net/vmw_vsock/virtio_transport_common.c | 210 ++++++++++++++++++++++++--------
 net/vmw_vsock/vsock_loopback.c          |   8 +-
 8 files changed, 253 insertions(+), 63 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 8f0082da5e70..159c1a22c1a8 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -32,7 +32,8 @@
 enum {
 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
 			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
-			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
+			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
 };
 
 enum {
@@ -56,6 +57,7 @@ struct vhost_vsock {
 	atomic_t queued_replies;
 
 	u32 guest_cid;
+	bool dgram_allow;
 	bool seqpacket_allow;
 };
 
@@ -394,6 +396,7 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
 	return val < vq->num;
 }
 
+static bool vhost_transport_dgram_allow(u32 cid, u32 port);
 static bool vhost_transport_seqpacket_allow(u32 remote_cid);
 
 static struct virtio_transport vhost_transport = {
@@ -410,10 +413,11 @@ static struct virtio_transport vhost_transport = {
 		.cancel_pkt               = vhost_transport_cancel_pkt,
 
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_allow              = virtio_transport_dgram_allow,
+		.dgram_allow              = vhost_transport_dgram_allow,
 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
 		.dgram_get_port		  = virtio_transport_dgram_get_port,
 		.dgram_get_length	  = virtio_transport_dgram_get_length,
+		.dgram_payload_offset	  = 0,
 
 		.stream_enqueue           = virtio_transport_stream_enqueue,
 		.stream_dequeue           = virtio_transport_stream_dequeue,
@@ -446,6 +450,22 @@ static struct virtio_transport vhost_transport = {
 	.send_pkt = vhost_transport_send_pkt,
 };
 
+static bool vhost_transport_dgram_allow(u32 cid, u32 port)
+{
+	struct vhost_vsock *vsock;
+	bool dgram_allow = false;
+
+	rcu_read_lock();
+	vsock = vhost_vsock_get(cid);
+
+	if (vsock)
+		dgram_allow = vsock->dgram_allow;
+
+	rcu_read_unlock();
+
+	return dgram_allow;
+}
+
 static bool vhost_transport_seqpacket_allow(u32 remote_cid)
 {
 	struct vhost_vsock *vsock;
@@ -802,6 +822,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
 		vsock->seqpacket_allow = true;
 
+	if (features & (1ULL << VIRTIO_VSOCK_F_DGRAM))
+		vsock->dgram_allow = true;
+
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		vq = &vsock->vqs[i];
 		mutex_lock(&vq->mutex);
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 73afa09f4585..237ca87a2ecd 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -216,7 +216,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
 u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
 bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
 bool virtio_transport_stream_allow(u32 cid, u32 port);
-bool virtio_transport_dgram_allow(u32 cid, u32 port);
 int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid);
 int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port);
 int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len);
@@ -247,4 +246,8 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
 void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
 int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
 int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
+void virtio_transport_init_dgram_bind_tables(void);
+int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid);
+int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port);
+int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len);
 #endif /* _LINUX_VIRTIO_VSOCK_H */
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 7bedb9ee7e3e..c115e655b4f5 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -225,6 +225,7 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
 				     void (*fn)(struct sock *sk));
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
 bool vsock_find_cid(unsigned int cid);
+struct sock *vsock_find_bound_dgram_socket(struct sockaddr_vm *addr);
 
 /**** TAP ****/
 
diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 772487c66f9d..2cad35e39a61 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -70,6 +70,7 @@ struct virtio_vsock_hdr {
 enum virtio_vsock_type {
 	VIRTIO_VSOCK_TYPE_STREAM = 1,
 	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
+	VIRTIO_VSOCK_TYPE_DGRAM = 3,
 };
 
 enum virtio_vsock_op {
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ed02a5592e43..e8c70069d77d 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -180,6 +180,10 @@ struct list_head vsock_connected_table[VSOCK_HASH_SIZE];
 EXPORT_SYMBOL_GPL(vsock_connected_table);
 DEFINE_SPINLOCK(vsock_table_lock);
 EXPORT_SYMBOL_GPL(vsock_table_lock);
+struct list_head vsock_dgram_bind_table[VSOCK_HASH_SIZE];
+EXPORT_SYMBOL_GPL(vsock_dgram_bind_table);
+DEFINE_SPINLOCK(vsock_dgram_table_lock);
+EXPORT_SYMBOL_GPL(vsock_dgram_table_lock);
 
 /* Autobind this socket to the local address if necessary. */
 static int vsock_auto_bind(struct vsock_sock *vsk)
@@ -202,6 +206,9 @@ static void vsock_init_tables(void)
 
 	for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++)
 		INIT_LIST_HEAD(&vsock_connected_table[i]);
+
+	for (i = 0; i < ARRAY_SIZE(vsock_dgram_bind_table); i++)
+		INIT_LIST_HEAD(&vsock_dgram_bind_table[i]);
 }
 
 static void __vsock_insert_bound(struct list_head *list,
@@ -248,6 +255,23 @@ struct sock *vsock_find_bound_socket_common(struct sockaddr_vm *addr,
 	return NULL;
 }
 
+struct sock *
+vsock_find_bound_dgram_socket(struct sockaddr_vm *addr)
+{
+	struct sock *sk;
+
+	spin_lock_bh(&vsock_dgram_table_lock);
+	sk = vsock_find_bound_socket_common(addr,
+					    &vsock_dgram_bind_table[VSOCK_HASH(addr)]);
+	if (sk)
+		sock_hold(sk);
+
+	spin_unlock_bh(&vsock_dgram_table_lock);
+
+	return sk;
+}
+EXPORT_SYMBOL_GPL(vsock_find_bound_dgram_socket);
+
 static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
 {
 	return vsock_find_bound_socket_common(addr, vsock_bound_sockets(addr));
@@ -730,11 +754,18 @@ int vsock_bind_stream(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL(vsock_bind_stream);
 
-static int __vsock_bind_dgram(struct vsock_sock *vsk,
-			      struct sockaddr_vm *addr)
+static int vsock_bind_dgram(struct vsock_sock *vsk,
+			    struct sockaddr_vm *addr)
 {
-	if (!vsk->transport || !vsk->transport->dgram_bind)
-		return -EINVAL;
+	if (!vsk->transport || !vsk->transport->dgram_bind) {
+		int retval;
+		spin_lock_bh(&vsock_dgram_table_lock);
+		retval = vsock_bind_common(vsk, addr, vsock_dgram_bind_table,
+					   VSOCK_HASH_SIZE);
+		spin_unlock_bh(&vsock_dgram_table_lock);
+
+		return retval;
+	}
 
 	return vsk->transport->dgram_bind(vsk, addr);
 }
@@ -765,7 +796,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
 		break;
 
 	case SOCK_DGRAM:
-		retval = __vsock_bind_dgram(vsk, addr);
+		retval = vsock_bind_dgram(vsk, addr);
 		break;
 
 	default:
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 1b7843a7779a..7160a3104218 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -63,6 +63,7 @@ struct virtio_vsock {
 
 	u32 guest_cid;
 	bool seqpacket_allow;
+	bool dgram_allow;
 };
 
 static u32 virtio_transport_get_local_cid(void)
@@ -413,6 +414,7 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
+static bool virtio_transport_dgram_allow(u32 cid, u32 port);
 static bool virtio_transport_seqpacket_allow(u32 remote_cid);
 
 static struct virtio_transport virtio_transport = {
@@ -465,6 +467,21 @@ static struct virtio_transport virtio_transport = {
 	.send_pkt = virtio_transport_send_pkt,
 };
 
+static bool virtio_transport_dgram_allow(u32 cid, u32 port)
+{
+	struct virtio_vsock *vsock;
+	bool dgram_allow;
+
+	dgram_allow = false;
+	rcu_read_lock();
+	vsock = rcu_dereference(the_virtio_vsock);
+	if (vsock)
+		dgram_allow = vsock->dgram_allow;
+	rcu_read_unlock();
+
+	return dgram_allow;
+}
+
 static bool virtio_transport_seqpacket_allow(u32 remote_cid)
 {
 	struct virtio_vsock *vsock;
@@ -658,6 +675,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
 		vsock->seqpacket_allow = true;
 
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
+		vsock->dgram_allow = true;
+
 	vdev->priv = vsock;
 
 	ret = virtio_vsock_vqs_init(vsock);
@@ -750,7 +770,8 @@ static struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
-	VIRTIO_VSOCK_F_SEQPACKET
+	VIRTIO_VSOCK_F_SEQPACKET,
+	VIRTIO_VSOCK_F_DGRAM
 };
 
 static struct virtio_driver virtio_vsock_driver = {
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 5e9bccb21869..ab4af21c4f3f 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -37,6 +37,35 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
 	return container_of(t, struct virtio_transport, transport);
 }
 
+/* Requires info->msg and info->vsk */
+static struct sk_buff *
+virtio_transport_sock_alloc_send_skb(struct virtio_vsock_pkt_info *info, unsigned int size,
+				     gfp_t mask, int *err)
+{
+	struct sk_buff *skb;
+	struct sock *sk;
+	int noblock;
+
+	if (size < VIRTIO_VSOCK_SKB_HEADROOM) {
+		*err = -EINVAL;
+		return NULL;
+	}
+
+	if (info->msg)
+		noblock = info->msg->msg_flags & MSG_DONTWAIT;
+	else
+		noblock = 1;
+
+	sk = sk_vsock(info->vsk);
+	sk->sk_allocation = mask;
+	skb = sock_alloc_send_skb(sk, size, noblock, err);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
+	return skb;
+}
+
 /* Returns a new packet on success, otherwise returns NULL.
  *
  * If NULL is returned, errp is set to a negative errno.
@@ -47,7 +76,8 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 			   u32 src_cid,
 			   u32 src_port,
 			   u32 dst_cid,
-			   u32 dst_port)
+			   u32 dst_port,
+			   int *errp)
 {
 	const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
 	struct virtio_vsock_hdr *hdr;
@@ -55,9 +85,21 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 	void *payload;
 	int err;
 
-	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
-	if (!skb)
+	/* dgrams do not use credits, self-throttle according to sk_sndbuf
+	 * using sock_alloc_send_skb. This helps avoid triggering the OOM.
+	 */
+	if (info->vsk && info->type == VIRTIO_VSOCK_TYPE_DGRAM) {
+		skb = virtio_transport_sock_alloc_send_skb(info, skb_len, GFP_KERNEL, &err);
+	} else {
+		skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
+		if (!skb)
+			err = -ENOMEM;
+	}
+
+	if (!skb) {
+		*errp = err;
 		return NULL;
+	}
 
 	hdr = virtio_vsock_hdr(skb);
 	hdr->type	= cpu_to_le16(info->type);
@@ -102,6 +144,7 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 	return skb;
 
 out:
+	*errp = err;
 	kfree_skb(skb);
 	return NULL;
 }
@@ -183,7 +226,9 @@ EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
 
 static u16 virtio_transport_get_type(struct sock *sk)
 {
-	if (sk->sk_type == SOCK_STREAM)
+	if (sk->sk_type == SOCK_DGRAM)
+		return VIRTIO_VSOCK_TYPE_DGRAM;
+	else if (sk->sk_type == SOCK_STREAM)
 		return VIRTIO_VSOCK_TYPE_STREAM;
 	else
 		return VIRTIO_VSOCK_TYPE_SEQPACKET;
@@ -239,11 +284,10 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 
 		skb = virtio_transport_alloc_skb(info, skb_len,
 						 src_cid, src_port,
-						 dst_cid, dst_port);
-		if (!skb) {
-			ret = -ENOMEM;
+						 dst_cid, dst_port,
+						 &ret);
+		if (!skb)
 			break;
-		}
 
 		virtio_transport_inc_tx_pkt(vvs, skb);
 
@@ -583,14 +627,30 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
 
-int
-virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
-			       struct msghdr *msg,
-			       size_t len, int flags)
+int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
 {
-	return -EOPNOTSUPP;
+	*cid = le64_to_cpu(virtio_vsock_hdr(skb)->src_cid);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_cid);
+
+int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
+{
+	*port = le32_to_cpu(virtio_vsock_hdr(skb)->src_port);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
+EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_port);
+
+int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
+{
+	/* The device layer must have already moved the data ptr beyond the
+	 * header for skb->len to be correct.
+	 */
+	WARN_ON(skb->data == skb->head);
+	*len = skb->len;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_length);
 
 s64 virtio_transport_stream_has_data(struct vsock_sock *vsk)
 {
@@ -790,30 +850,6 @@ bool virtio_transport_stream_allow(u32 cid, u32 port)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
 
-int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
-{
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_cid);
-
-int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
-{
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_port);
-
-int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
-{
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_length);
-
-bool virtio_transport_dgram_allow(u32 cid, u32 port)
-{
-	return false;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_dgram_allow);
-
 int virtio_transport_connect(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_pkt_info info = {
@@ -846,7 +882,34 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t dgram_len)
 {
-	return -EOPNOTSUPP;
+	const struct virtio_transport *t_ops;
+	struct virtio_vsock_pkt_info info = {
+		.op = VIRTIO_VSOCK_OP_RW,
+		.msg = msg,
+		.vsk = vsk,
+		.type = VIRTIO_VSOCK_TYPE_DGRAM,
+	};
+	u32 src_cid, src_port;
+	struct sk_buff *skb;
+	int err;
+
+	if (dgram_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
+		return -EMSGSIZE;
+
+	t_ops = virtio_transport_get_ops(vsk);
+	src_cid = t_ops->transport.get_local_cid();
+	src_port = vsk->local_addr.svm_port;
+
+	skb = virtio_transport_alloc_skb(&info, dgram_len,
+					 src_cid, src_port,
+					 remote_addr->svm_cid,
+					 remote_addr->svm_port,
+					 &err);
+
+	if (!skb)
+		return err;
+
+	return t_ops->send_pkt(skb);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
 
@@ -903,6 +966,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 		.reply = true,
 	};
 	struct sk_buff *reply;
+	int err;
 
 	/* Send RST only if the original pkt is not a RST pkt */
 	if (le16_to_cpu(hdr->op) == VIRTIO_VSOCK_OP_RST)
@@ -915,9 +979,10 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 					   le64_to_cpu(hdr->dst_cid),
 					   le32_to_cpu(hdr->dst_port),
 					   le64_to_cpu(hdr->src_cid),
-					   le32_to_cpu(hdr->src_port));
+					   le32_to_cpu(hdr->src_port),
+					   &err);
 	if (!reply)
-		return -ENOMEM;
+		return err;
 
 	return t->send_pkt(reply);
 }
@@ -1137,6 +1202,25 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 		kfree_skb(skb);
 }
 
+/* This function takes ownership of the skb.
+ *
+ * It either places the skb on the sk_receive_queue or frees it.
+ */
+static int
+virtio_transport_recv_dgram(struct sock *sk, struct sk_buff *skb)
+{
+	int err;
+
+	err = sock_queue_rcv_skb(sk, skb);
+	if (err < 0) {
+		kfree_skb(skb);
+		return err;
+	}
+
+	sk->sk_data_ready(sk);
+	return 0;
+}
+
 static int
 virtio_transport_recv_connected(struct sock *sk,
 				struct sk_buff *skb)
@@ -1300,7 +1384,8 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 static bool virtio_transport_valid_type(u16 type)
 {
 	return (type == VIRTIO_VSOCK_TYPE_STREAM) ||
-	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET);
+	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET) ||
+	       (type == VIRTIO_VSOCK_TYPE_DGRAM);
 }
 
 /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
@@ -1314,40 +1399,52 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	struct vsock_sock *vsk;
 	struct sock *sk;
 	bool space_available;
+	u16 type;
 
 	vsock_addr_init(&src, le64_to_cpu(hdr->src_cid),
 			le32_to_cpu(hdr->src_port));
 	vsock_addr_init(&dst, le64_to_cpu(hdr->dst_cid),
 			le32_to_cpu(hdr->dst_port));
 
+	type = le16_to_cpu(hdr->type);
+
 	trace_virtio_transport_recv_pkt(src.svm_cid, src.svm_port,
 					dst.svm_cid, dst.svm_port,
 					le32_to_cpu(hdr->len),
-					le16_to_cpu(hdr->type),
+					type,
 					le16_to_cpu(hdr->op),
 					le32_to_cpu(hdr->flags),
 					le32_to_cpu(hdr->buf_alloc),
 					le32_to_cpu(hdr->fwd_cnt));
 
-	if (!virtio_transport_valid_type(le16_to_cpu(hdr->type))) {
+	if (!virtio_transport_valid_type(type)) {
 		(void)virtio_transport_reset_no_sock(t, skb);
 		goto free_pkt;
 	}
 
-	/* The socket must be in connected or bound table
-	 * otherwise send reset back
+	/* For stream/seqpacket, the socket must be in connected or bound table
+	 * otherwise send reset back.
+	 *
+	 * For datagrams, no reset is sent back.
 	 */
 	sk = vsock_find_connected_socket(&src, &dst);
 	if (!sk) {
-		sk = vsock_find_bound_socket(&dst);
-		if (!sk) {
-			(void)virtio_transport_reset_no_sock(t, skb);
-			goto free_pkt;
+		if (type == VIRTIO_VSOCK_TYPE_DGRAM) {
+			sk = vsock_find_bound_dgram_socket(&dst);
+			if (!sk)
+				goto free_pkt;
+		} else {
+			sk = vsock_find_bound_socket(&dst);
+			if (!sk) {
+				(void)virtio_transport_reset_no_sock(t, skb);
+				goto free_pkt;
+			}
 		}
 	}
 
-	if (virtio_transport_get_type(sk) != le16_to_cpu(hdr->type)) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+	if (virtio_transport_get_type(sk) != type) {
+		if (type != VIRTIO_VSOCK_TYPE_DGRAM)
+			(void)virtio_transport_reset_no_sock(t, skb);
 		sock_put(sk);
 		goto free_pkt;
 	}
@@ -1363,12 +1460,18 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	/* Check if sk has been closed before lock_sock */
 	if (sock_flag(sk, SOCK_DONE)) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+		if (type != VIRTIO_VSOCK_TYPE_DGRAM)
+			(void)virtio_transport_reset_no_sock(t, skb);
 		release_sock(sk);
 		sock_put(sk);
 		goto free_pkt;
 	}
 
+	if (sk->sk_type == SOCK_DGRAM) {
+		virtio_transport_recv_dgram(sk, skb);
+		goto out;
+	}
+
 	space_available = virtio_transport_space_update(sk, skb);
 
 	/* Update CID in case it has changed after a transport reset event */
@@ -1400,6 +1503,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		break;
 	}
 
+out:
 	release_sock(sk);
 
 	/* Release refcnt obtained when we fetched this socket out of the
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 7b0a5030e555..53eccd714567 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -47,6 +47,7 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
 	return 0;
 }
 
+static bool vsock_loopback_dgram_allow(u32 cid, u32 port);
 static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
 
 static struct virtio_transport loopback_transport = {
@@ -63,7 +64,7 @@ static struct virtio_transport loopback_transport = {
 		.cancel_pkt               = vsock_loopback_cancel_pkt,
 
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_allow              = virtio_transport_dgram_allow,
+		.dgram_allow              = vsock_loopback_dgram_allow,
 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
 		.dgram_get_port		  = virtio_transport_dgram_get_port,
 		.dgram_get_length	  = virtio_transport_dgram_get_length,
@@ -99,6 +100,11 @@ static struct virtio_transport loopback_transport = {
 	.send_pkt = vsock_loopback_send_pkt,
 };
 
+static bool vsock_loopback_dgram_allow(u32 cid, u32 port)
+{
+	return true;
+}
+
 static bool vsock_loopback_seqpacket_allow(u32 remote_cid)
 {
 	return true;

-- 
2.30.2



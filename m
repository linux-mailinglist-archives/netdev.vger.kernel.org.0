Return-Path: <netdev+bounces-9751-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C1972A734
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 02:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54AA01C211C5
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 00:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179B11119;
	Sat, 10 Jun 2023 00:58:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D8E1846
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 00:58:48 +0000 (UTC)
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE7330EC
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:58:46 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-628f267aa5aso16380006d6.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 17:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1686358725; x=1688950725;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vXOrOkD9lXLIYQjcPepId4rJsMkbHM3+c/X7NTw0b1Q=;
        b=QnLc0Kr4f7WyJkk8NaU9ymXQMkhMF4DA380k4BiKXLH38kmYCmkLR9r77pwjGb09Ea
         Bi/wjMREH4yj+vErrcq8N80Vl/iRUfWddyL3rsuLY9+Ii0+lqAB+Fsl89oSzLQJ14RJN
         UX/GyvlR49DHWIXCczzDkN0SwWZ/vFzeNRdH0jrWCBDrVHQ3I2n664v/fAEBr3B+jSSs
         hWhNzzhNjDX3HDziPlzZqDwWuCJ5VJ7W9y8Qda4ce+Rmm8p99AETKjTswA6m1K/+lZJI
         sgFxRtwXQ+yQu1xs9lSYX/Jf6/KHb8+UjVjtkqmj3DQmBUAdk57UV5b9iq0JQ/MMoJTA
         2u0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686358725; x=1688950725;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vXOrOkD9lXLIYQjcPepId4rJsMkbHM3+c/X7NTw0b1Q=;
        b=Y8swhsST9fHPOLlG8adIMHs1Qqr55epK1oA3jwY2hDLEaoz3vn8Fu3w06MKe3dE8VW
         4NBJ+LLzc+K/eVaN65YhS+y9Kn5zM3UXKqNSPp4GfdXjD8Ib7/GQtFFr+E2dAu90ziaD
         vifXS3qrXB+/x58Ah+zefJ7Im86edaWvyufYFVv+M5ERK7EKgffAlY2F0xID5imDqngK
         yr01aN2d4r8tlgFcTN/qUxb9zl6EYcz0WG13iXvXLka1Mn1G6Ecel8iJdj8D60rxHRMe
         OY8sHeSVNVyYyikiZjiHzsKHlS/lelzpl1aUcB3DTnSQUElJ1/sa+MLzG+WocQ5K6AHn
         7XcA==
X-Gm-Message-State: AC+VfDx7nuLiZBhE7D5aiHoZwbOSdYAGiLssC3RzOzEQYVNfc81Bde/L
	4UfOVbzdAOgmt+o6NtPZbo5SAw==
X-Google-Smtp-Source: ACHHUZ7DvAnwH+mtOWVQQPtF2Gzv/LPQJv+J88Anf9/FlEjZY9L9KuzdzK9OlG0vd0jyutFmuhmyZg==
X-Received: by 2002:a05:6214:4018:b0:629:78ae:80f8 with SMTP id kd24-20020a056214401800b0062978ae80f8mr3109606qvb.10.1686358725361;
        Fri, 09 Jun 2023 17:58:45 -0700 (PDT)
Received: from [172.17.0.4] ([130.44.212.126])
        by smtp.gmail.com with ESMTPSA id x17-20020a0ce251000000b00606750abaf9sm1504075qvl.136.2023.06.09.17.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 17:58:45 -0700 (PDT)
From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Date: Sat, 10 Jun 2023 00:58:28 +0000
Subject: [PATCH RFC net-next v4 1/8] vsock/dgram: generalize recvmsg and
 drop transport->dgram_dequeue
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v4-1-0cebbb2ae899@bytedance.com>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryantan@vmware.com>, 
 Vishnu Dasa <vdasa@vmware.com>, 
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, 
 Simon Horman <simon.horman@corigine.com>, 
 Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org, 
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 bpf@vger.kernel.org, Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This commit drops the transport->dgram_dequeue callback and makes
vsock_dgram_recvmsg() generic. It also adds additional transport
callbacks for use by the generic vsock_dgram_recvmsg(), such as for
parsing skbs for CID/port which vary in format per transport.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c                   |  4 +-
 include/linux/virtio_vsock.h            |  3 ++
 include/net/af_vsock.h                  | 13 ++++++-
 net/vmw_vsock/af_vsock.c                | 51 ++++++++++++++++++++++++-
 net/vmw_vsock/hyperv_transport.c        | 17 +++++++--
 net/vmw_vsock/virtio_transport.c        |  4 +-
 net/vmw_vsock/virtio_transport_common.c | 18 +++++++++
 net/vmw_vsock/vmci_transport.c          | 68 +++++++++++++--------------------
 net/vmw_vsock/vsock_loopback.c          |  4 +-
 9 files changed, 132 insertions(+), 50 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 6578db78f0ae..c8201c070b4b 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -410,9 +410,11 @@ static struct virtio_transport vhost_transport = {
 		.cancel_pkt               = vhost_transport_cancel_pkt,
 
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_dequeue            = virtio_transport_dgram_dequeue,
 		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_allow              = virtio_transport_dgram_allow,
+		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
+		.dgram_get_port		  = virtio_transport_dgram_get_port,
+		.dgram_get_length	  = virtio_transport_dgram_get_length,
 
 		.stream_enqueue           = virtio_transport_stream_enqueue,
 		.stream_dequeue           = virtio_transport_stream_dequeue,
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c58453699ee9..23521a318cf0 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -219,6 +219,9 @@ bool virtio_transport_stream_allow(u32 cid, u32 port);
 int virtio_transport_dgram_bind(struct vsock_sock *vsk,
 				struct sockaddr_vm *addr);
 bool virtio_transport_dgram_allow(u32 cid, u32 port);
+int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid);
+int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port);
+int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len);
 
 int virtio_transport_connect(struct vsock_sock *vsk);
 
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 0e7504a42925..7bedb9ee7e3e 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -120,11 +120,20 @@ struct vsock_transport {
 
 	/* DGRAM. */
 	int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
-	int (*dgram_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
-			     size_t len, int flags);
 	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
 			     struct msghdr *, size_t len);
 	bool (*dgram_allow)(u32 cid, u32 port);
+	int (*dgram_get_cid)(struct sk_buff *skb, unsigned int *cid);
+	int (*dgram_get_port)(struct sk_buff *skb, unsigned int *port);
+	int (*dgram_get_length)(struct sk_buff *skb, size_t *length);
+
+	/* The number of bytes into the buffer at which the payload starts, as
+	 * first seen by the receiving socket layer. For example, if the
+	 * transport presets the skb pointers using skb_pull(sizeof(header))
+	 * than this would be zero, otherwise it would be the size of the
+	 * header.
+	 */
+	const size_t dgram_payload_offset;
 
 	/* STREAM. */
 	/* TODO: stream_bind() */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index efb8a0937a13..ffb4dd8b6ea7 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1271,11 +1271,15 @@ static int vsock_dgram_connect(struct socket *sock,
 int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 			size_t len, int flags)
 {
+	const struct vsock_transport *transport;
 #ifdef CONFIG_BPF_SYSCALL
 	const struct proto *prot;
 #endif
 	struct vsock_sock *vsk;
+	struct sk_buff *skb;
+	size_t payload_len;
 	struct sock *sk;
+	int err;
 
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
@@ -1286,7 +1290,52 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		return prot->recvmsg(sk, msg, len, flags, NULL);
 #endif
 
-	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
+	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
+		return -EOPNOTSUPP;
+
+	transport = vsk->transport;
+
+	/* Retrieve the head sk_buff from the socket's receive queue. */
+	err = 0;
+	skb = skb_recv_datagram(sk_vsock(vsk), flags, &err);
+	if (!skb)
+		return err;
+
+	err = transport->dgram_get_length(skb, &payload_len);
+	if (err)
+		goto out;
+
+	if (payload_len > len) {
+		payload_len = len;
+		msg->msg_flags |= MSG_TRUNC;
+	}
+
+	/* Place the datagram payload in the user's iovec. */
+	err = skb_copy_datagram_msg(skb, transport->dgram_payload_offset, msg, payload_len);
+	if (err)
+		goto out;
+
+	if (msg->msg_name) {
+		/* Provide the address of the sender. */
+		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
+		unsigned int cid, port;
+
+		err = transport->dgram_get_cid(skb, &cid);
+		if (err)
+			goto out;
+
+		err = transport->dgram_get_port(skb, &port);
+		if (err)
+			goto out;
+
+		vsock_addr_init(vm_addr, cid, port);
+		msg->msg_namelen = sizeof(*vm_addr);
+	}
+	err = payload_len;
+
+out:
+	skb_free_datagram(&vsk->sk, skb);
+	return err;
 }
 EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
 
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 7cb1a9d2cdb4..ff6e87e25fa0 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -556,8 +556,17 @@ static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
 	return -EOPNOTSUPP;
 }
 
-static int hvs_dgram_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
-			     size_t len, int flags)
+static int hvs_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hvs_dgram_get_port(struct sk_buff *skb, unsigned int *port)
+{
+	return -EOPNOTSUPP;
+}
+
+static int hvs_dgram_get_length(struct sk_buff *skb, size_t *len)
 {
 	return -EOPNOTSUPP;
 }
@@ -833,7 +842,9 @@ static struct vsock_transport hvs_transport = {
 	.shutdown                 = hvs_shutdown,
 
 	.dgram_bind               = hvs_dgram_bind,
-	.dgram_dequeue            = hvs_dgram_dequeue,
+	.dgram_get_cid		  = hvs_dgram_get_cid,
+	.dgram_get_port		  = hvs_dgram_get_port,
+	.dgram_get_length	  = hvs_dgram_get_length,
 	.dgram_enqueue            = hvs_dgram_enqueue,
 	.dgram_allow              = hvs_dgram_allow,
 
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..5763cdf13804 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -429,9 +429,11 @@ static struct virtio_transport virtio_transport = {
 		.cancel_pkt               = virtio_transport_cancel_pkt,
 
 		.dgram_bind               = virtio_transport_dgram_bind,
-		.dgram_dequeue            = virtio_transport_dgram_dequeue,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
+		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
+		.dgram_get_port		  = virtio_transport_dgram_get_port,
+		.dgram_get_length	  = virtio_transport_dgram_get_length,
 
 		.stream_dequeue           = virtio_transport_stream_dequeue,
 		.stream_enqueue           = virtio_transport_stream_enqueue,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index b769fc258931..e6903c719964 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -797,6 +797,24 @@ int virtio_transport_dgram_bind(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
 
+int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
+{
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_cid);
+
+int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
+{
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_port);
+
+int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
+{
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_length);
+
 bool virtio_transport_dgram_allow(u32 cid, u32 port)
 {
 	return false;
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index b370070194fa..bbc63826bf48 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1731,57 +1731,40 @@ static int vmci_transport_dgram_enqueue(
 	return err - sizeof(*dg);
 }
 
-static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
-					struct msghdr *msg, size_t len,
-					int flags)
+static int vmci_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
 {
-	int err;
 	struct vmci_datagram *dg;
-	size_t payload_len;
-	struct sk_buff *skb;
 
-	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
-		return -EOPNOTSUPP;
+	dg = (struct vmci_datagram *)skb->data;
+	if (!dg)
+		return -EINVAL;
 
-	/* Retrieve the head sk_buff from the socket's receive queue. */
-	err = 0;
-	skb = skb_recv_datagram(&vsk->sk, flags, &err);
-	if (!skb)
-		return err;
+	*cid = dg->src.context;
+	return 0;
+}
+
+static int vmci_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
+{
+	struct vmci_datagram *dg;
 
 	dg = (struct vmci_datagram *)skb->data;
 	if (!dg)
-		/* err is 0, meaning we read zero bytes. */
-		goto out;
-
-	payload_len = dg->payload_size;
-	/* Ensure the sk_buff matches the payload size claimed in the packet. */
-	if (payload_len != skb->len - sizeof(*dg)) {
-		err = -EINVAL;
-		goto out;
-	}
+		return -EINVAL;
 
-	if (payload_len > len) {
-		payload_len = len;
-		msg->msg_flags |= MSG_TRUNC;
-	}
+	*port = dg->src.resource;
+	return 0;
+}
 
-	/* Place the datagram payload in the user's iovec. */
-	err = skb_copy_datagram_msg(skb, sizeof(*dg), msg, payload_len);
-	if (err)
-		goto out;
+static int vmci_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
+{
+	struct vmci_datagram *dg;
 
-	if (msg->msg_name) {
-		/* Provide the address of the sender. */
-		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
-		vsock_addr_init(vm_addr, dg->src.context, dg->src.resource);
-		msg->msg_namelen = sizeof(*vm_addr);
-	}
-	err = payload_len;
+	dg = (struct vmci_datagram *)skb->data;
+	if (!dg)
+		return -EINVAL;
 
-out:
-	skb_free_datagram(&vsk->sk, skb);
-	return err;
+	*len = dg->payload_size;
+	return 0;
 }
 
 static bool vmci_transport_dgram_allow(u32 cid, u32 port)
@@ -2040,9 +2023,12 @@ static struct vsock_transport vmci_transport = {
 	.release = vmci_transport_release,
 	.connect = vmci_transport_connect,
 	.dgram_bind = vmci_transport_dgram_bind,
-	.dgram_dequeue = vmci_transport_dgram_dequeue,
 	.dgram_enqueue = vmci_transport_dgram_enqueue,
 	.dgram_allow = vmci_transport_dgram_allow,
+	.dgram_get_cid = vmci_transport_dgram_get_cid,
+	.dgram_get_port = vmci_transport_dgram_get_port,
+	.dgram_get_length = vmci_transport_dgram_get_length,
+	.dgram_payload_offset = sizeof(struct vmci_datagram),
 	.stream_dequeue = vmci_transport_stream_dequeue,
 	.stream_enqueue = vmci_transport_stream_enqueue,
 	.stream_has_data = vmci_transport_stream_has_data,
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 5c6360df1f31..2f3cabc79ee5 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -62,9 +62,11 @@ static struct virtio_transport loopback_transport = {
 		.cancel_pkt               = vsock_loopback_cancel_pkt,
 
 		.dgram_bind               = virtio_transport_dgram_bind,
-		.dgram_dequeue            = virtio_transport_dgram_dequeue,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
+		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
+		.dgram_get_port		  = virtio_transport_dgram_get_port,
+		.dgram_get_length	  = virtio_transport_dgram_get_length,
 
 		.stream_dequeue           = virtio_transport_stream_dequeue,
 		.stream_enqueue           = virtio_transport_stream_enqueue,

-- 
2.30.2



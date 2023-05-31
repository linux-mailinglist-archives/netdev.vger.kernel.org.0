Return-Path: <netdev+bounces-6636-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40CD471728C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:36:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C51091C20DA9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:36:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB019EA2;
	Wed, 31 May 2023 00:35:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1FBA23
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:35:51 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F64E57
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:35:21 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64d2da69fdfso5921369b3a.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685493310; x=1688085310;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MBkrJyItUyRhzT4bmma9mx6Vol4nebGHcShs2lGo94w=;
        b=iNlH0QtHTTTATAr/k26z3SJPVDTebYiG6fymyCkFevXaG4+jxrcnCVh1ZMFSU0YBxI
         fKWERi5FViCQU8d7y3jUstV3BQ7uu1gzZgc6jaQQMlrT/WjCJSV0s9gcgbZ7F4sk0gMc
         8TH8mWJEBwZw5aZEJ9srsIBYLl64BUOCfXEfbBDG8R18uL84tUW4hPQvv68ajCiWv+Mb
         jATKIcEpG7F3330JlQBhFtYdPmRnELcCN3grPIDYhLzrPDvT63St2pFpMiOrQzedZsIJ
         dKUQwv6h6mblByxwqiv+AJraQpQ6Nm+Tjrr9TJTZoVAr8ZuNLFnnwzZrl8DyRF3H/T6c
         +UhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685493310; x=1688085310;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBkrJyItUyRhzT4bmma9mx6Vol4nebGHcShs2lGo94w=;
        b=YCArs3/6foaBZEkhnxBnkM/Yc9Ev7Cz4FWPCn96ICKgHKY39cWzrobYHfk1B6o8YhH
         sb7kC7XGzFNY1j+LAZFLPtXkQif/RTToFy1ysxjPD64ftXh43PUsSQNW71mxDe2JdW3E
         SHiJURdW9c8+vRPLdQ3s/WYJHERF1Cz5xfZXvzLzZyf+AjiPQjWF0d3avkl3k5I5Gr9O
         nZucily8nMawBMi/lLaHdnZkEwtwlzbzwmM0LczsZL7gJIcvG2USJU3l0M3//CAnKmsd
         pn3Nw4u+NebK0BXbKBxeWyjUqWSrPsdWRHSGgEFb8ZQhuRrkydsaxpPftJB/SICpOqot
         ED3g==
X-Gm-Message-State: AC+VfDy93asEIjiEdb/IwFWROHkCqE0XRTs/CSezyPv8q4FpqnDAqkmG
	BeRklcdHss3rXYK02nXaNJ/LZA==
X-Google-Smtp-Source: ACHHUZ4tg6+fPh5E3zaS1dhuSUW1MyU7mic0eiffTdvmQiYap1qyPWZJUDXhr3lJ6bSbLOzR9CQfpQ==
X-Received: by 2002:a05:6a00:2ea9:b0:64c:4f2f:a235 with SMTP id fd41-20020a056a002ea900b0064c4f2fa235mr4899127pfb.30.1685493309676;
        Tue, 30 May 2023 17:35:09 -0700 (PDT)
Received: from [172.17.0.2] (c-67-170-131-147.hsd1.wa.comcast.net. [67.170.131.147])
        by smtp.gmail.com with ESMTPSA id j12-20020a62b60c000000b0064cb0845c77sm2151340pff.122.2023.05.30.17.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 17:35:09 -0700 (PDT)
From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Date: Wed, 31 May 2023 00:35:05 +0000
Subject: [PATCH RFC net-next v3 1/8] vsock/dgram: generalize recvmsg and
 drop transport->dgram_dequeue
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v3-1-c2414413ef6a@bytedance.com>
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
index 413407bb646c..7ec0659c6ae5 100644
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
+	skb = skb_recv_datagram(&vsk->sk, flags, &err);
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
index e4878551f140..abd939694a1a 100644
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
index b370070194fa..b6a51afb74b8 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1731,57 +1731,40 @@ static int vmci_transport_dgram_enqueue(
 	return err - sizeof(*dg);
 }
 
-static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
-					struct msghdr *msg, size_t len,
-					int flags)
+int vmci_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
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
+int vmci_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
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
+int vmci_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
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
index e3afc0c866f5..136061f622b8 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -63,9 +63,11 @@ static struct virtio_transport loopback_transport = {
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



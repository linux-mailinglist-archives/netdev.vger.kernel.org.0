Return-Path: <netdev+bounces-9753-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D65EC72A74A
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 183341C211E0
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACFE1846;
	Sat, 10 Jun 2023 00:58:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A90623D6
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 00:58:51 +0000 (UTC)
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4DF3A9C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:58:48 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id 6a1803df08f44-6263b2526a0so16313726d6.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 17:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1686358727; x=1688950727;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RzIAOXq4i4bbs1zeMJ542v3hXYyPRwWNz5JJa1wC9EA=;
        b=OP+oXfcQ6tZNLSTEug87YmxqQRMSkH26emVGngJGdzDTW6IXWyoUAeN4zWaQC4/tUj
         SsY46cZa1RbtZHz9ZXbiZ36gteI+cLxx9MVEvep4MlxOsqxd6RtNq0WSL3hB+vvVT1UG
         dMU0+Nn43ALJe1WCC4vHMAxF+p/9bFj/od6jHaB7m6Ua5ku05kmLDH5VN6fHauyot/fO
         RYhxoAsH+X3zsv0pVlMkk3DGRJS8w7sLOBH39NxzwIUl1aSBnHcZHlEhlHW/dHX+YPWp
         59/6uctu3mgQt3g1+8mhN3ECuakEW598ilenjEbUe6VzJJzYP4ar3Uwo849Cbvvn5SRU
         oEaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686358727; x=1688950727;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RzIAOXq4i4bbs1zeMJ542v3hXYyPRwWNz5JJa1wC9EA=;
        b=ecLmBlD1U82YNDME5CwvoHIS2DNKyx73zBxyTcP09uL5vqdEC8ilzXxWo/r3+DW3YW
         IG+8Yyjl/P1zyjw0jUK1LEzvVe+SOyRwmzPV/+pUHBsxMkqBV+iY9j84MLsvInX5SDm2
         h4D7xUlcbYrjXKEvjkruZkMmkmG9VD5aeP3ii87hsFCcPR+R6DSLUEGboSuUP3y8/Jm0
         nGk6chkODuU4Q1DPI58KZOBJ+RALh6sVB78uz4p5klWinBJAxCpkNt87oHMuqsC2HFnr
         0jG9omXFc94wefVl7Jbv3tihSxMrfhITWB3mAODYfWYYKdZIJ6SO9j3OU+ItIYxh2MBh
         QUcA==
X-Gm-Message-State: AC+VfDxZKjjdVSzkUPKT+08Zq357u00XYVoUJGQwynn1weT1yUb0aaiG
	HMUS8/Go3RfIDhYcO4pe+TKp7A==
X-Google-Smtp-Source: ACHHUZ7mFSwfyLQVrjWC30P+xI+apXc3GBJNuQDHvqZsX9NyGUuHeRv8kvE9SmcGM1O2qj0WW+mNuA==
X-Received: by 2002:a05:6214:5013:b0:5a6:24f6:724d with SMTP id jo19-20020a056214501300b005a624f6724dmr4134395qvb.13.1686358727069;
        Fri, 09 Jun 2023 17:58:47 -0700 (PDT)
Received: from [172.17.0.4] ([130.44.212.126])
        by smtp.gmail.com with ESMTPSA id x17-20020a0ce251000000b00606750abaf9sm1504075qvl.136.2023.06.09.17.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 17:58:46 -0700 (PDT)
From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Date: Sat, 10 Jun 2023 00:58:30 +0000
Subject: [PATCH RFC net-next v4 3/8] vsock: support multi-transport
 datagrams
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v4-3-0cebbb2ae899@bytedance.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch adds support for multi-transport datagrams.

This includes:
- Per-packet lookup of transports when using sendto(sockaddr_vm)
- Selecting H2G or G2H transport using VMADDR_FLAG_TO_HOST and CID in
  sockaddr_vm

To preserve backwards compatibility with VMCI, some important changes
were made. The "transport_dgram" / VSOCK_TRANSPORT_F_DGRAM is changed to
be used for dgrams iff there is not yet a g2h or h2g transport that has
been registered that can transmit the packet. If there is a g2h/h2g
transport for that remote address, then that transport will be used and
not "transport_dgram". This essentially makes "transport_dgram" a
fallback transport for when h2g/g2h has not yet gone online, which
appears to be the exact use case for VMCI.

This design makes sense, because there is no reason that the
transport_{g2h,h2g} cannot also service datagrams, which makes the role
of transport_dgram difficult to understand outside of the VMCI context.

The logic around "transport_dgram" had to be retained to prevent
breaking VMCI:

1) VMCI datagrams appear to function outside of the h2g/g2h
   paradigm. When the vmci transport becomes online, it registers itself
   with the DGRAM feature, but not H2G/G2H. Only later when the
   transport has more information about its environment does it register
   H2G or G2H. In the case that a datagram socket becomes active
   after DGRAM registration but before G2H/H2G registration, the
   "transport_dgram" transport needs to be used.

2) VMCI seems to require special message be sent by the transport when a
   datagram socket calls bind(). Under the h2g/g2h model, the transport
   is selected using the remote_addr which is set by connect(). At
   bind time there is no remote_addr because often no connect() has been
   called yet: the transport is null. Therefore, with a null transport
   there doesn't seem to be any good way for a datagram socket a tell the
   VMCI transport that it has just had bind() called upon it.

Only transports with a special datagram fallback use-case such as VMCI
need to register VSOCK_TRANSPORT_F_DGRAM.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c                   |  1 -
 include/linux/virtio_vsock.h            |  2 -
 net/vmw_vsock/af_vsock.c                | 78 +++++++++++++++++++++++++--------
 net/vmw_vsock/hyperv_transport.c        |  6 ---
 net/vmw_vsock/virtio_transport.c        |  1 -
 net/vmw_vsock/virtio_transport_common.c |  7 ---
 net/vmw_vsock/vsock_loopback.c          |  1 -
 7 files changed, 60 insertions(+), 36 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index c8201c070b4b..8f0082da5e70 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -410,7 +410,6 @@ static struct virtio_transport vhost_transport = {
 		.cancel_pkt               = vhost_transport_cancel_pkt,
 
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_allow              = virtio_transport_dgram_allow,
 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
 		.dgram_get_port		  = virtio_transport_dgram_get_port,
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 23521a318cf0..73afa09f4585 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -216,8 +216,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
 u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
 bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
 bool virtio_transport_stream_allow(u32 cid, u32 port);
-int virtio_transport_dgram_bind(struct vsock_sock *vsk,
-				struct sockaddr_vm *addr);
 bool virtio_transport_dgram_allow(u32 cid, u32 port);
 int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid);
 int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 74358f0b47fa..ef86765f3765 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -438,6 +438,18 @@ vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
 	return transport;
 }
 
+static const struct vsock_transport *
+vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
+{
+	const struct vsock_transport *transport;
+
+	transport = vsock_connectible_lookup_transport(cid, flags);
+	if (transport)
+		return transport;
+
+	return transport_dgram;
+}
+
 /* Assign a transport to a socket and call the .init transport callback.
  *
  * Note: for connection oriented socket this must be called when vsk->remote_addr
@@ -474,7 +486,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 
 	switch (sk->sk_type) {
 	case SOCK_DGRAM:
-		new_transport = transport_dgram;
+		new_transport = vsock_dgram_lookup_transport(remote_cid,
+							     remote_flags);
 		break;
 	case SOCK_STREAM:
 	case SOCK_SEQPACKET:
@@ -691,6 +704,9 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 static int __vsock_bind_dgram(struct vsock_sock *vsk,
 			      struct sockaddr_vm *addr)
 {
+	if (!vsk->transport || !vsk->transport->dgram_bind)
+		return -EINVAL;
+
 	return vsk->transport->dgram_bind(vsk, addr);
 }
 
@@ -1172,19 +1188,24 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	lock_sock(sk);
 
-	transport = vsk->transport;
-
-	err = vsock_auto_bind(vsk);
-	if (err)
-		goto out;
-
-
 	/* If the provided message contains an address, use that.  Otherwise
 	 * fall back on the socket's remote handle (if it has been connected).
 	 */
 	if (msg->msg_name &&
 	    vsock_addr_cast(msg->msg_name, msg->msg_namelen,
 			    &remote_addr) == 0) {
+		transport = vsock_dgram_lookup_transport(remote_addr->svm_cid,
+							 remote_addr->svm_flags);
+		if (!transport) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (!try_module_get(transport->module)) {
+			err = -ENODEV;
+			goto out;
+		}
+
 		/* Ensure this address is of the right type and is a valid
 		 * destination.
 		 */
@@ -1193,11 +1214,27 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			remote_addr->svm_cid = transport->get_local_cid();
 
 		if (!vsock_addr_bound(remote_addr)) {
+			module_put(transport->module);
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (!transport->dgram_allow(remote_addr->svm_cid,
+					    remote_addr->svm_port)) {
+			module_put(transport->module);
 			err = -EINVAL;
 			goto out;
 		}
+
+		err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
+		module_put(transport->module);
 	} else if (sock->state == SS_CONNECTED) {
 		remote_addr = &vsk->remote_addr;
+		transport = vsk->transport;
+
+		err = vsock_auto_bind(vsk);
+		if (err)
+			goto out;
 
 		if (remote_addr->svm_cid == VMADDR_CID_ANY)
 			remote_addr->svm_cid = transport->get_local_cid();
@@ -1205,23 +1242,23 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		/* XXX Should connect() or this function ensure remote_addr is
 		 * bound?
 		 */
-		if (!vsock_addr_bound(&vsk->remote_addr)) {
+		if (!vsock_addr_bound(remote_addr)) {
 			err = -EINVAL;
 			goto out;
 		}
-	} else {
-		err = -EINVAL;
-		goto out;
-	}
 
-	if (!transport->dgram_allow(remote_addr->svm_cid,
-				    remote_addr->svm_port)) {
+		if (!transport->dgram_allow(remote_addr->svm_cid,
+					    remote_addr->svm_port)) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
+	} else {
 		err = -EINVAL;
 		goto out;
 	}
 
-	err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
-
 out:
 	release_sock(sk);
 	return err;
@@ -1255,13 +1292,18 @@ static int vsock_dgram_connect(struct socket *sock,
 	if (err)
 		goto out;
 
+	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
+
+	err = vsock_assign_transport(vsk, NULL);
+	if (err)
+		goto out;
+
 	if (!vsk->transport->dgram_allow(remote_addr->svm_cid,
 					 remote_addr->svm_port)) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
 	sock->state = SS_CONNECTED;
 
 	/* sock map disallows redirection of non-TCP sockets with sk_state !=
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index ff6e87e25fa0..c00bc5da769a 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -551,11 +551,6 @@ static void hvs_destruct(struct vsock_sock *vsk)
 	kfree(hvs);
 }
 
-static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
-{
-	return -EOPNOTSUPP;
-}
-
 static int hvs_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
 {
 	return -EOPNOTSUPP;
@@ -841,7 +836,6 @@ static struct vsock_transport hvs_transport = {
 	.connect                  = hvs_connect,
 	.shutdown                 = hvs_shutdown,
 
-	.dgram_bind               = hvs_dgram_bind,
 	.dgram_get_cid		  = hvs_dgram_get_cid,
 	.dgram_get_port		  = hvs_dgram_get_port,
 	.dgram_get_length	  = hvs_dgram_get_length,
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 5763cdf13804..1b7843a7779a 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -428,7 +428,6 @@ static struct virtio_transport virtio_transport = {
 		.shutdown                 = virtio_transport_shutdown,
 		.cancel_pkt               = virtio_transport_cancel_pkt,
 
-		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e6903c719964..d5a3c8efe84b 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -790,13 +790,6 @@ bool virtio_transport_stream_allow(u32 cid, u32 port)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
 
-int virtio_transport_dgram_bind(struct vsock_sock *vsk,
-				struct sockaddr_vm *addr)
-{
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
-
 int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
 {
 	return -EOPNOTSUPP;
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 2f3cabc79ee5..e9de45a26fbd 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -61,7 +61,6 @@ static struct virtio_transport loopback_transport = {
 		.shutdown                 = virtio_transport_shutdown,
 		.cancel_pkt               = vsock_loopback_cancel_pkt,
 
-		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,

-- 
2.30.2



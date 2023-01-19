Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107AA6735CD
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjASKlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjASKkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:40:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C10530DA
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674124787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yJyNK1+/ge7a+pCPBNiTz9QCZuOZ3IXj3b3Hi4Jg3Co=;
        b=e0az8+4igmKGPZOmLle7ywwwajb+HiiNCVC6IA+puR2HPF3wW4xVsp15moA6ezGTkHQa1Z
        3/ySdQEILbRvkz0nWxZzChVaHTNpNReQ9SKA7nx8Z5d9J0des7km/gB5DlcVbURsCzRpoh
        zwdWXpN2trZ2esk+xM3x4fAZpWZhziE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-612-SvjEaCYuNj-JaZ4WTzPDig-1; Thu, 19 Jan 2023 05:39:46 -0500
X-MC-Unique: SvjEaCYuNj-JaZ4WTzPDig-1
Received: by mail-qk1-f197.google.com with SMTP id u10-20020a05620a0c4a00b00705e77d6207so1117862qki.5
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:39:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yJyNK1+/ge7a+pCPBNiTz9QCZuOZ3IXj3b3Hi4Jg3Co=;
        b=ze/7/ojUZ5ij1GkZS15Z8007HbJv0VAoSui3NpwVwzh6VXFfjHJ2Fd4MQ7scp2CH6/
         SygYY4Ha17L1GcljvotLJzMjicoCwae15ymX7xCo+rxMKJeyn4JVqm0GUQf7J6/CLGBv
         Im0d/wa0VwWBT2O3O9wh1SYRBYFB6l217+M1b6SY6h5XOc02pDmDyrrokCxY8mT1QQn/
         lGg6+aSv6MqHo008wLj3m19XRW8TKy9TJY0LdRT7EmWnbHJRy69YOA6NzlNpu5vCQf8z
         8hkQB2RovI1T6QuPuXDnAeBnJLmv/J6Pk0mwNn5qsonaHkWC4txVYUJTwm+u+4Cykxl3
         PXyg==
X-Gm-Message-State: AFqh2kpkiBduYtPBWZGNKsLZTIGv5JmtIceNMoNZsWReztuxyS8Z7QDa
        Eyj6sxk4dmzw3Kmb3bwAN3e5dznNil6v21TBKNSFDfU5B9VFXeD/wmEdl4+gtsfqV5J84Jqd7r/
        y5YZb/IK5mn7NuYK4
X-Received: by 2002:a0c:ea2c:0:b0:532:1fc2:9ad5 with SMTP id t12-20020a0cea2c000000b005321fc29ad5mr43158334qvp.0.1674124785405;
        Thu, 19 Jan 2023 02:39:45 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv2Gva+uX0eO+O8NQDdRYuDL8YmAeXTYwi19LkbvJqdFBP2KsHK7ntGx2b9TWFk0e7+X1H2sA==
X-Received: by 2002:a0c:ea2c:0:b0:532:1fc2:9ad5 with SMTP id t12-20020a0cea2c000000b005321fc29ad5mr43158304qvp.0.1674124785033;
        Thu, 19 Jan 2023 02:39:45 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-245.retail.telecomitalia.it. [82.57.51.245])
        by smtp.gmail.com with ESMTPSA id d136-20020ae9ef8e000000b006ef1a8f1b81sm23545975qkg.5.2023.01.19.02.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 02:39:44 -0800 (PST)
Date:   Thu, 19 Jan 2023 11:39:36 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH RFC 1/3] vsock: support sockmap
Message-ID: <20230119103936.ezjhewtqldhovybs@sgarzare-redhat>
References: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
 <20230118-support-vsock-sockmap-connectible-v1-1-d47e6294827b@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230118-support-vsock-sockmap-connectible-v1-1-d47e6294827b@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 12:27:39PM -0800, Bobby Eshleman wrote:
>This patch adds sockmap support for vsock sockets. It is intended to be
>usable by all transports, but only the virtio transport is implemented.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> drivers/vhost/vsock.c                   |   1 +
> include/linux/virtio_vsock.h            |   1 +
> include/net/af_vsock.h                  |  17 +++
> net/vmw_vsock/Makefile                  |   1 +
> net/vmw_vsock/af_vsock.c                |  59 +++++++++--
> net/vmw_vsock/virtio_transport.c        |   2 +
> net/vmw_vsock/virtio_transport_common.c |  22 ++++
> net/vmw_vsock/vsock_bpf.c               | 180 ++++++++++++++++++++++++++++++++
> net/vmw_vsock/vsock_loopback.c          |   2 +
> 9 files changed, 279 insertions(+), 6 deletions(-)

./scripts/checkpatch.pl --strict prints some simple warnings/checks that
I suggest to fix :-)

>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 1f3b89c885cca..3c6dc036b9044 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -439,6 +439,7 @@ static struct virtio_transport vhost_transport = {
> 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>
>+		.read_skb = virtio_transport_read_skb,
> 	},
>
> 	.send_pkt = vhost_transport_send_pkt,
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 3f9c166113063..c58453699ee98 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -245,4 +245,5 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
> void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
> void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
> int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
>+int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
> #endif /* _LINUX_VIRTIO_VSOCK_H */
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 568a87c5e0d0f..a73f5fbd296af 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -75,6 +75,7 @@ struct vsock_sock {
> 	void *trans;
> };
>
>+s64 vsock_connectible_has_data(struct vsock_sock *vsk);
> s64 vsock_stream_has_data(struct vsock_sock *vsk);
> s64 vsock_stream_has_space(struct vsock_sock *vsk);
> struct sock *vsock_create_connected(struct sock *parent);
>@@ -173,6 +174,9 @@ struct vsock_transport {
>
> 	/* Addressing. */
> 	u32 (*get_local_cid)(void);
>+
>+	/* Read a single skb */
>+	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
> };
>
> /**** CORE ****/
>@@ -225,5 +229,18 @@ int vsock_init_tap(void);
> int vsock_add_tap(struct vsock_tap *vt);
> int vsock_remove_tap(struct vsock_tap *vt);
> void vsock_deliver_tap(struct sk_buff *build_skb(void *opaque), void *opaque);
>+int vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>+			      int flags);
>+int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>+			       size_t len, int flags);
>+
>+#ifdef CONFIG_BPF_SYSCALL
>+extern struct proto vsock_proto;
>+int vsock_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
>+void __init vsock_bpf_build_proto(void);
>+#else
>+static inline void __init vsock_bpf_build_proto(void)
>+{}
>+#endif
>
> #endif /* __AF_VSOCK_H__ */
>diff --git a/net/vmw_vsock/Makefile b/net/vmw_vsock/Makefile
>index 6a943ec95c4a5..5da74c4a9f1d1 100644
>--- a/net/vmw_vsock/Makefile
>+++ b/net/vmw_vsock/Makefile
>@@ -8,6 +8,7 @@ obj-$(CONFIG_HYPERV_VSOCKETS) += hv_sock.o
> obj-$(CONFIG_VSOCKETS_LOOPBACK) += vsock_loopback.o
>
> vsock-y += af_vsock.o af_vsock_tap.o vsock_addr.o
>+vsock-$(CONFIG_BPF_SYSCALL) += vsock_bpf.o
>
> vsock_diag-y += diag.o
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index d593d5b6d4b15..7081b3a992c1e 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -116,10 +116,13 @@ static void vsock_sk_destruct(struct sock *sk);
> static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
>
> /* Protocol family. */
>-static struct proto vsock_proto = {
>+struct proto vsock_proto = {
> 	.name = "AF_VSOCK",
> 	.owner = THIS_MODULE,
> 	.obj_size = sizeof(struct vsock_sock),
>+#ifdef CONFIG_BPF_SYSCALL
>+	.psock_update_sk_prot = vsock_bpf_update_proto,
>+#endif
> };
>
> /* The default peer timeout indicates how long we will wait for a peer response
>@@ -865,7 +868,7 @@ s64 vsock_stream_has_data(struct vsock_sock *vsk)
> }
> EXPORT_SYMBOL_GPL(vsock_stream_has_data);
>
>-static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
>+s64 vsock_connectible_has_data(struct vsock_sock *vsk)
> {
> 	struct sock *sk = sk_vsock(vsk);
>
>@@ -874,6 +877,7 @@ static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
> 	else
> 		return vsock_stream_has_data(vsk);
> }
>+EXPORT_SYMBOL_GPL(vsock_connectible_has_data);
>
> s64 vsock_stream_has_space(struct vsock_sock *vsk)
> {
>@@ -1131,6 +1135,19 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 	return mask;
> }
>
>+static int vsock_read_skb(struct sock *sk, skb_read_actor_t read_actor)
>+{
>+	struct vsock_sock *vsk = vsock_sk(sk);
>+
>+	if (!vsk->transport)
>+		return -ENODEV;
>+
>+	if (!vsk->transport->read_skb)
>+		return -EOPNOTSUPP;
>+
>+	return vsk->transport->read_skb(vsk, read_actor);
>+}
>+
> static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> 			       size_t len)
> {
>@@ -1241,19 +1258,32 @@ static int vsock_dgram_connect(struct socket *sock,
>
> 	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
> 	sock->state = SS_CONNECTED;
>+	sk->sk_state = TCP_ESTABLISHED;

Why we need this change?
If it's a fix, we should put it in another patch.

>
> out:
> 	release_sock(sk);
> 	return err;
> }
>
>-static int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>-			       size_t len, int flags)
>+int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>+			size_t len, int flags)
> {
>-	struct vsock_sock *vsk = vsock_sk(sock->sk);
>+	const struct proto *prot;

We should use the guard for this statement as in
vsock_connectible_recvmsg().

>+	struct vsock_sock *vsk;
>+	struct sock *sk;
>+
>+	sk = sock->sk;
>+	vsk = vsock_sk(sk);
>+
>+#ifdef CONFIG_BPF_SYSCALL
>+	prot = READ_ONCE(sk->sk_prot);
>+	if (prot != &vsock_proto)
>+		return prot->recvmsg(sk, msg, len, flags, NULL);
>+#endif
>
> 	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
> }
>+EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
>
> static const struct proto_ops vsock_dgram_ops = {
> 	.family = PF_VSOCK,
>@@ -1272,6 +1302,7 @@ static const struct proto_ops vsock_dgram_ops = {
> 	.recvmsg = vsock_dgram_recvmsg,
> 	.mmap = sock_no_mmap,
> 	.sendpage = sock_no_sendpage,
>+	.read_skb = vsock_read_skb,
> };
>
> static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
>@@ -2085,13 +2116,16 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
> 	return err;
> }
>
>-static int
>+int
> vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 			  int flags)
> {
> 	struct sock *sk;
> 	struct vsock_sock *vsk;
> 	const struct vsock_transport *transport;
>+#ifdef CONFIG_BPF_SYSCALL
>+	const struct proto *prot;
>+#endif
> 	int err;
>
> 	sk = sock->sk;
>@@ -2138,6 +2172,14 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 		goto out;
> 	}
>
>+#ifdef CONFIG_BPF_SYSCALL
>+	prot = READ_ONCE(sk->sk_prot);
>+	if (prot != &vsock_proto) {
>+		release_sock(sk);
>+		return prot->recvmsg(sk, msg, len, flags, NULL);
>+	}
>+#endif
>+
> 	if (sk->sk_type == SOCK_STREAM)
> 		err = __vsock_stream_recvmsg(sk, msg, len, flags);
> 	else
>@@ -2147,6 +2189,7 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	release_sock(sk);
> 	return err;
> }
>+EXPORT_SYMBOL_GPL(vsock_connectible_recvmsg);
>
> static int vsock_set_rcvlowat(struct sock *sk, int val)
> {
>@@ -2187,6 +2230,7 @@ static const struct proto_ops vsock_stream_ops = {
> 	.mmap = sock_no_mmap,
> 	.sendpage = sock_no_sendpage,
> 	.set_rcvlowat = vsock_set_rcvlowat,
>+	.read_skb = vsock_read_skb,
> };
>
> static const struct proto_ops vsock_seqpacket_ops = {
>@@ -2208,6 +2252,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
> 	.recvmsg = vsock_connectible_recvmsg,
> 	.mmap = sock_no_mmap,
> 	.sendpage = sock_no_sendpage,
>+	.read_skb = vsock_read_skb,
> };
>
> static int vsock_create(struct net *net, struct socket *sock,
>@@ -2347,6 +2392,8 @@ static int __init vsock_init(void)
> 		goto err_unregister_proto;
> 	}
>
>+	vsock_bpf_build_proto();
>+
> 	return 0;
>
> err_unregister_proto:
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 28b5a8e8e0948..e95df847176b6 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -457,6 +457,8 @@ static struct virtio_transport virtio_transport = {
> 		.notify_send_pre_enqueue  = 
> 		virtio_transport_notify_send_pre_enqueue,
> 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>+
>+		.read_skb = virtio_transport_read_skb,
> 	},
>
> 	.send_pkt = virtio_transport_send_pkt,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index a1581c77cf84a..9a87ead5b1fc5 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1388,6 +1388,28 @@ int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *queue)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_purge_skbs);
>
>+int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_actor)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct sock *sk = sk_vsock(vsk);
>+	struct sk_buff *skb;
>+	int copied = 0;

We could avoid initializing `copied`, since it is overwritten later.

>+	int off = 0;
>+	int err;
>+
>+	spin_lock_bh(&vvs->rx_lock);
>+	skb = __skb_recv_datagram(sk, &vvs->rx_queue, MSG_DONTWAIT, &off, &err);

Will this work also for STREAM and SEQPACKET sockets?

>+	spin_unlock_bh(&vvs->rx_lock);
>+
>+	if (!skb)
>+		return err;
>+
>+	copied = recv_actor(sk, skb);
>+	kfree_skb(skb);

I would have moved these steps to vsock_read_skb() to avoid duplicating
these steps in each transport. Perhaps not all transports want to pass
skb ownership to the caller, though, so maybe we can leave it that
way for now.

>+	return copied;
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>+
> MODULE_LICENSE("GPL v2");
> MODULE_AUTHOR("Asias He");
> MODULE_DESCRIPTION("common code for virtio vsock");
>diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
>new file mode 100644
>index 0000000000000..9e11282d3bc1f
>--- /dev/null
>+++ b/net/vmw_vsock/vsock_bpf.c
>@@ -0,0 +1,180 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/* Copyright (c) 2022 Bobby Eshleman <bobby.eshleman@bytedance.com>
>+ *
>+ * Based off of net/unix/unix_bpf.c
>+ */
>+
>+#include <linux/bpf.h>
>+#include <linux/module.h>
>+#include <linux/skmsg.h>
>+#include <linux/socket.h>
>+#include <net/af_vsock.h>
>+#include <net/sock.h>
>+
>+#define vsock_sk_has_data(__sk, __psock)				\
>+		({	!skb_queue_empty(&__sk->sk_receive_queue) ||	\
>+			!skb_queue_empty(&__psock->ingress_skb) ||	\
>+			!list_empty(&__psock->ingress_msg);		\
>+		})
>+
>+static struct proto *vsock_dgram_prot_saved __read_mostly;
>+static DEFINE_SPINLOCK(vsock_dgram_prot_lock);
>+static struct proto vsock_dgram_bpf_prot;
>+
>+static bool vsock_has_data(struct vsock_sock *vsk, struct sk_psock *psock)
>+{
>+	struct sock *sk = sk_vsock(vsk);
>+	s64 ret;
>+
>+	ret = vsock_connectible_has_data(vsk);
>+	if (ret > 0)
>+		return true;
>+
>+	return vsock_sk_has_data(sk, psock);
>+}
>+
>+static int vsock_msg_wait_data(struct sock *sk, struct sk_psock *psock, long timeo)
>+{
>+	struct vsock_sock *vsk;
>+	int err;
>+
>+	DEFINE_WAIT(wait);
>+
>+	vsk = vsock_sk(sk);
>+	err = 0;
>+
>+	while (vsock_has_data(vsk, psock)) {
>+		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
>+
>+		if (sk->sk_err != 0 ||
>+		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>+		    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
>+			break;
>+		}
>+
>+		if (timeo == 0) {
>+			err = -EAGAIN;
>+			break;
>+		}
>+
>+		release_sock(sk);
>+		timeo = schedule_timeout(timeo);
>+		lock_sock(sk);
>+
>+		if (signal_pending(current)) {
>+			err = sock_intr_errno(timeo);
>+			break;
>+		} else if (timeo == 0) {
>+			err = -EAGAIN;
>+			break;
>+		}
>+	}
>+
>+	finish_wait(sk_sleep(sk), &wait);
>+
>+	if (err)
>+		return err;
>+
>+	return 0;
>+}
>+
>+static int vsock_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags)
>+{
>+	int err;
>+	struct socket *sock = sk->sk_socket;
>+
>+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
>+		err = vsock_connectible_recvmsg(sock, msg, len, flags);
>+	else

Could it happen that it is not DGRAM and we should return an error in
this case?

Thanks,
Stefano

>+		err = vsock_dgram_recvmsg(sock, msg, len, flags);
>+
>+	return err;
>+}
>+
>+static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>+			     size_t len, int flags, int *addr_len)
>+{
>+	int copied;
>+	struct sk_psock *psock;
>+
>+	lock_sock(sk);
>+	psock = sk_psock_get(sk);
>+	if (unlikely(!psock)) {
>+		release_sock(sk);
>+		return vsock_recvmsg(sk, msg, len, flags);
>+	}
>+
>+	if (vsock_has_data(vsock_sk(sk), psock) && sk_psock_queue_empty(psock)) {
>+		sk_psock_put(sk, psock);
>+		release_sock(sk);
>+		return vsock_recvmsg(sk, msg, len, flags);
>+	}
>+
>+msg_bytes_ready:
>+	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
>+	if (!copied) {
>+		long timeo;
>+		int data;
>+
>+		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>+		data = vsock_msg_wait_data(sk, psock, timeo);
>+		if (data) {
>+			if (!sk_psock_queue_empty(psock))
>+				goto msg_bytes_ready;
>+			sk_psock_put(sk, psock);
>+			release_sock(sk);
>+			return vsock_recvmsg(sk, msg, len, flags);
>+		}
>+		copied = -EAGAIN;
>+	}
>+	sk_psock_put(sk, psock);
>+	release_sock(sk);
>+
>+	return copied;
>+}
>+
>+/* Copy of original proto with updated sock_map methods */
>+static struct proto vsock_dgram_bpf_prot = {
>+	.close = sock_map_close,
>+	.recvmsg = vsock_bpf_recvmsg,
>+	.sock_is_readable = sk_msg_is_readable,
>+	.unhash = sock_map_unhash,
>+};
>+
>+static void vsock_dgram_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
>+{
>+	*prot        = *base;
>+	prot->close  = sock_map_close;
>+	prot->recvmsg = vsock_bpf_recvmsg;
>+	prot->sock_is_readable = sk_msg_is_readable;
>+}
>+
>+static void vsock_dgram_bpf_check_needs_rebuild(struct proto *ops)
>+{
>+	if (unlikely(ops != smp_load_acquire(&vsock_dgram_prot_saved))) {
>+		spin_lock_bh(&vsock_dgram_prot_lock);
>+		if (likely(ops != vsock_dgram_prot_saved)) {
>+			vsock_dgram_bpf_rebuild_protos(&vsock_dgram_bpf_prot, ops);
>+			smp_store_release(&vsock_dgram_prot_saved, ops);
>+		}
>+		spin_unlock_bh(&vsock_dgram_prot_lock);
>+	}
>+}
>+
>+int vsock_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
>+{
>+	if (restore) {
>+		sk->sk_write_space = psock->saved_write_space;
>+		sock_replace_proto(sk, psock->sk_proto);
>+		return 0;
>+	}
>+
>+	vsock_dgram_bpf_check_needs_rebuild(psock->sk_proto);
>+	sock_replace_proto(sk, &vsock_dgram_bpf_prot);
>+	return 0;
>+}
>+
>+void __init vsock_bpf_build_proto(void)
>+{
>+	vsock_dgram_bpf_rebuild_protos(&vsock_dgram_bpf_prot, &vsock_proto);
>+}
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index 671e03240fc52..40753b661c135 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -94,6 +94,8 @@ static struct virtio_transport loopback_transport = {
> 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
> 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>+
>+		.read_skb = virtio_transport_read_skb,
> 	},
>
> 	.send_pkt = vsock_loopback_send_pkt,
>
>-- 
>2.30.2
>


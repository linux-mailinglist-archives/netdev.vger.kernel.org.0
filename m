Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFE96A7E47
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 10:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjCBJo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 04:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjCBJoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 04:44:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35F239283
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 01:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677750191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d89OVXlxjMSQtumMo8iJ9aTVkJfH2plqezFb7xBWsgk=;
        b=WTHcGEhZtG9Vq4KWZCHkH961nki1ntSaOPI74AL4wgN9u5B6Rl7WWKS2nbWsmgJ96uk6L9
        Reorv4e9wQXgSKLEKRD4Pn8+pAzwVuhHGuXpq/q6zWIaULepWvmvoli+8pHxoUmv12RXqE
        E5/hrOeq5pqn4s+CbAcpU8aXWvsGjd8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-578-auXDTk91OhmqJ8uxPaO8GA-1; Thu, 02 Mar 2023 04:43:02 -0500
X-MC-Unique: auXDTk91OhmqJ8uxPaO8GA-1
Received: by mail-wr1-f70.google.com with SMTP id m7-20020a056000008700b002c7047ea429so3091607wrx.21
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 01:43:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677750180;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d89OVXlxjMSQtumMo8iJ9aTVkJfH2plqezFb7xBWsgk=;
        b=dQgOi5U2Lz2JDLK0feunKDRSXqNyU2aiTb9CWtvujfYLexR9qunoOwDsXfkrfAt2v/
         30tfcIIs5vostprmA08qbqkig805mP7fNo30AkC1Hah/aPcyj8zlXUWKLV1alinPvMf7
         wPe7jOkJjWpzM467mU7FK3AzgQfp0BFhusCc5b6pa1Xm4vlVPnu+YyFXpa+d9O+KIfA7
         KLV0g5uPh0Y9g+SLf1+PIxuivFDkq/Lu59PyHdjSfr8pxgzln2IWhjwZQ5VMEIXFR9EU
         qzFN7Gz/9dxIzTUVyjA8RZQp+GRuXufQ4PHBEouMt1c+XmBfRwhbrfUFXAnw1YlM54Nt
         m55w==
X-Gm-Message-State: AO0yUKWeSf/GAs8Dp1gMGCzQ7GnjPMwKTzj7ESJcSnRnt30ReKdTx65o
        VzzqXBRciHxSWcUDWsgb2ZsemTy6QuDL0xwxTn4yZdEzmWYjIqX5kGtxGu0j+X8H49vjNorHkJu
        4auy5ezYYq90Kd/6/
X-Received: by 2002:a05:6000:109:b0:2c7:832:8ccf with SMTP id o9-20020a056000010900b002c708328ccfmr6829242wrx.53.1677750180706;
        Thu, 02 Mar 2023 01:43:00 -0800 (PST)
X-Google-Smtp-Source: AK7set9nk5hBKDN8uFgpRMSqC2bK9CM1B9gpcwEU3K7OKO3TTS1sST4u6uiJc3UO9g93rBdogImeAQ==
X-Received: by 2002:a05:6000:109:b0:2c7:832:8ccf with SMTP id o9-20020a056000010900b002c708328ccfmr6829215wrx.53.1677750180357;
        Thu, 02 Mar 2023 01:43:00 -0800 (PST)
Received: from sgarzare-redhat (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id o8-20020a5d4a88000000b002c70c99db74sm14580816wrq.86.2023.03.02.01.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 01:42:59 -0800 (PST)
Date:   Thu, 2 Mar 2023 10:42:52 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net-next v3 1/3] vsock: support sockmap
Message-ID: <20230302094252.r3qnhdhlbpp7unna@sgarzare-redhat>
References: <20230227-vsock-sockmap-upstream-v3-0-7e7f4ce623ee@bytedance.com>
 <20230227-vsock-sockmap-upstream-v3-1-7e7f4ce623ee@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230227-vsock-sockmap-upstream-v3-1-7e7f4ce623ee@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 07:04:34PM +0000, Bobby Eshleman wrote:
>This patch adds sockmap support for vsock sockets. It is intended to be
>usable by all transports, but only the virtio transport is implemented.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> drivers/vhost/vsock.c                   |   1 +
> include/linux/virtio_vsock.h            |   1 +
> include/net/af_vsock.h                  |  17 ++++
> net/vmw_vsock/Makefile                  |   1 +
> net/vmw_vsock/af_vsock.c                |  55 ++++++++--
> net/vmw_vsock/virtio_transport.c        |   2 +
> net/vmw_vsock/virtio_transport_common.c |  25 +++++
> net/vmw_vsock/vsock_bpf.c               | 174 ++++++++++++++++++++++++++++++++
> net/vmw_vsock/vsock_loopback.c          |   2 +
> 9 files changed, 272 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 1f3b89c885cc..3c6dc036b904 100644
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
>index 3f9c16611306..c58453699ee9 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -245,4 +245,5 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
> void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
> void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
> int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
>+int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
> #endif /* _LINUX_VIRTIO_VSOCK_H */
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 568a87c5e0d0..a73f5fbd296a 100644
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

Just because you have to resend a v4, here we can align as `checkpatch
--strict` suggests:

CHECK: Alignment should match open parenthesis
#63: FILE: include/net/af_vsock.h:235:
+int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
+			      size_t len, int flags);

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
>index 6a943ec95c4a..5da74c4a9f1d 100644
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
>index 19aea7cba26e..f2cc04fb8b13 100644
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
>@@ -1131,6 +1135,13 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 	return mask;
> }
>
>+static int vsock_read_skb(struct sock *sk, skb_read_actor_t read_actor)
>+{
>+	struct vsock_sock *vsk = vsock_sk(sk);
>+
>+	return vsk->transport->read_skb(vsk, read_actor);
>+}
>+
> static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> 			       size_t len)
> {
>@@ -1241,19 +1252,34 @@ static int vsock_dgram_connect(struct socket *sock,
>
> 	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
> 	sock->state = SS_CONNECTED;
>+	sk->sk_state = TCP_ESTABLISHED;
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
>+#ifdef CONFIG_BPF_SYSCALL
>+	const struct proto *prot;
>+#endif
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
>@@ -1272,6 +1298,7 @@ static const struct proto_ops vsock_dgram_ops = {
> 	.recvmsg = vsock_dgram_recvmsg,
> 	.mmap = sock_no_mmap,
> 	.sendpage = sock_no_sendpage,
>+	.read_skb = vsock_read_skb,
> };
>
> static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
>@@ -2086,13 +2113,16 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
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
>@@ -2139,6 +2169,14 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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
>@@ -2148,6 +2186,7 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	release_sock(sk);
> 	return err;
> }
>+EXPORT_SYMBOL_GPL(vsock_connectible_recvmsg);
>
> static int vsock_set_rcvlowat(struct sock *sk, int val)
> {
>@@ -2188,6 +2227,7 @@ static const struct proto_ops vsock_stream_ops = {
> 	.mmap = sock_no_mmap,
> 	.sendpage = sock_no_sendpage,
> 	.set_rcvlowat = vsock_set_rcvlowat,
>+	.read_skb = vsock_read_skb,
> };
>
> static const struct proto_ops vsock_seqpacket_ops = {
>@@ -2209,6 +2249,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
> 	.recvmsg = vsock_connectible_recvmsg,
> 	.mmap = sock_no_mmap,
> 	.sendpage = sock_no_sendpage,
>+	.read_skb = vsock_read_skb,
> };
>
> static int vsock_create(struct net *net, struct socket *sock,
>@@ -2348,6 +2389,8 @@ static int __init vsock_init(void)
> 		goto err_unregister_proto;
> 	}
>
>+	vsock_bpf_build_proto();
>+
> 	return 0;
>
> err_unregister_proto:
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 28b5a8e8e094..e95df847176b 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -457,6 +457,8 @@ static struct virtio_transport virtio_transport = {
> 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
> 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>+
>+		.read_skb = virtio_transport_read_skb,
> 	},
>
> 	.send_pkt = virtio_transport_send_pkt,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index a1581c77cf84..f64527f32385 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1388,6 +1388,31 @@ int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *queue)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_purge_skbs);
>
>+int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_actor)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct sock *sk = sk_vsock(vsk);
>+	struct sk_buff *skb;
>+	int off = 0;
>+	int copied;
>+	int err;
>+
>+	spin_lock_bh(&vvs->rx_lock);
>+	/* Use __skb_recv_datagram() for race-free handling of the receive. It
>+	 * works for types other than dgrams.
>+	 */
>+	skb = __skb_recv_datagram(sk, &vvs->rx_queue, MSG_DONTWAIT, &off, &err);
>+	spin_unlock_bh(&vvs->rx_lock);
>+
>+	if (!skb)
>+		return err;
>+
>+	copied = recv_actor(sk, skb);
>+	kfree_skb(skb);
>+	return copied;
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>+
> MODULE_LICENSE("GPL v2");
> MODULE_AUTHOR("Asias He");
> MODULE_DESCRIPTION("common code for virtio vsock");
>diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
>new file mode 100644
>index 000000000000..9c71c163c684
>--- /dev/null
>+++ b/net/vmw_vsock/vsock_bpf.c
>@@ -0,0 +1,174 @@
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
>+#include <linux/wait.h>
>+#include <net/af_vsock.h>
>+#include <net/sock.h>
>+
>+#define vsock_sk_has_data(__sk, __psock)				\
>+		({	!skb_queue_empty(&(__sk)->sk_receive_queue) ||	\
>+			!skb_queue_empty(&(__psock)->ingress_skb) ||	\
>+			!list_empty(&(__psock)->ingress_msg);		\
>+		})
>+
>+static struct proto *vsock_prot_saved __read_mostly;
>+static DEFINE_SPINLOCK(vsock_prot_lock);
>+static struct proto vsock_bpf_prot;
>+
>+static bool vsock_has_data(struct sock *sk, struct sk_psock *psock)
>+{
>+	struct vsock_sock *vsk = vsock_sk(sk);
>+	s64 ret;
>+
>+	ret = vsock_connectible_has_data(vsk);
>+	if (ret > 0)
>+		return true;
>+
>+	return vsock_sk_has_data(sk, psock);
>+}
>+
>+static bool vsock_msg_wait_data(struct sock *sk, struct sk_psock *psock, long timeo)
>+{
>+	int ret;

`ret` can be bool now.

The rest LGTM.

Thanks,
Stefano


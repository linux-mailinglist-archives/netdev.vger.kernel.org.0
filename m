Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD29D674FEC
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 09:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjATI4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 03:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjATI4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 03:56:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17691367C5
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 00:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674204913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s3e6hycgcO72eezO5v4pG9Hz9NkTNCouPRTfvFIUR2A=;
        b=hZxi/2odcL3VQ4aZ3FF/WGvkFC5wuA0NZRaCrevj9/qFtDsfE+LAVv1GtLxDj5hEHfe2jQ
        RwuiOoS1yWTNYA8qejHXlDhs2YPddqu/dU4Z22P9wwqTOConM5Y3KXxkvbyntniCdaD2PC
        mGeG/kGue5X+O0HQjkEEZPtnOZfYvH0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-10-kl87FpRrP0eMbpfkWHXzOA-1; Fri, 20 Jan 2023 03:55:12 -0500
X-MC-Unique: kl87FpRrP0eMbpfkWHXzOA-1
Received: by mail-qv1-f72.google.com with SMTP id x6-20020a0cc506000000b005349c8b39d6so2212307qvi.2
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 00:55:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3e6hycgcO72eezO5v4pG9Hz9NkTNCouPRTfvFIUR2A=;
        b=GqND07o2EVPL1pOwudR1X8BW+c47bhOqcwC7p/IZaHsGUG7qrZh9IIK4eGe/jNDUD+
         eS5TPsqMSRSAQ6xO83MHwGCcY5NtudIcBg6bezexwvQrMjtAwTmgu5NTvIb8pQQCV7Vy
         G/gTfnCi/2OCO1pyTyA4mg/JmQDKLuxiUq8xWOnwS1J47UHRnJwiCHyDWi6K6GCFukq5
         WGaN6TGLku1wsgfRHW4GrXf+TQc8V6CpR+ytkspL++HJ3FEyG3UupAzq7YJLbaSDbd+M
         gC7hdozgbmVEu4Y5pQ8P9fgWqCQmibPA9VGDItHX5rEgsFwvSIcRueYdOEnlVUb40/VM
         KmlQ==
X-Gm-Message-State: AFqh2krhiLyDK2lg/PrrLnUwLrnGz1oONUA/K3pdMTsSi/yjxjY8b1Wk
        MbmR45J1NENtUpDGwtU5od/aRa7kcXJ/01vpxXt/I2MLu+vJgUFJur5O+r0nQGie6rDi6MKu42Z
        KAlUJGxbZDTdp7X1T
X-Received: by 2002:ac8:5292:0:b0:3ab:65aa:a873 with SMTP id s18-20020ac85292000000b003ab65aaa873mr18565438qtn.24.1674204911342;
        Fri, 20 Jan 2023 00:55:11 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtNnfvnXFPEwSoieIIOLcxRwjQu+UvQGnuCuQdvztXT9H8gf9ryouEKgkJUY0ME+LbBoSGzPw==
X-Received: by 2002:ac8:5292:0:b0:3ab:65aa:a873 with SMTP id s18-20020ac85292000000b003ab65aaa873mr18565408qtn.24.1674204910958;
        Fri, 20 Jan 2023 00:55:10 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-29.retail.telecomitalia.it. [87.11.6.29])
        by smtp.gmail.com with ESMTPSA id s10-20020a05620a29ca00b006fcb77f3bd6sm25996574qkp.98.2023.01.20.00.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 00:55:10 -0800 (PST)
Date:   Fri, 20 Jan 2023 09:55:02 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Song Liu <song@kernel.org>, Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Paolo Abeni <pabeni@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, Hao Luo <haoluo@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RFC 1/3] vsock: support sockmap
Message-ID: <20230120085502.xkltjilx6nmnxxgj@sgarzare-redhat>
References: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
 <20230118-support-vsock-sockmap-connectible-v1-1-d47e6294827b@bytedance.com>
 <20230119103936.ezjhewtqldhovybs@sgarzare-redhat>
 <Y8gLW0hI1sFtQ3Md@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y8gLW0hI1sFtQ3Md@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 03:08:11PM +0000, Bobby Eshleman wrote:
>On Thu, Jan 19, 2023 at 11:39:36AM +0100, Stefano Garzarella wrote:
>> On Wed, Jan 18, 2023 at 12:27:39PM -0800, Bobby Eshleman wrote:
>> > This patch adds sockmap support for vsock sockets. It is intended to be
>> > usable by all transports, but only the virtio transport is implemented.
>> >
>> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>> > ---
>> > drivers/vhost/vsock.c                   |   1 +
>> > include/linux/virtio_vsock.h            |   1 +
>> > include/net/af_vsock.h                  |  17 +++
>> > net/vmw_vsock/Makefile                  |   1 +
>> > net/vmw_vsock/af_vsock.c                |  59 +++++++++--
>> > net/vmw_vsock/virtio_transport.c        |   2 +
>> > net/vmw_vsock/virtio_transport_common.c |  22 ++++
>> > net/vmw_vsock/vsock_bpf.c               | 180 ++++++++++++++++++++++++++++++++
>> > net/vmw_vsock/vsock_loopback.c          |   2 +
>> > 9 files changed, 279 insertions(+), 6 deletions(-)
>>
>> ./scripts/checkpatch.pl --strict prints some simple warnings/checks that
>> I suggest to fix :-)
>>
>
>Oops, thanks. New machine, forgot my pre-commit hook. Putting in place
>now.
>
>> >
>> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> > index 1f3b89c885cca..3c6dc036b9044 100644
>> > --- a/drivers/vhost/vsock.c
>> > +++ b/drivers/vhost/vsock.c
>> > @@ -439,6 +439,7 @@ static struct virtio_transport vhost_transport = {
>> > 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
>> > 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>> >
>> > +		.read_skb = virtio_transport_read_skb,
>> > 	},
>> >
>> > 	.send_pkt = vhost_transport_send_pkt,
>> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> > index 3f9c166113063..c58453699ee98 100644
>> > --- a/include/linux/virtio_vsock.h
>> > +++ b/include/linux/virtio_vsock.h
>> > @@ -245,4 +245,5 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
>> > void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
>> > void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
>> > int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
>> > +int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
>> > #endif /* _LINUX_VIRTIO_VSOCK_H */
>> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> > index 568a87c5e0d0f..a73f5fbd296af 100644
>> > --- a/include/net/af_vsock.h
>> > +++ b/include/net/af_vsock.h
>> > @@ -75,6 +75,7 @@ struct vsock_sock {
>> > 	void *trans;
>> > };
>> >
>> > +s64 vsock_connectible_has_data(struct vsock_sock *vsk);
>> > s64 vsock_stream_has_data(struct vsock_sock *vsk);
>> > s64 vsock_stream_has_space(struct vsock_sock *vsk);
>> > struct sock *vsock_create_connected(struct sock *parent);
>> > @@ -173,6 +174,9 @@ struct vsock_transport {
>> >
>> > 	/* Addressing. */
>> > 	u32 (*get_local_cid)(void);
>> > +
>> > +	/* Read a single skb */
>> > +	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
>> > };
>> >
>> > /**** CORE ****/
>> > @@ -225,5 +229,18 @@ int vsock_init_tap(void);
>> > int vsock_add_tap(struct vsock_tap *vt);
>> > int vsock_remove_tap(struct vsock_tap *vt);
>> > void vsock_deliver_tap(struct sk_buff *build_skb(void *opaque), void *opaque);
>> > +int vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>> > +			      int flags);
>> > +int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>> > +			       size_t len, int flags);
>> > +
>> > +#ifdef CONFIG_BPF_SYSCALL
>> > +extern struct proto vsock_proto;
>> > +int vsock_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
>> > +void __init vsock_bpf_build_proto(void);
>> > +#else
>> > +static inline void __init vsock_bpf_build_proto(void)
>> > +{}
>> > +#endif
>> >
>> > #endif /* __AF_VSOCK_H__ */
>> > diff --git a/net/vmw_vsock/Makefile b/net/vmw_vsock/Makefile
>> > index 6a943ec95c4a5..5da74c4a9f1d1 100644
>> > --- a/net/vmw_vsock/Makefile
>> > +++ b/net/vmw_vsock/Makefile
>> > @@ -8,6 +8,7 @@ obj-$(CONFIG_HYPERV_VSOCKETS) += hv_sock.o
>> > obj-$(CONFIG_VSOCKETS_LOOPBACK) += vsock_loopback.o
>> >
>> > vsock-y += af_vsock.o af_vsock_tap.o vsock_addr.o
>> > +vsock-$(CONFIG_BPF_SYSCALL) += vsock_bpf.o
>> >
>> > vsock_diag-y += diag.o
>> >
>> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> > index d593d5b6d4b15..7081b3a992c1e 100644
>> > --- a/net/vmw_vsock/af_vsock.c
>> > +++ b/net/vmw_vsock/af_vsock.c
>> > @@ -116,10 +116,13 @@ static void vsock_sk_destruct(struct sock *sk);
>> > static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
>> >
>> > /* Protocol family. */
>> > -static struct proto vsock_proto = {
>> > +struct proto vsock_proto = {
>> > 	.name = "AF_VSOCK",
>> > 	.owner = THIS_MODULE,
>> > 	.obj_size = sizeof(struct vsock_sock),
>> > +#ifdef CONFIG_BPF_SYSCALL
>> > +	.psock_update_sk_prot = vsock_bpf_update_proto,
>> > +#endif
>> > };
>> >
>> > /* The default peer timeout indicates how long we will wait for a peer response
>> > @@ -865,7 +868,7 @@ s64 vsock_stream_has_data(struct vsock_sock *vsk)
>> > }
>> > EXPORT_SYMBOL_GPL(vsock_stream_has_data);
>> >
>> > -static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
>> > +s64 vsock_connectible_has_data(struct vsock_sock *vsk)
>> > {
>> > 	struct sock *sk = sk_vsock(vsk);
>> >
>> > @@ -874,6 +877,7 @@ static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
>> > 	else
>> > 		return vsock_stream_has_data(vsk);
>> > }
>> > +EXPORT_SYMBOL_GPL(vsock_connectible_has_data);
>> >
>> > s64 vsock_stream_has_space(struct vsock_sock *vsk)
>> > {
>> > @@ -1131,6 +1135,19 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
>> > 	return mask;
>> > }
>> >
>> > +static int vsock_read_skb(struct sock *sk, skb_read_actor_t read_actor)
>> > +{
>> > +	struct vsock_sock *vsk = vsock_sk(sk);
>> > +
>> > +	if (!vsk->transport)
>> > +		return -ENODEV;
>> > +
>> > +	if (!vsk->transport->read_skb)
>> > +		return -EOPNOTSUPP;
>> > +
>> > +	return vsk->transport->read_skb(vsk, read_actor);
>> > +}
>> > +
>> > static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>> > 			       size_t len)
>> > {
>> > @@ -1241,19 +1258,32 @@ static int vsock_dgram_connect(struct socket *sock,
>> >
>> > 	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
>> > 	sock->state = SS_CONNECTED;
>> > +	sk->sk_state = TCP_ESTABLISHED;
>>
>> Why we need this change?
>> If it's a fix, we should put it in another patch.
>>
>
>This is just required by sockmap's function that determines if a socket
>is a valid one to add to a map. It will refuse to add any socket that is
>not TCP_ESTABLISHED to a sockmap.
>
>This was the approach that unix dgrams took, so I followed here.

Okay, make sense to me.
Maybe mention that in the commit message.

>
>> >
>> > out:
>> > 	release_sock(sk);
>> > 	return err;
>> > }
>> >
>> > -static int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>> > -			       size_t len, int flags)
>> > +int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>> > +			size_t len, int flags)
>> > {
>> > -	struct vsock_sock *vsk = vsock_sk(sock->sk);
>> > +	const struct proto *prot;
>>
>> We should use the guard for this statement as in
>> vsock_connectible_recvmsg().
>>
>
>Got it.
>
>> > +	struct vsock_sock *vsk;
>> > +	struct sock *sk;
>> > +
>> > +	sk = sock->sk;
>> > +	vsk = vsock_sk(sk);
>> > +
>> > +#ifdef CONFIG_BPF_SYSCALL
>> > +	prot = READ_ONCE(sk->sk_prot);
>> > +	if (prot != &vsock_proto)
>> > +		return prot->recvmsg(sk, msg, len, flags, NULL);
>> > +#endif
>> >
>> > 	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
>> > }
>> > +EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
>> >
>> > static const struct proto_ops vsock_dgram_ops = {
>> > 	.family = PF_VSOCK,
>> > @@ -1272,6 +1302,7 @@ static const struct proto_ops vsock_dgram_ops = {
>> > 	.recvmsg = vsock_dgram_recvmsg,
>> > 	.mmap = sock_no_mmap,
>> > 	.sendpage = sock_no_sendpage,
>> > +	.read_skb = vsock_read_skb,
>> > };
>> >
>> > static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
>> > @@ -2085,13 +2116,16 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>> > 	return err;
>> > }
>> >
>> > -static int
>> > +int
>> > vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>> > 			  int flags)
>> > {
>> > 	struct sock *sk;
>> > 	struct vsock_sock *vsk;
>> > 	const struct vsock_transport *transport;
>> > +#ifdef CONFIG_BPF_SYSCALL
>> > +	const struct proto *prot;
>> > +#endif
>> > 	int err;
>> >
>> > 	sk = sock->sk;
>> > @@ -2138,6 +2172,14 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>> > 		goto out;
>> > 	}
>> >
>> > +#ifdef CONFIG_BPF_SYSCALL
>> > +	prot = READ_ONCE(sk->sk_prot);
>> > +	if (prot != &vsock_proto) {
>> > +		release_sock(sk);
>> > +		return prot->recvmsg(sk, msg, len, flags, NULL);
>> > +	}
>> > +#endif
>> > +
>> > 	if (sk->sk_type == SOCK_STREAM)
>> > 		err = __vsock_stream_recvmsg(sk, msg, len, flags);
>> > 	else
>> > @@ -2147,6 +2189,7 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>> > 	release_sock(sk);
>> > 	return err;
>> > }
>> > +EXPORT_SYMBOL_GPL(vsock_connectible_recvmsg);
>> >
>> > static int vsock_set_rcvlowat(struct sock *sk, int val)
>> > {
>> > @@ -2187,6 +2230,7 @@ static const struct proto_ops vsock_stream_ops = {
>> > 	.mmap = sock_no_mmap,
>> > 	.sendpage = sock_no_sendpage,
>> > 	.set_rcvlowat = vsock_set_rcvlowat,
>> > +	.read_skb = vsock_read_skb,
>> > };
>> >
>> > static const struct proto_ops vsock_seqpacket_ops = {
>> > @@ -2208,6 +2252,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
>> > 	.recvmsg = vsock_connectible_recvmsg,
>> > 	.mmap = sock_no_mmap,
>> > 	.sendpage = sock_no_sendpage,
>> > +	.read_skb = vsock_read_skb,
>> > };
>> >
>> > static int vsock_create(struct net *net, struct socket *sock,
>> > @@ -2347,6 +2392,8 @@ static int __init vsock_init(void)
>> > 		goto err_unregister_proto;
>> > 	}
>> >
>> > +	vsock_bpf_build_proto();
>> > +
>> > 	return 0;
>> >
>> > err_unregister_proto:
>> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> > index 28b5a8e8e0948..e95df847176b6 100644
>> > --- a/net/vmw_vsock/virtio_transport.c
>> > +++ b/net/vmw_vsock/virtio_transport.c
>> > @@ -457,6 +457,8 @@ static struct virtio_transport virtio_transport = {
>> > 		.notify_send_pre_enqueue  =
>> > 		virtio_transport_notify_send_pre_enqueue,
>> > 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
>> > 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>> > +
>> > +		.read_skb = virtio_transport_read_skb,
>> > 	},
>> >
>> > 	.send_pkt = virtio_transport_send_pkt,
>> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> > index a1581c77cf84a..9a87ead5b1fc5 100644
>> > --- a/net/vmw_vsock/virtio_transport_common.c
>> > +++ b/net/vmw_vsock/virtio_transport_common.c
>> > @@ -1388,6 +1388,28 @@ int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *queue)
>> > }
>> > EXPORT_SYMBOL_GPL(virtio_transport_purge_skbs);
>> >
>> > +int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_actor)
>> > +{
>> > +	struct virtio_vsock_sock *vvs = vsk->trans;
>> > +	struct sock *sk = sk_vsock(vsk);
>> > +	struct sk_buff *skb;
>> > +	int copied = 0;
>>
>> We could avoid initializing `copied`, since it is overwritten later.
>>
>
>Got it.
>
>> > +	int off = 0;
>> > +	int err;
>> > +
>> > +	spin_lock_bh(&vvs->rx_lock);
>> > +	skb = __skb_recv_datagram(sk, &vvs->rx_queue, MSG_DONTWAIT, &off, &err);
>>
>> Will this work also for STREAM and SEQPACKET sockets?
>>
>
>Yep, it is used for non-datagram sockets as well because it is free of race
>conditions, and handles waits/errors sensibly. For example, in
>unix_accept():
>
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/unix/af_unix.c#n1696

Good to know :-)
I'd add a comment, just because the function name suggests something 
else.

>
>> > +	spin_unlock_bh(&vvs->rx_lock);
>> > +
>> > +	if (!skb)
>> > +		return err;
>> > +
>> > +	copied = recv_actor(sk, skb);
>> > +	kfree_skb(skb);
>>
>> I would have moved these steps to vsock_read_skb() to avoid duplicating
>> these steps in each transport. Perhaps not all transports want to pass
>> skb ownership to the caller, though, so maybe we can leave it that
>> way for now.
>>
>
>That is a good point though. I bet your initial hunch is the right one.
>If even one other transport duplicates this, then I'd say it is worth
>pulling up into vsock_read_skb().

Make sense to me :-)

>
>> > +	return copied;
>> > +}
>> > +EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>> > +
>> > MODULE_LICENSE("GPL v2");
>> > MODULE_AUTHOR("Asias He");
>> > MODULE_DESCRIPTION("common code for virtio vsock");
>> > diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
>> > new file mode 100644
>> > index 0000000000000..9e11282d3bc1f
>> > --- /dev/null
>> > +++ b/net/vmw_vsock/vsock_bpf.c
>> > @@ -0,0 +1,180 @@
>> > +// SPDX-License-Identifier: GPL-2.0
>> > +/* Copyright (c) 2022 Bobby Eshleman <bobby.eshleman@bytedance.com>
>> > + *
>> > + * Based off of net/unix/unix_bpf.c
>> > + */
>> > +
>> > +#include <linux/bpf.h>
>> > +#include <linux/module.h>
>> > +#include <linux/skmsg.h>
>> > +#include <linux/socket.h>
>> > +#include <net/af_vsock.h>
>> > +#include <net/sock.h>
>> > +
>> > +#define vsock_sk_has_data(__sk, __psock)				\
>> > +		({	!skb_queue_empty(&__sk->sk_receive_queue) ||	\
>> > +			!skb_queue_empty(&__psock->ingress_skb) ||	\
>> > +			!list_empty(&__psock->ingress_msg);		\
>> > +		})
>> > +
>> > +static struct proto *vsock_dgram_prot_saved __read_mostly;
>> > +static DEFINE_SPINLOCK(vsock_dgram_prot_lock);
>> > +static struct proto vsock_dgram_bpf_prot;
>> > +
>> > +static bool vsock_has_data(struct vsock_sock *vsk, struct sk_psock *psock)
>> > +{
>> > +	struct sock *sk = sk_vsock(vsk);
>> > +	s64 ret;
>> > +
>> > +	ret = vsock_connectible_has_data(vsk);
>> > +	if (ret > 0)
>> > +		return true;
>> > +
>> > +	return vsock_sk_has_data(sk, psock);
>> > +}
>> > +
>> > +static int vsock_msg_wait_data(struct sock *sk, struct sk_psock *psock, long timeo)
>> > +{
>> > +	struct vsock_sock *vsk;
>> > +	int err;
>> > +
>> > +	DEFINE_WAIT(wait);
>> > +
>> > +	vsk = vsock_sk(sk);
>> > +	err = 0;
>> > +
>> > +	while (vsock_has_data(vsk, psock)) {
>> > +		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
>> > +
>> > +		if (sk->sk_err != 0 ||
>> > +		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>> > +		    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
>> > +			break;
>> > +		}
>> > +
>> > +		if (timeo == 0) {
>> > +			err = -EAGAIN;
>> > +			break;
>> > +		}
>> > +
>> > +		release_sock(sk);
>> > +		timeo = schedule_timeout(timeo);
>> > +		lock_sock(sk);
>> > +
>> > +		if (signal_pending(current)) {
>> > +			err = sock_intr_errno(timeo);
>> > +			break;
>> > +		} else if (timeo == 0) {
>> > +			err = -EAGAIN;
>> > +			break;
>> > +		}
>> > +	}
>> > +
>> > +	finish_wait(sk_sleep(sk), &wait);
>> > +
>> > +	if (err)
>> > +		return err;
>> > +
>> > +	return 0;
>> > +}
>> > +
>> > +static int vsock_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags)
>> > +{
>> > +	int err;
>> > +	struct socket *sock = sk->sk_socket;
>> > +
>> > +	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
>> > +		err = vsock_connectible_recvmsg(sock, msg, len, flags);
>> > +	else
>>
>> Could it happen that it is not DGRAM and we should return an error in
>> this case?
>>
>
>I'm not sure but for the sake of safety, I'll add that.

Yep, I agree.

Thanks,
Stefano


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3DC3219FE
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 15:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhBVOQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 09:16:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232004AbhBVONw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 09:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614003146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C4ob/HwZY6JToPa6OIARFnOVuWbb8EWH4Jtjs9jshMI=;
        b=ZJzeBd3FVu9OByQEluSXqLAxIaaA+l8rj3B7FAUNatpqBwKy5wI7Ak6GGvRUxbLDT9EsYc
        pJWPkcz9eTGJGPBhHDMGuBu7t4DHMxM2w8Wune7o4q6umXgKkEYMWe7rubfC9HrvXtM9qU
        7FzrvRRnrY47BlS6D/5s3Dx4w4zR7Uo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-kx5LNfBpOheI5w8yaZKDrA-1; Mon, 22 Feb 2021 09:12:24 -0500
X-MC-Unique: kx5LNfBpOheI5w8yaZKDrA-1
Received: by mail-wr1-f70.google.com with SMTP id t14so2840296wrr.11
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 06:12:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C4ob/HwZY6JToPa6OIARFnOVuWbb8EWH4Jtjs9jshMI=;
        b=SvsN4+9p0CynjBsz7kYk5RpPmFYRDWH28cUFfXh4T4lRBeniMYIdwyS6o8pbxEUFx0
         iUYzFJBYu7VDzcOoBZ8Q3VSXB0qTmylfTS/e3iO1AvIQhIfunroNEsW8r2uCV4aNzynV
         ppctMEy4UaAvA5iePSXLENf7pleFx70gbReqnF5Xd5lH+mqjdYR35pcDiPHfJuj2qpk+
         +vah+Nkf7s3GzP1geS4OGmKYZpAqVwCVENFQviohDqhpLV35Yr4VllD/7Y9A0VIalTdJ
         CmZobHyJsE2nWqpsdQJgeua7W4gDmmDtnqNd+KZ8c44ecORJ4spHRnu2MWqZUCxISbeV
         D2bw==
X-Gm-Message-State: AOAM532DwdwWd7Yv0tGvhFyY2CJ9ZQ2ipeWH8DbnAefY4Xeg2LEPQuAL
        kx2VWyApTwMgT/r+SqBNhjWgF2+maHiG6p5td0Y8exM2sf4X1fm0pI/Iy/kV1K0EJWz9Y/2QWhI
        i0GAvUBykJ0b73DND
X-Received: by 2002:a5d:5441:: with SMTP id w1mr21614561wrv.366.1614003142875;
        Mon, 22 Feb 2021 06:12:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzvUh6+RKpz1p9mHjfUgu/bHee+H13baHG8nnXHUSqARjGTCoY6aSGxXiwzPvqOvhgWfA6Rew==
X-Received: by 2002:a5d:5441:: with SMTP id w1mr21614537wrv.366.1614003142640;
        Mon, 22 Feb 2021 06:12:22 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id i1sm25218726wmq.12.2021.02.22.06.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 06:12:22 -0800 (PST)
Date:   Mon, 22 Feb 2021 15:12:19 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 07/19] af_vsock: rest of SEQPACKET support
Message-ID: <20210222141219.nvw4323sizvsud5d@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053831.1067678-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218053831.1067678-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 08:38:28AM +0300, Arseny Krasnov wrote:
>This does rest of SOCK_SEQPACKET support:
>1) Adds socket ops for SEQPACKET type.
>2) Allows to create socket with SEQPACKET type.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 36 +++++++++++++++++++++++++++++++++++-
> 1 file changed, 35 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index f352cd9d91ce..f4b02c6d35d1 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -452,6 +452,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 		new_transport = transport_dgram;
> 		break;
> 	case SOCK_STREAM:
>+	case SOCK_SEQPACKET:
> 		if (vsock_use_local_transport(remote_cid))
> 			new_transport = transport_local;
> 		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
>@@ -484,6 +485,14 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 	if (!new_transport || !try_module_get(new_transport->module))
> 		return -ENODEV;
>
>+	if (sk->sk_type == SOCK_SEQPACKET) {
>+		if (!new_transport->seqpacket_seq_send_len ||
>+		    !new_transport->seqpacket_seq_send_eor ||
>+		    !new_transport->seqpacket_seq_get_len ||
>+		    !new_transport->seqpacket_dequeue)

We must release the module reference acquired above:

			module_put(new_transport->module);

>+			return -ESOCKTNOSUPPORT;
>+	}
>+
> 	ret = new_transport->init(vsk, psk);
> 	if (ret) {
> 		module_put(new_transport->module);
>@@ -684,6 +693,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
>
> 	switch (sk->sk_socket->type) {
> 	case SOCK_STREAM:
>+	case SOCK_SEQPACKET:
> 		spin_lock_bh(&vsock_table_lock);
> 		retval = __vsock_bind_connectible(vsk, addr);
> 		spin_unlock_bh(&vsock_table_lock);
>@@ -769,7 +779,7 @@ static struct sock *__vsock_create(struct net *net,
>
> static bool sock_type_connectible(u16 type)
> {
>-	return type == SOCK_STREAM;
>+	return (type == SOCK_STREAM) || (type == SOCK_SEQPACKET);
> }
>
> static void __vsock_release(struct sock *sk, int level)
>@@ -2191,6 +2201,27 @@ static const struct proto_ops vsock_stream_ops = {
> 	.sendpage = sock_no_sendpage,
> };
>
>+static const struct proto_ops vsock_seqpacket_ops = {
>+	.family = PF_VSOCK,
>+	.owner = THIS_MODULE,
>+	.release = vsock_release,
>+	.bind = vsock_bind,
>+	.connect = vsock_connect,
>+	.socketpair = sock_no_socketpair,
>+	.accept = vsock_accept,
>+	.getname = vsock_getname,
>+	.poll = vsock_poll,
>+	.ioctl = sock_no_ioctl,
>+	.listen = vsock_listen,
>+	.shutdown = vsock_shutdown,
>+	.setsockopt = vsock_connectible_setsockopt,
>+	.getsockopt = vsock_connectible_getsockopt,
>+	.sendmsg = vsock_connectible_sendmsg,
>+	.recvmsg = vsock_connectible_recvmsg,
>+	.mmap = sock_no_mmap,
>+	.sendpage = sock_no_sendpage,
>+};
>+
> static int vsock_create(struct net *net, struct socket *sock,
> 			int protocol, int kern)
> {
>@@ -2211,6 +2242,9 @@ static int vsock_create(struct net *net, struct socket *sock,
> 	case SOCK_STREAM:
> 		sock->ops = &vsock_stream_ops;
> 		break;
>+	case SOCK_SEQPACKET:
>+		sock->ops = &vsock_seqpacket_ops;
>+		break;
> 	default:
> 		return -ESOCKTNOSUPPORT;
> 	}
>-- 
>2.25.1
>


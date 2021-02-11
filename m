Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3EA318AC3
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhBKMfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:35:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229649AbhBKM2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:28:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613046440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HMz6zYsvhAUacFy6he/Ff5pa+8L4MB4YjmA0Jw1xjYQ=;
        b=iQr6ock4ozX6Qc1vCQmUbkw4AjYbn5tMI13JXOfNFb87+Z5DYnli3FIcNY8alu1g5AcXw6
        8e+bM+zmzvnTlt5AZaJW8um81LGE3KDFAm4BROc9Z/QJbjUBjmhKVbk/DTgeISEHUH571t
        bB9OxsfjB6StnCO3ru/CxR8EQRg4jdk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-rNM7g0u4Mn-oZ2iCsh8lSw-1; Thu, 11 Feb 2021 07:27:18 -0500
X-MC-Unique: rNM7g0u4Mn-oZ2iCsh8lSw-1
Received: by mail-ed1-f71.google.com with SMTP id g6so4573991edy.9
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 04:27:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HMz6zYsvhAUacFy6he/Ff5pa+8L4MB4YjmA0Jw1xjYQ=;
        b=ZxIlQ/XPGtdQd5N0ZgCDhEKZMibhnJjfsVKntQP8r5GHG+rH/JwlPowTBRh+zsEqeU
         8jEivPcQiW4/l/sRP7L+w7qWzFBcabwOXoW+FU2xIkng+yExrSl7BYcMNUYjz2foYLM+
         FhEpElBFCBdVD4wseoAhd+AQ2BWtXlIot0x0fYgSqEhr1HCxcN9ClqDJX6E8hOdoI6hp
         kXkWnE48Y3Xej47lJOXyc3W3CIx1wyBEha594FTT275/PDLarXuoYINS/5/ske/zbMKI
         uLhxee/CbeRQmsMgxRoyqYMWdhu9HKffE8bnB11g/C4+6XNOgprm3PZd5OOalyZQFlKg
         bJYg==
X-Gm-Message-State: AOAM5323v2Fo3Ecwzv8MSRk9eQpGhkXRY0io7c9ZvldkZp9YZbOTYi00
        sRQwoM4MSzfMTAsJDpbK50ZiGcdCkOvkp6CxpCDEsie/DjT9YOTLU4xazG35n5TclA3pTF17F2V
        3I3kvwBxlbHfUiPRZ
X-Received: by 2002:a17:906:2747:: with SMTP id a7mr8529854ejd.250.1613046437362;
        Thu, 11 Feb 2021 04:27:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyk6B6DSr3e6B0w/xlbcUeWXisr2RXOx2YRDpQHkAnrdl/RyyOhCzJ+iUDi0A/EsFUj4H9p5g==
X-Received: by 2002:a17:906:2747:: with SMTP id a7mr8529844ejd.250.1613046437196;
        Thu, 11 Feb 2021 04:27:17 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id bo24sm3698134edb.51.2021.02.11.04.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:27:16 -0800 (PST)
Date:   Thu, 11 Feb 2021 13:27:14 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 07/17] af_vsock: rest of SEQPACKET support
Message-ID: <20210211122714.rqiwg3qp3kuprktb@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151615.805115-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151615.805115-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 06:16:12PM +0300, Arseny Krasnov wrote:
>This does rest of SOCK_SEQPACKET support:
>1) Adds socket ops for SEQPACKET type.
>2) Allows to create socket with SEQPACKET type.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 37 ++++++++++++++++++++++++++++++++++++-
> 1 file changed, 36 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index a033d3340ac4..c77998a14018 100644
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
>@@ -459,6 +460,15 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 			new_transport = transport_g2h;
> 		else
> 			new_transport = transport_h2g;
>+
>+		if (sk->sk_type == SOCK_SEQPACKET) {
>+			if (!new_transport ||
>+			    !new_transport->seqpacket_seq_send_len ||
>+			    !new_transport->seqpacket_seq_send_eor ||
>+			    !new_transport->seqpacket_seq_get_len ||
>+			    !new_transport->seqpacket_dequeue)
>+				return -ESOCKTNOSUPPORT;
>+		}

Maybe we should move this check after the try_module_get() call, since 
the memory pointed by 'new_transport' pointer can be deallocated in the 
meantime.

Also, if the socket had a transport before, we should deassign it before 
returning an error.

> 		break;
> 	default:
> 		return -ESOCKTNOSUPPORT;
>@@ -684,6 +694,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
>
> 	switch (sk->sk_socket->type) {
> 	case SOCK_STREAM:
>+	case SOCK_SEQPACKET:
> 		spin_lock_bh(&vsock_table_lock);
> 		retval = __vsock_bind_connectible(vsk, addr);
> 		spin_unlock_bh(&vsock_table_lock);
>@@ -769,7 +780,7 @@ static struct sock *__vsock_create(struct net *net,
>
> static bool sock_type_connectible(u16 type)
> {
>-	return type == SOCK_STREAM;
>+	return (type == SOCK_STREAM) || (type == SOCK_SEQPACKET);
> }
>
> static void __vsock_release(struct sock *sk, int level)
>@@ -2199,6 +2210,27 @@ static const struct proto_ops vsock_stream_ops = {
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
>@@ -2219,6 +2251,9 @@ static int vsock_create(struct net *net, struct socket *sock,
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


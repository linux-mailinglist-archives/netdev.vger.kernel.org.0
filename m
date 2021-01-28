Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B041307BD0
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 18:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhA1RIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 12:08:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232829AbhA1RGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 12:06:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611853473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LvcQzCTMhw0EZfzlSb3F515FxbS4cvGqc8hLzWtIraw=;
        b=JcDnJh5pewXv5NoDV+Wsn4MLDtPKTQJHuCf1YH3OcwfNxXwsCoImJLW1YdIKyib2q8nluV
        a2hg3Pb7mAujnj0zj8AKS6UrscBXebqoLA06j/BJ9LDOVqJQ7WeUwy67X7YcuFrLIfDo97
        dld42Mua92RJOIDALSNiLBW9n+aEwgc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-W3JbmY22MhS2vL6BJQ7bmA-1; Thu, 28 Jan 2021 12:04:32 -0500
X-MC-Unique: W3JbmY22MhS2vL6BJQ7bmA-1
Received: by mail-wr1-f69.google.com with SMTP id h18so3447853wrr.5
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 09:04:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LvcQzCTMhw0EZfzlSb3F515FxbS4cvGqc8hLzWtIraw=;
        b=IhNJgHpQNm+JqX3h80RLRgXZXlTIJJsw5ktgpgG54Q6yDzY44Na1zKi+lZxUnPRL9B
         p3+Ogc32SdgBVDSl/xefI//ZFd6941GIUdGzXAjwmjnuCynUPByk7ioLaNXWESS6FHte
         uzL3remg2c/DlF1RdQrFp+MMrsUtvJv4soagF0W/ALm8wPrAErDYK00Iw3lWp7BZ78mS
         Hy08vte/KQLixyaxcFPMICUEmQxepoc0mv36IoSTrJddC+Zy3hNQWyAIxc3alrNj6K5c
         vb29obzaIcoyMLhOOVUNdSPpVhtvcNidm3m0Av+B1rWFhdoKjh019+3WrKjqpkJq4y0X
         Ui6g==
X-Gm-Message-State: AOAM533Oyq6j13ygwn/ipZu2h3vSzWTdwxVCXib6zXTOvV5Lm7AQ1ZKW
        ZxVICxif7OtRkINBmatIyYXZ4dj9nWVJ5Ys5pj2rlZ2php0bcvZXJD/xYy9Kw+WSOpYZ40z1z6N
        0t+ZtALdcLNPyZFye
X-Received: by 2002:adf:9148:: with SMTP id j66mr47619wrj.28.1611853470490;
        Thu, 28 Jan 2021 09:04:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFXNXAEEeUISjmsj6o5JuE/Q8ctqnwUsP41thgGGDQLpC8xK5225WjWWJKnBOg3AVOH+RIYQ==
X-Received: by 2002:adf:9148:: with SMTP id j66mr47572wrj.28.1611853470215;
        Thu, 28 Jan 2021 09:04:30 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id v4sm8574382wrw.42.2021.01.28.09.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 09:04:29 -0800 (PST)
Date:   Thu, 28 Jan 2021 18:04:26 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 05/13] af_vsock: rest of SEQPACKET support
Message-ID: <20210128170426.522mpkocdd35bt2e@steredhat>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
 <20210125111321.598653-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210125111321.598653-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 02:13:18PM +0300, Arseny Krasnov wrote:
>This does rest of SOCK_SEQPACKET support:
>1) Adds socket ops for SEQPACKET type.
>2) Allows to create socket with SEQPACKET type.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 71 ++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 71 insertions(+)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 4600c1ec3bb3..bbc3c31085aa 100644
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
>@@ -459,6 +460,13 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 			new_transport = transport_g2h;
> 		else
> 			new_transport = transport_h2g;
>+
>+		if (sk->sk_type == SOCK_SEQPACKET) {

I think you must also check that new_transport is not NULL.

>+			if (!new_transport->seqpacket_seq_send_len ||
>+			    !new_transport->seqpacket_seq_get_len ||
>+			    !new_transport->seqpacket_dequeue)
>+				return -ENODEV;

I'm not sure about ENODEV is the better choice in this case, since the 
transport exists, but it doesn't support SOCK_SEQPACKET, so maybe is 
better ESOCKTNOSUPPORT.

>+		}
> 		break;
> 	default:
> 		return -ESOCKTNOSUPPORT;
>@@ -684,6 +692,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
>
> 	switch (sk->sk_socket->type) {
> 	case SOCK_STREAM:
>+	case SOCK_SEQPACKET:
> 		spin_lock_bh(&vsock_table_lock);
> 		retval = __vsock_bind_connectible(vsk, addr);
> 		spin_unlock_bh(&vsock_table_lock);
>@@ -1406,6 +1415,12 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
> 	return vsock_connect(sock, addr, addr_len, flags);
> }
>
>+static int vsock_seqpacket_connect(struct socket *sock, struct sockaddr *addr,
>+				   int addr_len, int flags)
>+{
>+	return vsock_connect(sock, addr, addr_len, flags);
>+}
>+
> static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
> 			bool kern)
> {
>@@ -1633,6 +1648,16 @@ static int vsock_stream_setsockopt(struct socket *sock,
> 					    optlen);
> }
>
>+static int vsock_seqpacket_setsockopt(struct socket *sock,
>+				      int level,
>+				      int optname,
>+				      sockptr_t optval,
>+				      unsigned int optlen)
>+{
>+	return vsock_connectible_setsockopt(sock, level, optname, optval,
>+					    optlen);
>+}
>+
> static int vsock_connectible_getsockopt(struct socket *sock,
> 					int level, int optname,
> 					char __user *optval,
>@@ -1713,6 +1738,15 @@ static int vsock_stream_getsockopt(struct socket *sock,
> 					    optlen);
> }
>
>+static int vsock_seqpacket_getsockopt(struct socket *sock,
>+				      int level, int optname,
>+				      char __user *optval,
>+				      int __user *optlen)
>+{
>+	return vsock_connectible_getsockopt(sock, level, optname, optval,
>+					    optlen);
>+}
>+
> static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 				     size_t len)
> {
>@@ -1870,6 +1904,12 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
> 	return vsock_connectible_sendmsg(sock, msg, len);
> }
>
>+static int vsock_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
>+				   size_t len)
>+{
>+	return vsock_connectible_sendmsg(sock, msg, len);
>+}
>+
> static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
> 			   long timeout,
> 			   struct vsock_transport_recv_notify_data *recv_data,
>@@ -2184,6 +2224,13 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	return vsock_connectible_recvmsg(sock, msg, len, flags);
> }
>
>+static int
>+vsock_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>+			int flags)
>+{
>+	return vsock_connectible_recvmsg(sock, msg, len, flags);
>+}
>+

As I said, I think you don't need to implement all of this helpers and 
you can directly assign the vsock_connectible_* functions in the 
'vsock_seqpacket_ops'.

> static const struct proto_ops vsock_stream_ops = {
> 	.family = PF_VSOCK,
> 	.owner = THIS_MODULE,
>@@ -2205,6 +2252,27 @@ static const struct proto_ops vsock_stream_ops = {
> 	.sendpage = sock_no_sendpage,
> };
>
>+static const struct proto_ops vsock_seqpacket_ops = {
>+	.family = PF_VSOCK,
>+	.owner = THIS_MODULE,
>+	.release = vsock_release,
>+	.bind = vsock_bind,
>+	.connect = vsock_seqpacket_connect,
>+	.socketpair = sock_no_socketpair,
>+	.accept = vsock_accept,
>+	.getname = vsock_getname,
>+	.poll = vsock_poll,
>+	.ioctl = sock_no_ioctl,
>+	.listen = vsock_listen,
>+	.shutdown = vsock_shutdown,
>+	.setsockopt = vsock_seqpacket_setsockopt,
>+	.getsockopt = vsock_seqpacket_getsockopt,
>+	.sendmsg = vsock_seqpacket_sendmsg,
>+	.recvmsg = vsock_seqpacket_recvmsg,
>+	.mmap = sock_no_mmap,
>+	.sendpage = sock_no_sendpage,
>+};
>+
> static int vsock_create(struct net *net, struct socket *sock,
> 			int protocol, int kern)
> {
>@@ -2225,6 +2293,9 @@ static int vsock_create(struct net *net, struct socket *sock,
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


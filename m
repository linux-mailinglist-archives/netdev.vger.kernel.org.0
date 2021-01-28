Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12189307A67
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhA1QMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:12:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21360 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232401AbhA1QMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:12:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611850237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q3+GaWOJcVoS280BO4ZTgt8MtsvmJpeZvLy5xokg2jk=;
        b=QJTPhyV1S5iQa5g7hOkXF/Fn6ZuDq+5txppfBjVBydJzkAxdDt81jbxK2pN9+B14vvEnbP
        ajn0aOjoTBG0fj2oe8S66tq7Bf8gWhZLDmFcuOzBR7T/9R4cE5S/P8sL4lHtA6Sqh1Mfrt
        Gv5wCV4eLLzRKKDm4HPnNe7HG/veMVw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-75J1hoYnNUqiw1Vv0ypaFA-1; Thu, 28 Jan 2021 11:10:34 -0500
X-MC-Unique: 75J1hoYnNUqiw1Vv0ypaFA-1
Received: by mail-wr1-f70.google.com with SMTP id l13so3343004wrq.7
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 08:10:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q3+GaWOJcVoS280BO4ZTgt8MtsvmJpeZvLy5xokg2jk=;
        b=FS//MSl0SCjkyP5ouJx1K/JUD6qKQZQUn2xVjfbVxGs/jY3pYTigsiVq5QM+g+evjU
         k9rzhDTGBeYQsawWfdUBO1H2OUNmvw9K7qsgutVVfjcI0HnL9HYlLVvQCMPwtAkyoWdy
         HeQUHK77ZIWJmtTF5oq36tKi6W/yYTd7ykN7ShON9JL1FiRpCPf3RsYTD0uLb29kp2Ty
         /kXqz6h8xBTaaAvYlqIPcW7cuXu0tEn3Z2uoBi0MH0S4pEmHVwF+jBmflipfbyDqaOAb
         QTGmxxg9CAnY4PBGnOU4W/EJfxcarhyUPigedErjohgQGipbhZrLeAJf/1ypNOax4XmR
         K7pA==
X-Gm-Message-State: AOAM533IkukaVB1/GJzNBLqovU/RftY6F/v9whC/joETIlWKU4X/iGgu
        BizrrUFra77TknF/GoWMsHFkTQJqnFw559D4cEQqrd/dmVVFp2KB6JgcUWS8hfDbt9RwFcATGbN
        qfC1ILf6ii07HrEIU
X-Received: by 2002:a5d:5910:: with SMTP id v16mr17858693wrd.29.1611850233400;
        Thu, 28 Jan 2021 08:10:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCJxet7P/Zrk9KZEMXq8X1p9C2h5zi7JFYpLswRvkfkQWra6ZTD64HKpdUGYoJqTRtuXS7kQ==
X-Received: by 2002:a5d:5910:: with SMTP id v16mr17858644wrd.29.1611850233122;
        Thu, 28 Jan 2021 08:10:33 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id l10sm7495512wro.4.2021.01.28.08.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 08:10:32 -0800 (PST)
Date:   Thu, 28 Jan 2021 17:10:29 +0100
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
Subject: Re: [RFC PATCH v3 01/13] af_vsock: prepare for SOCK_SEQPACKET support
Message-ID: <20210128161029.a53la6e3dv5bzazn@steredhat>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
 <20210125111131.597930-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210125111131.597930-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think the patch title should be more explicit, so something like

vsock: generalize function to manage connectible sockets

On Mon, Jan 25, 2021 at 02:11:28PM +0300, Arseny Krasnov wrote:
>This prepares af_vsock.c for SEQPACKET support:
>1) As both stream and seqpacket sockets are connection oriented, add
>   check for SOCK_SEQPACKET to conditions where SOCK_STREAM is checked.
>2) Some functions such as setsockopt(), getsockopt(), connect(),
>   recvmsg(), sendmsg() are shared between both types of sockets, so
>   rename them in general manner and create entry points for each type
>   of socket to call these functions(for stream in this patch, for
>   seqpacket in further patches).
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 91 +++++++++++++++++++++++++++++-----------
> 1 file changed, 67 insertions(+), 24 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index b12d3a322242..c9ce57db9554 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -604,8 +604,8 @@ static void vsock_pending_work(struct work_struct *work)
>
> /**** SOCKET OPERATIONS ****/
>
>-static int __vsock_bind_stream(struct vsock_sock *vsk,
>-			       struct sockaddr_vm *addr)
>+static int __vsock_bind_connectible(struct vsock_sock *vsk,
>+				    struct sockaddr_vm *addr)
> {
> 	static u32 port;
> 	struct sockaddr_vm new_addr;
>@@ -685,7 +685,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
> 	switch (sk->sk_socket->type) {
> 	case SOCK_STREAM:
> 		spin_lock_bh(&vsock_table_lock);
>-		retval = __vsock_bind_stream(vsk, addr);
>+		retval = __vsock_bind_connectible(vsk, addr);
> 		spin_unlock_bh(&vsock_table_lock);
> 		break;
>
>@@ -767,6 +767,11 @@ static struct sock *__vsock_create(struct net *net,
> 	return sk;
> }
>
>+static bool sock_type_connectible(u16 type)
>+{
>+	return (type == SOCK_STREAM || type == SOCK_SEQPACKET);
>+}
>+

I think it's okay to add this function in this patch, but until 
SOCK_SEQPACKET is not supported, I would check only SOCK_STREAM and add 
SOCK_SEQPACKET only when you add 'vsock_seqpacket_ops' later.

> static void __vsock_release(struct sock *sk, int level)
> {
> 	if (sk) {
>@@ -785,7 +790,7 @@ static void __vsock_release(struct sock *sk, int level)
>
> 		if (vsk->transport)
> 			vsk->transport->release(vsk);
>-		else if (sk->sk_type == SOCK_STREAM)
>+		else if (sock_type_connectible(sk->sk_type))
> 			vsock_remove_sock(vsk);
>
> 		sock_orphan(sk);
>@@ -945,7 +950,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
> 	sk = sock->sk;
> 	if (sock->state == SS_UNCONNECTED) {
> 		err = -ENOTCONN;
>-		if (sk->sk_type == SOCK_STREAM)
>+		if (sock_type_connectible(sk->sk_type))
> 			return err;
> 	} else {
> 		sock->state = SS_DISCONNECTING;
>@@ -960,7 +965,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
> 		sk->sk_state_change(sk);
> 		release_sock(sk);
>
>-		if (sk->sk_type == SOCK_STREAM) {
>+		if (sock_type_connectible(sk->sk_type)) {
> 			sock_reset_flag(sk, SOCK_DONE);
> 			vsock_send_shutdown(sk, mode);
> 		}
>@@ -1013,7 +1018,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 		if (!(sk->sk_shutdown & SEND_SHUTDOWN))
> 			mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
>
>-	} else if (sock->type == SOCK_STREAM) {
>+	} else if (sock_type_connectible(sk->sk_type)) {
> 		const struct vsock_transport *transport = vsk->transport;
> 		lock_sock(sk);
>
>@@ -1259,8 +1264,8 @@ static void vsock_connect_timeout(struct work_struct *work)
> 	sock_put(sk);
> }
>
>-static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
>-				int addr_len, int flags)
>+static int vsock_connect(struct socket *sock, struct sockaddr *addr,
>+			 int addr_len, int flags)
> {
> 	int err;
> 	struct sock *sk;
>@@ -1395,6 +1400,12 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
> 	return err;
> }
>
>+static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
>+				int addr_len, int flags)
>+{
>+	return vsock_connect(sock, addr, addr_len, flags);
>+}
>+

I think you can directly use vsock_connect in 'vsock_stream_ops'.

> static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
> 			bool kern)
> {
>@@ -1410,7 +1421,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
>
> 	lock_sock(listener);
>
>-	if (sock->type != SOCK_STREAM) {
>+	if (!sock_type_connectible(sock->type)) {
> 		err = -EOPNOTSUPP;
> 		goto out;
> 	}
>@@ -1487,7 +1498,7 @@ static int vsock_listen(struct socket *sock, int 
>backlog)
>
> 	lock_sock(sk);
>
>-	if (sock->type != SOCK_STREAM) {
>+	if (!sock_type_connectible(sk->sk_type)) {
> 		err = -EOPNOTSUPP;
> 		goto out;
> 	}
>@@ -1531,11 +1542,11 @@ static void vsock_update_buffer_size(struct vsock_sock *vsk,
> 	vsk->buffer_size = val;
> }
>
>-static int vsock_stream_setsockopt(struct socket *sock,
>-				   int level,
>-				   int optname,
>-				   sockptr_t optval,
>-				   unsigned int optlen)
>+static int vsock_connectible_setsockopt(struct socket *sock,
>+					int level,
>+					int optname,
>+					sockptr_t optval,
>+					unsigned int optlen)
> {
> 	int err;
> 	struct sock *sk;
>@@ -1612,10 +1623,20 @@ static int vsock_stream_setsockopt(struct socket *sock,
> 	return err;
> }
>
>-static int vsock_stream_getsockopt(struct socket *sock,
>-				   int level, int optname,
>-				   char __user *optval,
>-				   int __user *optlen)
>+static int vsock_stream_setsockopt(struct socket *sock,
>+				   int level,
>+				   int optname,
>+				   sockptr_t optval,
>+				   unsigned int optlen)
>+{
>+	return vsock_connectible_setsockopt(sock, level, optname, optval,
>+					    optlen);
>+}

As before, I think you can directly use vsock_connectible_setsockopt in 
'vsock_stream_ops'.

>+
>+static int vsock_connectible_getsockopt(struct socket *sock,
>+					int level, int optname,
>+					char __user *optval,
>+					int __user *optlen)
> {
> 	int err;
> 	int len;
>@@ -1683,8 +1704,17 @@ static int vsock_stream_getsockopt(struct socket *sock,
> 	return 0;
> }
>
>-static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>-				size_t len)
>+static int vsock_stream_getsockopt(struct socket *sock,
>+				   int level, int optname,
>+				   char __user *optval,
>+				   int __user *optlen)
>+{
>+	return vsock_connectible_getsockopt(sock, level, optname, optval,
>+					    optlen);
>+}
>+

Ditto.

>+static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>+				     size_t len)
> {
> 	struct sock *sk;
> 	struct vsock_sock *vsk;
>@@ -1822,10 +1852,16 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
> 	return err;
> }
>
>+static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>+				size_t len)
>+{
>+	return vsock_connectible_sendmsg(sock, msg, len);
>+}
>+

Ditto.

>
> static int
>-vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>-		     int flags)
>+vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>+			  int flags)
> {
> 	struct sock *sk;
> 	struct vsock_sock *vsk;
>@@ -1995,6 +2031,13 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	return err;
> }
>
>+static int
>+vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>+		     int flags)
>+{
>+	return vsock_connectible_recvmsg(sock, msg, len, flags);
>+}
>+

Ditto.

> static const struct proto_ops vsock_stream_ops = {
> 	.family = PF_VSOCK,
> 	.owner = THIS_MODULE,
>-- 
>2.25.1
>


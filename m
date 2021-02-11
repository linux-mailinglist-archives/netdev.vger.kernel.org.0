Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795803188FA
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhBKLDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:03:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231128AbhBKKyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:54:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613040755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c6JIyxLiRHESwY6rJeK+rsmJNAoxnfQJq+AkTGikyDY=;
        b=gKi4hz7cnY6rmBf7RnSpVJLsJQT3TLOW50w6cAZC6rzhYjmc0evEVzXPj88ipov2A7g/aC
        bM1nb/hMYRYwfGgxjGgscxCFL/lS32JIrC8fi5dx0WWzGOZrlq5W3/MYgoWPoN/RU10lZ9
        i0/hKJaOaNFpjwQ8jGDabPUIOnlhqk4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-L5uYiRE5NROxkTm3IePXEA-1; Thu, 11 Feb 2021 05:52:34 -0500
X-MC-Unique: L5uYiRE5NROxkTm3IePXEA-1
Received: by mail-ed1-f71.google.com with SMTP id w23so4396590edr.15
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:52:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c6JIyxLiRHESwY6rJeK+rsmJNAoxnfQJq+AkTGikyDY=;
        b=EMyErvEgrlmfxH6Etz6WC38GwjNbxRMcbOJfGX7mAsEVFgj7JR84hPTysGxCiwgLI1
         /fFopcPgJbhRwCk3dXuxihcHnAW+dGhsunJy2uuBmujhM+9f4QxuTlBfqZplryYv2mPw
         QSb8oZ7BrVBheFuNPoysEfauSToLzg3Dbl6yUJSB4daJaEFVN5w5JFQEP1GC7Gx0uamI
         mkOumX58UT8xFccvmtVnT/nZsQvjCVaxTwVffPJCP5Tl5PjSldC8sFHo7t6DvA+zJiRy
         ssD/gbodV90MmunE3nb2UbqjxSyVljwxdXvINFk4C6iqwACEXUq/ZsCkw8R54VgQdjaw
         DofA==
X-Gm-Message-State: AOAM531M57AY05r/nfHiQfu07v3bD+A7SYTUnSWvXSXnva0opj2Cv+i7
        puJPIFrEZKCBj3PnY+StvM30M9wMyUVq5Q60TJjZ6gdxSkzoQCedc5aGj11H92zbl7rx/Kn75zO
        qIJ6FMUNDayfZk2MU
X-Received: by 2002:a50:b765:: with SMTP id g92mr7847354ede.317.1613040752990;
        Thu, 11 Feb 2021 02:52:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4L+tgVkXdxNZfo4WOdRQsyzuiJJ+oUQSD+Mof1i2r3UcuhRlRZ20qv++UXJ9lCcDs9kLlIA==
X-Received: by 2002:a50:b765:: with SMTP id g92mr7847336ede.317.1613040752718;
        Thu, 11 Feb 2021 02:52:32 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id l12sm3613142edn.83.2021.02.11.02.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:52:32 -0800 (PST)
Date:   Thu, 11 Feb 2021 11:52:29 +0100
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
Subject: Re: [RFC PATCH v4 01/17] af_vsock: update functions for connectible
 socket
Message-ID: <20210211105229.fmdonwqe3swhq6lb@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151426.804348-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151426.804348-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 06:14:23PM +0300, Arseny Krasnov wrote:
>This prepares af_vsock.c for SEQPACKET support: some functions such
>as setsockopt(), getsockopt(), connect(), recvmsg(), sendmsg() are
>shared between both types of sockets, so rename them in general
>manner.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 64 +++++++++++++++++++++-------------------
> 1 file changed, 34 insertions(+), 30 deletions(-)

This patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 6894f21dc147..f4fabec50650 100644
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
>+	return type == SOCK_STREAM;
>+}
>+
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
> 		const struct vsock_transport *transport;
>
> 		lock_sock(sk);
>@@ -1263,8 +1268,8 @@ static void vsock_connect_timeout(struct work_struct *work)
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
>@@ -1414,7 +1419,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
>
> 	lock_sock(listener);
>
>-	if (sock->type != SOCK_STREAM) {
>+	if (!sock_type_connectible(sock->type)) {
> 		err = -EOPNOTSUPP;
> 		goto out;
> 	}
>@@ -1491,7 +1496,7 @@ static int vsock_listen(struct socket *sock, int backlog)
>
> 	lock_sock(sk);
>
>-	if (sock->type != SOCK_STREAM) {
>+	if (!sock_type_connectible(sk->sk_type)) {
> 		err = -EOPNOTSUPP;
> 		goto out;
> 	}
>@@ -1535,11 +1540,11 @@ static void vsock_update_buffer_size(struct vsock_sock *vsk,
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
>@@ -1617,10 +1622,10 @@ static int vsock_stream_setsockopt(struct socket *sock,
> 	return err;
> }
>
>-static int vsock_stream_getsockopt(struct socket *sock,
>-				   int level, int optname,
>-				   char __user *optval,
>-				   int __user *optlen)
>+static int vsock_connectible_getsockopt(struct socket *sock,
>+					int level, int optname,
>+					char __user *optval,
>+					int __user *optlen)
> {
> 	int err;
> 	int len;
>@@ -1688,8 +1693,8 @@ static int vsock_stream_getsockopt(struct socket *sock,
> 	return 0;
> }
>
>-static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>-				size_t len)
>+static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>+				     size_t len)
> {
> 	struct sock *sk;
> 	struct vsock_sock *vsk;
>@@ -1828,10 +1833,9 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
> 	return err;
> }
>
>-
> static int
>-vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>-		     int flags)
>+vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>+			  int flags)
> {
> 	struct sock *sk;
> 	struct vsock_sock *vsk;
>@@ -2007,7 +2011,7 @@ static const struct proto_ops vsock_stream_ops = {
> 	.owner = THIS_MODULE,
> 	.release = vsock_release,
> 	.bind = vsock_bind,
>-	.connect = vsock_stream_connect,
>+	.connect = vsock_connect,
> 	.socketpair = sock_no_socketpair,
> 	.accept = vsock_accept,
> 	.getname = vsock_getname,
>@@ -2015,10 +2019,10 @@ static const struct proto_ops vsock_stream_ops = {
> 	.ioctl = sock_no_ioctl,
> 	.listen = vsock_listen,
> 	.shutdown = vsock_shutdown,
>-	.setsockopt = vsock_stream_setsockopt,
>-	.getsockopt = vsock_stream_getsockopt,
>-	.sendmsg = vsock_stream_sendmsg,
>-	.recvmsg = vsock_stream_recvmsg,
>+	.setsockopt = vsock_connectible_setsockopt,
>+	.getsockopt = vsock_connectible_getsockopt,
>+	.sendmsg = vsock_connectible_sendmsg,
>+	.recvmsg = vsock_connectible_recvmsg,
> 	.mmap = sock_no_mmap,
> 	.sendpage = sock_no_sendpage,
> };
>-- 
>2.25.1
>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8523215CA
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhBVMIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:08:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55298 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230222AbhBVMIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:08:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613995606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zfN32sQUDLnzJ032yBR935SiIXgmWnEZ4V626Ip1AbU=;
        b=EnabMU3zuUU/HiMDZSVlvBXbNZKi9CtVjqxdk4TmgowxzLVHiW4EjqBx+aCxqIibjjNiAk
        pABxB19NpSXmk8X74Kj2xb7O9mtlrP8zQB9CSZNa2YG1/vrQ7FTn2hoYQ1vfKDG15tsW+T
        Pq81pVusQcAgd6s5RywX0YVgPatHuow=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-ALlsbXeENIWxbBIfRKEvcw-1; Mon, 22 Feb 2021 07:06:44 -0500
X-MC-Unique: ALlsbXeENIWxbBIfRKEvcw-1
Received: by mail-wm1-f72.google.com with SMTP id p8so4944249wmq.7
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 04:06:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zfN32sQUDLnzJ032yBR935SiIXgmWnEZ4V626Ip1AbU=;
        b=V2GSCNgrEJLLm1hk43j+PEUmrS86ata8UzhBNrBpKnZ/QlmCcSLHJ4zDQE4qcH1njx
         Rd/WpznHxeCyiOjHOflW1AeKomkZ1CRi38E6p5Nxz3ooeJG+OVSXKWBD7XbSpIXcTKYB
         JUI8XVF7dRKTLtm0wXdIFJMxj60047UmKpoj91s2dKGepgi3dYUCuA9UvCdv9eigAl+V
         rY+0p6uurkxvP5aLBygiSyUHnSXWZB6/uws2m/AxCgdO5HGVwSPA+WcoAldvHAaIz8zE
         /mfjMt0Y81/LotjkVJJz77YpCmj3eKRP9bBqexdXGVnMRQmoMMdCA5KNBaRTKj4zYBlo
         K+aA==
X-Gm-Message-State: AOAM531GLkpcpHx5gvhxFW9VoagQsDkHvs6LLMJB3DUyJNuwJjsiuL2i
        g0Ilj8gEpQL4ozXtAlrLDA/Dl7BUk/KOeGpPtqEDXm59dinquKq3DbnaBGqFT09vUenLrqg6dhw
        ZLoeqWOoz/QRD4Xit
X-Received: by 2002:a05:6000:89:: with SMTP id m9mr12916248wrx.3.1613995601961;
        Mon, 22 Feb 2021 04:06:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBgxVG1+KQe5ktBwrmeS45BwEguQMp9b4SH8ACBZnLC8/aSNiV9xm9pOzkDA3ilfNa94ePDA==
X-Received: by 2002:a05:6000:89:: with SMTP id m9mr12916229wrx.3.1613995601788;
        Mon, 22 Feb 2021 04:06:41 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id h20sm9909617wmb.1.2021.02.22.04.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 04:06:41 -0800 (PST)
Date:   Mon, 22 Feb 2021 13:06:38 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 05/19] af_vsock: separate wait space loop
Message-ID: <20210222120638.ybltjuubfabgk3uz@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053758.1067436-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218053758.1067436-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 08:37:54AM +0300, Arseny Krasnov wrote:
>This moves loop that waits for space on send to separate function,
>because it will be used for SEQ_BEGIN/SEQ_END sending before and
>after data transmission. Waiting for SEQ_BEGIN/SEQ_END is needed
>because such packets carries SEQPACKET header that couldn't be
>fragmented by credit mechanism, so to avoid it, sender waits until
>enough space will be ready.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   |  2 +
> net/vmw_vsock/af_vsock.c | 99 +++++++++++++++++++++++++---------------
> 2 files changed, 63 insertions(+), 38 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 01563338cc03..6fbe88306403 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -205,6 +205,8 @@ void vsock_remove_sock(struct vsock_sock *vsk);
> void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
> int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
> bool vsock_find_cid(unsigned int cid);
>+int vsock_wait_space(struct sock *sk, size_t space, int flags,
>+		     struct vsock_transport_send_notify_data *send_data);
>
> /**** TAP ****/
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index b754927a556a..09b377422b1e 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1692,6 +1692,65 @@ static int vsock_connectible_getsockopt(struct socket *sock,
> 	return 0;
> }
>
>+int vsock_wait_space(struct sock *sk, size_t space, int flags,
>+		     struct vsock_transport_send_notify_data *send_data)
>+{
>+	const struct vsock_transport *transport;
>+	struct vsock_sock *vsk;
>+	long timeout;
>+	int err;
>+
>+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>+
>+	vsk = vsock_sk(sk);
>+	transport = vsk->transport;
>+	timeout = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
>+	err = 0;
>+
>+	add_wait_queue(sk_sleep(sk), &wait);
>+
>+	while (vsock_stream_has_space(vsk) < space &&
>+	       sk->sk_err == 0 &&
>+	       !(sk->sk_shutdown & SEND_SHUTDOWN) &&
>+	       !(vsk->peer_shutdown & RCV_SHUTDOWN)) {
>+
>+		/* Don't wait for non-blocking sockets. */
>+		if (timeout == 0) {
>+			err = -EAGAIN;
>+			goto out_err;
>+		}
>+
>+		if (send_data) {
>+			err = transport->notify_send_pre_block(vsk, send_data);
>+			if (err < 0)
>+				goto out_err;
>+		}
>+
>+		release_sock(sk);
>+		timeout = wait_woken(&wait, TASK_INTERRUPTIBLE, timeout);
>+		lock_sock(sk);
>+		if (signal_pending(current)) {
>+			err = sock_intr_errno(timeout);
>+			goto out_err;
>+		} else if (timeout == 0) {
>+			err = -EAGAIN;
>+			goto out_err;
>+		}
>+	}
>+
>+	if (sk->sk_err) {
>+		err = -sk->sk_err;
>+	} else if ((sk->sk_shutdown & SEND_SHUTDOWN) ||
>+		   (vsk->peer_shutdown & RCV_SHUTDOWN)) {
>+		err = -EPIPE;
>+	}
>+
>+out_err:
>+	remove_wait_queue(sk_sleep(sk), &wait);
>+	return err;
>+}
>+EXPORT_SYMBOL_GPL(vsock_wait_space);
>+
> static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 				     size_t len)
> {
>@@ -1699,10 +1758,8 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 	struct vsock_sock *vsk;
> 	const struct vsock_transport *transport;
> 	ssize_t total_written;
>-	long timeout;
> 	int err;
> 	struct vsock_transport_send_notify_data send_data;
>-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>
> 	sk = sock->sk;
> 	vsk = vsock_sk(sk);
>@@ -1740,9 +1797,6 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 		goto out;
> 	}
>
>-	/* Wait for room in the produce queue to enqueue our user's data. */
>-	timeout = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
>-
> 	err = transport->notify_send_init(vsk, &send_data);
> 	if (err < 0)
> 		goto out;
>@@ -1750,39 +1804,8 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 	while (total_written < len) {
> 		ssize_t written;
>
>-		add_wait_queue(sk_sleep(sk), &wait);
>-		while (vsock_stream_has_space(vsk) == 0 &&
>-		       sk->sk_err == 0 &&
>-		       !(sk->sk_shutdown & SEND_SHUTDOWN) &&
>-		       !(vsk->peer_shutdown & RCV_SHUTDOWN)) {
>-
>-			/* Don't wait for non-blocking sockets. */
>-			if (timeout == 0) {
>-				err = -EAGAIN;
>-				remove_wait_queue(sk_sleep(sk), &wait);
>-				goto out_err;
>-			}
>-
>-			err = transport->notify_send_pre_block(vsk, &send_data);
>-			if (err < 0) {
>-				remove_wait_queue(sk_sleep(sk), &wait);
>-				goto out_err;
>-			}
>-
>-			release_sock(sk);
>-			timeout = wait_woken(&wait, TASK_INTERRUPTIBLE, timeout);
>-			lock_sock(sk);
>-			if (signal_pending(current)) {
>-				err = sock_intr_errno(timeout);
>-				remove_wait_queue(sk_sleep(sk), &wait);
>-				goto out_err;
>-			} else if (timeout == 0) {
>-				err = -EAGAIN;
>-				remove_wait_queue(sk_sleep(sk), &wait);
>-				goto out_err;
>-			}
>-		}
>-		remove_wait_queue(sk_sleep(sk), &wait);
>+		if (vsock_wait_space(sk, 1, msg->msg_flags, &send_data))
>+			goto out_err;
>
> 		/* These checks occur both as part of and after the loop
> 		 * conditional since we need to check before and after
>-- 
>2.25.1
>

The patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


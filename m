Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82146321528
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhBVLbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 06:31:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230189AbhBVLbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 06:31:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613993371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y8uZhtxPnMc3VJgJ7/XsbDI2s/GkB4V6o+tAFFKwv/8=;
        b=KQM7PgCAWhte1gbgsCw6g+PdEfTanAxPUwWPdC/28GdEVK3bSc4aE3fcZCpMMhlCxDO/al
        HhbK0kSdHsJ3nJkgZ74CkduX8cz4xt+Valu3wmXhM1w/M72xTLVWYQPRgnyUlc09dw9iwC
        /CyV5qNIBRnwZkaXi+wM4xVJMFyg7Xs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-iteTRuqTO9yXko-jMPMuKg-1; Mon, 22 Feb 2021 06:29:29 -0500
X-MC-Unique: iteTRuqTO9yXko-jMPMuKg-1
Received: by mail-wr1-f72.google.com with SMTP id s18so5989094wrf.0
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 03:29:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y8uZhtxPnMc3VJgJ7/XsbDI2s/GkB4V6o+tAFFKwv/8=;
        b=O5k1L515BXaJO3RMjM+tnVkzaylZ+EjycdkLouYCit9Ybfb/8ZpTehce1vHMpDiZDp
         Vn0EvIkGHP6ILIyyLAVLr5lVWKdXcjjldEP2YU5KlbyVHIzthdVHxXj9dgwVH8uKU0kD
         KAywnInS/br5XlFboKPSkUs5fKyG1ptfBODd2QwmvZhDM8agjULsWI85nvOKem1D1Rg1
         cPrDPZ6tFBdPPBW1nsrekPdFmidyqQH3z+4MDE9cWeRTSQ3p2lQbz406Np39yfv60zVe
         u5aH+qgQ7weHrWmV3S8eJ9TWX3sQFgVKmqRt5tUrd71lIfSm3iWt4TwCMu8sg+yokNmH
         8XYw==
X-Gm-Message-State: AOAM531aJSlN1aM71G6ZTmXUQ81yd3YkbvRGkniLDjkOnUIG5CP90rlb
        jurk7WbdNr0QE0vapMO++4bLc4CEf0Mliow9T80tiJ1YStzF63F/S8vRMzMmMx8GXL+m/St0pAE
        TJYxgTpdSPExZa+Ai
X-Received: by 2002:a5d:63ce:: with SMTP id c14mr7733611wrw.15.1613993368179;
        Mon, 22 Feb 2021 03:29:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxiJBgeZ62WLQXH1tkB63Xoc8oL1rWkIkvwkAGO6rqCCSIdNxSHGL/0LhoyC56LLS/oG3hmig==
X-Received: by 2002:a5d:63ce:: with SMTP id c14mr7733598wrw.15.1613993367956;
        Mon, 22 Feb 2021 03:29:27 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id m24sm7861270wmc.18.2021.02.22.03.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 03:29:27 -0800 (PST)
Date:   Mon, 22 Feb 2021 12:29:24 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 02/19] af_vsock: separate wait data loop
Message-ID: <20210222112924.hu2sfoiwni5kt5wm@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053637.1066959-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218053637.1066959-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 08:36:33AM +0300, Arseny Krasnov wrote:
>This moves wait loop for data to dedicated function, because later
>it will be used by SEQPACKET data receive loop.

The patch LGTM, maybe just add a line in the commit message with 
something like this:

     While moving the code around, let's update an old comment.

Whit that fixed:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 155 +++++++++++++++++++++------------------
> 1 file changed, 83 insertions(+), 72 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 656370e11707..6cf7bb977aa1 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1832,6 +1832,68 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 	return err;
> }
>
>+static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
>+			   long timeout,
>+			   struct vsock_transport_recv_notify_data *recv_data,
>+			   size_t target)
>+{
>+	const struct vsock_transport *transport;
>+	struct vsock_sock *vsk;
>+	s64 data;
>+	int err;
>+
>+	vsk = vsock_sk(sk);
>+	err = 0;
>+	transport = vsk->transport;
>+	prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
>+
>+	while ((data = vsock_stream_has_data(vsk)) == 0) {
>+		if (sk->sk_err != 0 ||
>+		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>+		    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
>+			break;
>+		}
>+
>+		/* Don't wait for non-blocking sockets. */
>+		if (timeout == 0) {
>+			err = -EAGAIN;
>+			break;
>+		}
>+
>+		if (recv_data) {
>+			err = transport->notify_recv_pre_block(vsk, target, recv_data);
>+			if (err < 0)
>+				break;
>+		}
>+
>+		release_sock(sk);
>+		timeout = schedule_timeout(timeout);
>+		lock_sock(sk);
>+
>+		if (signal_pending(current)) {
>+			err = sock_intr_errno(timeout);
>+			break;
>+		} else if (timeout == 0) {
>+			err = -EAGAIN;
>+			break;
>+		}
>+	}
>+
>+	finish_wait(sk_sleep(sk), wait);
>+
>+	if (err)
>+		return err;
>+
>+	/* Internal transport error when checking for available
>+	 * data. XXX This should be changed to a connection
>+	 * reset in a later change.
>+	 */
>+	if (data < 0)
>+		return -ENOMEM;
>+
>+	return data;
>+}
>+
> static int
> vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 			  int flags)
>@@ -1911,85 +1973,34 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>
>
> 	while (1) {
>-		s64 ready;
>-
>-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
>-		ready = vsock_stream_has_data(vsk);
>-
>-		if (ready == 0) {
>-			if (sk->sk_err != 0 ||
>-			    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>-			    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
>-				finish_wait(sk_sleep(sk), &wait);
>-				break;
>-			}
>-			/* Don't wait for non-blocking sockets. */
>-			if (timeout == 0) {
>-				err = -EAGAIN;
>-				finish_wait(sk_sleep(sk), &wait);
>-				break;
>-			}
>+		ssize_t read;
>
>-			err = transport->notify_recv_pre_block(
>-					vsk, target, &recv_data);
>-			if (err < 0) {
>-				finish_wait(sk_sleep(sk), &wait);
>-				break;
>-			}
>-			release_sock(sk);
>-			timeout = schedule_timeout(timeout);
>-			lock_sock(sk);
>+		err = vsock_wait_data(sk, &wait, timeout, &recv_data, target);
>+		if (err <= 0)
>+			break;
>
>-			if (signal_pending(current)) {
>-				err = sock_intr_errno(timeout);
>-				finish_wait(sk_sleep(sk), &wait);
>-				break;
>-			} else if (timeout == 0) {
>-				err = -EAGAIN;
>-				finish_wait(sk_sleep(sk), &wait);
>-				break;
>-			}
>-		} else {
>-			ssize_t read;
>-
>-			finish_wait(sk_sleep(sk), &wait);
>-
>-			if (ready < 0) {
>-				/* Invalid queue pair content. XXX This should
>-				* be changed to a connection reset in a later
>-				* change.
>-				*/
>-
>-				err = -ENOMEM;
>-				goto out;
>-			}
>-
>-			err = transport->notify_recv_pre_dequeue(
>-					vsk, target, &recv_data);
>-			if (err < 0)
>-				break;
>+		err = transport->notify_recv_pre_dequeue(vsk, target,
>+							 &recv_data);
>+		if (err < 0)
>+			break;
>
>-			read = transport->stream_dequeue(
>-					vsk, msg,
>-					len - copied, flags);
>-			if (read < 0) {
>-				err = -ENOMEM;
>-				break;
>-			}
>+		read = transport->stream_dequeue(vsk, msg, len - copied, flags);
>+		if (read < 0) {
>+			err = -ENOMEM;
>+			break;
>+		}
>
>-			copied += read;
>+		copied += read;
>
>-			err = transport->notify_recv_post_dequeue(
>-					vsk, target, read,
>-					!(flags & MSG_PEEK), &recv_data);
>-			if (err < 0)
>-				goto out;
>+		err = transport->notify_recv_post_dequeue(vsk, target, read,
>+						!(flags & MSG_PEEK), &recv_data);
>+		if (err < 0)
>+			goto out;
>
>-			if (read >= target || flags & MSG_PEEK)
>-				break;
>+		if (read >= target || flags & MSG_PEEK)
>+			break;
>
>-			target -= read;
>-		}
>+		target -= read;
> 	}
>
> 	if (sk->sk_err)
>-- 
>2.25.1
>


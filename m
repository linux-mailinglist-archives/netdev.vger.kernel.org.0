Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89F7348D1C
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 10:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhCYJiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 05:38:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230041AbhCYJho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 05:37:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616665063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tJmprqj60mO2lWaw1IZSUhyFWeosKgCMkgr1erB7bTU=;
        b=GXBYWAB0ykilkHjLW8GyjfcsX3kv6+vBUc7Hz/oJJbgiyFYEKTJU88M0RLNkQBmjv742/7
        ciCrHeGUNJSV8KLB6zdAgC9ONqPKdNp+yWb3ol3hMQwYbJf17dbHKdDbmwCCZcvbZD310Z
        /8vE8WyNTgEMYukZpLCw0fywAzEvKFM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-2ZQZ69TyPymft-emgK-B8Q-1; Thu, 25 Mar 2021 05:37:41 -0400
X-MC-Unique: 2ZQZ69TyPymft-emgK-B8Q-1
Received: by mail-wr1-f71.google.com with SMTP id h5so2371205wrr.17
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 02:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tJmprqj60mO2lWaw1IZSUhyFWeosKgCMkgr1erB7bTU=;
        b=QcvlfudbvkEhiSs44NI3NOAVfWdyutXF+PVCaK0aSr8DpEFkZHelvK9TkhpY+kJcuf
         HMFZoF/niJF1371a7jsKj3A/QFxGiRGrfEFy1lMSZ+HRkObA++nVpoQ4mIV43SXjU/C7
         Rh2qXXNdLTwfETJmM4YM8Y9ka++eOBpnuPMw7+X3jTeq1AhAcra+OgVP5dmHaEripkNC
         W16WmNqh/afwL9DtyQEPYc2eNP+V7leo1Vb2sPLL12fLNVhnKxqyuVSLAGvi2OpG3qAS
         NMrPV98W3+4jyiSG5cUsbMLuyQm0ovElBr8gOVFwFEVFrcdqho8OxMjicN5N9xWUcPUW
         AJKw==
X-Gm-Message-State: AOAM531fMBEsCSYuCtCRB/cTbSJ2ZcugD+MRNr9A8NPGT2bCzpuca2oo
        EzJ9mNa5tUPOeetVYjgOA9Ip5zYo+zI9Eb9s1m70SLnsfQES2i0gZh+biWOBm5/ObGoVloDWeuq
        j0KY4q2b0TPPIVXuU
X-Received: by 2002:a5d:5708:: with SMTP id a8mr6788634wrv.185.1616665060172;
        Thu, 25 Mar 2021 02:37:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwV06+jKR3eGl0aPDByqeGSXW8O7S5acvZEyvhMLUS/1hiKAP9QZVVCu+j26QpWA3McP4CQHw==
X-Received: by 2002:a5d:5708:: with SMTP id a8mr6788616wrv.185.1616665059991;
        Thu, 25 Mar 2021 02:37:39 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id r14sm7036453wrw.91.2021.03.25.02.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 02:37:39 -0700 (PDT)
Date:   Thu, 25 Mar 2021 10:37:36 +0100
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
        Norbert Slusarek <nslusarek@gmx.net>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v7 05/22] af_vsock: separate wait space loop
Message-ID: <20210325093736.h43s47ylrxcjd2qd@steredhat>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131026.2460194-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210323131026.2460194-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 04:10:23PM +0300, Arseny Krasnov wrote:
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

I had already reviewed this one as well and it doesn't seem to have 
changed :-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 74ac8a4c4168..7232f6c42a36 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -204,6 +204,8 @@ void vsock_remove_sock(struct vsock_sock *vsk);
> void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
> int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
> bool vsock_find_cid(unsigned int cid);
>+int vsock_wait_space(struct sock *sk, size_t space, int flags,
>+		     struct vsock_transport_send_notify_data *send_data);
>
> /**** TAP ****/
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index fa0c37f97330..617ffe42693d 100644
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


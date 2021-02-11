Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13678318A49
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhBKMUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:20:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231723AbhBKMPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:15:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613045655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BEPfHOoOC9PkCRSqxehgaNL1z0I7JWFoen0MxY6aOAg=;
        b=LFeEBnVLMu/3B+dvnNslsKAn7ukRH1dKK+BZk23xQ17D5hsAKI1mKpBN3kvO68ch5BbbDB
        Eg+Q6jABLFlCbJSKCTpu2CsiaEGIqJnlH9mrLUaBnN/qQgzZlrpZDSDQ6FkjY423RW+pW6
        7EhWtB/GegrhnjDJrU7WGSE/wrkxl/Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-6Sfd2KJMPOCQG0wErKU30w-1; Thu, 11 Feb 2021 07:14:14 -0500
X-MC-Unique: 6Sfd2KJMPOCQG0wErKU30w-1
Received: by mail-ed1-f71.google.com with SMTP id t9so4534267edd.3
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 04:14:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BEPfHOoOC9PkCRSqxehgaNL1z0I7JWFoen0MxY6aOAg=;
        b=gAqOO8lfLuwnbjDRQoJd2ThNxCeE8qWkdNFBOf9a5h4lc/M7xaoV7A114QwK3xgsO4
         i1lsIE/jXR9e5PcpZ+fhCHixvJxbGNFyvWqlY9ONQQExnwGYqnwWdYdKhh4sJYw2r2/J
         7FKbqv6W3B813JletvIrmRfV0mAjj8+GN7VhUe92ovf8RIIo9pf8mKo9EYhJe4AddmSQ
         i/vS+lG1jG5VFnouhddlmK9BIDz6gYFKNcIE5K2LVeZizISLxTfyrv7WvHiNOCWdVBWh
         l1Ds1i9bRg5Lz9FqVJcU/itUJ/uMBVyYTksrdmYunRkxDgMlmsfi83Slkg5Jiv1lEEOn
         N0dQ==
X-Gm-Message-State: AOAM530SrBZZskPWgEtLlyvnCmxSVdsCe0J7LDvjkn1v6b/PV7Tenx7I
        I+FmGP5FUU37TGD+Je4kKUkFYrcR0ZJUrem++RvSKI/fISbrDZeMVfSnS9AgFNZbNWHzMEPDIxc
        poKZUI9wq7O4N9064
X-Received: by 2002:a17:906:f8d1:: with SMTP id lh17mr2835197ejb.137.1613045652828;
        Thu, 11 Feb 2021 04:14:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7iYGVdrTZpB3saGpCtqnIsFnxkyZjFYwSdh7PVWVc2vA1axIrKedjuzKd7ebEYxovREQ/0w==
X-Received: by 2002:a17:906:f8d1:: with SMTP id lh17mr2835178ejb.137.1613045652627;
        Thu, 11 Feb 2021 04:14:12 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id t23sm4115198ejs.4.2021.02.11.04.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:14:12 -0800 (PST)
Date:   Thu, 11 Feb 2021 13:14:09 +0100
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
Subject: Re: [RFC PATCH v4 05/17] af_vsock: separate wait space loop
Message-ID: <20210211121409.y3yo3zzvm24rhmry@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151545.804889-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151545.804889-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 06:15:41PM +0300, Arseny Krasnov wrote:
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
> net/vmw_vsock/af_vsock.c | 93 ++++++++++++++++++++++++++--------------
> 2 files changed, 62 insertions(+), 33 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index bb6a0e52be86..19f6f22821ec 100644
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
>index 3d8af987216a..ea99261e88ac 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1693,6 +1693,64 @@ static int vsock_connectible_getsockopt(struct socket *sock,
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

Maybe a new line here, like in the original code, would help the 
readability.

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

After removing the wait loop in vsock_connectible_sendmsg(), we should 
remove the 'timeout' variable because it is no longer used.

>@@ -1751,39 +1809,8 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
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


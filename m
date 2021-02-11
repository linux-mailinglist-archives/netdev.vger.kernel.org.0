Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB073189B2
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhBKLmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:42:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231128AbhBKLjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:39:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613043479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jBJpn4LbluSU72a0eU+ANLaBQa/dsUCCbpTQvGN+K1w=;
        b=UL+FuWYpqI8fgpgnsbr8CvDSg/Rbsy5iHR8kmWYvNHzf2QmxIYvi/k7JCHHPzfFrdfbleG
        kUBZQ/GnBb8kYy2XB9uB+zSllAXO0jRisGuz8A3O0uVEhy198+cHyAsBC80GQ+r2ZtvkzT
        OH1AZOqRhCmCxEu9QD07tI1n8fEkH4I=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-_WN7dJ29OnqQ93iK5e8E4Q-1; Thu, 11 Feb 2021 06:37:57 -0500
X-MC-Unique: _WN7dJ29OnqQ93iK5e8E4Q-1
Received: by mail-ej1-f70.google.com with SMTP id by8so4700302ejc.1
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 03:37:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jBJpn4LbluSU72a0eU+ANLaBQa/dsUCCbpTQvGN+K1w=;
        b=sRL2TkkIgwO1+FskqPeGOP3lcXJtfxuzcPAeeCZ1KqJgABBlllMjEDw6yg20fjI6RL
         S49X4Lv0ILs0hjoa7YHpLH01z4y8AnnfF0OEDZKk5KHR8JaPdMmdnDPY5whVbWNCU1nx
         x6Y05TYFEKRtL0uHgowhJl6zpdLYVE1Qrqtny2EZPmltvaO1ENp2Tcuxg76xM4JF1CpQ
         DkSIyvqccmJ2cZd3G6N8L6FnBSRp0a/uLuJu6bnWscKIZeoX5yak6SzuvR1Zr+AZ1qG6
         0CND8rQVorOqJwQSgXl2gsJ9dVZJhvXpMPNj0iqXPnn8UtiKAHeRPsT4wXh6G+aDVvYQ
         AQnA==
X-Gm-Message-State: AOAM530EhzqlP1jUJc1CYH7od0uaIQFBshuL1solZoUKQaMmaqZa+2ty
        9coY7m8smGBWu/3cEXiv5Q8IR4XbiPjwz2nqrjl/Y79MSDDGS+k09NrSqhyo1ljndEshbCIJYNs
        b9enhtXf0zkMqEsh8
X-Received: by 2002:a17:906:37c1:: with SMTP id o1mr7920790ejc.488.1613043476411;
        Thu, 11 Feb 2021 03:37:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJnUUecMhZKbbTG7xRbeEA9y+GaY0YJsrOqETOe26tn0T3XY70P75PsWnGdEkMaW63FaTK2w==
X-Received: by 2002:a17:906:37c1:: with SMTP id o1mr7920773ejc.488.1613043476196;
        Thu, 11 Feb 2021 03:37:56 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id m7sm3982087ejk.52.2021.02.11.03.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 03:37:55 -0800 (PST)
Date:   Thu, 11 Feb 2021 12:37:53 +0100
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
Subject: Re: [RFC PATCH v4 03/17] af_vsock: separate receive data loop
Message-ID: <20210211113753.o4zco3yromuxpvo2@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151508.804615-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151508.804615-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 06:15:05PM +0300, Arseny Krasnov wrote:
>This moves STREAM specific data receive logic to dedicated function:
>'__vsock_stream_recvmsg()', while checks that will be same for both
>types of socket are in shared function: 'vsock_connectible_recvmsg()'.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 117 +++++++++++++++++++++++----------------
> 1 file changed, 68 insertions(+), 49 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 38927695786f..66c8a932f49b 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1898,65 +1898,22 @@ static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
> 	return err;
> }
>
>-static int
>-vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>-			  int flags)
>+static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>+				  size_t len, int flags)
> {
>-	struct sock *sk;
>-	struct vsock_sock *vsk;
>+	struct vsock_transport_recv_notify_data recv_data;
> 	const struct vsock_transport *transport;
>-	int err;
>-	size_t target;
>+	struct vsock_sock *vsk;
> 	ssize_t copied;
>+	size_t target;
> 	long timeout;
>-	struct vsock_transport_recv_notify_data recv_data;
>+	int err;
>
> 	DEFINE_WAIT(wait);
>
>-	sk = sock->sk;
> 	vsk = vsock_sk(sk);
>-	err = 0;
>-
>-	lock_sock(sk);
>-
> 	transport = vsk->transport;
>
>-	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
>-		/* Recvmsg is supposed to return 0 if a peer performs an
>-		 * orderly shutdown. Differentiate between that case and when a
>-		 * peer has not connected or a local shutdown occured with the
>-		 * SOCK_DONE flag.
>-		 */
>-		if (sock_flag(sk, SOCK_DONE))
>-			err = 0;
>-		else
>-			err = -ENOTCONN;
>-
>-		goto out;
>-	}
>-
>-	if (flags & MSG_OOB) {
>-		err = -EOPNOTSUPP;
>-		goto out;
>-	}
>-
>-	/* We don't check peer_shutdown flag here since peer may actually shut
>-	 * down, but there can be data in the queue that a local socket can
>-	 * receive.
>-	 */
>-	if (sk->sk_shutdown & RCV_SHUTDOWN) {
>-		err = 0;
>-		goto out;
>-	}
>-
>-	/* It is valid on Linux to pass in a zero-length receive buffer.  This
>-	 * is not an error.  We may as well bail out now.
>-	 */
>-	if (!len) {
>-		err = 0;
>-		goto out;
>-	}
>-
> 	/* We must not copy less than target bytes into the user's buffer
> 	 * before returning successfully, so we wait for the consume queue to
> 	 * have that much data to consume before dequeueing.  Note that this

At the end of __vsock_stream_recvmsg() you are calling release_sock(sk) 
and it's wrong since we are releasing it in vsock_connectible_recvmsg().

Please fix it.

>@@ -2020,6 +1977,68 @@ vsock_connectible_recvmsg(struct socket *sock, 
>struct msghdr *msg, size_t len,
> 	return err;
> }
>
>+static int
>+vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>+			  int flags)
>+{
>+	struct sock *sk;
>+	struct vsock_sock *vsk;
>+	const struct vsock_transport *transport;
>+	int err;
>+
>+	DEFINE_WAIT(wait);
>+
>+	sk = sock->sk;
>+	vsk = vsock_sk(sk);
>+	err = 0;
>+
>+	lock_sock(sk);
>+
>+	transport = vsk->transport;
>+
>+	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
>+		/* Recvmsg is supposed to return 0 if a peer performs an
>+		 * orderly shutdown. Differentiate between that case and when a
>+		 * peer has not connected or a local shutdown occurred with the
>+		 * SOCK_DONE flag.
>+		 */
>+		if (sock_flag(sk, SOCK_DONE))
>+			err = 0;
>+		else
>+			err = -ENOTCONN;
>+
>+		goto out;
>+	}
>+
>+	if (flags & MSG_OOB) {
>+		err = -EOPNOTSUPP;
>+		goto out;
>+	}
>+
>+	/* We don't check peer_shutdown flag here since peer may actually shut
>+	 * down, but there can be data in the queue that a local socket can
>+	 * receive.
>+	 */
>+	if (sk->sk_shutdown & RCV_SHUTDOWN) {
>+		err = 0;
>+		goto out;
>+	}
>+
>+	/* It is valid on Linux to pass in a zero-length receive buffer.  This
>+	 * is not an error.  We may as well bail out now.
>+	 */
>+	if (!len) {
>+		err = 0;
>+		goto out;
>+	}
>+
>+	err = __vsock_stream_recvmsg(sk, msg, len, flags);
>+
>+out:
>+	release_sock(sk);
>+	return err;
>+}
>+

The rest of the patch LGTM.

Stefano


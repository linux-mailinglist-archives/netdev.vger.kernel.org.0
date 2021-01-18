Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9A82FA3EE
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405193AbhARPBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:01:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55427 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405240AbhAROxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:53:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610981525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bvHYXveaY1fYHKCh/4G0s4Eb72E980+xC2zhbE72Tuc=;
        b=Eo7xIaWrpBf4arroqUcI24j4LTPNU470Qtd4KJcelOMnpIpOa6vApPlpjayRStsnNw9SZ6
        bxc1etsJ5UBFW0+dRG11z6Zo9zTL7Sbdhu5hLTOkpjU3vIJK/TU94VRED+Mj6/XyDp2pmx
        TbqFE/j8MuWUt7V19iGaqALXTZqvLR0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-PNfQfeByOpmMxxxU1K9vBg-1; Mon, 18 Jan 2021 09:52:03 -0500
X-MC-Unique: PNfQfeByOpmMxxxU1K9vBg-1
Received: by mail-wm1-f72.google.com with SMTP id 14so2062831wmo.8
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 06:52:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bvHYXveaY1fYHKCh/4G0s4Eb72E980+xC2zhbE72Tuc=;
        b=QyGZfbD+WBybrpBJ0KOhG5iy4rNCQBoxjQovM6dz8aOsrrAokZXZjNCISTl4DMf8q1
         D6Xvna7sobn8/mgA9CzGO8ClMZ9XOC5U83Tv9vrg1yfg04AzXeIrThQX/o85DqxAEN4M
         +p/8aXksfTd1+QMoPUmSMx3mXhgumXO2+Z2GXSA3Sk0Rz31857GUHH1yMq9LKYd0fIUW
         tWOkNc6Rq7myH5FsGfn7VJsO4v+AcYsuWERWzQBy5sWgtFAb9CFLFqezqe+QXWntCLyo
         K5AQfvYaCY40GChj+KmDjXizzTmQuww7FJWCuhv9k6qri6pl+9OKaq9t84ZdeEKPKc3F
         M74g==
X-Gm-Message-State: AOAM533XKUpqeIfRB1wZ2i0mpmkGFM2h1ms/AtYHXxAUVCs3iUs6YvKs
        rjS6akKGpc0iM9jlCeHKXljvlY5TZolt1eCnNKJ/ESt8zN5hyeBY3fTa6A7e2ShCjj1W9dYljwz
        gH63RwYZhrIeYk/zq
X-Received: by 2002:a5d:42d0:: with SMTP id t16mr26110654wrr.230.1610981522395;
        Mon, 18 Jan 2021 06:52:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyLYqyNMVyFEoAlbSpKAd9WKw+ODMCj85rmyuhMgWAf133vbbFpPK94WXLLheaXzynpxdDRUg==
X-Received: by 2002:a5d:42d0:: with SMTP id t16mr26110629wrr.230.1610981522214;
        Mon, 18 Jan 2021 06:52:02 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id x25sm1728972wmk.20.2021.01.18.06.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 06:52:01 -0800 (PST)
Date:   Mon, 18 Jan 2021 15:51:58 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 01/13] af_vsock: implement 'vsock_wait_data()'.
Message-ID: <20210118145158.ufakay5mbezjex4v@steredhat>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
 <20210115054028.1455574-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210115054028.1455574-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 08:40:25AM +0300, Arseny Krasnov wrote:
>This adds 'vsock_wait_data()' function which is called from user's read
>syscall and waits until new socket data is arrived. It was based on code
>from stream dequeue logic and moved to separate function because it will
>be called both from SOCK_STREAM and SOCK_SEQPACKET receive loops.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 47 ++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 47 insertions(+)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index b12d3a322242..af716f5a93a4 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1822,6 +1822,53 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
> 	return err;
> }
>
>+static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
>+			   long timeout,
>+			   struct vsock_transport_recv_notify_data *recv_data,
>+			   size_t target)
>+{
>+	int err = 0;
>+	struct vsock_sock *vsk;
>+	const struct vsock_transport *transport;

Please be sure that here and in all of the next patches, you follow the 
"Reverse Christmas tree" rule followed in net/ for the local variable 
declarations (order variable declaration lines longest to shortest).

>+
>+	vsk = vsock_sk(sk);
>+	transport = vsk->transport;
>+
>+	if (sk->sk_err != 0 ||
>+	    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>+	    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
>+		finish_wait(sk_sleep(sk), wait);
>+		return -1;
>+	}
>+	/* Don't wait for non-blocking sockets. */
>+	if (timeout == 0) {
>+		err = -EAGAIN;
>+		finish_wait(sk_sleep(sk), wait);
>+		return err;
>+	}
>+
>+	if (recv_data) {
>+		err = transport->notify_recv_pre_block(vsk, target, recv_data);
>+		if (err < 0) {
>+			finish_wait(sk_sleep(sk), wait);
>+			return err;
>+		}
>+	}
>+
>+	release_sock(sk);
>+	timeout = schedule_timeout(timeout);
>+	lock_sock(sk);
>+
>+	if (signal_pending(current)) {
>+		err = sock_intr_errno(timeout);
>+		finish_wait(sk_sleep(sk), wait);
>+	} else if (timeout == 0) {
>+		err = -EAGAIN;
>+		finish_wait(sk_sleep(sk), wait);
>+	}
>+

Since we are calling finish_wait() before return in all path, why not 
doing somethig like this:

out:
	finish_wait(sk_sleep(sk), wait);
>+	return err;
>+}

Then in the error paths you can do:

	err = XXX;
	goto out;

Thanks,
Stefano

>
> static int
> vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>-- 
>2.25.1
>


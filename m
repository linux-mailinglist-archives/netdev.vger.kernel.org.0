Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B392437F6DF
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhEMLio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:38:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233434AbhEMLib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:38:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620905841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DRqqB24gd3+ASWzztdWzuQdssCUOQLMyXNWzP2IKOvI=;
        b=f8nQTkgGhY/9JzOk54oqDflxIQvkWzzadgp+SnHm3p6hEuWPlbjnkWrGAVqRs9bX6UC5in
        ZInJ2Fs9PE2nbUfbDLKfNtaRw6ZmP4ZB+6Ps4+tIXv7L8T2UmumEO8BMyn4c3sCIF8LKQo
        Y9MSGHYaE51ilRob1OjFRiw65N0TpvE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-dQ6VEcHbODGqNBArcaEfMg-1; Thu, 13 May 2021 07:37:20 -0400
X-MC-Unique: dQ6VEcHbODGqNBArcaEfMg-1
Received: by mail-ed1-f72.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so14469972edd.2
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 04:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DRqqB24gd3+ASWzztdWzuQdssCUOQLMyXNWzP2IKOvI=;
        b=oK2J6q0nj8zSES4HJmOM7R9MYHND6e07SlEObHThIK+Gfv17GeOpu543sImT4V0O1m
         dztQR9hkUPCvlNR3YYwsruHSo/klgYOR4HduDz5kLtwyzKcm1a7XmFYjBvdZdttb09Nk
         S2byQplUZ9lfA6xaUcOmS8BCCEcLsVWyQqnMME0GbJkUdc4/1tOD6ao8gy3mvUl9f7w+
         AyATqdGrjHqd3buvLxB2LWE2s0wysstNWJBvxVaectl9rNCWaGRwVEHnzJYAJYWHByit
         HS1lFHRQ94kVHxqbQlHWHKWKt1yF0mE1/c8WqM081ulEV4HCJalXJXN/xflz1CWDVWqY
         S9qg==
X-Gm-Message-State: AOAM531a5cQLJQsqWZh/EYvvDlku1uMMgYyziOrsTPd5oqYp4eTi1aZa
        lyRY2VMmk0uAs1Rh0JdUriK3ixY4M/9LCl38mjS35AJ3q+tcZ9VFq3Tva42NmzX02guis3OZ7Zv
        nopnoWcjR6B9D82mj
X-Received: by 2002:a50:fe04:: with SMTP id f4mr49468080edt.29.1620905838869;
        Thu, 13 May 2021 04:37:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYBoisjvioqkuhbDl1f4o8CnFYjX/SVd3LzRyycgeuzueUgqsjX7RgKTJKNT4gk8J0jiNIaw==
X-Received: by 2002:a50:fe04:: with SMTP id f4mr49468059edt.29.1620905838697;
        Thu, 13 May 2021 04:37:18 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id cf10sm2158332edb.21.2021.05.13.04.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:37:18 -0700 (PDT)
Date:   Thu, 13 May 2021 13:37:16 +0200
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
Subject: Re: [RFC PATCH v9 04/19] af_vsock: implement SEQPACKET receive loop
Message-ID: <20210513113716.admtjzo5nt2y63qi@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163317.3431119-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163317.3431119-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 07:33:14PM +0300, Arseny Krasnov wrote:
>This adds receive loop for SEQPACKET. It looks like receive loop for
>STREAM, but there is a little bit difference:
>1) It doesn't call notify callbacks.
>2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
>   there is no sense for these values in SEQPACKET case.
>3) It waits until whole record is received or error is found during
>   receiving.
>4) It processes and sets 'MSG_TRUNC' flag.
>
>So to avoid extra conditions for two types of socket inside one loop, two
>independent functions were created.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v8 -> v9:
> 1) 'tmp_record_len' renamed to 'fragment_len'.
> 2) MSG_TRUNC handled in af_vsock.c instead of transport.
> 3) 'flags' still passed to transport for MSG_PEEK support.

Ah, right I see, sorry for the wrong suggestion to remove it.

>
> include/net/af_vsock.h   |  4 +++
> net/vmw_vsock/af_vsock.c | 72 +++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 75 insertions(+), 1 deletion(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index b1c717286993..5175f5a52ce1 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -135,6 +135,10 @@ struct vsock_transport {
> 	bool (*stream_is_active)(struct vsock_sock *);
> 	bool (*stream_allow)(u32 cid, u32 port);
>
>+	/* SEQ_PACKET. */
>+	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>+				     int flags, bool *msg_ready);
>+
> 	/* Notification. */
> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index c4f6bfa1e381..78b9af545ca8 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1974,6 +1974,73 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
> 	return err;
> }
>
>+static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>+				     size_t len, int flags)
>+{
>+	const struct vsock_transport *transport;
>+	bool msg_ready;
>+	struct vsock_sock *vsk;
>+	ssize_t record_len;
>+	long timeout;
>+	int err = 0;
>+	DEFINE_WAIT(wait);
>+
>+	vsk = vsock_sk(sk);
>+	transport = vsk->transport;
>+
>+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>+	msg_ready = false;
>+	record_len = 0;
>+
>+	while (1) {
>+		ssize_t fragment_len;
>+
>+		if (vsock_wait_data(sk, &wait, timeout, NULL, 0) <= 0) {
>+			/* In case of any loop break(timeout, signal
>+			 * interrupt or shutdown), we report user that
>+			 * nothing was copied.
>+			 */
>+			err = 0;
>+			break;
>+		}
>+
>+		fragment_len = transport->seqpacket_dequeue(vsk, msg, flags, &msg_ready);
>+

So, IIUC, seqpacket_dequeue() must return the real length,
and not the bytes copied, right?

I'm not sure virtio_transport_seqpacket_do_dequeue() is doing that.
I'll post a comment on that patch.

>+		if (fragment_len < 0) {
>+			err = -ENOMEM;
>+			break;
>+		}
>+
>+		record_len += fragment_len;
>+
>+		if (msg_ready)
>+			break;
>+	}
>+
>+	if (sk->sk_err)
>+		err = -sk->sk_err;
>+	else if (sk->sk_shutdown & RCV_SHUTDOWN)
>+		err = 0;
>+
>+	if (msg_ready && err == 0) {
>+		/* User sets MSG_TRUNC, so return real length of
>+		 * packet.
>+		 */
>+		if (flags & MSG_TRUNC)
>+			err = record_len;
>+		else
>+			err = len - msg->msg_iter.count;

I think is better to use msg_data_left(msg) instead of accessing fields.

>+
>+		/* Always set MSG_TRUNC if real length of packet is
>+		 * bigger than user's buffer.
>+		 */
>+		if (record_len > len)
>+			msg->msg_flags |= MSG_TRUNC;
>+	}
>+
>+	return err;
>+}
>+
> static int
> vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 			  int flags)
>@@ -2029,7 +2096,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 		goto out;
> 	}
>
>-	err = __vsock_stream_recvmsg(sk, msg, len, flags);
>+	if (sk->sk_type == SOCK_STREAM)
>+		err = __vsock_stream_recvmsg(sk, msg, len, flags);
>+	else
>+		err = __vsock_seqpacket_recvmsg(sk, msg, len, flags);
>
> out:
> 	release_sock(sk);
>-- 
>2.25.1
>


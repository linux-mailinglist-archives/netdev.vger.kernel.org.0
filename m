Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632C33189D9
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhBKLvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:51:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231355AbhBKLtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:49:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613044075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=622PK+GXq9S1qrkes0QjDaGHdMGIQhnkDb8cr2jJCIE=;
        b=b15nW0YPkZq4X1/AZ2v8FBI1TVF7uZJZeVT6ZqvfcakqE1w2ekT9dganCpOSFXi5en5JX4
        PQeKg+jKiqsrW0RAgaoXD8XRsYJznhb9XrlMAgGunzQJFoTPD3QfgwP3qnHxUEyaDDI50+
        FCrN+pUGPjI8BTg/mhZeysK6LvNp+qQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-a2H87cosMIWoLAOvUunkMw-1; Thu, 11 Feb 2021 06:47:53 -0500
X-MC-Unique: a2H87cosMIWoLAOvUunkMw-1
Received: by mail-ej1-f69.google.com with SMTP id ia14so4634189ejc.8
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 03:47:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=622PK+GXq9S1qrkes0QjDaGHdMGIQhnkDb8cr2jJCIE=;
        b=b2uHTcQg4oOUlI6Wl7Ywhbvt1BqvUgsrwuJpJl2jqArzhmQ46vIWSBKlOs4KGX7Flr
         O5HthWgWKR14YiAw2hXaK7tr1oDsY2iWsmMfePGnv2nRByw4VIJbNOg9C0XbzEVMfceZ
         U/vzR2L9LHdk5S8fOlFnem93LiWy5hRzKQrTsSznUGUBKYhtgxAA76pquDENV4DWbq7x
         rcAvmnaEfarsTP90b+flHWBJj48pvjI4NfZ8ctihpAsRyeUEMQgO1NXyvu3rMVqR68Uo
         qSCus4OOqhcaZa0Hi5ostB5RBtX2gFl+dtSRrUdzQ/DbT2FIrETY+S7o/Nk7F9MUfGXq
         7mlg==
X-Gm-Message-State: AOAM532px0ITJfgTJEJ9WBB49p34eucKPZqXTOdAIwlo5lo6KLahddnf
        DHqHoNlzeA4Y9ElouTmgfTmNQ7ryaitqhSebj1AbyCKPp//XqK54FxjuUfesWc0psoszMfc+e86
        dwjXoGurGwKl5Cs2X
X-Received: by 2002:a17:906:6087:: with SMTP id t7mr8301145ejj.90.1613044071889;
        Thu, 11 Feb 2021 03:47:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzj6t5agYEkOXzy2VYeZHkZnED6Gv95JyBHm5LY8BHXS5lTBekja2hs7Ao+RNUkHsDuAOb8sg==
X-Received: by 2002:a17:906:6087:: with SMTP id t7mr8301133ejj.90.1613044071704;
        Thu, 11 Feb 2021 03:47:51 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id x17sm1593873edq.42.2021.02.11.03.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 03:47:51 -0800 (PST)
Date:   Thu, 11 Feb 2021 12:47:48 +0100
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
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 04/17] af_vsock: implement SEQPACKET receive loop
Message-ID: <20210211114748.jshxyiecqmbwzmv3@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151526.804741-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151526.804741-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 06:15:22PM +0300, Arseny Krasnov wrote:
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
> include/net/af_vsock.h   |  5 +++
> net/vmw_vsock/af_vsock.c | 96 +++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 100 insertions(+), 1 deletion(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index b1c717286993..bb6a0e52be86 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -135,6 +135,11 @@ struct vsock_transport {
> 	bool (*stream_is_active)(struct vsock_sock *);
> 	bool (*stream_allow)(u32 cid, u32 port);
>
>+	/* SEQ_PACKET. */
>+	size_t (*seqpacket_seq_get_len)(struct vsock_sock *);
>+	int (*seqpacket_dequeue)(struct vsock_sock *, struct msghdr *,
>+				     int flags, bool *msg_ready);

CHECK: Alignment should match open parenthesis
#35: FILE: include/net/af_vsock.h:141:
+	int (*seqpacket_dequeue)(struct vsock_sock *, struct msghdr *,
+				     int flags, bool *msg_ready);

And to make checkpatch.pl happy please use the identifier name also for 
the others parameter. I know we haven't done this before, but for new 
code I think we can do it.

>+
> 	/* Notification. */
> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 66c8a932f49b..3d8af987216a 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1977,6 +1977,97 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
> 	return err;
> }
>
>+static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>+				     size_t len, int flags)
>+{
>+	const struct vsock_transport *transport;
>+	const struct iovec *orig_iov;
>+	unsigned long orig_nr_segs;
>+	bool msg_ready;
>+	struct vsock_sock *vsk;
>+	size_t record_len;
>+	long timeout;
>+	int err = 0;
>+	DEFINE_WAIT(wait);
>+
>+	vsk = vsock_sk(sk);
>+	transport = vsk->transport;
>+
>+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>+	orig_nr_segs = msg->msg_iter.nr_segs;
>+	orig_iov = msg->msg_iter.iov;
>+	msg_ready = false;
>+	record_len = 0;
>+
>+	while (1) {
>+		err = vsock_wait_data(sk, &wait, timeout, NULL, 0);
>+
>+		if (err <= 0) {
>+			/* In case of any loop break(timeout, signal
>+			 * interrupt or shutdown), we report user that
>+			 * nothing was copied.
>+			 */
>+			err = 0;
>+			break;
>+		}
>+
>+		if (record_len == 0) {
>+			record_len =
>+				transport->seqpacket_seq_get_len(vsk);
>+
>+			if (record_len == 0)
>+				continue;
>+		}
>+
>+		err = transport->seqpacket_dequeue(vsk, msg,
>+					flags, &msg_ready);

A single line here should be okay.

>+		if (err < 0) {
>+			if (err == -EAGAIN) {
>+				iov_iter_init(&msg->msg_iter, READ,
>+					      orig_iov, orig_nr_segs,
>+					      len);
>+				/* Clear 'MSG_EOR' here, because dequeue
>+				 * callback above set it again if it was
>+				 * set by sender. This 'MSG_EOR' is from
>+				 * dropped record.
>+				 */
>+				msg->msg_flags &= ~MSG_EOR;
>+				record_len = 0;
>+				continue;
>+			}
>+
>+			err = -ENOMEM;
>+			break;
>+		}
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
>+	if (msg_ready) {
>+		/* User sets MSG_TRUNC, so return real length of
>+		 * packet.
>+		 */
>+		if (flags & MSG_TRUNC)
>+			err = record_len;
>+		else
>+			err = len - msg->msg_iter.count;
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
>@@ -2032,7 +2123,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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

The rest seems ok to me, but I need to get more familiar with SEQPACKET 
before giving my R-b.

Thanks,
Stefano


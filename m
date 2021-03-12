Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A32339100
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhCLPSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:18:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231786AbhCLPRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:17:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615562274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fcdXIBkMUbEAmnKNGjfKXpW1RdG7ljI/r3++0m/WhAc=;
        b=JC6E5YAwybfisueglRFOXalXyyOVPX9rS1QIZbjIo9SCT3btWEljmNflhkI/d9b+D6rAK5
        S5TfB8eXw4RNFP76NgoDugClcW0XVKv4ARUsHaiBB9UqC5ii9kj1CbL75ug0745T0g/7La
        eJKLEAWZive3T0jSR7hPh+R6ZYwz84U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-rfcpTljtNt62rsKx7_bmig-1; Fri, 12 Mar 2021 10:17:52 -0500
X-MC-Unique: rfcpTljtNt62rsKx7_bmig-1
Received: by mail-wm1-f69.google.com with SMTP id c7so5474369wml.8
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 07:17:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fcdXIBkMUbEAmnKNGjfKXpW1RdG7ljI/r3++0m/WhAc=;
        b=h2EOi8f1p/hKLFUfHrj9MVThu2yK7p4a5BteUAUDlnz0WF+OXwVSWuRw+l1mf7hpFI
         QFr8IZSfAvG8GJBCq+T4iyeRuScoeCcWYYAqr1dB7JuB5oZw95Rsr5yC/T5WQRmRGJxr
         1IVa61azZsPYLWdZoHgLGsWUgSkgyv8eF8YaWrFxASUn0VxZR8d8DO+ripPp/w3uXx9g
         3p2xblp69n8Fh7DJQcqVfEqJwMT6uk0LVR1RsfAod0fY8P6YXbj4i6khw0IN05Fw3xnX
         jHnRRLzdFCDpJNt1Icqtnd1YpiKHOqhfB5+7fha8z1N7sms3SRV7fxXt7A85UM8/yHXc
         0S+w==
X-Gm-Message-State: AOAM531Eq7Fsyc70074uudjH/hClqOYGKrfUafRF95KM7Ae/csE/ghCN
        7MFGhN/f0bScs99tKhXyidCVFYqtW+8yDek42bHEscQlhynHqvmyatZvpmA/JACFN13577zk2uN
        mk9TQeiTGsEwlXhoj
X-Received: by 2002:adf:d1ce:: with SMTP id b14mr14461780wrd.126.1615562270439;
        Fri, 12 Mar 2021 07:17:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzAMx11Ovd8zZCAJGG/0+ZaRgtZy/TRxsnI0ZPXiYL7ISzBWl3fOdUyeVOdPptrSBVoQa1AVA==
X-Received: by 2002:adf:d1ce:: with SMTP id b14mr14461752wrd.126.1615562270269;
        Fri, 12 Mar 2021 07:17:50 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id k4sm10606172wrd.9.2021.03.12.07.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:17:49 -0800 (PST)
Date:   Fri, 12 Mar 2021 16:17:47 +0100
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
Subject: Re: [RFC PATCH v6 04/22] af_vsock: implement SEQPACKET receive loop
Message-ID: <20210312151747.quk37sezpcwwq4id@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307175948.3464885-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307175948.3464885-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 08:59:45PM +0300, Arseny Krasnov wrote:
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
> net/vmw_vsock/af_vsock.c | 95 +++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 99 insertions(+), 1 deletion(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index b1c717286993..5ad7ee7f78fd 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -135,6 +135,11 @@ struct vsock_transport {
> 	bool (*stream_is_active)(struct vsock_sock *);
> 	bool (*stream_allow)(u32 cid, u32 port);
>
>+	/* SEQ_PACKET. */
>+	size_t (*seqpacket_seq_get_len)(struct vsock_sock *vsk);
>+	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>+				 int flags, bool *msg_ready);
>+
> 	/* Notification. */
> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 0bc661e54262..ac2f69362f2e 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1973,6 +1973,96 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
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
>+		err = transport->seqpacket_dequeue(vsk, msg, flags, &msg_ready);

In order to simplify the transport interface, can we do the work of 
seqpacket_seq_get_len() at the beginning of seqpacket_dequeue()?

So in this way seqpacket_dequeue() can return the 'record_len' or an 
error.


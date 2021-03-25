Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEEB348D0A
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 10:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhCYJe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 05:34:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229651AbhCYJeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 05:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616664862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nRf7NxGYGZiHnx9JPcY1YBSuqFXsi8pdHWs1zzP6w98=;
        b=Sr32jQJOH11EsGmQif/fT0k5E1KNPMSqMZzvPkOguogN/aGuuXm/R+lC5Ln9WGMqNA2U9k
        MmTl0LULMQw3jB/mxRnjAkiUJAhYSfPkt+OK8ZmuEk4+xNxwyj/DKnmXdSiprJmG6N3JkV
        UPpgGEFi/AaTCKRA21timFojTMpsiwg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-tt5n1iLhNAScTwjakL1CWA-1; Thu, 25 Mar 2021 05:34:20 -0400
X-MC-Unique: tt5n1iLhNAScTwjakL1CWA-1
Received: by mail-wr1-f69.google.com with SMTP id m13so1091876wri.16
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 02:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nRf7NxGYGZiHnx9JPcY1YBSuqFXsi8pdHWs1zzP6w98=;
        b=foyDx8ocaNTqrWQelCptE3UI/bAtSfHZFCVlbp66J9pi3P1DWhXveVy3D+dt13iaAh
         JOb3MqGl3rA+A996wJyu+XbR8XAio/N9KtczY93vF/9a8GlQofP4x2CNiYZZKlytvqKL
         b1V+zX8Em8O+YJ1JZ9BaOkHeMetnmM+Z26mUKIs/ZUV1J1/m2cFKVXePlX/AHLqnpKPK
         MdE6VHzOMcVKm/3vSsKgj3H5cQRpd1+wtR1e42zmTBaxI9KGktsixIVokuv9dnf9QIEd
         VK8ggGIqrgaNIs4moKllAMnSZ32D0N9/bWRVXxUHRpNT4QH8Ky8A/HDa+PpKJR8trdXB
         nr7g==
X-Gm-Message-State: AOAM530nykYCaeW+Zp2fyUntgNVs8VIwRioUyoCazH6zeiYibosTYKSZ
        7FKoJ04p2vxSMU+nctHP+HUlHf9edc/dWhO+idH6X/KLpLTS4hJZ2cwaM23k4PuB5FOopY6sEzk
        Xp2GMvVEExssA3+vB
X-Received: by 2002:a5d:6c67:: with SMTP id r7mr7831860wrz.373.1616664858979;
        Thu, 25 Mar 2021 02:34:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwp7FkesHjnWfGl/YQCfTcHUdEisO/iTjMVOdjUfjZ9/ssRfZECVX4/rMdG4zKhoEe/0ngIDg==
X-Received: by 2002:a5d:6c67:: with SMTP id r7mr7831840wrz.373.1616664858753;
        Thu, 25 Mar 2021 02:34:18 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id u2sm7165948wmm.5.2021.03.25.02.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 02:34:18 -0700 (PDT)
Date:   Thu, 25 Mar 2021 10:34:15 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v7 04/22] af_vsock: implement SEQPACKET receive loop
Message-ID: <20210325093415.mpysybt5vfnsl7fg@steredhat>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131006.2460058-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210323131006.2460058-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 04:10:03PM +0300, Arseny Krasnov wrote:
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
> v6 -> v7:
> 'seqpacket_get_len' callback now removed, length of message is returned
>  by 'seqpacket_dequeue' callback.
>
> include/net/af_vsock.h   |  4 ++
> net/vmw_vsock/af_vsock.c | 88 +++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 91 insertions(+), 1 deletion(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index b1c717286993..74ac8a4c4168 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -135,6 +135,10 @@ struct vsock_transport {
> 	bool (*stream_is_active)(struct vsock_sock *);
> 	bool (*stream_allow)(u32 cid, u32 port);
>
>+	/* SEQ_PACKET. */
>+	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>+				 int flags, bool *msg_ready, size_t *record_len);
>+

Why not using ssize_t as return value and return the length or a 
negative value in case of error?

In this way we can remove the 'record_len' parameter.

> 	/* Notification. */
> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 0bc661e54262..fa0c37f97330 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1973,6 +1973,89 @@ static int __vsock_stream_recvmsg(struct sock 
>*sk, struct msghdr *msg,
> 	return err;
> }
>
>+static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr 
>*msg,
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
>+		err = transport->seqpacket_dequeue(vsk, msg, flags, &msg_ready, &record_len);
>+
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

If 'err' is not 0, should we skip this branch?

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
>@@ -2028,7 +2111,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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


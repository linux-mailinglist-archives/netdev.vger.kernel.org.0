Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C830307B88
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhA1Q6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:58:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232743AbhA1Q4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:56:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611852927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HgtxAPALtY+nCny47e18Ou0vNrOzLT1OduAQqQAsR8o=;
        b=Vq0jiBu55tUtrNx72EsWNyczKfTng6VZeWp5oo9USlBc0gtjfNBfAbF9LP/69PvuEdUFN0
        y7esIiQ4GVOSJvNfV1mav+EyUGPnPQ6tT8IRbl4SKldyTnqbMpSOcShmx21xILkN5pD66b
        EuCeRV+r9eeGh17BOk6ciUotmeGBDBg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-JVsHzBl_MCO_r6E3of-ffw-1; Thu, 28 Jan 2021 11:55:23 -0500
X-MC-Unique: JVsHzBl_MCO_r6E3of-ffw-1
Received: by mail-wm1-f71.google.com with SMTP id u67so2652427wmg.9
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 08:55:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HgtxAPALtY+nCny47e18Ou0vNrOzLT1OduAQqQAsR8o=;
        b=nJVbLF+ew6cBNno1qqZSZCI9iDdmZ7kwblv3rmGHSGHlOjAoFSGIDDmY4WSQrQ7dOy
         uctpX3uCvxvLfOF8y0fKKp41FCLCirrIcsYbOeLGv+ch+KxBdzet1mRMbOmUVUnxjXTz
         EB4mSZIoe3yibpe6GKhJ8pNi0FOdHXh7QLFr1DtcEg+bNGFaCbxyG1ZX8pdvpR0Q9wge
         hKofWRQEZIp55xOT+4UJUE09ks0ucmDCeomw+aCiB3UcPs2mmYWwHHpJlp1e74Td6BrF
         XQnCXDdsRUb3O/+oFhIzTJpckpXCl00DMhGXI0xYLpI+l+2lt0hc/Gh5nsd+J3P8JC4A
         L0Vw==
X-Gm-Message-State: AOAM532qkJGoxyCTn87biO1hAFHC8JAUpOn/YyHmxuAsGrgtIhu0cTed
        4Qa6RQ4Vk56HYEc8VGU2Di682td0gRGtqSbXfsIOSxLoZkD0ndldzIukrA0SgDefanamHnCYXG5
        yhw58jUrhGZscAMSW
X-Received: by 2002:a1c:a549:: with SMTP id o70mr135304wme.71.1611852922174;
        Thu, 28 Jan 2021 08:55:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyb6UPtRnhkfUKRNkSJfjFxJ3q1MvMrhDM7KtpKfLvcGV1YzLJVQtRahOZNlCd6vpRf46h8cQ==
X-Received: by 2002:a1c:a549:: with SMTP id o70mr135279wme.71.1611852921999;
        Thu, 28 Jan 2021 08:55:21 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id q6sm6320451wmj.32.2021.01.28.08.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 08:55:21 -0800 (PST)
Date:   Thu, 28 Jan 2021 17:55:18 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 03/13] af_vsock: implement SEQPACKET rx loop
Message-ID: <20210128165518.ho3csm5u7v5pnwnd@steredhat>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
 <20210125111239.598377-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210125111239.598377-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 02:12:36PM +0300, Arseny Krasnov wrote:
>This adds receive loop for SEQPACKET. It looks like receive loop for
>SEQPACKET, but there is a little bit difference:
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
> include/net/af_vsock.h   |   5 ++
> net/vmw_vsock/af_vsock.c | 102 ++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 106 insertions(+), 1 deletion(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index b1c717286993..46073842d489 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -135,6 +135,11 @@ struct vsock_transport {
> 	bool (*stream_is_active)(struct vsock_sock *);
> 	bool (*stream_allow)(u32 cid, u32 port);
>
>+	/* SEQ_PACKET. */
>+	size_t (*seqpacket_seq_get_len)(struct vsock_sock *);
>+	ssize_t (*seqpacket_dequeue)(struct vsock_sock *, struct msghdr *,
>+				     size_t len, int flags);
>+
> 	/* Notification. */
> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 524df8fc84cd..3b266880b7c8 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2006,7 +2006,107 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
> static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
> 				     size_t len, int flags)
> {
>-	return -1;
>+	const struct vsock_transport *transport;
>+	const struct iovec *orig_iov;
>+	unsigned long orig_nr_segs;
>+	ssize_t dequeued_total = 0;
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
>+	msg->msg_flags &= ~MSG_EOR;

Maybe add a comment about why we need to clear MSG_EOR.

>+	orig_nr_segs = msg->msg_iter.nr_segs;
>+	orig_iov = msg->msg_iter.iov;
>+
>+	while (1) {
>+		ssize_t dequeued;
>+		s64 ready;
>+
>+		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
>+		ready = vsock_stream_has_data(vsk);
>+
>+		if (ready == 0) {
>+			if (vsock_wait_data(sk, &wait, timeout, NULL, 0)) {
>+				/* In case of any loop break(timeout, signal
>+				 * interrupt or shutdown), we report user that
>+				 * nothing was copied.
>+				 */
>+				dequeued_total = 0;
>+				break;
>+			}
>+			continue;
>+		}
>+
>+		finish_wait(sk_sleep(sk), &wait);
>+
>+		if (ready < 0) {
>+			err = -ENOMEM;
>+			goto out;
>+		}
>+
>+		if (dequeued_total == 0) {
>+			record_len =
>+				transport->seqpacket_seq_get_len(vsk);
>+
>+			if (record_len == 0)
>+				continue;
>+		}
>+
>+		/* 'msg_iter.count' is number of unused bytes in iov.
>+		 * On every copy to iov iterator it is decremented at
>+		 * size of data.
>+		 */
>+		dequeued = transport->seqpacket_dequeue(vsk, msg,
>+					msg->msg_iter.count, flags);
                                         ^
                                         Is this needed or 'msg' can be 
                                         used in the transport?
>+
>+		if (dequeued < 0) {
>+			dequeued_total = 0;
>+
>+			if (dequeued == -EAGAIN) {
>+				iov_iter_init(&msg->msg_iter, READ,
>+					      orig_iov, orig_nr_segs,
>+					      len);
>+				msg->msg_flags &= ~MSG_EOR;
>+				continue;

Why we need to reset MSG_EOR here?

>+			}
>+
>+			err = -ENOMEM;
>+			break;
>+		}
>+
>+		dequeued_total += dequeued;
>+
>+		if (dequeued_total >= record_len)
>+			break;
>+	}

Maybe a new line here.

>+	if (sk->sk_err)
>+		err = -sk->sk_err;
>+	else if (sk->sk_shutdown & RCV_SHUTDOWN)
>+		err = 0;
>+
>+	if (dequeued_total > 0) {
>+		/* User sets MSG_TRUNC, so return real length of
>+		 * packet.
>+		 */
>+		if (flags & MSG_TRUNC)
>+			err = record_len;
>+		else
>+			err = len - msg->msg_iter.count;
>+
>+		/* Always set MSG_TRUNC if real length of packet is
>+		 * bigger that user buffer.

s/that/than

>+		 */
>+		if (record_len > len)
>+			msg->msg_flags |= MSG_TRUNC;
>+	}
>+out:
>+	return err;
> }
>
> static int
>-- 
>2.25.1
>


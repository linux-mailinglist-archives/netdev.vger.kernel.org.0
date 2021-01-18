Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2542FA41D
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405543AbhARPG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:06:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405456AbhARPGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610982281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SLOedUuUAetYBtp0/6k8K8pT2ynnPsFK+R3zYe7flUQ=;
        b=FYoGhr9sXSsrWE7WX7LyS2JAxNkuKCF7tFyDefihAXpMJ+OXeyv12HVPs399vKk5O0OOFL
        ufzSSbgZbyLxmdVXCWv1AL+DPY5Sd6VkHcLJtb6AAOUPbf8bIZpmRntjUCIWZkciQTtOct
        7STJSzBJMmMlWpcGBrbUqy7xJ0gHGQY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-iymZDVtOOj2d4YuTZ87VIA-1; Mon, 18 Jan 2021 10:04:39 -0500
X-MC-Unique: iymZDVtOOj2d4YuTZ87VIA-1
Received: by mail-wr1-f72.google.com with SMTP id v5so8417240wrr.0
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 07:04:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SLOedUuUAetYBtp0/6k8K8pT2ynnPsFK+R3zYe7flUQ=;
        b=aStQarmjFAh6IV108JNq1o2lFfYHC5XXI9IOt6Z36M7jTDYQ41i3Lfimfr2YQSZVmS
         jAwkpOmvsb4jxWy4y3ozYYBiwvrq0rGSuMGwi4X0YzDGuBlRPZha9PWrCDXjShmsNEWo
         KJqYnrs2uqyHvfeRQhtB2Mb+31XdAdR3Vwi8efzrOxqiCHiFqTHShpx9qjjmictmQmOd
         ifLs5DQ8199Rv2WuVeg9s3QdX4KKOub4EXZDLJfKnlwexM41pimjX2me8I8cyghmzWDn
         a2diT0u/8RUInOPjhhxbaiLP7W+iwEGbRxSHRBlFqyn61a9MKux9FNK/YkFr6MZhYwsu
         RESw==
X-Gm-Message-State: AOAM530soUBd0wKP+BL/Eb4VjIMp9WeiMndromZcyb5B/e+FoziA7Hl5
        1OchzhDNWzhFfOLXcRA3aqVtoY4tEVZGvGNjkuSV+O8FYQ4mricDydh9Gt2CZS8kBw11g6R0yDh
        ECNlsDorB3uISWexH
X-Received: by 2002:a1c:68c5:: with SMTP id d188mr21765378wmc.64.1610982277977;
        Mon, 18 Jan 2021 07:04:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzAocm4YOtLjCr5k37DjhAHDbUBhVkU09C7Q2qMpBxBR3X3zOVzn936ICMee7QrKjcDbvR50g==
X-Received: by 2002:a1c:68c5:: with SMTP id d188mr21765236wmc.64.1610982276528;
        Mon, 18 Jan 2021 07:04:36 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id u205sm26786291wme.42.2021.01.18.07.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 07:04:35 -0800 (PST)
Date:   Mon, 18 Jan 2021 16:04:33 +0100
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
Subject: Re: [RFC PATCH v2 02/13] af_vsock: separate rx loops for
 STREAM/SEQPACKET.
Message-ID: <20210118150433.kj4wuoecddyng632@steredhat>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
 <20210115054054.1455729-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210115054054.1455729-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 08:40:50AM +0300, Arseny Krasnov wrote:
>This adds two receive loops: for SOCK_STREAM and SOCK_SEQPACKET. Both are
>look like twins, but SEQPACKET is a little bit different from STREAM:
>1) It doesn't call notify callbacks.
>2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
>   there is no sense for these values in SEQPACKET case.
>3) It waits until whole record is received or error is found during
>   receiving.
>4) It processes and sets 'MSG_TRUNC' flag.
>
>So to avoid extra conditions for two types of socket inside on loop, two
>independent functions were created.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   |   5 +
> net/vmw_vsock/af_vsock.c | 202 +++++++++++++++++++++++++++++++++++++++
> 2 files changed, 207 insertions(+)
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
>index af716f5a93a4..afacbe9f4231 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1870,6 +1870,208 @@ static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
> 	return err;
> }
>
>+static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>+				     size_t len, int flags)
>+{
>+	int err = 0;
>+	size_t record_len;
>+	struct vsock_sock *vsk;
>+	const struct vsock_transport *transport;
>+	long timeout;
>+	ssize_t dequeued_total = 0;
>+	unsigned long orig_nr_segs;
>+	const struct iovec *orig_iov;
>+	DEFINE_WAIT(wait);
>+
>+	vsk = vsock_sk(sk);
>+	transport = vsk->transport;
>+
>+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>+	msg->msg_flags &= ~MSG_EOR;
>+	orig_nr_segs = msg->msg_iter.nr_segs;
>+	orig_iov = msg->msg_iter.iov;
>+
>+	while (1) {
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

Maybe here we can do 'continue', remove the next line, and reduce the 
indentation on the next block.

>+		} else {
>+			ssize_t dequeued;
>+
>+			finish_wait(sk_sleep(sk), &wait);
>+
>+			if (ready < 0) {
>+				err = -ENOMEM;
>+				goto out;
>+			}
>+
>+			if (dequeued_total == 0) {
>+				record_len =
>+					transport->seqpacket_seq_get_len(vsk);
>+
>+				if (record_len == 0)
>+					continue;
>+			}
>+
>+			/* 'msg_iter.count' is number of unused bytes in iov.
>+			 * On every copy to iov iterator it is decremented at
>+			 * size of data.
>+			 */
>+			dequeued = transport->seqpacket_dequeue(vsk, msg,
>+						msg->msg_iter.count, flags);
>+
>+			if (dequeued < 0) {
>+				dequeued_total = 0;
>+
>+				if (dequeued == -EAGAIN) {
>+					iov_iter_init(&msg->msg_iter, READ,
>+						      orig_iov, orig_nr_segs,
>+						      len);
>+					msg->msg_flags &= ~MSG_EOR;
>+					continue;
>+				}
>+
>+				err = -ENOMEM;
>+				break;
>+			}
>+
>+			dequeued_total += dequeued;
>+
>+			if (dequeued_total >= record_len)
>+				break;
>+		}
>+	}
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
>+		 */
>+		if (record_len > len)
>+			msg->msg_flags |= MSG_TRUNC;
>+	}
>+out:
>+	return err;
>+}
>+
>+static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>+				  size_t len, int flags)
>+{
>+	int err;
>+	const struct vsock_transport *transport;
>+	struct vsock_sock *vsk;
>+	size_t target;
>+	struct vsock_transport_recv_notify_data recv_data;
>+	long timeout;
>+	ssize_t copied;
>+
>+	DEFINE_WAIT(wait);
>+
>+	vsk = vsock_sk(sk);
>+	transport = vsk->transport;
>+
>+	/* We must not copy less than target bytes into the user's buffer
>+	 * before returning successfully, so we wait for the consume queue to
>+	 * have that much data to consume before dequeueing.  Note that this
>+	 * makes it impossible to handle cases where target is greater than the
>+	 * queue size.
>+	 */
>+	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
>+	if (target >= transport->stream_rcvhiwat(vsk)) {
>+		err = -ENOMEM;
>+		goto out;
>+	}
>+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>+	copied = 0;
>+
>+	err = transport->notify_recv_init(vsk, target, &recv_data);
>+	if (err < 0)
>+		goto out;
>+
>+	while (1) {
>+		s64 ready;
>+
>+		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
>+		ready = vsock_stream_has_data(vsk);
>+
>+		if (ready == 0) {
>+			if (vsock_wait_data(sk, &wait, timeout, 
>&recv_data, target))
>+				break;

The same also here.

>+		} else {
>+			ssize_t read;
>+
>+			finish_wait(sk_sleep(sk), &wait);
>+
>+			if (ready < 0) {
>+				/* Invalid queue pair content. XXX This should
>+				 * be changed to a connection reset in a later
>+				 * change.
>+				 */
>+
>+				err = -ENOMEM;
>+				goto out;
>+			}
>+
>+			err = transport->notify_recv_pre_dequeue(vsk,
>+						target, &recv_data);
>+			if (err < 0)
>+				break;
>+			read = transport->stream_dequeue(vsk, msg, len - copied, flags);
>+
>+			if (read < 0) {
>+				err = -ENOMEM;
>+				break;
>+			}
>+
>+			copied += read;
>+
>+			err = transport->notify_recv_post_dequeue(vsk,
>+						target, read,
>+						!(flags & MSG_PEEK), &recv_data);
>+			if (err < 0)
>+				goto out;
>+
>+			if (read >= target || flags & MSG_PEEK)
>+				break;
>+
>+			target -= read;
>+		}
>+	}
>+
>+	if (sk->sk_err)
>+		err = -sk->sk_err;
>+	else if (sk->sk_shutdown & RCV_SHUTDOWN)
>+		err = 0;
>+	if (copied > 0)
>+		err = copied;
>+
>+out:
>+	release_sock(sk);
>+	return err;
>+}
>+
> static int
> vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 		     int flags)
>-- 
>2.25.1
>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1958A39A397
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 16:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhFCOr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 10:47:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229744AbhFCOr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 10:47:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622731541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YABTD2STAWQQlm5tg1g6NJ074ZuyxPbxn7absUYPnjc=;
        b=RJPxzOKreFlujHreI1HOu/q3wEFHqRB8KLkXFfBfAFNlKNZKsq91bkweXK6r7qopxtbYzH
        E7Kfqm0B6YO7xM+/VCVpGNRgdXIpBVHPAu3rnZuuFKR0dK8IhCltyHLAu1dIQ0Ad+DQZzI
        9ZOqQPIPCR82nEtABeK3YVQmXDtL+Ps=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-cCQ8CBNEOKqNLbw5xMvMsA-1; Thu, 03 Jun 2021 10:45:20 -0400
X-MC-Unique: cCQ8CBNEOKqNLbw5xMvMsA-1
Received: by mail-ed1-f70.google.com with SMTP id d8-20020a0564020008b0290387d38e3ce0so3393057edu.1
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 07:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YABTD2STAWQQlm5tg1g6NJ074ZuyxPbxn7absUYPnjc=;
        b=loxe+A3vZbxopV8N8S9CA9bx8KUtu4B/Uby6PmEca20lKtVokLk31H2DtwXwryYoED
         cbPxJVeHvtF4lSdjvG17SIj3Wk3mrJ5GfvdTINvdoKDy8kRkkwdJKsvkRxTWwAsf+3L/
         2T6W8/EDvDN5sOe/0XeqC0we0SVUiinQfRJitz7hVZMHOjE3YlbKLF6aKys/c5QSPRyi
         s4Xz7KvU4iARi3I2XT3ZLGy/9MqbXgQb4YdWu80AziYC8w0pIoIyULq9mR9PwJvhO/Xq
         y6RwNky2WyLGK1Y7dVvlmNUWYb5SF8+uE8d57P5HjuRfrz2ScB6OFCkLm+lukmR1fODJ
         YfwQ==
X-Gm-Message-State: AOAM5301/IMQmrylZm2e1v32+DgADIVVIg7aj3J61ieN4SNw+QPRDlJ4
        +jpvh6CdhO3ipBYZ9cpxZ0dWTcHGaZvcQkiAyem3zh8kcMji7OItMyzKRs822DINMWVhAk7mnRX
        l9fvI2ryUE/lv3fn0
X-Received: by 2002:a50:afe4:: with SMTP id h91mr203595edd.28.1622731518862;
        Thu, 03 Jun 2021 07:45:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJXKlXoitE1mjpn8GN6FD+0N7T0+mjhG0D3VTzD5XyuA6+OeMMiJZX3H1kZB9DlLneqf+VlA==
X-Received: by 2002:a50:afe4:: with SMTP id h91mr203573edd.28.1622731518678;
        Thu, 03 Jun 2021 07:45:18 -0700 (PDT)
Received: from steredhat ([5.170.129.82])
        by smtp.gmail.com with ESMTPSA id bh3sm1622721ejb.19.2021.06.03.07.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 07:45:17 -0700 (PDT)
Date:   Thu, 3 Jun 2021 16:45:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 11/18] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210603144513.ryjzauq7abnjogu3@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191801.1272027-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191801.1272027-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:17:58PM +0300, Arseny Krasnov wrote:
>Callback fetches RW packets from rx queue of socket until whole record
>is copied(if user's buffer is full, user is not woken up). This is done
>to not stall sender, because if we wake up user and it leaves syscall,
>nobody will send credit update for rest of record, and sender will wait
>for next enter of read syscall at receiver's side. So if user buffer is
>full, we just send credit update and drop data.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v9 -> v10:
> 1) Number of dequeued bytes incremented even in case when
>    user's buffer is full.
> 2) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
> 3) Rename variable 'err' to 'dequeued_len', in case of error
>    it has negative value.
>
> include/linux/virtio_vsock.h            |  5 ++
> net/vmw_vsock/virtio_transport_common.c | 65 +++++++++++++++++++++++++
> 2 files changed, 70 insertions(+)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index dc636b727179..02acf6e9ae04 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -80,6 +80,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags);
>
>+ssize_t
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags,
>+				   bool *msg_ready);
> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index ad0d34d41444..61349b2ea7fe 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -393,6 +393,59 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>+						 struct msghdr *msg,
>+						 int flags,
>+						 bool *msg_ready)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct virtio_vsock_pkt *pkt;
>+	int dequeued_len = 0;
>+	size_t user_buf_len = msg_data_left(msg);
>+
>+	*msg_ready = false;
>+	spin_lock_bh(&vvs->rx_lock);
>+
>+	while (!*msg_ready && !list_empty(&vvs->rx_queue) && dequeued_len >= 0) {

I'

>+		size_t bytes_to_copy;
>+		size_t pkt_len;
>+
>+		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>+		pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>+		bytes_to_copy = min(user_buf_len, pkt_len);
>+
>+		if (bytes_to_copy) {
>+			/* sk_lock is held by caller so no one else can dequeue.
>+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>+			 */
>+			spin_unlock_bh(&vvs->rx_lock);
>+
>+			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy))
>+				dequeued_len = -EINVAL;

I think here is better to return the error returned by memcpy_to_msg(), 
as we do in the other place where we use memcpy_to_msg().

I mean something like this:
			err = memcpy_to_msgmsg, pkt->buf, bytes_to_copy);
			if (err)
				dequeued_len = err;

>+			else
>+				user_buf_len -= bytes_to_copy;
>+
>+			spin_lock_bh(&vvs->rx_lock);
>+		}
>+

Maybe here we can simply break the cycle if we have an error:
		if (dequeued_len < 0)
			break;

Or we can refactor a bit, simplifying the while() condition and also the 
code in this way (not tested):

	while (!*msg_ready && !list_empty(&vvs->rx_queue)) {
		...

		if (bytes_to_copy) {
			int err;

			/* ...
			*/
			spin_unlock_bh(&vvs->rx_lock);
			err = memcpy_to_msgmsg, pkt->buf, bytes_to_copy);
			if (err) {
				dequeued_len = err;
				goto out;
			}
			spin_lock_bh(&vvs->rx_lock);

			user_buf_len -= bytes_to_copy;
		}

		dequeued_len += pkt_len;

		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
			*msg_ready = true;

		virtio_transport_dec_rx_pkt(vvs, pkt);
		list_del(&pkt->list);
		virtio_transport_free_pkt(pkt);
	}

out:
	spin_unlock_bh(&vvs->rx_lock);

	virtio_transport_send_credit_update(vsk);

	return dequeued_len;
}


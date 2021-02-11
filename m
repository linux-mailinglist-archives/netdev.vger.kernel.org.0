Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83B9318DAF
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 15:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhBKOt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 09:49:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230401AbhBKOlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 09:41:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613054371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cQ4WX5LrjUBO2B/BlX8QGxVMDWmqK2VEqVOioz82st4=;
        b=cZ8pnvnnnzMs+eHVnsqMEWjHhTyKalYKAXshNOuYTMRVMs2vP3M71P3B2vlzk5c0eIbOsE
        ZZLaL/9lH5btaAbr7N5wc4e/lumOKbrQiDo0yShTwLOurUTfPh7AK+oy97LIxhXwzQTWy+
        2Mnj5+/tV0a0PiM49jVvJBgiDFU42v0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-z7LyK8vYNMGWidjLwi-kQw-1; Thu, 11 Feb 2021 09:39:27 -0500
X-MC-Unique: z7LyK8vYNMGWidjLwi-kQw-1
Received: by mail-ed1-f70.google.com with SMTP id w23so4633898edr.15
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 06:39:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cQ4WX5LrjUBO2B/BlX8QGxVMDWmqK2VEqVOioz82st4=;
        b=XkcpWS/dx5e34nGqbMQlpq67OWoXYILBTZoTja7VT2WSWzMwS9mWNTkateXbVhqKoL
         8cFJnem4Ke+17xwmTNXjTuGiIOl9jOUdnZwP4+mLVj6np2jRBIzo+lMfuEo0NHiayt69
         EpNvC1PZh+OdyN+HEewKzEym8tTjYncOX4UDdB6eEZOJ3KUZrZtaMPT42zEZ73dIcJjf
         jIrXpEnHf92xQKKHBSXqD73BYpkcYOWH2iJ65JBuBzP+Gm8+E7MKuWPDErJsiIAGcNw+
         OzIE9f0KlCRNA5XC1GI/8D84Rr5k6jxgkYh080nv5nlpFNP/YLhA20ZbObC1wZHuD5Hn
         KTxQ==
X-Gm-Message-State: AOAM532W9IRJuYPF5bB+mrgYthqf3rieSVo3xXHh+H86wTSAVjk1ay8o
        52EuEGMNR2OPp/ttTH8s8wBF8ecuLurFS5Pd4hM98RxFOlOHFEQ0QbQFMfS0jvckMRBl92s2Yga
        HJdsFTgH63H7e2cCv
X-Received: by 2002:aa7:da55:: with SMTP id w21mr8927647eds.138.1613054366355;
        Thu, 11 Feb 2021 06:39:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzeSfLIg11TiFZiqkHyTCpLEsRrFR4Oa/VLugYW1mgKMahXhYPQG9fA0BChZD7qP/oqS9HACQ==
X-Received: by 2002:aa7:da55:: with SMTP id w21mr8927629eds.138.1613054366198;
        Thu, 11 Feb 2021 06:39:26 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id bm9sm4539585ejb.14.2021.02.11.06.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 06:39:25 -0800 (PST)
Date:   Thu, 11 Feb 2021 15:39:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 17/17] virtio/vsock: simplify credit update
 function API
Message-ID: <20210211143922.pfvngujv6k7lutll@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151906.806343-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151906.806343-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 06:19:03PM +0300, Arseny Krasnov wrote:
>'virtio_transport_send_credit_update()' has some extra args:
>1) 'type' may be set in 'virtio_transport_send_pkt_info()' using type
>   of socket.
>2) This function is static and 'hdr' arg was always NULL.
>

Okay, I saw this patch after my previous comment.

I think this looks good, but please move this before your changes (e.g.  
before patch 'virtio/vsock: dequeue callback for SOCK_SEQPACKET').

In this way you don't need to modify 
virtio_transport_notify_buffer_size(), calling 
virtio_transport_get_type() and then remove these changes.

It's generally not a good idea to make changes in a patch and then 
remove them a few patches later in the same series. This should ring a 
bell about moving these changes before others.

Thanks,
Stefano

>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 20 +++++---------------
> 1 file changed, 5 insertions(+), 15 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c 
>b/net/vmw_vsock/virtio_transport_common.c
>index 0aa0fd33e9d6..46308679c8a4 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -286,13 +286,10 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_put_credit);
>
>-static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
>-					       int type,
>-					       struct virtio_vsock_hdr *hdr)
>+static int virtio_transport_send_credit_update(struct vsock_sock *vsk)
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_CREDIT_UPDATE,
>-		.type = type,
> 		.vsk = vsk,
> 	};
>
>@@ -401,9 +398,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	 * with different values.
> 	 */
> 	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
>-		virtio_transport_send_credit_update(vsk,
>-						    VIRTIO_VSOCK_TYPE_STREAM,
>-						    NULL);
>+		virtio_transport_send_credit_update(vsk);
> 	}
>
> 	return total;
>@@ -525,9 +520,7 @@ size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk)
> 	spin_unlock_bh(&vvs->rx_lock);
>
> 	if (bytes_dropped)
>-		virtio_transport_send_credit_update(vsk,
>-						    VIRTIO_VSOCK_TYPE_SEQPACKET,
>-						    NULL);
>+		virtio_transport_send_credit_update(vsk);
>
> 	return vvs->user_read_seq_len;
> }
>@@ -624,8 +617,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>
> 	spin_unlock_bh(&vvs->rx_lock);
>
>-	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_SEQPACKET,
>-					    NULL);
>+	virtio_transport_send_credit_update(vsk);
>
> 	return err;
> }
>@@ -735,15 +727,13 @@ EXPORT_SYMBOL_GPL(virtio_transport_do_socket_init);
> void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)
> {
> 	struct virtio_vsock_sock *vvs = vsk->trans;
>-	int type;
>
> 	if (*val > VIRTIO_VSOCK_MAX_BUF_SIZE)
> 		*val = VIRTIO_VSOCK_MAX_BUF_SIZE;
>
> 	vvs->buf_alloc = *val;
>
>-	type = virtio_transport_get_type(sk_vsock(vsk));
>-	virtio_transport_send_credit_update(vsk, type, NULL);
>+	virtio_transport_send_credit_update(vsk);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
>
>-- 
>2.25.1
>


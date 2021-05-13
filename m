Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B9737F7A4
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 14:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbhEMMPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 08:15:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47137 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233662AbhEMMPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 08:15:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620908047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SQD/pcH6/EwepQ7zwHhPK/O6wsXARP4FrHE+OPXdfJc=;
        b=h0Fruh/2vn1Yw1UEWpZ/srFHb4z58w4z0tSbkOlhlM9y4EGPnVb2NPgWkKNhmGIrv3vbqP
        YUNnscDCASf9GR1vmrs0TqhE6DUuJze/DLfHPRNfbI5ifmhBjY6ij7r3MPvSZpmnLlrmgD
        ShZ7/ao3964T2iUgHiRCH3+beUUtm+I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-iLYEfR7aPWSdkEwJdTtiFg-1; Thu, 13 May 2021 08:14:05 -0400
X-MC-Unique: iLYEfR7aPWSdkEwJdTtiFg-1
Received: by mail-ed1-f70.google.com with SMTP id o12-20020aa7d3cc0000b02903891695ceabso14547597edr.3
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 05:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SQD/pcH6/EwepQ7zwHhPK/O6wsXARP4FrHE+OPXdfJc=;
        b=hm3isGmy2g4jGDPUFIqsmenaS1AlrW/ZF6NUojmJbZp8wpqOskuJpaU0yZFbASwt+7
         ZuuOfEmquI8bdW39X6KiA1ZhXSMKXNaw8/W5Mckn6WBYi5QFdcfs5XmcPHfR03G8bvYp
         eLxuM8mXwA/Vt+yaCGAwOrrOZz2bfXTIQD6zyCVCGtXs8vPhfMJ1Qf7FzJhudzDlPKo0
         n4QLAv6dwrFt+VzECFgBlCd8TFomeO5cT9+1n/qU5PIcbxUEosY57pf4wZ16oHHqHBup
         Mvw36u2BM7hcfZLgMBV3rJWE4414kzCsKpDjPpzRUzxAix91GrgYAKVKIe77r6W8LVg0
         Of6Q==
X-Gm-Message-State: AOAM532Hj+8VL9dQbmZ1phe2IgeSRtNMDDuiV1nJgIv/ArqjSmyqA3MM
        IaFVqWIN0PY7gr6XVlXsYWPQHPv8TS+GOPSRq9u7BYxb+UQB39ziIxhQ3mzgSf+OGSbUy2P5mex
        Cwg7rc/StTlifWeL7
X-Received: by 2002:a05:6402:6cd:: with SMTP id n13mr51384880edy.330.1620908043090;
        Thu, 13 May 2021 05:14:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiXiCGmnyqZKpqgMhRFcjk2WSuaiuU6ojG6BUl5WGN+JeIJysyCkHdp91nTXn7XKitQGIpkA==
X-Received: by 2002:a05:6402:6cd:: with SMTP id n13mr51384863edy.330.1620908042947;
        Thu, 13 May 2021 05:14:02 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id bn5sm1728763ejb.97.2021.05.13.05.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:14:02 -0700 (PDT)
Date:   Thu, 13 May 2021 14:14:00 +0200
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
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 12/19] virtio/vsock: add SEQPACKET receive logic
Message-ID: <20210513121400.7u7kectkxwame76b@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163544.3432132-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163544.3432132-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 07:35:40PM +0300, Arseny Krasnov wrote:
>This modifies current receive logic for SEQPACKET support:
>1) Inserts 'RW' packet to socket's rx queue, but without merging with
>   buffer of last packet in queue.

This is not true anymore, right?

>2) Performs check for packet and socket types on receive(if mismatch,
>   then reset connection).
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Also this patch is changed :-)

>---
> net/vmw_vsock/virtio_transport_common.c | 28 +++++++++++++++++++++++--
> 1 file changed, 26 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index f649a21dd23b..7fea0a2192f7 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -165,6 +165,14 @@ void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
>
>+static u16 virtio_transport_get_type(struct sock *sk)
>+{
>+	if (sk->sk_type == SOCK_STREAM)
>+		return VIRTIO_VSOCK_TYPE_STREAM;
>+	else
>+		return VIRTIO_VSOCK_TYPE_SEQPACKET;
>+}
>+
> /* This function can only be used on connecting/connected sockets,
>  * since a socket assigned to a transport is required.
>  *
>@@ -980,11 +988,15 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> 		/* If there is space in the last packet queued, we copy the
> 		 * new packet in its buffer.
> 		 */
>-		if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
>+		if ((pkt->len <= last_pkt->buf_len - last_pkt->len) &&
>+		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)) {

Maybe we should update the comment above.

> 			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
> 			       pkt->len);
> 			last_pkt->len += pkt->len;
> 			free_pkt = true;
>+
>+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>+				last_pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);

What about doing the following in any case?

			last_pkt->hdr.flags |= pkt->hdr.flags;

> 			goto out;
> 		}
> 	}


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BF13667BB
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237873AbhDUJNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:13:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235219AbhDUJNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:13:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618996356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JFQIJ+5CqCy4do+wsQBitgOFibPbQLAGAyXiYakCXZc=;
        b=R9ILyV6SbJsrVR3/VhTuDgm81qnuL90wF8Cd1QFexDXYDSa1ha7T49a364ArxKxQ5EAZrv
        XmjhdJDKoWixGy0THawJ1SA6dGSEKauybw29jA9nzQoKUTCwSXwigOpj0eNTGwB5Ic2voJ
        M5CrsZvJ8gz3MwOz5TRUEnsweuaIzJc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-iKbsJwuuPPOo4iydPIYm4A-1; Wed, 21 Apr 2021 05:12:34 -0400
X-MC-Unique: iKbsJwuuPPOo4iydPIYm4A-1
Received: by mail-ej1-f71.google.com with SMTP id t9-20020a1709069489b02903807ab24426so3121842ejx.2
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 02:12:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JFQIJ+5CqCy4do+wsQBitgOFibPbQLAGAyXiYakCXZc=;
        b=NbgNoZtowwnMqDZxKCd46zPokSdD+NTw8Z5emIZg+W4k/GMDlRjNhdXZRb+yiFpzR/
         3awFxSE4XvbPxIr1bKNzbp6O0BYPbIsCU2YFcCZFe+Da8qiuLQp+ZOa9qIuffBlzeOCq
         Px9oN/BAiKCwCaxt2+pEj8sik+sHNu/B1hMxL2mj26hWNPuHoPnaNn06ENzdbWWJ48V2
         /ixrgObc9QZFOTKJSLk0ZM5nFPapNOaAjC6EmtbEddVWwS3P9OzBlpPbdsSFeJt43gSl
         d8B96uytONitp64BJ/7UqlZ9b/3TDmeT2OonJ56o1ZEePjdkqgnwPpqtZctQSUUi5p1Z
         ENXw==
X-Gm-Message-State: AOAM533zNMvVLbdxrdE2/JR/+or4UXZ5CRshH+tyu50VLbteCifEq1x1
        ZcEy1VzQA8dpZlQ4ZlGMrbcZI+mB2J7aHR8hrGFYf2dACd66H6UH4IxUF87QEx09bM+qDarh28G
        0yJai2mXr2iiQOL+S
X-Received: by 2002:a50:fb0a:: with SMTP id d10mr24562943edq.146.1618996352008;
        Wed, 21 Apr 2021 02:12:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4h+POcUCHwJn3anUWZxgfuhqxTTTMI2BlWbtYQhJqOg9+yrbcbRX7689t2hRaE5mbU+0swg==
X-Received: by 2002:a50:fb0a:: with SMTP id d10mr24562907edq.146.1618996351808;
        Wed, 21 Apr 2021 02:12:31 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id dc24sm1725846ejb.123.2021.04.21.02.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 02:12:31 -0700 (PDT)
Date:   Wed, 21 Apr 2021 11:12:28 +0200
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
        Norbert Slusarek <nslusarek@gmx.net>,
        Alexander Popov <alex.popov@linux.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        stsp <stsp2@yandex.ru>, Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v8 13/19] virtio/vsock: rest of SOCK_SEQPACKET support
Message-ID: <CAGxU2F6A3-pY5We-pC7-k-3v-tOdKnFvHEAs7eGo4bHnD=sM5Q@mail.gmail.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124528.3404287-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413124528.3404287-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 03:45:25PM +0300, Arseny Krasnov wrote:
>This adds rest of logic for SEQPACKET:
>1) Send SHUTDOWN on socket close for SEQPACKET type.
>2) Set SEQPACKET packet type during send.
>3) 'seqpacket_allow' flag to virtio transport.
>4) Set 'VIRTIO_VSOCK_SEQ_EOR' bit in flags for last
>   packet of message.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
>v7 -> v8:
> - MSG_EOR handling is removed, i didn't found exact description about
>   how it works in POSIX.
> - SEQ_BEGIN, SEQ_END, etc. now removed.
>
> include/linux/virtio_vsock.h            |  6 ++++++
> net/vmw_vsock/virtio_transport_common.c | 16 ++++++++++++++--
> 2 files changed, 20 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 02acf6e9ae04..f00a01bfdd7e 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -68,6 +68,8 @@ struct virtio_transport {
>
>       /* Takes ownership of the packet */
>       int (*send_pkt)(struct virtio_vsock_pkt *pkt);
>+
>+      bool seqpacket_allow;
> };
>
> ssize_t
>@@ -80,6 +82,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>                              struct msghdr *msg,
>                              size_t len, int flags);
>
>+int
>+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>+                                 struct msghdr *msg,
>+                                 size_t len);
> ssize_t
> virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>                                  struct msghdr *msg,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 572869fef832..4c5b63601308 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -74,6 +74,9 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
>               err = memcpy_from_msg(pkt->buf, info->msg, len);
>               if (err)
>                       goto out;
>+
>+              if (info->msg->msg_iter.count == 0)
>+                      pkt->hdr.flags |= VIRTIO_VSOCK_SEQ_EOR;

We should set the flag in info->flags and assign it using cpu_to_le32() 
or just the following:
			pkt->hdr.flags = cpu_to_le32(info->flags |
						VIRTIO_VSOCK_SEQ_EOR);


>       }
>
>       trace_virtio_transport_alloc_pkt(src_cid, src_port,
>@@ -187,7 +190,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>       struct virtio_vsock_pkt *pkt;
>       u32 pkt_len = info->pkt_len;
>
>-      info->type = VIRTIO_VSOCK_TYPE_STREAM;
>+      info->type = virtio_transport_get_type(sk_vsock(vsk));
>
>       t_ops = virtio_transport_get_ops(vsk);
>       if (unlikely(!t_ops))
>@@ -486,6 +489,15 @@ virtio_transport_seqpacket_dequeue(struct 
>vsock_sock *vsk,
> }
> EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>
>+int
>+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>+                                 struct msghdr *msg,
>+                                 size_t len)
>+{
>+      return virtio_transport_stream_enqueue(vsk, msg, len);
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
>+
> int
> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>                              struct msghdr *msg,
>@@ -905,7 +917,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
>       struct sock *sk = &vsk->sk;
>       bool remove_sock = true;
>
>-      if (sk->sk_type == SOCK_STREAM)
>+      if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
>               remove_sock = virtio_transport_close(vsk);
>
>       list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
>--
>2.25.1
>


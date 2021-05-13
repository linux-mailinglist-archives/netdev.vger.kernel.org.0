Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8729C37F7EA
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 14:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhEMM2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 08:28:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231209AbhEMM2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 08:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620908835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bun77zqk7VkzrXJl00b3NEyJ8M8mJCA5zh/pMnmjFG0=;
        b=MdENMMTXPf4uPiI0M3w9EsxlEPm+4moVWAy3O6j31rBhd0TummwMEq6QtZv7ONnybvNNaF
        z5ryHynqCmA4Y4V86WcljLNNR+zG7rFaD3RE4cSMfOl9BeGB6HPV/7Hsp58qZqAGDQJFoi
        UAachT7df9wXYklfONnBc2AC1BwoFOs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-ZMq9ZYPYMmOSj4DFicqQyQ-1; Thu, 13 May 2021 08:27:13 -0400
X-MC-Unique: ZMq9ZYPYMmOSj4DFicqQyQ-1
Received: by mail-ej1-f69.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso8321651ejc.7
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 05:27:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bun77zqk7VkzrXJl00b3NEyJ8M8mJCA5zh/pMnmjFG0=;
        b=DYDLsw16KIvXuSx7Q8H6rq5zV1nWf1mNm3FF9QkWr9lItlBdONw5sqNX6KSRQ0dPA8
         O2FK7kFp/heWizH4afY2mcYsn2VB2trZaHblKskWlavNPLoewEinru27A6qN95hfuqKN
         GPhIBcRqQIFMFORBibvFk/asBVDyYFSeKvVp/kbllHsiUneEQRY5uZq02MRpQ2uXe4DH
         0SeZhwAPxUA8mhQV2DilLIzEhEzB21HjzozL/m3A1XfCSvwifkq6j2v2CQxffXg2yoUL
         o50Dqil59NeYezaz11yc8mf2yvCxMMHHMFMC+DIZ3TtalpSlpE6veSHyJO899m//K8Ux
         U8FQ==
X-Gm-Message-State: AOAM5320O2zvGUKpnD150oKgQPVSSypPV9yRSVdQtR05qpVlAaNBd46l
        e4Wr+RUiQoDvq0VllIGkqFX3ANs0vBcYJdgo/8tRr75IZpk7f5YWftoqaQgtIS3IPPVEroXB84b
        h5StgtAmSTBQmR/Pq
X-Received: by 2002:a17:907:dab:: with SMTP id go43mr887187ejc.164.1620908832789;
        Thu, 13 May 2021 05:27:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwue4TmFqWLEu2VxiQaCD7KEItg8q3jSRdx8XvzysQOkYR1mJoopNDC9/BUXvDd7qRZ6CJ1Qw==
X-Received: by 2002:a17:907:dab:: with SMTP id go43mr887165ejc.164.1620908832621;
        Thu, 13 May 2021 05:27:12 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id g17sm2863576edv.47.2021.05.13.05.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:27:12 -0700 (PDT)
Date:   Thu, 13 May 2021 14:27:08 +0200
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
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 13/19] virtio/vsock: rest of SOCK_SEQPACKET support
Message-ID: <20210513122708.mwooglzkhv7du7jo@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163558.3432246-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163558.3432246-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 07:35:54PM +0300, Arseny Krasnov wrote:
>This adds rest of logic for SEQPACKET:
>1) Send SHUTDOWN on socket close for SEQPACKET type.
>2) Set SEQPACKET packet type during send.
>3) 'seqpacket_allow' flag to virtio transport.

Please update this commit message, point 3 is not included anymore in 
this patch, right?

>4) Set 'VIRTIO_VSOCK_SEQ_EOR' bit in flags for last
>   packet of message.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v8 -> v9:
> 1) Use cpu_to_le32() to set VIRTIO_VSOCK_SEQ_EOR.
>
> include/linux/virtio_vsock.h            |  4 ++++
> net/vmw_vsock/virtio_transport_common.c | 17 +++++++++++++++--
> 2 files changed, 19 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 02acf6e9ae04..7360ab7ea0af 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -80,6 +80,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags);
>
>+int
>+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   size_t len);
> ssize_t
> virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> 				   struct msghdr *msg,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 7fea0a2192f7..b6608b4ac7c2 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -74,6 +74,10 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
> 		err = memcpy_from_msg(pkt->buf, info->msg, len);
> 		if (err)
> 			goto out;
>+
>+		if (info->msg->msg_iter.count == 0)

Also here is better `msg_data_left(info->msg)`

>+			pkt->hdr.flags = cpu_to_le32(info->flags |
>+						VIRTIO_VSOCK_SEQ_EOR);

Re-thinking an alternative could be to set EOR here...

			info->flags |= VIRTIO_VSOCK_SEQ_EOR;

> 	}

... and move pkt->hdr.flags assignment after this block:

	pkt->hdr.flags = cpu_to_le32(info->flags);

But I don't have a strong opinion on that.

>
> 	trace_virtio_transport_alloc_pkt(src_cid, src_port,


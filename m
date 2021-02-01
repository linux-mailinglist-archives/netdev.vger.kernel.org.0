Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C3830A627
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 12:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhBALGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 06:06:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233411AbhBALFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 06:05:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612177459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GResI48hDY26XzmbVp+6z1SLZhVjnr0cyMwLNeDGS6w=;
        b=B30Iu51xAGoZn1mLbGbcZVOVe/f5WVNNJteVrrurVJCCN3JARTwQ5FmQSCe0/QpfpcnxdO
        sM6O4NJTTcrzuA1j/rV8RHO1kWDnqt6XqBtEwO9+D8l1P4VhhOiPfZrLnLd2WELMQaM7Uo
        PDLkTxrS5LlXgbgl+s1zw/i0QepmO3E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-rjlyo04rMSKmm0B3-MX8NA-1; Mon, 01 Feb 2021 06:04:18 -0500
X-MC-Unique: rjlyo04rMSKmm0B3-MX8NA-1
Received: by mail-wm1-f70.google.com with SMTP id f65so4403664wmf.2
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 03:04:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GResI48hDY26XzmbVp+6z1SLZhVjnr0cyMwLNeDGS6w=;
        b=QpbVMgBHPiIGKzruvBCLfw45PPsiSqHLaBYtj64vwYB0ID+XjqqxkOKrvXLcnXisLM
         lVqjdrmCBJZBCML7KfZO3F1q6g7SAu2z++al3eNAbOCVpb6D49KLFGipSL8Z5Ul+0Ta4
         0nFyR3bVX7ooVBo7IlFujyFnb4dWBHZCzMTievvLFZ1Wa263/nxt1282S+KGYmZxZTKB
         O4M5lGOYGcDQf1vq9pWsF38DyRswq1Mrue1hVAIMsnopJ394LBsSSeh6aR80fpBlxlHg
         gvFCTj3h5ln7KnZQXO6nSzRrlPH4qv0bc5o+v6icUU7NuNQDgsNoGQHgocm9vQn1xpAQ
         6Lbg==
X-Gm-Message-State: AOAM532BdziFpjmqYyKirRvRmYvaRZtcp3iWeIXH/rFyuzXKleczzIZL
        MUdQw6P/o+C5xdnA7OBdjZRM+AswzMdqEwYpuqku8OCcRZqWNMcG3WQrYD9wjx2ox22PiKqvIud
        j4fCfUFjGAXK4MlUU
X-Received: by 2002:a1c:2c89:: with SMTP id s131mr14401977wms.176.1612177457130;
        Mon, 01 Feb 2021 03:04:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyNhnD4X6xfgK4CDHcyftCnfHwb6wW61+fr1Lvod9SkVBfuQu/PNKXCAly6eJ6Qqevyykx9aA==
X-Received: by 2002:a1c:2c89:: with SMTP id s131mr14401948wms.176.1612177456881;
        Mon, 01 Feb 2021 03:04:16 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id d3sm29682647wrp.79.2021.02.01.03.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 03:04:16 -0800 (PST)
Date:   Mon, 1 Feb 2021 12:04:13 +0100
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
        Jeff Vander Stoep <jeffv@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v3 10/13] virtio/vsock: rest of SOCK_SEQPACKET support
Message-ID: <20210201110413.rhraxue2df4vhmpv@steredhat>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
 <20210125111529.599448-1-arseny.krasnov@kaspersky.com>
 <20210129110350.p5h2wtb2xj42rbm4@steredhat>
 <83775d60-29c0-2da0-a87f-11c1f0a3102b@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <83775d60-29c0-2da0-a87f-11c1f0a3102b@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 07:00:16PM +0300, Arseny Krasnov wrote:
>
>On 29.01.2021 14:03, Stefano Garzarella wrote:
>> On Mon, Jan 25, 2021 at 02:15:26PM +0300, Arseny Krasnov wrote:
>>> This adds rest of logic for SEQPACKET:
>>> 1) Shared functions for packet sending now set valid type of packet
>>>   according socket type.
>>> 2) SEQPACKET specific function like SEQ_BEGIN send and data dequeue.
>>> 3) TAP support for SEQPACKET is not so easy if it is necessary to
>>> send whole record to TAP interface. This could be done by allocating
>>> new packet when whole record is received, data of record must be
>>> copied to TAP packet.
>>>
>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>> ---
>>> include/linux/virtio_vsock.h            |  7 ++++
>>> net/vmw_vsock/virtio_transport_common.c | 55 +++++++++++++++++++++----
>>> 2 files changed, 55 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>> index af8705ea8b95..ad9783df97c9 100644
>>> --- a/include/linux/virtio_vsock.h
>>> +++ b/include/linux/virtio_vsock.h
>>> @@ -84,7 +84,14 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>> 			       struct msghdr *msg,
>>> 			       size_t len, int flags);
>>>
>>> +bool virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len);
>>> size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
>>> +ssize_t
>>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>>> +				   struct msghdr *msg,
>>> +				   size_t len,
>>> +				   int type);
>>> +
>>> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>>> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index 90f9feef9d8f..fab14679ca7b 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -139,6 +139,7 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
>>> 		break;
>>> 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
>>> 	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
>>> +	case VIRTIO_VSOCK_OP_SEQ_BEGIN:
>>> 		hdr->op = cpu_to_le16(AF_VSOCK_OP_CONTROL);
>>> 		break;
>>> 	default:
>>> @@ -157,6 +158,10 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
>>>
>>> void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
>>> {
>>> +	/* TODO: implement tap support for SOCK_SEQPACKET. */
>> I think we should do this before merging SOCK_SEQPACKET support because
>> it can be very useful to use tcpdump to figure out what's going on, do
>> you think it's complicated?
>
>It is not complicated if for TAP interface we will consider seqpacket
>
>same as stream, e.g. TAP reader won't see whole record as one
>
>packet,it will see fragments of record as in stream socket. Implement

Maybe as initial support we can have this limitation and complete it 
later.

>
>normal interpretation of seqpacket is not complicated, but requires
>
>some extra work. Ok, i'll check it

Thanks,
Stefano


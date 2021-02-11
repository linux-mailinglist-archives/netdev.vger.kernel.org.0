Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7182318DD9
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 16:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhBKPHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 10:07:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhBKO6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 09:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613055427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gFCDuYQ0NJSVtwITqtQ+46tToq+Osod385U12POaAjM=;
        b=bz9mp7lU9zeLDnkyFhxsGwnA/RusrisblVYXYbts6C29OBYFWkeuSEs0s5HkxvDctZnKHK
        nl2wA94pe5Z65zMMKzbkoX1N9wYIOZcZv2Ix544wLjTnPdwte8fgwQCchEsWq9a+zrmxVV
        Kr4r2NqK1+p6gwXVS05TfCZPCDBNjaI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-RZRtoAbfMja7IJR2eBBkqw-1; Thu, 11 Feb 2021 09:57:05 -0500
X-MC-Unique: RZRtoAbfMja7IJR2eBBkqw-1
Received: by mail-ed1-f69.google.com with SMTP id x13so4754290edi.7
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 06:57:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gFCDuYQ0NJSVtwITqtQ+46tToq+Osod385U12POaAjM=;
        b=FTOatXLo7P0WRlle7p3p6iwdnjEmanYkrvG1PEf6HiZnBSc4xuqz/BzCpL1/88pxin
         PZyW8mRAc3rCqpbfYAwkpnhOz/ooaLbXnODqeoFfq940fQesbhProTzO45WXYbqTSJGt
         OMVMeuDnAAg/+/BiCHPEkm26X7cDcD7leKpHuq2M21pqbu0qi44ozDn9iSfERi4Qrksf
         RNbIYCPcZlgOLbJwXEHz+cq5YzA9n5GZHDEzowagvX+udayoORaoNU9wRCackNZylKhe
         H2vp01P2E29cBAmJkGNTtXEOIp6PkVWyHiULFRn3jR0DoToCjgAUsiY6QwwfB62fRujq
         vmUw==
X-Gm-Message-State: AOAM532EWdIR2JhiuK064BIH9ZbZifP3YjsB9GbB6Gd50CJVjo7SVbtC
        UePKj3QgMZhLbtLSKsPS1hnOOTOmbt9y+WNz6TvY219SgAFaEITMxeShGSxdZ9uk2uYH9e6VaLA
        NGHwVXFBjZYnB1B2l
X-Received: by 2002:a17:906:af15:: with SMTP id lx21mr8842903ejb.139.1613055424619;
        Thu, 11 Feb 2021 06:57:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyeH4FkCLGBkXk194sjR+p03o5Zq0FzJ5zSMRQEIg/gWSDHV6WIdPXXz75vHhwbeQrmSsX0sg==
X-Received: by 2002:a17:906:af15:: with SMTP id lx21mr8842889ejb.139.1613055424403;
        Thu, 11 Feb 2021 06:57:04 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id b11sm4582514eja.115.2021.02.11.06.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 06:57:03 -0800 (PST)
Date:   Thu, 11 Feb 2021 15:57:01 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v4 00/17] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210211145701.qikgx5czosdwx3mm@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207111954-mutt-send-email-mst@kernel.org>
 <8bd3789c-8df1-4383-f233-b4b854b30970@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8bd3789c-8df1-4383-f233-b4b854b30970@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,

On Mon, Feb 08, 2021 at 09:32:59AM +0300, Arseny Krasnov wrote:
>
>On 07.02.2021 19:20, Michael S. Tsirkin wrote:
>> On Sun, Feb 07, 2021 at 06:12:56PM +0300, Arseny Krasnov wrote:
>>> 	This patchset impelements support of SOCK_SEQPACKET for virtio
>>> transport.
>>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>> do it, two new packet operations were added: first for start of record
>>>  and second to mark end of record(SEQ_BEGIN and SEQ_END later). Also,
>>> both operations carries metadata - to maintain boundaries and payload
>>> integrity. Metadata is introduced by adding special header with two
>>> fields - message count and message length:
>>>
>>> 	struct virtio_vsock_seq_hdr {
>>> 		__le32  msg_cnt;
>>> 		__le32  msg_len;
>>> 	} __attribute__((packed));
>>>
>>> 	This header is transmitted as payload of SEQ_BEGIN and SEQ_END
>>> packets(buffer of second virtio descriptor in chain) in the same way as
>>> data transmitted in RW packets. Payload was chosen as buffer for this
>>> header to avoid touching first virtio buffer which carries header of
>>> packet, because someone could check that size of this buffer is equal
>>> to size of packet header. To send record, packet with start marker is
>>> sent first(it's header contains length of record and counter), then
>>> counter is incremented and all data is sent as usual 'RW' packets and
>>> finally SEQ_END is sent(it also carries counter of message, which is
>>> counter of SEQ_BEGIN + 1), also after sedning SEQ_END counter is
>>> incremented again. On receiver's side, length of record is known from
>>> packet with start record marker. To check that no packets were dropped
>>> by transport, counters of two sequential SEQ_BEGIN and SEQ_END are
>>> checked(counter of SEQ_END must be bigger that counter of SEQ_BEGIN by
>>> 1) and length of data between two markers is compared to length in
>>> SEQ_BEGIN header.
>>> 	Now as  packets of one socket are not reordered neither on
>>> vsock nor on vhost transport layers, such markers allows to restore
>>> original record on receiver's side. If user's buffer is smaller that
>>> record length, when all out of size data is dropped.
>>> 	Maximum length of datagram is not limited as in stream socket,
>>> because same credit logic is used. Difference with stream socket is
>>> that user is not woken up until whole record is received or error
>>> occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>>> 	Tests also implemented.
>>>
>>>  Arseny Krasnov (17):
>>>   af_vsock: update functions for connectible socket
>>>   af_vsock: separate wait data loop
>>>   af_vsock: separate receive data loop
>>>   af_vsock: implement SEQPACKET receive loop
>>>   af_vsock: separate wait space loop
>>>   af_vsock: implement send logic for SEQPACKET
>>>   af_vsock: rest of SEQPACKET support
>>>   af_vsock: update comments for stream sockets
>>>   virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>>   virtio/vsock: fetch length for SEQPACKET record
>>>   virtio/vsock: add SEQPACKET receive logic
>>>   virtio/vsock: rest of SOCK_SEQPACKET support
>>>   virtio/vsock: setup SEQPACKET ops for transport
>>>   vhost/vsock: setup SEQPACKET ops for transport
>>>   vsock_test: add SOCK_SEQPACKET tests
>>>   loopback/vsock: setup SEQPACKET ops for transport
>>>   virtio/vsock: simplify credit update function API
>>>
>>>  drivers/vhost/vsock.c                   |   8 +-
>>>  include/linux/virtio_vsock.h            |  15 +
>>>  include/net/af_vsock.h                  |   9 +
>>>  include/uapi/linux/virtio_vsock.h       |  16 +
>>>  net/vmw_vsock/af_vsock.c                | 588 +++++++++++++++-------
>>>  net/vmw_vsock/virtio_transport.c        |   5 +
>>>  net/vmw_vsock/virtio_transport_common.c | 316 ++++++++++--
>>>  net/vmw_vsock/vsock_loopback.c          |   5 +
>>>  tools/testing/vsock/util.c              |  32 +-
>>>  tools/testing/vsock/util.h              |   3 +
>>>  tools/testing/vsock/vsock_test.c        | 126 +++++
>>>  11 files changed, 895 insertions(+), 228 deletions(-)
>>>
>>>  TODO:
>>>  - What to do, when server doesn't support SOCK_SEQPACKET. In current
>>>    implementation RST is replied in the same way when listening port
>>>    is not found. I think that current RST is enough,because case when
>>>    server doesn't support SEQ_PACKET is same when listener missed(e.g.
>>>    no listener in both cases).

I think is fine.

>>    - virtio spec patch
>Ok

Yes, please prepare a patch to discuss the VIRTIO spec changes.

For example for 'virtio_vsock_seq_hdr', I left a comment about 'msg_cnt' 
naming that should be better to discuss with virtio guys.

Anyway, I reviewed this series and I left some comments.
I think we are in a good shape :-)

Thanks,
Stefano


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C70319B05
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 09:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhBLIJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 03:09:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhBLIJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 03:09:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613117281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e91sBuS2eUt5U/U4RuQCZfbUWRB/D2S94vtMrUqV2is=;
        b=HBd518FOjfQ3gz8LetFZeOefAbaI7fHDzCMHXTBzciiJM6nOWdqgORNauS/Ym35EV1ElZ2
        mlb+gkZnnJUAeNhUxg7LvH6agfPcQpjUPTqzNBQcKz4tukKWSDnTBz71DTjLyfo9/aWZn3
        CpFuRg+kJrDt42sgMO4OapOeV9vvSM0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-nDMtAWJ9N0OV1Izsu_PmFQ-1; Fri, 12 Feb 2021 03:08:00 -0500
X-MC-Unique: nDMtAWJ9N0OV1Izsu_PmFQ-1
Received: by mail-ej1-f72.google.com with SMTP id n25so6469341ejd.5
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 00:07:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e91sBuS2eUt5U/U4RuQCZfbUWRB/D2S94vtMrUqV2is=;
        b=fWSWg40T8SOZByVCq3bBV/UcNZv6RnQdlZb1N+LEeApkJZfX43iOiMKb/b/dxxEO/B
         f0d+Ab+jfG8KnqQPMsaMJ3GUCatUPpPBaI21TiPWNRvFNnALLsBBdzzouuq08+Srv7R9
         0w+XckIbwdv/jPKzVb2CgcOHdW9ikg3MqO1aE2MF58dKbhBPNA3542UvF7O7Eeza/s+5
         Rfn8598oLcphbC/oO6WdSGY5YXlN01/s+E9tsoJTKHeoVf3TDMDzkBZPtP++iGn62mTV
         xy473Y1Pr7KkfwpCLl5+M1ImxXzumUdIr35gUYHJUtXegNw9uXlHjLzjR8R0nPB8zIJv
         SVLw==
X-Gm-Message-State: AOAM533djfxhTY+nG93j256g9L3RK4Q1I7ph5ufVbieYkpnOsXWT7nkM
        3IbStthkHCj1TtadrUO3LUtTDVV2EXxMRZmS5oheJnNg43H46X2aCjCSL4BYAmPwZjqgs6iLcKG
        9aamfaqXg2/2SZjIj
X-Received: by 2002:a17:906:b19a:: with SMTP id w26mr1837749ejy.296.1613117278927;
        Fri, 12 Feb 2021 00:07:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx4UZHOM3MECOyqyoo31l+Ya9+PmIMzipGRc9pjPxWBn6h9u4zDZXf7FXG0XDCU+qiqPKdNxg==
X-Received: by 2002:a17:906:b19a:: with SMTP id w26mr1837718ejy.296.1613117278668;
        Fri, 12 Feb 2021 00:07:58 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id cn18sm5361167edb.66.2021.02.12.00.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 00:07:58 -0800 (PST)
Date:   Fri, 12 Feb 2021 09:07:55 +0100
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
Message-ID: <20210212080755.ajip7s7dhmxqhxqd@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207111954-mutt-send-email-mst@kernel.org>
 <8bd3789c-8df1-4383-f233-b4b854b30970@kaspersky.com>
 <20210211145701.qikgx5czosdwx3mm@steredhat>
 <10aa4548-2455-295d-c993-30f25fba15f2@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <10aa4548-2455-295d-c993-30f25fba15f2@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 09:11:50AM +0300, Arseny Krasnov wrote:
>
>On 11.02.2021 17:57, Stefano Garzarella wrote:
>> Hi Arseny,
>>
>> On Mon, Feb 08, 2021 at 09:32:59AM +0300, Arseny Krasnov wrote:
>>> On 07.02.2021 19:20, Michael S. Tsirkin wrote:
>>>> On Sun, Feb 07, 2021 at 06:12:56PM +0300, Arseny Krasnov wrote:
>>>>> 	This patchset impelements support of SOCK_SEQPACKET for virtio
>>>>> transport.
>>>>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>>>> do it, two new packet operations were added: first for start of record
>>>>>  and second to mark end of record(SEQ_BEGIN and SEQ_END later). Also,
>>>>> both operations carries metadata - to maintain boundaries and payload
>>>>> integrity. Metadata is introduced by adding special header with two
>>>>> fields - message count and message length:
>>>>>
>>>>> 	struct virtio_vsock_seq_hdr {
>>>>> 		__le32  msg_cnt;
>>>>> 		__le32  msg_len;
>>>>> 	} __attribute__((packed));
>>>>>
>>>>> 	This header is transmitted as payload of SEQ_BEGIN and SEQ_END
>>>>> packets(buffer of second virtio descriptor in chain) in the same way as
>>>>> data transmitted in RW packets. Payload was chosen as buffer for this
>>>>> header to avoid touching first virtio buffer which carries header of
>>>>> packet, because someone could check that size of this buffer is equal
>>>>> to size of packet header. To send record, packet with start marker is
>>>>> sent first(it's header contains length of record and counter), then
>>>>> counter is incremented and all data is sent as usual 'RW' packets and
>>>>> finally SEQ_END is sent(it also carries counter of message, which is
>>>>> counter of SEQ_BEGIN + 1), also after sedning SEQ_END counter is
>>>>> incremented again. On receiver's side, length of record is known from
>>>>> packet with start record marker. To check that no packets were dropped
>>>>> by transport, counters of two sequential SEQ_BEGIN and SEQ_END are
>>>>> checked(counter of SEQ_END must be bigger that counter of SEQ_BEGIN by
>>>>> 1) and length of data between two markers is compared to length in
>>>>> SEQ_BEGIN header.
>>>>> 	Now as  packets of one socket are not reordered neither on
>>>>> vsock nor on vhost transport layers, such markers allows to restore
>>>>> original record on receiver's side. If user's buffer is smaller that
>>>>> record length, when all out of size data is dropped.
>>>>> 	Maximum length of datagram is not limited as in stream socket,
>>>>> because same credit logic is used. Difference with stream socket is
>>>>> that user is not woken up until whole record is received or error
>>>>> occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>>>>> 	Tests also implemented.
>>>>>
>>>>>  Arseny Krasnov (17):
>>>>>   af_vsock: update functions for connectible socket
>>>>>   af_vsock: separate wait data loop
>>>>>   af_vsock: separate receive data loop
>>>>>   af_vsock: implement SEQPACKET receive loop
>>>>>   af_vsock: separate wait space loop
>>>>>   af_vsock: implement send logic for SEQPACKET
>>>>>   af_vsock: rest of SEQPACKET support
>>>>>   af_vsock: update comments for stream sockets
>>>>>   virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>>>>   virtio/vsock: fetch length for SEQPACKET record
>>>>>   virtio/vsock: add SEQPACKET receive logic
>>>>>   virtio/vsock: rest of SOCK_SEQPACKET support
>>>>>   virtio/vsock: setup SEQPACKET ops for transport
>>>>>   vhost/vsock: setup SEQPACKET ops for transport
>>>>>   vsock_test: add SOCK_SEQPACKET tests
>>>>>   loopback/vsock: setup SEQPACKET ops for transport
>>>>>   virtio/vsock: simplify credit update function API
>>>>>
>>>>>  drivers/vhost/vsock.c                   |   8 +-
>>>>>  include/linux/virtio_vsock.h            |  15 +
>>>>>  include/net/af_vsock.h                  |   9 +
>>>>>  include/uapi/linux/virtio_vsock.h       |  16 +
>>>>>  net/vmw_vsock/af_vsock.c                | 588 +++++++++++++++-------
>>>>>  net/vmw_vsock/virtio_transport.c        |   5 +
>>>>>  net/vmw_vsock/virtio_transport_common.c | 316 ++++++++++--
>>>>>  net/vmw_vsock/vsock_loopback.c          |   5 +
>>>>>  tools/testing/vsock/util.c              |  32 +-
>>>>>  tools/testing/vsock/util.h              |   3 +
>>>>>  tools/testing/vsock/vsock_test.c        | 126 +++++
>>>>>  11 files changed, 895 insertions(+), 228 deletions(-)
>>>>>
>>>>>  TODO:
>>>>>  - What to do, when server doesn't support SOCK_SEQPACKET. In current
>>>>>    implementation RST is replied in the same way when listening port
>>>>>    is not found. I think that current RST is enough,because case when
>>>>>    server doesn't support SEQ_PACKET is same when listener missed(e.g.
>>>>>    no listener in both cases).
>> I think is fine.
>>
>>>>    - virtio spec patch
>>> Ok
>> Yes, please prepare a patch to discuss the VIRTIO spec changes.
>>
>> For example for 'virtio_vsock_seq_hdr', I left a comment about 'msg_cnt'
>> naming that should be better to discuss with virtio guys.
>
>Ok, i'll prepare it in v5. So I have to send it both LKML(as one of patches) and
>
>virtio mailing lists? (e.g. virtio-comment@lists.oasis-open.org)

I think you can send the VIRTIO spec patch separately from this series 
to virtio-comment, maybe CCing virtualization@lists.linux-foundation.org

But Michael could correct me :-)

>
>>
>> Anyway, I reviewed this series and I left some comments.
>> I think we are in a good shape :-)
>Great, thanks for review. I'll consider all review comments in next 
>version.

Great!

Stefano


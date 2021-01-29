Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A8B308800
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 12:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhA2K6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 05:58:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232200AbhA2K0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 05:26:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611915856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nP4l2G4dODpjaU7YDjg1QGuqXy7wbW7wVhXMNoRQIL8=;
        b=Eqh7bkVyYpdnDsbErTErc62QFiAgHbnl8k8wiyObaT50FaWf+XNBBSf3CINep//4NxagIO
        8CBhdmQpo+21Q6iVJbrPWI0H4C+hBdzBo+D/ytHZKZbeh1uGNk2sfyYhQ1fdvm+Z9accPO
        kCYuZ/jYbUQqDEkKJYH7w0rJ0GQThgI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-6dENrCoUPfS_29BC6mrRQQ-1; Fri, 29 Jan 2021 04:26:09 -0500
X-MC-Unique: 6dENrCoUPfS_29BC6mrRQQ-1
Received: by mail-ed1-f72.google.com with SMTP id x13so4653047edi.7
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 01:26:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nP4l2G4dODpjaU7YDjg1QGuqXy7wbW7wVhXMNoRQIL8=;
        b=LkpUE1qR+AW0rcCPstzuZ2M5Xiie71NsUlQZHRCJOuMgfTO+xs3hHx8opl3hdXux75
         ShmJL1N/I8IKJ83HFYFtGUdhmOO5mx2rN+dz2PmrJ6YzvPHafOMWoTTGmElRsIiYzKdz
         pfVtWRRkqfhxF/QNGRg8niwtngSxA8WdehulwJqk0tB6/ovENWWPi3+wx4goi3alk5XV
         L1q4fJDyCyHw5vlFJ0JQjCXH+Gx6UKWH55CKL2goDjTuhiAj5iB14v4gC1klozmnNLat
         4FpcU5RoZHAHr+zgqeUpg63x7ng/231/TrfHyvj/lxfknN9Q5vsKhzPt+9yWQARgphuH
         AJQQ==
X-Gm-Message-State: AOAM532bnXcWeIgU1xWvdjxsqOL7FaNJALuDHp3yJrDMwR/7wk//bb/B
        kT9mc0Y52APLDR7ksEnRPBaUNlGMxYm9whu5yexwOTGonrL4I4T+nFdNKYbBn1d/ISVKK8LbWlt
        BnUNEPWh8xHouaUqK
X-Received: by 2002:a05:6402:4242:: with SMTP id g2mr4091928edb.103.1611912368195;
        Fri, 29 Jan 2021 01:26:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy2D+e1xoz9VblcO2a9mHDykKQQov6UxFQbNQz9AXlqGu90jfarHaQYZn2TFTNC1vtihyqKwg==
X-Received: by 2002:a05:6402:4242:: with SMTP id g2mr4091910edb.103.1611912367935;
        Fri, 29 Jan 2021 01:26:07 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id r23sm3509763ejd.56.2021.01.29.01.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 01:26:07 -0800 (PST)
Date:   Fri, 29 Jan 2021 10:26:04 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
Subject: Re: [RFC PATCH v3 00/13] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210129092604.mgaw3ipiyv6xra3b@steredhat>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
 <20210128171923.esyna5ccv5s27jyu@steredhat>
 <63459bb3-da22-b2a4-71ee-e67660fd2e12@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <63459bb3-da22-b2a4-71ee-e67660fd2e12@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 09:41:50AM +0300, Arseny Krasnov wrote:
>
>On 28.01.2021 20:19, Stefano Garzarella wrote:
>> Hi Arseny,
>> I reviewed a part, tomorrow I hope to finish the other patches.
>>
>> Just a couple of comments in the TODOs below.
>>
>> On Mon, Jan 25, 2021 at 02:09:00PM +0300, Arseny Krasnov wrote:
>>> 	This patchset impelements support of SOCK_SEQPACKET for virtio
>>> transport.
>>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>> do it, new packet operation was added: it marks start of record (with
>>> record length in header), such packet doesn't carry any data.  To send
>>> record, packet with start marker is sent first, then all data is sent
>>> as usual 'RW' packets. On receiver's side, length of record is known
>> >from packet with start record marker. Now as  packets of one socket
>>> are not reordered neither on vsock nor on vhost transport layers, such
>>> marker allows to restore original record on receiver's side. If user's
>>> buffer is smaller that record length, when all out of size data is
>>> dropped.
>>> 	Maximum length of datagram is not limited as in stream socket,
>>> because same credit logic is used. Difference with stream socket is
>>> that user is not woken up until whole record is received or error
>>> occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>>> 	Tests also implemented.
>>>
>>> Arseny Krasnov (13):
>>>  af_vsock: prepare for SOCK_SEQPACKET support
>>>  af_vsock: prepare 'vsock_connectible_recvmsg()'
>>>  af_vsock: implement SEQPACKET rx loop
>>>  af_vsock: implement send logic for SOCK_SEQPACKET
>>>  af_vsock: rest of SEQPACKET support
>>>  af_vsock: update comments for stream sockets
>>>  virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>>  virtio/vsock: fetch length for SEQPACKET record
>>>  virtio/vsock: add SEQPACKET receive logic
>>>  virtio/vsock: rest of SOCK_SEQPACKET support
>>>  virtio/vsock: setup SEQPACKET ops for transport
>>>  vhost/vsock: setup SEQPACKET ops for transport
>>>  vsock_test: add SOCK_SEQPACKET tests
>>>
>>> drivers/vhost/vsock.c                   |   7 +-
>>> include/linux/virtio_vsock.h            |  12 +
>>> include/net/af_vsock.h                  |   6 +
>>> include/uapi/linux/virtio_vsock.h       |   9 +
>>> net/vmw_vsock/af_vsock.c                | 543 ++++++++++++++++------
>>> net/vmw_vsock/virtio_transport.c        |   4 +
>>> net/vmw_vsock/virtio_transport_common.c | 295 ++++++++++--
>>> tools/testing/vsock/util.c              |  32 +-
>>> tools/testing/vsock/util.h              |   3 +
>>> tools/testing/vsock/vsock_test.c        | 126 +++++
>>> 10 files changed, 862 insertions(+), 175 deletions(-)
>>>
>>> TODO:
>>> - Support for record integrity control. As transport could drop some
>>>   packets, something like "record-id" and record end marker need to
>>>   be implemented. Idea is that SEQ_BEGIN packet carries both record
>>>   length and record id, end marker(let it be SEQ_END) carries only
>>>   record id. To be sure that no one packet was lost, receiver checks
>>>   length of data between SEQ_BEGIN and SEQ_END(it must be same with
>>>   value in SEQ_BEGIN) and record ids of SEQ_BEGIN and SEQ_END(this
>>>   means that both markers were not dropped. I think that easiest way
>>>   to implement record id for SEQ_BEGIN is to reuse another field of
>>>   packet header(SEQ_BEGIN already uses 'flags' as record length).For
>>>   SEQ_END record id could be stored in 'flags'.
>> I don't really like the idea of reusing the 'flags' field for this
>> purpose.
>>
>>>     Another way to implement it, is to move metadata of both SEQ_END
>>>   and SEQ_BEGIN to payload. But this approach has problem, because
>>>   if we move something to payload, such payload is accounted by
>>>   credit logic, which fragments payload, while payload with record
>>>   length and id couldn't be fragmented. One way to overcome it is to
>>>   ignore credit update for SEQ_BEGIN/SEQ_END packet.Another solution
>>>   is to update 'stream_has_space()' function: current implementation
>>>   return non-zero when at least 1 byte is allowed to use,but updated
>>>   version will have extra argument, which is needed length. For 'RW'
>>>   packet this argument is 1, for SEQ_BEGIN it is sizeof(record len +
>>>   record id) and for SEQ_END it is sizeof(record id).
>> Is the payload accounted by credit logic also if hdr.op is not
>> VIRTIO_VSOCK_OP_RW?
>
>Yes, on send any packet with payload could be fragmented if
>
>there is not enough space at receiver. On receive 'fwd_cnt' and
>
>'buf_alloc' are updated with header of every packet. Of course,
>
>to every such case i've described i can add check for 'RW'
>
>packet, to exclude payload from credit accounting, but this is
>
>bunch of dumb checks.
>
>>
>> I think that we can define a specific header to put after the
>> virtio_vsock_hdr when hdr.op is SEQ_BEGIN or SEQ_END, and in this header
>> we can store the id and the length of the message.
>
>I think it is better than use payload and touch credit logic
>

Cool, so let's try this option, hoping there aren't a lot of issues.

Another item for TODO could be to add the SOCK_SEQPACKET support also 
for vsock_loopback. Should be simple since it also uses 
virtio_transport_common APIs and it can be useful for testing and 
debugging.

Thanks,
Stefano


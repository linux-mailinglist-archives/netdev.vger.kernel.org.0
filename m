Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4154830A9A8
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 15:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhBAOZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 09:25:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbhBAOZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:25:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612189420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86wgtLiyakUoknVPpiVvEtMtCYGvN/TevNX9IJtMnLs=;
        b=XVj1crxNefJTqd2E1sFaBIwdGG1KpaKNSW/63+SDQMv+xFtEfSYsVjB2GLEuXtULdv3jhD
        tYQbLLjYtc7+0776snUJiAbU8FCBf75hWSPfA70t8qffzXSxmj0r5aNCYfPgeKsufnLF15
        +71/NM9Wl2GBm9cmgEaiqhIyHoU/v1c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-G3T4hGpuPrymm9ihTeBZEw-1; Mon, 01 Feb 2021 09:23:38 -0500
X-MC-Unique: G3T4hGpuPrymm9ihTeBZEw-1
Received: by mail-wr1-f71.google.com with SMTP id r5so10455592wrx.18
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 06:23:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=86wgtLiyakUoknVPpiVvEtMtCYGvN/TevNX9IJtMnLs=;
        b=QykqnzTp3JLJYwh/iJSie4z92dZtrWbd0nHyTJjX0yU1whNZe8sfExDJ8bJBkk7gMD
         CyUZBf5M+L0du2RTIK+CArSGYytTX/ywqRvAGoPg2Uf17RuMTLCLHSd6q1OYoQf5mwo2
         a7w4EJ9BmvPVDRnotPL9edOnUQWXmaVlsA2yZa6WCbUdo9o1CtNFfVZdvWkQKwReyHoi
         XIMjCiMfjkCkU/3JR/fTlPsQkdlUcZl1TRdNDV75/E1qbHzGtH0/p4wgXlY1+kvs7/cO
         DDF/zYzGYzKRMY8W45HnfxXhJyEDdswmMM1i5kF02k+qMTjw/dbkeVD4xiUVvsnOvQGW
         p7QQ==
X-Gm-Message-State: AOAM532lolAjJ5MLMdgIyi+rCx2qFXRach1fw0MJ6yn1rbuGfM0tydtc
        SauGAyLlgenGg+MI9/rZxTbjiw0kiG+4dLf6W4bcGM71Gtgc0iMwrlpQYld+lPJYpAMdBzG9nc4
        QblecsS11Kt0rWdY0
X-Received: by 2002:a05:6000:10cd:: with SMTP id b13mr18482279wrx.163.1612189417139;
        Mon, 01 Feb 2021 06:23:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwNjDZs4wPbvLSs1VKoyvrMSmuyDsQUQk5MtEmGv49naG2WxLk2j3+tAQuFAzhm3cNzYFEAg==
X-Received: by 2002:a05:6000:10cd:: with SMTP id b13mr18482261wrx.163.1612189416906;
        Mon, 01 Feb 2021 06:23:36 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id x25sm21285174wmk.20.2021.02.01.06.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 06:23:36 -0800 (PST)
Date:   Mon, 1 Feb 2021 15:23:33 +0100
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
Message-ID: <20210201142333.7zcgoqq432y7kktb@steredhat>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
 <20210128171923.esyna5ccv5s27jyu@steredhat>
 <63459bb3-da22-b2a4-71ee-e67660fd2e12@kaspersky.com>
 <20210129092604.mgaw3ipiyv6xra3b@steredhat>
 <cb6d5a9c-fd49-a9dd-33b3-52027ae2f71c@kaspersky.com>
 <20210201110258.7ze7a7izl7gesv4w@steredhat>
 <1b80eb27-4818-50d7-7454-ff6cc398422e@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b80eb27-4818-50d7-7454-ff6cc398422e@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 04:57:18PM +0300, Arseny Krasnov wrote:
>
>On 01.02.2021 14:02, Stefano Garzarella wrote:
>> On Fri, Jan 29, 2021 at 06:52:23PM +0300, Arseny Krasnov wrote:
>>> On 29.01.2021 12:26, Stefano Garzarella wrote:
>>>> On Fri, Jan 29, 2021 at 09:41:50AM +0300, Arseny Krasnov wrote:
>>>>> On 28.01.2021 20:19, Stefano Garzarella wrote:
>>>>>> Hi Arseny,
>>>>>> I reviewed a part, tomorrow I hope to finish the other patches.
>>>>>>
>>>>>> Just a couple of comments in the TODOs below.
>>>>>>
>>>>>> On Mon, Jan 25, 2021 at 02:09:00PM +0300, Arseny Krasnov wrote:
>>>>>>> 	This patchset impelements support of SOCK_SEQPACKET for virtio
>>>>>>> transport.
>>>>>>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>>>>>> do it, new packet operation was added: it marks start of record (with
>>>>>>> record length in header), such packet doesn't carry any data.  To send
>>>>>>> record, packet with start marker is sent first, then all data is sent
>>>>>>> as usual 'RW' packets. On receiver's side, length of record is known
>>>>>> >from packet with start record marker. Now as  packets of one socket
>>>>>>> are not reordered neither on vsock nor on vhost transport layers, such
>>>>>>> marker allows to restore original record on receiver's side. If user's
>>>>>>> buffer is smaller that record length, when all out of size data is
>>>>>>> dropped.
>>>>>>> 	Maximum length of datagram is not limited as in stream socket,
>>>>>>> because same credit logic is used. Difference with stream socket is
>>>>>>> that user is not woken up until whole record is received or error
>>>>>>> occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>>>>>>> 	Tests also implemented.
>>>>>>>
>>>>>>> Arseny Krasnov (13):
>>>>>>>  af_vsock: prepare for SOCK_SEQPACKET support
>>>>>>>  af_vsock: prepare 'vsock_connectible_recvmsg()'
>>>>>>>  af_vsock: implement SEQPACKET rx loop
>>>>>>>  af_vsock: implement send logic for SOCK_SEQPACKET
>>>>>>>  af_vsock: rest of SEQPACKET support
>>>>>>>  af_vsock: update comments for stream sockets
>>>>>>>  virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>>>>>>  virtio/vsock: fetch length for SEQPACKET record
>>>>>>>  virtio/vsock: add SEQPACKET receive logic
>>>>>>>  virtio/vsock: rest of SOCK_SEQPACKET support
>>>>>>>  virtio/vsock: setup SEQPACKET ops for transport
>>>>>>>  vhost/vsock: setup SEQPACKET ops for transport
>>>>>>>  vsock_test: add SOCK_SEQPACKET tests
>>>>>>>
>>>>>>> drivers/vhost/vsock.c                   |   7 +-
>>>>>>> include/linux/virtio_vsock.h            |  12 +
>>>>>>> include/net/af_vsock.h                  |   6 +
>>>>>>> include/uapi/linux/virtio_vsock.h       |   9 +
>>>>>>> net/vmw_vsock/af_vsock.c                | 543 ++++++++++++++++------
>>>>>>> net/vmw_vsock/virtio_transport.c        |   4 +
>>>>>>> net/vmw_vsock/virtio_transport_common.c | 295 ++++++++++--
>>>>>>> tools/testing/vsock/util.c              |  32 +-
>>>>>>> tools/testing/vsock/util.h              |   3 +
>>>>>>> tools/testing/vsock/vsock_test.c        | 126 +++++
>>>>>>> 10 files changed, 862 insertions(+), 175 deletions(-)
>>>>>>>
>>>>>>> TODO:
>>>>>>> - Support for record integrity control. As transport could drop some
>>>>>>>   packets, something like "record-id" and record end marker need to
>>>>>>>   be implemented. Idea is that SEQ_BEGIN packet carries both record
>>>>>>>   length and record id, end marker(let it be SEQ_END) carries only
>>>>>>>   record id. To be sure that no one packet was lost, receiver checks
>>>>>>>   length of data between SEQ_BEGIN and SEQ_END(it must be same with
>>>>>>>   value in SEQ_BEGIN) and record ids of SEQ_BEGIN and SEQ_END(this
>>>>>>>   means that both markers were not dropped. I think that easiest way
>>>>>>>   to implement record id for SEQ_BEGIN is to reuse another field of
>>>>>>>   packet header(SEQ_BEGIN already uses 'flags' as record length).For
>>>>>>>   SEQ_END record id could be stored in 'flags'.
>>>>>> I don't really like the idea of reusing the 'flags' field for this
>>>>>> purpose.
>>>>>>
>>>>>>>     Another way to implement it, is to move metadata of both SEQ_END
>>>>>>>   and SEQ_BEGIN to payload. But this approach has problem, because
>>>>>>>   if we move something to payload, such payload is accounted by
>>>>>>>   credit logic, which fragments payload, while payload with record
>>>>>>>   length and id couldn't be fragmented. One way to overcome it is to
>>>>>>>   ignore credit update for SEQ_BEGIN/SEQ_END packet.Another solution
>>>>>>>   is to update 'stream_has_space()' function: current implementation
>>>>>>>   return non-zero when at least 1 byte is allowed to use,but updated
>>>>>>>   version will have extra argument, which is needed length. For 'RW'
>>>>>>>   packet this argument is 1, for SEQ_BEGIN it is sizeof(record len +
>>>>>>>   record id) and for SEQ_END it is sizeof(record id).
>>>>>> Is the payload accounted by credit logic also if hdr.op is not
>>>>>> VIRTIO_VSOCK_OP_RW?
>>>>> Yes, on send any packet with payload could be fragmented if
>>>>>
>>>>> there is not enough space at receiver. On receive 'fwd_cnt' and
>>>>>
>>>>> 'buf_alloc' are updated with header of every packet. Of course,
>>>>>
>>>>> to every such case i've described i can add check for 'RW'
>>>>>
>>>>> packet, to exclude payload from credit accounting, but this is
>>>>>
>>>>> bunch of dumb checks.
>>>>>
>>>>>> I think that we can define a specific header to put after the
>>>>>> virtio_vsock_hdr when hdr.op is SEQ_BEGIN or SEQ_END, and in this header
>>>>>> we can store the id and the length of the message.
>>>>> I think it is better than use payload and touch credit logic
>>>>>
>>>> Cool, so let's try this option, hoping there aren't a lot of issues.
>>> If i understand, current implementation has 'struct 
>>> virtio_vsock_hdr',
>>>
>>> then i'll add 'struct virtio_vsock_hdr_seq' with message length and id.
>>>
>>> After that, in 'struct virtio_vsock_pkt' which describes packet, field for
>>>
>>> header(which is 'struct virtio_vsock_hdr') must be replaced with new
>>>
>>> structure which  contains both 'struct virtio_vsock_hdr' and 'struct
>>>
>>> virtio_vsock_hdr_seq', because header field of 'struct virtio_vsock_pkt'
>>>
>>> is buffer for virtio layer. After it all accesses to header(for example to
>>>
>>> 'buf_alloc' field will go accross new  structure with both headers:
>>>
>>> pkt->hdr.buf_alloc   ->   pkt->extended_hdr.classic_hdr.buf_alloc
>>>
>>> May be to avoid this, packet's header could be allocated dynamically
>>>
>>> in the same manner as packet's buffer? Size of allocation is always
>>>
>>> sizeof(classic header) + sizeof(seq header). In 'struct virtio_vsock_pkt'
>>>
>>> such header will be implemented as union of two pointers: class header
>>>
>>> and extended header containing classic and seq header. Which pointer
>>>
>>> to use is depends on packet's op.
>> I think that the 'classic header' can stay as is, and the extended
>> header can be dynamically allocated, as we do for the payload.
>>
>> But we have to be careful what happens if the other peer doesn't support
>> SEQPACKET and if it counts this extra header as a payload for the credit
>> mechanism.
>
>You mean put extra header to payload(buffer of second virtio desc),
>
>in this way on send/receive auxiliary 'if's are needed to avoid credit
>
>logic(or set length field in header of such packets to 0). But what
>
>about placing extra header after classic header in buffer of first virtio
>
>desc? In this case extra header is not payload and credit works as is.
>
>Or it is critical, that size of first buffer will be not same as size of
>
>classic header?

We need to think about compatibility with old drivers.

What would happen in this case?

I think it's easier to use the second buffer, usually used for the 
payload, to carry the extra header. Also, we can leave hdr.len = 0, so 
we are sure that it is not counted in credit mechanism.

If the driver supports SEQPACKET, it knows it must fetch extra header 
when it must handle SEQ_BEGIN/SEQ_END.

If it is not clear, I'll try to provide a simple PoC of a patch.

Thanks,
Stefano


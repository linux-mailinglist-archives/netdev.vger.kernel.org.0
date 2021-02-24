Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05F93238CA
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 09:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhBXIh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 03:37:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234512AbhBXIg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 03:36:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614155723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u2cCLiq5dRL7OLoCY/lyttfbFxENLjxHql4LOuHz3Jg=;
        b=gXwz39Fpub4G351WfynhN+4siVmpYj301DiAmH09ycO9VzIXYAW3pU3YiW5DRSSakJeMIj
        CjN5ryjENZehK77fLfaZv5lSuXyuv1JWYQNHiikJRdjRSCm5ckPD2aoXI2NC2e9PzfLzkI
        d2qT90agymVtmPfmPLV6pFAo8ORkBjg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-ybzfU-llOUCnYVHfc7oBsw-1; Wed, 24 Feb 2021 03:35:21 -0500
X-MC-Unique: ybzfU-llOUCnYVHfc7oBsw-1
Received: by mail-wr1-f71.google.com with SMTP id l10so710749wry.16
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 00:35:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u2cCLiq5dRL7OLoCY/lyttfbFxENLjxHql4LOuHz3Jg=;
        b=BYp7tc987V8cFYzQdFSA4nPlDIcu8DaT00/0uutBCw1LtBp1Z3u56DB2lkUB+B2+rK
         yo8VdRRCT6I0XpJCXM8lDiha3C0kFq5JMc16+FMPTzBvd1L1MfLum4MGCbXd2azvSQ8G
         y2/TySdGWgUiijcikwzDEdZvLgUfOJBZ2Zu2E0DuwZ0xeF+5iHDLUDfG3sE8xdqyvu6g
         cYa/0oGTTvku7OcRBv9IQ/i1nakCmh9N80jpx9krcZ83qNrmBOlrc2CFwy4biupzlBsv
         UgWTC/8Sf19y0JJkV9JoxYlm5XWO7wyGCJDCVpWxkJEd43kSjfJd1+ybBhGl4PeNHrfF
         YvmQ==
X-Gm-Message-State: AOAM531Kf7EY/zgJg88Q/DTmY1xxyBcizpG9lXPSQao8r/dmWVXpMX7V
        CFDH3fkfxhuxNfxBx6SP1ZoIeVleS8Zf0qpc5YP2NDV/zk6id0Ne3c0WDkviFlAOzNyhqM/L4Rp
        pfkZaOy+E9UnVPLso
X-Received: by 2002:a1c:c906:: with SMTP id f6mr2571783wmb.128.1614155719952;
        Wed, 24 Feb 2021 00:35:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKD3EgkojM04mK/2unwdiZBQo5BwpQUu3yMCwRrLcbPtdC8ONeJZN9YjQd8V8wZCs15R2MeQ==
X-Received: by 2002:a1c:c906:: with SMTP id f6mr2571773wmb.128.1614155719766;
        Wed, 24 Feb 2021 00:35:19 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id g18sm2173103wrw.40.2021.02.24.00.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 00:35:19 -0800 (PST)
Date:   Wed, 24 Feb 2021 09:35:16 +0100
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v5 00/19] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210224083516.kkxlkoin632iaqik@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210222142311.gekdd7gsm33wglos@steredhat>
 <20210223145016.ddavx6fihq4akdim@steredhat>
 <7a280168-cb54-ae26-4697-c797f6b04708@kaspersky.com>
 <20210224082319.yrmqr6zs7emvghw3@steredhat>
 <710d9dc2-3a0c-ea0b-fb02-68b460e6282e@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <710d9dc2-3a0c-ea0b-fb02-68b460e6282e@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 11:28:50AM +0300, Arseny Krasnov wrote:
>
>On 24.02.2021 11:23, Stefano Garzarella wrote:
>> On Wed, Feb 24, 2021 at 07:29:25AM +0300, Arseny Krasnov wrote:
>>> On 23.02.2021 17:50, Stefano Garzarella wrote:
>>>> On Mon, Feb 22, 2021 at 03:23:11PM +0100, Stefano Garzarella wrote:
>>>>> Hi Arseny,
>>>>>
>>>>> On Thu, Feb 18, 2021 at 08:33:44AM +0300, Arseny Krasnov wrote:
>>>>>> 	This patchset impelements support of SOCK_SEQPACKET for virtio
>>>>>> transport.
>>>>>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>>>>> do it, two new packet operations were added: first for start of record
>>>>>> and second to mark end of record(SEQ_BEGIN and SEQ_END later). Also,
>>>>>> both operations carries metadata - to maintain boundaries and payload
>>>>>> integrity. Metadata is introduced by adding special header with two
>>>>>> fields - message count and message length:
>>>>>>
>>>>>> 	struct virtio_vsock_seq_hdr {
>>>>>> 		__le32  msg_cnt;
>>>>>> 		__le32  msg_len;
>>>>>> 	} __attribute__((packed));
>>>>>>
>>>>>> 	This header is transmitted as payload of SEQ_BEGIN and SEQ_END
>>>>>> packets(buffer of second virtio descriptor in chain) in the same way as
>>>>>> data transmitted in RW packets. Payload was chosen as buffer for this
>>>>>> header to avoid touching first virtio buffer which carries header of
>>>>>> packet, because someone could check that size of this buffer is equal
>>>>>> to size of packet header. To send record, packet with start marker is
>>>>>> sent first(it's header contains length of record and counter), then
>>>>>> counter is incremented and all data is sent as usual 'RW' packets and
>>>>>> finally SEQ_END is sent(it also carries counter of message, which is
>>>>>> counter of SEQ_BEGIN + 1), also after sedning SEQ_END counter is
>>>>>> incremented again. On receiver's side, length of record is known from
>>>>>> packet with start record marker. To check that no packets were dropped
>>>>>> by transport, counters of two sequential SEQ_BEGIN and SEQ_END are
>>>>>> checked(counter of SEQ_END must be bigger that counter of SEQ_BEGIN by
>>>>>> 1) and length of data between two markers is compared to length in
>>>>>> SEQ_BEGIN header.
>>>>>> 	Now as  packets of one socket are not reordered neither on
>>>>>> vsock nor on vhost transport layers, such markers allows to restore
>>>>>> original record on receiver's side. If user's buffer is smaller that
>>>>>> record length, when all out of size data is dropped.
>>>>>> 	Maximum length of datagram is not limited as in stream socket,
>>>>>> because same credit logic is used. Difference with stream socket is
>>>>>> that user is not woken up until whole record is received or error
>>>>>> occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>>>>>> 	Tests also implemented.
>>>>> I reviewed the first part (af_vsock.c changes), tomorrow I'll review
>>>>> the rest. That part looks great to me, only found a few minor issues.
>>>> I revieiwed the rest of it as well, left a few minor comments, but I
>>>> think we're well on track.
>>>>
>>>> I'll take a better look at the specification patch tomorrow.
>>> Great, Thank You
>>>> Thanks,
>>>> Stefano
>>>>
>>>>> In the meantime, however, I'm getting a doubt, especially with regard
>>>>> to other transports besides virtio.
>>>>>
>>>>> Should we hide the begin/end marker sending in the transport?
>>>>>
>>>>> I mean, should the transport just provide a seqpacket_enqueue()
>>>>> callbacl?
>>>>> Inside it then the transport will send the markers. This is because
>>>>> some transports might not need to send markers.
>>>>>
>>>>> But thinking about it more, they could actually implement stubs for
>>>>> that calls, if they don't need to send markers.
>>>>>
>>>>> So I think for now it's fine since it allows us to reuse a lot of
>>>>> code, unless someone has some objection.
>>> I thought about that, I'll try to implement it in next version. Let's see...
>> If you want to discuss it first, write down the idea you want to
>> implement, I wouldn't want to make you do unnecessary work. :-)
>
>Idea is simple, in iov iterator of 'struct msghdr' which is passed to
>
>enqueue callback we have two fields: 'iov_offset' which is byte
>
>offset inside io vector where next data must be picked and 'count'
>
>which is rest of unprocessed bytes in io vector. So in seqpacket
>
>enqueue callback if 'iov_offset' is 0 i'll send SEQBEGIN, and if
>
>'count' is 0 i'll send SEQEND.
>

Got it, make sense and it's defently more transparent for the vsock 
core!
Go head, maybe adding a comment in the vsock core explaining this, so 
other developers can understand better if they want to support SEPACKET 
in other transports.

Thanks,
Stefano


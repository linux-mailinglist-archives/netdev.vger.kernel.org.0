Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95FF322CDD
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 15:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbhBWOwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 09:52:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232457AbhBWOvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 09:51:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614091827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M2OsuZx3r6NZflw0QWxaOyg4KYFKBmW4S9BSyB7K63o=;
        b=JwguBFUTcrY0aVN5hCIZFKnIkTfMN4G8zKVhl9iilXvn9dREjywr8vbiBAvpzztPJpyQUa
        RXCSIMZOV/pAlA/JV2TISxC0ckOA+LXRhQpi/iqRT13JTfGR7xh1MvEdmQmuvEXLRLmWSs
        duE6gHh+nAGFt9mE9JwQBv2wrOtQaSM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-ey1vSwHfPJ-UDIJwUPdLPA-1; Tue, 23 Feb 2021 09:50:21 -0500
X-MC-Unique: ey1vSwHfPJ-UDIJwUPdLPA-1
Received: by mail-wr1-f72.google.com with SMTP id d10so7391373wrq.17
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 06:50:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M2OsuZx3r6NZflw0QWxaOyg4KYFKBmW4S9BSyB7K63o=;
        b=VsFtX4tWyh2bTe8Vu941MEba/u1+ZkEW0+EY6rPaT8ECUHxPGfvs6tc07gWDy4JdnH
         pocup0qb5BVl9Q9OIJHylGXXp5ANDBAD43qzd5Hn0si799eE//3DnPu2WPAFwrBgpimm
         ewSMLm6J+vhpsuL7s9slgr7hprBlEzNe9tNYVtyKQvO86+uVzriNiMCX/mtHDlcUb77l
         mn64h9yvTZfFCVAv8PKwTnd70HGYY6BkEuHZ+UuNrncsAdcJIidRbO5n+omFcVGgsL8p
         liYiGjfwerA/DRW7BJ4dAhrLV3daGhu5lOIK/inXV694h+JXAaefP3rDrK1NGMPECgbl
         FTNA==
X-Gm-Message-State: AOAM533sNx9JPNsWrs4tc52ZJHlbLKH9qq0Rp4o/8A40a+fsXfnizsWO
        Mb9t6lCZNYpvAepFqkXDCOh5z2ToDdUiT2lKaaA1gXJIkG3LPc2Ju1+WIQ5Z8UrMhhIWg60UMxh
        w7kZvX4B5XuBC9kU1
X-Received: by 2002:a1c:98c2:: with SMTP id a185mr9344418wme.72.1614091819959;
        Tue, 23 Feb 2021 06:50:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9tKk0w/iRNRhb7cnm0SfH7twj8rmJO83bREpU9MxKNF6QINjG5A2hMiz9ZZMxEqXDfAr0og==
X-Received: by 2002:a1c:98c2:: with SMTP id a185mr9344394wme.72.1614091819741;
        Tue, 23 Feb 2021 06:50:19 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id o15sm2891607wmh.39.2021.02.23.06.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 06:50:19 -0800 (PST)
Date:   Tue, 23 Feb 2021 15:50:16 +0100
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
Subject: Re: [RFC PATCH v5 00/19] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210223145016.ddavx6fihq4akdim@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210222142311.gekdd7gsm33wglos@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210222142311.gekdd7gsm33wglos@steredhat>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 03:23:11PM +0100, Stefano Garzarella wrote:
>Hi Arseny,
>
>On Thu, Feb 18, 2021 at 08:33:44AM +0300, Arseny Krasnov wrote:
>>	This patchset impelements support of SOCK_SEQPACKET for virtio
>>transport.
>>	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>do it, two new packet operations were added: first for start of record
>>and second to mark end of record(SEQ_BEGIN and SEQ_END later). Also,
>>both operations carries metadata - to maintain boundaries and payload
>>integrity. Metadata is introduced by adding special header with two
>>fields - message count and message length:
>>
>>	struct virtio_vsock_seq_hdr {
>>		__le32  msg_cnt;
>>		__le32  msg_len;
>>	} __attribute__((packed));
>>
>>	This header is transmitted as payload of SEQ_BEGIN and SEQ_END
>>packets(buffer of second virtio descriptor in chain) in the same way as
>>data transmitted in RW packets. Payload was chosen as buffer for this
>>header to avoid touching first virtio buffer which carries header of
>>packet, because someone could check that size of this buffer is equal
>>to size of packet header. To send record, packet with start marker is
>>sent first(it's header contains length of record and counter), then
>>counter is incremented and all data is sent as usual 'RW' packets and
>>finally SEQ_END is sent(it also carries counter of message, which is
>>counter of SEQ_BEGIN + 1), also after sedning SEQ_END counter is
>>incremented again. On receiver's side, length of record is known from
>>packet with start record marker. To check that no packets were dropped
>>by transport, counters of two sequential SEQ_BEGIN and SEQ_END are
>>checked(counter of SEQ_END must be bigger that counter of SEQ_BEGIN by
>>1) and length of data between two markers is compared to length in
>>SEQ_BEGIN header.
>>	Now as  packets of one socket are not reordered neither on
>>vsock nor on vhost transport layers, such markers allows to restore
>>original record on receiver's side. If user's buffer is smaller that
>>record length, when all out of size data is dropped.
>>	Maximum length of datagram is not limited as in stream socket,
>>because same credit logic is used. Difference with stream socket is
>>that user is not woken up until whole record is received or error
>>occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>>	Tests also implemented.
>
>I reviewed the first part (af_vsock.c changes), tomorrow I'll review 
>the rest. That part looks great to me, only found a few minor issues.

I revieiwed the rest of it as well, left a few minor comments, but I 
think we're well on track.

I'll take a better look at the specification patch tomorrow.

Thanks,
Stefano

>
>In the meantime, however, I'm getting a doubt, especially with regard 
>to other transports besides virtio.
>
>Should we hide the begin/end marker sending in the transport?
>
>I mean, should the transport just provide a seqpacket_enqueue() 
>callbacl?
>Inside it then the transport will send the markers. This is because 
>some transports might not need to send markers.
>
>But thinking about it more, they could actually implement stubs for 
>that calls, if they don't need to send markers.
>
>So I think for now it's fine since it allows us to reuse a lot of 
>code, unless someone has some objection.
>
>Thanks,
>Stefano
>


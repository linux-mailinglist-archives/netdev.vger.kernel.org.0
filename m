Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4046321A5A
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 15:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhBVO2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 09:28:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231363AbhBVOYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 09:24:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614003797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wzyVHac7bUd3mCc3EMe28wAe65P5w8DpSyWYPCo7GCg=;
        b=WdUQTOM4Z+KSXRdVEPoMmxbdvvmGR3gM7ZikhSOOfSsWuzN1S4BssVHZX7X3Brc67DwyPi
        Go99xbLkiC5w+bdsi+HHE35LgLcI2OvL0vVgfrIdSSnHbwALC8iYNLxV4u2i6VtPtsxrj/
        i6+Ue0GhcZLNeB+d4ncmFEua9IZVnFo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-_RGa_lzbNMWQILoMOudtHw-1; Mon, 22 Feb 2021 09:23:16 -0500
X-MC-Unique: _RGa_lzbNMWQILoMOudtHw-1
Received: by mail-wr1-f71.google.com with SMTP id x14so5524374wrr.13
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 06:23:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wzyVHac7bUd3mCc3EMe28wAe65P5w8DpSyWYPCo7GCg=;
        b=HjJAXesRL8/qeBG3IWtBMdeycjTaiLSfCjNVjrLVrRbW/xa+kpvajhuiEyuk5YxtFV
         bp00IHLHQnF68tcR4WeP81WlKngIa1XClM2Jx9itB4yJhXvRd/Dy44bX6R2hz+OhXhf5
         VqHqG3JS7YZwngxl/o9be3EqZmCa/b0Gm1c8LNElyUgagIt2NQDIP4pjdNA0h4KCWgWs
         rK+lYGxm0a1c7E+wRY3QxeZdJr+MjRXB8vIKg0OvnO6PEHfJvi38efRg1nQgqnPEgeFS
         4AV3gjrRiszRw7qUjfu4WYHE2ZblEv18lBt4l3y29TA/teKQPx5D9hbWiN95EkEYB36I
         MLyQ==
X-Gm-Message-State: AOAM533ET3t0MmG5gW64rXU7SWSsOvyiSeIgDXwgzZzwdVOTivTzkETC
        +ddvPGOchnBWS2Hy/vEQwb/pCIBWdqtic7iIEBfNXi0qmVMFfc4VEMPNP2nbZeoU3E62khfDmfT
        YNDXjYBsTvu07wsaW
X-Received: by 2002:a1c:23c2:: with SMTP id j185mr20392831wmj.96.1614003795019;
        Mon, 22 Feb 2021 06:23:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyCb72c0yXyjgk1dT0m2zWBpWEuSOVEk1PCqETARj8JSNyPsc7yiew5yYtu4mvxw9C4hwrGDA==
X-Received: by 2002:a1c:23c2:: with SMTP id j185mr20392806wmj.96.1614003794853;
        Mon, 22 Feb 2021 06:23:14 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id o10sm22488407wrx.5.2021.02.22.06.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 06:23:14 -0800 (PST)
Date:   Mon, 22 Feb 2021 15:23:11 +0100
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
Message-ID: <20210222142311.gekdd7gsm33wglos@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,

On Thu, Feb 18, 2021 at 08:33:44AM +0300, Arseny Krasnov wrote:
>	This patchset impelements support of SOCK_SEQPACKET for virtio
>transport.
>	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>do it, two new packet operations were added: first for start of record
> and second to mark end of record(SEQ_BEGIN and SEQ_END later). Also,
>both operations carries metadata - to maintain boundaries and payload
>integrity. Metadata is introduced by adding special header with two
>fields - message count and message length:
>
>	struct virtio_vsock_seq_hdr {
>		__le32  msg_cnt;
>		__le32  msg_len;
>	} __attribute__((packed));
>
>	This header is transmitted as payload of SEQ_BEGIN and SEQ_END
>packets(buffer of second virtio descriptor in chain) in the same way as
>data transmitted in RW packets. Payload was chosen as buffer for this
>header to avoid touching first virtio buffer which carries header of
>packet, because someone could check that size of this buffer is equal
>to size of packet header. To send record, packet with start marker is
>sent first(it's header contains length of record and counter), then
>counter is incremented and all data is sent as usual 'RW' packets and
>finally SEQ_END is sent(it also carries counter of message, which is
>counter of SEQ_BEGIN + 1), also after sedning SEQ_END counter is
>incremented again. On receiver's side, length of record is known from
>packet with start record marker. To check that no packets were dropped
>by transport, counters of two sequential SEQ_BEGIN and SEQ_END are
>checked(counter of SEQ_END must be bigger that counter of SEQ_BEGIN by
>1) and length of data between two markers is compared to length in
>SEQ_BEGIN header.
>	Now as  packets of one socket are not reordered neither on
>vsock nor on vhost transport layers, such markers allows to restore
>original record on receiver's side. If user's buffer is smaller that
>record length, when all out of size data is dropped.
>	Maximum length of datagram is not limited as in stream socket,
>because same credit logic is used. Difference with stream socket is
>that user is not woken up until whole record is received or error
>occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>	Tests also implemented.

I reviewed the first part (af_vsock.c changes), tomorrow I'll review the 
rest. That part looks great to me, only found a few minor issues.

In the meantime, however, I'm getting a doubt, especially with regard to 
other transports besides virtio.

Should we hide the begin/end marker sending in the transport?

I mean, should the transport just provide a seqpacket_enqueue() 
callbacl?
Inside it then the transport will send the markers. This is because some 
transports might not need to send markers.

But thinking about it more, they could actually implement stubs for that 
calls, if they don't need to send markers.

So I think for now it's fine since it allows us to reuse a lot of code, 
unless someone has some objection.

Thanks,
Stefano


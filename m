Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DE1348E63
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 11:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhCYKxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 06:53:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229581AbhCYKxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 06:53:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616669585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rA6ScZsKFbklJRAOSK9fbmhff8O1iylGdvkUdoNRPG8=;
        b=iSroUovuPQbOZtN4Bqv/MwZdwTz/NDm6ZnOUiC+xm3HQpk9hVx9JefD41roJQRURpRw1VR
        mHx3c5+eN5GlNu24bTJZKLp65yolfdgJ9rqUZ/WQBR7CHG+snhnCjAfTnQIFXQft9hOkgt
        k4ml8vREOtDfixCEIU+YY/QHK2p9u6w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-ktWPrZ9cMJOgUgRjsxi1Vw-1; Thu, 25 Mar 2021 06:53:04 -0400
X-MC-Unique: ktWPrZ9cMJOgUgRjsxi1Vw-1
Received: by mail-wm1-f69.google.com with SMTP id n17so1098034wmi.2
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 03:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rA6ScZsKFbklJRAOSK9fbmhff8O1iylGdvkUdoNRPG8=;
        b=DKZJByOYx0v6pnowiH6S5roX35Ff3B4ZYgXv344BAixmbRYURpKjf+Fjm/1VxxUwaq
         6UFdN47qCdEqGsv7c39bSV0dALdGpPUJ4/6OUcWRuXRkYrNvF6Rv+VV0onGyiHXRBb+w
         WUvLB9e+KW+qyk8L/ELQ+uTazkxbd3CJoTl1JotCdskH3qCEFDOe8s7a55ygmkMX5ske
         ycBv+silxwPyUp9+O5NvLRftVSpUcIwRdRFJWudIprFBqeK7S4S4uCmzIVFYYvSCrAX3
         e2lwk8gD9tkWRTWYhV/yZGwgjt779pdKkDgP7HCZGHK/eUowDc0Nev8XohC999+UU/hY
         QARg==
X-Gm-Message-State: AOAM533mvGqzIb7e9Pt420D80k55WEEdAdzoKuPekyZtobG3xcTisVdY
        7V9Mob31HksYH+UDhUdUmSoAiN/BijQc9zteQagxbE1v0rumDhNc8rbvJV8yxmixI91FcPw4RY+
        LXMwnmvwvqbuAROTr
X-Received: by 2002:a05:600c:198f:: with SMTP id t15mr7325681wmq.8.1616669582887;
        Thu, 25 Mar 2021 03:53:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPF/o7JivieTbfBmgFLVxa3jW4fWoo6PGZnk/wPYmH1nohRO66HgZd9zJ49OgEoAEvFWs5wA==
X-Received: by 2002:a05:600c:198f:: with SMTP id t15mr7325659wmq.8.1616669582638;
        Thu, 25 Mar 2021 03:53:02 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id u63sm6101187wmg.24.2021.03.25.03.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 03:53:02 -0700 (PDT)
Date:   Thu, 25 Mar 2021 11:52:59 +0100
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
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v7 00/22] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210325105259.dujvq7honiwigfyg@steredhat>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,

On Tue, Mar 23, 2021 at 04:07:13PM +0300, Arseny Krasnov wrote:
>	This patchset implements support of SOCK_SEQPACKET for virtio
>transport.
>	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>do it, two new packet operations were added: first for start of record
> and second to mark end of record(SEQ_BEGIN and SEQ_END later). Also,
>both operations carries metadata - to maintain boundaries and payload
>integrity. Metadata is introduced by adding special header with two
>fields - message id and message length:
>
>	struct virtio_vsock_seq_hdr {
>		__le32  msg_id;
>		__le32  msg_len;
>	} __attribute__((packed));
>
>	This header is transmitted as payload of SEQ_BEGIN and SEQ_END
>packets(buffer of second virtio descriptor in chain) in the same way as
>data transmitted in RW packets. Payload was chosen as buffer for this
>header to avoid touching first virtio buffer which carries header of
>packet, because someone could check that size of this buffer is equal
>to size of packet header. To send record, packet with start marker is
>sent first(it's header carries length of record and id),then all data
>is sent as usual 'RW' packets and finally SEQ_END is sent(it carries
>id of message, which is equal to id of SEQ_BEGIN), also after sending
>SEQ_END id is incremented. On receiver's side,size of record is known
>from packet with start record marker. To check that no packets were
>dropped by transport, 'msg_id's of two sequential SEQ_BEGIN and SEQ_END
>are checked to be equal and length of data between two markers is
>compared to then length in SEQ_BEGIN header.
>	Now as  packets of one socket are not reordered neither on
>vsock nor on vhost transport layers, such markers allows to restore
>original record on receiver's side. If user's buffer is smaller that
>record length, when all out of size data is dropped.
>	Maximum length of datagram is not limited as in stream socket,
>because same credit logic is used. Difference with stream socket is
>that user is not woken up until whole record is received or error
>occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>	Tests also implemented.
>
>	Thanks to stsp2@yandex.ru for encouragements and initial design
>recommendations.
>
> Arseny Krasnov (22):
>  af_vsock: update functions for connectible socket
>  af_vsock: separate wait data loop
>  af_vsock: separate receive data loop
>  af_vsock: implement SEQPACKET receive loop
>  af_vsock: separate wait space loop
>  af_vsock: implement send logic for SEQPACKET
>  af_vsock: rest of SEQPACKET support
>  af_vsock: update comments for stream sockets
>  virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
>  virtio/vsock: simplify credit update function API
>  virtio/vsock: dequeue callback for SOCK_SEQPACKET
>  virtio/vsock: fetch length for SEQPACKET record
>  virtio/vsock: add SEQPACKET receive logic
>  virtio/vsock: rest of SOCK_SEQPACKET support
>  virtio/vsock: SEQPACKET support feature bit
>  virtio/vsock: setup SEQPACKET ops for transport
>  vhost/vsock: setup SEQPACKET ops for transport
>  vsock/loopback: setup SEQPACKET ops for transport
>  vhost/vsock: SEQPACKET feature bit support
>  virtio/vsock: SEQPACKET feature bit support
>  vsock_test: add SOCK_SEQPACKET tests
>  virtio/vsock: update trace event for SEQPACKET
>
> drivers/vhost/vsock.c                        |  21 +-
> include/linux/virtio_vsock.h                 |  21 +
> include/net/af_vsock.h                       |   9 +
> .../events/vsock_virtio_transport_common.h   |  48 +-
> include/uapi/linux/virtio_vsock.h            |  19 +
> net/vmw_vsock/af_vsock.c                     | 581 +++++++++++------
> net/vmw_vsock/virtio_transport.c             |  17 +
> net/vmw_vsock/virtio_transport_common.c      | 379 +++++++++--
> net/vmw_vsock/vsock_loopback.c               |  12 +
> tools/testing/vsock/util.c                   |  32 +-
> tools/testing/vsock/util.h                   |   3 +
> tools/testing/vsock/vsock_test.c             | 126 ++++
> 12 files changed, 1015 insertions(+), 253 deletions(-)
>
> v6 -> v7:
> General changelog:
> - virtio transport callback for message length now removed
>   from transport. Length of record is returned by dequeue
>   callback.
>
> - function which tries to get message length now returns 0
>   when rx queue is empty. Also length of current message in
>   progress is set to 0, when message processed or error
>   happens.
>
> - patches for virtio feature bit moved after patches with
>   transport ops.
>
> Per patch changelog:
>  see every patch after '---' line.

I reviewed the series and I left some comments, I think we are at a good 
point, but we should have the specification accepted before merging this 
series to avoid having to change the implementation later.

What do you think?

Thanks,
Stefano


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E6233B149
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhCOLkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:40:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229579AbhCOLkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:40:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615808433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PxSaxzcxzfAbRfARa8s8vrxSF0Vnz+8utthTPaHAa5g=;
        b=ImIWsnjf4pUI5VRiOndXDP2SK4+FteVLhLWLLKi/SGTvLAd6ee+EXmW3mlX8AjA+0Naoif
        9UEaIODsD/YuTr2inLMA55G+wCtC4PWEPFKpcNGYRSHs2tYPfQylHePgrcraZ3L0OlxUkj
        SL1iPDelY9Xu10p6jouzXh2L+J739Tk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-mScfyRJEM0aDr9A_vHXGOA-1; Mon, 15 Mar 2021 07:40:31 -0400
X-MC-Unique: mScfyRJEM0aDr9A_vHXGOA-1
Received: by mail-wr1-f69.google.com with SMTP id n17so14990089wrq.5
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PxSaxzcxzfAbRfARa8s8vrxSF0Vnz+8utthTPaHAa5g=;
        b=cGl7slyX+rc19hHBeW3aI9aDDf8xqlILCL3DVG/x59mg3a9Rr5ctdWlQrm+EerFiSi
         IbN2TM8hmwGPbILMfApKmfJ808gIi/f7Oxw9KsAwqpiukoxKqZ8mWUbjtw/paQqfZy6C
         jl3cp/zCNtIrAv7jmHEDbJC4wwXmRho3Zhy9nkyVsBURULlhjSpiVJMEHquljijmaMMD
         O6Z7Pbyj9imRVY/fV5nQAKYDctzcfR6ihn7FQbBVP0tz0Gn23RHMOmsTO+nCPRsFZdUk
         TRqE6mfNcYh9tX0vFGcavCJEMnZJXyNC/C2Zn6E8DaPbhO2BxQJiXuZPZbF2PKVGvDjV
         Izfw==
X-Gm-Message-State: AOAM533A56NmFh1mHziT7wjA7sl/mwKV/XGXjhSakW/fsNuSZ8PztrSf
        sSisDRrTrTl88nd1D5LmEGtj5PVpxckyHyNoJBAxBDWRo6Egg7Qpb1MWgEXbLtfZsBE47OaXeyR
        VUx7td1aWy7pwDwl+
X-Received: by 2002:a05:600c:35c1:: with SMTP id r1mr25432451wmq.60.1615808430351;
        Mon, 15 Mar 2021 04:40:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxe9wDe+7swqQKqvY5kx7A6XwNsh8/JyRypHkYEToXuJ1PEbwx4O2LUUxUlVxnA1rSmVHkGtQ==
X-Received: by 2002:a05:600c:35c1:: with SMTP id r1mr25432432wmq.60.1615808430099;
        Mon, 15 Mar 2021 04:40:30 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id l4sm17987614wrt.60.2021.03.15.04.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:40:29 -0700 (PDT)
Date:   Mon, 15 Mar 2021 12:40:27 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 00/22] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210315114027.neacovpmw3nzz77z@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,

On Sun, Mar 07, 2021 at 08:57:19PM +0300, Arseny Krasnov wrote:
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
>  virtio/vsock: SEQPACKET feature bit
>  vhost/vsock: SEQPACKET feature bit support
>  virtio/vsock: SEQPACKET feature bit support
>  virtio/vsock: setup SEQPACKET ops for transport
>  vhost/vsock: setup SEQPACKET ops for transport
>  vsock/loopback: setup SEQPACKET ops for transport
>  vsock_test: add SOCK_SEQPACKET tests
>  virtio/vsock: update trace event for SEQPACKET
>
> drivers/vhost/vsock.c                        |  22 +-
> include/linux/virtio_vsock.h                 |  22 +
> include/net/af_vsock.h                       |  10 +
> .../events/vsock_virtio_transport_common.h   |  48 +-
> include/uapi/linux/virtio_vsock.h            |  19 +
> net/vmw_vsock/af_vsock.c                     | 589 +++++++++++------
> net/vmw_vsock/virtio_transport.c             |  18 +
> net/vmw_vsock/virtio_transport_common.c      | 364 ++++++++--
> net/vmw_vsock/vsock_loopback.c               |  13 +
> tools/testing/vsock/util.c                   |  32 +-
> tools/testing/vsock/util.h                   |   3 +
> tools/testing/vsock/vsock_test.c             | 126 ++++
> 12 files changed, 1013 insertions(+), 253 deletions(-)
>
> v5 -> v6:
> General changelog:
> - virtio transport specific callbacks which send SEQ_BEGIN or
>   SEQ_END now hidden inside virtio transport. Only enqueue,
>   dequeue and record length callbacks are provided by transport.
>
> - virtio feature bit for SEQPACKET socket support introduced:
>   VIRTIO_VSOCK_F_SEQPACKET.
>
> - 'msg_cnt' field in 'struct virtio_vsock_seq_hdr' renamed to
>   'msg_id' and used as id.
>
> Per patch changelog:
> - 'af_vsock: separate wait data loop':
>    1) Commit message updated.
>    2) 'prepare_to_wait()' moved inside while loop(thanks to
>      Jorgen Hansen).
>    Marked 'Reviewed-by' with 1), but as 2) I removed R-b.
>
> - 'af_vsock: separate receive data loop': commit message
>    updated.
>    Marked 'Reviewed-by' with that fix.
>
> - 'af_vsock: implement SEQPACKET receive loop': style fixes.
>
> - 'af_vsock: rest of SEQPACKET support':
>    1) 'module_put()' added when transport callback check failed.
>    2) Now only 'seqpacket_allow()' callback called to check
>       support of SEQPACKET by transport.
>
> - 'af_vsock: update comments for stream sockets': commit message
>    updated.
>    Marked 'Reviewed-by' with that fix.
>
> - 'virtio/vsock: set packet's type in send':
>    1) Commit message updated.
>    2) Parameter 'type' from 'virtio_transport_send_credit_update()'
>       also removed in this patch instead of in next.
>
> - 'virtio/vsock: dequeue callback for SOCK_SEQPACKET': SEQPACKET
>    related state wrapped to special struct.
>
> - 'virtio/vsock: update trace event for SEQPACKET': format strings
>    now not broken by new lines.

I left a bunch of comments in the patches, I hope they are easy to fix 
:-)

Thanks for the changelogs. About 'per patch changelog', it is very 
useful!
Just a suggestion, I think is better to include them in each patch after 
the '---' to simplify the review.

You can use git-notes(1) or you can simply edit the format-patch and add 
the changelog after the 3 dashes, so that they are ignored when the 
patch is applied.

Thanks,
Stefano


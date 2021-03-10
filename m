Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF8933396A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 11:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhCJKGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 05:06:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60345 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231634AbhCJKGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 05:06:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615370769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7CRQ300l9ojIfUbCmT+C5ubXUEMhIVQ36tvLGt6fXYw=;
        b=C5jZV8UJhZohPRVKyTTCOdViy71zfkxoKoYUQBgBRAfbKx5IShBam6jyCiwT2TX+d0kmn4
        vDnKuGkugzAv8j0nxd0CbEw+zESoHKnaGQ4rYybz8dH9YqpObWJqwBArtiZ1+IL0M/24T2
        gqEC+pM7GSWTlVSK3pxjMqFKM4hMdac=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-McwPZEguOmerSs4YEKsrZw-1; Wed, 10 Mar 2021 05:06:07 -0500
X-MC-Unique: McwPZEguOmerSs4YEKsrZw-1
Received: by mail-wm1-f72.google.com with SMTP id n2so2453546wmi.2
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 02:06:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7CRQ300l9ojIfUbCmT+C5ubXUEMhIVQ36tvLGt6fXYw=;
        b=fp7M28uC7fGE0MI1UoLp3ejQxcBGbeTpWHeiqTy8Mpzok+PIrLUtlIkTGrACndwn/d
         ogPzOgt+o/EC9+hGGc+B/4LJEAeNqPJ+nMKW//BDTL2kbYL3hJdbBV1bH6ZyN4zHzEkO
         /YCGhA2sWcZ0de2BLnSFfWoGdZmYQ9wbgnjbHyUpz0tfQL0rMA6XpyRGDT8cSgjKh8ql
         xyitLL4U5GzNu1QAHtMjfZBdOcjsHsSj23/7VXyHb/tdJSp4SeK3elKwMxfLs3VhxpmZ
         /wOi2L1lRbRCm9tZB6tWvJ2pJ8m0uf7PLvXc6iwoWXkV0UQjQeCCyIpQJD8Vj9myiamG
         VmNA==
X-Gm-Message-State: AOAM531kjSX7j3hMUr5P7QLkNw8TbZ2F0Wk92w9sWtKbtMp4pO6yoj0V
        ravJ/bPc5SGabms6hzlBBcSpxKsC7gqvDPirAcJGVIGQGYNQjKivuCEmeFA1NtkplhuyRVchZGg
        d6COEPIPmL8tH1orN
X-Received: by 2002:a5d:42ca:: with SMTP id t10mr2638802wrr.274.1615370766254;
        Wed, 10 Mar 2021 02:06:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxukHZJqVBikEoxvoszKeSjN05neMT7KJmv/Z9q2En3QSA5YMz/ssw5amFoPjs73pTibvqdNQ==
X-Received: by 2002:a5d:42ca:: with SMTP id t10mr2638770wrr.274.1615370765973;
        Wed, 10 Mar 2021 02:06:05 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id b17sm27828299wrt.17.2021.03.10.02.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 02:06:05 -0800 (PST)
Date:   Wed, 10 Mar 2021 11:06:03 +0100
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
Message-ID: <20210310100603.rfhpy4uglkb6oxez@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,
thanks for this new version.

It's a busy week for me, but I hope to review this series by the end of 
this week :-)

Thanks,
Stefano

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
>
> v4 -> v5:
> - patches reorganized:
>   1) Setting of packet's type in 'virtio_transport_send_pkt_info()'
>      is moved to separate patch.
>   2) Simplifying of 'virtio_transport_send_credit_update()' is
>      moved to separate patch and before main virtio/vsock patches.
> - style problem fixed
> - in 'af_vsock: separate receive data loop' extra 'release_sock()'
>   removed
> - added trace event fields for SEQPACKET
> - in 'af_vsock: separate wait data loop':
>   1) 'vsock_wait_data()' removed 'goto out;'
>   2) Comment for invalid data amount is changed.
> - in 'af_vsock: rest of SEQPACKET support', 'new_transport' pointer
>   check is moved after 'try_module_get()'
> - in 'af_vsock: update comments for stream sockets', 'connect-oriented'
>   replaced with 'connection-oriented'
> - in 'loopback/vsock: setup SEQPACKET ops for transport',
>   'loopback/vsock' replaced with 'vsock/loopback'
>
> v3 -> v4:
> - SEQPACKET specific metadata moved from packet header to payload
>   and called 'virtio_vsock_seq_hdr'
> - record integrity check:
>   1) SEQ_END operation was added, which marks end of record.
>   2) Both SEQ_BEGIN and SEQ_END carries counter which is incremented
>      on every marker send.
> - af_vsock.c: socket operations for STREAM and SEQPACKET call same
>   functions instead of having own "gates" differs only by names:
>   'vsock_seqpacket/stream_getsockopt()' now replaced with
>   'vsock_connectible_getsockopt()'.
> - af_vsock.c: 'seqpacket_dequeue' callback returns error and flag that
>   record ready. There is no need to return number of copied bytes,
>   because case when record received successfully is checked at virtio
>   transport layer, when SEQ_END is processed. Also user doesn't need
>   number of copied bytes, because 'recv()' from SEQPACKET could return
>   error, length of users's buffer or length of whole record(both are
>   known in af_vsock.c).
> - af_vsock.c: both wait loops in af_vsock.c(for data and space) moved
>   to separate functions because now both called from several places.
> - af_vsock.c: 'vsock_assign_transport()' checks that 'new_transport'
>   pointer is not NULL and returns 'ESOCKTNOSUPPORT' instead of 'ENODEV'
>   if failed to use transport.
> - tools/testing/vsock/vsock_test.c: rename tests
>
> v2 -> v3:
> - patches reorganized: split for prepare and implementation patches
> - local variables are declared in "Reverse Christmas tree" manner
> - virtio_transport_common.c: valid leXX_to_cpu() for vsock header
>   fields access
> - af_vsock.c: 'vsock_connectible_*sockopt()' added as shared code
>   between stream and seqpacket sockets.
> - af_vsock.c: loops in '__vsock_*_recvmsg()' refactored.
> - af_vsock.c: 'vsock_wait_data()' refactored.
>
> v1 -> v2:
> - patches reordered: af_vsock.c related changes now before virtio vsock
> - patches reorganized: more small patches, where +/- are not mixed
> - tests for SOCK_SEQPACKET added
> - all commit messages updated
> - af_vsock.c: 'vsock_pre_recv_check()' inlined to
>   'vsock_connectible_recvmsg()'
> - af_vsock.c: 'vsock_assign_transport()' returns ENODEV if transport
>   was not found
> - virtio_transport_common.c: transport callback for seqpacket dequeue
> - virtio_transport_common.c: simplified
>   'virtio_transport_recv_connected()'
> - virtio_transport_common.c: send reset on socket and packet type
>			      mismatch.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>
>-- 
>2.25.1
>


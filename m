Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C96A38C118
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 09:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbhEUH4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 03:56:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232050AbhEUH4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 03:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621583726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MKLcqJa2iylzORtbJXUW2ATOuGg9/HRvaJOuq041BJQ=;
        b=QxD/vErZUMW5lv8HROP0aw2ImhcEb8hmhNP3mjk/AReWXJMzklQ3PnDEZduMLsl9bo7Ngh
        uH3133EKCoCcruFn+6oBiIpNoBGrXPXC5WNW/txf4I1kQTc9NiiQqrZel6OWjgliwA/g1p
        LvGtD4tQSx+eW2CnfK2W5yMtzcK4wBY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-Dqln_KPMOJavS9fTwxjsNw-1; Fri, 21 May 2021 03:55:24 -0400
X-MC-Unique: Dqln_KPMOJavS9fTwxjsNw-1
Received: by mail-ej1-f71.google.com with SMTP id k9-20020a17090646c9b029039d323bd239so5853735ejs.16
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 00:55:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MKLcqJa2iylzORtbJXUW2ATOuGg9/HRvaJOuq041BJQ=;
        b=UZHTd6Mtl+8id/31nH8gYUJqMW3V49PJQesVh3xIQemvEfXbc/7JGKRJ5c6OoQvAW1
         G46k8sZS2ZOejzbS4YAFt9tWw6ZrusTprcOPyYcpgHZ7YCKAUd0flkIK3/28qUfS/+lH
         9ZmzdzRaUjlYsKvwhkZHXFkxPwFO6KaVoAqoAmGtYiShJpXLqVNqZCwhL432SjoVVfUN
         7LrsaBktrziFynTlL+GteWNdqX4tNn0HKhdKxp+gmBVmeYkibPQhl868fUcOu0hDISfJ
         uQyHp4wcBnv9geALK3yEoxqQQJlZArgj8v3pal0ibndEqEtE6e1guuKiLKrVhdeoLCJo
         4eTQ==
X-Gm-Message-State: AOAM531cYrelkjuXQxfLyabR2F5ueZuImGZ1aEMRCKwk6MOsNHjxPpUl
        VFjx4NTQGS8GDepbmNxNIit9IqUhUTo3TQgmk3ctvI62kaYUJk6dCsWr3z8nWF4HD0uZjnCQpze
        O30fuPv+OnonqjPZP
X-Received: by 2002:a17:906:3016:: with SMTP id 22mr8966360ejz.28.1621583723541;
        Fri, 21 May 2021 00:55:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRRc49At9H/iHMJC0Wy7jU0JjEq6nQKIZb6L7nnf1RN7gq6Nbx4+sKgpnx/hOvdQPNHey0iQ==
X-Received: by 2002:a17:906:3016:: with SMTP id 22mr8966348ejz.28.1621583723233;
        Fri, 21 May 2021 00:55:23 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id k9sm3513273edv.69.2021.05.21.00.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 00:55:22 -0700 (PDT)
Date:   Fri, 21 May 2021 09:55:20 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 00/18] virtio/vsock: introduce SOCK_SEQPACKET support
Message-ID: <20210521075520.ghg75wpzz42zorxg@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,

On Thu, May 20, 2021 at 10:13:53PM +0300, Arseny Krasnov wrote:
>	This patchset implements support of SOCK_SEQPACKET for virtio
>transport.

I'll carefully review and test this series next Monday, in the mean time 
I think we should have at least an agreement about the changes that 
regards virtio-spec before merge this series, to avoid any compatibility 
issues.

Do you plan to send a new version of the specification changes?

Thanks,
Stefano

>	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>do it, new bit for field 'flags' was added: SEQ_EOR. This bit is
>set to 1 in last RW packet of message.
>	Now as  packets of one socket are not reordered neither on vsock
>nor on vhost transport layers, such bit allows to restore original
>message on receiver's side. If user's buffer is smaller than message
>length, when all out of size data is dropped.
>	Maximum length of datagram is not limited as in stream socket,
>because same credit logic is used. Difference with stream socket is
>that user is not woken up until whole record is received or error
>occurred. Implementation also supports 'MSG_TRUNC' flags.
>	Tests also implemented.
>
>	Thanks to stsp2@yandex.ru for encouragements and initial design
>recommendations.
>
> Arseny Krasnov (18):
>  af_vsock: update functions for connectible socket
>  af_vsock: separate wait data loop
>  af_vsock: separate receive data loop
>  af_vsock: implement SEQPACKET receive loop
>  af_vsock: implement send logic for SEQPACKET
>  af_vsock: rest of SEQPACKET support
>  af_vsock: update comments for stream sockets
>  virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
>  virtio/vsock: simplify credit update function API
>  virtio/vsock: defines and constants for SEQPACKET
>  virtio/vsock: dequeue callback for SOCK_SEQPACKET
>  virtio/vsock: add SEQPACKET receive logic
>  virtio/vsock: rest of SOCK_SEQPACKET support
>  virtio/vsock: enable SEQPACKET for transport
>  vhost/vsock: enable SEQPACKET for transport
>  vsock/loopback: enable SEQPACKET for transport
>  vsock_test: add SOCK_SEQPACKET tests
>  virtio/vsock: update trace event for SEQPACKET
>
> drivers/vhost/vsock.c                        |  44 +-
> include/linux/virtio_vsock.h                 |   9 +
> include/net/af_vsock.h                       |   7 +
> .../events/vsock_virtio_transport_common.h   |   5 +-
> include/uapi/linux/virtio_vsock.h            |   9 +
> net/vmw_vsock/af_vsock.c                     | 465 +++++++++++------
> net/vmw_vsock/virtio_transport.c             |  25 +
> net/vmw_vsock/virtio_transport_common.c      | 133 ++++-
> net/vmw_vsock/vsock_loopback.c               |  11 +
> tools/testing/vsock/util.c                   |  32 +-
> tools/testing/vsock/util.h                   |   3 +
> tools/testing/vsock/vsock_test.c             | 116 ++++
> 12 files changed, 672 insertions(+), 187 deletions(-)
>
> v9 -> v10:
> General changelog:
> - patch for write serialization removed from patchset
> - commit messages rephrased
> - RFC tag removed
>
> Per patch changelog:
>  see every patch after '---' line.
>
> v8 -> v9:
> General changelog:
> - see per patch change log.
>
> Per patch changelog:
>  see every patch after '---' line.
>
> v7 -> v8:
> General changelog:
> - whole idea is simplified: channel now considered reliable,
>   so SEQ_BEGIN, SEQ_END, 'msg_len' and 'msg_id' were removed.
>   Only thing that is used to mark end of message is bit in
>   'flags' field of packet header: VIRTIO_VSOCK_SEQ_EOR. Packet
>   with such bit set to 1 means, that this is last packet of
>   message.
>
> - POSIX MSG_EOR support is removed, as there is no exact
>   description how it works.
>
> - all changes to 'include/uapi/linux/virtio_vsock.h' moved
>   to dedicated patch, as these changes linked with patch to
>   spec.
>
> - patch 'virtio/vsock: SEQPACKET feature bit support' now merged
>   to 'virtio/vsock: setup SEQPACKET ops for transport'.
>
> - patch 'vhost/vsock: SEQPACKET feature bit support' now merged
>   to 'vhost/vsock: setup SEQPACKET ops for transport'.
>
> Per patch changelog:
>  see every patch after '---' line.
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


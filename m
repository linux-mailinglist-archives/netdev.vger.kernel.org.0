Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACA63125F9
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 17:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBGQWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 11:22:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229629AbhBGQWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 11:22:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612714833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FZqyDugOGOW0JQq4JTJQ1tDgFP/xH2dXqvp4jbAWnlA=;
        b=RmgIofntqJBxbB2NSQAwYGxcjqzapGgewbxjKILKQYenodoE+oCkAPWQ9RHM2qL0cpjcnJ
        6SCn+1ImcrtSu69VOACk4XBVTkc0CX0NSWUqc/hsW7JjSPjlnmn29Z+l4WhD4RAOqYUZn7
        ZVKquqQNSqZncCaS0IcW4ytyKBEtnC8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-Zw8jKY_uOHefwrvFOR9lWg-1; Sun, 07 Feb 2021 11:20:31 -0500
X-MC-Unique: Zw8jKY_uOHefwrvFOR9lWg-1
Received: by mail-ed1-f72.google.com with SMTP id bd22so11804341edb.4
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 08:20:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FZqyDugOGOW0JQq4JTJQ1tDgFP/xH2dXqvp4jbAWnlA=;
        b=Lnz0zPa0N//vOHlu6VOYtVPmLJaNVMM3yPVHNVBgvcAVV2u1U1qou+ZERbHint/is7
         VrAOKhiybSltH/vjvYcJQZ83e+NpqrjRbejmuvZQvsaysW1TZWqDIfExKloR5AiAEU8k
         OEL2r8SGvcqHQYHgkPAIJqhfoW8jP/4n3gLuH+UshxrE+iy2V8v7YyGqQY0CVHKnpUnw
         Xyw3u9y5ot2cBLP3DdH/Qf3pDFCbQkQzoLQQumAqLUmjeTIPYGmdGHJV+Tuao+28wCOb
         IBp3C+7e0ZwEAD60myRtahVduFabi2OIjfVbSgjTqOa1/SzfCWi/7v915FzVmhj+GzvM
         DSPA==
X-Gm-Message-State: AOAM530sn2ZhtfAziKBMJb3ndCqdK9tthLI1vymWIvnCmHEzlBVrOFXX
        kPTKan/+ACwsvFvJ9syZ5QWPlQBeiq1Vms8uN2KDxBk9Uz50RPzmgOV5KR9s+4kBsIFMkgPnPS+
        zl3IgmlHoxr+yEvUh
X-Received: by 2002:aa7:cb0d:: with SMTP id s13mr13143852edt.221.1612714830407;
        Sun, 07 Feb 2021 08:20:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxSdcDNfe71ti67oDmkvTssos1+0OxTMKiTicFwRsqODDXrK/rf1JmpCvBGtLbnaWdb2ccmlQ==
X-Received: by 2002:aa7:cb0d:: with SMTP id s13mr13143828edt.221.1612714830149;
        Sun, 07 Feb 2021 08:20:30 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id w3sm7043867eja.52.2021.02.07.08.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 08:20:29 -0800 (PST)
Date:   Sun, 7 Feb 2021 11:20:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 00/17] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210207111954-mutt-send-email-mst@kernel.org>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 06:12:56PM +0300, Arseny Krasnov wrote:
> 	This patchset impelements support of SOCK_SEQPACKET for virtio
> transport.
> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
> do it, two new packet operations were added: first for start of record
>  and second to mark end of record(SEQ_BEGIN and SEQ_END later). Also,
> both operations carries metadata - to maintain boundaries and payload
> integrity. Metadata is introduced by adding special header with two
> fields - message count and message length:
> 
> 	struct virtio_vsock_seq_hdr {
> 		__le32  msg_cnt;
> 		__le32  msg_len;
> 	} __attribute__((packed));
> 
> 	This header is transmitted as payload of SEQ_BEGIN and SEQ_END
> packets(buffer of second virtio descriptor in chain) in the same way as
> data transmitted in RW packets. Payload was chosen as buffer for this
> header to avoid touching first virtio buffer which carries header of
> packet, because someone could check that size of this buffer is equal
> to size of packet header. To send record, packet with start marker is
> sent first(it's header contains length of record and counter), then
> counter is incremented and all data is sent as usual 'RW' packets and
> finally SEQ_END is sent(it also carries counter of message, which is
> counter of SEQ_BEGIN + 1), also after sedning SEQ_END counter is
> incremented again. On receiver's side, length of record is known from
> packet with start record marker. To check that no packets were dropped
> by transport, counters of two sequential SEQ_BEGIN and SEQ_END are
> checked(counter of SEQ_END must be bigger that counter of SEQ_BEGIN by
> 1) and length of data between two markers is compared to length in
> SEQ_BEGIN header.
> 	Now as  packets of one socket are not reordered neither on
> vsock nor on vhost transport layers, such markers allows to restore
> original record on receiver's side. If user's buffer is smaller that
> record length, when all out of size data is dropped.
> 	Maximum length of datagram is not limited as in stream socket,
> because same credit logic is used. Difference with stream socket is
> that user is not woken up until whole record is received or error
> occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
> 	Tests also implemented.
> 
>  Arseny Krasnov (17):
>   af_vsock: update functions for connectible socket
>   af_vsock: separate wait data loop
>   af_vsock: separate receive data loop
>   af_vsock: implement SEQPACKET receive loop
>   af_vsock: separate wait space loop
>   af_vsock: implement send logic for SEQPACKET
>   af_vsock: rest of SEQPACKET support
>   af_vsock: update comments for stream sockets
>   virtio/vsock: dequeue callback for SOCK_SEQPACKET
>   virtio/vsock: fetch length for SEQPACKET record
>   virtio/vsock: add SEQPACKET receive logic
>   virtio/vsock: rest of SOCK_SEQPACKET support
>   virtio/vsock: setup SEQPACKET ops for transport
>   vhost/vsock: setup SEQPACKET ops for transport
>   vsock_test: add SOCK_SEQPACKET tests
>   loopback/vsock: setup SEQPACKET ops for transport
>   virtio/vsock: simplify credit update function API
> 
>  drivers/vhost/vsock.c                   |   8 +-
>  include/linux/virtio_vsock.h            |  15 +
>  include/net/af_vsock.h                  |   9 +
>  include/uapi/linux/virtio_vsock.h       |  16 +
>  net/vmw_vsock/af_vsock.c                | 588 +++++++++++++++-------
>  net/vmw_vsock/virtio_transport.c        |   5 +
>  net/vmw_vsock/virtio_transport_common.c | 316 ++++++++++--
>  net/vmw_vsock/vsock_loopback.c          |   5 +
>  tools/testing/vsock/util.c              |  32 +-
>  tools/testing/vsock/util.h              |   3 +
>  tools/testing/vsock/vsock_test.c        | 126 +++++
>  11 files changed, 895 insertions(+), 228 deletions(-)
> 
>  TODO:
>  - What to do, when server doesn't support SOCK_SEQPACKET. In current
>    implementation RST is replied in the same way when listening port
>    is not found. I think that current RST is enough,because case when
>    server doesn't support SEQ_PACKET is same when listener missed(e.g.
>    no listener in both cases).

   - virtio spec patch

>  v3 -> v4:
>  - callbacks for loopback transport
>  - SEQPACKET specific metadata moved from packet header to payload
>    and called 'virtio_vsock_seq_hdr'
>  - record integrity check:
>    1) SEQ_END operation was added, which marks end of record.
>    2) Both SEQ_BEGIN and SEQ_END carries counter which is incremented
>       on every marker send.
>  - af_vsock.c: socket operations for STREAM and SEQPACKET call same
>    functions instead of having own "gates" differs only by names:
>    'vsock_seqpacket/stream_getsockopt()' now replaced with
>    'vsock_connectible_getsockopt()'.
>  - af_vsock.c: 'seqpacket_dequeue' callback returns error and flag that
>    record ready. There is no need to return number of copied bytes,
>    because case when record received successfully is checked at virtio
>    transport layer, when SEQ_END is processed. Also user doesn't need
>    number of copied bytes, because 'recv()' from SEQPACKET could return
>    error, length of users's buffer or length of whole record(both are
>    known in af_vsock.c).
>  - af_vsock.c: both wait loops in af_vsock.c(for data and space) moved
>    to separate functions because now both called from several places.
>  - af_vsock.c: 'vsock_assign_transport()' checks that 'new_transport'
>    pointer is not NULL and returns 'ESOCKTNOSUPPORT' instead of 'ENODEV'
>    if failed to use transport.
>  - tools/testing/vsock/vsock_test.c: rename tests
> 
>  v2 -> v3:
>  - patches reorganized: split for prepare and implementation patches
>  - local variables are declared in "Reverse Christmas tree" manner
>  - virtio_transport_common.c: valid leXX_to_cpu() for vsock header
>    fields access
>  - af_vsock.c: 'vsock_connectible_*sockopt()' added as shared code
>    between stream and seqpacket sockets.
>  - af_vsock.c: loops in '__vsock_*_recvmsg()' refactored.
>  - af_vsock.c: 'vsock_wait_data()' refactored.
> 
>  v1 -> v2:
>  - patches reordered: af_vsock.c related changes now before virtio vsock
>  - patches reorganized: more small patches, where +/- are not mixed
>  - tests for SOCK_SEQPACKET added
>  - all commit messages updated
>  - af_vsock.c: 'vsock_pre_recv_check()' inlined to
>    'vsock_connectible_recvmsg()'
>  - af_vsock.c: 'vsock_assign_transport()' returns ENODEV if transport
>    was not found
>  - virtio_transport_common.c: transport callback for seqpacket dequeue
>  - virtio_transport_common.c: simplified
>    'virtio_transport_recv_connected()'
>  - virtio_transport_common.c: send reset on socket and packet type
> 			      mismatch.
> 
> -- 
> 2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE30303C72
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392426AbhAZMFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:05:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28441 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392267AbhAZLZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 06:25:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611660218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JTt2fKtk93GppUvATa0pV3yHgt515EpEGR8mjlKiGYA=;
        b=VSnJZTk5M1/GEEnUBMNtfaCYhFXJ4wRStZIsEm0Jthn90ArDzupO1CnaQdg2F/SYD90Yrx
        SukZiLA93awC0TzL8/vWB0j8LqDOZl8YWx3fGyuj36WGuoK7TsGoNJNMjtTjP9Rr2EmIG5
        oqd/OECL/zS11RNXsriwRKDHITg7nBk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-j-pjGugXOfi5M4Xo2BDE1g-1; Tue, 26 Jan 2021 06:23:37 -0500
X-MC-Unique: j-pjGugXOfi5M4Xo2BDE1g-1
Received: by mail-ed1-f72.google.com with SMTP id ck25so9173141edb.16
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 03:23:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JTt2fKtk93GppUvATa0pV3yHgt515EpEGR8mjlKiGYA=;
        b=JmM9eMlfb/6ngo7PqQgK1HvHUVv4ByOkB9PWzR7A23rGSGuduQfCSoDnFhOCdv1s3B
         7yg7Ohh0LNuxo2N2dH2OvZ9eXnaEVBVZxRneoWEGORMRUgadXlwD7vgjY0bWb2ibLtYV
         BeQFIVDB7eatC/V2nCAnBXar/oGK1UGm2xOmNxcCStM/MtWidvp6AfcbBkuSA0/uBepV
         vOmyjQadN25AEF3JKW8jjVLvwbe+YAM4DkqC730R7wgyqKeZ4A/yNmU7d/4RLML6Q1S/
         OFPQcruBOrFOuSvS4apUV2LuNkGn9tFy/avxBPYzu1ie3jgdZ0QShTkhqmXv8gYLjfgN
         qlhw==
X-Gm-Message-State: AOAM530GPST/LEazppSUPGTQXNkMPXEBL10pYelCvqlUxGxw9SaQvjLX
        ucmi+4U+AlAKbPUBjVvQJ4CgfGYgGnYt/JbE/8bxB8/vQO52Y0Zbf0jb7XsRAw0VrNC5Tf5nG2s
        P5Xa93//q7YDMeHY7
X-Received: by 2002:a17:906:ae42:: with SMTP id lf2mr2986699ejb.487.1611660215814;
        Tue, 26 Jan 2021 03:23:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxaADKffvaOLAwo/NSoh7H/haFhO7LTo/Xzq1n4nH+wZ/VXL/AKBofvf7/ECClCE+fB2NwxOg==
X-Received: by 2002:a17:906:ae42:: with SMTP id lf2mr2986681ejb.487.1611660215554;
        Tue, 26 Jan 2021 03:23:35 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id da26sm12273587edb.36.2021.01.26.03.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:23:34 -0800 (PST)
Date:   Tue, 26 Jan 2021 12:23:32 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 00/13] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210126112332.bykmpexzcri7xi2j@steredhat>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,
thanks for this new series!
I'm a bit busy but I hope to review it tomorrow or on Thursday.

Stefano

On Mon, Jan 25, 2021 at 02:09:00PM +0300, Arseny Krasnov wrote:
>	This patchset impelements support of SOCK_SEQPACKET for virtio
>transport.
>	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>do it, new packet operation was added: it marks start of record (with
>record length in header), such packet doesn't carry any data.  To send
>record, packet with start marker is sent first, then all data is sent
>as usual 'RW' packets. On receiver's side, length of record is known
>from packet with start record marker. Now as  packets of one socket
>are not reordered neither on vsock nor on vhost transport layers, such
>marker allows to restore original record on receiver's side. If user's
>buffer is smaller that record length, when all out of size data is
>dropped.
>	Maximum length of datagram is not limited as in stream socket,
>because same credit logic is used. Difference with stream socket is
>that user is not woken up until whole record is received or error
>occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>	Tests also implemented.
>
> Arseny Krasnov (13):
>  af_vsock: prepare for SOCK_SEQPACKET support
>  af_vsock: prepare 'vsock_connectible_recvmsg()'
>  af_vsock: implement SEQPACKET rx loop
>  af_vsock: implement send logic for SOCK_SEQPACKET
>  af_vsock: rest of SEQPACKET support
>  af_vsock: update comments for stream sockets
>  virtio/vsock: dequeue callback for SOCK_SEQPACKET
>  virtio/vsock: fetch length for SEQPACKET record
>  virtio/vsock: add SEQPACKET receive logic
>  virtio/vsock: rest of SOCK_SEQPACKET support
>  virtio/vsock: setup SEQPACKET ops for transport
>  vhost/vsock: setup SEQPACKET ops for transport
>  vsock_test: add SOCK_SEQPACKET tests
>
> drivers/vhost/vsock.c                   |   7 +-
> include/linux/virtio_vsock.h            |  12 +
> include/net/af_vsock.h                  |   6 +
> include/uapi/linux/virtio_vsock.h       |   9 +
> net/vmw_vsock/af_vsock.c                | 543 ++++++++++++++++------
> net/vmw_vsock/virtio_transport.c        |   4 +
> net/vmw_vsock/virtio_transport_common.c | 295 ++++++++++--
> tools/testing/vsock/util.c              |  32 +-
> tools/testing/vsock/util.h              |   3 +
> tools/testing/vsock/vsock_test.c        | 126 +++++
> 10 files changed, 862 insertions(+), 175 deletions(-)
>
> TODO:
> - Support for record integrity control. As transport could drop some
>   packets, something like "record-id" and record end marker need to
>   be implemented. Idea is that SEQ_BEGIN packet carries both record
>   length and record id, end marker(let it be SEQ_END) carries only
>   record id. To be sure that no one packet was lost, receiver checks
>   length of data between SEQ_BEGIN and SEQ_END(it must be same with
>   value in SEQ_BEGIN) and record ids of SEQ_BEGIN and SEQ_END(this
>   means that both markers were not dropped. I think that easiest way
>   to implement record id for SEQ_BEGIN is to reuse another field of
>   packet header(SEQ_BEGIN already uses 'flags' as record length).For
>   SEQ_END record id could be stored in 'flags'.
>     Another way to implement it, is to move metadata of both SEQ_END
>   and SEQ_BEGIN to payload. But this approach has problem, because
>   if we move something to payload, such payload is accounted by
>   credit logic, which fragments payload, while payload with record
>   length and id couldn't be fragmented. One way to overcome it is to
>   ignore credit update for SEQ_BEGIN/SEQ_END packet.Another solution
>   is to update 'stream_has_space()' function: current implementation
>   return non-zero when at least 1 byte is allowed to use,but updated
>   version will have extra argument, which is needed length. For 'RW'
>   packet this argument is 1, for SEQ_BEGIN it is sizeof(record len +
>   record id) and for SEQ_END it is sizeof(record id).
>
> - What to do, when server doesn't support SOCK_SEQPACKET. In current
>   implementation RST is replied in the same way when listening port
>   is not found. I think that current RST is enough,because case when
>   server doesn't support SEQ_PACKET is same when listener missed(e.g.
>   no listener in both cases).
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5F0307C38
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 18:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhA1RWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 12:22:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233082AbhA1RU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 12:20:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611854369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C3eK8ADi3ZeyPV4PVYDApesK2wmgAogV+vFpEBdBI34=;
        b=CAtd+js9CWodlUPuJWsWLEuPaL8j6f8WnxHTYmAPvV+YsmYl1tSbThMwsE8+ArO0+Sn0Q3
        n9MQa+LBrsfKa8TFOyst2u108bIxqDL8hI30YC+3FyIeVXUukG/ejqILeURJmhv93eEeO4
        V76ZYmFcZTrlPVsJ0b0i1OpdxiLQ51s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-7ajlSI19NsyVAZpedeeHvQ-1; Thu, 28 Jan 2021 12:19:27 -0500
X-MC-Unique: 7ajlSI19NsyVAZpedeeHvQ-1
Received: by mail-wm1-f69.google.com with SMTP id f65so2472170wmf.2
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 09:19:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C3eK8ADi3ZeyPV4PVYDApesK2wmgAogV+vFpEBdBI34=;
        b=L82iKMFpXRxfxciOSbJg5a0HbGDHJqKfPX9dpOyAdJR7hOfyNfprDitNRO+gctbrBY
         UzCIlUMHD2UGhbR4kvu1tPV9T9ZIrcFeMEeC9lbOHtOpB+Q8ZAeKrE/iDiKEVsFcoWVG
         NiCpf8/xXfZ/41Q/8WLvxWztOct4MdJoLW8yJozqclDhMKeI/2QgOEiCOQKnIMjSedLJ
         aeCxIMAGZ6CRzdp4QhxTn9GLKxMX4efJSKTFg8OEB5yfBc7lOY4/PxICwLud3rc8C3P5
         4lGG3qI0R4xOibAkHjiMoae6zlRl52Vj6NscUn6f3U2HM/VrHC1VFjuUPi8x3J1BcBpd
         p9qQ==
X-Gm-Message-State: AOAM531hj6BLtcOreFNGwT3JmeOvcg/WjMbzMHQWKxE6k637nYt8Rj+9
        4yXykmCSSvBoGr8vzAECoInTRzLLzmfQ3cvS/zHIReDBoWHuc7BqL1JEgfpKy42GQ1yMAqgbwfH
        cPmhvkcy/TF9qGWg+
X-Received: by 2002:adf:ee43:: with SMTP id w3mr132408wro.200.1611854366590;
        Thu, 28 Jan 2021 09:19:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/v8ANcRwlI8G7EsFYD8nauxfmP7TArGJygNoYeVZtqgy5WGQaFyFb7Is20oZGBeCQYNOxTA==
X-Received: by 2002:adf:ee43:: with SMTP id w3mr132383wro.200.1611854366394;
        Thu, 28 Jan 2021 09:19:26 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id y18sm7666251wrt.19.2021.01.28.09.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 09:19:25 -0800 (PST)
Date:   Thu, 28 Jan 2021 18:19:23 +0100
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
Message-ID: <20210128171923.esyna5ccv5s27jyu@steredhat>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,
I reviewed a part, tomorrow I hope to finish the other patches.

Just a couple of comments in the TODOs below.

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

I don't really like the idea of reusing the 'flags' field for this 
purpose.

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

Is the payload accounted by credit logic also if hdr.op is not 
VIRTIO_VSOCK_OP_RW?

I think that we can define a specific header to put after the 
virtio_vsock_hdr when hdr.op is SEQ_BEGIN or SEQ_END, and in this header 
we can store the id and the length of the message.

>
> - What to do, when server doesn't support SOCK_SEQPACKET. In current
>   implementation RST is replied in the same way when listening port
>   is not found. I think that current RST is enough,because case when
>   server doesn't support SEQ_PACKET is same when listener missed(e.g.
>   no listener in both cases).

I think so, but I'll check better if we can have some issues.

Thanks,
Stefano

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


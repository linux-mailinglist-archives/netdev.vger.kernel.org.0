Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FEBD426F
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfJKOL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:11:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbfJKOL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 10:11:27 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A48C37FDFC
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 14:11:26 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id r19so9518954qtk.15
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:11:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/5+qfTpOpKieneBL3zVg4rgG1HjlGzu1pbBmw0jwKqY=;
        b=ONsFdAmY7KrOedP1DxlUjczQaUwB/UDF6ujnMEPDUfKuZSdDfE7DBlaSPL4PdOGwji
         dP7vtF2AnMtbEtpEvwawq9y1OwgdL4GvRfYIncofYnueovovA/xvKsnXa/NgIG1xjfBB
         MKrI1hZvx+HQz5rU3Z8yaQ+mTuPLb49ZjIDYAXss5Ch39uMkztdzM74AGrK1q0atArC2
         TXGDxEr8xlPBfxFVKxvLAskZtZS9Z/XG6r2qAXT16gtiV+rSchHtNVgdmCplSmd9+Sud
         3NKgvP3SIt7dwztAek67fZJV15GcWLjGQpsLaoh1oxns4rwmhqaKym4hHRR9ip2KJhAj
         8PiQ==
X-Gm-Message-State: APjAAAVYxcLtTxvV10aZsmstR+35GOcAjVOex8E/VBpY2Wugs1JYVu0M
        uyWVb+x2sbJqDq1Jw63x4kYM45fhx1A9MCqDf0K7AXKU7twL6lmE60q5P606Y0E2AQKyXKmHRVy
        5U6u9PdV7Tt4t6NeH
X-Received: by 2002:a0c:e6a6:: with SMTP id j6mr15931240qvn.74.1570803085771;
        Fri, 11 Oct 2019 07:11:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwzI22/2EpzWkNXVdGjCf2ULJJgnXoU6L3SXRMDWJixRY0RDFTe3D6KiXivotXW43C6OuJT0w==
X-Received: by 2002:a0c:e6a6:: with SMTP id j6mr15931202qvn.74.1570803085424;
        Fri, 11 Oct 2019 07:11:25 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id b16sm5376769qtk.65.2019.10.11.07.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 07:11:24 -0700 (PDT)
Date:   Fri, 11 Oct 2019 10:11:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20191011100826-mutt-send-email-mst@kernel.org>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org>
 <20190830094059.c7qo5cxrp2nkrncd@steredhat>
 <20190901024525-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fA5UtkuMQbOHHy0noOGZUtpepBNKFg5afD81bynMVUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F7fA5UtkuMQbOHHy0noOGZUtpepBNKFg5afD81bynMVUQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 03:40:48PM +0200, Stefano Garzarella wrote:
> On Sun, Sep 1, 2019 at 8:56 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Fri, Aug 30, 2019 at 11:40:59AM +0200, Stefano Garzarella wrote:
> > > On Mon, Jul 29, 2019 at 10:04:29AM -0400, Michael S. Tsirkin wrote:
> > > > On Wed, Jul 17, 2019 at 01:30:26PM +0200, Stefano Garzarella wrote:
> > > > > Since virtio-vsock was introduced, the buffers filled by the host
> > > > > and pushed to the guest using the vring, are directly queued in
> > > > > a per-socket list. These buffers are preallocated by the guest
> > > > > with a fixed size (4 KB).
> > > > >
> > > > > The maximum amount of memory used by each socket should be
> > > > > controlled by the credit mechanism.
> > > > > The default credit available per-socket is 256 KB, but if we use
> > > > > only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> > > > > buffers, using up to 1 GB of memory per-socket. In addition, the
> > > > > guest will continue to fill the vring with new 4 KB free buffers
> > > > > to avoid starvation of other sockets.
> > > > >
> > > > > This patch mitigates this issue copying the payload of small
> > > > > packets (< 128 bytes) into the buffer of last packet queued, in
> > > > > order to avoid wasting memory.
> > > > >
> > > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > >
> > > > This is good enough for net-next, but for net I think we
> > > > should figure out how to address the issue completely.
> > > > Can we make the accounting precise? What happens to
> > > > performance if we do?
> > > >
> > >
> > > Since I'm back from holidays, I'm restarting this thread to figure out
> > > how to address the issue completely.
> > >
> > > I did a better analysis of the credit mechanism that we implemented in
> > > virtio-vsock to get a clearer view and I'd share it with you:
> > >
> > >     This issue affect only the "host->guest" path. In this case, when the
> > >     host wants to send a packet to the guest, it uses a "free" buffer
> > >     allocated by the guest (4KB).
> > >     The "free" buffers available for the host are shared between all
> > >     sockets, instead, the credit mechanism is per-socket, I think to
> > >     avoid the starvation of others sockets.
> > >     The guests re-fill the "free" queue when the available buffers are
> > >     less than half.
> > >
> > >     Each peer have these variables in the per-socket state:
> > >        /* local vars */
> > >        buf_alloc        /* max bytes usable by this socket
> > >                            [exposed to the other peer] */
> > >        fwd_cnt          /* increased when RX packet is consumed by the
> > >                            user space [exposed to the other peer] */
> > >        tx_cnt                 /* increased when TX packet is sent to the other peer */
> > >
> > >        /* remote vars  */
> > >        peer_buf_alloc   /* peer's buf_alloc */
> > >        peer_fwd_cnt     /* peer's fwd_cnt */
> > >
> > >     When a peer sends a packet, it increases the 'tx_cnt'; when the
> > >     receiver consumes the packet (copy it to the user-space buffer), it
> > >     increases the 'fwd_cnt'.
> > >     Note: increments are made considering the payload length and not the
> > >     buffer length.
> > >
> > >     The value of 'buf_alloc' and 'fwd_cnt' are sent to the other peer in
> > >     all packet headers or with an explicit CREDIT_UPDATE packet.
> > >
> > >     The local 'buf_alloc' value can be modified by the user space using
> > >     setsockopt() with optname=SO_VM_SOCKETS_BUFFER_SIZE.
> > >
> > >     Before to send a packet, the peer checks the space available:
> > >       credit_available = peer_buf_alloc - (tx_cnt - peer_fwd_cnt)
> > >     and it will send up to credit_available bytes to the other peer.
> > >
> > > Possible solutions considering Michael's advice:
> > > 1. Use the buffer length instead of the payload length when we increment
> > >    the counters:
> > >   - This approach will account precisely the memory used per socket.
> > >   - This requires changes in both guest and host.
> > >   - It is not compatible with old drivers, so a feature should be negotiated.
> > > 2. Decrease the advertised 'buf_alloc' taking count of bytes queued in
> > >    the socket queue but not used. (e.g. 256 byte used on 4K available in
> > >    the buffer)
> > >   - pkt->hdr.buf_alloc = buf_alloc - bytes_not_used.
> > >   - This should be compatible also with old drivers.
> > >
> > > Maybe the second is less invasive, but will it be too tricky?
> > > Any other advice or suggestions?
> > >
> > > Thanks in advance,
> > > Stefano
> >
> > OK let me try to clarify.  The idea is this:
> >
> > Let's say we queue a buffer of 4K, and we copy if len < 128 bytes.  This
> > means that in the worst case (128 byte packets), each byte of credit in
> > the socket uses up 4K/128 = 16 bytes of kernel memory. In fact we need
> > to also account for the virtio_vsock_pkt since I think it's kept around
> > until userspace consumes it.
> >
> > Thus given X buf alloc allowed in the socket, we should publish X/16
> > credits to the other side. This will ensure the other side does not send
> > more than X/16 bytes for a given socket and thus we won't need to
> > allocate more than X bytes to hold the data.
> >
> > We can play with the copy break value to tweak this.
> >
> 
> Hi Michael,
> sorry for the long silence, but I focused on multi-transport.
> 
> Before to implement your idea, I tried to do some calculations and
> looking better to our credit mechanism:
> 
>   buf_alloc = 256 KB (default, tunable through setsockopt)
>   sizeof(struct virtio_vsock_pkt) = 128
> 
>   - guest (we use preallocated 4 KB buffers to receive packets, copying
>     small packet - < 128 -)
>     worst_case = 129
>     buf_size = 4 KB
>     credit2mem = (buf_size + sizeof(struct virtio_vsock_pkt)) / worst_case = 32

Making virtio_vsock_pkt smaller will help btw.
E.g. why keep a work struct per packet? do we need the header there? etc
etc.

> 
>     credit_published = buf_alloc / credit2mem = ~8 KB
>     Space for just 2 full packet (4 KB)
> 
>   - host (we copy packets from the vring, allocating the space for the payload)
>     worst_case = 1
>     buf_size = 1
>     credit2mem = (buf_size + sizeof(struct virtio_vsock_pkt)) / worst_case = 129
> 
>     credit_published = buf_alloc / credit2mem = ~2 KB
>     Less than a full packet (guest now can send up to 64 KB with a single
>     packet, so it will be limited to 2 KB)

1 byte in struct virtio_vsock_pkt is crazy. Can't we copy
like we do in the guest? E.g. allocate at least 128 bytes,
and then we can add data to the tail of the last packet?

> Current memory consumption in the worst case if the RX queue is full:
>   - guest
>     mem = (buf_alloc / worst_case) *
>           (buf_size + sizeof(struct virtio_vsock_pkt) = ~8MB
> 
>   - host
>     mem = (buf_alloc / worst_case) *
>           (buf_size + sizeof(struct virtio_vsock_pkt) = ~32MB
> 
> I think that the performance with big packets will be affected,
> but I still have to try.
> 
> Another approach that I want to explore is to play with buf_alloc
> published to the peer.
> 
> One thing that's not clear to me yet is the meaning of
> SO_VM_SOCKETS_BUFFER_SIZE:
> - max amount of memory used in the RX queue
> - max amount of payload bytes in the RX queue (without overhead of
>   struct virtio_vsock_pkt + preallocated buffer)
> 
> >From the 'include/uapi/linux/vm_sockets.h':
>     /* Option name for STREAM socket buffer size.  Use as the option name in
>      * setsockopt(3) or getsockopt(3) to set or get an unsigned long long that
>      * specifies the size of the buffer underlying a vSockets STREAM socket.
>      * Value is clamped to the MIN and MAX.
>      */
> 
>     #define SO_VM_SOCKETS_BUFFER_SIZE 0
> 
> Regardless, I think we need to limit memory consumption in some way.
> I'll check the implementation of other transports, to understand better.
> 
> I'll keep you updated!
> 
> Thanks,
> Stefano

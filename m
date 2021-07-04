Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930EB3BAC9A
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 11:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhGDJ5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 05:57:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229476AbhGDJ5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 05:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625392476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VYPXgNYdb3c09oXqHPIxazq2MDtMHdph5d1ic1D1Bi8=;
        b=hu4Qn8oQ7Vk9HRFIRoKRhWEcu57eAc2nYE/E571CyiU7FQLtGxU1W87flSGDIdB4ikLDlE
        YXHbC3RZ7U3IWUTi64ELM0xGm3f1cn+nZEGMSHXOXQ+u8r8KV1REzDnf1dI1W+RjmifL17
        umvRdSQobi1XqxqUlvHGoDvUlVAGXHU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-agATpNooNAaffMiOoXz7vw-1; Sun, 04 Jul 2021 05:54:35 -0400
X-MC-Unique: agATpNooNAaffMiOoXz7vw-1
Received: by mail-wr1-f71.google.com with SMTP id g4-20020a5d64e40000b029013398ce8904so755560wri.16
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 02:54:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VYPXgNYdb3c09oXqHPIxazq2MDtMHdph5d1ic1D1Bi8=;
        b=AfmAaidHudthztwK3ta5yGm8rIjQRAyPWc/RwPsN0ZI2c+RLFEWgUSZZudUd9P2N4h
         eLFL8WsAmkicZ3x/ikCQct5rGUC2plRL0yuVtsKCYWC2PONPi27Z6ZUkhyMY+umXq5PI
         EqMxYkf6LjOVhOZNVFcxG5F0xUCNgniryIGcgNmVpXNlrb88bksfoqLwIys/2WNAkxhW
         hXiPPFAx1AOYo8FByTaoFeZFVXmzsc5ZB/3LgTzldW7FH802bwGiTYNaPB0ket7f4Xu2
         mou8aHRAmjV02kRjvq9c73FVM8QRJPzJXvrlf8HnvIqO6nAVT//4C3nRLIt/GfSVmQUd
         g2uw==
X-Gm-Message-State: AOAM530TOsi05b+R9jHOkKVuStAYT9oBZYc1VGMJ1TkrB2EPddv0v/Dd
        hwhsSj6/QUS54ZMmNAIpLV3d1sDABHawFllqLR4JAboYbaiQb3cmOXiRhjJWRV1Mh7L6xcJr3EY
        nNwAOYCLMrkSGvIY1
X-Received: by 2002:a7b:c8d9:: with SMTP id f25mr8743148wml.153.1625392474431;
        Sun, 04 Jul 2021 02:54:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWmhMPJZJ9uEg3kxS9p3QQw859N5k7H/UO+tCXIvTNNDhdZj57iiThsIDoBtYfE9gIxTqrUg==
X-Received: by 2002:a7b:c8d9:: with SMTP id f25mr8743122wml.153.1625392474177;
        Sun, 04 Jul 2021 02:54:34 -0700 (PDT)
Received: from redhat.com ([2.55.4.39])
        by smtp.gmail.com with ESMTPSA id c12sm10458200wrr.90.2021.07.04.02.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 02:54:33 -0700 (PDT)
Date:   Sun, 4 Jul 2021 05:54:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v2 0/6] Improve SOCK_SEQPACKET receive logic
Message-ID: <20210704055037-mutt-send-email-mst@kernel.org>
References: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
 <20210704042843-mutt-send-email-mst@kernel.org>
 <b427dee7-5c1b-9686-9004-05fa05d45b28@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b427dee7-5c1b-9686-9004-05fa05d45b28@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 04, 2021 at 12:23:03PM +0300, Arseny Krasnov wrote:
> 
> On 04.07.2021 11:30, Michael S. Tsirkin wrote:
> > On Sun, Jul 04, 2021 at 11:08:13AM +0300, Arseny Krasnov wrote:
> >> 	This patchset modifies receive logic for SOCK_SEQPACKET.
> >> Difference between current implementation and this version is that
> >> now reader is woken up when there is at least one RW packet in rx
> >> queue of socket and data is copied to user's buffer, while merged
> >> approach wake up user only when whole message is received and kept
> >> in queue. New implementation has several advantages:
> >>  1) There is no limit for message length. Merged approach requires
> >>     that length must be smaller than 'peer_buf_alloc', otherwise
> >>     transmission will stuck.
> >>  2) There is no need to keep whole message in queue, thus no
> >>     'kmalloc()' memory will be wasted until EOR is received.
> >>
> >>     Also new approach has some feature: as fragments of message
> >> are copied until EOR is received, it is possible that part of
> >> message will be already in user's buffer, while rest of message
> >> still not received. And if user will be interrupted by signal or
> >> timeout with part of message in buffer, it will exit receive loop,
> >> leaving rest of message in queue. To solve this problem special
> >> callback was added to transport: it is called when user was forced
> >> to leave exit loop and tells transport to drop any packet until
> >> EOR met.
> > Sorry about commenting late in the game.  I'm a bit lost
> >
> >
> > SOCK_SEQPACKET
> > Provides sequenced, reliable, bidirectional, connection-mode transmission paths for records. A record can be sent using one or more output operations and received using one or more input operations, but a single operation never transfers part of more than one record. Record boundaries are visible to the receiver via the MSG_EOR flag.
> >
> > it's supposed to be reliable - how is it legal to drop packets?
> 
> Sorry, seems i need to rephrase description. "Packet" here means fragment of record(message) at transport
> 
> layer. As this is SEQPACKET mode, receiver could get only whole message or error, so if only several fragments
> 
> of message was copied (if signal received for example) we can't return it to user - it breaks SEQPACKET sense. I think,
> 
> in this case we can drop rest of record's fragments legally.
> 
> 
> Thank You

Would not that violate the reliable property? IIUC it's only ok to
return an error if socket gets closed. Just like e.g. TCP ...



> >
> >
> >> When EOR is found, this mode is disabled and normal packet
> >> processing started. Note, that when 'drop until EOR' mode is on,
> >> incoming packets still inserted in queue, reader will be woken up,
> >> tries to copy data, but nothing will be copied until EOR found.
> >> It was possible to drain such unneeded packets it rx work without
> >> kicking user, but implemented way is simplest. Anyway, i think
> >> such cases are rare.
> >
> >>     New test also added - it tries to copy to invalid user's
> >> buffer.
> >>
> >> Arseny Krasnov (16):
> >>  af_vsock/virtio/vsock: change seqpacket receive logic
> >>  af_vsock/virtio/vsock: remove 'seqpacket_has_data' callback
> >>  virtio/vsock: remove 'msg_count' based logic
> >>  af_vsock/virtio/vsock: add 'seqpacket_drop()' callback
> >>  virtio/vsock: remove record size limit for SEQPACKET
> >>  vsock_test: SEQPACKET read to broken buffer
> >>
> >>  drivers/vhost/vsock.c                   |   2 +-
> >>  include/linux/virtio_vsock.h            |   7 +-
> >>  include/net/af_vsock.h                  |   4 +-
> >>  net/vmw_vsock/af_vsock.c                |  44 ++++----
> >>  net/vmw_vsock/virtio_transport.c        |   2 +-
> >>  net/vmw_vsock/virtio_transport_common.c | 103 ++++++++-----------
> >>  net/vmw_vsock/vsock_loopback.c          |   2 +-
> >>  tools/testing/vsock/vsock_test.c        | 120 ++++++++++++++++++++++
> >>  8 files changed, 193 insertions(+), 91 deletions(-)
> >>
> >>  v1 -> v2:
> >>  Patches reordered and reorganized.
> >>
> >> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> >> ---
> >>  cv.txt | 0
> >>  1 file changed, 0 insertions(+), 0 deletions(-)
> >>  create mode 100644 cv.txt
> >>
> >> diff --git a/cv.txt b/cv.txt
> >> new file mode 100644
> >> index 000000000000..e69de29bb2d1
> >> -- 
> >> 2.25.1
> >


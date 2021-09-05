Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65EB4010D4
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 18:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbhIEQVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 12:21:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236953AbhIEQVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 12:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630858805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fRYy/Eng/PbQ0NSsRYCZUyszyBEgStXzxFIIt91qQHo=;
        b=heZdJzgD3BrUIpx8eem0SyBrQQO3sKqK/N6U8z/HjWJr8G1RKdj7iP1SpYXX+ZiDtokflE
        LB5jLvdgfGcq30jJ+p3CDalc7wDrpx7bby0Zh+XIz17WCPbIuJSSh9iNkM55w8LlUcpFfj
        yAW/ZuMAmZNhxZHbgaLPp/XeJa0axH4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-vO5D3eO_ODazWuw4PygP9g-1; Sun, 05 Sep 2021 12:20:04 -0400
X-MC-Unique: vO5D3eO_ODazWuw4PygP9g-1
Received: by mail-ed1-f71.google.com with SMTP id j13-20020aa7ca4d000000b003c44c679d73so2458848edt.8
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 09:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fRYy/Eng/PbQ0NSsRYCZUyszyBEgStXzxFIIt91qQHo=;
        b=Emic7fd46qol/2FzUPxf3SX0b8y+Rz/dMOvFxfgSHcyIxgrcKwtpxUtZx0E4XA3tCH
         +UFIDVxwuv6YtjCJwV5dKbfLfVKK+x0e1hrK+EWocUEjn10c3+fiAIxUNcEQDVAgcVIv
         8028XcGclorII6uYIjnGNAL7aBhqMS/Io/GmE+RTz5gltqlhs+3oC06OdN5Oe9IBz567
         2CdcNt95Fw1dNMxOpSExoc+CLapqQfJ+jIOnvRw1m+OzswkF3avl3FLGNwQpvS8NCO5U
         0zjNHccCEsSU4nnO9OBGR6jpXgSvWcgkbyEAfR+8yIsnHEPRJL5mjXLKJdQYc21mQgZU
         C7Zw==
X-Gm-Message-State: AOAM5313kUxC/STAYg4pjcW5TwrK20LJ4Y9X7kJ+KhaP8FrozqLo0+rg
        EvCv+InUWxYSOVKtFlhvWQtdCYKhQI4FPYiN19uqfS+u3wq65K+wCFTfMXd5gjmLpiKjVKqayaN
        m1+NlbYv9n4Wwqvl1
X-Received: by 2002:a17:906:30d6:: with SMTP id b22mr9793539ejb.442.1630858803353;
        Sun, 05 Sep 2021 09:20:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVBWPaYK4Y1+X8g7dGzoXkW4iRhsvR8rCJkBiSFUcTsOQuYVNyMbcLxv2SeJyTzVoQEN3QEA==
X-Received: by 2002:a17:906:30d6:: with SMTP id b22mr9793515ejb.442.1630858803086;
        Sun, 05 Sep 2021 09:20:03 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id w3sm3049714edc.42.2021.09.05.09.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 09:20:00 -0700 (PDT)
Date:   Sun, 5 Sep 2021 12:19:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [PATCH net-next v5 0/6] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
Message-ID: <20210905121932-mutt-send-email-mst@kernel.org>
References: <20210903123016.3272800-1-arseny.krasnov@kaspersky.com>
 <20210905115139-mutt-send-email-mst@kernel.org>
 <4558e96b-6330-667f-955b-b689986f884f@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4558e96b-6330-667f-955b-b689986f884f@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 07:02:44PM +0300, Arseny Krasnov wrote:
> 
> On 05.09.2021 18:55, Michael S. Tsirkin wrote:
> > On Fri, Sep 03, 2021 at 03:30:13PM +0300, Arseny Krasnov wrote:
> >> 	This patchset implements support of MSG_EOR bit for SEQPACKET
> >> AF_VSOCK sockets over virtio transport.
> >> 	First we need to define 'messages' and 'records' like this:
> >> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
> >> etc. It has fixed maximum length, and it bounds are visible using
> >> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
> >> Current implementation based on message definition above.
> >> 	Record has unlimited length, it consists of multiple message,
> >> and bounds of record are visible via MSG_EOR flag returned from
> >> 'recvmsg()' call. Sender passes MSG_EOR to sending system call and
> >> receiver will see MSG_EOR when corresponding message will be processed.
> >> 	Idea of patchset comes from POSIX: it says that SEQPACKET
> >> supports record boundaries which are visible for receiver using
> >> MSG_EOR bit. So, it looks like MSG_EOR is enough thing for SEQPACKET
> >> and we don't need to maintain boundaries of corresponding send -
> >> receive system calls. But, for 'sendXXX()' and 'recXXX()' POSIX says,
> >> that all these calls operates with messages, e.g. 'sendXXX()' sends
> >> message, while 'recXXX()' reads messages and for SEQPACKET, 'recXXX()'
> >> must read one entire message from socket, dropping all out of size
> >> bytes. Thus, both message boundaries and MSG_EOR bit must be supported
> >> to follow POSIX rules.
> >> 	To support MSG_EOR new bit was added along with existing
> >> 'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
> >> works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
> >> is used to mark 'MSG_EOR' bit passed from userspace.
> >> 	This patchset includes simple test for MSG_EOR.
> >
> > I'm prepared to merge this for this window,
> > but I'm not sure who's supposed to ack the net/vmw_vsock/af_vsock.c
> > bits. It's a harmless variable renaming so maybe it does not matter.
> >
> > The rest is virtio stuff so I guess my tree is ok.
> >
> > Objections, anyone?
> 
> https://lkml.org/lkml/2021/9/3/76 this is v4. It is same as v5 in af_vsock.c changes.
> 
> It has Reviewed by from Stefano Garzarella.

Is Stefano the maintainer for af_vsock then?
I wasn't sure.

> >
> >
> >>  Arseny Krasnov(6):
> >>   virtio/vsock: rename 'EOR' to 'EOM' bit.
> >>   virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR' bit.
> >>   vhost/vsock: support MSG_EOR bit processing
> >>   virtio/vsock: support MSG_EOR bit processing
> >>   af_vsock: rename variables in receive loop
> >>   vsock_test: update message bounds test for MSG_EOR
> >>
> >>  drivers/vhost/vsock.c                   | 28 +++++++++++++----------
> >>  include/uapi/linux/virtio_vsock.h       |  3 ++-
> >>  net/vmw_vsock/af_vsock.c                | 10 ++++----
> >>  net/vmw_vsock/virtio_transport_common.c | 23 ++++++++++++-------
> >>  tools/testing/vsock/vsock_test.c        |  8 ++++++-
> >>  5 files changed, 45 insertions(+), 27 deletions(-)
> >>
> >>  v4 -> v5:
> >>  - Move bitwise and out of le32_to_cpu() in 0003.
> >>
> >>  v3 -> v4:
> >>  - 'sendXXX()' renamed to 'send*()' in 0002- commit msg.
> >>  - Comment about bit restore updated in 0003-.
> >>  - 'same' renamed to 'similar' in 0003- commit msg.
> >>  - u32 used instead of uint32_t in 0003-.
> >>
> >>  v2 -> v3:
> >>  - 'virtio/vsock: rename 'EOR' to 'EOM' bit.' - commit message updated.
> >>  - 'VIRTIO_VSOCK_SEQ_EOR' bit add moved to separate patch.
> >>  - 'vhost/vsock: support MSG_EOR bit processing' - commit message
> >>    updated.
> >>  - 'vhost/vsock: support MSG_EOR bit processing' - removed unneeded
> >>    'le32_to_cpu()', because input argument was already in CPU
> >>    endianness.
> >>
> >>  v1 -> v2:
> >>  - 'VIRTIO_VSOCK_SEQ_EOR' is renamed to 'VIRTIO_VSOCK_SEQ_EOM', to
> >>    support backward compatibility.
> >>  - use bitmask of flags to restore in vhost.c, instead of separated
> >>    bool variable for each flag.
> >>  - test for EAGAIN removed, as logically it is not part of this
> >>    patchset(will be sent separately).
> >>  - cover letter updated(added part with POSIX description).
> >>
> >> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> >> -- 
> >> 2.25.1
> >


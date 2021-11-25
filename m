Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF5B45D56C
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhKYHbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:31:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230342AbhKYH3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:29:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637825182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KCI9CPt99xPAxo4OPIihJLE+9ULo5GUcCD2zEw3zAm0=;
        b=MmAOUjSXwHGYgLyON40rZREWkuxvRJQzAlU4tSMhh5eNMxeNaLbCsB7MWR57ov7HNBRfbE
        1LDGY+U2pRQS3FyOvwiLyVzUgcX22bQnelvoWiasyBsV5MdFor4CgibkV5nEYWRuEDjeuc
        NL7gKQEEY9LJ274R1S3uMdktx4YevbM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-2BFixzhTMjOeNqcGTXW1Qw-1; Thu, 25 Nov 2021 02:26:21 -0500
X-MC-Unique: 2BFixzhTMjOeNqcGTXW1Qw-1
Received: by mail-wm1-f69.google.com with SMTP id z138-20020a1c7e90000000b003319c5f9164so4436377wmc.7
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:26:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KCI9CPt99xPAxo4OPIihJLE+9ULo5GUcCD2zEw3zAm0=;
        b=Fh44rbLuJ6GyYFQTZx/3mHYmGFSe/DUwabZpHaOG8Km0UMZuO95bvWIyLlnR8WnlVA
         wbFhRqhp15Ngr8Beu2TveVgN60YYBAppkc1An9fz2zt71OpMmOKOidnkgLCEDY5MSLkb
         3iWh3dPs7feGesuR/JLSmd3IyX9Qz5rDnxOf0dV7t1Do4TUbCKkOPlTKfVcywJy9njK6
         iHamGYolaz9QwBEbz6diNDBsgt/JUy+/vtnjJh3aad+ts0irW7IcbfKCpEU2VTXjPkTZ
         Tvhjca4OiyzT0BaPBoJODxHsD7LS9VSJSHikVB2WJYNf3lviaNIgbhWt8jES0EUyXDP6
         Y/9g==
X-Gm-Message-State: AOAM530c8LigGvPO1Y8+BQyGomPBVaaTNj2/BxswI3IuiVVrsDk/2bCX
        t0RaeWgVq2Akfu7CZaOY+3PWZAseZJIGt2SkOCui2H5ugtEocX7DTxfPuvyrKJH+DVojPC0nPPK
        Wqd5mz2cPEYdlvlJM
X-Received: by 2002:adf:b18e:: with SMTP id q14mr4435686wra.477.1637825180321;
        Wed, 24 Nov 2021 23:26:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzM6lbQ3uDZ5zJpkNVH+bqgGz375VJK1frTc+q8xHT9a96tyQUcZyAB+1UDheXMUsphwXYylg==
X-Received: by 2002:adf:b18e:: with SMTP id q14mr4435665wra.477.1637825180075;
        Wed, 24 Nov 2021 23:26:20 -0800 (PST)
Received: from redhat.com ([45.15.18.67])
        by smtp.gmail.com with ESMTPSA id f19sm9035167wmq.34.2021.11.24.23.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 23:26:19 -0800 (PST)
Date:   Thu, 25 Nov 2021 02:26:13 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eli Cohen <elic@nvidia.com>
Subject: Re: [PATCH net] virtio-net: enable big mode correctly
Message-ID: <20211125022442-mutt-send-email-mst@kernel.org>
References: <20211125060547.11961-1-jasowang@redhat.com>
 <20211125015532-mutt-send-email-mst@kernel.org>
 <CACGkMEv+hehZazXRG9mavv=KZ76XfCrkeNqB8CPOnkwRF9cdHA@mail.gmail.com>
 <20211125021308-mutt-send-email-mst@kernel.org>
 <CACGkMEscBZw+PjX2fP5yN03SDVYc12tsQLXL=woAXdYWnC2q9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEscBZw+PjX2fP5yN03SDVYc12tsQLXL=woAXdYWnC2q9w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 03:20:07PM +0800, Jason Wang wrote:
> On Thu, Nov 25, 2021 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Nov 25, 2021 at 03:11:58PM +0800, Jason Wang wrote:
> > > On Thu, Nov 25, 2021 at 3:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Thu, Nov 25, 2021 at 02:05:47PM +0800, Jason Wang wrote:
> > > > > When VIRTIO_NET_F_MTU feature is not negotiated, we assume a very
> > > > > large max_mtu. In this case, using small packet mode is not correct
> > > > > since it may breaks the networking when MTU is grater than
> > > > > ETH_DATA_LEN.
> > > > >
> > > > > To have a quick fix, simply enable the big packet mode when
> > > > > VIRTIO_NET_F_MTU is not negotiated.
> > > >
> > > > This will slow down dpdk hosts which disable mergeable buffers
> > > > and send standard MTU sized packets.
> > > >
> > > > > We can do optimization on top.
> > > >
> > > > I don't think it works like this, increasing mtu
> > > > from guest >4k never worked,
> > >
> > > Looking at add_recvbuf_small() it's actually GOOD_PACKET_LEN if I was not wrong.
> >
> > OK, even more so then.
> >
> > > > we can't regress everyone's
> > > > performance with a promise to maybe sometime bring it back.
> > >
> > > So consider it never work before I wonder if we can assume a 1500 as
> > > max_mtu value instead of simply using MAX_MTU?
> > >
> > > Thanks
> >
> > You want to block guests from setting MTU to a value >GOOD_PACKET_LEN?
> 
> Yes, or fix the issue to let large packets on RX work (e.g as the TODO
> said, size the buffer: for <=4K mtu continue to work as
> add_recvbuf_small(), for >= 4K switch to use big).

Right. The difficulty is with changing modes, current code isn't
designed for it.

> > Maybe ... it will prevent sending large packets which did work ...
> 
> Yes, but it's strange to allow TX but not RX
> 
> > I'd tread carefully here, and I don't think this kind of thing is net
> > material.
> 
> I agree consider it can't be fixed easily.
> 
> Thanks
> 
> >
> > > >
> > > > > Reported-by: Eli Cohen <elic@nvidia.com>
> > > > > Cc: Eli Cohen <elic@nvidia.com>
> > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > >
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 7 ++++---
> > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 7c43bfc1ce44..83ae3ef5eb11 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -3200,11 +3200,12 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > >               dev->mtu = mtu;
> > > > >               dev->max_mtu = mtu;
> > > > >
> > > > > -             /* TODO: size buffers correctly in this case. */
> > > > > -             if (dev->mtu > ETH_DATA_LEN)
> > > > > -                     vi->big_packets = true;
> > > > >       }
> > > > >
> > > > > +     /* TODO: size buffers correctly in this case. */
> > > > > +     if (dev->max_mtu > ETH_DATA_LEN)
> > > > > +             vi->big_packets = true;
> > > > > +
> > > > >       if (vi->any_header_sg)
> > > > >               dev->needed_headroom = vi->hdr_len;
> > > > >
> > > > > --
> > > > > 2.25.1
> > > >
> >


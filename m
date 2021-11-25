Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0FE45D54C
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhKYHUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:20:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349230AbhKYHSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:18:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637824511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DrdfoJuoyuNHgO43HGDwB7KWOWfQOVP7BNUczbuAPp8=;
        b=Csn6QAYanCT42bmVAwdUJmnnmPcCqfb4/x+R8tiF+ct0GfPqtVLv0XtuDxoYxp8rUj21pU
        poP3aW5oOuPnuuwye9Ozd9ng6z2IeeJQSx35kBfD2gCUf235rYuPzBsC1T0jr6nVdK9dfQ
        qs2eRx6Wpl95dhyOJcLtQJpf8M98nlU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-lmxE98vjOm69MeGU60vicA-1; Thu, 25 Nov 2021 02:15:10 -0500
X-MC-Unique: lmxE98vjOm69MeGU60vicA-1
Received: by mail-ed1-f69.google.com with SMTP id l15-20020a056402124f00b003e57269ab87so4663070edw.6
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:15:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DrdfoJuoyuNHgO43HGDwB7KWOWfQOVP7BNUczbuAPp8=;
        b=fahx/uAjgitO0j41TBRqly+Vaikyb5YEUuN2EmAUCurPeZGD7ZK79YcqyOAeTQuD4k
         pPUUQ+8jNiOZhqre/wk5w9cactqXiWsBYJBtxRA9OJCo76iNTWERA1Rx4eddeGI9nOT4
         z5PzPiTgApaa64Sr0HwRzoKGZygRJBJ1xl4i1LZCH3H/vKpaFX18OkdZfGNDG3oNJCiH
         PPIaTOoYCHvV1KmMRx66+bELxJ6MNr6tiV567d5ah/k7MWkYTHd0DCpDHOJj3oL5vMVv
         0bwBj42q7BoEBytY2ja1plXaCinb0zzp5mHEEt5vY8w3PPc4D88Ow9LbpT9k85SfPSrO
         qveg==
X-Gm-Message-State: AOAM533FKwBmoGRFgZk4/bhuK9KI+KX5LxH84aY7aVeC1zblboymL0kx
        KARAzjV2Bj2ORtZ3QfZzJQZN52Y0V59FmAPAR+WRNgZxC+74wzKC2y+6nbXLv36rWGGbVZzVqJN
        5PSOUDKAk5aBfJbZH
X-Received: by 2002:a05:6402:3496:: with SMTP id v22mr34843223edc.177.1637824508931;
        Wed, 24 Nov 2021 23:15:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzT4Ux6nJrzHTTYycQkkUo3yCguo+1d6EF1/y5nPdIGUEaoov9qqpPkw+eeVpNdKNDvLUtBeA==
X-Received: by 2002:a05:6402:3496:: with SMTP id v22mr34843190edc.177.1637824508772;
        Wed, 24 Nov 2021 23:15:08 -0800 (PST)
Received: from redhat.com ([45.15.18.67])
        by smtp.gmail.com with ESMTPSA id m15sm1281606edl.22.2021.11.24.23.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 23:14:55 -0800 (PST)
Date:   Thu, 25 Nov 2021 02:14:48 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eli Cohen <elic@nvidia.com>
Subject: Re: [PATCH net] virtio-net: enable big mode correctly
Message-ID: <20211125021308-mutt-send-email-mst@kernel.org>
References: <20211125060547.11961-1-jasowang@redhat.com>
 <20211125015532-mutt-send-email-mst@kernel.org>
 <CACGkMEv+hehZazXRG9mavv=KZ76XfCrkeNqB8CPOnkwRF9cdHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEv+hehZazXRG9mavv=KZ76XfCrkeNqB8CPOnkwRF9cdHA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 03:11:58PM +0800, Jason Wang wrote:
> On Thu, Nov 25, 2021 at 3:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Nov 25, 2021 at 02:05:47PM +0800, Jason Wang wrote:
> > > When VIRTIO_NET_F_MTU feature is not negotiated, we assume a very
> > > large max_mtu. In this case, using small packet mode is not correct
> > > since it may breaks the networking when MTU is grater than
> > > ETH_DATA_LEN.
> > >
> > > To have a quick fix, simply enable the big packet mode when
> > > VIRTIO_NET_F_MTU is not negotiated.
> >
> > This will slow down dpdk hosts which disable mergeable buffers
> > and send standard MTU sized packets.
> >
> > > We can do optimization on top.
> >
> > I don't think it works like this, increasing mtu
> > from guest >4k never worked,
> 
> Looking at add_recvbuf_small() it's actually GOOD_PACKET_LEN if I was not wrong.

OK, even more so then.

> > we can't regress everyone's
> > performance with a promise to maybe sometime bring it back.
> 
> So consider it never work before I wonder if we can assume a 1500 as
> max_mtu value instead of simply using MAX_MTU?
> 
> Thanks

You want to block guests from setting MTU to a value >GOOD_PACKET_LEN?
Maybe ... it will prevent sending large packets which did work ...
I'd tread carefully here, and I don't think this kind of thing is net
material.

> >
> > > Reported-by: Eli Cohen <elic@nvidia.com>
> > > Cc: Eli Cohen <elic@nvidia.com>
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > >
> > > ---
> > >  drivers/net/virtio_net.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 7c43bfc1ce44..83ae3ef5eb11 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -3200,11 +3200,12 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >               dev->mtu = mtu;
> > >               dev->max_mtu = mtu;
> > >
> > > -             /* TODO: size buffers correctly in this case. */
> > > -             if (dev->mtu > ETH_DATA_LEN)
> > > -                     vi->big_packets = true;
> > >       }
> > >
> > > +     /* TODO: size buffers correctly in this case. */
> > > +     if (dev->max_mtu > ETH_DATA_LEN)
> > > +             vi->big_packets = true;
> > > +
> > >       if (vi->any_header_sg)
> > >               dev->needed_headroom = vi->hdr_len;
> > >
> > > --
> > > 2.25.1
> >


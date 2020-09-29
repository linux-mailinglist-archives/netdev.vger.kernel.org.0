Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415FC27BDE4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgI2HXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:23:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgI2HXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 03:23:07 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601364185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DkxDE/GfK+LWdfYX0Hon0sHSmMWfOnLZHyrioNnimaM=;
        b=HLU+ECU9RuQb6n3MCjA6guYMNbi7rFNMYzIXLvpKL3UrFsDRFn+CBix3bkEqhDAreclvB7
        ao8gHbwoS6/0k7lQ6inNEe3lpKoN3fyIducQIR9nOUnFs7YcQ1PDjeNb6EGIJ6OjhHnh6V
        Wnhzu8XqfpHm05+U5kMpkpd61xGxpO4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-4TyssVz3O5a6Fq3djCagOg-1; Tue, 29 Sep 2020 03:21:59 -0400
X-MC-Unique: 4TyssVz3O5a6Fq3djCagOg-1
Received: by mail-wr1-f72.google.com with SMTP id l15so1363302wro.10
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:21:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DkxDE/GfK+LWdfYX0Hon0sHSmMWfOnLZHyrioNnimaM=;
        b=qFZ2xwjmi3eN7kLhwhr2T/XfnNsAvPiVMGJSyzaQS69qFfaMGMo/jlncsY2aK/lHFz
         4+/u8SbYUFMBX4UKPXyQ+qRtb1jt1YrWqMEKq2xjJstUGVz0gPq8mzvh5wyswQ0rD57N
         llYpDwGltTN8lj/44H6TXpHjxC6TSv0gp+ID0OVxvRzhdZfcUJHHui6jF5VptzKfrRAk
         0NIg28XkMn0xlSsw3DwoIDmZ92IPXJ48YtcmgGBV2/OZChXlaMSFqkVN8oJQIWPZNWZb
         0L7H5MfRmTv9/+sZYFx5l1Kiwr/YFT7GUf33unLpiBgvVaLKqnVzXnzlep37H/TKB/r7
         eC9g==
X-Gm-Message-State: AOAM533ure4x4wLN3cwgYKUAqiV/BQlJ63oVZljX6Vq8YP0Ijr1aU44R
        qhevRAZErpaoHbzMBKPGu4D/BEOYGjAW2qF+H/FyiVtay0q74eGNPEKBNvBLz1mpZ0VdsHbOqKJ
        cUuorlt4n08PV4ikj
X-Received: by 2002:a5d:554c:: with SMTP id g12mr2567224wrw.294.1601364118119;
        Tue, 29 Sep 2020 00:21:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGtzPdArh0eM4rppGx9qZiRUi92ATAXBOK4TCSCvWZu7TS6qA/fpQQUdNfu1bm57pomibcFQ==
X-Received: by 2002:a5d:554c:: with SMTP id g12mr2567206wrw.294.1601364117946;
        Tue, 29 Sep 2020 00:21:57 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id n4sm4598775wrp.61.2020.09.29.00.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 00:21:57 -0700 (PDT)
Date:   Tue, 29 Sep 2020 03:21:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2] virtio-net: don't disable guest csum when disable
 LRO
Message-ID: <20200929031754-mutt-send-email-mst@kernel.org>
References: <20200929015806.19171-1-xiangxia.m.yue@gmail.com>
 <20200929022246-mutt-send-email-mst@kernel.org>
 <CAMDZJNWM7eBkrYk9nkEvPyHW7=kt_hTHGQCDB1CPRz=EV6vJcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMDZJNWM7eBkrYk9nkEvPyHW7=kt_hTHGQCDB1CPRz=EV6vJcQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 02:59:03PM +0800, Tonghao Zhang wrote:
> On Tue, Sep 29, 2020 at 2:23 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Sep 29, 2020 at 09:58:06AM +0800, xiangxia.m.yue@gmail.com wrote:
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > Open vSwitch and Linux bridge will disable LRO of the interface
> > > when this interface added to them. Now when disable the LRO, the
> > > virtio-net csum is disable too. That drops the forwarding performance.
> > >
> > > Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Jason Wang <jasowang@redhat.com>
> > > Cc: Willem de Bruijn <willemb@google.com>
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > ---
> > > v2:
> > > * change the fix-tag
> > > ---
> > >  drivers/net/virtio_net.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 7145c83c6c8c..21b71148c532 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -63,6 +63,11 @@ static const unsigned long guest_offloads[] = {
> > >       VIRTIO_NET_F_GUEST_CSUM
> > >  };
> > >
> > > +#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> > > +                             (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> > > +                             (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > +                             (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > +
> >
> > I think I'd rather we open-coded this, the macro is only
> > used in one place ...
> Yes, in this patch, it is used only in one place. But in next patch
> [1], we use it twice and that make the code look a bit nicer.
> Would we open-coded this in this patch ?
> 
> [1] - http://patchwork.ozlabs.org/project/netdev/patch/20200928033915.82810-2-xiangxia.m.yue@gmail.com/

OK then maybe keep this in a series like you did with v1.



> > >  struct virtnet_stat_desc {
> > >       char desc[ETH_GSTRING_LEN];
> > >       size_t offset;
> > > @@ -2531,7 +2536,8 @@ static int virtnet_set_features(struct net_device *dev,
> > >               if (features & NETIF_F_LRO)
> > >                       offloads = vi->guest_offloads_capable;
> > >               else
> > > -                     offloads = 0;
> > > +                     offloads = vi->guest_offloads_capable &
> > > +                                ~GUEST_OFFLOAD_LRO_MASK;
> > >
> > >               err = virtnet_set_guest_offloads(vi, offloads);
> > >               if (err)
> >
> > > --
> > > 2.23.0
> >
> 
> 
> -- 
> Best regards, Tonghao


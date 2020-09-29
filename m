Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7870E27BCBE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 08:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbgI2GD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 02:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgI2GD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 02:03:58 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63C2C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 23:03:57 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id nw23so13303034ejb.4
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 23:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cbzGI2E63rvacCgT4IMKli2vxVX3CttMz/Tx1YiiZz4=;
        b=NxNiZNJ+OG8oxMmSK7C6prgulO6SqIcircN1UxT/zdOGR92Uemo+KDnwi9gT0syDgZ
         /nEIFdDUiHPieQZrs5fA5lGMztANsWA41JiobgsR/bSJVTABbJD4Vc/BtrGBXsUepY1F
         5Nk/m+D46iZ8n5qs56ejH60OiZN4zjU392fNgEQTUtWNNZHWytx0r/ZTvBRcvuybUqad
         XkKz/qBEEeMc1x44VTnwc8bc/TITwSu2UbsZz+4WjbfvaHc+UDVdGegNcrPwroG18wAW
         JQALySM+3lHTMbiMVH+ODU2to/AvBeeM5u/wd2bhoatGd6GCTcyFz4zWkTmQUD0VSiEf
         fxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cbzGI2E63rvacCgT4IMKli2vxVX3CttMz/Tx1YiiZz4=;
        b=ogvc41EM2MJeW8OTO+FTOsG/hSb065bkoXFKF5TQ4SppOC/ZRYbx6DHm2c4W4wkbBc
         eDVx1p8VKLmWDYJjQClOmDjA6XiRtuu2cVK5YfvNp5zlTgjjgK8i8JKH5nedKLZYbS0t
         +48gtOS2Q/K+gPOFY2XnVLTzIIC1TxHpkyDfvW5PYiPCbRaN9p/iqnCNZuj+JCvBhxe3
         uRP4j/KsSzdx7+RrhFx0EbojZwaI89avZidV08x0QAg7z3tLfxVdaCxqWHovwiazl4b7
         9sjAjOEjKslB9OGhLX3Ns5OKK//UJCyzehN7fHe0DIGWTyiNIgxyEH6FeluiLBMNJsZj
         TMpg==
X-Gm-Message-State: AOAM532rg9NOJ+JTL5IW9dG4QqIuLTGdja1ndDrHTFJopfj2KIgFzOkK
        uJ3qTmW9T82X7KHv6GG3VoPnGZrkljOYAuVadZI=
X-Google-Smtp-Source: ABdhPJx4NzKw/Sv5M31LactrcvvEGd5J1cmI3BJLFWADl29QUTQ+on8SInzw2zCQ0mO4/8iDIsy3zhNZ2eCoIisHQX8=
X-Received: by 2002:a17:906:178d:: with SMTP id t13mr2350935eje.410.1601359436511;
 Mon, 28 Sep 2020 23:03:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
 <20200928151531-mutt-send-email-mst@kernel.org> <CAMDZJNV_A+EuqFGEhB_-g_5unUJ9TyyDZu1krtxBS22EnW1mAw@mail.gmail.com>
 <20200929015624-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200929015624-mutt-send-email-mst@kernel.org>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 29 Sep 2020 14:01:32 +0800
Message-ID: <CAMDZJNWtGBoiOsyzpPg8MK-YL=E+a4+fiV_cThrDpW-GY+fMMg@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio-net: don't disable guest csum when disable LRO
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 1:57 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Sep 29, 2020 at 09:40:22AM +0800, Tonghao Zhang wrote:
> > On Tue, Sep 29, 2020 at 3:21 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Sep 28, 2020 at 11:39:14AM +0800, xiangxia.m.yue@gmail.com wrote:
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > Open vSwitch and Linux bridge will disable LRO of the interface
> > > > when this interface added to them. Now when disable the LRO, the
> > > > virtio-net csum is disable too. That drops the forwarding performance.
> > > >
> > > > Fixes: e59ff2c49ae1 ("virtio-net: disable guest csum during XDP set")
> > >
> > > I am a bit confused by this tag. Did this change bring about
> > > disabling checksum when LRO is disabled? I am not sure
> > > I follow how ...
> > Hi Michael
> > It's not right fix tag.
> > The commit a02e8964eaf9 ("virtio-net: ethtool configurable LRO"),
> > disable the csum, when we disable the LRO
>
> OK then, pls send a correct Fixes tag when you repost this ...
Hi Michael
I repost this patch, please review. thanks.
http://patchwork.ozlabs.org/project/netdev/patch/20200929015806.19171-1-xiangxia.m.yue@gmail.com/
> > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > Cc: Willem de Bruijn <willemb@google.com>
> > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > ---
> > > >  drivers/net/virtio_net.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 7145c83c6c8c..21b71148c532 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -63,6 +63,11 @@ static const unsigned long guest_offloads[] = {
> > > >       VIRTIO_NET_F_GUEST_CSUM
> > > >  };
> > > >
> > > > +#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> > > > +                             (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> > > > +                             (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > > +                             (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > > +
> > > >  struct virtnet_stat_desc {
> > > >       char desc[ETH_GSTRING_LEN];
> > > >       size_t offset;
> > > > @@ -2531,7 +2536,8 @@ static int virtnet_set_features(struct net_device *dev,
> > > >               if (features & NETIF_F_LRO)
> > > >                       offloads = vi->guest_offloads_capable;
> > > >               else
> > > > -                     offloads = 0;
> > > > +                     offloads = vi->guest_offloads_capable &
> > > > +                                ~GUEST_OFFLOAD_LRO_MASK;
> > > >
> > > >               err = virtnet_set_guest_offloads(vi, offloads);
> > > >               if (err)
> > > > --
> > > > 2.23.0
> > >
> >
> >
> > --
> > Best regards, Tonghao
>


-- 
Best regards, Tonghao

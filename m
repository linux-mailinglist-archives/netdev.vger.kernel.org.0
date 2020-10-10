Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C9B289D5E
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 04:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgJJCIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 22:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbgJJB5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 21:57:39 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A61C0613CF
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 18:57:39 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id t21so11311829eds.6
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 18:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ej9W/wdGVHkJe37GtEVPFUNkVAYebVIX+ppZawU5yrs=;
        b=AGxCOJHzE8qt9ydl/IFHP1pag6Xl2y0SE6klNIOxFzIPPOL9B1XBGnoEnNg+MdCh0G
         MHvMO+8NydjJjzZLvD1Sh+rjlc9BPaP8mJ2rdRUtBObCS89ZtnqW4zHe4prcYfHWfmGa
         3e9j+lVcc+InthdxpylwAj5yHUEyGStkdSwYSYnXyzTNuMl6RZeXFB5orzWCvGGL/qmo
         3B7gfcEoeP9R0MKPU1pZqtCneKTBbUifr8fKnkGWtkZq4QbBtDeudVSh5tgHIcPVygZa
         yPHQzFeiGbyg0LcYWG+E6dKX/CfjmK/meXzQXjiT1OIKIT5MVere9406dlZ5Irpq+w+w
         +4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ej9W/wdGVHkJe37GtEVPFUNkVAYebVIX+ppZawU5yrs=;
        b=FRZxFNChyXC/Wjh2AuJGCbiz9mcMCss2p5bcxe52GH0V3tTIcnrFZ22kCwuK3optkS
         GSh0OtverTYK1nr4dKv7g3c3yX1KxqNrRINV4JSRD8aBgO+Pq4YiGIlP7YcGmEq2YGh5
         z7zYAAmRVik/wWvbH98eEpd4b4lxazpPYRlRV3QRDTgKDq2wZHdFYgX6ea+CQT5XrTjl
         9nVekx91areKNf6wd6jxX2LwgHUElG3qfWV7/pwTqfoEJw2iws2hZvSEKcUzRNhO9ZtZ
         YOPo6qQg8UMnqk4OnGIEuMfq9FYa2ldA8hSAursczuc8+3PVacXBgV1pAkHHpLhfcan0
         3rBQ==
X-Gm-Message-State: AOAM532l8xU7JeizdLxqOHPhRMuvQhyAEi9x+Vr26DV4IG2AcSqVHb3l
        k5AZ2Rnh2k3w1cU6VfEdEo9pIXw9tRHO2qZIhJE=
X-Google-Smtp-Source: ABdhPJyJJ+UkVEE2d2vb9hs4seDQAQq4hn36I76NEv8nbeEGM+0qf7M+SunlzivmvT00lYbk0s/isHHe1DNP0bwbmf4=
X-Received: by 2002:a05:6402:7c8:: with SMTP id u8mr2267491edy.153.1602295057527;
 Fri, 09 Oct 2020 18:57:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200930020300.62245-1-xiangxia.m.yue@gmail.com>
 <CA+FuTSed1GsGp8a=GnHqV-HUcsOSZ0tb0NCe8360S8Md3MbS3g@mail.gmail.com>
 <CAMDZJNWX=3ikS5f0H+xD-dByW2=JHXjvk1=R=CkDLt0TW-orTg@mail.gmail.com> <CA+FuTSeVRhM+q_WuWvBDMk+Ao61y+iJWTukpoLzNCHGfYG9=UA@mail.gmail.com>
In-Reply-To: <CA+FuTSeVRhM+q_WuWvBDMk+Ao61y+iJWTukpoLzNCHGfYG9=UA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 10 Oct 2020 09:53:45 +0800
Message-ID: <CAMDZJNUY-F47m0aQ0wqG_O-ttauS0_dciBTrL=DU=Z_h-w+-Kw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] virtio-net: ethtool configurable RXCSUM
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 9:49 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 9:19 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Wed, Sep 30, 2020 at 6:05 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Wed, Sep 30, 2020 at 4:05 AM <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > Allow user configuring RXCSUM separately with ethtool -K,
> > > > reusing the existing virtnet_set_guest_offloads helper
> > > > that configures RXCSUM for XDP. This is conditional on
> > > > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> > > >
> > > > If Rx checksum is disabled, LRO should also be disabled.
> > > >
> > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > The first patch was merged into net.
> > >
> > > Please wait until that is merged into net-next, as this depends on the
> > > other patch.
> > >
> > > > ---
> > > > v2:
> > > > * LRO depends the rx csum
> > > > * remove the unnecessary check
> > > > ---
> > > >  drivers/net/virtio_net.c | 49 ++++++++++++++++++++++++++++++----------
> > > >  1 file changed, 37 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 21b71148c532..5407a0106771 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
> > > >                                 (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > >                                 (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > >
> > > > +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > > > +
> > > >  struct virtnet_stat_desc {
> > > >         char desc[ETH_GSTRING_LEN];
> > > >         size_t offset;
> > > > @@ -2522,29 +2524,49 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
> > > >         return 0;
> > > >  }
> > > >
> > > > +static netdev_features_t virtnet_fix_features(struct net_device *netdev,
> > > > +                                             netdev_features_t features)
> > > > +{
> > > > +       /* If Rx checksum is disabled, LRO should also be disabled.
> > > > +        * That is life. :)
> > >
> > > Please remove this second line.
> > OK
> > > > +        */
> > > > +       if (!(features & NETIF_F_RXCSUM))
> > > > +               features &= ~NETIF_F_LRO;
> > > > +
> > > > +       return features;
> > > > +}
> > > > +
> > > >  static int virtnet_set_features(struct net_device *dev,
> > > >                                 netdev_features_t features)
> > > >  {
> > > >         struct virtnet_info *vi = netdev_priv(dev);
> > > > -       u64 offloads;
> > > > +       u64 offloads = vi->guest_offloads &
> > > > +                      vi->guest_offloads_capable;
> > >
> > > When can vi->guest_offloads have bits set outside the mask of
> > > vi->guest_offloads_capable?
> > In this case, we can use only vi->guest_offloads. and
> > guest_offloads_capable will not be used any more.
> > so should we remove guest_offloads_capable ?
>
> That bitmap stores the capabilities of the device as learned at
> initial device probe. I don't see how it can be removed.
Hi Willem
guest_offloads_capable was introduced by
a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
and used only for LRO. Now we don't use it anymore, right ?
because this patch (virtio-net: ethtool configurable RXCSUM)
doesn't use it.


-- 
Best regards, Tonghao

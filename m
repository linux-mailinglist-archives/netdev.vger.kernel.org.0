Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6C228A212
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388663AbgJJWyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730536AbgJJS6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:58:46 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF7BC0613BD
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 11:58:41 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id r1so5835305vsi.12
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 11:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GvvHnnSbHJ2XDnxeZeyrA7lUthNy++4jLaKqWSsbUWg=;
        b=UI3mYte48TBb7t5UoUAlrw8I1mebFnXRYY0E4e+Xwm3vyju2+1MmUZL/KsVSGejObH
         2sNlqaeBB6/8OGFGpxILOyMyFX5cTCd8DX928wIN78HWmoeGmeI2inhnW7chCIMeLFvS
         H58EERauO+uS02O2GmXWUxs7YGz0xducr5JyMQHzXKqFgolaJG37RQenIzwb5F7+Oriw
         jgisMb9W7i0UAKD3YuP7J38Zc5dcJRqu6Hbi+5gTwunWBW2N3EoYPqYQWAWVRGiwiBsV
         N1wgKDacLLXXrADZX0WYXmfwIjL0BLh76O37N9Wov+aTYnu8RjmKBfwYV61HWvzYDKQi
         9qUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GvvHnnSbHJ2XDnxeZeyrA7lUthNy++4jLaKqWSsbUWg=;
        b=cz6Ayzq8g3+iU7PVHcaKFdcaKweuZ3w2LOTvHKukZ/u9vhCpIK7HmpRbaIc4M34Ink
         JDgBEJ9hIirtKmn3Q7Wk6xDSMsQ8CZLTRYZj++KNifOJDmfTVBdJK5BB2hT6fmd9xPgQ
         aSyfvKO2k4HqFC6lurKWW5uqXJZjJKdyJqTVURlkmT4PpjdUUxuNuQyxHlNEXy5IQ6e1
         d9yabDmRuarRF4CouLl0cEBwDzZFyM2VDlhQ6+qa8/ISAdupcxcw/baHrL29OYU3gT0z
         fYl3o+HynGkrgs9HgWbi6lx1NNQ9UxKb2HHRq9gseTBdzVQ/LaiNZs1tVtORFo42lHgw
         oC5w==
X-Gm-Message-State: AOAM53369V/i/SYT12iE+4xytPUTWvdZom4j5M4MJv4KvPdqvJJ33yQb
        rDSlgeoSsj7p2ZDJ9NaXsf2e1Hkgnxs=
X-Google-Smtp-Source: ABdhPJx3MBDPhpCEmHXDhwMJ0JfAD/MIkeh08E7LuK83IVgh75xF7oqdhcTLO6RPufmk00yOHGbS2A==
X-Received: by 2002:a67:ec54:: with SMTP id z20mr10782710vso.4.1602356320189;
        Sat, 10 Oct 2020 11:58:40 -0700 (PDT)
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com. [209.85.221.178])
        by smtp.gmail.com with ESMTPSA id 31sm1846587uac.10.2020.10.10.11.58.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 11:58:39 -0700 (PDT)
Received: by mail-vk1-f178.google.com with SMTP id d2so2896924vkd.13
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 11:58:38 -0700 (PDT)
X-Received: by 2002:a1f:5341:: with SMTP id h62mr10099366vkb.24.1602356317922;
 Sat, 10 Oct 2020 11:58:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200930020300.62245-1-xiangxia.m.yue@gmail.com>
 <CA+FuTSed1GsGp8a=GnHqV-HUcsOSZ0tb0NCe8360S8Md3MbS3g@mail.gmail.com>
 <CAMDZJNWX=3ikS5f0H+xD-dByW2=JHXjvk1=R=CkDLt0TW-orTg@mail.gmail.com>
 <CA+FuTSeVRhM+q_WuWvBDMk+Ao61y+iJWTukpoLzNCHGfYG9=UA@mail.gmail.com> <CAMDZJNUY-F47m0aQ0wqG_O-ttauS0_dciBTrL=DU=Z_h-w+-Kw@mail.gmail.com>
In-Reply-To: <CAMDZJNUY-F47m0aQ0wqG_O-ttauS0_dciBTrL=DU=Z_h-w+-Kw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 10 Oct 2020 14:58:01 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeOa1Xh4XtrKd2F2hJa5cn-+UA3-E3BKxe66oTJbxH3Vw@mail.gmail.com>
Message-ID: <CA+FuTSeOa1Xh4XtrKd2F2hJa5cn-+UA3-E3BKxe66oTJbxH3Vw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] virtio-net: ethtool configurable RXCSUM
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 10:10 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Fri, Oct 9, 2020 at 9:49 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Oct 8, 2020 at 9:19 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > On Wed, Sep 30, 2020 at 6:05 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > > > On Wed, Sep 30, 2020 at 4:05 AM <xiangxia.m.yue@gmail.com> wrote:
> > > > >
> > > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > >
> > > > > Allow user configuring RXCSUM separately with ethtool -K,
> > > > > reusing the existing virtnet_set_guest_offloads helper
> > > > > that configures RXCSUM for XDP. This is conditional on
> > > > > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> > > > >
> > > > > If Rx checksum is disabled, LRO should also be disabled.
> > > > >
> > > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > The first patch was merged into net.
> > > >
> > > > Please wait until that is merged into net-next, as this depends on the
> > > > other patch.
> > > >
> > > > > ---
> > > > > v2:
> > > > > * LRO depends the rx csum
> > > > > * remove the unnecessary check
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 49 ++++++++++++++++++++++++++++++----------
> > > > >  1 file changed, 37 insertions(+), 12 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 21b71148c532..5407a0106771 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
> > > > >                                 (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > > >                                 (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > > >
> > > > > +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > > > > +
> > > > >  struct virtnet_stat_desc {
> > > > >         char desc[ETH_GSTRING_LEN];
> > > > >         size_t offset;
> > > > > @@ -2522,29 +2524,49 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
> > > > >         return 0;
> > > > >  }
> > > > >
> > > > > +static netdev_features_t virtnet_fix_features(struct net_device *netdev,
> > > > > +                                             netdev_features_t features)
> > > > > +{
> > > > > +       /* If Rx checksum is disabled, LRO should also be disabled.
> > > > > +        * That is life. :)
> > > >
> > > > Please remove this second line.
> > > OK
> > > > > +        */
> > > > > +       if (!(features & NETIF_F_RXCSUM))
> > > > > +               features &= ~NETIF_F_LRO;
> > > > > +
> > > > > +       return features;
> > > > > +}
> > > > > +
> > > > >  static int virtnet_set_features(struct net_device *dev,
> > > > >                                 netdev_features_t features)
> > > > >  {
> > > > >         struct virtnet_info *vi = netdev_priv(dev);
> > > > > -       u64 offloads;
> > > > > +       u64 offloads = vi->guest_offloads &
> > > > > +                      vi->guest_offloads_capable;
> > > >
> > > > When can vi->guest_offloads have bits set outside the mask of
> > > > vi->guest_offloads_capable?
> > > In this case, we can use only vi->guest_offloads. and
> > > guest_offloads_capable will not be used any more.
> > > so should we remove guest_offloads_capable ?
> >
> > That bitmap stores the capabilities of the device as learned at
> > initial device probe. I don't see how it can be removed.
> Hi Willem
> guest_offloads_capable was introduced by
> a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
> and used only for LRO. Now we don't use it anymore, right ?
> because this patch (virtio-net: ethtool configurable RXCSUM)
> doesn't use it.

It is needed, because it serves as an upper bound on configurable options.

virtnet_set_features cannot enable LRO unless the LRO flags are
captured by the feature negotiation at probe time.

I think on enable you need something like

-                       offloads = vi->guest_offloads_capable;
+                       offloads |= vi->guest_offloads_capable &
GUEST_OFFLOAD_LRO_MASK;

instead of unconditional

+                       offloads |= GUEST_OFFLOAD_LRO_MASK;

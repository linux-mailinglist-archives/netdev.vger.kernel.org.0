Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF54288A02
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 15:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387508AbgJINtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 09:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732613AbgJINtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 09:49:12 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA92C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 06:49:12 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id v23so2423931vsp.6
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 06:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xcgKUFX7XcfbXXXU6IJ8NOQNoF8tX9KNcM10Wer9NFI=;
        b=kSKaUhS3NF5+0MnqrqG9Tel/yOhnje8J8LUX20QIIO1+893CAXqRgMBxJze3kQg/8u
         widPuRn+6Dp5zw54npeh3GsawVMM6PeHoCbgz7meCFpMhRNt+bymJyiirARl9GDrITp6
         kDXW75ppyUFTLQ10FaZPWu7PrbKCTe7NJHIrI00AjU3V+Gxo3WJuIMMNna8XD0+ammj+
         uEripBxUzRLpsOOH86oJsmyHGzmEAlFefiqXEakMNMJd5JOUiXaxIwieJFuh7oxd1oFP
         kP7YlFj/5wTwAnXnSt86BL8y6d3pV0lckICiIxxgTK/QzYrIssrf7XCswZ3UkDmd/PZI
         +mnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xcgKUFX7XcfbXXXU6IJ8NOQNoF8tX9KNcM10Wer9NFI=;
        b=QGSiZErnd6z8dv7bR8MoGz4t9IeXYCyrMnvur+fGxWJcFWYAoBFnUT/9RgEgH7ta7n
         dz8uSb2ghA57OPB+BUW3KnIQldYdWdQttM8DNxTQZ1ABBVedSS0j2hQcSqs+BFONOnAg
         52O8xU219zrATkoNM9O8hiXYIIZFqU5Xnk7YJPJq/aNYIdrr/OjZ8wl0sFlHDjq4UxNc
         jqnHGbnhhLc3iyj1nb1MSOVUqRYxJJkSOjb5Xcgn60ttWkuKmJpHqh2ZAm3ZQNNAux7f
         3Cj9ILp9Ge+g9TvCyMssB1pU3Zlu+eV0AXDXFBpt/p6ehd9NVuUPbFeA25hK/Y6wLsKH
         XfGg==
X-Gm-Message-State: AOAM533xtkJsTYhbCq8ZgsFDQECDYWWCVcgl/G75VO9v3GgPgSrBH5dJ
        3fdPyMVj4dxzq6Dz3FbDU8GNKfwS1Fg=
X-Google-Smtp-Source: ABdhPJx/DcPE5f6Y9GJIEDRP4whjx3utUH0gcu9cfS4WlFXRi8Ur+tQdEkTIbeLiRd2f+DdKumFQRw==
X-Received: by 2002:a05:6102:205c:: with SMTP id q28mr7981563vsr.38.1602251349476;
        Fri, 09 Oct 2020 06:49:09 -0700 (PDT)
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com. [209.85.221.169])
        by smtp.gmail.com with ESMTPSA id o145sm1165022vkd.13.2020.10.09.06.49.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 06:49:08 -0700 (PDT)
Received: by mail-vk1-f169.google.com with SMTP id d2so2124008vkd.13
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 06:49:07 -0700 (PDT)
X-Received: by 2002:a1f:ae85:: with SMTP id x127mr4312160vke.8.1602251347387;
 Fri, 09 Oct 2020 06:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200930020300.62245-1-xiangxia.m.yue@gmail.com>
 <CA+FuTSed1GsGp8a=GnHqV-HUcsOSZ0tb0NCe8360S8Md3MbS3g@mail.gmail.com> <CAMDZJNWX=3ikS5f0H+xD-dByW2=JHXjvk1=R=CkDLt0TW-orTg@mail.gmail.com>
In-Reply-To: <CAMDZJNWX=3ikS5f0H+xD-dByW2=JHXjvk1=R=CkDLt0TW-orTg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 9 Oct 2020 09:48:31 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeVRhM+q_WuWvBDMk+Ao61y+iJWTukpoLzNCHGfYG9=UA@mail.gmail.com>
Message-ID: <CA+FuTSeVRhM+q_WuWvBDMk+Ao61y+iJWTukpoLzNCHGfYG9=UA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] virtio-net: ethtool configurable RXCSUM
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 9:19 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Wed, Sep 30, 2020 at 6:05 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Wed, Sep 30, 2020 at 4:05 AM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > Allow user configuring RXCSUM separately with ethtool -K,
> > > reusing the existing virtnet_set_guest_offloads helper
> > > that configures RXCSUM for XDP. This is conditional on
> > > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> > >
> > > If Rx checksum is disabled, LRO should also be disabled.
> > >
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Jason Wang <jasowang@redhat.com>
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > The first patch was merged into net.
> >
> > Please wait until that is merged into net-next, as this depends on the
> > other patch.
> >
> > > ---
> > > v2:
> > > * LRO depends the rx csum
> > > * remove the unnecessary check
> > > ---
> > >  drivers/net/virtio_net.c | 49 ++++++++++++++++++++++++++++++----------
> > >  1 file changed, 37 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 21b71148c532..5407a0106771 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
> > >                                 (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > >                                 (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > >
> > > +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > > +
> > >  struct virtnet_stat_desc {
> > >         char desc[ETH_GSTRING_LEN];
> > >         size_t offset;
> > > @@ -2522,29 +2524,49 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
> > >         return 0;
> > >  }
> > >
> > > +static netdev_features_t virtnet_fix_features(struct net_device *netdev,
> > > +                                             netdev_features_t features)
> > > +{
> > > +       /* If Rx checksum is disabled, LRO should also be disabled.
> > > +        * That is life. :)
> >
> > Please remove this second line.
> OK
> > > +        */
> > > +       if (!(features & NETIF_F_RXCSUM))
> > > +               features &= ~NETIF_F_LRO;
> > > +
> > > +       return features;
> > > +}
> > > +
> > >  static int virtnet_set_features(struct net_device *dev,
> > >                                 netdev_features_t features)
> > >  {
> > >         struct virtnet_info *vi = netdev_priv(dev);
> > > -       u64 offloads;
> > > +       u64 offloads = vi->guest_offloads &
> > > +                      vi->guest_offloads_capable;
> >
> > When can vi->guest_offloads have bits set outside the mask of
> > vi->guest_offloads_capable?
> In this case, we can use only vi->guest_offloads. and
> guest_offloads_capable will not be used any more.
> so should we remove guest_offloads_capable ?

That bitmap stores the capabilities of the device as learned at
initial device probe. I don't see how it can be removed.

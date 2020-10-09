Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16E5287FF2
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 03:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgJIBTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 21:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgJIBTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 21:19:50 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39281C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 18:19:48 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id md26so10713743ejb.10
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 18:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a2HTm3KOv0Z8HJoze2OjkAd2YBNF85LGZH52VXfPgqs=;
        b=WDNgefohu7er2tk3/lc9Cg3sXN5aHkGNuZ1BLbvwZ2uL3FPN8vb+FOfRJFg5l7LM5d
         w7bwicv7RuLWhMvXg/yeH1GQkRwbqT1CrqFDGsp8O+fCeg08TaGVwgsxvJt7xI++iTlp
         eml5xLno2Nv2wi0qwpWub9x/r5T63NohjSrhstlanAEWAJ+xHDCOQPQ5NwJGO6HH2vik
         ssbLXoSloVED/6ZJxHSgPBuwyqvgtGnaZPBW0M5XX4Zqxga2DV28yMVkS0yZ62Dtq1ze
         yap3zArJVoaU3RPxz9s1VT96T+N1zZFKgei68SBrNyWijWizC4GHL6ivYbfNxCb9cF1Z
         aFCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a2HTm3KOv0Z8HJoze2OjkAd2YBNF85LGZH52VXfPgqs=;
        b=iazYrQmCEyaQYDnvLpRfxmJo8+Qva+5EUEV8p3VNhSrJ6fYgp1dCM/ZTajYuBd+FqH
         vaijglZATOHPwlI8+8klJiIbxj9whM6vQHvdQFh0CWGSkomd3gkT1Ajbn9LQWXwpouPZ
         ereZpqt/xGU4aEd7etTD5MxtmGu/UbiGeHdNhctFspAJl53qwi2qFxL5KMeiRbR+SzSE
         Q1T0S9cN0gG69cS5NGQObYDWJUUZp+I2bqB4rPXNAVETBbWzLm2/cyAiy/yQRBSY7nmg
         55/Njl/+IQ3OteDMkktiKhvR2+NluX+7pPyRTj8gW6J/hDIX+CBB/vc+eh1rAWMMFOP6
         jC4A==
X-Gm-Message-State: AOAM531aUxWtSIUO6IjU9isJTfc2gXf6FbPLwYof7OCvxe/dxsGV/GtW
        Po7BgFnphjRa74uv07jThh1PhYXg+t3aQ5DHL/M=
X-Google-Smtp-Source: ABdhPJxCRQCoklODuoDgiWCBO3W1quztLP50pmXq22Yavm2mLJO4Lpjxq0l0zEMXa1xkRWmNM/VMUIy6ixMIPpZ9gd4=
X-Received: by 2002:a17:906:490d:: with SMTP id b13mr11549213ejq.122.1602206386937;
 Thu, 08 Oct 2020 18:19:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200930020300.62245-1-xiangxia.m.yue@gmail.com> <CA+FuTSed1GsGp8a=GnHqV-HUcsOSZ0tb0NCe8360S8Md3MbS3g@mail.gmail.com>
In-Reply-To: <CA+FuTSed1GsGp8a=GnHqV-HUcsOSZ0tb0NCe8360S8Md3MbS3g@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 9 Oct 2020 09:16:14 +0800
Message-ID: <CAMDZJNWX=3ikS5f0H+xD-dByW2=JHXjvk1=R=CkDLt0TW-orTg@mail.gmail.com>
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

On Wed, Sep 30, 2020 at 6:05 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Sep 30, 2020 at 4:05 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Allow user configuring RXCSUM separately with ethtool -K,
> > reusing the existing virtnet_set_guest_offloads helper
> > that configures RXCSUM for XDP. This is conditional on
> > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> >
> > If Rx checksum is disabled, LRO should also be disabled.
> >
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The first patch was merged into net.
>
> Please wait until that is merged into net-next, as this depends on the
> other patch.
>
> > ---
> > v2:
> > * LRO depends the rx csum
> > * remove the unnecessary check
> > ---
> >  drivers/net/virtio_net.c | 49 ++++++++++++++++++++++++++++++----------
> >  1 file changed, 37 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 21b71148c532..5407a0106771 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
> >                                 (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> >                                 (1ULL << VIRTIO_NET_F_GUEST_UFO))
> >
> > +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > +
> >  struct virtnet_stat_desc {
> >         char desc[ETH_GSTRING_LEN];
> >         size_t offset;
> > @@ -2522,29 +2524,49 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
> >         return 0;
> >  }
> >
> > +static netdev_features_t virtnet_fix_features(struct net_device *netdev,
> > +                                             netdev_features_t features)
> > +{
> > +       /* If Rx checksum is disabled, LRO should also be disabled.
> > +        * That is life. :)
>
> Please remove this second line.
OK
> > +        */
> > +       if (!(features & NETIF_F_RXCSUM))
> > +               features &= ~NETIF_F_LRO;
> > +
> > +       return features;
> > +}
> > +
> >  static int virtnet_set_features(struct net_device *dev,
> >                                 netdev_features_t features)
> >  {
> >         struct virtnet_info *vi = netdev_priv(dev);
> > -       u64 offloads;
> > +       u64 offloads = vi->guest_offloads &
> > +                      vi->guest_offloads_capable;
>
> When can vi->guest_offloads have bits set outside the mask of
> vi->guest_offloads_capable?
In this case, we can use only vi->guest_offloads. and
guest_offloads_capable will not be used any more.
so should we remove guest_offloads_capable ?


-- 
Best regards, Tonghao

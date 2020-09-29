Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE8127BA68
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgI2Bmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbgI2Bmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:42:49 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5B6C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 18:42:48 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id e22so4549431edq.6
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 18:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IQKWtC0wIHlSJXdfuyYSbunoEcU6dfwYtAy5hCXjdZ8=;
        b=NrBpM1Pu4gPdmggMcZ8OxQ/ECw5kW4etkMwgZvySzOblDj4FUJwORp/LkrTWrpnrkV
         W5jH8xHGLT5lVqELy/zvIUC7u3ZTmBJWCn0QdISXTjIWbyC4VCoXen1apEzowuKTq64m
         FaWjVeIxTldjKwxjfoEdTcrrHk7XwDzucdLWewkjNscz8vrUigsHHrrBq7DV7F5/V7dk
         Wb85rVrqoJxhd2soAN8QK+tawYf6dPYOxQOsh9ZNm2uhXlw7onghNTqGJRFZjh70vy9F
         rPPeGtEw5lCzL18umFYymXqo+GjFWrbQGiIefwY3eCVmhPJh9OC53/p2yFibNHDfDDRL
         YuRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IQKWtC0wIHlSJXdfuyYSbunoEcU6dfwYtAy5hCXjdZ8=;
        b=gQjs5S71fEDryFkvgfkvrjjZq4aUpL2RWOs3Ea1MO6hoaU9ZhWLGHIJUb1Jqm87h/B
         wFXojYowYP/7nLk+pwBbHJYfOAJPpdcC+df6TZTnMIi6K+aVqodjC8BuhvidmOq4mBYl
         3Kdq2tX3YGqO438JrlQueK+qGSzmAVw6CiU6SMdm4ZBv93E4o2eZ0CLBMSzqtqHic6Go
         0fvbsqTzFLcw2Un5LOwjWlPvp85elmfleYHFi+h6bx3Xp44AorCWm91XonWka40qjTxq
         GCEMjxywJUL6TmePP0C2qgMa2vexdxfKEK6pakwOMmBIviFskjWDRQFSAWmiz02aU0QK
         8YJA==
X-Gm-Message-State: AOAM532sRgSml6Oc6g49sZ8qeq5ID/W7OMnZi99CGjSzIsPmLJbDiEMU
        H6/GpWPb044FP75flQOQq2+QuWRhFP241ucwTHo=
X-Google-Smtp-Source: ABdhPJxWP+vDQBZIyhqtl/TJR0OyD55XOIXLvNoXKt1oybE+bSm9jtwbhrvExc8KL6cFbnfaY5ZQWkamrUbHYzePfnM=
X-Received: by 2002:a05:6402:2c3:: with SMTP id b3mr796758edx.213.1601343766492;
 Mon, 28 Sep 2020 18:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com> <20200928151531-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200928151531-mutt-send-email-mst@kernel.org>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 29 Sep 2020 09:40:22 +0800
Message-ID: <CAMDZJNV_A+EuqFGEhB_-g_5unUJ9TyyDZu1krtxBS22EnW1mAw@mail.gmail.com>
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

On Tue, Sep 29, 2020 at 3:21 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Sep 28, 2020 at 11:39:14AM +0800, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Open vSwitch and Linux bridge will disable LRO of the interface
> > when this interface added to them. Now when disable the LRO, the
> > virtio-net csum is disable too. That drops the forwarding performance.
> >
> > Fixes: e59ff2c49ae1 ("virtio-net: disable guest csum during XDP set")
>
> I am a bit confused by this tag. Did this change bring about
> disabling checksum when LRO is disabled? I am not sure
> I follow how ...
Hi Michael
It's not right fix tag.
The commit a02e8964eaf9 ("virtio-net: ethtool configurable LRO"),
disable the csum, when we disable the LRO

> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  drivers/net/virtio_net.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 7145c83c6c8c..21b71148c532 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -63,6 +63,11 @@ static const unsigned long guest_offloads[] = {
> >       VIRTIO_NET_F_GUEST_CSUM
> >  };
> >
> > +#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> > +                             (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> > +                             (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > +                             (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > +
> >  struct virtnet_stat_desc {
> >       char desc[ETH_GSTRING_LEN];
> >       size_t offset;
> > @@ -2531,7 +2536,8 @@ static int virtnet_set_features(struct net_device *dev,
> >               if (features & NETIF_F_LRO)
> >                       offloads = vi->guest_offloads_capable;
> >               else
> > -                     offloads = 0;
> > +                     offloads = vi->guest_offloads_capable &
> > +                                ~GUEST_OFFLOAD_LRO_MASK;
> >
> >               err = virtnet_set_guest_offloads(vi, offloads);
> >               if (err)
> > --
> > 2.23.0
>


-- 
Best regards, Tonghao

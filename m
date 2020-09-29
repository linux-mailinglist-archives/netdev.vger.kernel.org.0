Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DD127BD85
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgI2HBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI2HBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 03:01:31 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0CEC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:01:29 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c8so5162986edv.5
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6FpQU46O4XX7PspnZBfr4+krtVC3YDEqV8ZUznNkTjc=;
        b=ArrwmDOzWhdNaRIIKFZGLmvvV6ddxJx+/n+apInuYhOBMWokidaGcy6mfM75qIYZxv
         b3zGbovXJ4c9eXJu9zZTt9SqP5tSt4gX5UlvcNTzHjMHL2M1RJZ0iJ0RHoKrJfXdKemr
         HCO1R32v7BrUoJahWAaFOUwi3yq12tAMHzcl20evrO424qEBpHy3kKWMn74CALVma/mb
         cNyJrlEKtHjMZyvNDjn6mBUxKSpR2JqheO/FuG2ScROpboVzv3FvGVtf0tK9Jxa8pf6K
         a8Xo6wxFgPo06oEbKmrYNUxc0JLNmCnrDAOckI1fPG6/Rvwzv5gzb4As/oMmLljvGrGy
         Dk9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6FpQU46O4XX7PspnZBfr4+krtVC3YDEqV8ZUznNkTjc=;
        b=FJU9I1QuTPXHg8Xmn6nAkxKCQHG4bmnRRZ6UyS7mduo43W13l+cqSBkHgChE1qxQ3L
         HC5RPckPk0KZwElHNaCv4QSFHKlDt8mKxN+MDydXvVjLwozgNs3vy1Ub972vytYbxK0j
         Bq72+oT1jIwh3qIQOS5BhjIiT3cc5BcQ64WbjK78SQzpi/KN/isxdE/B08GRMaStWwGi
         blC4X2f7+6BTYutBossgmaUwL5hbj4487pPiJRBw5GnbGE841/W+vnJErHNLA9Wq2Z4S
         e6mZfQTDKj5S+/74+vRnl07s4YJ+4fVodNNz/ggRlztsbn0m1zYfLURkcsDsskaeMqH1
         u3Xg==
X-Gm-Message-State: AOAM531mmoTgIozpfISpLfJKT+34umP11VkQlUQb83wihQineaF86dO4
        GUPLL4b34HGSPJlO9Brt4UQwQeibtSXaV+0+jPdc1ZMYSRo=
X-Google-Smtp-Source: ABdhPJxqaoenk2GDSZXo79HFW8w9lqiOFaaEUGWp51velKCS1oFo9BKRf0EZoyxqGb7U74b/LTi+rTr4odyU7ckH5j4=
X-Received: by 2002:a05:6402:304f:: with SMTP id bu15mr1700728edb.201.1601362888358;
 Tue, 29 Sep 2020 00:01:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200929015806.19171-1-xiangxia.m.yue@gmail.com> <20200929022246-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200929022246-mutt-send-email-mst@kernel.org>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 29 Sep 2020 14:59:03 +0800
Message-ID: <CAMDZJNWM7eBkrYk9nkEvPyHW7=kt_hTHGQCDB1CPRz=EV6vJcQ@mail.gmail.com>
Subject: Re: [PATCH net v2] virtio-net: don't disable guest csum when disable LRO
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 2:23 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Sep 29, 2020 at 09:58:06AM +0800, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Open vSwitch and Linux bridge will disable LRO of the interface
> > when this interface added to them. Now when disable the LRO, the
> > virtio-net csum is disable too. That drops the forwarding performance.
> >
> > Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> > v2:
> > * change the fix-tag
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
>
> I think I'd rather we open-coded this, the macro is only
> used in one place ...
Yes, in this patch, it is used only in one place. But in next patch
[1], we use it twice and that make the code look a bit nicer.
Would we open-coded this in this patch ?

[1] - http://patchwork.ozlabs.org/project/netdev/patch/20200928033915.82810-2-xiangxia.m.yue@gmail.com/

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
>
> > --
> > 2.23.0
>


-- 
Best regards, Tonghao

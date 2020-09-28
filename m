Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5FD27AAAC
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgI1JZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgI1JZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 05:25:06 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C335C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 02:25:06 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l17so491880edq.12
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 02:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D54y3w+nC4nVWs7Kc//fHorCLSEx8nCQ+X16e2eDf14=;
        b=LKeWaMM23bFWnothf8UNYy+IVMcB9xCJ9DPOEjaISvkbMppRy8WT5dOTlyUwCKw7TT
         hjIhKrBSTxj7UoJtIqrqf/xo/gcz7xYlDRm8uM8eO3ihYlb5MPb11ryzqXYHRxKAwnMm
         kIuA07d1ZI6eS7CU1kH/Af+2buP/jrKy6cio98vuZ973gF4Nc48ZxiPgOqyT8nX/j7zz
         SQKHGTw5Od9Fru8pUddZhrqsHew5iAkEMnfsi3ZEx60fDc0CSQRUsPmelklPDix0/Evv
         WxsgY6LBVONJDiZo38OFbACx5eIpOtmu6MrFOAMlVW5VPsmp4PySYMPBQvh6rEsV4X5Q
         7Clw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D54y3w+nC4nVWs7Kc//fHorCLSEx8nCQ+X16e2eDf14=;
        b=k2RunhMgK9jRBCgaeIwGnDzvWR7boIzTEv2sWn11iAkGXegpYy5tm+FYaxkkqXJuQX
         hmjmhPRTY4gr2W1Ceepe1a4Y0gKrmw0PIT6/5qTf8pqYAl7S7ndPw7+vCPBzCrtlEE1v
         YZ+kqbuCrHLkcjCbouIGZWtF0646bnsSN26lyaoJxGdEY8Xzmaqa+8z8XtBYxNUJ7m9m
         dYnSAAnVTdVCYc48iTy/vxtUGEVkv4aZIQrBuvqyEqciyngpHipsdhDK1YIBcdyprTLx
         jQG9gY1KzEji084/Ujw14r0LJ91rIguhUT1PW78GteEz3lQhL7nEE8sgx8GpZFl6Feoe
         tS1Q==
X-Gm-Message-State: AOAM532x55Xxp5SPGjImFej/HMsqOVmaOM995dv950NL/7LjdhhedSIf
        h3o7gRLSEwyp1itELTW8gGh8RGgqHRxwqR4uT+gI6hQa
X-Google-Smtp-Source: ABdhPJxR6b3+1zzRBUVLqpxSSiAWiCWb5Sh5292b3+AcD6At3PjbCLi8ucjBdo9k7H+vplPCduJl41tAx1bXHOKIDZI=
X-Received: by 2002:a05:6402:304f:: with SMTP id bu15mr661152edb.201.1601285105029;
 Mon, 28 Sep 2020 02:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
 <20200928033915.82810-2-xiangxia.m.yue@gmail.com> <CA+FuTSeOzCAVShBa1VTXtkqzc9YFdng_Dk1wVbjVeniTRREM=A@mail.gmail.com>
In-Reply-To: <CA+FuTSeOzCAVShBa1VTXtkqzc9YFdng_Dk1wVbjVeniTRREM=A@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 28 Sep 2020 17:22:53 +0800
Message-ID: <CAMDZJNWBtbB07czxpgmGXEazFSKuaToaWPAGxt4ts2AeV8BJnw@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio-net: ethtool configurable RXCSUM
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 4:39 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Sep 28, 2020 at 5:42 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Allow user configuring RXCSUM separately with ethtool -K,
> > reusing the existing virtnet_set_guest_offloads helper
> > that configures RXCSUM for XDP. This is conditional on
> > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> >
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  drivers/net/virtio_net.c | 40 ++++++++++++++++++++++++++++------------
> >  1 file changed, 28 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 21b71148c532..2e3af0b2c281 100644
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
> > @@ -2526,25 +2528,37 @@ static int virtnet_set_features(struct net_device *dev,
> >                                 netdev_features_t features)
> >  {
> >         struct virtnet_info *vi = netdev_priv(dev);
> > -       u64 offloads;
> > +       u64 offloads = vi->guest_offloads &
> > +                      vi->guest_offloads_capable;
> >         int err;
> >
> > -       if ((dev->features ^ features) & NETIF_F_LRO) {
> > -               if (vi->xdp_queue_pairs)
> > -                       return -EBUSY;
> > +       /* Don't allow configuration while XDP is active. */
> > +       if (vi->xdp_queue_pairs)
> > +               return -EBUSY;
> >
> > +       if ((dev->features ^ features) & NETIF_F_LRO) {
> >                 if (features & NETIF_F_LRO)
> > -                       offloads = vi->guest_offloads_capable;
> > +                       offloads |= GUEST_OFFLOAD_LRO_MASK;
> >                 else
> > -                       offloads = vi->guest_offloads_capable &
> > -                                  ~GUEST_OFFLOAD_LRO_MASK;
> > +                       offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> > +       }
> >
> > -               err = virtnet_set_guest_offloads(vi, offloads);
> > -               if (err)
> > -                       return err;
> > -               vi->guest_offloads = offloads;
> > +       if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> > +               if (features & NETIF_F_RXCSUM)
> > +                       offloads |= GUEST_OFFLOAD_CSUM_MASK;
> > +               else
> > +                       offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
> >         }
>
> LRO requires receive checksum offload: packets must have their
> checksum verified prior to coalescing.
Oh, sorry for that, I will change that patch. thanks!
> The two features can thus not be configured fully independently.



-- 
Best regards, Tonghao

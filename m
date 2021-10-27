Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D956F43C3D8
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbhJ0H1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:27:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240384AbhJ0H1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:27:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635319512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DbPmqjJWgzA3Y/zZgHiZJYXUBsMyJrhMz63cdq96J9s=;
        b=R7gecuaI1c2ZHQjqbNvjR4nldc0VjNw49LkLIi+QrbmzHT569LRL8b/ehAR5vzmAQA2p+g
        l4/HGtACQkvHLfTAarnNiEHvSTmyKaX298elpvj5r6YYQhJ3CnmzX+quydpFYT9t+7vBEC
        ZdZpY2YeZXRzm/mXhbc9ieCc+7z9XJw=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-0greNRMIOsSXl936zLwNxw-1; Wed, 27 Oct 2021 03:25:08 -0400
X-MC-Unique: 0greNRMIOsSXl936zLwNxw-1
Received: by mail-lf1-f72.google.com with SMTP id f13-20020a056512228d00b003ffd53671d8so313543lfu.14
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 00:25:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DbPmqjJWgzA3Y/zZgHiZJYXUBsMyJrhMz63cdq96J9s=;
        b=GsRXMIn8MWQ+2XCLZaTlSQ3qlKkIIKOwoLAMB8Aku/IwNHFrt3LhRXfcb0inPI+5ZV
         Np2mex8gikddoLJ+SmzWzpPUpqOZ9hBUS6ZeWvylFf9L/DnVRPZlSV8cXmqeIg0zc16r
         vhck1lSf6j54wyqdUpk42U07DnPXJAicrrzynJGIUSkpUgF8VIoHI3mzwWDJeqgFQgDd
         Mji5T1ZE0S+wJfy3nKrGkeRdrTK43V62TOex1mIzpoiQ0Ne98pU81/ypFLrSCPza5lkD
         HPOzSqJKG4o3m1s+qmUOPRes0ilMGHOc2ZJefC3mjt0NGURgqmAh/kkCvORr3MW9edTI
         dHKQ==
X-Gm-Message-State: AOAM533otgQFWTu4i1816FsXkHmRl7mVANVot7fAClgCMTy7X32QRoNZ
        foYUnZluZGdmRhM/+Q4/W1/U2kFaKLjrApPVlASs/P/EvSplZXdp1Sp49sM7gPgRp8UUPV5mAUC
        fxnFWwfWQbp2QJ2dS2T7lKeENDj2pK+Vw
X-Received: by 2002:a2e:5344:: with SMTP id t4mr31144647ljd.362.1635319506837;
        Wed, 27 Oct 2021 00:25:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx60K3agBV72twigmEzIG4Fvw5bMCI5GhxSGQ19U5tE6uaE7t6SoxPwUooNXl7eML2YSuLhLTyhqBbs6SAqrUA=
X-Received: by 2002:a2e:5344:: with SMTP id t4mr31144627ljd.362.1635319506634;
 Wed, 27 Oct 2021 00:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211026175634.3198477-1-kuba@kernel.org> <CACGkMEu6ZnyJF2nKS-GURc2Fz8BqUY6OGFEa71fNKPfGA0Wp7g@mail.gmail.com>
In-Reply-To: <CACGkMEu6ZnyJF2nKS-GURc2Fz8BqUY6OGFEa71fNKPfGA0Wp7g@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 27 Oct 2021 15:24:55 +0800
Message-ID: <CACGkMEvWKOLWEuexbdZozYzzRWPM-Wnf8ms4wLk6gX76hWmzwA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: virtio: use eth_hw_addr_set()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 10:45 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, Oct 27, 2021 at 1:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > of VLANs...") introduced a rbtree for faster Ethernet address look
> > up. To maintain netdev->dev_addr in this tree we need to make all
> > the writes to it go through appropriate helpers.
>
> I think the title should be "net: virtio: use eth_hw_addr_set()"

I meant "dev_addr_set()" actually.

Thanks

>
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > CC: mst@redhat.com
> > CC: jasowang@redhat.com
> > CC: virtualization@lists.linux-foundation.org
> > ---
> >  drivers/net/virtio_net.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index c501b5974aee..b7f35aff8e82 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3177,12 +3177,16 @@ static int virtnet_probe(struct virtio_device *vdev)
> >         dev->max_mtu = MAX_MTU;
> >
> >         /* Configuration may specify what MAC to use.  Otherwise random. */
> > -       if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC))
> > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
> > +               u8 addr[MAX_ADDR_LEN];
> > +
> >                 virtio_cread_bytes(vdev,
> >                                    offsetof(struct virtio_net_config, mac),
> > -                                  dev->dev_addr, dev->addr_len);
> > -       else
> > +                                  addr, dev->addr_len);
> > +               dev_addr_set(dev, addr);
> > +       } else {
> >                 eth_hw_addr_random(dev);
> > +       }
>
> Do we need to change virtnet_set_mac_address() as well?
>
> Thanks
>
> >
> >         /* Set up our device-specific information */
> >         vi = netdev_priv(dev);
> > --
> > 2.31.1
> >


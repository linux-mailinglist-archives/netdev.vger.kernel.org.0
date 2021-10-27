Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA9B43C41E
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240554AbhJ0Hm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:42:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240555AbhJ0Hm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:42:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635320431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TEMdpklZCdrGSBmQUj25Y0ktpMBCup6v7uzdSdkzaUk=;
        b=V9dPGyQTGMIDYQqgEuls5sHP/8L9NbKPf1x1pfFPG6UnW7q34g517Cc/atyKE5WiXWTFOs
        LC7l7zcWuPjgZBwoH2UwpxBpNUUe+Mg2Ww8vFYUsx1KhS7TKT94a+5sZ4a8GYbMTQPL8YR
        s0RzpPCBwREARWmda2f/z6wMg983vyA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-9Dr8YTAUNQ-pTzaDtcXBSA-1; Wed, 27 Oct 2021 03:40:30 -0400
X-MC-Unique: 9Dr8YTAUNQ-pTzaDtcXBSA-1
Received: by mail-wm1-f70.google.com with SMTP id l187-20020a1c25c4000000b0030da46b76daso1782384wml.9
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 00:40:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TEMdpklZCdrGSBmQUj25Y0ktpMBCup6v7uzdSdkzaUk=;
        b=0v2+iLsR3S3U4oPfxn1iy5iaToOOtiOhJM0IdEfxaNaO1jGJ1AFn7U9SV/f/Sgb/+M
         BqAWm8G66/z9lDx5wQTFfJA6JwppDCEH90OFJxK2c7hhawphmw+TP/dkFu+7dPvhauMB
         eYpH2a65Pzd05zinWDQnb0ayX40eFV4LHPgj/4BcJIYTGzHbzN88L8xv3tU+BmERpDVQ
         SoIZ69C3n3Zk2pIpNjQDvdVAYudypLt3KqBu33u7jEPSnSdbPWKZFzWVZ5bbejMqg732
         ZWvSMfJRnIr820Rh62a83VGd1nK3r+/FovmiNIWjFiOREtcHE3OvV2AkXVe9G77LhJAN
         c0Yw==
X-Gm-Message-State: AOAM530cyHvNsAWNhAIqLwQ30uY6weNjnsX7GFZ271rvhFh5tz137pto
        aMKJL6QrI5rvm4S7ergYZ/dptM/BJepnwkVnjAGftUWWmojAz8p4hxJryVuYF2Gqx0ba1DWnZXT
        Vf0al/YG58flEacn1
X-Received: by 2002:adf:e412:: with SMTP id g18mr3753002wrm.432.1635320429110;
        Wed, 27 Oct 2021 00:40:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXkAgCBgSDgFmaA5XGsk/PKUZtfwuVXsdd5KlKKdpYl/Yabs7af1uQPQN6+bhbIMXZyAywnA==
X-Received: by 2002:adf:e412:: with SMTP id g18mr3752995wrm.432.1635320428972;
        Wed, 27 Oct 2021 00:40:28 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:a543:72f:c4d1:8911:6346])
        by smtp.gmail.com with ESMTPSA id q14sm11526705wrv.55.2021.10.27.00.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 00:40:28 -0700 (PDT)
Date:   Wed, 27 Oct 2021 03:40:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH net-next] net: virtio: use eth_hw_addr_set()
Message-ID: <20211027033958-mutt-send-email-mst@kernel.org>
References: <20211026175634.3198477-1-kuba@kernel.org>
 <CACGkMEu6ZnyJF2nKS-GURc2Fz8BqUY6OGFEa71fNKPfGA0Wp7g@mail.gmail.com>
 <CACGkMEvWKOLWEuexbdZozYzzRWPM-Wnf8ms4wLk6gX76hWmzwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvWKOLWEuexbdZozYzzRWPM-Wnf8ms4wLk6gX76hWmzwA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 03:24:55PM +0800, Jason Wang wrote:
> On Wed, Oct 27, 2021 at 10:45 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Wed, Oct 27, 2021 at 1:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > > of VLANs...") introduced a rbtree for faster Ethernet address look
> > > up. To maintain netdev->dev_addr in this tree we need to make all
> > > the writes to it go through appropriate helpers.
> >
> > I think the title should be "net: virtio: use eth_hw_addr_set()"
> 
> I meant "dev_addr_set()" actually.
> 
> Thanks


Good point, this confused me too. Could be fixed up when applying?

> >
> > >
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > ---
> > > CC: mst@redhat.com
> > > CC: jasowang@redhat.com
> > > CC: virtualization@lists.linux-foundation.org
> > > ---
> > >  drivers/net/virtio_net.c | 10 +++++++---
> > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index c501b5974aee..b7f35aff8e82 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -3177,12 +3177,16 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >         dev->max_mtu = MAX_MTU;
> > >
> > >         /* Configuration may specify what MAC to use.  Otherwise random. */
> > > -       if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC))
> > > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
> > > +               u8 addr[MAX_ADDR_LEN];
> > > +
> > >                 virtio_cread_bytes(vdev,
> > >                                    offsetof(struct virtio_net_config, mac),
> > > -                                  dev->dev_addr, dev->addr_len);
> > > -       else
> > > +                                  addr, dev->addr_len);
> > > +               dev_addr_set(dev, addr);
> > > +       } else {
> > >                 eth_hw_addr_random(dev);
> > > +       }
> >
> > Do we need to change virtnet_set_mac_address() as well?
> >
> > Thanks
> >
> > >
> > >         /* Set up our device-specific information */
> > >         vi = netdev_priv(dev);
> > > --
> > > 2.31.1
> > >


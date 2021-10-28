Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0CF43D957
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 04:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhJ1CdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 22:33:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhJ1CdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 22:33:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635388248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q3qRktrDZtvaYh1K6rXXgHvHdfmThWB3M78MTr+j2As=;
        b=gyPK/qTZEYUP8P9a/a+Y/NoIm4+XeG/TKI4Y/6CQVRasbuK6kazRwpeBcW2p5EhxSibcdY
        v/LJzeaJnczu9dBGO9VlkOp6ZF50rx+fW2ikyOGeu4jpQgD/9Rchhix7w+aAp5Wawl4068
        yvtD34dtvrZ5+KEEYflaXeF3sNZa/i0=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-SNJmWPkwM_GxUK-v8J1Pfw-1; Wed, 27 Oct 2021 22:30:47 -0400
X-MC-Unique: SNJmWPkwM_GxUK-v8J1Pfw-1
Received: by mail-lf1-f71.google.com with SMTP id f13-20020a056512228d00b003ffd53671d8so1483277lfu.14
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 19:30:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q3qRktrDZtvaYh1K6rXXgHvHdfmThWB3M78MTr+j2As=;
        b=fevOlT5U2JeO7Rljd61OMX12xKForufn7y2rGmvMSfA3r70A/+0046AZZOgVXuCzFC
         CDjhvSU7X+tLLqaSfqCtHlJ7XQEA/GBhWxSna7Y9RoTYSjpc9brLG8/uNUdSrTQkD3lG
         W7yRHkj/eEwdb5GzLzRa/NFK8TAHIRSLFD8+RZZs9pdcIv5b12i+sK/iIPaKYeH0PLNm
         AqdHMC4vhLTBsIeIOaLNbGAh3O8pG9yUxn0lx7tQEmgpNS8KuKnYOj42EnHOUCggIsqx
         dBJOgLPDMrKrk4H4GRhqN+cQ0DXfPOEiXlQgmrHBcEQ1uGbdHuxgn7vnJvYbtP/G5iDl
         Tzkw==
X-Gm-Message-State: AOAM533NWBkn4ObhVK7NBGxuuNp3ILD2vxWGu/cJFJ9MX/ovqdrtQAu0
        WI/3enRPYxIgcYgPw9NQYFFCQIL5ipsXXS2InykEgGb9T8KB4/eeCTt60dS1kWx9rXKs72sttQs
        FjVUaP1RenZcZT4Rw3rylnaqcm55P1H5B
X-Received: by 2002:a05:6512:1291:: with SMTP id u17mr1462660lfs.84.1635388245922;
        Wed, 27 Oct 2021 19:30:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwv40ZuZY7bdVdkZG2ijgIgHr8upPl1ETTaDY/LJKvRVhoK0WuC8SyD/3/Y9K6G6AJO+LYjny9BO9rozIKbw2Y=
X-Received: by 2002:a05:6512:1291:: with SMTP id u17mr1462642lfs.84.1635388245770;
 Wed, 27 Oct 2021 19:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211027152012.3393077-1-kuba@kernel.org> <20211027113033-mutt-send-email-mst@kernel.org>
In-Reply-To: <20211027113033-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 28 Oct 2021 10:30:34 +0800
Message-ID: <CACGkMEtSTf3xiBaUeoyW4B=uTst5B3Ew2yfWe7bcpiLm4FiHYA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: virtio: use eth_hw_addr_set()
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 11:31 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Oct 27, 2021 at 08:20:12AM -0700, Jakub Kicinski wrote:
> > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > of VLANs...") introduced a rbtree for faster Ethernet address look
> > up. To maintain netdev->dev_addr in this tree we need to make all
> > the writes to it go through appropriate helpers.
> >
> > Even though the current code uses dev->addr_len the we can switch
> > to eth_hw_addr_set() instead of dev_addr_set(). The netdev is
> > always allocated by alloc_etherdev_mq() and there are at least two
> > places which assume Ethernet address:
> >  - the line below calling eth_hw_addr_random()
> >  - virtnet_set_mac_address() -> eth_commit_mac_addr_change()
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

>
> > ---
> > v2: - actually switch to eth_hw_addr_set() not dev_addr_set()
> >     - resize the buffer to ETH_ALEN
> >     - pass ETH_ALEN instead of dev->dev_addr to virtio_cread_bytes()
> >
> > CC: mst@redhat.com
> > CC: jasowang@redhat.com
> > CC: virtualization@lists.linux-foundation.org
> > ---
> >  drivers/net/virtio_net.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index c501b5974aee..cc79343cd220 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3177,12 +3177,16 @@ static int virtnet_probe(struct virtio_device *vdev)
> >       dev->max_mtu = MAX_MTU;
> >
> >       /* Configuration may specify what MAC to use.  Otherwise random. */
> > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC))
> > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
> > +             u8 addr[ETH_ALEN];
> > +
> >               virtio_cread_bytes(vdev,
> >                                  offsetof(struct virtio_net_config, mac),
> > -                                dev->dev_addr, dev->addr_len);
> > -     else
> > +                                addr, ETH_ALEN);
> > +             eth_hw_addr_set(dev, addr);
> > +     } else {
> >               eth_hw_addr_random(dev);
> > +     }
> >
> >       /* Set up our device-specific information */
> >       vi = netdev_priv(dev);
> > --
> > 2.31.1
>


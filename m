Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B07327BCA1
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 07:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgI2F5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 01:57:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725764AbgI2F5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 01:57:02 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601359022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7sAUumQ3LtY3a6NnfdifHLAxDChsRCTw8gS8QJu5HtI=;
        b=MFkWGmoLLbD7OqSSr2g8UpuKzxZkTkV0sDJhbUd9bus2x5IUWnpoWTgM3eSPaCchb8fvys
        8XnH0KAYJv24ClmOc56T1pRHXm+2AhRwdEdzSVK0d3U8IYbSj/N26RQjwlewaEWMKsjJYj
        CGq+kSXveuQkt81lU9+upNaV6mhuOjM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-2omg8zSEOWiSwqDkcm8q9g-1; Tue, 29 Sep 2020 01:56:58 -0400
X-MC-Unique: 2omg8zSEOWiSwqDkcm8q9g-1
Received: by mail-wr1-f69.google.com with SMTP id v5so1259643wrs.17
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 22:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7sAUumQ3LtY3a6NnfdifHLAxDChsRCTw8gS8QJu5HtI=;
        b=ULNWjOwnXd507qgw65ngp6ACz3f9YvsoyfnWUoOVCImhvrPWtGPyyK+Z3f+1oyyIxp
         PEvGoIt3Te0wLIxOo2hijnSQEjT/qEwSWqqlAjYJ8ZO2OSZG+ZhFZKS/Oy31VUHJJY8p
         AwuBgsg6rcs8msJosTNkTBzQJSdGV7otEQTN0UQCa2VDc7CTdr6XHyhjZMmyzY8UmRo5
         ELopf3GQdq+QAx8yB5PiWQFNyhmp0wToIto7N4YpCMuZczsD1sDhhmPgG2hHM9DjFdiH
         pAPl9IpKLJvpZTL4MHGOfxg8iJ0e615uKHcQGLNIJvT7p/+0qntwIWoukUXAE/Bp42UW
         r2xQ==
X-Gm-Message-State: AOAM53051R39bPBZ7srvysocgrYJNhdqZ6RckzSph6WuY4Z4mHEVQ7f1
        0Ri4uy/WNctVLQgZvVPy1EP+lwdZJNVkmw1jCthJOKBrak6WhB3vLLDbvD3Y4Sj97xDalq6Rvs0
        GkfBq0a/BZ2yW60uY
X-Received: by 2002:a5d:634d:: with SMTP id b13mr2188239wrw.324.1601359017678;
        Mon, 28 Sep 2020 22:56:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyM2A/ekxW5Bwb1A1nOpooejEQoSy10eakYmExcJHJ6eZcuPjgYm5pjbcgxCyi02Q40GK45Nw==
X-Received: by 2002:a5d:634d:: with SMTP id b13mr2188227wrw.324.1601359017479;
        Mon, 28 Sep 2020 22:56:57 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id f14sm4722311wrv.72.2020.09.28.22.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 22:56:56 -0700 (PDT)
Date:   Tue, 29 Sep 2020 01:56:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH 1/2] virtio-net: don't disable guest csum when disable LRO
Message-ID: <20200929015624-mutt-send-email-mst@kernel.org>
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
 <20200928151531-mutt-send-email-mst@kernel.org>
 <CAMDZJNV_A+EuqFGEhB_-g_5unUJ9TyyDZu1krtxBS22EnW1mAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMDZJNV_A+EuqFGEhB_-g_5unUJ9TyyDZu1krtxBS22EnW1mAw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:40:22AM +0800, Tonghao Zhang wrote:
> On Tue, Sep 29, 2020 at 3:21 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Sep 28, 2020 at 11:39:14AM +0800, xiangxia.m.yue@gmail.com wrote:
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > Open vSwitch and Linux bridge will disable LRO of the interface
> > > when this interface added to them. Now when disable the LRO, the
> > > virtio-net csum is disable too. That drops the forwarding performance.
> > >
> > > Fixes: e59ff2c49ae1 ("virtio-net: disable guest csum during XDP set")
> >
> > I am a bit confused by this tag. Did this change bring about
> > disabling checksum when LRO is disabled? I am not sure
> > I follow how ...
> Hi Michael
> It's not right fix tag.
> The commit a02e8964eaf9 ("virtio-net: ethtool configurable LRO"),
> disable the csum, when we disable the LRO

OK then, pls send a correct Fixes tag when you repost this ...

> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Jason Wang <jasowang@redhat.com>
> > > Cc: Willem de Bruijn <willemb@google.com>
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > ---
> > >  drivers/net/virtio_net.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 7145c83c6c8c..21b71148c532 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -63,6 +63,11 @@ static const unsigned long guest_offloads[] = {
> > >       VIRTIO_NET_F_GUEST_CSUM
> > >  };
> > >
> > > +#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> > > +                             (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> > > +                             (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > +                             (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > +
> > >  struct virtnet_stat_desc {
> > >       char desc[ETH_GSTRING_LEN];
> > >       size_t offset;
> > > @@ -2531,7 +2536,8 @@ static int virtnet_set_features(struct net_device *dev,
> > >               if (features & NETIF_F_LRO)
> > >                       offloads = vi->guest_offloads_capable;
> > >               else
> > > -                     offloads = 0;
> > > +                     offloads = vi->guest_offloads_capable &
> > > +                                ~GUEST_OFFLOAD_LRO_MASK;
> > >
> > >               err = virtnet_set_guest_offloads(vi, offloads);
> > >               if (err)
> > > --
> > > 2.23.0
> >
> 
> 
> -- 
> Best regards, Tonghao


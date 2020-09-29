Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759E227BE72
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgI2HzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgI2HzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 03:55:19 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21FCC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:55:16 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id h26so3536038ejq.3
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UYWbaC8aE126T5Hj/W5A6qSb9Eu6WNag0875Och8Hj8=;
        b=q3UY85kYH/ftJxjf4HUMlmXQB7aWGNGt7k7K6R9t9xSBktnKPbi0m8m0njP6xlXI83
         +A/aVV1pirG8rIao8b48e76AgHA0h70IdhiZrDHEyfBEf9IfJQ0AtFNo6bjENIR40SR8
         QxdwkVNQeG36EubJFVnVTf4/KD00+aC1Ax1KCxY0FGVPgwvChlSnmqkTsCaEGzVUb+F8
         dpctKQxtnHOFE60/qfm/f7AHJ4KSHs0nZBNPcYct9MKIlVzBsFzqWWyii0vRlBE05I8a
         Y7DHIYlIveaJNz6Uu6KID27kBjfLxS92aGJ63zlE7ertHe8UY9j8AIAr0GIbyxRLBTUG
         8DoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UYWbaC8aE126T5Hj/W5A6qSb9Eu6WNag0875Och8Hj8=;
        b=IoWYnzT/f8T5UZ8XhNLnyBdqyYeIR99AykciEpe/4prZyTSnvqIvRGpedaMacEyAGw
         qHH9PWRewLcBGPpvYpvoT5ffQjJ7KMkcNzDYSM3uuvJaUakI3nvtwUMoB14kLSBMESGf
         waQKCGQW2hEsupJon9XqhcAaYe8YjePSjZ95s2uziHgjVABwMue7dam5VYPIr3VP6Fb7
         F7sacetnhOGSF2dfK4VKNpdnQH+pAmIapkEvQOz4ea20LVd0MdWF4hB+R20jKadLKBqC
         mKKG/3bi7qh+l1l5d1NY4032Ec2AGcnCGQ3xHtaSHpns6u6wbDvL6i4Y58gjcrbyWBfX
         IPAg==
X-Gm-Message-State: AOAM531YzxKkuMllr0DkO5GC+nWVSp9/Y1I+5KaR64cgtUI0Qv43ELdc
        E3/q7M7WCq3piPPY4zZnRqc+E/bF2Lw5/Fq6coM=
X-Google-Smtp-Source: ABdhPJw2blRXVy3vvgyOw6gmyB/cgS0V0ZxGeeOpOq/evab2dKaH7d40B5QYi38OVhBibn7wVpzHZbHEsjYhUFK2N6w=
X-Received: by 2002:a17:906:1690:: with SMTP id s16mr2587774ejd.122.1601366115502;
 Tue, 29 Sep 2020 00:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200929015806.19171-1-xiangxia.m.yue@gmail.com> <CA+FuTSebRQ=2VfT0KnM6ChjMg0j3NWJDPwn9S=aQk8tbNrUt6w@mail.gmail.com>
In-Reply-To: <CA+FuTSebRQ=2VfT0KnM6ChjMg0j3NWJDPwn9S=aQk8tbNrUt6w@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 29 Sep 2020 15:52:50 +0800
Message-ID: <CAMDZJNW=hEEcsJy1gUEwrnERRgH3kRBkEuDtcPwPdfXr91eTGg@mail.gmail.com>
Subject: Re: [PATCH net v2] virtio-net: don't disable guest csum when disable LRO
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 3:32 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 4:00 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Open vSwitch and Linux bridge will disable LRO of the interface
> > when this interface added to them. Now when disable the LRO, the
> > virtio-net csum is disable too. That drops the forwarding performance.
>
> I had focused on the code previously.
>
> The s/w checksum verification cost is significant in a VM with traffic
> to local destinations. A bridge does not verify transport layer
> checksums OTOH?
Hi Willem.
No, think about GRO(In the GRO we don't know packets will be forwarded
to other ports or to local). The call tree as below:
   + 5.41% secondary_startup_64
   - 1.22% ret_from_fork
....
        net_rx_action
        napi_poll
        virtnet_poll
        virtnet_receive
        napi_gro_receive
        dev_gro_receive
        inet_gro_receive
        tcp4_gro_receive
        __skb_gro_checksum_complete
        skb_checksum
        __skb_checksum
        csum_partial
        do_csum
   - 1.13% do_csum

$ brctl show
bridge name bridge id STP enabled interfaces
br0 8000.001122330001 no eth1
eth2


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
> >         VIRTIO_NET_F_GUEST_CSUM
> >  };
> >
> > +#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> > +                               (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> > +                               (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > +                               (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > +
> >  struct virtnet_stat_desc {
> >         char desc[ETH_GSTRING_LEN];
> >         size_t offset;
> > @@ -2531,7 +2536,8 @@ static int virtnet_set_features(struct net_device *dev,
> >                 if (features & NETIF_F_LRO)
> >                         offloads = vi->guest_offloads_capable;
> >                 else
> > -                       offloads = 0;
> > +                       offloads = vi->guest_offloads_capable &
> > +                                  ~GUEST_OFFLOAD_LRO_MASK;
> >
> >                 err = virtnet_set_guest_offloads(vi, offloads);
> >                 if (err)
> > --
> > 2.23.0
> >



-- 
Best regards, Tonghao

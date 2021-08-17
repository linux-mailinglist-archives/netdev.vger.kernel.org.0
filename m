Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65A33EE6D5
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 08:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbhHQGqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 02:46:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234454AbhHQGqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 02:46:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629182761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lXzAWi/HXh25vel2OolK4VZSzbIL75BQ1OCpFeAQ1hU=;
        b=ZCe+wHKa9q+XDBSEhGQPeOTBGqdZf9OjwJ3O+DROsXK114p9py6DwvDKjpO9AwnT2GTpbC
        MEwXLNNbHvzEbAbWCospUV815d9yCkJahdHTZspzmkiunVV0HFcd3yrczm5OhQMBrY2ykl
        MgGBIrRzXuPt6LdjBkXibSRdaZBaauI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-Opb7qwmmMLGGsFmvix_Q9Q-1; Tue, 17 Aug 2021 02:46:00 -0400
X-MC-Unique: Opb7qwmmMLGGsFmvix_Q9Q-1
Received: by mail-ed1-f70.google.com with SMTP id x4-20020a50d9c4000000b003bed5199871so3920567edj.14
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 23:46:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lXzAWi/HXh25vel2OolK4VZSzbIL75BQ1OCpFeAQ1hU=;
        b=b0K0yFu5E6yB28fFpn5fu5tS4vvZloZV21ZZVDsHxFzrTsy7/W7cFKbPU0Ounqcl/g
         yveRwVxzenL9xkIwPUnVHL01Zq7bqDu2SoI5GdeU28syr3R3ATyAdxFbn4CQM2FWl3hX
         UVFR7d0PMEtpxMhzl6zN19wQvYejkYZj5DnFFTDmSXHg5Zcyn/2rKOjhVmmGFBHARBQ+
         EPumwXd1S7P2Pns7ODcjz+YXwRm+ZTFfazTqctaVd//vQmoflv5mxLbHJduwLnuJDboL
         N9Y+aXybs6LBqBczwdW4NrJaW9jANZyheqY4R/eg36Wr+YNvstHPrTHDPWHKaluAoDI3
         uS+Q==
X-Gm-Message-State: AOAM532rRT0x0bnNT4qLjV5ox1ccg6d0srj8YZzmV0LB1IzIc9gMJx80
        xwwLe2S/4MGhk34X1J4drlDyTC6MKVmn5J0MfAwWEpbu8ckiTPqQLF+Mq9zw2T+ChK39QAY8tMG
        3HjTezvuym3iYhLQ0
X-Received: by 2002:a05:6402:2789:: with SMTP id b9mr2370511ede.44.1629182759255;
        Mon, 16 Aug 2021 23:45:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzH2wWiYROA/dfLu4hqPoGlGhFo7q8W4+f9VoW35hDbwGSiGiLOK+rAIUjANWYFYXWhk+AKuA==
X-Received: by 2002:a05:6402:2789:: with SMTP id b9mr2370494ede.44.1629182759049;
        Mon, 16 Aug 2021 23:45:59 -0700 (PDT)
Received: from redhat.com ([2.55.150.133])
        by smtp.gmail.com with ESMTPSA id qh2sm337553ejb.75.2021.08.16.23.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 23:45:58 -0700 (PDT)
Date:   Tue, 17 Aug 2021 02:45:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, willemb@google.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ivan@prestigetransportation.com,
        xiangxia.m.yue@gmail.com
Subject: Re: [PATCH net] virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
Message-ID: <20210817023118-mutt-send-email-mst@kernel.org>
References: <20210817020338.6400-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817020338.6400-1-jasowang@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch is good. Suggest some tweaks to the commit log.

On Tue, Aug 17, 2021 at 10:03:38AM +0800, Jason Wang wrote:
> Commit a02e8964eaf92 ("virtio-net: ethtool configurable LRO") tries to
> advertise LRO on behalf of the guest offloading features and allow the

tries to advertise -> advertises

that part actually works.

allow -> allows

on behalf of features is really weird. maybe "maps"?

> administrator to enable and disable those features via ethtool.
> 
> This may lead several issues:

may lead->lead to

> 
> - For the device that doesn't support control guest offloads, the
>   "LRO" can't be disabled so we will get a warn in the

warn -> warning

>   dev_disable_lro()

.. when turning off LRO or when enabling forwarding bridging etc.

> - For the device that have the control guest offloads, the guest

have the -> supports

>   offloads were disabled in the case of bridge etc

etc -> forwarding etc

> which may slow down

were -> are

may slow -> slows

>   the traffic.
> 
> Fixing this by using NETIF_F_GRO_HW instead. Though the spec does not
> guaranteed to be re-segmented as original explicitly now, we can add

guaranteed -> guarantee

> that to the spec

I would add:

Further, we never advertised LRO historically before a02e8964eaf92
("virtio-net: ethtool configurable LRO") and so bridged/forwarded
configs effectively relied on virtio receive offloads being GRO.




> and then we can catch the bad configuration and
> setup.

Don't know what does this part mean. How would we catch it?
With a new flag? Let's say so.

> 
> Fixes: a02e8964eaf92 ("virtio-net: ethtool configurable LRO")
> Signed-off-by: Jason Wang <jasowang@redhat.com>



Proposed rewritten commit log:

===
[PATCH net] virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO

Commit a02e8964eaf92 ("virtio-net: ethtool configurable LRO")
maps LRO to virtio guest offloading features and allows the
administrator to enable and disable those features via ethtool.
 
This leads to several issues:


- For a device that doesn't support control guest offloads, the "LRO"
  can't be disabled triggering WARN in dev_disable_lro() when turning
  off LRO or when enabling forwarding bridging etc.

- For a device that supports control guest offloads, the guest
  offloads are disabled in cases of bridging, forwarding etc
  slowing down the traffic.
 
Fix this by using NETIF_F_GRO_HW instead. Though the spec does not
guarantee packets to be re-segmented as the original ones,
we can add that to the spec, possibly with a flag for devices to
differentiate between GRO and LRO.

Further, we never advertised LRO historically before a02e8964eaf92
("virtio-net: ethtool configurable LRO") and so bridged/forwarded
configs effectively always relied on virtio receive offloads behaving
like GRO - thus even if this breaks any configs it is at least not
a regression.

Fixes: a02e8964eaf92 ("virtio-net: ethtool configurable LRO")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reported-by: Ivan <ivan@prestigetransportation.com>
Tested-by: Ivan <ivan@prestigetransportation.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>

===


> ---
>  drivers/net/virtio_net.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0416a7e00914..10c382b08bce 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -63,7 +63,7 @@ static const unsigned long guest_offloads[] = {
>  	VIRTIO_NET_F_GUEST_CSUM
>  };
>  
> -#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> +#define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
>  				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
>  				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
>  				(1ULL << VIRTIO_NET_F_GUEST_UFO))
> @@ -2481,7 +2481,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>  	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
>  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
>  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
> -		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing LRO/CSUM, disable LRO/CSUM first");
> +		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
>  		return -EOPNOTSUPP;
>  	}
>  
> @@ -2612,15 +2612,15 @@ static int virtnet_set_features(struct net_device *dev,
>  	u64 offloads;
>  	int err;
>  
> -	if ((dev->features ^ features) & NETIF_F_LRO) {
> +	if ((dev->features ^ features) & NETIF_F_GRO_HW) {
>  		if (vi->xdp_enabled)
>  			return -EBUSY;
>  
> -		if (features & NETIF_F_LRO)
> +		if (features & NETIF_F_GRO_HW)
>  			offloads = vi->guest_offloads_capable;
>  		else
>  			offloads = vi->guest_offloads_capable &
> -				   ~GUEST_OFFLOAD_LRO_MASK;
> +				   ~GUEST_OFFLOAD_GRO_HW_MASK;
>  
>  		err = virtnet_set_guest_offloads(vi, offloads);
>  		if (err)
> @@ -3100,9 +3100,9 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		dev->features |= NETIF_F_RXCSUM;
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>  	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> -		dev->features |= NETIF_F_LRO;
> +		dev->features |= NETIF_F_GRO_HW;
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> -		dev->hw_features |= NETIF_F_LRO;
> +		dev->hw_features |= NETIF_F_GRO_HW;
>  
>  	dev->vlan_features = dev->features;
>  
> -- 
> 2.25.1


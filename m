Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E1A27B53B
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgI1TZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:25:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726656AbgI1TZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:25:18 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601321116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2nKTlXCHkk0I+UzMY9e22BDypXWl7/hOf+zrdkgOpTo=;
        b=bNNmzgIR89bgwCxZZB0v6o2cnJY1AiuBpnNt6sURcS2yxBcUS2cIyE3oP2aKU3aqpraqiA
        wB5Nc7G3EaQWzyPx5OL3Vw0TRyE4ll9C8sQUka/FShh4vpKRl8I0JZwOGn0mBfdotAhVMm
        BWykjXMt5xkVNuMXbNO08AAXGE/egkw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-kQtBAbMBP8ebQTOAonIoGQ-1; Mon, 28 Sep 2020 15:25:14 -0400
X-MC-Unique: kQtBAbMBP8ebQTOAonIoGQ-1
Received: by mail-wr1-f69.google.com with SMTP id b2so779230wrs.7
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 12:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2nKTlXCHkk0I+UzMY9e22BDypXWl7/hOf+zrdkgOpTo=;
        b=SyvyjALMrH1613JMIeaK7J+ErfE9LiQDLorS2/edAnOpYYfiIVXdxA6LFpS9uWwV15
         gMV0+BeFFr65wbk+tIB/QJR4RqADhGb7MU/qprygwHkywTl+RjuUpAwmRQ2AnMLhQ2fO
         6fuGdGJ/CRQ5dX7dbUQlfE5uESlpcmd1EHtCp9LHtq92QYR4lPLd0zXlNglsf/hOnd/h
         fHs3OkONZc0+ukhzhM5tfZxt2O4uNzISK+TRqt0xoS25WUDsJBBCFTPIEA/1y1Rxk/GS
         15lTkHzh+OT3nZV43gUsX6cWcGiJGJd8ITSO7dAjocW66nH1ei48RYk/v/KfBFKnkvzE
         bvcw==
X-Gm-Message-State: AOAM532ij2cpt3Phg7Lu0rxyQ7ao88Atu4WLda//oeO0N52GsxHm4u0T
        EWH7gt2uOozXcuNgWjlGMDHlDQKUymYj81z1Nr5y7WCJHnp7b+/iy4lCQ93mrG22a/ULXGsgGsB
        xLE9Nf8gMp14eSOyd
X-Received: by 2002:adf:eacf:: with SMTP id o15mr67866wrn.12.1601321113607;
        Mon, 28 Sep 2020 12:25:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7xSjUlrIYA4jwMpqWY182+T5ivdXhloLPiggvlGpfiY12bL5p1W8yFCJEjoKt1aJv2vxTvQ==
X-Received: by 2002:adf:eacf:: with SMTP id o15mr67852wrn.12.1601321113379;
        Mon, 28 Sep 2020 12:25:13 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id o16sm2604020wrp.52.2020.09.28.12.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 12:25:12 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:25:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     xiangxia.m.yue@gmail.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio-net: ethtool configurable RXCSUM
Message-ID: <20200928152142-mutt-send-email-mst@kernel.org>
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
 <20200928033915.82810-2-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928033915.82810-2-xiangxia.m.yue@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 11:39:15AM +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Allow user configuring RXCSUM separately with ethtool -K,
> reusing the existing virtnet_set_guest_offloads helper
> that configures RXCSUM for XDP. This is conditional on
> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  drivers/net/virtio_net.c | 40 ++++++++++++++++++++++++++++------------
>  1 file changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 21b71148c532..2e3af0b2c281 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
>  				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
>  				(1ULL << VIRTIO_NET_F_GUEST_UFO))
>  
> +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> +
>  struct virtnet_stat_desc {
>  	char desc[ETH_GSTRING_LEN];
>  	size_t offset;
> @@ -2526,25 +2528,37 @@ static int virtnet_set_features(struct net_device *dev,
>  				netdev_features_t features)
>  {
>  	struct virtnet_info *vi = netdev_priv(dev);
> -	u64 offloads;
> +	u64 offloads = vi->guest_offloads &
> +		       vi->guest_offloads_capable;
>  	int err;
>  
> -	if ((dev->features ^ features) & NETIF_F_LRO) {
> -		if (vi->xdp_queue_pairs)
> -			return -EBUSY;
> +	/* Don't allow configuration while XDP is active. */
> +	if (vi->xdp_queue_pairs)
> +		return -EBUSY;
>  
> +	if ((dev->features ^ features) & NETIF_F_LRO) {
>  		if (features & NETIF_F_LRO)
> -			offloads = vi->guest_offloads_capable;
> +			offloads |= GUEST_OFFLOAD_LRO_MASK;
>  		else
> -			offloads = vi->guest_offloads_capable &
> -				   ~GUEST_OFFLOAD_LRO_MASK;
> +			offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> +	}
>  
> -		err = virtnet_set_guest_offloads(vi, offloads);
> -		if (err)
> -			return err;
> -		vi->guest_offloads = offloads;
> +	if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> +		if (features & NETIF_F_RXCSUM)
> +			offloads |= GUEST_OFFLOAD_CSUM_MASK;
> +		else
> +			offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
>  	}
>  
> +	if (offloads == (vi->guest_offloads &
> +			 vi->guest_offloads_capable))
> +		return 0;

Hmm, what exactly does this do?

> +
> +	err = virtnet_set_guest_offloads(vi, offloads);
> +	if (err)
> +		return err;
> +
> +	vi->guest_offloads = offloads;
>  	return 0;
>  }
>  
> @@ -3013,8 +3027,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>  	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
>  		dev->features |= NETIF_F_LRO;
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> +		dev->hw_features |= NETIF_F_RXCSUM;
>  		dev->hw_features |= NETIF_F_LRO;
> +	}
>  
>  	dev->vlan_features = dev->features;
>  
> -- 
> 2.23.0


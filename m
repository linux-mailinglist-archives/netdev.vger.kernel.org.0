Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C43927E634
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgI3KHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:07:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbgI3KHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:07:02 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601460421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BwVIHLEWodPVOSsatT81+9zezrxEE2RvlRZKZt8C+R0=;
        b=IFP4H0QPKMSi/WidQRXNQO4QlAb30HsR9U0M6BmIBW3hhtklK7Q9iAxN1CQGnqrffUbKlP
        WiTIiEfMIReVHeiQ5t0piLp8W/NYHdVJ3YlGgx5WLWE6MqIAzlteuhD8n/wkP/v6YQ+ZKb
        8Dmh/KWlAxrp8QJCdTUPa83yS2eZU20=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-CWI6YIp1NFWFtFaQDfC5kw-1; Wed, 30 Sep 2020 06:06:59 -0400
X-MC-Unique: CWI6YIp1NFWFtFaQDfC5kw-1
Received: by mail-wr1-f71.google.com with SMTP id h4so429523wrb.4
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 03:06:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BwVIHLEWodPVOSsatT81+9zezrxEE2RvlRZKZt8C+R0=;
        b=fLbeCCqMEm5zPgv34eP/6+MrQLZaCDwKUnE9nK7ljzGpuNHH2aAz4m+QVa6YqIl9xh
         cu2CVO/8YZaEHex+dED3O5fyqfAr/WZgtU4l9spTRDFHLOQQ55ExDDMBT9G02LDvTshd
         RXJQLgIzLhKXJEhyL6BQd5/Dkzl59ebppmxb0133XPfK3vjqomHJ4G5H3S5Ul/T/0KlQ
         Ot9j71LntZNRoN7/ldQgJoI84qDH3mgZjyqw7d1RURSdbRHfr+OrrMKqMgh2gr/k2cpC
         rWuypD/IiqrrkwKZ3+l/rosj4pwe0fXEOvFafSv5EijwuFbl+ijP1oo6or9fX2FbhHC6
         e19w==
X-Gm-Message-State: AOAM532syj1/raecytVhySJZWwKZw1GV977DOS2UXNQl0kC4Ue5zTsB2
        GEwV/yaP/IplMDelGltfrpqGFTsVZEA0f8Vj3lbak9DsK3f/yv1HtYCuvB8VaTY1kqX4IwhAQ0z
        Qja/Lx3Xr8VF44oNz
X-Received: by 2002:a5d:44cc:: with SMTP id z12mr2293414wrr.189.1601460417953;
        Wed, 30 Sep 2020 03:06:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXAUnYauOkE1JQ0+HRkYxCraj5fkodDQ5XeZ6e8HpPC6ihFDym5v/2ZUmtyKsepgbZSrnwrQ==
X-Received: by 2002:a5d:44cc:: with SMTP id z12mr2293384wrr.189.1601460417674;
        Wed, 30 Sep 2020 03:06:57 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id 70sm1974647wme.15.2020.09.30.03.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 03:06:56 -0700 (PDT)
Date:   Wed, 30 Sep 2020 06:06:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     xiangxia.m.yue@gmail.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] virtio-net: ethtool configurable RXCSUM
Message-ID: <20200930060625-mutt-send-email-mst@kernel.org>
References: <20200930020300.62245-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930020300.62245-1-xiangxia.m.yue@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:03:00AM +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Allow user configuring RXCSUM separately with ethtool -K,
> reusing the existing virtnet_set_guest_offloads helper
> that configures RXCSUM for XDP. This is conditional on
> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> 
> If Rx checksum is disabled, LRO should also be disabled.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> ---
> v2:
> * LRO depends the rx csum
> * remove the unnecessary check
> ---
>  drivers/net/virtio_net.c | 49 ++++++++++++++++++++++++++++++----------
>  1 file changed, 37 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 21b71148c532..5407a0106771 100644
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
> @@ -2522,29 +2524,49 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
>  	return 0;
>  }
>  
> +static netdev_features_t virtnet_fix_features(struct net_device *netdev,
> +					      netdev_features_t features)
> +{
> +	/* If Rx checksum is disabled, LRO should also be disabled.
> +	 * That is life. :)
> +	 */
> +	if (!(features & NETIF_F_RXCSUM))
> +		features &= ~NETIF_F_LRO;
> +
> +	return features;
> +}
> +
>  static int virtnet_set_features(struct net_device *dev,
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
> +	err = virtnet_set_guest_offloads(vi, offloads);
> +	if (err)
> +		return err;
> +
> +	vi->guest_offloads = offloads;
>  	return 0;
>  }
>  
> @@ -2563,6 +2585,7 @@ static const struct net_device_ops virtnet_netdev = {
>  	.ndo_features_check	= passthru_features_check,
>  	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
>  	.ndo_set_features	= virtnet_set_features,
> +	.ndo_fix_features	= virtnet_fix_features,
>  };
>  
>  static void virtnet_config_changed_work(struct work_struct *work)
> @@ -3013,8 +3036,10 @@ static int virtnet_probe(struct virtio_device *vdev)
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


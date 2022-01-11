Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D1148A6D1
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 05:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347891AbiAKEdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 23:33:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347876AbiAKEdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 23:33:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641875583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nLpbspIbehopKxn2rF3AjHCSmpudjuRm/i0geJ0lrYQ=;
        b=A1x/tR5PWav3EZ9JdLvW1F7hExQonXF+wYhFnhf8srDuFrhaPDayftEPZGXrqJ9WxGCyj4
        IZmrLb6vH/btKckgCt9oZ8JEabZrMoeAeLHY+RlY1nGBd6TAIef8dvbetfAUiS2ttT80sS
        jVis1TAc2L8VL3CGjl5Fz4IfPSjq+Ko=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-SPZYXRIBNDWliQw82BLpQw-1; Mon, 10 Jan 2022 23:33:02 -0500
X-MC-Unique: SPZYXRIBNDWliQw82BLpQw-1
Received: by mail-pl1-f198.google.com with SMTP id s11-20020a170902ea0b00b00149c6b7cde7so4116332plg.18
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 20:33:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nLpbspIbehopKxn2rF3AjHCSmpudjuRm/i0geJ0lrYQ=;
        b=Lwx+4RpumHe0+0NLMtSGaTBosYsmbE2EEhoPFoqEQ24rxk7TKzXcPOIgi0QOPjYrMD
         k2gLGB0BJ9UPskUbkf2AXnkLU0xHbzJof+5a+Kjpmu/YhOobLkbaCTQVlXCzAFVcdhJc
         kcYyB4WT0J6KPrXU9r9Z0tGZhqOwMAqjxcLntQtdLAr851GZUNywTIfylJTEBavUTpa1
         OJXyKIzr3eR99C1nw9rDDFmNfdGvpYYvMi0QooKd8PwQHULiEFezdZomlRw/vvzWgLLe
         tFNMnqv0xR9rnOHPzLRGRVxjjaZB3JpsZij6nVeHN6/qGu8OCoAU6l8ZUMiPkbksY7Jr
         eLMA==
X-Gm-Message-State: AOAM531pnZ/AzZXkjw5uy8UXddEOJVSsN8+ou0KnmMqXh99XJ53kb2NX
        ky/fXOx/b7WAB3EMFsoxuwfy9plBxO0DjmvGc0gpM9hrWQWbmsNtXTU9TAZw9yp3vP00XkDBL1N
        NcuiOzideCK3q23kv
X-Received: by 2002:a62:e711:0:b0:4bf:1965:35d4 with SMTP id s17-20020a62e711000000b004bf196535d4mr2956896pfh.48.1641875581608;
        Mon, 10 Jan 2022 20:33:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwNaV7c82GTwcVIr6bVq+wS3qfc+Iv4NnNHlsN4PtQHDG7TtmRMpXw1sIupeV+p2lx6OLxQwQ==
X-Received: by 2002:a62:e711:0:b0:4bf:1965:35d4 with SMTP id s17-20020a62e711000000b004bf196535d4mr2956878pfh.48.1641875581293;
        Mon, 10 Jan 2022 20:33:01 -0800 (PST)
Received: from [10.72.13.222] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t6sm3226769pgk.31.2022.01.10.20.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 20:33:00 -0800 (PST)
Message-ID: <e92eba5b-1fd6-0b58-6fb5-2e322fdad3ef@redhat.com>
Date:   Tue, 11 Jan 2022 12:32:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 4/4] drivers/net/virtio_net: Added RSS hash report
 control.
Content-Language: en-US
To:     Andrew Melnychenko <andrew@daynix.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
References: <20220109210659.2866740-1-andrew@daynix.com>
 <20220109210659.2866740-5-andrew@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220109210659.2866740-5-andrew@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/10 上午5:06, Andrew Melnychenko 写道:
> Now it's possible to control supported hashflows.
> Also added hashflow set/get callbacks.
> Also, disabling RXH_IP_SRC/DST for TCP would disable then for UDP.
> TCP and UDP supports only:
> ethtool -U eth0 rx-flow-hash tcp4 sd
>      RXH_IP_SRC + RXH_IP_DST
> ethtool -U eth0 rx-flow-hash tcp4 sdfn
>      RXH_IP_SRC + RXH_IP_DST + RXH_L4_B_0_1 + RXH_L4_B_2_3
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> ---
>   drivers/net/virtio_net.c | 159 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 159 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 6e7461b01f87..1b8dd384483c 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -235,6 +235,7 @@ struct virtnet_info {
>   	u8 rss_key_size;
>   	u16 rss_indir_table_size;
>   	u32 rss_hash_types_supported;
> +	u32 rss_hash_types_saved;
>   
>   	/* Has control virtqueue */
>   	bool has_cvq;
> @@ -2275,6 +2276,7 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
>   	int i = 0;
>   
>   	vi->ctrl->rss.table_info.hash_types = vi->rss_hash_types_supported;
> +	vi->rss_hash_types_saved = vi->rss_hash_types_supported;
>   	vi->ctrl->rss.table_info.indirection_table_mask = vi->rss_indir_table_size - 1;
>   	vi->ctrl->rss.table_info.unclassified_queue = 0;
>   
> @@ -2289,6 +2291,131 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
>   	netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
>   }
>   
> +static void virtnet_get_hashflow(const struct virtnet_info *vi, struct ethtool_rxnfc *info)
> +{
> +	info->data = 0;
> +	switch (info->flow_type) {
> +	case TCP_V4_FLOW:
> +		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_TCPv4) {
> +			info->data = RXH_IP_SRC | RXH_IP_DST |
> +						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
> +		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4) {
> +			info->data = RXH_IP_SRC | RXH_IP_DST;
> +		}
> +		break;
> +	case TCP_V6_FLOW:
> +		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_TCPv6) {
> +			info->data = RXH_IP_SRC | RXH_IP_DST |
> +						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
> +		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6) {
> +			info->data = RXH_IP_SRC | RXH_IP_DST;
> +		}
> +		break;
> +	case UDP_V4_FLOW:
> +		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_UDPv4) {
> +			info->data = RXH_IP_SRC | RXH_IP_DST |
> +						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
> +		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4) {
> +			info->data = RXH_IP_SRC | RXH_IP_DST;
> +		}
> +		break;
> +	case UDP_V6_FLOW:
> +		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_UDPv6) {
> +			info->data = RXH_IP_SRC | RXH_IP_DST |
> +						 RXH_L4_B_0_1 | RXH_L4_B_2_3;
> +		} else if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6) {
> +			info->data = RXH_IP_SRC | RXH_IP_DST;
> +		}
> +		break;
> +	case IPV4_FLOW:
> +		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4)
> +			info->data = RXH_IP_SRC | RXH_IP_DST;
> +
> +		break;
> +	case IPV6_FLOW:
> +		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv4)
> +			info->data = RXH_IP_SRC | RXH_IP_DST;
> +
> +		break;
> +	default:
> +		info->data = 0;
> +		break;
> +	}
> +}
> +
> +static bool virtnet_set_hashflow(struct virtnet_info *vi, struct ethtool_rxnfc *info)
> +{
> +	u64 is_iphash = info->data & (RXH_IP_SRC | RXH_IP_DST);
> +	u64 is_porthash = info->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3);
> +	u32 new_hashtypes = vi->rss_hash_types_saved;
> +
> +	if ((is_iphash && (is_iphash != (RXH_IP_SRC | RXH_IP_DST))) ||
> +	    (is_porthash && (is_porthash != (RXH_L4_B_0_1 | RXH_L4_B_2_3)))) {
> +		return false;
> +	}
> +
> +	if (!is_iphash && is_porthash)
> +		return false;


This seems not filter out all the combinations:

e.g RXH_VLAN with port hash?


> +
> +	switch (info->flow_type) {
> +	case TCP_V4_FLOW:
> +	case UDP_V4_FLOW:
> +	case IPV4_FLOW:
> +		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv4;
> +		if (is_iphash)
> +			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4;
> +
> +		break;
> +	case TCP_V6_FLOW:
> +	case UDP_V6_FLOW:
> +	case IPV6_FLOW:
> +		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv6;
> +		if (is_iphash)
> +			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6;
> +
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	switch (info->flow_type) {
> +	case TCP_V4_FLOW:
> +		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_TCPv4;


Any way to merge the two switch? The code is hard to be reviewed anyhow.


> +		if (is_porthash)
> +			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_TCPv4;
> +
> +		break;
> +	case UDP_V4_FLOW:
> +		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_UDPv4;
> +		if (is_porthash)
> +			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_UDPv4;
> +
> +		break;
> +	case TCP_V6_FLOW:
> +		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_TCPv6;
> +		if (is_porthash)
> +			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_TCPv6;
> +
> +		break;
> +	case UDP_V6_FLOW:
> +		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_UDPv6;
> +		if (is_porthash)
> +			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_UDPv6;
> +
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (new_hashtypes != vi->rss_hash_types_saved) {
> +		vi->rss_hash_types_saved = new_hashtypes;
> +		vi->ctrl->rss.table_info.hash_types = vi->rss_hash_types_saved;
> +		if (vi->dev->features & NETIF_F_RXHASH)
> +			return virtnet_commit_rss_command(vi);
> +	}
> +
> +	return true;
> +}
>   
>   static void virtnet_get_drvinfo(struct net_device *dev,
>   				struct ethtool_drvinfo *info)
> @@ -2574,6 +2701,27 @@ static int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
>   	switch (info->cmd) {
>   	case ETHTOOL_GRXRINGS:
>   		info->data = vi->curr_queue_pairs;
> +		break;
> +	case ETHTOOL_GRXFH:
> +		virtnet_get_hashflow(vi, info);
> +		break;
> +	default:
> +		rc = -EOPNOTSUPP;
> +	}
> +
> +	return rc;
> +}
> +
> +static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	int rc = 0;
> +
> +	switch (info->cmd) {
> +	case ETHTOOL_SRXFH:
> +		if (!virtnet_set_hashflow(vi, info))
> +			rc = -EINVAL;
> +
>   		break;
>   	default:
>   		rc = -EOPNOTSUPP;
> @@ -2602,6 +2750,7 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
>   	.get_rxfh = virtnet_get_rxfh,
>   	.set_rxfh = virtnet_set_rxfh,
>   	.get_rxnfc = virtnet_get_rxnfc,
> +	.set_rxnfc = virtnet_set_rxnfc,
>   };
>   
>   static void virtnet_freeze_down(struct virtio_device *vdev)
> @@ -2854,6 +3003,16 @@ static int virtnet_set_features(struct net_device *dev,
>   		vi->guest_offloads = offloads;
>   	}
>   
> +	if ((dev->features ^ features) & NETIF_F_RXHASH) {
> +		if (features & NETIF_F_RXHASH)
> +			vi->ctrl->rss.table_info.hash_types = vi->rss_hash_types_saved;
> +		else
> +			vi->ctrl->rss.table_info.hash_types = 0;


I think it's better to use VIRTIO_NET_HASH_REPORT_NONE here.

Thanks


> +
> +		if (!virtnet_commit_rss_command(vi))
> +			return -EINVAL;
> +	}
> +
>   	return 0;
>   }
>   


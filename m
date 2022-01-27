Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FCF49DC85
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237722AbiA0I0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:26:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231513AbiA0I0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:26:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643271976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NPZpEk9tAlF/9TYdHvnoR4LLaJ/T4+GkuS6a0bKM6ZY=;
        b=BIhkqPM7Y2dqiSfo5I2CHktt1zKdycMeALq0rNREH3o3VgdldznmlzoV4s84vE8Rxduyig
        cfArnpcl7m4sfSq8ZuROlmKt5TgpMWaIF9JRLVBgVCCorFznaKuqrqlVVbxHy2KKMFO/bp
        HFgWKQdPnXjYprlwrqPntsoDra7b05k=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-MgJB_VE7MDGCqctX-nnURw-1; Thu, 27 Jan 2022 03:26:14 -0500
X-MC-Unique: MgJB_VE7MDGCqctX-nnURw-1
Received: by mail-pj1-f72.google.com with SMTP id a4-20020a17090a70c400b001b21d9c8bc8so3906007pjm.7
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 00:26:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NPZpEk9tAlF/9TYdHvnoR4LLaJ/T4+GkuS6a0bKM6ZY=;
        b=fixiBqXQAgK4lQkDAA0idw2yY1FjgxFDXZV2TeMx8nsktDjkddS5gsxcEchEbeYuze
         KbS+ZZ3qWw19rBMSASl8rUENURA1qKw7EmJS5SabXQSubyjnWS4AeLckki8JTDbomjnM
         +PvWtzegHHDgrQtg4NoCmw3TsWYjRexIyn4AfcEvv9mZpmBJZdt/qZvtfYIqYcUwmgv7
         BVIOuKiVOHlOOnpLbFk3L7PhCe0U0k5NVh0tJ11yn+TB0e1BDGbABzeQ3PpnD7/AXKby
         FtlrjckonwXjMJDYyIQL/phW0LWEIvkzuXezGum2WGlwgRIONn9p6Y35Wddp6yWH9xTH
         qaGQ==
X-Gm-Message-State: AOAM530xOMKgwVE0TRFQWdUh9uKZIwPAWPstind8dWih98mVeyX94ywz
        04vVZkfXQoqsrblAnMehHGNBmNcw9MFFbgX5ATUM/Tut5Ij/QcLWgPE0RTJM+QChNNfyBeCx6yh
        l3sBq7vPxdrS0VDEo
X-Received: by 2002:a17:90b:4b83:: with SMTP id lr3mr12923220pjb.42.1643271973625;
        Thu, 27 Jan 2022 00:26:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgdc/o7y6Ezn5wb5v88KfeYn2L3mr1v3k4YeB6Heq9fEXuUbTvnqLgME9ezyVe/hgVzmKzfA==
X-Received: by 2002:a17:90b:4b83:: with SMTP id lr3mr12923196pjb.42.1643271973314;
        Thu, 27 Jan 2022 00:26:13 -0800 (PST)
Received: from [10.72.13.129] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k21sm4675088pff.33.2022.01.27.00.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 00:26:12 -0800 (PST)
Message-ID: <67ab707b-b2a1-9efe-df1a-777893dc7099@redhat.com>
Date:   Thu, 27 Jan 2022 16:26:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 4/4] drivers/net/virtio_net: Added RSS hash report
 control.
Content-Language: en-US
To:     Andrew Melnychenko <andrew@daynix.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
References: <20220117080009.3055012-1-andrew@daynix.com>
 <20220117080009.3055012-5-andrew@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220117080009.3055012-5-andrew@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/17 下午4:00, Andrew Melnychenko 写道:
> Now it's possible to control supported hashflows.
> Added hashflow set/get callbacks.
> Also, disabling RXH_IP_SRC/DST for TCP would disable then for UDP.
> TCP and UDP supports only:
> ethtool -U eth0 rx-flow-hash tcp4 sd
>      RXH_IP_SRC + RXH_IP_DST
> ethtool -U eth0 rx-flow-hash tcp4 sdfn
>      RXH_IP_SRC + RXH_IP_DST + RXH_L4_B_0_1 + RXH_L4_B_2_3
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 141 ++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 140 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2c61f96ce3e6..f837d3257eb6 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -231,6 +231,7 @@ struct virtnet_info {
>   	u8 rss_key_size;
>   	u16 rss_indir_table_size;
>   	u32 rss_hash_types_supported;
> +	u32 rss_hash_types_saved;
>   
>   	/* Has control virtqueue */
>   	bool has_cvq;
> @@ -2274,6 +2275,7 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
>   	int i = 0;
>   
>   	vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
> +	vi->rss_hash_types_saved = vi->rss_hash_types_supported;
>   	vi->ctrl->rss.indirection_table_mask = vi->rss_indir_table_size - 1;
>   	vi->ctrl->rss.unclassified_queue = 0;
>   
> @@ -2288,6 +2290,121 @@ static void virtnet_init_default_rss(struct virtnet_info *vi)
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
> +		if (vi->rss_hash_types_saved & VIRTIO_NET_RSS_HASH_TYPE_IPv6)
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
> +	u32 new_hashtypes = vi->rss_hash_types_saved;
> +	bool is_disable = info->data & RXH_DISCARD;
> +	bool is_l4 = info->data == (RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 | RXH_L4_B_2_3);
> +
> +	/* supports only 'sd', 'sdfn' and 'r' */
> +	if (!((info->data == (RXH_IP_SRC | RXH_IP_DST)) | is_l4 | is_disable))
> +		return false;
> +
> +	switch (info->flow_type) {
> +	case TCP_V4_FLOW:
> +		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv4 | VIRTIO_NET_RSS_HASH_TYPE_TCPv4);
> +		if (!is_disable)
> +			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4
> +				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_TCPv4 : 0);
> +		break;
> +	case UDP_V4_FLOW:
> +		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv4 | VIRTIO_NET_RSS_HASH_TYPE_UDPv4);
> +		if (!is_disable)
> +			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4
> +				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_UDPv4 : 0);
> +		break;
> +	case IPV4_FLOW:
> +		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv4;
> +		if (!is_disable)
> +			new_hashtypes = VIRTIO_NET_RSS_HASH_TYPE_IPv4;
> +		break;
> +	case TCP_V6_FLOW:
> +		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv6 | VIRTIO_NET_RSS_HASH_TYPE_TCPv6);
> +		if (!is_disable)
> +			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6
> +				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_TCPv6 : 0);
> +		break;
> +	case UDP_V6_FLOW:
> +		new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv6 | VIRTIO_NET_RSS_HASH_TYPE_UDPv6);
> +		if (!is_disable)
> +			new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6
> +				| (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_UDPv6 : 0);
> +		break;
> +	case IPV6_FLOW:
> +		new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv6;
> +		if (!is_disable)
> +			new_hashtypes = VIRTIO_NET_RSS_HASH_TYPE_IPv6;
> +		break;
> +	default:
> +		/* unsupported flow */
> +		return false;
> +	}
> +
> +	/* if unsupported hashtype was set */
> +	if (new_hashtypes != (new_hashtypes & vi->rss_hash_types_supported))
> +		return false;
> +
> +	if (new_hashtypes != vi->rss_hash_types_saved) {
> +		vi->rss_hash_types_saved = new_hashtypes;
> +		vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
> +		if (vi->dev->features & NETIF_F_RXHASH)
> +			return virtnet_commit_rss_command(vi);
> +	}
> +
> +	return true;
> +}
>   
>   static void virtnet_get_drvinfo(struct net_device *dev,
>   				struct ethtool_drvinfo *info)
> @@ -2573,6 +2690,27 @@ static int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
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
> @@ -2601,6 +2739,7 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
>   	.get_rxfh = virtnet_get_rxfh,
>   	.set_rxfh = virtnet_set_rxfh,
>   	.get_rxnfc = virtnet_get_rxnfc,
> +	.set_rxnfc = virtnet_set_rxnfc,
>   };
>   
>   static void virtnet_freeze_down(struct virtio_device *vdev)
> @@ -2855,7 +2994,7 @@ static int virtnet_set_features(struct net_device *dev,
>   
>   	if ((dev->features ^ features) & NETIF_F_RXHASH) {
>   		if (features & NETIF_F_RXHASH)
> -			vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
> +			vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
>   		else
>   			vi->ctrl->rss.hash_types = VIRTIO_NET_HASH_REPORT_NONE;
>   


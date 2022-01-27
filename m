Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780B649DC46
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbiA0ILy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:11:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230231AbiA0ILy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:11:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643271113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZuylhvZW6x86a+V3ZnUj04ytdDhKjPy9bvsW6hie+MI=;
        b=Kt5wGyI5MnrYoHdF5ikQOeDTYhJX4R6HXzvkdGh2EN3rYDonr7mu6Okd54U37KFyGTCuU/
        ELBU2WGiN/kHyiaBlMM9aKR7SjIXxLIRET29EGlP+k2S4Onil+r3rw/XFfn0jL3FVOfHhK
        rUUYB92FoVXerIobRLBFhlM66wTMT04=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-OSG_t8M6P12l-yHjBRDWQA-1; Thu, 27 Jan 2022 03:11:52 -0500
X-MC-Unique: OSG_t8M6P12l-yHjBRDWQA-1
Received: by mail-pl1-f199.google.com with SMTP id s19-20020a170902b19300b00149a463ad43so1193139plr.1
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 00:11:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZuylhvZW6x86a+V3ZnUj04ytdDhKjPy9bvsW6hie+MI=;
        b=d7I4vK9nrDKz9gzBc+TgzYAZUg89rM1I0NZur6EtE13h1nVIJUjL+mVcsfim4RU4UX
         BN7BEZn+2hFUEMp+2s8msokHD48nxdd+Nc0VhUilNn8ki+MiCg58ha4YdZI8jw5wmH7b
         tCs0T7WVeEneetz5QJePzF3UUAh/PasfphS8F8flr7OgtqW79OkbKVCjvfULPaXIR/ji
         sEl3P49Gde1FNS0G2IpnLocynqZ/px/GHoFQwAD4UfOB0YmncSOY3+P4L5Q14S15Eut5
         BMtWmxBbO7ML1jgWdCOFGAF4YAhkpuTToUPlSxJMYToTKtWfWcQthkOjVC9StHxi1C5F
         Wiyg==
X-Gm-Message-State: AOAM530IMpX0KlAgwrIG8t6740EMgWQAVf0ejBBf8+9dieBS0bvRpg2k
        V2K1+SlPkWPTNzO1FuiTsd+6huFYiZmaoPIiJxDA8MpZWUwvRnVvmMwdBE90uDjgwk9qk2e8r8b
        cbScQ4yAkmnneXH73
X-Received: by 2002:a17:902:c406:: with SMTP id k6mr2860113plk.96.1643271110822;
        Thu, 27 Jan 2022 00:11:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypuog472VkiNADz94IYec37oeQ0JMAbX9TfSK1gaeX1KWEh/IsZjnP5oH8QAPttv41Px2E6g==
X-Received: by 2002:a17:902:c406:: with SMTP id k6mr2860100plk.96.1643271110503;
        Thu, 27 Jan 2022 00:11:50 -0800 (PST)
Received: from [10.72.13.129] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m11sm18368079pgb.15.2022.01.27.00.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 00:11:49 -0800 (PST)
Message-ID: <6ef76a28-4836-cb55-cb4c-b9d0c5fac95e@redhat.com>
Date:   Thu, 27 Jan 2022 16:11:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 3/4] drivers/net/virtio_net: Added RSS hash report.
Content-Language: en-US
To:     Andrew Melnychenko <andrew@daynix.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
References: <20220117080009.3055012-1-andrew@daynix.com>
 <20220117080009.3055012-4-andrew@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220117080009.3055012-4-andrew@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/17 下午4:00, Andrew Melnychenko 写道:
> Added features for RSS hash report.
> If hash is provided - it sets to skb.
> Added checks if rss and/or hash are enabled together.
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> ---
>   drivers/net/virtio_net.c | 58 ++++++++++++++++++++++++++++++++--------
>   1 file changed, 47 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9aae11cb568e..2c61f96ce3e6 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -227,6 +227,7 @@ struct virtnet_info {
>   
>   	/* Host supports rss and/or hash report */
>   	bool has_rss;
> +	bool has_rss_hash_report;
>   	u8 rss_key_size;
>   	u16 rss_indir_table_size;
>   	u32 rss_hash_types_supported;
> @@ -420,7 +421,9 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	hdr_p = p;
>   
>   	hdr_len = vi->hdr_len;
> -	if (vi->mergeable_rx_bufs)
> +	if (vi->has_rss_hash_report)
> +		hdr_padded_len = sizeof(struct virtio_net_hdr_v1_hash);


This seems wrong, add_recvbuf_big() will always try to use sizeof(struct 
padded_vnet_hdr).

This can be tested by disabling mrg_rxbuf.


> +	else if (vi->mergeable_rx_bufs)
>   		hdr_padded_len = sizeof(*hdr);
>   	else
>   		hdr_padded_len = sizeof(struct padded_vnet_hdr);
> @@ -1156,6 +1159,8 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>   	struct net_device *dev = vi->dev;
>   	struct sk_buff *skb;
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
> +	struct virtio_net_hdr_v1_hash *hdr_hash;
> +	enum pkt_hash_types rss_hash_type;
>   
>   	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
>   		pr_debug("%s: short packet %i\n", dev->name, len);
> @@ -1182,6 +1187,29 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>   		return;
>   
>   	hdr = skb_vnet_hdr(skb);
> +	if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report) {
> +		hdr_hash = (struct virtio_net_hdr_v1_hash *)(hdr);
> +
> +		switch (hdr_hash->hash_report) {
> +		case VIRTIO_NET_HASH_REPORT_TCPv4:
> +		case VIRTIO_NET_HASH_REPORT_UDPv4:
> +		case VIRTIO_NET_HASH_REPORT_TCPv6:
> +		case VIRTIO_NET_HASH_REPORT_UDPv6:
> +		case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
> +		case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
> +			rss_hash_type = PKT_HASH_TYPE_L4;
> +			break;
> +		case VIRTIO_NET_HASH_REPORT_IPv4:
> +		case VIRTIO_NET_HASH_REPORT_IPv6:
> +		case VIRTIO_NET_HASH_REPORT_IPv6_EX:
> +			rss_hash_type = PKT_HASH_TYPE_L3;
> +			break;
> +		case VIRTIO_NET_HASH_REPORT_NONE:
> +		default:
> +			rss_hash_type = PKT_HASH_TYPE_NONE;
> +		}
> +		skb_set_hash(skb, hdr_hash->hash_value, rss_hash_type);
> +	}
>   
>   	if (hdr->hdr.flags & VIRTIO_NET_HDR_F_DATA_VALID)
>   		skb->ip_summed = CHECKSUM_UNNECESSARY;
> @@ -2232,7 +2260,8 @@ static bool virtnet_commit_rss_command(struct virtnet_info *vi)
>   	sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
>   
>   	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
> -				  VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
> +				  vi->has_rss ? VIRTIO_NET_CTRL_MQ_RSS_CONFIG
> +				  : VIRTIO_NET_CTRL_MQ_HASH_CONFIG, sgs)) {
>   		dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
>   		return false;
>   	}
> @@ -3230,6 +3259,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
>   	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
>   			     "VIRTIO_NET_F_CTRL_VQ") ||
>   	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
> +			     "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
>   			     "VIRTIO_NET_F_CTRL_VQ"))) {
>   		return false;
>   	}
> @@ -3365,16 +3396,18 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>   		vi->mergeable_rx_bufs = true;
>   
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
> +		vi->has_rss_hash_report = true;
> +
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
>   		vi->has_rss = true;
> +
> +	if (vi->has_rss || vi->has_rss_hash_report) {
>   		vi->rss_indir_table_size =
>   			virtio_cread16(vdev, offsetof(struct virtio_net_config,
> -						      rss_max_indirection_table_length));
> +					rss_max_indirection_table_length));


Unnecessary changes.


>   		vi->rss_key_size =
>   			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
> -	}
> -
> -	if (vi->has_rss) {


This can be squashed into previous patch.

Thanks


>   		vi->rss_hash_types_supported =
>   		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
>   		vi->rss_hash_types_supported &=
> @@ -3384,8 +3417,11 @@ static int virtnet_probe(struct virtio_device *vdev)
>   
>   		dev->hw_features |= NETIF_F_RXHASH;
>   	}
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
> -	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> +
> +	if (vi->has_rss_hash_report)
> +		vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
> +	else if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
> +		 virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
>   		vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
>   	else
>   		vi->hdr_len = sizeof(struct virtio_net_hdr);
> @@ -3452,7 +3488,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>   		}
>   	}
>   
> -	if (vi->has_rss)
> +	if (vi->has_rss || vi->has_rss_hash_report)
>   		virtnet_init_default_rss(vi);
>   
>   	err = register_netdev(dev);
> @@ -3587,7 +3623,7 @@ static struct virtio_device_id id_table[] = {
>   	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>   	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>   	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -	VIRTIO_NET_F_RSS
> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
>   
>   static unsigned int features[] = {
>   	VIRTNET_FEATURES,


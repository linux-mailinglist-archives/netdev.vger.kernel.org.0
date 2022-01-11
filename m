Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DB148A6AB
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 05:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347392AbiAKEGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 23:06:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59824 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347384AbiAKEGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 23:06:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641873960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j57iOHdt0+hHkG5NMCwdg6XG2RVl9jKj5pe7d1y/oaY=;
        b=eWUTpOzhGowD3o7g4MlK76uJIyrpFwOwch9NAivwWHIa9+iOCv/0YV8HT5NCVNpnDEQC0C
        xZjFoZ0oo0/hNubHPBgTfMkKYwu5BGb8b+iJfrmNUyYqS/e3dT7CVZpuz4bcipKxqIcJkg
        Irvf8urngaMR35AFiAltMfntPVn+KXI=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-lKm5Qd7pOJeQapiSAgjD3g-1; Mon, 10 Jan 2022 23:05:59 -0500
X-MC-Unique: lKm5Qd7pOJeQapiSAgjD3g-1
Received: by mail-pj1-f70.google.com with SMTP id 62-20020a17090a0fc400b001b31e840054so1451363pjz.1
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 20:05:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j57iOHdt0+hHkG5NMCwdg6XG2RVl9jKj5pe7d1y/oaY=;
        b=wH+oF3Fp8h+qD96E3xAR0Wu7YC0WJmbtiM+7AKXzNbvPQi2dzwT3nD8IdEdxz/6AAL
         BySlaZg9nZajUzJL+MI6RrBsKrEj220BlUc5oKzNznYBWHZ4vatrO01UCzuZECQvoO5h
         pSGEZ5KrZNrdLGbhyYqmMIyLyG+oI/lDZrs5cgPPO6L+eVQabakOywC7ShLMDkvUxuZa
         MiRHZrR2jg+yinHddQESIVAaaGPdvdxTCwn5XDnHdmaVZpaJKn7k6w+l/u9bBBOo4q9d
         OsU+jjn7fP1vw1FzpDmpGKxMfNIi0bONVu6aSW7cMPECifCxE5qNUcn5Gn60y9Q2bq+j
         ihkg==
X-Gm-Message-State: AOAM531U85j0gGpBHH1D1kS1CRs7UxxLjRlzIJxVjoYQFp762QPSG/Uh
        wE0wbItXOuYnl95kQmkeVdAK8UytZxGN6if9R8W9I+JEg1cGeUSGy76TZPRfrlurLZFzXEFB+Oa
        NGRwmP2an9W4kX2vB
X-Received: by 2002:a17:90a:e610:: with SMTP id j16mr1108017pjy.139.1641873957962;
        Mon, 10 Jan 2022 20:05:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyiyZ3FXmA3cDHJpzQKJdoRERQuq+I3vTjGX55+gVot2kVqfrz76/R4a7jnSeGoY38thvsbNQ==
X-Received: by 2002:a17:90a:e610:: with SMTP id j16mr1107999pjy.139.1641873957633;
        Mon, 10 Jan 2022 20:05:57 -0800 (PST)
Received: from [10.72.13.222] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d11sm8737373pfu.211.2022.01.10.20.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 20:05:57 -0800 (PST)
Message-ID: <60f24351-1011-de84-b443-ff5a50c3ff7f@redhat.com>
Date:   Tue, 11 Jan 2022 12:05:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 3/4] drivers/net/virtio_net: Added RSS hash report.
Content-Language: en-US
To:     Andrew Melnychenko <andrew@daynix.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
References: <20220109210659.2866740-1-andrew@daynix.com>
 <20220109210659.2866740-4-andrew@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220109210659.2866740-4-andrew@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/10 上午5:06, Andrew Melnychenko 写道:
> Added features for RSS hash report.
> If hash is provided - it sets to skb.
> Added checks if rss and/or hash are enabled together.
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> ---
>   drivers/net/virtio_net.c | 56 ++++++++++++++++++++++++++++++++++------
>   1 file changed, 48 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 21794731fc75..6e7461b01f87 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -231,6 +231,7 @@ struct virtnet_info {
>   
>   	/* Host supports rss and/or hash report */
>   	bool has_rss;
> +	bool has_rss_hash_report;
>   	u8 rss_key_size;
>   	u16 rss_indir_table_size;
>   	u32 rss_hash_types_supported;
> @@ -424,7 +425,9 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	hdr_p = p;
>   
>   	hdr_len = vi->hdr_len;
> -	if (vi->mergeable_rx_bufs)
> +	if (vi->has_rss_hash_report)
> +		hdr_padded_len = sizeof(struct virtio_net_hdr_v1_hash);
> +	else if (vi->mergeable_rx_bufs)
>   		hdr_padded_len = sizeof(*hdr);
>   	else
>   		hdr_padded_len = sizeof(struct padded_vnet_hdr);
> @@ -1160,6 +1163,8 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>   	struct net_device *dev = vi->dev;
>   	struct sk_buff *skb;
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
> +	struct virtio_net_hdr_v1_hash *hdr_hash;
> +	enum pkt_hash_types rss_hash_type;
>   
>   	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
>   		pr_debug("%s: short packet %i\n", dev->name, len);
> @@ -1186,6 +1191,29 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>   		return;
>   
>   	hdr = skb_vnet_hdr(skb);
> +	if (dev->features & NETIF_F_RXHASH) {
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
> @@ -2233,7 +2261,8 @@ static bool virtnet_commit_rss_command(struct virtnet_info *vi)
>   	sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
>   
>   	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
> -				  VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
> +				  vi->has_rss ? VIRTIO_NET_CTRL_MQ_RSS_CONFIG
> +				  : VIRTIO_NET_CTRL_MQ_HASH_CONFIG, sgs)) {
>   		dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
>   		return false;
>   	}
> @@ -3220,7 +3249,9 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
>   	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
>   	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
>   			     "VIRTIO_NET_F_CTRL_VQ") ||
> -	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS, "VIRTIO_NET_F_RSS"))) {
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS, "VIRTIO_NET_F_RSS") ||


I think we should make RSS depend on CTRL_VQ.


> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
> +			     "VIRTIO_NET_F_HASH_REPORT"))) {


Need to depend on CTRL_VQ here.


>   		return false;
>   	}
>   
> @@ -3355,6 +3386,12 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>   		vi->mergeable_rx_bufs = true;
>   
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT)) {
> +		vi->has_rss_hash_report = true;
> +		vi->rss_indir_table_size = 1;
> +		vi->rss_key_size = VIRTIO_NET_RSS_MAX_KEY_SIZE;


Any reason to initialize RSS feature here not the init_default_rss()?

Thanks


> +	}
> +
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
>   		vi->has_rss = true;
>   		vi->rss_indir_table_size =
> @@ -3364,7 +3401,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>   			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
>   	}
>   
> -	if (vi->has_rss) {
> +	if (vi->has_rss || vi->has_rss_hash_report) {
>   		vi->rss_hash_types_supported =
>   		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
>   		vi->rss_hash_types_supported &=
> @@ -3374,8 +3411,11 @@ static int virtnet_probe(struct virtio_device *vdev)
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
> @@ -3442,7 +3482,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>   		}
>   	}
>   
> -	if (vi->has_rss) {
> +	if (vi->has_rss || vi->has_rss_hash_report) {
>   		rtnl_lock();
>   		virtnet_init_default_rss(vi);
>   		rtnl_unlock();
> @@ -3580,7 +3620,7 @@ static struct virtio_device_id id_table[] = {
>   	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>   	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>   	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -	VIRTIO_NET_F_RSS
> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
>   
>   static unsigned int features[] = {
>   	VIRTNET_FEATURES,


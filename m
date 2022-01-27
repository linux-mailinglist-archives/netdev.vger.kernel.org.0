Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3548249DC02
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 08:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbiA0H5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 02:57:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233765AbiA0H5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 02:57:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643270231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rKEofx388MJV155pb0uGfd/Ni4klHP4l0jjlBsgi5xc=;
        b=AaKYZzavbiu5CvzC3O4KES0qV/INjgppJuoI//BFYsAuMXEv4Vmc7xa+b5N6/LBNobRpj1
        qmo0Qz7mS2P/bq4LCfEFKwOJtCQjZV2Gaqo1W75NItDrW+kjDieGq0XGgknQ+leeJh0fYj
        JI/qZvcbg5ubmTDTI492JCGQAd+FHc8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-N7ZfDl5RMD6JTb66TtTzkg-1; Thu, 27 Jan 2022 02:57:10 -0500
X-MC-Unique: N7ZfDl5RMD6JTb66TtTzkg-1
Received: by mail-pl1-f197.google.com with SMTP id v14-20020a170902e8ce00b0014b48e8e498so1171636plg.2
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 23:57:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rKEofx388MJV155pb0uGfd/Ni4klHP4l0jjlBsgi5xc=;
        b=zuB5C5FUHE58RzG95FHSTYbWoayR2OscJZg7dEk+Se5ySVA+C/pqG7Cp0ALM5KlQl5
         7/Oj/pW+MaVWLOisbkNRjv3GLs3Q/Q6a17kJUS8+XpFDcQ2zokdvKT523sa4xpYDExD0
         TopMmEzW+hsdhCurQIznE9WyW2Z1njXC+wp8IbA1PUi6Y0qN1B6fpqYEio0Lsl5pkRy/
         VaNL0ccL5y7b2ztHHS5EMgq7XCDzZxAsBCzqAMuQH9zwV+2uRbt7r44NduOSkRjfxthL
         iGxc5V9iP2F06iH1rg3UVPU2/5dIQPmdeAJtKRr8qbPJXmSS/QU7U3ilvDG2ZMoh15w2
         E0XQ==
X-Gm-Message-State: AOAM532RoIyZ/CKqpxcS6mBHny2I+YxwOL+KkDtrTzhwh1ENYiWSpmUe
        9KolsEGpwrdU/eGCSExY2JWIFev8Nv7vbWrhL0PNasPiKV4mD7q8/3NSlSK12qKs2+wTPnWHNx7
        cd/HixFS4cUHanrDT
X-Received: by 2002:a63:6909:: with SMTP id e9mr1956801pgc.514.1643270229410;
        Wed, 26 Jan 2022 23:57:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxV7sMkygjbaQB5ymNlWOzkapdgh0MOBiS+DFFML1YJa6qyG70uDcvA7KaRZ82ZwzXQKa6ngQ==
X-Received: by 2002:a63:6909:: with SMTP id e9mr1956790pgc.514.1643270229114;
        Wed, 26 Jan 2022 23:57:09 -0800 (PST)
Received: from [10.72.13.149] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k16sm19056702pgm.26.2022.01.26.23.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 23:57:08 -0800 (PST)
Message-ID: <35221232-ae92-a532-8738-b6a93cb4638c@redhat.com>
Date:   Thu, 27 Jan 2022 15:57:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 2/4] drivers/net/virtio_net: Added basic RSS support.
Content-Language: en-US
To:     Andrew Melnychenko <andrew@daynix.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
References: <20220117080009.3055012-1-andrew@daynix.com>
 <20220117080009.3055012-3-andrew@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220117080009.3055012-3-andrew@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/17 下午4:00, Andrew Melnychenko 写道:
> Added features for RSS.
> Added initialization, RXHASH feature and ethtool ops.
> By default RSS/RXHASH is disabled.
> Virtio RSS "IPv6 extensions" hashes disabled.
> Added ethtools ops to set key and indirection table.
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> ---
>   drivers/net/virtio_net.c | 193 +++++++++++++++++++++++++++++++++++++--
>   1 file changed, 187 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 05fe5ba32187..9aae11cb568e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -169,6 +169,24 @@ struct receive_queue {
>   	struct xdp_rxq_info xdp_rxq;
>   };
>   
> +/* This structure can contain rss message with maximum settings for indirection table and keysize
> + * Note, that default structure that describes RSS configuration virtio_net_rss_config
> + * contains same info but can't handle table values.
> + * In any case, structure would be passed to virtio hw through sg_buf split by parts
> + * because table sizes may be differ according to the device configuration.
> + */
> +#define VIRTIO_NET_RSS_MAX_KEY_SIZE     40
> +#define VIRTIO_NET_RSS_MAX_TABLE_LEN    128
> +struct virtio_net_ctrl_rss {
> +	u32 hash_types;
> +	u16 indirection_table_mask;
> +	u16 unclassified_queue;
> +	u16 indirection_table[VIRTIO_NET_RSS_MAX_TABLE_LEN];
> +	u16 max_tx_vq;
> +	u8 hash_key_length;
> +	u8 key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
> +};
> +
>   /* Control VQ buffers: protected by the rtnl lock */
>   struct control_buf {
>   	struct virtio_net_ctrl_hdr hdr;
> @@ -178,6 +196,7 @@ struct control_buf {
>   	u8 allmulti;
>   	__virtio16 vid;
>   	__virtio64 offloads;
> +	struct virtio_net_ctrl_rss rss;
>   };
>   
>   struct virtnet_info {
> @@ -206,6 +225,12 @@ struct virtnet_info {
>   	/* Host will merge rx buffers for big packets (shake it! shake it!) */
>   	bool mergeable_rx_bufs;
>   
> +	/* Host supports rss and/or hash report */
> +	bool has_rss;
> +	u8 rss_key_size;
> +	u16 rss_indir_table_size;
> +	u32 rss_hash_types_supported;
> +
>   	/* Has control virtqueue */
>   	bool has_cvq;
>   
> @@ -2184,6 +2209,56 @@ static void virtnet_get_ringparam(struct net_device *dev,
>   	ring->tx_pending = ring->tx_max_pending;
>   }
>   
> +static bool virtnet_commit_rss_command(struct virtnet_info *vi)
> +{
> +	struct net_device *dev = vi->dev;
> +	struct scatterlist sgs[4];
> +	unsigned int sg_buf_size;
> +
> +	/* prepare sgs */
> +	sg_init_table(sgs, 4);
> +
> +	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, indirection_table);
> +	sg_set_buf(&sgs[0], &vi->ctrl->rss, sg_buf_size);
> +
> +	sg_buf_size = sizeof(uint16_t) * vi->rss_indir_table_size;
> +	sg_set_buf(&sgs[1], vi->ctrl->rss.indirection_table, sg_buf_size);
> +
> +	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, key)
> +			- offsetof(struct virtio_net_ctrl_rss, max_tx_vq);
> +	sg_set_buf(&sgs[2], &vi->ctrl->rss.max_tx_vq, sg_buf_size);
> +
> +	sg_buf_size = vi->rss_key_size;
> +	sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
> +
> +	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
> +				  VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
> +		dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static void virtnet_init_default_rss(struct virtnet_info *vi)
> +{
> +	u32 indir_val = 0;
> +	int i = 0;
> +
> +	vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
> +	vi->ctrl->rss.indirection_table_mask = vi->rss_indir_table_size - 1;
> +	vi->ctrl->rss.unclassified_queue = 0;
> +
> +	for (; i < vi->rss_indir_table_size; ++i) {
> +		indir_val = ethtool_rxfh_indir_default(i, vi->curr_queue_pairs);
> +		vi->ctrl->rss.indirection_table[i] = indir_val;
> +	}
> +
> +	vi->ctrl->rss.max_tx_vq = vi->curr_queue_pairs;
> +	vi->ctrl->rss.hash_key_length = vi->rss_key_size;
> +
> +	netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
> +}
> +
>   
>   static void virtnet_get_drvinfo(struct net_device *dev,
>   				struct ethtool_drvinfo *info)
> @@ -2412,6 +2487,71 @@ static void virtnet_update_settings(struct virtnet_info *vi)
>   		vi->duplex = duplex;
>   }
>   
> +static u32 virtnet_get_rxfh_key_size(struct net_device *dev)
> +{
> +	return ((struct virtnet_info *)netdev_priv(dev))->rss_key_size;
> +}
> +
> +static u32 virtnet_get_rxfh_indir_size(struct net_device *dev)
> +{
> +	return ((struct virtnet_info *)netdev_priv(dev))->rss_indir_table_size;
> +}
> +
> +static int virtnet_get_rxfh(struct net_device *dev, u32 *indir, u8 *key, u8 *hfunc)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	int i;
> +
> +	if (indir) {
> +		for (i = 0; i < vi->rss_indir_table_size; ++i)
> +			indir[i] = vi->ctrl->rss.indirection_table[i];
> +	}
> +
> +	if (key)
> +		memcpy(key, vi->ctrl->rss.key, vi->rss_key_size);
> +
> +	if (hfunc)
> +		*hfunc = ETH_RSS_HASH_TOP;
> +
> +	return 0;
> +}
> +
> +static int virtnet_set_rxfh(struct net_device *dev, const u32 *indir, const u8 *key, const u8 hfunc)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	int i;
> +
> +	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
> +		return -EOPNOTSUPP;
> +
> +	if (indir) {
> +		for (i = 0; i < vi->rss_indir_table_size; ++i)
> +			vi->ctrl->rss.indirection_table[i] = indir[i];
> +	}
> +	if (key)
> +		memcpy(vi->ctrl->rss.key, key, vi->rss_key_size);
> +
> +	virtnet_commit_rss_command(vi);
> +
> +	return 0;
> +}
> +
> +static int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u32 *rule_locs)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	int rc = 0;
> +
> +	switch (info->cmd) {
> +	case ETHTOOL_GRXRINGS:
> +		info->data = vi->curr_queue_pairs;
> +		break;
> +	default:
> +		rc = -EOPNOTSUPP;
> +	}
> +
> +	return rc;
> +}
> +
>   static const struct ethtool_ops virtnet_ethtool_ops = {
>   	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
>   	.get_drvinfo = virtnet_get_drvinfo,
> @@ -2427,6 +2567,11 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
>   	.set_link_ksettings = virtnet_set_link_ksettings,
>   	.set_coalesce = virtnet_set_coalesce,
>   	.get_coalesce = virtnet_get_coalesce,
> +	.get_rxfh_key_size = virtnet_get_rxfh_key_size,
> +	.get_rxfh_indir_size = virtnet_get_rxfh_indir_size,
> +	.get_rxfh = virtnet_get_rxfh,
> +	.set_rxfh = virtnet_set_rxfh,
> +	.get_rxnfc = virtnet_get_rxnfc,
>   };
>   
>   static void virtnet_freeze_down(struct virtio_device *vdev)
> @@ -2679,6 +2824,16 @@ static int virtnet_set_features(struct net_device *dev,
>   		vi->guest_offloads = offloads;
>   	}
>   
> +	if ((dev->features ^ features) & NETIF_F_RXHASH) {
> +		if (features & NETIF_F_RXHASH)
> +			vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
> +		else
> +			vi->ctrl->rss.hash_types = VIRTIO_NET_HASH_REPORT_NONE;
> +
> +		if (!virtnet_commit_rss_command(vi))
> +			return -EINVAL;
> +	}
> +
>   	return 0;
>   }
>   
> @@ -3073,6 +3228,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
>   			     "VIRTIO_NET_F_CTRL_VQ") ||
>   	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
>   	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
> +			     "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
>   			     "VIRTIO_NET_F_CTRL_VQ"))) {
>   		return false;
>   	}
> @@ -3113,13 +3270,14 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	u16 max_queue_pairs;
>   	int mtu;
>   
> -	/* Find if host supports multiqueue virtio_net device */
> -	err = virtio_cread_feature(vdev, VIRTIO_NET_F_MQ,
> -				   struct virtio_net_config,
> -				   max_virtqueue_pairs, &max_queue_pairs);
> +	/* Find if host supports multiqueue/rss virtio_net device */
> +	max_queue_pairs = 0;


Do we need to initialize this to 1? Otherwise we won't pass the below 
check against VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN.


> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
> +		max_queue_pairs =
> +		     virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));
>   
>   	/* We need at least 2 queue's */
> -	if (err || max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
> +	if (max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
>   	    max_queue_pairs > VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX ||
>   	    !virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
>   		max_queue_pairs = 1;
> @@ -3207,6 +3365,25 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>   		vi->mergeable_rx_bufs = true;
>   
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
> +		vi->has_rss = true;
> +		vi->rss_indir_table_size =
> +			virtio_cread16(vdev, offsetof(struct virtio_net_config,
> +						      rss_max_indirection_table_length));
> +		vi->rss_key_size =
> +			virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
> +	}
> +
> +	if (vi->has_rss) {


We don't need this check, we can simple reuse the above one.


Thanks


> +		vi->rss_hash_types_supported =
> +		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
> +		vi->rss_hash_types_supported &=
> +				~(VIRTIO_NET_RSS_HASH_TYPE_IP_EX |
> +				  VIRTIO_NET_RSS_HASH_TYPE_TCP_EX |
> +				  VIRTIO_NET_RSS_HASH_TYPE_UDP_EX);
> +
> +		dev->hw_features |= NETIF_F_RXHASH;
> +	}
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
>   	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
>   		vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
> @@ -3275,6 +3452,9 @@ static int virtnet_probe(struct virtio_device *vdev)
>   		}
>   	}
>   
> +	if (vi->has_rss)
> +		virtnet_init_default_rss(vi);
> +
>   	err = register_netdev(dev);
>   	if (err) {
>   		pr_debug("virtio_net: registering device failed\n");
> @@ -3406,7 +3586,8 @@ static struct virtio_device_id id_table[] = {
>   	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
>   	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>   	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> -	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY
> +	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> +	VIRTIO_NET_F_RSS
>   
>   static unsigned int features[] = {
>   	VIRTNET_FEATURES,


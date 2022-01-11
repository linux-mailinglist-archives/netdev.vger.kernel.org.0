Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808D048AD32
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 13:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239420AbiAKMAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 07:00:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239153AbiAKMAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 07:00:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641902442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=THcNYoUiQXT0RGR+jY+YTB6YPm1T2/jKfNy70DiF97k=;
        b=awJhXXYQWGJFQjaMhVNzgJHDBEynHzZtW+2LMgO0mtp5yvhTsLrlHGEkongRVlo12w0lrM
        XY723CKmQfzzoIobU1OHmMmamgsfnqy+rxd1w08dzTZqFs2TX7/f28yXbxgp71ukox+OlR
        gNFgj427e+w9XkTWmRCAkiAO1Sug5BQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-WDZXuOmIMV-_gv9kPR4JIw-1; Tue, 11 Jan 2022 07:00:41 -0500
X-MC-Unique: WDZXuOmIMV-_gv9kPR4JIw-1
Received: by mail-wm1-f71.google.com with SMTP id i81-20020a1c3b54000000b003467c58cbddso1419418wma.5
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 04:00:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=THcNYoUiQXT0RGR+jY+YTB6YPm1T2/jKfNy70DiF97k=;
        b=fLWKa4/+6nFdpbvajlYPgcY6m82PrPAQRk4THMnPT5ex4WecFGKLM0+A6hGIjyfzJs
         jDPuEO+hSjtY3X5vg/H54QCQmZKnN3b5EXtkcTGb8dDAMczLCY6SG6JaGt+eIHr52E1I
         XegAh3jOi7DaPyPfeB4yBYsWr4T8geFqRXEV1ECAIjIl1Xj4KTNl8NU3BUnONg/PH2Dd
         KKOYeVTLy8fT4SBqS2sZjYzy/4FvrMuFOK6m1PKazV36eBm0TWt7IXuNuFiZNXEUxeox
         jOulrvG+OOj1IB6Kb33YGrcjV0T8KYP4OZJe8yPIAi0pqp6iVykwJB7l6DtaxIBi1HLd
         coFg==
X-Gm-Message-State: AOAM530+yrb9nl3bsg3t91tdj4/c9gr8eiDDQQ/Lkg9xExV6J2X+LfEt
        UvysLW2joREQO787BXZXohozP51v3NSluqrzdqm2nJLn//XqbM9ba7165udxJCgQ+pgPRXOkCaX
        gu+YxbF7l/ltBYY5N
X-Received: by 2002:a05:6000:1002:: with SMTP id a2mr3421170wrx.157.1641902439207;
        Tue, 11 Jan 2022 04:00:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz4YSuB/GqbCt19n6tpprmL7h3cgtRkKL8QSJzqOZK7rn30aslEqbzpa9pg+AInFiBei4efrA==
X-Received: by 2002:a05:6000:1002:: with SMTP id a2mr3421156wrx.157.1641902438967;
        Tue, 11 Jan 2022 04:00:38 -0800 (PST)
Received: from redhat.com ([2.55.5.100])
        by smtp.gmail.com with ESMTPSA id o3sm10569265wry.98.2022.01.11.04.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 04:00:38 -0800 (PST)
Date:   Tue, 11 Jan 2022 07:00:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, yan@daynix.com, yuri.benditovich@daynix.com
Subject: Re: [PATCH 2/4] drivers/net/virtio_net: Added basic RSS support.
Message-ID: <20220111065539-mutt-send-email-mst@kernel.org>
References: <20220109210659.2866740-1-andrew@daynix.com>
 <20220109210659.2866740-3-andrew@daynix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220109210659.2866740-3-andrew@daynix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 09, 2022 at 11:06:57PM +0200, Andrew Melnychenko wrote:
> Added features for RSS.
> Added initialization, RXHASH feature and ethtool ops.
> By default RSS/RXHASH is disabled.
> Virtio RSS "IPv6 extensions" hashes disabled.
> Added ethtools ops to set key and indirection table.
> 
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> ---
>  drivers/net/virtio_net.c | 194 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 184 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 66439ca488f4..21794731fc75 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -169,6 +169,28 @@ struct receive_queue {
>  	struct xdp_rxq_info xdp_rxq;
>  };
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
> +	struct {
> +		__le32 hash_types;
> +		__le16 indirection_table_mask;
> +		__le16 unclassified_queue;
> +	} __packed table_info;
> +	u16 indirection_table[VIRTIO_NET_RSS_MAX_TABLE_LEN];
> +	struct {
> +		u16 max_tx_vq; /* queues */
> +		u8 hash_key_length;
> +	} __packed key_info;
> +	u8 key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
> +};
> +

Generally best to avoid __packed.
I think it's not a bad idea to just follow the spec when
you lay out the structures. Makes it easier to follow
that it matches. Spec has just a single struct:

struct virtio_net_rss_config {
    le32 hash_types;
    le16 indirection_table_mask;
    le16 unclassified_queue;
    le16 indirection_table[indirection_table_length];
    le16 max_tx_vq;
    u8 hash_key_length;
    u8 hash_key_data[hash_key_length];
};

and with this layout you don't need __packed.



>  /* Control VQ buffers: protected by the rtnl lock */
>  struct control_buf {
>  	struct virtio_net_ctrl_hdr hdr;
> @@ -178,6 +200,7 @@ struct control_buf {
>  	u8 allmulti;
>  	__virtio16 vid;
>  	__virtio64 offloads;
> +	struct virtio_net_ctrl_rss rss;
>  };
>  
>  struct virtnet_info {
> @@ -206,6 +229,12 @@ struct virtnet_info {
>  	/* Host will merge rx buffers for big packets (shake it! shake it!) */
>  	bool mergeable_rx_bufs;
>  
> +	/* Host supports rss and/or hash report */
> +	bool has_rss;
> +	u8 rss_key_size;
> +	u16 rss_indir_table_size;
> +	u32 rss_hash_types_supported;
> +
>  	/* Has control virtqueue */
>  	bool has_cvq;
>  
> @@ -395,9 +424,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	hdr_p = p;
>  
>  	hdr_len = vi->hdr_len;
> -	if (vi->has_rss_hash_report)
> -		hdr_padded_len = sizeof(struct virtio_net_hdr_v1_hash);
> -	else if (vi->mergeable_rx_bufs)
> +	if (vi->mergeable_rx_bufs)
>  		hdr_padded_len = sizeof(*hdr);
>  	else
>  		hdr_padded_len = sizeof(struct padded_vnet_hdr);
> @@ -2184,6 +2211,55 @@ static void virtnet_get_ringparam(struct net_device *dev,
>  	ring->tx_pending = ring->tx_max_pending;
>  }
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
> +	sg_buf_size = sizeof(vi->ctrl->rss.table_info);
> +	sg_set_buf(&sgs[0], &vi->ctrl->rss.table_info, sg_buf_size);
> +
> +	sg_buf_size = sizeof(uint16_t) * vi->rss_indir_table_size;
> +	sg_set_buf(&sgs[1], vi->ctrl->rss.indirection_table, sg_buf_size);
> +
> +	sg_buf_size = sizeof(vi->ctrl->rss.key_info);
> +	sg_set_buf(&sgs[2], &vi->ctrl->rss.key_info, sg_buf_size);
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
> +	vi->ctrl->rss.table_info.hash_types = vi->rss_hash_types_supported;
> +	vi->ctrl->rss.table_info.indirection_table_mask = vi->rss_indir_table_size - 1;
> +	vi->ctrl->rss.table_info.unclassified_queue = 0;
> +
> +	for (; i < vi->rss_indir_table_size; ++i) {
> +		indir_val = ethtool_rxfh_indir_default(i, vi->max_queue_pairs);
> +		vi->ctrl->rss.indirection_table[i] = indir_val;
> +	}
> +
> +	vi->ctrl->rss.key_info.max_tx_vq = vi->curr_queue_pairs;
> +	vi->ctrl->rss.key_info.hash_key_length = vi->rss_key_size;
> +
> +	netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
> +}
> +
>  
>  static void virtnet_get_drvinfo(struct net_device *dev,
>  				struct ethtool_drvinfo *info)
> @@ -2412,6 +2488,71 @@ static void virtnet_update_settings(struct virtnet_info *vi)
>  		vi->duplex = duplex;
>  }
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
>  static const struct ethtool_ops virtnet_ethtool_ops = {
>  	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
>  	.get_drvinfo = virtnet_get_drvinfo,
> @@ -2427,6 +2568,11 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
>  	.set_link_ksettings = virtnet_set_link_ksettings,
>  	.set_coalesce = virtnet_set_coalesce,
>  	.get_coalesce = virtnet_get_coalesce,
> +	.get_rxfh_key_size = virtnet_get_rxfh_key_size,
> +	.get_rxfh_indir_size = virtnet_get_rxfh_indir_size,
> +	.get_rxfh = virtnet_get_rxfh,
> +	.set_rxfh = virtnet_set_rxfh,
> +	.get_rxnfc = virtnet_get_rxnfc,
>  };
>  
>  static void virtnet_freeze_down(struct virtio_device *vdev)
> @@ -3073,7 +3219,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
>  			     "VIRTIO_NET_F_CTRL_VQ") ||
>  	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
>  	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
> -			     "VIRTIO_NET_F_CTRL_VQ"))) {
> +			     "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS, "VIRTIO_NET_F_RSS"))) {
>  		return false;
>  	}
>  
> @@ -3113,13 +3260,14 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	u16 max_queue_pairs;
>  	int mtu;
>  
> -	/* Find if host supports multiqueue virtio_net device */
> -	err = virtio_cread_feature(vdev, VIRTIO_NET_F_MQ,
> -				   struct virtio_net_config,
> -				   max_virtqueue_pairs, &max_queue_pairs);
> +	/* Find if host supports multiqueue/rss virtio_net device */
> +	max_queue_pairs = 0;
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
> +		max_queue_pairs =
> +		     virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));
>  
>  	/* We need at least 2 queue's */
> -	if (err || max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
> +	if (max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
>  	    max_queue_pairs > VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX ||
>  	    !virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
>  		max_queue_pairs = 1;
> @@ -3207,6 +3355,25 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>  		vi->mergeable_rx_bufs = true;
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
> +		vi->rss_hash_types_supported =
> +		    virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
> +		vi->rss_hash_types_supported &=
> +				~(VIRTIO_NET_RSS_HASH_TYPE_IP_EX |
> +				  VIRTIO_NET_RSS_HASH_TYPE_TCP_EX |
> +				  VIRTIO_NET_RSS_HASH_TYPE_UDP_EX);
> +
> +		dev->hw_features |= NETIF_F_RXHASH;
> +	}
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
>  	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
>  		vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
> @@ -3275,6 +3442,12 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		}
>  	}
>  
> +	if (vi->has_rss) {
> +		rtnl_lock();
> +		virtnet_init_default_rss(vi);
> +		rtnl_unlock();
> +	}
> +
>  	err = register_netdev(dev);
>  	if (err) {
>  		pr_debug("virtio_net: registering device failed\n");
> @@ -3406,7 +3579,8 @@ static struct virtio_device_id id_table[] = {
>  	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> -	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY
> +	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> +	VIRTIO_NET_F_RSS
>  
>  static unsigned int features[] = {
>  	VIRTNET_FEATURES,
> -- 
> 2.34.1


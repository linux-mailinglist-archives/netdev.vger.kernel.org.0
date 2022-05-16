Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C6152922A
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348763AbiEPU5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349324AbiEPU4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:56:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E572FDE94
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652733063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bOoDearR1zB3a2w7A+HksnTESO3xkC8mNyYtIdVnIMU=;
        b=GfbO8k6i4mAaNr61Xh2c1E0dhGH+XPpUbBpW4k3uaq0t2zNPXXudpTPUPvhu3XWMqADsxz
        /ylBBYjv3EsjzCdspxF66wy7lyqseSCmIaUI/yXmbRCnpqrwLKys9v61KlvfIfLrKHz5uA
        uXxEoyLjBiKck8sbaichDYFw8lvuN1U=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-NT7LDL2oOw-H5CLtQEu1gw-1; Mon, 16 May 2022 16:31:01 -0400
X-MC-Unique: NT7LDL2oOw-H5CLtQEu1gw-1
Received: by mail-ed1-f71.google.com with SMTP id p13-20020aa7c4cd000000b0042ab847aba8so1829259edr.0
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:31:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bOoDearR1zB3a2w7A+HksnTESO3xkC8mNyYtIdVnIMU=;
        b=RHU3v7tNxsaeOJEnJQ6SwjRlV7M4EHBbPr/6ofqjRKhL13DKs82KlvLxDfMonEwNoa
         /cUwvpEMpUdHboGlHuhMTq2Hly3Vx8kcozcBKhZp0EUTPeF3lxA5rX+gWpP8VyuZBuGf
         9/zYTXR8nUlijnyO2iTFv8SIgdMV2qBwXwt9pOPKqajS2lPs0o/NfoDHrm/wH5Nu0e++
         zEjZwhUz9aCV26Q7Zr01NsogfSWRK7e6iFiIhwM0YcSv6HBPbm6T4JE/uxc4TpU7QDux
         tvDdUQ+xLBklC5DWlbPKo+up/AV1/7sEcp1Y5sFV+qZwMQ54X1gLzRK8vb8w1wU0rrvZ
         rzvw==
X-Gm-Message-State: AOAM530E7BAivlE6hf9MBgWGACW5wICf4zieUsfqAo6DolE5uGQV2NO2
        CHFbB7rXEl3XJOUFxQ9X2xBIJMMu0vK8iMPPgM9nuulMS8eioMIdObiYXVAZJD1E5E65Osws12a
        Pxsku5a5WNGxvMu1P
X-Received: by 2002:a17:907:3e93:b0:6f4:e215:e293 with SMTP id hs19-20020a1709073e9300b006f4e215e293mr16423567ejc.629.1652733060188;
        Mon, 16 May 2022 13:31:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgNE2jxmV5iPzpCMdlVLdLPqKlrj4EXVgUVCDrGgP032Wn42CrM3KYwf6ZJLGYuKhZx5Lfcg==
X-Received: by 2002:a17:907:3e93:b0:6f4:e215:e293 with SMTP id hs19-20020a1709073e9300b006f4e215e293mr16423551ejc.629.1652733059939;
        Mon, 16 May 2022 13:30:59 -0700 (PDT)
Received: from redhat.com ([2.55.131.38])
        by smtp.gmail.com with ESMTPSA id cx4-20020a05640222a400b0042ac2b71078sm328391edb.55.2022.05.16.13.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 13:30:59 -0700 (PDT)
Date:   Mon, 16 May 2022 16:30:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev@vger.kernel.org, rabeeh@solid-run.com,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2] net: virtio_net: support interrupt coalescing
Message-ID: <20220516162820-mutt-send-email-mst@kernel.org>
References: <20220515064330.75604-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220515064330.75604-1-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 15, 2022 at 09:43:30AM +0300, Alvaro Karsz wrote:
> Control a Virtio network device interrupt coalescing parameters
> using the control virtqueue.
> 
> New VirtIO network feature: VIRTIO_NET_F_INTR_COAL.
> 
> A device that supports this fetature can receive
> VIRTIO_NET_CTRL_INTR_COAL control commands.
> 
> - VIRTIO_NET_CTRL_INTR_COAL_USECS_SET:
>         change the rx-usecs and tx-usecs parameters.
> 
>         rx-usecs - Time to delay an RX interrupt after packet arrival in
>                 microseconds.
> 
>         tx-usecs - Time to delay a TX interrupt after a sending a packet
>                 in microseconds.
> 
> - VIRTIO_NET_CTRL_INTR_COAL_FRAMES_SET:
>         change the rx-max-frames and tx-max-frames parameters.
> 
>         rx-max-frames: Number of packets to delay an RX interrupt after
>                 packet arrival.
> 
>         tx-max-frames: Number of packets to delay a TX interrupt after
>                 sending a packet.
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> ---
> v2:
>         - usage of __virtio vairables.
>         - send commands to device only if the values have changed.
> ---
>  drivers/net/virtio_net.c        | 116 ++++++++++++++++++++++++++++----
>  include/uapi/linux/virtio_net.h |  34 +++++++++-


This needs review of the virtio TC, and a vote. Let's wait for this
before merging please. Until then pls post RFC patches.

For patch itself, I'm going on vacation until May 25, will review
afterwards.


>  2 files changed, 136 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index cbba9d2e8f3..e40f453edb9 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -261,6 +261,12 @@ struct virtnet_info {
>  	u8 duplex;
>  	u32 speed;
>  
> +	/* Interrupt coalescing settings */
> +	u32 tx_usecs;
> +	u32 rx_usecs;
> +	u32 tx_frames_max;
> +	u32 rx_frames_max;
> +
>  	unsigned long guest_offloads;
>  	unsigned long guest_offloads_capable;
>  
> @@ -2594,19 +2600,83 @@ static int virtnet_set_coalesce(struct net_device *dev,
>  {
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int i, napi_weight;
> +	struct scatterlist sgs_usecs, sgs_frames;
> +	struct virtio_net_ctrl_coal_frames c_frames;
> +	struct virtio_net_ctrl_coal_usec c_usecs;
> +	bool update_napi,
> +	intr_coal = virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL);
> +
> +	/* rx_coalesce_usecs/tx_coalesce_usecs are supported only
> +	 * if VIRTIO_NET_F_INTR_COAL feature is set.
> +	 */
> +	if (!intr_coal && (ec->rx_coalesce_usecs || ec->tx_coalesce_usecs))
> +		return -EOPNOTSUPP;
>  
> -	if (ec->tx_max_coalesced_frames > 1 ||
> -	    ec->rx_max_coalesced_frames != 1)
> +	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL)) {
> +		/* Send usec command only if value has changed */
> +		if (ec->tx_coalesce_usecs != vi->tx_usecs ||
> +		    ec->rx_coalesce_usecs != vi->rx_usecs) {
> +			c_usecs.tx_usecs = cpu_to_virtio32(vi->vdev, ec->tx_coalesce_usecs);
> +			c_usecs.rx_usecs = cpu_to_virtio32(vi->vdev, ec->rx_coalesce_usecs);
> +			sg_init_one(&sgs_usecs, &c_usecs, sizeof(c_usecs));
> +
> +			if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_INTR_COAL,
> +						  VIRTIO_NET_CTRL_INTR_COAL_USECS_SET,
> +						  &sgs_usecs))
> +				return -EINVAL;
> +
> +			/* Save parameters */
> +			vi->tx_usecs = ec->tx_coalesce_usecs;
> +			vi->rx_usecs = ec->rx_coalesce_usecs;
> +		}
> +
> +		/* Send frames command only if value has changed */
> +		if (ec->tx_max_coalesced_frames != vi->tx_frames_max ||
> +		    ec->rx_max_coalesced_frames != vi->rx_frames_max) {
> +			c_frames.tx_frames_max = cpu_to_virtio32(vi->vdev,
> +								 ec->tx_max_coalesced_frames);
> +			c_frames.rx_frames_max = cpu_to_virtio32(vi->vdev,
> +								 ec->rx_max_coalesced_frames);
> +			sg_init_one(&sgs_frames, &c_frames, sizeof(c_frames));
> +
> +			if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_INTR_COAL,
> +						  VIRTIO_NET_CTRL_INTR_COAL_FRAMES_SET,
> +						  &sgs_frames))
> +				return -EINVAL;
> +
> +			/* Save parameters */
> +			vi->tx_frames_max = ec->tx_max_coalesced_frames;
> +			vi->rx_frames_max = ec->rx_max_coalesced_frames;
> +		}
> +	}
> +
> +	/* Should we update NAPI? */
> +	update_napi = ec->tx_max_coalesced_frames <= 1 &&
> +			ec->rx_max_coalesced_frames == 1;
> +
> +	/* If interrupt coalesing feature is not set, and we can't update NAPI, return an error */
> +	if (!intr_coal && !update_napi)
>  		return -EINVAL;
>  
> -	napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
> -	if (napi_weight ^ vi->sq[0].napi.weight) {
> -		if (dev->flags & IFF_UP)
> -			return -EBUSY;
> -		for (i = 0; i < vi->max_queue_pairs; i++)
> -			vi->sq[i].napi.weight = napi_weight;
> +	if (update_napi) {
> +		napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
> +		if (napi_weight ^ vi->sq[0].napi.weight) {
> +			if (dev->flags & IFF_UP) {
> +				/* If Interrupt coalescing feature is not set, return an error.
> +				 * Otherwise exit without changing the NAPI paremeters
> +				 */
> +				if (!intr_coal)
> +					return -EBUSY;
> +
> +				goto exit;
> +			}
> +
> +			for (i = 0; i < vi->max_queue_pairs; i++)
> +				vi->sq[i].napi.weight = napi_weight;
> +		}
>  	}
>  
> +exit:
>  	return 0;
>  }
>  
> @@ -2616,14 +2686,25 @@ static int virtnet_get_coalesce(struct net_device *dev,
>  				struct netlink_ext_ack *extack)
>  {
>  	struct ethtool_coalesce ec_default = {
> -		.cmd = ETHTOOL_GCOALESCE,
> -		.rx_max_coalesced_frames = 1,
> +		.cmd = ETHTOOL_GCOALESCE
>  	};
> +
>  	struct virtnet_info *vi = netdev_priv(dev);
> +	bool intr_coal = virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL);
> +
> +	/* Add Interrupt coalescing settings */
> +	if (intr_coal) {
> +		ec_default.rx_coalesce_usecs = vi->rx_usecs;
> +		ec_default.tx_coalesce_usecs = vi->tx_usecs;
> +		ec_default.tx_max_coalesced_frames = vi->tx_frames_max;
> +		ec_default.rx_max_coalesced_frames = vi->rx_frames_max;
> +	} else {
> +		ec_default.rx_max_coalesced_frames = 1;
> +	}
>  
>  	memcpy(ec, &ec_default, sizeof(ec_default));
>  
> -	if (vi->sq[0].napi.weight)
> +	if (!intr_coal && vi->sq[0].napi.weight)
>  		ec->tx_max_coalesced_frames = 1;
>  
>  	return 0;
> @@ -2743,7 +2824,7 @@ static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
>  }
>  
>  static const struct ethtool_ops virtnet_ethtool_ops = {
> -	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
> +	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES | ETHTOOL_COALESCE_USECS,
>  	.get_drvinfo = virtnet_get_drvinfo,
>  	.get_link = ethtool_op_get_link,
>  	.get_ringparam = virtnet_get_ringparam,
> @@ -3423,6 +3504,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
>  	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
>  			     "VIRTIO_NET_F_CTRL_VQ") ||
>  	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
> +			     "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_INTR_COAL,
>  			     "VIRTIO_NET_F_CTRL_VQ"))) {
>  		return false;
>  	}
> @@ -3558,6 +3641,13 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>  		vi->mergeable_rx_bufs = true;
>  
> +	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL)) {
> +		vi->rx_usecs = 0;
> +		vi->tx_usecs = 0;
> +		vi->tx_frames_max = 0;
> +		vi->rx_frames_max = 0;
> +	}
> +
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
>  		vi->has_rss_hash_report = true;
>  
> @@ -3786,7 +3876,7 @@ static struct virtio_device_id id_table[] = {
>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_INTR_COAL
>  
>  static unsigned int features[] = {
>  	VIRTNET_FEATURES,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index 3f55a4215f1..05da9eb6ad9 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -56,7 +56,7 @@
>  #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
>  					 * Steering */
>  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
> -
> +#define VIRTIO_NET_F_INTR_COAL	24	/* Guest can handle Interrupt coalescing */
>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
> @@ -355,4 +355,36 @@ struct virtio_net_hash_config {
>  #define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
>  #define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
>  
> +/*
> + * Control interrupt coalescing.
> + *
> + * Request the device to change the interrupt coalescing parameters.
> + *
> + * Available with the VIRTIO_NET_F_INTR_COAL feature bit.
> + */
> +#define VIRTIO_NET_CTRL_INTR_COAL		6
> +/*
> + * Set the rx-usecs/tx-usecs patameters.
> + * rx-usecs - Number of microseconds to delay an RX interrupt after packet arrival.
> + * tx-usecs - Number of microseconds to delay a TX interrupt after a sending a packet.
> + */
> +struct virtio_net_ctrl_coal_usec {
> +	__virtio32 tx_usecs;
> +	__virtio32 rx_usecs;
> +};
> +
> +#define VIRTIO_NET_CTRL_INTR_COAL_USECS_SET		0
> +
> +/*
> + * Set the rx-max-frames/tx-max-frames patameters.
> + * rx-max-frames - Number of packets to delay an RX interrupt after packet arrival.
> + * tx-max-frames - Number of packets to delay a TX interrupt after sending a packet.
> + */
> +struct virtio_net_ctrl_coal_frames {
> +	__virtio32 tx_frames_max;
> +	__virtio32 rx_frames_max;
> +};
> +
> +#define VIRTIO_NET_CTRL_INTR_COAL_FRAMES_SET		1
> +
>  #endif /* _UAPI_LINUX_VIRTIO_NET_H */
> -- 
> 2.32.0


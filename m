Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948B62E69B8
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 18:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgL1Ra0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 12:30:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727332AbgL1Ra0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 12:30:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609176539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gGvJqem7a81M/b2pl+4LUjnrCUZWKh0z89Pf1v3aCwI=;
        b=gskuHSdWb+L/AnLgmbZwtmLltDKHeR33w1JWROMAyefl87KRwJ91B3gcWi3YOBggCR/Iwe
        Go8CACRpI7qhYrVEDvEgr9KeHcAshDc36qEnoQgwbaC8L3a1am5ueKZwc6LKJ/5LzRB1ZW
        ZivchuxzjSLDK/9W5mhE/xuLwM2eq/4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-I-NSoK7AMTyCk7tqACVmDQ-1; Mon, 28 Dec 2020 12:28:57 -0500
X-MC-Unique: I-NSoK7AMTyCk7tqACVmDQ-1
Received: by mail-wr1-f69.google.com with SMTP id 88so6561587wrc.17
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 09:28:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gGvJqem7a81M/b2pl+4LUjnrCUZWKh0z89Pf1v3aCwI=;
        b=RM2jRn1hyuDG88itwzwsVwuLD2Yntr96KwyzHuxtc7fiX3H/vZKgnntna68u2Cx56S
         y112dcB8nL9Ty51Sglnx3frllozpNkJtXQk/sW+6oEEzrexesKKazhU1BLTXkhj9vtTT
         MY1K1jLskACqXef2Re4j4HEpYDfyRiLXBZBjNpfmHq9vd2eWKzyAk5jD4tr6NM21INfJ
         988AVlJ8ROrMLQ+lx2VpbRl+rxtR1QP6Of92mR9SHVgNEeOm1yZp23Y8E4MWlY3OZKbC
         r+wq1F7EWpq8s3pY2cQr9nbQwz6VKn7gQBR60X8cUqO816dlJW7zkYT8X7LaLpBZCVVY
         XOcA==
X-Gm-Message-State: AOAM5331pIStuFDEV8il7WgSbfpqiSi7riBJ9j52AeQGb82nFrXD2J/N
        ZkyM46WkBCqF3xdfFZvue9vsqnJZB22gqVIMrrzA1FYtJu5PMeNpsqViDqOQbKAAkUW1qOKlC5V
        jnbVRVjDw2xbomxDl
X-Received: by 2002:adf:9cca:: with SMTP id h10mr51884088wre.77.1609176535870;
        Mon, 28 Dec 2020 09:28:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3CvROt5ur1I1l3P77PDjZ8wuWthA9/Pni/ZrE+rb1H8lj93XGC/+D+KNt3FmC+uKlTcUXyQ==
X-Received: by 2002:adf:9cca:: with SMTP id h10mr51884075wre.77.1609176535702;
        Mon, 28 Dec 2020 09:28:55 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id a13sm53668700wrt.96.2020.12.28.09.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 09:28:55 -0800 (PST)
Date:   Mon, 28 Dec 2020 12:28:52 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jasowang@redhat.com, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
Message-ID: <20201228122253-mutt-send-email-mst@kernel.org>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 11:22:32AM -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Add optional PTP hardware timestamp offload for virtio-net.
> 
> Accurate RTT measurement requires timestamps close to the wire.
> Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> virtio-net header is expanded with room for a timestamp. A host may
> pass receive timestamps for all or some packets. A timestamp is valid
> if non-zero.
> 
> The timestamp straddles (virtual) hardware domains. Like PTP, use
> international atomic time (CLOCK_TAI) as global clock base. It is
> guest responsibility to sync with host, e.g., through kvm-clock.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  drivers/net/virtio_net.c        | 20 +++++++++++++++++++-
>  include/uapi/linux/virtio_net.h | 12 ++++++++++++
>  2 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index b917b7333928..57744bb6a141 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -204,6 +204,9 @@ struct virtnet_info {
>  	/* Guest will pass tx path info to the host */
>  	bool has_tx_hash;
>  
> +	/* Host will pass CLOCK_TAI receive time to the guest */
> +	bool has_rx_tstamp;
> +
>  	/* Has control virtqueue */
>  	bool has_cvq;
>  
> @@ -292,6 +295,13 @@ static inline struct virtio_net_hdr_mrg_rxbuf *skb_vnet_hdr(struct sk_buff *skb)
>  	return (struct virtio_net_hdr_mrg_rxbuf *)skb->cb;
>  }
>  
> +static inline struct virtio_net_hdr_v12 *skb_vnet_hdr_12(struct sk_buff *skb)
> +{
> +	BUILD_BUG_ON(sizeof(struct virtio_net_hdr_v12) > sizeof(skb->cb));
> +
> +	return (void *)skb->cb;
> +}
> +
>  /*
>   * private is used to chain pages for big packets, put the whole
>   * most recent used list in the beginning for reuse
> @@ -1082,6 +1092,9 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>  		goto frame_err;
>  	}
>  
> +	if (vi->has_rx_tstamp)
> +		skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(skb_vnet_hdr_12(skb)->tstamp);
> +
>  	skb_record_rx_queue(skb, vq2rxq(rq->vq));
>  	skb->protocol = eth_type_trans(skb, dev);
>  	pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
> @@ -3071,6 +3084,11 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
>  	}
>  
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_RX_TSTAMP)) {
> +		vi->has_rx_tstamp = true;
> +		vi->hdr_len = sizeof(struct virtio_net_hdr_v12);
> +	}
> +
>  	if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
>  	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
>  		vi->any_header_sg = true;
> @@ -3261,7 +3279,7 @@ static struct virtio_device_id id_table[] = {
>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -	VIRTIO_NET_F_TX_HASH
> +	VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP
>  
>  static unsigned int features[] = {
>  	VIRTNET_FEATURES,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index f6881b5b77ee..0ffe2eeebd4a 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -57,6 +57,7 @@
>  					 * Steering */
>  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
>  
> +#define VIRTIO_NET_F_RX_TSTAMP	  55	/* Host sends TAI receive time */
>  #define VIRTIO_NET_F_TX_HASH	  56	/* Guest sends hash report */
>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
> @@ -182,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
>  	};
>  };
>  
> +struct virtio_net_hdr_v12 {
> +	struct virtio_net_hdr_v1 hdr;
> +	struct {
> +		__le32 value;
> +		__le16 report;
> +		__le16 flow_state;
> +	} hash;
> +	__virtio32 reserved;
> +	__virtio64 tstamp;
> +};
> +
>  #ifndef VIRTIO_NET_NO_LEGACY
>  /* This header comes first in the scatter-gather list.
>   * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must


So it looks like VIRTIO_NET_F_RX_TSTAMP should depend on both
VIRTIO_NET_F_RX_TSTAMP and VIRTIO_NET_F_HASH_REPORT then?

I am not sure what does v12 mean here.

virtio_net_hdr_v1 is just with VIRTIO_F_VERSION_1,
virtio_net_hdr_v1_hash is with VIRTIO_F_VERSION_1 and
VIRTIO_NET_F_HASH_REPORT.

So this one is virtio_net_hdr_hash_tstamp I guess?


> -- 
> 2.29.2.729.g45daf8777d-goog


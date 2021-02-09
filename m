Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281B131541B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhBIQlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:41:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232935AbhBIQk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:40:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612888741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j18aWEf5CADfmqMvOrXJkqA0qqCkiJleoTu3goUeHSM=;
        b=AjNTNrcJ2Fb1zlzA0SPp1dNydBJfYoax3n20rnBX6SRC4il/BLHHv+3Ds9BkvR2VTqy3/G
        Y0rKUCmBrRg1jT0PG+AJe2DN8DyCUH0ERc+aJmSs/gDinhm6JRO76SmFkSRTYDlRbMFygb
        i8S4ONclZvvBt7cUCpVfZgqalMLDxIo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-p6MKepJnOAWSrlzfmMgFOQ-1; Tue, 09 Feb 2021 11:38:59 -0500
X-MC-Unique: p6MKepJnOAWSrlzfmMgFOQ-1
Received: by mail-wm1-f69.google.com with SMTP id o18so2930845wmq.2
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 08:38:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=j18aWEf5CADfmqMvOrXJkqA0qqCkiJleoTu3goUeHSM=;
        b=qLKauK9RK3kn9LaEOwgmnRkmLKxrf9l3vjSK4riFHsLFtm7WiKcQvwImk6CuasrGK8
         lbdoPsjQQiftX7ctpgNF3I2GQ5MDy4L6d1GeC99MwRBkvh+ErmE80ap9VyzLcNFI1DXR
         Ure6k1hLQPpIFchBxb+ZX3pg381vL5TsJTrhUsu14FXwYyg8ZyYIY93eX1WYHQtxfc11
         YPGKqoeGkpL7HZGAOh6IHyGQoH3sbemiY0w+cuhcy0VYi13yyR9cTsFsRSuCjAcRPaM7
         lNm9PeOk20iYck/oT9prenCrrZ3l7oyp54dhNSjTre7Spp8vqdBpmNwOd20ymfKhCf39
         FMOw==
X-Gm-Message-State: AOAM531jlHztvESJhSPlLrFnBZ3lTnEbdBgJdF1bJ4R6f6IkB7UQvrEf
        JTP2nYDl+7zffk2nGa0A0o+z3PZceKGGxmYQ/Wn9wVJI/+KndQKLyOLwWCFA7WQbvFXqZ3lQ0mq
        CeH8MUp06UzCtIY3G
X-Received: by 2002:a5d:690b:: with SMTP id t11mr26608188wru.12.1612888738146;
        Tue, 09 Feb 2021 08:38:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRKdJBQCdmzziwPcmnK3944oxwc/YSEzg8BUmyrortM8c8BTMwCWv53TxFKLYzqUjxjED4bg==
X-Received: by 2002:a5d:690b:: with SMTP id t11mr26608156wru.12.1612888737904;
        Tue, 09 Feb 2021 08:38:57 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id v5sm17877825wro.71.2021.02.09.08.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 08:38:57 -0800 (PST)
Date:   Tue, 9 Feb 2021 11:38:54 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH RFC v2 3/4] virtio-net: support transmit timestamp
Message-ID: <20210209113643-mutt-send-email-mst@kernel.org>
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
 <20210208185558.995292-4-willemdebruijn.kernel@gmail.com>
 <6bfdf48d-c780-bc65-b0b9-24a33f18827b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6bfdf48d-c780-bc65-b0b9-24a33f18827b@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 01:45:11PM +0800, Jason Wang wrote:
> 
> On 2021/2/9 上午2:55, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> > 
> > Add optional PTP hardware tx timestamp offload for virtio-net.
> > 
> > Accurate RTT measurement requires timestamps close to the wire.
> > Introduce virtio feature VIRTIO_NET_F_TX_TSTAMP, the transmit
> > equivalent to VIRTIO_NET_F_RX_TSTAMP.
> > 
> > The driver sets VIRTIO_NET_HDR_F_TSTAMP to request a timestamp
> > returned on completion. If the feature is negotiated, the device
> > either places the timestamp or clears the feature bit.
> > 
> > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > international atomic time (CLOCK_TAI) as global clock base. The driver
> > must sync with the device, e.g., through kvm-clock.
> > 
> > Modify can_push to ensure that on tx completion the header, and thus
> > timestamp, is in a predicatable location at skb_vnet_hdr.
> > 
> > RFC: this implementation relies on the device writing to the buffer.
> > That breaks DMA_TO_DEVICE semantics. For now, disable when DMA is on.
> > The virtio changes should be a separate patch at the least.
> > 
> > Tested: modified txtimestamp.c to with h/w timestamping:
> >    -       sock_opt = SOF_TIMESTAMPING_SOFTWARE |
> >    +       sock_opt = SOF_TIMESTAMPING_RAW_HARDWARE |
> >    + do_test(family, SOF_TIMESTAMPING_TX_HARDWARE);
> > 
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> >   drivers/net/virtio_net.c        | 61 ++++++++++++++++++++++++++++-----
> >   drivers/virtio/virtio_ring.c    |  3 +-
> >   include/linux/virtio.h          |  1 +
> >   include/uapi/linux/virtio_net.h |  1 +
> >   4 files changed, 56 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index ac44c5efa0bc..fc8ecd3a333a 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -210,6 +210,12 @@ struct virtnet_info {
> >   	/* Device will pass rx timestamp. Requires has_rx_tstamp */
> >   	bool enable_rx_tstamp;
> > +	/* Device can pass CLOCK_TAI transmit time to the driver */
> > +	bool has_tx_tstamp;
> > +
> > +	/* Device will pass tx timestamp. Requires has_tx_tstamp */
> > +	bool enable_tx_tstamp;
> > +
> >   	/* Has control virtqueue */
> >   	bool has_cvq;
> > @@ -1401,6 +1407,20 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
> >   	return stats.packets;
> >   }
> > +static void virtnet_record_tx_tstamp(const struct send_queue *sq,
> > +				     struct sk_buff *skb)
> > +{
> > +	const struct virtio_net_hdr_hash_ts *h = skb_vnet_hdr_ht(skb);
> > +	const struct virtnet_info *vi = sq->vq->vdev->priv;
> > +	struct skb_shared_hwtstamps ts;
> > +
> > +	if (h->hdr.flags & VIRTIO_NET_HDR_F_TSTAMP &&
> > +	    vi->enable_tx_tstamp) {
> > +		ts.hwtstamp = ns_to_ktime(le64_to_cpu(h->tstamp));
> > +		skb_tstamp_tx(skb, &ts);
> 
> 
> This probably won't work since the buffer is read-only from the device. (See
> virtqueue_add_outbuf()).
> 
> Another issue that I vaguely remember that the virtio spec forbids out
> buffer after in buffer.

Both Driver Requirements: Message Framing and Driver Requirements: Scatter-Gather Support
have this statement:

	The driver MUST place any device-writable descriptor elements after any device-readable descriptor ele-
	ments.


similarly

Device Requirements: The Virtqueue Descriptor Table
	A device MUST NOT write to a device-readable buffer, and a device SHOULD NOT read a device-writable
	buffer.



> 
> > +	}
> > +}
> > +
> >   static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
> >   {
> >   	unsigned int len;
> > @@ -1412,6 +1432,7 @@ static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
> >   		if (likely(!is_xdp_frame(ptr))) {
> >   			struct sk_buff *skb = ptr;
> > +			virtnet_record_tx_tstamp(sq, skb);
> >   			pr_debug("Sent skb %p\n", skb);
> >   			bytes += skb->len;
> > @@ -1558,7 +1579,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
> >   	struct virtio_net_hdr_mrg_rxbuf *hdr;
> >   	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
> >   	struct virtnet_info *vi = sq->vq->vdev->priv;
> > -	struct virtio_net_hdr_v1_hash *ht;
> > +	struct virtio_net_hdr_hash_ts *ht;
> >   	int num_sg;
> >   	unsigned hdr_len = vi->hdr_len;
> >   	bool can_push;
> > @@ -1567,7 +1588,8 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
> >   	can_push = vi->any_header_sg &&
> >   		!((unsigned long)skb->data & (__alignof__(*hdr) - 1)) &&
> > -		!skb_header_cloned(skb) && skb_headroom(skb) >= hdr_len;
> > +		!skb_header_cloned(skb) && skb_headroom(skb) >= hdr_len &&
> > +		!vi->enable_tx_tstamp;
> >   	/* Even if we can, don't push here yet as this would skew
> >   	 * csum_start offset below. */
> >   	if (can_push)
> > @@ -1588,10 +1610,12 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
> >   		u16 report = skb->l4_hash ? VIRTIO_NET_HASH_REPORT_L4 :
> >   					    VIRTIO_NET_HASH_REPORT_OTHER;
> > -		ht->hash_value = cpu_to_le32(skb->hash);
> > -		ht->hash_report = cpu_to_le16(report);
> > -		ht->hash_state = cpu_to_le16(VIRTIO_NET_HASH_STATE_DEFAULT);
> > +		ht->hash.value = cpu_to_le32(skb->hash);
> > +		ht->hash.report = cpu_to_le16(report);
> > +		ht->hash.flow_state = cpu_to_le16(VIRTIO_NET_HASH_STATE_DEFAULT);
> >   	}
> > +	if (vi->enable_tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
> > +		ht->hdr.flags |= VIRTIO_NET_HDR_F_TSTAMP;
> >   	sg_init_table(sq->sg, skb_shinfo(skb)->nr_frags + (can_push ? 1 : 2));
> >   	if (can_push) {
> > @@ -2307,7 +2331,13 @@ static int virtnet_get_ts_info(struct net_device *dev,
> >   		info->rx_filters = HWTSTAMP_FILTER_NONE;
> >   	}
> > -	info->tx_types = HWTSTAMP_TX_OFF;
> > +	if (vi->has_tx_tstamp) {
> > +		info->so_timestamping |= SOF_TIMESTAMPING_TX_HARDWARE |
> > +					 SOF_TIMESTAMPING_RAW_HARDWARE;
> > +		info->tx_types = HWTSTAMP_TX_ON;
> > +	} else {
> > +		info->tx_types = HWTSTAMP_TX_OFF;
> > +	}
> >   	return 0;
> >   }
> > @@ -2616,7 +2646,8 @@ static int virtnet_ioctl_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
> >   		return -EFAULT;
> >   	if (tsconf.flags)
> >   		return -EINVAL;
> > -	if (tsconf.tx_type != HWTSTAMP_TX_OFF)
> > +	if (tsconf.tx_type != HWTSTAMP_TX_OFF &&
> > +	    tsconf.tx_type != HWTSTAMP_TX_ON)
> >   		return -ERANGE;
> >   	if (tsconf.rx_filter != HWTSTAMP_FILTER_NONE &&
> >   	    tsconf.rx_filter != HWTSTAMP_FILTER_ALL)
> > @@ -2627,6 +2658,11 @@ static int virtnet_ioctl_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
> >   	else
> >   		vi->enable_rx_tstamp = tsconf.rx_filter == HWTSTAMP_FILTER_ALL;
> > +	if (!vi->has_tx_tstamp)
> > +		tsconf.tx_type = HWTSTAMP_TX_OFF;
> > +	else
> > +		vi->enable_tx_tstamp = tsconf.tx_type == HWTSTAMP_TX_ON;
> > +
> >   	if (copy_to_user(ifr->ifr_data, &tsconf, sizeof(tsconf)))
> >   		return -EFAULT;
> > @@ -2641,7 +2677,8 @@ static int virtnet_ioctl_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
> >   	tsconf.flags = 0;
> >   	tsconf.rx_filter = vi->enable_rx_tstamp ? HWTSTAMP_FILTER_ALL :
> >   						  HWTSTAMP_FILTER_NONE;
> > -	tsconf.tx_type = HWTSTAMP_TX_OFF;
> > +	tsconf.tx_type = vi->enable_tx_tstamp ? HWTSTAMP_TX_ON :
> > +						HWTSTAMP_TX_OFF;
> >   	if (copy_to_user(ifr->ifr_data, &tsconf, sizeof(tsconf)))
> >   		return -EFAULT;
> > @@ -3178,6 +3215,12 @@ static int virtnet_probe(struct virtio_device *vdev)
> >   		vi->hdr_len = sizeof(struct virtio_net_hdr_hash_ts);
> >   	}
> > +	if (virtio_has_feature(vdev, VIRTIO_NET_F_TX_TSTAMP) &&
> > +	    !vring_use_dma_api(vdev)) {
> > +		vi->has_tx_tstamp = true;
> > +		vi->hdr_len = sizeof(struct virtio_net_hdr_hash_ts);
> > +	}
> > +
> >   	if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
> >   	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> >   		vi->any_header_sg = true;
> > @@ -3369,7 +3412,7 @@ static struct virtio_device_id id_table[] = {
> >   	VIRTIO_NET_F_CTRL_MAC_ADDR, \
> >   	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> >   	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> > -	VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP
> > +	VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP, VIRTIO_NET_F_TX_TSTAMP
> >   static unsigned int features[] = {
> >   	VIRTNET_FEATURES,
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 71e16b53e9c1..cf5d5d1f9b14 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -238,7 +238,7 @@ static inline bool virtqueue_use_indirect(struct virtqueue *_vq,
> >    * unconditionally on data path.
> >    */
> > -static bool vring_use_dma_api(struct virtio_device *vdev)
> > +bool vring_use_dma_api(struct virtio_device *vdev)
> >   {
> >   	if (!virtio_has_dma_quirk(vdev))
> >   		return true;
> > @@ -257,6 +257,7 @@ static bool vring_use_dma_api(struct virtio_device *vdev)
> >   	return false;
> >   }
> > +EXPORT_SYMBOL_GPL(vring_use_dma_api);
> >   size_t virtio_max_dma_size(struct virtio_device *vdev)
> >   {
> > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > index 55ea329fe72a..5289e2812e95 100644
> > --- a/include/linux/virtio.h
> > +++ b/include/linux/virtio.h
> > @@ -140,6 +140,7 @@ int virtio_device_freeze(struct virtio_device *dev);
> >   int virtio_device_restore(struct virtio_device *dev);
> >   #endif
> > +bool vring_use_dma_api(struct virtio_device *vdev);
> >   size_t virtio_max_dma_size(struct virtio_device *vdev);
> >   #define virtio_device_for_each_vq(vdev, vq) \
> > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> > index a5c84410cf92..b5d6f0c6cead 100644
> > --- a/include/uapi/linux/virtio_net.h
> > +++ b/include/uapi/linux/virtio_net.h
> > @@ -57,6 +57,7 @@
> >   					 * Steering */
> >   #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
> > +#define VIRTIO_NET_F_TX_TSTAMP	  54	/* Device sends TAI transmit time */
> >   #define VIRTIO_NET_F_RX_TSTAMP	  55	/* Device sends TAI receive time */
> 
> 
> I wonder how much value to split into two features.
> 
> Thanks
> 
> 
> >   #define VIRTIO_NET_F_TX_HASH	  56	/* Driver sends hash report */
> >   #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */


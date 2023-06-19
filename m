Return-Path: <netdev+bounces-11941-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A5A7355B7
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C898428110C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39435D2F1;
	Mon, 19 Jun 2023 11:27:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D63FC8E8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:27:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2258187
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 04:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687174053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zh5IQuiIAUYkefOhABEziM0DhfI+q27ES/7CYkgrJC0=;
	b=HGlv1oCu+0Sm1zSdRvx19V/leIhPW85jB2AWa8oYd/TFS/l5QjSUomtDezREipv5fFE5y6
	68/bXo9mGuquPwrIpgN67UhCqNGMnJlLB4Ch7oRSOvF5p5kFZyWWEzUot03+myAt+VLvhF
	2P3rvvl3Z4xQMmA+MwrRSFvLoPQqs3M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-kGMB7sHTM_mWQHokRW5yBg-1; Mon, 19 Jun 2023 07:27:31 -0400
X-MC-Unique: kGMB7sHTM_mWQHokRW5yBg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f8fa2ef407so10987695e9.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 04:27:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687174051; x=1689766051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zh5IQuiIAUYkefOhABEziM0DhfI+q27ES/7CYkgrJC0=;
        b=haKM8LoSu1gKj310h9xZZPptmRdLkBPO81IJepD+8c6bGkoHmfSi+XA+pgo2KJ9R2U
         MD5wcZRHldSbGA3ukJcO0xE+I1vEMNa5I8m54euyM3HBWroZw5EHny61SdhPe9gQCuT4
         kTKLGUpD078tXoqFwnPXlv/ipgXgGVXqzP/2WmGVP8FReFUlNeIsy4HijyOFv8ySJ0pk
         J3TpuhKT+Pg9ZePophgxhMlYk4TDqlUYBD3pSzDYON+HXU0CPJ3BqznT79hNG89P2Km0
         AYYaUUNxGkpZCCygeK3mYK8KloV301Ff/zPDkdow+Pqc7CMgCldtCiAtfkPJXq1F+JOA
         1cbQ==
X-Gm-Message-State: AC+VfDxBF9THSm0QtYx84K5lvgko5S8llM780o3IAzD89ULG7adWWnXq
	GwWuSRjjif44jqDjKtjFEd9f4v5LCAulVlv1H1rn88GLBVe8gBTkdZowq8KgiO2PU3Lt/98bCqv
	xCR2NPLvhoXmFXlC0
X-Received: by 2002:a05:600c:2112:b0:3f7:395e:46a2 with SMTP id u18-20020a05600c211200b003f7395e46a2mr6399011wml.16.1687174050871;
        Mon, 19 Jun 2023 04:27:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Nc2QR5k5hCKzbQWbZJxxMcW93Z3w8LARddlu/uxWen5gDlYsRKsb0TwL0znnH8mS8wrPglQ==
X-Received: by 2002:a05:600c:2112:b0:3f7:395e:46a2 with SMTP id u18-20020a05600c211200b003f7395e46a2mr6399001wml.16.1687174050678;
        Mon, 19 Jun 2023 04:27:30 -0700 (PDT)
Received: from redhat.com ([2.52.15.156])
        by smtp.gmail.com with ESMTPSA id v11-20020a7bcb4b000000b003f8d6647661sm10400086wmj.15.2023.06.19.04.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 04:27:30 -0700 (PDT)
Date: Mon, 19 Jun 2023 07:27:26 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Heng Qi <hengqi@linux.alibaba.com>
Cc: netdev@vger.kernel.org, bpf@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next 2/4] virtio-net: reprobe csum related fields for
 skb passed by XDP
Message-ID: <20230619072651-mutt-send-email-mst@kernel.org>
References: <20230619105738.117733-1-hengqi@linux.alibaba.com>
 <20230619105738.117733-3-hengqi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619105738.117733-3-hengqi@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 06:57:36PM +0800, Heng Qi wrote:
> Currently, the VIRTIO_NET_F_GUEST_CSUM (corresponds to NETIF_F_RXCSUM
> for netdev) feature of the virtio-net driver conflicts with the loading
> of XDP, which is caused by the problem described in [1][2], that is,
> XDP may cause errors in partial csumed-related fields which can lead
> to packet dropping.
> 
> In addition, when communicating between vm and vm on the same host, the
> receiving side vm will receive packets marked as
> VIRTIO_NET_HDR_F_NEEDS_CSUM, but after these packets are processed by
> XDP, the VIRTIO_NET_HDR_F_NEEDS_CSUM and skb CHECKSUM_PARTIAL flags will
> be cleared, causing the packet dropping.
> 
> This patch introduces a helper function, which will try to solve the
> above problems in the subsequent patch.
> 
> [1] commit 18ba58e1c234 ("virtio-net: fail XDP set if guest csum is negotiated")
> [2] commit e59ff2c49ae1 ("virtio-net: disable guest csum during XDP set")
> 
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


squash this and patch 1 into where the helpers are used.

in particular so we don't get warnings with bisect.

> ---
>  drivers/net/virtio_net.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 36cae78f6311..07b4801d689c 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1663,6 +1663,44 @@ static int virtnet_flow_dissect_udp_tcp(struct virtnet_info *vi, struct sk_buff
>  	return 0;
>  }
>  
> +static int virtnet_set_csum_after_xdp(struct virtnet_info *vi,
> +				      struct sk_buff *skb,
> +				      __u8 flags)
> +{
> +	int err;
> +
> +	/* When XDP program is loaded, for example, the vm-vm scenario
> +	 * on the same host, packets marked as VIRTIO_NET_HDR_F_NEEDS_CSUM
> +	 * will travel. Although these packets are safe from the point of
> +	 * view of the vm, to avoid modification by XDP and successful
> +	 * forwarding in the upper layer, we re-probe the necessary checksum
> +	 * related information: skb->csum_{start, offset}, pseudo-header csum.
> +	 *
> +	 * This benefits us:
> +	 * 1. XDP can be loaded when there's _F_GUEST_CSUM.
> +	 * 2. The device verifies the checksum of packets , especially
> +	 *    benefiting for large packets.
> +	 * 3. In the same-host vm-vm scenario, packets marked as
> +	 *    VIRTIO_NET_HDR_F_NEEDS_CSUM are no longer dropped after being
> +	 *    processed by XDP.
> +	 */
> +	if (flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
> +		err = virtnet_flow_dissect_udp_tcp(vi, skb);
> +		if (err < 0)
> +			return -EINVAL;
> +
> +		skb->ip_summed = CHECKSUM_PARTIAL;
> +	} else if (flags && VIRTIO_NET_HDR_F_DATA_VALID) {
> +		/* We want to benefit from this: XDP guarantees that packets marked
> +		 * as VIRTIO_NET_HDR_F_DATA_VALID still have correct csum after they
> +		 * are processed.
> +		 */
> +		skb->ip_summed = CHECKSUM_UNNECESSARY;
> +	}
> +
> +	return 0;
> +}
> +
>  static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>  			void *buf, unsigned int len, void **ctx,
>  			unsigned int *xdp_xmit,
> -- 
> 2.19.1.6.gb485710b



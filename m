Return-Path: <netdev+bounces-8333-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2DBC723BE4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8722C281597
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B913D8A;
	Tue,  6 Jun 2023 08:34:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E901C818
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:34:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6653D10D8
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686040395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lM2mS3A3zk3o/TK+dZncVPidMr9a4SjCD0isQDm9YqI=;
	b=VFlygUSHt8SVrk5vo3CXm8LKzzmaz1qEZTUiUft7y/MgszQWPPutohRu1UImxvyP2G1fzg
	XThbCGAwGdrSXYQhO2UQAiye6Qc5TMMM0oMdFYyJmnE8MNll25wAFw8HlQ23Jz7RofM81+
	dyWM1EHksKy35hl2uCbV3b/qa+zK4z4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-e90jSIvhN7ubtbLdPNtEOQ-1; Tue, 06 Jun 2023 04:30:04 -0400
X-MC-Unique: e90jSIvhN7ubtbLdPNtEOQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f612a1b0fdso35039135e9.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 01:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686040203; x=1688632203;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lM2mS3A3zk3o/TK+dZncVPidMr9a4SjCD0isQDm9YqI=;
        b=RDvEPO0eGzyVvNIBDGIWcBmPbunwRPifD6yqMC/04Zonaznm6NxpL787T5EfVWMoSW
         ltOFszmy2AnT7gh9Sj7JGhaGMisZZyRe3sDfE57qpkNDUmvUx1WtCXBVV4c5DxJnSqal
         QIojGBV5mqCDaMmY3l26Wb9N69+8+fr5ccIo35UjDL219alltGnLdc3GmOGT/YL9jtd1
         ZjCRUQ5XcQoPNIuLxlV362a+Q2AWWbHL2fAcohkcyXCvykC4I80mtqA0ZRV/TJ7y44Rw
         TXW7HkgjRnle5TdyZkcwGGcx/4wzDnN460CxG2DeW1Sb7Mw478T7xTbB3mMX5oIqpGHT
         VG+w==
X-Gm-Message-State: AC+VfDwSra/7aKpFOCcqu8cKOcRZvKcPf3JCHd5XFMKqO1aZxxB5cqEc
	yAL4TrKV732q/FVtAQKj/JuY7gBmjc2XESt367IcvnyhDBFB/zLACo64tinkboQ9K97xz+E9mWy
	cGdKYR/8q/n8Q8vvC
X-Received: by 2002:a05:600c:218b:b0:3f7:39ed:c9a4 with SMTP id e11-20020a05600c218b00b003f739edc9a4mr1718493wme.30.1686040203301;
        Tue, 06 Jun 2023 01:30:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4wzn5kTFHCj7kpNMtHXKZMzbAwhIp+5L6K4sup6x8HZTdlr5Lt/2XPeXnEL6/uX9ypoH2r+w==
X-Received: by 2002:a05:600c:218b:b0:3f7:39ed:c9a4 with SMTP id e11-20020a05600c218b00b003f739edc9a4mr1718474wme.30.1686040202996;
        Tue, 06 Jun 2023 01:30:02 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id n16-20020a1c7210000000b003f736e28cd6sm7884431wmc.4.2023.06.06.01.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 01:30:02 -0700 (PDT)
Date: Tue, 6 Jun 2023 04:29:58 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	alvaro.karsz@solid-run.com, pabeni@redhat.com, kuba@kernel.org,
	edumazet@google.com, davem@davemloft.net,
	xuanzhuo@linux.alibaba.com, jasowang@redhat.com,
	shannon.nelson@amd.com, allen.hubbe@amd.com
Subject: Re: [PATCH net] virtio_net: use control_buf for coalesce params
Message-ID: <20230606042942-mutt-send-email-mst@kernel.org>
References: <20230605195925.51625-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605195925.51625-1-brett.creeley@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 12:59:25PM -0700, Brett Creeley wrote:
> Commit 699b045a8e43 ("net: virtio_net: notifications coalescing
> support") added coalescing command support for virtio_net. However,
> the coalesce commands are using buffers on the stack, which is causing
> the device to see DMA errors. There should also be a complaint from
> check_for_stack() in debug_dma_map_xyz(). Fix this by adding and using
> coalesce params from the control_buf struct, which aligns with other
> commands.
> 
> Fixes: 699b045a8e43 ("net: virtio_net: notifications coalescing support")
> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
> Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

stable material too.

> ---
>  drivers/net/virtio_net.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 56ca1d270304..486b5849033d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -205,6 +205,8 @@ struct control_buf {
>  	__virtio16 vid;
>  	__virtio64 offloads;
>  	struct virtio_net_ctrl_rss rss;
> +	struct virtio_net_ctrl_coal_tx coal_tx;
> +	struct virtio_net_ctrl_coal_rx coal_rx;
>  };
>  
>  struct virtnet_info {
> @@ -2934,12 +2936,10 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
>  				       struct ethtool_coalesce *ec)
>  {
>  	struct scatterlist sgs_tx, sgs_rx;
> -	struct virtio_net_ctrl_coal_tx coal_tx;
> -	struct virtio_net_ctrl_coal_rx coal_rx;
>  
> -	coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
> -	coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
> -	sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
> +	vi->ctrl->coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
> +	vi->ctrl->coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
> +	sg_init_one(&sgs_tx, &vi->ctrl->coal_tx, sizeof(vi->ctrl->coal_tx));
>  
>  	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
>  				  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
> @@ -2950,9 +2950,9 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
>  	vi->tx_usecs = ec->tx_coalesce_usecs;
>  	vi->tx_max_packets = ec->tx_max_coalesced_frames;
>  
> -	coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
> -	coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
> -	sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
> +	vi->ctrl->coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
> +	vi->ctrl->coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
> +	sg_init_one(&sgs_rx, &vi->ctrl->coal_rx, sizeof(vi->ctrl->coal_rx));
>  
>  	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
>  				  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
> -- 
> 2.17.1



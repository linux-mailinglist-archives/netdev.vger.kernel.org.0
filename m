Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836636E3BF1
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 22:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjDPUjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 16:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPUjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 16:39:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9DD211B
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 13:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681677498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1gmjEPQ1Z2707YDu2q8TGB4gvRcqR+kjHgJ0ZU8q2GE=;
        b=UABSA020eadNdRYgNssvgDc9HlSzrAN2ANud2WR7U5X3ZPIzghaOt7q32NRKV+FRdEtkE2
        I8vuMMnXYhcYu0zZ12/sSyl4eKVcFljgMDckuskuhG2lepF695Pqy2m//FDNoX+wq4lDAL
        155AuKsrXsv4J49Ra5h1w45bX8Apmzs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-tCcDFZkFPvqo4yNDZ0NMgw-1; Sun, 16 Apr 2023 16:38:17 -0400
X-MC-Unique: tCcDFZkFPvqo4yNDZ0NMgw-1
Received: by mail-ed1-f69.google.com with SMTP id r1-20020a50d681000000b0050504eaf919so7129475edi.8
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 13:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681677496; x=1684269496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1gmjEPQ1Z2707YDu2q8TGB4gvRcqR+kjHgJ0ZU8q2GE=;
        b=C3CCkpCB+9dCYDFqeHKOWe8V+Pii/vNWkiawWWUYGuopmdCHIsKNgD1i20+I48yy64
         2uWd94QrryM5i24sQ/UU5tZ0yHKyhO+L7M0LRPxfZdrmPbNMqsWvD2pB0WoXJaHBq8pA
         dDEJoQWaiNOlBG+uh+gWzwmuzU9ipV0sn+yzUVPwzLJLT5/VAcvxEe1AsrEbtAx1fTW9
         NjWiHAuKjEh9WMy7TVSbAlnw7BJZ9DXclsTsTJR8hN435Js11+bTfMfDxCtSGzjsKvzo
         0WF2IOqnRVlWR1+u6P+R/Z5DrwKJdNSGdr3QBpEbqRGiDP3Ddmv+s+ZET2zhU2qM/jE+
         8hug==
X-Gm-Message-State: AAQBX9cz+/X519pZHcFT1xSkkIjukITwvHgg/K7gtsLCwD5A0taLEWfY
        CKw8VqnwF9yNRbkIikMl0GRpynR34BtEbxTJwi1Kn+kcrcW87uTu7PUaUVDX8E4W567lD7gBbhJ
        FueqKA4yBYrvlUqjnwpY+obHu
X-Received: by 2002:a17:906:bc42:b0:94f:5e17:e80d with SMTP id s2-20020a170906bc4200b0094f5e17e80dmr2534416ejv.45.1681677495993;
        Sun, 16 Apr 2023 13:38:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZXEZ6g56atv06YaLfflLN9idtJzsyZtc6S7GD+9Ye4l6xSIop1CrwmmH2GLzP5maJM6si0Jg==
X-Received: by 2002:a17:906:bc42:b0:94f:5e17:e80d with SMTP id s2-20020a170906bc4200b0094f5e17e80dmr2534403ejv.45.1681677495687;
        Sun, 16 Apr 2023 13:38:15 -0700 (PDT)
Received: from redhat.com ([2.52.136.129])
        by smtp.gmail.com with ESMTPSA id xg12-20020a170907320c00b0094ee99eeb01sm3877035ejb.150.2023.04.16.13.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 13:38:15 -0700 (PDT)
Date:   Sun, 16 Apr 2023 16:38:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     jasowang@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Message-ID: <20230416163751-mutt-send-email-mst@kernel.org>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 10:46:07AM +0300, Alvaro Karsz wrote:
> Check vring size and fail probe if a transmit/receive vring size is
> smaller than MAX_SKB_FRAGS + 2.
> 
> At the moment, any vring size is accepted. This is problematic because
> it may result in attempting to transmit a packet with more fragments
> than there are descriptors in the ring.
> 
> Furthermore, it leads to an immediate bug:
> 
> The condition: (sq->vq->num_free >= 2 + MAX_SKB_FRAGS) in
> virtnet_poll_cleantx and virtnet_poll_tx always evaluates to false,
> so netif_tx_wake_queue is not called, leading to TX timeouts.
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> ---
>  drivers/net/virtio_net.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2396c28c012..59676252c5c 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3745,6 +3745,26 @@ static int init_vqs(struct virtnet_info *vi)
>  	return ret;
>  }
>  
> +static int virtnet_validate_vqs(struct virtnet_info *vi)
> +{
> +	u32 i, min_size = roundup_pow_of_two(MAX_SKB_FRAGS + 2);

why power of two?

> +
> +	/* Transmit/Receive vring size must be at least MAX_SKB_FRAGS + 2
> +	 * (fragments + linear part + virtio header)
> +	 */
> +	for (i = 0; i < vi->max_queue_pairs; i++) {
> +		if (virtqueue_get_vring_size(vi->sq[i].vq) < min_size ||
> +		    virtqueue_get_vring_size(vi->rq[i].vq) < min_size) {
> +			dev_warn(&vi->vdev->dev,
> +				 "Transmit/Receive virtqueue vring size must be at least %u\n",
> +				 min_size);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  #ifdef CONFIG_SYSFS
>  static ssize_t mergeable_rx_buffer_size_show(struct netdev_rx_queue *queue,
>  		char *buf)
> @@ -4056,6 +4076,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (err)
>  		goto free;
>  
> +	err = virtnet_validate_vqs(vi);
> +	if (err)
> +		goto free_vqs;
> +
>  #ifdef CONFIG_SYSFS
>  	if (vi->mergeable_rx_bufs)
>  		dev->sysfs_rx_queue_group = &virtio_net_mrg_rx_group;
> -- 
> 2.34.1


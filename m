Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D7068DBF3
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjBGOor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbjBGOo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:44:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB25D3AAE
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 06:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675780981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y7UwxcvAseBsjh7pGrBqJ/wmKCj0VJ5wu3GBO8xXE30=;
        b=GbDx/ELsa6N3m9rQDNOQ3b3b+LZWgfgdSiinn7M0HAuN8BaXC+OufiWxckJHFyeSyz901V
        cC3J4pev2/9JkMKFRFm2uKZVA7jok6LjUv135htL32ReqNDBnjW6XgReoDeD0t6oKejfN0
        HNrtF+XZCjOyLdb+gC3aRc77OvaYM18=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-313-r6uIAtuCNaya_zjBLF0QEw-1; Tue, 07 Feb 2023 09:31:20 -0500
X-MC-Unique: r6uIAtuCNaya_zjBLF0QEw-1
Received: by mail-wr1-f69.google.com with SMTP id g15-20020adfd1ef000000b002c3daec14f3so1499662wrd.3
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 06:31:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7UwxcvAseBsjh7pGrBqJ/wmKCj0VJ5wu3GBO8xXE30=;
        b=7LaIgB3eoMEpEOlr6AjJFX61CPLP9wBERgZwcc/rRtIMgqKOYY72868+2c6tbi+ey0
         8dfNQPrJhhU+mw+Z8iU3d+NKlXkVwxgBeGGLgh0g1ThX6MeSaY+yy7qZHVaQM8fTB813
         0735LwRBna6Uh6TYABqdlcgtrOAxTG9UDSRVLSbqqYEIV+suiwdXVcUE90oUwvLgRHNE
         XfB1xwft8w6HDJPfXYGIECF1g7HXQcvaPqM1FbtC4pvzUpwYWf8rX4OLU9AQJhNrF+/l
         rp+0kLfpe4fVYo0GLfa0mxELNBPIZ65yzzdeoLkkTahACGSydWDN180eUCWz2xB/9uFT
         P7aA==
X-Gm-Message-State: AO0yUKXl6agS0iU/FfHT3FUlwPytRPcJW2jaFNYzdBQCVER1t6bJibvL
        6ORU1+y5qaguS1eO/samRSdMI6eDFZaCwoIt18cZepVYiVr538Tx/hLclfEAFkuh8Q8/71IXo20
        6c5vIM/cmx6mrdguy
X-Received: by 2002:adf:f692:0:b0:2bf:d0a4:3e63 with SMTP id v18-20020adff692000000b002bfd0a43e63mr2834808wrp.44.1675780275060;
        Tue, 07 Feb 2023 06:31:15 -0800 (PST)
X-Google-Smtp-Source: AK7set9EMyvWAcesJnVx+zWygqLzgzk04YOqSIrlVesjXu4aN4SVh8ZHPZ0ICb66swxD2EjUb062cw==
X-Received: by 2002:adf:f692:0:b0:2bf:d0a4:3e63 with SMTP id v18-20020adff692000000b002bfd0a43e63mr2834785wrp.44.1675780274874;
        Tue, 07 Feb 2023 06:31:14 -0800 (PST)
Received: from redhat.com ([2.52.8.17])
        by smtp.gmail.com with ESMTPSA id c12-20020adffb4c000000b002b6bcc0b64dsm11357157wrs.4.2023.02.07.06.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 06:31:14 -0800 (PST)
Date:   Tue, 7 Feb 2023 09:31:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        lorenzo.bianconi@redhat.com, jasowang@redhat.com, hawk@kernel.org,
        john.fastabend@gmail.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH bpf-next] virtio_net: update xdp_features with xdp
 multi-buff
Message-ID: <20230207093102-mutt-send-email-mst@kernel.org>
References: <60c76cd63a0246db785606e8891b925fd5c9bf06.1675763384.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60c76cd63a0246db785606e8891b925fd5c9bf06.1675763384.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 10:53:40AM +0100, Lorenzo Bianconi wrote:
> Now virtio-net supports xdp multi-buffer so add it to xdp_features
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

makes sense


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 692dff071782..ddc3dc7ea73c 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3281,7 +3281,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>  				virtnet_clear_guest_offloads(vi);
>  		}
>  		if (!old_prog)
> -			xdp_features_set_redirect_target(dev, false);
> +			xdp_features_set_redirect_target(dev, true);
>  	} else {
>  		xdp_features_clear_redirect_target(dev);
>  		vi->xdp_enabled = false;
> @@ -3940,8 +3940,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
>  	spin_lock_init(&vi->refill_lock);
>  
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
>  		vi->mergeable_rx_bufs = true;
> +		dev->xdp_features |= NETDEV_XDP_ACT_RX_SG;
> +	}
>  
>  	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
>  		vi->rx_usecs = 0;
> -- 
> 2.39.1


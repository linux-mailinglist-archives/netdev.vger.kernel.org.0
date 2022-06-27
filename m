Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27B955D768
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiF0Hoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbiF0Hob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:44:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3410C60C6
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656315868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9JFk1orzuEaIozJoxvbuTHAStsu1Q5iabE/7CHYRH08=;
        b=Mv3kIJErS7wp/Y55Ab2p1uQCUVZA/zUdHu0cLlnLJIwsJkJF8M+4fiheZ8El4nfAGf+Rkl
        jlynTXMBUmlJoaBGti7nxQzyd3uX7rm+wOemk6/GIXijQ1Mbpj43f+pZO7VzABcW9/UexR
        DaB1Oej8as9VRRi1YBj2tCWO3Z83GFE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-A_5fLLhnP1e98V_L_aaQsA-1; Mon, 27 Jun 2022 03:44:26 -0400
X-MC-Unique: A_5fLLhnP1e98V_L_aaQsA-1
Received: by mail-wr1-f70.google.com with SMTP id n5-20020adf8b05000000b00219ece7272bso950048wra.8
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:44:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9JFk1orzuEaIozJoxvbuTHAStsu1Q5iabE/7CHYRH08=;
        b=bDbPc4f6s1hktR/pZBgWoO4XpgDmaBuYzBSYdH6HOhxRdeWUVdlQfZCP+2q+12mg4a
         FfxMbTMcofvs4aTnnohFj7EWyC1FrzLKaCXFhm5pg86vfgeU9cWMR8bIKDYT6FDw/8a6
         5Tsc+tNfgjV6ypJlzUj1jCyQsc0CJbnJlUqRgxu61bEs5O5YXwDe1i0dZgegiGEHBbJP
         ulrCH6qQoNX7+wl/CsLMHGZJfUYYqJZwCndVxeYl6MKVdd74kudYrwqkkT0eBLNGIoP/
         QP9r/QENVxnkNDr/GCneXg1tUuoWpUP618Xl/iIHRPDPEMaE1P7aSv0AHzITXDkIzuNF
         bitw==
X-Gm-Message-State: AJIora8byMWVLEH9a8rK9Anfcxy/U49OVbXMdyOmkOHh9uFV3EFQcdwM
        /qTAlHrVIcraGYRfL+bD9kXr17Mv33EzUAM5puaMgLaYdH+P128dWNmzmDnxQg0h/NAaFZThmJw
        EwE7jdUtaszLAWDKj
X-Received: by 2002:a5d:49cc:0:b0:21b:aaec:eba8 with SMTP id t12-20020a5d49cc000000b0021baaeceba8mr10755141wrs.660.1656315865084;
        Mon, 27 Jun 2022 00:44:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sbVryOidUE0xJ953k5Axs8LsqG+OeJXJtKMhrC6JEI5Et8HZUs3TNohurBNJO6jZ45MJflcw==
X-Received: by 2002:a5d:49cc:0:b0:21b:aaec:eba8 with SMTP id t12-20020a5d49cc000000b0021baaeceba8mr10755126wrs.660.1656315864813;
        Mon, 27 Jun 2022 00:44:24 -0700 (PDT)
Received: from redhat.com ([2.54.45.90])
        by smtp.gmail.com with ESMTPSA id k8-20020a05600c1c8800b003a04722d745sm5020741wms.23.2022.06.27.00.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 00:44:24 -0700 (PDT)
Date:   Mon, 27 Jun 2022 03:44:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] virtio-net: fix race between ndo_open() and
 virtio_device_ready()
Message-ID: <20220627033422-mutt-send-email-mst@kernel.org>
References: <20220627063656.52397-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627063656.52397-1-jasowang@redhat.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 02:36:56PM +0800, Jason Wang wrote:
> We used to call virtio_device_ready() after netdev registration.

s/used to call/currently call/

> This
> cause

s/This cause/Since ndo_open can be called immediately
after register_netdev, this means there exists/

> a race between ndo_open() and virtio_device_ready(): if
> ndo_open() is called before virtio_device_ready(), the driver may
> start to use the device before DRIVER_OK which violates the spec.
> 
> Fixing

s/Fixing/Fix/

> this by switching to use register_netdevice() and protect the
> virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
> only be called after virtio_device_ready().
> 
> Fixes: 4baf1e33d0842 ("virtio_net: enable VQs early")

it's an unusual use of Fixes - the patch in question does not
introduce the problem, it just does not fix it completely.
But OK I guess.

> Signed-off-by: Jason Wang <jasowang@redhat.com>

With commit log changes:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index db05b5e930be..8a5810bcb839 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3655,14 +3655,20 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (vi->has_rss || vi->has_rss_hash_report)
>  		virtnet_init_default_rss(vi);
>  
> -	err = register_netdev(dev);
> +	/* serialize netdev register + virtio_device_ready() with ndo_open() */
> +	rtnl_lock();
> +
> +	err = register_netdevice(dev);
>  	if (err) {
>  		pr_debug("virtio_net: registering device failed\n");
> +		rtnl_unlock();
>  		goto free_failover;
>  	}
>  
>  	virtio_device_ready(vdev);
>  
> +	rtnl_unlock();
> +
>  	err = virtnet_cpu_notif_add(vi);
>  	if (err) {
>  		pr_debug("virtio_net: registering cpu notifier failed\n");
> -- 
> 2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE86F51E4FB
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 08:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445954AbiEGHAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 03:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446074AbiEGG7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 02:59:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 076552D1F0
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 23:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651906555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mA3ni8Zg3OWPpt35GHXOc/cRif71faI1+8GwT0AzIDA=;
        b=bh5/eGsKyifoEK0lo3EJLutNEyVpoRvUbPzqOT4QwZN9ngIPPArq0SY3tHNm0BV0rSafyZ
        4nny+GQWeNcBDWwT9CndxjlCi9Pcyet0vp5oBI16p2Wj2x9CUOO7O+aPfXjHNOr26Wjmg0
        pXFOsAgIxopz0githzp9cDzNw/08jh0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-1nnfkd-wOPW2oX32ppH0ww-1; Sat, 07 May 2022 02:55:53 -0400
X-MC-Unique: 1nnfkd-wOPW2oX32ppH0ww-1
Received: by mail-wm1-f72.google.com with SMTP id t2-20020a7bc3c2000000b003528fe59cb9so2924016wmj.5
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 23:55:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mA3ni8Zg3OWPpt35GHXOc/cRif71faI1+8GwT0AzIDA=;
        b=ZBi/bLPwPSbrvyxB8ViBo0RJ0n4Qr8tTX2am46JTzaRqHRFxm919FZplY7ei2b4Hu7
         us2ULrorPv8tsyB7Wudrpp7ynnEip1mZUZY6u0d1oIPDSEDWBP8j+hoUhi/4fdYxWn5s
         1CMCbE923ssJ/fd0u/y0j6Qd3fR7MtIEWxpnrX5b+dDGiSD9aUAxP7Efi26408s975sb
         Fo4V2MtWDRz+qf575iVItKrir+M9BcSFYc4ylik486ZqCjGCm7Qj9/NxTVj4xt2ofJul
         aGFVjMErDuImK+dUu3POonxxm1aorbFVfcCvGDWgJ5PZAPtQLRryEHYQKQDXp0fi1uj+
         gr+Q==
X-Gm-Message-State: AOAM5321o89vWwe5SJ3oLCOjjEYUorM56DsCu+680KDp0DhFJTHMFLw/
        AFu9+udPaq9ySv5it4w5dJtUewZhgHTyaC3wwu3Kqwo33UtZbFlQaVdxqSTFHft1zfzoin97U9K
        BQokj3VNbKE3KDnPW
X-Received: by 2002:a1c:cc08:0:b0:393:e7d2:e580 with SMTP id h8-20020a1ccc08000000b00393e7d2e580mr6927383wmb.145.1651906552625;
        Fri, 06 May 2022 23:55:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB2ngzTaW/27Ki7b/jkMItsT5HlxPv1mI3lwVeD1vH5toUt9GGrERjwHdyAq5CSpK2ugUcsQ==
X-Received: by 2002:a1c:cc08:0:b0:393:e7d2:e580 with SMTP id h8-20020a1ccc08000000b00393e7d2e580mr6927375wmb.145.1651906552426;
        Fri, 06 May 2022 23:55:52 -0700 (PDT)
Received: from redhat.com ([2.55.154.141])
        by smtp.gmail.com with ESMTPSA id q20-20020a7bce94000000b0039456fb80b3sm8600883wmj.43.2022.05.06.23.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 23:55:51 -0700 (PDT)
Date:   Sat, 7 May 2022 02:55:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, wanghai38@huawei.com
Subject: Re: [PATCH net-next 2/6] caif_virtio: switch to
 netif_napi_add_weight()
Message-ID: <20220507025543-mutt-send-email-mst@kernel.org>
References: <20220506170751.822862-1-kuba@kernel.org>
 <20220506170751.822862-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506170751.822862-3-kuba@kernel.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 10:07:47AM -0700, Jakub Kicinski wrote:
> caif_virtio uses a custom napi weight, switch to the new
> API for setting custom weights.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> CC: mst@redhat.com
> CC: wanghai38@huawei.com
> ---
>  drivers/net/caif/caif_virtio.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
> index 444ef6a342f6..5458f57177a0 100644
> --- a/drivers/net/caif/caif_virtio.c
> +++ b/drivers/net/caif/caif_virtio.c
> @@ -714,7 +714,8 @@ static int cfv_probe(struct virtio_device *vdev)
>  	/* Initialize NAPI poll context data */
>  	vringh_kiov_init(&cfv->ctx.riov, NULL, 0);
>  	cfv->ctx.head = USHRT_MAX;
> -	netif_napi_add(netdev, &cfv->napi, cfv_rx_poll, CFV_DEFAULT_QUOTA);
> +	netif_napi_add_weight(netdev, &cfv->napi, cfv_rx_poll,
> +			      CFV_DEFAULT_QUOTA);
>  
>  	tasklet_setup(&cfv->tx_release_tasklet, cfv_tx_release_tasklet);
>  
> -- 
> 2.34.1


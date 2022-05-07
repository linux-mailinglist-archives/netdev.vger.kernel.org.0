Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F6451E4FC
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 08:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388494AbiEGHAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 03:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446041AbiEGG72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 02:59:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F27F205EA
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 23:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651906542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5ky9664jBBxipaK1+T4WD1CyHdwDxzdCPyIZwivjlQ8=;
        b=dIKeKr3O4sxKaECs90Z/7c9B8T2gcbz6zn2MniaM4seaE7B04phLK+zqo6TnrOD4IkJpWO
        Vl4Ake72tZwaWtl0AzGhUhnTt4PVb+nZ4z1iHVZz1jRRQViyjFbWDtJ/uSuhnGYN4HXj1K
        HnC2bZAy5KdRnuaGCAHedz4TFDkwNUE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-wkLGuiA-MWGO7f7sMmqw1w-1; Sat, 07 May 2022 02:55:40 -0400
X-MC-Unique: wkLGuiA-MWGO7f7sMmqw1w-1
Received: by mail-wm1-f72.google.com with SMTP id e9-20020a05600c4e4900b00394779649b1so2492720wmq.3
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 23:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5ky9664jBBxipaK1+T4WD1CyHdwDxzdCPyIZwivjlQ8=;
        b=XXKI3aDMqXwpzZKeEpKUNDYOI8XGApq5Bre47lPSmibv7tcKU1x41xeg1UYtgT6rGN
         7UJHIfggBre+UPNu38HukSBK6DlolIQQ1jpAzlQXvloqKgeXt+JkQpzb6d+eILLFSKbX
         qxw+Qo/eMEalKv9cO29zdCzqtUO/NytVI2VXxCrMusK0aTJ+PHDJ6lNPMszNLueo/6wn
         oQTcqDwwp9KSNMHu28zISr4rJ9KtZDgG0sBY4JFAbX6wqyeEyP7JVp5MN6auz4QSwcBv
         dIHQqNG8j6poJM8QMVudVIPu2Qz+iVAFKNsWVSLOYyvDXv1YFj3p9wmQ8Xx0TmDdKlLt
         RTJw==
X-Gm-Message-State: AOAM531346rsJCi4r3JeW4Q9LazDDdXT8+ZkPTrz3t5b3SMLi31y5Bpe
        3dfUxkcRhh/qtACVtPOxrz2K35aGivxTPO3B4g+7ARnbV7lJWCCHbCZ4NY6ZK/RfCRVrnWorGns
        cVXGyyEHQ1cswuGoV
X-Received: by 2002:a5d:5887:0:b0:20c:83c9:b72 with SMTP id n7-20020a5d5887000000b0020c83c90b72mr5533770wrf.588.1651906539534;
        Fri, 06 May 2022 23:55:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBtR1KWNuMpwef5G9NX642kzlWT08eDCiawrk/2foN5QTS+D1MNeZJ72hyJtzipf1hz24aGA==
X-Received: by 2002:a5d:5887:0:b0:20c:83c9:b72 with SMTP id n7-20020a5d5887000000b0020c83c90b72mr5533755wrf.588.1651906539325;
        Fri, 06 May 2022 23:55:39 -0700 (PDT)
Received: from redhat.com ([2.55.154.141])
        by smtp.gmail.com with ESMTPSA id t18-20020a5d6912000000b0020c5253d913sm5154408wru.95.2022.05.06.23.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 23:55:38 -0700 (PDT)
Date:   Sat, 7 May 2022 02:55:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next 5/6] net: virtio: switch to
 netif_napi_add_weight()
Message-ID: <20220507025428-mutt-send-email-mst@kernel.org>
References: <20220506170751.822862-1-kuba@kernel.org>
 <20220506170751.822862-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506170751.822862-6-kuba@kernel.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 10:07:50AM -0700, Jakub Kicinski wrote:
> virtio netdev driver uses a custom napi weight, switch to the new
> API for setting custom weight.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> CC: mst@redhat.com
> CC: jasowang@redhat.com
> CC: virtualization@lists.linux-foundation.org
> ---
>  drivers/net/virtio_net.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ebb98b796352..db05b5e930be 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3313,8 +3313,8 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>  	INIT_DELAYED_WORK(&vi->refill, refill_work);
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
>  		vi->rq[i].pages = NULL;
> -		netif_napi_add(vi->dev, &vi->rq[i].napi, virtnet_poll,
> -			       napi_weight);
> +		netif_napi_add_weight(vi->dev, &vi->rq[i].napi, virtnet_poll,
> +				      napi_weight);
>  		netif_napi_add_tx_weight(vi->dev, &vi->sq[i].napi,
>  					 virtnet_poll_tx,
>  					 napi_tx ? napi_weight : 0);
> -- 
> 2.34.1


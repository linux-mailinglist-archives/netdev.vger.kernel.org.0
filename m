Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84366516DF4
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 12:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384486AbiEBKQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 06:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384543AbiEBKPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 06:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0F3E1A065
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 03:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651486321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ubkPMM7lGOGefVidp2PZUNsHYwR7P6fqEV/HuLIFHHI=;
        b=hW9Y0rH3C/h652Mh2AlmUp4vFc6z8Lf7BT43nRcCCFc9V8IpwzsrhKsEwNV5g/M9D91phs
        yJ0XdMAyzJSA8GxPYjTEq8WuRwlQ5uLynYRlw5QRzPiMpKTDNdY4IggAtTfc7I263Ts6xi
        H4jkm89lsSR2ql0CPWmas6S6qfedDPE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-78HlJ4CsMsakIqy2BFC1fg-1; Mon, 02 May 2022 06:12:00 -0400
X-MC-Unique: 78HlJ4CsMsakIqy2BFC1fg-1
Received: by mail-wm1-f70.google.com with SMTP id q128-20020a1c4386000000b003942fe15835so1626689wma.6
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 03:12:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ubkPMM7lGOGefVidp2PZUNsHYwR7P6fqEV/HuLIFHHI=;
        b=V/1HaxJCrJdkdCxQpWLhZNGKxvO/d2p1ejIq0Qwez3WZfoH9HnN76UuWhqgszaivja
         DGjHc/5b34LKfwep+0l1+blAFsXk7OYg4U832Ao284EglJfGsBaJTgS7/G0lMH4bMIMn
         gYrlDb/w9olWQVuiS7eqB43WIHcr6DYTSUy64X4WOPNLNP5hd3TuqsOqqvZS0ms3DCiS
         9S8aSNJAe5vgB9w8WHraihU+lk8kUQ7BRSepPpj1INmlrRSoC+WPMq4SRUUwIU/RMNHR
         G0noeFNAtLvosbswzaHlmlKeZV6DR0al2ynrT5GBFXUS+1Qg+TVDl4H1ESXMrBOUDU3X
         MqYw==
X-Gm-Message-State: AOAM532KHjvm0VOlJxToBuwH0ygm+vLKylpcFpcQOK3m9WrdSKR9wvzT
        4ocBOjMPLl58LBK2CwbZIcE6ZoEOwzG5+3glj3Ph69I1pd8t/9Yu1dT2D4TvysMrGt06VHKBh5K
        FEH1Rfh1qc2QH4UrF
X-Received: by 2002:a05:6000:80e:b0:20c:5b45:a700 with SMTP id bt14-20020a056000080e00b0020c5b45a700mr5234046wrb.662.1651486319167;
        Mon, 02 May 2022 03:11:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyL+p/dZm6XFCVpnxRCr2V8pm5sCHEUSvuNjrOyzNTTrHW0Q4G/gDEV4PHvjWdF7VOSpcULlg==
X-Received: by 2002:a05:6000:80e:b0:20c:5b45:a700 with SMTP id bt14-20020a056000080e00b0020c5b45a700mr5234036wrb.662.1651486318917;
        Mon, 02 May 2022 03:11:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id z10-20020a1c4c0a000000b003942a244f54sm5952761wmf.45.2022.05.02.03.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 03:11:58 -0700 (PDT)
Message-ID: <4320a4cb3e826335db51a6fac49053dbd386f119.camel@redhat.com>
Subject: Re: [net-next PATCH] amt: Use BIT macros instead of open codes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Juhee Kang <claudiajkang@gmail.com>, ap420073@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Date:   Mon, 02 May 2022 12:11:57 +0200
In-Reply-To: <20220430135622.103683-1-claudiajkang@gmail.com>
References: <20220430135622.103683-1-claudiajkang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2022-04-30 at 13:56 +0000, Juhee Kang wrote:
> Replace open code related to bit operation with BIT macros, which kernel
> provided. This patch provides no functional change.
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> ---
>  drivers/net/amt.c | 2 +-
>  include/net/amt.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
> index 10455c9b9da0..76c1969a03f5 100644
> --- a/drivers/net/amt.c
> +++ b/drivers/net/amt.c
> @@ -959,7 +959,7 @@ static void amt_req_work(struct work_struct *work)
>  	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
>  	spin_lock_bh(&amt->lock);
>  out:
> -	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
> +	exp = min_t(u32, (1 * BIT(amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
>  	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 1000));
>  	spin_unlock_bh(&amt->lock);
>  }
> diff --git a/include/net/amt.h b/include/net/amt.h
> index 7a4db8b903ee..d2fd76b0a424 100644
> --- a/include/net/amt.h
> +++ b/include/net/amt.h
> @@ -354,7 +354,7 @@ struct amt_dev {
>  #define AMT_MAX_GROUP		32
>  #define AMT_MAX_SOURCE		128
>  #define AMT_HSIZE_SHIFT		8
> -#define AMT_HSIZE		(1 << AMT_HSIZE_SHIFT)
> +#define AMT_HSIZE		BIT(AMT_HSIZE_SHIFT)
>  
>  #define AMT_DISCOVERY_TIMEOUT	5000
>  #define AMT_INIT_REQ_TIMEOUT	1

Even if the 2 replaced statements use shift operations, they do not
look like bit manipulation: the first one is an exponential timeout,
the 2nd one is an (hash) size. I think using the BIT() macro here will
be confusing.

Cheers,

Paolo


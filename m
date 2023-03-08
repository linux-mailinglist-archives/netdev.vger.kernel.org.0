Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4596B161F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 00:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCHXF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 18:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCHXFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 18:05:41 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859A4580D3;
        Wed,  8 Mar 2023 15:05:25 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k37so58093wms.0;
        Wed, 08 Mar 2023 15:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678316724; x=1680908724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MrxkA4cq74hDMupjOi0zWcSJLkmKMsoUcThtRoU/3Oo=;
        b=nnp9T1aXGbvlYvJlD99TC+T19fkjxIZZSmADG+12rqYctJe3eVYg3L38Y8SnkD49CQ
         1gjF/uyCKT3k+OOwEJmrREG8WWwh7+Xfu01SQxHbUGdVVzfOLHi2ItZs+0i9JVDsgbIc
         JyIENEbmQDiUYsVFKeHDd1RWVFhFDy8IqqXfdWaEc72zgb+lcdtL+xL2sC/3d420UKwe
         lFSOSqd57sFlEFMKV5NZUEWa62VmrO+T/guun+aSOqKa4eEOtJlm1LATeVyCfrvdpgdx
         0Qb1hZtl8DN4eR4qKnL3eb+ZYcWlcRkhaKrqc9q1yrNMjVDUHCA1L0vpPIGcKWB+CE23
         JzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678316724; x=1680908724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MrxkA4cq74hDMupjOi0zWcSJLkmKMsoUcThtRoU/3Oo=;
        b=TLUQx5Fi/T6Tzwgx5xZk9Rw3DEqzZFFk44IuVisZWz8ekS3CXjNLRLHyZnCQ4/IzEn
         gXw6gcGYEHOs/KSBO+HvePu8Uz1dnfwXKkPOg3IpAgEWLqt8GDHS4bAKk6wbIUcq3mGu
         KxM1gYFu+hUjlSZfYQZSNdh31j5AfvyJqisElmRlo3e6N8xsAPx53jRY6KNth2ZKrc5u
         hKeYAF0iTOykrA/EdCW8RqhGMk57lrTGK38e2U2djaHzCI3o+T6nN33DzCnQFTe9jqti
         nBDXJvqqux6DwijtYSP/mqQhnLCFAgNHoz0iCUViizx15u1yXJPLpRTLHJ1EoU+FVA7j
         dW8w==
X-Gm-Message-State: AO0yUKV5xJ/16w0o+7ECUDgqXbe7WK4CxwGfYfVEX/gmYlMvs6g6QLzr
        KlewINiD085pjRX1wgqo+q8=
X-Google-Smtp-Source: AK7set+71iHzT2HoiBXeCi495NcoLsl4psvqiV+FiR8SAPV3dVdxadhB54QXVl9Wg4EXh9MTD8ASYg==
X-Received: by 2002:a05:600c:1c1e:b0:3df:f7ba:14f8 with SMTP id j30-20020a05600c1c1e00b003dff7ba14f8mr678359wms.1.1678316723831;
        Wed, 08 Mar 2023 15:05:23 -0800 (PST)
Received: from matrix-ESPRIMO-P710 (p57935146.dip0.t-ipconnect.de. [87.147.81.70])
        by smtp.gmail.com with ESMTPSA id d7-20020a05600c3ac700b003e0015c8618sm754537wms.6.2023.03.08.15.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 15:05:23 -0800 (PST)
Date:   Thu, 9 Mar 2023 00:05:21 +0100
From:   philipp hortmann <philipp.g.hortmann@gmail.com>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: rtl8xxxu: use module_usb_driver
Message-ID: <20230308230521.GA8064@matrix-ESPRIMO-P710>
References: <20230307195718.168021-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307195718.168021-1-martin@kaiser.cx>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 08:57:17PM +0100, Martin Kaiser wrote:
> We can use the module_usb_driver macro instead of open-coding the driver's
> init and exit functions. This is simpler and saves some lines of code.
> Other realtek wireless drivers use module_usb_driver as well.
> 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
>  .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 20 +------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index e619ed21fbfe..58dbad9a14c2 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -7455,24 +7455,6 @@ static struct usb_driver rtl8xxxu_driver = {
>  	.disable_hub_initiated_lpm = 1,
>  };
>  
> -static int __init rtl8xxxu_module_init(void)
> -{
> -	int res;
> -
> -	res = usb_register(&rtl8xxxu_driver);
> -	if (res < 0)
> -		pr_err(DRIVER_NAME ": usb_register() failed (%i)\n", res);
> -
> -	return res;
> -}
> -
> -static void __exit rtl8xxxu_module_exit(void)
> -{
> -	usb_deregister(&rtl8xxxu_driver);
> -}
> -
> -
>  MODULE_DEVICE_TABLE(usb, dev_table);
>  
> -module_init(rtl8xxxu_module_init);
> -module_exit(rtl8xxxu_module_exit);
> +module_usb_driver(rtl8xxxu_driver);
> -- 
> 2.30.2

Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com> # Edimax N150


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A4F5F270B
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 01:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiJBXIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 19:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiJBXIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 19:08:01 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5249543624
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 16:03:12 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-13256dbfd58so2182227fac.8
        for <netdev@vger.kernel.org>; Sun, 02 Oct 2022 16:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date;
        bh=xQFel9naC92r6XO2zeGG43gUPLFb+3A7sfy4YtREbYY=;
        b=P84qes6JLjGgW9fen2ZncG5INJyjkTB9wSozgeYE762fVrrguJR3wvyM4bJ6z2+6Xs
         0MAEHyqWJLe6nTU/7lC993SoGSHpWlTFWiqgqIAd0trEiMrMG12IxuW90pMyIxP5beKD
         HhB9MkOvJK3jZRT4BWlfllAS2+QDheXJEOJ9+eE9tnSuas5waZdUT5snsl9ZC1MJwLuI
         Na4y7kDolc/Gseml7OsTW54uXa7RiRsPGryrjBPod5HD39mQIFcIqxtd4pRlSrWz5XBI
         hju9pqR54QnZ3+KPuMedesM2JkkvTD8sDlMEiPYFP1VbJ2QC7SqzMzZho72ynkKCZVuP
         GtQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=xQFel9naC92r6XO2zeGG43gUPLFb+3A7sfy4YtREbYY=;
        b=GyToJne3rBZctkd+Zqbil770eTjuA5WbKABIwNP1k52+60Cy3r5BlaBmMbj23hUow+
         aqoIRKczwh7T/6XyhqnigQwoKCRQKMuw+Edy3tkSyS9eIypJn/NdDzU3Ho2rTytdi18W
         TIPTwKYedGfd7P3J3Jwq40NKYoiVQyK2U/2YCsD6T56E7O2E2oyMOWQuSfAtSTPFHZdX
         HY38MoFgg5VYRQ5Yl9M95GDD1H8wwbqZIgHYetcwKpjI9CuNxctQQNF2/W4ooqPwiZ88
         al6rvVYQ09MrBFLv71PathXaet8kg2PWjS4W7d9IKAiRTc6SRP8jg07H2fimfnF1K8dM
         eq4Q==
X-Gm-Message-State: ACrzQf3ZVDZ3y+4AY+iSfvD5m50BZuLAb1hb7ypSgYHg6Wvazd+71GzG
        opGDd5sRXL0gAwNcVmMRvbTHExf1pMz/JQ==
X-Google-Smtp-Source: AMsMyM6x2JR6kdJXvW2jmtgoWs4NslED6Hqcs//TAUsQmo/ZLZa1hqiP4guPiKDz86cKZ/Q8wKtOCA==
X-Received: by 2002:a17:90b:4c09:b0:203:1b6d:2135 with SMTP id na9-20020a17090b4c0900b002031b6d2135mr9048377pjb.42.1664751243154;
        Sun, 02 Oct 2022 15:54:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y83-20020a626456000000b005386b58c8a3sm3481310pfb.100.2022.10.02.15.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 15:54:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 2 Oct 2022 15:54:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, liuhangbin@gmail.com, mkl@pengutronix.de
Subject: Re: [PATCH net-next] eth: octeon: fix build after netif_napi_add()
 changes
Message-ID: <20221002225401.GA1000012@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 02, 2022 at 10:56:50AM -0700, Jakub Kicinski wrote:
> Guenter reports I missed a netif_napi_add() call
> in one of the platform-specific drivers:
> 
> drivers/net/ethernet/cavium/octeon/octeon_mgmt.c: In function 'octeon_mgmt_probe':
> drivers/net/ethernet/cavium/octeon/octeon_mgmt.c:1399:9: error: too many arguments to function 'netif_napi_add'
>  1399 |         netif_napi_add(netdev, &p->napi, octeon_mgmt_napi_poll,
>       |         ^~~~~~~~~~~~~~
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Fixes: b48b89f9c189 ("net: drop the weight argument from netif_napi_add")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Tested-by: Guenter Roeck <linux@roeck-us.net>

> ---
> CC: liuhangbin@gmail.com
> CC: mkl@pengutronix.de
> ---
>  drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
> index 369bfd376d6f..edde0b8fa49c 100644
> --- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
> +++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
> @@ -1396,8 +1396,8 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, netdev);
>  	p = netdev_priv(netdev);
> -	netif_napi_add(netdev, &p->napi, octeon_mgmt_napi_poll,
> -		       OCTEON_MGMT_NAPI_WEIGHT);
> +	netif_napi_add_weight(netdev, &p->napi, octeon_mgmt_napi_poll,
> +			      OCTEON_MGMT_NAPI_WEIGHT);
>  
>  	p->netdev = netdev;
>  	p->dev = &pdev->dev;
> -- 
> 2.37.3
> 

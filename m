Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27F8608065
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 22:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiJUUzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 16:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiJUUzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 16:55:15 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C89836FC;
        Fri, 21 Oct 2022 13:55:10 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e18so10318194edj.3;
        Fri, 21 Oct 2022 13:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MgNLT44Fi7WL4VBnJfXfs2StY3uKraQEThQA3rU8sVM=;
        b=ClFfSj4Hf3Hfg+xt0BrrTxzkN5I65/D5ejg3LNE/dprh+ihPUbF231N1JmFYvYTZUw
         SFAqB5K6CujUp8FMJ9EWKzFitJE2+ops1i+G4DsBL/6AxKS4P2DrXq4g2IfzLQUnjtzp
         jfMI/YocVzeM6V+ryJ/pEL1VFYlzhp86/oVWQsMspQIYzIfR/i/dpnLL0RQb+kvVUSLe
         4BQh86VpfXamVmyDTRB6Hiy8cJkd6kCbrTf1BOczFeTzryoQw2xLrq9fTF4tmZ/u9YUX
         mugWTW5i/xBeZAYtpasw7307LoDWDDA6wstJ3nQ/kfbTNUns4uO3/RVRYaRJSPwYRv8t
         HGTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MgNLT44Fi7WL4VBnJfXfs2StY3uKraQEThQA3rU8sVM=;
        b=ghzaKUyVigw4ls8WMVzTPnqNrS3amctLoJ87N3uWffpHX5lEH5/2reykosP0GYuErt
         E/saB3ghsreS/zlUbuIfn5Ivj67F2jkFKTQlf+wkwknJM+k6Q6keU0kG1kVOCoTYLzk2
         /cCi7+QafPQURI7S5gw0zE+YAEoQ2Ly7GsQHAd0l2ugTdBZpieCPqXjPeoDB/0NimuNq
         ahYr08TVB0p8dtK2vTZZui8xxXNIkvJ3a8Smxg+A+oOQerEpbiWVRr/OVSGexnqQ/1FW
         Cyeij2Xzz7vL+7lZXdvGbcjyrmdoMdDe1u1L1+zO3OnWblp6Z1wy+JqWQ79uyNU1Di5w
         JcJQ==
X-Gm-Message-State: ACrzQf0dW+sQmcmC3vc3PYM+qwGuaXfnsThLyG2iOWJ1htySJMZNDf4e
        o5S5V2QMO4nYMkC2f/H4VPA=
X-Google-Smtp-Source: AMsMyM4UYHObmdaLYfMZl+HLERw4uBb20nSBcQLdFuJwKAUd+fdZ6u2Za2RUDdEGdMhDG2O1+3/beQ==
X-Received: by 2002:a05:6402:28cd:b0:459:19c3:43d0 with SMTP id ef13-20020a05640228cd00b0045919c343d0mr19053600edb.197.1666385709053;
        Fri, 21 Oct 2022 13:55:09 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b40:ea00:b919:c359:7abe:713e? (dynamic-2a01-0c22-7b40-ea00-b919-c359-7abe-713e.c22.pool.telefonica.de. [2a01:c22:7b40:ea00:b919:c359:7abe:713e])
        by smtp.googlemail.com with ESMTPSA id q1-20020a170906360100b00773c60c2129sm12264706ejb.141.2022.10.21.13.55.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 13:55:08 -0700 (PDT)
Message-ID: <2333ef88-6e3e-a5ad-dcdc-89a405ba2f9e@gmail.com>
Date:   Fri, 21 Oct 2022 22:55:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221021174552.6828-1-hayashi.kunihiko@socionext.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] net: ethernet: ave: Remove duplicate suspend/resume
 calls for phy
In-Reply-To: <20221021174552.6828-1-hayashi.kunihiko@socionext.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.10.2022 19:45, Kunihiko Hayashi wrote:
> Since AVE has its own suspend/resume functions, there is no need to call
> mdio_bus suspend/resume functions. Set phydev->mac_managed_pm to true
> to avoid the calls.
> 
The commit description doesn't make clear (any longer) what the issue
is that you're fixing. You should mention the WARN_ON() dump here
like in your first attempt.

> In addition, ave_open() executes __phy_resume() via phy_start() in
> ave_resume(), so no need to call phy_resume() explicitly. Remove it.
> 
This sounds like an improvement, being independent of the actual fix.
The preferred approach would be:
- submit the fix to net
- submit the improvement in a separate patch to net-next

> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Fixes: 0ba78b4a4989 ("net: ethernet: ave: Add suspend/resume support")
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> ---
>  drivers/net/ethernet/socionext/sni_ave.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
> index 14cdd2e8373c..b4e0c57af7c3 100644
> --- a/drivers/net/ethernet/socionext/sni_ave.c
> +++ b/drivers/net/ethernet/socionext/sni_ave.c
> @@ -1271,6 +1271,8 @@ static int ave_init(struct net_device *ndev)
>  
>  	phy_support_asym_pause(phydev);
>  
> +	phydev->mac_managed_pm = true;
> +
>  	phy_attached_info(phydev);
>  
>  	return 0;
> @@ -1806,12 +1808,6 @@ static int ave_resume(struct device *dev)
>  	wol.wolopts = priv->wolopts;
>  	__ave_ethtool_set_wol(ndev, &wol);
>  
> -	if (ndev->phydev) {
> -		ret = phy_resume(ndev->phydev);
> -		if (ret)
> -			return ret;
> -	}
> -
>  	if (netif_running(ndev)) {
>  		ret = ave_open(ndev);
>  		netif_device_attach(ndev);


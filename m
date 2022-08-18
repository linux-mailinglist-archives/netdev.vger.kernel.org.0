Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2CA59855D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245234AbiHROKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245244AbiHROKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:10:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD2A7C507
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 07:10:10 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id a22so2038096edj.5
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 07:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=T5Yjth+cBserTEd1KAgfppe4sKdMSSzSyoSk+LuIvNk=;
        b=I0CZUQgDLav1zga1mFS4taYmt0g7lywt5VkqrNIYAQXnfGmH+x/9IKC6Gs+76HAfy+
         1kYWm8C+CA5XKpIi01oUXDcIFQrxh5a1eJaI+o4zwO/6X5/a0fms8r65uslAGDIGlE+b
         4xzeh3LdnHvuKurw0DSXVL6phsp82ytElgVUfWZyvNS2WMTjRbCCTSKHcVmip5ocjv4Q
         rSly9BVuGKw2E2cenAIhwgh56cH/qMkNQOfKGY4y6n3XCBEjGOZSkau5W6EOjtlECPCk
         pRScuc4oDXNNjHWKl2FBYaK3kZInLfcBtpaVoDKQ9csd5YM7j/pKly8HNoEYtD/Fbw0k
         r+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=T5Yjth+cBserTEd1KAgfppe4sKdMSSzSyoSk+LuIvNk=;
        b=xGEvdsQe3U9t0TiHPywhDXvIdx6qEvTIqa/oWItktha0WY16O2rnMkdEPSbhiYBwMs
         G/XEbjqKij+zwNciWgOhTvN15NQSW+0b+qQptStatdgFSkyU9kM3qkKQh55vWrg93pWK
         6r+IDlMh0uAVOKpUTiFHcMZpmrLVg4HN1orJNpNUnNOiBwATvvZ3PpEKoEyNfCKsAerz
         E6z5I3qnofpSQrV7uSuJ/17npp3XCp7H/DjaRr+N9of69LhamC2TUoCpo+nPQrWMD/sF
         LJGqr5+JLlEos1LrE6ko0qNqqdLPgR6JBDcMFR85Y9UYUdJanqIsD0YbhO1h7t/lJoDL
         fNAg==
X-Gm-Message-State: ACgBeo2lyUdxrva4x/GGD31jDhF95sig0cEfxC/2rUy0nTXbl9zoLH84
        zjShwcihFOV1oYyTOvuCRr8=
X-Google-Smtp-Source: AA6agR7cgBH6QwMPuE5G7PqhP+pna5sUL0fetNLYg7qlEcyAwBGd7fmuQPJvKtFcBcaD0Hys5hJ5tQ==
X-Received: by 2002:a05:6402:d06:b0:440:3e9d:77d with SMTP id eb6-20020a0564020d0600b004403e9d077dmr2354100edb.286.1660831808806;
        Thu, 18 Aug 2022 07:10:08 -0700 (PDT)
Received: from skbuf ([188.25.231.137])
        by smtp.gmail.com with ESMTPSA id e1-20020a17090618e100b0072ed9efc9dfsm876311ejf.48.2022.08.18.07.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:10:07 -0700 (PDT)
Date:   Thu, 18 Aug 2022 17:10:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Guobin Huang <huangguobin4@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v2] net: moxa: MAC address reading, generating, validity
 checking
Message-ID: <20220818141005.3xz2ksjfsf4spzmj@skbuf>
References: <20220818092317.529557-1-saproj@gmail.com>
 <20220818092317.529557-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818092317.529557-1-saproj@gmail.com>
 <20220818092317.529557-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:23:17PM +0300, Sergei Antonov wrote:
> This device does not remember its MAC address, so add a possibility
> to get it from the platform. If it fails, generate a random address.
> This will provide a MAC address early during boot without user space
> being involved.
> 
> Also remove extra calls to is_valid_ether_addr().
> 
> Made after suggestions by Andrew Lunn:
> 1) Use eth_hw_addr_random() to assign a random MAC address during probe.
> 2) Remove is_valid_ether_addr() from moxart_mac_open()
> 3) Add a call to platform_get_ethdev_address() during probe
> 4) Remove is_valid_ether_addr() from moxart_set_mac_address(). The core does this
> 
> v1 -> v2:
> Handle EPROBE_DEFER returned from platform_get_ethdev_address().
> Move MAC reading code to the beginning of the probe function.
> 
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> CC: Jakub Kicinski <kuba@kernel.org>
> CC: Vladimir Oltean <olteanv@gmail.com>
> CC: Yang Yingliang <yangyingliang@huawei.com>
> CC: Pavel Skripkin <paskripkin@gmail.com>
> CC: Guobin Huang <huangguobin4@huawei.com>
> CC: Yang Wei <yang.wei9@zte.com.cn>
> CC: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/moxa/moxart_ether.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
> index f11f1cb92025..402fea7505e6 100644
> --- a/drivers/net/ethernet/moxa/moxart_ether.c
> +++ b/drivers/net/ethernet/moxa/moxart_ether.c
> @@ -62,9 +62,6 @@ static int moxart_set_mac_address(struct net_device *ndev, void *addr)
>  {
>  	struct sockaddr *address = addr;
>  
> -	if (!is_valid_ether_addr(address->sa_data))
> -		return -EADDRNOTAVAIL;
> -
>  	eth_hw_addr_set(ndev, address->sa_data);
>  	moxart_update_mac_address(ndev);
>  
> @@ -172,9 +169,6 @@ static int moxart_mac_open(struct net_device *ndev)
>  {
>  	struct moxart_mac_priv_t *priv = netdev_priv(ndev);
>  
> -	if (!is_valid_ether_addr(ndev->dev_addr))
> -		return -EADDRNOTAVAIL;
> -
>  	napi_enable(&priv->napi);
>  
>  	moxart_mac_reset(ndev);
> @@ -488,6 +482,14 @@ static int moxart_mac_probe(struct platform_device *pdev)
>  	}
>  	ndev->base_addr = res->start;
>  
> +	// MAC address
> +	ret = platform_get_ethdev_address(p_dev, ndev);
> +	if (ret == -EPROBE_DEFER) // EEPROM has not probed yet?
> +		goto init_fail;

The comments are not very useful, and the kernel coding style is to use
the C-style comments /* */ rather than the C++ style //.
Anyway this is a minor remark, I don't think you have to resend for this.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> +	if (ret)
> +		eth_hw_addr_random(ndev);
> +	moxart_update_mac_address(ndev);
> +
>  	spin_lock_init(&priv->txlock);
>  
>  	priv->tx_buf_size = TX_BUF_SIZE;
> -- 
> 2.32.0
> 


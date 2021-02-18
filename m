Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8943B31E4DA
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 05:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBRED1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 23:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhBREDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 23:03:20 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F58C061574;
        Wed, 17 Feb 2021 20:02:40 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 189so393385pfy.6;
        Wed, 17 Feb 2021 20:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=echKm0vQnXRQ9N6KP/puA2VMUggBJORu/hUHHIxOcss=;
        b=n3I8DINZk/PzQxUBcMSXfCh8n94o5gB7JRHUAEu/3B9UkSTgcQjUdzRtzsvnVAOlux
         Ptr0k3guQTQXzhevjg8G8HRSKN1XXft9x7EO7wn0c3KH15mQyqHUvGF07vrkzfg0XieX
         qctvPFiRzHv+/js0/n6jARobT9yH6XoiCC0+rKlmqvqWp5Yj5F/0LOGyJFH65uRBzoPb
         Re9bPMOw0VkSMz+LnrzLEj1RshYh2jeik3bmRPB2MqBghpBXnLgKktbo37KScLDvT2C5
         lhvlruAzOIcYCgsrJbq3PJS+da3J+ewFWY4KulFEQcTWhtjGxf0rnfOS2tFVkQQWgmxl
         H5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=echKm0vQnXRQ9N6KP/puA2VMUggBJORu/hUHHIxOcss=;
        b=g2xc+henQB7ZPhFa7juOC9gZd3e0H1a18dBLZ4Lrx1m8Y5pnLM+Najm8IsUyEohjDf
         EkBK9gsed+pVUdP4agseu44b1esLLTzep05Pri9OlSnFX+s4DjJY0DtseO4DCS2MabRv
         gt81/7ivwtaQ8dOHMv2J8NMsmw2HaDhsSNeVnj3M/z63pbT+vJ5mwknAEnZqlZYHgGtV
         +hiTI6tXA90N1ZVw4hg9r0LXMEzPUq+Ov/+rg+xohDo7+Xclbu/YV5qqleyE/xlXe67O
         c1wWOY6+3rR3I4bGaJoVqcWywO9nPEdmRLkvWVVeCaP3xv9YgonE7hOGU0i6hh5CjE89
         u1Lw==
X-Gm-Message-State: AOAM533oVMwk+8iEC2PEaXwumVcwbSL3g9Nk6jM+vN1uo2cH9VaQMlMn
        bOMB5W9iEch+xldxJvaI71WuYXD1Vss=
X-Google-Smtp-Source: ABdhPJzhfjdGxgpav6wX41tSYQQmkVX10yaJnhJcFdeF56NRAFcmBnhWmW14nZbSS+9brI9d7G0USw==
X-Received: by 2002:a05:6a00:1385:b029:1be:ac19:3a9d with SMTP id t5-20020a056a001385b02901beac193a9dmr2411835pfg.65.1613620958187;
        Wed, 17 Feb 2021 20:02:38 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id jx20sm777682pjb.30.2021.02.17.20.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 20:02:37 -0800 (PST)
Subject: Re: [PATCH] net: ftgmac100: Support phyless operation
To:     "William A. Kennington III" <wak@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joel Stanley <joel@jms.id.au>
References: <20210218034040.296869-1-wak@google.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bcafa57a-c849-0115-311d-e8859db93b87@gmail.com>
Date:   Wed, 17 Feb 2021 20:02:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210218034040.296869-1-wak@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/17/2021 7:40 PM, William A. Kennington III wrote:
> We have BMC to BMC connections that lack a PHY in between but don't
> want to use the NC-SI state machinery of the kernel. Instead,
> allow for an option to disable the phy detection and mdio logic.
> 
> Signed-off-by: William A. Kennington III <wak@google.com>

The way drivers deal with MAC to MAC connection is to use a fixed-link
Device Tree node that just presents hard coded link parameters. This
provides an emulation for the PHY library as well as user-space and
requires little Ethernet MAC driver changes other than doing something
along these lines:

          /* Fetch the PHY phandle */
          priv->phy_dn = of_parse_phandle(dn, "phy-handle", 0);

          /* In the case of a fixed PHY, the DT node associated
           * to the PHY is the Ethernet MAC DT node.
           */
          if (!priv->phy_dn && of_phy_is_fixed_link(dn)) {
                  ret = of_phy_register_fixed_link(dn);
                  if (ret)
                          return ret;

                  priv->phy_dn = of_node_get(dn);
          }

Can this work for you here?

> ---
>  .../devicetree/bindings/net/ftgmac100.txt     |  2 ++
>  drivers/net/ethernet/faraday/ftgmac100.c      | 30 +++++++++++--------
>  2 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/ftgmac100.txt b/Documentation/devicetree/bindings/net/ftgmac100.txt
> index 29234021f601..22c729c5fd3e 100644
> --- a/Documentation/devicetree/bindings/net/ftgmac100.txt
> +++ b/Documentation/devicetree/bindings/net/ftgmac100.txt
> @@ -19,6 +19,8 @@ Optional properties:
>  - phy-mode: See ethernet.txt file in the same directory. If the property is
>    absent, "rgmii" is assumed. Supported values are "rgmii*" and "rmii" for
>    aspeed parts. Other (unknown) parts will accept any value.
> +- no-phy: Disable any MDIO or PHY connection logic and assume the interface
> +  is always up.
>  - use-ncsi: Use the NC-SI stack instead of an MDIO PHY. Currently assumes
>    rmii (100bT) but kept as a separate property in case NC-SI grows support
>    for a gigabit link.
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 88bfe2107938..f2cf190654c8 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1467,18 +1467,18 @@ static int ftgmac100_open(struct net_device *netdev)
>  		return err;
>  	}
>  
> -	/* When using NC-SI we force the speed to 100Mbit/s full duplex,
> +	/* When PHYless we force the speed to 100Mbit/s full duplex,
>  	 *
>  	 * Otherwise we leave it set to 0 (no link), the link
>  	 * message from the PHY layer will handle setting it up to
>  	 * something else if needed.
>  	 */
> -	if (priv->use_ncsi) {
> -		priv->cur_duplex = DUPLEX_FULL;
> -		priv->cur_speed = SPEED_100;
> -	} else {
> +	if (netdev->phydev) {
>  		priv->cur_duplex = 0;
>  		priv->cur_speed = 0;
> +	} else {
> +		priv->cur_duplex = DUPLEX_FULL;
> +		priv->cur_speed = SPEED_100;
>  	}
>  
>  	/* Reset the hardware */
> @@ -1506,14 +1506,16 @@ static int ftgmac100_open(struct net_device *netdev)
>  	if (netdev->phydev) {
>  		/* If we have a PHY, start polling */
>  		phy_start(netdev->phydev);
> -	} else if (priv->use_ncsi) {
> -		/* If using NC-SI, set our carrier on and start the stack */
> +	} else {
> +		/* If PHYless, set our carrier on and start the stack */
>  		netif_carrier_on(netdev);
>  
> -		/* Start the NCSI device */
> -		err = ncsi_start_dev(priv->ndev);
> -		if (err)
> -			goto err_ncsi;
> +		if (priv->use_ncsi) {
> +			/* Start the NCSI device */
> +			err = ncsi_start_dev(priv->ndev);
> +			if (err)
> +				goto err_ncsi;
> +		}
>  	}
>  
>  	return 0;
> @@ -1725,8 +1727,8 @@ static int ftgmac100_setup_clk(struct ftgmac100 *priv)
>  	 * 1000Mbit link speeds. As NCSI is limited to 100Mbit, 25MHz
>  	 * is sufficient
>  	 */
> -	rc = clk_set_rate(priv->clk, priv->use_ncsi ? FTGMAC_25MHZ :
> -			  FTGMAC_100MHZ);
> +	rc = clk_set_rate(priv->clk, priv->netdev->phydev ? FTGMAC_100MHZ :
> +			  FTGMAC_25MHZ);
>  	if (rc)
>  		goto cleanup_clk;
>  
> @@ -1837,6 +1839,8 @@ static int ftgmac100_probe(struct platform_device *pdev)
>  		priv->ndev = ncsi_register_dev(netdev, ftgmac100_ncsi_handler);
>  		if (!priv->ndev)
>  			goto err_phy_connect;
> +	} else if (np && of_get_property(np, "no-phy", NULL)) {
> +		dev_info(&pdev->dev, "Using PHYless interface\n");
>  	} else if (np && of_get_property(np, "phy-handle", NULL)) {
>  		struct phy_device *phy;
>  
> 

-- 
Florian

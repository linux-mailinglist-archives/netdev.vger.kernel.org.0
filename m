Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D01654ABBA
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 10:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240449AbiFNIYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 04:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238388AbiFNIYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 04:24:34 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C685E3B3CB;
        Tue, 14 Jun 2022 01:24:32 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id m20so15637383ejj.10;
        Tue, 14 Jun 2022 01:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WXuGdpJ/ktmaAuLDQEnwufoxcn7RuD1hCg1Czf+mf9c=;
        b=Q1dIx3t6+ALKXuTCDMOu3B1LE7YS0qfxzmYkyVhCyMJSD5agmRuGa3F6IA5+D8kbIb
         NF/yNb3t6vtCRBlk/+sNqAt1oQU8OxmIyo1jWcBlQK6qP4bBMGKxjQaHcoro8nIyCY/3
         BYGg64XM0/L8m9YReEn9Oe7+Ty/s6NSzPFusQRZ4KtT1bNzMxec66eDChdebImZHTsk4
         rZ+ZwLhCrU2B47oVDG1CCioW/9b23hMvyYa7dJTv2Wtlz2ouzZQ+F1TfM6FFKGhNu71w
         n8dFH48GrauRLsRz3S48qh29JBl802R0dlW2yT6Z2GV/fFPjqGteQ20wzPReQm8KQ9PH
         fzlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WXuGdpJ/ktmaAuLDQEnwufoxcn7RuD1hCg1Czf+mf9c=;
        b=TC5JfEZp5Ibn4i5KRewRJSi/ywflJxvrve+qnLqP6beVxQwNQXP8X6aMcCaLxgNQOp
         kWjBcyE3x3CmR8jS+PNLNYwmRXJTkjGW7a50g5JbQy1+SmbKBiiVfGPMJgxvUlgEcctl
         FY1e3qeIt2mslzW3al4j36wEAoM+sOwR0KsYEduF+Lq747SZ8P599iDU0LndPLwtEQsi
         Y+KGVhKTtJDnGhDZn5YXbx6RRWeBk/p3R7Y3dzPS/A8EwwMzwAhWIBkZ0eLas7+Ejy8u
         HkAORZgWBQFRxeOFnpVRPbaKmzOCm1bU4B3vGlnvqGmxfwOtR3IEyTEkfGPNs69F0Vor
         ZdBg==
X-Gm-Message-State: AOAM533g4pZtCEqindW59KT0W4aIGZhvBbXB1v/8Nxtq6AX49tpJTxAO
        GoE3pP53tgkLg1sJJvcqsmQ=
X-Google-Smtp-Source: AGRyM1vFzrQHZt3O6I810GAZD5IhC0Lv8+ZAInN4GGwMthsn+110tSCZARoxIfqMGs13PHuTX3fbdw==
X-Received: by 2002:a17:906:b15:b0:715:bf2e:df92 with SMTP id u21-20020a1709060b1500b00715bf2edf92mr3135889ejg.576.1655195071176;
        Tue, 14 Jun 2022 01:24:31 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id x90-20020a50bae3000000b0042ab87ea713sm6642368ede.22.2022.06.14.01.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 01:24:30 -0700 (PDT)
Date:   Tue, 14 Jun 2022 11:24:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC Patch net-next v2 12/15] net: dsa: microchip: ksz9477:
 separate phylink mode from switch register
Message-ID: <20220614082429.x2ger7aysr4j4zbo@skbuf>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-13-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530104257.21485-13-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 04:12:54PM +0530, Arun Ramadoss wrote:
> As per 'commit 3506b2f42dff ("net: dsa: microchip: call
> phy_remove_link_mode during probe")' phy_remove_link_mode is added in
> the switch_register function after dsa_switch_register. In order to have
> the common switch register function, moving this phy init after
> dsa_register_switch using the new ksz_dev_ops.dsa_init hook.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz9477.c    | 49 ++++++++++++++------------
>  drivers/net/dsa/microchip/ksz_common.c |  5 ++-
>  drivers/net/dsa/microchip/ksz_common.h |  1 +
>  3 files changed, 31 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index ecce99b77ef6..c87ce0e2afd8 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -1349,6 +1349,30 @@ static void ksz9477_switch_exit(struct ksz_device *dev)
>  	ksz9477_reset_switch(dev);
>  }
>  
> +static int ksz9477_dsa_init(struct ksz_device *dev)
> +{
> +	struct phy_device *phydev;
> +	int i;
> +
> +	for (i = 0; i < dev->phy_port_cnt; ++i) {
> +		if (!dsa_is_user_port(dev->ds, i))
> +			continue;

I understand this is just code movement, but this is more efficient:

	struct dsa_switch *ds = dev->ds;
	struct dsa_port *dp;

	dsa_switch_for_each_user_port(dp, ds) {
		...
	}

> +
> +		phydev = dsa_to_port(dev->ds, i)->slave->phydev;
> +
> +		/* The MAC actually cannot run in 1000 half-duplex mode. */
> +		phy_remove_link_mode(phydev,
> +				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> +
> +		/* PHY does not support gigabit. */
> +		if (!(dev->features & GBIT_SUPPORT))
> +			phy_remove_link_mode(phydev,
> +					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
> +	}

I wonder why the driver did not just remove these from the supported
mask in the phylink validation procedure in the first place?
Adding these link mode fixups to a dev_ops callback named "dsa_init"
does not sound quite right.

> +
> +	return 0;
> +}
> +
>  static const struct ksz_dev_ops ksz9477_dev_ops = {
>  	.setup = ksz9477_setup,
>  	.get_port_addr = ksz9477_get_port_addr,
> @@ -1377,35 +1401,14 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
>  	.change_mtu = ksz9477_change_mtu,
>  	.max_mtu = ksz9477_max_mtu,
>  	.shutdown = ksz9477_reset_switch,
> +	.dsa_init = ksz9477_dsa_init,
>  	.init = ksz9477_switch_init,
>  	.exit = ksz9477_switch_exit,
>  };
>  
>  int ksz9477_switch_register(struct ksz_device *dev)
>  {
> -	int ret, i;
> -	struct phy_device *phydev;
> -
> -	ret = ksz_switch_register(dev, &ksz9477_dev_ops);
> -	if (ret)
> -		return ret;
> -
> -	for (i = 0; i < dev->phy_port_cnt; ++i) {
> -		if (!dsa_is_user_port(dev->ds, i))
> -			continue;
> -
> -		phydev = dsa_to_port(dev->ds, i)->slave->phydev;
> -
> -		/* The MAC actually cannot run in 1000 half-duplex mode. */
> -		phy_remove_link_mode(phydev,
> -				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> -
> -		/* PHY does not support gigabit. */
> -		if (!(dev->features & GBIT_SUPPORT))
> -			phy_remove_link_mode(phydev,
> -					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
> -	}
> -	return ret;
> +	return ksz_switch_register(dev, &ksz9477_dev_ops);
>  }
>  EXPORT_SYMBOL(ksz9477_switch_register);
>  
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index ace5cf0ad5a8..f40d64858d35 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -1253,7 +1253,10 @@ int ksz_switch_register(struct ksz_device *dev,
>  	/* Start the MIB timer. */
>  	schedule_delayed_work(&dev->mib_read, 0);
>  
> -	return 0;
> +	if (dev->dev_ops->dsa_init)
> +		ret = dev->dev_ops->dsa_init(dev);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(ksz_switch_register);
>  
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 872d378ac45c..23962f47df46 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -213,6 +213,7 @@ struct ksz_dev_ops {
>  	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
>  	void (*port_init_cnt)(struct ksz_device *dev, int port);
>  	int (*shutdown)(struct ksz_device *dev);
> +	int (*dsa_init)(struct ksz_device *dev);
>  	int (*init)(struct ksz_device *dev);
>  	void (*exit)(struct ksz_device *dev);
>  };
> -- 
> 2.36.1
> 


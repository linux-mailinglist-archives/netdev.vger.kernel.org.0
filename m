Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B202F1491
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732450AbhAKN0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729937AbhAKN0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 08:26:51 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AF9C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 05:26:11 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c133so13819417wme.4
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 05:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rfL6iBIIP1AJVvDRLnNKpGzLYt6fcJsAF9dgT3lotag=;
        b=oRL8pAT9C0nTstWZSG6IvQsuwDEbzvNP+4hVtz0JApzmavcViMJ1xSN3jtSLXfrYed
         I/oprriA0JfY/GrwEaHl3OQmGVZVjj5BQr9TGGKcM/kidfy0pX8CltY0JZ6yOqi2o5xL
         PCHXwfjSh0Oo8sPOAkI/Z5EDOC75f23mYSxil1Sh7nHTTZMsURkOLS50xKA3SDg0W7vb
         AZxWS5a3RPGeZvPYq/FDOkjNGO/ndhJhwU8kbfUWNkEUPxq+32z73f4+2tiNNJAcHPFS
         wc8Dm98jWpLTlp1LtLhBn+TovcZ9j82u0ijXD7a+FCwVO9ToQkhMamgWvTrELv+5fLvw
         o6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rfL6iBIIP1AJVvDRLnNKpGzLYt6fcJsAF9dgT3lotag=;
        b=SrzRw6qFuaE5dinGj83u8CCnKRl6wfXoAKD1Lh7efJ5L9Rsfcia8RM8a9v4+ZDBg9+
         vD7X5vtiohjuWdsEm8wfQB9H4pLv7w0K2JxY5vBxlUc3SqRP44YUgj6JX9Q9wBPeqOVL
         xIY/ersNswf/xjHw/D9Vtj/sSg+e1Zn6AyYGZBbn8K0UJZB6k4cNBMb/lU84S0HxTNBD
         nEpKOrpWpGxv0l7uNWIjAu4koCqCBneO9rmIrAF8Bd9Y3JbBzb+XYBLudT6MZhvU4WZG
         QoZXBwhzveGG9fKZU8cExeAb7Jpf3ghxkX8ndNKuYzY+DM5RvbGVM6WElyr+W29FV1Yo
         XW/g==
X-Gm-Message-State: AOAM530blDFQlwG3xFdIPCeCKS6Wfry620+kWHfGz38SGj2njZFOjtD7
        eaOVTxfCtfDQDjpjS6wNvFhR0YFt110=
X-Google-Smtp-Source: ABdhPJyn0ZfGvZ1B7E7PS6j+2/gK6S1mQ91GXPNe4qT1kkQ3RZdlcs2RgVIjoLQnLNA/Zu7RAqDPYA==
X-Received: by 2002:a7b:c24d:: with SMTP id b13mr14497933wmj.151.1610371569888;
        Mon, 11 Jan 2021 05:26:09 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:70c5:7cc:8644:5b6d? (p200300ea8f06550070c507cc86445b6d.dip0.t-ipconnect.de. [2003:ea:8f06:5500:70c5:7cc:8644:5b6d])
        by smtp.googlemail.com with ESMTPSA id b9sm24917751wmd.32.2021.01.11.05.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 05:26:09 -0800 (PST)
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Lukas Wunner <lukas@wunner.de>
References: <20210111125337.36513-1-marex@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: ks8851: Connect and start/stop the internal
 PHY
Message-ID: <a8eb8186-cde4-19ab-5b3c-e885e11106cf@gmail.com>
Date:   Mon, 11 Jan 2021 14:26:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111125337.36513-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.01.2021 13:53, Marek Vasut wrote:
> Unless the internal PHY is connected and started, the phylib will not
> poll the PHY for state and produce state updates. Connect the PHY and
> start/stop it.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Lukas Wunner <lukas@wunner.de>
> ---
>  drivers/net/ethernet/micrel/ks8851.h        |  2 ++
>  drivers/net/ethernet/micrel/ks8851_common.c | 28 +++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
> index e2eb0caeac82..ef13929036cf 100644
> --- a/drivers/net/ethernet/micrel/ks8851.h
> +++ b/drivers/net/ethernet/micrel/ks8851.h
> @@ -359,6 +359,7 @@ union ks8851_tx_hdr {
>   * @vdd_io: Optional digital power supply for IO
>   * @gpio: Optional reset_n gpio
>   * @mii_bus: Pointer to MII bus structure
> + * @phy_dev: Pointer to PHY device structure
>   * @lock: Bus access lock callback
>   * @unlock: Bus access unlock callback
>   * @rdreg16: 16bit register read callback
> @@ -405,6 +406,7 @@ struct ks8851_net {
>  	struct regulator	*vdd_io;
>  	int			gpio;
>  	struct mii_bus		*mii_bus;
> +	struct phy_device	*phy_dev;
>  
>  	void			(*lock)(struct ks8851_net *ks,
>  					unsigned long *flags);
> diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
> index 058fd99bd483..a3716fd2d858 100644
> --- a/drivers/net/ethernet/micrel/ks8851_common.c
> +++ b/drivers/net/ethernet/micrel/ks8851_common.c
> @@ -432,6 +432,11 @@ static void ks8851_flush_tx_work(struct ks8851_net *ks)
>  		ks->flush_tx_work(ks);
>  }
>  
> +static void ks8851_handle_link_change(struct net_device *net)
> +{
> +	phy_print_status(net->phydev);
> +}
> +
>  /**
>   * ks8851_net_open - open network device
>   * @dev: The network device being opened.
> @@ -445,11 +450,22 @@ static int ks8851_net_open(struct net_device *dev)
>  	unsigned long flags;
>  	int ret;
>  
> +	ret = phy_connect_direct(ks->netdev, ks->phy_dev,
> +				 &ks8851_handle_link_change,
> +				 PHY_INTERFACE_MODE_INTERNAL);
> +	if (ret) {
> +		netdev_err(dev, "failed to attach PHY\n");
> +		return ret;
> +	}
> +
> +	phy_attached_info(ks->phy_dev);
> +
>  	ret = request_threaded_irq(dev->irq, NULL, ks8851_irq,
>  				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
>  				   dev->name, ks);
>  	if (ret < 0) {
>  		netdev_err(dev, "failed to get irq\n");
> +		phy_disconnect(ks->phy_dev);
>  		return ret;
>  	}
>  
> @@ -507,6 +523,7 @@ static int ks8851_net_open(struct net_device *dev)
>  	netif_dbg(ks, ifup, ks->netdev, "network device up\n");
>  
>  	ks8851_unlock(ks, &flags);
> +	phy_start(ks->phy_dev);
>  	mii_check_link(&ks->mii);
>  	return 0;
>  }
> @@ -528,6 +545,9 @@ static int ks8851_net_stop(struct net_device *dev)
>  
>  	netif_stop_queue(dev);
>  
> +	phy_stop(ks->phy_dev);
> +	phy_disconnect(ks->phy_dev);
> +
>  	ks8851_lock(ks, &flags);
>  	/* turn off the IRQs and ack any outstanding */
>  	ks8851_wrreg16(ks, KS_IER, 0x0000);
> @@ -1084,6 +1104,7 @@ int ks8851_resume(struct device *dev)
>  
>  static int ks8851_register_mdiobus(struct ks8851_net *ks, struct device *dev)
>  {
> +	struct phy_device *phy_dev;
>  	struct mii_bus *mii_bus;
>  	int ret;
>  
> @@ -1103,10 +1124,17 @@ static int ks8851_register_mdiobus(struct ks8851_net *ks, struct device *dev)
>  	if (ret)
>  		goto err_mdiobus_register;
>  
> +	phy_dev = phy_find_first(mii_bus);
> +	if (!phy_dev)
> +		goto err_find_phy;
> +
>  	ks->mii_bus = mii_bus;
> +	ks->phy_dev = phy_dev;
>  
>  	return 0;
>  
> +err_find_phy:
> +	mdiobus_unregister(mii_bus);
>  err_mdiobus_register:
>  	mdiobus_free(mii_bus);
>  	return ret;
> 

LGTM. When having a brief look at the driver I stumbled across two things:

1. Do MAC/PHY support any pause mode? Then a call to
   phy_support_(a)sym_pause() would be missing.

2. Don't have the datasheet, but IRQ_LCI seems to be the link change
   interrupt. So far it's ignored by the driver. You could configure
   it and use phy_mac_interrupt() to operate the internal PHY in
   interrupt mode.

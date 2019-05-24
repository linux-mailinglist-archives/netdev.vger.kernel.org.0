Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E73229F61
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 21:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391360AbfEXTww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 15:52:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57018 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730068AbfEXTww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 15:52:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nF08utblDp367xLdzVkNFUF8Qc9njHe2z2nMTbc6/RU=; b=eftgIDDtaHOXs3g3twZzv/Zk0u
        YjmKjqDn6M/XhamkbG7rbY0anEZr6dTmrpW110kcPAVDC86tfnjgfuRrlnuf914C0rtywaMiJZFAt
        oY/9E3PEI2FHClq6jKOObaykdT4uEYtD81XqED//PjXlvJowcTulwtii1u3vhIOuK+A8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUGFF-0004Ec-0w; Fri, 24 May 2019 21:52:49 +0200
Date:   Fri, 24 May 2019 21:52:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>
Subject: Re: [PATCH 3/8] net: ehernet: ixp4xx: Use devm_alloc_etherdev()
Message-ID: <20190524195249.GO21208@lunn.ch>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
 <20190524162023.9115-4-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524162023.9115-4-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1481,8 +1478,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
>  	if ((err = register_netdev(ndev)))
>  		goto err_phy_dis;
>  
> -	printk(KERN_INFO "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
> -	       npe_name(port->npe));
> +	dev_info(dev, "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
> +		 npe_name(port->npe));

Hi Linus

If you get here, the interface has been registered. So you could use
netdev_info(ndev, ...). You can also call it before register_netdev,
but since the name as not yet been determined, it is not so
informative as dev_err() which will give you the bus address or
something.

	Andrew

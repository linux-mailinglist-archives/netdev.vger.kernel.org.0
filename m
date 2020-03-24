Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5AD1905F2
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 07:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgCXGwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 02:52:17 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:47855 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgCXGwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 02:52:17 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2020 02:52:16 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id EFE341005D064;
        Tue, 24 Mar 2020 07:46:38 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 8E2CF497F9; Tue, 24 Mar 2020 07:46:38 +0100 (CET)
Date:   Tue, 24 Mar 2020 07:46:38 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 01/14] net: ks8851: Factor out spi->dev in
 probe()/remove()
Message-ID: <20200324064638.szp3nfbccthfvqu6@wunner.de>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-2-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:50AM +0100, Marek Vasut wrote:
> -	gpio = of_get_named_gpio_flags(spi->dev.of_node, "reset-gpios",
> +	gpio = of_get_named_gpio_flags(dev->of_node, "reset-gpios",
>  				       0, NULL);
>  	if (gpio == -EPROBE_DEFER) {
>  		ret = gpio;

Nit: It would be nice to unwrap the line since it is shorter than
80 chars even with "0, NULL);" appended.


> @@ -1456,12 +1457,12 @@ static int ks8851_probe(struct spi_device *spi)
>  
>  	ret = regulator_enable(ks->vdd_io);
>  	if (ret) {
> -		dev_err(&spi->dev, "regulator vdd_io enable fail: %d\n",
> +		dev_err(dev, "regulator vdd_io enable fail: %d\n",
>  			ret);
>  		goto err_reg_io;
>  	}

Same here.


> @@ -1469,7 +1470,7 @@ static int ks8851_probe(struct spi_device *spi)
>  
>  	ret = regulator_enable(ks->vdd_reg);
>  	if (ret) {
> -		dev_err(&spi->dev, "regulator vdd enable fail: %d\n",
> +		dev_err(dev, "regulator vdd enable fail: %d\n",
>  			ret);
>  		goto err_reg;
>  	}

Same.

Thanks,

Lukas

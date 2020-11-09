Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1518C2AC571
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 20:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbgKITtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 14:49:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44072 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbgKITtn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 14:49:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcDAU-0068dg-Qx; Mon, 09 Nov 2020 20:49:34 +0100
Date:   Mon, 9 Nov 2020 20:49:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI
 mode flags
Message-ID: <20201109194934.GE1456319@lunn.ch>
References: <20201109193117.2017-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109193117.2017-1-TheSven73@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/phy/spi_ks8995.c
> @@ -491,7 +491,9 @@ static int ks8995_probe(struct spi_device *spi)
>  
>  	spi_set_drvdata(spi, ks);
>  
> -	spi->mode = SPI_MODE_0;
> +	/* use SPI_MODE_0 without changing any other mode flags */
> +	spi->mode &= ~(SPI_CPHA | SPI_CPOL);
> +	spi->mode |= SPI_MODE_0;
>  	spi->bits_per_word = 8;

Did you check to see if there is a help to set just the mode without
changing any of the other bits?

	 Andrew

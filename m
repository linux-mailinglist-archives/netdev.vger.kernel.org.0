Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E552AC6A6
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbgKIVJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:09:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgKIVJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 16:09:02 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DDC3206CB;
        Mon,  9 Nov 2020 21:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604956141;
        bh=Pv45jqhpj6D9l7uaZtADH1iQ5NeKsgfBsKyUxNTbCdM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Me0aH2dKk/4bCMtGXZanq7PtE72HwuKT5YkPJ9kWnasPBz/iJDnRO+YlvGr/19DNI
         9urR7G4y5C/p6yyo5kfMIrJpn3mjH3PvHr/5lS7Ya6tI15XPOjtQftRQe+OhmnnW31
         75ft5EBCFV9VIFPgSpJFrggrMtzIx+SDo7h9nuYA=
Date:   Mon, 9 Nov 2020 13:09:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI
 mode flags
Message-ID: <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109193117.2017-1-TheSven73@gmail.com>
References: <20201109193117.2017-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 14:31:17 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> This driver makes sure the underlying SPI bus is set to "mode 0"
> by assigning SPI_MODE_0 to spi->mode. This overwrites all other
> SPI mode flags.
> 
> In some circumstances, this can break the underlying SPI bus driver.
> For example, if SPI_CS_HIGH is set on the SPI bus, the driver
> will clear that flag, which results in a chip-select polarity issue.
> 
> Fix by changing only the SPI_MODE_N bits, i.e. SPI_CPHA and SPI_CPOL.
> 
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

This is a fix right? You seem to be targeting net-next and there is no
Fixes tag but it sounds like a bug.

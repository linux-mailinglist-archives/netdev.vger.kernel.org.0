Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34AB190373
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgCXBz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:55:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53302 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgCXBz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 21:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YSLX10TLalxC08fYPRSYFNteoOyTZpAwAi7YZ+C4kG8=; b=gkJNJsmkHhxZKGQWFrmCiutKKg
        PlpwaAJh7lLxX4jwQON16mIZyFN2toAQ+PMzQwm6fwLe+0OQ/+1PCjjiRM1e7bwLT2VZy0UCYSltP
        WyyTns+bjfoj4WTJ1UEAx+AEmo6gk78SSSPDLZsuejCtB1an0UUGdMCjCZtnWjZbWksY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGYms-0005id-5R; Tue, 24 Mar 2020 02:55:26 +0100
Date:   Tue, 24 Mar 2020 02:55:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 09/14] net: ks8851: Split out SPI specific entries in
 struct ks8851_net
Message-ID: <20200324015526.GP3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-10-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-10-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> + * struct ks8851_net_spi - KS8851 SPI driver private data
> + * @ks8851: KS8851 driver common private data
> + * @spidev: The spi device we're bound to.
> + * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
> + * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.
> + */
> +struct ks8851_net_spi {
> +	struct ks8851_net	ks8851;	/* Must be first */
> +	struct spi_device	*spidev;
> +	struct spi_message	spi_msg1;
> +	struct spi_message	spi_msg2;
> +	struct spi_transfer	spi_xfer1;
> +	struct spi_transfer	spi_xfer2[2];
> +};
> +
> +#define to_ks8851_spi(ks) container_of((ks), struct ks8851_net_spi, ks8851)

Since you are using container_of(), ks8851 does not need to be first.

      Andrew

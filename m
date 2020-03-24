Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2C2190D61
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgCXM1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:27:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727112AbgCXM1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 08:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BnWuafZlsgV90Vbh07U10Pb9Zl+lPp5dBlQCByTadNU=; b=y+Dw2zRWca5WsnupU0yG9ObajZ
        OUWZ2V7YrjtWrPFvUiCb3YDi6AFUZm3yI7FmJ1V7WVQZwDrkNQgkHihwJH2mu/7ll7FMCdQgI8+p6
        p/vpKIfjVoBKfXjpE1ifBU+JeOBvr1tA6I/3XeZlkVG4FNhd4PdeptZCwSx0K4jFzJNc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGiel-0001Wn-IV; Tue, 24 Mar 2020 13:27:43 +0100
Date:   Tue, 24 Mar 2020 13:27:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 09/14] net: ks8851: Split out SPI specific entries in
 struct ks8851_net
Message-ID: <20200324122743.GT3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-10-marex@denx.de>
 <20200324104919.djfirlzgwpjr52tk@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324104919.djfirlzgwpjr52tk@wunner.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 11:49:19AM +0100, Lukas Wunner wrote:
> On Tue, Mar 24, 2020 at 12:42:58AM +0100, Marek Vasut wrote:
> > +/**
> > + * struct ks8851_net_spi - KS8851 SPI driver private data
> > + * @ks8851: KS8851 driver common private data
> > + * @spidev: The spi device we're bound to.
> > + * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
> > + * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.
> 
> You need to remove these kerneldoc entries further up from struct ks8851_net.
> 
> 
> > +struct ks8851_net_spi {
> > +	struct ks8851_net	ks8851;	/* Must be first */
> > +	struct spi_device	*spidev;
> > +	struct spi_message	spi_msg1;
> > +	struct spi_message	spi_msg2;
> > +	struct spi_transfer	spi_xfer1;
> > +	struct spi_transfer	spi_xfer2[2];
> > +};
> > +
> > +#define to_ks8851_spi(ks) container_of((ks), struct ks8851_net_spi, ks8851)
> 
> Since it's always the first entry in the struct, a cast instead of
> container_of() would seem to be sufficient.

Hi Lukus

That is bad practice. container_of() will always get it correct,
making it safer.

       Andrew

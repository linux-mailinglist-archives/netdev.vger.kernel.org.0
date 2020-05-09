Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21901CC41C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 21:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgEITZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 15:25:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbgEITZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 15:25:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Czp6EvuSD6gwFQUCZ8nVgdkjgi6dIzphR2cz7XGMCVE=; b=qT14cHTmIeRoBjxc7xnf3iDQNA
        BNGOwr4or4MOJE23lFwsr7150k5OAKR8hz5R8AS2PXRC+diOI8hzWRWqHMWm2+wAAjbvodtEnkStK
        k1UNhf4ZiPIANyiw3CPqZcmM/xJIctwKV+OUaWF3z6CNz9R2RcrnoUxPD8qVGKMinK38=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXV6b-001XHl-NY; Sat, 09 May 2020 21:25:49 +0200
Date:   Sat, 9 May 2020 21:25:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de
Subject: Re: [PATCH v3 1/5] net: phy: Add support for microchip SMI0 MDIO bus
Message-ID: <20200509192549.GB338317@lunn.ch>
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
 <20200508154343.6074-2-m.grzeschik@pengutronix.de>
 <08858b46-95f0-24d0-0e11-1eaec292187c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08858b46-95f0-24d0-0e11-1eaec292187c@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > -		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
> > +		mdiobb_cmd(ctrl, ctrl->op_c22_write, phy, reg);
> 
> There are other users of the mdio-bitbang.c file which I believe you are
> going to break here because they will not initialize op_c22_write or
> op_c22_read, and thus they will be using 0, instead of MDIO_READ and
> MDIO_WRITE. I believe you need something like the patch attached.

Ah, totally missed that:

https://elixir.bootlin.com/linux/latest/source/arch/powerpc/platforms/82xx/ep8248e.c#L98
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/8390/ax88796.c#L444
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c#L103
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/renesas/ravb_main.c#L165
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/renesas/sh_eth.c#L1257

	Andrew

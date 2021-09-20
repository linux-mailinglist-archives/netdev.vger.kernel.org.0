Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52224411400
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbhITMMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:12:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49996 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhITMMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 08:12:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ynPuYJw34L7manFae3VE050hQpjFpbwhxqvbfLwY7L0=; b=FZiXvErhz6wL2EaMma7YyZQSC3
        p6+kdVyLCZeK0GSHrY9xr94uhueRxQvSvm1egCUVK5StQar3ptI8/M7Mprn58CAg7BuAVUehFXMIM
        vfEU1l1Qniq59ljCvcXnEQv8D1ADqNm1CYLrNguEYB550lbMUrL4Ic3wwuag4QsKTWIk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSI8X-007UdS-Ke; Mon, 20 Sep 2021 14:11:05 +0200
Date:   Mon, 20 Sep 2021 14:11:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, vladimir.oltean@nxp.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH net-next 05/12] reset: lan966x: Add switch reset
 driver
Message-ID: <YUh6WcEVBigG61y6@lunn.ch>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-6-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920095218.1108151-6-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:52:11AM +0200, Horatiu Vultur wrote:
> The lan966x switch SoC has a number of components that can be reset
> indiviually, but at least the switch core needs to be in a well defined
> state at power on, when any of the lan966x drivers starts to access the
> switch core, this reset driver is available.
> 
> The reset driver is loaded early via the postcore_initcall interface, and
> will then be available for the other lan966x drivers (SGPIO, SwitchDev etc)
> that are loaded next, and the first of them to be loaded can perform the
> one-time switch core reset that is needed.

A lot of this looks very similar to
reset-microchip-sparx5.c. PROTECT_REG is 0x88 rather than 0x84, but
actually using the value is the same. SOFT_RESET_REG is identical.  So
rather than adding a new driver, maybe you can generalize
reset-microchip-sparx5.c, and add a second compatible string?

	Andrew

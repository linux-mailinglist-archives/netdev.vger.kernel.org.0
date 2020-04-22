Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888711B4696
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgDVNs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:48:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgDVNs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 09:48:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7TRBksrRcniqfuhke/STkEOfL1Jd3Vi8JGTUQCRaXWA=; b=ZGoT0+iZqAlanJCCZY5iAAOe2q
        Pri5kdsXBVYVsMtE8dmeyYMdKRfrJEyJP+hiZnesrq6powNkRv7TrYRXLg3M57KnWriCjHX3Mjk0t
        eXzd2pOEvFAWcMoYw4a6/Wt2fT4ooxEyoa9v38YybrZi27jS/PzaRBKHOS0AjuVZz5k0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRFkC-004D8m-F2; Wed, 22 Apr 2020 15:48:52 +0200
Date:   Wed, 22 Apr 2020 15:48:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v5 4/4] net: phy: tja11xx: add delayed
 registration of TJA1102 PHY1
Message-ID: <20200422134852.GD974925@lunn.ch>
References: <20200422092456.24281-1-o.rempel@pengutronix.de>
 <20200422092456.24281-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422092456.24281-5-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 11:24:56AM +0200, Oleksij Rempel wrote:
> TJA1102 is a dual PHY package with PHY0 having proper PHYID and PHY1
> having no ID. On one hand it is possible to for PHY detection by
> compatible, on other hand we should be able to reset complete chip
> before PHY1 configured it, and we need to define dependencies for proper
> power management.
> 
> We can solve it by defining PHY1 as child of PHY0:
> 	tja1102_phy0: ethernet-phy@4 {
> 		reg = <0x4>;
> 
> 		interrupts-extended = <&gpio5 8 IRQ_TYPE_LEVEL_LOW>;
> 
> 		reset-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
> 		reset-assert-us = <20>;
> 		reset-deassert-us = <2000>;
> 
> 		tja1102_phy1: ethernet-phy@5 {
> 			reg = <0x5>;
> 
> 			interrupts-extended = <&gpio5 8 IRQ_TYPE_LEVEL_LOW>;
> 		};
> 	};
> 
> The PHY1 should be a subnode of PHY0 and registered only after PHY0 was
> completely reset and initialized.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

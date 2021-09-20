Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9329141141A
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237613AbhITMRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:17:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50022 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237583AbhITMRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 08:17:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WTbZe8VMbmEjY4wxdK+axHkoEChu9D4sUMPCOdYrijU=; b=yvxfjOEcwBbJ028xSMsUyrRtO5
        a9nK/eBdV1dm3xyhQLiyWuoul7qVeLM8QfrzrqL+z+vR7aTIBx6YZZ9s6dM63Njg2bcKD4lenVKzP
        igieyQf/2bxlwvg0qb5bElxxx8Nw+f965m2jklYs1Vvp8qdhOwPKDRtGNJi5bd59U8vg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSICw-007UfB-4c; Mon, 20 Sep 2021 14:15:38 +0200
Date:   Mon, 20 Sep 2021 14:15:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, vladimir.oltean@nxp.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH net-next 07/12] power: reset: Add lan966x power reset
 driver
Message-ID: <YUh7ammFjBHj3Kj8@lunn.ch>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-8-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920095218.1108151-8-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct lan966x_reset_context {
> +	struct regmap *gcb_ctrl;
> +	struct regmap *cpu_ctrl;
> +	struct notifier_block restart_handler;
> +};
> +
> +#define PROTECT_REG    0x88
> +#define PROTECT_BIT    BIT(5)
> +#define SOFT_RESET_REG 0x00
> +#define SOFT_RESET_BIT BIT(1)
> +
> +static int lan966x_restart_handle(struct notifier_block *this,
> +				  unsigned long mode, void *cmd)
> +{
> +	struct lan966x_reset_context *ctx = container_of(this, struct lan966x_reset_context,
> +							restart_handler);
> +
> +	/* Make sure the core is not protected from reset */
> +	regmap_update_bits(ctx->cpu_ctrl, PROTECT_REG, PROTECT_BIT, 0);

This all looks familiar...

Maybe yet another compatible added to reset-microchip-sparx5.c ?

      Andrew

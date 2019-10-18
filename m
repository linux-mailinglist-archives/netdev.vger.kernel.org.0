Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F85DCF2A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443217AbfJRTOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:14:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53232 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436517AbfJRTOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uOGFhvWAOHYOd3SMNOBvMaqJx6e/h1fD+87RpUGL3JA=; b=DqHXfO5K7qpUVaIl5ayJXP8tBm
        icn61OE8mn1aq4PX0ehbF76hEvR44IldjsJb8LhYbqOcI8VmxuskMupU91pZhDVnEV7BZ9tIa5C1q
        oNzSLnHLl7j+Sy9yEgQIxL4DQ96CcmnoU+WJjjxkdOswUbOHWi7SItxXE/jl+5ai8Udg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLXhc-0002rk-Qx; Fri, 18 Oct 2019 21:14:20 +0200
Date:   Fri, 18 Oct 2019 21:14:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, alexandre.belloni@bootlin.com,
        nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH net-next] net: macb: convert to phylink
Message-ID: <20191018191420.GI24810@lunn.ch>
References: <20191018143924.7375-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018143924.7375-1-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
> +	    (state->interface == PHY_INTERFACE_MODE_NA ||
> +	     state->interface == PHY_INTERFACE_MODE_GMII ||
> +	     state->interface == PHY_INTERFACE_MODE_SGMII ||
> +	     phy_interface_mode_is_rgmii(state->interface))) {
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 1000baseX_Full);
> +
> +		if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
> +			phylink_set(mask, 1000baseT_Half);
> +	}
> +
> +	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +}
> +
> +static int macb_mac_link_state(struct phylink_config *config,
> +			       struct phylink_link_state *state)
> +{
> +	return -EOPNOTSUPP;
> +}

The hardware supports SGMII, but you have no way of knowing if the
SGMII link is up? That seems odd.

      Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05E72C73B6
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387690AbgK1Vty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54582 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387407AbgK1THE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 14:07:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kj5Y0-009HLC-6D; Sat, 28 Nov 2020 20:06:16 +0100
Date:   Sat, 28 Nov 2020 20:06:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201128190616.GF2191767@lunn.ch>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127133307.2969817-3-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void sparx5_phylink_mac_config(struct phylink_config *config,
> +				      unsigned int mode,
> +				      const struct phylink_link_state *state)
> +{
> +	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
> +	struct sparx5_port_config conf;
> +	int err = 0;
> +
> +	conf = port->conf;
> +	conf.autoneg = state->an_enabled;
> +	conf.pause = state->pause;
> +	conf.duplex = state->duplex;
> +	conf.power_down = false;
> +	conf.portmode = state->interface;
> +
> +	if (state->speed == SPEED_UNKNOWN) {
> +		/* When a SFP is plugged in we use capabilities to
> +		 * default to the highest supported speed
> +		 */

This looks suspicious.

Russell, please could you look through this?

	 Andrew

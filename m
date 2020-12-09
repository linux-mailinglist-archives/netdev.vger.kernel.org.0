Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B147A2D4671
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbgLIQK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:10:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729519AbgLIQKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 11:10:19 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn21v-00B5Hf-Q6; Wed, 09 Dec 2020 17:09:27 +0100
Date:   Wed, 9 Dec 2020 17:09:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 1/1] net: stmmac: allow stmmac to probe for C45
 PHY devices
Message-ID: <20201209160927.GC2602479@lunn.ch>
References: <20201209111933.16121-1-vee.khee.wong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209111933.16121-1-vee.khee.wong@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 07:19:33PM +0800, Wong Vee Khee wrote:
> Assign stmmac's mdio_bus probe capabilities to MDIOBUS_C22_C45.
> This extends the probing of C45 PHY devices on the MDIO bus.
> 
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index b2a707e2ef43..9f96bb7d27db 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -364,6 +364,7 @@ int stmmac_mdio_register(struct net_device *ndev)
>  		memcpy(new_bus->irq, mdio_bus_data->irqs, sizeof(new_bus->irq));
>  
>  	new_bus->name = "stmmac";
> +	new_bus->probe_capabilities = MDIOBUS_C22_C45;

It looks like this needs to be conditional on the version. xgmax2
supports C45. And gmac4. But other versions don't.

	 Andrew

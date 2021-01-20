Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD63D2FC5BC
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbhATAZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 19:25:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48866 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730033AbhATAZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 19:25:06 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l21IJ-001YCR-NQ; Wed, 20 Jan 2021 01:24:19 +0100
Date:   Wed, 20 Jan 2021 01:24:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next V2] net: dsa: microchip: ksz8795: Fix KSZ8794
 port map again
Message-ID: <YAd4M1v/NgXKFED+@lunn.ch>
References: <20210120001045.488506-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120001045.488506-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 01:10:45AM +0100, Marek Vasut wrote:
> The KSZ8795 switch has 4 external ports {0,1,2,3} and 1 CPU port {4}, so
> does the KSZ8765. The KSZ8794 seems to be repackaged KSZ8795 with different
> ID and port 3 not routed out, however the port 3 registers are present in
> the silicon, so the KSZ8794 switch has 3 external ports {0,1,2} and 1 CPU
> port {4}. Currently the driver always uses the last port as CPU port, on
> KSZ8795/KSZ8765 that is port 4 and that is OK, but on KSZ8794 that is port
> 3 and that is not OK, as it must also be port 4.
> 
> This patch adjusts the driver such that it always registers a switch with
> 5 ports total (4 external ports, 1 CPU port), always sets the CPU port to
> switch port 4, and then configures the external port mask according to
> the switch model -- 3 ports for KSZ8794 and 4 for KSZ8795/KSZ8765.
> 
> Fixes: 68a1b676db52 ("net: dsa: microchip: ksz8795: remove superfluous port_cnt assignment")
> Fixes: 4ce2a984abd8 ("net: dsa: microchip: ksz8795: use phy_port_cnt where possible")
> Fixes: 241ed719bc98 ("net: dsa: microchip: ksz8795: use port_cnt instead of TOTOAL_PORT_NUM")
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

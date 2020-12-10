Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497392D5056
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732515AbgLJBZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:25:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732060AbgLJBZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 20:25:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1knAha-00B95y-3W; Thu, 10 Dec 2020 02:25:02 +0100
Date:   Thu, 10 Dec 2020 02:25:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Zhao Qiang <qiang.zhao@nxp.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] ethernet: ucc_geth: set dev->max_mtu to 1518
Message-ID: <20201210012502.GB2638572@lunn.ch>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205191744.7847-2-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205191744.7847-2-rasmus.villemoes@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 05, 2020 at 08:17:24PM +0100, Rasmus Villemoes wrote:
> All the buffers and registers are already set up appropriately for an
> MTU slightly above 1500, so we just need to expose this to the
> networking stack. AFAICT, there's no need to implement .ndo_change_mtu
> when the receive buffers are always set up to support the max_mtu.
> 
> This fixes several warnings during boot on our mpc8309-board with an
> embedded mv88e6250 switch:
> 
> mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 0
> ...
> mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 4
> ucc_geth e0102000.ethernet eth1: error -22 setting MTU to 1504 to include DSA overhead
> 
> The last line explains what the DSA stack tries to do: achieving an MTU
> of 1500 on-the-wire requires that the master netdevice connected to
> the CPU port supports an MTU of 1500+the tagging overhead.
> 
> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

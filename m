Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168272EAD65
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbhAEOe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:34:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbhAEOeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:34:25 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwnOo-00GBBp-7X; Tue, 05 Jan 2021 15:33:26 +0100
Date:   Tue, 5 Jan 2021 15:33:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "leoyang.li@nxp.com" <leoyang.li@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "murali.policharla@broadcom.com" <murali.policharla@broadcom.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "qiang.zhao@nxp.com" <qiang.zhao@nxp.com>
Subject: Re: [PATCH 01/20] ethernet: ucc_geth: set dev->max_mtu to 1518
Message-ID: <X/R4tqny72Bjt28b@lunn.ch>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205191744.7847-2-rasmus.villemoes@prevas.dk>
 <20201210012502.GB2638572@lunn.ch>
 <33816fa937efc8d4865d95754965e59ccfb75f2c.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <33816fa937efc8d4865d95754965e59ccfb75f2c.camel@infinera.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 02:17:42PM +0000, Joakim Tjernlund wrote:
> On Thu, 2020-12-10 at 02:25 +0100, Andrew Lunn wrote:
> > On Sat, Dec 05, 2020 at 08:17:24PM +0100, Rasmus Villemoes wrote:
> > > All the buffers and registers are already set up appropriately for an
> > > MTU slightly above 1500, so we just need to expose this to the
> > > networking stack. AFAICT, there's no need to implement .ndo_change_mtu
> > > when the receive buffers are always set up to support the max_mtu.
> > > 
> > > This fixes several warnings during boot on our mpc8309-board with an
> > > embedded mv88e6250 switch:
> > > 
> > > mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 0
> > > ...
> > > mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 4
> > > ucc_geth e0102000.ethernet eth1: error -22 setting MTU to 1504 to include DSA overhead
> > > 
> > > The last line explains what the DSA stack tries to do: achieving an MTU
> > > of 1500 on-the-wire requires that the master netdevice connected to
> > > the CPU port supports an MTU of 1500+the tagging overhead.
> > > 
> > > Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> > > Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > 
> >     Andrew
> 
> I don't see this in any kernel, seems stuck? Maybe because the series as a whole is not approved?

Hi Joakim

When was it posted? If it was while netdev was closed during the merge
window, you need to repost.

You should be able to see the status in the netdev patchwork instance

https://patchwork.kernel.org/project/netdevbpf/list/

	Andrew

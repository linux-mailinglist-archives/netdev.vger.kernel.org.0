Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06ED42FBBB7
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391635AbhASPxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:53:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390924AbhASPxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:53:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l1tIX-001TEb-B5; Tue, 19 Jan 2021 16:52:01 +0100
Date:   Tue, 19 Jan 2021 16:52:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: mrp: use stp state as substitute for
 unimplemented mrp state
Message-ID: <YAcAIcwfp8za9JUo@lunn.ch>
References: <20210118181319.25419-1-rasmus.villemoes@prevas.dk>
 <20210118185618.75h45rjf6qqberic@soft-dev3.localdomain>
 <20210118194632.zn5yucjfibguemjq@skbuf>
 <20210118202036.wk2fuwa3hysg4dmj@soft-dev3.localdomain>
 <20210118212735.okoov5ndybszd6m5@skbuf>
 <20210119083240.37cxv3lxi25hwduj@soft-dev3.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119083240.37cxv3lxi25hwduj@soft-dev3.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 09:32:40AM +0100, Horatiu Vultur wrote:
> The 01/18/2021 21:27, Vladimir Oltean wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On Mon, Jan 18, 2021 at 09:20:36PM +0100, Horatiu Vultur wrote:
> > > The 01/18/2021 19:46, Vladimir Oltean wrote:
> > > >
> > > > On Mon, Jan 18, 2021 at 07:56:18PM +0100, Horatiu Vultur wrote:
> > > > > The reason was to stay away from STP, because you can't run these two
> > > > > protocols at the same time. Even though in SW, we reuse port's state.
> > > > > In our driver(which is not upstreamed), we currently implement
> > > > > SWITCHDEV_ATTR_ID_MRP_PORT_STATE and just call the
> > > > > SWITCHDEV_ATTR_ID_PORT_STP_STATE.
> > > >
> > > > And isn't Rasmus's approach reasonable, in that it allows unmodified
> > > > switchdev drivers to offload MRP port states without creating
> > > > unnecessary code churn?
> > >
> > > I am sorry but I don't see this as the correct solution. In my opinion,
> > > I would prefer to have 3 extra lines in the driver and have a better
> > > view of what is happening. Than having 2 calls in the driver for
> > > different protocols.
> > 
> > I think the question boils down to: is a MRP-unaware driver expected to
> > work with the current bridge MRP code?
> 
> If the driver has switchdev support, then is not expected to work with
> the current bridge MRP code.

> 
> For example, the Ocelot driver, it has switchdev support but no MRP
> support so this is not expected to work.

Then ideally, we need switchdev core to be testing for the needed ops
and returning an error which prevents MRP being configured when it
cannot work.

       Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF33835C8C6
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242302AbhDLOa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:30:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242263AbhDLOaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:30:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVxZj-00GHBk-33; Mon, 12 Apr 2021 16:30:03 +0200
Date:   Mon, 12 Apr 2021 16:30:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <YHRZa9R22UyIRSd9@lunn.ch>
References: <20210412121430.20898-1-pali@kernel.org>
 <YHRH2zWsYkv/yjYz@lunn.ch>
 <20210412133447.fyqkavrs5r5wbino@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412133447.fyqkavrs5r5wbino@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +/* This table contains representative model for every family */
> > > +static const enum mv88e6xxx_model family_model_table[] = {
> > > +	[MV88E6XXX_FAMILY_6095] = MV88E6095,
> > > +	[MV88E6XXX_FAMILY_6097] = MV88E6097,
> > > +	[MV88E6XXX_FAMILY_6185] = MV88E6185,
> > > +	[MV88E6XXX_FAMILY_6250] = MV88E6250,
> > > +	[MV88E6XXX_FAMILY_6320] = MV88E6320,
> > > +	[MV88E6XXX_FAMILY_6341] = MV88E6341,
> > > +	[MV88E6XXX_FAMILY_6351] = MV88E6351,
> > > +	[MV88E6XXX_FAMILY_6352] = MV88E6352,
> > > +	[MV88E6XXX_FAMILY_6390] = MV88E6390,
> > > +};
> > 
> > This table is wrong. MV88E6390 does not equal
> > MV88E6XXX_PORT_SWITCH_ID_PROD_6390. MV88E6XXX_PORT_SWITCH_ID_PROD_6390
> > was chosen because it is already an MDIO device ID, in register 2 and
> > 3. It probably will never clash with a real Marvell PHY ID. MV88E6390
> > is just a small integer, and there is a danger it will clash with a
> > real PHY.
> 
> So... how to solve this issue? What should be in the mapping table?

You need to use MV88E6XXX_PORT_SWITCH_ID_PROD_6095,
MV88E6XXX_PORT_SWITCH_ID_PROD_6097,
...
MV88E6XXX_PORT_SWITCH_ID_PROD_6390,

> > You cannot just replace the MARVELL_PHY_ID_88E6390. That will break
> > the 6390! You need to add the new PHY for the 88E6341.
> 
> I have not replaced anything.

Yes, sorry. I read the diff wrong.

     Andrew

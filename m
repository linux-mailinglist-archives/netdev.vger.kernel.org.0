Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F18A2C8823
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgK3Pfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:35:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57576 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgK3Pfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 10:35:47 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjlCd-009WY9-Mp; Mon, 30 Nov 2020 16:34:59 +0100
Date:   Mon, 30 Nov 2020 16:34:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
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
Message-ID: <20201130153459.GD2073444@lunn.ch>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190334.GE2191767@lunn.ch>
 <20201130132835.7ln72bbdr36spuwm@mchp-dev-shegelun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130132835.7ln72bbdr36spuwm@mchp-dev-shegelun>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hmm.  I will have to revisit this again.  The intent was to be able to
> destinguish between regular PHYs and SFPs (as read from the DT).
> But maybe the phylink_of_phy_connect function handles this
> automatically...

Yes, you should not have to differentiate between an SFP and a
traditional copper PHY. phylink will handle it all.

> > 
> > > +void sparx5_destroy_netdev(struct sparx5 *sparx5, struct sparx5_port *port)
> > > +{
> > > +     if (port->phylink) {
> > > +             /* Disconnect the phy */
> > > +             if (rtnl_trylock()) {
> > 
> > Why do you use rtnl_trylock()?
> 
> The sparx5_port_stop() in turn calls phylink_stop() that expects the lock
> to be taken.  Should I rather just call rtnl_lock()?

Yes, you don't want to not call phylink_stop().

     Andrew

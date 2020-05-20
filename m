Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60AC1DB811
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgETPXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:23:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:53794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgETPXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:23:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BB0E0B229;
        Wed, 20 May 2020 15:23:54 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CF618604F6; Wed, 20 May 2020 17:23:50 +0200 (CEST)
Date:   Wed, 20 May 2020 17:23:50 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY Signal
 Quality Index (SQI)
Message-ID: <20200520152350.GC8771@lion.mk-sys.cz>
References: <20200520062915.29493-1-o.rempel@pengutronix.de>
 <20200520062915.29493-2-o.rempel@pengutronix.de>
 <20200520144544.GB8771@lion.mk-sys.cz>
 <20200520150711.rj4b22g3zhzej2aw@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520150711.rj4b22g3zhzej2aw@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 05:07:11PM +0200, Oleksij Rempel wrote:
> On Wed, May 20, 2020 at 04:45:44PM +0200, Michal Kubecek wrote:
> > On Wed, May 20, 2020 at 08:29:14AM +0200, Oleksij Rempel wrote:
> > > Signal Quality Index is a mandatory value required by "OPEN Alliance
> > > SIG" for the 100Base-T1 PHYs [1]. This indicator can be used for cable
> > > integrity diagnostic and investigating other noise sources and
> > > implement by at least two vendors: NXP[2] and TI[3].
> > > 
> > > [1] http://www.opensig.org/download/document/218/Advanced_PHY_features_for_automotive_Ethernet_V1.0.pdf
> > > [2] https://www.nxp.com/docs/en/data-sheet/TJA1100.pdf
> > > [3] https://www.ti.com/product/DP83TC811R-Q1
> > > 
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > ---
> > 
> > This looks good to me, there is just one thing I'm not sure about:
> > 
> > > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > > index 59344db43fcb1..950ba479754bd 100644
> > > --- a/include/linux/phy.h
> > > +++ b/include/linux/phy.h
> > > @@ -706,6 +706,8 @@ struct phy_driver {
> > >  			    struct ethtool_tunable *tuna,
> > >  			    const void *data);
> > >  	int (*set_loopback)(struct phy_device *dev, bool enable);
> > > +	int (*get_sqi)(struct phy_device *dev);
> > > +	int (*get_sqi_max)(struct phy_device *dev);
> > >  };
> > >  #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
> > >  				      struct phy_driver, mdiodrv)
> > 
> > I'm not sure if it's a good idea to define two separate callbacks. It
> > means adding two pointers instead of one (for every instance of the
> > structure, not only those implementing them), doing two calls, running
> > the same checks twice, locking twice, checking the result twice.
> > 
> > Also, passing a structure pointer would mean less code changed if we
> > decide to add more related state values later.
> > 
> > What do you think?
> > 
> > If you don't agree, I have no objections so
> > 
> > Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> 
> I have no strong opinion on it. Should I rework it?

It's up to you. It was a suggestion for possible improvement but I have
no problem with this version being applied.

Michal

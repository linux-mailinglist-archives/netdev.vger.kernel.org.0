Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02861B2A7F
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgDUOwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:52:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54222 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgDUOwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 10:52:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Mjm8qP8+w+T0fVjvHJ/inEJrZOdLk4lUvlHtL7aGk9o=; b=uehvY9zagyOx7GTejoB3p8hdAG
        Gr/TqpDH99jjyTn6Ytd3U6RIm3YMBu+wyS5/zhsDtozl1EWdWuM3qkrWiTM0aRUOi2GQG6SNVUJDq
        VJk8j30wi03BocLI94FtXcjB97lTefHvRcqvJC7Bpd1B6iWDTGhLvmVzhfgbpEHQqeg8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQuFy-0042d3-D1; Tue, 21 Apr 2020 16:52:14 +0200
Date:   Tue, 21 Apr 2020 16:52:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: add concept of shared storage
 for PHYs
Message-ID: <20200421145214.GD933345@lunn.ch>
References: <20200420232624.9127-1-michael@walle.cc>
 <20200421143455.GB933345@lunn.ch>
 <20200421144302.GD25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421144302.GD25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 03:43:02PM +0100, Russell King - ARM Linux admin wrote:
> On Tue, Apr 21, 2020 at 04:34:55PM +0200, Andrew Lunn wrote:
> > > +static inline bool phy_package_init_once(struct phy_device *phydev)
> > > +{
> > > +	struct phy_package_shared *shared = phydev->shared;
> > > +
> > > +	if (!shared)
> > > +		return false;
> > > +
> > > +	return !test_and_set_bit(PHY_SHARED_F_INIT_DONE, &shared->flags);
> > > +}
> > 
> > I need to look at how you actually use this, but i wonder if this is
> > sufficient. Can two PHYs probe at the same time? Could we have one PHY
> > be busy setting up the global init, and the other thinks the global
> > setup is complete? Do we want a comment like: 'Returns true when the
> > global package initialization is either under way or complete'?
> 
> IIRC, probe locking in the driver model is by per-driver locks, so
> any particular driver won't probe more than one device at a time.

Hi Russel

Cool, thanks for the info.

      Andrew

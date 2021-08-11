Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E394D3E9AE4
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhHKWYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:24:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45978 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232212AbhHKWYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:24:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=poRP3nQyD7lNNQ3P/1blKXJqRofYUQsNWQobugkVHSw=; b=V8YaSRJ0X3LFGR0LK38iM3oI1C
        Sa3g0d0FsYoJa5hi9MNtdYAnWqwe2Y4x3mn5UK2dWE9JK9omwgnf7t4dvMARu/QYOYpi6vFbmUctH
        EMTrTAqmYu6L+UTeXlHfK34qleGUQm1FVVlbvwFk+wVl8Ux8Kw/HvdE3IGhbf/aJeatg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDwdP-00HCP9-GX; Thu, 12 Aug 2021 00:23:39 +0200
Date:   Thu, 12 Aug 2021 00:23:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "Ivan T. Ivanov" <iivanov@suse.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: leds: Trigger leds only if PHY speed is known
Message-ID: <YRRN6z3EjaItF3TJ@lunn.ch>
References: <20210716141142.12710-1-iivanov@suse.de>
 <YPGjnvB92ajEBKGJ@lunn.ch>
 <162646032060.16633.4902744414139431224@localhost>
 <20210719152942.GQ22278@shell.armlinux.org.uk>
 <162737250593.8289.392757192031571742@localhost>
 <162806599009.5748.14837844278631256325@localhost>
 <20210809141633.GT22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809141633.GT22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 03:16:33PM +0100, Russell King (Oracle) wrote:
> On Wed, Aug 04, 2021 at 11:33:10AM +0300, Ivan T. Ivanov wrote:
> > I have sent new patch[1] which I think is proper fix for this.
> > 
> > [1] https://lore.kernel.org/netdev/20210804081339.19909-1-iivanov@suse.de/T/#u
> 
> Thanks.
> 
> I haven't reviewed the driver, but the patch itself LGTM from the
> point of view that phy_read_status() should definitely only be
> called with phydev->lock held.

I'm cooking up a patchset which makes phy_read_status() take the
lock. I don't see any external callers taking the lock, so all the
changes are internal to phylib.

The change is however made a bit more complex by phy_read_status()
being in a header file, not phy.c. I wounder if there is some build
dependencies, modules vs built in. So my first patch simply moves it
into phy.c no other change. I will push it to github and let 0-day
chew on it for a while and see if it finds any build failures.

     Andrew

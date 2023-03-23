Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1EF6C71D1
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbjCWUrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbjCWUrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:47:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D92193EC;
        Thu, 23 Mar 2023 13:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eUkdv6Q7/eqKCd6rPmBFDOxJKcz0jZzE3fT0VIR99q4=; b=zPuIimfBQ66Vy5fFRLviudlFfZ
        a5WdKzqpM8Jsze/rSjK2ng1dUoPsstUiJYsnqepINeCS/QSNMjT9CZWSoDM14lgrTzLNwoqhZ1/t8
        tNsnOcm9HcVnxKVuo/iw30lxW6yDgwwHS5erx4ByZHPYNcfycvvHHOK6WXDVCpFHvRj3rtjPB7aEE
        6fVGta9PNtcCYWJQXAUGGa12NCwsgGNXjIDrrqF4IJN+Je7rJqKV0EFAIMqMyyS8qBvuErsaINYAF
        R+nRlZJC+tZwNiHhv0hls+fIxucuPgCqZ5t/g+jIpRTsg9YmTU9QGmeZi8FHtApvV/nWxsDXABzSL
        crweK91g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43804)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfRpn-0005p4-OW; Thu, 23 Mar 2023 20:46:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfRpj-0001ip-Ug; Thu, 23 Mar 2023 20:46:52 +0000
Date:   Thu, 23 Mar 2023 20:46:51 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 3/7] net: dsa: use fwnode_get_phy_mode() to
 get phy interface mode
Message-ID: <ZBy6u/8HhaPbWXA9@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
 <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
 <ZBxiqJo470A7bkig@shell.armlinux.org.uk>
 <ZBxkZYXrfugz0gYw@smile.fi.intel.com>
 <ZBxm3XrQAfnmbHoF@shell.armlinux.org.uk>
 <ZBxpeLOmTMzqVTRV@smile.fi.intel.com>
 <ZBySKoHh25AMMBVg@shell.armlinux.org.uk>
 <ZByUvVGRhpFUYrVq@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZByUvVGRhpFUYrVq@smile.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 08:04:45PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 23, 2023 at 05:53:46PM +0000, Russell King (Oracle) wrote:
> > On Thu, Mar 23, 2023 at 05:00:08PM +0200, Andy Shevchenko wrote:
> > > On Thu, Mar 23, 2023 at 02:49:01PM +0000, Russell King (Oracle) wrote:
> > > > Let's start here. We pass this fwnode to fwnode_get_phy_mode():
> > > > 
> > > > include/linux/property.h:int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
> > > > 
> > > > Does fwnode_get_phy_mode() alter the contents of the fwnode? Probably
> > > > not, but it doesn't take a const pointer. Therefore, to declare my
> > > > fwnode as const, I'd need to cast the const-ness away before calling
> > > > this.
> > > 
> > > So, fix the fwnode_get_phy_mode(). Is it a problem?
> > > 
> > > > Then there's phylink_create(). Same problem.
> > > 
> > > So, fix that. Is it a problem?
> > 
> > To do both of these creates a five patch series, because there are so
> > many things that need to be constified:
> > 
> > fwnode_get_phy_mode() is the trivial one.
> > 
> > sfp_bus_find_fwnode(), and the sfp-bus internal fwnode uses.
> > 
> > fwnode_get_phy_node().
> > 
> > phylink_create(), phylink_parse_fixedlink(), phylink_parse_mode(),
> > phylink_fwnode_phy_connect().
> > 
> > Hopefully nothing breaks as a result of changing all those - but that
> > can hardly be "tacked" on to the start of my series as a trivial
> > change - and clearly such a change should _not_ be part of this
> > series.
> 
> Thank you for doing that!
> 
> > Those five patches do not include moving fwnode_get_phy_mode(), whose
> > location remains undecided.
> 
> No problem, we like iterative work.

Oh, and what a waste of time that was.

You request that the fwnode should be declared const, but now I
realise that you never looked at patch 4, where we call
fwnode_remove_software_node() on this fwnode (so that the swnodes
returned by ->port_get_fwnode are released).

Since fwnode_remove_software_node() modifies the swnode containing
the fwnode, and therefore does not take a const fwnode pointer, we
also can't make _this_ fwnode pointer const - even with all those
changes.

So, I feel like I've been on a wild goose chase and what a needless
effort it has been to concoct patches that I don't even need for
this.

So again, rmk was right! Sigh.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

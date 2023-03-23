Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A593F6C6D89
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbjCWQaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbjCWQ3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:29:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC24A29413;
        Thu, 23 Mar 2023 09:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TsjIJlHCr6RHkaUXi8Zsa2mLTRFAwmW9uSJPS9QodsY=; b=PLPKgya13Ye0I193Mm7ypYz1Sh
        gHEoR+t54KikNxB29i+nD/MEbjw6QSsn4uPBWtTGovlxzpCi4N3mW80gXCYfuIbfatZsZGExGZRMd
        nkxXxguxgGBS6hNiF+0+0S5tB+/31O/cUTIk+5SVQ7WGHiF3CCTHQmivyMyyqbOuUevK8EohkK59A
        MWxop4LfcVGNxrsRhdxPNAqZwopN8sWogiDlJc0NRHhPTXXeMWjBtGWOylTawaDWiJdICXDhiK4Ys
        G40q/5gBGxdpNuAbgAuvO6sLhfiKzm7qFVj5RmtIBGzx6Xv2LfCLrQn5hlezxVROZuqYmUkW6rtE3
        CNJmLnuA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37188)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfNop-0005S9-A7; Thu, 23 Mar 2023 16:29:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfNon-0001Wp-N6; Thu, 23 Mar 2023 16:29:37 +0000
Date:   Thu, 23 Mar 2023 16:29:37 +0000
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
Message-ID: <ZBx+cUbdSPxCRK2H@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
 <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
 <ZBxiqJo470A7bkig@shell.armlinux.org.uk>
 <ZBxkZYXrfugz0gYw@smile.fi.intel.com>
 <ZBxm3XrQAfnmbHoF@shell.armlinux.org.uk>
 <ZBxpeLOmTMzqVTRV@smile.fi.intel.com>
 <ZBxu4FvyO2JDwmMq@shell.armlinux.org.uk>
 <ZBxxPYyNZrOQ6aVN@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBxxPYyNZrOQ6aVN@smile.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 05:33:17PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 23, 2023 at 03:23:12PM +0000, Russell King (Oracle) wrote:
> > On Thu, Mar 23, 2023 at 05:00:08PM +0200, Andy Shevchenko wrote:
> > > On Thu, Mar 23, 2023 at 02:49:01PM +0000, Russell King (Oracle) wrote:
> > > > On Thu, Mar 23, 2023 at 04:38:29PM +0200, Andy Shevchenko wrote:
> > > > > On Thu, Mar 23, 2023 at 02:31:04PM +0000, Russell King (Oracle) wrote:
> > > > > > On Thu, Mar 23, 2023 at 04:03:05PM +0200, Andy Shevchenko wrote:
> > > > > > > On Wed, Mar 22, 2023 at 12:00:06PM +0000, Russell King (Oracle) wrote:
> 
> ...
> 
> > > > > > > > +	struct fwnode_handle *fwnode;
> > > > > > > 
> > > > > > > > +	fwnode = of_fwnode_handle(dp->dn);
> > > > > > > 
> > > > > > > 	const struct fwnode_handle *fwnode = of_fwnode_handle(dp->dn);
> > > > > > > 
> > > > > > > ?
> > > > > > 
> > > > > > Why const?
> > > > > 
> > > > > Do you modify its content on the fly?
> > > > 
> > > > Do you want to litter code with casts to get rid of the const?
> > > > 
> > > > > For fwnode as a basic object type we want to reduce the scope of the possible
> > > > > modifications. If you don't modify and APIs you call do not require non-const
> > > > > object, use const for fwnode.
> > > > 
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
> > 
> > No, I refuse. That's for a different patch set.
> 
> I don't disagree, but it can be done as a precursor to your RFC.

And you want that merged through net-next?

> > > > Then there's phylink_create(). Same problem.
> > > 
> > > So, fix that. Is it a problem?
> > 
> > No for the same reason.
> > 
> > > > So NAK to this const - until such time that we have a concerted effort
> > > > to making functions we call which do not modify the "fwnode" argument
> > > > constify that argument. Otherwise it's just rediculously crazy to
> > > > declare a variable const only to then litter the code with casts to get
> > > > rid of it at every call site.
> > > > 
> > > > Please do a bit of research before making suggestions. Thanks.
> > > 
> > > So, MAK to your patch. You can fix that, and you know that.
> > 
> > Sorry, I don't accept your NAK. While you have a valid point about
> > these things being const, that is not the fault of this patch series,
> > and is something that should be addressed separately.
> 
> Yes, and since it's not a big deal it can be done as a precursor work.
> 
> > The lack of const-ness that has been there for quite some time is no
> > reason to NAK a patch that has nothing to do with this.
> 
> Instead of saying politely that you didn't agree of the necessity of the asked
> changes, you shoowed your confrontational manner with a strong NAK. Let's not
> escalate it further, it won't play well with a nervous system.
> 
> > > P.S. Please, move that phy thingy away from property.h, it doesn't belong
> > > there.
> > 
> > Again, that's a subject for a separate patch.
> > 
> > I will re-post this in due course and ignore your NAK (due to your
> > lack of research, and confrontational nature.)
> 
> Don't make a drama out of it. Many maintainers are asking for a small cleanups
> before applying a feature.
> 
> Nevertheless, since I'm neither a net nor a DSA maintainer, I have only thing
> to push is to move the PHY APIs out from the property.h. The rest is up to you.

Really? In your previous message, you were NAKing the patch based on the
lack of "const"ness. So you've changed your tune to something that was
a request in a post-script (PS).

If you had done due diligence, you would have realised that its
implementation is in property.c, so presumably if you had known that
either (a) you wouldn't be making the request or (b) you would be
asking for that to be moved as well.

Now, where do you expect it to be moved to? There is nowhere convenient
in net/ nor drivers/net/ for it today. It's corresponding DT equivalent
is in net/core/of_net.c, but that is only built if CONFIG_OF is enabled
which is unsuitable for the fwnode version. I guess we could have a
net/core/fwnode.c just for this single function... then where do we put
the prototype? include/linux/fwnode_net.h (which would be a new header
just for this), and updating the five drivers for this change.

In any case, due to the way netdev works, this should *not* be part
of this patch series, because if there's a reason to revert this
series, we wouldn't want the move of fwnode_get_phy_mode() to also
get reverted - that would potentially cause chaos.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

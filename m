Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3436C6D3B
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjCWQS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjCWQSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:18:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845BA13524;
        Thu, 23 Mar 2023 09:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=y0gf9APDtYtZIsT+1u7Mlyc7cn3Ei5tfdECMdBpWVeU=; b=zzoV2hFmCn3Lk4bQYaeGaZKM1j
        SaLlJ8aWMHVZxpEjj4Efsiuy/iBIiQXs5eknlWOgKsMsTy7jh3BwjOQ/aa0/IF3STAEeIqjdj6bkz
        UqpzdhOvLuhddfb9EFHQRj531XHv2rECf1O2dsrQpUyHm+vIKfyIQYKIORHT2X+VOzWLiy6qr7167
        Kz0R72RC7jbRA4kHWCVaF7ucCKwKJI55/zgNvUpAfwf685HoiV00vR2z/3NAv43quLqPvPJmr187J
        Mw19jbx0WfRXPCMs5H/wZ8S4SgUALbNMj1GgYt/vbKF57QMLX2GdcvHde1Ftyq+ThlW2CXOwLpANx
        emQAxfBQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46466)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfNdt-0005Qb-LI; Thu, 23 Mar 2023 16:18:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfNdn-0001Wa-R2; Thu, 23 Mar 2023 16:18:15 +0000
Date:   Thu, 23 Mar 2023 16:18:15 +0000
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
Message-ID: <ZBx7xxs0NQV25cFn@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
 <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
 <ZBxiqJo470A7bkig@shell.armlinux.org.uk>
 <ZBxkZYXrfugz0gYw@smile.fi.intel.com>
 <ZBxm3XrQAfnmbHoF@shell.armlinux.org.uk>
 <ZBxpeLOmTMzqVTRV@smile.fi.intel.com>
 <ZBxu4FvyO2JDwmMq@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBxu4FvyO2JDwmMq@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 03:23:12PM +0000, Russell King (Oracle) wrote:
> On Thu, Mar 23, 2023 at 05:00:08PM +0200, Andy Shevchenko wrote:
> > On Thu, Mar 23, 2023 at 02:49:01PM +0000, Russell King (Oracle) wrote:
> > > On Thu, Mar 23, 2023 at 04:38:29PM +0200, Andy Shevchenko wrote:
> > > > Do you modify its content on the fly?
> > > 
> > > Do you want to litter code with casts to get rid of the const?
> > > 
> > > > For fwnode as a basic object type we want to reduce the scope of the possible
> > > > modifications. If you don't modify and APIs you call do not require non-const
> > > > object, use const for fwnode.
> > > 
> > > Let's start here. We pass this fwnode to fwnode_get_phy_mode():
> > > 
> > > include/linux/property.h:int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
> > > 
> > > Does fwnode_get_phy_mode() alter the contents of the fwnode? Probably
> > > not, but it doesn't take a const pointer. Therefore, to declare my
> > > fwnode as const, I'd need to cast the const-ness away before calling
> > > this.
> > 
> > So, fix the fwnode_get_phy_mode(). Is it a problem?
> 
> No, I refuse. That's for a different patch set.
> 
> > > Then there's phylink_create(). Same problem.
> > 
> > So, fix that. Is it a problem?
> 
> No for the same reason.
> 
> > > So NAK to this const - until such time that we have a concerted effort
> > > to making functions we call which do not modify the "fwnode" argument
> > > constify that argument. Otherwise it's just rediculously crazy to
> > > declare a variable const only to then litter the code with casts to get
> > > rid of it at every call site.
> > > 
> > > Please do a bit of research before making suggestions. Thanks.
> > 
> > So, MAK to your patch. You can fix that, and you know that.
> 
> Sorry, I don't accept your NAK. While you have a valid point about
> these things being const, that is not the fault of this patch series,
> and is something that should be addressed separately.
> 
> The lack of const-ness that has been there for quite some time is no
> reason to NAK a patch that has nothing to do with this.

To illustrate how rediculous this is:

$ git grep 'struct fwnode_handle \*.*='

gives 134 instances. Of those, only five are const, which means 129
aren't. So I question - why are you singling mine out for what appears
to be special treatment.


Let's look at other parts of the fwnode API.

void __iomem *fwnode_iomap(struct fwnode_handle *fwnode, int index);

Does that modify the fwnode it was passed? It calls:

        void __iomem *(*iomap)(struct fwnode_handle *fwnode, int index);

in struct fwnode_operations, so that would need to be made const as well.
The only implementation of that which I can find is of_fwnode_iomap()
which uses to_of_node() on that, which casts away the const-ness. So
this would be a candidate to making const.


bool fwnode_is_ancestor_of(struct fwnode_handle *ancestor, struct fwnode_handle *child);

I'd be surprised if that modifies either of those fwnodes. It seems
to use fwnode_for_each_parent_node() from the child, which passes
"child" to fwnode_get_parent(), which itself is const. Therefore, it
seems there's no reason not to make "child" const. "ancestor" can
also be made const since it's only being used for pointer-compares.


unsigned int fwnode_graph_get_endpoint_count(struct fwnode_handle *fwnode,
                                             unsigned long flags);

Similar story with this, although it uses
fwnode_graph_for_each_endpoint(), which seems to mean that "fwnode"
can also be const.


My point is that there are several things in the fwnode API that
should be made const but that aren't, but which should likely be
fixed before requiring const-ness of those fwnode_handle
declarations in people's code.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

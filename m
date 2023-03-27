Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5DF6CA1CA
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjC0KzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjC0KzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:55:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD143ABA;
        Mon, 27 Mar 2023 03:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LjdljXs5mhTAwAt4d7B3JqrMlSZ0hWCorVM+f3jxq+g=; b=rFbZTymh0Y8t9drMsYeJpWpaxW
        C0Eqt8qmIMUbxlccrCkqMFy7hSyiMUSbQVXFgwtYa1xQ0JJUqtn85BJFgaP/M21kOwjEPDDDuyFcs
        PttAFhElGYI4w0d+Wt5kfDd0IdcoUf5UGqxbAR877wflVYvlg4MNcuwG/YqpEHcKRcqxdfpmJMR5F
        YGqExlVo3pJ8fhX0WQd0U+6PmZOhpGZjinBGBcdxTbl6+iGbn2waFHwQw5ic1n2vmu6wPKnx4FquB
        rJ18iRO3VbZ7EapzgnAodSc4lQwW0TxEiKlhFjOrgtQLZnyKJ8kzQLXeVxGzHSYEsjCVrmu8nDLh1
        tFUcDbqw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47118)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pgkVF-0003Uj-N9; Mon, 27 Mar 2023 11:55:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pgkVA-0005Lh-Fj; Mon, 27 Mar 2023 11:55:00 +0100
Date:   Mon, 27 Mar 2023 11:55:00 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 6/7] net: dsa: mv88e6xxx: provide software
 node for default settings
Message-ID: <ZCF2BLvGoaD/RGCS@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <ZB24fDEqwx53Rthm@kuha.fi.intel.com>
 <ZB3YGWTWLYyecgw7@shell.armlinux.org.uk>
 <ZCFvtuyelA+WoeqK@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCFvtuyelA+WoeqK@kuha.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 01:28:06PM +0300, Heikki Krogerus wrote:
> On Fri, Mar 24, 2023 at 05:04:25PM +0000, Russell King (Oracle) wrote:
> > On Fri, Mar 24, 2023 at 04:49:32PM +0200, Heikki Krogerus wrote:
> > > Hi Russell,
> > > 
> > > On Wed, Mar 22, 2023 at 12:00:21PM +0000, Russell King (Oracle) wrote:
> > > > +static struct fwnode_handle *mv88e6xxx_create_fixed_swnode(struct fwnode_handle *parent,
> > > > +							   int speed,
> > > > +							   int duplex)
> > > > +{
> > > > +	struct property_entry fixed_link_props[3] = { };
> > > > +
> > > > +	fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
> > > > +	if (duplex == DUPLEX_FULL)
> > > > +		fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");
> > > > +
> > > > +	return fwnode_create_named_software_node(fixed_link_props, parent,
> > > > +						 "fixed-link");
> > > > +}
> > > > +
> > > > +static struct fwnode_handle *mv88e6xxx_create_port_swnode(phy_interface_t mode,
> > > > +							  int speed,
> > > > +							  int duplex)
> > > > +{
> > > > +	struct property_entry port_props[2] = {};
> > > > +	struct fwnode_handle *fixed_link_fwnode;
> > > > +	struct fwnode_handle *new_port_fwnode;
> > > > +
> > > > +	port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
> > > > +	new_port_fwnode = fwnode_create_software_node(port_props, NULL);
> > > > +	if (IS_ERR(new_port_fwnode))
> > > > +		return new_port_fwnode;
> > > > +
> > > > +	fixed_link_fwnode = mv88e6xxx_create_fixed_swnode(new_port_fwnode,
> > > > +							  speed, duplex);
> > > > +	if (IS_ERR(fixed_link_fwnode)) {
> > > > +		fwnode_remove_software_node(new_port_fwnode);
> > > > +		return fixed_link_fwnode;
> > > > +	}
> > > > +
> > > > +	return new_port_fwnode;
> > > > +}
> > > 
> > > That new fwnode_create_named_software_node() function looks like a
> > > conflict waiting to happen - if a driver adds a node to the root level
> > > (does not have to be root level), all the tests will pass because
> > > there is only a single device, but when a user later tries the driver
> > > with two devices, it fails, because the node already exist. But you
> > > don't need that function at all.
> > 
> > I think you're totally failing to explain how this can fail.
> > 
> > Let me reiterate what thestructure of the swnodes here is:
> > 
> > 	root
> > 	`- node%d (%d allocated by root IDA)
> > 	   +- phy-mode property
> > 	   `- fixed-link
> > 	      +- speed property
> > 	      `- optional full-duplex property
> > 
> > If we have two different devices creating these nodes, then at the
> > root level, they will end up having different root names. The
> > "fixed-link" is a child of this node.
> 
> Ah, sorry, the problem is not with this patch, or your use case. The
> problem is with the PATCH 1/7 of this series where you introduce that
> new function fwnode_create_named_software_node() which will not be
> tied to your use case only. In this patch you just use that function.
> I should have been more clear on that.

How is this any different from creating two struct device's with the
same parent and the same name? Or kobject_add() with the same parent
and name?

> I really just wanted to show how you can create those nodes by using
> the API designed for the statically described software nodes. So you
> don't need that new function. Please check that proposal from my
> original reply.

I don't see why I should. This is clearly a case that if one creates
two named nodes with the same name and same parent, it should fail and
it's definitely a "well don't do that then" in just the same way that
one doesn't do it with kobject_add() or any of the other numerous
interfaces that take names in a space that need to be unique.

I really don't think there is any issue here to be solved. In fact,
I think solving it will add additional useless complexity that just
isn't required - which adds extra code that can be wrong and fail.

Let's keep this simple. This approach is simple. If one does something
stupid (like creating two named nodes with the same name and same
parent) then it will verbosely fail. That is a good thing.

Internal kernel APIs are not supposed to protect people from being
stupid.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

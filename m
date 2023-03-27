Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA76F6CA168
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbjC0K3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbjC0K2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:28:25 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F363A5247;
        Mon, 27 Mar 2023 03:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679912893; x=1711448893;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tQ2SAQSOoA/DS/YF+meqpiyIPpb8Ic0BbubT/o+xj5g=;
  b=QXvzVhSuWzdLR9MgzJJ3pN7hvXXIhq2Lx/G1SvxVao9uBndlQQd7ofTR
   YCMjF0BLpseDjegKNOYSknftqg7NxeeokU31+k9JxnoATdM5/kOkGr+Yf
   cuL4UlSKZGfFa+OIFTPbk46WX8vPwO5JgiALAaRh9d7hWvYs/vO3qjecc
   /L9X4HgB5CiOm7OyR5BebRbDVVDzzxujCO16RpDPZqCDxMz2Tq87aNeHt
   4RhsVOiocWM5CW7w84HKfnjg30oCVAWLyOKOo3oGR3rRlfGOlzIJNmb4i
   bQeEXe1/aiuBF1ARRCswL9rXGuIVI+6AdpLWppgDUzFpl2D1KWei8ODkO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="402827913"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="402827913"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 03:28:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="826995774"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="826995774"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 27 Mar 2023 03:28:07 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 27 Mar 2023 13:28:06 +0300
Date:   Mon, 27 Mar 2023 13:28:06 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Message-ID: <ZCFvtuyelA+WoeqK@kuha.fi.intel.com>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <ZB24fDEqwx53Rthm@kuha.fi.intel.com>
 <ZB3YGWTWLYyecgw7@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZB3YGWTWLYyecgw7@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 05:04:25PM +0000, Russell King (Oracle) wrote:
> On Fri, Mar 24, 2023 at 04:49:32PM +0200, Heikki Krogerus wrote:
> > Hi Russell,
> > 
> > On Wed, Mar 22, 2023 at 12:00:21PM +0000, Russell King (Oracle) wrote:
> > > +static struct fwnode_handle *mv88e6xxx_create_fixed_swnode(struct fwnode_handle *parent,
> > > +							   int speed,
> > > +							   int duplex)
> > > +{
> > > +	struct property_entry fixed_link_props[3] = { };
> > > +
> > > +	fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
> > > +	if (duplex == DUPLEX_FULL)
> > > +		fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");
> > > +
> > > +	return fwnode_create_named_software_node(fixed_link_props, parent,
> > > +						 "fixed-link");
> > > +}
> > > +
> > > +static struct fwnode_handle *mv88e6xxx_create_port_swnode(phy_interface_t mode,
> > > +							  int speed,
> > > +							  int duplex)
> > > +{
> > > +	struct property_entry port_props[2] = {};
> > > +	struct fwnode_handle *fixed_link_fwnode;
> > > +	struct fwnode_handle *new_port_fwnode;
> > > +
> > > +	port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
> > > +	new_port_fwnode = fwnode_create_software_node(port_props, NULL);
> > > +	if (IS_ERR(new_port_fwnode))
> > > +		return new_port_fwnode;
> > > +
> > > +	fixed_link_fwnode = mv88e6xxx_create_fixed_swnode(new_port_fwnode,
> > > +							  speed, duplex);
> > > +	if (IS_ERR(fixed_link_fwnode)) {
> > > +		fwnode_remove_software_node(new_port_fwnode);
> > > +		return fixed_link_fwnode;
> > > +	}
> > > +
> > > +	return new_port_fwnode;
> > > +}
> > 
> > That new fwnode_create_named_software_node() function looks like a
> > conflict waiting to happen - if a driver adds a node to the root level
> > (does not have to be root level), all the tests will pass because
> > there is only a single device, but when a user later tries the driver
> > with two devices, it fails, because the node already exist. But you
> > don't need that function at all.
> 
> I think you're totally failing to explain how this can fail.
> 
> Let me reiterate what thestructure of the swnodes here is:
> 
> 	root
> 	`- node%d (%d allocated by root IDA)
> 	   +- phy-mode property
> 	   `- fixed-link
> 	      +- speed property
> 	      `- optional full-duplex property
> 
> If we have two different devices creating these nodes, then at the
> root level, they will end up having different root names. The
> "fixed-link" is a child of this node.

Ah, sorry, the problem is not with this patch, or your use case. The
problem is with the PATCH 1/7 of this series where you introduce that
new function fwnode_create_named_software_node() which will not be
tied to your use case only. In this patch you just use that function.
I should have been more clear on that.

I really just wanted to show how you can create those nodes by using
the API designed for the statically described software nodes. So you
don't need that new function. Please check that proposal from my
original reply.

If the potential conflict that the new function creates is still not
clear, then - firstly, you have to remember that that API is not only
for your drivers, it's generic API! - the problem comes from the fact
that there simply is nothing preventing it from being used to place
the new nodes always at the same level. So for example using NULL as
the parent:

        fwnode = fwnode_create_named_software_node(props,
                                                   NULL, /* NOTE */
                                                   "same_name");

thanks,

-- 
heikki

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8F06CA74C
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbjC0ORy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbjC0ORe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:17:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DD27EE8;
        Mon, 27 Mar 2023 07:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679926556; x=1711462556;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ox9tnbz40rWD/uO2RoiNuk3Q6ue3OpOJ6imdFJJEttU=;
  b=kHeuHF3xnSvsWl0v1oUj3Al3QYkeZjc3+wOXzH0OB2k0MVmMhe1WCZ3j
   2d9vNDkV+E1z+AoICH+AbeovViqSYbEvaz+Fk5o3P63jGfVwkO0jtFAFw
   NpMxaQs3zlY8EQlkN0B/1Rna+JB+zfrU3ce6TRQpY3K+lMclF+OvzdSu+
   vG9cNSZkDIak2hPiecmv5KdPrci1zTVCvatmp5qEbKglrS2zfIUqJoLVy
   YbOATaAfsH36owQywnRX7yyRDa3uE9HZVLfUjhVZKCBGD5dzJmk8rkEaG
   6FTpqTHk4W0SdiEQ58qeNY6l/tOsfSIALkVdTnNMZhx47wZCzGz5l0VXn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="342675576"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="342675576"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 07:13:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="827049499"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="827049499"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 27 Mar 2023 07:13:26 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 27 Mar 2023 17:13:25 +0300
Date:   Mon, 27 Mar 2023 17:13:25 +0300
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
Message-ID: <ZCGkhUh20OK6rEck@kuha.fi.intel.com>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <ZB24fDEqwx53Rthm@kuha.fi.intel.com>
 <ZB3YGWTWLYyecgw7@shell.armlinux.org.uk>
 <ZCFvtuyelA+WoeqK@kuha.fi.intel.com>
 <ZCF2BLvGoaD/RGCS@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCF2BLvGoaD/RGCS@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Mon, Mar 27, 2023 at 11:55:00AM +0100, Russell King (Oracle) wrote:
> On Mon, Mar 27, 2023 at 01:28:06PM +0300, Heikki Krogerus wrote:
> > On Fri, Mar 24, 2023 at 05:04:25PM +0000, Russell King (Oracle) wrote:
> > > On Fri, Mar 24, 2023 at 04:49:32PM +0200, Heikki Krogerus wrote:
> > > > Hi Russell,
> > > > 
> > > > On Wed, Mar 22, 2023 at 12:00:21PM +0000, Russell King (Oracle) wrote:
> > > > > +static struct fwnode_handle *mv88e6xxx_create_fixed_swnode(struct fwnode_handle *parent,
> > > > > +							   int speed,
> > > > > +							   int duplex)
> > > > > +{
> > > > > +	struct property_entry fixed_link_props[3] = { };
> > > > > +
> > > > > +	fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
> > > > > +	if (duplex == DUPLEX_FULL)
> > > > > +		fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");
> > > > > +
> > > > > +	return fwnode_create_named_software_node(fixed_link_props, parent,
> > > > > +						 "fixed-link");
> > > > > +}
> > > > > +
> > > > > +static struct fwnode_handle *mv88e6xxx_create_port_swnode(phy_interface_t mode,
> > > > > +							  int speed,
> > > > > +							  int duplex)
> > > > > +{
> > > > > +	struct property_entry port_props[2] = {};
> > > > > +	struct fwnode_handle *fixed_link_fwnode;
> > > > > +	struct fwnode_handle *new_port_fwnode;
> > > > > +
> > > > > +	port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
> > > > > +	new_port_fwnode = fwnode_create_software_node(port_props, NULL);
> > > > > +	if (IS_ERR(new_port_fwnode))
> > > > > +		return new_port_fwnode;
> > > > > +
> > > > > +	fixed_link_fwnode = mv88e6xxx_create_fixed_swnode(new_port_fwnode,
> > > > > +							  speed, duplex);
> > > > > +	if (IS_ERR(fixed_link_fwnode)) {
> > > > > +		fwnode_remove_software_node(new_port_fwnode);
> > > > > +		return fixed_link_fwnode;
> > > > > +	}
> > > > > +
> > > > > +	return new_port_fwnode;
> > > > > +}
> > > > 
> > > > That new fwnode_create_named_software_node() function looks like a
> > > > conflict waiting to happen - if a driver adds a node to the root level
> > > > (does not have to be root level), all the tests will pass because
> > > > there is only a single device, but when a user later tries the driver
> > > > with two devices, it fails, because the node already exist. But you
> > > > don't need that function at all.
> > > 
> > > I think you're totally failing to explain how this can fail.
> > > 
> > > Let me reiterate what thestructure of the swnodes here is:
> > > 
> > > 	root
> > > 	`- node%d (%d allocated by root IDA)
> > > 	   +- phy-mode property
> > > 	   `- fixed-link
> > > 	      +- speed property
> > > 	      `- optional full-duplex property
> > > 
> > > If we have two different devices creating these nodes, then at the
> > > root level, they will end up having different root names. The
> > > "fixed-link" is a child of this node.
> > 
> > Ah, sorry, the problem is not with this patch, or your use case. The
> > problem is with the PATCH 1/7 of this series where you introduce that
> > new function fwnode_create_named_software_node() which will not be
> > tied to your use case only. In this patch you just use that function.
> > I should have been more clear on that.
> 
> How is this any different from creating two struct device's with the
> same parent and the same name? Or kobject_add() with the same parent
> and name?

But that can not mean we have to take the same risk everywhere. I do
understand that we don't protect developers from doing silly decisions
in kernel, but that does not mean that we should simply accept
interfaces into the kernel that expose these risk if we don't need
them.

> > I really just wanted to show how you can create those nodes by using
> > the API designed for the statically described software nodes. So you
> > don't need that new function. Please check that proposal from my
> > original reply.
> 
> I don't see why I should. This is clearly a case that if one creates
> two named nodes with the same name and same parent, it should fail and
> it's definitely a "well don't do that then" in just the same way that
> one doesn't do it with kobject_add() or any of the other numerous
> interfaces that take names in a space that need to be unique.
> 
> I really don't think there is any issue here to be solved. In fact,
> I think solving it will add additional useless complexity that just
> isn't required - which adds extra code that can be wrong and fail.
> 
> Let's keep this simple. This approach is simple. If one does something
> stupid (like creating two named nodes with the same name and same
> parent) then it will verbosely fail. That is a good thing.

Well, I think the most simplest approach would be to have both the
nodes and the properties as part of that struct mv88e6xxx_chip:

struct mv88e6xxx_chip {
        ...
       struct property_entry port_props[2];
       struct property_entry fixed_link_props[3];

       struct software_node port_swnode;
       struct software_node fixed_link_swnode;
};

That allows you to register both nodes in one go:

static struct fwnode_handle *mv88e6xxx_create_port_swnode(struct mv88e6xxx_chip *chip,
                                                          phy_interface_t mode,
                                                          int speed,
                                                          int duplex)
{
        struct software_node *nodes[3] = {
                &chip->port_swnode,
                &chip->fixed_link_swnode,
        };
        int ret;

        chip->port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
        chip->port_swnode.properties = chip->port_props;

        chip->fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
        if (duplex == DUPLEX_FULL)
                chip->fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");

        chip->fixed_link_swnode.name = "fixed-link";
        chip->fixed_link_swnode.parent = &chip->port_swnode;
        chip->fixed_link_swnode.properties = chip->fixed_link_props;

        ret = software_node_register_node_group(nodes);
        if (ret)
                return ERR_PTR(ret);

        return software_node_fwnode(&chip->port_swnode);
}

> Internal kernel APIs are not supposed to protect people from being
> stupid.

This is an interesting topic. I used to agree with this
idea/philosophy without much thought, but then after (years of :-)
listening maintainers complaining about how new developers always
repeat the same mistakes over an over again, I've started thinking
about it. To use a bit rough analog, if we give a gun to a monkey, how
can we be surprised if if ends up shooting first its mates and then
its own brains out...

Perhaps this is a more generic subject, a topic for some conference
maybe, but I in any case don't think this is a black and white matter.
A little bit of protection is not only a harmful thing and always only
in the way of flexibility.

At the very least, I don't think we should not use this philosophy as
an argument for doing things in ways that may expose even minute risks
in the cases like this were an alternative approach already exists.

Br,

-- 
heikki

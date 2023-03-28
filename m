Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA286CBEA5
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjC1MKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbjC1MKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:10:05 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08116900C;
        Tue, 28 Mar 2023 05:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680005402; x=1711541402;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xLoBSbbOLL0OEQuqy4tqvOjcxTg30d+Q9GsnDRIy93Y=;
  b=WM+xUBfHUQhAiqpFsPSECVct4E0aDOr38wEBrerbiNkWVbRQjE5M+naC
   j0ePjbU3aWRaK6MTbVhokZR+5mRsJO5t5BS84VcW3nNhxiEiCSvSnBMAq
   i47mwLKMZ8tB/Sw4sVotknuWJTqP3k83qsNIo9d7Iyi3XD1wuXt/R4sOX
   0W/kTIcEktkvhvc+SCJq7ZBQwdqRA2bK3PPMsp+1qXZkU+DrGUS7nGJIN
   sFgA3pX3cYzPSmPkzaaWy/MOCiAycVtoW7IiMAgTadh+il71nrlmsiMAH
   oRg+JunrVwOAfBmTy03grAA3Co8WHXvnXXCVzL0fCtZwYWhL5jiAxy+k6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="340570154"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="340570154"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 05:10:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="827458585"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="827458585"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 28 Mar 2023 05:09:56 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 28 Mar 2023 15:09:56 +0300
Date:   Tue, 28 Mar 2023 15:09:56 +0300
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
Message-ID: <ZCLZFA964zu/otQJ@kuha.fi.intel.com>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <ZB24fDEqwx53Rthm@kuha.fi.intel.com>
 <ZB3YGWTWLYyecgw7@shell.armlinux.org.uk>
 <ZCFvtuyelA+WoeqK@kuha.fi.intel.com>
 <ZCF2BLvGoaD/RGCS@shell.armlinux.org.uk>
 <ZCGkhUh20OK6rEck@kuha.fi.intel.com>
 <ZCGpDlaJ7+HmPQiB@shell.armlinux.org.uk>
 <ZCG6D7KV/0W0FUoI@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCG6D7KV/0W0FUoI@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 04:45:19PM +0100, Russell King (Oracle) wrote:
> On Mon, Mar 27, 2023 at 03:32:46PM +0100, Russell King (Oracle) wrote:
> > On Mon, Mar 27, 2023 at 05:13:25PM +0300, Heikki Krogerus wrote:
> > > Hi Russell,
> > > 
> > > On Mon, Mar 27, 2023 at 11:55:00AM +0100, Russell King (Oracle) wrote:
> > > > On Mon, Mar 27, 2023 at 01:28:06PM +0300, Heikki Krogerus wrote:
> > > > > On Fri, Mar 24, 2023 at 05:04:25PM +0000, Russell King (Oracle) wrote:
> > > > > > On Fri, Mar 24, 2023 at 04:49:32PM +0200, Heikki Krogerus wrote:
> > > > > > > Hi Russell,
> > > > > > > 
> > > > > > > On Wed, Mar 22, 2023 at 12:00:21PM +0000, Russell King (Oracle) wrote:
> > > > > > > > +static struct fwnode_handle *mv88e6xxx_create_fixed_swnode(struct fwnode_handle *parent,
> > > > > > > > +							   int speed,
> > > > > > > > +							   int duplex)
> > > > > > > > +{
> > > > > > > > +	struct property_entry fixed_link_props[3] = { };
> > > > > > > > +
> > > > > > > > +	fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
> > > > > > > > +	if (duplex == DUPLEX_FULL)
> > > > > > > > +		fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");
> > > > > > > > +
> > > > > > > > +	return fwnode_create_named_software_node(fixed_link_props, parent,
> > > > > > > > +						 "fixed-link");
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static struct fwnode_handle *mv88e6xxx_create_port_swnode(phy_interface_t mode,
> > > > > > > > +							  int speed,
> > > > > > > > +							  int duplex)
> > > > > > > > +{
> > > > > > > > +	struct property_entry port_props[2] = {};
> > > > > > > > +	struct fwnode_handle *fixed_link_fwnode;
> > > > > > > > +	struct fwnode_handle *new_port_fwnode;
> > > > > > > > +
> > > > > > > > +	port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
> > > > > > > > +	new_port_fwnode = fwnode_create_software_node(port_props, NULL);
> > > > > > > > +	if (IS_ERR(new_port_fwnode))
> > > > > > > > +		return new_port_fwnode;
> > > > > > > > +
> > > > > > > > +	fixed_link_fwnode = mv88e6xxx_create_fixed_swnode(new_port_fwnode,
> > > > > > > > +							  speed, duplex);
> > > > > > > > +	if (IS_ERR(fixed_link_fwnode)) {
> > > > > > > > +		fwnode_remove_software_node(new_port_fwnode);
> > > > > > > > +		return fixed_link_fwnode;
> > > > > > > > +	}
> > > > > > > > +
> > > > > > > > +	return new_port_fwnode;
> > > > > > > > +}
> > > > > > > 
> > > > > > > That new fwnode_create_named_software_node() function looks like a
> > > > > > > conflict waiting to happen - if a driver adds a node to the root level
> > > > > > > (does not have to be root level), all the tests will pass because
> > > > > > > there is only a single device, but when a user later tries the driver
> > > > > > > with two devices, it fails, because the node already exist. But you
> > > > > > > don't need that function at all.
> > > > > > 
> > > > > > I think you're totally failing to explain how this can fail.
> > > > > > 
> > > > > > Let me reiterate what thestructure of the swnodes here is:
> > > > > > 
> > > > > > 	root
> > > > > > 	`- node%d (%d allocated by root IDA)
> > > > > > 	   +- phy-mode property
> > > > > > 	   `- fixed-link
> > > > > > 	      +- speed property
> > > > > > 	      `- optional full-duplex property
> > > > > > 
> > > > > > If we have two different devices creating these nodes, then at the
> > > > > > root level, they will end up having different root names. The
> > > > > > "fixed-link" is a child of this node.
> > > > > 
> > > > > Ah, sorry, the problem is not with this patch, or your use case. The
> > > > > problem is with the PATCH 1/7 of this series where you introduce that
> > > > > new function fwnode_create_named_software_node() which will not be
> > > > > tied to your use case only. In this patch you just use that function.
> > > > > I should have been more clear on that.
> > > > 
> > > > How is this any different from creating two struct device's with the
> > > > same parent and the same name? Or kobject_add() with the same parent
> > > > and name?
> > > 
> > > But that can not mean we have to take the same risk everywhere. I do
> > > understand that we don't protect developers from doing silly decisions
> > > in kernel, but that does not mean that we should simply accept
> > > interfaces into the kernel that expose these risk if we don't need
> > > them.
> > > 
> > > > > I really just wanted to show how you can create those nodes by using
> > > > > the API designed for the statically described software nodes. So you
> > > > > don't need that new function. Please check that proposal from my
> > > > > original reply.
> > > > 
> > > > I don't see why I should. This is clearly a case that if one creates
> > > > two named nodes with the same name and same parent, it should fail and
> > > > it's definitely a "well don't do that then" in just the same way that
> > > > one doesn't do it with kobject_add() or any of the other numerous
> > > > interfaces that take names in a space that need to be unique.
> > > > 
> > > > I really don't think there is any issue here to be solved. In fact,
> > > > I think solving it will add additional useless complexity that just
> > > > isn't required - which adds extra code that can be wrong and fail.
> > > > 
> > > > Let's keep this simple. This approach is simple. If one does something
> > > > stupid (like creating two named nodes with the same name and same
> > > > parent) then it will verbosely fail. That is a good thing.
> > > 
> > > Well, I think the most simplest approach would be to have both the
> > > nodes and the properties as part of that struct mv88e6xxx_chip:
> > > 
> > > struct mv88e6xxx_chip {
> > >         ...
> > >        struct property_entry port_props[2];
> > >        struct property_entry fixed_link_props[3];
> > > 
> > >        struct software_node port_swnode;
> > >        struct software_node fixed_link_swnode;
> > > };
> > > 
> > > That allows you to register both nodes in one go:
> > > 
> > > static struct fwnode_handle *mv88e6xxx_create_port_swnode(struct mv88e6xxx_chip *chip,
> > >                                                           phy_interface_t mode,
> > >                                                           int speed,
> > >                                                           int duplex)
> > > {
> > >         struct software_node *nodes[3] = {
> > >                 &chip->port_swnode,
> > >                 &chip->fixed_link_swnode,
> > >         };
> > >         int ret;
> > > 
> > >         chip->port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
> > >         chip->port_swnode.properties = chip->port_props;
> > > 
> > >         chip->fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
> > >         if (duplex == DUPLEX_FULL)
> > >                 chip->fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");
> > > 
> > >         chip->fixed_link_swnode.name = "fixed-link";
> > >         chip->fixed_link_swnode.parent = &chip->port_swnode;
> > >         chip->fixed_link_swnode.properties = chip->fixed_link_props;
> > > 
> > >         ret = software_node_register_node_group(nodes);
> > >         if (ret)
> > >                 return ERR_PTR(ret);
> > > 
> > >         return software_node_fwnode(&chip->port_swnode);
> > > }
> > 
> > You're suggesting code that passes a fwnode pointer back up layers
> > that has been allocated in the driver's private structure, assuming
> > that those upper layers are going to release this before re-calling
> > this function for a different port. They do today, but in the future?
> > 
> > There are always plenty of guns...
> > 
> > If we don't want to give the monkey the gun, we need a more complex
> > solution than that... and it becomes a question about how far you
> > want to take gun control.
> > 
> > Then there's the question about why we should have this data allocated
> > permanently in the system when it is only used for a very short period
> > during driver initialisation. That seems to be a complete waste of
> > resources.
> 
> Also, given that the data structures get re-used, your above example
> code is actually buggy - so you seem to have taken the gun and shot
> yourself! Why is it buggy?

> If on the first call to it, duplex is DUPLEX_FULL, then we set
> fixed_link_props[1] to point at the full-duplex property. On the next
> call, if we pass DUPLEX_HALF, then fixed_link_props[1] is left#
> untouched and will still point at the full-duplex property.

I have not shared a patch with you, I've only shared code snippet with
you - an example like you said. The only purpose of it is to give you
a rough idea how you can use the API. Please note that I did also
explain you that if you need to allocate those structures then you
just go ahead allocate them (see my original reply). I'm not giving
you the final solution, only the correct approach in a form of a
sketch.

The way you adapt that into this driver is not up to me, it's
something you need to do.

> This is a great illustration why trying to remove one gun from
> circulation results in other more subtle guns being manufactured.
> 
> I'm in favour of simple obviously correct code, which is what my
> proposal is. If someone does something stupid with it such as
> creating two swnodes with the same name, that isn't a problem -
> kobject (and sysfs) will detect the error, print a warning and
> return an error - resulting in a graceful cleanup. It won't crash
> the kernel.

The problem is that the function you are proposing will be exploited
silently - people will use NULL as the parent without anybody
noticing. Everything will work for a while, because everybody will
first only have a single device for that driver. But as time goes by
and new hardware appears, suddenly there are multiple devices for
those drivers, and the conflict start to appear.

At that point the changes that added the function call will have
trickled down to the stable trees, so the distros are affected. Now we
are no longer talking about a simple cleanup that fixes the issue. In
the unlikely, but possible case, this will turn into ABI problem if
there is something in user space that for whatever reason now expects
the node to be always accessible at the same level and with the same
name.

As you pointed out, this kind of risks we have to live with kbojects,
struct device stuff and many others, but the thing is, with the
software node and device property APIs right now we don't. So the fact
that a risk exists in one place just isn't justification to accept the
same risk absolutely everywhere.

> I think you're making a mountain out of a mole hill over the "someone
> might use fwnode_create_named_software_node() to create two nodes with
> the same name under the same parent" issue. At least to me, it's
> really not an issue that should have been raised, and I am firmly
> of the opinion that this is a total non-issue.
> 
> I'm also of the opinion that trying to "fix" this non-issue creates
> more problems than it solves.

Russell, if you have some good arguments for accepting your proposal,
I assure you I will agree with you, but so far all you have given are
attacks on a sketch details and statements like that "I think you're
making a mountain out of a mole". Those just are not good enough.

I've explained, repeatedly, the risk involved with your proposal. Your
counter arguments to that has been that the same risk exists
elsewhere, which does not matter like I explained above, and basically
that we can live with the risk, which really should not be acceptable
answer in general, but in this case since we have an alternative
approach it is definitely not an argument.

Your claim that using the existing API adds complexity is also
complete bogus, because the changes you will need to do to this patch
(this driver) are going to very small - the code will not look that
different. Just try the existing API.

So please note that I'm not trying to "fix" anything here - I don't
have to. Right now it seems all I'm doing is preventing useless
function from being added to the kernel.

thanks,

-- 
heikki

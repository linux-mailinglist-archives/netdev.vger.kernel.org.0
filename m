Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6736C804F
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 15:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjCXOt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 10:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbjCXOtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 10:49:49 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0B8227B5;
        Fri, 24 Mar 2023 07:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679669382; x=1711205382;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ruroUJ7d/6LRKlwwiZ0nBgtOFf+MF22+LVWHfWZkQa8=;
  b=f1FX3Qfl8b9x5fquBbYwp3pMm3kIzN4EAdJNFygpYollIVxZqcJChbNL
   AYcywqmu0uS4YGhszHUB/fHBLr5lRFl7NMtRf1pLVbM5CN7pdk5nn/6IF
   ZZTTFp0Suo522fHUtuwJqxgHu0Q8GHTvkYmJxHU8eDI3utKlEDwpRWeAb
   kbYHpvxIFV049bAkRtE1wKL0KIHA8tLnO3UXN257Rs4Vel3+y6Ff4/7rX
   jsLG9HBrkWEv9yeP8TqKqLh+ei00lp5vQaFCls3GOAEioPQg3k5/h5xwc
   L5Nlv69mI0BJ241AHRqaFNAGoyy0hXD2oP749Yq59tXkLRdIvDHpubfoS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="328212916"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="328212916"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 07:49:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="826280434"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="826280434"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 24 Mar 2023 07:49:34 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Fri, 24 Mar 2023 16:49:33 +0200
Date:   Fri, 24 Mar 2023 16:49:32 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
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
Message-ID: <ZB24fDEqwx53Rthm@kuha.fi.intel.com>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Wed, Mar 22, 2023 at 12:00:21PM +0000, Russell King (Oracle) wrote:
> +static struct fwnode_handle *mv88e6xxx_create_fixed_swnode(struct fwnode_handle *parent,
> +							   int speed,
> +							   int duplex)
> +{
> +	struct property_entry fixed_link_props[3] = { };
> +
> +	fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
> +	if (duplex == DUPLEX_FULL)
> +		fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");
> +
> +	return fwnode_create_named_software_node(fixed_link_props, parent,
> +						 "fixed-link");
> +}
> +
> +static struct fwnode_handle *mv88e6xxx_create_port_swnode(phy_interface_t mode,
> +							  int speed,
> +							  int duplex)
> +{
> +	struct property_entry port_props[2] = {};
> +	struct fwnode_handle *fixed_link_fwnode;
> +	struct fwnode_handle *new_port_fwnode;
> +
> +	port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
> +	new_port_fwnode = fwnode_create_software_node(port_props, NULL);
> +	if (IS_ERR(new_port_fwnode))
> +		return new_port_fwnode;
> +
> +	fixed_link_fwnode = mv88e6xxx_create_fixed_swnode(new_port_fwnode,
> +							  speed, duplex);
> +	if (IS_ERR(fixed_link_fwnode)) {
> +		fwnode_remove_software_node(new_port_fwnode);
> +		return fixed_link_fwnode;
> +	}
> +
> +	return new_port_fwnode;
> +}

That new fwnode_create_named_software_node() function looks like a
conflict waiting to happen - if a driver adds a node to the root level
(does not have to be root level), all the tests will pass because
there is only a single device, but when a user later tries the driver
with two devices, it fails, because the node already exist. But you
don't need that function at all.

Here's an example how you can add the nodes with the already existing
APIs. To keep this example simple, I'm expecting that you have members
for the software nodes to the struct mv88e6xxx_chip:

struct mv88e6xxx_chip {
        ...
        /* swnodes */
        struct software_node port_swnode;
        struct software_node fixed_link_swnode;
};

Of course, you don't have to add those members if you don't want to.
Then you just need to allocate the nodes separately, but that should
not be a problem. In any case, something like this:

static struct fwnode_handle *mv88e6xxx_create_port_swnode(struct mv88e6xxx_chip *chip,
                                                          phy_interface_t mode,
							  int speed,
							  int duplex)
{
	struct property_entry fixed_link_props[3] = { };
	struct property_entry port_props[2] = { };
	int ret;

        /*
         * First register the port node.
         */
	port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));

	chip->port_swnode.properties = property_entries_dup(port_props);
        if (IS_ERR(chip->port_swnode.properties))
                return ERR_CAST(chip->port_swnode.properties);

	ret = software_node_register(&chip->port_swnode);
	if (ret) {
                kfree(chip->port_swnode.properties);
		return ERR_PTR(ret);
        }

        /*
         * Then the second node, child of the port node.
         */
	fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
	if (duplex == DUPLEX_FULL)
		fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");

        chip->fixed_link_swnode.name = "fixed-link";
        chip->fixed_link_swnode.parent = &chip->port_swnode;
	chip->fixed_link_swnode.properties = property_entries_dup(fixed_link_props);
        if (IS_ERR(chip->port_swnode.properties)) {
                software_node_unregister(&chip->port_swnode);
                kfree(chip->port_swnode.properties);
                return ERR_CAST(chip->fixed_link_swnode.properties);
        }

	ret = software_node_register(&chip->fixed_link_swnode);
        if (ret) {
                software_node_unregister(&chip->port_swnode);
                kfree(chip->port_swnode.properties);
                kfree(chip->fixed_link_swnode.properties);
		return ERR_PTR(ret);
        }

        /*
         * Finally, return the port fwnode.
         */
        return software_node_fwnode(&chip->port_swnode);
}

thanks,

-- 
heikki

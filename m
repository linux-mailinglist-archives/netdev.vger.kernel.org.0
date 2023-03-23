Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1656C6B3F
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbjCWOji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjCWOjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:39:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837F5FF15;
        Thu, 23 Mar 2023 07:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679582376; x=1711118376;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1IHKYvoqQNAlPTL/CEWVc+xiON1bwXfO7wjKBlDVmnQ=;
  b=ECcF/AIZd6KfKaIdy8zHGxmrfwq/0C338kykzHgio/P/ImCA3NmF4LWv
   9EtRQhHwh34630BXFq7ijNntQeNeriD0+EcZU5xjgreLPN/8cfHE27AyE
   MO55EApOFb4qxTf6LLHeh5pSvNbHxWe103bQMXMciskDHCDpAdKd56tRH
   b7y2VqTmo9fAqvn/WkTvq/rP5I7RFxkWdM9RWI/QDdkPGW9yocabQHE/1
   LM7etlYo/IQ1kOBwDZwNzDrHYw97H/9A60m1tpp3KEgYbfwe00XkUE2jY
   V60OSRuSeMmFMapdVLpjfrD+86kAqdmUcMijWvfrZ0kwd5iDfPXHMLiN4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="323367084"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="323367084"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 07:39:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="714833537"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="714833537"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 23 Mar 2023 07:39:31 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pfM6D-007Xe4-1d;
        Thu, 23 Mar 2023 16:39:29 +0200
Date:   Thu, 23 Mar 2023 16:39:29 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Subject: Re: [PATCH RFC net-next 1/7] software node: allow named software
 node to be created
Message-ID: <ZBxkoSEgVR3jmK72@smile.fi.intel.com>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8F-00Dvnf-Sm@rmk-PC.armlinux.org.uk>
 <ZBxbKxAcAKznIVJ2@smile.fi.intel.com>
 <ZBxiRJXMqjrOl9TE@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBxiRJXMqjrOl9TE@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 02:29:24PM +0000, Russell King (Oracle) wrote:
> On Thu, Mar 23, 2023 at 03:59:07PM +0200, Andy Shevchenko wrote:
> > On Wed, Mar 22, 2023 at 11:59:55AM +0000, Russell King wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > 
> > > Allow a named software node to be created, which is needed for software
> > > nodes for a fixed-link specification for DSA.

...

> > > +fwnode_create_named_software_node(const struct property_entry *properties,
> > > +				  const struct fwnode_handle *parent,
> > > +				  const char *name)
> > >  {
> > >  	struct fwnode_handle *fwnode;
> > >  	struct software_node *node;
> > > @@ -930,6 +931,7 @@ fwnode_create_software_node(const struct property_entry *properties,
> > >  		return ERR_CAST(node);
> > >  
> > >  	node->parent = p ? p->node : NULL;
> > > +	node->name = name;
> > 
> > The same question stays as before: how can we be sure that the name is unique
> > and we won't have a collision?
> 
> This got discussed at length last time around, starting here:
> 
> https://lore.kernel.org/all/YtHGwz4v7VWKhIXG@smile.fi.intel.com/
> 
> My conclusion is that your concern is invalid, because we're creating
> this tree:
> 
> 	node%d
> 	+- phy-mode property
> 	`- fixed-link node
> 	   +- speed property
> 	   `- full-duplex (optional) property
> 
> Given that node%d will be allocated against the swnode_root_ids IDA,
> then how can there possibly be a naming collision.
> 
> You would be correct if the "fixed-link" node were to be created at
> root level, or if we were intentionally creating two swnodes under
> the same parent with the same name, but we aren't.
> 
> Plus, the code _already_ allows for e.g. multiple "node1" names - for
> example, one in root and one as a child node, since the code uses
> separate IDAs to allocate those.
> 
> Hence, I do not recognise the conern you are raising, and I believe
> your concern is not valid.
> 
> Your concern would be valid if it was a general concern about
> fwnode_create_named_software_node() being used to create the same
> named node under the same parent, but that IMHO is a programming
> bug, no different from trying to create two devices under the same
> parent with the same name.
> 
> So, unless you can be more expansive about _precisely_ what your
> concern is, then I don't think there exists any problem with this.

OK.

I leave it to others to review. I have nothing to add.

-- 
With Best Regards,
Andy Shevchenko



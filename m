Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8153A6C6C57
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbjCWPdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbjCWPda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:33:30 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404837DB4;
        Thu, 23 Mar 2023 08:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679585606; x=1711121606;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FSr9ghF0Z+gbb/JxQNcySsnS0FLxNhtSAag/X+SSZ2Y=;
  b=f4FQzR6rOw1kSKkJHa3b0mc+7V7KRaEOGMqAUyWhpcUfHu/61Erp1Aag
   0sBitEB6zY0028ch482RHyEcd3EssazTpegfYPZTcdnjH82EXYu5Shd1O
   /pg3BIA3uC1b1l4rncL3zgi9am3VrP2FQE3Zm0a8h9XOuIjGiAOqtcNtO
   +XW6FAvEZudHjslsKRvPc9exz+9nHUYFnFiYPfvzdNR9cBQc1W+9i4KIQ
   EVkI94r3+BieLxC2RB+bc7qT4kZZYnTbz8BRiLzMytaqlRrBItOdkw6MS
   eHyTLDMI1dDhH0/7PU2cULArcBq4+L2zB5t3ljUxOspEVQDfQbEi0v13L
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="319177596"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="319177596"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 08:33:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="712713758"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="712713758"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008.jf.intel.com with ESMTP; 23 Mar 2023 08:33:20 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pfMwI-007Yd3-0H;
        Thu, 23 Mar 2023 17:33:18 +0200
Date:   Thu, 23 Mar 2023 17:33:17 +0200
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
Subject: Re: [PATCH RFC net-next 3/7] net: dsa: use fwnode_get_phy_mode() to
 get phy interface mode
Message-ID: <ZBxxPYyNZrOQ6aVN@smile.fi.intel.com>
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
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
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
> > > > On Thu, Mar 23, 2023 at 02:31:04PM +0000, Russell King (Oracle) wrote:
> > > > > On Thu, Mar 23, 2023 at 04:03:05PM +0200, Andy Shevchenko wrote:
> > > > > > On Wed, Mar 22, 2023 at 12:00:06PM +0000, Russell King (Oracle) wrote:

...

> > > > > > > +	struct fwnode_handle *fwnode;
> > > > > > 
> > > > > > > +	fwnode = of_fwnode_handle(dp->dn);
> > > > > > 
> > > > > > 	const struct fwnode_handle *fwnode = of_fwnode_handle(dp->dn);
> > > > > > 
> > > > > > ?
> > > > > 
> > > > > Why const?
> > > > 
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

I don't disagree, but it can be done as a precursor to your RFC.

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

Yes, and since it's not a big deal it can be done as a precursor work.

> The lack of const-ness that has been there for quite some time is no
> reason to NAK a patch that has nothing to do with this.

Instead of saying politely that you didn't agree of the necessity of the asked
changes, you shoowed your confrontational manner with a strong NAK. Let's not
escalate it further, it won't play well with a nervous system.

> > P.S. Please, move that phy thingy away from property.h, it doesn't belong
> > there.
> 
> Again, that's a subject for a separate patch.
> 
> I will re-post this in due course and ignore your NAK (due to your
> lack of research, and confrontational nature.)

Don't make a drama out of it. Many maintainers are asking for a small cleanups
before applying a feature.

Nevertheless, since I'm neither a net nor a DSA maintainer, I have only thing
to push is to move the PHY APIs out from the property.h. The rest is up to you.

-- 
With Best Regards,
Andy Shevchenko



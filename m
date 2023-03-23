Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924D46C6BBE
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjCWPAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbjCWPA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:00:28 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D851912A;
        Thu, 23 Mar 2023 08:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679583626; x=1711119626;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p1yP5VaKxRh8aNw09SSnNje/p5ZzINNB14cTYNhYeLc=;
  b=SNloEObLSCun2Eo6EjENRT8JmSgWjzzslSc8LKjEFgnUNGkJQGgv2ceb
   Ipu5besLcZUG3NS+SlnxS+oNjGqi8IACvBRYqJXKdzqN9RtXBxnCOBSed
   GCI8kea4OpwDk3yxgacjJeMWW4oHKGIdx99zi67GMshtHL6UT7/xyx1a+
   PJ00Jq5KUhw4hLb9w2YGvPQSTLcM2N/b/rHoq8f9TY1B+3/ftX/QNCcEH
   PjVn+3kLd4uKTXjvJuanmWNI+2W2Ob1K6CMcHRvCHDZypFxHNRm5IdCWo
   NTh1rppr3MOltBXKMOM+ieZkCwRZwIsiwQt4tT1PdXYwx4hJq2kd5LAcJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="323372199"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="323372199"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 08:00:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="746739875"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="746739875"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP; 23 Mar 2023 08:00:11 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pfMQC-007Y3R-2S;
        Thu, 23 Mar 2023 17:00:08 +0200
Date:   Thu, 23 Mar 2023 17:00:08 +0200
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
Message-ID: <ZBxpeLOmTMzqVTRV@smile.fi.intel.com>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
 <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
 <ZBxiqJo470A7bkig@shell.armlinux.org.uk>
 <ZBxkZYXrfugz0gYw@smile.fi.intel.com>
 <ZBxm3XrQAfnmbHoF@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBxm3XrQAfnmbHoF@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 02:49:01PM +0000, Russell King (Oracle) wrote:
> On Thu, Mar 23, 2023 at 04:38:29PM +0200, Andy Shevchenko wrote:
> > On Thu, Mar 23, 2023 at 02:31:04PM +0000, Russell King (Oracle) wrote:
> > > On Thu, Mar 23, 2023 at 04:03:05PM +0200, Andy Shevchenko wrote:
> > > > On Wed, Mar 22, 2023 at 12:00:06PM +0000, Russell King (Oracle) wrote:

...

> > > > > +	struct fwnode_handle *fwnode;
> > > > 
> > > > > +	fwnode = of_fwnode_handle(dp->dn);
> > > > 
> > > > 	const struct fwnode_handle *fwnode = of_fwnode_handle(dp->dn);
> > > > 
> > > > ?
> > > 
> > > Why const?
> > 
> > Do you modify its content on the fly?
> 
> Do you want to litter code with casts to get rid of the const?
> 
> > For fwnode as a basic object type we want to reduce the scope of the possible
> > modifications. If you don't modify and APIs you call do not require non-const
> > object, use const for fwnode.
> 
> Let's start here. We pass this fwnode to fwnode_get_phy_mode():
> 
> include/linux/property.h:int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
> 
> Does fwnode_get_phy_mode() alter the contents of the fwnode? Probably
> not, but it doesn't take a const pointer. Therefore, to declare my
> fwnode as const, I'd need to cast the const-ness away before calling
> this.

So, fix the fwnode_get_phy_mode(). Is it a problem?

> Then there's phylink_create(). Same problem.

So, fix that. Is it a problem?

> So NAK to this const - until such time that we have a concerted effort
> to making functions we call which do not modify the "fwnode" argument
> constify that argument. Otherwise it's just rediculously crazy to
> declare a variable const only to then litter the code with casts to get
> rid of it at every call site.
> 
> Please do a bit of research before making suggestions. Thanks.

So, MAK to your patch. You can fix that, and you know that.

P.S. Please, move that phy thingy away from property.h, it doesn't belong
there.

-- 
With Best Regards,
Andy Shevchenko



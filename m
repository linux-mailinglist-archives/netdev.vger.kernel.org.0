Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3686C6FED
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 19:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjCWSE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 14:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjCWSEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 14:04:54 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC03A270;
        Thu, 23 Mar 2023 11:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679594693; x=1711130693;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t/igcvPmGEkBTn/4UAPcnfoY2ioHhWapkDNqA0L1LpQ=;
  b=N7fKtmt9QK7zOyt/VEIa9+WTWTe6x33PEpzldYkWtRytCmqbt/QL9oC5
   b69bkObHAh74Qh3NxH+CB+jhvLLUn3sTHm+SDJsdyFz3c/sLzOULEJLQR
   il6H7B8piEtm3v7AvXZllgO+PbxsCQJ8Oyy8xvgJhC96gVb3spr3mZcPx
   uDgSplzs/CjDtOTjOYlyBJTgMvolqzz4XIJsUFXMsgU2Zptxp7TonPLN8
   RBcSZZsNKC2GqRr1llHX66hBNZcdgkXZ/pB6qdtAP5xFHR53j9NVXE8ct
   wUeVBz1RmDdG6yRIxJaI9k+8z64uRT046M/VVe8EgSueIOOl7HNVERXXg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="327977712"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="327977712"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 11:04:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="675800262"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="675800262"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga007.jf.intel.com with ESMTP; 23 Mar 2023 11:04:47 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pfPIr-007bN5-1R;
        Thu, 23 Mar 2023 20:04:45 +0200
Date:   Thu, 23 Mar 2023 20:04:45 +0200
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
Message-ID: <ZByUvVGRhpFUYrVq@smile.fi.intel.com>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
 <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
 <ZBxiqJo470A7bkig@shell.armlinux.org.uk>
 <ZBxkZYXrfugz0gYw@smile.fi.intel.com>
 <ZBxm3XrQAfnmbHoF@shell.armlinux.org.uk>
 <ZBxpeLOmTMzqVTRV@smile.fi.intel.com>
 <ZBySKoHh25AMMBVg@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBySKoHh25AMMBVg@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 05:53:46PM +0000, Russell King (Oracle) wrote:
> On Thu, Mar 23, 2023 at 05:00:08PM +0200, Andy Shevchenko wrote:
> > On Thu, Mar 23, 2023 at 02:49:01PM +0000, Russell King (Oracle) wrote:
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
> > 
> > > Then there's phylink_create(). Same problem.
> > 
> > So, fix that. Is it a problem?
> 
> To do both of these creates a five patch series, because there are so
> many things that need to be constified:
> 
> fwnode_get_phy_mode() is the trivial one.
> 
> sfp_bus_find_fwnode(), and the sfp-bus internal fwnode uses.
> 
> fwnode_get_phy_node().
> 
> phylink_create(), phylink_parse_fixedlink(), phylink_parse_mode(),
> phylink_fwnode_phy_connect().
> 
> Hopefully nothing breaks as a result of changing all those - but that
> can hardly be "tacked" on to the start of my series as a trivial
> change - and clearly such a change should _not_ be part of this
> series.

Thank you for doing that!

> Those five patches do not include moving fwnode_get_phy_mode(), whose
> location remains undecided.

No problem, we like iterative work.

-- 
With Best Regards,
Andy Shevchenko



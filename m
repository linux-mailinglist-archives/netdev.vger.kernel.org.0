Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85B76C6B38
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjCWOis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjCWOiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:38:46 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB51E062;
        Thu, 23 Mar 2023 07:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679582326; x=1711118326;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mI4OADSSiI62N+WyiwOKPAYpaQgNtnikwIrzT/dzZ0Y=;
  b=QlDRthpE2tPw3OsmbviKMIWnDNYg+XVr2DFpRQF23yQGnM9ouIDjrmRv
   6M3TLhRuKsp7ZgevWF3uxxMaP0r4qxOp/c0npClD1xPC+ML2DsM2CYfbl
   8t5LsTVKSW9VqsapqhZC/4ZR/KxjBvpjHytmO7EgeOysKN59PZUYerzfz
   D82GspkU40lUTUZTesVV/rG1KsCMQNnmTLaNb1KJ8pBfrneZeby69kIzh
   kZHQKanmy7xtARF6s6Pte4Fq/kBk/chirxF/uMTbCoV0SxzZzW0B2zr1k
   IoqEADgSyKstL174Uj9nXAoJ7C2nMMJKJoWMHM/3YMHJ//jRCJ6OV0m9p
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="323366806"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="323366806"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 07:38:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="714833200"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="714833200"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 23 Mar 2023 07:38:32 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pfM5G-007XdD-10;
        Thu, 23 Mar 2023 16:38:30 +0200
Date:   Thu, 23 Mar 2023 16:38:29 +0200
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
Message-ID: <ZBxkZYXrfugz0gYw@smile.fi.intel.com>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
 <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
 <ZBxiqJo470A7bkig@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBxiqJo470A7bkig@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 02:31:04PM +0000, Russell King (Oracle) wrote:
> On Thu, Mar 23, 2023 at 04:03:05PM +0200, Andy Shevchenko wrote:
> > On Wed, Mar 22, 2023 at 12:00:06PM +0000, Russell King (Oracle) wrote:

...

> > > +	struct fwnode_handle *fwnode;
> > 
> > > +	fwnode = of_fwnode_handle(dp->dn);
> > 
> > 	const struct fwnode_handle *fwnode = of_fwnode_handle(dp->dn);
> > 
> > ?
> 
> Why const?

Do you modify its content on the fly?

For fwnode as a basic object type we want to reduce the scope of the possible
modifications. If you don't modify and APIs you call do not require non-const
object, use const for fwnode.

...

> Why do you want it on one line? The code as written conforms to
> netdev coding standards which as you well know are different from
> the rest of the kernel.

This is up to you. I don't care.


-- 
With Best Regards,
Andy Shevchenko



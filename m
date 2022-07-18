Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6633578B83
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 22:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiGRUJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 16:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbiGRUJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 16:09:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC42B42;
        Mon, 18 Jul 2022 13:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658174945; x=1689710945;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZbT+9aB0j/cIG9R+/zgGzINn4AUswURHEqrlVeDgrwA=;
  b=cBtE/WkXfqmQEoPaT2ipPBrXPosrC7isONzX+W87Gzk6154LcHdQtIfQ
   VzMuWe+OqeMOYetU/jakiCRQGDFU0yUhWGIg9pHc+dhwT86MAuIUoN2jo
   iy38E2Yol+yCRatFXA+M/8Kf9JOrlRvENB2BgG9HQuPYJ8T7vcHuJPAA8
   OzU+LS9yzbMsF+CNJ1z8syHyoh49hcw+0CqoqQ0NRBHTCsp2lCkprp5pL
   PDeXZodW5o1dlj2Llw5H03la/+tx6yKQ3csqd0N1qCHJy3Trr4oMy0Ien
   wBCA74B0UK93Egy8KKLxbtWHv3GPAMVNokY/b7/yk/TZHzyKgnTPlL6ZE
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="348002150"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="348002150"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 13:09:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="723983942"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 13:08:57 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oDX2y-001OTa-2m;
        Mon, 18 Jul 2022 23:08:52 +0300
Date:   Mon, 18 Jul 2022 23:08:52 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 5/6] net: dsa: use swnode fixed-link if using
 default params
Message-ID: <YtW91F42jhhtPj9p@smile.fi.intel.com>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNlE-006e3z-3T@rmk-PC.armlinux.org.uk>
 <YtHJ5rfxZ+icXrkC@smile.fi.intel.com>
 <YtHd3f22AtrIzZ1K@shell.armlinux.org.uk>
 <YtWtjYuQ8aLL64Tg@smile.fi.intel.com>
 <YtWwzwO9gZoR+9T/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtWwzwO9gZoR+9T/@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 08:13:19PM +0100, Russell King (Oracle) wrote:
> On Mon, Jul 18, 2022 at 09:59:25PM +0300, Andy Shevchenko wrote:
> > On Fri, Jul 15, 2022 at 10:36:29PM +0100, Russell King (Oracle) wrote:
> > > On Fri, Jul 15, 2022 at 11:11:18PM +0300, Andy Shevchenko wrote:
> > > > On Fri, Jul 15, 2022 at 05:01:48PM +0100, Russell King (Oracle) wrote:
> > 
> > ...
> > 
> > > > > Co-developed by Vladimir Oltean and myself.
> > > > 
> > > > Why not to use
> > > > 
> > > >   Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > 
> > > Ah, that's an official thing. Thanks.
> > 
> > Yep, it's even documented in Submitting Patches.
> > 
> > ...
> > 
> > > > > +	phy_node = of_parse_phandle(dn, "phy-handle", 0);
> > > > 
> > > > fwnode in the name, why not to use fwnode APIs?
> > > > 
> > > > 	fwnode_find_reference();
> > > 
> > > Marcin has a series converting DSA to use fwnode things - currently DSA
> > > does not support ACPI, so converting it to fwnode doesn't make that much
> > > sese until the proper ACPI patches get merged, which have now been
> > > rebased on this series by Marcin in the expectation that these patches
> > > would be merged... so I don't want to tred on Marcin's feet on that.
> > 
> > But it's normal development process...
> > 
> > Anyway, it seems to me that you are using fwnode out of that (with the
> > exception of one call). To me it looks that you add a work to him, rather
> > than making his life easier, since you know ahead that this is going to be
> > converted.
> 
> No, I didn't know ahead of time until Marcin piped up about it, and
> then we discussed how to resolve the conflict between the two patch
> sets.

But now you know that and since your series is not yet in, back to phase 1,
i.e. "normal development process (with additional coordination required)".

-- 
With Best Regards,
Andy Shevchenko



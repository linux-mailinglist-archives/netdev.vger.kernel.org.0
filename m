Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B63C5789F3
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbiGRS7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbiGRS7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:59:38 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A632B267;
        Mon, 18 Jul 2022 11:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658170777; x=1689706777;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TIEQ4MTYN/3mHVFEK8QSYRaebmDVBch4wfEANQ4Z+F4=;
  b=OdAZMs5/FV9r4rM3kel/TrlnhkFPe49hMTYeGBKjIwHkeEq2hVoxu6sN
   ov8KI5oZYP1m13BZEAG3UYBOKybImL2Cuq0HFUSoxKVUG+FVIv8ayDBsz
   O6SOLBfyAnpdqAt8GufkKSiEgD3EpZjhK+OPzfhIWw3trXG/aHK49AVSi
   Z/rzcf50beDz08rRbgxgRj/bls8kGC4NVBPp4WKAQXTczSwnwdByKE1eC
   Uy95zE1/pvG5L1eV8pUQBjXNRCWBNU5SD4WBqOcTJC0OZsjdcnwyDOfnz
   xhmbThAShT0LJ58bh0dHBmFEittdEeGBsb7+CmG4T5JuSmRA81dXbJorZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287446628"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="287446628"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 11:59:37 -0700
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="700140775"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 11:59:30 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oDVxl-001OP6-31;
        Mon, 18 Jul 2022 21:59:25 +0300
Date:   Mon, 18 Jul 2022 21:59:25 +0300
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
Message-ID: <YtWtjYuQ8aLL64Tg@smile.fi.intel.com>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNlE-006e3z-3T@rmk-PC.armlinux.org.uk>
 <YtHJ5rfxZ+icXrkC@smile.fi.intel.com>
 <YtHd3f22AtrIzZ1K@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtHd3f22AtrIzZ1K@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 10:36:29PM +0100, Russell King (Oracle) wrote:
> On Fri, Jul 15, 2022 at 11:11:18PM +0300, Andy Shevchenko wrote:
> > On Fri, Jul 15, 2022 at 05:01:48PM +0100, Russell King (Oracle) wrote:

...

> > > Co-developed by Vladimir Oltean and myself.
> > 
> > Why not to use
> > 
> >   Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Ah, that's an official thing. Thanks.

Yep, it's even documented in Submitting Patches.

...

> > > +	phy_node = of_parse_phandle(dn, "phy-handle", 0);
> > 
> > fwnode in the name, why not to use fwnode APIs?
> > 
> > 	fwnode_find_reference();
> 
> Marcin has a series converting DSA to use fwnode things - currently DSA
> does not support ACPI, so converting it to fwnode doesn't make that much
> sese until the proper ACPI patches get merged, which have now been
> rebased on this series by Marcin in the expectation that these patches
> would be merged... so I don't want to tred on Marcin's feet on that.

But it's normal development process...

Anyway, it seems to me that you are using fwnode out of that (with the
exception of one call). To me it looks that you add a work to him, rather
than making his life easier, since you know ahead that this is going to be
converted.

-- 
With Best Regards,
Andy Shevchenko



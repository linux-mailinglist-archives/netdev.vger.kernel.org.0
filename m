Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A37F578258
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiGRMaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbiGRMaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:30:05 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E71E13;
        Mon, 18 Jul 2022 05:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658147404; x=1689683404;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iD9MNKwEAKGE0wV7TMV/IgNKE43bbdq4a0RjU1vPlEE=;
  b=cTnEXpCwcIEEIo7knsVt92HIpgsTppO8s66cv3P1oNGW93Dz37hmaojs
   xvwF46g98FUCigWA33hQ/bch8pk132vwNP/sctndMnh35XKP63G+z3+iY
   D1hlkp6dqg23S/rmr13G3tbhqjAxbZIN9+jqrcLN2gso/I+mNwkhxVxT9
   0OlDp+/Esc91huhG5L5duAR89Ic9OdvNWy7hRNqhwlxmL6H+gXN1sNRBD
   Zz2QTaRpzje1Ov5IOahOT76WpWgerxRHp15ipmL45TCMHlEltYpbyjK5C
   9nyyfa7miOsJt37JqXbym51UHktFVW7/dpopIbBf4phePTwHAoBDyVKM7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="286948444"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="286948444"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 05:30:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="655256538"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 05:29:56 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oDPsm-001OAe-1M;
        Mon, 18 Jul 2022 15:29:52 +0300
Date:   Mon, 18 Jul 2022 15:29:52 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
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
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNky-006e3g-KA@rmk-PC.armlinux.org.uk>
 <YtHGwz4v7VWKhIXG@smile.fi.intel.com>
 <20220715201715.foea4rifegmnti46@skbuf>
 <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
 <20220715204841.pwhvnue2atrkc2fx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715204841.pwhvnue2atrkc2fx@skbuf>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 11:48:41PM +0300, Vladimir Oltean wrote:
> On Fri, Jul 15, 2022 at 11:33:40PM +0300, Andy Shevchenko wrote:
> > On Fri, Jul 15, 2022 at 11:17:15PM +0300, Vladimir Oltean wrote:
> > > On Fri, Jul 15, 2022 at 10:57:55PM +0300, Andy Shevchenko wrote:
> > > > On Fri, Jul 15, 2022 at 05:01:32PM +0100, Russell King wrote:
> > > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > > 
> > > > > Allow a named software node to be created, which is needed for software
> > > > > nodes for a fixed-link specification for DSA.
> > > > 
> > > > In general I have no objection, but what's worrying me is a possibility to
> > > > collide in namespace. With the current code the name is generated based on
> > > > unique IDs, how can we make this one more robust?
> > > 
> > > Could you be more clear about the exact concern?
> > 
> > Each software node can be created with a name. The hierarchy should be unique,
> > means that there can't be two or more nodes with the same path (like on file
> > system or more specifically here, Device Tree). Allowing to pass names we may
> > end up with the situation when it will be a path collision. Yet, the static
> > names are easier to check, because one may run `git grep ...` or coccinelle
> > script to see what's in the kernel.
> 
> So won't kobject_init_and_add() fail on namespace collision? Is it the
> problem that it's going to fail, or that it's not trivial to statically
> determine whether it'll fail?
> 
> Sorry, but I don't see something actionable about this.

I'm talking about validation before a runtime. But if you think that is fine,
let's fail it at runtime, okay, and consume more backtraces in the future.

-- 
With Best Regards,
Andy Shevchenko



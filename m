Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A735789B3
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbiGRSnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiGRSny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:43:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA67362D3;
        Mon, 18 Jul 2022 11:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658169834; x=1689705834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KdBF4yjrLuXbz/OvgsIOnMxdr8dPb/kuNCRv0XTho8U=;
  b=QAH8skE1JqPNmP/hePVKZrVFxvdOfaXt8vNNqU5upJPweT5c3O1QrvT1
   OQsO6vP9ih1bKFSHpySK94v8Xt7HQaXu82Qgga9ybLoKWexdwvKpuVlQr
   fIyXIR506pJsiGcMjKsRbbWEL4ZxSPvCsC3dGivNjXeL3EyhPaB65Ihwa
   boasTUhIR6kKvwqF51eUyJ1OvH9h/5+LvBWhel/abhVYasjoT9cDM04Go
   MmXsdojkgezMTsUT+jjVxsnjtotnkTMxpDrovx2GOTLBO9cVhrGgbIJli
   OWdaLjlDc0Hw/0zLq/R+f5bPyVT0HXZ6FmhPOABxJMqZlnJnQ8WhxnGwd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="347984337"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="347984337"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 11:43:54 -0700
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="843374513"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 11:43:46 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oDViY-001OOO-0R;
        Mon, 18 Jul 2022 21:43:42 +0300
Date:   Mon, 18 Jul 2022 21:43:41 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <YtWp3WkpCtfe559l@smile.fi.intel.com>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNky-006e3g-KA@rmk-PC.armlinux.org.uk>
 <YtHGwz4v7VWKhIXG@smile.fi.intel.com>
 <20220715201715.foea4rifegmnti46@skbuf>
 <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
 <20220715204841.pwhvnue2atrkc2fx@skbuf>
 <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
 <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 02:27:02PM +0100, Russell King (Oracle) wrote:
> On Mon, Jul 18, 2022 at 03:29:52PM +0300, Andy Shevchenko wrote:
> > On Fri, Jul 15, 2022 at 11:48:41PM +0300, Vladimir Oltean wrote:
> > > So won't kobject_init_and_add() fail on namespace collision? Is it the
> > > problem that it's going to fail, or that it's not trivial to statically
> > > determine whether it'll fail?
> > > 
> > > Sorry, but I don't see something actionable about this.
> > 
> > I'm talking about validation before a runtime. But if you think that is fine,
> > let's fail it at runtime, okay, and consume more backtraces in the future.
> 
> Is there any sane way to do validation of this namespace before
> runtime?

For statically compiled, I think we can do it (to some extent).
Currently only three drivers, if I'm not mistaken, define software nodes with
names. It's easy to check that their node names are unique.

When you allow such an API then we might have tracebacks (from sysfs) bout name
collisions. Not that is something new to kernel (we have seen many of a kind),
but I prefer, if possible, to validate this before sysfs issues a traceback.

> The problem in this instance is we need a node named "fixed-link" that
> is attached to the parent node as that is defined in the binding doc,
> and we're creating swnodes to provide software generated nodes for
> this binding.

And how you guarantee that it will be only a single one with unique pathname?

For example, you have two DSA cards (or whatever it's called) in the SMP system,
it mean that there is non-zero probability of coexisting swnodes for them.

> There could be several such nodes scattered around, but in this
> instance they are very short-lived before they are destroyed, they
> don't even need to be published to userspace (and its probably a waste
> of CPU cycles for them to be published there.)
> 
> So, for this specific case, is this the best approach, or is there
> some better way to achieve what we need here?

Honestly, I don't know.

The "workaround" (but it looks to me rather a hack) is to create unique swnode
and make fixed-link as a child of it.

Or entire concept of the root swnodes (when name is provided) should be
reconsidered, so somehow we will have a uniqueness so that the entire
path(s) behind it will be caller-dependent. But this I also don't like.

Maybe Heikki, Sakari, Rafael can share their thoughts...

Just for my learning, why PHY uses "fixed-link" instead of relying on a
(firmware) graph? It might be the actual solution to your problem.

How graphs are used with swnodes, you may look into IPU3 (Intel Camera)
glue driver to support devices before MIPI standardisation of the
respective properties.

-- 
With Best Regards,
Andy Shevchenko



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B90578AA5
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbiGRTYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235833AbiGRTYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:24:23 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC152CE2B;
        Mon, 18 Jul 2022 12:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658172262; x=1689708262;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OXqejUTzX+fvce7JjUJhsn70C74RWhXrDYrBi19HgoQ=;
  b=KSRQpvKqGXqvNMZ12mObsPF1RfOKHQG+fR6jp8O88nFOsUvVG3qNr0Tb
   S6Zj3k1aKWaIHfqzxMtVxZivViJt/zGOaXdPKl+FIwkvurs6yecSiufVb
   xey/AVkIhjedsCyeagD+dvVYZ8jRWiTTknOeoypQRB/zgAueohdhm3g0/
   Xlfr8Su4t2rGLPOrPgiMGyfeSCF0V7C3L56SXB3j9lbFHK98pCCKJcMAa
   7/Qp7UgEzciM4StZ7r4ZAwhX50YuqWwWyjFD5AvUfb8SQ7Km2A0WXNmF5
   6IAm4BWaJ5n7s6fSxXAOLbm47cdheJKrQjh5RlvuV0xBNYaxES0T4ElaZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="266708197"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="266708197"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 12:24:22 -0700
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="624860660"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 12:24:14 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oDWLh-001OQH-3C;
        Mon, 18 Jul 2022 22:24:09 +0300
Date:   Mon, 18 Jul 2022 22:24:09 +0300
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
Message-ID: <YtWzWdkFVMg0Hyvf@smile.fi.intel.com>
References: <E1oCNky-006e3g-KA@rmk-PC.armlinux.org.uk>
 <YtHGwz4v7VWKhIXG@smile.fi.intel.com>
 <20220715201715.foea4rifegmnti46@skbuf>
 <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
 <20220715204841.pwhvnue2atrkc2fx@skbuf>
 <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
 <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
 <YtWp3WkpCtfe559l@smile.fi.intel.com>
 <YtWsM1nr2GZWDiEN@smile.fi.intel.com>
 <YtWxMrz3LcVQa43I@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtWxMrz3LcVQa43I@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 08:14:58PM +0100, Russell King (Oracle) wrote:
> On Mon, Jul 18, 2022 at 09:53:39PM +0300, Andy Shevchenko wrote:
> > On Mon, Jul 18, 2022 at 09:43:42PM +0300, Andy Shevchenko wrote:
> > > On Mon, Jul 18, 2022 at 02:27:02PM +0100, Russell King (Oracle) wrote:
> > > > On Mon, Jul 18, 2022 at 03:29:52PM +0300, Andy Shevchenko wrote:
> > > > > On Fri, Jul 15, 2022 at 11:48:41PM +0300, Vladimir Oltean wrote:
> > > > > > So won't kobject_init_and_add() fail on namespace collision? Is it the
> > > > > > problem that it's going to fail, or that it's not trivial to statically
> > > > > > determine whether it'll fail?
> > > > > > 
> > > > > > Sorry, but I don't see something actionable about this.
> > > > > 
> > > > > I'm talking about validation before a runtime. But if you think that is fine,
> > > > > let's fail it at runtime, okay, and consume more backtraces in the future.
> > > > 
> > > > Is there any sane way to do validation of this namespace before
> > > > runtime?
> > > 
> > > For statically compiled, I think we can do it (to some extent).
> > > Currently only three drivers, if I'm not mistaken, define software nodes with
> > > names. It's easy to check that their node names are unique.
> > > 
> > > When you allow such an API then we might have tracebacks (from sysfs) bout name
> > > collisions. Not that is something new to kernel (we have seen many of a kind),
> > > but I prefer, if possible, to validate this before sysfs issues a traceback.
> > > 
> > > > The problem in this instance is we need a node named "fixed-link" that
> > > > is attached to the parent node as that is defined in the binding doc,
> > > > and we're creating swnodes to provide software generated nodes for
> > > > this binding.
> > > 
> > > And how you guarantee that it will be only a single one with unique pathname?
> > > 
> > > For example, you have two DSA cards (or whatever it's called) in the SMP system,
> > > it mean that there is non-zero probability of coexisting swnodes for them.
> > > 
> > > > There could be several such nodes scattered around, but in this
> > > > instance they are very short-lived before they are destroyed, they
> > > > don't even need to be published to userspace (and its probably a waste
> > > > of CPU cycles for them to be published there.)
> > > > 
> > > > So, for this specific case, is this the best approach, or is there
> > > > some better way to achieve what we need here?
> > > 
> > > Honestly, I don't know.
> > > 
> > > The "workaround" (but it looks to me rather a hack) is to create unique swnode
> > > and make fixed-link as a child of it.
> > > 
> > > Or entire concept of the root swnodes (when name is provided) should be
> > > reconsidered, so somehow we will have a uniqueness so that the entire
> > > path(s) behind it will be caller-dependent. But this I also don't like.
> > > 
> > > Maybe Heikki, Sakari, Rafael can share their thoughts...
> > > 
> > > Just for my learning, why PHY uses "fixed-link" instead of relying on a
> > > (firmware) graph? It might be the actual solution to your problem.
> > > 
> > > How graphs are used with swnodes, you may look into IPU3 (Intel Camera)
> > > glue driver to support devices before MIPI standardisation of the
> > > respective properties.
> > 
> > Forgot to say (yes, it maybe obvious) that this API will be exported,
> > anyone can use it and trap into the similar issue, because, for example,
> > of testing in environment with a single instance of the caller.
> 
> I think we're coming to the conclusion that using swnodes is not the
> correct approach for this problem, correct?

If I understand the possibilities of the usage in _this_ case, then it's
would be problematic (it does not mean it's incorrect). It might be due to
swnode design restrictions which shouldn't be made, I dunno. That' why
it's better to ask the others for their opinions.

By design swnode's name makes not much sense, because the payload there
is a property set, where _name_ is a must.

Now, telling you this, I'm questioning myself why the heck I added names
to swnodes in the intel_quark_i2c_gpio driver...

-- 
With Best Regards,
Andy Shevchenko



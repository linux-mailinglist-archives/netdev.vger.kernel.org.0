Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF73578C0B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 22:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiGRUsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 16:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiGRUse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 16:48:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A494230F5F;
        Mon, 18 Jul 2022 13:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658177313; x=1689713313;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Gi29ipHphab6y06j2mvJvTRBDSiD7z2zobQEJWGvcQM=;
  b=mV/sY83NxF2BGU3hEgU2gs9UxMGc5v6oEf171H0zvsy0PwVKHF+3XQg2
   O2xCqo4GNrHlNA2+KGyA5gfucG5u7ktXqbaGwBqUGCK2N9bB2dFzsattf
   uDkyjqIrex8E5jT31/Taipbb0KVnXXf5NAJFCcm68ktoVQenesprPKPwV
   UyYF7vi0O1SSBR2DkD4Kk5D2e/jU+q6AerbwXxN8RCjvYKa025ob4I9Qv
   4qpULoLBes15LJPpUJbwV0gWmANLYHC8A3xUbskaNFsS2xDR+tiy61Bj5
   CAnFBJIa4/nLu8CWYWdSyP2Sx4gp/aYQWTm7PTphTfu88h8HkERIWbJpq
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="283884268"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="283884268"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 13:48:33 -0700
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="843407801"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 13:48:26 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oDXfC-001OVf-0d;
        Mon, 18 Jul 2022 23:48:22 +0300
Date:   Mon, 18 Jul 2022 23:48:21 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
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
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <YtXHFQqB3M5Picdl@smile.fi.intel.com>
References: <20220715201715.foea4rifegmnti46@skbuf>
 <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
 <20220715204841.pwhvnue2atrkc2fx@skbuf>
 <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
 <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
 <YtWp3WkpCtfe559l@smile.fi.intel.com>
 <YtWsM1nr2GZWDiEN@smile.fi.intel.com>
 <YtWxMrz3LcVQa43I@shell.armlinux.org.uk>
 <YtWzWdkFVMg0Hyvf@smile.fi.intel.com>
 <20220718223942.245f29b6@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220718223942.245f29b6@thinkpad>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 10:39:42PM +0200, Marek Behún wrote:
> On Mon, 18 Jul 2022 22:24:09 +0300
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > On Mon, Jul 18, 2022 at 08:14:58PM +0100, Russell King (Oracle) wrote:
> > > On Mon, Jul 18, 2022 at 09:53:39PM +0300, Andy Shevchenko wrote:  
> > > > On Mon, Jul 18, 2022 at 09:43:42PM +0300, Andy Shevchenko wrote:  
> > > > > On Mon, Jul 18, 2022 at 02:27:02PM +0100, Russell King (Oracle) wrote:  
> > > > > > On Mon, Jul 18, 2022 at 03:29:52PM +0300, Andy Shevchenko wrote:  
> > > > > > > On Fri, Jul 15, 2022 at 11:48:41PM +0300, Vladimir Oltean wrote:  
> > > > > > > > So won't kobject_init_and_add() fail on namespace collision? Is it the
> > > > > > > > problem that it's going to fail, or that it's not trivial to statically
> > > > > > > > determine whether it'll fail?
> > > > > > > > 
> > > > > > > > Sorry, but I don't see something actionable about this.  
> > > > > > > 
> > > > > > > I'm talking about validation before a runtime. But if you think that is fine,
> > > > > > > let's fail it at runtime, okay, and consume more backtraces in the future.  
> > > > > > 
> > > > > > Is there any sane way to do validation of this namespace before
> > > > > > runtime?  
> > > > > 
> > > > > For statically compiled, I think we can do it (to some extent).
> > > > > Currently only three drivers, if I'm not mistaken, define software nodes with
> > > > > names. It's easy to check that their node names are unique.
> > > > > 
> > > > > When you allow such an API then we might have tracebacks (from sysfs) bout name
> > > > > collisions. Not that is something new to kernel (we have seen many of a kind),
> > > > > but I prefer, if possible, to validate this before sysfs issues a traceback.
> > > > >   
> > > > > > The problem in this instance is we need a node named "fixed-link" that
> > > > > > is attached to the parent node as that is defined in the binding doc,
> > > > > > and we're creating swnodes to provide software generated nodes for
> > > > > > this binding.  
> > > > > 
> > > > > And how you guarantee that it will be only a single one with unique pathname?
> > > > > 
> > > > > For example, you have two DSA cards (or whatever it's called) in the SMP system,
> > > > > it mean that there is non-zero probability of coexisting swnodes for them.
> > > > >   
> > > > > > There could be several such nodes scattered around, but in this
> > > > > > instance they are very short-lived before they are destroyed, they
> > > > > > don't even need to be published to userspace (and its probably a waste
> > > > > > of CPU cycles for them to be published there.)
> > > > > > 
> > > > > > So, for this specific case, is this the best approach, or is there
> > > > > > some better way to achieve what we need here?  
> > > > > 
> > > > > Honestly, I don't know.
> > > > > 
> > > > > The "workaround" (but it looks to me rather a hack) is to create unique swnode
> > > > > and make fixed-link as a child of it.
> > > > > 
> > > > > Or entire concept of the root swnodes (when name is provided) should be
> > > > > reconsidered, so somehow we will have a uniqueness so that the entire
> > > > > path(s) behind it will be caller-dependent. But this I also don't like.
> > > > > 
> > > > > Maybe Heikki, Sakari, Rafael can share their thoughts...
> > > > > 
> > > > > Just for my learning, why PHY uses "fixed-link" instead of relying on a
> > > > > (firmware) graph? It might be the actual solution to your problem.
> > > > > 
> > > > > How graphs are used with swnodes, you may look into IPU3 (Intel Camera)
> > > > > glue driver to support devices before MIPI standardisation of the
> > > > > respective properties.  
> > > > 
> > > > Forgot to say (yes, it maybe obvious) that this API will be exported,
> > > > anyone can use it and trap into the similar issue, because, for example,
> > > > of testing in environment with a single instance of the caller.  
> > > 
> > > I think we're coming to the conclusion that using swnodes is not the
> > > correct approach for this problem, correct?  
> > 
> > If I understand the possibilities of the usage in _this_ case, then it's
> > would be problematic (it does not mean it's incorrect). It might be due to
> > swnode design restrictions which shouldn't be made, I dunno. That' why
> > it's better to ask the others for their opinions.
> > 
> > By design swnode's name makes not much sense, because the payload there
> > is a property set, where _name_ is a must.
> > 
> > Now, telling you this, I'm questioning myself why the heck I added names
> > to swnodes in the intel_quark_i2c_gpio driver...
> 
> 1. the way we use this new named swnode (in patch 5/6 of this series) is
>    that it gets destroyed immediately after being parsed, so I don't
>    think there will be collisions in the namespace for forseeable future
> 
>    also, we first create an unnamed swnode for port and only then
>    fixed-link swnode as a child.
> 
>       new_port_fwnode = fwnode_create_software_node(port_props, NULL);
>       ...
>       fixed_link_fwnode =
>         fwnode_create_named_software_node(fixed_link_props,
>                                           new_port_fwnode, "fixed-link");
> 
>    so there shouldn't be a name collision, since the port node gets a
>    unique name, or am I misunderstanding this?

This is not problem, but what I was talking about is how to guarantee this
hierarchy? See what I answered to RNK.

> 2. even if there was a problem with name collision, I think the place
>    that needs to be fixed is swnode system. What use are swnodes if
>    they cannot be used like this?

Precisely, that's why I don't want to introduce an API that needs to be fixed.

-- 
With Best Regards,
Andy Shevchenko



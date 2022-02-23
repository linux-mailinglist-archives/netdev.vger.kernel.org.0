Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2837E4C15AB
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241709AbiBWOsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiBWOsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:48:10 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6A5B45BD;
        Wed, 23 Feb 2022 06:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645627662; x=1677163662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=BkHybutatV6vUyGz3nWn+QmzS5y/pmABztKKcic8BMk=;
  b=aJrmeSqIL57jpznpZUAoULcFs2MWVCtB5+bZ4Isy7gnuUdMIb/TdjlIm
   Cb5YFg3co+32N3AqN7a3DZF0diwpJw5uhWYnbpfHpQUyrVm1D9eNjDwEN
   ckAjkSidbgrQmTN8MtvuOsupbsHEAGlMyDA399I3K/plHPafKegReHJd/
   LsOhSz7MIySbCtjwiDiXnjt/nHZmzKtxMbzjgjCizTTzdTgp79PrT4TNz
   mGJp7iJ6qxA3fOY6fAAyPwB1ROEIav+IG9GUk9VNJzOB/9n7ppu9rHWjt
   vih28bR/U5hDkeN+qthtsOFYKegW+e9IhxoQxioaM2X9XdDgKX4+lyBEO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="312694401"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="312694401"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 06:47:42 -0800
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="707054244"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 06:47:37 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMsuk-007Sjr-5L;
        Wed, 23 Feb 2022 16:46:46 +0200
Date:   Wed, 23 Feb 2022 16:46:45 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Enrico Weigelt <info@metux.net>
Cc:     Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <YhZI1XImMNJgzORb@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <YhPOxL++yhNHh+xH@smile.fi.intel.com>
 <20220222173019.2380dcaf@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220222173019.2380dcaf@fixe.home>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 05:30:19PM +0100, Clément Léger wrote:
> Le Mon, 21 Feb 2022 19:41:24 +0200,
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :

> > > We thought about adding CONFIG_OF to x86 and potentially describe this
> > > card using device-tree overlays but it introduce other problems that
> > > also seems difficult to solve (overlay loading without base
> > > device-tree, fixup of IRQs, adresses, and so on) and CONFIG_OF is not
> > > often enabled on x86 to say the least.  
> > 
> > Why it can't be described by SSDT overlay (if the x86 platform in question is
> > ACPI based)?
> 
> This devices uses a SoC for which drivers are already available but are
> meant to be used by a device-tree description. These drivers uses the
> following subsystems:
> - reset (no ACPI support ?)
> - clk (no ACPI support ?)
> - pinctrl (no ACPI support ?)
> - syscon (no ACPI support ?)
> - gpio
> - phy
> - mdio
> 
> Converting existing OF support to fwnode support and thus allowing
> drivers and subsystems to be compatible with software nodes seemed like
> the easiest way to do what I needed by keeping all existing drivers.
> With this support, the driver is completely self-contained and does
> allow the card to be plugged on whatever platform the user may have.

I agree with Hans on the point that converting to / supporting fwnode is
a good thing by its own.

> Again, the PCI card is independent of the platform, I do not really see
> why it should be described using platform description language.

Yep, and that why it should cope with the platforms it's designed to be used
with.

> > > This series introduce a number of changes in multiple subsystems to
> > > allow registering and using devices that are described with a
> > > software_node description attached to a mfd_cell, making them usable
> > > with the fwnode API. It was needed to modify many subsystem where
> > > CONFIG_OF was tightly integrated through the use of of_xlate()
> > > functions and other of_* calls. New calls have been added to use fwnode
> > > API and thus be usable with a wider range of nodes. Functions that are
> > > used to get the devices (pinctrl_get, clk_get and so on) also needed
> > > to be changed to use the fwnode API internally.
> > > 
> > > For instance, the clk framework has been modified to add a
> > > fwnode_xlate() callback and a new named fwnode_clk_add_hw_provider()
> > > has been added. This function will register a clock using
> > > fwnode_xlate() callback. Note that since the fwnode API is compatible
> > > with devices that have a of_node member set, it will still be possible
> > > to use the driver and get the clocks with CONFIG_OF enabled
> > > configurations.  
> > 
> > How does this all is compatible with ACPI approaches?
> > I mean we usually do not reintroduce 1:1 DT schemas in ACPI.
> 
> For the moment, I only added fwnode API support as an alternative to
> support both OF and software nodes. ACPI is not meant to be handled by
> this code "as-is". There is for sure some modifications to be made and
> I do not know how clocks are handled when using ACPI. Based on some
> thread dating back to 2018 [1], it seem it was even not supported at
> all.
> 
> To be clear, I added the equivalent of the OF support but using
> fwnode API because I was interested primarly in using it with software
> nodes and still wanted OF support to work. I did not planned it to be
> "ACPI compliant" right now since I do not have any knowledge in that
> field.

And here is the problem. We have a few different resource providers
(a.k.a. firmware interfaces) which we need to cope with.

What is going on in this series seems to me quite a violation of the
layers and technologies. But I guess you may find a supporter of your
ideas (I mean Enrico). However, I'm on the other side and do not like
this approach.

> > I think the CCF should be converted to use fwnode APIs and meanwhile
> > we may discuss how to deal with clocks on ACPI platforms, because
> > it may be a part of the power management methods.
> 
> Ok, before going down that way, should the fwnode support be the "only"
> one, ie remove of_clk_register and others and convert them to
> fwnode_clk_register for instance or should it be left to avoid
> modifying all clock drivers ?

IRQ domain framework decided to cohabit both, while deprecating the OF one.
(see "add" vs. "create" APIs there). I think it's a sane choice.

> > > In some subsystems, it was possible to keep OF related function by
> > > wrapping the fwnode ones. It is not yet sure if both support
> > > (device-tree and fwnode) should still continue to coexists. For instance
> > > if fwnode_xlate() and of_xlate() should remain since the fwnode version
> > > also supports device-tree. Removing of_xlate() would of course require
> > > to modify all drivers that uses it.
> > > 
> > > Here is an excerpt of the lan966x description when used as a PCIe card.
> > > The complete description is visible at [2]. This part only describe the
> > > flexcom controller and the fixed-clock that is used as an input clock.
> > > 
> > > static const struct property_entry ddr_clk_props[] = {
> > >         PROPERTY_ENTRY_U32("clock-frequency", 30000000),  
> > 
> > >         PROPERTY_ENTRY_U32("#clock-cells", 0),  
> > 
> > Why this is used?
> 
> These props actually describes a fixed-clock properties. When adding
> fwnode support to clk framework, it was needed to add the
> equivalent of of_xlate() for fwnode (fwnode_xlate()). The number of
> cells used to describe a reference is still needed to do the
> translation using fwnode_property_get_reference_args() and give the
> correct arguments to fwnode_xlate().

What you described is the programming (overkilled) point. But does hardware
needs this? I.o.w. does it make sense in the _hardware_ description?

> [1]
> https://lore.kernel.org/lkml/914341e7-ca94-054d-6127-522b745006b4@arm.com/T/

-- 
With Best Regards,
Andy Shevchenko



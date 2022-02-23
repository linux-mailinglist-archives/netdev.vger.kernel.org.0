Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49BF4C16B3
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242010AbiBWP0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbiBWP0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:26:02 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8F047541;
        Wed, 23 Feb 2022 07:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645629934; x=1677165934;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Pv6qoeuRRxG1BKg3CrjndNCfYi5xjha5hFmmaSyl8u4=;
  b=Op/5E9j9ZDmwBLhtrIub4rlxfGN6nRZrD1wMMSIex1AjXhJXQtJVD7L+
   RPoskfu89eu8CCUci7zCY7ZOlt6h5a9MBbTRPsX7cNGgqjk231BjJoRUz
   sUr0SMdgmTIV0TUQdXH80n9yr+i0uUb6aturQSPliPG+rvKspFVSSbhsP
   D4F0nu5WCziRRkJTZHSKoFlnX5JRm+wKzQW5pyyHzXe0KKnNA7r1HXvuv
   bm99jqfDgHlKw23vo1fXt9MRfbPPDLTw4FDF7w2mH9psYj6KYGzqDvSMo
   ZhU8H6TPNV+AmftpCmpf3sUC6omwKM4pfL3DFVClfGqhI0noZDrGzAPfo
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="338425242"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="338425242"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 07:25:34 -0800
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="491231866"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 07:25:29 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMtVN-007TS8-TO;
        Wed, 23 Feb 2022 17:24:37 +0200
Date:   Wed, 23 Feb 2022 17:24:37 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Mark Brown <broonie@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Enrico Weigelt <info@metux.net>,
        Daniel Scally <djrscally@gmail.com>,
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
Message-ID: <YhZRtads7MGzPEEL@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <YhPOxL++yhNHh+xH@smile.fi.intel.com>
 <20220222173019.2380dcaf@fixe.home>
 <YhZI1XImMNJgzORb@smile.fi.intel.com>
 <20220223161150.664aa5e6@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220223161150.664aa5e6@fixe.home>
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

On Wed, Feb 23, 2022 at 04:11:50PM +0100, Clément Léger wrote:
> Le Wed, 23 Feb 2022 16:46:45 +0200,
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :

...

> > > Again, the PCI card is independent of the platform, I do not really see
> > > why it should be described using platform description language.  
> > 
> > Yep, and that why it should cope with the platforms it's designed to be used
> > with.
> 
> I don't think PCIe card manufacturer expect them to be used solely on a
> x86 platform with ACPI. So why should I used ACPI to describe it (or DT
> by the way), that's my point.

Because you want it to be used on x86 platforms. On the rest it needs DT
or whatever is required by those platforms (I dunno about Zephyr RTOS, or
VxWorks, or *BSDs).

...

> > > For the moment, I only added fwnode API support as an alternative to
> > > support both OF and software nodes. ACPI is not meant to be handled by
> > > this code "as-is". There is for sure some modifications to be made and
> > > I do not know how clocks are handled when using ACPI. Based on some
> > > thread dating back to 2018 [1], it seem it was even not supported at
> > > all.
> > > 
> > > To be clear, I added the equivalent of the OF support but using
> > > fwnode API because I was interested primarly in using it with software
> > > nodes and still wanted OF support to work. I did not planned it to be
> > > "ACPI compliant" right now since I do not have any knowledge in that
> > > field.  
> > 
> > And here is the problem. We have a few different resource providers
> > (a.k.a. firmware interfaces) which we need to cope with.
> 
> Understood that but does adding fwnode support means it should work
> as-is with both DT and ACPI ? ACPI code is still in place and only the
> of part was converted. But maybe you expect the fwnode prot to be
> conformant with ACPI.

Not only me, I believe Mark also was against using pure DT approach on
ACPI enabled platforms.

...

> > What is going on in this series seems to me quite a violation of the
> > layers and technologies. But I guess you may find a supporter of your
> > ideas (I mean Enrico). However, I'm on the other side and do not like
> > this approach.
> 
> As I said in the cover-letter, this approach is the only one that I did
> found acceptable without being tied to some firmware description. If you
> have another more portable approach, I'm ok with that. But this
> solution should ideally work with pinctrl, gpio, clk, reset, phy, i2c,
> i2c-mux without rewriting half of the code. And also allows to easily
> swap the PCIe card to other slots/computer without having to modify the
> description.

My proposal is to use overlays that card provides with itself.
These are supported mechanisms by Linux kernel.

...

> > > > > static const struct property_entry ddr_clk_props[] = {
> > > > >         PROPERTY_ENTRY_U32("clock-frequency", 30000000),    
> > > >   
> > > > >         PROPERTY_ENTRY_U32("#clock-cells", 0),    
> > > > 
> > > > Why this is used?  
> > > 
> > > These props actually describes a fixed-clock properties. When adding
> > > fwnode support to clk framework, it was needed to add the
> > > equivalent of of_xlate() for fwnode (fwnode_xlate()). The number of
> > > cells used to describe a reference is still needed to do the
> > > translation using fwnode_property_get_reference_args() and give the
> > > correct arguments to fwnode_xlate().  
> > 
> > What you described is the programming (overkilled) point. But does hardware
> > needs this? I.o.w. does it make sense in the _hardware_ description?
> 
> This does not makes sense for the hardware of course. It also does not
> makes sense for the hardware to provide that in the device-tree though.

How it can be discovered and enumerated without a hint? And under hint
we may understand, in particular, the overlay blob.

> I actually think this should be only provided by the drivers but it
> might be difficult to parse the descriptions then (either DT or
> software_node), at least that's how it works right now.

-- 
With Best Regards,
Andy Shevchenko



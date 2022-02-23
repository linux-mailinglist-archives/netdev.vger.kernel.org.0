Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB4A4C1587
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241658AbiBWOib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235883AbiBWOia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:38:30 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F2A4BFC9;
        Wed, 23 Feb 2022 06:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645627082; x=1677163082;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZrtkatlHEX8TrOAncGqCt3HfwjC0OWdY0TpW7ZrDiNo=;
  b=lKD3blN6P7WQQoRVM53f/E+cDOFfaNxBEz8sMtTon+HsoeQRo5WB+k72
   uoP8/G/i1yzHK7aV7/QyutIEZVjQAmP5vyeS8TBI43X+br9fPY5NyU51b
   Y6rT4b5cFQZP7tdxw9bcyp8qxxzKqgWSAyhDKzymzpCLlY9j/FoVwHKbR
   brqcAm3Exc7t6q52oXbIrlQ+x1D339uKDChjoOpRzNXSxKn0Q6G61LS9/
   iAn6jl84nvVN+J/bDulgNkEjh6jeH2Nt7ezL6MCxs3kdaM1EsKz2dj523
   Rn1etJ1UNMHqpwQwzsCob/3dsKtei202SI1dRveCXa+Zy0nqpYVo+yhq2
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="235484596"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="235484596"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 06:38:01 -0800
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="639327488"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 06:37:57 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMslN-007SYd-JO;
        Wed, 23 Feb 2022 16:37:05 +0200
Date:   Wed, 23 Feb 2022 16:37:05 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Message-ID: <YhZGkZNAaXNPBRbf@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-11-clement.leger@bootlin.com>
 <YhPSkz8+BIcdb72R@smile.fi.intel.com>
 <20220222142513.026ad98c@fixe.home>
 <YhYZAc5+Q1rN3vhk@smile.fi.intel.com>
 <888f9f1a-ca5a-1250-1423-6c012ec773e2@redhat.com>
 <YhYriwvHJKjrDQRf@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YhYriwvHJKjrDQRf@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 12:41:47PM +0000, Russell King (Oracle) wrote:
> On Wed, Feb 23, 2022 at 01:02:23PM +0100, Hans de Goede wrote:
> > On 2/23/22 12:22, Andy Shevchenko wrote:
> > > On Tue, Feb 22, 2022 at 02:25:13PM +0100, Clément Léger wrote:
> > >> Le Mon, 21 Feb 2022 19:57:39 +0200,
> > >> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :
> > >>> On Mon, Feb 21, 2022 at 05:26:52PM +0100, Clément Léger wrote:
> > >>>> Add support to retrieve a i2c bus in sfp with a fwnode. This support
> > >>>> is using the fwnode API which also works with device-tree and ACPI.
> > >>>> For this purpose, the device-tree and ACPI code handling the i2c
> > >>>> adapter retrieval was factorized with the new code. This also allows
> > >>>> i2c devices using a software_node description to be used by sfp code.  
> > >>>
> > >>> If I'm not mistaken this patch can even go separately right now, since all used
> > >>> APIs are already available.
> > >>
> > >> This patches uses fwnode_find_i2c_adapter_by_node() which is introduced
> > >> by "i2c: fwnode: add fwnode_find_i2c_adapter_by_node()" but they can
> > >> probably be contributed both in a separate series.
> > > 
> > > I summon Hans into the discussion since I remember he recently refactored
> > > a bit I2C (ACPI/fwnode) APIs. Also he might have an idea about entire big
> > > picture approach with this series based on his ACPI experience.
> > 
> > If I understand this series correctly then this is about a PCI-E card
> > which has an I2C controller on the card and behind that I2C-controller
> > there are a couple if I2C muxes + I2C clients.
> 
> That is what I gathered as well.
> 
> > Assuming I did understand the above correctly. One alternative would be
> > to simply manually instantiate the I2C muxes + clients using
> > i2c_new_client_device(). But I'm not sure if i2c_new_client_device()
> > will work for the muxes without adding some software_nodes which
> > brings us back to something like this patch-set.
> 
> That assumes that an I2C device is always present, which is not always
> the case - there are hot-pluggable devices on I2C buses.
> 
> Specifically, this series includes pluggable SFP modules, which fall
> into this category of "hot-pluggable I2C devices" - spanning several
> bus addresses (0x50, 0x51, 0x56). 0x50 is EEPROM like, but not quite
> as the top 128 bytes is paged and sometimes buggy in terms of access
> behaviour. 0x51 contains a bunch of monitoring and other controls
> for the module which again can be paged. At 0x56, there may possibly
> be some kind of device that translates I2C accesses to MDIO accesses
> to access a PHY onboard.
> 
> Consequently, the SFP driver and MDIO translation layer wants access to
> the I2C bus, rather than a device.
> 
> Now, before ARM was converted to DT, we had ways to cope with
> non-firmware described setups like this by using platform devices and
> platform data. Much of that ended up deprecated, because - hey - DT
> is great and more modern and the old way is disgusting and we want to
> get rid of it.
> 
> However, that approach locks us into describing stuff in firmware,
> which is unsuitable when something like this comes along.

Looks like this is a way to reinvent what FPGA should cope with already.
And if I remember correctly the discussions about PCIe FPGAs (from 2016,
though) the idea is that FPGA should have provided a firmware description
with itself. I.o.w. If we are talking about "run-time configurable"
devices they should provide a way to bring their description to the
system.

The currently available way to do it is to get this from EEPROM / ROM
specified on the hardware side in form of DT and ACPI blobs (representing
overlays). Then the only part that is missed (at least for ACPI case) is
to dynamically insert that based on the PCI BDF of the corresponding
PCI bridge.

TL;DR: In my opinion such hardware must bring the description with itself
in case it uses non-enumerable busses, such as SPI, I²C.

I dunno what was the last development in this area for FPGAs cases.

-- 
With Best Regards,
Andy Shevchenko



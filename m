Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CF230A8F6
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 14:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhBANl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 08:41:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231259AbhBANlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 08:41:55 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l6ZRz-003dWk-9a; Mon, 01 Feb 2021 14:41:07 +0100
Date:   Mon, 1 Feb 2021 14:41:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Ahern <dsahern@gmail.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Roopa Prabhu <roopa@nvidia.com>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <YBgE84Qguek7r27t@lunn.ch>
References: <YBF1SmecdzLOgSIl@lunn.ch>
 <20210128081434.GV3565223@nanopsycho.orion>
 <YBLHaagSmqqUVap+@lunn.ch>
 <20210129072015.GA4652@nanopsycho.orion>
 <YBQujIdnFtEhWqTF@lunn.ch>
 <DM6PR12MB389878422F910221DB296DC2AFB99@DM6PR12MB3898.namprd12.prod.outlook.com>
 <YBRGj5Shy+qpUUgS@lunn.ch>
 <20210130141952.GB4652@nanopsycho.orion>
 <251d1e12-1d61-0922-31f8-a8313f18f194@gmail.com>
 <20210201081641.GC4652@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201081641.GC4652@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 09:16:41AM +0100, Jiri Pirko wrote:
> Sun, Jan 31, 2021 at 06:09:24PM CET, dsahern@gmail.com wrote:
> >On 1/30/21 7:19 AM, Jiri Pirko wrote:
> >> Fri, Jan 29, 2021 at 06:31:59PM CET, andrew@lunn.ch wrote:
> >>>> Platform line card driver is aware of line card I2C topology, its
> >>>> responsibility is to detect line card basic hardware type, create I2C
> >>>> topology (mux), connect all the necessary I2C devices, like hotswap
> >>>> devices, voltage and power regulators devices, iio/a2d devices and line
> >>>> card EEPROMs, creates LED instances for LED located on a line card, exposes
> >>>> line card related attributes, like CPLD and FPGA versions, reset causes,
> >>>> required powered through line card hwmon interface.
> >>>
> >>> So this driver, and the switch driver need to talk to each other, so
> >>> the switch driver actually knows what, if anything, is in the slot.
> >> 
> >> Not possible in case the BMC is a different host, which is common
> >> scenario.
> >> 
> >
> >User provisions a 4 port card, but a 2 port card is inserted. How is
> >this detected and the user told the wrong card is inserted?
> 
> The card won't get activated.
> The user won't see the type of inserted linecard. Again, it is not
> possible for ASIC to access the linecard eeprom. See Vadim's reply.
> 
> 
> >
> >If it is not detected that's a serious problem, no?
> 
> That is how it is, unfortunatelly.
> 
> 
> >
> >If it is detected why can't the same mechanism be used for auto
> >provisioning?
> 
> Again, not possible to detect.

If the platform line card driver is running in the host, you can
detect it. From your wording, it sounds like some systems do have this
driver in the host. So please add the needed code.

When the platform line card driver is on the BMC, you need a proxy in
between. Isn't this what IPMI and Redfish is all about? The proxy
driver can offer the same interface as the platform line card driver.

    Andrew

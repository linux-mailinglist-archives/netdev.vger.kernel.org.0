Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA7F3009C9
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbhAVR3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:29:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:29322 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729805AbhAVRNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 12:13:05 -0500
IronPort-SDR: avJ7zOLMX10DdlUu09FWHPMf29Mapoe8xdie2xT8q6sX1OTz4qg8azh3t1/XAT3hwps+wr40U6
 oyHDcnYWOV8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="198233178"
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="198233178"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 09:12:20 -0800
IronPort-SDR: yqnk3jB27YouuRgleyQwzREUrl8c55y4GP7bS5wDjn5bCM+PbC1W/kJLjfowYeSQPfjqW48Wr7
 9v4ATfdIQ8WA==
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="571191463"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 09:12:13 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1l2zzm-009DzL-8d; Fri, 22 Jan 2021 19:13:14 +0200
Date:   Fri, 22 Jan 2021 19:13:14 +0200
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [net-next PATCH v4 09/15] device property: Introduce
 fwnode_get_id()
Message-ID: <YAsHqu/nW3zU/JgO@smile.fi.intel.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-10-calvin.johnson@oss.nxp.com>
 <CAJZ5v0gzdi08fwf0e3NyP1WzuSBk47J5OT5DW_aaUHn_9icfag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0gzdi08fwf0e3NyP1WzuSBk47J5OT5DW_aaUHn_9icfag@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:40:41PM +0100, Rafael J. Wysocki wrote:
> On Fri, Jan 22, 2021 at 4:46 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Using fwnode_get_id(), get the reg property value for DT node
> > or get the _ADR object value for ACPI node.
> 
> So I'm not really sure if this is going to be generically useful.
> 
> First of all, the meaning of the _ADR return value is specific to a
> given bus type (e.g. the PCI encoding of it is different from the I2C
> encoding of it) and it just happens to be matching the definition of
> the "reg" property for this particular binding.

> IOW, not everyone may expect the "reg" property and the _ADR return
> value to have the same encoding and belong to the same set of values,

I have counted three or even four attempts to open code exact this scenario
in the past couple of years. And I have no idea where to put a common base for
them so they will not duplicate this in each case.

> so maybe put this function somewhere closer to the code that's going
> to use it, because it seems to be kind of specific to this particular
> use case?


-- 
With Best Regards,
Andy Shevchenko



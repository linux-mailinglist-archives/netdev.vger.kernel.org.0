Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79802F37DD
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405344AbhALSDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:03:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:8871 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727622AbhALSDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 13:03:33 -0500
IronPort-SDR: /y30fUKi3fy0PsP2L6ib52cAaLwmhepf9j/3kGS0lU2T9cnRGtSV6RHKJGu2EJnnBkwftkJkYH
 w1Xr2Cvs+MQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="174575798"
X-IronPort-AV: E=Sophos;i="5.79,342,1602572400"; 
   d="scan'208";a="174575798"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 10:02:50 -0800
IronPort-SDR: IghNfaeOKkLonEtFV3SlDC2GPc2G7LVoov8V38TT6EAGjGeBDykr49C+0uZnWOi1b/HJT0NDd6
 FpQAlxctiuGQ==
X-IronPort-AV: E=Sophos;i="5.79,342,1602572400"; 
   d="scan'208";a="404557273"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 10:02:42 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1kzO19-00C00S-FU; Tue, 12 Jan 2021 20:03:43 +0200
Date:   Tue, 12 Jan 2021 20:03:43 +0200
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
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
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce
 fwnode_get_id()
Message-ID: <20210112180343.GI4077@smile.fi.intel.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com>
 <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 09:30:31AM -0800, Saravana Kannan wrote:
> On Tue, Jan 12, 2021 at 5:42 AM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Using fwnode_get_id(), get the reg property value for DT node
> > or get the _ADR object value for ACPI node.

...

> > +/**
> > + * fwnode_get_id - Get the id of a fwnode.
> > + * @fwnode: firmware node
> > + * @id: id of the fwnode
> > + *
> > + * This function provides the id of a fwnode which can be either
> > + * DT or ACPI node. For ACPI, "reg" property value, if present will
> > + * be provided or else _ADR value will be provided.
> > + * Returns 0 on success or a negative errno.
> > + */
> > +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> > +{
> > +#ifdef CONFIG_ACPI
> > +       unsigned long long adr;
> > +       acpi_status status;
> > +#endif
> > +       int ret;
> > +
> > +       ret = fwnode_property_read_u32(fwnode, "reg", id);
> > +       if (!(ret && is_acpi_node(fwnode)))
> > +               return ret;
> > +
> > +#ifdef CONFIG_ACPI
> > +       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > +                                      METHOD_NAME__ADR, NULL, &adr);
> > +       if (ACPI_FAILURE(status))
> > +               return -EINVAL;
> > +       *id = (u32)adr;
> > +#endif
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(fwnode_get_id);

> Please don't do it this way. The whole point of fwnode_operations is
> to avoid conditional stuff at the fwnode level.

Not fully true. We have non-POD getters that are conditional. Moreover,
we have additional layer of Primary / Secondary fwnodes on top of that.

The caller of fwnode API is indeed agnostic, but under the hood it differs by
the definition (obviously due to natural differences between ACPI and DT and
whatever else might come in the future.

> Also ACPI and DT
> aren't mutually exclusive if I'm not mistaken.

That's why we try 'reg' property for both cases first.

is_acpi_fwnode() conditional is that what I don't like though.

...

> fwnode is lower level that the device-driver framework.

Agree.

> Making
> it aware of busses like mdio, etc doesn't sound right.

Disagree. Conceptually resource providers can be quite different and fwnode API
*is* LCM for them.

-- 
With Best Regards,
Andy Shevchenko



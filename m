Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FC92FD9D6
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388706AbhATSpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 13:45:44 -0500
Received: from mail-ot1-f46.google.com ([209.85.210.46]:34726 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391982AbhATSTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 13:19:32 -0500
Received: by mail-ot1-f46.google.com with SMTP id a109so24298289otc.1;
        Wed, 20 Jan 2021 10:19:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RfjCq1s0j/dTx5RKp24NHHvH/UNwDWa3zTESuWCm4vc=;
        b=mDE8Iqla1LpEh4hRirQ/VukquO76UAYyO2JXq06S1WGDQJDGsARPGjuqL3bPSGmA91
         WUym30LvO0fsAMJ+FSlS1ZyEauz8XjdL7lT0QkDyOQO4akV9dUKM8sT08zwFGcTY+24D
         /3Kr+lYzD4uk+MaRRJbsiRp/l9P1gDhpyNxSk5/FyCDPCmhhqVyrrfYf6t3GMQUo5UbU
         5wF5E9z5VbZAnbBe+9gZeilPkk+GGvtmyT+wFj9oAR3EcmIY91QnuAQyjztQxiX0ftRc
         /TK7XhXzkFXNmmiO+aiNqsryXo+tbcPScVrt7gLL2wx+dhEi22i7LYl0qP5INRBZ4z8a
         /teQ==
X-Gm-Message-State: AOAM530tfxjvCFXhM3B/sAjeMkZbGxyFfJpTRKAGhEHRjmATveSGfXus
        Ew+QStqbBdw+U5WrG+4NDMCu4oEdoV9r3gzV6wQ=
X-Google-Smtp-Source: ABdhPJxjjx+8/5mn6sTGpsVzrBDqc+mQXtTJzYAmalBqYoJlGkyJBPRpIZxk5vd1pRNG8MwaerzQXe4s0ED0VIkflr0=
X-Received: by 2002:a05:6830:138f:: with SMTP id d15mr1590839otq.321.1611166731213;
 Wed, 20 Jan 2021 10:18:51 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com> <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
 <20210112180343.GI4077@smile.fi.intel.com>
In-Reply-To: <20210112180343.GI4077@smile.fi.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 20 Jan 2021 19:18:39 +0100
Message-ID: <CAJZ5v0iW0jJUcXtiQtLOakkSejZCJD=hTFLL4mvoAN3ZTB+1Tw@mail.gmail.com>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
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
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 7:02 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Tue, Jan 12, 2021 at 09:30:31AM -0800, Saravana Kannan wrote:
> > On Tue, Jan 12, 2021 at 5:42 AM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:
> > >
> > > Using fwnode_get_id(), get the reg property value for DT node
> > > or get the _ADR object value for ACPI node.
>
> ...
>
> > > +/**
> > > + * fwnode_get_id - Get the id of a fwnode.
> > > + * @fwnode: firmware node
> > > + * @id: id of the fwnode
> > > + *
> > > + * This function provides the id of a fwnode which can be either
> > > + * DT or ACPI node. For ACPI, "reg" property value, if present will
> > > + * be provided or else _ADR value will be provided.
> > > + * Returns 0 on success or a negative errno.
> > > + */
> > > +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> > > +{
> > > +#ifdef CONFIG_ACPI
> > > +       unsigned long long adr;
> > > +       acpi_status status;
> > > +#endif
> > > +       int ret;
> > > +
> > > +       ret = fwnode_property_read_u32(fwnode, "reg", id);
> > > +       if (!(ret && is_acpi_node(fwnode)))
> > > +               return ret;
> > > +
> > > +#ifdef CONFIG_ACPI
> > > +       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > > +                                      METHOD_NAME__ADR, NULL, &adr);
> > > +       if (ACPI_FAILURE(status))
> > > +               return -EINVAL;
> > > +       *id = (u32)adr;
> > > +#endif
> > > +       return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(fwnode_get_id);
>
> > Please don't do it this way. The whole point of fwnode_operations is
> > to avoid conditional stuff at the fwnode level.
>
> Not fully true. We have non-POD getters that are conditional. Moreover,
> we have additional layer of Primary / Secondary fwnodes on top of that.
>
> The caller of fwnode API is indeed agnostic, but under the hood it differs by
> the definition (obviously due to natural differences between ACPI and DT and
> whatever else might come in the future.
>
> > Also ACPI and DT
> > aren't mutually exclusive if I'm not mistaken.
>
> That's why we try 'reg' property for both cases first.
>
> is_acpi_fwnode() conditional is that what I don't like though.

I'm not sure what you mean here, care to elaborate?

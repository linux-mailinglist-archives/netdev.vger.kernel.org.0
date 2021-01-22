Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CDB3008E9
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 17:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbhAVQir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:38:47 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]:45440 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729681AbhAVQhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:37:55 -0500
Received: by mail-ot1-f42.google.com with SMTP id n42so5600744ota.12;
        Fri, 22 Jan 2021 08:37:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ziah0gDgjxW52q7hTGscqUGRQaHkOp440j+Y21a5So=;
        b=V7wRvj/6ti3ImPdHhBG2RS7aurp3AKeyeNJoxspfVqhm9s7yuSCgQRslUN+01/93l/
         YpoUfEEtHniTHjYdHbMapN8t+n0AyiaCOPn+2W4MXJphIsgUkdQf1n020jFaI0zQrqyH
         4OTUSaAgX9CUaZztj1XLE7FleXXipW7l99W6HP7XCGpEQIlsWkVv0mbV66irUy4mxrjk
         naK1YwB73BLOuKn7m6r3t3CQ9qR0carnLEQ5JBxyayxBKCIhGtxWP14OTSYPN1TnrARS
         Aoi16dcFBMOhZxZTu4NqJqWiBYuq7xH5Ef4+eSp61kFNYsSyVoKE/Nx/D8c//aQ2Ypnt
         VANg==
X-Gm-Message-State: AOAM530Pf1in5AFmxcHeVZyIblV4DMgsF6FAdx3h28MHVIdRR4zFDjs0
        KfoaI6m+zvv18Es96TR3tEurBu/R0PtZvK68PEPuxsaa
X-Google-Smtp-Source: ABdhPJxNJ2wvRRXdQ/YZlopcgpGZ26D4L7j3Kp5mfxpU0edrQrsmUV3VOk1J3Rk1OEfhRrxRfbJQoDpsNQJvmizZBpw=
X-Received: by 2002:a9d:1710:: with SMTP id i16mr3885403ota.260.1611333263819;
 Fri, 22 Jan 2021 08:34:23 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com> <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
 <20210112180343.GI4077@smile.fi.intel.com> <CAJZ5v0iW0jJUcXtiQtLOakkSejZCJD=hTFLL4mvoAN3ZTB+1Tw@mail.gmail.com>
 <CAHp75VcJS10KMA5amUc36PFgj0FLddj1fXD4dUtuAchrVhhzPg@mail.gmail.com>
 <CAJZ5v0ga5RqwFzbBqSChJ7=gBBM-7dWNQPz6bqvqsNAkWZJ=vQ@mail.gmail.com> <CAGETcx8DP8J53ntxX2VCSnbMfq1qki7gD-md+NC_jVfOkTam3g@mail.gmail.com>
In-Reply-To: <CAGETcx8DP8J53ntxX2VCSnbMfq1qki7gD-md+NC_jVfOkTam3g@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 22 Jan 2021 17:34:12 +0100
Message-ID: <CAJZ5v0gUCUxJX9sGJiZ+zTVYrc3rjuUO2B2fx+O6PewbG7F8aw@mail.gmail.com>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
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
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 9:01 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Wed, Jan 20, 2021 at 11:15 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Wed, Jan 20, 2021 at 7:51 PM Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> > >
> > > On Wed, Jan 20, 2021 at 8:18 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > > On Tue, Jan 12, 2021 at 7:02 PM Andy Shevchenko
> > > > <andy.shevchenko@gmail.com> wrote:
> > > > > On Tue, Jan 12, 2021 at 09:30:31AM -0800, Saravana Kannan wrote:
> > > > > > On Tue, Jan 12, 2021 at 5:42 AM Calvin Johnson
> > > > > > <calvin.johnson@oss.nxp.com> wrote:
> > >
> > > ...
> > >
> > > > > > > +       ret = fwnode_property_read_u32(fwnode, "reg", id);
> > > > > > > +       if (!(ret && is_acpi_node(fwnode)))
> > > > > > > +               return ret;
> > > > > > > +
> > > > > > > +#ifdef CONFIG_ACPI
> > > > > > > +       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > > > > > > +                                      METHOD_NAME__ADR, NULL, &adr);
> > > > > > > +       if (ACPI_FAILURE(status))
> > > > > > > +               return -EINVAL;
> > > > > > > +       *id = (u32)adr;
> > > > > > > +#endif
> > > > > > > +       return 0;
> > >
> > > > > > Also ACPI and DT
> > > > > > aren't mutually exclusive if I'm not mistaken.
> > > > >
> > > > > That's why we try 'reg' property for both cases first.
> > > > >
> > > > > is_acpi_fwnode() conditional is that what I don't like though.
> > > >
> > > > I'm not sure what you mean here, care to elaborate?
> > >
> > > I meant is_acpi_node(fwnode) in the conditional.
> > >
> > > I think it's redundant and we can simple do something like this:
> > >
> > >   if (ret) {
> > > #ifdef ACPI
> > >     ...
> > > #else
> > >     return ret;
> > > #endif
> > >   }
> > >   return 0;
> > >
> > > --
> >
> > Right, that should work.  And I'd prefer it too.
>
> Rafael,
>
> I'd rather this new function be an ops instead of a bunch of #ifdef or
> if (acpi) checks. Thoughts?

Well, it looks more like a helper function than like an op and I'm not
even sure how many potential users of it will expect that _ADR should
be evaluated in the absence of the "reg" property.

It's just that the "reg" property happens to be kind of an _ADR
equivalent in this particular binding AFAICS.

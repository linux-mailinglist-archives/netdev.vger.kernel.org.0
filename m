Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C8F300B94
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbhAVSlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:41:31 -0500
Received: from mail-ot1-f51.google.com ([209.85.210.51]:36049 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729674AbhAVSWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:22:36 -0500
Received: by mail-ot1-f51.google.com with SMTP id v21so5993741otj.3;
        Fri, 22 Jan 2021 10:22:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V/EFH6Ql65NSSTaEnUgoWWm4SDFIF3z/84dTt3kf2To=;
        b=N9d+8dg3mPcCMaYquRiCE23GTgyP/Qdg116Qc46dHvUxbWaiH16JgwOSktclGitwuH
         8YCRqPgMmUHymNjKa9Br8CUcoxPz5wb+u44JqSfYChLjo1TbuHG9C5atbSCWwOq8s41d
         w3FM0SoKDENuvlLqX6mCH7bNModBQt01GoyW6bBZe040O+8Qs4GKIAKe9dmqYrPgmfgV
         sezJ58Ifje7haOJN6GsUyLD13hVk2U5hqwl+1ygSKyk3mykOhaL+Ptd28+SQrBz9CAL1
         WmEkiW8TsyLB7iYAxGsOfqppLfl0K0lJ5VEl+JoGLCf/7AFnEH8VjU+D23QJ/yprdB/V
         y/Ng==
X-Gm-Message-State: AOAM533Izbtbx6aPle8vDCSSO8O5MDEuclFLT3hsoEwk34jd2KeL4w9t
        XkcN1aGRw8UWJjYwwOd027LVvMoyn0c5BjojfPQ=
X-Google-Smtp-Source: ABdhPJxHer9Mezam0M1D2OMTm67UIR4PERwADrgcszaR0liTmmwGY1G3OYFMc1I0mM/FFG11jyQZtqMEan7rOwAXBfE=
X-Received: by 2002:a9d:1710:: with SMTP id i16mr4274123ota.260.1611339715790;
 Fri, 22 Jan 2021 10:21:55 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-10-calvin.johnson@oss.nxp.com> <CAJZ5v0gzdi08fwf0e3NyP1WzuSBk47J5OT5DW_aaUHn_9icfag@mail.gmail.com>
 <YAsHqu/nW3zU/JgO@smile.fi.intel.com> <CAJZ5v0izwiuD+gRmbw=i=DojDMwqOevDQwXArcmq4WyPVrEDfQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0izwiuD+gRmbw=i=DojDMwqOevDQwXArcmq4WyPVrEDfQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 22 Jan 2021 19:21:44 +0100
Message-ID: <CAJZ5v0gtS9P5Hg1JJJ-KPEZ-qSfnMyf4vaCcZ=9HOijky2hc+Q@mail.gmail.com>
Subject: Re: [net-next PATCH v4 09/15] device property: Introduce fwnode_get_id()
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 7:11 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Fri, Jan 22, 2021 at 6:12 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> >
> > On Fri, Jan 22, 2021 at 05:40:41PM +0100, Rafael J. Wysocki wrote:
> > > On Fri, Jan 22, 2021 at 4:46 PM Calvin Johnson
> > > <calvin.johnson@oss.nxp.com> wrote:
> > > >
> > > > Using fwnode_get_id(), get the reg property value for DT node
> > > > or get the _ADR object value for ACPI node.
> > >
> > > So I'm not really sure if this is going to be generically useful.
> > >
> > > First of all, the meaning of the _ADR return value is specific to a
> > > given bus type (e.g. the PCI encoding of it is different from the I2C
> > > encoding of it) and it just happens to be matching the definition of
> > > the "reg" property for this particular binding.
> >
> > > IOW, not everyone may expect the "reg" property and the _ADR return
> > > value to have the same encoding and belong to the same set of values,
> >
> > I have counted three or even four attempts to open code exact this scenario
> > in the past couple of years. And I have no idea where to put a common base for
> > them so they will not duplicate this in each case.
>
> In that case it makes sense to have it in the core, but calling the
> _ADR return value an "id" generically is a stretch to put it lightly.
>
> It may be better to call the function something like
> fwnode_get_local_bus_id()

Or fwnode_get_local_address() for that matter.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDB52FD94E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392244AbhATTQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:16:50 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:42693 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392477AbhATTQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 14:16:27 -0500
Received: by mail-wr1-f42.google.com with SMTP id m4so24132955wrx.9;
        Wed, 20 Jan 2021 11:16:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lHHjUnuoF9CRFeUi11DuMAFbrNISTZnauEeaO/iF4Jo=;
        b=gydQBAMjjbyyqKKDl48HIROuG5msARAyfNgGuuLgrRw1je8qxy5j7qp8I7H+vjt3z3
         B4CeHfbox6JOPOkPyMc9PRL9TnIfuXaBuilT9nVrsIO4fDDYKYT2hIWDxm0f46Mwuvpq
         9qEM0jv70FDCE5TV7ZJSrSoNmucN9AaRpR7EN+4hRaIeffIFELYgYYoXPMQ6RIDEz5z3
         HTXzvQ2vfy3W9F719uCEECVUw/hAtQJXCgecZWXaTYW6CRqa8iG9L6ke0lkXqvsx3KNq
         zeUAxtub+t8LXvbFA+ZhJGIYpb2W/zQS6Fry87RE8Z6YKZWMlS6kRpak1Iy7+J4IaqnN
         1YzA==
X-Gm-Message-State: AOAM530aBsTGj7Q/Nb8E1GE0uaNrbiVMGn2ANh9BTOyVOYjfiUMZS20R
        j1y4qDUjE31/sO594uEB3tMQWTy0f2U6T+jrac8=
X-Google-Smtp-Source: ABdhPJyexTqRRTbwmp5/VB7u2r9ewojCoOLJc1IwN0xo2pOgQvUAZjYUoeFY1P2UQebC0YljtpVYXf80ZqCQK1BVKYU=
X-Received: by 2002:adf:ce84:: with SMTP id r4mr10662902wrn.91.1611170141586;
 Wed, 20 Jan 2021 11:15:41 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com> <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
 <20210112180343.GI4077@smile.fi.intel.com> <CAJZ5v0iW0jJUcXtiQtLOakkSejZCJD=hTFLL4mvoAN3ZTB+1Tw@mail.gmail.com>
 <CAHp75VcJS10KMA5amUc36PFgj0FLddj1fXD4dUtuAchrVhhzPg@mail.gmail.com>
In-Reply-To: <CAHp75VcJS10KMA5amUc36PFgj0FLddj1fXD4dUtuAchrVhhzPg@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 20 Jan 2021 20:15:30 +0100
Message-ID: <CAJZ5v0ga5RqwFzbBqSChJ7=gBBM-7dWNQPz6bqvqsNAkWZJ=vQ@mail.gmail.com>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
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

On Wed, Jan 20, 2021 at 7:51 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Wed, Jan 20, 2021 at 8:18 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > On Tue, Jan 12, 2021 at 7:02 PM Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> > > On Tue, Jan 12, 2021 at 09:30:31AM -0800, Saravana Kannan wrote:
> > > > On Tue, Jan 12, 2021 at 5:42 AM Calvin Johnson
> > > > <calvin.johnson@oss.nxp.com> wrote:
>
> ...
>
> > > > > +       ret = fwnode_property_read_u32(fwnode, "reg", id);
> > > > > +       if (!(ret && is_acpi_node(fwnode)))
> > > > > +               return ret;
> > > > > +
> > > > > +#ifdef CONFIG_ACPI
> > > > > +       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > > > > +                                      METHOD_NAME__ADR, NULL, &adr);
> > > > > +       if (ACPI_FAILURE(status))
> > > > > +               return -EINVAL;
> > > > > +       *id = (u32)adr;
> > > > > +#endif
> > > > > +       return 0;
>
> > > > Also ACPI and DT
> > > > aren't mutually exclusive if I'm not mistaken.
> > >
> > > That's why we try 'reg' property for both cases first.
> > >
> > > is_acpi_fwnode() conditional is that what I don't like though.
> >
> > I'm not sure what you mean here, care to elaborate?
>
> I meant is_acpi_node(fwnode) in the conditional.
>
> I think it's redundant and we can simple do something like this:
>
>   if (ret) {
> #ifdef ACPI
>     ...
> #else
>     return ret;
> #endif
>   }
>   return 0;
>
> --

Right, that should work.  And I'd prefer it too.

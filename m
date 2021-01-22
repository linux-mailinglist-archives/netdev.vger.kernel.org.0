Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7BE300E75
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 22:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbhAVVF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 16:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729907AbhAVU7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 15:59:41 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F23DC0613D6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 12:59:01 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id x6so6784149ybr.1
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 12:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tFBOhDhZE+sffz0l6h3gmZcjhk5QjifXRo2nY423Z8U=;
        b=EltnYhbWOukF5okpdXiW9OaK/D6IEMnbuoQC70nY4erIGhZ1kOk/vJ9OLSs8Kgwsud
         /DhiwEtqJy12ahGMvuwb+wuqRQNgbnmHhSjEUe9vXI/YTfajEz8EdAhHg+6J5TXycfvZ
         TG3X/m4WjMQ7ncBnEPPVSJD9zhH23Yg9le/dNQ9SOzLDk+jMT5qCZA0AUoLZ63uOZy0C
         84ZCmYx7FRbx5aZeFEHes29O+KC7v7piqEnqKgyXCnPUNkul58/qakvGk0hffEyyo98d
         7mFdEsVFFgfsJxZfcxFJtZVoTwy0nt+71QPASazRu3magI4PS6kM1f4YrBb0ure9a2Zx
         a1lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tFBOhDhZE+sffz0l6h3gmZcjhk5QjifXRo2nY423Z8U=;
        b=ghkWCk9Fvhel9A8ejFKLHhuHy+AhUdJLU+axI//ymdld1lXnvPGIzCqHtEDxniRYE0
         me9h11XbckXWfYzPiLc2EfbRdQ6OnmioOqIolmvedv0Wcgn1Sunf1+1aZ4uSCM80ErBi
         DXshXLTpgy7o7rMdUcV3l/aq9oWtV/ljPjXyrSNoAMj3JYWMBD3eHlsX9eO9dJJ+HXci
         jMVnEn1z19sys8eL6dDaLu8+ffatFHAzUDpsh2dRGgfBo0uW49dK6GKb4OlJMhKWgevm
         /0nx/awr2vORserFm8VTJtGnA5bdyaG7vb8AZGFT3RvFfA6IKGiL3nPZ7lRHKW5qKBMB
         OlEA==
X-Gm-Message-State: AOAM533TNBwMNvyCMuPBsny2teLwkN6FkiVbm4Y3XrBsx7Ao3Gh48ONQ
        lulxlWH4Ht0bQ/pW5KdsHp8DiC6i4CGyWtu23AaR9Q==
X-Google-Smtp-Source: ABdhPJxz6BmL17ilwDtkmTNCHLH83w6r5IBrNYbPHVFz4VMv0KgX+SH2FrNiRHxMyDNAIkSS99ID76Oyojyirckz9B0=
X-Received: by 2002:a25:3345:: with SMTP id z66mr9201005ybz.466.1611349140491;
 Fri, 22 Jan 2021 12:59:00 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com> <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
 <20210112180343.GI4077@smile.fi.intel.com> <CAJZ5v0iW0jJUcXtiQtLOakkSejZCJD=hTFLL4mvoAN3ZTB+1Tw@mail.gmail.com>
 <CAHp75VcJS10KMA5amUc36PFgj0FLddj1fXD4dUtuAchrVhhzPg@mail.gmail.com>
 <CAJZ5v0ga5RqwFzbBqSChJ7=gBBM-7dWNQPz6bqvqsNAkWZJ=vQ@mail.gmail.com>
 <CAGETcx8DP8J53ntxX2VCSnbMfq1qki7gD-md+NC_jVfOkTam3g@mail.gmail.com> <CAJZ5v0gUCUxJX9sGJiZ+zTVYrc3rjuUO2B2fx+O6PewbG7F8aw@mail.gmail.com>
In-Reply-To: <CAJZ5v0gUCUxJX9sGJiZ+zTVYrc3rjuUO2B2fx+O6PewbG7F8aw@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 22 Jan 2021 12:58:24 -0800
Message-ID: <CAGETcx-904Cr11nVW6PC=OqWnwM-ZC-DdEUa8+7JmhsH3UOqHw@mail.gmail.com>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
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

On Fri, Jan 22, 2021 at 8:34 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Wed, Jan 20, 2021 at 9:01 PM Saravana Kannan <saravanak@google.com> wrote:
> >
> > On Wed, Jan 20, 2021 at 11:15 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > >
> > > On Wed, Jan 20, 2021 at 7:51 PM Andy Shevchenko
> > > <andy.shevchenko@gmail.com> wrote:
> > > >
> > > > On Wed, Jan 20, 2021 at 8:18 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > > > On Tue, Jan 12, 2021 at 7:02 PM Andy Shevchenko
> > > > > <andy.shevchenko@gmail.com> wrote:
> > > > > > On Tue, Jan 12, 2021 at 09:30:31AM -0800, Saravana Kannan wrote:
> > > > > > > On Tue, Jan 12, 2021 at 5:42 AM Calvin Johnson
> > > > > > > <calvin.johnson@oss.nxp.com> wrote:
> > > >
> > > > ...
> > > >
> > > > > > > > +       ret = fwnode_property_read_u32(fwnode, "reg", id);
> > > > > > > > +       if (!(ret && is_acpi_node(fwnode)))
> > > > > > > > +               return ret;
> > > > > > > > +
> > > > > > > > +#ifdef CONFIG_ACPI
> > > > > > > > +       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > > > > > > > +                                      METHOD_NAME__ADR, NULL, &adr);
> > > > > > > > +       if (ACPI_FAILURE(status))
> > > > > > > > +               return -EINVAL;
> > > > > > > > +       *id = (u32)adr;
> > > > > > > > +#endif
> > > > > > > > +       return 0;
> > > >
> > > > > > > Also ACPI and DT
> > > > > > > aren't mutually exclusive if I'm not mistaken.
> > > > > >
> > > > > > That's why we try 'reg' property for both cases first.
> > > > > >
> > > > > > is_acpi_fwnode() conditional is that what I don't like though.
> > > > >
> > > > > I'm not sure what you mean here, care to elaborate?
> > > >
> > > > I meant is_acpi_node(fwnode) in the conditional.
> > > >
> > > > I think it's redundant and we can simple do something like this:
> > > >
> > > >   if (ret) {
> > > > #ifdef ACPI
> > > >     ...
> > > > #else
> > > >     return ret;
> > > > #endif
> > > >   }
> > > >   return 0;
> > > >
> > > > --
> > >
> > > Right, that should work.  And I'd prefer it too.
> >
> > Rafael,
> >
> > I'd rather this new function be an ops instead of a bunch of #ifdef or
> > if (acpi) checks. Thoughts?
>
> Well, it looks more like a helper function than like an op and I'm not
> even sure how many potential users of it will expect that _ADR should
> be evaluated in the absence of the "reg" property.
>
> It's just that the "reg" property happens to be kind of an _ADR
> equivalent in this particular binding AFAICS.

I agree it is not clear how useful this helper function is going to be.

But in general, to me, any time the wrapper/helper functions in
drivers/base/property.c need to do something like this:

if (ACPI)
   ACPI specific code
if (OF)
   OF specific code

I think the code should be pushed to the fwnode ops. That's one of the
main point of fwnode. So that firmware specific stuff is done by
firmware specific code. Also, when adding support for new firmware,
it's pretty clear what support the firmware needs to implement.
Instead of having to go fix up a bunch of code all over the place.

So fwnode_ops->get_id() would be the OP ACPI and OF would implement.
And then we can have a wrapper in drivers/base/property.c.

-Saravana

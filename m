Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6A42FDA57
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392843AbhATUC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392817AbhATUCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 15:02:35 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9C7C0613C1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 12:01:55 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id k132so13489521ybf.2
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 12:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iIQkHFua75zKVFsuhL/YtTgWQYbFphkYUNhcmtte7cI=;
        b=FntrFOmogvKLljoXUn9c934WUcHRtUiQRvpd1ZiGtPRYhNn82GXlOUvaDhdrrnSMIs
         9Y5JZD0vzWwnq/qt6P/x4m8XCD3c4JaDLhhQQvpq+mIrJu8eaSyfvCUZJI1uTdCBxari
         OTNusp/ISB2xalHx2ROzznYLKWsUj+QxxDT7fbyyzi3UmgYYTBzZ1Q8jdSVvtUUMM0se
         55WaSuNRYtQwtFrFedV9mbw+cArjqgUI8Obcm6DTpaPL+L97/TIxH8G00S/T9jFIkzb5
         itak5MGLNjY70QgK/jGBN8hl+0aXCaMC5HOmtrRRDnXlCc1tx4zfFyv2alxKW0w2PViZ
         3bdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iIQkHFua75zKVFsuhL/YtTgWQYbFphkYUNhcmtte7cI=;
        b=LiuQ+au+SgosLX6CV3lggRQByumACmY5qW4CuncMZFzlN4STzF15UMsux0ECtvDT7Y
         OB9m2YqdZUNJHYjGpoMNleOQTD8POQOWlNruVFYkpHHz4UxpDlrIkLHemA0vCB6swC/6
         TMdsK/tXHcmwL8zwWuksXIg6+HcB+pci66TtRDUv97sftz1n4fokyayXivLrwT+PTZ3j
         VUeKaJum1FSx8qZo1DVXsPZ+HKk6bRK/EdLsH5B/4HBhTTnIlxVfVA1+2seHGd0uDXuH
         c3bwZvPbTNyS4I7MIHCtRhAVm7ZcKBiusR/7pSfR2oJwAeRKAAP0GK46u/K3NLo7ZYzx
         D4YA==
X-Gm-Message-State: AOAM5304BHMd72WX5WH+q/K9E5jTegr14LOQPnM/Dra+l+Nx6RxJJsg8
        JTnBRn+7KI9jf4ls+Ekt/a1DFhO8TtgEljd6RCIlrw==
X-Google-Smtp-Source: ABdhPJyQ1EzGExfijeB9ZWv06Zp1Zx67T2SHjlDixARPP4z/QUBjqg+i2pvxSHfzzfJjgpxj7FLE9HtpYfpcauOGIis=
X-Received: by 2002:a25:c343:: with SMTP id t64mr15648975ybf.228.1611172914565;
 Wed, 20 Jan 2021 12:01:54 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com> <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
 <20210112180343.GI4077@smile.fi.intel.com> <CAJZ5v0iW0jJUcXtiQtLOakkSejZCJD=hTFLL4mvoAN3ZTB+1Tw@mail.gmail.com>
 <CAHp75VcJS10KMA5amUc36PFgj0FLddj1fXD4dUtuAchrVhhzPg@mail.gmail.com> <CAJZ5v0ga5RqwFzbBqSChJ7=gBBM-7dWNQPz6bqvqsNAkWZJ=vQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0ga5RqwFzbBqSChJ7=gBBM-7dWNQPz6bqvqsNAkWZJ=vQ@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 20 Jan 2021 12:01:18 -0800
Message-ID: <CAGETcx8DP8J53ntxX2VCSnbMfq1qki7gD-md+NC_jVfOkTam3g@mail.gmail.com>
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

On Wed, Jan 20, 2021 at 11:15 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Wed, Jan 20, 2021 at 7:51 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> >
> > On Wed, Jan 20, 2021 at 8:18 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > On Tue, Jan 12, 2021 at 7:02 PM Andy Shevchenko
> > > <andy.shevchenko@gmail.com> wrote:
> > > > On Tue, Jan 12, 2021 at 09:30:31AM -0800, Saravana Kannan wrote:
> > > > > On Tue, Jan 12, 2021 at 5:42 AM Calvin Johnson
> > > > > <calvin.johnson@oss.nxp.com> wrote:
> >
> > ...
> >
> > > > > > +       ret = fwnode_property_read_u32(fwnode, "reg", id);
> > > > > > +       if (!(ret && is_acpi_node(fwnode)))
> > > > > > +               return ret;
> > > > > > +
> > > > > > +#ifdef CONFIG_ACPI
> > > > > > +       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > > > > > +                                      METHOD_NAME__ADR, NULL, &adr);
> > > > > > +       if (ACPI_FAILURE(status))
> > > > > > +               return -EINVAL;
> > > > > > +       *id = (u32)adr;
> > > > > > +#endif
> > > > > > +       return 0;
> >
> > > > > Also ACPI and DT
> > > > > aren't mutually exclusive if I'm not mistaken.
> > > >
> > > > That's why we try 'reg' property for both cases first.
> > > >
> > > > is_acpi_fwnode() conditional is that what I don't like though.
> > >
> > > I'm not sure what you mean here, care to elaborate?
> >
> > I meant is_acpi_node(fwnode) in the conditional.
> >
> > I think it's redundant and we can simple do something like this:
> >
> >   if (ret) {
> > #ifdef ACPI
> >     ...
> > #else
> >     return ret;
> > #endif
> >   }
> >   return 0;
> >
> > --
>
> Right, that should work.  And I'd prefer it too.

Rafael,

I'd rather this new function be an ops instead of a bunch of #ifdef or
if (acpi) checks. Thoughts?

-Saravana

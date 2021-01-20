Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF7E2FD94C
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391213AbhATTQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392251AbhATSvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 13:51:54 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB99C061575;
        Wed, 20 Jan 2021 10:51:13 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id x20so2766122pjh.3;
        Wed, 20 Jan 2021 10:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Hs2DcL35t0kl1yCFHjjFssW9wT5FyIR7wKEzzsdbpo=;
        b=dRav0suxujHDPp6A8CK2JWKAEtKakYb5QGn9YEZzwzGCtYrYK14SCri4gnR5bxb+Us
         lGUMCX39l82e11zEbX5HZOfIXR715YY8bU84qeW0W9tmRDo2fT36BlvGcsZry0L3ZPBz
         H4mlxJ0cKy97A6D2uqaBkhs0t4ujUmNSbDvXRAq/VCVNWZtC+tc5lS8ROvv/AW/ZW5Y2
         U4nVx2BBEcO4UBbPiSaPA/DX6cb7UWpZEtVfghF8oqMRhWlmF4C3xdwOjc/snLriUl7X
         rrugv/vNvJGyOnM6ZxNhGyWOLtguohjdDIRgkQY3Vd83pX81q+UP3VjPY9k4wjNCQCoP
         NNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Hs2DcL35t0kl1yCFHjjFssW9wT5FyIR7wKEzzsdbpo=;
        b=TaBDbpB7dJx4r5B7Iq4+h67SXokBvbm8DiECJSqWo4cJPz9+ksybw5qHNi8R3btaIn
         hoX6WX8WJXyc9boPAglN01IoIwOiV8RfX1WqEgps0I4d9lHB+sEsoF/O4b1SSDWBHiTr
         FDNDSOcLACdYpdMBJt5dJVw5hPMPAuW6ZkJkWmytZ/Ic6hqkxb8N3N7TbLUeB6bMMBhq
         5a57E6UAldL0MGuWpspVzX4b+50ZXRKLRqzwGttUj5ewgVxviFVDKGpRyynnle15QnfZ
         XjG9o+LQvouiXVtQ/s+GAADt/EWzHwGc6kx+UuuV8R2T5cHcP0zbfZaeHid1QF+khyRT
         AuKA==
X-Gm-Message-State: AOAM530nOjNIV2a9G9Pp6pSlUIDZfvLyLIlhcztA2CT+/qFIK1DH2X/9
        hXYycWh3mK+6KtGj3riU931MXC2h1xmePtVVdqQ=
X-Google-Smtp-Source: ABdhPJzv8KOKKxqz3FzB3J06cEYWD65UwnYAnvtnchLHoC0Fyy3OdQsBe2nstf01pUlHCsnd7GvQhp0Qu1G3Y8TFe/4=
X-Received: by 2002:a17:90a:1050:: with SMTP id y16mr7368838pjd.181.1611168673398;
 Wed, 20 Jan 2021 10:51:13 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com> <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
 <20210112180343.GI4077@smile.fi.intel.com> <CAJZ5v0iW0jJUcXtiQtLOakkSejZCJD=hTFLL4mvoAN3ZTB+1Tw@mail.gmail.com>
In-Reply-To: <CAJZ5v0iW0jJUcXtiQtLOakkSejZCJD=hTFLL4mvoAN3ZTB+1Tw@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 20 Jan 2021 20:52:02 +0200
Message-ID: <CAHp75VcJS10KMA5amUc36PFgj0FLddj1fXD4dUtuAchrVhhzPg@mail.gmail.com>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>,
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

On Wed, Jan 20, 2021 at 8:18 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> On Tue, Jan 12, 2021 at 7:02 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Tue, Jan 12, 2021 at 09:30:31AM -0800, Saravana Kannan wrote:
> > > On Tue, Jan 12, 2021 at 5:42 AM Calvin Johnson
> > > <calvin.johnson@oss.nxp.com> wrote:

...

> > > > +       ret = fwnode_property_read_u32(fwnode, "reg", id);
> > > > +       if (!(ret && is_acpi_node(fwnode)))
> > > > +               return ret;
> > > > +
> > > > +#ifdef CONFIG_ACPI
> > > > +       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > > > +                                      METHOD_NAME__ADR, NULL, &adr);
> > > > +       if (ACPI_FAILURE(status))
> > > > +               return -EINVAL;
> > > > +       *id = (u32)adr;
> > > > +#endif
> > > > +       return 0;

> > > Also ACPI and DT
> > > aren't mutually exclusive if I'm not mistaken.
> >
> > That's why we try 'reg' property for both cases first.
> >
> > is_acpi_fwnode() conditional is that what I don't like though.
>
> I'm not sure what you mean here, care to elaborate?

I meant is_acpi_node(fwnode) in the conditional.

I think it's redundant and we can simple do something like this:

  if (ret) {
#ifdef ACPI
    ...
#else
    return ret;
#endif
  }
  return 0;

-- 
With Best Regards,
Andy Shevchenko

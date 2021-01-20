Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61472FD9DA
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392111AbhATTbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388689AbhATSpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 13:45:45 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1CBC061795;
        Wed, 20 Jan 2021 10:44:41 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id f63so7241921pfa.13;
        Wed, 20 Jan 2021 10:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4NjDehqz0VgBm2L8y0qfZbDJgiSQ3HAHgeBuj2A8VUE=;
        b=Ew80wgcaPeRu4eGH9QGEtVnTO2VVqb4OOkFIowpw4AhsVGl/lFDyVUG/v6htZyPlYG
         vcZAk29nRUxj1cjXxqLNLywTlTuSkiCKoKN7Ode1kLfXHdpEtXd1qnV8MeRj/Uw0bvea
         zljoRfRy9jUqxrU2KB6s2KTVH+1U478kvx4/sNRjKCM48gwk8eviC1jP62HHOt/TSDOS
         7wq1HCmvqQrVA45t3YkOzUvgxf3hMRFETvFeEBYIi1CdWxs10qaVRxgHQkIXT7mbVcLf
         OB6ci0CoX7/HVOAnmg9q0R01YslgykNumPlJp6ozHV4Q8Wk6KZtadB4oAUnSktIl7ypn
         +eoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4NjDehqz0VgBm2L8y0qfZbDJgiSQ3HAHgeBuj2A8VUE=;
        b=bkOCA83uFtYQnmWu7us9JlRlk772hQGaJf727unbrWsB5hEgGblxKsyE2XAqCQ8qu9
         U7WKUB9UtFPtZlPLB0fc2hAMiVptcuMWEDIA+KZ5d0vy5PDhTh9O1v77RSTiUeFfoXqF
         X+QN6b999JU4MbU0TlA+E6vE52HS7R9xmz9h6MlXomoytn0R1Q3HztQdImr0lPGfx0Wa
         N1i1yBMtNJIYDNDpjDDRyir4pH+Upa2nq3v4iVECXalxI8RIqsuQQz+LeWrrjTBdXq1l
         KH9qafXQdmvWHXTPnvZwSMX/kyFfSTUMzF3x0hkOqWeyuBV/HOeQIu0dmqN7q7Z+FJkA
         LgNQ==
X-Gm-Message-State: AOAM532mW6QeWwHjcvXm2LeO4OsIhSAkpi093G/Hqv/cPhLrBynOVAlo
        tQAiGOLCPAWU3bJt79+5Y3AuyZ8xp/N3RtpMRg4=
X-Google-Smtp-Source: ABdhPJyOxC9DANNKIW3fVJdIGBkotlsd6iFQeUA8RKkDW+/BvfBEPt3uPpSRULwknE4nfSX+6odRLjPBCy+zUwIOi20=
X-Received: by 2002:a65:644b:: with SMTP id s11mr10783324pgv.4.1611168281104;
 Wed, 20 Jan 2021 10:44:41 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com> <CAHp75VdyPWD-cM5Q_9k8yRAutMSjm-3kwE0pQT3+ztKGwcU+4A@mail.gmail.com>
 <CAJZ5v0hic-Yf74Rn06kui4z+KZBES_uiH-pRmmRcFcYjuDZ=CA@mail.gmail.com>
In-Reply-To: <CAJZ5v0hic-Yf74Rn06kui4z+KZBES_uiH-pRmmRcFcYjuDZ=CA@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 20 Jan 2021 20:45:30 +0200
Message-ID: <CAHp75Vc=b8tXmv7yussXNVKPOovmpKAB1b9cWSAw5rpKDcvLiQ@mail.gmail.com>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
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
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Saravana Kannan <saravanak@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 8:18 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> On Tue, Jan 12, 2021 at 4:47 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Tue, Jan 12, 2021 at 3:42 PM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:

...

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
> >
> > Shouldn't be
> >
> >        return 0;
> > #else
> >        return -EINVAL;
> > #endif
> >
> > ?
> >
> > Yes, it's a theoretical case when is_acpi_node() returns true when
> > CONFIG_ACPI=n.
>
> How so?  is_acpi_node() is defined as a static inline returning false then.

I understand that, that's why it's pure theoretical when, for example,
the semantics is changed. But I believe it's unlucky to happen.

-- 
With Best Regards,
Andy Shevchenko

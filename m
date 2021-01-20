Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749242FD93F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392327AbhATTOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:14:15 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:38206 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388578AbhATTNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 14:13:44 -0500
Received: by mail-wm1-f42.google.com with SMTP id y187so3807021wmd.3;
        Wed, 20 Jan 2021 11:13:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MBnGinpLx/odbS3fMalb2PzzBTxTBoYrscYbO4dcTx4=;
        b=jQK8KsomxkfnpfpF06mYjwHfydEhZZRMxmpaztn9NkUx54MfEK9fn9wocyoa1BbVzt
         YW1La+uX/oiAQCLmr5ZpNZTpmySgblUJyuYpmkTnGe4aPM2U2mvXFgElHDqlyct2V45U
         cjMAPCbch1jICD3HqdjgveCuw+VxZ+YxfgZo55fPPxszNNPJwZtotvt5nwbZCWAde9Ol
         hx8RpgaMedSXfmYUbMhgGob4A13g177bHE8J8Vw6twC2ooBArPUfeQChlazn/3dZxXSz
         VitUO0K8ej/iG/7nelG33ZTHKLN1cEJmqXjoW97xnM47laEPY5Oi+uEBprMlFZL526k/
         sOEg==
X-Gm-Message-State: AOAM5307vz7dJHGgOy4N5jjq62h1jE3cNC+rwzPAQOZwZb/yo9YQe9yy
        ot5MPwJ1miARJQIO0jJvUMblkqNS6zD2489tiq8=
X-Google-Smtp-Source: ABdhPJw8c6qlkHR9iOkx8qE2vXeyMZs0yuZj2aqvZqkBYp8IXyAbHDidFzxsbIm2t+aeBTe9BpPR7HOZC2oOs1VO7wQ=
X-Received: by 2002:a1c:a593:: with SMTP id o141mr5723964wme.92.1611169982589;
 Wed, 20 Jan 2021 11:13:02 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com> <CAHp75VdyPWD-cM5Q_9k8yRAutMSjm-3kwE0pQT3+ztKGwcU+4A@mail.gmail.com>
 <CAJZ5v0hic-Yf74Rn06kui4z+KZBES_uiH-pRmmRcFcYjuDZ=CA@mail.gmail.com> <CAHp75Vc=b8tXmv7yussXNVKPOovmpKAB1b9cWSAw5rpKDcvLiQ@mail.gmail.com>
In-Reply-To: <CAHp75Vc=b8tXmv7yussXNVKPOovmpKAB1b9cWSAw5rpKDcvLiQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 20 Jan 2021 20:12:26 +0100
Message-ID: <CAJZ5v0ivSmgAbfH9JhGHRp9411F14XtrimESHftZGMLYKLfKmQ@mail.gmail.com>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
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

On Wed, Jan 20, 2021 at 7:44 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Wed, Jan 20, 2021 at 8:18 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > On Tue, Jan 12, 2021 at 4:47 PM Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> > > On Tue, Jan 12, 2021 at 3:42 PM Calvin Johnson
> > > <calvin.johnson@oss.nxp.com> wrote:
>
> ...
>
> > > > +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> > > > +{
> > > > +#ifdef CONFIG_ACPI
> > > > +       unsigned long long adr;
> > > > +       acpi_status status;
> > > > +#endif
> > > > +       int ret;
> > > > +
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
> > >
> > > Shouldn't be
> > >
> > >        return 0;
> > > #else
> > >        return -EINVAL;
> > > #endif
> > >
> > > ?
> > >
> > > Yes, it's a theoretical case when is_acpi_node() returns true when
> > > CONFIG_ACPI=n.
> >
> > How so?  is_acpi_node() is defined as a static inline returning false then.
>
> I understand that, that's why it's pure theoretical when, for example,
> the semantics is changed. But I believe it's unlucky to happen.

Changing the definition of it for CONFIG_ACPI=n would be a regression
given the current usage of it.

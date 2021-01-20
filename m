Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493872FD82A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 19:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404349AbhATSTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 13:19:54 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:39512 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391964AbhATSSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 13:18:44 -0500
Received: by mail-ot1-f50.google.com with SMTP id i30so11348535ota.6;
        Wed, 20 Jan 2021 10:18:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IgWDE0PErg3ORn5MUSyThw1N3Ecrc6Z8pCtsc577ahI=;
        b=ojM9r7PCtlxNYXItFNuFj/iw6hmuaeCLkNxVczASwTCTvtBngMAekwLoUvvd6etJaI
         ybFnwSmuTOkJoyBjly/xRwbNLWye/NhawA2DdPwZRVj/ilBSIhz5Eo7crOy2+itv0nNV
         CVcL7Tsw77M7BMHNUNHT3u/vQOlMggZ8R77Fl2P0wfSyzjuFrAvDQuFe5AZDM2sTKUxE
         yJSK1lErEmX26ucnQWobUn2fJ32RYt5FYhrlWU+jLaHSWABujrBDC5nZod/Jlx1JOMjZ
         P7B/LQPO1JeBtWjEkwgI/+b06V5MWh8DoJrkiWvy5Lpq27Ii0kQ8mgg6OWZMhhuBvo7e
         6a0Q==
X-Gm-Message-State: AOAM5319XFPLIJwgtWTE35qCnVYCoOV0ZimRJ132nvoFjO4vSDacAFK4
        vDHXGKIyblYZqlCEhS0v3Ikp3kcOQLjtnVeNQHs=
X-Google-Smtp-Source: ABdhPJwN77JI0VoJPEv4UVgKZFKkiy2aKaFZpzEAoON0ded46fj5YtH3TNGxm9cmcPfHk60ojzmuOupUQn33CroVRy0=
X-Received: by 2002:a05:6830:138f:: with SMTP id d15mr1588674otq.321.1611166682565;
 Wed, 20 Jan 2021 10:18:02 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-10-calvin.johnson@oss.nxp.com> <CAHp75VdyPWD-cM5Q_9k8yRAutMSjm-3kwE0pQT3+ztKGwcU+4A@mail.gmail.com>
In-Reply-To: <CAHp75VdyPWD-cM5Q_9k8yRAutMSjm-3kwE0pQT3+ztKGwcU+4A@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 20 Jan 2021 19:17:51 +0100
Message-ID: <CAJZ5v0hic-Yf74Rn06kui4z+KZBES_uiH-pRmmRcFcYjuDZ=CA@mail.gmail.com>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
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

On Tue, Jan 12, 2021 at 4:47 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Tue, Jan 12, 2021 at 3:42 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Using fwnode_get_id(), get the reg property value for DT node
> > or get the _ADR object value for ACPI node.
> >
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> >
> > Changes in v3:
> > - Modified to retrieve reg property value for ACPI as well
> > - Resolved compilation issue with CONFIG_ACPI = n
> > - Added more info into documentation
> >
> > Changes in v2: None
> >
> >  drivers/base/property.c  | 33 +++++++++++++++++++++++++++++++++
> >  include/linux/property.h |  1 +
> >  2 files changed, 34 insertions(+)
> >
> > diff --git a/drivers/base/property.c b/drivers/base/property.c
> > index 35b95c6ac0c6..2d51108cb936 100644
> > --- a/drivers/base/property.c
> > +++ b/drivers/base/property.c
> > @@ -580,6 +580,39 @@ const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode)
> >         return fwnode_call_ptr_op(fwnode, get_name_prefix);
> >  }
> >
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
>
> Shouldn't be
>
>        return 0;
> #else
>        return -EINVAL;
> #endif
>
> ?
>
> Yes, it's a theoretical case when is_acpi_node() returns true when
> CONFIG_ACPI=n.

How so?  is_acpi_node() is defined as a static inline returning false then.

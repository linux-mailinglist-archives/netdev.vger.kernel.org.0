Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CFE300B9E
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbhAVSmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:42:25 -0500
Received: from mail-oi1-f174.google.com ([209.85.167.174]:42333 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730067AbhAVSgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:36:25 -0500
Received: by mail-oi1-f174.google.com with SMTP id x71so7012357oia.9;
        Fri, 22 Jan 2021 10:36:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g8SVGJP7WiJQmZYbq/niFUHB4GuvGT5AtK/6Ph5PLj0=;
        b=tChtH8J+HJnYJRHGL7uYSVy36di01ZFJ1MROlR3Q/eQs+fOBldjlgS7vT5Wn0fk+VT
         0NR7Qx2/xTghvznrwRHGJo5uICwufeoajo/DywzooWi/TTMssVpPpwlWis7qEOfulkMA
         yhuVTr9PUTp2ymolkmrGqHcskyaBwyF+IBFWhvGC3g9VapAdSAUyCsxOYwwmf8Bl8ZJq
         0+eC5KWjIh13MlT454IluNHetd6QoVyZqAg0Ep3pIwK7IfjiLBWirbsi1qUzUtNa7sa9
         qN7mzKijyjiHnxTydGnfGdTM30Q9ZTlZ7j6dJeD+oEWuzi8zQgMWDFkMBMd3g/aVyyHt
         7McQ==
X-Gm-Message-State: AOAM533kvUJVq2s0K4TtzUFyRFg5U5wHfXEI3urdJSpXjrPT113VNCqa
        w4JGTIoKL1MvFZaQdGq+G0aSiYSwLw0zhfUPq/M=
X-Google-Smtp-Source: ABdhPJx9mF8QICc0mYhGnIBPzdwBKgYF4cPaz9TsBRhcrjMj053U9m78mBaJ1A5RBhabza3mCLBfXcPoG321WBk40WM=
X-Received: by 2002:a05:6808:9a8:: with SMTP id e8mr4342802oig.157.1611340543679;
 Fri, 22 Jan 2021 10:35:43 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-10-calvin.johnson@oss.nxp.com> <CAJZ5v0i9XyBKqZS9OL3riAdpmu3St_HZ3JBDcswMbX5pw03gqQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0i9XyBKqZS9OL3riAdpmu3St_HZ3JBDcswMbX5pw03gqQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 22 Jan 2021 19:35:32 +0100
Message-ID: <CAJZ5v0hWqfM0tn6N=U2tK_4jOtQSvX5v-XmR7-ti0QfhuF85YQ@mail.gmail.com>
Subject: Re: [net-next PATCH v4 09/15] device property: Introduce fwnode_get_id()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 7:13 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Fri, Jan 22, 2021 at 4:46 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Using fwnode_get_id(), get the reg property value for DT node
> > or get the _ADR object value for ACPI node.

This is not accurate AFAICS, because if the "reg" property is present
in the ACPI case, it will be returned then too.

> >
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> >
> > Changes in v4:
> > - Improve code structure to handle all cases
> >
> > Changes in v3:
> > - Modified to retrieve reg property value for ACPI as well
> > - Resolved compilation issue with CONFIG_ACPI = n
> > - Added more info into documentation
> >
> > Changes in v2: None
> >
> >  drivers/base/property.c  | 34 ++++++++++++++++++++++++++++++++++
> >  include/linux/property.h |  1 +
> >  2 files changed, 35 insertions(+)
> >
> > diff --git a/drivers/base/property.c b/drivers/base/property.c
> > index 35b95c6ac0c6..f0581bbf7a4b 100644
> > --- a/drivers/base/property.c
> > +++ b/drivers/base/property.c
> > @@ -580,6 +580,40 @@ const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode)
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

What about using the following description instead of the above:

"Retrieve the value of the "reg" property for @fwnode which can be
either DT or ACPI node.  In the ACPI case, if the "reg" property is
missing, evaluate the _ADR object located under the given node, if
present, and provide its return value to the caller.

Return 0 on success or a negative error code.

This function can be used only if it is known valid to treat the _ADR
return value as a fallback replacement for the value of the "reg"
property that is missing in the given use case."

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
> > +       if (ret) {
> > +#ifdef CONFIG_ACPI
> > +               status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > +                                              METHOD_NAME__ADR, NULL, &adr);
> > +               if (ACPI_FAILURE(status))
> > +                       return -EINVAL;
>
> Please don't return -EINVAL from here, because this means "invalid
> argument" to the caller, but there may be nothing wrong with the
> fwnode and id pointers.
>
> I would return -ENODATA instead.
>
> > +               *id = (u32)adr;
> > +#else
> > +               return ret;
> > +#endif
> > +       }
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(fwnode_get_id);
> > +
> >  /**
> >   * fwnode_get_parent - Return parent firwmare node
> >   * @fwnode: Firmware whose parent is retrieved
> > diff --git a/include/linux/property.h b/include/linux/property.h
> > index 0a9001fe7aea..3f41475f010b 100644
> > --- a/include/linux/property.h
> > +++ b/include/linux/property.h
> > @@ -82,6 +82,7 @@ struct fwnode_handle *fwnode_find_reference(const struct fwnode_handle *fwnode,
> >
> >  const char *fwnode_get_name(const struct fwnode_handle *fwnode);
> >  const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode);
> > +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id);
> >  struct fwnode_handle *fwnode_get_parent(const struct fwnode_handle *fwnode);
> >  struct fwnode_handle *fwnode_get_next_parent(
> >         struct fwnode_handle *fwnode);
> > --
> > 2.17.1
> >

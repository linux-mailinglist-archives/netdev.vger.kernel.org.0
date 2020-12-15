Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732A62DB2FE
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgLORtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730636AbgLORtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:49:06 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912BDC06179C;
        Tue, 15 Dec 2020 09:48:26 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id t22so5547327pfl.3;
        Tue, 15 Dec 2020 09:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s9+zKZ0t51Yi4UpYePVg2qU/uZjrDKprhqn56lhIt7U=;
        b=g/qgg+hYJxwJ1wiJKO0C59GAodEnrbrvnncGyWVdQhjNsrQWrZAtSpFUEnVlkHjS4U
         /L9Vw6pBy2ay+Kxr7ExcGX8tVyKfmeaI/tQz8QcaSt8Vl4NgOztUVOFepe45SuVaWyhi
         0JAsdS/kAZVW1arB0DCTGqI3XSX6LqrBVrXIul5EYnVXWiMXP32y7APu6gsNGXKVntDA
         pwJcgOjGNfTBNnxuIpR2G0Ryhg95ZfdFN0sLmZONwysP+Vus7c1SIhl294KctE05ZSTg
         B9gHIuCweJHtShSNzDQddRfLNFfuWMZRjykFvP2c1c9u15biGP0tXQEPEziGccXaM5Wn
         WJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s9+zKZ0t51Yi4UpYePVg2qU/uZjrDKprhqn56lhIt7U=;
        b=pU96pSjGnGRyd0xS4ntY7f0gUT5tG1YPu/wpCCgcDQGar7uXLiDubAeq3rfOw1xqpr
         n9R4K4bO9/QalgVJJkVdw1u1ejMWsviMxHZaDS027yKqL60EvB7RX0GYWKVwfIx3xp4I
         LBV1JNgtZWmCkHRuk7VzNzcyNQDz6ckqusOcwHh4mBED/bvFkmkVu1L4JZbjrXgZ9YtS
         OwKnpbzTAg5Zyqew0sNPzXU3KVlyr3wfkyajahNfhi5RFXYF78j9hODl5c5kodPkjEDI
         oUuPIqHOALK7ezhLFo/8KY+VWVOsjaSC4d7Wyon4quAtG3CN+2JvsldwMMQTRmWvFR0m
         n9AA==
X-Gm-Message-State: AOAM531WsD2H7ahny3CYgVwmfPwzIBZCkLY69UPcGdid+L/G5N1+9o1l
        MoLDTMc0k1ppClKSyRGBr/HcwR7IeoO4hLY4wsw6uUdivzk=
X-Google-Smtp-Source: ABdhPJzymc6jnpVMoKVo8nxL5P6Vbt77JXltH1HwbknkAaR4p5CWR5f4ROkpxYPU6o8UTlWDPtsR0WAYGpRbRDJv6Oo=
X-Received: by 2002:a62:19cc:0:b029:19e:321b:a22e with SMTP id
 195-20020a6219cc0000b029019e321ba22emr22353379pfz.73.1608054506066; Tue, 15
 Dec 2020 09:48:26 -0800 (PST)
MIME-Version: 1.0
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-11-calvin.johnson@oss.nxp.com> <X9jrrMJIj2EQBykI@pendragon.ideasonboard.com>
In-Reply-To: <X9jrrMJIj2EQBykI@pendragon.ideasonboard.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 15 Dec 2020 19:49:14 +0200
Message-ID: <CAHp75VdA9Qzvg0TqOes1B1PXF+z8YMM2hK1zOJYMZusmHz=hdQ@mail.gmail.com>
Subject: Re: [net-next PATCH v2 10/14] device property: Introduce fwnode_get_id()
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh+dt@kernel.org>
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
        Jon <jon@solid-run.com>, "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 7:00 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Tue, Dec 15, 2020 at 10:13:11PM +0530, Calvin Johnson wrote:
> > Using fwnode_get_id(), get the reg property value for DT node
> > and get the _ADR object value for ACPI node.

...

> > +/**
> > + * fwnode_get_id - Get the id of a fwnode.
> > + * @fwnode: firmware node
> > + * @id: id of the fwnode
>
> Is the concept of fwnode ID documented clearly somewhere ? I think this
> function should otherwise have more documentation, at least to explain
> what the ID is.

I'm afraid that OF has no clear concept of this either. It's usually
used as a unique ID for the children of some device (like MFD) and can
represent a lot of things. But I agree it should be documented.

Rob, any ideas about this?

> > + * Returns 0 on success or a negative errno.
> > + */
> > +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> > +{
> > +     unsigned long long adr;
> > +     acpi_status status;
> > +
> > +     if (is_of_node(fwnode)) {
> > +             return of_property_read_u32(to_of_node(fwnode), "reg", id);
> > +     } else if (is_acpi_node(fwnode)) {
> > +             status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> > +                                            METHOD_NAME__ADR, NULL, &adr);
> > +             if (ACPI_FAILURE(status))
> > +                     return -ENODATA;
>
> Would it make sense to standardize error codes ? of_property_read_u32()
> can return -EINVAL, -ENODATA or -EOVERFLOW. I don't think the caller of
> this function would be very interested to tell those three cases apart.
> Maybe we should return -EINVAL in all error cases ? Or maybe different
> error codes to mean "the backend doesn't support the concept of IDs",
> and "the device doesn't have an ID" ?

We may actually get mapping to all three if first we check for the
method/name existence followed by value check.
But I don't think we need to bloat this simple one.

> > +             *id = (u32)adr;
> > +             return 0;
> > +     }
> > +     return -EINVAL;
> > +}

-- 
With Best Regards,
Andy Shevchenko

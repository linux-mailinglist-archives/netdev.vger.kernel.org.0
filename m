Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F6D2DE6B7
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 16:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgLRPgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 10:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgLRPgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 10:36:15 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700E4C0617B0;
        Fri, 18 Dec 2020 07:35:35 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id n10so1524628pgl.10;
        Fri, 18 Dec 2020 07:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7xxcDN6HCVBj/n2MlzzYP00orDljms2QLMLINjiTeKg=;
        b=PE89hqai0/jIJUHPqZ7bRVSqKfzWQ/DhvoEEQ4sspOUPUhLGpHBNxu9U1C2M/8I4n4
         DVzd32+NCzVyWuKEUcsihuNq2qxMxqdnthytjkif66VngeSNwttZEz3FS7dPIx7KbYdB
         5JHf90i8Jkjj18qMEgi7pknOQirHGNujvq5Vy8n0rXQZkqX+CDx46/BY4H8gY8jmjLAW
         QLYMKFlZC7Y6iPwb8fGmViDYBpcnSV0moF8CRkbeEyfQ7CgEvu094FrnnbT85W6jNDPb
         H7EXObGdWHIDj5DE0Xxeyl/JDV2B1b7PacNJp62azmLXBvbu21RYReIA8cRKRlT/YYb0
         NMVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xxcDN6HCVBj/n2MlzzYP00orDljms2QLMLINjiTeKg=;
        b=NUy1RV/u5TzZyGA5XkG2lR3Ay6Y/8IlGMpB/vvjF6Hev9WOZUWzT0FE57H7x6kCmwQ
         T4rADExdMr/+3PvoimQfaeDhy8hEPN1zVVhyduYDNXtpOAOuJAPFDaf4EsKUkHeKqBPv
         5WTZC6SDck4zU6tlX9Yp7cwiuVhrTLF5DGhIVQ+SXms7UavGPAsVR5wk/mJTv1+jFscE
         ACVY1+f8AeTKL4aEeTRiolzZtZNjIVKgc2IR5rrH1mv9MN+9qS/552+9tA6AnW/bAa1z
         tMlhYrzfM7vyJJqldNuXtZoAySJSbHijWJE1/Gpu4bnb+ZD6Ka8V53CAQVWB/QBlPPl8
         t7Sw==
X-Gm-Message-State: AOAM532sOXgpVzooYfRd6P0J1LBrLdwRdo182IKauBpTbUdir8tCb1ut
        AGtyZmygh/dvSiJNOWF8yQJFB4+BO6CNkpnFUf8=
X-Google-Smtp-Source: ABdhPJzMq/DpCv05vW4vujkFDPFHUdO8ySOlZHFnDqZRGc41djLydqFSESwRz1xasN7D7grqT31Q5+xe5XXkf2GP3Kk=
X-Received: by 2002:a63:74b:: with SMTP id 72mr4675770pgh.4.1608305734916;
 Fri, 18 Dec 2020 07:35:34 -0800 (PST)
MIME-Version: 1.0
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-7-calvin.johnson@oss.nxp.com> <CAHp75VcY2uOirAXGv5kFvHbNfHcZ6-gPsUMTB-_5AuBkHdu-0A@mail.gmail.com>
 <20201218053423.GA14594@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20201218053423.GA14594@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 18 Dec 2020 17:35:18 +0200
Message-ID: <CAHp75Vd=dia5_a3dYvxd14UxHzL-FPuggi7SrwKdY1PUm7j9Ug@mail.gmail.com>
Subject: Re: [net-next PATCH v2 06/14] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
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
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 7:34 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> On Tue, Dec 15, 2020 at 07:33:40PM +0200, Andy Shevchenko wrote:
> > On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:

...

> > > +               /* phy->mii_ts may already be defined by the PHY driver. A
> > > +                * mii_timestamper probed via the device tree will still have
> > > +                * precedence.
> > > +                */
> >
> > > +               if (mii_ts)
> > > +                       phy->mii_ts = mii_ts;
> >
> > How is that defined? Do you need to do something with an old pointer?
>
> As the comment says, I think PHY drivers which got invoked before calling
> of_mdiobus_register_phy() may have defined phy->mii_ts.

What I meant here is that the old pointer might need some care (freeing?).

> > > +       }

-- 
With Best Regards,
Andy Shevchenko

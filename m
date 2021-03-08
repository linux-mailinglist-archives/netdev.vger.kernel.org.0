Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745F7331180
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 15:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhCHO6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 09:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbhCHO5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 09:57:52 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF05EC06174A;
        Mon,  8 Mar 2021 06:57:51 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so3118845pjb.0;
        Mon, 08 Mar 2021 06:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1v0ao3b2/Ux4Trc+2qyo6Snq2zmvaCA06fjB7BxQBtk=;
        b=UN2m03gJoZakMr0gOlQjQr5POq2Jz4sA0ztlFhKdsp4HXOGelbToq5jKRqnI3v7zjc
         TVRSriUUvtKcFRhvvKGNdcmkwyI/o3i5ZzMytKZaF1m7DznLjrZ8iJCqLWYmgJnjuV3L
         mTQArkXhtOCZxDqQEGN7AxVsZTZL4ah2L8Uh9Cp1OrQQgVe2fpmMYPzG0w/sfLvv96yO
         56x52+9LalsUGPXMQ9bwE7fM/f7ybD/qobWl3ryinOVUrWnrQnoaHThwxojB8VgJ0h2D
         BdFrVGbwBMi/tCtYP27qFCuVTn6pG64SMtEwJEcOSie7MTdvPvfR5V5OmFVncRm1i4R9
         xB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1v0ao3b2/Ux4Trc+2qyo6Snq2zmvaCA06fjB7BxQBtk=;
        b=dVva7WWv86XP5l8ZxqUZbzAghRfrGXm7Z2QYpQ+SQjUE7P3l+tS2h2Za6Bqc5Bzstn
         V5bXhnTul7Y6duQuFjj0d7uV+raZVB4H89pqgmD8lz3d6bIlwsawmDdjNqkFoqLDmZ4C
         XBm7XP7xnPrV3GijBNmMhwkuJ2Bzx3vE+T/24JpgL4efZgLh4eiHMSsFN6EmArO9IiKu
         MfbKZ/XFrywC98xJmcAA330ATCpGILuOGKgwCbmzMNCB40lvxXfy3ayqAH3kLajEV3gq
         9TXO89rIBvUR01Kq+BK+8KBKk6tGZS3WNn0GHpHgPMhkbkVQfd3K+1jfG3V7x34Q43lf
         9YxA==
X-Gm-Message-State: AOAM530GSInHEGhMA+wZ7MYoYderLV5/8vFLUVxpGJ4tPvDKSmginjPh
        0aC47mlhFdtxIPmFSOH/fUU37LMGHrmyxLIkOVs=
X-Google-Smtp-Source: ABdhPJwWLAcn/zCc7JnKH0rPVVA2UFQqpno+iYzLW3XAAZ6juSRPbxlixiAKwoAOG82N4Y3z+Z9QJAbVtiVxxrJMbRk=
X-Received: by 2002:a17:902:70c7:b029:e3:71cf:33d2 with SMTP id
 l7-20020a17090270c7b02900e371cf33d2mr21445892plt.21.1615215471340; Mon, 08
 Mar 2021 06:57:51 -0800 (PST)
MIME-Version: 1.0
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
 <20210218052654.28995-11-calvin.johnson@oss.nxp.com> <CAHp75VdpvTN2R-FTb81GnwvAr_eoprEhsOMx+akukaDNBrptsQ@mail.gmail.com>
 <20210308140936.GA2740@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20210308140936.GA2740@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 8 Mar 2021 16:57:35 +0200
Message-ID: <CAHp75Vc2OtScGFhCL7QiRsakrQAZYE6Wz-0qzmz5uB63cjieQw@mail.gmail.com>
Subject: Re: [net-next PATCH v6 10/15] net: mdio: Add ACPI support code for mdio
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 8, 2021 at 4:11 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Thu, Feb 18, 2021 at 05:08:05PM +0200, Andy Shevchenko wrote:
> > On Thu, Feb 18, 2021 at 7:28 AM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:

> > > Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
> > > each ACPI child node.
> >
> > > +#include <linux/acpi.h>
> > > +#include <linux/acpi_mdio.h>
> >
> > Perhaps it's better to provide the headers that this file is direct
> > user of, i.e.
> >  bits.h
> >  dev_printk.h
>
> Looks like device.h needs to be used instead of dev_printk.h. Please
> let me know if you've a different opinion.

I don't see the user of device.h. dev_printk.h is definitely in use here...
Do you see a user for device.h? Which line in your code requires it?

It might be that I don't see something quite obvious...

> >  module.h
> >  types.h
> >
> > The rest seems fine because they are guaranteed to be included by
> > acpi.h (IIUC about fwnode API and acpi_mdio includes MDIO PHY APIs).



-- 
With Best Regards,
Andy Shevchenko

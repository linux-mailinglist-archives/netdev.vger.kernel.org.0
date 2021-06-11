Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BE23A420B
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhFKMeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 08:34:00 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:39482 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhFKMd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 08:33:59 -0400
Received: by mail-ot1-f42.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so2960109otu.6;
        Fri, 11 Jun 2021 05:31:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pa41k2a2Rwm0Si9XJrZMd28ASYH/qozjAczbkbkfJ5k=;
        b=IZrqC/0qj2dbQK12JuaB8jyKBmxh3jQkB0xk8y/y1FPcJ9JPVXX6nLVmr41CW0ePMY
         YCAa/8zMoux9H78nRJy1qx7ytuyZ//0LL76ZvKGaHgBVvh1V+eQRYmtn9Im0cebRMwXu
         ikqJPUEFASUKeYEcGUu9KGfIUK1mK/P1t6pBAvx7Cr0xmqtn86dj2Vo8TCpI8xDnAqJa
         XnHKaMyz5tpE6NtAYfIbb5v3LqVOFVjJaEh+cmgwDbgjNV7svM7JnMyCDkGgic4cXNdG
         7he3U68QU4uhVU3K4tVKQXMyZhy7jFkkAqGVpxZOubUVk+/xlGalwDQ8iew+6mew1eV7
         44OQ==
X-Gm-Message-State: AOAM530eWEhSTl5NRYik1bI2xGj9aKhTHyyVVBH4sSEl2J2CSd6eOW2d
        +vyUCwf1FOKNP0wuNdWIRM6MFr+LFFVVUU+t4zOIl2o4
X-Google-Smtp-Source: ABdhPJwCOyXsVkHlt17OBdjoNwNbDTluawZ39cTrzWv1WE+/fKEDDZQ8/tqHpMPnuZmn/OlHD33hAFHJoVpjwQi6Xus=
X-Received: by 2002:a9d:3e53:: with SMTP id h19mr2947026otg.260.1623414709206;
 Fri, 11 Jun 2021 05:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
 <20210611105401.270673-4-ciorneiioana@gmail.com> <CAHp75VcfEbMecsGprNW33OtiddVw1MhmOVrtb9Gx4tKL5BjvYw@mail.gmail.com>
 <CAJZ5v0ipvAodoFhU4XK+cL2tf-0jExtMd2QUarMK0QPJQyeJxg@mail.gmail.com> <20210611120843.GK22278@shell.armlinux.org.uk>
In-Reply-To: <20210611120843.GK22278@shell.armlinux.org.uk>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 11 Jun 2021 14:31:38 +0200
Message-ID: <CAJZ5v0ijr8jhuyJDDS8n=8L53R26rtnYHmO-g7S7gdLXH+P3Lw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 03/15] net: phy: Introduce phy related fwnode functions
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ioana Ciornei <ciorneiioana@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 2:08 PM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Fri, Jun 11, 2021 at 01:40:59PM +0200, Rafael J. Wysocki wrote:
> > I'm not sure why you want the above to be two if () statements instead of one?
> >
> > I would change the ordering anyway, that is
> >
> > if (!IS_ERR(phy_node) || is_acpi_node(fwnode))
> >         return phy_node;
> >
> > And I think that the is_acpi_node() check is there to return the error
> > code right away so as to avoid returning a "not found" error later.
> >
> > But I'm not sure if this is really necessary.  Namely, if nothing
> > depends on the specific error code returned by this function, it would
> > be somewhat cleaner to let the code below run if phy_node is an error
> > pointer in the ACPI case, because in that case the code below will
> > produce an error pointer anyway.
>
> However, that opens the door to someone shipping "working" ACPI with
> one of these names that we've taken the decision not to support on
> ACPI firmware. Surely, it's much better that we don't accept the
> legacy names so we don't allow such configurations to work.

Fair enough.

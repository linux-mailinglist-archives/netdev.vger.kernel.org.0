Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791403186A8
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 10:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhBKJBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 04:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhBKI5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 03:57:45 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BCCC06174A
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 00:58:31 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id k4so4857070ybp.6
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 00:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q7UX8xRAUx3NEYdZGJAbsbrxAPMirbP6gw872O+KA8o=;
        b=Xg3FjLP2YzkiPDJPOpJk+hijX0k6WHa6l2qtY8JyPZARLj2WfedEyqy11NQp6ZsaF3
         kiXd6917qhcGTwXnB2HWyMontdMQtTaw3/G6XrT+26/K9v8X8wLQF/ax9h1S9fv8RbBT
         ExAKfRgtRXW9R2xzYSdrBrs73dCenkh6f2MyH3CkKpIGAy9gPQpNS6l5ARf+zZ+GppND
         oFvb6KwR7VEd28/JLBEs5MLqeXkSLkJklsxF1ULRrdoxb8ckZ16lD/NZwrukBvMX62GC
         usI/X3IiCQSxORNledNjo3cJb/pWxARqMhdZzpI6RwMzbwvZWecfr5qv19/SC2H0hYmL
         T7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q7UX8xRAUx3NEYdZGJAbsbrxAPMirbP6gw872O+KA8o=;
        b=q+ds2ZGwLZd+Evrq2ErFaLCnGrDw2qnM5+eHd8DBYWGoVPQeV7DRHNYY0S9jzTENOb
         Mufnt2n89usgZmSSWqn5hiXb4W53KzUiSaTxyamtKLfBOn8jVuhtdiW8nySH/n4eERY+
         7mdQ6qQxKKf7pURA3Lr0fLczWg+nuQFtlbkOcb92p5lRmc0RrP9iBNJTUkcAdYXtaCxj
         O3sDUqjQQqu1QwstpNha2MaYBM6p9tTTdNIAJsKzq9UfRqF07qKgwAoEdVYzWyGz8c9m
         tvm26hb1vMnpFa5V8s7bfMw7H9ylb+onO+8KN9Zb9SBzpM0HhNQhTJ+jOvQrb/ZP3NJb
         10ug==
X-Gm-Message-State: AOAM530SrEapXKjADKch19n+VLXwRkhCyD8AAzoAJ0kY2Acau/U2MokH
        sy08hdMm6oC17S+7HZYZMGjX0lrcCgjzWGd7j6lX4Q==
X-Google-Smtp-Source: ABdhPJwehssBwTCoYDaR9vzFN0Orq2ozY4huTH5fDgfg40w++mvdzV0VxDVewk8kNIuw0cvuFJjFyvs4lsaoBz1ZL9I=
X-Received: by 2002:a25:8b8b:: with SMTP id j11mr9412475ybl.310.1613033910135;
 Thu, 11 Feb 2021 00:58:30 -0800 (PST)
MIME-Version: 1.0
References: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
 <YCRjmpKjK0pxKTCP@lunn.ch> <CAGETcx-tBw_=VPvQVYcpPJBJjgQvp8UASrdMdSbSduahZpJf9w@mail.gmail.com>
 <4f0086ad-1258-063d-0ace-fe4c6c114991@gmail.com>
In-Reply-To: <4f0086ad-1258-063d-0ace-fe4c6c114991@gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 11 Feb 2021 00:57:54 -0800
Message-ID: <CAGETcx_9bmeLzOvDp8eCGdWtfwZNajCBCNSbyx7a_0T=FcSvwA@mail.gmail.com>
Subject: Re: phy_attach_direct()'s use of device_bind_driver()
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:31 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 11.02.2021 00:29, Saravana Kannan wrote:
> > On Wed, Feb 10, 2021 at 2:52 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >> On Wed, Feb 10, 2021 at 02:13:48PM -0800, Saravana Kannan wrote:
> >>> Hi,
> >>>
> >>> This email was triggered by this other email[1].
> >>>
> >>> Why is phy_attach_direct() directly calling device_bind_driver()
> >>> instead of using bus_probe_device()?
> >>
> >> Hi Saravana
> >>
> >> So this is to do with the generic PHY, which is a special case.
> >>
> >> First the normal case. The MDIO bus driver registers an MDIO bus using
> >> mdiobus_register(). This will enumerate the bus, finding PHYs on
> >> it. Each PHY device is registered with the device core, using the
> >> usual device_add(). The core will go through the registered PHY
> >> drivers and see if one can drive this hardware, based on the ID
> >> registers the PHY has at address 2 and 3. If a match is found, the
> >> driver probes the device, all in the usual way.
> >>
> >> Sometime later, the MAC driver wants to make use of the PHY
> >> device. This is often in the open() call of the MAC driver, when the
> >> interface is configured up. The MAC driver asks phylib to associate a
> >> PHY devices to the MAC device. In the normal case, the PHY has been
> >> probed, and everything is good to go.
> >>
> >> However, sometimes, there is no driver for the PHY. There is no driver
> >> for that hardware. Or the driver has not been built, or it is not on
> >> the disk, etc. So the device core has not been able to probe
> >> it. However, IEEE 802.3 clause 22 defines a minimum set of registers a
> >> PHY should support. And most PHY devices have this minimum. So there
> >> is a fall back driver, the generic PHY driver. It assumes the minimum
> >> registers are available, and does its best to drive the hardware. It
> >> often works, but not always. So if the MAC asks phylib to connect to a
> >> PHY which does not have a driver, we forcefully bind the generic
> >> driver to the device, and hope for the best.
> >
> > Thanks for the detailed answer Andrew! I think it gives me enough
> > info/context to come up with a proper fix.
> >
> >> We don't actually recommend using the generic driver. Use the specific
> >> driver for the hardware. But the generic driver can at least get you
> >> going, allow you to scp the correct driver onto the system, etc.
> >
> > I'm not sure if I can control what driver they use. If I can fix this
> > warning, I'll probably try to do that.
> >
> The genphy driver is a last resort, at least they lose functionality like
> downshift detection and control. Therefore they should go with the
> dedicated Marvell PHY driver.
>
> But right, this avoids the warning, but the underlying issue (probably
> in device_bind_driver()) still exists. Would be good if you can fix it.

Yeah, I plan to fix this. So I have a few more questions. In the
example I gave, what should happen if the gpios listed in the phy's DT
node aren't ready yet? The generic phy driver itself probably isn't
using any GPIO? But will the phy work without the GPIO hardware being
initialized? The reason I'm asking this question is, if the phy is
linked to a supplier and the supplier is not ready, should the
device_bind_driver() succeed or not?

-Saravana

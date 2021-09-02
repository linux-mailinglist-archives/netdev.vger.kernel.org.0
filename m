Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933393FF7DA
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbhIBXbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhIBXbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:31:01 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B34C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 16:30:02 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id e133so7018108ybh.0
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 16:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6xTg00PepVPylOtm1J0Y6rkZ7Wc4zH5g0ApsRZq0FUI=;
        b=n0XEJv7UdxOAcuracft+Xvw5QLLeajqnN5CBStW2IoBqQrqE1Dbq87vM10iYzXFByF
         kUaZoFC1HUuRs53G3sY8xqoEzzF0znynaeWGk0K4NlkxVzF375NsTwszhwJPQ/fLd5QE
         wDNFWc4sRuP44bSNwqAWirv21TiIhf/t/RQ4VnwmBrB85MFz4Sd2psvxdmin8UuwQjKV
         BmuvEzVXD1CJKZiwK/c2LdjhBveXGZZ9u4UEZ8RnKeBLujx7P69Uemzzhc4rWPxaoI4m
         nksWWTXfCGzbqYSGzFUNuSeq0v30pBFOHG99yWvFShn47nWm5dZS+jHyOZYEfCcbLbxL
         /daw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6xTg00PepVPylOtm1J0Y6rkZ7Wc4zH5g0ApsRZq0FUI=;
        b=fZ8ONoVelf3QKegiz2eAqIEaBwR57ksuV4LK7jOWge3mM9TsHRyS81e92n2ngjrzI+
         smxZ8UPUa483TpC8ow3GW0GRDdCYyaYFbwU01cYcpD/urMcsmDm2cHZWwwYpxa1Bj6pv
         eoXYiRYlzidMzZmGks0Km5zoqthGPXGXMutB9kLyDEB7UYW1vI6wNBjF2lQz35ZNTX/C
         7hDmCqXlAmwfm8WiUeKI+rI3U+2Jt6Pyh0M5WyYSsprJWIBUAz2nQiq8F3vnAUYLxvoo
         FaZwvIWK2ywzLkt6AD5sX9Qf2BDpHRjsues107USd78LZSEtOAHZYPdNOeUOTlVcxGDY
         UUvA==
X-Gm-Message-State: AOAM532kQ72KrurqzHotLPXNT2ZbsnIUEo88E1/QwEoJqVHd1MVKeKZp
        ssAe+NVWN06B/z+plijh2EtNO5tGQgGReXdSOd3/2A==
X-Google-Smtp-Source: ABdhPJwDEizZwDXmFQo9X/jBsqiugcTqCUwjHAa6hvmWH2Qm4+fQv6S4de/oQBbZ8ps6OnpvyMtT6nU3W/ioGOS3xS4=
X-Received: by 2002:a25:6746:: with SMTP id b67mr1341051ybc.96.1630625401243;
 Thu, 02 Sep 2021 16:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com> <20210902220520.hyybu6k3mjzbl7mn@skbuf>
In-Reply-To: <20210902220520.hyybu6k3mjzbl7mn@skbuf>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 2 Sep 2021 16:29:25 -0700
Message-ID: <CAGETcx8i_TSRKmnMAwbh9FbQDFO1ueU5nWTRxQgQpaY3i0v=Jw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 3:05 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Sep 02, 2021 at 01:50:50AM +0300, Vladimir Oltean wrote:
> > This is a continuation of the discussion on patch "[v1,1/2] driver core:
> > fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT" from here:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210826074526.825517-2-saravanak@google.com/
> >
> > Summary: in a complex combination of device dependencies which is not
> > really relevant to what is being proposed here, DSA ends up calling
> > phylink_of_phy_connect during a period in which the PHY driver goes
> > through a series of probe deferral events.
> >
> > The central point of that discussion is that DSA seems "broken" for
> > expecting the PHY driver to probe immediately on PHYs belonging to the
> > internal MDIO buses of switches. A few suggestions were made about what
> > to do, but some were not satisfactory and some did not solve the problem.
> >
> > In fact, fw_devlink, the mechanism that causes the PHY driver to defer
> > probing in this particular case, has some significant "issues" too, but
> > its "issues" are only in quotes "because at worst it'd allow a few
> > unnecessary deferred probes":
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210826074526.825517-2-saravanak@google.com/#24418895
> >
> > So if that's the criterion by which an issue is an issue, maybe we
> > should take a step back and look at the bigger picture.
> >
> > There is nothing about the idea that a PHY might defer probing, or about
> > the changes proposed here, that has anything with DSA. Furthermore, the
> > changes done by this series solve the problem in the same way: "they
> > allow a few unnecessary deferred probes" <- in this case they provoke
> > this to the caller of phy_attach_direct.
> >
> > If we look at commit 16983507742c ("net: phy: probe PHY drivers
> > synchronously"), we see that the PHY library expectation is for the PHY
> > device to have a PHY driver bound to it as soon as device_add() finishes.
> >
> > Well, as it turns out, in case the PHY device has any supplier which is
> > not ready, this is not possible, but that patch still seems to ensure
> > that the process of binding a driver to the device has at least started.
> > That process will continue for a while, and will race with
> > phy_attach_direct calls, so we need to make the latter observe the fact
> > that a driver is struggling to probe, and wait for it a bit more.
> >
> > What I've not tested is loading the PHY module at runtime, and seeing
> > how phy_attach_direct behaves then. I expect that this change set will
> > not alter the behavior in that case: the genphy will still bind to a
> > device with no driver, and phy_attach_direct will not return -EPROBE_DEFER
> > in that case.
> >
> > I might not be very versed in the device core/internals, but the patches
> > make sense to me, and worked as intended from the first try on my system
> > (Turris MOX with mv88e6xxx), which was modified to make the same "sins"
> > as those called out in the thread above:
> >
> > - use PHY interrupts provided by the switch itself as an interrupt-controller
> > - call of_mdiobus_register from setup() and not from probe(), so as to
> >   not circumvent fw_devlink's limitations, and still get to hit the PHY
> >   probe deferral conditions.
> >
> > So feedback and testing on other platforms is very appreciated.
> >
> > Vladimir Oltean (3):
> >   net: phy: don't bind genphy in phy_attach_direct if the specific
> >     driver defers probe
> >   net: dsa: destroy the phylink instance on any error in
> >     dsa_slave_phy_setup
> >   net: dsa: allow the phy_connect() call to return -EPROBE_DEFER
> >
> >  drivers/base/dd.c            | 21 +++++++++++++++++++--
> >  drivers/net/phy/phy_device.c |  8 ++++++++
> >  include/linux/device.h       |  1 +
> >  net/dsa/dsa2.c               |  2 ++
> >  net/dsa/slave.c              | 12 +++++-------
> >  5 files changed, 35 insertions(+), 9 deletions(-)
> >
> > --
> > 2.25.1
> >
>
> Ouch, I just realized that Saravana, the person whose reaction I've been
> waiting for the most, is not copied....
>
> Saravana, you can find the thread here to sync up with what has been
> discussed:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210901225053.1205571-1-vladimir.oltean@nxp.com/

Woah! The thread blew up.

>
> Sorry.

No worries.

I'll read through the thread later and maybe provide more responses,
but one thing I wanted to say right away:

Don't depend on dev->p->deferred_probe. It can be "empty" for a device
that has returned -EPROBE_DEFER for a bunch of reasons:

1. When the device is in the middle of being reattempted, it would be
empty. You can't hold any lock that'll ensure correctness either
because deferred probe locking is a mess (I'm working on cleaning that
up).

2. I'm working on actually not adding devices to that list if there's
a known supplier that hasn't been probed yet. No point retrying it
again and again for every deferred probe trigger when we know it's
going to fail. And we'll basically get topological probe ordering.

Your closest bet right now is d->can_match. Only caveat is that it's
not cleared if the actual driver gets unregistered.


-Saravana

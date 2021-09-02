Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C963FECC8
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 13:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245081AbhIBLSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 07:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhIBLSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 07:18:03 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A31AC061575;
        Thu,  2 Sep 2021 04:17:05 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a25so3458322ejv.6;
        Thu, 02 Sep 2021 04:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uFEkTCd/xhh2jHjXLDAM0hWxj6RGslNzQrjo3X/7zUU=;
        b=A/cYi8R1cALl21mnfBisBtq/UcUEk6B9DJHllYb1B8XYF6oP8CKv0eLrTDrXmwVhN2
         sWCn2WtsylxzWyApOwb9EVbnqD5s9dS1fx3dQ18RJlfSMV1A1wj9+CqpEJYzKdaKYpB2
         pi9U8uYZG4sONB1kkD+eTiiN186QrJ24rf1e6ANx14m05K7DDb2XvP0zTDAUoEUkbbR/
         YPxsu0s6oQv6Kv705tXMzlJPqAknOda6hnKwLjoVPFY8Oi71ux+wYE01I/LJY48VeMmC
         xOxSSyhOzYAN5ZcHx8i8URE4wk3k76PdeTZPc3mCRXFHDnRwVGmz+DhC9Kg8RCkAFHMz
         XzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uFEkTCd/xhh2jHjXLDAM0hWxj6RGslNzQrjo3X/7zUU=;
        b=t6nfM9CYcrQN5SmiI5cYlyN6BifsLMSC6OO1BKdQz+5KVfl0Oz2XybsXWHf9h2gFWk
         hN/DKDDxIW8hkjllIAk8CNciWwwslSmrjw2fKWJ6gESbvV0F5l724jeUbvFrzCb60tGZ
         YSTuprPjvz2tz5lnx609IBB9VvHxW5QtIdZyHXyG9fRoSlwoyEH+VxvJhuJa1csmQdpB
         Gi24KzbA9HD4qZrTq1a7W0a+07Pg8SW0If3Gudpm+AM1+peD/Oym4L9bKAsz4SwEPuj2
         SywBbo6mv7Cuozdfxxl5ARbTGGgJ2BarzDYQv9X5/O1BeGiuromsFRF7rAk1GgnBv6Qe
         ckSA==
X-Gm-Message-State: AOAM532vAmsNkP8FA0yxjI3tXWUMtJ+xXzcqLma5v+gfuE7VLFmoFnOT
        gsEemLpQkdfc4UyUUNVC6KA=
X-Google-Smtp-Source: ABdhPJxVJn37EXfC1Kkgvx/x3vaArliD0lsBCMi/Vq5/WEkUoTCbcdl5fExGTGuKoQC3WyMe6MlzxQ==
X-Received: by 2002:a17:907:7844:: with SMTP id lb4mr3117219ejc.381.1630581423928;
        Thu, 02 Sep 2021 04:17:03 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id t16sm901503ejj.54.2021.09.02.04.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 04:17:03 -0700 (PDT)
Date:   Thu, 2 Sep 2021 14:17:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
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
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210902111702.4n6suxfbze46wcgb@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <YTBkbvYYy2f/b3r2@kroah.com>
 <20210902101150.dnd2gycc7ekjwgc6@skbuf>
 <YTCpbkDMUfBtJM1V@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTCpbkDMUfBtJM1V@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 12:37:34PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Sep 02, 2021 at 01:11:50PM +0300, Vladimir Oltean wrote:
> > On Thu, Sep 02, 2021 at 07:43:10AM +0200, Greg Kroah-Hartman wrote:
> > > Wait, no, this should not be a "special" thing, and why would the list
> > > of deferred probe show this?
> >
> > Why as in why would it work/do what I want, or as in why would you want to do that?
>
> Both!  :)

So first: why would it work.
You seem to have a misconception that I am "messing with the probe
function list".
I am not, I am just exporting the information whether the device had a
driver which returned -EPROBE_DEFER during probe, or not. For that I am
looking at the presence of this device on the deferred_probe_pending_list.

driver_probe_device
-> if (ret == -EPROBE_DEFER || ret == EPROBE_DEFER) driver_deferred_probe_add(dev);
   -> list_add_tail(&dev->p->deferred_probe, &deferred_probe_pending_list);

driver_bound
-> driver_deferred_probe_del
   -> list_del_init(&dev->p->deferred_probe);

So the presence of "dev" inside deferred_probe_pending_list means
precisely that a driver is pending to be bound.

Second: why would I want to do that.
In the case of PHY devices, the driver binding process starts here:

phy_device_register
-> device_add

It begins synchronously, but may not finish due to probe deferral.
So after device_add finishes, phydev->drv might be NULL due to 2 reasons:

1. -EPROBE_DEFER triggered by "somebody", either by the PHY driver probe
   function itself, or by third parties (like device_links_check_suppliers
   happening to notice that before even calling the driver's probe fn).
   Anyway, the distinction between these 2 is pretty much irrelevant.

2. There genuinely was no driver loaded in the system for this PHY. Note
   that the way things are written, the Generic PHY driver will not
   match on any device in phy_bus_match(). It is bound manually, separately.

The PHY library is absolutely happy to work with a headless chicken, a
phydev with a NULL phydev->drv. Just search for "if (!phydev->drv)"
inside drivers/net/phy/phy.c and drivers/net/phy/phy_device.c.

However, the phydev walking with a NULL drv can only last for so long.
An Ethernet port will soon need that PHY device, and will attach to it.
There are many code paths, all ending in phy_attach_direct.
However, when an Ethernet port decides to attach to a PHY device is
completely asynchronous to the lifetime of the PHY device itself.
This moment is where a driver is really needed, and if none is present,
the generic one is force-bound.

My patch only distinguishes between case 1 and 2 for which phydev->drv
might be NULL. It avoids force-binding the generic PHY when a specific
PHY driver was found, but did not finish binding due to probe deferral.

> > > If a bus wants to have this type of "generic vs. specific" logic, then
> > > it needs to handle it in the bus logic itself as that does NOT fit into
> > > the normal driver model at all.  Don't try to get a "hint" of this by
> > > messing with the probe function list.
> >
> > Where and how? Do you have an example?
>
> No I do not, sorry, most busses do not do this for obvious ordering /
> loading / we are not that crazy reasons.
>
> What is causing this all to suddenly break?  The devlink stuff?

There was a report related to fw_devlink indeed, however strictly
speaking, I wouldn't say it is the cause of all this. It is pretty
uncommon for a PHY device to defer probing I think, hence the bad
assumptions made around it.

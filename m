Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1EE4958AC
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiAUDyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:54:40 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:53750
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233679AbiAUDyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:54:31 -0500
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A609D3F1C4
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 03:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642737265;
        bh=/qfmUciOYEO8XJhJTcmvwik+crZ7hTsDSnybic5K3Io=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=O5HGWTpHtwU2+FtNnuvi+e2g5Mzlh/tlryKCcj15bDU+CuRk8oJ3Jt3aPwt/oBp06
         D+Y51zj1F413VBPLKDRG/RIMS7TNnEVGqi6F+woNUcJcQCqcpGtGgs1VwiY69dAexU
         /3aP7PPJzEpmmSQFRAUcdwjmHKkvZZ2/QFSetVzRkTQp7ti8w+MNpIIrlkap7Pl6l9
         /8btjIIU8gbBmvjDQNlRo4HkBOSIK5vaMjcE31xnASqTwQ61Jtzcg/b2LFDpk/UJ7n
         Hq+OLImkARUUxdb3o5kqmQ3ou/5yjjXlBgp1d0moNzvfNE4ZWf3hLRLTVjUw18SKA2
         PhBkUsUUQfiUQ==
Received: by mail-oi1-f199.google.com with SMTP id v204-20020acaded5000000b002c896f409c4so5149848oig.6
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 19:54:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/qfmUciOYEO8XJhJTcmvwik+crZ7hTsDSnybic5K3Io=;
        b=bNF9qYEKris2DPEfXatgkXwP0SYHRsdpuLbIWWBQsg8TZC9to1jWHdycpEzr/qREcQ
         dKv5lFto5XNrlS6VUEnuNfNQWYs0NM9vsgycHndrfaGUP7mdVfZnHWdvXb+o1LW9ydXe
         t3AAbrq5RvtXReWMcLSl/wNOg7DPmaz5yhiFs9thN301EakL6+bixuaQN9i3RSFPIt0X
         E0Rkhb+xIYwAPT/IsVsrVcVq/uv/DqJzewR4rdi5rCprIOZ69eYGiql4YFOQpDTxiVbV
         Uqi196lpKqbdNDMTR+6OfHY1LQA5tuYGZv5JgWwQvPl6Du0bQ33DA1le1yQh3omaVNq8
         0nDw==
X-Gm-Message-State: AOAM5310zrY6yujXQe0ns9g36hyPsTjLfp4SbuDCJMP+CA6VF9fjGve4
        Lec3XekmW2YZauBmw5e6sLFBY8Satbxix4DkuGkXCMm5IAydnF0cfaZ9c3o3autuUwNpUgVZh2A
        Bd2/icESfXztW+bgdiQxTSy+s+p4YxcgpunU6/TNqJtp1/qP71w==
X-Received: by 2002:a9d:480e:: with SMTP id c14mr1497887otf.233.1642737262394;
        Thu, 20 Jan 2022 19:54:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxumutELwlkJ1LbF7ieXcxsoMfjpqlDCRYJLXNiBaEGXZ7YrJ1EBh/SKM0xWS9LaKrdEBUpoDw9vBdkIBgkLQ0=
X-Received: by 2002:a9d:480e:: with SMTP id c14mr1497880otf.233.1642737262070;
 Thu, 20 Jan 2022 19:54:22 -0800 (PST)
MIME-Version: 1.0
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com> <Yelnzrrd0a4Bl5AL@lunn.ch>
In-Reply-To: <Yelnzrrd0a4Bl5AL@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 21 Jan 2022 11:54:11 +0800
Message-ID: <CAAd53p45BbLy0T8AG5QTKhP00zMBsMHfm7i-bTmZmQWM5DpLnQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 9:46 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Jan 20, 2022 at 01:19:29PM +0800, Kai-Heng Feng wrote:
> > BIOS on Dell Edge Gateway 3200 already makes its own phy LED setting, so
> > instead of setting another value, keep it untouched and restore the saved
> > value on system resume.
>
> Please split this patch into two:
>
> Don't touch the LEDs
>
> Save and restore the LED configuration over suspend/resume.

Will split into two patch for next iteration.

>
> > -static void marvell_config_led(struct phy_device *phydev)
> > +static int marvell_find_led_config(struct phy_device *phydev)
> >  {
> > -     u16 def_config;
> > -     int err;
> > +     int def_config;
> > +
> > +     if (phydev->dev_flags & PHY_USE_FIRMWARE_LED) {
> > +             def_config = phy_read_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL);
> > +             return def_config < 0 ? -1 : def_config;
>
> What about the other two registers which configure the LEDs?

Do you mean the other two LEDs? They are not used on this machine.

>
> Since you talked about suspend/resume, does this machine support WoL?
> Is the BIOS configuring LED2 to be used as an interrupt when WoL is
> enabled in the BIOS? Do you need to save/restore that configuration
> over suspend/review? And prevent the driver from changing the
> configuration?

This NIC on the machine doesn't support WoL.

>
> > +static const struct dmi_system_id platform_flags[] = {
> > +     {
> > +             .matches = {
> > +                     DMI_MATCH(DMI_SYS_VENDOR, "Dell EMC"),
> > +                     DMI_MATCH(DMI_PRODUCT_NAME, "Edge Gateway 3200"),
> > +             },
> > +             .driver_data = (void *)PHY_USE_FIRMWARE_LED,
> > +     },
>
> This needs a big fat warning, that it will affect all LEDs for PHYs
> which linux is driving, on that machine. So PHYs on USB dongles, PHYs
> in SFPs, PHYs on plugin PCIe card etc.
>
> Have you talked with Dells Product Manager and do they understand the
> implications of this?

Right, that's why the original approach is passing the flag from the MAC driver.
That approach can be more specific and doesn't touch unrelated PHYs.

>
> > +     {}
> > +};
> > +
> >  /**
> >   * phy_attach_direct - attach a network device to a given PHY device pointer
> >   * @dev: network device to attach
> > @@ -1363,6 +1379,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
> >       struct mii_bus *bus = phydev->mdio.bus;
> >       struct device *d = &phydev->mdio.dev;
> >       struct module *ndev_owner = NULL;
> > +     const struct dmi_system_id *dmi;
> >       bool using_genphy = false;
> >       int err;
> >
> > @@ -1443,6 +1460,10 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
> >                       phydev_err(phydev, "error creating 'phy_standalone' sysfs entry\n");
> >       }
> >
> > +     dmi = dmi_first_match(platform_flags);
> > +     if (dmi)
> > +             phydev->dev_flags |= (u32)dmi->driver_data;
>
> Please us your new flag directly. We don't want this abused to pass
> any old flag to the PHY.

Will change it.

>
> > +
> >  /**
> >   * struct phy_device - An instance of a PHY
> >   *
> > @@ -663,6 +665,7 @@ struct phy_device {
> >
> >       struct phy_led_trigger *led_link_trigger;
> >  #endif
> > +     int led_config;
>
> You cannot put this here because you don't know how many registers are
> used to hold the configuration. Marvell has 3, other drivers can have
> other numbers. The information needs to be saved into the drivers on
> priv structure.

Ok.

>
> >
> >       /*
> >        * Interrupt number for this PHY
> > @@ -776,6 +779,12 @@ struct phy_driver {
> >        */
> >       int (*config_init)(struct phy_device *phydev);
> >
> > +     /**
> > +      * @config_led: Called to config the PHY LED,
> > +      * Use the resume flag to indicate init or resume
> > +      */
> > +     void (*config_led)(struct phy_device *phydev, bool resume);
>
> I don't see any need for this.

Ok.

Kai-Heng

>
>   Andrew

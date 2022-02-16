Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15FB4B7DC9
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343766AbiBPCbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:31:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343758AbiBPCbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:31:07 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E683F543C
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:30:56 -0800 (PST)
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8D76B3F339
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 02:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644978654;
        bh=DRpDpqQiuMMldgIWegtfvVNJCD2dQ9IK5RuKdfq/h34=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=H5UEtIe0dUWEaKkkWc5pW4VBsWHl7h8tYbDW99AZMBnRj9vCD2qr5zO/9T0TPTWCD
         bmiDMmeJj8zMQQhkEXpSTudmu6aq52fne369rNH7rgU02A0lmjEfhEI93Wd2PFUr/p
         NJfCwWayNhX9mE4evApH+X0vzN1IBlLFXrF0r2ctEmyx+XiQzhH2XVFbTj6hBMFEUX
         SMi/19p5Ad5AlXwx8tx982SqCp/m8Bs1p4PabsJm/smxFMXZMduj5fhSlRfh78yDXT
         Cg4CeEVLa1LVJKoWbMRp0ChCwaucwh7dDYJE8VLQg0W6ut3NSMeH1pU3IkkaBMudyO
         QM8yumAkeguxg==
Received: by mail-oo1-f70.google.com with SMTP id h13-20020a4aa74d000000b002e99030d358so518017oom.6
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:30:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DRpDpqQiuMMldgIWegtfvVNJCD2dQ9IK5RuKdfq/h34=;
        b=BPVqxZayi1uIu2IKx8RCe4pGsR1EDu9Qf7PPKLOcLJ61pj31bSnCx+rdT7gjbo9lMf
         fSVecpS5FtQZrdNg6d20Bh9+8P6v1oLkdEPAgPZcNLYAthLaTM+Ge3SRQmWu7zCoRs8B
         Zcg+2+sHXjbnIoq4yrXeqI1vtLb3XDRsWu5O34hr3Y6MvBz0b4zAAAeKZgjCTmZDi0uu
         Haxx9FyMTd2CVPNIm2636+bsdK5B3GUxmeRKtsG0L6Lb269W6KslvikJCKAa4/MU0H88
         60wBGmocBxP16rsG6HBhAtB2snvkm/XlxzBZf2Z4aC8h9GwqRmKmfItNZtfsOcUPhoR0
         m/uw==
X-Gm-Message-State: AOAM5328jY+xx3XTNCCdNBbUtUjzixVvbH3BBcH3Nb6QW8mLTuJ+Y9Qb
        I4/rkqH/72EexOSZxGzWPuGBAal50GliJFPxB7VyIMObFNJ7BX29MUYSurD862khZrZWGN0yQGl
        lyH/moxtn7iXLK4N7Y+B/Vqwe42/Xr+6+3qojDj+ZSzMuSqUmxg==
X-Received: by 2002:a05:6808:2110:b0:2d4:4137:b4fc with SMTP id r16-20020a056808211000b002d44137b4fcmr1437207oiw.111.1644978653243;
        Tue, 15 Feb 2022 18:30:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKcxvfa5TGSRV5o84na68B8EZ+r4ouH5y0ksyeGSQjbiQCwHBY/Dz9pUtQROobZB9JcDQDjlETALEg+JopC1o=
X-Received: by 2002:a05:6808:2110:b0:2d4:4137:b4fc with SMTP id
 r16-20020a056808211000b002d44137b4fcmr1437198oiw.111.1644978652934; Tue, 15
 Feb 2022 18:30:52 -0800 (PST)
MIME-Version: 1.0
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <YelxMFOiqnfIVmyy@lunn.ch> <CAAd53p7NjvzsBs2aWTP-3GMjoyefMmLB3ou+7fDcrNVfKwALHw@mail.gmail.com>
 <Yeqzhx3GbMzaIbj6@lunn.ch> <CAAd53p5pF+SRfwGfJaBTPkH7+9Z6vhPHcuk-c=w8aPTzMBxPcg@mail.gmail.com>
 <YerOIXi7afbH/3QJ@lunn.ch> <3d7b1ff0-6776-6480-ed20-c9ad61b400f7@gmail.com>
 <Yex0rZ0wRWQH/L4n@lunn.ch> <CAAd53p6pfuYDor3vgm_bHFe_o7urNhv7W6=QGxVz6c=htt7wLg@mail.gmail.com>
 <YgwMslde2OxOOp9d@lunn.ch>
In-Reply-To: <YgwMslde2OxOOp9d@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 16 Feb 2022 10:30:41 +0800
Message-ID: <CAAd53p4QXHe7XTv5ntsdnC1Z9EpDfXQECKHDEsRA++SEQSdbYQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 4:27 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Feb 14, 2022 at 01:40:43PM +0800, Kai-Heng Feng wrote:
> > On Sun, Jan 23, 2022 at 5:18 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > One more idea:
> > > > The hw reset default for register 16 is 0x101e. If the current value
> > > > is different when entering config_init then we could preserve it
> > > > because intentionally a specific value has been set.
> > > > Only if we find the hw reset default we'd set the values according
> > > > to the current code.
> > >
> > > We can split the problem into two.
> > >
> > > 1) I think saving LED configuration over suspend/resume is not an
> > > issue. It is probably something we will be needed if we ever get PHY
> > > LED configuration via sys/class/leds.
> > >
> > > 2) Knowing something else has configured the LEDs and the Linux driver
> > > should not touch it. In general, Linux tries not to trust the
> > > bootloader, because experience has shown bad things can happen when
> > > you do. We cannot tell if the LED configuration is different to
> > > defaults because something has deliberately set it, or it is just
> > > messed up, maybe from the previous boot/kexec, maybe by the
> > > bootloader. Even this Dell system BIOS gets it wrong, it configures
> > > the LED on power on, but not resume !?!?!. And what about reboot?
> >
> > The LED will be reconfigured correctly after each reboot.
> > The platform firmware folks doesn't want to restore the value on
> > resume because the Windows driver already does that. They are afraid
> > it may cause regression if firmware does the same thing.
>
> How can it cause regressions? Why would the Windows driver decide that
> if the PHY already has the correct configuration is should mess it all
> up? Have you looked at the sources and check what it does?

Unfortunately I don't and won't have access to the driver source for Windows.

>
> Anyway, we said that we need to save and restore the LED configuration
> over suspend/resume because at some point in the maybe distant future,
> we are going to support user configuration of the LEDs via
> /sys/class/leds. So you can add the needed support to the PHY driver.

OK.

>
> > This is an ACPI based platform and we are working on new firmware
> > property "use-firmware-led" to give driver a hint:
> > ...
> >     Scope (_SB.PC00.OTN0)
> >     {
> >         Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
> >         {
> >             ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device
> > Properties for _DSD */,
> >             Package (0x01)
> >             {
> >                 Package (0x02)
> >                 {
> >                     "use-firmware-led",
> >                     One
> >                 }
> >             }
> >         })
> >     }
> > ...
> >
> > Because the property is under PCI device namespace, I am not sure how
> > to (cleanly) bring the property from the phylink side to phydev side.
> > Do you have any suggestion?
>
> I'm no ACPI expert, but i think
> Documentation/firmware-guide/acpi/dsd/phy.rst gives you the basis:
>
>     During the MDIO bus driver initialization, PHYs on this bus are probed
>     using the _ADR object as shown below and are registered on the MDIO bus.
>
>       Scope(\_SB.MDI0)
>       {
>         Device(PHY1) {
>           Name (_ADR, 0x1)
>         } // end of PHY1
>
>         Device(PHY2) {
>           Name (_ADR, 0x2)
>         } // end of PHY2
>       }
>
> These are the PHYs on the MDIO bus. I _think_ that next to the Name,
> you can add additional properties, like your "use-firmware-led". This
> would then be very similar to DT, which is in effect what ACPI is
> copying. So you need to update this document with your new property,
> making it clear that this property only applies to boot, not
> suspend/resume. And fwnode_mdiobus_register_phy() can look for the
> property and set a flag in the phydev structure indicating that ACPI
> is totally responsible for LEDs at boot time.

The problem here is there's no MDIO bus in ACPI namespace, namely no
"Scope(\_SB.MDI0)" on this platform.

Since the phydev doesn't have a fwnode, the new property needs to be
passed from phylink to phydev, and right now I can't find a clean way
to do it.

Kai-Heng

>
>         Andrew

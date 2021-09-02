Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577163FF4F3
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbhIBUdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbhIBUdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:33:21 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8765C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 13:32:22 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id g8so3160258ilc.5
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 13:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bpfEvfQHHfm4a7cLUlxhEaEOy6czrpgLDcWklEvIxrE=;
        b=Y9n4c6YS07+e7ilmjFGk3nUoP/HgkWmKpgy/Ej9GG3J6Y0TonjjVA/4dS0ikgwdHjs
         2wp4lJzyNyqapuSuCSmGt37WthqxzTkpPYzVAGzSJuRMwdOIGEdQZjn5VJkejcrAva+C
         VKszJFuxI0fjM6B7cHjkq1FbR3Heq7q649EDdLWQh/jrMG2j6iaBDtIf/OCLndggSgSd
         xVss5L3+3VWFESKDD3phrLFhVcloPRCT7g8pfZQhQfFnWFATwqhR7yt4GA9J8iz5DDFG
         WkB0t3fNB40r617zglSNd2LGsaDghfQi3mQJ35xezhOPiZBDBrn9M9U+QVq8VQavo0dH
         zdeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bpfEvfQHHfm4a7cLUlxhEaEOy6czrpgLDcWklEvIxrE=;
        b=a+Z3X/igCQ+kDJtzeHjdtK/2XW8OOqbAcqnzC2sVVkLjcguMe3ghUv77w7uBg13fxn
         vB8tG8gYZt+ZKd2i2yBYr89KpjYMevi0iA+jBe6dS0CSOyXSO9zc8hWS/WzBo8cTVFS5
         4uaziKzwhYVCJ1BhuEIVVP4dcY0RqMUuSLNOcOGa7IxbxdHwk5Fnep/EG04DEWSAeWnL
         EXTJNHF6IPQfaoqaHvVX5fnpNChqpyy18v8IMlfkFy00aZ8ToxBqvkk9o1zC3DH+3RIU
         4/iMQx9of2oUS06l047avMKir7rNQ+2SUZKMhcQyHm1GxhluudF8kDzsXQpuIpT0j3w1
         FAGA==
X-Gm-Message-State: AOAM5321iX+QCrDAVy9OBshckRjgAFIi2FGLxN99pjq3+5JZiXwRaa5q
        RkChZdU1f9cdsSP0bphbbIaIwF6GkoG7l/M0pyHo6t0foPpRXoRRQZQ=
X-Google-Smtp-Source: ABdhPJzzL/UFCE1MgQaYdkv3HfdqRHJUzQUtmeujGTrc7jnwMscnMP3zRSsZGILsJFFmH7RHwWd+FkEMNEOXKvEanj8=
X-Received: by 2002:a92:ca0a:: with SMTP id j10mr32317ils.192.1630614742336;
 Thu, 02 Sep 2021 13:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210831193425.26193-1-gerhard@engleder-embedded.com>
 <20210831193425.26193-4-gerhard@engleder-embedded.com> <YS6lQejOJJCATMCp@lunn.ch>
 <CANr-f5zXWrqPxWV81CT6=4O6PoPRB0Qs0T=egJ3q8FMG16f6xw@mail.gmail.com> <YS/qQdmjT/X0tiEt@lunn.ch>
In-Reply-To: <YS/qQdmjT/X0tiEt@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Thu, 2 Sep 2021 22:32:10 +0200
Message-ID: <CANr-f5wU0JTqwoHoFEwdFCVSYtcohx-DPc4mz8-GrVFpyNuajA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] tsnep: Add TSN endpoint Ethernet MAC driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > +static int tsnep_ethtool_set_priv_flags(struct net_device *netdev,
> > > > +                                     u32 priv_flags)
> > > > +{
> > > > +     struct tsnep_adapter *adapter = netdev_priv(netdev);
> > > > +     int retval;
> > > > +
> > > > +     if (priv_flags & ~TSNEP_PRIV_FLAGS)
> > > > +             return -EINVAL;
> > > > +
> > > > +     if ((priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_100) &&
> > > > +         (priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_1000))
> > > > +             return -EINVAL;
> > > > +
> > > > +     if ((priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_100) &&
> > > > +         adapter->loopback != SPEED_100) {
> > > > +             if (adapter->loopback != SPEED_UNKNOWN)
> > > > +                     retval = phy_loopback(adapter->phydev, false);
> > > > +             else
> > > > +                     retval = 0;
> > > > +
> > > > +             if (!retval) {
> > > > +                     adapter->phydev->speed = SPEED_100;
> > > > +                     adapter->phydev->duplex = DUPLEX_FULL;
> > > > +                     retval = phy_loopback(adapter->phydev, true);
> > >
> > > This is a pretty unusual use of private flags, changing loopback at
> > > runtime. ethtool --test generally does that.
> > >
> > > What is your use case which requires loopback in normal operation, not
> > > during testing?
> >
> > Yes it is unusual. I was searching for some user space interface for loopback
> > and found drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c which uses
> > private flags.
>
> Ah, that passed my by. I would of probably said something about it.
>
> > Use case is still testing and not normal operation. Testing is done mostly with
> > a user space application, because I don't want to overload the driver with test
> > code and test frameworks can be used in user space. With loopback it is
> > possible to execute a lot of tests like stressing the MAC with various frame
> > lengths and checking TX/RX time stamps. These tests are useful for every
> > integration of this IP core into an FPGA and not only for IP core development.
>
> I did a quick search. CAN has something interesting:
>
> https://wiki.rdu.im/_pages/Application-Notes/Software/can-bus-in-linux.html
> $ sudo ip link set can0 down
> $ sudo ip link set can0 type can loopback on
> $ sudo ip link set can0 up type can bitrate 1000000
>
> Also
>
> https://www.kernel.org/doc/Documentation/networking/can.txt
>
> The semantics are maybe slightly different. It appears to loopback can
> messages, but also send out the wire. I think many can transcievers
> can do this in hardware, but this seems to be a software feature for
> when the hardware cannot do it? I have seen Ethernet PHYs which do
> send out the wire when in loopback, so it does seem like a reasonable
> model. Also i like that you need to down the interface before you can
> put it into loopback. Saves a lot of surprises.
>
> Maybe you can look at this, see if it can be made generic, and could
> be used here?

In contrast to CAN, Ethernet loopback is only useful for testing. Even if some
Ethernet PHYs send out the wire when in loopback, reception from the wire
is not possible because it will conflict with the looped back frame (Ethernet is
full duplex capable, CAN not). Ethernet link behavior is configured
with ethtool,
so I was searching for some ethtool interface.

I will take a look at CAN loopback support.

> > > > +static irqreturn_t tsnep_irq(int irq, void *arg)
> > > > +{
> > > > +     struct tsnep_adapter *adapter = arg;
> > > > +     u32 active = ioread32(adapter->addr + ECM_INT_ACTIVE);
> > > > +
> > > > +     /* acknowledge interrupt */
> > > > +     if (active != 0)
> > > > +             iowrite32(active, adapter->addr + ECM_INT_ACKNOWLEDGE);
> > > > +
> > > > +     /* handle management data interrupt */
> > > > +     if ((active & ECM_INT_MD) != 0) {
> > > > +             adapter->md_active = false;
> > > > +             wake_up_interruptible(&adapter->md_wait);
> > > > +     }
> > > > +
> > > > +     /* handle link interrupt */
> > > > +     if ((active & ECM_INT_LINK) != 0) {
> > > > +             if (adapter->netdev->phydev) {
> > > > +                     struct phy_device *phydev = adapter->netdev->phydev;
> > > > +                     u32 status = ioread32(adapter->addr + ECM_STATUS);
> > > > +                     int link = (status & ECM_NO_LINK) ? 0 : 1;
> > > > +                     u32 speed = status & ECM_SPEED_MASK;
> > >
> > > How does PHY link and speed get into this MAC register? Is the MAC
> > > polling the PHY over the MDIO bus? Is the PHY internal to the MAC and
> > > it has backdoor access to the PHY status?
> >
> > PHY is external. The MAC expects additional signals for link status. These
> > signals can be derived from RGMII in band signaling of the link status or by
> > using PHY link and speed LED outputs. The MAC is using the link status for
> > a quick no link reaction to minimize the impact to real time applications.
> > EtherCAT for example also uses the link LED output for a no link reaction
> > within a few microseconds.
>
> O.K. This is not the normal Linux way. You normally have the PHY
> driver tell the PHY core, which then tells the MAC driver. That always
> works. RGMII in band signaling is not supported by all PHY devices,
> and the board design would require the LED output are correctly
> connected, and i guess you need a hacked PHY driver to use the correct
> LED meanings? Plus i guess you have additional changes in the PHY
> driver to do fast link down detection?

Yes, LED outputs must be correctly connected in the board design. LED
outputs are usually configured with strapping pins, which again require a
correct board design. Fast link down detection is a hardware property of
the selected PHY. So far no PHY driver changes were necessary.

> I think this needs another DT property to enable using such short
> cuts, and you should use the Linux way by default.

Isn't choosing PHY_MAC_INTERRUPT also the Linux way? I preferred it
over PHY_POLL, because I need the link information directly in the MAC
anyway. But maybe the speed information is too much and should be provided
to the MAC.

> Also, don't you need a property which tells you to either use RGMII
> inband, or LED signals?

No, this decision is done in VHDL/FPGA. No need to consume precious FPGA
resources for runtime configuration.

> > > > +static int tsnep_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
> > > > +{
> > > > +     struct tsnep_adapter *adapter = bus->priv;
> > > > +     u32 md;
> > > > +     int retval;
> > > > +
> > > > +     if (regnum & MII_ADDR_C45)
> > > > +             return -EOPNOTSUPP;
> > > > +
> > > > +     /* management data frame without preamble */
> > > > +     md = ECM_MD_READ;
> > >
> > > I know some PHYs are happy to work without a preamble. But as far as i
> > > know, 802.3 c22 does not say it is optional. So this needs to be an
> > > opt-in feature, for when you know all the devices on the bus support
> > > it. We have a standard DT property for this. See mdio.yaml,
> > > suppress-preamble. Please look for this in the DT blob, and only
> > > suppress the pre-amble if it is present.
> >
> > You are right, I will improve that.
>
> You might also be interested in clock-frequency, if you can control
> the bus frequency. I've run Marvell PHYs at i think 8Mhz, rather than
> the usual 2.5MHz.

Thank you for the information. Currently the frequency cannot be controlled
and is fixed at 2.5MHz.

> > > > +static int tsnep_phy_init(struct tsnep_adapter *adapter)
> > > > +{
> > > > +     struct device_node *dn;
> > > > +     int retval;
> > > > +
> > > > +     retval = of_get_phy_mode(adapter->pdev->dev.of_node,
> > > > +                              &adapter->phy_mode);
> > > > +     if (retval)
> > > > +             adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
> > > > +
> > > > +     dn = of_parse_phandle(adapter->pdev->dev.of_node, "phy-handle", 0);
> > > > +     adapter->phydev = of_phy_find_device(dn);
> > > > +     of_node_put(dn);
> > > > +     if (!adapter->phydev && adapter->mdiobus)
> > > > +             adapter->phydev = phy_find_first(adapter->mdiobus);
> > >
> > > Do you actually need phy_find_first()? It is better to have it in DT.
> >
> > I thought it is a reasonable fallback, because then PHY can be ommited in
> > DT (lazy developer, unknown PHY address during development, ...).
>
> It is a reasonable fallback, until it goes wrong, because you have two
> PHYs on the bus etc.
>
> > Driver
> > and IP core will be used also on x86 over PCIe without DT. In this case this
> > fallback also makes sense. But I must confess, the driver is not ready for
> > x86 use case yet.
>
> We recently added ACPI properties. See
> Documentation/firmware-guide/acpi/dsd/phy.rst.

I'm afraid that relying on ACPI is not always an option. x86 CPU modules are
very often used in industrial automation and the BIOS of the CPU module is
usually not adapted to the carrier board. Also other drivers implement
a fallback
like this. Shall I still remove it?

> Also, watch out. It might not be ready, but it will get compiled for
> x86, mips, powerpc etc, by the build bots, if you don't prevent it. So
> it needs to at least be warning free.

Yes, of course!

Gerhard

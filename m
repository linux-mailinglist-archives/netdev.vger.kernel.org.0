Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F35400633
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 21:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349686AbhICTzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 15:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbhICTzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 15:55:04 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0134C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 12:54:03 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id g8so135144ilc.5
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 12:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WhUkEmPqCcDJAYSx7n9rl5f9Im7JA8BFKLZ4EdK5U7s=;
        b=AH6yS0qtb4wGIkbWMNJTTnJkvJuMioZNblzcidzAo4jUWPlAGjNqEDmB4WYN27TU/2
         xP4KfZdKjBzCf6JT8CgyDrwaZdVoZCsaKbDFdas5bj6V22ACpFeX1sg86mW3bYjAalkV
         jlA0KG1VthpimpDeU/b3yvgMOrtxaP1SKisLh9S3I99hfsXQL4k/SrduXA0jCPYgbTQA
         ptKqQOKDTXPtXcVtBmPwuPnTMMDyT0s4bEEW1AM15RLkazu1TbfZRLtfXVNc/54viU51
         m1HzrFHLfGs72tiI4IwFMW3W7lTVnowNpxgAZrLs45Dt5Wr74WtyrWRv9tgAsnX0o8fc
         wwhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WhUkEmPqCcDJAYSx7n9rl5f9Im7JA8BFKLZ4EdK5U7s=;
        b=ZSkJeRVvjqxxHF8tU85ueQxz8w183AGOjhwOQLzbuR2TmSar0EFZRj+mR/b9WHEdcj
         5n59op8NB/c3T80GH+neozaPiaGn9mEBO2XIlhfGeCis0kxk8NI1/RA6DnFryNMQc8+d
         m1Xw3FnQuTdgrYUUCSOXbxBasaFw7S2kwcBWttPF9EwNdPEZvw0uS1G2KMOc05KxeWqM
         gTrTgF+P4kO9yC1LdjkmzPxiA7UUjIxU+HtBoC6zUnMPdWFxExm74tp4xR81dMq33sKI
         efuRuW2WtBnnaDcVSchXRbnFMdswUaReDd3NdfRP2Vqq69gQIdsp8SSgyCqH6o6B0A05
         /Bcg==
X-Gm-Message-State: AOAM531Hs6E1YJA1bBMDmpLY82h+/RfXA6sb+ffxii7tjq7wkewXGdbP
        mjE3AnJuol9D+isKcuGDA6RD5xvYN0YG7Z2hkQO+Rg==
X-Google-Smtp-Source: ABdhPJxUt6K9CNI+ofNIPhR+qmvS+X62FrTVZ8AS+QG+X3gWIh0mimgONY80QXwueTd37786K2D+ff9cQF0hXtE/6VU=
X-Received: by 2002:a05:6e02:20cd:: with SMTP id 13mr457664ilq.156.1630698842742;
 Fri, 03 Sep 2021 12:54:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210831193425.26193-1-gerhard@engleder-embedded.com>
 <20210831193425.26193-4-gerhard@engleder-embedded.com> <YS6lQejOJJCATMCp@lunn.ch>
 <CANr-f5zXWrqPxWV81CT6=4O6PoPRB0Qs0T=egJ3q8FMG16f6xw@mail.gmail.com>
 <YS/qQdmjT/X0tiEt@lunn.ch> <CANr-f5wU0JTqwoHoFEwdFCVSYtcohx-DPc4mz8-GrVFpyNuajA@mail.gmail.com>
 <YTFAc/vMXTKdFSHL@lunn.ch>
In-Reply-To: <YTFAc/vMXTKdFSHL@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Fri, 3 Sep 2021 21:53:51 +0200
Message-ID: <CANr-f5xksPeHJJFF0Qq65tX_sCqmWgxkD0q0LcChWzoC5hiR3Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] tsnep: Add TSN endpoint Ethernet MAC driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > > > +static irqreturn_t tsnep_irq(int irq, void *arg)
> > > > > > +{
> > > > > > +     struct tsnep_adapter *adapter = arg;
> > > > > > +     u32 active = ioread32(adapter->addr + ECM_INT_ACTIVE);
> > > > > > +
> > > > > > +     /* acknowledge interrupt */
> > > > > > +     if (active != 0)
> > > > > > +             iowrite32(active, adapter->addr + ECM_INT_ACKNOWLEDGE);
> > > > > > +
> > > > > > +     /* handle management data interrupt */
> > > > > > +     if ((active & ECM_INT_MD) != 0) {
> > > > > > +             adapter->md_active = false;
> > > > > > +             wake_up_interruptible(&adapter->md_wait);
> > > > > > +     }
> > > > > > +
> > > > > > +     /* handle link interrupt */
> > > > > > +     if ((active & ECM_INT_LINK) != 0) {
> > > > > > +             if (adapter->netdev->phydev) {
> > > > > > +                     struct phy_device *phydev = adapter->netdev->phydev;
> > > > > > +                     u32 status = ioread32(adapter->addr + ECM_STATUS);
> > > > > > +                     int link = (status & ECM_NO_LINK) ? 0 : 1;
> > > > > > +                     u32 speed = status & ECM_SPEED_MASK;
> > > > >
> > > > > How does PHY link and speed get into this MAC register? Is the MAC
> > > > > polling the PHY over the MDIO bus? Is the PHY internal to the MAC and
> > > > > it has backdoor access to the PHY status?
> > > >
> > > > PHY is external. The MAC expects additional signals for link status. These
> > > > signals can be derived from RGMII in band signaling of the link status or by
> > > > using PHY link and speed LED outputs. The MAC is using the link status for
> > > > a quick no link reaction to minimize the impact to real time applications.
> > > > EtherCAT for example also uses the link LED output for a no link reaction
> > > > within a few microseconds.
> > >
> > > O.K. This is not the normal Linux way. You normally have the PHY
> > > driver tell the PHY core, which then tells the MAC driver. That always
> > > works. RGMII in band signaling is not supported by all PHY devices,
> > > and the board design would require the LED output are correctly
> > > connected, and i guess you need a hacked PHY driver to use the correct
> > > LED meanings? Plus i guess you have additional changes in the PHY
> > > driver to do fast link down detection?
> >
> > Yes, LED outputs must be correctly connected in the board design. LED
> > outputs are usually configured with strapping pins, which again require a
> > correct board design.
>
> Linux sometime, maybe soon, will be able the control the PHY LEDs, and
> probably export them to user space so root can change their meaning.
>
> > Fast link down detection is a hardware property of the selected
> > PHY. So far no PHY driver changes were necessary.
>
> Marvell PHYs for example follow 802.3 C40 and default to waiting 750ms
> before reporting the link down. You can configure them to only wait
> 10ms, 20ms or 40ms. So it sounds like you are using a PHY which does
> not conform to C40? In general, we probably need to be able to
> configure this, for those that do follow C40.
>
> > > I think this needs another DT property to enable using such short
> > > cuts, and you should use the Linux way by default.
> >
> > Isn't choosing PHY_MAC_INTERRUPT also the Linux way? I preferred it
> > over PHY_POLL, because I need the link information directly in the MAC
> > anyway. But maybe the speed information is too much and should be provided
> > to the MAC.
>
> PHY_MAC_INTERRUPT is just the first step. It means something happened
> in the PHY. You need to ask the PHY what? It could be link up or down,
> it could be cable diagnostics have finished, the temperature is
> getting too hot, whatever can cause the PHY to change state. The PHY
> driver will then determine what has actually happened. Some cases, the
> MAC does not needed to know. Others the MAC will be told, via the
> callback it registered. It gets to know the link speed, up down etc.
> That is the Linux way, the complete chain.

I will reduce the MAC knowledge to "something happened" and let the driver
tell it what. Driver and VHDL will be changed.

> > > Also, don't you need a property which tells you to either use RGMII
> > > inband, or LED signals?
> >
> > No, this decision is done in VHDL/FPGA. No need to consume precious FPGA
> > resources for runtime configuration.
>
> You mean you have two ways to synthesis the MAC. You have two
> bitstreams. One for LEDs and one of inband RGMII?

No, not two bitstreams. Just board specific glue logic around the IP core.
As mentioned above, it will be changed.

> > I'm afraid that relying on ACPI is not always an option. x86 CPU modules are
> > very often used in industrial automation and the BIOS of the CPU module is
> > usually not adapted to the carrier board.
>
> Yes, i've been there. I have managed to get the BIOS customised, but
> it is not easy. DT is much easier to use.

Yes, it is not easy and it makes you cry when you have to switch to a different
CPU module.

Gerhard

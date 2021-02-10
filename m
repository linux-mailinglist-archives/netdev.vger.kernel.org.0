Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53431317466
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbhBJXaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbhBJXak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 18:30:40 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28E4C061756
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 15:29:59 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id x19so1076886ybe.0
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 15:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MfvAlJS6MDThBR93eBM8Kuwg+g9RRXOQOpVXLQT/p8w=;
        b=AO0rWQGlUWpJkMZF2QG+N2z6oIAl+/5IN78xVvptElOJ4vH3pLlxXzRojB1+486zPN
         JpqhNhH7o1roOSEhRKJP8+ltwQ9gSUHqHYNQS652gDPbi3ocThUSL984qg6xrqqLk2py
         zRgDZdkofpBDcgcW27d2nS/Ksh0X3qMob+Jh0T4M+SWXkugv/xt9yZsX+lDCmUds4FQd
         bP7ryeqZpbgA04rUVzHq50jwS35GzMHjFIk2ws1TiY1yQRGuko6VrNWmLwRKJo9oSIpJ
         GGvvLmJeqS6nC+LfpaPUImUZh4iJqN5oAeRkq9ywHN2TH4pu8uxdnp7QpdlnUVO1TnRS
         7bZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MfvAlJS6MDThBR93eBM8Kuwg+g9RRXOQOpVXLQT/p8w=;
        b=lGN7d+WAlI/Xch8OvDydKN+XOhImJ/OQBBLSxkWTOCGWHqBpBw0VR2XgunNDwqsebn
         HKglihO6MTW4cu2htxrzwkrC0K7MmQpDGoXDZd/FwxgoGbw4UCuaK0h2CZ8FifI6OolJ
         +qdBG3IACfBbAA7gMZi7EYDjQ+Sk7eSKYx2l871Nd/HzwTd+iFM35DuSu/i/Wil1dtxF
         X5/gVm9Hme5fIqHAS6j1advtC9gjQ5qN79euCDfu/PsG4K4gS72ihALzLQs+L0v58mB/
         paZEuEU/vNKR72KXxEmIi4a3lYxBspaZpe5apZSkWQVldz2dpwtHAEuHgHc2VLWhbrpw
         zFgw==
X-Gm-Message-State: AOAM533AoTpaQQulJ/Xsxp3kZRixHI5/LVn16Rhekpd8B8TaL8mzM6F7
        93q1mnVG28a+WRmVbFuvd6xz3ip/izo5ynsWqjiJiA==
X-Google-Smtp-Source: ABdhPJw5B1DUqPG6B2amdfFSGmzNUyTqXAvC+bDvXpk/9IVdgtBUzQYMC/PTT2Y8jPexn8qMPSA3w2AZCIm7FjRJKlE=
X-Received: by 2002:a25:af0b:: with SMTP id a11mr7449292ybh.228.1612999798394;
 Wed, 10 Feb 2021 15:29:58 -0800 (PST)
MIME-Version: 1.0
References: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
 <YCRjmpKjK0pxKTCP@lunn.ch>
In-Reply-To: <YCRjmpKjK0pxKTCP@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 10 Feb 2021 15:29:22 -0800
Message-ID: <CAGETcx-tBw_=VPvQVYcpPJBJjgQvp8UASrdMdSbSduahZpJf9w@mail.gmail.com>
Subject: Re: phy_attach_direct()'s use of device_bind_driver()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
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

On Wed, Feb 10, 2021 at 2:52 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Feb 10, 2021 at 02:13:48PM -0800, Saravana Kannan wrote:
> > Hi,
> >
> > This email was triggered by this other email[1].
> >
> > Why is phy_attach_direct() directly calling device_bind_driver()
> > instead of using bus_probe_device()?
>
> Hi Saravana
>
> So this is to do with the generic PHY, which is a special case.
>
> First the normal case. The MDIO bus driver registers an MDIO bus using
> mdiobus_register(). This will enumerate the bus, finding PHYs on
> it. Each PHY device is registered with the device core, using the
> usual device_add(). The core will go through the registered PHY
> drivers and see if one can drive this hardware, based on the ID
> registers the PHY has at address 2 and 3. If a match is found, the
> driver probes the device, all in the usual way.
>
> Sometime later, the MAC driver wants to make use of the PHY
> device. This is often in the open() call of the MAC driver, when the
> interface is configured up. The MAC driver asks phylib to associate a
> PHY devices to the MAC device. In the normal case, the PHY has been
> probed, and everything is good to go.
>
> However, sometimes, there is no driver for the PHY. There is no driver
> for that hardware. Or the driver has not been built, or it is not on
> the disk, etc. So the device core has not been able to probe
> it. However, IEEE 802.3 clause 22 defines a minimum set of registers a
> PHY should support. And most PHY devices have this minimum. So there
> is a fall back driver, the generic PHY driver. It assumes the minimum
> registers are available, and does its best to drive the hardware. It
> often works, but not always. So if the MAC asks phylib to connect to a
> PHY which does not have a driver, we forcefully bind the generic
> driver to the device, and hope for the best.

Thanks for the detailed answer Andrew! I think it gives me enough
info/context to come up with a proper fix.

> We don't actually recommend using the generic driver. Use the specific
> driver for the hardware. But the generic driver can at least get you
> going, allow you to scp the correct driver onto the system, etc.

I'm not sure if I can control what driver they use. If I can fix this
warning, I'll probably try to do that.

-Saravana

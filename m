Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D4E3FD0E7
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241693AbhIABsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241643AbhIABse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:48:34 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A8BC061760
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 18:47:36 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id k65so2044400yba.13
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 18:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bUppOyGDnS2PXlyA+AfNJ4qIRCwjAsIJpMZ2OY0NEas=;
        b=qGCxpFM9x4A+ZKqPCXlem1JBCqKYPgiuQusam80EPcStiBfQng/KZ/G3b/LP68akmW
         zEaTndaIysWsJpcxt6hR9hHDEfMCqu8v38hwGwgs/IlQGrL/+8KCOvZUgdNMhefkn7q5
         EXk4WwuWjsfUImzdGsFxk1gY9tsLUfltarLgVUPMnfmZa9OSfXV9IASKvll1Y/ZAaYfj
         jVdbTgdgw8UX63yyKZDB8KktBcqwQ27AoR1ndreMh+PbCl+9T0dJ8gXHUkAy2C81lUpb
         Z+iAK3Qlrc6NBz+pgwyafuFloR1ERVUjKvxwxBHPehD51BabKfZOl0v4tqEkDbghg1f1
         21HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bUppOyGDnS2PXlyA+AfNJ4qIRCwjAsIJpMZ2OY0NEas=;
        b=n1K8I3NCAuUIYGvmyos3ukYRt7Ymiiz4tekhoI+v+L6f8Xf741YJckphrraO2F8NM8
         AgpqsqmkoSRLbX+ANNr5YJeuIGxIuJgIU2Cx0DbLuKD3UWp2pdfMYzxiyx+pwIAEA515
         PwGp4lLXkaXZ/MDcWcG3sB96U7Xi0vyAWXflP+Bc8fyjSdiTnL/S6QYX166Y7Mlrykr7
         TXpd/EkCmT+Z14jEhEAW85lQoHjY5xUD1zLT4mFm2zCR+IJFhec+Dyyf1vysvjcj6Sj1
         DvWyx36t1IAf3lo7XBSnwh76g25QCsuglGzyVZY3d/eCOMD3U2ZdkoWZar7H3Pc9pabP
         FmUA==
X-Gm-Message-State: AOAM530CurtPA5XL4pHa5UCu09RWJxu15kMszMV5bJSP9dFBo3NpM0tj
        kFxs/8WHhSX7VHPRIEOkDh/U+kHQZU2yBSCkdnhIpw==
X-Google-Smtp-Source: ABdhPJyT6CUc0oxZ8hx9Xt/8WMw+Mrp1K9LbFgvg4hs/hLtHbEkLXskLrbTTMyyO0RGV8pIWeqtq2eb9U/wHNA4o8lo=
X-Received: by 2002:a25:81ce:: with SMTP id n14mr35769623ybm.32.1630460855812;
 Tue, 31 Aug 2021 18:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <YSjsQmx8l4MXNvP+@lunn.ch> <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch> <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch> <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch> <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch> <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
In-Reply-To: <YS608fdIhH4+qJsn@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 31 Aug 2021 18:46:59 -0700
Message-ID: <CAGETcx_FgDkUSkKG=d9b0Drtcy3BySmTwy1Mzhz0GatmxO5tFg@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 4:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > If the switches are broken without the phy-handle or ethernet change,
> > I'm not sure if the "BROKEN_PARENT" patch would help.
>
> > > Which is not enough to fix these Ethernet switches.
> >
> > Ok, if you can give more specifics on this, I'll look into it.
>
> The switches probe, but get the wrong PHY driver, genphy, not the
> Marvell PHY driver. And genphy is not sufficient for this hardware.
>
> I'd need:
> > 1) The DTS file that you see the issue on.
>
> I did the bisect on arch/arm/boot/dts/vf610-zii-dev-rev-c.dts but i
> also tested arch/arm/boot/dts/vf610-zii-dev-rev-b.dts.

Thanks for the detailed info Andrew. I looked at the DT files. So
yeah, this is similar to the realtek issue and my generic fix for DSA
should work for all of these unless I'm forgetting something. Please
let me know if it doesn't.

-Saravana

> Rev B is interesting because switch0 and switch1 got genphy, while
> switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
> interrupt properties, so don't loop back to their parent device.
>
> Here is Rev B. I trimmed out other devices probing in parallel:
>
> [    1.029100] fec 400d1000.ethernet: Invalid MAC address: 00:00:00:00:00:00
> [    1.034735] fec 400d1000.ethernet: Using random MAC address: 42:f2:14:33:78:f5
> [    1.042272] libphy: fec_enet_mii_bus: probed
> [    1.455932] libphy: mdio_mux: probed
> [    1.459432] mv88e6085 0.1:00: switch 0x3520 detected: Marvell 88E6352, revision 1
> [    1.494076] libphy: mdio: probed
> [    1.518958] libphy: mdio_mux: probed
> [    1.522553] mv88e6085 0.2:00: switch 0x3520 detected: Marvell 88E6352, revision 1
> [    1.537295] libphy: mdio: probed
> [    1.556571] libphy: mdio_mux: probed
> [    1.559719] mv88e6085 0.4:00: switch 0x1a70 detected: Marvell 88E6185, revision 2
> [    1.574614] libphy: mdio: probed
> [    1.733104] mv88e6085 0.1:00 lan0 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:00] driver [Generic PHY] (irq=POLL)
> [    1.750737] mv88e6085 0.1:00 lan1 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
> [    1.768273] mv88e6085 0.1:00 lan2 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
> [    1.806561] mv88e6085 0.2:00 lan3 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:00] driver [Generic PHY] (irq=POLL)
> [    1.824033] mv88e6085 0.2:00 lan4 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
> [    1.841496] mv88e6085 0.2:00 lan5 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
> [    1.943535] mv88e6085 0.4:00 lan6 (uninitialized): PHY [!mdio-mux!mdio@4!switch@0!mdio:00] driver [Marvell 88E1545] (irq=POLL)
> [    2.003529] mv88e6085 0.4:00 lan7 (uninitialized): PHY [!mdio-mux!mdio@4!switch@0!mdio:01] driver [Marvell 88E1545] (irq=POLL)
> [    2.063535] mv88e6085 0.4:00 lan8 (uninitialized): PHY [!mdio-mux!mdio@4!switch@0!mdio:02] driver [Marvell 88E1545] (irq=POLL)
> [    2.084768] DSA: tree 0 setup
> [    2.087791] libphy: mdio_mux: probed
> [    2.265477] Micrel KSZ8041 400d0000.ethernet-1:00: attached PHY driver (mii_bus:phy_addr=400d0000.ethernet-1:00, irq=POLL)
>
> root@zii-devel-b:~# cat /sys/kernel/debug/devices_deferred
> root@zii-devel-b:~#
>
> For Rev C we see:
>
> [    1.244417] fec 400d1000.ethernet: Invalid MAC address: 00:00:00:00:00:00
> [    1.250081] fec 400d1000.ethernet: Using random MAC address: c6:42:89:ed:5f:dd
> [    1.257507] libphy: fec_enet_mii_bus: probed
> [    1.570725] libphy: mdio_mux: probed
> [    1.574208] mv88e6085 0.1:00: switch 0xa10 detected: Marvell 88E6390X, revision 1
> [    1.590272] libphy: mdio: probed
> [    1.627721] libphy: mdio_mux: probed
> [    1.631222] mv88e6085 0.2:00: switch 0xa10 detected: Marvell 88E6390X, revision 1
> [    1.659643] libphy: mdio: probed
> [    1.811665] mv88e6085 0.1:00 lan1 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
> [    1.829230] mv88e6085 0.1:00 lan2 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
> [    1.845884] mv88e6085 0.1:00 lan3 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:03] driver [Generic PHY] (irq=POLL)
> [    1.863237] mv88e6085 0.1:00 lan4 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:04] driver [Generic PHY] (irq=POLL)
> [    1.884078] mv88e6085 0.2:00 lan5 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
> [    1.901630] mv88e6085 0.2:00 lan6 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
> [    1.918287] mv88e6085 0.2:00 lan7 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:03] driver [Generic PHY] (irq=POLL)
> [    1.933721] mv88e6085 0.2:00 lan8 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:04] driver [Generic PHY] (irq=POLL)
> [    1.948722] DSA: tree 0 setup
> [    1.951599] libphy: mdio_mux: probed
>
> [   21.565550] Micrel KSZ8041 400d0000.ethernet-1:00: attached PHY driver (mii_bus:phy_addr=400d0000.ethernet-1:00, irq=48)
>
> I have Rev B using NFS root, so the interfaces are configured up by
> the kernel during boot. Rev C has a local root filesystem, so user
> space brings the interfaces up, and it is only when the FEC is opened
> does it attach to the Micrel PHY. That explains the difference between
> 2.265 and 21.565 seconds for the last line.
>
> Again, nothing deferred.
>
>        Andrew

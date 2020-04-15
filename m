Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B271AAB68
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 17:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371239AbgDOPHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 11:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389590AbgDOPH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 11:07:29 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BC3C061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 08:07:29 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id k133so13006063oih.12
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 08:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJ/egVWRNDuUrA/1e/qFDXWs5Qc4J9+ABqHJ5tB4g3c=;
        b=iWw1bOn3loZLesgeK5vvFlv/vbKF1B9cNeqqd8NzRsrGERu7XHxYHXWJ5Vj2aIKqQt
         ALZSRzXYFGnpipKbpX9Mj6K4dlBHCsyPxQWdqycQN4uudHiPdiNQ0A4222J8g43ypldP
         OoxNb0rt9UnzHvWxrcg9sL819b/jYP4eu3+0EmNCdVKPHvJcY9vtyTYzET+LtNy8PYxy
         w5zNHoiUMDb8nwu0Ak6Y43R2eh/vABGjwHeVRBBsoy1i6JORJ6gx1bi4NriKKzTDSfEW
         +T7kNtgF2mUJ+v+m5uG2JWiihzllu8oTQDSg0pj7Z+C/Og4Ys6uPJ1cmXJnz3/1755By
         AQYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJ/egVWRNDuUrA/1e/qFDXWs5Qc4J9+ABqHJ5tB4g3c=;
        b=cV+Pv/uVj48CI3WCCQY0wy9qqNDK5tcpw3mC0sl0Bd0//lN1Te19kkyDPdlqBYQXy3
         lkzQLU2BwfgwsGohAn3m7DkyhAYKbTiWJxrmVYpCHTSr/0jvqh7uv5YT4GWvRoa4BXix
         TYPLipPBxE1O4ehl+fXrxseJ7z3VzlYZsXS5tJq7rAtNnmnI2f4nqwRVtwrCZRMCrWkj
         vMC0iIyoNEGQPoYQLkYzxd4HO5WjFdTQ0VxNpxImif9sXQBwff6Vryxw/I/ts08ItC2W
         fHEmkHMp0/oxHPNk3opOD7SpOFGHB9HCW2hR4brfBP60qBfFf+v54PezhJz0SWZjd+JC
         eXcw==
X-Gm-Message-State: AGi0PuY44GkZKrvD6QBCK8/GuAhrfAx089yi5n/swI8tJw2779xxb6XN
        v+d0o6VOC0g90QSQ8bCTmshX5VEsPovX0YDWcXDprw==
X-Google-Smtp-Source: APiQypLvNSLmbcj2GoOJKPRwQ0b4TevwhF9jPUtKlLczQuSmRgDhP5Yyzo2l8yt6eZwfR64jtzXnvSUgm75W51k8BEs=
X-Received: by 2002:aca:4d86:: with SMTP id a128mr19561982oib.96.1586963248561;
 Wed, 15 Apr 2020 08:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200414181012.114905-1-robert.marko@sartura.hr> <20200415093334.GC25745@shell.armlinux.org.uk>
In-Reply-To: <20200415093334.GC25745@shell.armlinux.org.uk>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Wed, 15 Apr 2020 17:07:17 +0200
Message-ID: <CA+HBbNEYkQKy-WjxB+QDasknH8gAChddcbtNX6xxE3a+GoNC2g@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] net: phy: mdio: add IPQ40xx MDIO driver
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have sent a v3.

I tried to incorporate all of your remarks there.

Thanks
Robert

On Wed, Apr 15, 2020 at 11:33 AM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Tue, Apr 14, 2020 at 08:10:11PM +0200, Robert Marko wrote:
> > diff --git a/drivers/net/phy/mdio-ipq40xx.c b/drivers/net/phy/mdio-ipq40xx.c
> > new file mode 100644
> > index 000000000000..d8c11c621f20
> > --- /dev/null
> > +++ b/drivers/net/phy/mdio-ipq40xx.c
> > @@ -0,0 +1,176 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> > +/* Copyright (c) 2015, The Linux Foundation. All rights reserved. */
> > +/* Copyright (c) 2020 Sartura Ltd. */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/mutex.h>
> > +#include <linux/io.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_mdio.h>
> > +#include <linux/phy.h>
> > +#include <linux/platform_device.h>
> > +
>
> Looking at how these registers are used, they could be renamed:
>
> > +#define MDIO_CTRL_0_REG              0x40
>
> This seems to be unused.
>
> > +#define MDIO_CTRL_1_REG              0x44
>
> MDIO_ADDR_REG
>
> > +#define MDIO_CTRL_2_REG              0x48
>
> MDIO_DATA_WRITE_REG
>
> > +#define MDIO_CTRL_3_REG              0x4c
>
> MDIO_DATA_READ_REG
>
> > +#define MDIO_CTRL_4_REG              0x50
> > +#define MDIO_CTRL_4_ACCESS_BUSY              BIT(16)
> > +#define MDIO_CTRL_4_ACCESS_START             BIT(8)
> > +#define MDIO_CTRL_4_ACCESS_CODE_READ         0
> > +#define MDIO_CTRL_4_ACCESS_CODE_WRITE        1
>
> MDIO_CMD_* ?
>
> > +
> > +#define IPQ40XX_MDIO_RETRY   1000
> > +#define IPQ40XX_MDIO_DELAY   10
> > +
> > +struct ipq40xx_mdio_data {
> > +     void __iomem    *membase;
> > +};
> > +
> > +static int ipq40xx_mdio_wait_busy(struct mii_bus *bus)
> > +{
> > +     struct ipq40xx_mdio_data *priv = bus->priv;
> > +     int i;
> > +
> > +     for (i = 0; i < IPQ40XX_MDIO_RETRY; i++) {
> > +             unsigned int busy;
> > +
> > +             busy = readl(priv->membase + MDIO_CTRL_4_REG) &
> > +                     MDIO_CTRL_4_ACCESS_BUSY;
> > +             if (!busy)
> > +                     return 0;
> > +
> > +             /* BUSY might take to be cleard by 15~20 times of loop */
> > +             udelay(IPQ40XX_MDIO_DELAY);
> > +     }
> > +
> > +     dev_err(bus->parent, "MDIO operation timed out\n");
> > +
> > +     return -ETIMEDOUT;
> > +}
> > +
> > +static int ipq40xx_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> > +{
> > +     struct ipq40xx_mdio_data *priv = bus->priv;
> > +     int value = 0;
> > +     unsigned int cmd = 0;
>
> No need to initialise either of these, and you can eliminate "value"
> which will then satisfy davem's requirement for reverse-christmas-tree
> ordering of variable declarations.
>
> > +
> > +     /* Reject clause 45 */
> > +     if (regnum & MII_ADDR_C45)
> > +             return -EOPNOTSUPP;
> > +
> > +     if (ipq40xx_mdio_wait_busy(bus))
> > +             return -ETIMEDOUT;
> > +
> > +     /* issue the phy address and reg */
> > +     writel((mii_id << 8) | regnum, priv->membase + MDIO_CTRL_1_REG);
> > +
> > +     cmd = MDIO_CTRL_4_ACCESS_START | MDIO_CTRL_4_ACCESS_CODE_READ;
> > +
> > +     /* issue read command */
> > +     writel(cmd, priv->membase + MDIO_CTRL_4_REG);
> > +
> > +     /* Wait read complete */
> > +     if (ipq40xx_mdio_wait_busy(bus))
> > +             return -ETIMEDOUT;
> > +
> > +     /* Read data */
> > +     value = readl(priv->membase + MDIO_CTRL_3_REG);
> > +
> > +     return value;
> > +}
> > +
> > +static int ipq40xx_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> > +                                                      u16 value)
> > +{
> > +     struct ipq40xx_mdio_data *priv = bus->priv;
> > +     unsigned int cmd = 0;
>
> No need to initialise cmd.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

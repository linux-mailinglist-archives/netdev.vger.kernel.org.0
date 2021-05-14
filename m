Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2B8380B06
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhENOGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbhENOGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 10:06:05 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733F9C061574;
        Fri, 14 May 2021 07:04:52 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id e128so3376590ybf.6;
        Fri, 14 May 2021 07:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d1TP8dTb9QYh8tJMpBMMCeivqgPhgd5Em9F+I5eS1/s=;
        b=GGQwNqX2a9NZBP3x4Jp4nTKhr+kkMJDRKDK9zl/ycYJ1OZt7kB8XMI6g1coIfKgJVC
         Z4wfrYdVOV78K3H8M/rnKwYYzO6cE8h5A8MbiBRS2bvrrx9/fgmBsU2q+YFEw7sY4uuq
         f16vwXQ9NmggIznSMEQtjNRGqiEg60HVMJ0zBVMRHgDA9+p0R0XNNtP2yPIL72xGqqjP
         Crhl9R9bOLRqHWhG7wt/akJYeAwC+IOt3vvAf2yftj7y51VYyvH8cP1e0IsC1PwQwXUd
         Rtf8jU2DeEq0fIW06z1pAyKs2KKqrVX7HdTG2+mhl4PGlnkayx5Od4BTIez7EkBVyKp5
         8NXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d1TP8dTb9QYh8tJMpBMMCeivqgPhgd5Em9F+I5eS1/s=;
        b=qJLHbcde1sGaG2h/25du58GAK0uf5teeSmncbxtdgktsXR1cU+MEU9RjSeRqycvSJE
         XTue2zM9qjc9umUR0c8oGsTONitlZ+VQF23ShEtm+rbVGF0NMSBOAPSe5uUMXpznQP7Q
         HO7ab2MkEvNwrV8l+4D3uNLry3xeaP0UKbvf4nfHdr7FhcmLlNeRgqObB8gw/UInPiMK
         IYHGGCrX6ExxM9xesEEnZ0ud/WrPf4z/KuZpX+450uFpZfaFDbA9C6Htohg+Tdw2Qcqf
         5iUfXDujPgVvxz4GCsBrL3Ra8/jI4WILcrdPoC3CWy22ORRhOK/JEUQNej11rTgHCO8Y
         pnKQ==
X-Gm-Message-State: AOAM531/SwRiCl5LimFleiTLDkZYZKRktAOOAbMX4SRg4BAwHFfRO0Xg
        tu/H/ybENR28C/P6Ia8+wZo+Q/7Lc/K63SiZaPw=
X-Google-Smtp-Source: ABdhPJxP4/QM4w6gXE/B7YHO12MqkwcHL4Q/hx4MZlSp3jhtC9GZLpR9EF7Bhr3vfU7kbwH6odXwExTcZx89pdGX6KE=
X-Received: by 2002:a25:9982:: with SMTP id p2mr66128979ybo.457.1621001091579;
 Fri, 14 May 2021 07:04:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210514115826.3025223-1-pgwipeout@gmail.com> <a4e2188f-bd3e-d505-f922-2c2930b3838f@gmail.com>
In-Reply-To: <a4e2188f-bd3e-d505-f922-2c2930b3838f@gmail.com>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Fri, 14 May 2021 10:04:40 -0400
Message-ID: <CAMdYzYoU6+1k6XyX2fxPw2BMq1LZPeMY_+S2P-KQzm+DzJ6k-Q@mail.gmail.com>
Subject: Re: [PATCH v3] net: phy: add driver for Motorcomm yt8511 phy
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 9:09 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 14.05.2021 13:58, Peter Geis wrote:
> > Add a driver for the Motorcomm yt8511 phy that will be used in the
> > production Pine64 rk3566-quartz64 development board.
> > It supports gigabit transfer speeds, rgmii, and 125mhz clk output.
> >
> > Signed-off-by: Peter Geis <pgwipeout@gmail.com>
> > ---
> > Changes v3:
> > - Add rgmii mode selection support
> >
> > Changes v2:
> > - Change to __phy_modify
> > - Handle return errors
> > - Remove unnecessary &
> >
> >  MAINTAINERS                 |   6 ++
> >  drivers/net/phy/Kconfig     |   6 ++
> >  drivers/net/phy/Makefile    |   1 +
> >  drivers/net/phy/motorcomm.c | 121 ++++++++++++++++++++++++++++++++++++
> >  4 files changed, 134 insertions(+)
> >  create mode 100644 drivers/net/phy/motorcomm.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 601b5ae0368a..2a2e406238fc 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -12388,6 +12388,12 @@ F:   Documentation/userspace-api/media/drivers/meye*
> >  F:   drivers/media/pci/meye/
> >  F:   include/uapi/linux/meye.h
> >
> > +MOTORCOMM PHY DRIVER
> > +M:   Peter Geis <pgwipeout@gmail.com>
> > +L:   netdev@vger.kernel.org
> > +S:   Maintained
> > +F:   drivers/net/phy/motorcomm.c
> > +
> >  MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
> >  S:   Orphan
> >  F:   Documentation/driver-api/serial/moxa-smartio.rst
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index 288bf405ebdb..16db9f8037b5 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -229,6 +229,12 @@ config MICROSEMI_PHY
> >       help
> >         Currently supports VSC8514, VSC8530, VSC8531, VSC8540 and VSC8541 PHYs
> >
> > +config MOTORCOMM_PHY
> > +     tristate "Motorcomm PHYs"
> > +     help
> > +       Enables support for Motorcomm network PHYs.
> > +       Currently supports the YT8511 gigabit PHY.
> > +
> >  config NATIONAL_PHY
> >       tristate "National Semiconductor PHYs"
> >       help
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index bcda7ed2455d..37ffbc6e3c87 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -70,6 +70,7 @@ obj-$(CONFIG_MICREL_PHY)    += micrel.o
> >  obj-$(CONFIG_MICROCHIP_PHY)  += microchip.o
> >  obj-$(CONFIG_MICROCHIP_T1_PHY)       += microchip_t1.o
> >  obj-$(CONFIG_MICROSEMI_PHY)  += mscc/
> > +obj-$(CONFIG_MOTORCOMM_PHY)  += motorcomm.o
> >  obj-$(CONFIG_NATIONAL_PHY)   += national.o
> >  obj-$(CONFIG_NXP_C45_TJA11XX_PHY)    += nxp-c45-tja11xx.o
> >  obj-$(CONFIG_NXP_TJA11XX_PHY)        += nxp-tja11xx.o
> > diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
> > new file mode 100644
> > index 000000000000..b85f10efa28e
> > --- /dev/null
> > +++ b/drivers/net/phy/motorcomm.c
> > @@ -0,0 +1,121 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * Driver for Motorcomm PHYs
> > + *
> > + * Author: Peter Geis <pgwipeout@gmail.com>
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/phy.h>
> > +
> > +#define PHY_ID_YT8511                0x0000010a
>
> This PHY ID looks weird, the OUI part is empty.
> Looking here http://standards-oui.ieee.org/cid/cid.txt
> it seems Motorcomm has been assigned at least a CID.
> An invalid OUI leaves a good chance for a PHY ID conflict.

Delightfully, that's what the OUI reports....
The only bits that aren't all 0s are the Type and Revision blocks.
I also haven't found a way to update the eeprom so I don't know how
this could get fixed.

>
> > +
> > +#define YT8511_PAGE_SELECT   0x1e
> > +#define YT8511_PAGE          0x1f
> > +#define YT8511_EXT_CLK_GATE  0x0c
> > +#define YT8511_EXT_SLEEP_CTRL        0x27
> > +
> > +/* 2b00 25m from pll
> > + * 2b01 25m from xtl *default*
> > + * 2b10 62.m from pll
> > + * 2b11 125m from pll
> > + */
> > +#define YT8511_CLK_125M              (BIT(2) | BIT(1))
> > +
> > +/* RX Delay enabled = 1.8ns 1000T, 8ns 10/100T */
> > +#define YT8511_DELAY_RX              BIT(0)
> > +
> > +/* TX Delay is bits 7:4, default 0x5
> > + * Delay = 150ps * N - 250ps, Default = 500ps
> > + */
> > +#define YT8511_DELAY_TX              (0x5 << 4)
> > +
> > +static int yt8511_read_page(struct phy_device *phydev)
> > +{
> > +     return __phy_read(phydev, YT8511_PAGE_SELECT);
> > +};
> > +
> > +static int yt8511_write_page(struct phy_device *phydev, int page)
> > +{
> > +     return __phy_write(phydev, YT8511_PAGE_SELECT, page);
> > +};
> > +
> > +static int yt8511_config_init(struct phy_device *phydev)
> > +{
> > +     int ret, oldpage, val;
> > +
> > +     /* set clock mode to 125mhz */
> > +     oldpage = phy_select_page(phydev, YT8511_EXT_CLK_GATE);
> > +     if (oldpage < 0)
> > +             goto err_restore_page;
> > +
> > +     ret = __phy_modify(phydev, YT8511_PAGE, 0, YT8511_CLK_125M);
> > +     if (ret < 0)
> > +             goto err_restore_page;
> > +
> > +     /* set rgmii delay mode */
> > +     val = __phy_read(phydev, YT8511_PAGE);
> > +
> > +     switch (phydev->interface) {
> > +     case PHY_INTERFACE_MODE_RGMII:
> > +             val &= ~(YT8511_DELAY_RX | YT8511_DELAY_TX);
> > +             break;
> > +     case PHY_INTERFACE_MODE_RGMII_ID:
> > +             val |= YT8511_DELAY_RX | YT8511_DELAY_TX;
> > +             break;
> > +     case PHY_INTERFACE_MODE_RGMII_RXID:
> > +             val &= ~(YT8511_DELAY_TX);
> > +             val |= YT8511_DELAY_RX;
> > +             break;
> > +     case PHY_INTERFACE_MODE_RGMII_TXID:
> > +             val &= ~(YT8511_DELAY_RX);
> > +             val |= YT8511_DELAY_TX;
> > +             break;
> > +     default: /* leave everything alone in other modes */
> > +             break;
> > +     }
> > +
> > +     ret = __phy_write(phydev, YT8511_PAGE, val);
> > +     if (ret < 0)
> > +             goto err_restore_page;
> > +
> > +     /* disable auto sleep */
> > +     ret = __phy_write(phydev, YT8511_PAGE_SELECT, YT8511_EXT_SLEEP_CTRL);
> > +     if (ret < 0)
> > +             goto err_restore_page;
> > +     ret = __phy_modify(phydev, YT8511_PAGE, BIT(15), 0);
> > +     if (ret < 0)
> > +             goto err_restore_page;
> > +
> > +err_restore_page:
> > +     return phy_restore_page(phydev, oldpage, ret);
> > +}
> > +
> > +static struct phy_driver motorcomm_phy_drvs[] = {
> > +     {
> > +             PHY_ID_MATCH_EXACT(PHY_ID_YT8511),
> > +             .name           = "YT8511 Gigabit Ethernet",
> > +             .config_init    = yt8511_config_init,
> > +             .get_features   = genphy_read_abilities,
> > +             .config_aneg    = genphy_config_aneg,
> > +             .read_status    = genphy_read_status,
>
> These three genphy callbacks are fallbacks anyway.
> So you don't have to set them.

Okay, thanks!

>
> > +             .suspend        = genphy_suspend,
> > +             .resume         = genphy_resume,
> > +             .read_page      = yt8511_read_page,
> > +             .write_page     = yt8511_write_page,
> > +     },
> > +};
> > +
> > +module_phy_driver(motorcomm_phy_drvs);
> > +
> > +MODULE_DESCRIPTION("Motorcomm PHY driver");
> > +MODULE_AUTHOR("Peter Geis");
> > +MODULE_LICENSE("GPL");
> > +
> > +static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
> > +     { PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
> > +     { /* sentinal */ }
> > +};
> > +
> > +MODULE_DEVICE_TABLE(mdio, motorcomm_tbl);
> >
>

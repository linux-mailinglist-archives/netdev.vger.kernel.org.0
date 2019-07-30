Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 165EE79DFA
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 03:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730495AbfG3Bcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 21:32:48 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46419 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729473AbfG3Bcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 21:32:48 -0400
Received: by mail-ed1-f68.google.com with SMTP id d4so61093668edr.13;
        Mon, 29 Jul 2019 18:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Ftzg7THfmAK8OMfuBiBZ76IWfuhIkncq/8zqyt2pEg=;
        b=cXRFi9Xs7adSiJ9+x1QqPHr3kKXJq+4QwiXeWuiyGUhnfzD7x+Xlf0nf9LePdzzpGs
         jrC6UqK1Lv2A/GJU9u3Iht8ecKAJsFH7QHSUgHUb1S6BqFK6TBOgQsokgu/bkgPHVO8D
         1Vlfqy4gYXJeZLbqtDztUyVuGbQsX5xB3nbC8wPz9HJcGCep1oP6xlihpg7SCnuAf984
         0p+//YdZ1pxoUiIQNDSSary8lO5mxtN/n/PgX2rveV0WR5miFbnL2eo3VJu4qzGuVUSd
         NR69lE0abWNwaprvqo769kpvEOOawbYdxvQi0DkDbPdk0EOdYMOq6+FE23Z0vRkMMqRW
         wPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Ftzg7THfmAK8OMfuBiBZ76IWfuhIkncq/8zqyt2pEg=;
        b=iDOBA7ldoFb+ftvUDySyd7V4qTYYG5pgZpPtYuRFxfrqOLLoAVciPgp4nwZWpyimmM
         Jn+9CGVz1WMhxiKdf8Lh3+arKj3PmINXWnXQXyiZcGAahw+cSxqfkosIfNVNDvgP15U9
         vHHMtOhhB154esNCSAYgopi0pOFg9TirihW7+8rP8tcD+iJklrLQiDkvrBfU2ulhrwxA
         ima5uYHHQcZWMOsN+brKG34KgACRwFr7SzA3cPhF7/KWpK1DizdTeS9Q6+Pu7SZ2tMp6
         CKlev6c0j2/04BVWlKbNA0F2W5VKmSn1jKP6Lp3hq15+lUe2exqHEFhWOZlsqTGcOoeq
         txzw==
X-Gm-Message-State: APjAAAXMk1Uj3/CvnO+efOFNcuHxaGOEZ9+kWYwc5fso/0LH9nFKI3BL
        dZq4ax0IC87RfUB1G1aHy1Ib73lF8UFUntAPtbg=
X-Google-Smtp-Source: APXvYqwt/QDnB9rTcjd7QhYqNNd2VrJcFwWAxBLPBnlVoaUa9E+8qUS6lr2o3cQ+y2MNazuIPOMHiQ8/FdFxQAC3UU4=
X-Received: by 2002:a50:ba19:: with SMTP id g25mr98971820edc.123.1564450366223;
 Mon, 29 Jul 2019 18:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190730002549.86824-1-taoren@fb.com>
In-Reply-To: <20190730002549.86824-1-taoren@fb.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 30 Jul 2019 04:32:35 +0300
Message-ID: <CA+h21hq1+E6-ScFx425hXwTPTZHTVZbBuAm7RROFZTBOFvD8vQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
To:     Tao Ren <taoren@fb.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>, openbmc@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tao,

On Tue, 30 Jul 2019 at 03:31, Tao Ren <taoren@fb.com> wrote:
>
> Configure the BCM54616S for 1000Base-X mode when "brcm-phy-mode-1000bx"
> is set in device tree. This is needed when the PHY is used for fiber and
> backplane connections.
>
> The patch is inspired by commit cd9af3dac6d1 ("PHYLIB: Add 1000Base-X
> support for Broadcom bcm5482").

As far as I can see, for the commit you referenced,
PHY_BCM_FLAGS_MODE_1000BX is referenced from nowhere in the entire
mainline kernel:
https://elixir.bootlin.com/linux/latest/ident/PHY_BCM_FLAGS_MODE_1000BX
(it is supposed to be put by the MAC driver in phydev->dev_flags prior
to calling phy_connect). But I don't see the point to this - can't you
check for phydev->interface == PHY_INTERFACE_MODE_1000BASEX?
This has the advantage that no MAC driver will need to know that it's
talking to a Broadcom PHY. Additionally, no custom DT bindings are
needed.
Also, for backplane connections you probably want 1000Base-KX which
has its own AN/LT, not plain 1000Base-X.

>
> Signed-off-by: Tao Ren <taoren@fb.com>
> ---
>  drivers/net/phy/broadcom.c | 58 +++++++++++++++++++++++++++++++++++---
>  include/linux/brcmphy.h    |  4 +--
>  2 files changed, 56 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> index 2b4e41a9d35a..6c22ac3a844b 100644
> --- a/drivers/net/phy/broadcom.c
> +++ b/drivers/net/phy/broadcom.c
> @@ -383,9 +383,9 @@ static int bcm5482_config_init(struct phy_device *phydev)
>                 /*
>                  * Select 1000BASE-X register set (primary SerDes)
>                  */
> -               reg = bcm_phy_read_shadow(phydev, BCM5482_SHD_MODE);
> -               bcm_phy_write_shadow(phydev, BCM5482_SHD_MODE,
> -                                    reg | BCM5482_SHD_MODE_1000BX);
> +               reg = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
> +               bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE,
> +                                    reg | BCM54XX_SHD_MODE_1000BX);
>
>                 /*
>                  * LED1=ACTIVITYLED, LED3=LINKSPD[2]
> @@ -451,6 +451,34 @@ static int bcm5481_config_aneg(struct phy_device *phydev)
>         return ret;
>  }
>
> +static int bcm54616s_config_init(struct phy_device *phydev)
> +{
> +       int err, reg;
> +       struct device_node *np = phydev->mdio.dev.of_node;
> +
> +       err = bcm54xx_config_init(phydev);
> +
> +       if (of_property_read_bool(np, "brcm-phy-mode-1000bx")) {
> +               /* Select 1000BASE-X register set. */
> +               reg = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
> +               bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE,
> +                                    reg | BCM54XX_SHD_MODE_1000BX);
> +
> +               /* Auto-negotiation doesn't seem to work quite right
> +                * in this mode, so we disable it and force it to the
> +                * right speed/duplex setting.  Only 'link status'
> +                * is important.
> +                */
> +               phydev->autoneg = AUTONEG_DISABLE;
> +               phydev->speed = SPEED_1000;
> +               phydev->duplex = DUPLEX_FULL;
> +

1000Base-X AN does not include speed negotiation, so hardcoding
SPEED_1000 is probably correct.
What is wrong with the AN of duplex settings?

> +               phydev->dev_flags |= PHY_BCM_FLAGS_MODE_1000BX;
> +       }
> +
> +       return err;
> +}
> +
>  static int bcm54616s_config_aneg(struct phy_device *phydev)
>  {
>         int ret;
> @@ -464,6 +492,27 @@ static int bcm54616s_config_aneg(struct phy_device *phydev)
>         return ret;
>  }
>
> +static int bcm54616s_read_status(struct phy_device *phydev)
> +{
> +       int ret;
> +
> +       ret = genphy_read_status(phydev);
> +       if (ret < 0)
> +               return ret;
> +
> +       if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX) {
> +               /* Only link status matters for 1000Base-X mode, so force
> +                * 1000 Mbit/s full-duplex status.
> +                */
> +               if (phydev->link) {
> +                       phydev->speed = SPEED_1000;
> +                       phydev->duplex = DUPLEX_FULL;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
>  static int brcm_phy_setbits(struct phy_device *phydev, int reg, int set)
>  {
>         int val;
> @@ -651,8 +700,9 @@ static struct phy_driver broadcom_drivers[] = {
>         .phy_id_mask    = 0xfffffff0,
>         .name           = "Broadcom BCM54616S",
>         .features       = PHY_GBIT_FEATURES,
> -       .config_init    = bcm54xx_config_init,
> +       .config_init    = bcm54616s_config_init,
>         .config_aneg    = bcm54616s_config_aneg,
> +       .read_status    = bcm54616s_read_status,
>         .ack_interrupt  = bcm_phy_ack_intr,
>         .config_intr    = bcm_phy_config_intr,
>  }, {
> diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
> index 6db2d9a6e503..82030155558c 100644
> --- a/include/linux/brcmphy.h
> +++ b/include/linux/brcmphy.h
> @@ -200,8 +200,8 @@
>  #define BCM5482_SHD_SSD                0x14    /* 10100: Secondary SerDes control */
>  #define BCM5482_SHD_SSD_LEDM   0x0008  /* SSD LED Mode enable */
>  #define BCM5482_SHD_SSD_EN     0x0001  /* SSD enable */
> -#define BCM5482_SHD_MODE       0x1f    /* 11111: Mode Control Register */
> -#define BCM5482_SHD_MODE_1000BX        0x0001  /* Enable 1000BASE-X registers */
> +#define BCM54XX_SHD_MODE       0x1f    /* 11111: Mode Control Register */
> +#define BCM54XX_SHD_MODE_1000BX        0x0001  /* Enable 1000BASE-X registers */

These registers are also present on my BCM5464, probably safe to
assume they're generic for the entire family.
So if you make the registers definitions common, you can probably make
the 1000Base-X configuration common as well.

>
>
>  /*
> --
> 2.17.1
>

Regards,
-Vladimir

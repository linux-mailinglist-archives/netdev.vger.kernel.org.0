Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2364148A373
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 00:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345641AbiAJXMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 18:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242456AbiAJXMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 18:12:17 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328C9C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 15:12:17 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e19so7689718plc.10
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 15:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DE7tsoe/6VvMNz3ew9Qg9ku4Byq5CT/3Rryx+5ThdvU=;
        b=G/PJ8UZWasPMFb3LtHmAndNVvfp9XhtZhWnXkgqWKLo8LWjhWMvSNmhqhWykQ6UWks
         yvFbyGltOjYxwT5upM6jWHgBIsOU4j1ynKgC9QGK1mIOzRQWhxm/RnDOAoJr6YqeHsuR
         Xd9AMqGlKFNlulCrTim6i+OWMSrXgboDACa1QT45P8OK+xQ0g8jN7IkagPySb6C7MzaK
         HFBZSbh5cxkJYaEDEAdrH9/+MVhW3JFIBMM3qJRZfMed5dT94ZsEjOXD7cB58BSOfVkF
         Gl1Oe/ZCYZmke/V70A9ZZEaSqSmHxaYhsQ/saAs6lfsg7Yt13i8YsFKlf27kG9aUwjNY
         Gcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DE7tsoe/6VvMNz3ew9Qg9ku4Byq5CT/3Rryx+5ThdvU=;
        b=ziSy8iIgvyxCbppds7v3EvaKG/iRAvF+A7AkiZfXTHUmbNz6DHUW4/jtpB0iis+qHk
         oqi0S+OawlEegpOy6sZMx9QSKXn4ZaTERYPE4e9iyPhG34Je42nojEDSyHT2xy46v9Qk
         RCOFXXNl33iESRZKCe3eSzzlnXjCJqR4WHedQuDelH8AtIkVScjeKNpr9kugyhNqDORH
         0PRfbw/QulZneH+asYmmXDsMQejXVQGM5sm3f9Bekk9JJVf/i4klXcUNRwk+uA07OW9H
         qLu5zedLNHnXM0qJ60wwaPy/7zmV9Y36yOxeyeb+0nsP+BTf17WhrBhPfGHfXWJ6a2+c
         09qQ==
X-Gm-Message-State: AOAM5338DFPrLSQ5Qcr3SvUSHYpnQeKtRdAg8bHEEgzNXdkG+/Cxhx+k
        BxIjy4QPN+mUF3Hp7G49mdcREb2eTR29soiEgdGXAjauCq3yOQ==
X-Google-Smtp-Source: ABdhPJxbW0VjZTQureAYIpMbt0/SCidcDDFE9MYbOdzkSsVvM76DPOE76TxrZ+KFIQPAJdu+w8O1FQQHrYw12HTwa8M=
X-Received: by 2002:a17:90b:4b0e:: with SMTP id lx14mr103435pjb.66.1641856336561;
 Mon, 10 Jan 2022 15:12:16 -0800 (PST)
MIME-Version: 1.0
References: <20210719082756.15733-1-ms@dev.tdt.de>
In-Reply-To: <20210719082756.15733-1-ms@dev.tdt.de>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 10 Jan 2022 15:12:05 -0800
Message-ID: <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 2:07 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> This adds the possibility to configure the RGMII RX/TX clock skew via
> devicetree.
>
> Simply set phy mode to "rgmii-id", "rgmii-rxid" or "rgmii-txid" and add
> the "rx-internal-delay-ps" or "tx-internal-delay-ps" property to the
> devicetree.
>
> Furthermore, a warning is now issued if the phy mode is configured to
> "rgmii" and an internal delay is set in the phy (e.g. by pin-strapping),
> as in the dp83867 driver.
>
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> ---
>
> Changes to v5:
> o remove #if IS_ENABLED(CONFIG_OF_MDIO) check
> o rename new function to xway_gphy_rgmii_init()
>
> Changes to v4:
> o Fix Alignment to match open parenthesis
>
> Changes to v3:
> o Fix typo in commit message
> o use FIELD_PREP() and FIELD_GET() macros
> o further code cleanups
> o always mask rxskew AND txskew value in the register value
>
> Changes to v2:
> o Fix missing whitespace in warning.
>
> Changes to v1:
> o code cleanup and use phy_modify().
> o use default of 2.0ns if delay property is absent instead of returning
>   an error.
>
> ---
>  drivers/net/phy/intel-xway.c | 78 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
>
> diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/intel-xway.c
> index d453ec016168..fd7da2eeb963 100644
> --- a/drivers/net/phy/intel-xway.c
> +++ b/drivers/net/phy/intel-xway.c
> @@ -8,11 +8,16 @@
>  #include <linux/module.h>
>  #include <linux/phy.h>
>  #include <linux/of.h>
> +#include <linux/bitfield.h>
>
> +#define XWAY_MDIO_MIICTRL              0x17    /* mii control */
>  #define XWAY_MDIO_IMASK                        0x19    /* interrupt mask */
>  #define XWAY_MDIO_ISTAT                        0x1A    /* interrupt status */
>  #define XWAY_MDIO_LED                  0x1B    /* led control */
>
> +#define XWAY_MDIO_MIICTRL_RXSKEW_MASK  GENMASK(14, 12)
> +#define XWAY_MDIO_MIICTRL_TXSKEW_MASK  GENMASK(10, 8)
> +
>  /* bit 15:12 are reserved */
>  #define XWAY_MDIO_LED_LED3_EN          BIT(11) /* Enable the integrated function of LED3 */
>  #define XWAY_MDIO_LED_LED2_EN          BIT(10) /* Enable the integrated function of LED2 */
> @@ -157,6 +162,75 @@
>  #define PHY_ID_PHY11G_VR9_1_2          0xD565A409
>  #define PHY_ID_PHY22F_VR9_1_2          0xD565A419
>
> +static const int xway_internal_delay[] = {0, 500, 1000, 1500, 2000, 2500,
> +                                        3000, 3500};
> +
> +static int xway_gphy_rgmii_init(struct phy_device *phydev)
> +{
> +       struct device *dev = &phydev->mdio.dev;
> +       unsigned int delay_size = ARRAY_SIZE(xway_internal_delay);
> +       s32 int_delay;
> +       int val = 0;
> +
> +       if (!phy_interface_is_rgmii(phydev))
> +               return 0;
> +
> +       /* Existing behavior was to use default pin strapping delay in rgmii
> +        * mode, but rgmii should have meant no delay.  Warn existing users,
> +        * but do not change anything at the moment.
> +        */
> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII) {
> +               u16 txskew, rxskew;
> +
> +               val = phy_read(phydev, XWAY_MDIO_MIICTRL);
> +               if (val < 0)
> +                       return val;
> +
> +               txskew = FIELD_GET(XWAY_MDIO_MIICTRL_TXSKEW_MASK, val);
> +               rxskew = FIELD_GET(XWAY_MDIO_MIICTRL_RXSKEW_MASK, val);
> +
> +               if (txskew > 0 || rxskew > 0)
> +                       phydev_warn(phydev,
> +                                   "PHY has delays (e.g. via pin strapping), but phy-mode = 'rgmii'\n"
> +                                   "Should be 'rgmii-id' to use internal delays txskew:%d ps rxskew:%d ps\n",
> +                                   xway_internal_delay[txskew],
> +                                   xway_internal_delay[rxskew]);
> +               return 0;
> +       }
> +
> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +           phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> +               int_delay = phy_get_internal_delay(phydev, dev,
> +                                                  xway_internal_delay,
> +                                                  delay_size, true);
> +
> +               if (int_delay < 0) {
> +                       phydev_warn(phydev, "rx-internal-delay-ps is missing, use default of 2.0 ns\n");
> +                       int_delay = 4; /* 2000 ps */
> +               }
> +
> +               val |= FIELD_PREP(XWAY_MDIO_MIICTRL_RXSKEW_MASK, int_delay);
> +       }
> +
> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +           phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +               int_delay = phy_get_internal_delay(phydev, dev,
> +                                                  xway_internal_delay,
> +                                                  delay_size, false);
> +
> +               if (int_delay < 0) {
> +                       phydev_warn(phydev, "tx-internal-delay-ps is missing, use default of 2.0 ns\n");
> +                       int_delay = 4; /* 2000 ps */
> +               }
> +
> +               val |= FIELD_PREP(XWAY_MDIO_MIICTRL_TXSKEW_MASK, int_delay);
> +       }
> +
> +       return phy_modify(phydev, XWAY_MDIO_MIICTRL,
> +                         XWAY_MDIO_MIICTRL_RXSKEW_MASK |
> +                         XWAY_MDIO_MIICTRL_TXSKEW_MASK, val);
> +}
> +
>  static int xway_gphy_config_init(struct phy_device *phydev)
>  {
>         int err;
> @@ -204,6 +278,10 @@ static int xway_gphy_config_init(struct phy_device *phydev)
>         phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2H, ledxh);
>         phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2L, ledxl);
>
> +       err = xway_gphy_rgmii_init(phydev);
> +       if (err)
> +               return err;
> +
>         return 0;
>  }
>
> --
> 2.20.1
>

Martin,

I've got some boards with the GPY111 phy on them and I'm finding that
modifying XWAY_MDIO_MIICTRL to change the skew has no effect unless I
do a soft reset (BCMR_RESET) first. I don't see anything in the
datasheet which specifies this to be the case so I'm interested it
what you have found. Are you sure adjusting the skews like this
without a soft (or hard pin based) reset actually works?

Best regards,

Tim

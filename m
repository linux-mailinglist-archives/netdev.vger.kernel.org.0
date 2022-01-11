Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B7B48B688
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 20:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350354AbiAKTMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 14:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346117AbiAKTMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 14:12:45 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E401C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:12:45 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n30-20020a17090a5aa100b001b2b6509685so576482pji.3
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cj/+pQ+TtfHL2NX+OfFYOfj8tH9YtaAE2RZYOHqHiRE=;
        b=P4xxx2yQaqkIkvOkzwOAuagTF9X3VnQAdtx4W3oBFppAYNi95LmNOcTZwgrfuKCTWs
         svdeVnNopY7oSVgGKBkESdu+zK/ntWVns2fF44Sjg3z4atMOY0T7YAcgZQqbbo89GYng
         u9BqusYcwk9MjoVGPMpstgtDiVG9+nmQGanatKIS47AKf2EcV6aYnkUruzYrGFJCB6Gs
         5x4WQ3smzEHiVKzDDkNDA0b9a7jbKaAYCV5W3VgcCT0+SuUC7X/69phqdcu00axtUqus
         8chxfeO5WzlKhl6qGYZMoI/wbLgpUhgz1zwqJkEn5dh8MaNWhL+MRaDT3qn3QzIbQuzs
         D3Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cj/+pQ+TtfHL2NX+OfFYOfj8tH9YtaAE2RZYOHqHiRE=;
        b=pMeH4nDpEeTDK+OTw7G4ft8QPQe/NXmVUsAKhLUn73qW9EIqwHS27+ERyljJgEJ0fj
         We09G5+uGi7Ve3AKys0RcjprkoonMaLDKSF+pNKhXt8K2/41QeHtjImA4azLYAvUQtR2
         fsW1QQOKtzF05AANo/xw9+1vSjOmtTPjj3bfUpjfejerIe1ZjbQnSla+B76hA3wQDjXa
         +EqCVTgoAZl/yTRdXS1hxaMCXbPrnn3HiHdlwVZqtOu+QWM0KsmS9jpNvZXgA5tkl3P8
         WT5OsOoT92PodCQx4TZuNtdRcIYIcBB5ZxxBtOW8PTPDkD6QdhO5cyUkpz+3eC0OR0i3
         7LBg==
X-Gm-Message-State: AOAM533VgM8uRBZ62HvRkQ9xRp5oAF2hyQjzGlGdhcH7lPWmu8e7bPWe
        I9EnCcQFVwyCTjZGsn63uny8fcLU5l86SoeX52TY6KQekCTkcQ==
X-Google-Smtp-Source: ABdhPJxprsXuwze5Ru6IcgCzB4rmNk1NCrRWGtTNiT1guit/xqnPyFx3PU7jb2jJ70fct5X3Wtl7BWeArV9HZaYjSmA=
X-Received: by 2002:a62:ed06:0:b0:4bb:1152:2fbd with SMTP id
 u6-20020a62ed06000000b004bb11522fbdmr5842018pfh.34.1641928364710; Tue, 11 Jan
 2022 11:12:44 -0800 (PST)
MIME-Version: 1.0
References: <20210719082756.15733-1-ms@dev.tdt.de> <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de>
In-Reply-To: <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 11 Jan 2022 11:12:33 -0800
Message-ID: <CAJ+vNU2Bn_eks03g191KKLx5uuuekdqovx000aqcT5=f_6Zq=w@mail.gmail.com>
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

On Mon, Jan 10, 2022 at 11:44 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> On 2022-01-11 00:12, Tim Harvey wrote:
> > On Mon, Jul 19, 2021 at 2:07 AM Martin Schiller <ms@dev.tdt.de> wrote:
> >>
> >> This adds the possibility to configure the RGMII RX/TX clock skew via
> >> devicetree.
> >>
> >> Simply set phy mode to "rgmii-id", "rgmii-rxid" or "rgmii-txid" and
> >> add
> >> the "rx-internal-delay-ps" or "tx-internal-delay-ps" property to the
> >> devicetree.
> >>
> >> Furthermore, a warning is now issued if the phy mode is configured to
> >> "rgmii" and an internal delay is set in the phy (e.g. by
> >> pin-strapping),
> >> as in the dp83867 driver.
> >>
> >> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> >> ---
> >>
> >> Changes to v5:
> >> o remove #if IS_ENABLED(CONFIG_OF_MDIO) check
> >> o rename new function to xway_gphy_rgmii_init()
> >>
> >> Changes to v4:
> >> o Fix Alignment to match open parenthesis
> >>
> >> Changes to v3:
> >> o Fix typo in commit message
> >> o use FIELD_PREP() and FIELD_GET() macros
> >> o further code cleanups
> >> o always mask rxskew AND txskew value in the register value
> >>
> >> Changes to v2:
> >> o Fix missing whitespace in warning.
> >>
> >> Changes to v1:
> >> o code cleanup and use phy_modify().
> >> o use default of 2.0ns if delay property is absent instead of
> >> returning
> >>   an error.
> >>
> >> ---
> >>  drivers/net/phy/intel-xway.c | 78
> >> ++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 78 insertions(+)
> >>
> >> diff --git a/drivers/net/phy/intel-xway.c
> >> b/drivers/net/phy/intel-xway.c
> >> index d453ec016168..fd7da2eeb963 100644
> >> --- a/drivers/net/phy/intel-xway.c
> >> +++ b/drivers/net/phy/intel-xway.c
> >> @@ -8,11 +8,16 @@
> >>  #include <linux/module.h>
> >>  #include <linux/phy.h>
> >>  #include <linux/of.h>
> >> +#include <linux/bitfield.h>
> >>
> >> +#define XWAY_MDIO_MIICTRL              0x17    /* mii control */
> >>  #define XWAY_MDIO_IMASK                        0x19    /* interrupt
> >> mask */
> >>  #define XWAY_MDIO_ISTAT                        0x1A    /* interrupt
> >> status */
> >>  #define XWAY_MDIO_LED                  0x1B    /* led control */
> >>
> >> +#define XWAY_MDIO_MIICTRL_RXSKEW_MASK  GENMASK(14, 12)
> >> +#define XWAY_MDIO_MIICTRL_TXSKEW_MASK  GENMASK(10, 8)
> >> +
> >>  /* bit 15:12 are reserved */
> >>  #define XWAY_MDIO_LED_LED3_EN          BIT(11) /* Enable the
> >> integrated function of LED3 */
> >>  #define XWAY_MDIO_LED_LED2_EN          BIT(10) /* Enable the
> >> integrated function of LED2 */
> >> @@ -157,6 +162,75 @@
> >>  #define PHY_ID_PHY11G_VR9_1_2          0xD565A409
> >>  #define PHY_ID_PHY22F_VR9_1_2          0xD565A419
> >>
> >> +static const int xway_internal_delay[] = {0, 500, 1000, 1500, 2000,
> >> 2500,
> >> +                                        3000, 3500};
> >> +
> >> +static int xway_gphy_rgmii_init(struct phy_device *phydev)
> >> +{
> >> +       struct device *dev = &phydev->mdio.dev;
> >> +       unsigned int delay_size = ARRAY_SIZE(xway_internal_delay);
> >> +       s32 int_delay;
> >> +       int val = 0;
> >> +
> >> +       if (!phy_interface_is_rgmii(phydev))
> >> +               return 0;
> >> +
> >> +       /* Existing behavior was to use default pin strapping delay in
> >> rgmii
> >> +        * mode, but rgmii should have meant no delay.  Warn existing
> >> users,
> >> +        * but do not change anything at the moment.
> >> +        */
> >> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII) {
> >> +               u16 txskew, rxskew;
> >> +
> >> +               val = phy_read(phydev, XWAY_MDIO_MIICTRL);
> >> +               if (val < 0)
> >> +                       return val;
> >> +
> >> +               txskew = FIELD_GET(XWAY_MDIO_MIICTRL_TXSKEW_MASK,
> >> val);
> >> +               rxskew = FIELD_GET(XWAY_MDIO_MIICTRL_RXSKEW_MASK,
> >> val);
> >> +
> >> +               if (txskew > 0 || rxskew > 0)
> >> +                       phydev_warn(phydev,
> >> +                                   "PHY has delays (e.g. via pin
> >> strapping), but phy-mode = 'rgmii'\n"
> >> +                                   "Should be 'rgmii-id' to use
> >> internal delays txskew:%d ps rxskew:%d ps\n",
> >> +                                   xway_internal_delay[txskew],
> >> +                                   xway_internal_delay[rxskew]);
> >> +               return 0;
> >> +       }
> >> +
> >> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> >> +           phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> >> +               int_delay = phy_get_internal_delay(phydev, dev,
> >> +
> >> xway_internal_delay,
> >> +                                                  delay_size, true);
> >> +
> >> +               if (int_delay < 0) {
> >> +                       phydev_warn(phydev, "rx-internal-delay-ps is
> >> missing, use default of 2.0 ns\n");
> >> +                       int_delay = 4; /* 2000 ps */
> >> +               }
> >> +
> >> +               val |= FIELD_PREP(XWAY_MDIO_MIICTRL_RXSKEW_MASK,
> >> int_delay);
> >> +       }
> >> +
> >> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> >> +           phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> >> +               int_delay = phy_get_internal_delay(phydev, dev,
> >> +
> >> xway_internal_delay,
> >> +                                                  delay_size, false);
> >> +
> >> +               if (int_delay < 0) {
> >> +                       phydev_warn(phydev, "tx-internal-delay-ps is
> >> missing, use default of 2.0 ns\n");
> >> +                       int_delay = 4; /* 2000 ps */
> >> +               }
> >> +
> >> +               val |= FIELD_PREP(XWAY_MDIO_MIICTRL_TXSKEW_MASK,
> >> int_delay);
> >> +       }
> >> +
> >> +       return phy_modify(phydev, XWAY_MDIO_MIICTRL,
> >> +                         XWAY_MDIO_MIICTRL_RXSKEW_MASK |
> >> +                         XWAY_MDIO_MIICTRL_TXSKEW_MASK, val);
> >> +}
> >> +
> >>  static int xway_gphy_config_init(struct phy_device *phydev)
> >>  {
> >>         int err;
> >> @@ -204,6 +278,10 @@ static int xway_gphy_config_init(struct
> >> phy_device *phydev)
> >>         phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2H, ledxh);
> >>         phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2L, ledxl);
> >>
> >> +       err = xway_gphy_rgmii_init(phydev);
> >> +       if (err)
> >> +               return err;
> >> +
> >>         return 0;
> >>  }
> >>
> >> --
> >> 2.20.1
> >>
> >
> > Martin,
> >
> > I've got some boards with the GPY111 phy on them and I'm finding that
> > modifying XWAY_MDIO_MIICTRL to change the skew has no effect unless I
> > do a soft reset (BCMR_RESET) first. I don't see anything in the
> > datasheet which specifies this to be the case so I'm interested it
> > what you have found. Are you sure adjusting the skews like this
> > without a soft (or hard pin based) reset actually works?
> >
> > Best regards,
> >
> > Tim
>
> Hello Tim,
>
> yes, you are right. It is not applied immediately. The link needs to be
> toggled to get this settings active. But my experience shows that this
> would be done in the further boot process anyway e.g. by restarting the
> autonegotiation etc.
>

Martin,

I added a debug statement in xway_gphy_rgmii_init and here you can see
it gets called 'before' the link comes up from the NIC on a board that
has a cable plugged in at power-on. I can tell from testing that the
rx_delay/tx_delay set in xway_gphy_rgmii_init does not actually take
effect unless I then bring the link down and up again manually as you
indicate.

# dmesg | egrep "xway|nicvf"
[    6.855971] xway_gphy_rgmii_init mdio_thunder MDI_MIICTRL:0xb100
rx_delay=1500 tx_delay=500
[    6.999651] nicvf, ver 1.0
[    7.002478] nicvf 0000:05:00.1: Adding to iommu group 7
[    7.007785] nicvf 0000:05:00.1: enabling device (0004 -> 0006)
[    7.053189] nicvf 0000:05:00.2: Adding to iommu group 8
[    7.058511] nicvf 0000:05:00.2: enabling device (0004 -> 0006)
[   11.044616] nicvf 0000:05:00.2 eth1: Link is Up 1000 Mbps Full duplex

If I add a 'genphy_soft_reset(phydev);' at the top of
xway_gphy_rgmii_init before the write to XWAY_MDIO_MIICTRL the values
do take effect so perhaps that's the proper fix.

I'm not fond of even using this phy driver either as it blatantly
forces LED configuration which may not agree with what boot firmware
does. I've noticed phy drivers starting to configure LED behavior more
and more but it seems like there should be dt bindings for that or
maybe an option to preserve the configuration that is set from boot
firmware.

Best regards,

Tim

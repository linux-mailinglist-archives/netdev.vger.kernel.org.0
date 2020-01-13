Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A608C13925C
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgAMNm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:42:59 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33239 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMNm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:42:57 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so4749786pgk.0;
        Mon, 13 Jan 2020 05:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=whYuuyKP7cM54m2BHiaOqZnRmLdECXVM77M1Nve7Ffc=;
        b=BpBu1MKso0rl5yqFzVvoG+42t1/WiLxg452cMSkz5JIP6pdNF84C8ImAhLacQb8hpE
         wrO+C9PizuH/G7n54SGH1J+efVOgRy61RsZ8hXfYMItaNaQmiEC50GqsTJ7N64UlZD9O
         LeTfb56GeeK2RBvGKnOp2B+SaMW37ktA+1AH6OqhotZdLLublMQ6PkqeR0BfvGA9KG+V
         8m1E6re0psxTVrBNox9DOcsNRInLzMx+222WfyrppqUU+AcxBx7gD/wnejdICsysN2+d
         d1Fghpo5Y4Jl5N7ty/vrPI8s6aGEpKUZVCcDOd5zN6oxesk1zTIYd1+YUdF/pH/xhOT+
         uUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=whYuuyKP7cM54m2BHiaOqZnRmLdECXVM77M1Nve7Ffc=;
        b=Dm/+ri4Co5cfnkXxZxTTdKVoZYJg8xjs75qJebZtT+V9uqybUpIg1kWqguQYzyK5tP
         2SGCRvGOls/MKxdTdwQ+rL0JwOnZnpbEJ6TE4uJ8V+aZ85BNH4dmUiSiAOImSPa30lbP
         Hvx1+3eN+sJRLkDJ+3FOPVn3xKjzWWVszIaDdMNFxFmHLorDEWB1WgnLo1N9bZSnFM7o
         ppkdxdaq3vZQrloKi6NSZs5moNU/1zXJ6fULzyRKfYNVSQCium2ODnXk/S1stUup8MpG
         ut5Z5boofqYH11Ppp4G9Lcjgz3b9c+6LZ8bI3PFZxCkuRU6myuDnc51Joz0/nm3rVlw9
         jPFg==
X-Gm-Message-State: APjAAAXwiA0U2XUYE2gOreEQUrpZQ1M6S0IO0ozl5shSStgI8sbbPyn0
        4WmqUAOvg+F1fMgqrw9EphuHPFDc0QzgLySWGfrkFwp6h6M=
X-Google-Smtp-Source: APXvYqxf6ye7tv+WsLah0hWVoa8RQA0tzFyu/ew79zuYgii1HftfpvsqkAaYYHP4cjua4I+c3QcgTwcUHn5nw1BwR3o=
X-Received: by 2002:a63:941:: with SMTP id 62mr21498457pgj.203.1578922976770;
 Mon, 13 Jan 2020 05:42:56 -0800 (PST)
MIME-Version: 1.0
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
In-Reply-To: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 13 Jan 2020 15:42:47 +0200
Message-ID: <CAHp75VeOefY_BK7MitFtdb7enrh5TOOwZ8kDJfVxvW28gejUbg@mail.gmail.com>
Subject: Re: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 3:13 PM Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> Adds the basic support for XPCS including support for USXGMII.

...

> +#define SYNOPSYS_XPHY_ID               0x7996ced0
> +#define SYNOPSYS_XPHY_MASK             0xffffffff

GENMASK() ?
(It seems bits.h is missed in the headers block)

...

> +#define DW_USXGMII_2500                        (BIT(5))
> +#define DW_USXGMII_1000                        (BIT(6))
> +#define DW_USXGMII_100                 (BIT(13))
> +#define DW_USXGMII_10                  (0)

Useless parentheses.

...

> +static int dw_poll_reset(struct phy_device *phydev, int dev)
> +{
> +       /* Poll until the reset bit clears (50ms per retry == 0.6 sec) */
> +       unsigned int retries = 12;
> +       int ret;
> +
> +       do {

> +               msleep(50);

It's a bit unusual to have timeout loop to be started with sleep.
Imagine the case when between writing a reset bit and actual checking
the scheduling happens and reset has been done You add here
unnecessary 50 ms of waiting.

> +               ret = phy_read_mmd(phydev, dev, MDIO_CTRL1);
> +               if (ret < 0)
> +                       return ret;
> +       } while (ret & MDIO_CTRL1_RESET && --retries);
> +       if (ret & MDIO_CTRL1_RESET)
> +               return -ETIMEDOUT;
> +
> +       return 0;
> +}
> +
> +static int __dw_soft_reset(struct phy_device *phydev, int dev, int reg)
> +{
> +       int val;

val?! Perhaps ret is better name?
Applicable to the rest of functions.

> +
> +       val = phy_write_mmd(phydev, dev, reg, MDIO_CTRL1_RESET);
> +       if (val < 0)
> +               return val;
> +

> +       val = dw_poll_reset(phydev, dev);
> +       if (val < 0)
> +               return val;
> +
> +       return 0;

return dw_poll_reset(...);

> +}
> +
> +static int dw_soft_reset(struct phy_device *phydev, u32 mmd_mask)
> +{
> +       int val, devad;
> +
> +       while (mmd_mask) {
> +               devad = __ffs(mmd_mask);
> +               mmd_mask &= ~BIT(devad);

for_each_set_bit()

> +
> +               val = __dw_soft_reset(phydev, devad, MDIO_CTRL1);
> +               if (val < 0)
> +                       return val;
> +       }
> +
> +       return 0;
> +}
> +
> +static int dw_read_link(struct phy_device *phydev, u32 mmd_mask)
> +{
> +       bool link = true;
> +       int val, devad;
> +
> +       while (mmd_mask) {
> +               devad = __ffs(mmd_mask);
> +               mmd_mask &= ~BIT(devad);

Ditto.

> +
> +               val = phy_read_mmd(phydev, devad, MDIO_STAT1);
> +               if (val < 0)
> +                       return val;
> +
> +               if (!(val & MDIO_STAT1_LSTATUS))
> +                       link = false;
> +       }
> +
> +       return link;
> +}

> +#define dw_warn(__phy, __args...) \

dw_warn() -> dw_warn_if_phy_link()

> +({ \
> +       if ((__phy)->link) \
> +               dev_warn(&(__phy)->mdio.dev, ##__args); \
> +})

...

> +       int val, speed_sel = 0x0;

Redundant assignment.

> +       switch (phydev->speed) {
> +       case SPEED_10:
> +               speed_sel = DW_USXGMII_10;
> +               break;
> +       case SPEED_100:
> +               speed_sel = DW_USXGMII_100;
> +               break;
> +       case SPEED_1000:
> +               speed_sel = DW_USXGMII_1000;
> +               break;
> +       case SPEED_2500:
> +               speed_sel = DW_USXGMII_2500;
> +               break;
> +       case SPEED_5000:
> +               speed_sel = DW_USXGMII_5000;
> +               break;
> +       case SPEED_10000:
> +               speed_sel = DW_USXGMII_10000;
> +               break;
> +       default:
> +               /* Nothing to do here */
> +               return 0;
> +       }

...

> +static int dw_config_aneg_c73(struct phy_device *phydev)
> +{
> +       u32 adv = 0;

Redundant assignment.

> +       int ret;
> +
> +       /* SR_AN_ADV3 */
> +       adv = phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV3);
> +       if (adv < 0)
> +               return adv;

> +}

...

> +       do {
> +               msleep(50);

Same as above about timeout loops.

> +               val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
> +               if (val < 0)
> +                       return val;
> +       } while (val & MDIO_AN_CTRL1_RESTART && --retries);

...

> +static int dw_aneg_done(struct phy_device *phydev)
> +{
> +       int val;
> +
> +       val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
> +       if (val < 0)
> +               return val;
> +
> +       if (val & MDIO_AN_STAT1_COMPLETE) {
> +               val = phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_LP_ABL1);
> +               if (val < 0)
> +                       return val;
> +
> +               /* Check if Aneg outcome is valid */
> +               if (!(val & 0x1))
> +                       goto fault;
> +

> +               return 1;

1?! What does it mean?

> +       }
> +
> +       if (val & MDIO_AN_STAT1_RFAULT)
> +               goto fault;
> +
> +       return 0;
> +fault:
> +       dev_err(&phydev->mdio.dev, "Invalid Autoneg result!\n");
> +       dev_err(&phydev->mdio.dev, "CTRL1=0x%x, STAT1=0x%x\n",
> +               phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1),
> +               phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1));
> +       dev_err(&phydev->mdio.dev, "ADV1=0x%x, ADV2=0x%x, ADV3=0x%x\n",
> +               phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV1),
> +               phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV2),
> +               phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_ADV3));
> +       dev_err(&phydev->mdio.dev, "LP_ADV1=0x%x, LP_ADV2=0x%x, LP_ADV3=0x%x\n",
> +               phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_LP_ABL1),
> +               phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_LP_ABL2),
> +               phy_read_mmd(phydev, MDIO_MMD_AN, DW_SR_AN_LP_ABL3));
> +
> +       val = dw_soft_reset(phydev, MDIO_DEVS_PCS);
> +       if (val < 0)
> +               return val;
> +
> +       return dw_config_aneg(phydev);
> +}

...

> +       phydev->pause = val & DW_C73_PAUSE ? 1 : 0;
> +       phydev->asym_pause = val & DW_C73_ASYM_PAUSE ? 1 : 0;

!!(x) should work as well. But I think compiler optimizes that ternary well.

...

> +               val = dw_aneg_done(phydev);
> +               if (val <= 0) {

This <= 0 should be explained. Why we set link when it's < 0 or
otherwise why we return 0 when link is set to false.

> +                       phydev->link = false;
> +                       return val;
> +               }

...

> +static struct mdio_device_id __maybe_unused dw_tbl[] = {
> +       { SYNOPSYS_XPHY_ID, SYNOPSYS_XPHY_MASK },
> +       { },

Comma is not needed.

> +};

-- 
With Best Regards,
Andy Shevchenko

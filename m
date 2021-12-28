Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878AA480762
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 09:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhL1IWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 03:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhL1IWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 03:22:07 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AFCC061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 00:22:07 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z9-20020a17090a7b8900b001b13558eadaso20723813pjc.4
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 00:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KfWFTFsuzsr8X8U6KyBefX/VYh4fYkfqF4Oj0/eygbc=;
        b=Ajj+LIoZvX06CG7aTqGXua+elrfm+I/LHy9JhazdJSGqR1X0gLYDu2NdSeCXUNKN4R
         yxihe9KPAMD+4hegdvVo5U0CvN8xqkz3wAyKDFHQGFTWA6dlw/NTGd7ZvlqwTfDieTZU
         RuHu9NQvUlMD6B0t9YSyyBgJDFdaIjX0oXj+lIa9x34h096Gusg/J44r4Nme+TugAIKu
         VauCQrDZwZdYFdPgUEeNEWMN5CiHwg+9dxrXMhKQRj8v62cfJXMwM12aghaAu2R2q4AA
         Z+um8rPavI0jliSvws5+jhqaLlyGYILTzVfgozUkgA8sNVWVuiLCaOW+/QF7yqiqur1i
         kp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KfWFTFsuzsr8X8U6KyBefX/VYh4fYkfqF4Oj0/eygbc=;
        b=SMZovoByKOtxNnsOpyyM7AqipKZoLUJBl+H8wSY42hPaCnMQiKE5hBFqtuKaerHFIo
         zWl3KTVFNzNvMmxKHp+aN7XckPq2OgWP0+a7rPROsyYLyqWrOn8kTTMhRymLQqV8qdq7
         NHfi6vOC05MYyXjNvdmgMHdekByVjSvkGZgAy7Lmx+48gQuJcIAR5LkrBwP7WhpYRk5R
         EjbRVFS1E98Oj0N3CpvTmOuSGDiGtFnyKQrrkpVTt8fpDUpSx7k76eI9Ic8pOHhwQli5
         m+PTT+zENgilp8NhZIMcf15V42a/3iYg4+Py9WXBQrDvyKdGLZC6dhkMPcKLR09cqMX9
         Jqyg==
X-Gm-Message-State: AOAM532hju4zSzMC6JsJbmI7OqK/1fVZeJMt7FqVPHgm8wBcsfs0t6+L
        GBmFDjONrcO+yL0zDOdG69grTFEyXe2x729t8vtYQffK1SsY5Q==
X-Google-Smtp-Source: ABdhPJwinZ4a1/fkAASY870XKSHCEyLKdl2A8SnVey6SgRBboM8Aij5MavOmEF5UhSc8zBFqXKw+2S6XRseySIEFXzk=
X-Received: by 2002:a17:902:b106:b0:149:7902:5ed1 with SMTP id
 q6-20020a170902b10600b0014979025ed1mr10511565plr.66.1640679726725; Tue, 28
 Dec 2021 00:22:06 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-8-luizluca@gmail.com> <ea9b8a62-e6ba-0d99-9164-ae5a53075309@bang-olufsen.dk>
In-Reply-To: <ea9b8a62-e6ba-0d99-9164-ae5a53075309@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 28 Dec 2021 05:21:55 -0300
Message-ID: <CAJq09z4g_jfNuRgh4JLLYw0nPg_borA_RT6gnVaoEovAKK6Vnw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 07/13] net: dsa: realtek: add new mdio
 interface for drivers
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em dom., 19 de dez. de 2021 18:17, Alvin =C5=A0ipraga
<ALSI@bang-olufsen.dk> escreveu:
>
> On 12/18/21 09:14, Luiz Angelo Daros de Luca wrote:
> > This driver is a mdio_driver instead of a platform driver (like
> > realtek-smi).
>
> I noticed in the vendor driver that the PHY register access procedure is
> different depending on whether we are connected via MDIO or SMI. For SMI
> it is actually pretty complicated due to indirect register access logic,
> but when you are using MDIO already it seems rather more
> straightforward. Did you check that PHY register access is working
> correctly? I assume so since otherwise you wouldn't even get a link up.
> Second question is whether you considered simplifying it in the MDIO
> case, but I suppose if it works for both cases then there is no harm done=
.

AFAIK, indirect access is working as expected and for both cases.

>
> >
> > Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > ---
> >   drivers/net/dsa/realtek/Kconfig        |  11 +-
> >   drivers/net/dsa/realtek/Makefile       |   1 +
> >   drivers/net/dsa/realtek/realtek-mdio.c | 270 ++++++++++++++++++++++++=
+
> >   drivers/net/dsa/realtek/realtek.h      |   2 +
> >   4 files changed, 282 insertions(+), 2 deletions(-)
> >   create mode 100644 drivers/net/dsa/realtek/realtek-mdio.c
> >
> > diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/=
Kconfig
> > index cd1aa95b7bf0..73b26171fade 100644
> > --- a/drivers/net/dsa/realtek/Kconfig
> > +++ b/drivers/net/dsa/realtek/Kconfig
> (...)
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/device.h>
> > +#include <linux/spinlock.h>
>
> I don't think you need all of these includes (e.g. spinlock).

OK. I'll take a look.

>
> > +#include <linux/skbuff.h>
> > +#include <linux/of.h>
> > +#include <linux/of_device.h>
> > +#include <linux/of_mdio.h>
> > +#include <linux/delay.h>
> > +#include <linux/gpio/consumer.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/regmap.h>
> > +#include <linux/bitops.h>
> > +#include <linux/if_bridge.h>
> > +
> > +#include "realtek.h"
> > +
> > +/* Read/write via mdiobus */
> > +#define MDC_MDIO_CTRL0_REG           31
> > +#define MDC_MDIO_START_REG           29
> > +#define MDC_MDIO_CTRL1_REG           21
> > +#define MDC_MDIO_ADDRESS_REG         23
> > +#define MDC_MDIO_DATA_WRITE_REG              24
> > +#define MDC_MDIO_DATA_READ_REG               25
> > +
> > +#define MDC_MDIO_START_OP            0xFFFF
> > +#define MDC_MDIO_ADDR_OP             0x000E
> > +#define MDC_MDIO_READ_OP             0x0001
> > +#define MDC_MDIO_WRITE_OP            0x0003
> > +#define MDC_REALTEK_DEFAULT_PHY_ADDR 0x0
> > +
> > +int realtek_mdio_read_reg(struct realtek_priv *priv, u32 addr, u32 *da=
ta)
> > +{
> > +     u32 phy_id =3D priv->phy_id;
> > +     struct mii_bus *bus =3D priv->bus;
> > +
> > +     BUG_ON(in_interrupt());
>
> Again, please don't use BUG here - just make sure this never happens (it
> looks OK to me). There is a separate warning in mutex_lock which may
> print a stacktrace if the kernel is configured to do so.

OK. So, is it safe to simply drop it? I'm not sure what this check is
trying to avoid but it looks like mdio read/write are not allowed to
come from interruptions. The subdrivers can configure an interrupt
controller property to use it instead of polling port status. Would
that trigger this BUG_ON? Should I try harder to avoid the presence of
an interrupt controller? In my case, there is no dedicated interrupt
GPIO for my Realtek switch and maybe it is a requirement for
mdio-connected switches.

>
> > +
> > +     mutex_lock(&bus->mdio_lock);
>
> Newline (to balance the newline before mutex_unlock)?

OK

>
> > +     /* Write Start command to register 29 */
> > +     bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
>
> I'm curious where these START commands came from because I cannot find
> an anlogous procedure in the Realtek driver dump I have. Did you figure
> this out empirically? Does it not work without? Same goes for the other
> ones downstairs.

It came from OpenWrt rtl8667b driver:

https://github.com/openwrt/openwrt/blob/f0c0b18234418c6ed6d35fcf1c6e5b0cbdc=
eed49/target/linux/generic/files/drivers/net/phy/rtl8366_smi.c#L266

Trully, I didn't study the details in the MDIO read/write. I just used
a code that has been working for years in OpenWrt. I didn't test it
without the start but I'll do it in a couple of days. Now I'm away
from my device.

>
>
>
> > +
> > +     /* Write address control code to register 31 */
>
> Not particularly informative to state the register number when we have
> macros...

I'll improve it or drop it.

>
> > +     bus->write(bus, phy_id, MDC_MDIO_CTRL0_REG, MDC_MDIO_ADDR_OP);
> > +
> > +     /* Write Start command to register 29 */
> > +     bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
> > +
> > +     /* Write address to register 23 */
> > +     bus->write(bus, phy_id, MDC_MDIO_ADDRESS_REG, addr);
> > +
> > +     /* Write Start command to register 29 */
> > +     bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
> > +
> > +     /* Write read control code to register 21 */
> > +     bus->write(bus, phy_id, MDC_MDIO_CTRL1_REG, MDC_MDIO_READ_OP);
> > +
> > +     /* Write Start command to register 29 */
> > +     bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
> > +
> > +     /* Read data from register 25 */
> > +     *data =3D bus->read(bus, phy_id, MDC_MDIO_DATA_READ_REG);
> > +
> > +     mutex_unlock(&bus->mdio_lock);
> > +
> > +     return 0;
> > +}
> > +
> > +static int realtek_mdio_write_reg(struct realtek_priv *priv, u32 addr,=
 u32 data)
> > +{
> > +     u32 phy_id =3D priv->phy_id;
> > +     struct mii_bus *bus =3D priv->bus;
> > +
> > +     BUG_ON(in_interrupt());
> > +
> > +     mutex_lock(&bus->mdio_lock);
> > +
> > +     /* Write Start command to register 29 */
> > +     bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
> > +
> > +     /* Write address control code to register 31 */
> > +     bus->write(bus, phy_id, MDC_MDIO_CTRL0_REG, MDC_MDIO_ADDR_OP);
> > +
> > +     /* Write Start command to register 29 */
> > +     bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
> > +
> > +     /* Write address to register 23 */
> > +     bus->write(bus, phy_id, MDC_MDIO_ADDRESS_REG, addr);
> > +
> > +     /* Write Start command to register 29 */
> > +     bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
> > +
> > +     /* Write data to register 24 */
> > +     bus->write(bus, phy_id, MDC_MDIO_DATA_WRITE_REG, data);
> > +
> > +     /* Write Start command to register 29 */
> > +     bus->write(bus, phy_id, MDC_MDIO_START_REG, MDC_MDIO_START_OP);
> > +
> > +     /* Write data control code to register 21 */
> > +     bus->write(bus, phy_id, MDC_MDIO_CTRL1_REG, MDC_MDIO_WRITE_OP);
> > +
> > +     mutex_unlock(&bus->mdio_lock);
> > +     return 0;
>
> Newline before return?


ok

>
> > +}
> > +
> > +/* Regmap accessors */
> > +
> > +static int realtek_mdio_write(void *ctx, u32 reg, u32 val)
> > +{
> > +     struct realtek_priv *priv =3D ctx;
> > +
> > +     return realtek_mdio_write_reg(priv, reg, val);
> > +}
> > +
> > +static int realtek_mdio_read(void *ctx, u32 reg, u32 *val)
> > +{
> > +     struct realtek_priv *priv =3D ctx;
> > +
> > +     return realtek_mdio_read_reg(priv, reg, val);
> > +}
> > +
> > +static const struct regmap_config realtek_mdio_regmap_config =3D {
> > +     .reg_bits =3D 10, /* A4..A0 R4..R0 */
> > +     .val_bits =3D 16,
> > +     .reg_stride =3D 1,
> > +     /* PHY regs are at 0x8000 */
> > +     .max_register =3D 0xffff,
> > +     .reg_format_endian =3D REGMAP_ENDIAN_BIG,
> > +     .reg_read =3D realtek_mdio_read,
> > +     .reg_write =3D realtek_mdio_write,
> > +     .cache_type =3D REGCACHE_NONE,
> > +};
> > +
> > +static int realtek_mdio_probe(struct mdio_device *mdiodev)
> > +{
> > +     struct realtek_priv *priv;
> > +     struct device *dev =3D &mdiodev->dev;
> > +     const struct realtek_variant *var;
> > +     int ret;
> > +     struct device_node *np;
> > +
> > +     var =3D of_device_get_match_data(dev);
> > +     priv =3D devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
> > +     if (!priv)
> > +             return -ENOMEM;
> > +
> > +     priv->phy_id =3D mdiodev->addr;
> > +
> > +     // Start by setting up the register mapping
>
> Please use C style comments.


I'll just drop it. It is not very informative.

>
> > +     priv->map =3D devm_regmap_init(dev, NULL, priv, &realtek_mdio_reg=
map_config);
> > +
> > +     priv->bus =3D mdiodev->bus;
> > +     priv->dev =3D &mdiodev->dev;
> > +     priv->chip_data =3D (void *)priv + sizeof(*priv);
> > +
> > +     priv->clk_delay =3D var->clk_delay;
> > +     priv->cmd_read =3D var->cmd_read;
> > +     priv->cmd_write =3D var->cmd_write;
> > +     priv->ops =3D var->ops;
> > +
> > +     if (IS_ERR(priv->map))
> > +             dev_warn(dev, "regmap initialization failed");
>
> Shouldn't you bail out here? Like from the smi part:
>
>         smi->map =3D devm_regmap_init(dev, NULL, smi,
>                                     &realtek_smi_mdio_regmap_config);
>         if (IS_ERR(smi->map)) {
>                 ret =3D PTR_ERR(smi->map);
>                 dev_err(dev, "regmap init failed: %d\n", ret);
>                 return ret;
>         }
>
> It is also more common to check the return value (in this case from
> devm_regmap_init) immediately after the call, not after filling the rest
> of a struct.


Yes. Thanks.

>
> > +
> > +     priv->write_reg_noack =3D realtek_mdio_write_reg;
> > +
> > +     np =3D dev->of_node;
> > +
> > +     dev_set_drvdata(dev, priv);
> > +     spin_lock_init(&priv->lock);
> > +
> > +     /* TODO: if power is software controlled, set up any regulators h=
ere */
> > +     priv->leds_disabled =3D of_property_read_bool(np, "realtek,disabl=
e-leds");
> > +
> > +     ret =3D priv->ops->detect(priv);
> > +     if (ret) {
> > +             dev_err(dev, "unable to detect switch\n");
> > +             return ret;
> > +     }
> > +
> > +     priv->ds =3D devm_kzalloc(dev, sizeof(*priv->ds), GFP_KERNEL);
> > +     if (!priv->ds)
> > +             return -ENOMEM;
> > +
> > +     priv->ds->dev =3D dev;
> > +     priv->ds->num_ports =3D priv->num_ports;
> > +     priv->ds->priv =3D priv;
> > +     priv->ds->ops =3D var->ds_ops;
> > +
> > +     ret =3D dsa_register_switch(priv->ds);
> > +     if (ret) {
> > +             dev_err(priv->dev, "unable to register switch ret =3D %d\=
n", ret);
> > +             return ret;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void realtek_mdio_remove(struct mdio_device *mdiodev)
> > +{
> > +     struct realtek_priv *priv =3D dev_get_drvdata(&mdiodev->dev);
> > +
> > +     if (!priv)
> > +             return;
> > +
> > +     dsa_unregister_switch(priv->ds);
> > +     //gpiod_set_value(priv->reset, 1);
>
> What's going on here?

It is a leftover from realtek-smi code. The SMI code deasserts the
reset pin during the probe, because it asserted it during removal. For
SMI, the reset gpio is required but I'm not sure it should be even
there.

In my device, there is a reset pin for the internal switch but I'm not
sure if it is shared with the realtek switch. It would give an
interesting state if the internal switch resets when someone removes
the external switch driver.

I'm not sure if I should reenable this or simply drop it. Even if the
device requires a reset, it would only happen after it was unloaded.
Anyway, I think that requiring a reset is just a symptom that the
driver initialization steps is missing something.

> > +     dev_set_drvdata(&mdiodev->dev, NULL);
> > +}
> > +
> > +static void realtek_mdio_shutdown(struct mdio_device *mdiodev)
> > +{
> > +     struct realtek_priv *priv =3D dev_get_drvdata(&mdiodev->dev);
> > +
> > +     if (!priv)
> > +             return;
> > +
> > +     dsa_switch_shutdown(priv->ds);
> > +
> > +     dev_set_drvdata(&mdiodev->dev, NULL);
> > +}
> > +
> > +static const struct of_device_id realtek_mdio_of_match[] =3D {
> > +#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8366RB)
> > +     { .compatible =3D "realtek,rtl8366rb", .data =3D &rtl8366rb_varia=
nt, },
> > +#endif
> > +     /* FIXME: add support for RTL8366S and more */
> > +     { .compatible =3D "realtek,rtl8366s", .data =3D NULL, },
>
> Won't this cause a NULL-pointer dereference in realtek_mdio_probe()
> since we don't check if of_device_get_match_data() returns NULL?
>
> It's also the same in the SMI part. Linus, should we just delete this
> line for now? Surely it never worked?
>
> > +#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8365MB)
> > +     { .compatible =3D "realtek,rtl8365mb", .data =3D &rtl8365mb_varia=
nt, },
> > +#endif
> > +     { /* sentinel */ },
> > +};
> > +MODULE_DEVICE_TABLE(of, realtek_mdio_of_match);
> > +
> > +static struct mdio_driver realtek_mdio_driver =3D {
> > +     .mdiodrv.driver =3D {
> > +             .name =3D "realtek-mdio",
> > +             .of_match_table =3D of_match_ptr(realtek_mdio_of_match),
> > +     },
> > +     .probe  =3D realtek_mdio_probe,
> > +     .remove =3D realtek_mdio_remove,
> > +     .shutdown =3D realtek_mdio_shutdown,
> > +};
> > +
> > +mdio_module_driver(realtek_mdio_driver);
> > +
> > +MODULE_AUTHOR("Luiz Angelo Daros de Luca <luizluca@gmail.com>");
> > +MODULE_DESCRIPTION("Driver for Realtek ethernet switch connected via M=
DIO interface");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realte=
k/realtek.h
> > index a03de15c4a94..97274273cb3b 100644
> > --- a/drivers/net/dsa/realtek/realtek.h
> > +++ b/drivers/net/dsa/realtek/realtek.h
> > @@ -50,6 +50,8 @@ struct realtek_priv {
> >       struct gpio_desc        *mdio;
> >       struct regmap           *map;
> >       struct mii_bus          *slave_mii_bus;
> > +     struct mii_bus          *bus;
> > +     int                     phy_id;
> >
> >       unsigned int            clk_delay;
> >       u8                      cmd_read;
>

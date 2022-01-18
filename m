Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB858491E8F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 05:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbiAREix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 23:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbiAREiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 23:38:52 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28577C061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 20:38:52 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h12so192945pjq.3
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 20:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+zSx7QV7XNVje98egLAskk0mJfvbAlbPVNucLWAgrE=;
        b=aYX26mRfP8c27lYpNpVj2WyH2yG+Slr4AL5i48Uogrgq3gpnd8Y9pAZL19HXMo8raq
         WMvsIWXzU84f7Oq+VkdOhneDXcICBP0TmHwprs6rwe6LNE0gUClRdlTUAO5Qx24swiBB
         iOgfISROrkqvcwwfYjXNeBmLgN78UJlvrKuZI1d+gGncuzmEPAYAkrxOxiprfMyh9P6W
         cXq933C1izpOC7acHAIyt2rwsV6ecTIufJ2j7/atHqnXBOrGudKOFLLrTubsGiRWpAGb
         PhXkCXJIr4g82dcLuks9JDLejLwLkxwKWB+W1K+xVeiL9uzSmGQv3UBBMR9kE+GGbUVm
         61bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+zSx7QV7XNVje98egLAskk0mJfvbAlbPVNucLWAgrE=;
        b=GYoH0yXJ1MtrJIwyCofvHo0iuYQRl7vrQldQvWVH/sSA2buGmGKy52M8cSq1D/Ibdk
         oLDeenbOpcdMVx6B7NlBbJ2U7pq3u6YBvPXLSjxnz4rjhuFVuzUJzuqacVMlvoDok+Dh
         ZVuWATyN+GxC1VBC55CwcHaj/COerqjl80F9OG//nyWpBwPP0FNzYJ2UIRArbzmWphWz
         UmPOUfc5Cij1FpurzS2VMx/ND8H6vfB0x8EfxiXRpe7kfST5EI39ITMpAhiwoSJd071c
         8svTYcLN9D9Gp7SYXBUCyNbxxNRB1udLMc8+EDVdf0kNP/kM2qiBgVD6SSXtSjweqA4G
         jhVA==
X-Gm-Message-State: AOAM532tLi/4rTXWJQixjmXHcpi/kPhtjA8e9/K29A2NfFGIwwvQDt2e
        yfOHdqgEUYfzYKcMl1OpWmBuZs5hoJLXsi78Jb8=
X-Google-Smtp-Source: ABdhPJx9hXZQVLwwKTCruTeYbnLjl83mv2+oohpOaCrwM+WhS6ealhfOuRBG/fuf06tz2d5ofIM+gin4Ah9ohWoz2bg=
X-Received: by 2002:a17:902:8544:b0:14a:bea3:1899 with SMTP id
 d4-20020a170902854400b0014abea31899mr7506401plo.143.1642480731497; Mon, 17
 Jan 2022 20:38:51 -0800 (PST)
MIME-Version: 1.0
References: <20220105031515.29276-1-luizluca@gmail.com> <20220105031515.29276-7-luizluca@gmail.com>
 <feaf03db-6fb9-d79f-0f51-bbedca739785@gmail.com>
In-Reply-To: <feaf03db-6fb9-d79f-0f51-bbedca739785@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 18 Jan 2022 01:38:40 -0300
Message-ID: <CAJq09z5A3SiXXMrm-7SfyiRF8KQw5cnTeArBWikx_ka8QEJo2Q@mail.gmail.com>
Subject: Re: [PATCH net-next v4 06/11] net: dsa: realtek: add new mdio
 interface for drivers
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int realtek_mdio_read_reg(struct realtek_priv *priv, u32 addr, u32 *data)
> > +{
> > +     u32 phy_id = priv->phy_id;
> > +     struct mii_bus *bus = priv->bus;
> > +
> > +     mutex_lock(&bus->mdio_lock);
> > +
> > +     bus->write(bus, phy_id, REALTEK_MDIO_CTRL0_REG, REALTEK_MDIO_ADDR_OP);
> > +     bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> > +     bus->write(bus, phy_id, REALTEK_MDIO_ADDRESS_REG, addr);
> > +     bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> > +     bus->write(bus, phy_id, REALTEK_MDIO_CTRL1_REG, REALTEK_MDIO_READ_OP);
> > +     bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> > +     *data = bus->read(bus, phy_id, REALTEK_MDIO_DATA_READ_REG);
>
> Do you have no way to return an error for instance, if you read from a
> non-existent PHY device on the MDIO bus, -EIO would be expected for
> instance. If the data returned is 0xffff that ought to be enough.

I'll check for error (non zero for write, negative for read) and
return that value

> > +
> > +     mutex_unlock(&bus->mdio_lock);
> > +
> > +     return 0;
> > +}
> > +
> > +static int realtek_mdio_write_reg(struct realtek_priv *priv, u32 addr, u32 data)
> > +{
> > +     u32 phy_id = priv->phy_id;
> > +     struct mii_bus *bus = priv->bus;
> > +
> > +     mutex_lock(&bus->mdio_lock);
> > +
> > +     bus->write(bus, phy_id, REALTEK_MDIO_CTRL0_REG, REALTEK_MDIO_ADDR_OP);
> > +     bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> > +     bus->write(bus, phy_id, REALTEK_MDIO_ADDRESS_REG, addr);
>
> This repeats between read and writes, might be worth a helper function.

Without the REALTEK_MDIO_START_OP Alvin asked, it is not worth it anymore.

>
> > +     bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> > +     bus->write(bus, phy_id, REALTEK_MDIO_DATA_WRITE_REG, data);
> > +     bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> > +     bus->write(bus, phy_id, REALTEK_MDIO_CTRL1_REG, REALTEK_MDIO_WRITE_OP);
> > +
> > +     mutex_unlock(&bus->mdio_lock);
> > +
> > +     return 0;
> > +}
> > +
> > +/* Regmap accessors */
> > +
> > +static int realtek_mdio_write(void *ctx, u32 reg, u32 val)
> > +{
> > +     struct realtek_priv *priv = ctx;
> > +
> > +     return realtek_mdio_write_reg(priv, reg, val);
> > +}
> > +
> > +static int realtek_mdio_read(void *ctx, u32 reg, u32 *val)
> > +{
> > +     struct realtek_priv *priv = ctx;
> > +
> > +     return realtek_mdio_read_reg(priv, reg, val);
> > +}
>
> Do you see a value for this function as oppposed to inlining the bodies
> of realtek_mdio_read_reg and realtek_mdio_write_reg directly into these
> two functions?
>

I merged them. I also changed the write_reg_noack signature to match
regmap->write_reg, so I can use it without a wrapper.

> > +
> > +static const struct regmap_config realtek_mdio_regmap_config = {
> > +     .reg_bits = 10, /* A4..A0 R4..R0 */
> > +     .val_bits = 16,
> > +     .reg_stride = 1,
> > +     /* PHY regs are at 0x8000 */
> > +     .max_register = 0xffff,
> > +     .reg_format_endian = REGMAP_ENDIAN_BIG,
> > +     .reg_read = realtek_mdio_read,
> > +     .reg_write = realtek_mdio_write,
> > +     .cache_type = REGCACHE_NONE,
> > +};
> > +
> > +static int realtek_mdio_probe(struct mdio_device *mdiodev)
> > +{
> > +     struct realtek_priv *priv;
> > +     struct device *dev = &mdiodev->dev;
> > +     const struct realtek_variant *var;
> > +     int ret;
> > +     struct device_node *np;
> > +
> > +     var = of_device_get_match_data(dev);
>
> Don't you have to check that var is non-NULL just in case?

I'll add that check but it is not likely to happen.

>
> > +     priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
> > +     if (!priv)
> > +             return -ENOMEM;
> > +
> > +     priv->map = devm_regmap_init(dev, NULL, priv, &realtek_mdio_regmap_config);
> > +     if (IS_ERR(priv->map)) {
> > +             ret = PTR_ERR(priv->map);
> > +             dev_err(dev, "regmap init failed: %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     priv->phy_id = mdiodev->addr;
>
> Please use a more descriptive variable name such as mdio_addr or
> something like that. I know that phy_id is typically used but it could
> also mean a 32-bit PHY unique identifier, which a MDIO device does not
> have typically.

Renamed to mdio_addr. As you said, I just used what is typically used
but you know best.

>
> Looks fine otherwise.

Thanks, Florian.

Luiz

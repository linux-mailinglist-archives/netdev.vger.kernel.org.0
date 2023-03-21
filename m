Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747C06C2DE6
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 10:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCUJcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 05:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjCUJcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 05:32:09 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F962DBEB;
        Tue, 21 Mar 2023 02:32:08 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id x198so6552898ybe.9;
        Tue, 21 Mar 2023 02:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679391127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxAl6P7LjZGLPUad9YiYxQw9UvNeqA2k882/4TQj+2M=;
        b=TXTyuHsSWLPU3uGxMKSvr7NBzqPO7uz9Nm2FA3aXycmFTskKCBjke+XzO61KdoOgXb
         GTescvK25EYx1ZSysLmMR4C6eG/hbdudKVIv55z4/qMj00roH+Sb9aerDhukKXKhCqrG
         0qVkPQmNQKtTZhhAzWp555JYD9GXoaGfjvJL0t//4hxmHUOQz30knoK+Ih/LB6NDzSNE
         8ysWgl0nesyasI7v6vo+Gb176PRrBDdktysL51W1GxUV6f7CcXjfueAl/pUC5M7ANEcZ
         MMUipYbV+GQwBCebZ0bWVpUPla4+dDtLwdD9siEDO5HtBXsa0xFrxsU8LynvIpb9/2go
         91mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679391127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vxAl6P7LjZGLPUad9YiYxQw9UvNeqA2k882/4TQj+2M=;
        b=JThyUsK2kr6ZMm/nO1s1WdLoVAHMOV9XqqarnquLYGmI9ZfxLXpK4VyHMI1FDZ5zek
         7Ddw2wqF5gPu1sSbMZHC8baXn+SpZ9rEn+25prQ7RqqrDh79GDRZEEgykNdLfwep2yCw
         UYBNxh0MgIM8jWxZj/zazJSmZyZF+68F5yw/F1J5Se/cAQ1gjcUZ0JQfd9flkb+bL/xG
         8fAf/M7oNxas468112rXCtmltWvvZmgJxYt46PFfnzbx9iOr2Ejx/XOVIV0y/crtHf30
         zbw3CIvp5utYocF193nKttrltUTW8lj5oMc1fsUJRMsz/RlW1OGv3ZvZOzZ48LH1kpUv
         iNKA==
X-Gm-Message-State: AAQBX9cwKYy11ZNK03YJUkTQIzMMjDR3SMyc/n1EdApr1BjvakX+OPlp
        HFwBJbWFQiQBhMQ/ytqkboF/BLUOi/KwiszjwsA=
X-Google-Smtp-Source: AKy350ZjNwIja6llqyKuUDIfDv5nwr0Kha9siW3n5D9MjKRke6UPZymetQDMELjmyiZBverIvmpGJgMnWKOuHJj7TUM=
X-Received: by 2002:a05:6902:242:b0:94a:ebba:cba6 with SMTP id
 k2-20020a056902024200b0094aebbacba6mr792174ybs.9.1679391126946; Tue, 21 Mar
 2023 02:32:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:199d:b0:490:be1c:c35a with HTTP; Tue, 21 Mar 2023
 02:32:06 -0700 (PDT)
In-Reply-To: <20230320182813.963508-1-noltari@gmail.com>
References: <20230320182813.963508-1-noltari@gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Tue, 21 Mar 2023 10:32:06 +0100
Message-ID: <CAKR-sGfWkqumiPD3Ni_F5PzTW3Eb_GvFY9=h0iP0tYujwtFL3Q@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: net: dsa: b53: mmap: add phy ops
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-03-20 19:28 GMT+01:00, =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail=
.com>:
> Currently, B53 MMAP BCM63xx devices with an external switch hang when
> performing PHY read and write operations due to invalid registers access.
> This adds support for PHY ops by using the internal bus from
> mdio-mux-bcm6368
> when probed by device tree and also falls back to direct MDIO registers i=
f
> not.
>
> This is an alternative to:
> -
> https://patchwork.kernel.org/project/netdevbpf/cover/20230317113427.30216=
2-1-noltari@gmail.com/
> -
> https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.30216=
2-2-noltari@gmail.com/
> -
> https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.30216=
2-3-noltari@gmail.com/
> -
> https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.30216=
2-4-noltari@gmail.com/
> As discussed, it was an ABI break and not the correct way of fixing the
> issue.
>
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_mmap.c    | 86 +++++++++++++++++++++++++++++++
>  include/linux/platform_data/b53.h |  1 +
>  2 files changed, 87 insertions(+)
>
> diff --git a/drivers/net/dsa/b53/b53_mmap.c
> b/drivers/net/dsa/b53/b53_mmap.c
> index 706df04b6cee..7deca1c557c5 100644
> --- a/drivers/net/dsa/b53/b53_mmap.c
> +++ b/drivers/net/dsa/b53/b53_mmap.c
> @@ -19,14 +19,25 @@
>  #include <linux/bits.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of_mdio.h>
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
>  #include <linux/platform_data/b53.h>
>
>  #include "b53_priv.h"
>
> +#define REG_MDIOC		0xb0
> +#define  REG_MDIOC_EXT_MASK	BIT(16)
> +#define  REG_MDIOC_REG_SHIFT	20
> +#define  REG_MDIOC_PHYID_SHIFT	25
> +#define  REG_MDIOC_RD_MASK	BIT(30)
> +#define  REG_MDIOC_WR_MASK	BIT(31)
> +
> +#define REG_MDIOD		0xb4
> +
>  struct b53_mmap_priv {
>  	void __iomem *regs;
> +	struct mii_bus *bus;

Can we reuse "bus" from b53_device instead of adding a new one for
b53_mmap_priv?

>  };
>
>  static int b53_mmap_read8(struct b53_device *dev, u8 page, u8 reg, u8
> *val)
> @@ -216,6 +227,69 @@ static int b53_mmap_write64(struct b53_device *dev, =
u8
> page, u8 reg,
>  	return 0;
>  }
>
> +static inline void b53_mmap_mdio_read(struct b53_device *dev, int phy_id=
,
> +				      int loc, u16 *val)
> +{
> +	uint32_t reg;
> +
> +	b53_mmap_write32(dev, 0, REG_MDIOC, 0);
> +
> +	reg =3D REG_MDIOC_RD_MASK |
> +	      (phy_id << REG_MDIOC_PHYID_SHIFT) |
> +	      (loc << REG_MDIOC_REG_SHIFT);
> +
> +	b53_mmap_write32(dev, 0, REG_MDIOC, reg);
> +	udelay(50);
> +	b53_mmap_read16(dev, 0, REG_MDIOD, val);
> +}
> +
> +static inline int b53_mmap_mdio_write(struct b53_device *dev, int phy_id=
,
> +				      int loc, u16 val)
> +{
> +	uint32_t reg;
> +
> +	b53_mmap_write32(dev, 0, REG_MDIOC, 0);
> +
> +	reg =3D REG_MDIOC_WR_MASK |
> +	      (phy_id << REG_MDIOC_PHYID_SHIFT) |
> +	      (loc << REG_MDIOC_REG_SHIFT) |
> +	      val;
> +
> +	b53_mmap_write32(dev, 0, REG_MDIOC, reg);
> +	udelay(50);
> +
> +	return 0;
> +}
> +
> +static int b53_mmap_phy_read16(struct b53_device *dev, int addr, int reg=
,
> +			       u16 *value)
> +{
> +	struct b53_mmap_priv *priv =3D dev->priv;
> +	struct mii_bus *bus =3D priv->bus;
> +
> +	if (bus)
> +		*value =3D mdiobus_read_nested(bus, addr, reg);
> +	else
> +		b53_mmap_mdio_read(dev, addr, reg, value);
> +
> +	return 0;
> +}
> +
> +static int b53_mmap_phy_write16(struct b53_device *dev, int addr, int re=
g,
> +				u16 value)
> +{
> +	struct b53_mmap_priv *priv =3D dev->priv;
> +	struct mii_bus *bus =3D priv->bus;
> +	int ret;
> +
> +	if (bus)
> +		ret =3D mdiobus_write_nested(bus, addr, reg, value);
> +	else
> +		ret =3D b53_mmap_mdio_write(dev, addr, reg, value);
> +
> +	return ret;
> +}
> +
>  static const struct b53_io_ops b53_mmap_ops =3D {
>  	.read8 =3D b53_mmap_read8,
>  	.read16 =3D b53_mmap_read16,
> @@ -227,6 +301,8 @@ static const struct b53_io_ops b53_mmap_ops =3D {
>  	.write32 =3D b53_mmap_write32,
>  	.write48 =3D b53_mmap_write48,
>  	.write64 =3D b53_mmap_write64,
> +	.phy_read16 =3D b53_mmap_phy_read16,
> +	.phy_write16 =3D b53_mmap_phy_write16,
>  };
>
>  static int b53_mmap_probe_of(struct platform_device *pdev,
> @@ -234,6 +310,7 @@ static int b53_mmap_probe_of(struct platform_device
> *pdev,
>  {
>  	struct device_node *np =3D pdev->dev.of_node;
>  	struct device_node *of_ports, *of_port;
> +	struct device_node *mdio;
>  	struct device *dev =3D &pdev->dev;
>  	struct b53_platform_data *pdata;
>  	void __iomem *mem;
> @@ -251,6 +328,14 @@ static int b53_mmap_probe_of(struct platform_device
> *pdev,
>  	pdata->chip_id =3D (u32)device_get_match_data(dev);
>  	pdata->big_endian =3D of_property_read_bool(np, "big-endian");
>
> +	mdio =3D of_parse_phandle(np, "mii-bus", 0);

Is "mii-bus" OK or shall we use something like "brcm,mii-bus"?

> +	if (!mdio)
> +		return -EINVAL;
> +
> +	pdata->bus =3D of_mdio_find_bus(mdio);
> +	if (!pdata->bus)
> +		return -EPROBE_DEFER;
> +
>  	of_ports =3D of_get_child_by_name(np, "ports");
>  	if (!of_ports) {
>  		dev_err(dev, "no ports child node found\n");
> @@ -297,6 +382,7 @@ static int b53_mmap_probe(struct platform_device *pde=
v)
>  		return -ENOMEM;
>
>  	priv->regs =3D pdata->regs;
> +	priv->bus =3D pdata->bus;
>
>  	dev =3D b53_switch_alloc(&pdev->dev, &b53_mmap_ops, priv);
>  	if (!dev)
> diff --git a/include/linux/platform_data/b53.h
> b/include/linux/platform_data/b53.h
> index 6f6fed2b171d..be0c5bfdedad 100644
> --- a/include/linux/platform_data/b53.h
> +++ b/include/linux/platform_data/b53.h
> @@ -32,6 +32,7 @@ struct b53_platform_data {
>  	/* only used by MMAP'd driver */
>  	unsigned big_endian:1;
>  	void __iomem *regs;
> +	struct mii_bus *bus;
>  };
>
>  #endif
> --
> 2.30.2
>
>

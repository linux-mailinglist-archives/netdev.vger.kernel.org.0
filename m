Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D544B32C2
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 03:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiBLCsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 21:48:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiBLCsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 21:48:17 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B112E081
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:48:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1644634075; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=l7lfuNdRFyYNmChwp4/EzAsg7g/fEFMdMuiBTFnIsxddW+zGNVyWnRFGIgyP1VOqgU7brQ3g2SCJxarrlv41gWxhBbYXEv4uCb1TG6/3HMEKWfP3aFpIk1U3gGZ9lQlVaR7CIxE61o1kq2LJD/GCreGqi4OwgGQS59XD4oScS7M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1644634075; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=Qz6N2KT0jhiOGBaaM+9LS/034yOYe/AGgndLH5QDZj0=; 
        b=WEXNwZ2DafK+jdbEl1V7Go01QKu2zfJNUUF4sVJ50Uzyw+5SdPUnGxy+BLL+fcF5m6lZqkhvBjp4qqNxQFZnzr6eZ4ah9q1WgLBxbJZcDNAtdN8zgtNR8F9GJOQqW/DlAfrgJ+fo4PdrlQmqxvdpDNCklnBljX44Do11yRADSLU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1644634075;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Content-Type:Content-Transfer-Encoding:From:Mime-Version:Subject:Message-Id:Date:Cc:To;
        bh=Qz6N2KT0jhiOGBaaM+9LS/034yOYe/AGgndLH5QDZj0=;
        b=NA/P3YKPiNcdsqQ8EFdBY0/11ftrtM6e0I3+Hs9TzfzzLnxGJN5eCcaJYBdA9amW
        kh9ocBlHGeTSTSH/nWNdcX5j67mqk4h3vfC+NDdYWSunuhsHAoGjHFvTyZNyhfYvuZE
        XBFQ4qgPERY+mTwlYA0VhLVxZjNjsA0ZIVemo21g=
Received: from [10.10.10.4] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1644634074540224.65486788941382; Fri, 11 Feb 2022 18:47:54 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   =?utf-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Mime-Version: 1.0 (1.0)
Subject: Re:  [PATCH net-next v2] net: dsa: realtek: realtek-mdio: reset before setup
Message-Id: <B3AA2DEA-D04C-49C8-9D22-BA6D64F7A6B2@arinc9.com>
Date:   Sat, 12 Feb 2022 05:47:49 +0300
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        Frank Wunderlich <frank-w@public-files.de>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
X-Mailer: iPhone Mail (17H35)
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BF
>=20
> On 12 Feb 2022, at 05:27, Luiz Angelo Daros de Luca <luizluca@gmail.com> w=
rote:
>=20
> =EF=BB=BFSome devices, like the switch in Banana Pi BPI R64 only starts to=
 answer
> after a HW reset. It is the same reset code from realtek-smi.
>=20
> In realtek-smi, only assert the reset when the gpio is defined.

If realtek-smi also resets before setup with this patch (I don=E2=80=99t und=
erstand code very well) can you mention it next to mdio in the summary too?

In any case:
Acked-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>

>=20
> Reported-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
> ---
> drivers/net/dsa/realtek/realtek-mdio.c | 19 +++++++++++++++++++
> drivers/net/dsa/realtek/realtek-smi.c  | 17 ++++++++++-------
> drivers/net/dsa/realtek/realtek.h      |  3 +++
> 3 files changed, 32 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/real=
tek/realtek-mdio.c
> index 0c5f2bdced9d..fa2339763c71 100644
> --- a/drivers/net/dsa/realtek/realtek-mdio.c
> +++ b/drivers/net/dsa/realtek/realtek-mdio.c
> @@ -152,6 +152,21 @@ static int realtek_mdio_probe(struct mdio_device *mdi=
odev)
>   /* TODO: if power is software controlled, set up any regulators here */
>   priv->leds_disabled =3D of_property_read_bool(np, "realtek,disable-leds"=
);
>=20
> +    /* Assert then deassert RESET */
> +    priv->reset =3D devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH)=
;
> +    if (IS_ERR(priv->reset)) {
> +        dev_err(dev, "failed to get RESET GPIO\n");
> +        return PTR_ERR(priv->reset);
> +    }
> +
> +    if (priv->reset) {
> +        dev_dbg(dev, "asserted RESET\n");
> +        msleep(REALTEK_HW_STOP_DELAY);
> +        gpiod_set_value(priv->reset, 0);
> +        msleep(REALTEK_HW_START_DELAY);
> +        dev_dbg(dev, "deasserted RESET\n");
> +    }
> +
>   ret =3D priv->ops->detect(priv);
>   if (ret) {
>       dev_err(dev, "unable to detect switch\n");
> @@ -185,6 +200,10 @@ static void realtek_mdio_remove(struct mdio_device *m=
diodev)
>=20
>   dsa_unregister_switch(priv->ds);
>=20
> +    /* leave the device reset asserted */
> +    if (priv->reset)
> +        gpiod_set_value(priv->reset, 1);
> +
>   dev_set_drvdata(&mdiodev->dev, NULL);
> }
>=20
> diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realt=
ek/realtek-smi.c
> index 946fbbd70153..a13ef07080a2 100644
> --- a/drivers/net/dsa/realtek/realtek-smi.c
> +++ b/drivers/net/dsa/realtek/realtek-smi.c
> @@ -43,8 +43,6 @@
> #include "realtek.h"
>=20
> #define REALTEK_SMI_ACK_RETRY_COUNT        5
> -#define REALTEK_SMI_HW_STOP_DELAY        25    /* msecs */
> -#define REALTEK_SMI_HW_START_DELAY        100    /* msecs */
>=20
> static inline void realtek_smi_clk_delay(struct realtek_priv *priv)
> {
> @@ -426,10 +424,13 @@ static int realtek_smi_probe(struct platform_device *=
pdev)
>       dev_err(dev, "failed to get RESET GPIO\n");
>       return PTR_ERR(priv->reset);
>   }
> -    msleep(REALTEK_SMI_HW_STOP_DELAY);
> -    gpiod_set_value(priv->reset, 0);
> -    msleep(REALTEK_SMI_HW_START_DELAY);
> -    dev_info(dev, "deasserted RESET\n");
> +    if (priv->reset) {
> +        dev_dbg(dev, "asserted RESET\n");
> +        msleep(REALTEK_HW_STOP_DELAY);
> +        gpiod_set_value(priv->reset, 0);
> +        msleep(REALTEK_HW_START_DELAY);
> +        dev_dbg(dev, "deasserted RESET\n");
> +    }
>=20
>   /* Fetch MDIO pins */
>   priv->mdc =3D devm_gpiod_get_optional(dev, "mdc", GPIOD_OUT_LOW);
> @@ -474,7 +475,9 @@ static int realtek_smi_remove(struct platform_device *=
pdev)
>   dsa_unregister_switch(priv->ds);
>   if (priv->slave_mii_bus)
>       of_node_put(priv->slave_mii_bus->dev.of_node);
> -    gpiod_set_value(priv->reset, 1);
> +
> +    if (priv->reset)
> +        gpiod_set_value(priv->reset, 1);
>=20
>   platform_set_drvdata(pdev, NULL);
>=20
> diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/r=
ealtek.h
> index 3512b832b148..e7d3e1bcf8b8 100644
> --- a/drivers/net/dsa/realtek/realtek.h
> +++ b/drivers/net/dsa/realtek/realtek.h
> @@ -13,6 +13,9 @@
> #include <linux/gpio/consumer.h>
> #include <net/dsa.h>
>=20
> +#define REALTEK_HW_STOP_DELAY        25    /* msecs */
> +#define REALTEK_HW_START_DELAY        100    /* msecs */
> +
> struct realtek_ops;
> struct dentry;
> struct inode;
> --=20
> 2.35.1


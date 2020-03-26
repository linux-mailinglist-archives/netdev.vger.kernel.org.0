Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFD2193A80
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 09:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgCZIMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 04:12:36 -0400
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:7024
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726347AbgCZIMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 04:12:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IM8P2NeW0cZ+KBe2vh1tf2q55NmFd++vAKRkWgX7Em3Y39WM8NoXfrz0PWW8iEA2vGeAA82AGxIeVJ3jfZ68/lxhfO8DVeOXaHXnoh0vRHlupSikFB4AWsriYgZIJAcNZy2KigoOmG8PmCXJJDaKChzy4tdW3az35CcYqbCYOkMKhq/BlOFq3l8xlSd2XLHyuiA3Wo56XLg4tOcapulxSs2bpP0sUNi1XYPOQ/4a4XM39lkM2DSSFv6ZoDeUjZSnkL9ww5RAihpfhvJpndKTaIyZpONGIYrYPxHKD6sl0Wi4NurqZKlagScfEyBcOVt3jH/fsYTvDqkN0j2VgZMaEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hp+hYlTy622z6XoeNOHlYdxpwNKPX9DGBWi1zINYV+I=;
 b=VMW+xrSHAX7ZnK7EG0baWNM7SOptfWumLBJqBJsmTTroafGAghv788bOEpp6upZvkJuGD1qugjnozX0Dtr/gy9NBC/Y6WDGYXvG/qVYKJXUAvL4egonwaUm7dmdi6ioji2jQ6L7Xdcukc8/RPgKL+sBl1YUdl0zTI+R3KtXYES3yS4J1n0PAKhSF/t+/HB3d3fiBbE5eHNA2KVu5Cvhkkm9oo+8dw+/BftBhwpijdtqgsr38GK2b37ZQweNaOkeeWTLaRORu4gVI5VhyZs/p7Yuw4fUv1xBeNZM+1eiyh6cSOJeqfleSPpgFmsaJSd5HZ1vvVFXQivWqxXnuzV+Akw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hp+hYlTy622z6XoeNOHlYdxpwNKPX9DGBWi1zINYV+I=;
 b=JKZ1ApXAKI9qe11vSqqOMSVUxEIfawAr7hYuBMIrYIvW6mEc52Hw0g97b3e7dVAvvnX/cOiN4ashYAT0Ck7c2AV00ZjC0kOzfkPV9IteYtGMk7/VoPJ5yOGjqmUrZBb4BeMZ9jRsPcE9QLTl92xUxyjNl95gGvrxtQ9RyXSArk8=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB2941.eurprd04.prod.outlook.com (10.175.24.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Thu, 26 Mar 2020 07:57:27 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 07:57:27 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: RE: [EXT] [PATCH v2 1/4] net: fec: set GPR bit on suspend by DT
 configuration.
Thread-Topic: [EXT] [PATCH v2 1/4] net: fec: set GPR bit on suspend by DT
 configuration.
Thread-Index: AQHWAtDh+CkQ/OBPP02JRbywuhHuAKhagalQ
Date:   Thu, 26 Mar 2020 07:57:27 +0000
Message-ID: <VI1PR0402MB3600DA9163F47F284D258CDFFFCF0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
 <1585159919-11491-2-git-send-email-martin.fuzzey@flowbird.group>
In-Reply-To: <1585159919-11491-2-git-send-email-martin.fuzzey@flowbird.group>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e6d84ea5-e205-4e24-1217-08d7d15b53a1
x-ms-traffictypediagnostic: VI1PR0402MB2941:|VI1PR0402MB2941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB29414F1077DD416F8FE82EC8FFCF0@VI1PR0402MB2941.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(66946007)(81166006)(9686003)(66556008)(7416002)(66446008)(186003)(64756008)(110136005)(76116006)(55016002)(8676002)(6506007)(66476007)(7696005)(81156014)(26005)(71200400001)(4326008)(5660300002)(2906002)(316002)(86362001)(8936002)(33656002)(15650500001)(54906003)(52536014)(478600001)(45080400002)(30864003)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2941;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OLMDhRAq+5EUPTm3EOn6uomdTS1cbqH5yGqcju1J3B1i5HLHYBZ6U0c/8lzjXQazLTK1AediKydsTGggJHmIwzSC64Ivtc19KcIhcaqAzXtA1LGrPtnppCZOmur7OzDGoeZUipbzz5MGXgFXiNCNCaVvdjIs6zRHyRi4zp/CWNywG2N0yIe5zjJzRwteVh3YE4iFY/cP3hojwf54MO1cf4iGvPaAlter+q8Lqz705rFQaVFxb9OvhcoxAyfBHodOqfTgz0L3pvT/opqcWtN7eEjhh3eZq2N8Y4PESvVGDcFS5bltzOsjqbNPmTQp47mhHYzaRNhYsJiOm8IAo8vr1mgbck9RcP+/8WOg7cahRkW06tf3kyG9TCpxMjAYbfJiFCVw4Mm2FB1Qx4ONWYQnvctdHHUIqHElgV1CZPRhB70wK2/syjTv/z83rhEX/c+S10W1C58aEu581uFIKYJEsNGbvNlIXEQ1A+StUOy4puoBthARoLCom3iy9DwybKxvE3x79dSTFtUmC/Kd8pSXoQ==
x-ms-exchange-antispam-messagedata: 84VNjW9ARKv05M8EGzfOtA0TpEZBmiwbds5NFD4Wx1hjnQxxNfs5WVFO2OXOprPV+atfJ8mjtug4jGZpxE1h14OylxN+Qpeuvdwzm+YgnJrLTo9cXtZXh3v5TPK7aBUAA7B4KAcDEbWx1qsCoRFUvg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d84ea5-e205-4e24-1217-08d7d15b53a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 07:57:27.0908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RG14ohzFLBsUI9+7GjaCsFuKfP8mA2iCLCvr5dhKUTh8rT9d569tL5XzyTDTjtfQSPGYzvckVMqRYxQ9/xFPAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group> Sent: Thursday, March 26=
, 2020 2:12 AM
> On some SoCs, such as the i.MX6, it is necessary to set a bit in the SoC =
level
> GPR register before suspending for wake on lan to work.
>=20
> The fec platform callback sleep_mode_enable was intended to allow this bu=
t
> the platform implementation was NAK'd back in 2015 [1]
>=20
> This means that, currently, wake on lan is broken on mainline for the i.M=
X6 at
> least.
>=20
> So implement the required bit setting in the fec driver by itself by addi=
ng a
> new optional DT property indicating the GPR register and adding the offse=
t
> and bit information to the driver.
>=20
> [1]
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.s
> pinics.net%2Flists%2Fnetdev%2Fmsg310922.html&amp;data=3D02%7C01%7Cf
> ugang.duan%40nxp.com%7Ce3cf15de6619429eb23108d7d0e8036a%7C686e
> a1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637207567214747980&am
> p;sdata=3DjfJGqJg7b0u31qfUDr6nxJPeKgp%2FisoTQSOJ607v6KM%3D&amp;rese
> rved=3D0
>=20
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>

The version look much better.

> ---
>  drivers/net/ethernet/freescale/fec.h      |   7 ++
>  drivers/net/ethernet/freescale/fec_main.c | 149
> ++++++++++++++++++++++++------
>  2 files changed, 127 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec.h
> b/drivers/net/ethernet/freescale/fec.h
> index f79e57f..d89568f 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -488,6 +488,12 @@ struct fec_enet_priv_rx_q {
>         struct  sk_buff *rx_skbuff[RX_RING_SIZE];  };
>=20
> +struct fec_stop_mode_gpr {
> +       struct regmap *gpr;
> +       u8 reg;
> +       u8 bit;
> +};
> +
>  /* The FEC buffer descriptors track the ring buffers.  The rx_bd_base an=
d
>   * tx_bd_base always point to the base of the buffer descriptors.  The
>   * cur_rx and cur_tx point to the currently available buffer.
> @@ -562,6 +568,7 @@ struct fec_enet_private {
>         int hwts_tx_en;
>         struct delayed_work time_keep;
>         struct regulator *reg_phy;
> +       struct fec_stop_mode_gpr stop_gpr;
>=20
>         unsigned int tx_align;
>         unsigned int rx_align;
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 23c5fef..69cab0b 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -62,6 +62,8 @@
>  #include <linux/if_vlan.h>
>  #include <linux/pinctrl/consumer.h>
>  #include <linux/prefetch.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
>  #include <soc/imx/cpuidle.h>
>=20
>  #include <asm/cacheflush.h>
> @@ -84,6 +86,56 @@
>  #define FEC_ENET_OPD_V 0xFFF0
>  #define FEC_MDIO_PM_TIMEOUT  100 /* ms */
>=20
> +struct fec_devinfo {
> +       u32 quirks;
> +       u8 stop_gpr_reg;
> +       u8 stop_gpr_bit;
> +};
> +
> +static const struct fec_devinfo fec_imx25_info =3D {
> +       .quirks =3D FEC_QUIRK_USE_GASKET | FEC_QUIRK_MIB_CLEAR |
> +                 FEC_QUIRK_HAS_FRREG,
> +};
> +
> +static const struct fec_devinfo fec_imx27_info =3D {
> +       .quirks =3D FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG, };
> +
> +static const struct fec_devinfo fec_imx28_info =3D {
> +       .quirks =3D FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
> +                 FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
> +                 FEC_QUIRK_HAS_FRREG,
> +};
> +
> +static const struct fec_devinfo fec_imx6q_info =3D {
> +       .quirks =3D FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
> +                 FEC_QUIRK_HAS_BUFDESC_EX |
> FEC_QUIRK_HAS_CSUM |
> +                 FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
> +                 FEC_QUIRK_HAS_RACC,
> +       .stop_gpr_reg =3D 0x34,
> +       .stop_gpr_bit =3D 27,
> +};
> +
> +static const struct fec_devinfo fec_mvf600_info =3D {
> +       .quirks =3D FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC, };
> +
> +static const struct fec_devinfo fec_imx6x_info =3D {
> +       .quirks =3D FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
> +                 FEC_QUIRK_HAS_BUFDESC_EX |
> FEC_QUIRK_HAS_CSUM |
> +                 FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
> +                 FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE
> |
> +                 FEC_QUIRK_HAS_RACC |
> FEC_QUIRK_HAS_COALESCE, };
> +
> +static const struct fec_devinfo fec_imx6ul_info =3D {
> +       .quirks =3D FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
> +                 FEC_QUIRK_HAS_BUFDESC_EX |
> FEC_QUIRK_HAS_CSUM |
> +                 FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
> +                 FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC
> |
> +                 FEC_QUIRK_HAS_COALESCE, };
> +
>  static struct platform_device_id fec_devtype[] =3D {
>         {
>                 /* keep it for coldfire */ @@ -91,39 +143,25 @@
>                 .driver_data =3D 0,
>         }, {
>                 .name =3D "imx25-fec",
> -               .driver_data =3D FEC_QUIRK_USE_GASKET |
> FEC_QUIRK_MIB_CLEAR |
> -                              FEC_QUIRK_HAS_FRREG,
> +               .driver_data =3D (kernel_ulong_t)&fec_imx25_info,
>         }, {
>                 .name =3D "imx27-fec",
> -               .driver_data =3D FEC_QUIRK_MIB_CLEAR |
> FEC_QUIRK_HAS_FRREG,
> +               .driver_data =3D (kernel_ulong_t)&fec_imx27_info,
>         }, {
>                 .name =3D "imx28-fec",
> -               .driver_data =3D FEC_QUIRK_ENET_MAC |
> FEC_QUIRK_SWAP_FRAME |
> -                               FEC_QUIRK_SINGLE_MDIO |
> FEC_QUIRK_HAS_RACC |
> -                               FEC_QUIRK_HAS_FRREG,
> +               .driver_data =3D (kernel_ulong_t)&fec_imx28_info,
>         }, {
>                 .name =3D "imx6q-fec",
> -               .driver_data =3D FEC_QUIRK_ENET_MAC |
> FEC_QUIRK_HAS_GBIT |
> -                               FEC_QUIRK_HAS_BUFDESC_EX |
> FEC_QUIRK_HAS_CSUM |
> -                               FEC_QUIRK_HAS_VLAN |
> FEC_QUIRK_ERR006358 |
> -                               FEC_QUIRK_HAS_RACC,
> +               .driver_data =3D (kernel_ulong_t)&fec_imx6q_info,
>         }, {
>                 .name =3D "mvf600-fec",
> -               .driver_data =3D FEC_QUIRK_ENET_MAC |
> FEC_QUIRK_HAS_RACC,
> +               .driver_data =3D (kernel_ulong_t)&fec_mvf600_info,
>         }, {
>                 .name =3D "imx6sx-fec",
> -               .driver_data =3D FEC_QUIRK_ENET_MAC |
> FEC_QUIRK_HAS_GBIT |
> -                               FEC_QUIRK_HAS_BUFDESC_EX |
> FEC_QUIRK_HAS_CSUM |
> -                               FEC_QUIRK_HAS_VLAN |
> FEC_QUIRK_HAS_AVB |
> -                               FEC_QUIRK_ERR007885 |
> FEC_QUIRK_BUG_CAPTURE |
> -                               FEC_QUIRK_HAS_RACC |
> FEC_QUIRK_HAS_COALESCE,
> +               .driver_data =3D (kernel_ulong_t)&fec_imx6x_info,
>         }, {
>                 .name =3D "imx6ul-fec",
> -               .driver_data =3D FEC_QUIRK_ENET_MAC |
> FEC_QUIRK_HAS_GBIT |
> -                               FEC_QUIRK_HAS_BUFDESC_EX |
> FEC_QUIRK_HAS_CSUM |
> -                               FEC_QUIRK_HAS_VLAN |
> FEC_QUIRK_ERR007885 |
> -                               FEC_QUIRK_BUG_CAPTURE |
> FEC_QUIRK_HAS_RACC |
> -                               FEC_QUIRK_HAS_COALESCE,
> +               .driver_data =3D (kernel_ulong_t)&fec_imx6ul_info,
>         }, {
>                 /* sentinel */
>         }
> @@ -1092,11 +1130,28 @@ static void fec_enet_reset_skb(struct
> net_device *ndev)
>=20
>  }
>=20
> +static void fec_enet_stop_mode(struct fec_enet_private *fep, bool
> +enabled) {
> +       struct fec_platform_data *pdata =3D fep->pdev->dev.platform_data;
> +       struct fec_stop_mode_gpr *stop_gpr =3D &fep->stop_gpr;
> +
> +       if (stop_gpr->gpr) {
> +               if (enabled)
> +                       regmap_update_bits(stop_gpr->gpr,
> stop_gpr->reg,
> +                                          BIT(stop_gpr->bit),
> +                                          BIT(stop_gpr->bit));
> +               else
> +                       regmap_update_bits(stop_gpr->gpr,
> stop_gpr->reg,
> +                                          BIT(stop_gpr->bit), 0);
> +       } else if (pdata && pdata->sleep_mode_enable) {
> +               pdata->sleep_mode_enable(enabled);
> +       }
> +}
> +
>  static void
>  fec_stop(struct net_device *ndev)
>  {
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
> -       struct fec_platform_data *pdata =3D fep->pdev->dev.platform_data;
>         u32 rmii_mode =3D readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
>         u32 val;
>=20
> @@ -1125,9 +1180,7 @@ static void fec_enet_reset_skb(struct net_device
> *ndev)
>                 val =3D readl(fep->hwp + FEC_ECNTRL);
>                 val |=3D (FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
>                 writel(val, fep->hwp + FEC_ECNTRL);
> -
> -               if (pdata && pdata->sleep_mode_enable)
> -                       pdata->sleep_mode_enable(true);
> +               fec_enet_stop_mode(fep, true);
>         }
>         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>=20
> @@ -3397,6 +3450,37 @@ static int fec_enet_get_irq_cnt(struct
> platform_device *pdev)
>         return irq_cnt;
>  }
>=20
> +static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
> +                                  struct fec_devinfo *dev_info,
> +                                  struct device_node *np) {
> +       struct device_node *gpr_np;
> +       int ret;
> +
> +       if (!dev_info)
> +               return 0;
> +
> +       gpr_np =3D of_parse_phandle(np, "gpr", 0);
> +       if (!gpr_np)
> +               return 0;
> +
> +       fep->stop_gpr.gpr =3D syscon_node_to_regmap(gpr_np);
> +       if (IS_ERR(fep->stop_gpr.gpr)) {
> +               dev_err(&fep->pdev->dev, "could not find gpr regmap\n");
> +               ret =3D PTR_ERR(fep->stop_gpr.gpr);
> +               fep->stop_gpr.gpr =3D NULL;
> +               goto out;
> +       }
> +
> +       fep->stop_gpr.reg =3D dev_info->stop_gpr_reg;
> +       fep->stop_gpr.bit =3D dev_info->stop_gpr_bit;
> +
> +out:
> +       of_node_put(gpr_np);
> +
> +       return ret;
> +}
> +
>  static int
>  fec_probe(struct platform_device *pdev)  { @@ -3412,6 +3496,7 @@
> static int fec_enet_get_irq_cnt(struct platform_device *pdev)
>         int num_rx_qs;
>         char irq_name[8];
>         int irq_cnt;
> +       struct fec_devinfo *dev_info;
>=20
>         fec_enet_get_queue_num(pdev, &num_tx_qs, &num_rx_qs);
>=20
> @@ -3429,7 +3514,9 @@ static int fec_enet_get_irq_cnt(struct
> platform_device *pdev)
>         of_id =3D of_match_device(fec_dt_ids, &pdev->dev);
>         if (of_id)
>                 pdev->id_entry =3D of_id->data;
> -       fep->quirks =3D pdev->id_entry->driver_data;
> +       dev_info =3D (struct fec_devinfo *)pdev->id_entry->driver_data;
> +       if (dev_info)
> +               fep->quirks =3D dev_info->quirks;
>=20
>         fep->netdev =3D ndev;
>         fep->num_rx_queues =3D num_rx_qs;
> @@ -3463,6 +3550,10 @@ static int fec_enet_get_irq_cnt(struct
> platform_device *pdev)
>         if (of_get_property(np, "fsl,magic-packet", NULL))
>                 fep->wol_flag |=3D FEC_WOL_HAS_MAGIC_PACKET;
>=20
> +       ret =3D fec_enet_init_stop_mode(fep, dev_info, np);
> +       if (ret)
> +               goto failed_stop_mode;
> +
>         phy_node =3D of_parse_phandle(np, "phy-handle", 0);
>         if (!phy_node && of_phy_is_fixed_link(np)) {
>                 ret =3D of_phy_register_fixed_link(np); @@ -3631,6
> +3722,7 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
>         if (of_phy_is_fixed_link(np))
>                 of_phy_deregister_fixed_link(np);
>         of_node_put(phy_node);
> +failed_stop_mode:
>  failed_phy:
>         dev_id--;
>  failed_ioremap:
> @@ -3708,7 +3800,6 @@ static int __maybe_unused fec_resume(struct
> device *dev)  {
>         struct net_device *ndev =3D dev_get_drvdata(dev);
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
> -       struct fec_platform_data *pdata =3D fep->pdev->dev.platform_data;
>         int ret;
>         int val;
>=20
> @@ -3726,8 +3817,8 @@ static int __maybe_unused fec_resume(struct
> device *dev)
>                         goto failed_clk;
>                 }
>                 if (fep->wol_flag & FEC_WOL_FLAG_ENABLE) {
> -                       if (pdata && pdata->sleep_mode_enable)
> -                               pdata->sleep_mode_enable(false);
> +                       fec_enet_stop_mode(fep, false);
> +
>                         val =3D readl(fep->hwp + FEC_ECNTRL);
>                         val &=3D ~(FEC_ECR_MAGICEN |
> FEC_ECR_SLEEP);
>                         writel(val, fep->hwp + FEC_ECNTRL);
> --
> 1.9.1


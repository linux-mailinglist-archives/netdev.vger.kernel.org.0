Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6B11A7178
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 05:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404426AbgDNDHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 23:07:16 -0400
Received: from mail-vi1eur05on2086.outbound.protection.outlook.com ([40.107.21.86]:44417
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404405AbgDNDHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 23:07:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atrwX7R0MfMpAcG05mBfcx4c/rDWcAJ6lqyyVR0xbd6KciBwSk3ThKiwEd7umQXEdhAl7zMTXtJ3WvHKblcgSqh8o1D9x1ZL/9Tvz8JMZ8nehiRU34xX9qDyp3KPPMjMeUDOw3bzk0hMaYkdKJWk/LGYzWgE2Yc9N+fm+y+nDEiHIrr5GRXwmYG89kDTd/NSOSPFCn968/PXQwxuzDP1EZjV1waJpwcM6PGDbiirIEN6yMmrkXmygoOzmiQeOLqHkJn3uA7IOfLAYLhl2Ts3pfsBa7KNAyHIm9fcI9agBdz1eFG2Crd/CnTtc6lV7AgPtc/oMFOtLwQdVAaJv17XOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9Q9DUfXsM9jhLdgpDdVSYvd6NbK4JQnud72hXp3iOA=;
 b=aveaWFeCO8ikO000cTR+LWge15WVLA59plAb0pGGoiudnlL5ggbaTgtXHhBysP7yF8OZv9/jiVzGz94EuynrQPwdxTXQcEWL5tZlEqcjXtF9YAueAT0ATJPtl/+TnLj6q+DVtouOceO6DijvcMcLegr1sPw7Nr4mTq6MQEL3Fw5GjMEWO7I7Q7GqNJ2trIX1ONvnlNco6uQkkiIYwV2dleH3onSeUO72a4b9uPb1duHqSjdRr/dLAHEDto/1THJ/KllG/8SZvL6QyePgDR7U16dsgiacEzq/dXFElgnW09e80BDYkaIaE1DMcpPCi18FFGAzHjxncAS8VAjX4m5okg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9Q9DUfXsM9jhLdgpDdVSYvd6NbK4JQnud72hXp3iOA=;
 b=L98a49XEmjfgJWOPM6zUWQ83NLhFSVpQIc+Un4eA10lL5habDS6KboEPtvhV1KP8Z6bMJtHwVy3vePSIM6vmPCQpM9qo8hzb1A4gVik2F10pYnfoM+a9NFUV8lgJ3GwT2yHrcQ2Vhkm5Q+ckrB2XOHQzzPIPZNE7zQg+w8wTck8=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (2603:10a6:803:7::18)
 by VI1PR0402MB3470.eurprd04.prod.outlook.com (2603:10a6:803:10::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Tue, 14 Apr
 2020 03:07:10 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::d411:cfdb:bf:2b14]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::d411:cfdb:bf:2b14%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 03:07:09 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        Chris Heally <cphealy@gmail.com>
Subject: RE: [EXT] [PATCH] net: ethernet: fec: Replace interrupt driven MDIO
 with polled IO
Thread-Topic: [EXT] [PATCH] net: ethernet: fec: Replace interrupt driven MDIO
 with polled IO
Thread-Index: AQHWEfYVWKKbuFIKoUCCrpamVzdoDKh37gfg
Date:   Tue, 14 Apr 2020 03:07:09 +0000
Message-ID: <VI1PR0402MB3600B82EE105E43BD20E2190FFDA0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20200414004551.607503-1-andrew@lunn.ch>
In-Reply-To: <20200414004551.607503-1-andrew@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [101.86.1.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9dc76493-cc0a-4264-5a63-08d7e020ebd0
x-ms-traffictypediagnostic: VI1PR0402MB3470:|VI1PR0402MB3470:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR0402MB3470BF917A606EF469933A59FFDA0@VI1PR0402MB3470.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(66476007)(55016002)(86362001)(478600001)(26005)(66946007)(7696005)(66446008)(66556008)(76116006)(64756008)(9686003)(33656002)(2906002)(8936002)(5660300002)(6506007)(81156014)(110136005)(54906003)(316002)(71200400001)(4326008)(52536014)(186003)(8676002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3phu3Ibx9cj9GF1gTnd1coKliqI5H3dXAHlDk9JJn6S4MP63s75RnfLM3qsdD8hoTJ+c5RiUmW8lLCc/8VsW82P0hpYWrs88S6THQog5C5lAuE2vCTNJEwqxLR8whfElCwZMggkvKbDr9r5MUCf+0HWAaMQhcRURs3Mrdvo+uDPxn+AkJB93qtlQC+KTxbpDIIq4m4sObdOtbqgF/kWI5CqBtgzSxIgv68y807rgAKdS0DXqCxi17tbDgbU3D0XLzVKX5NagKOZVp3dMLX4IWF/YIFoco1w3k5t0tez8CQmE9z092H4Rj1P+Kl6OPnrX1qGfxRA7ChH2+TDFoaC6L9c/zxu+br8JLFhjNpRUbwSwOY/3N16hZMoLrotyLnCLdnA1Fi/wTLksaipEzNHyFikAIG58feuBp03YFIfF6KLHN+NaXxRDZK/v30sfYaJx
x-ms-exchange-antispam-messagedata: K7J+jKfYNnZ1Uckvp+/DT2C9A/hi8oaVcqITjDNFVc1ZUyzjPDvoTGFAImoXPNhJZy8qWRbdN8HBx5tklv9RaXbOv1V6FLUmdjsluhQHfIRl48hT/U3waH92Cz9M56hCBESEZB3MB71SfUPp4lg4PA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc76493-cc0a-4264-5a63-08d7e020ebd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 03:07:09.4780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GKh9D2/VL4V2FAwL4zYqz8opkwsVRNcsTqZh8q4DjaHk/udb9M2IfvDxj1BIUew1gRpiJ0Pob1iuN4bgkU1ltw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3470
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Tuesday, April 14, 2020 8:46 AM
> Measurements of the MDIO bus have shown that driving the MDIO bus using
> interrupts is slow. Back to back MDIO transactions take about 90uS, with
> 25uS spent performing the transaction, and the remainder of the time the =
bus
> is idle.
>=20
> Replacing the completion interrupt with polled IO results in back to back
> transactions of 40uS. The polling loop waiting for the hardware to comple=
te
> the transaction takes around 27uS. Which suggests interrupt handling has =
an
> overhead of 50uS, and polled IO nearly halves this overhead, and doubles =
the
> MDIO performance.
>=20

Although the mdio performance is better, but polling IO by reading register
cause system/bus loading more heavy.

So I don't think it is valuable to change interrupt mode to polling mode.

Thanks,
Andy
> Suggested-by: Chris Heally <cphealy@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/freescale/fec.h      |  4 +-
>  drivers/net/ethernet/freescale/fec_main.c | 69 ++++++++++++-----------
>  2 files changed, 37 insertions(+), 36 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec.h
> b/drivers/net/ethernet/freescale/fec.h
> index bd898f5b4da5..4c8e7f57957a 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -376,8 +376,7 @@ struct bufdesc_ex {
>  #define FEC_ENET_TS_AVAIL       ((uint)0x00010000)
>  #define FEC_ENET_TS_TIMER       ((uint)0x00008000)
>=20
> -#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF |
> FEC_ENET_MII) -#define FEC_NAPI_IMASK FEC_ENET_MII
> +#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF)
>  #define FEC_RX_DISABLED_IMASK (FEC_DEFAULT_IMASK &
> (~FEC_ENET_RXF))
>=20
>  /* ENET interrupt coalescing macro define */ @@ -537,7 +536,6 @@ struct
> fec_enet_private {
>         int     link;
>         int     full_duplex;
>         int     speed;
> -       struct  completion mdio_done;
>         int     irq[FEC_IRQ_NUM];
>         bool    bufdesc_ex;
>         int     pause_flag;
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index c1c267b61647..48ac0a3a4eb0 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -938,8 +938,8 @@ fec_restart(struct net_device *ndev)
>         writel((__force u32)cpu_to_be32(temp_mac[1]),
>                fep->hwp + FEC_ADDR_HIGH);
>=20
> -       /* Clear any outstanding interrupt. */
> -       writel(0xffffffff, fep->hwp + FEC_IEVENT);
> +       /* Clear any outstanding interrupt, except MDIO. */
> +       writel((0xffffffff & ~FEC_ENET_MII), fep->hwp + FEC_IEVENT);
>=20
>         fec_enet_bd_init(ndev);
>=20
> @@ -1085,7 +1085,7 @@ fec_restart(struct net_device *ndev)
>         if (fep->link)
>                 writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
>         else
> -               writel(FEC_ENET_MII, fep->hwp + FEC_IMASK);
> +               writel(0, fep->hwp + FEC_IMASK);
>=20
>         /* Init the interrupt coalescing */
>         fec_enet_itr_coal_init(ndev);
> @@ -1599,6 +1599,10 @@ fec_enet_interrupt(int irq, void *dev_id)
>         irqreturn_t ret =3D IRQ_NONE;
>=20
>         int_events =3D readl(fep->hwp + FEC_IEVENT);
> +
> +       /* Don't clear MDIO events, we poll for those */
> +       int_events &=3D ~FEC_ENET_MII;
> +
>         writel(int_events, fep->hwp + FEC_IEVENT);
>         fec_enet_collect_events(fep, int_events);
>=20
> @@ -1606,16 +1610,12 @@ fec_enet_interrupt(int irq, void *dev_id)
>                 ret =3D IRQ_HANDLED;
>=20
>                 if (napi_schedule_prep(&fep->napi)) {
> -                       /* Disable the NAPI interrupts */
> -                       writel(FEC_NAPI_IMASK, fep->hwp +
> FEC_IMASK);
> +                       /* Disable interrupts */
> +                       writel(0, fep->hwp + FEC_IMASK);
>                         __napi_schedule(&fep->napi);
>                 }
>         }
>=20
> -       if (int_events & FEC_ENET_MII) {
> -               ret =3D IRQ_HANDLED;
> -               complete(&fep->mdio_done);
> -       }
>         return ret;
>  }
>=20
> @@ -1765,11 +1765,26 @@ static void fec_enet_adjust_link(struct
> net_device *ndev)
>                 phy_print_status(phy_dev);  }
>=20
> +static int fec_enet_mdio_wait(struct fec_enet_private *fep) {
> +       int retries =3D 10000;
> +       uint ievent;
> +
> +       while (retries--) {
> +               ievent =3D readl(fep->hwp + FEC_IEVENT);
> +               if (ievent & FEC_ENET_MII) {
> +                       writel(FEC_ENET_MII, fep->hwp +
> FEC_IEVENT);
> +                       return 0;
> +               }
> +       }
> +
> +       return -ETIMEDOUT;
> +}
> +
>  static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnu=
m)  {
>         struct fec_enet_private *fep =3D bus->priv;
>         struct device *dev =3D &fep->pdev->dev;
> -       unsigned long time_left;
>         int ret =3D 0, frame_start, frame_addr, frame_op;
>         bool is_c45 =3D !!(regnum & MII_ADDR_C45);
>=20
> @@ -1777,8 +1792,6 @@ static int fec_enet_mdio_read(struct mii_bus *bus,
> int mii_id, int regnum)
>         if (ret < 0)
>                 return ret;
>=20
> -       reinit_completion(&fep->mdio_done);
> -
>         if (is_c45) {
>                 frame_start =3D FEC_MMFR_ST_C45;
>=20
> @@ -1790,11 +1803,9 @@ static int fec_enet_mdio_read(struct mii_bus
> *bus, int mii_id, int regnum)
>                        fep->hwp + FEC_MII_DATA);
>=20
>                 /* wait for end of transfer */
> -               time_left =3D
> wait_for_completion_timeout(&fep->mdio_done,
> -                               usecs_to_jiffies(FEC_MII_TIMEOUT));
> -               if (time_left =3D=3D 0) {
> +               ret =3D fec_enet_mdio_wait(fep);
> +               if (ret) {
>                         netdev_err(fep->netdev, "MDIO address write
> timeout\n");
> -                       ret =3D -ETIMEDOUT;
>                         goto out;
>                 }
>=20
> @@ -1813,11 +1824,9 @@ static int fec_enet_mdio_read(struct mii_bus
> *bus, int mii_id, int regnum)
>                 FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
>=20
>         /* wait for end of transfer */
> -       time_left =3D wait_for_completion_timeout(&fep->mdio_done,
> -                       usecs_to_jiffies(FEC_MII_TIMEOUT));
> -       if (time_left =3D=3D 0) {
> +       ret =3D fec_enet_mdio_wait(fep);
> +       if (ret) {
>                 netdev_err(fep->netdev, "MDIO read timeout\n");
> -               ret =3D -ETIMEDOUT;
>                 goto out;
>         }
>=20
> @@ -1835,7 +1844,6 @@ static int fec_enet_mdio_write(struct mii_bus *bus,
> int mii_id, int regnum,  {
>         struct fec_enet_private *fep =3D bus->priv;
>         struct device *dev =3D &fep->pdev->dev;
> -       unsigned long time_left;
>         int ret, frame_start, frame_addr;
>         bool is_c45 =3D !!(regnum & MII_ADDR_C45);
>=20
> @@ -1845,8 +1853,6 @@ static int fec_enet_mdio_write(struct mii_bus *bus,
> int mii_id, int regnum,
>         else
>                 ret =3D 0;
>=20
> -       reinit_completion(&fep->mdio_done);
> -
>         if (is_c45) {
>                 frame_start =3D FEC_MMFR_ST_C45;
>=20
> @@ -1858,11 +1864,9 @@ static int fec_enet_mdio_write(struct mii_bus
> *bus, int mii_id, int regnum,
>                        fep->hwp + FEC_MII_DATA);
>=20
>                 /* wait for end of transfer */
> -               time_left =3D
> wait_for_completion_timeout(&fep->mdio_done,
> -                       usecs_to_jiffies(FEC_MII_TIMEOUT));
> -               if (time_left =3D=3D 0) {
> +               ret =3D fec_enet_mdio_wait(fep);
> +               if (ret) {
>                         netdev_err(fep->netdev, "MDIO address write
> timeout\n");
> -                       ret =3D -ETIMEDOUT;
>                         goto out;
>                 }
>         } else {
> @@ -1878,12 +1882,9 @@ static int fec_enet_mdio_write(struct mii_bus
> *bus, int mii_id, int regnum,
>                 fep->hwp + FEC_MII_DATA);
>=20
>         /* wait for end of transfer */
> -       time_left =3D wait_for_completion_timeout(&fep->mdio_done,
> -                       usecs_to_jiffies(FEC_MII_TIMEOUT));
> -       if (time_left =3D=3D 0) {
> +       ret =3D fec_enet_mdio_wait(fep);
> +       if (ret)
>                 netdev_err(fep->netdev, "MDIO write timeout\n");
> -               ret  =3D -ETIMEDOUT;
> -       }
>=20
>  out:
>         pm_runtime_mark_last_busy(dev);
> @@ -2079,6 +2080,9 @@ static int fec_enet_mii_init(struct platform_device
> *pdev)
>=20
>         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>=20
> +       /* Clear any pending transaction complete indication */
> +       writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
> +
>         fep->mii_bus =3D mdiobus_alloc();
>         if (fep->mii_bus =3D=3D NULL) {
>                 err =3D -ENOMEM;
> @@ -3583,7 +3587,6 @@ fec_probe(struct platform_device *pdev)
>                 fep->irq[i] =3D irq;
>         }
>=20
> -       init_completion(&fep->mdio_done);
>         ret =3D fec_enet_mii_init(pdev);
>         if (ret)
>                 goto failed_mii_init;
> --
> 2.26.0


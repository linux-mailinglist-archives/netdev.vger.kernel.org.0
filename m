Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FAE1AEDB9
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 15:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgDRNzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 09:55:33 -0400
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:41499
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbgDRNzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 09:55:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEkjrq1U1uNRG7ScbGDCHOaP/tTe90Rd++w145kFLdzE3s1qi9eaMgVKVop9P9IY8ZIX7H3gHjQpCf7A1jeW0wrwKlwUVZ8uOduCJwSHlWzsP4qlhfMHqWPGWb5LhnuLLcKKzwW25ANGb2HkVE4P7HwIxJnkRfewDyb8lzeDA0ufPZUuDsyQ6kNUqLmEPNqUIM/giVKlp6ovwSBietHaBCTaEWgYkuS17tK33HNdx3uYnTC3ZOJKcz31xDmz/OG2T6ZT/MeR4dwWyCI/x7H2XI012cDQNRSjsJziLfccfOQoF63K6H5IFaL2WEbPYlavbGwdYs7fCRkv4Tlznnw3Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9i/qg74mVDK6SX9Hi7M5dscs4b7F+/epUz5gCK8HsB0=;
 b=nGMyjnVZdMEsmDe3TYRnHcw+3qJcjPFcIU56gphv3yxA9wDwOaKspHY8lm8tKEQwoMGomy0JXKAtXVD5293ka670+3ezVzc3fUJ/yR/3KSSqJI4l5uTIHEKZF50JHvvdZXL9XqIqRLBH6CUqxhwR3e5ten31S/1KHUAU7b0VRi7kgepvQdIZOTndC6QaGNqLNqhJaD3dGDWXUq2jJTu8XoYpftYkrRddZD1skde+2FxN1OQkeJe9rCkVjpuwuDvMi4ZiN8BjBCnHlnoE++kd6WOHjIkKZjpiocwJhzoChKoFhDObyDj4T1DtxwagNDUd2AOFVhydZGYb8LqIvXZ5pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9i/qg74mVDK6SX9Hi7M5dscs4b7F+/epUz5gCK8HsB0=;
 b=A9NJHkqkMpxCqzta+a4cWHZihYCqkdcGAVsaXOyYyYI1NZQUwBtIZJgn2XXq7sEEDHuYyJHsyBYAZTuya/N4VNYNK4RMpO1fPfaQriFgAuaKsvD+Lpmja0Vzuk6nxRByYrv0S2x18pmbhIxwNioWHLGOdQZ8x+2WBNsrbKNCsnk=
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB3353.eurprd04.prod.outlook.com (2603:10a6:7:88::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26; Sat, 18 Apr
 2020 13:55:26 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::f9f4:42f7:8353:96ad]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::f9f4:42f7:8353:96ad%3]) with mapi id 15.20.2900.030; Sat, 18 Apr 2020
 13:55:26 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Heally <cphealy@gmail.com>
Subject: RE: [EXT] [PATCH net-next v2 1/3] net: ethernet: fec: Replace
 interrupt driven MDIO with polled IO
Thread-Topic: [EXT] [PATCH net-next v2 1/3] net: ethernet: fec: Replace
 interrupt driven MDIO with polled IO
Thread-Index: AQHWFRTlsErE76O07kq9ckJaSa4Q1qh+5wKg
Date:   Sat, 18 Apr 2020 13:55:26 +0000
Message-ID: <HE1PR0402MB27450B207DFFB1B86DCF287DFFD60@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-2-andrew@lunn.ch>
In-Reply-To: <20200418000355.804617-2-andrew@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [101.86.0.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0d95cb9f-702e-4d4a-6c17-08d7e3a025d8
x-ms-traffictypediagnostic: HE1PR0402MB3353:
x-microsoft-antispam-prvs: <HE1PR0402MB3353CDE65AB810BD5AA54AC1FFD60@HE1PR0402MB3353.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 0377802854
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(55016002)(316002)(86362001)(110136005)(9686003)(54906003)(5660300002)(2906002)(7696005)(66476007)(186003)(76116006)(66556008)(66946007)(66446008)(64756008)(4326008)(478600001)(6506007)(8676002)(33656002)(8936002)(81156014)(71200400001)(52536014)(26005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MC72YN8wwnXnd3Wyc48qNaCe0bW9aAKSd10BRLMepUEtECQ1jM+dflKXhF9uVa5kbMcfgS4SrsLExIzFLC9Cdfmd5ZJmS/oZBpEHEf88xqGjRMaRI6RWw4kmeu7kgVZ/FBN9L5Mg1+I11UNMGLQD7EDSX6lU5xcNLCzspYTIFr4HJNl0Eb4DTz+eu1dYuZ90JUqYv6SAieSb2U12he0dAQvgsG/FKqSR0P7HX0Xo08gTdQ7C6fqrbPs+kYrMrFPeqXfWyU+teDBaneVwTDOf4O3rx1Li+dCRdjlDHnvM6LBoYnyalIR8RviMOWvQNyZsNTT/PtXxkxZW/lhNPyD4/I1KV3pBkjOE3ra1P29x865HnhZr4pZ0HYkOLeqlSDKbZZaLruG+M2K4hRmydKTAmDq09S4rTuKd/lUyjpSjOrRSmMv5+dCc2Vn1BU3+oxgH
x-ms-exchange-antispam-messagedata: Y+rkYQGlsZQkfjeMqIX952ji8zDALGkq+NTe3cq78ghAMat8lYySk2d50uwRzFAAqe1xnFNF59QRfxGJ4FN2ZHVARq3x7ZTe1xfQNPGpnMBdTQ1Iu3FX+o6i0IZWRY0vHqO1ovEcPjHiw7KjqBpYyA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d95cb9f-702e-4d4a-6c17-08d7e3a025d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2020 13:55:26.4078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0XHhI/xKoTd1uXdTK1dl8GkwpOS4r/R6ljv1xHe8xuI4iX6L0o8/FGwj2SgyBGSCz9X57lfonWXgft/EFB7t5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3353
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Saturday, April 18, 2020 8:04 AM
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
> Suggested-by: Chris Heally <cphealy@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/freescale/fec.h      |  4 +-
>  drivers/net/ethernet/freescale/fec_main.c | 67 ++++++++++++-----------
>  2 files changed, 35 insertions(+), 36 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec.h
> b/drivers/net/ethernet/freescale/fec.h
> index e74dd1f86bba..a6cdd5b61921 100644
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
>  /* ENET interrupt coalescing macro define */ @@ -543,7 +542,6 @@ struct
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
> index dc6f8763a5d4..6530829632b1 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -976,8 +976,8 @@ fec_restart(struct net_device *ndev)
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
> @@ -1123,7 +1123,7 @@ fec_restart(struct net_device *ndev)
>         if (fep->link)
>                 writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
>         else
> -               writel(FEC_ENET_MII, fep->hwp + FEC_IMASK);
> +               writel(0, fep->hwp + FEC_IMASK);
>=20
>         /* Init the interrupt coalescing */
>         fec_enet_itr_coal_init(ndev);
> @@ -1652,6 +1652,10 @@ fec_enet_interrupt(int irq, void *dev_id)
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
> @@ -1659,16 +1663,12 @@ fec_enet_interrupt(int irq, void *dev_id)
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
> @@ -1818,11 +1818,24 @@ static void fec_enet_adjust_link(struct
> net_device *ndev)
>                 phy_print_status(phy_dev);  }
>=20
> +static int fec_enet_mdio_wait(struct fec_enet_private *fep) {
> +       uint ievent;
> +       int ret;
> +
> +       ret =3D readl_poll_timeout(fep->hwp + FEC_IEVENT, ievent,
> +                                ievent & FEC_ENET_MII, 0, 30000);

sleep X us between reads ?

> +
> +       if (!ret)
> +               writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
> +
> +       return ret;
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
> @@ -1830,8 +1843,6 @@ static int fec_enet_mdio_read(struct mii_bus *bus,
> int mii_id, int regnum)
>         if (ret < 0)
>                 return ret;
>=20
> -       reinit_completion(&fep->mdio_done);
> -
>         if (is_c45) {
>                 frame_start =3D FEC_MMFR_ST_C45;
>=20
> @@ -1843,11 +1854,9 @@ static int fec_enet_mdio_read(struct mii_bus
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
> @@ -1866,11 +1875,9 @@ static int fec_enet_mdio_read(struct mii_bus
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
> @@ -1888,7 +1895,6 @@ static int fec_enet_mdio_write(struct mii_bus *bus,
> int mii_id, int regnum,  {
>         struct fec_enet_private *fep =3D bus->priv;
>         struct device *dev =3D &fep->pdev->dev;
> -       unsigned long time_left;
>         int ret, frame_start, frame_addr;
>         bool is_c45 =3D !!(regnum & MII_ADDR_C45);
>=20
> @@ -1898,8 +1904,6 @@ static int fec_enet_mdio_write(struct mii_bus *bus,
> int mii_id, int regnum,
>         else
>                 ret =3D 0;
>=20
> -       reinit_completion(&fep->mdio_done);
> -
>         if (is_c45) {
>                 frame_start =3D FEC_MMFR_ST_C45;
>=20
> @@ -1911,11 +1915,9 @@ static int fec_enet_mdio_write(struct mii_bus
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
> @@ -1931,12 +1933,9 @@ static int fec_enet_mdio_write(struct mii_bus
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
> @@ -2132,6 +2131,9 @@ static int fec_enet_mii_init(struct platform_device
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
> @@ -3674,7 +3676,6 @@ fec_probe(struct platform_device *pdev)
>                 fep->irq[i] =3D irq;
>         }
>=20
> -       init_completion(&fep->mdio_done);
>         ret =3D fec_enet_mii_init(pdev);
>         if (ret)
>                 goto failed_mii_init;
> --
> 2.26.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AF829E065
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgJ1WE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:04:56 -0400
Received: from mail-am6eur05on2070.outbound.protection.outlook.com ([40.107.22.70]:56993
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728749AbgJ1WB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:01:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oM00jVuHuUimqVP7tlaN0rjzrb5rtc+N3rWoOyGw9bPAtHCyiToVQaI71jlm3Uh1zXkRhSLKUb+TLgi2h79lwqT8P6MyRWtEHrVgi1l97NFqULFx6FjqSKdZKOwL6P2ebpXM1hwvPSB8zoMh1Z7Se28Qnk8hr3oEygguMe1rmcUfTSrzc1DKlC88Y6dD/olUldWYV/16Og//36Z9AT0oQW4aLAZrrPVnSNhmmKmVoyZaqewj0XV2UhBLZj8GiM3pK1xdzGRhhpKT4k189VewwO8XLPvhbr3Zg+oUt5UuCd01D9Z4opUGa5CBiVEvvy86411bqcttRGOAK8vgQauTog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVIjx02oZASJc0uSOHzeUXG0uWjRH/nmqhPghT1CbY0=;
 b=SYIHpu5cFGTvirXcQnbdLuBbq9blW4guVhlEvnzvCqSUTHkTjGbWxINYyXL1+EipxOcje6qfcludeezW5qITne1DFHGqlew2PpZRYvjfy+yoA01zgiixZfRCCfQr4olU9GL+riqD9QJydeSUR7ZiSFN8nxAu7rqTKdzQLzomUS1czkfW+vdfsfKsnl2s3dT9r7kTIQl769gfVCZ0lidilKU9W+cNH4oYDlYz0gTkWA8Ys1pS7gqLcmjTS+16+kzCQOJUvxgnLdGWQirXlp/Sf5F3HyuChaoQJ/2LvodP9ldAIk7LVcZxAJeSdYM8tlCyPTVqc3070s/80R7F6x1mdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVIjx02oZASJc0uSOHzeUXG0uWjRH/nmqhPghT1CbY0=;
 b=U9j+7so9QJjtbM+T7mxTt+hAay8w0cKvDtoBfDzwnWJlrHqffzi1uuffGjKvqm+IVlxbXsrsy8KrV8WZVfj5ZyWyr0FD0VpwOnVUxTzviXFLmxCBiMq+xERM4w+GQhCJ43VxOySIm3OWnXODm2A7Eb3Sk0rqTxIsw2d2VPw23uU=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM4PR0401MB2228.eurprd04.prod.outlook.com (2603:10a6:200:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Wed, 28 Oct
 2020 05:28:23 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271%6]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 05:28:23 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Greg Ungerer <gerg@linux-m68k.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        "dkarr@vyex.com" <dkarr@vyex.com>,
        "clemens.gruber@pqgruber.com" <clemens.gruber@pqgruber.com>
Subject: RE: [EXT] [PATCH v2] net: fec: fix MDIO probing for some FEC hardware
 blocks
Thread-Topic: [EXT] [PATCH v2] net: fec: fix MDIO probing for some FEC
 hardware blocks
Thread-Index: AQHWrOpeCCq9w3UZDUi2T1Oo+DZi56msfECg
Date:   Wed, 28 Oct 2020 05:28:23 +0000
Message-ID: <AM8PR04MB7315D4E076D0A74EF3026C26FF170@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <20201028052232.1315167-1-gerg@linux-m68k.org>
In-Reply-To: <20201028052232.1315167-1-gerg@linux-m68k.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e30fd114-bb9c-405c-0d8b-08d87b0249d8
x-ms-traffictypediagnostic: AM4PR0401MB2228:
x-microsoft-antispam-prvs: <AM4PR0401MB22286BC0AEAF3E97F9768FBFFF170@AM4PR0401MB2228.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qFiECNpEtoffhTaIBQlSLHTRySOAWcIXk9mjeb+C8KRDTtHlhBdhkx4guFy6wYrsMbNxVAbExwgjO2L7+o8utX1lSgOFkxRxXRtrtRzPtgSpflk9QQ/i8zLsbRiLGa0mhmzxpanRLWmC5VKT6F+QUdrbRfv/Ztt6SNaP6nmtoTy/MrPXpoBImOiyR6t9Vg3HF3vPi10Eit6TirYNy78U+vuEDKLQf5S4h26mPiq0NH8oIEDarFRjqbgQC3cgbkd5FEOom8LE9sH3TftkQdbT/5z0huYaQ5TeAy37P18SG5h3+tTSeW7O/qKZmXoYTkHtubNEt2dDUM75RQYTgmR2Og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(9686003)(26005)(83380400001)(4326008)(8936002)(316002)(52536014)(8676002)(186003)(6506007)(66556008)(7696005)(5660300002)(76116006)(64756008)(110136005)(478600001)(66476007)(66446008)(66946007)(33656002)(55016002)(86362001)(71200400001)(54906003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: IWTxafNbEmn07w3YyiPfAV9CWfa2WZdwNeInc/4IHn9mOgsbJ3HikWe756Z36VOAt6xBo85QC2Vkx+gpdNsuj5Tz+ZgLsBcfYKuVwZV6fsRuPTvJkLZwWmR3zwfwpaw1y65/nvCIQVOMPecNPX+a5bp+35srhyutt44UqRPsnnSbRKeu1oI8tC7bdLUtIfnSVgb3NlnNMWm8fyZxnhkY9WEBAj3ElpVcbLfHukiv8G5nru4VimyJpfnviCgfp+jHmDg7UbQDSCYd/G1YIjJtbUva8r2VgLbcyBVG2CKhedao4TCCFl2wIKm3xgtRhdpTL53yNhY8Fhp6LM+iJdonCSbsOJxBabvo6I3Pq7afnSQfc++cmWzJyvP+uX+KiBEt5N5A8LhIIQZjM9SAI9I3j73ySbDfkNiYdyDUf8ekdvSgHOkrY7V8KtFR5t/B9yLWfkuXhJ+0DoyLjOzxhuy0hhUZw62NdseJnBD8qL63eiRmv66RexQEZJ6buivmfYlq9JUQ4dfVG9BsWkFtHDmcUMMCEEYFynb1KjRtD5w8ff50/QgydoeoLIdiGrS50Qe8C9shca9I2vUDBP0/kB4nbiRRqn3cjPnLPO1XkA7iMnzlXeB8ETsNUQJfIg/dTekANY3+BOoFFKUNTsf9FUvpKQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e30fd114-bb9c-405c-0d8b-08d87b0249d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2020 05:28:23.1255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QUAjWFnJ1zdu4Pe6VrOfQ6OrL7udwfPiQWIDUe3hkPIuGwhu/rR3VDzS6Ix0AeqhTOzUAfbu25POmdyEXhizrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2228
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Ungerer <gerg@linux-m68k.org> Sent: Wednesday, October 28, 2020 =
1:23 PM
> Some (apparently older) versions of the FEC hardware block do not like th=
e
> MMFR register being cleared to avoid generation of MII events at initiali=
zation
> time. The action of clearing this register results in no future MII event=
s being
> generated at all on the problem block. This means the probing of the MDIO=
 bus
> will find no PHYs.
>=20
> Create a quirk that can be checked at the FECs MII init time so that the =
right
> thing is done. The quirk is set as appropriate for the FEC hardware block=
s that
> are known to need this.
>=20
> Fixes: f166f890c8f0 ("net: ethernet: fec: Replace interrupt driven MDIO w=
ith
> polled IO")
> Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Thanks!

Acked-by: Fugang Duan <fugand.duan@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec.h      |  6 +++++
>  drivers/net/ethernet/freescale/fec_main.c | 29 +++++++++++++----------
>  2 files changed, 22 insertions(+), 13 deletions(-)
>=20
> v2: use quirk for imx28 as well
>=20
> Resending for consideration based on Andy's last comment that this fix is=
 enough
> on its own for all hardware types.
>=20
> diff --git a/drivers/net/ethernet/freescale/fec.h
> b/drivers/net/ethernet/freescale/fec.h
> index 832a2175636d..c527f4ee1d3a 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -456,6 +456,12 @@ struct bufdesc_ex {
>   */
>  #define FEC_QUIRK_HAS_FRREG            (1 << 16)
>=20
> +/* Some FEC hardware blocks need the MMFR cleared at setup time to
> +avoid
> + * the generation of an MII event. This must be avoided in the older
> + * FEC blocks where it will stop MII events being generated.
> + */
> +#define FEC_QUIRK_CLEAR_SETUP_MII      (1 << 17)
> +
>  struct bufdesc_prop {
>         int qid;
>         /* Address of Rx and Tx buffers */ diff --git
> a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index fb37816a74db..65784d3e54a5 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -100,14 +100,14 @@ static const struct fec_devinfo fec_imx27_info =3D
> {  static const struct fec_devinfo fec_imx28_info =3D {
>         .quirks =3D FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
>                   FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
> -                 FEC_QUIRK_HAS_FRREG,
> +                 FEC_QUIRK_HAS_FRREG |
> FEC_QUIRK_CLEAR_SETUP_MII,
>  };
>=20
>  static const struct fec_devinfo fec_imx6q_info =3D {
>         .quirks =3D FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
>                   FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM
> |
>                   FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
> -                 FEC_QUIRK_HAS_RACC,
> +                 FEC_QUIRK_HAS_RACC | FEC_QUIRK_CLEAR_SETUP_MII,
>  };
>=20
>  static const struct fec_devinfo fec_mvf600_info =3D { @@ -119,7 +119,8 @=
@
> static const struct fec_devinfo fec_imx6x_info =3D {
>                   FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM
> |
>                   FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
>                   FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
> -                 FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE,
> +                 FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
> +                 FEC_QUIRK_CLEAR_SETUP_MII,
>  };
>=20
>  static const struct fec_devinfo fec_imx6ul_info =3D { @@ -127,7 +128,7 @=
@
> static const struct fec_devinfo fec_imx6ul_info =3D {
>                   FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM
> |
>                   FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
>                   FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
> -                 FEC_QUIRK_HAS_COALESCE,
> +                 FEC_QUIRK_HAS_COALESCE |
> FEC_QUIRK_CLEAR_SETUP_MII,
>  };
>=20
>  static struct platform_device_id fec_devtype[] =3D { @@ -2114,15 +2115,1=
7 @@
> static int fec_enet_mii_init(struct platform_device *pdev)
>         if (suppress_preamble)
>                 fep->phy_speed |=3D BIT(7);
>=20
> -       /* Clear MMFR to avoid to generate MII event by writing MSCR.
> -        * MII event generation condition:
> -        * - writing MSCR:
> -        *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> -        *        mscr_reg_data_in[7:0] !=3D 0
> -        * - writing MMFR:
> -        *      - mscr[7:0]_not_zero
> -        */
> -       writel(0, fep->hwp + FEC_MII_DATA);
> +       if (fep->quirks & FEC_QUIRK_CLEAR_SETUP_MII) {
> +               /* Clear MMFR to avoid to generate MII event by writing
> MSCR.
> +                * MII event generation condition:
> +                * - writing MSCR:
> +                *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> +                *        mscr_reg_data_in[7:0] !=3D 0
> +                * - writing MMFR:
> +                *      - mscr[7:0]_not_zero
> +                */
> +               writel(0, fep->hwp + FEC_MII_DATA);
> +       }
>=20
>         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>=20
> --
> 2.25.1


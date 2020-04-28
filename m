Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537331BC030
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 15:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgD1NvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 09:51:06 -0400
Received: from mail-am6eur05on2050.outbound.protection.outlook.com ([40.107.22.50]:6225
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726871AbgD1NvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 09:51:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdWlutzBRCXKYwCHR2W2jEB7V1e3UHDDMRDMmkCqcLhSVXB1sImMZchnPHcTRnz54DKZbtFJ8NN9hQV45GmyLYK7In2g0//EXHZXHkNcKR5H1OO5UhEdbypgyOc8kNemZ4thUQ8ca2D4IWML9uJ49uYVpJlW8y5Q/n7gqZh6/aQth+y/CnQdZoZRG0p5aHox5CYvlcK+v2uzLplQeEMY77Bk+11oTac/qmkBtZVEzy+YXU6E2o2AJLpBP5mHYFa5j+Z5GX9EU4GiYqlb/V0LlTD7Dk0Zg/rp9wQ3GHypUgOHfcF1cOxkBP0cc61GG85X84bawFZ17nDSjgSlvWuziw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cL0a5zOWaUdLw/3XTGAbktaqLw7mu98YQOV2K+exLkM=;
 b=D+TA45U0JfTUWvnGOFTHH7MisHLnc4Z1Q1c4HdtVpig6epacJ9W9IYo2Y6xkSuE6eaJyFyp2a0anAK5Es6FSNQ9kKxzn8AM6OdGpCo0+Crx9hhiFHVvzJZWuiVEo2G1aOCxBKii6uvOxYRN4KFWw1WzvYN10GVZ4FxpOC0J8AYpFiQynxpAsxhaWZMk4tHo1xSyiq0j9ZjydeYqMlY8tAKt2FFdN8E9SvNzbZZsJRqIeVbZWtc5EM0saMf2k4Yc9ZYf29CdQk6mZo5Z+/lUIPoH+0jxZB8I/3EqkbTTxaFCw8/vPSJQYHpXKfzXtCN5tpfkRzStm+8UYt2CcOxsGSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cL0a5zOWaUdLw/3XTGAbktaqLw7mu98YQOV2K+exLkM=;
 b=h+m6QmOi+VvJ4aKM3Nj0StP9B5Z+vNUO1BtBRShzmp2wvieVhvw2GSYKr1kJi35rxFscR7cFso3ksSnHDxbdBZ0JuORJP3h6YtIOtBdBx6XqCjyaRP6empRpBFhO0nwKF2lAuPfzMWAdOFVw2oAgLUbjdFp+v9uwGVygDIRgnaY=
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB2844.eurprd04.prod.outlook.com (2603:10a6:3:d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Tue, 28 Apr
 2020 13:50:59 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d%10]) with mapi id 15.20.2937.023; Tue, 28 Apr
 2020 13:50:59 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Leonard Crestez <leonard.crestez@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>, Chris Healy <cphealy@gmail.com>
Subject: RE: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Topic: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Index: AQHWHM6CT0RwD5X86UGpti/P/f0ND6iNZxCAgAC/mtCAAGNHgIAAAhcQ
Date:   Tue, 28 Apr 2020 13:50:59 +0000
Message-ID: <HE1PR0402MB27457CCE2807853856117D76FFAC0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427164620.GD1250287@lunn.ch>
 <VI1PR04MB6941C603529307039AF7F4ABEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427201339.GJ1250287@lunn.ch>
 <HE1PR0402MB2745B6388B6BF7306629A305FFAC0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
 <20200428133445.GA21352@lunn.ch>
In-Reply-To: <20200428133445.GA21352@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [101.86.0.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4e0d5a35-7aa8-4d0c-130a-08d7eb7b2ee1
x-ms-traffictypediagnostic: HE1PR0402MB2844:|HE1PR0402MB2844:|HE1PR0402MB2844:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0402MB28448496A267F3BA389B2542FFAC0@HE1PR0402MB2844.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(33656002)(7696005)(8936002)(6506007)(186003)(26005)(8676002)(2906002)(55016002)(478600001)(6916009)(81156014)(9686003)(4326008)(71200400001)(86362001)(76116006)(52536014)(66946007)(66556008)(54906003)(64756008)(316002)(66476007)(66446008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fNc3COFiMrCTSjMlFYs3ihy/iTPD1gwCcX8NJpJedeWI+zXBK4MJNt0dMapmj4yMkmDuC4qvLNkgOPxiDKspwJ4VQfnSdZe1TymzibXxg3bnAbc/TOVeBNz3utZ3poiIlQ8eqfmB50+bbOqv2x5GrHHtT40Cu+hU8tiQHrfzBk0+4QRXsO5m1Dg3XYuGi/N37qrIJAOsCvg2fhxW/Vn4juE4E8ZrKjhK4/Ow+S2FEMzc7HEqdWm5Qm+hRF2BK7nZpsw6urqNlvWoP694KTXfkUYZyZ8ggOB3F3xHc07+Zbvcea8QM3jnVAE7jsfCF9m5f6+QPvDfs9nYUQzGcOvmgVEWGFm5bKa6d7SyECWKBohE9ujCkBc9UwzqSHEc6UY6w3zZMCBPxyWD6Tnk8FrZnQc5ndAhFENwR7wzys+aI8fcaBGij3erdlkyUbnJQNFV
x-ms-exchange-antispam-messagedata: VYmb23FcRuoTLbMx2u0IIQpjdwN8fq4yHKQj2A15SNu/1FTS8xSajbjCYWmDxjzg8R5o7+siGQx2LEoGcFWJkEjaIhERendx/Po5ldg3pOnaBv2VcVDO49wUyAtDSyxdUXA0B10NkelaqzJSp9FpHLwI6yV6KWSo+A8VW+xPhA1Ew7L4RjKritWEvvfXzHrzifhIthnze0pHf4G3hI1o/e7brLMaX0xwncSr6Lu+SmJSd0HYSZxe/Psl56rtg2C+fu07eDZTcCNM2l5leyqbiqtqhRbAx4XpfRll3aPEE/I271anqzOD+hnAKocxkxkutNYgQwXA0aW3o90FGbJLbehk84C8T7PTHcjWj/3zR3VPBcVcA0CABbnHri8V1cgrTWKReJzFaX+l9tkC0ZQuOrt8ac7C5oQRM7SiE/gVIPe7QNw/ch0RqW0Z5YpVOK7jgWC5cltZ1Tqo3AUlj9u5TVaMECQu3aHcgFVN4VnMYau/YXmfR2zASKH5MA57l5f56Mu6N1ve10vW5PYmlHdSIlzKz8C9umjDg0amQuzMcGLaWhCxDlipdFCJtTQ9XNqRHVdanwbV9dpGMN98geVFxMnkNZhT6eYWujjezhbUbJUDVEv9P8pIE0B7cbPsRp2UaJqCGTDj65mCuTA5mUZ8iN8AtqgD9SIfuilTDjVjUjLNHLXn0LaBRjeVt3aYD9dvLIVUCdwqmNyDtBCwyW4v9844Eo8qMvTarkjcQF9PZFvfjg/hjIHkbVzh5l86CuWenGhPyZ1boI4LJ3NuKoUX2i4W/QGOkeEVnx1YIGawvzY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0d5a35-7aa8-4d0c-130a-08d7eb7b2ee1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2020 13:50:59.4912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EoG5PtNVh7LOdwZpk30z0bQBPABYGvwhe9E+fSpx/H+33deox6UYekRGVdo1vCfkeo6G/YHJ/xRUbXrT9lftqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2844
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Tuesday, April 28, 2020 9:35 PM
> > Andrew, after investigate the issue, there have one MII event coming
> > later then clearing MII pending event when writing MSCR register
> (MII_SPEED).
> >
> > Check the rtl design by co-working with our IC designer, the MII event
> > generation
> > condition:
> > - writing MSCR:
> >       - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> > mscr_reg_data_in[7:0] !=3D 0
> > - writing MMFR:
> >       - mscr[7:0]_not_zero
> >
> > mmfr[31:0]: current MMFR register value
> > mscr[7:0]: current MSCR register value
> > mscr_reg_data_in[7:0]: the value wrote to MSCR
> >
> >
> > Below patch can fix the block issue:
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -2142,6 +2142,15 @@ static int fec_enet_mii_init(struct
> platform_device *pdev)
> >         if (suppress_preamble)
> >                 fep->phy_speed |=3D BIT(7);
> >
> > +       /*
> > +        * Clear MMFR to avoid to generate MII event by writing MSCR.
> > +        * MII event generation condition:
> > +        * - writing MSCR:
> > +        *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> mscr_reg_data_in[7:0] !=3D 0
> > +        * - writing MMFR:
> > +        *      - mscr[7:0]_not_zero
> > +        */
> > +       writel(0, fep->hwp + FEC_MII_DATA);
> >         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>=20
> Hi Andy
>=20
> Thanks for digging into the internal of the FEC. Just to make sure i unde=
rstand
> this correctly:
>=20
> In fec_enet_mii_init() we have:
>=20
>         holdtime =3D DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), 100000000)
> - 1;
>=20
>         fep->phy_speed =3D mii_speed << 1 | holdtime << 8;
>=20
>         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>=20
>         /* Clear any pending transaction complete indication */
>         writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
>=20
> You are saying this write to the FEC_MII_SPEED register can on some SoCs
> trigger an FEC_ENET_MII event. And because it does not happen immediately=
,
> it happens after the clear which is performed here?

Correct.
Before write FEC_MII_SPEED register, FEC_MII_DATA register is not zero, and
the current value of FEC_MII_SPEED register is zero, once write non zero va=
lue
to FEC_MII_SPEED register, it trigger MII event.

> Sometime later we then go into fec_enet_mdio_wait(), the event is still
> pending, so we read the FEC_MII_DATA register too early?

Correct.
The first mdio operation is mdio read, read FEC_MII_DATA register is too ea=
rly,
it get invalid value.=20
>=20
> But this does not fully explain the problem. This should only affect the =
first
> MDIO transaction, because as we exit fec_enet_mdio_wait() the event is
> cleared. But Leonard reported that all reads return 0, not just the first=
.

Of course, it impact subsequent mdio read/write operations.
After you clear MII event that is pending before.
Then, after mdio read data back, MII event is set again.

cpu instruction is much faster than mdio read/write operation.

>=20
>     Andrew


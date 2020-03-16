Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20D241865E7
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 08:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgCPHti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 03:49:38 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:21891
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729962AbgCPHth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 03:49:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1TKwkA1M1ABz5aO3fvI7QJeSvg+NKwjATb3BaGWFBLXcs4+jouJ970yfS6OSqmf13FoVYfXyOvkgEH7AQXMcssxtbfbNRc2MgeQU3MqyK3QrVlMlY4Ib4HsCp3/vsbXHvXpoI7IGyrcfI6rrFKL0/kOI7xY8lLAHzJkU/B/W1FlIApDgZgz1aMfl30zsXAjPHxwdDqnQa7LtbPiYfvW+l+3y8GivSD6T5YpFDQ0L55T31uYBANUJbisXcMtzyijlBkxBnxirnGo4f3k5gp0fbx0IJUcc1Jr7NhzYipFz0/OZbjJEPxPf9jQMM1qRKwGuHH1nmiAu31knfZUc7M+jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpCBeoe2lLkXvVfcU8rtdlfxDYdovFqqGcNOru5xYrg=;
 b=cG/GrZv2hcEbvOvnvZPmxvweQr2+tz0s6XeZJIIWJMR/pw0hhwBLl71R5KwUvi649IRJHM13DNMznJu8ul+ajkTjgBn1cS8uGZTiuxxlqIL332Hx8AiMjMHi5ytFqOZ5qD09f4moJ/AtW2FzpECNVdB0vqOkeWNtA+YAKST+rECnVztQrHBeObFKG3ncHJPMO598VWbnZtAvrBXYpDwmz21Ma3x310StmzVHgJ2OSMnUj9RSyyXzv1G1mjJK8og9NRFCtm8+beJK8F/pRgc7ZcjS+P0Slwn1G3T3rv73go+kOJS1nes4f+7UYCvD4ETbIgSkHxh6yh0uBSrHmxA0Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpCBeoe2lLkXvVfcU8rtdlfxDYdovFqqGcNOru5xYrg=;
 b=HiIl+4/b2eYEi3q/eLqHLa1k3O1qIa0B80UB0gBBMin7rXoMq5mC9lv1FNNpW8Zqq/OUCXJfxdbhTOIizpniUCKwPgg8htntW7R1NDjFVdrwUsfUfubAC6x9TYbzIhlCy/6UnAElifZBWFyBrXnVpdk0+lh8RWeUtmKME+TdS4w=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB5786.eurprd04.prod.outlook.com (20.179.10.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Mon, 16 Mar 2020 07:49:29 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 07:49:29 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/3] net: fsl/fman: treat all RGMII modes in
 memac_adjust_link()
Thread-Topic: [PATCH net 1/3] net: fsl/fman: treat all RGMII modes in
 memac_adjust_link()
Thread-Index: AQHV+S+S+wpsiCwtU0+eT3Hbq+n4/6hImSeAgAJDFLA=
Date:   Mon, 16 Mar 2020 07:49:29 +0000
Message-ID: <DB8PR04MB69859D7B209FEA972409FEEBECF90@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1584101065-3482-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1584101065-3482-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20200314211601.GA8622@lunn.ch>
In-Reply-To: <20200314211601.GA8622@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [86.120.221.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e9601ebb-1f0b-4f9e-3f07-08d7c97e8f13
x-ms-traffictypediagnostic: DB8PR04MB5786:|DB8PR04MB5786:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB57862E35E82AEA5310BE03AEADF90@DB8PR04MB5786.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(199004)(71200400001)(110136005)(76116006)(316002)(54906003)(66946007)(186003)(4326008)(478600001)(26005)(55016002)(33656002)(52536014)(9686003)(2906002)(66476007)(66446008)(66556008)(53546011)(64756008)(5660300002)(86362001)(7696005)(8676002)(81166006)(81156014)(8936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5786;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q9OM+1rgk8YzjwuASV+912uCJhEXBdwO6G/Aoo5YVMWAmpNpypq9XLPowhU/ysm9FfCRuvAyHQaphZValeue2GLL7nDnxEijzrlsz9SkATWpTE1wT74ZDifSMgnz1Eevy9bLS5nStLovVQdREvtDVrRVXhPWphTn3+3VNA/zEcpCZqVfygsLYg3VE9jZz/ezi1YGJihgNEzTCP/AC2rThyUVeRZjz1nLgcUxHIsbMO6Y7gW9JdMZ3QQ2OlllfHqkWqYYw69LUCK42mAUwnNLZpnNZQjtbbAiF2EYejWjPyyVwMzlCz2Ir/ogP4rdHd8gtB9hqKxcvTNHTu91kP0tSa4JS69YspROVE2ykVPVt5AhVRl/wyPT/5eEgpinuI4yZ66cs8tYpoFhkmjKzdiu/ExXy3qkE7+i7KAT9ispgq0eU04TEGXDI3TWvSYPwJ5Z
x-ms-exchange-antispam-messagedata: nweVwE0if2VOhGBl6vFtR8VCN5fZ3Or1bicYf/mMNzlTaxyFvxHZC0hCTk0gQumMYwMeI7ePJ19fUlOqxlDwyt47STQVip0UNsYuG4uR297AtX8z3ARS0XaQEaOafCV3NGHFXjDJxRHBPTh3/9TS2g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9601ebb-1f0b-4f9e-3f07-08d7c97e8f13
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2020 07:49:29.7838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b9vUAXrMwlIl4wETBEkDGopwa32B6qvi+Pcy7hAKOIuhERSSolap45ISkUgzNs3yH5gnkmbqSjWMLwutISGuqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5786
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Saturday, March 14, 2020 11:16 PM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; shawnguo@kernel.org; Leo Li
> <leoyang.li@nxp.com>; robh+dt@kernel.org; mark.rutland@arm.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net 1/3] net: fsl/fman: treat all RGMII modes in
> memac_adjust_link()
>=20
> On Fri, Mar 13, 2020 at 02:04:23PM +0200, Madalin Bucur wrote:
> > Treat all internal delay variants the same as RGMII.
> >
> > Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/fman/fman_memac.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c
> b/drivers/net/ethernet/freescale/fman/fman_memac.c
> > index e1901874c19f..0fc98584974a 100644
> > --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
> > +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
> > @@ -782,7 +782,10 @@ int memac_adjust_link(struct fman_mac *memac, u16
> speed)
> >  	/* Set full duplex */
> >  	tmp &=3D ~IF_MODE_HD;
> >
> > -	if (memac->phy_if =3D=3D PHY_INTERFACE_MODE_RGMII) {
> > +	if (memac->phy_if =3D=3D PHY_INTERFACE_MODE_RGMII ||
> > +	    memac->phy_if =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
> > +	    memac->phy_if =3D=3D PHY_INTERFACE_MODE_RGMII_RXID ||
> > +	    memac->phy_if =3D=3D PHY_INTERFACE_MODE_RGMII_TXID) {
>=20
> Hi Madalin
>=20
> You can use phy_interface_mode_is_rgmii()
>=20
>     Andrew

I have that on the todo list for all the places in the code, but that's
net-next material.

Thanks,
Madalin

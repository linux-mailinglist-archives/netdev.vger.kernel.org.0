Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7663C8895
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 18:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhGNQ1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 12:27:11 -0400
Received: from mail-eopbgr1410127.outbound.protection.outlook.com ([40.107.141.127]:23868
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235503AbhGNQ1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 12:27:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RouV1cRkjSnKRRkKQKvjalSzBbyNP7Fm744hZykOK43vCqU03OT/TMVLsld/VXic0c/PwAGW7lcz5O/DMIC8hRTtw7eFnJZrcYNssSiJGPX/YF1VFQ2TiQVHz6+ZypG6EEyFiIKGIx3cnp5f+gfT2Tr7H1a/poah579ArILKMSgV2lNmB/L+W33ZVA+6OLriRPxM9tHlvGeGBXreR/sHyifePYsS90R3kzy9AGvDo81VVGl5bt5ft7Hpvn62gqPwmrjRLLKRL+qJM3kytalwqJl/jLmoZqdn3Gp7PiG15rPqFjuKFEi+aJj8fQsvMUir09JMC11oL4QeTiljGDrUEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E06b0MHfX0xSRn1N+1t3J3RLXk2RTj+X/T1g7xbDmz4=;
 b=PyuLxerNdLj6KBPJOj4A+VeTqi2oLLu67buI94rj+8hjACJxnTJba4rHnsvRvWEAhzmZoYjNK2D/aTX3O6vC/ssxXN92QDNOSTiw9MIK+pTY6Ai8cy8/R/0+ZMnndJgYajnI85RTswuBZa/VhfyrcKiBokRxPp7SYgZi7q2VvFYlgfa+bZo8FhVUkdhX0r0IIRk/bw/6lV4/d6psYdSHnVldSq2tTavwQrNmqVgkkUaw3hxFnEz1ZOshAkkqCuxHSK7XG70u1Gs3N5r09Rz9Tb4fBNDP2QrX8zO4WL0m2dQtlE56rfyeusibGxZZ8uE9D7aFE6sk+qGM0C4S/7rv2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E06b0MHfX0xSRn1N+1t3J3RLXk2RTj+X/T1g7xbDmz4=;
 b=nrh1UJXw/VWdCP+IemGBEwDTUbdcbuEMVHiozZqSOupVgWS19B8qyU4k2VNTgUhnVTxWbVfbR36seqH7RvPvVD61Mm8B8oYShLUR9Ht8g0Csc7BfhK87rNf12/3r4Nmk/Kh6uFMo7B+492LpHcSDHaiSWE40AKWLdQ3ccXSTRNQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB1701.jpnprd01.prod.outlook.com (2603:1096:603:6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 16:24:08 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4331.021; Wed, 14 Jul 2021
 16:24:07 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH/RFC 1/2] ravb: Preparation for supporting Gigabit Ethernet
 driver
Thread-Topic: [PATCH/RFC 1/2] ravb: Preparation for supporting Gigabit
 Ethernet driver
Thread-Index: AQHXeMAg2hyIxeRWBEODyF+mF0If96tCm0OAgAALPJA=
Date:   Wed, 14 Jul 2021 16:24:07 +0000
Message-ID: <OS0PR01MB59220D61614D47EFEB3C67BF86139@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
 <20210714145408.4382-2-biju.das.jz@bp.renesas.com> <YO8FG0zJoG3GI9S9@lunn.ch>
In-Reply-To: <YO8FG0zJoG3GI9S9@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 545e3d5d-bdad-46fa-596d-08d946e3ce2a
x-ms-traffictypediagnostic: OSBPR01MB1701:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB1701D36B88C8B6558D75796286139@OSBPR01MB1701.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DVCDzuP/dY9d/EJGhIIfKUoOwytgD7LvinBCkahdhMqukt11f0xt6mjCE5b08RkpXhoBhc47fh+o38uuoC772SmCIH38nxDax565SJq5KaOOAmhCguldcaDH7BcAaLj6+y4qIKHUFK2RxaipkgBjBfzB/KQPGYRXYIfurTMPgj7T4eVlKrduGX6sin2OTYjBjSCGH+B0yewnSDFq4KcfSj1ShNNrcYXVCxFm+KiklrFCwh+//5zyGVFFsa+ZkpIqOaFg7qVqlIpRRlnA9sWbW1frHaOSQHm+8D0rt5wzyZxwYlb45SMDus2DsDuvlh0MXJcAX8C3POxUwHHz64Wl5lNWfKjQwnv8pt44D8JTaWVNSPoAD2e2RRy1CBmcVHgv4VvrRWXa5adhvD5VcG6zmdtqPgmru1/lTvyZA3cguw4dXoiCA8ylV9HSPy+7XSHUx1v1UwpNsdh7bPiUn9hZif5YRMzBSCICu7m6gnZAmQw6F/I9OpcJgDIT/wOe2uow8dpn+UEZ/ssCk7zHjEZ1LAvdvfWlAFisvk/FglYJf6veD4CVe6kuS1FjN0lZjTwLg2Sj7U1lNz1rskBDEjnCGEFtB+eba6MXHseKsP+4Wc3LAWN14Z2ByVkNrpwb870iK8YVbnlw2beBNmboazh2Ic94sI39EIboFe+WOb0DTi2LtzQzxsBm72f8YRNU6EEZy5K+0us6/CEPmwhDe0mrnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(39850400004)(346002)(107886003)(4326008)(478600001)(5660300002)(7416002)(2906002)(7696005)(26005)(55016002)(8676002)(8936002)(9686003)(33656002)(66556008)(6506007)(66946007)(64756008)(71200400001)(83380400001)(66476007)(6916009)(66446008)(86362001)(186003)(76116006)(122000001)(316002)(38100700002)(54906003)(52536014)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Si+x/9TNVuCZwEAP3cI10yNJ0+YEdL67tLMNxoDDKb9Guyq1MI0iOr8O9ySx?=
 =?us-ascii?Q?E34X0FoMrBO666jvzIyvnuz/k0qRnTnUJ9DsFSgXda1437/HKN8R0v6KzJZa?=
 =?us-ascii?Q?YUfHxJUfivS07l8tQMZ0zs8V44zthjYnG++d3zgJM8bhvthSzQ63pExAaful?=
 =?us-ascii?Q?8Hw3k/T2olK/vfC9vwIRss0nXqirbk7jObfar+klqkwJHDNh5H/SjhuoGzx2?=
 =?us-ascii?Q?MxhdOCsU06i5bGfc3K63TKeQ0pAadDYyoHnXHxJwTEwvg1kYGsQD3N+2HTtC?=
 =?us-ascii?Q?8TbvL9O3uyDfvK7Cnaz0AFsh6WAvtTYEdFgyFyj++eenRHfR4Xy9zcZAMN2S?=
 =?us-ascii?Q?qtBsKG6OwGJYuluzNRFgjAUVzyucVqkefT/Xi3n5azBRbxHUvWcvPBsleroC?=
 =?us-ascii?Q?U/oazuuRFJLaLcS27y6sxw9W3GRxP9uCR8TFQzG2LCgdTQ3ZQYnXhoq7SC+D?=
 =?us-ascii?Q?EwHMWo25ZXe40snzod8xEvtfMctmnxnOwK2Sw5/0EubOldEGfstcuVTbdkDW?=
 =?us-ascii?Q?EZgisb+onM2tA7uM9SvYhIlhL2KzUoU/I4CpnvxsgP5xff/UvDCN6dgEYeBn?=
 =?us-ascii?Q?g8QDx/7r/ZvfKxErO52zxi5VQSt1FXtAr3zbghsuTYXCS3Y4ZImPjoOPN9ul?=
 =?us-ascii?Q?gBDwmLAb3pUlyC/4eQJHas7XtAarffi4fUQfNsTg+NZvF03BUzZfN/yWbM3X?=
 =?us-ascii?Q?YG87YFO/9wuGqKzijvuVn5GQtmDS14AWWM0km1L0dOoG8PVmlAGC8JNnqbIm?=
 =?us-ascii?Q?2Own/2lW9bL6EL2eRrRFpgWf2maVoH4TcFQ5abk4JB4hJFEtl5oSWHG3N9Gt?=
 =?us-ascii?Q?TO+rTBZIjAvNCSZmPuAFozh8Poz8He007CBps6FzAt/yhwTHjoWbBrQedTRl?=
 =?us-ascii?Q?ChrtIyNFp8obTFBlcKlpL7f4ahYTwpKjj4q8CiloWMFyG3uzssAWXKbDH4xy?=
 =?us-ascii?Q?ZDmF5IUlTJ4Nxl/o1gklDiyFUm/xCWd5gDyeMVuusDpl5gLSpopsvaiC6f64?=
 =?us-ascii?Q?Y+I2Hzd1c7rVsGzhrrqdtaGj4oK2FuQGa5hJpye1U6I3F9vuAei3w+/bbnTv?=
 =?us-ascii?Q?rYiRB71fVP+y9FCuBYSxjoZ0vQFkA8NJ95WM2LMcLq3YL4f7L0Oe9Ohbl5mG?=
 =?us-ascii?Q?aziRSIyUX4gwzOx7TgWK+t0PdReu43qtLmUoBz3aBLD7KnXWtcPITLZfq9qb?=
 =?us-ascii?Q?Lh4hJlA6ggkiMmhiolrjtZQZbojgVjYIaUlFUH99HjejREnskZY8LheC77hE?=
 =?us-ascii?Q?vls04RnmDpOC1y5C2xAyOP/E4TLwWrn6nC0MRzHpeeGf34BiQLPiW5bCFL9S?=
 =?us-ascii?Q?gFLRFo2TkfZNsuFzI6xn7alo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 545e3d5d-bdad-46fa-596d-08d946e3ce2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2021 16:24:07.5727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cGPlWWBRKkPzvxe/El/KTNWt8eNCOel+bPcrey5UfhLPCwQYS19ijXB9vSyTIwifrIbPoALtyG3gBAxIsTKrU3wqBQv8NeWxxbwKYoovKOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew Lunn,

Thanks for the feedback.

> Subject: Re: [PATCH/RFC 1/2] ravb: Preparation for supporting Gigabit
> Ethernet driver
>=20
> On Wed, Jul 14, 2021 at 03:54:07PM +0100, Biju Das wrote:
> > The DMAC and EMAC blocks of Gigabit Ethernet IP is almost similar to
> > Ethernet AVB. With few canges in driver we can
>=20
> changes

Ok. Will fix it.

>=20
> > support both the IP. This patch is in preparation for supporting the
> > same.
>=20
> Please break this up a bit, it is hard to review. You can put all the
> refactoring into helpers into one patch. But changes like

> > -			if (priv->chip_id =3D=3D RCAR_GEN2) {
> > +			if (priv->chip_id !=3D RCAR_GEN3) {
>=20
> should be in a seperate patch with an explanation.

Ok.

>=20
> You are aiming for lots of very simple patches which are obviously
> correct.

OK will make simple patches

1) Code common to R-Car Gen2 and RZ/G2L (priv->chip_id !=3D RCAR_GEN3)
2) Code specific to R-Car Gen3.
3) Spelling mistake
4) White space=20
5) Refactorization patches


>=20
> > diff --git a/drivers/net/ethernet/renesas/ravb.h
> > b/drivers/net/ethernet/renesas/ravb.h
> > index 86a1eb0634e8..80e62ca2e3d3 100644
> > --- a/drivers/net/ethernet/renesas/ravb.h
> > +++ b/drivers/net/ethernet/renesas/ravb.h
> > @@ -864,7 +864,7 @@ enum GECMR_BIT {
> >
> >  /* The Ethernet AVB descriptor definitions. */  struct ravb_desc {
> > -	__le16 ds;		/* Descriptor size */
> > +	__le16 ds;	/* Descriptor size */
> >  	u8 cc;		/* Content control MSBs (reserved) */
> >  	u8 die_dt;	/* Descriptor interrupt enable and type */
> >  	__le32 dptr;	/* Descriptor pointer */
>=20
> Please put white spaces changes in a patch of its own.

OK.

Thanks,
Biju

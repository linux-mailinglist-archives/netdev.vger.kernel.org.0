Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD66A29336F
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 05:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390948AbgJTDCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 23:02:34 -0400
Received: from mail-vi1eur05on2070.outbound.protection.outlook.com ([40.107.21.70]:30689
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390933AbgJTDCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 23:02:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCVM99gxl4rQavD4I/m/mOMJp/PpKskNlghuNSL/1dAFn42vX/+BWZqTOqyDghIkOqsDwHHLUoI2E5GgpfurV4fvUGTsfHj4cbHvAGoSJ0g3NqgYvL31Ry9wZRRXnFocD/pobI8BT/TqumXvNS7BWAKpQo6iFpfUvkoz7/DKXcWtSmphKJ64OAY/NqsxyHCKNaMJByxU9GLzx1yxD3JDh+Qkr4DeEp3Es09Coyy6CS5/6UKphI5oD10UZqpdSYJOaxg76A1CyQibYqxheBd5hWYRiDQHzEx9oBjq7tpjYXxyprTnpOOcs6Z1XlPkeUA7Ik71/FkSnKq+/oSye5+mEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9KrPk4rya+v4zCy8AgYJcfqgpSVUMRWaJRxBDSOO1w=;
 b=Mwcmrna1toWbqu9BXBMsxVw1kGOILReSVxi+MWmmRWk0HPJ4N1GD0fOKTfgUPJ0UunBy9N20+pHP2xcF+Z5ann5pbtHCq6LSAQLvnTDawhXcjtLinwMh23FvBMMck53VtypeHIF45vuDM/avWS5OIrNqE0lOsXRI6EnavMmRjHNqOWsnFsq81U0msvikZ9JxUHAGflsaR4nGSqCEuJGPVHawD9x349VtmP5EwaNAvs5bWKNNQLfnx9lDFlSZB5LRDodLJrkg3c5xFLC/qpA2XYEIbGveulKBzDLRHkkGxN0JwkgTlgi2/zpSOjyVDtvHWyHXoxRxchEys6DjCIU6/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9KrPk4rya+v4zCy8AgYJcfqgpSVUMRWaJRxBDSOO1w=;
 b=pmJgS9QWPib8tLPUKmY1BJB3NA0hQH3g3gecuZYzbGRxY1UGQiB2MLZBCgoWYFYvArcO6ugixpZy1HJAfK9ZMtTF4J/yGCPfl3R0Uld83wBTtLHqqpVs9WukjVvLfP+96VmUpyKKr/tpMnt0cIsWo8QVEIcyrjrpHCxNbjqHQw0=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR04MB4082.eurprd04.prod.outlook.com (2603:10a6:208:59::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 20 Oct
 2020 03:02:29 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271%6]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 03:02:29 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, Greg Ungerer <gerg@linux-m68k.org>
CC:     Chris Heally <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Topic: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Index: AQHWpoauv6yGoz1SREmyP2rAbcRdI6mfx44AgAAFGyA=
Date:   Tue, 20 Oct 2020 03:02:29 +0000
Message-ID: <AM8PR04MB73150BDBA6E79ABE662B6762FF1F0@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
 <20201020024000.GV456889@lunn.ch>
In-Reply-To: <20201020024000.GV456889@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f6f9972e-8d6c-40cc-273b-08d874a494f4
x-ms-traffictypediagnostic: AM0PR04MB4082:
x-microsoft-antispam-prvs: <AM0PR04MB4082B168BDE9EC244CF7A05DFF1F0@AM0PR04MB4082.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ebiq1ahMA4zgF2UTxaeQGgzxadfarx9DBqVsMGDJZj4FQsXRqNCWn5ICNjY2qXcqnJLGFGlcSVqRiPCK0ALxzfzf12EdG8wQbVCz/V0b8dlxcGVDWPgrL1YSXvnUYBDq8m+IBwd/ndiJOTKJh4VLSyRnzfQgDgWtFyUYNlPGEbDf2TjCPVZmeCTED8FS0L4o9s1bNC/uPU5LDVZ0G2Qbf16peNRo/f4Hp6f29AAiNzEEqg0PDc7ULRvcYJPPlG/LYSZQ5KEmln14mBrqtAvYJ2b1JbYl8lWvuXDQeOXyBiOgjbP6lTZdfyKTaE5Us50El2yEnZ4Udjw1TPJu9i8Img==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(8676002)(33656002)(4326008)(66946007)(110136005)(52536014)(66446008)(64756008)(26005)(66476007)(316002)(66556008)(8936002)(5660300002)(7696005)(6506007)(76116006)(186003)(71200400001)(83380400001)(54906003)(55016002)(9686003)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: t5dxJzsFXQs5TKmsN0tz26soi2QCnto71s3pUIqN+uao6wwamdjaM2Y4krNyzy94KchWmR3FJlHNwMtTVYekb8OQMxPuDj7efIr+IG+CzvbltQ9MlgBoIjysVD6ogEXg2SM510WOpFB3h4jaF+JWHfxCjPCWLQuxmHbjo+2nVl2g1jT3EaakQii+eLUogYPGcwEMvO6PvKrIXDyrm4+QG8OEAvMq+vE6lwhqBRe/RH4TAGsCM1jZbDHE6MTFMzxyevYls3rKDkM66Dr8EDqE4yFpGFQ8q3Eb3Wzn5YTno7Pl0dadgzJ/LgbzOpJkN6M2mewqc4+q33JILHWWRKYna0Q30NM4esCoxN2VurdM04L+m959ucoG9hAlLYacCQIdL5ugEG252tDnLB+1jMpT4SJguLqaFjjAOsdAlxfxhYHwodbfk1P1cGcJqhMUnKAR1H0+O3U71VzuwI4fBrCkfEYGDQ4pVANky356GlZg7iQBnhclwEzrKt18Yl0KsfnErr2BP7kt39v0M9y4suHN7u5470waRMNOmbJQvaSNzke3kTCcrngKrcvmTpFB3ZP0SqUhMBYFi8sqLvf08q9z/G/V+KhHVBRmuHAmRJlKcuALVCPeApHM7/KCQ4p5ySI5dy3uY7iSosVwVfVyQj1YzA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f9972e-8d6c-40cc-273b-08d874a494f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 03:02:29.4725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 07EUGo99se6hKRppstVuQ8Sp8H6V7MVAPF2yzrSxO2K/oBcwjIqfSmYL9uUTMPiLffNSV9VwZbHJEWG4PB1eSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Tuesday, October 20, 2020 10:40 AM
> On Tue, Oct 20, 2020 at 12:14:04PM +1000, Greg Ungerer wrote:
> > Hi Andrew,
> >
> > Commit f166f890c8f0 ("[PATCH] net: ethernet: fec: Replace interrupt
> > driven MDIO with polled IO") breaks the FEC driver on at least one of
> > the ColdFire platforms (the 5208). Maybe others, that is all I have
> > tested on so far.
> >
> > Specifically the driver no longer finds any PHY devices when it probes
> > the MDIO bus at kernel start time.
> >
> > I have pinned the problem down to this one specific change in this comm=
it:
> >
> > > @@ -2143,8 +2142,21 @@ static int fec_enet_mii_init(struct
> platform_device *pdev)
> > >     if (suppress_preamble)
> > >             fep->phy_speed |=3D BIT(7);
> > > +   /* Clear MMFR to avoid to generate MII event by writing MSCR.
> > > +    * MII event generation condition:
> > > +    * - writing MSCR:
> > > +    *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> > > +    *        mscr_reg_data_in[7:0] !=3D 0
> > > +    * - writing MMFR:
> > > +    *      - mscr[7:0]_not_zero
> > > +    */
> > > +   writel(0, fep->hwp + FEC_MII_DATA);
> >
> > At least by removing this I get the old behavior back and everything
> > works as it did before.
> >
> > With that write of the FEC_MII_DATA register in place it seems that
> > subsequent MDIO operations return immediately (that is FEC_IEVENT is
> > set) - even though it is obvious the MDIO transaction has not completed=
 yet.
> >
> > Any ideas?
>=20
> Hi Greg
>=20
> This has come up before, but the discussion fizzled out without a final p=
atch
> fixing the issue. NXP suggested this
>=20
> writel(0, fep->hwp + FEC_MII_DATA);
>=20
> Without it, some other FEC variants break because they do generate an
> interrupt at the wrong time causing all following MDIO transactions to fa=
il.
>=20
> At the moment, we don't seem to have a clear understanding of the differe=
nt
> FEC versions, and how their MDIO implementations vary.
>=20
>           Andrew

Andrew, different varants has little different behavior, so the line is req=
uired for
Imx6/7/7 platforms but should be removed in imx5 and ColdFire.

As we discuss one solution to resolve the issue, but it bring 30ms latency =
for kernel boot.

Now, I want to revert the polling mode to original interrupt mode, do you a=
gree ?

Andy

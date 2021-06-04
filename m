Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A3F39C290
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhFDVjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:39:16 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:46952
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229746AbhFDVjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:39:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcLOSZkc9WkP8+oVReF4Goop59Bhl1arXK9oZbld36Nwt/GVAh/fyMnJ3d+zyMjv6IRbKAnj2Jw0u/T/08eL1T7NKY2EVbRP1S/6ZWtJvrAf07pSqX2C+YwJmxNkS8KnziN9L+hJApHUL8uyDk6XbmGauR1no2v2iU9uwt6qi/7RN2gcJ2ezsyqnmcmj6v9UMEljCJCSosldMexfcRDpb5O7IOHa6E00kLTpuIAPsirDGuyJXkedff4uFR/xEeK7qI4rqdLP8fp5Aftmo+j7KehJreH4ah9dgWQPfYPtqDb3TobaUiuEdbWzEX27UBDvY4iuATcbk3kk+VDUeE36Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FceF+sTzi2hJCKLjJmxymAJ4+azqK30MwF45YC8eTl0=;
 b=fjJvjDDkyRYtq7plWHbFag4Wel+ykE1FRFxnUqTC+f0eG5AQGjEDWbWX/c2jbBpWxFjHxAYwjllvT55A/yQQ2bvlIJHAhCJwTG0J8cHYI9Wrx49ZoGARJO8BZWk7/3G0c1vCisvtL76EAKpgBDmn0CrsR9h4ZPwrNF1CT6gu+4Ij3Rs57d6PpNx4Ejkt2Z1yMpzngdhsXmtp6+tiIzCZgkILb3rjoeAW4cGZSrj6ewyP5fII1fnrEURqhVHy99v1YtLKmzrjKQruOywCLhnKr7c3Tdu9i2howwQIEp6DCSPhP3LIVOWER+KGtcOzX555vs6G2iNJnIPuuwRZ164qaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FceF+sTzi2hJCKLjJmxymAJ4+azqK30MwF45YC8eTl0=;
 b=dULG+rIZU/sl+fXei5b7UdwpxS/yR+N7fjs7aucYIUZQbCAXNKAfsClaH/xtnrP1CDNzuwV4iiHV9DABZd8a+ih93W+ZkI2pp8GcnrfXCfuY/3ezsV/F7i6oSK+8wF+AJozSpmyjfePmZKglnAE9ltxlaMX39uMcUl2CV1WWJbk=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB4744.eurprd04.prod.outlook.com (2603:10a6:20b:5::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 21:37:25 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7854:74ce:4bb7:858a]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7854:74ce:4bb7:858a%4]) with mapi id 15.20.4173.030; Fri, 4 Jun 2021
 21:37:25 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     =?iso-8859-1?Q?Pali_Roh=E1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: RE: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Thread-Topic: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Thread-Index: AQHXWIWiLLzXceBiLkWovt9CFi28O6sCZLOAgABNOICAAL4lwIAAzjqAgAABF4CAAAgCgIAAGkyw
Date:   Fri, 4 Jun 2021 21:37:25 +0000
Message-ID: <AM6PR04MB39765402C93D1BC25D04B950EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20210603143453.if7hgifupx5k433b@pali> <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
 <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604200007.GX30436@shell.armlinux.org.uk>
In-Reply-To: <20210604200007.GX30436@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [81.196.28.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63a77ad1-94bf-4261-6ad5-08d927a0f1c7
x-ms-traffictypediagnostic: AM6PR04MB4744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB4744008A1DE8844845E8FDC5EC3B9@AM6PR04MB4744.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qJV/3zz6yVYhqXBqjNQ64mPUKOmaTr8h6XjZdGHCfRM8QTo9LjBeS41YWE1ReSulSukw/puChH/frn7fUhcpaDvQ+KWCE34JV4GFavm5jj8MRp1o2Lg1YmCLPjlM7sDvdA8wUtd0U4Lg2JRlnNB3uSfnVG/72k7XJwyFoASCBK0UGRLmZzISOz1B8Evsvn21TjFt2X8jfv3WOz920k1bLJyJRd7ZDzVwxDaouXQlw3nTrU2XYAMgxnP7uF1m/s9zjDOAXJ8CGXOwtqZNc3UPN6TN7vqQCqhVDMPOqM/7uSf3h+pJaJ2xD/R7Un9MYcRXBpXPgtNQuQy1UnDChiSehrDx1UAGrvufpEU3T8X+5WXb/oE+dnnjBFVpeP15rR2oFEZuhF48qWIjDcsaMSVJpUzCPxokPQKegAaKSbyLClYn4x3DT4SQtrJYW0eM9MjIyItOFycQAxEjh9n+3+5FqMgy1yXE11btBT+Qj0Ar56L9t/TTBNDVgGF1Qdb9vlLcrbVISqnhdOI6pQnmpf0lzLdGBK+hjD5+w6m9pfjG8j4T5l03bI2xf5uEbjJO/2izHU9+tha1ouJrztAP0OThEKApGK6xsh11/4X+sUrv8SY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(396003)(136003)(376002)(366004)(52536014)(316002)(33656002)(5660300002)(66556008)(66476007)(66446008)(64756008)(76116006)(2906002)(66946007)(71200400001)(54906003)(6916009)(8936002)(8676002)(66574015)(55016002)(9686003)(86362001)(7416002)(53546011)(6506007)(83380400001)(7696005)(44832011)(122000001)(186003)(38100700002)(478600001)(26005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?rR/bCCMFBo8w92mbX184AprQb2OMA1snPYWhrICaoJdX4Kc3uE1dCwf3cS?=
 =?iso-8859-1?Q?tGJTM4mibkOgCrFleSf/9+TSacL5iYpOh93YBN2IPDXWRcsdi/mZBgx+tw?=
 =?iso-8859-1?Q?RJFHAFdq4/8yVducNmV5Pr3aMWDKouKUUx98hfQgS7i+ENx226EmCEr5B9?=
 =?iso-8859-1?Q?HCds53rksnI4JghA/VJ8Dytf1Uoc+QtyqXwA0uFxbaHqGlIA/jNjwi0+mD?=
 =?iso-8859-1?Q?9G2HzWnSzHitE8BAi/GHBZBTV9LoeVodTIQmsvEmJ5kQkUODRbubSVDoGr?=
 =?iso-8859-1?Q?WsDmBcyNpb8WKtuP+xPk7NMbqDj+WDXuYsRjLhooTGUHSYHxx0RweHBU0V?=
 =?iso-8859-1?Q?3lEbvugguPdSvEQcq2Nuq1EQ88/bmQ2UfGbGRr+xRbPETnH+0vA09ftVHX?=
 =?iso-8859-1?Q?uc9Xud5fFdQmnU9AYQ3yOqfF6WFUjSyDmW7Z75NM5wE0rCOpYtgAvNMEdk?=
 =?iso-8859-1?Q?S66zBco5VPj8ED38/JtrPI50QE6I1h7AfpnSUYC7EH7kmQTjn7JU9tIueJ?=
 =?iso-8859-1?Q?ho965VNS4yMHxg6Q0R6O+eHbWrD47BSmys42u2RP52k+eSSrGQ4KoKxN6V?=
 =?iso-8859-1?Q?6cJf5CkOGOrCrOuQreSLuAmJcE6aAEYiQ3ck4b82kbInNOXCB3Ndgu7UCR?=
 =?iso-8859-1?Q?JPzA8PS+seaPdlJS9vGvahWI6VOaPJZVdSttRp8HUSBGRUyWwmZjWq+p1i?=
 =?iso-8859-1?Q?xwPdYWsQvGgs28z8eMgJzi77vDd8KLYt0Zkvzg0e4pZNH1OhxRzEnw8Zt0?=
 =?iso-8859-1?Q?qZkggI3acYvPL0laixugiSW/sjAXSRt8O2YmInDguGkkrhiYHK1cvDabKx?=
 =?iso-8859-1?Q?jNIX5KFWJnObwN8as8KX4W5owJyxXfKy1LStPnH9jk5joIhgQfzFVbTeNh?=
 =?iso-8859-1?Q?Rwutom0UI9dAOdwjEmg0fxzuwuTp4mUvTHWSho7eIv3zil4a+WMopOStl2?=
 =?iso-8859-1?Q?EWP5QHSVdUwzZL/ws5+tjKm3iBxsu7t3+5OarZyhQe874niiFIPSXUfE0W?=
 =?iso-8859-1?Q?C/nSvgT3+zu2+8JIM0BNpCPX6wb9oq/e2djHg2SZBlWIiWOCF6fbjONRbC?=
 =?iso-8859-1?Q?ZWpCx91c+ixMiVpKMwbjichYSTfX6qagSGm3oaYaB+eKY+Xk2O4NgC881h?=
 =?iso-8859-1?Q?jtOWJB+gsG48Y3Sk95Dqt6P/nOWTScsbh75Y5aIlhxFiEeGIxtW2YqP6NU?=
 =?iso-8859-1?Q?3CqgjoC88a0wgiJEkzrVYk8zPtszl3JSXwEYqHfJu2pCSmdAl2Y6F0T2gf?=
 =?iso-8859-1?Q?+BPiPrK95lzJy0cQrLIUBIhtYw4kpsg3EFdCEmXXtQBVtijLUUVYLzSRdN?=
 =?iso-8859-1?Q?PtsmhY0nqg2IPEtLkuxdkaa9oL92AOsdPuVtSYa1y8+GvD3fHL7zJ5rogw?=
 =?iso-8859-1?Q?tV68t6jDvi?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63a77ad1-94bf-4261-6ad5-08d927a0f1c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 21:37:25.3464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ucdd2YqLie6KkKjkIitRcTPSxJvFAgw8BBvFUWfnMgklNG8XlG0e3xM5qytjfdwWi2ncAFcbdszaMg3ey6AtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4744
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: 04 June 2021 23:00
> To: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: Pali Roh=E1r <pali@kernel.org>; Andrew Lunn <andrew@lunn.ch>; Igal
> Liberman <Igal.Liberman@freescale.com>; Shruti Kanetkar
> <Shruti@freescale.com>; Emil Medve <Emilian.Medve@freescale.com>; Scott
> Wood <oss@buserror.net>; Rob Herring <robh+dt@kernel.org>; Michael
> Ellerman <mpe@ellerman.id.au>; Benjamin Herrenschmidt
> <benh@kernel.crashing.org>; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org; Camelia
> Alexandra Groza (OSS) <camelia.groza@oss.nxp.com>
> Subject: Re: Unsupported phy-connection-type sgmii-2500 in
> arch/powerpc/boot/dts/fsl/t1023rdb.dts
>=20
> On Fri, Jun 04, 2021 at 07:39:10PM +0000, Madalin Bucur wrote:
> > > -----Original Message-----
> > > From: Russell King <linux@armlinux.org.uk>
> > > Sent: 04 June 2021 22:28
> > > To: Madalin Bucur <madalin.bucur@nxp.com>
> > > Cc: Pali Roh=E1r <pali@kernel.org>; Andrew Lunn <andrew@lunn.ch>; Iga=
l
> > > Liberman <Igal.Liberman@freescale.com>; Shruti Kanetkar
> > > <Shruti@freescale.com>; Emil Medve <Emilian.Medve@freescale.com>;
> Scott
> > > Wood <oss@buserror.net>; Rob Herring <robh+dt@kernel.org>; Michael
> > > Ellerman <mpe@ellerman.id.au>; Benjamin Herrenschmidt
> > > <benh@kernel.crashing.org>; netdev@vger.kernel.org;
> > > devicetree@vger.kernel.org; linux-kernel@vger.kernel.org; Camelia
> > > Alexandra Groza (OSS) <camelia.groza@oss.nxp.com>
> > > Subject: Re: Unsupported phy-connection-type sgmii-2500 in
> > > arch/powerpc/boot/dts/fsl/t1023rdb.dts
> > >
> > > On Fri, Jun 04, 2021 at 07:35:33AM +0000, Madalin Bucur wrote:
> > > > Hi, the Freescale emails no longer work, years after Freescale
> joined
> > > NXP.
> > > > Also, the first four recipients no longer work for NXP.
> > > >
> > > > In regards to the sgmii-2500 you see in the device tree, it
> describes
> > > SGMII
> > > > overclocked to 2.5Gbps, with autonegotiation disabled.
> > > >
> > > > A quote from a long time ago, from someone from the HW team on this=
:
> > > >
> > > > 	The industry consensus is that 2.5G SGMII is overclocked 1G
> SGMII
> > > > 	using XAUI electricals. For the PCS and MAC layers, it looks
> exactly
> > > > 	like 1G SGMII, just with a faster clock.
> > > >
> > > > The statement that it does not exist is not accurate, it exists in
> HW,
> > > and
> > > > it is described as such in the device tree. Whether or not it is
> > > properly
> > > > treated in SW it's another discussion.
> > >
> > > Here's the issue though:
> > >
> > > 802.3 defined 1000base-X which is a fixed 1G speed interface using a
> > > 16-bit control word. Implementations of this exist where the control
> > > word can be disabled.
> > >
> > > Cisco came along, took 1000base-X and augmented it to allow speeds of
> > > 10M and 100M by symbol repetition, and changing the format of the
> > > 16-bit control word. Otherwise, it is functionally compatible - indee=
d
> > > SGMII with the control word disabled will connect with 1000base-X wit=
h
> > > the control word disabled. I've done it several times.
> > >
> > > There exists 2500base-X, which is 1000base-X clocked faster, and it
> > > seems the concensus is that it has the AN disabled - in other words,
> > > no control word.
> > >
> > > Now you're saying that SGMII at 2.5G speed exists, which is 1G SGMII
> > > fixed at 1G speed, without a control word, upclocked by 2.5x.
> > >
> > > My question to you is how is how is this SGMII 2.5G different from
> > > 2500base-X?
> > >
> > > > In 2015, when this was submitted,
> > > > there were no other 2.5G compatibles in use, if I'm not mistaken.
> > > > 2500Base-X started to be added to device trees four years later, it
> > > should
> > > > be compatible/interworking but it is less specific on the actual
> > > implementation
> > > > details (denotes 2.5G speed, 8b/10b coding, which is true for this
> > > overclocked
> > > > SGMII). If they are compatible, SW should probably treat them in th=
e
> > > same manner.
> > >
> > > My argument has been (since I've had experience of SGMII talking to
> > > 1000base-X, and have also accidentally clocked such a scenario at
> > > 2.5G speeds) that there is in fact no functional difference between
> > > SGMII and base-X when they are running at identical speeds with the
> > > control word disabled.
> > >
> > > Given that we well know that industry likes to use the term "SGMII"
> > > very loosely to mean <whatever>base-X as well as SGMII, it becomes
> > > a very bad term to use when we wish to differentiate between a
> > > base-X and a real Cisco SGMII link with their different control word
> > > formats.
> > >
> > > And this has always been my point - industry has created confusion
> > > over these terms, but as software programmers, we need to know the
> > > difference. So, SGMII should _only_ be used to identify the Cisco
> > > SGMII modified version of 802.3 base-X _with_ the modified control
> > > word or with the capability of symbol repetition. In other words,
> > > the very features that make it SGMII as opposed to 802.3 base-X.
> > > Everything else should not use the term SGMII.
> > >
> > > > There were some discussions a while ago about the mix or even
> confusion
> > > between
> > > > the actual HW description (that's what the dts is supposed to do)
> and
> > > the settings
> > > > one wants to represent in SW (i.e. speed) denoted loosely by
> > > denominations like
> > > > 10G Base-R.
> > >
> > > The "confusion" comes from an abuse of terms. Abused terms really
> > > can't adequately be used to describe hardware properties.
> > >
> > > As I say above, we _know_ that some manufacturers state that their
> > > single lane serdes is "SGMII" when it is in fact 1000base-X. That
> > > doesn't mean we stuff "sgmii" into device tree because that's what
> > > the vendor decided to call it.
> > >
> > > "sgmii" in the device tree means Cisco's well defined SGMII and
> > > does not mean 1000base-X.
> >
> > The "sgmii-2500" compatible in that device tree describes an SGMII HW
> > block, overclocked at 2.5G. Without that overclocking, it's a plain
> > Cisco (like) SGMII HW block. That's the reason you need to disable it's
> > AN setting when overclocked. With the proper Reset Configuration Word,
> > you could remove the overclocking and transform that into a plain
> "sgmii".
> > Thus, the dts compatible describes the HW, as it is.
>=20
> I have given you a detailed explanation of my view on this, which is
> based on reading the 802.3 and Cisco SGMII specifications and various
> device datasheets from multiple different manufacturers.
>=20
> I find your argument which seems to be based on what your hardware
> in front of you "does" and the actual explanation of it to be an
> extremely weak response.
>=20
> Please provide a robust argument for your position. Thanks.

By lacking AN abilities, this HW fits neither SGMII nor 1000Base-X, leave a=
side
the speed increment. Other than that, I do not feel I have to justify someo=
ne's
decision to not align in 2015 to something that became a habit in 2019, I j=
ust
provided an explanation for the information they acted upon.

Regards,
Madalin

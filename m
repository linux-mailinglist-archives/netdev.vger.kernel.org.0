Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C38E39C088
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 21:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhFDTlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 15:41:00 -0400
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:43617
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230022AbhFDTlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 15:41:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+6m3VEfeqYT/u26+6trj+uh/rOIbbw+gOINtJwZsHjHD+CcrZHFy/GnSWkzSkbvOuCZ0KQUUPDakcmlKnCa6BxcDsxmiY7fc5/nrPE3YMbgBMsu4SZIm6zUGJ6Of5zwPEbruQw9BzaVqzEULbxpDSaYUSqGao0SyD5EevrH6iCvylDoi0tpDuJSZkcNajwtvUdUe13eT0czuEm8AIiFQnoTiFf8HZrjmzzMsD+xAHv9x3oXga4Fdv2Ho4kXlU6j4Ra5VVIxLMY8+CFEZtsfcHwXPljFLyze9QYWyp1Z/udmzxy0NMOPW0SA3MnR06C1d4GDMMJMS1MnutpM0fdm3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9Ri8fZgv3LN2WriySMv25aum0i5w8VKwLIKPFFoJfc=;
 b=iz02yd5xRX/5HlN1op+W9pXqFFi8O/ySt+f4gSR1JAgBnHpK03bAM5h6+VdnSUpIPYrNhnJujgOEdq3rRMwlxpTECYrldRqJ6b0SDsjox6v09RFAAWrkG7BS6IREDM/0r8D6Op5Ovlq65kGt+z+VwvUzAHW0wrhcB+5KUiJ3Ch5DXmvMPFBiGHeC++mrauY0MJbHAtTsGGHs9yGSuo4V9HgZNDY2Vy0CSBKZCljy0L+99ea6+hXOsX2DvGS7mPE/I5xHvednG1kHPxghTx3Kruc/X43CRkl5q1TtBWrGwOknI5AHCR3DjEwJZloH7x9TI0t3cIwdI9i9moy0CgOxqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9Ri8fZgv3LN2WriySMv25aum0i5w8VKwLIKPFFoJfc=;
 b=CdjWoV2UIX84+1n7tTqdg9iQIbf8Iwej0OehwA8ia6grYCxc6bbPfJLaRgR8AaLRp0sbZhumX6/FQLsiyVdiiKgeL8Wgz1ls3I1E0RLp+IaACLL5AQdhrkL5cSrVuEi0uDkT/LQvHG8mzW7jp6coR7oz9YV/9ax/QxiLbN3IcTo=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM7PR04MB6824.eurprd04.prod.outlook.com (2603:10a6:20b:10e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 19:39:10 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7854:74ce:4bb7:858a]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7854:74ce:4bb7:858a%4]) with mapi id 15.20.4173.030; Fri, 4 Jun 2021
 19:39:10 +0000
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
Thread-Index: AQHXWIWiLLzXceBiLkWovt9CFi28O6sCZLOAgABNOICAAL4lwIAAzjqAgAABF4A=
Date:   Fri, 4 Jun 2021 19:39:10 +0000
Message-ID: <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20210603143453.if7hgifupx5k433b@pali> <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
 <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
In-Reply-To: <20210604192732.GW30436@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [81.196.28.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 237fcc14-3410-48bd-c2d7-08d927906d1d
x-ms-traffictypediagnostic: AM7PR04MB6824:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB6824FEB82535089AF65F6620EC3B9@AM7PR04MB6824.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8vShN9VD2om9oJebnrQ1o2Dl9bwQZ6xjchQUpraSwyaf+DNO5SNqnc5vKFJkYCAH+WYWD0iOK+usIzFfsVlR/7oaIXHl5If0ScSLFThnZRtP9DN4/UUyOG9ADC6ieeUAlfgG1zXqD5en4YLmT7mhkHNOlE7SSmSjauVxKp232qa2nY0XXCec+KD+wwiQpfYZgw5awCYWdmYA3KOv8rD3lC3EOxDK/3vxTfxp+7tox2WxwQn1/eu9eISGzVfHWaCoZqkWugyjKTNoDmqPNRfw8hpH8yTen0ow55dH9vexkXANyy7Q5YPO5p9UHInOdBiYSamvFrkY+QMK4vHv//2dPRKisNzGOsBNs+WBzsOZCk5u7NRwZmanHen9hx7ji4olBfLmn8eFoW53h3yOVTyql6khhQtBy332K3WRJ+deRGFBbeuPRtCcy6a1mNjZekTXUcZrcxuxckfV2aLGzmIjjBdj2Is6J3mfiqaKAEsh/V/WmX+3UcGxr3668REPSNtv1blXowsW+nxCMI0zf1vUEDUVYKM+o7/+pEnNaqT8ZKF4AGTBF2xH6QoOg5cchbOeQC/ygK2Wn9Aml1JgJlMAsHARPVMjYdV9RqGHIakdr00=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(396003)(136003)(376002)(366004)(5660300002)(83380400001)(53546011)(66574015)(26005)(52536014)(44832011)(6916009)(6506007)(38100700002)(478600001)(33656002)(8936002)(8676002)(71200400001)(9686003)(122000001)(316002)(66446008)(66946007)(66476007)(64756008)(7696005)(7416002)(86362001)(4326008)(2906002)(66556008)(54906003)(76116006)(55016002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?g7tDFoimVfC4zIDQEl8imvCI5PLs7384+WbCD/humRiwLF/hcE++XK1ba5?=
 =?iso-8859-1?Q?uvTUkwVUHUiMXDT0mf8xqDv/tZv/9x/rfNI5I1bx7AmEJkT6w9NqnluHXK?=
 =?iso-8859-1?Q?+2l5x19UUld2YD82zyMSZguPRruX3Jp67iPivngxj/mKMEnJCDPABtsbaa?=
 =?iso-8859-1?Q?Ruk1U3ysgGEjBnESH4HDL/lwtgIevSgwia8rCApOdhEVIvfGUd7jB/Z4AY?=
 =?iso-8859-1?Q?uCJHxMBIsN4V+4siXa4oOzsZYFEV4tteNlF09XBeY595AYhhd+h1B40a9R?=
 =?iso-8859-1?Q?UWEfeR0NIH8VLmAvPSuGyDynHHlD2RKFdNr2342qi58+ZBfILig/qC4tNs?=
 =?iso-8859-1?Q?v+4KkhaAQKGuWceQnpxgGFv4wMmazJiycd+BQtQMeb+gPGJFfiInRbLGpy?=
 =?iso-8859-1?Q?qDB7Ghz1d9GKYGYu57odJAu482jakFDCVHCuCsFgU0HNHMwISwTdKhlMjb?=
 =?iso-8859-1?Q?skg/lxVAdk9tfHxoGqAGKh/bDJOi9g9YkN63sK01Ts0a2MOCxlYt3/+LkO?=
 =?iso-8859-1?Q?Gl06Zoa8A/FN4COjhVOuTYtxEFBX3exizLuF2Hkxa5on/muWENgViLrDfQ?=
 =?iso-8859-1?Q?2ltqpAyULrCblBWAuxjF/ALwP+Iw3RIoHmui33KV5RCoykQM9ZXCiWyZmV?=
 =?iso-8859-1?Q?fgmQudIO9jZAtFbDgS6dhbUwzE07i0VtF7ys1E7LLsQY3aiTFwivk7CZm1?=
 =?iso-8859-1?Q?LX8Iby5fD3nn0mfSNvTlt/XRi8wTEoOkNV6iaC1Qvw0pZJy9wrQoe2v9Ms?=
 =?iso-8859-1?Q?uaeKYQx76rma5YIdntNvsRTOscyLO1jUDv1YK6bx9s6ktXnSG0XDyjc5Im?=
 =?iso-8859-1?Q?9tM6kM8Id2mB4bMFjXsZweA44VJsQGJm7TOCRtKkGvcDhvNDQHoxsnGryL?=
 =?iso-8859-1?Q?SOgmpAqCdGPZst+QVUHNjiAduGkFfdOSYL3TQMtwkFeQ/FIrZuLm3fsj3B?=
 =?iso-8859-1?Q?yJXIa73XH6nolK60AQKm+CYAlpw2AXeeuhN7QA3iA5SFgaqI1qoTF8PRNX?=
 =?iso-8859-1?Q?8sEt8W2ZPceceH5t/sUA+sSXB6EsPgoroGaISgOB0XsVDt5W0j39NKH06J?=
 =?iso-8859-1?Q?KFI4qSPBqAiOIsvmv4P3aPT2MKs9emP8/bd17K0N5kmnrxta6T9ZCK9c4U?=
 =?iso-8859-1?Q?Wp9m8gT3XHtHpwEQxt/UH/no3jxqlszQEmjI1ouo8gGifvbmWjgdbGDzjG?=
 =?iso-8859-1?Q?qPg5X8JahcS22LjldbpuzdegRFXepDY2jiCnqD8b4tYWJYrU0aP953wIsq?=
 =?iso-8859-1?Q?N9NYTFj4tX0BRk4mhBBbMGH91+P5XBojgGQErm7ZyenO+OHF7CQxC05irY?=
 =?iso-8859-1?Q?bbRkD1G05JaH4Xgf1tqNg0pMW362lunAHw9elEGcNVVQ1wLdsLQGZCUpzn?=
 =?iso-8859-1?Q?GTKgb/qL7H?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 237fcc14-3410-48bd-c2d7-08d927906d1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 19:39:10.7907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N7MRD3MbEaeugu0mnEjEaP4erVhbpVHkJBk5lloSlnZNeoMtW3dtR3NeaaDHlsjFyrepxPDPR3CKlDds2fnMUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6824
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: 04 June 2021 22:28
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
> On Fri, Jun 04, 2021 at 07:35:33AM +0000, Madalin Bucur wrote:
> > Hi, the Freescale emails no longer work, years after Freescale joined
> NXP.
> > Also, the first four recipients no longer work for NXP.
> >
> > In regards to the sgmii-2500 you see in the device tree, it describes
> SGMII
> > overclocked to 2.5Gbps, with autonegotiation disabled.
> >
> > A quote from a long time ago, from someone from the HW team on this:
> >
> > 	The industry consensus is that 2.5G SGMII is overclocked 1G SGMII
> > 	using XAUI electricals. For the PCS and MAC layers, it looks exactly
> > 	like 1G SGMII, just with a faster clock.
> >
> > The statement that it does not exist is not accurate, it exists in HW,
> and
> > it is described as such in the device tree. Whether or not it is
> properly
> > treated in SW it's another discussion.
>=20
> Here's the issue though:
>=20
> 802.3 defined 1000base-X which is a fixed 1G speed interface using a
> 16-bit control word. Implementations of this exist where the control
> word can be disabled.
>=20
> Cisco came along, took 1000base-X and augmented it to allow speeds of
> 10M and 100M by symbol repetition, and changing the format of the
> 16-bit control word. Otherwise, it is functionally compatible - indeed
> SGMII with the control word disabled will connect with 1000base-X with
> the control word disabled. I've done it several times.
>=20
> There exists 2500base-X, which is 1000base-X clocked faster, and it
> seems the concensus is that it has the AN disabled - in other words,
> no control word.
>=20
> Now you're saying that SGMII at 2.5G speed exists, which is 1G SGMII
> fixed at 1G speed, without a control word, upclocked by 2.5x.
>=20
> My question to you is how is how is this SGMII 2.5G different from
> 2500base-X?
>=20
> > In 2015, when this was submitted,
> > there were no other 2.5G compatibles in use, if I'm not mistaken.
> > 2500Base-X started to be added to device trees four years later, it
> should
> > be compatible/interworking but it is less specific on the actual
> implementation
> > details (denotes 2.5G speed, 8b/10b coding, which is true for this
> overclocked
> > SGMII). If they are compatible, SW should probably treat them in the
> same manner.
>=20
> My argument has been (since I've had experience of SGMII talking to
> 1000base-X, and have also accidentally clocked such a scenario at
> 2.5G speeds) that there is in fact no functional difference between
> SGMII and base-X when they are running at identical speeds with the
> control word disabled.
>=20
> Given that we well know that industry likes to use the term "SGMII"
> very loosely to mean <whatever>base-X as well as SGMII, it becomes
> a very bad term to use when we wish to differentiate between a
> base-X and a real Cisco SGMII link with their different control word
> formats.
>=20
> And this has always been my point - industry has created confusion
> over these terms, but as software programmers, we need to know the
> difference. So, SGMII should _only_ be used to identify the Cisco
> SGMII modified version of 802.3 base-X _with_ the modified control
> word or with the capability of symbol repetition. In other words,
> the very features that make it SGMII as opposed to 802.3 base-X.
> Everything else should not use the term SGMII.
>=20
> > There were some discussions a while ago about the mix or even confusion
> between
> > the actual HW description (that's what the dts is supposed to do) and
> the settings
> > one wants to represent in SW (i.e. speed) denoted loosely by
> denominations like
> > 10G Base-R.
>=20
> The "confusion" comes from an abuse of terms. Abused terms really
> can't adequately be used to describe hardware properties.
>=20
> As I say above, we _know_ that some manufacturers state that their
> single lane serdes is "SGMII" when it is in fact 1000base-X. That
> doesn't mean we stuff "sgmii" into device tree because that's what
> the vendor decided to call it.
>=20
> "sgmii" in the device tree means Cisco's well defined SGMII and
> does not mean 1000base-X.

The "sgmii-2500" compatible in that device tree describes an SGMII HW
block, overclocked at 2.5G. Without that overclocking, it's a plain
Cisco (like) SGMII HW block. That's the reason you need to disable it's
AN setting when overclocked. With the proper Reset Configuration Word,
you could remove the overclocking and transform that into a plain "sgmii".
Thus, the dts compatible describes the HW, as it is.

Madalin



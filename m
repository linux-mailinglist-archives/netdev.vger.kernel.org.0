Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D285E41890C
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 15:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhIZNgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 09:36:06 -0400
Received: from mail-eopbgr1400095.outbound.protection.outlook.com ([40.107.140.95]:41384
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231737AbhIZNgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 09:36:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUYA8qbQVEL/7u33HZvqFXA+DtgfG7CEjxrfnTXUR9c1VnUwoMSW5olORfWviDsgw/2sK8HjQ7+UTS+x8wEzmfOlkR4u3Pw80kCazr0VNuKvRzGVu4JgL5doZhTLtX0Is1ZRr9lTvYPFyKeuw1aha0o9OTXbujNEojnVcldCCwvVmOTobwh5UGFIFIFiW4NO6g+7bRo5Tvv6snvZdv70C9Nu3n73aLq3/dw2xmbhPQ/IeIVs3m55QE+0V/uoQ0ke5GzFyx4p4IjHaEdcGtsqPtYrB/yx7+Zh4fF/zjrTO5/hZz0u3FZe56fKJkHoaqHP+CYJUNHNrI14hidtqBBL5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CNN24IvH6ozfBa5S8ty4JzyYWDsYBndv5F2f1GebCgM=;
 b=g8p16cDpnpbyvTGIB9IBEmeN20SjQzKoHw1vtnoWlZ/O6LmkG7z/70JsubG2cHQuxiCKHTcpX3jseBDvIGJFPcbIWx3Bohtkmsy3YG0k5mCnVpXa2yFwtirl3emKlYFg9CcNBjdDgvYS+OdLCzI1DCNMniNBna/pSUYvsGSvTMOgZbWB0DBL+gNJqc3OEVGeYxCO7nn8zl0FGJnCUJWSYQvEk5fu/UqkcVRnshCOTGhYRpWd/a9p+bEPkBE/qmUxuXv2GqqT+2AroCJUEIRlUgX/RUm/Gv4yP1VC4bW9QnU51hF7nn1ZuDZEIGlBj8Qz3bpMb/f8pyhJIaNdbXec0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNN24IvH6ozfBa5S8ty4JzyYWDsYBndv5F2f1GebCgM=;
 b=I48wn1iZxs1t/Y2BH+0etnitM7t1HI545Q62FXLocIpQdN9LooVUoi4SazPOZsts8OSrlP1ejBY8UCkrDSqOtigxm7XzMde7DocsugRHGhGcaT/D0fzvx89sT4d1oZxZLCuslkOPpZQR3Cgoj970t11j+4tS/tNPDLD6RV6c0xs=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2259.jpnprd01.prod.outlook.com (2603:1096:603:15::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21; Sun, 26 Sep
 2021 13:34:25 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%7]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 13:34:25 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 02/18] ravb: Rename the variables "no_ptp_cfg_active"
 and "ptp_cfg_active"
Thread-Topic: [RFC/PATCH 02/18] ravb: Rename the variables "no_ptp_cfg_active"
 and "ptp_cfg_active"
Thread-Index: AQHXsIR6i8xRzRPknU2rkuHPKtaM+auxyTsAgAAE3lCAABnwgIAABInwgARog2A=
Date:   Sun, 26 Sep 2021 13:34:24 +0000
Message-ID: <OS0PR01MB5922153584C6577D4B1486A886A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-3-biju.das.jz@bp.renesas.com>
 <e54aa4c9-9438-bd99-559a-6aaa3676d733@omp.ru>
 <OS0PR01MB59228BE53DE8DB7AA491F03F86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <2d2760da-8400-c43a-8629-a16e78f79326@omp.ru>
 <OS0PR01MB59228BD43B2423B61EF60E6C86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB59228BD43B2423B61EF60E6C86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9a544d5-e58f-406b-c14d-08d980f25b46
x-ms-traffictypediagnostic: OSAPR01MB2259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB2259581ED00A568DA66D5AC086A69@OSAPR01MB2259.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jKJohbktZxhOBZ0B9YpgcRhGmyYc5Tq57sDCCyMtHXDSwU4hOFTe9tjCsfEWwmtMwugye+7pXTb0wMqTkqgb+mjcmkGmRZA49/DMwOI+yOyFGATxqhLO/GoEs97PZQf/NPqsnCesbQ+NiUKAz8mJ+akf7Cb4+UJrC9LBlg3W6dh0i5QS8HdUANQp6VbrnMmKMouyyZlsDjWdPydk2U54+f7sq8u4b39T+GcpO7urXBwaOK3IhI+UjjC4prt86hkJCGLHtg3nclNhXwWg5i3mBd943QobM1qCV6wFnm93tzvvBRrBay3QN11fTyj2Y2mlLLTY5gxj5amez8HsgplSH0wSR9fyGA7Dvk3Wme7qJzkSbBJpZ0+Gc+1lOAR8+YHQncgrb2pc/d/uMCwULOWF2uHWL+MdN/pRQLn1fnTH2gV9+C1pkQDYTP3T0Huz+JHmxyBTrgHeLtflgmyQTZZlNTstEpDOelI5jlZHPOupzMvI3ub294wAMCzeqvIYdcEyMxrXXtLsN3yh/fsEY6DSzm5/yo7g4Kqii9fklFMfao7H4ZaNyffnuRCXrNsvSugqBpBRDsVXfoquQvjCgCzEHhr5V2A8XM9bzNSfnCQn5GpmGDRN638MwHXCYUodk9/zQ/E8Lq6+iDUuRJWFzoVeSApcxDvgd/hKvJXUTON5WgtsepuoknjxyFKqbgEexeLLOm9bbKwzYu0Ga+GDW69L94PnLZxoC5UWsDaAilgjS/BIxLWtXwJKFCBdpBifJvFpGVSog0b4aqisr9rykIo7aZw/YTaFWI6zGqfTOa9o6bs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(55016002)(4326008)(33656002)(5660300002)(7696005)(26005)(76116006)(9686003)(66556008)(66476007)(66946007)(86362001)(45080400002)(8676002)(83380400001)(6506007)(8936002)(53546011)(64756008)(38100700002)(122000001)(71200400001)(186003)(38070700005)(316002)(107886003)(52536014)(508600001)(2906002)(54906003)(110136005)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2xHcds1Yr0FryCCQhc8sYxLgYKX8ckY3oyqWO1YmGAI0lZO59BabsbkNz/x9?=
 =?us-ascii?Q?KCqHWti7Nn9p7PjoyZqrkxfw2v2cACm6dzy0Qg6aN4VQQH7dke3MVZsakJ0W?=
 =?us-ascii?Q?0G2BGAeq0OF6DqwAgLAqoWUYdZwcYaTyW3h9AOc9hoPZet/y3/D0vWDDT/Ut?=
 =?us-ascii?Q?gjDhg3UFdslLUAtZBSltYm3NvZdaMSkVDz1MJPSvVGr0uBLJPmmGP3WEKvpw?=
 =?us-ascii?Q?gMf/zE4EVgMJn+n5uIsPxuhzz22v0eF4ZNNit278SN3rWbnAfz1YB+hZPBkI?=
 =?us-ascii?Q?MZCCJu3iNKPzOqH9FZe2AdRRhQQQT2iXd0SUh9tu43s116AExtuIQc82dHQn?=
 =?us-ascii?Q?xih7T+VMcgjVJOWbwZTlrJDGN1pPbHvIhNr6PHxNBA7wHmrQkNjoOJZe+MfK?=
 =?us-ascii?Q?1oiFDmdngqApdlagrg3SGXYPzaKFaYLdxsmyd2o4Z4RTv/MZjiDh+xH3OHRv?=
 =?us-ascii?Q?vUp385Drhb0tL9YK0WhRXIgCZm0aLsWaA6ohLZ23dDu3gOcBPYSq0ypnnnAo?=
 =?us-ascii?Q?3fNeUJda8MZueLyrhjJLub+oQs/uiwoyu5oOpPn4Rcuobdo0G3GL25DcJJ5O?=
 =?us-ascii?Q?gjaEgsDR4dNamFkYZridqY+BPA7LJH0iFEXv/HUPCRaO3d6vMKyjB0g5jc4V?=
 =?us-ascii?Q?+nLolDyI6S0+qAnsKipjNbQBbihFUIRCFVdWePjJDRl4uDmIrKHIzyXn3LRe?=
 =?us-ascii?Q?fZHel05r2S/tSG6Qnz+Zm0T7KMRq4cra+YxRYh2HBxipA3qhwI+O44LsdObb?=
 =?us-ascii?Q?Fu01967kWfU7jKwxfBkoNPDrhAE42FAKe9FVOSuH8e867p1CvyKe8nIToyLB?=
 =?us-ascii?Q?figEIcouNZBkg/xN0uo2qJYsW118r4jVXs3Zb41C9wCoAHK3zRlY6fGph6RW?=
 =?us-ascii?Q?3yA8k4DUe7qM0qeoQWkJd6gBSVj0SvKeFLt+iG49RX1FlFM6fb7wUlVyQGQE?=
 =?us-ascii?Q?2/T+rUfP2fKHFgye/kp1Th1/nSe8DxfHdWmPKyQcMNkgHbYba9mT0ovDHFdV?=
 =?us-ascii?Q?U72UBj5IxlkUCjR9GrUhQ5ND3N3eWN/21iCWGH9svMLR7/OttScFOPUleFWF?=
 =?us-ascii?Q?opEVonOXSxwCF+r5sebJS9+GDe4s5UlBOghduLreZeifz6t7QhfioIGHMgPi?=
 =?us-ascii?Q?Yz2FC7OWDVV7tL0/t2cdRg5WQGOEitV426JqqUH47W+oO9dsPNIfN45O08hg?=
 =?us-ascii?Q?tNvHm6jc0Bs4hBfwiqESYOBbqlBSVLtJS4RCBE5HX+XA3E3ueZ/U0si52R9x?=
 =?us-ascii?Q?y+FNBK+XsLJzlaswCBIrFRnC0U/QiO6NeZPM4KFQOf3tVxH6Y+S/+zlS80xf?=
 =?us-ascii?Q?f4urJzxBcw6ioMcWWW3iwaLt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a544d5-e58f-406b-c14d-08d980f25b46
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 13:34:24.7886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2s+UQ3QCkyNhafyITz3J60a3+nUjKvEx5WDkx7hyfFY8qydu1ybNHxhMF+S1R3jFwvLIH3yZ0cAJlfJrKiLB4F208FQqBqBAVCIYRL/jbFE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2259
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

> Subject: RE: [RFC/PATCH 02/18] ravb: Rename the variables
> "no_ptp_cfg_active" and "ptp_cfg_active"
>=20
> Hi Sergei,
>=20
> > Subject: Re: [RFC/PATCH 02/18] ravb: Rename the variables
> > "no_ptp_cfg_active" and "ptp_cfg_active"
> >
> > On 9/23/21 7:35 PM, Biju Das wrote:
> >
> > [...]
> > >>> Rename the variable "no_ptp_cfg_active" with "no_gptp" with
> > >>> inverted checks and "ptp_cfg_active" with "ccc_gac".
> > >>
> > >>    That's not exactly rename, no? At least for the 1st case...
> > >
> > > This is what we agreed as per last discussion[1].
> > >
> > > https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fp=
a
> > > tc
> > > hwork.kernel.org%2Fproject%2Flinux-renesas-soc%2Fpatch%2F20210825070
> > > 15
> > > 4.14336-5-biju.das.jz%40bp.renesas.com%2F&amp;data=3D04%7C01%7Cbiju.d=
as.
> > > jz%40bp.renesas.com%7Cec41661b87e14f9e810808d97ebbae07%7C53d82571da1
> > > 94
> > > 7e49cb4625a166a4a2a%7C0%7C0%7C637680166814248680%7CUnknown%7CTWFpbGZ
> > > sb
> > > 3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> > > D%
> > > 7C1000&amp;sdata=3Dze0ica0K57exFOSQ9LyMuQ%2FFimvOW4PtH8ETxYJ8o6Y%3D&a=
m
> > > p;
> > > reserved=3D0
> >
> >    Sorry, I've changed my mind about 'no_gpgp' after seeing all the
> > checks. I'd like to avoiud the double negations in those checks --
> > this should make the code more clear. My 1st idea (just 'gp[tp')
> > turned out to be more practical, sorry about this going
> > back-and-forth. :-<
>=20
> So Just to confirm the name to be used are "ccc_gac" and "gptp".
>=20
> Case 1) On R-Car Gen3, gPTP support is active in config mode. (replace
> "ptp_cfg_active" with "ccc_gac") Case 2) On R-Car Gen2, gPTP support is
> not active in config mode ( replace "no_ptp_cfg_active" with "gptp") Case
> 3) RZ/G2L does not support the gPTP feature(if "no_gac" or "gptp" then it
> falls to case 3).

As per the above discussion, I have prepared a new patch.

Regards,
Biju

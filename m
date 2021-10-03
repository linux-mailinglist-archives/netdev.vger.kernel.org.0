Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7F6420068
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 09:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhJCHHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 03:07:18 -0400
Received: from mail-eopbgr1410105.outbound.protection.outlook.com ([40.107.141.105]:53438
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229567AbhJCHHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 03:07:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ch+ZZcAJtVbiHuT7BUPoPZR6uS88EC6G6UNa3vMwjWD1xfdJiKjg+U8LTLOwWumiG9km1CSWTKXwgK4sHLwjlQqupnOu6XHdlMxk/F/Yff/Q42VRtGxn635BzAphgDs8H2lllg6s3ekilGKdsRkmdgyS7/1DEEXE4in3+otnUG5FLdmM9vWazp2F+qjaJtjQbQ0F/uV/Rzdo9Ty1Fq6HWUGOznHJ4k1C9mBS0QTE+IA+6EHuFVCer+usLrUU2khQjTrX+AX/Yl1P1k2sA/e8DId7Rto93//YqHCfpC2jpT/QRIRIfhBcVj8YPtsiY4Ub2p51/CHy4A9qXjIBxJmGZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ODkoBJb7Qxp62izAopqxQiyK9G4RBOw4fFchDeCBe8=;
 b=hKLPXs9rc0ki+xMXGoLMG5xEOQYHzoGFeQly0BCqrYp6idIb7hT8CI1gDSwzioZWXZDiAcT/32SQxHVhwhsOaJllxjJYLTQDKnmMWO9iP57GJeJNqLCqvVR/fb8ke5OI7HutH4BhO41dR1zhInA7NnGysRIUMIwhTIVihop9jynmamOJ0UGpXwFpICvCX+XQsS8j4HF9NG83DbCx3TJ1HwQuejAnOAh4blbVdVKrT+S2tZWu3b2gQuxpk7FaxDTLvi/27m7h4leZ3tvIstYdcshwexMlTkB/9YAM4sg2ih9Y7pUETW/yc/4h9pRk1U7Hraln/LvD7QWGeJ1DB+hcZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ODkoBJb7Qxp62izAopqxQiyK9G4RBOw4fFchDeCBe8=;
 b=V0l/z13h2JiAa4xG3F8Xh6L0HpesLDQeMiiSj05okPnAYntwHEclEbEmR49T0h6Omi5ESuGAhKJ5d3FD9poevWoU9XrGk9pZ6XNsw6Wq872efClBMAdKIafjXHmg3VaDu6zdZah0e37xMH0mDzkjfqrNaZB963o/MZ8C6upd/kU=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB3204.jpnprd01.prod.outlook.com (2603:1096:604:7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Sun, 3 Oct
 2021 07:05:26 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.015; Sun, 3 Oct 2021
 07:05:26 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH 02/10] ravb: Rename "no_ptp_cfg_active" and
 "ptp_cfg_active" variables
Thread-Topic: [PATCH 02/10] ravb: Rename "no_ptp_cfg_active" and
 "ptp_cfg_active" variables
Thread-Index: AQHXttX2biYCMslwJE+yxvVmFxGPZ6u+nEeAgAC0NnCAALXMgIAA1E7A
Date:   Sun, 3 Oct 2021 07:05:26 +0000
Message-ID: <OS0PR01MB5922C26DA21717B9DF9C501186AD9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-3-biju.das.jz@bp.renesas.com>
 <232c6ad6-c35b-76c0-2800-e05ca2631048@omp.ru>
 <OS0PR01MB59225BB8DF5AE4811158563786AC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <88414688-cf04-0dc9-4583-b860a04791c2@omp.ru>
In-Reply-To: <88414688-cf04-0dc9-4583-b860a04791c2@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f344bdda-fecf-4b3f-1c62-08d9863c2d4e
x-ms-traffictypediagnostic: OSAPR01MB3204:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB320497E7B0DCD26F19FB0CA386AD9@OSAPR01MB3204.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +gHiO/1mFnxi5KlNyxzWWaM/YnApDDJSU+Vro5xHgWucXONvy8d3uLs5vmXTkHMpIkKNvDHesH6JOfr98VLVWtU1GmIBl0JJ9rTj88DYh7ftg/0SK7P5W5+4qixMVcLUD55lF7TJdz0YD9frLKPqKrDC1Tlh4q+TR9CRhV2E2t4ukRue8llT7AK3Bgxgdg3TS0ZmXFz5FLLuNATswDE9qwvOymgvNuTD4PNfE2RJfuhHV1UzwVx9xYKbXw6ckpb4+rntfoiOOb24DCht4/DrerwIkp1eP+Gz6IeI9KKZ3ts13fwrKiP/WUOEQvRTwAYwf1ap96V6VhnuMCl5ISqESVVbhzaj7f9NFFcTo/CGR262ibeK8xbtP6bhv36JaSrt+DfZOzdlrArk6Eot5hmKN70dOY3TU/yeAIlI8Son/12bcLCnyySZ5pEExCq3igM+oFdckjls5y+OdBPXz0/QUSIwdEnSSisfQvUvAkg+tLsiJ8CHm9wGT18q2+mO6zCkwSNmC9aLoKEqRO6hXPswG1Z2kIMS1p4qNYFqWRV8F8mtkITtb3P+P0TL14qZ/kglCjwG+BsPYehSXPyURcomda69OiC64sEVzONYttExErIMYy/ZR3DGBe/+hzrldSSCC/nwZxJ4qN9MX4GAFBeym99D6DCQ4a4N/QIV/eMtb8ehIcYNkrygcVTmDdH4lMBn1c7pAkT+RdOkYYzVdTIxdqoZc/NblPb+xrOTjYnmZsmUMKyZeMKb4VYjwg2Z8PDhoIAiHi6INotmrBgDaz+zMOzYeTq0mZb5d6mDTJAUrZc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(5660300002)(45080400002)(71200400001)(4326008)(38100700002)(122000001)(76116006)(86362001)(7696005)(66446008)(64756008)(66556008)(66476007)(508600001)(33656002)(966005)(6506007)(53546011)(55016002)(7416002)(38070700005)(83380400001)(186003)(9686003)(107886003)(52536014)(26005)(316002)(110136005)(54906003)(8676002)(2906002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dpsNP4v4QFbatc5WJ9FFIQhcjWwr4ufVZszukZ2MngVlw2pwX4oPxs4iJF/I?=
 =?us-ascii?Q?dnFf+YHGVxbzXHVDj1gJskb+d7mcPE9bLE0dow6fM53k2MwwHSFddhiP30Ob?=
 =?us-ascii?Q?Rnf/aCzJlxDV/cd8RT3GDliPOClqBAPPlRyJVnGxioxjLPUJ2dL3J/XjxTDK?=
 =?us-ascii?Q?GfHPY9pflSAlcwOQWUhKn5BboosjeAzKx55gg7IZnv1h3b8KHoAD+IbEkCJa?=
 =?us-ascii?Q?6JCgaKxwG18msHCQteW6mxXymqFS58oLOsm7kEn4oW2xUiTV50M1kO+oC7Sz?=
 =?us-ascii?Q?oWWekdqYutybvgPqS3aGUWOOylBg52ag8av2IyMJY1u2bT4dhPzPQ7e/wzUX?=
 =?us-ascii?Q?+v8b0lRyc2w6a0DwUoxPvKzlwFKgL7uvughzsPoiaJQho0ITsRDhIRuinmG7?=
 =?us-ascii?Q?ZFuW8/9wnJxa7yf77oKja4zHxOuGYGYVmWAMMOgLp4GGMijQmJvVKk3AOoLA?=
 =?us-ascii?Q?oZFO+P/9J+JcGtSr4LN+JYS5KFyT1JmJfFkOR5HolPDKA6hPPiqzWmIQ8KKM?=
 =?us-ascii?Q?CexlddueBMRRR3Dq4vntSs7RP9kbWynLoo+Zf6OTqo+WuVJGQeMUB95P74Ep?=
 =?us-ascii?Q?Cu7/nFUe+vSB/Yqrf0E/EfL5eyuqqeZUwArJCEoBFRS9OrWJ8PYw0Fp8x//5?=
 =?us-ascii?Q?i1Q3f8RE3sJs3tc/stAtmjcmzifWtVcHemUdGYWqM+MP/GKwG/TIZ9g8RkjY?=
 =?us-ascii?Q?SMAntd5aSqfeDiRMdBZzbNc/LDoAeBMsMoqRSqU8+5FS3IkaPbTCOjNWXCRi?=
 =?us-ascii?Q?Fr2rdwovftsQxix9iKs9/DS3zvyRVJkLbh0/xv4GXLSSsCZks2dv2UfcN+2f?=
 =?us-ascii?Q?ilfc39inz3V/HRScaCi3wfs5m3JSwNOdLEednCnCBH78dhegkJs4dq2NsYol?=
 =?us-ascii?Q?QWOJ2k43s9SBLsW7mQQqNe4TTFK3gRwBwLOCAe9Qj6xIyTC3zAb7TpDk7xGm?=
 =?us-ascii?Q?Dn3K3KYECCNwo76v7FJyk3dQzEbyvHCZm0NivOU+C0cKsvsddg4PzZSb74Aw?=
 =?us-ascii?Q?ZbYSD03C/wp2edOPBQXbmdIsLPyqZSmIp6Dt+gvVMesm+/khwweH7MwECc80?=
 =?us-ascii?Q?+sOPkcvqMBp/WUQ3CZmsA2pDjma3IvRxwaXj7WzcQ/CeO7k30b58IoGV7BeY?=
 =?us-ascii?Q?QGyLaOhqPBsPfpXoKAe84E1qA6nEzpxv78g22sX68/oDf04cUlmC3zuaV+so?=
 =?us-ascii?Q?w8tJTx5iGRQ9qZ9tkKdPTCFaZZ71cmvuXFyHUFrAu9TP4MyvebP0smRfHA7a?=
 =?us-ascii?Q?WpPuwE6y9mxpLDhy22y/An5nntO/LH804C9sQkqlBGooxu9x4YXx5Cyt4CbE?=
 =?us-ascii?Q?T3g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f344bdda-fecf-4b3f-1c62-08d9863c2d4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 07:05:26.3609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 900LiGE8bIynW/0D0Qzdx6o4iSKTTTabntAy/RxQ4KKbJnjQVyolfmOm8FQFVUcoDiovQImJKwjqCnRgeBXxvdnCcdoWywE7Z6H3k40x7Dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3204
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

> Subject: Re: [PATCH 02/10] ravb: Rename "no_ptp_cfg_active" and
> "ptp_cfg_active" variables
>=20
> Hello!
>=20
>    Damn, DaveM continues ignoring my review efforts... :-( will finish
> reviewing the series anyway.
>=20
> On 10/2/21 10:53 AM, Biju Das wrote:
>=20
> >> Subject: Re: [PATCH 02/10] ravb: Rename "no_ptp_cfg_active" and
> >> "ptp_cfg_active" variables
> >>
> >> On 10/1/21 6:06 PM, Biju Das wrote:
> >>
> >>> Rename the variable "no_ptp_cfg_active" with "gptp" and
> >>
> >>    This shouldn't be a rename but the extension of the meaning
> instead...
> >
> > This is the original ptp support for both R-Car Gen3 and R-Car Gen2
> without config in active mode. Later we added feature support active in
> config mode for R-Car Gen3 by patch[1].
> > [1]
> > https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit=
.
> > kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%2
> > Fcommit%2Fdrivers%2Fnet%2Fethernet%2Frenesas%2Fravb_main.c%3Fh%3Dv5.15
> > -rc3%26id%3Df5d7837f96e53a8c9b6c49e1bc95cf0ae88b99e8&amp;data=3D04%7C01=
%
> > 7Cbiju.das.jz%40bp.renesas.com%7Cb4a62982865a4f7cf38408d985d11fef%7C53
> > d82571da1947e49cb4625a166a4a2a%7C0%7C0%7C637687955521294093%7CUnknown%
> > 7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJX
> > VCI6Mn0%3D%7C1000&amp;sdata=3D6rpdh6hEAUl1yMng2ruFrKflBiDGmq6RylI90Ije3=
t
> > 4%3D&amp;reserved=3D0
>=20
>    And? Do you think I don't remember the driver development history? :-)
>=20
> >>> "ptp_cfg_active" with "ccc_gac" to match the HW features.
> >>>
> >>> There is no functional change.
> >>>
> >>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> >>> Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> >>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> >>> ---
> >>> RFc->v1:
> >>>  * Renamed the variable "no_ptp_cfg_active" with "gptp" and
> >>>    "ptp_cfg_active" with "ccc_gac
> >>> ---
> >>>  drivers/net/ethernet/renesas/ravb.h      |  4 ++--
> >>>  drivers/net/ethernet/renesas/ravb_main.c | 26
> >>> ++++++++++++------------
> >>>  2 files changed, 15 insertions(+), 15 deletions(-)
> >>
> >> [...]
> >>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
> >>> b/drivers/net/ethernet/renesas/ravb_main.c
> >>> index 8f2358caef34..dc7654abfe55 100644
> >>> --- a/drivers/net/ethernet/renesas/ravb_main.c
> >>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> >>> @@ -1274,7 +1274,7 @@ static int ravb_set_ringparam(struct
> >>> net_device
> >> *ndev,
> >>>  	if (netif_running(ndev)) {
> >>>  		netif_device_detach(ndev);
> >>>  		/* Stop PTP Clock driver */
> >>> -		if (info->no_ptp_cfg_active)
> >>> +		if (info->gptp)
> >>
> >>    Where have you lost !info->ccc_gac?
> >
> >   As per patch[1], the check is for R-Car Gen2. Why do you need
> > additional check as per the current driver?
>=20
>    Because the driver now supports not only gen2, but also gen3, and
> RZ/G2L, finally.
>=20
> > I see below you are proposing to enable both "gptp" and "ccc_gac" for
> > R-Car Gen3,
>=20
>    Yes, this is how the hardware evolved. gPTP hardware can (optionally)
> be active outside the config mode, otherwise there's no difference b/w
> gen2 and gen3.
>=20
> > According to me it is a feature improvement for R-Car Gen3 in which,
> > you can have
> >
> > 1) gPTP support active in config mode
> > 2) gPTP support not active in config mode
>=20
>    Right.
>=20
> > But the existing driver code just support "gPTP support active in confi=
g
> mode" for R-Car Gen3.
>=20
>    And?
>=20
> > Do you want me to do feature improvement as well, as part of Gbethernet
> support?
>=20
>    I thought we agreed on this patch in the previous iteration, To be mor=
e
> clear, by asking to remove the "double negation", I meant using:

I never thought of adding feature improvements as part of Gbethernet suppor=
t. Any feature improvements after adding GbEthernet support.

If you expressed your ideas like adding gptp, ccc_gac for R-Car Gen3 earlie=
r, then
I should have responded it is feature improvement. So please share your ide=
as in advance.

Regards,
Biju




>=20
> 	if (info->gptp && !info->ccc_gac)
>=20
> versus your:
>=20
> 	if (!info->no_gptp && !info->ccc_gac)
>=20
> > Please let me know your thoughts.
> >
> > The same comments applies to all the comments you have mentioned below.
> >
> > Regards,
> > Biju
>=20
> [...]
>=20
> MBR, Sergey

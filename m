Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395D842807F
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 12:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhJJKdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 06:33:05 -0400
Received: from mail-eopbgr1400121.outbound.protection.outlook.com ([40.107.140.121]:9185
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231466AbhJJKdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 06:33:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEz/Kxx6bxQwN/O6q+leQNHTfBlfJWiip6v0J1Umihs6oLNL3EQ5tpAo0Gem7exla9l2jJjcPmLqQY0sYH5vhR6w80koOIFqzE7ihQ/uv4ict0i/5UhBgMGiLM6FEE8jqeG6unak0RWDz88X9vSB2U1LxLdT4s6lgtkKGd9o4ThGAp+8Ky5loESHAQLViPFKk62GVPaeFernh6NMNRSWbrMObkSG+xJSQ+9XHvXKy5Gmx8wZpe69yEYwchLYJGPMfM+pgAPTo4Nu4FeMvgL0J5+UHcCaU6ORfI6uc49tiRlukhoVbnbO8jd9gipWNH+vbiBTxj0RhsnmtXtS+Du1CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7s8t35ol6kBkKWQgWWVaBuXOYadwkATvU/sV8qjlE1c=;
 b=R8I543Xo7M7CmDwCgELk5muET9h6GJowIxpZTQ+ohTi497qgRNw79gRqL3zhSXOOF9q7yR2HervrNmsskqEH21A+PJHUGRvd8qjtr2M/iAcbZjX/FJbxk9bEWXjB0rO7pEUw6tPTFiqaHiOQi+x0NY+tFE9cTmaedGhbnMh/WS0y+5yTGy/b3kBRsEzAtBWpyXZ5bMvkx/dfRbftFLeJV4XMiUqNr6WbGxUcUUdBF7NWrarbgJAZ/q+hoiVh+ArIkTJ4MHOnv6GU3xZHwlBN9+IrhYQESJfsYwt8wuugTuL53Q+56kfvCnv74a6XQVoI5ZrIpVudOGDIaTHyhnecMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7s8t35ol6kBkKWQgWWVaBuXOYadwkATvU/sV8qjlE1c=;
 b=f0ccIK1JpB3miB9xAo0DQU1sM5LWMgFcDQYPR7xQx8IwJJOfk7C+z+9HBedY2yH84EMQRLpjajQEXYefSVxkrIuFSyz4Tt6Q9dXDgdMg+4+1HDSMAqFLCCYF/WueOvJ73OtNpjK4/vn/ZZbdWOYZwgLTL6ZqnJXHBJSsGgeukHA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB1873.jpnprd01.prod.outlook.com (2603:1096:603:30::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Sun, 10 Oct
 2021 10:31:01 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.025; Sun, 10 Oct 2021
 10:31:01 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH 00/14] Add functional support for Gigabit Ethernet driver
Thread-Topic: [PATCH 00/14] Add functional support for Gigabit Ethernet driver
Thread-Index: AQHXvUEBHULAomfYXUWxvR6NssmBBqvLDP4AgADISoCAAB5vgIAAAUUAgAABfECAAAm/gIAACEXg
Date:   Sun, 10 Oct 2021 10:31:01 +0000
Message-ID: <OS0PR01MB592231245B070634A3449C6E86B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
 <ccdd66e0-5d67-905d-a2ff-65ca95d2680a@omp.ru>
 <OS0PR01MB5922B0A86C654401D7B719E086B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <eefb62c7-d200-78d5-9268-d84b75c753c3@omp.ru>
 <6a57ab4e-3681-6a47-c47b-fd7ad022d239@omp.ru>
 <OS0PR01MB5922FA0C0B34CF86286F518686B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <deecd659-f9e7-0ab1-d898-8d3d196862c5@omp.ru>
In-Reply-To: <deecd659-f9e7-0ab1-d898-8d3d196862c5@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6be1dda9-9f84-41ca-42f1-08d98bd90e85
x-ms-traffictypediagnostic: OSAPR01MB1873:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB18738F923FB25758AC77226586B49@OSAPR01MB1873.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FNAzVRCOPHUpwJLI9GzklCPMtg/m28vT8rapxceTphiy2UCKpNTM+WZ7Zyhc8w3LXpylP6mchwRUpdJJLkJ/DMFN0jgiCPYxmvsF4RwaA8NNjyOxWPwyw3QLV7Db45PBuO2DwLuWqZTuSOrCSwxlwCiYUH63YkpOUJr1M3OmVFCtbOZspn9LQGMjlTMV0sHGVh8JCRD0WXAJTbEre2V6UM/L3hsMuDDQD4RrUQTlvzTzIcIKtl/ACPab4Z60RLUOY+9zZt1Tt7d9P7mtiBmZ+Yu2uyRwTK9Nm4ZK7hHJ1mL/AcnOe7/3YDSSGJJHwJMEcy0J5KHJoInvtD8yUQAJrwN0zDoj/IZzBwZQOV9dTrLDWmzeMBydUuZUTTnfCiypO7Uf+UlcmIoJMdP58eDuzaW7szTvpjzCY+nLaid5LO3YW6u9vLPIx+1xqvbfkkkzJxP+Pt4s4glZVMVGh2/aPeYgX+BvlAzcaWRXe2dApXQsB6/Jvg4pUZtiYuksQtUnRfWgdZjp9pipG3O9aW0cTgMRKjd6Mi873OecY9r9qdf6qbQOmRbzC6e7q+Dha8/dIHjk8cs6Yj31+goWrSGpTyuxMU9FpHTNtbALRSRUy7UkClX62DT91IfUHp1icEhw7uYRDwqjOSeU2LBqj8H8a2+8ywSDn1nLNOApHlTNIjPkJXvz4rOvUWFqWCFTbTyjtZ1S5P85S/d+45/iN1kPro8ohk+P9/UFOABNpfEUkcJlN2QKJgno+vn7vC9yPBpJgXeVMbUEYI/+bsZ3UOBaYy+Xd3SWcHezLio2DwxV/rgtKSoVZxDLherEyrn8oubP0GJxRZJblhf/nYUAS7LSFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(9686003)(4326008)(8676002)(26005)(5660300002)(53546011)(6506007)(107886003)(122000001)(186003)(38100700002)(83380400001)(966005)(52536014)(7696005)(71200400001)(66446008)(86362001)(54906003)(2906002)(55016002)(508600001)(38070700005)(66946007)(66476007)(66556008)(45080400002)(76116006)(64756008)(316002)(110136005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+NXHEMD1UgdnIJoINj/jvw6GkmQaUUpQ6dreocd0Vy9Kxq/4mqMrsXESOj?=
 =?iso-8859-1?Q?Ai4V7X6u5KKdd+Ji8RIAlY5G4Am4D2JHC18xvTCRprAi4uIyOlM7zYbDaj?=
 =?iso-8859-1?Q?TfjNk0OXR7LzH+wLfEEFw/nYF+xNhPBX3NciijqZMJq20WhVy6eN9zmy1u?=
 =?iso-8859-1?Q?6G90+qrzHAItipoulFLT81J83FrPbeJvabw2ilnUkUpJVAcfdfRBJhS//x?=
 =?iso-8859-1?Q?j+0tL23cbqyU4sGPkKceFpqSshl4r5/lQX542fZEpqvlULd2Q/b7NMHiZy?=
 =?iso-8859-1?Q?tGAYIh1Bc9NaMtyH4TPFf8gRGo2NEknmoWIRq/Z3ga3/PaxKLB9BkDCVBd?=
 =?iso-8859-1?Q?oS/3AygsdkBKYLiVsR+L2TjJsOi0Kr7KkgVCglPSbON/Lf3CgOvD0QI1yQ?=
 =?iso-8859-1?Q?MMoor3NWiicWo/EqH32/vs5SJdTyxtw5Renhmc74+j7XdP3QPPz8wE5uYF?=
 =?iso-8859-1?Q?R2IBKCgcH2h0uSkthSWrodPh+Ssc/lJUYTkm+4oEuneIignzhNqS9NVA9a?=
 =?iso-8859-1?Q?SBqa08geFz0+bAR5DpP4OgUDV7h6MigIFxiVVGBdWzXXEXNqTA1UuoYfpV?=
 =?iso-8859-1?Q?+84gtClkslgjEy0dtbHwG5Un2aR7nW0h1RuNw3fLKkpFBfYrQ72leqtMAR?=
 =?iso-8859-1?Q?ez8RpWaFDaTIQY4DtVZjCPXda+OZBwrwAVDjhBHNaenOaRArILdlE3WL/6?=
 =?iso-8859-1?Q?sS2MJ2Mzga/J/E8bzMY9OuWcI12bmmoQuAPMSYIewhTcSn/BwL9Fk9O2gX?=
 =?iso-8859-1?Q?DBu43CZSEQtnKDEi72jNoSgK9ln1dzNAxOdQYfmsReXFgn30R1OsM9vqWI?=
 =?iso-8859-1?Q?UluMc9D3HglFVJsbFkAwoa041p71HLEThQfRwZ57EME7iioPIgZ12Teyoc?=
 =?iso-8859-1?Q?ZN3Bex/BJUs1hOkc/yUlON9k/ckiR+9l1GO8UZcZF6dxdqw+6FA7bhIFpa?=
 =?iso-8859-1?Q?9YbyOlib/OfudkBOoOtofehiD8hKX/HheLLW5Esrwyw8qsVnOuriyY5J5x?=
 =?iso-8859-1?Q?lengYcqJesezbyNMCEOE85Sw3fAVFqqp2JT1Eob7KZvtkj/IRkS5KbzOlz?=
 =?iso-8859-1?Q?6oDPgAZ2HvRVdkRG3BKEa39RBrm2RU8Seapo9Bfly7KVnJHLe/KfAMSsr6?=
 =?iso-8859-1?Q?yqCR/5XGXaGJ0Im9KjeSWX836OXYTV+Ahuysq9gPiXb+8LEyZwcUzby6R6?=
 =?iso-8859-1?Q?Ysd+s5kea1zPZf/hmcat0PhJl6uAiIAMkO8WN22QWgFspecn/N9+CWXaJ9?=
 =?iso-8859-1?Q?nq+HV6gN4DFP+L5GeQeQibTG/ed5qbJZ1niDm6Xvpdn/z7/eC5gaEO9kG9?=
 =?iso-8859-1?Q?/Pcfpu6f/4ly/DySuwO7kYwOa1gr0agfvY4vqQ7umEaSRpw=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be1dda9-9f84-41ca-42f1-08d98bd90e85
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2021 10:31:01.3332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z9R4qhDN75JPANnIb4toEXWyZ6EHPI3kct9ic5JA2GQ6lIL89ctBQwZshr5V2/5QOQR3dZWQciQp+shpFAzH3YoWMQ/6kPEgT3zOjwwGJrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1873
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

> Subject: Re: [PATCH 00/14] Add functional support for Gigabit Ethernet
> driver
>=20
> On 10.10.2021 12:25, Biju Das wrote:
>=20
> [...]
> >>>>>> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L
> >>>>>> SoC are similar to the R-Car Ethernet AVB IP.
> >>>>>>
> >>>>>> The Gigabit Ethernet IP consists of Ethernet controller (E-MAC),
> >>>>>> Internal TCP/IP Offload Engine (TOE)=A0 and Dedicated Direct memor=
y
> >>>>>> access controller (DMAC).
> >>>>>>
> >>>>>> With a few changes in the driver we can support both IPs.
> >>>>>>
> >>>>>> This patch series is aims to add functional support for Gigabit
> >>>>>> Ethernet driver by filling all the stubs except set_features.
> >>>>>>
> >>>>>> set_feature patch will send as separate RFC patch along with
> >>>>>> rx_checksum patch, as it needs detailed discussion related to HW
> >>>>> checksum.
> >>>>>>
> >>>>>> Ref:-
> >>>>>>
> >>>>>> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%=
2
> >>>>>> Fp
> >>>>>> atc
> >>>>>> hwork.kernel.org%2Fproject%2Flinux-renesas-soc%2Flist%2F%3Fseries
> >>>>>> %3
> >>>>>> D55
> >>>>>> 7655&amp;data=3D04%7C01%7Cbiju.das.jz%40bp.renesas.com%7C25bc7b915=
5
> >>>>>> d8
> >>>>>> 402
> >>>>>> a191808d98b5ae62f%7C53d82571da1947e49cb4625a166a4a2a%7C0%7C0%7C63
> >>>>>> 76
> >>>>>> 940
> >>>>>> 44814904836%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV
> >>>>>> 2l
> >>>>>> uMz
> >>>>>> IiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DVktj5v0GvrNf%2=
B
> >>>>>> DN
> >>>>>> IFs
> >>>>>> e6xjCUm6OjtzwHvK3q8aG1E5Y%3D&amp;reserved=3D0
> >>>>>>
> >>>>>> RFC->V1:
> >>>>>>  =A0 * Removed patch#3 will send it as RFC
> >>>>>>  =A0 * Removed rx_csum functionality from patch#7, will send it as
> >>>>>> RFC
> >>>>>>  =A0 * Renamed "nc_queue" -> "nc_queues"
> >>>>>>  =A0 * Separated the comment patch into 2 separate patches.
> >>>>>>  =A0 * Documented PFRI register bit
> >>>>>>  =A0 * Added Sergy's Rb tag
> >>>>>
> >>>>>  =A0=A0=A0 It's Sergey. :-)
> >>>>
> >>>> My Bad. Sorry will taken care this in future. I need to send V2, as
> >>>> accidentally I have added 2 macros in patch #6 As part of RFC
> >>>> discussion into v1. I will send V2 to remove this.
> >>>
> >>>   =A0=A0 I'm not seeing patches #2, #4, and #9 in my inboxes... :-/
> >>
> >>      Seeing them now in the linux-renesas-soc folder in the GMail
> account.
> >> But they should have landed on the OMP account too. :-/
> >
> > Can you please confirm latest series[1] lands on your OMP account?
> > [1]
> > https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpat=
c
> > hwork.kernel.org%2Fproject%2Fnetdevbpf%2Flist%2F%3Fseries%3D560617&amp
> > ;data=3D04%7C01%7Cbiju.das.jz%40bp.renesas.com%7C4ba52eb2327b42fb997c08=
d
> > 98bd48373%7C53d82571da1947e49cb4625a166a4a2a%7C0%7C0%7C637694567141278
> > 405%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTi
> > I6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DLyurKu2sR%2BujQkts4LRyLMfPx=
w
> > 7xmjON91zgS7f5Ktg%3D&amp;reserved=3D0
>=20
>     No, as I've told you already. Was unclear again. :-)

Which patch doesn't have OMP account? I am sure, I have added your OMP acco=
unt=20
As first cc list in the latest series.

Regards,
Biju

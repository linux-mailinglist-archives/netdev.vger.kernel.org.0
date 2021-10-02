Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDACD41FA48
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 09:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhJBHaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 03:30:01 -0400
Received: from mail-eopbgr1400098.outbound.protection.outlook.com ([40.107.140.98]:28384
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231941AbhJBH35 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 03:29:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qp4QabDWp9JBs8UqKnO79k61081iuYwwww1FGbrNSW1qgfbqtxNqLRqZd6ViIlKDqu9mRcB44EPvpmXZ/RBrSdQzRGuyy+x6CCX+Syey1Lc/mWVr2TUA+jZ0hGE1TGx5TgyC5yKKGsVSJDjYwqn8sqdECaWJzhptNBaMQ3FREpuMjwTCXd/42X2/eTKIzSNgllCiaQJRiTP4D5xYN3AK2AMMM2bothpw4vn3uk0qROAVA6DM/na3c1xohp/YjApff17wZYZdupgfCp6peYVvR/uTEpUuL7tMHsGgv/AcDfsew6N4D5BFPQM7LH7ROtCH+5RJywSPsgz+cTkLBKz+4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zxrIBVTUxTD9folw70WgLefl/hVEKBEHOuVEkZVei5I=;
 b=jUJpAzF4w5IyeKRzPli+ieYqQPykI+V50/dBlLaP1ckkp3gYuNRjTLdRkGLgPTTIJdco9AjJ87OoFpMnHh09uWEnvCAY2olaZWjZDzr2RO1JI2QRiQvArs6vzQwP5A8BZpfSMF6Z4NgSS3VDDzi72CctqohXOW0AlSjwtSQibg6OEgawCvFrdfoigdisgvD62CiCM7fM7QJxkjUVW6kXKK0seBqEfhUeN36Y+snybEECRMKwkQGAOwS7GTM5v/OJl9UXOpvcAEGPTZFlhnIv5peT7EirIeJQrdJh8psZowqmTgcq/wyBWCzddrnIIbsQZjFnSoQypVQz76SMdREQBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxrIBVTUxTD9folw70WgLefl/hVEKBEHOuVEkZVei5I=;
 b=G52h0yARXRhtZdT/3THXs9rqvz4LaUo6qcxYNq8+DatuhfXpCToHaKCWuSVBysPuKfBbAIc0ce6NyskMyDm4ro3vf//HdGR6p3kvFCFmoTZg9ilRusF5axoHB0cDFINIVICgfKtfKEh65Big2yozoAolrADZHw7wI6DHJ9HTVqA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5393.jpnprd01.prod.outlook.com (2603:1096:604:a0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Sat, 2 Oct
 2021 07:28:07 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.015; Sat, 2 Oct 2021
 07:28:07 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
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
Subject: RE: [PATCH 0/8] Fillup stubs for Gigabit Ethernet driver support
Thread-Topic: [PATCH 0/8] Fillup stubs for Gigabit Ethernet driver support
Thread-Index: AQHXtuNtifj0aCMBNUOA9Z7ugyeZAau+e1+AgADUqAA=
Date:   Sat, 2 Oct 2021 07:28:06 +0000
Message-ID: <OS0PR01MB5922240F88E5E0FD989ECDF386AC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001164305.8999-1-biju.das.jz@bp.renesas.com>
 <20211001114559.376cbf19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211001114559.376cbf19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30da010a-c856-4574-8535-08d985762de4
x-ms-traffictypediagnostic: OS0PR01MB5393:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB5393D1AD0275B6E1A71E248F86AC9@OS0PR01MB5393.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d79Rz+2WJefmQ8Ike1xj2NZW1G+5ZzkYWlRd7JBYtda+Euw23tmB+eQxQGzDRjABHDDupGiQ85NjJbiqlEX8LAJaI55tTU0B5hkJAyzofoGwYPphoM2hrJiJCHL+1CN2fp82eA3bfwEfYxr/vSWyIFHoerjLjuk5pVqKnngLeeR3voKs0WVnplkRE5c3tFp4H0ueg9oDyPMIMQRYKMpjeA3h16JEJEinUMRSq4tZjbarPhDgSCMpv3vwcrx1xBOUD4mF/95uL4KkQHSB/OsANcDat90/Pa4jh5h92giuqSzabLD/9yU6fjT4vWV0+uOXnnHQziAIhGC0KN/9qNQ09lcvO0GPPV/G5kwMFezEakoHEXRxPhhZm0SU89nWAIstS/3oY+BpaXkes72Qus3ow9+3Mz4Mq8UIPuahvaOEirbh9BbHIXcHLRyY2M8c17cJTWHBclQ6+fNwUiL3EF5hskCwMxkRD9TJE2ByGVz3n2N/tEbKo7SKnxzAKUJeI3zyEiGJdrlC1OStJsx074+ntYoIAUUs7xGxr4hcfFHFO5Z40YuyKp0Pmqzujrd8uIbyfZNgpxFoFKe2nfxasvIMstZ/Wen7MSPEZTCinRyKxpYg7EoS+g6oDqnwhldSvEISKK587Pb3L+SlNiQkIA98pnoJj72zH7Yr7TCrbPJ2oC9NuTeZ2lLDdQVKktbapugkz/sXS1iRmU27RuFw3/4UtZxHy6B71ZetkjMatZijiDfwmI+8CQvBu7Mh1wdDoxhyN9tZzG13OB6y+xBfBbBEkHiXC5bprVjrZ9JAsmGAicU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(966005)(8936002)(186003)(38070700005)(55016002)(26005)(9686003)(7696005)(5660300002)(8676002)(6506007)(53546011)(54906003)(508600001)(66476007)(83380400001)(122000001)(66446008)(38100700002)(2906002)(76116006)(86362001)(6916009)(64756008)(66556008)(52536014)(316002)(33656002)(107886003)(45080400002)(66946007)(4326008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LaH5Nz7ah1vLr4JIeXBwXe9lI5kCY2nw36ZSnk8Ck75+d0/Noy8Ax9cm8VWt?=
 =?us-ascii?Q?HvmT0nU621NYHZ8gFxVIhq/IsG+1J7jVckXlAzW6CH+RGGTO2B7DDtPtXlCv?=
 =?us-ascii?Q?p12xOrnB5Ac+EPJ/c1MRntWHFsPPg8eZGlV4D05W5GesSdSWKKjECYA3bpt/?=
 =?us-ascii?Q?2BPLfmHB9ODb7vExzWejtnW5QAxbt0D9WSv7d7hDIARaw4MHMmy0dXA/lLHp?=
 =?us-ascii?Q?OnU0Rh8XC05MrnzbfeIq5PrYklmIIwPAQnuphaKzPiKaope7MUirNbAqbQ4R?=
 =?us-ascii?Q?Q2Hi8UjKecyjk4hV941AIuqmJVLIsKpi30GfCzsJaSwhtLlpNVntVI9d2CkO?=
 =?us-ascii?Q?1+91CtucqvH8ed87nOFnZLH2Am4jwc48FIE7wZWa615gmLmoMiUGI81gVj1I?=
 =?us-ascii?Q?nRSXB/RgsujU3YCE6Os/tTUfLp+Tfizv/vK+Zkj5/7mWjL3WSBfG0GPRAFLj?=
 =?us-ascii?Q?+vOlZGoOiqew2G/t+JPIfdV4Eleh3tyTseIUlPcVo5ru5cYuthpDj2Z+4vy8?=
 =?us-ascii?Q?AUSjtdDshJ6R+4k+n4vBeAmV4bRdOiK6MRLy4zGymdz6UoDr2NINsCZJJ4Wo?=
 =?us-ascii?Q?XQizxfes9QnMqJc2qfWIzP43EOWI7SOn9Iw4lSYBDHnQigDJZdsMQJrSTFRT?=
 =?us-ascii?Q?q6gFsFBiBivp4zxZ2rV+IxriCzasXsUMCRl40FvQhyZujLBWdlfXODJRHUjs?=
 =?us-ascii?Q?5NHpNZJlV14yxdkF7ahp/7QYgkqdB3jklZOWBE8PwsCPB6RnF7O4NOYMvGEN?=
 =?us-ascii?Q?jyAmWzcT0U5ebaGLfw2TwmdPKOfI4BYVrxHV9g9eeka9ROLPR7moI8Ts4mmB?=
 =?us-ascii?Q?+gfrYHAnbHcWrr2xyDbQOVEXSnM9A1wR2AMFW6AACUwx8+TctcBLx2mMn1Nw?=
 =?us-ascii?Q?aRwR3hHP1kIJGCYJwdm3NjRn5j04RcqgMEYTQ7u2HzgJ5VeJcso8pYqD8X8Q?=
 =?us-ascii?Q?RANkNy/Kx/kyv7BNYhpaOlwoBA4RN7VXc0lJhSXha29glDDoCkGGYnU/xEdj?=
 =?us-ascii?Q?SMjcZ0mHxSykGaAOOlJ0LSQHhOewpvoWMQAFkkRI2YmeITs0kkgL9WButinG?=
 =?us-ascii?Q?8iMlAJzhCcr05RmZ+C1ejcwzzaEuCrThY/c5n2K7iWs73OPl79PZUjPsT9lX?=
 =?us-ascii?Q?QpnL4XrMV+Ahw/jmUj8HCnHiiu/Wk2ib3wLUCockdjAmIKjrENZRnYVGut/3?=
 =?us-ascii?Q?0KgJcW9CkxcB/BFAMAr+eO2U8P0nMg+elayI8GVpdbSJSXmm12G9V4bIOZgT?=
 =?us-ascii?Q?hc900/S0OIgHCuXxr6BbjZiU6k9PIcF1y3AvFGAxUAxUM473XHDWDAsGl64K?=
 =?us-ascii?Q?20g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30da010a-c856-4574-8535-08d985762de4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2021 07:28:06.7681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hLDvwTz72v/CRazobHvM8dFm6M3exi6dt0GMCKQGdL1UuK695HlvnsaWGCILgjJRrTqF6xQv8N6nRedZAreBzdMR5OHBKtY8Fml7YKo6cwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5393
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub Kicinski,

Thanks for the feedback.

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: 01 October 2021 19:46
> To: Biju Das <biju.das.jz@bp.renesas.com>
> Cc: David S. Miller <davem@davemloft.net>; Sergey Shtylyov
> <s.shtylyov@omp.ru>; Prabhakar Mahadev Lad <prabhakar.mahadev-
> lad.rj@bp.renesas.com>; Andrew Lunn <andrew@lunn.ch>; Sergei Shtylyov
> <sergei.shtylyov@gmail.com>; Geert Uytterhoeven <geert+renesas@glider.be>=
;
> Adam Ford <aford173@gmail.com>; Yoshihiro Shimoda
> <yoshihiro.shimoda.uh@renesas.com>; netdev@vger.kernel.org; linux-renesas=
-
> soc@vger.kernel.org; Chris Paterson <Chris.Paterson2@renesas.com>; Biju
> Das <biju.das@bp.renesas.com>
> Subject: Re: [PATCH 0/8] Fillup stubs for Gigabit Ethernet driver support
>=20
> On Fri,  1 Oct 2021 17:42:57 +0100 Biju Das wrote:
> > This patch series depend upon [1]
> > [1]
> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.=
ker
> nel.org%2Flinux-renesas-soc%2F20211001150636.7500-1-
> biju.das.jz%40bp.renesas.com%2FT%2F%23t&amp;data=3D04%7C01%7Cbiju.das.jz%=
40b
> p.renesas.com%7C05175e47a5464f89a02f08d9850bb7cb%7C53d82571da1947e49cb462=
5
> a166a4a2a%7C0%7C0%7C637687107650777424%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC=
4
> wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=
=3DT
> fSvrZyyc9%2B%2BOWglDr4Dx0wLqx%2B1tv4toP%2BKaCclp%2FE%3D&amp;reserved=3D0
>=20
> Post it as an RFC, then, please.

Agreed. Will post this patch series as RFC.

Regards,
Biju

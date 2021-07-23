Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECD13D34AF
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 08:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhGWFsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 01:48:18 -0400
Received: from mail-eopbgr1410128.outbound.protection.outlook.com ([40.107.141.128]:45887
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229839AbhGWFsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 01:48:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VX7YXCoJBH3DsJ0vIsPncx332k7iPhi7QegFp8rsGRy7X+Phz/z5Hr7FDDxOwFFhHkoE8fb7OviF+ixuRAANKIwkHSUnAQ8EVaTZgfxeT2PVMJMXCrCxUTdj00+tn2aZlWW9kF+GuXuoyK68VF3SFcdXrzP5QAN77UrNXYg/c28kKd2nYu0vkY6zyBrbeIzMKscQzRHi34HItgr3BP6TknmdEwj254VEqnA5T5OBLlDrd4QrghLGVmvJc+BLyP/XDVkQUVjHmqd6SVlXyoAPoxxgaP2dC+3Gl82Pt9gxFhRu+gwVdUgmKdRE33bLZ1rjIA3nUfPiw76OTvpt4lnqEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hDkbgwaekhPSfnJs82ji4VjWVAmlCNd/cPyw4+6ExM=;
 b=PVT/fAipR4/JibB8haFO/VdHk/EpQcp8wD14Q7xzUQUsX7cSP/6PG2kt/rT1TDaTLgodcDf+96EU0bQgh7e3+lguTKQ/CTtEI4gn7NID82/HWRBH4PRiJGLKDx8NLtQr71gqBisGGYbeIY1ax4E/l9+J1/RlvveYpx4x2T+mDfKP4WQYowGknhJHb7U/XEJz3+MBimCnZUzCzTSim6XCfvnxIBGncx+EuDKiOger79CcKugCV6teQOsoiUSyeOiWBkmaPAIe31W+n7YnBlS9YKLKM/adWc2vay9uKhcbXnd26lu8Obhii49ToeSFUaANiEaLjOt+BYZr/3qrCra+Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hDkbgwaekhPSfnJs82ji4VjWVAmlCNd/cPyw4+6ExM=;
 b=eBmbwg9KvxWPWfdcI3ilwUDvZytWMWYao3aaeb8YnCvytjsTy6yBd0nrlkx1MD/XS/X3VSu+MVblsTBS/INbsK4Pdx+N2MWFArc3pvqUPGhVq215LlGZq6V5iMlN/L6JftZ6QT0XXx3L18nqahAkutJYbpISXJsLXiJElcQEg/Y=
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com (2603:1096:400:47::11)
 by TYAPR01MB5673.jpnprd01.prod.outlook.com (2603:1096:404:8052::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Fri, 23 Jul
 2021 06:28:48 +0000
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::1bb:3bd3:f308:a8c7]) by TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::1bb:3bd3:f308:a8c7%5]) with mapi id 15.20.4352.026; Fri, 23 Jul 2021
 06:28:48 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next 00/18] Add Gigabit Ethernet driver support
Thread-Topic: [PATCH net-next 00/18] Add Gigabit Ethernet driver support
Thread-Index: AQHXfzu3gyIx47f3XEGpM81xIR3XoatPfKQAgACbhlA=
Date:   Fri, 23 Jul 2021 06:28:48 +0000
Message-ID: <TYCPR01MB593398E6E5422E81C01F1F8C86E59@TYCPR01MB5933.jpnprd01.prod.outlook.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <b295ec23-f8b2-0432-83e6-16078754e5e3@gmail.com> <YPneBpUk6z8iy94G@lunn.ch>
In-Reply-To: <YPneBpUk6z8iy94G@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67558776-69cd-40bc-e8df-08d94da32181
x-ms-traffictypediagnostic: TYAPR01MB5673:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYAPR01MB5673BFF570B80AE5B952570586E59@TYAPR01MB5673.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LC8gkUZ0KAW1TvR/SKT9xZC9wgcLCiNjcfErZjqX1ccNvdhYPdxFenwuAuNdbV9NDHC1N4PdVHzCF5Ndv74GrNnTO5Ae9XhJvAnXK1w5DnOJKL029WYwyPzTm4Roj4iAGVLH4kXQLBq2KZ/XPmQ9K4X/8Br+RshT8tlaYV9BOr7HxKcjZlHScKXa36el2tYMM77BlLgwvZMRbFVDTz1CAx9Fdu183sw1WN6Y1//LPvuoQvWFcJd06NHL1PKE1zjAFWyVR/Te3Mrmmkc4uQ76TXyJ1UE/JDGVyK3kOW84AP/KCRravkGc/I/4TicC4y3lCJmRAf2gJPiDgZ+7F0d92/ZUBY4MG1w6OaI+/SWYxtQVTzKly+0KDjyIaq72ZBRJXC5HitrMAw2B0+LFpVesAgjM5dIVNTetFlbwE3c4lSSRpNOhZmEvNNocGjppuAQzUNQSx1qLFLZBl5vZTv3lFOh4zD/iGwCZwIuLjDI12qu1bawjh6Rq2e/RTisiQ19NFMKVnVqTZoW7cEx7IGrl2dqWDY1qOfs0pnxYUTouzjAjcOci+UvdgVn7btlB9c/3sPD0KiOqI9MUikhg/7fC9L1jiTgJb4R0EOeVQyFeJdCX3zPCUJAmCLC8L9L+HERPCJNb+eP6F0iQP4fJVCxv11jRb96O1PmVVcKxczCmd6oQuIXH9KcZFru0hlxQQGZrkeaBW81u3jOzUawA7YY5gbCPDg5+wsYwX4nHezy6BMtzKmXRgQ2wzqtaDZXXtRi4vsXMcnGdFNPGiFLY9np2gmvBwpjPYOZcxaRmxmv4Pa4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB5933.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(966005)(7696005)(110136005)(122000001)(71200400001)(76116006)(26005)(186003)(55016002)(7416002)(4326008)(2906002)(5660300002)(6506007)(53546011)(478600001)(33656002)(9686003)(66476007)(66556008)(316002)(66446008)(64756008)(107886003)(83380400001)(45080400002)(86362001)(8936002)(52536014)(66946007)(54906003)(8676002)(38100700002)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ydxzm9eAkSOpOvc/lvxvhxu/iEzQ+y8jTwZMnlkRJLxGVWBRWvzV/jpkvytS?=
 =?us-ascii?Q?yAaA8dAKWRxy8VmmUPW/gEGkCpFqa2Q0JriJv+aqpFrWbokg4WD8V6Msuk3m?=
 =?us-ascii?Q?qMPRCEloPDuJ+UTXPRv/o74EmSVth0oiVV9D1jdkxo5/NMTBaitnYKa2h/3X?=
 =?us-ascii?Q?fEM85NCDEZ7h0n4Vp9pkO+f9gdivMDR3jsbpxYWHZpYfRHVZiPW5T60/mwZa?=
 =?us-ascii?Q?hHIZ5vLXNdg6oNRbRRFBMwlQIwn+GzpKBAJEwvtCw0FeOBTxto8R2Xv8YW6H?=
 =?us-ascii?Q?ltTzFHbcu6yRitPnozw5Vx9xkAVmcQd+ixQqFjTkUvz4/jfiqzgyWmDXUbs1?=
 =?us-ascii?Q?ThfOXuce5zZVDHAMWYrZkRvuxhsj1E2mHrhkjFDNubRVX3KRcwx2x1p5k+6b?=
 =?us-ascii?Q?ob/OXkFnDrFLCnp5Sm7ybIhA6h3GuzTio+q/TburGvgN9ByoFb+g0Um8rb72?=
 =?us-ascii?Q?BfgpkxmTD2wwcQ7LXBM2wwXc6vPRDUav+7Cs46PlDEvbVGWJRFR2LgzTeP4k?=
 =?us-ascii?Q?qxX7ttdoJ6bg2IxOdrePnOcUpZZqyMV8kFQGwHcgNq5BipR93OpSOTWlfdoq?=
 =?us-ascii?Q?I1wTrMCtAZokVTlcNXowFk2+dLARxsmGzcF4WYsbFHSZJrMvuJ6cfgT1mFvc?=
 =?us-ascii?Q?FZOaJKv7Y/H2ES2WppHDwv13+SfqwDArP80XtIg45NpLiMwjnh3PLdYLYEZ+?=
 =?us-ascii?Q?pyrxKtptrqQA08xfGBaCWCufuWWroTBKQ9DfPJHANNGxv7urd3JQ6f2WhUNq?=
 =?us-ascii?Q?BwunlFVmxgzRTk35Ll+CLPZxfSYMy7WVlgXzic9umtB3sBQqCKsEDKH6+O9u?=
 =?us-ascii?Q?4tHBJr9SevwWlSzOnYdh9M4V/c8yPuVXTEg98JbtSi/qFMQV5BIgydHjCfsf?=
 =?us-ascii?Q?zNq84qGIOPifsZ4Oz6GRYWVg8qJuSvmKb5x/jYItqeKJB0YhtKAIgJkj7XGz?=
 =?us-ascii?Q?YdkLA8b1to9ij0GqG9j15EDg4SB5v5b4pOMdenIVXO4Q3OxZ9b1Zz+hvkr/0?=
 =?us-ascii?Q?SBsiQ3Hn32clgDI6q6O/fPbQtIiXt+4sr5gBZ0dIIIcEcNQpeBjvznM8o+7u?=
 =?us-ascii?Q?WiMoIOU/SdcDEAwBOw35zwSYqs+i1bJ2SpaI9UQ7ln3FJNuDjoh/qmXoyCsN?=
 =?us-ascii?Q?v5Nq3TUBygZMbtl+BkR2wJiYfTL0KRP5IyzkPWKSW2rfSec16s14JjTptTz2?=
 =?us-ascii?Q?m4YjzpKxS9j8sLgwhkKQLeMOpUPrIx/BTi84dHPKAusCvTWLp7U6KoXuuWLx?=
 =?us-ascii?Q?r58ECKzkO7YoWlawhReOYpgY+oKi9DQpFCJm6s3P+d5ugXGQ91HlEF9SAXzo?=
 =?us-ascii?Q?5phDKlgDhieq1X2NtKEx3/+T?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB5933.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67558776-69cd-40bc-e8df-08d94da32181
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2021 06:28:48.5461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lSdDpKRAhiMuI412JLi3Y7URvVOhJFiwRkS5ggbalsFf8RWvofn6/XbldAk5AusswbnyUcYXLXYdmrx70Gaf5/0oLxhEUpY/ntIJMXR+tTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5673
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and Sergei,


> Subject: Re: [PATCH net-next 00/18] Add Gigabit Ethernet driver support
>=20
> On Thu, Jul 22, 2021 at 11:53:59PM +0300, Sergei Shtylyov wrote:
> > On 7/22/21 5:13 PM, Biju Das wrote:
> >
> > > The DMAC and EMAC blocks of Gigabit Ethernet IP is almost similar to
> Ethernet AVB.
> > >
> > > The Gigabit Etherner IP consists of Ethernet controller (E-MAC),
> Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory access
> controller (DMAC).
> > >
> > > With few changes in driver, we can support Gigabit ethernet driver as
> well.
> > >
> > > This patch series is aims to support the same
> > >
> > > RFC->V1
> > >   * Incorporated feedback from Andrew, Sergei, Geert and Prabhakar
> > >   *
> > > https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fp=
a
> > > tchwork.kernel.org%2Fproject%2Flinux-renesas-soc%2Flist%2F%3Fseries%
> > > 3D515525&amp;data=3D04%7C01%7Cbiju.das.jz%40bp.renesas.com%7C6fe3922c=
c
> > > 35d4178cb1d08d94d54bc75%7C53d82571da1947e49cb4625a166a4a2a%7C0%7C0%7
> > > C637625848601442706%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQ
> > > IjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DbOpIqV1=
g
> > > lMUXqz9rsX0UK3Oqap2J1cY86TGVOJvzYe4%3D&amp;reserved=3D0
> > >
> > > Biju Das (18):
> > >   dt-bindings: net: renesas,etheravb: Document Gigabit Ethernet IP
> > >   drivers: clk: renesas: rzg2l-cpg: Add support to handle MUX clocks
> > >   drivers: clk: renesas: r9a07g044-cpg: Add ethernet clock sources
> > >   drivers: clk: renesas: r9a07g044-cpg: Add GbEthernet clock/reset
> >
> >
> >    It's not a good idea to have the patch to the defferent subsystems
> > lumped all together in a single series...
>=20
> Agreed.
>=20
> Are these changes inseparable? If so, you need to be up front on this, an=
d
> you need an agreement with the subsystem maintainers how the patches are
> going to be merged? Through which tree. And you need Acked-by from the
> other tree maintainers.
>=20
> Ideally you submit multiple patchsets. This assumes all sets will compile
> independently.

Agreed. Will split this patch series in 3 patchsets

1) single binding patch=20

2) Clock patchset

3) ravb driver patchset.

Cheers,
Biju

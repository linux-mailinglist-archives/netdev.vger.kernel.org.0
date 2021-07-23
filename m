Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FE13D349A
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 08:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbhGWFnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 01:43:10 -0400
Received: from mail-eopbgr1400108.outbound.protection.outlook.com ([40.107.140.108]:27472
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233835AbhGWFnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 01:43:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abl8rXr1+hpeZ9/NY+RPI5tQ1kF+aRFQxv2yg4/A8ulk1t9SLDUIsZ6WOEC3aqj44cRV7ccNkakQsKKvyC/3fY7WhaU7SwqYwMRqoH7MKeWk0XIwRctyILE7SY6S+ef3iV57YZIDRCZAcMQAQRy080g+1ap2qJ1xfJy5NG6lE2mzHCFUgKO87LInA5/DDz4aV+vpTJf1bPLAiLXxl5dUl9X4RStbMTsyrAmz44jn41Cbj2/slk0h72z8bi4zwQ23Ct2EypKkHtIRbYPC9DQoeehQW1f8xPKQjWNAi0eTvRvVqQdw/26tEUSkKSmFRIKRBkI9HAvj8icFHfApISRyzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uz853pLRdOG3pTeeuq/EbcBh3XcgWVbrqfBBb1cSjrE=;
 b=ABN6ZHtZotCu+mCPUEoac5lt0KOv8z4SsCN0G9TkeglivhdwNALktPH5oOIEgw5+l4nzcmxxKCcIE7G/uP094aSgBoQ9whX7LyGcrOFTfOEz8XjP1fpgd7zIOyflsPICwEVwGJIXYwR4UiDLNGd2HWagUJcimOapMqEuWp/r4L3sERib0W9Sz2bRVdXmqqal0Px7uDPwlgn4qKWe79BIBZdUVtu5pFRRVb3gsn0LmCMYLEFIDoWpaYka7iK3kXF2NpiQIKi87TsVcUUM+TkLUTtCYMhmk2MUOb+msVJWXbicU8X0vmVgPrXvYdIAQfSeLLmF2xx0FipKQm7F+gOIjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uz853pLRdOG3pTeeuq/EbcBh3XcgWVbrqfBBb1cSjrE=;
 b=RvLDE2MkNoyd3ER7hkWhPdAT0vu14n/TuEDflRSv4XyC/P7N0XxfIcq6q5MlIVCRmZwWpTzDnbDml06QGSTkVUAwNgvi32r3SreBEcAO/g9AvTVDM6CcY8Pfa9ms20/XyeASOn6uBvJksNq1ZP24D2TewU/VYcWlZy7huFXWnFs=
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com (2603:1096:400:47::11)
 by TYAPR01MB5353.jpnprd01.prod.outlook.com (2603:1096:404:803d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Fri, 23 Jul
 2021 06:23:39 +0000
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::1bb:3bd3:f308:a8c7]) by TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::1bb:3bd3:f308:a8c7%5]) with mapi id 15.20.4352.026; Fri, 23 Jul 2021
 06:23:39 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
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
Thread-Index: AQHXfzu3gyIx47f3XEGpM81xIR3XoatQFa+A
Date:   Fri, 23 Jul 2021 06:23:39 +0000
Message-ID: <TYCPR01MB59334319695607A2683C1A5E86E59@TYCPR01MB5933.jpnprd01.prod.outlook.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <b295ec23-f8b2-0432-83e6-16078754e5e3@gmail.com>
In-Reply-To: <b295ec23-f8b2-0432-83e6-16078754e5e3@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4aed96a3-f667-4a98-ee1f-08d94da26920
x-ms-traffictypediagnostic: TYAPR01MB5353:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYAPR01MB5353503EFDD51F6DEEFF2A3286E59@TYAPR01MB5353.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oW35rQL2Xv4SNJnuIijm/v5m2lLnBesgo2Cks7foOov2VrTa781O6SRQC2tPkvZmSduN8avavFt54FYxyJlfz3FUFwvUuTGUhJCclk5cJF0PV1wXOBlHs2evDGiM8rK57wxzS/AOmpibNIgTyXKRA+HJmLNkTNVnyuK74mZga6Ith8k30L+h4KUmeJ/w3Tas1dL5sEqDBkoum6u2xoicwxwbRIMuJPXFQmVQ2VsnyTtWFXHlEtxXo3oUnST3NlOHAmRWQfcI3z5tB0ZprVSXuooiasXP437TZA/cAZ6kXLPievKdGQmCbB+RzCWCWzDesUm1e3JmqlpAMxiNH5TSMZD8Kw84ewjM+nC4AUsVOPGPpg0/OeM5bGqDnOR40LpwOo5DXNBq5WfxuF21eBi8L/ynsrQ3/NCMlt6WGO4VYSAjV/9ZMU7ePqF3Mz0RaBUERd62aWzCuBkNjc25nvj/iL2nUYFA9C9uHMaEOJCRwEsEpE4YZGs5nqpoSoUaJplMY/89xt1JmcL1A5cKXPx1CpZyMXyWyeqUhgmPKMSyDKQM6nhdeThVKoRQBl8/+rZsHiEKXNSIb1c3sAOM+Ygheg/wy4c43VczxDePedKPmZt6Ws5yZD8ZxnxwTEPt8n9tVwRa1aQCz8FKqCW8F2sTqH31jbgjMqpu5XG4kXVBzniLznc38CTATu3/JMEn79hNQDFt7a0YWMqoq0P46eUyuxiEFkhMyVoQSNpo746AGFxRuO9cNP4DpT9sH8uYFLcg0GaWYmiVfxVPoknqFPV8nXQR5wVnLmV77NH9FLygTtIAfjMJscUHQqkipMcfzBDhlzv6hvZfS5QHd8NcR0zEsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB5933.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(8936002)(86362001)(107886003)(55016002)(4326008)(52536014)(54906003)(7696005)(66946007)(38100700002)(7416002)(83380400001)(71200400001)(2906002)(5660300002)(9686003)(66446008)(33656002)(8676002)(316002)(186003)(110136005)(45080400002)(6506007)(53546011)(66556008)(966005)(478600001)(26005)(66476007)(64756008)(76116006)(122000001)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DCMMxTZkmT7XWFoZ/meRUi7i7Mur5Rr5C9iMmhCYPIq2+GJybuT9yUDqlT8h?=
 =?us-ascii?Q?EHxPvaT7Sn7E5rrA6P0ZLjYu8HdRPstv1okB/V8fsWXe6KKzta6qodpTBp8j?=
 =?us-ascii?Q?8SMM5+WGKrIST6ZXxEP8NUBIIgpj1cB7CQLxicTMrR4OmY0X50n8ha9dsNxn?=
 =?us-ascii?Q?paofGLmvdmdN+CIqcpwD0LB2/zTsHn0R4VF006g4iyui1CBxNAhAy3fvYx1g?=
 =?us-ascii?Q?QORoHZ2CMlj5iGRjoBrdH1NrcoFnLYOUHhRgCpC+OFj47Nw8iZGeCs3vLQ/r?=
 =?us-ascii?Q?/yJEsRc53RzMueIiNs15tFHwjl2+NlmdE1ECG2lhGTTsvYOlMbwn9rn632Ct?=
 =?us-ascii?Q?ffgPpXoRbh/FfVybvSRV0UfzxSO/P4vf2zutDUXPWiwxXpG+XxguJDC+p6Pj?=
 =?us-ascii?Q?3yefGh/CuwnfiLFBnSZuJSAJOJQOZ3QJHGvoeODnZzv2ny5DS/pau1+EItIi?=
 =?us-ascii?Q?PM3LbOORRvww179LAgAxo2FbQNMfd6ONHx5KbIP0IYz0ou5uM8XYuTPJZtlh?=
 =?us-ascii?Q?3ygzUXBhOsRvZRq3z0xQdjK6kyN4YylsNz67VpsRHHOGTB0UVykT8GXtVjz/?=
 =?us-ascii?Q?ovZT4AM0IrDDaqlI5GebwrC/qXbeiE76dVOBOWp9wE5/agRfQbkj7EIAf0/i?=
 =?us-ascii?Q?R88ffmbsOSsLUKJyhuWOdz7GFCw6sIUOe2zT7VQAdHRoFtGkwwWAegQnmfkP?=
 =?us-ascii?Q?bZTs1jNwbDItgxmwsS0j+jlcXVv6HTsey8rhtW6nmM894lrQifrtP/aYfHAv?=
 =?us-ascii?Q?PDdYlsf+3bcwv38VfTShqxoCAshx2KKJS/Q1moTM4XsGnK34rdFNjvI8B/nj?=
 =?us-ascii?Q?wseDiLsdlsEb2eMHA2vO6Ur1y9YLgM1tZHdtb15eBdDxV3OwZtWHgGmhxIVj?=
 =?us-ascii?Q?+dvgnTnEacazi3I7fYkwXw623l/fVimqC6GmGEuFmCoBs+5RzwhaEckqkJbk?=
 =?us-ascii?Q?IeM8OE3isbJ9CHcAcM705HXH4eoq58DiHAq7PUYk/X67bxOzf8tMjqGDNiHE?=
 =?us-ascii?Q?q6OaBu2re20+tGjg/xqO0il4IDl/FPk428xUF4qeZbOFmIchwY5smlaIu1d/?=
 =?us-ascii?Q?qYTNdcJPSOLECT2EJRsAddsiPj6RM8m2Jtkw9W26FwBfKzA0wspX/F1XaPQm?=
 =?us-ascii?Q?uk2MGOGiVwiqZhfQdFGuKB3edOQmWx23QZR1lhrKkCPhbaU0WHkHQn8A5bX/?=
 =?us-ascii?Q?/w80O7mcEVqJ4SmYz6jTvjW9skJqZ8BNjyl0stEEbaCVjik1uH+LS+bhPBpP?=
 =?us-ascii?Q?ntt/sRxCmiORAKEBEwWeL75SHwRHhuBCQqNzDbP0K9o4OyV4mM0NiD9HCGzt?=
 =?us-ascii?Q?1KlDstrxmggobZgH5jPAc0DS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB5933.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aed96a3-f667-4a98-ee1f-08d94da26920
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2021 06:23:39.2367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BgXbuR4WjLy4ahTJzj1nNWGuF6OiDTPaZltS4oEoQTxIwQwk4SebOm/c+HTCi39DLT2t3t/GTExOa+2L93BdpINDOWu+HBIBuZ1PzaVRdqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5353
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

Thanks for the feedback.

> Subject: Re: [PATCH net-next 00/18] Add Gigabit Ethernet driver support
>=20
> On 7/22/21 5:13 PM, Biju Das wrote:
>=20
> > The DMAC and EMAC blocks of Gigabit Ethernet IP is almost similar to
> Ethernet AVB.
> >
> > The Gigabit Etherner IP consists of Ethernet controller (E-MAC),
> Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory access
> controller (DMAC).
> >
> > With few changes in driver, we can support Gigabit ethernet driver as
> well.
> >
> > This patch series is aims to support the same
> >
> > RFC->V1
> >   * Incorporated feedback from Andrew, Sergei, Geert and Prabhakar
> >   *
> > https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpat=
c
> > hwork.kernel.org%2Fproject%2Flinux-renesas-soc%2Flist%2F%3Fseries%3D51
> > 5525&amp;data=3D04%7C01%7Cbiju.das.jz%40bp.renesas.com%7Cb01d51eb444247=
6
> > 149d608d94d52d7c9%7C53d82571da1947e49cb4625a166a4a2a%7C0%7C0%7C6376258
> > 40484693261%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMz
> > IiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DM6biLbregS1y2R%2BMN=
b
> > b5PRRvgQxympZfHZkbuH0ZrXI%3D&amp;reserved=3D0
> >
> > Biju Das (18):
> >   dt-bindings: net: renesas,etheravb: Document Gigabit Ethernet IP
> >   drivers: clk: renesas: rzg2l-cpg: Add support to handle MUX clocks
> >   drivers: clk: renesas: r9a07g044-cpg: Add ethernet clock sources
> >   drivers: clk: renesas: r9a07g044-cpg: Add GbEthernet clock/reset
>=20
>=20
>    It's not a good idea to have the patch to the defferent subsystems
> lumped all together in a single series...
>=20
> >   ravb: Replace chip type with a structure for driver data
>=20
>    I was expecting some real changes on how the gen2/3 diff. features in
> this patch, but I only saw new info having no real changes where they wer=
e
> needed and having the changes that did not need to be converted yet...
>    Anwyay, I have stopped here for today.

This patch is a preparation patch. On the subsequent patches[1] [2] and [3]=
 you will see the real hw changes wr.to gen2/gen3. Feature bit is not added=
 in this patch, but on the subsequent patches. I believe you haven't review=
ed that patches yet.

PTP feature and the diff between gen2/gen3
------------------------------------------
[1] https://patchwork.kernel.org/project/linux-renesas-soc/patch/2021072214=
1351.13668-7-biju.das.jz@bp.renesas.com/


Features specific to R-Car Gen3
--------------------------------
[2] https://patchwork.kernel.org/project/linux-renesas-soc/patch/2021072214=
1351.13668-8-biju.das.jz@bp.renesas.com/


R-Car common features
---------------------

[3] https://patchwork.kernel.org/project/linux-renesas-soc/patch/2021072214=
1351.13668-9-biju.das.jz@bp.renesas.com/

There is a review comment for making smaller changes.=20
what do you recommend after going through [1],[2] and [3].=20
Please let us know.

Regards,
Biju


>=20
> >   ravb: Factorise ptp feature
> >   ravb: Add features specific to R-Car Gen3
> >   ravb: Add R-Car common features
> >   ravb: Factorise ravb_ring_free function
> >   ravb: Factorise ravb_ring_format function
> >   ravb: Factorise ravb_ring_init function
> >   ravb: Factorise {emac,dmac} init function
> >   ravb: Factorise ravb_rx function
> >   ravb: Factorise ravb_adjust_link function
> >   ravb: Factorise ravb_set_features
> >   ravb: Add reset support
> >   ravb: Add GbEthernet driver support
> >   arm64: dts: renesas: r9a07g044: Add GbEther nodes
> >
> [...]
>=20
> MBR, Sergei

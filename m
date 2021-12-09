Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9436A46E9F4
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 15:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhLIOcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 09:32:07 -0500
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:42862
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232331AbhLIOcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 09:32:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQ91Ypqr4yZXq/hwAr93nS9ei/DSpgA7btRqJNl4QsPH3Iyz3X6vsXDGjrCSw3TST9EFf2D3fddrPJ+HpIen3oq75HBOrGRVzdG7Z7oZtUCm3+e1hXzsp9tvHGCk/hBab0dR7NPOReiLe1q3ZoWCOCwBWvO/spvatpOYnpINfAnoosimRcgykmuUiUH0Imen2qRs0sFp1tVcTNhry3Ss8Ye+TlJ8T6hnRskBfm5n1L4E0PdmcU+xa/5mz9P2J27pB/iX52OHzTRUFFXpsy541cUDBeP6Gs9fKDFqf+jr3D9s79eJa60X6H5/kNws98GJIM28yYV4+CWGtp6ylu/yIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CnwMnKYSiFu+c6Ks5yGZ24CK/GPpQs6857MA35uX8M=;
 b=EUpq07Zc7f1L9l1VtorG/U+8KKUfWxfcWdO1VHE+MMtvw55mBV/09IZUvkkIEb/BlXyxk273HCkAS7miuZ28QAAH0AYGJc2sPFOKFvlssu6/7POIkYojsoXIbfvVhEbILVgkzn38iHACtP8peI7oFw6wwR76yWuvYNUhc+r7V5gTfIWPFpBumL7cM+BFlUgRGvqagb1zCKzCFePkAQvDliKKTb9zVel2IpDPpbEYGJvTK8eePVON1Q1vEUyI+aHbGyhLlnkUlzIsBDVrIi2/8o1hQ0ysvMhpgY5wgOXEGgQMrvFHQ42s1YCDU80kA+S89SnYYD0vav03VkchwaRV3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CnwMnKYSiFu+c6Ks5yGZ24CK/GPpQs6857MA35uX8M=;
 b=aRESaKfJgHEyfxgvulb8jGE82jMXMYhloBdxPxtA+UNomFvstrCb62ONptenO6dfNYnSiCmJf8WIh+AckjXemg+zlTWYQ+lI6ne1WMPESVd0ffWSnncP/cg7Xw/vtY2TRden/lK6Af/a4AIiDX0NkfiGbkj3TMzxwAsYVGZFmZo=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB5795.eurprd04.prod.outlook.com (2603:10a6:208:129::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 14:28:31 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 14:28:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 0/7] DSA master state tracking
Thread-Topic: [RFC PATCH net-next 0/7] DSA master state tracking
Thread-Index: AQHX7IOEQ9VmgGohuU2xLWeadphC86wpelqAgAC+sQA=
Date:   Thu, 9 Dec 2021 14:28:30 +0000
Message-ID: <20211209142830.yh3j6gv7kskfif5w@skbuf>
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
 <61b17299.1c69fb81.8ef9.8daa@mx.google.com>
In-Reply-To: <61b17299.1c69fb81.8ef9.8daa@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85eda305-cd23-48eb-06ca-08d9bb202c82
x-ms-traffictypediagnostic: AM0PR04MB5795:EE_
x-microsoft-antispam-prvs: <AM0PR04MB579542885B329CF30177E09EE0709@AM0PR04MB5795.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pjPX3nrNFT6L2VbKsavpRmu1EIphobY5sbH9Zu5An1FczYYAOe5V/Eo5qUNjiNqqm4YksQY/9GIzSzDXUpiIcWO/IgTytC2QJLQKtnzOwa2gM0/zcJusxJuGGGKr/ovk5eur+UKk78fOFt7uAiKRFMquXKMEKMiNkYHfBcPW9KHkdduXGVW4IU8eU2i19G3UESfZdI/cvAcmAGChJSTVcGfSnKaJ8SFbs/ZA+9GeZtFBBSVOnu8EG+m5YSSQYAsA+JtZ+N2tVrDn5Khl0y/b+53FF677GCv8CFwtS0Z8Bn9xxOcI1BY9nT2SCGuzjxGjMCHBY+Kbol6IE1dZlRW5CDralgfz3xXYyvEb1fvphX4rfMOaS5ueIcRS0H4HxO7Rne/9ItDdx2QLDJ8Sg2mn3l6PyeknpoB1b4B3JMlmFVWwA1qyDJLso3kspFCufHYtt6N6T4RwG0NF3edzJYkfQv2hSB2c3ks98t2lfq0d3tXugavSN94YKa2ZYDGT7wDSri94FpBJRZn9yRY1MdEqGQDT8Rm+Qt0r86ugI1jnglRNtLxHzuGs8jVd6qVKxlkWIo1ugMOTQ+iJDWjgiAxnzntaBIdzf3d+Ao5Q2Ob1HWtRxnAtOLMDXZewGKcr2Z1c1ulgoq2J5gvMLbdvJa8AOLfP8T0fzAjfl4RV/sCIJ3mL06f3DwACy5UDyDiJan1/hQsXOuzo/O9XUf0EfkDSJ+sP4hU1Lcutd00RT+C6O754p9zvmjgt41rhdtVJgCxWmKpE3ebc1+D9hMbqmFEqb6qs1Bgz9SG660YZ8S99M2z+/JrrdfQVCfDW5IBgCO3Pg22T/GDdB3PoGsd8ABP4B59fUwmsepeMsX7jKWOGazQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(38070700005)(44832011)(8936002)(4326008)(6916009)(122000001)(38100700002)(316002)(33716001)(8676002)(966005)(6486002)(54906003)(508600001)(6512007)(86362001)(186003)(66556008)(9686003)(76116006)(64756008)(66446008)(91956017)(5660300002)(66946007)(6506007)(26005)(1076003)(2906002)(83380400001)(71200400001)(66476007)(10126625002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GIw5HKPnOawu6k696Z/rFA81drAHwXLNaFsoYtwXehYte/m9ujjq6I3/JjEs?=
 =?us-ascii?Q?q3GAhijNCCmZJ/7Sk2zmwN56o7z2+iq1enZXN+wQfnTAV4069hlLKDpJA+bK?=
 =?us-ascii?Q?ild5jJvvcAtzbtNm2W31rnA0U/qNs5N3vFNZ4XFDVS1uO1PPY6uIy/TJSLXS?=
 =?us-ascii?Q?YKcmIGqIUPPE1e7WDbJdbNyJcdfyVREvyuJwlTrkacybNpWrfR0v3BEnw+lc?=
 =?us-ascii?Q?yaNeSiKvDF7aXpodjMKCpGSQcb4BlNWh6U78TbsfiYCuF/+Mv9ZYCgTqhMHB?=
 =?us-ascii?Q?AuwGSv4ZhYvrBoyGhL9DEV1WPte6/5wiTpFwHDMQ04s5yl8VchiAYTqSSfjK?=
 =?us-ascii?Q?9AvnzXyo75gANh3jI5Oe7XBjvcWssQNgWrtp3jLGeVLAtIrMpCMNq/t2U+8x?=
 =?us-ascii?Q?1PrLySBdGmQNhb+AouBWE+C5dmurFieYAPeA3mWnba2MxoxRKtsnCLEI8iIZ?=
 =?us-ascii?Q?VfMzd10pISPIGb1Y6C9P4JdwsIDZbpjUcWU1XBKNHZL8xjVXnQqxAas/Wylm?=
 =?us-ascii?Q?HIA5YPGPb3eurZuKOfm2qQA+Wrct4tWfNvyLpS9Cc7upolveVGptRWv9smi+?=
 =?us-ascii?Q?QyGd5iHSZ8P4z4oupmzpfKwnfpAmDqbf8xXuz51TC3MK6R5GAqqolTwTgicl?=
 =?us-ascii?Q?9OpwBA/dhFKnFO6td79EIEN7jb7jAql2Zd6SNE92LzlEhc5xtG+ff99P7AXL?=
 =?us-ascii?Q?DwxUmKqzItjYl6BqWCFZubaL3KQSHjt4lQqi8zQdHTzSiPYYB/C3a58Nq4Po?=
 =?us-ascii?Q?rs9fA4JYmQHzfTw8zAe1+TFeQP70opJGvndDmplUv1wFR3Ok4xnT2iVIxvFs?=
 =?us-ascii?Q?Xmw8DJdJpB2Mt3Jz4U09ffF0Cc12W/bC6g8I+lGisqtZYmr3hGWP0QBHnSR+?=
 =?us-ascii?Q?vtGaQlntJ/rkTB5geGFdefCM8SMTDsdXKfWIWfXrqzZoGJjbxzA1QxGh9TUp?=
 =?us-ascii?Q?zf2YjJXwtgIKbEB1KWu3ZYLc1tZsiRbw/Oas7sBjnhT2VyF/y8IhuUHU161H?=
 =?us-ascii?Q?pVBndpKOaY/a2oR6+tAh1FqcHqHhlBUN8L9t+iaFtXxezc1f6yApJ2reexzx?=
 =?us-ascii?Q?IYcGxYgiNUiLgrwfH6HUTcc0P+W2gjlokjcQpFPZ/2C2CRn0P6gJnMiH5MW0?=
 =?us-ascii?Q?phVTQ2eU5aBT6jT0Y4geysiJc61U7EMYxcAJFoKhL3Np5L1v+7y/4RtbTVvm?=
 =?us-ascii?Q?Fz1HLj9G0BYUoM65FpeQkjJ0saXJlRTys8o/FK617UyTudSrN/LsfmKLx2ve?=
 =?us-ascii?Q?Qurf6O7ZDHc1rRpfvQeEx+OiE8LIpUjuicqgu+IjPrDlEZE65n4Jz9pxuqWo?=
 =?us-ascii?Q?DFrK9BA+Y17fwXVfFAGWp7Km0OXs7ld4cxH0/ZZ2Ss7/e2lsZFxw/k1p/QwQ?=
 =?us-ascii?Q?2f50a+FbLoK6B1476sWPgQ2Fvq4WP2kofHhzQ+0+XSWJiNwQEyt3KYWD3i1r?=
 =?us-ascii?Q?m9Yr5onoh5wsIVmvguSOWNhpi9GGKOlDFCeTG6fyvJghj+4aTRWf3KxPAG06?=
 =?us-ascii?Q?09NnZv2BGrGAYn/oXI1lOKNlF/in+CYYRXWbomw68Y1NeOHFOkLrwCQMxdGC?=
 =?us-ascii?Q?VK9lBe3qh3V3eYMgix+KVJ/VfdgSjSqH4OLvCGjS3O32EMD2Q51Q1LaBM4v6?=
 =?us-ascii?Q?YC7HfphXtlFWuPfHTMOu2nM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E1ABB9A9A643F84E8D1A4A1190A8FC27@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85eda305-cd23-48eb-06ca-08d9bb202c82
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 14:28:30.7823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mL9+jwcIjnY8lSmaEHCRvoSrFlK4iOT7okjulDMjvsFSqerCiElFmOB9zgqUbgX69py1vv4sUh99YIpSI9Srqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 04:05:59AM +0100, Ansuel Smith wrote:
> On Thu, Dec 09, 2021 at 12:32:23AM +0200, Vladimir Oltean wrote:
> > This patch set is provided solely for review purposes (therefore not to
> > be applied anywhere) and for Ansuel to test whether they resolve the
> > slowdown reported here:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.744=
4-1-ansuelsmth@gmail.com/
> >=20
> > It does conflict with net-next due to other patches that are in my tree=
,
> > and which were also posted here and would need to be picked ("Rework DS=
A
> > bridge TX forwarding offload API"):
> > https://patchwork.kernel.org/project/netdevbpf/cover/20211206165758.155=
3882-1-vladimir.oltean@nxp.com/
> >=20
> > Additionally, for Ansuel's work there is also a logical dependency with
> > this series ("Replace DSA dp->priv with tagger-owned storage"):
> > https://patchwork.kernel.org/project/netdevbpf/cover/20211208200504.313=
6642-1-vladimir.oltean@nxp.com/
> >=20
> > To get both dependency series, the following commands should be suffici=
ent:
> > git b4 20211206165758.1553882-1-vladimir.oltean@nxp.com
> > git b4 20211208200504.3136642-1-vladimir.oltean@nxp.com
> >=20
> > where "git b4" is an alias in ~/.gitconfig:
> > [b4]
> > 	midmask =3D https://lore.kernel.org/r/%25s
> > [alias]
> > 	b4 =3D "!f() { b4 am -t -o - $@ | git am -3; }; f"
> >=20
> > The patches posted here are mainly to offer a consistent
> > "master_up"/"master_going_down" chain of events to switches, without
> > duplicates, and always starting with "master_up" and ending with
> > "master_going_down". This way, drivers should know when they can perfor=
m
> > Ethernet-based register access.
> >=20
> > Vladimir Oltean (7):
> >   net: dsa: only bring down user ports assigned to a given DSA master
> >   net: dsa: refactor the NETDEV_GOING_DOWN master tracking into separat=
e
> >     function
> >   net: dsa: use dsa_tree_for_each_user_port in
> >     dsa_tree_master_going_down()
> >   net: dsa: provide switch operations for tracking the master state
> >   net: dsa: stop updating master MTU from master.c
> >   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
> >   net: dsa: replay master state events in
> >     dsa_tree_{setup,teardown}_master
> >=20
> >  include/net/dsa.h  |  8 +++++++
> >  net/dsa/dsa2.c     | 52 ++++++++++++++++++++++++++++++++++++++++++++--
> >  net/dsa/dsa_priv.h | 11 ++++++++++
> >  net/dsa/master.c   | 29 +++-----------------------
> >  net/dsa/slave.c    | 32 +++++++++++++++-------------
> >  net/dsa/switch.c   | 29 ++++++++++++++++++++++++++
> >  6 files changed, 118 insertions(+), 43 deletions(-)
> >=20
> > --=20
> > 2.25.1
> >=20
>=20
> I applied this patch and it does work correctly. Sadly the problem is
> not solved and still the packet are not tracked correctly. What I notice
> is that everything starts to work as soon as the master is set to
> promiiscuous mode. Wonder if we should track that event instead of
> simple up?
>=20
> Here is a bootlog [0]. I added some log when the function timeouts and wh=
en
> master up is actually called.
> Current implementation for this is just a bool that is set to true on
> master up and false on master going down. (final version should use
> locking to check if an Ethernet transation is in progress)
>=20
> [0] https://pastebin.com/7w2kgG7a

This is strange. What MAC DA do the ack packets have? Could you give us
a pcap with the request and reply packets (not necessarily now)?
Can you try to set ".promisc_on_master =3D true" in qca_netdev_ops?=

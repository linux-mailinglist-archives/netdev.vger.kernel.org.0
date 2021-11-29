Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F3F461CE8
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 18:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349625AbhK2RqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 12:46:00 -0500
Received: from mail-db8eur05on2076.outbound.protection.outlook.com ([40.107.20.76]:28383
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348315AbhK2Rn7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 12:43:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrOsxrFiMh5i+5QHDXiKtgH987h4GJa/TU40EPR+oZdYeAMimldeF7sQYkgpleEeCKhsvjAU3PylvgCjPeawJyAkrzspRnQX/W/U9qsFr9gGKmfUpj9MT9ckGjuf0NCx+rS3XY+9T3X5sJ3kexSpQC8Vz6KU33LZ/7/UuHuPUZ4aDflTygNme8ceY2Ili4U6GMrXeIwsQpNokTh8YzJHE3Pq202oI9whA0kX1D/KKInok8a/d5mNMjZmBBAK5ZFtAeVy0zH6rZKGh6LFL/ma56lVXzxJn+Ro9wJjtCTX4MoxyLfZte/THpfogOLTb31LMrtsAGztuZVMtyfaHZl1+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZVA6hSvr3g/R6KBOBzSISLV+XkrungaIWZqxjljSv0=;
 b=FFSqPmjCPwvJRKocMIuPYrmn21t9UEDcp8TUm6Ia6rciE1ba7fWrMnZj7dMKbcDiwWQJsby0wuPpZEEFmYiDaNl54EpYUFGG9tyiqmjQCBNo3N4aiXQ/fVJYR8rw60yfdevWLYVvxL2rxFrF89gqm0NRoRe1tc13ZZL5FMDXlLPfhJYZZGoGRKh1sMylpennPjnL7ymINoZDzjalmlzXZhAuRXWvkBpDFYbSN0uqq+42h2UG/JOhaVCh2Euys3b7QEJlakzcTK3JrcenAYc7V0aVawOMZLTYVerU84usppF/9D6Ht1gE0eyy7HfSxsCtVlSYqJMK1SMtdYlHLYZkyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZVA6hSvr3g/R6KBOBzSISLV+XkrungaIWZqxjljSv0=;
 b=rvTly8VNFRJAFsaKwesfF9wGyrcspGvXJpiJ7Y9iRAyZL96wqZgrdtZtMBVWEj1kSI0/xEU/Xmbw1qaBreX7clVe5KPQ0Mm1rNXEjlj9xkC8aNtL2mz61VWSKf9QiABeufAlOctOY08XEpL1F04jdrm9YUi7KoZyegkPTmj82fE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7470.eurprd04.prod.outlook.com (2603:10a6:800:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 29 Nov
 2021 17:40:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 17:40:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v3 4/4] net: ocelot: add FDMA support
Thread-Topic: [PATCH net-next v3 4/4] net: ocelot: add FDMA support
Thread-Index: AQHX4ur0oKFzimZda0eyFp+wSrHWQKwXeIeAgAK1KwCAAJzpAA==
Date:   Mon, 29 Nov 2021 17:40:39 +0000
Message-ID: <20211129174038.gptbivgmbqzrrgtz@skbuf>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
 <20211126172739.329098-5-clement.leger@bootlin.com>
 <20211127145805.75qh2vim7c5m5hjd@skbuf> <20211129091902.0112eb17@fixe.home>
In-Reply-To: <20211129091902.0112eb17@fixe.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7e47792-3302-419d-df6d-08d9b35f5be3
x-ms-traffictypediagnostic: VE1PR04MB7470:
x-microsoft-antispam-prvs: <VE1PR04MB74704B44ABA328B053FE887AE0669@VE1PR04MB7470.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XBBiOLsCnbxwpBdQ6X9exg9aX6Fd2LTgrAFq/2vYFWWjCFXoI9tCd7cqtnLSxzERD61PlBXULlQX+hMbzuIe54siZCFiwXMTIgj5ii6yYpC7cUgr8ZR/pEB48CRZWX4cKxsiPyMDzw+skffbnisCzRGveK1juqJE3uChXPiXZbeENVccDNcvII/IYxHxeP3GiZCU0hlNVCQIaon38fiiVV5zG61NTDqG/jVgfGqyvXcuDfN9oCJQFPk51S2fqGGsZKkjAFwZVf7XzhLN7htAD7bntJk//tXSNNPs/613JUpj4i8RpPshN1nzdzy8QKmrxKXaMSkVo4tmO4eUhPGgq8zsBiXtWS/WbZgJv+1h8B7kI4fjizzgofA47OIhprMbLEdUUfFCp444WJ9lsUQ3Z+HyCdVIE7ft8SRc5bRHyqu5J3vds1/kDzok9jqzjbhKtuMFf8kNgOsmBDeZUTdSrYyOqz5dR6M1zmdAuyYQdJxPiQoUOxYDhOuSeQff+dGx6AXOf3jsPN/jAI6qc/BdLSXuoY+sOE9eQguiQSWbQE2nifLXmaAeZi5Bu6cak8fA8TtfPZ3hdQUR8P5e7sLr2CQ1l7tiO4/MFJiPbN28+RM1reRHCFX+GtCOifJ6JtxVL4VT+P9F49E/yFOy4nSPQJh+gjAx65sMb0+Ll09s9Qv9uydyaERxffI2uNcRK9ndBtIpuACRcvXhEKjGU6IsBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(4326008)(33716001)(7416002)(38070700005)(6512007)(71200400001)(9686003)(122000001)(186003)(38100700002)(26005)(3716004)(66574015)(8676002)(8936002)(2906002)(86362001)(508600001)(83380400001)(6486002)(54906003)(6506007)(1076003)(5660300002)(66446008)(316002)(6916009)(44832011)(66556008)(66946007)(66476007)(64756008)(91956017)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?u0jHV5pAS4Qu8GAkrHKAsgc4zsXZwcM/W8eYa5cIqkC/X36mQKr15WMP+P?=
 =?iso-8859-1?Q?EtXAsB2ZRTsqtkFA/B2C4lXRmdX44iMalzWZSfe5UEAe2xQ0CV9ctbdzlp?=
 =?iso-8859-1?Q?fzNngwJfVkPZDr9iZdIv3AzGjyWBFrD/kzi45xYCN5TdGkduvVAFsf4WHD?=
 =?iso-8859-1?Q?8vTf8d15cuOnjHwgwMG9CBKgz94W2d7TTVQMmkBxpyfKs1L7KJ8PJ3vHX1?=
 =?iso-8859-1?Q?Za7JqCM2nBnwJ0ilRooUPaQ9ZaZ7dCpvKMfv5wDiAh8Zyh2IkqrybNS6Kw?=
 =?iso-8859-1?Q?kT4OYFlZUesEFlE46FEniQo1logJ5dxQOm1rrgWBWvtOeTG6c75fGS67NJ?=
 =?iso-8859-1?Q?GhGXP0nYd4382EmESRZTfpsaoQEpj7AGlIEu0Wt1+1RrE2K0ysnXOqMRfz?=
 =?iso-8859-1?Q?gS6lCOcMRJlYnBfd8JtulYcFX2LE6XEn+5eL9GVGD4JTbZKQ6coyfzqFEK?=
 =?iso-8859-1?Q?VEZa0+jzN8xUCxEe6OyRg0787Q9T4l0uhEM5sAR1fd9m9+8F9oEIYTBVe0?=
 =?iso-8859-1?Q?WUsk47enGQOZ/gPg73CwdH6VFObwth9dbP0um8iGlAMAbiancD/uKhWwPG?=
 =?iso-8859-1?Q?UIPVQLt0oWPIjn05EudM+PcL6so6aRXeFXX6ym32gPvXuW0RbEamc0Z5dr?=
 =?iso-8859-1?Q?KS0Mvq0iqkJ+gSXUVM1pvzKvOwcUxswdCFIvU6JfzwwrXS+MukN5Zp1oko?=
 =?iso-8859-1?Q?BAy9RfoC3QhpgGPstGpoqyz9E77UUtUZIsCAD1+wShzY/IAgdiauzpexHp?=
 =?iso-8859-1?Q?LfJon/nDlW2MBkOcZUhdZ0Ycq298euuOMVhifIyvxIsQpyo+/WJ4NHSqxa?=
 =?iso-8859-1?Q?tabsDSD4WpBgk6R6qrJYvhWhtykNHrnPVTjRQ3lqWMgMfPJLbpk5d2cRZJ?=
 =?iso-8859-1?Q?DsuUEoKnkKBPph5OIGhP/3SkOB/asMwKOw/yGQoKSL2OxYdS5XLw/7keAR?=
 =?iso-8859-1?Q?WW+2lp1908OR3ifhJOn+4AgSHPMCBN5ppM+91/O9+H4DXkjqH/68gaW2oz?=
 =?iso-8859-1?Q?tlXVg4YC5xYjQigfbXAXRC3gAskOpubH6P3qdn1UXYHRFRwc27hSDRkh/e?=
 =?iso-8859-1?Q?7CvNdvh3JIlJz214FEee2XuPM7hTYqB1//97tSJy1IGbz9EERgdSjG73lD?=
 =?iso-8859-1?Q?1rLeGuRtZ+vfnrvIqiZnNzY0VTC4p+wiZQpht18Y2WIL3mgrcDMB7h0d4t?=
 =?iso-8859-1?Q?BrtuLG2yBVqgJUqWKdMkT6ja07t6U+H9Cr55ytV24Grs59kJZs7fd1s395?=
 =?iso-8859-1?Q?ST6R+8QxHKPBO7VqWNh98dC8y3tZRN5gYCQUTOy37T5KKh3O7hw+JaTvYY?=
 =?iso-8859-1?Q?W3NMpOENrYVuoyU8kSB9cmAlGaj2T7CVQEG1/pyskth0SPjwJB6s5LGuG9?=
 =?iso-8859-1?Q?BdJMdWVGDZTCOaTQwTNgF48iUG0nhQvtqmmo+qtzzA3X4rAcWydiHZaLIp?=
 =?iso-8859-1?Q?+GRSblLKpl28nhjKl5UbyJkLNKUajyrTnX81v19LRrVqSvFhKD25cHpS39?=
 =?iso-8859-1?Q?/+1VWqO7ZMcloiZk7JZ7X/x/QranORd7yGjXI3gr35xobCj3EvD85rxMKa?=
 =?iso-8859-1?Q?fbiyMUwUDzVnSu2CkpsjU+8Lekrl1/5X7TbvIG+tOD1zivqpliVkoB3mtu?=
 =?iso-8859-1?Q?Odwre2+rARGGMitl2bkHyX3gCQbHNC6GVGlQjtpjzPoVQ01Hu8imVTnuAo?=
 =?iso-8859-1?Q?bWAKJ19vZ/ozmYYTCKM=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <8469D342D3D67D49AAA34A6D424CD819@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7e47792-3302-419d-df6d-08d9b35f5be3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 17:40:39.3042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQsoWgES2we4kgsDNvkwvlxE7lTyP6LsczDJRHRbqJurKH6pr3VZWpJTP2LKmUlVcqjDXkmcr3gkE0QvBQMoVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 09:19:02AM +0100, Cl=E9ment L=E9ger wrote:
> > I'm not sure why you're letting the hardware grind to a halt first,
> > before refilling? I think since the CPU is the bottleneck anyway, you
> > can stop the extraction channel at any time you want to refill.
> > A constant stream of less data might be better than a bursty one.
> > Or maybe I'm misunderstanding some of the details of the hardware.
>=20
> Indeed, I can stop the extraction channel but that does not seems a
> good idea to stop the channel in a steady state. At least that's what I
> thought since it will make the receive "window" non predictable. Not
> sure how well it will play with various protocol but I will try
> implementing the refill we talked previously (ie when there an
> available threshold is reached).
(...)
> > I don't understand why you restart the injection channel from the TX
> > confirmation interrupt. It raised the interrupt to tell you that it hit
> > a NULL LLP because there's nothing left to send. If you restart it now =
and
> > no other transmission has happened in the meantime, won't it stop again=
?
>=20
> Actually, it is only restarted if there is some pending packets to
> send. With this hardware, packets can't be added while the FDMA is
> running and it must be stopped everytime we want to add a packet to the
> list. To avoid that, in the TX path, if the FDMA is stopped, we set the
> llp of the packet to NULL and start the chan. However, if the FDMA TX
> channel is running, we don't stop it, we simply add the next packets to
> the ring. However, the FDMA will stop on the previous NULL LLP. So when
> we hit a LLP, we might not be at the end of the list. This is why the
> next check verifies if we hit a NULL LLP and if there is still some
> packet to send.=20

Oh, is that so? That would be pretty odd if the hardware is so dumb that
it doesn't detect changes made to an LLP on the go.

The manual has this to say, and I'm not sure how to interpret it:

| It is possible to update an active channels LLP pointer and pointers in
| the DCB chains. Before changing pointers software must schedule the
| channel for disabling (by writing FDMA_CH_DISABLE.CH_DISABLE[ch]) and
| then wait for the channel to set FDMA_CH_SAFE.CH_SAFE[ch]. When the
| pointer update is complete, soft must re-activate the channel by setting
| FDMA_CH_ACTIVATE.CH_ACTIVATE[ch]. Setting activate will cancel the
| deactivate-request, or if the channel has disabled itself in the
| meantime, it will re activate the channel.

So it is possible to update an active channel's LLP pointer, but not
while it's active? Thank you very much!

If true, this will severely limit the termination performance one is
able to obtain with this switch, even with a faster CPU and PCIe.

> > > +void ocelot_fdma_netdev_init(struct ocelot_fdma *fdma, struct net_de=
vice *dev)
> > > +{
> > > +	dev->needed_headroom =3D OCELOT_TAG_LEN;
> > > +	dev->needed_tailroom =3D ETH_FCS_LEN; =20
> >=20
> > The needed_headroom is in no way specific to FDMA, right? Why aren't yo=
u
> > doing it for manual register-based injection too? (in a separate patch =
ofc)
>=20
> Actually, If I switch to page based ring, This won't be useful anymore
> because the header will be written directly in the page and not anymore
> directly in the skb header.

I don't understand this comment. You set up the needed headroom and
tailroom netdev variables to avoid reallocation on TX, not for RX.
And you use half page buffers for RX, not for TX.

> > I can't help but think how painful it is that with a CPU as slow as
> > yours, insult over injury, you also need to check for each packet
> > whether the device tree had defined the "fdma" region or not, because
> > you practically keep two traffic I/O implementations due to that sole
> > reason. I think for the ocelot switchdev driver, which is strictly for
> > MIPS CPUs embedded within the device, it should be fine to introduce a
> > static key here (search for static_branch_likely in the kernel).
>=20
> I thinked about it *but* did not wanted to add a key since it would be
> global. However, we could consider that there is always only one
> instance of the driver and indeed a static key is an option.
> Unfortunately, I'm not sure this will yield any noticeable performance
> improvement.

What is the concern with a static key in this driver, exactly?=

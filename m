Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67062363E3B
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 11:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbhDSJIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 05:08:00 -0400
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:1734
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232023AbhDSJH4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 05:07:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXL0Icjx65983w05GF3KRbauaC4w8RYhNZ0eQNB9CnSJrNNnfA+rc7qgozhUrVXn+kOjgiTGGaMvL2YQHgoPuyFKDzogxlBKi6aYd+bGASudnsI6nZ9kmT/TOjQ5YcDxQNiFmwT297dvGPfn/otc8lRMqwG/unJveqSxkGBGuAOXDB/jnalxuqVS91ISEzb00GNFezMBvJyhRig/A9ItpIGN0KPZEs0Z54slM8Rtd09UFFfSt9jLPjQFXPrN2CT0DgPM0mkWLLP0oDafYCfkGbAU41KTBTBGV1VPqsxJid7ujFxHPkuk+/Jfw66GsoDF5vU95Dv2U0FFdXCpCLU94Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HUvKHNom/owTJM5x3vFAK78YrrSqtcaoWP8GO86fl8=;
 b=F7uXcQwpHIZqmG8KGXwQzdPXhl+LzObW9wjrB4LRIwt6mi4LOOnahapw8OasPcJZuS+/LoDRYlM0d1tLX2mrD7nt3gc9Qlngy0DBAVLmM29157pTMNs+fk4MDXj6KItNv33obxkYnbMjbmg0NHI0tAEcFCL+BIPPmg0BgBh2sWosTC0J/FDLEKSnpEEvBZra6r6o1Ooq25W+svauKIYCzh9vxP4y7t5FI4dl9a8KQ6FrADyOGOx/Kv6mybyLQjI39pA2+Ngwj4I0SV9eBo49nCMjRxabelYPj0YtLMEf1bD9I7TRsIW2kUOE/mBuvwlLPC0jSHpqJU7m2SvaQjMZTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HUvKHNom/owTJM5x3vFAK78YrrSqtcaoWP8GO86fl8=;
 b=CooFX3rvKZKZoxbrOU0f68oyroxGqdtnxdPQImjZ7WMeTQqhJ2eBZXclHEE8nzW9Y62WKvtOmcjPgp083nNDIcAQSGoGHJt7Ac7vZ4u/vyf3gxbrrHU5jsv95sxkgEqEczGbX01QCHBn6OxdBaSTv66Z9XxxRPwstz91+nVaYJo=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR0402MB3331.eurprd04.prod.outlook.com (2603:10a6:208:1d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Mon, 19 Apr
 2021 09:07:23 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::f12c:54bd:ccfc:819a]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::f12c:54bd:ccfc:819a%7]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 09:07:23 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>
CC:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next 5/5] net: enetc: add support for flow control
Thread-Topic: [PATCH net-next 5/5] net: enetc: add support for flow control
Thread-Index: AQHXMxpZEYIxiwunrU26djqgH5Ni/Kq7kFUg
Date:   Mon, 19 Apr 2021 09:07:23 +0000
Message-ID: <AM0PR04MB6754B48B5F0C5B166783680696499@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20210416234225.3715819-1-olteanv@gmail.com>
 <20210416234225.3715819-6-olteanv@gmail.com>
In-Reply-To: <20210416234225.3715819-6-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79b64bdc-6167-42e0-d9ed-08d903128b91
x-ms-traffictypediagnostic: AM0PR0402MB3331:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0402MB33318D94110080498B8FBF9196499@AM0PR0402MB3331.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Eo7jfkSpBgxFFHfGWX+qaoICZRS6hq0FgomraVVqIemRH5ZDUwhKHLqmSbC/Uey94J6RGP+VOyXljhnuJK5TCLVYVNfpESbsbNh/ioHG9i3Bx2p1Y0VsGKXlak73DTJf5vvyEdfmDu7HZswzuEjEdhmUtirys7C3iPsBo6LGE2mTVuET5iDEpac8spzedu7IaziEn6XOrmDAhHAZkEJKVyVp1zJ0vvD3ehhGvMnMFeSKKzXlZ6Llcvc/RHERYZ/p/3Q7H6GZqgepXtScxB9SInm5Wgs1E3eO/w+Ur0Bsj9e1Ws15q5xcVd3MMZMqol33OpdWpVzdeeCeaUqGFIwSKx7sKLV+Uf0ZV60AEKP7qz8lu6jsrC/N7AC4B2LfdV3bQKMcQ2YqwV34p6w2f6KEgPHf/vaM8Gjewq0O936OWRAlyHn5fDEKsgpBQTiETCq4CNXIDm2c93iTXrPX7b8Kg4a+XMbAF4RNoHlkcWpuaOCGiaYeUPTnZ0MaUluZdp1dtIKd5DE3POrZcbjydilanwVtWCQegNfOQd65kazhR8N3O7upHdW2nPllSwfKM6X+ZlSE8dDOsiga+lhYv4ji3D5egHcl8Z3TBcCaBKU6jFY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(9686003)(186003)(8676002)(7416002)(86362001)(38100700002)(66946007)(55016002)(52536014)(44832011)(2906002)(478600001)(66476007)(122000001)(7696005)(316002)(8936002)(6506007)(83380400001)(4326008)(71200400001)(26005)(76116006)(64756008)(66556008)(110136005)(66446008)(33656002)(5660300002)(6636002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/0QLZsoN5bKxcWQkhAX50DOxuh5HnRxfL4NYi1O/RkjbTOFH3xkqJ02adYeV?=
 =?us-ascii?Q?+NA1PD9URAbsrDIrdGTd33HT+MdA4U4BHDN3WmSuF5qIHyMSUsRogHrnwLTT?=
 =?us-ascii?Q?ex0irY/arkQBVpWHZ188okl8kDS2Vr7diK8d+95XoC92P29kgum5vhTDhZ8m?=
 =?us-ascii?Q?pUcU6IGwF/X7PqGde0ciEx9qVc+vaPjVjHyYr9YsUWyJP4bCoeOPNi0rM2CS?=
 =?us-ascii?Q?NEwvAV6Q5myPEI9YWKJ7PWLeQt/0PZGXhpBMEjMAeEg9XL6EPDKSfJa3eVgs?=
 =?us-ascii?Q?qEgiJ+Zj+EJpWxSWKJhmZ73tupLc6KEFGJyWOnjhBS3nMAHxuKoFThptznks?=
 =?us-ascii?Q?w1oNtbTPC18WCCFVwSwSXwLphGue2Zb1CGA8f3bpPEzb9EdqgpLx5aGs66Oz?=
 =?us-ascii?Q?z7SsXKTiOdPymgtybaANlCvOqbj4sx/3vAsnfOx6rqYEmX3XD76XXqdJhCiL?=
 =?us-ascii?Q?4dG0YWonFVcMp8/ST6Xjmjw0it0TcX7iV3ZVJaPuX7H+BEnaZzLr2MjcbUvJ?=
 =?us-ascii?Q?yl+iTOGzq8++Conju8g/2kkpK73vu0t/VhlUZaQYWJw2IIxpRqlBd5m0qzeL?=
 =?us-ascii?Q?xAI/xX7AscOSlBVDOD/nqevy5gTGJW8XZlUajJHK7YBBC+YtRDHEyfIBYoYc?=
 =?us-ascii?Q?EmEiBU6AGRR72Asit76rRdzxk9wMBwLZaFXYxfNhLKXx86hu/d0FmeutaZRf?=
 =?us-ascii?Q?XUlfs9Q6slgC2LaUCk2xJHZQi3Doawa51IZkH7bWt4Qn9CFWA14wCTyJ64Lr?=
 =?us-ascii?Q?2bCDs0vmpxCKMyhoebzLLb8bm9+uHzbHo9nNmTxKy/OGHVCTOhintD7HPwXf?=
 =?us-ascii?Q?ikNHfb0kG63r9Lnsr3CfuyIJ3CVV9GTsdWMK3avDL6huOCVFTBIyiF+bnBze?=
 =?us-ascii?Q?UYlR17AY89gNoahtc2qEjNlbgOn8uQbQy72Eg8rdCfBPju0epM58d7VnhAg4?=
 =?us-ascii?Q?ra+l6ABUvW7C9+uEIzJyIlu/5GzHrl6GwUwW9SF7gCztuISdKO1j70YpzKXd?=
 =?us-ascii?Q?sZ/PjV7z3h5rVSbW0TCgt1TRmBlXA4ikxm6Ir+RDSjE4HdacTarNVmOaeWyI?=
 =?us-ascii?Q?RM6mXLCXb0oLQfvp3ev9IiO7Ff2Nx7Xa9VPSP2JVnFbMsIxOiBr9W66y9/Hc?=
 =?us-ascii?Q?15HANNx/89Nk00Rpg7QZV7/XqHRGyXHWtXoZ4RSAnr1iF+KZS4f/cKfi8h9Z?=
 =?us-ascii?Q?5vVyD7OLfgl06o94jsZcvLCJ6HgdvwrShfn/jSoI5GaeSLgofDOzBMi2ynWx?=
 =?us-ascii?Q?Z0QLwAeyeNIdd9nT19pJTSoEksPCiepWnBn4hTdXqRiGGx4Udggsf9crjorM?=
 =?us-ascii?Q?VJ6NtXZ+IrAqi0Yd6RyQEK0s?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b64bdc-6167-42e0-d9ed-08d903128b91
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 09:07:23.4132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QQxb9t8NIeYPPzrrw92L6ggnn1/+wF0r5787D4vOoHqY6cy0D5aiNtQOC/baEre/vTBtCvhJfPzp10veYeddhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Vladimir Oltean <olteanv@gmail.com>
>Sent: Saturday, April 17, 2021 2:42 AM
>To: Jakub Kicinski <kuba@kernel.org>; David S. Miller
><davem@davemloft.net>; netdev@vger.kernel.org; Po Liu
><po.liu@nxp.com>
>Cc: Claudiu Manoil <claudiu.manoil@nxp.com>; Alexandru Marginean
><alexandru.marginean@nxp.com>; Rob Herring <robh+dt@kernel.org>;
>Shawn Guo <shawnguo@kernel.org>; linux-arm-kernel@lists.infradead.org;
>devicetree@vger.kernel.org; Russell King - ARM Linux admin
><linux@armlinux.org.uk>; Andrew Lunn <andrew@lunn.ch>; Michael Walle
><michael@walle.cc>; Vladimir Oltean <vladimir.oltean@nxp.com>
>Subject: [PATCH net-next 5/5] net: enetc: add support for flow control
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>In the ENETC receive path, a frame received by the MAC is first stored
>in a 256KB 'FIFO' memory, then transferred to DRAM when enqueuing it to
>the RX ring. The FIFO is a shared resource for all ENETC ports, but
>every port keeps track of its own memory utilization, on RX and on TX.
>
>There is a setting for RX rings through which they can either operate in
>'lossy' mode (where the lack of a free buffer causes an immediate
>discard of the frame) or in 'lossless' mode (where the lack of a free
>buffer in the ring makes the frame stay longer in the FIFO).
>
>In turn, when the memory utilization of the FIFO exceeds a certain
>margin, the MAC can be configured to emit PAUSE frames.
>
>There is enough FIFO memory to buffer up to 3 MTU-sized frames per RX
>port while not jeopardizing the other use cases (jumbo frames), and
>also not consume bytes from the port TX allocations. Also, 3 MTU-sized
>frames worth of memory is enough to ensure zero loss for 64 byte packets
>at 1G line rate.
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>

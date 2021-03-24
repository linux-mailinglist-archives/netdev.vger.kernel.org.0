Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43537347D99
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbhCXQVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:21:38 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:23778
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233111AbhCXQVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 12:21:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXM8SHhfCoBrxpdt5w6IpJGjadbap2xTod4z0+8bvWCP3sgZ3uSOLvYVGACwtlouFNvEId2V/h9vyunRbde1MVgj2cRd4rQ4uuxhk8GHtvnK6z8TbePDonF5zxiXcT3NszvC4j5+fvIzuU4yXt7XB//3Pzv+deOmadNfxOG9s9fGtlHfFVwtYPB5JS+XR6IS6fiLgPzNbZ6Wsx/Ya2qnFsg42jEK3YUB2MZkbWYBnY/FLuu5I6GtASOFLcu3jV3Fokh26iaEI2GRdfX7odg88Yj74VHYpHV/dBUQ8dgFGiYnkLk31PStKh6tFVYwBv832xs2hYsIGbW3bycUPI7D5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lu7+JorLC1fudWIqRhvOILyh9xXt645QCIAwIUUhwA0=;
 b=SXaOOTEe+oc9Jc+rZqrGJNhA9ptPJA5Cy2sIIX0PefSOWqFY/ZVIl0k9MGC5WEJR7u6C5UWBRdNLAzNa1mX1RCuy4xmqw0ZCgqodjDdfQHMgYYSPMkt2aBOBzAh7HaPGCKSdtH1x4A9XItczn96SldkZMzSmgppeKYRBqjnAPO0dJCrT8FLIlko5Zo75pRozLMyLV88G38aGGCsXwH6TxF6aJaJshsbqJ7GCU5Dx4JvazwWNoQrZZ6Q6HK3ZSQ12axJ7znw+VU8iXKnbNm8MSq+Ig8BCOMWSSMCLvDD1yBmgMwMbRsNp6Ab3nhEZrm+1YC2iA1FOBaNCG0fzulKJ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lu7+JorLC1fudWIqRhvOILyh9xXt645QCIAwIUUhwA0=;
 b=ofcO9VyBo4q1V0ktyKAN+qFcFCQV73/Bp9jjLM5edCbrgBumTmqS9sAMfs1bJTHdwjapDP8ixs/E2LwpDw8JddBxW2EFZHDOM5/Bb+UVrZLCbUm+yQksOhI3VyIuRrx7//FShhbmIWkYLYhRezGwnkGxKaRR9kjPaD7tCosHaOE=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB6084.eurprd04.prod.outlook.com (2603:10a6:208:13e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 16:21:11 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae%6]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:21:10 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next 2/2] net: enetc: don't depend on system
 endianness in enetc_set_mac_ht_flt
Thread-Topic: [PATCH net-next 2/2] net: enetc: don't depend on system
 endianness in enetc_set_mac_ht_flt
Thread-Index: AQHXIMSrvVN/XG6XaUyjc0hwaTBilKqTUb4Q
Date:   Wed, 24 Mar 2021 16:21:10 +0000
Message-ID: <AM0PR04MB6754A702666F9BD41310F94796639@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20210324154455.1899941-1-olteanv@gmail.com>
 <20210324154455.1899941-2-olteanv@gmail.com>
In-Reply-To: <20210324154455.1899941-2-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [79.115.161.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 81965790-2439-4456-4447-08d8eee0d663
x-ms-traffictypediagnostic: AM0PR04MB6084:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB608436AFD24C90C486B27FB896639@AM0PR04MB6084.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gTGIb/gVj0/AN8WHTpJ6oiChFkHt/5B/ElEiZl1izfBQisO23Jpki4TanjGkpyI3EcDDug5weRG2HdLpSpx0aGTarLZ7cOHXEk4Ctwga8+8DJvuU6Cb4xUBHiti8lyGTzvRMmSdgPilw5MdMTvUs2lPyKUoA6KxzYKh2XnRWvxzSDsBu2sNBuobFV/285qxd8J1vZdmiLOp6ttcAu/nrVQRrpa3Xy2L9DHpfMnMsRIePIrHkxbb2tEpETDqZLqzHHAkLa7HF53juYJ1l7qQ1KHtEHthc6zBHfMDqNKbULOhxDl6/BDv9btVip66SZQuN7VBBn91Ptj9QeLII7urD/mp2gfHxhLD3ADiQdvu0Z37BAjOyeuIm2NaXYb+T4N0gv1FY8TzJKdj6ZnRFGkw8iaXeswZCX7qIpAKWDCmTu7aLdpht66x2HEzD1anh5Mo2lbSJu5j+ysp+8qy40ONiO7IB1CedyrvzDRM0L9ktTja5exZqPV10YhgOxgyZlU1kiLx/HF8zaLAX+Fb3DzfAB8XeT4PdmIRQ/LmbleCgg3D+lBkuiZrd+QkuBebyfDI9zX4pZefTEKnvZ5cF1xzfBkHVSWN8JVaqu8HT89GD2gBNJXkD5C44VHio0AhNq8+4w+rHxD/6jqO4utD+WnadeDjumgNotdVpT7OKcqAP95Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(9686003)(66946007)(55016002)(2906002)(64756008)(76116006)(66476007)(33656002)(110136005)(66556008)(66446008)(86362001)(54906003)(83380400001)(38100700001)(186003)(316002)(6506007)(7696005)(8676002)(26005)(478600001)(4326008)(71200400001)(44832011)(5660300002)(8936002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cMJMb+oMU/1iNSZhWi+8hV6g9RjKTSAdpM6vOV/RQA8gVmfIltUShBkZWudb?=
 =?us-ascii?Q?2DZYWZgaq60iUUZCcMxFeuzcNq87fkv6a64PKTcVpKcOz9nmFCXZuEL+LUSE?=
 =?us-ascii?Q?Qjfg4BwuCC718LmN7nf9f6j7xgpPGu6l89k5Xiu7OtY5Z2FuVqOiOuwCqorR?=
 =?us-ascii?Q?Toso+c0gAwt/kn3An4YAGRgplsZDjEfgs2FrKbKhGfpnTdfq6uBL5M/6ugzr?=
 =?us-ascii?Q?K5GhmuR+fDAE9dY9iQzTHMMPbd6dY3LoNOTf6jV6WDMPeN/68gPEE9SDQADU?=
 =?us-ascii?Q?SL6X8jJDWMz3rYgpp/lSxJPYjWZv0Bcb96dBsGT1MY3G7PKXVc+pfJQg8nxa?=
 =?us-ascii?Q?EMDdOlB1rwWia1VCt8nql2prEWHO06Z3wtwVzZjGsLTAtVQ+8eICSJbnnWz0?=
 =?us-ascii?Q?ccMspVEVGF3jskcyftV6CXjb2CzmF3teP2j0qx9+ATX8VOaqKkMZl8m5TNh4?=
 =?us-ascii?Q?Fum4qbAXikLrG0iHPvtIDyMLPWWEu9hW5b5T0680q9QDJ2JUe6H7J0lpYa3H?=
 =?us-ascii?Q?qoWDgkjrhXoAN7eVT0aAhsk5qdFKbM+XWOSeow3PrDlzMyTaxG99ppMH2C8W?=
 =?us-ascii?Q?faLolpWyPhWUcYX0UF7aDKQ76Io5/3HxGfaKUJeRBP7Z658pUVxWxSRuxANS?=
 =?us-ascii?Q?xDYGFQ2PAsIaoPpWRX/FEyl4d2Scng8XXglbGMEhgQvhtbGjZlU3POY+E45P?=
 =?us-ascii?Q?kvtL2vTSSWKZZIqh4FW/tS+w3q9KAFwSPhFr2ReQmZLApcxkuKv5eO0HLLEk?=
 =?us-ascii?Q?F/PHM+1aGsffjd6HGPzzaX7B12MaDyULIAzlE3oeowji9/Qnp/WdgBZ4A49w?=
 =?us-ascii?Q?80IcyALldxb1Qf+JOaSvY/ndQPOsMjoix1FqPTqMV6OKIUPWqLhw0WpVvqTk?=
 =?us-ascii?Q?fVOFSGKORhj/ANP4Li750Wapc53gHgvhBwJprux3bBXRvdnk85KSJfGLTlUU?=
 =?us-ascii?Q?bGDheHBUA/AuBDrVwPnMyBTVqllmsz0OD1G+hWPec8YYA0bDbYtRZMuCkmoP?=
 =?us-ascii?Q?7uxfxiPLSMcjFsXWUYHldf7txI9IquTRO2Vy0FbEZgpbrfwIGnX+qSEMIYKx?=
 =?us-ascii?Q?Hd3K+A5rq0UVOJgbI115kG6HT25Wnv9ohghkZaHcdqXT0W7RlY4NY8nuGzHr?=
 =?us-ascii?Q?/HmzwH1iEJ1N4nJXggzxnIlYYLFyKF95UxPKMlAq/saQsdVJkXjSsPBarHle?=
 =?us-ascii?Q?1A9/y+/xNuidoyX5Ak53bTBqsnTkJTIpt5CT8jmv0/dRSRb/BymRvIJcHoQe?=
 =?us-ascii?Q?TzFhp3MhbKT+OF475g2TbNgvqp6wUYV50toqRcdjzehX8unxa3tf5Z92XaFc?=
 =?us-ascii?Q?TaCTJCPQhkT+mcjy3hGDsjGr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81965790-2439-4456-4447-08d8eee0d663
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 16:21:10.8610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZXN7r27gng4exw4xBWTDhpK1aO31gI/XHZCVdixkLj1keIs9RxCvL5hiB/CFMnw8/zAuZRZQphaiH3V1Kx13Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Vladimir Oltean <olteanv@gmail.com>
>Sent: Wednesday, March 24, 2021 5:45 PM
>To: Jakub Kicinski <kuba@kernel.org>; David S. Miller
><davem@davemloft.net>
>Cc: netdev@vger.kernel.org; Claudiu Manoil <claudiu.manoil@nxp.com>;
>Vladimir Oltean <vladimir.oltean@nxp.com>
>Subject: [PATCH net-next 2/2] net: enetc: don't depend on system
>endianness in enetc_set_mac_ht_flt
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>When enetc runs out of exact match entries for unicast address
>filtering, it switches to an approach based on hash tables, where
>multiple MAC addresses might end up in the same bucket.
>
>However, the enetc_set_mac_ht_flt function currently depends on the
>system endianness, because it interprets the 64-bit hash value as an
>array of two u32 elements. Modify this to use lower_32_bits and
>upper_32_bits.
>
>Tested by forcing enetc to go into hash table mode by creating two
>macvlan upper interfaces:
>
>ip link add link eno0 address 00:01:02:03:00:00 eno0.0 type macvlan && ip =
link
>set eno0.0 up
>ip link add link eno0 address 00:01:02:03:00:01 eno0.1 type macvlan && ip =
link
>set eno0.1 up
>
>and verified that the same bit values are written to the registers
>before and after:
>
>enetc_sync_mac_filters: addr 00:00:80:00:40:10 exact match 0
>enetc_sync_mac_filters: addr 00:00:00:00:80:00 exact match 0
>enetc_set_mac_ht_flt: hash 0x80008000000000 UMHFR0 0x0 UMHFR1
>0x800080
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>

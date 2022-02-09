Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837F04AEC86
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239676AbiBIId7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:33:59 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbiBIId6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:33:58 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80764C0401DA;
        Wed,  9 Feb 2022 00:33:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jmn6UD2p1K55Q+fPvsNqaqOGFclp2ru6zI8Jg2MRB6Xu9AxDKsDZMatlxmi8KXzmn0RQVjKO0MMb8udgk/b+Xqix+044OUAnSG1DLTxunggETWySdS23WmuUY49BdXjfi7nFwPdjuwM1BcCnMoc8Gpz5ZnW3xoWl7UdbCHra7uFksowcK4PqfQKrKfNJoVCR5aw6PUJr0uS3IvV8toZf27lk3mnUh7xrGn2eiTuh17ODjL9MLxlJBFK4WM7j9/H/YS8sZ4ALj38xSmVBBoBJWoLee5edrjBRDgW29vaL9u6Bu6ybYxdmoZxjStXKZni6z2QeHx3NqJ5Zt4/o7yCPKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nzdFXcgTyTzklT84W3v1k4YogDV9YJ53/51xrAvM648=;
 b=C1v7sZPm0dajUwW2n/4cECMDweGXGtex4Urvp5DoeNV2osdC8wjMRxawAxBB7Zk53e4HPLHr3v9A37u6YsXKLWrpw0/RBuHnBjki6ijU1HQtUxwrmSMfRDVjfd9Air+tSkp7vuYOHtWL94voQq7sRv9Us1pUpxmzybTjRYplmJhGSaT5IPXFhsS0cXBc4G/Wpm2O30f86dKdOX6eZMGeoeh6dg3yuLe5dn/YTSGO46GMJAVOj5TcMtPA07rzN1kNUAHCOGJTU8+Dd6Ah28985p2WbqdgaD7BoQSx35uvtG17Yuxwu+xZC8BRoaJNGvRAXo1mRhDDwsZUw/w4bXt6QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzdFXcgTyTzklT84W3v1k4YogDV9YJ53/51xrAvM648=;
 b=nCo/KT4O7mlWTGWaRyFnfh+h5pY0UBRwevLUf1wGoBgDAcwKV8R78KqI62j5z1fBbgdDDvd4oigXp0ikt8ybswcazlCcCSb2zHM7CJ9uWYZc9pH+sH4LbgzaFjBjwuGg5nZK2hf4EYxfC9s+ePkrw6FpWlgxkLgCWRQHnw0dajA=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM8PR04MB7859.eurprd04.prod.outlook.com (2603:10a6:20b:24c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 08:33:46 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::99e6:4d39:1ead:e908]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::99e6:4d39:1ead:e908%6]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 08:33:46 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Po Liu <po.liu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: RE: [v1,net-next 2/3] net:enetc: command BD ring data memory alloc as
 one function alone
Thread-Topic: [v1,net-next 2/3] net:enetc: command BD ring data memory alloc
 as one function alone
Thread-Index: AQHYHXjyJYBx6OxMzUSnNUvUrAxofqyK5GKQ
Date:   Wed, 9 Feb 2022 08:33:46 +0000
Message-ID: <AM9PR04MB83973F2FA7CFD11895A98A60962E9@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220209054929.10266-1-po.liu@nxp.com>
 <20220209054929.10266-2-po.liu@nxp.com>
In-Reply-To: <20220209054929.10266-2-po.liu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5aa2097b-88bb-45cd-6ed3-08d9eba6e3c2
x-ms-traffictypediagnostic: AM8PR04MB7859:EE_
x-microsoft-antispam-prvs: <AM8PR04MB7859A9F3783BB0E089C0DE2E962E9@AM8PR04MB7859.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X4jcE5L2GU/ztEXDDlEY316RGqTquiqFdVNAevXOr81pjZ4ZcLFi0CtHEatN2xPlgYFkOuJKlUSN0HNVf53JFEwPbZ2D8k3HsokeynR5uqTgc0+tmF8UJ4UcdWhQxmdxd1bKxLpseTFmaredJYutyHw3eZMBv2Q+DidDlqd31+35cLxFaL1ptcJgdIbZFqSwoUa6axr1QK4+Dm/qRFj4dCu0qKrhQ3/KeamXxBVeJNVbZrl/knbbXoYdgU6iaDGgMl49aMkXG7VxW9ssW9sB/iJkuV5p9cISFsM0H4wz9rStVgm6HLjug2BoA6cbqHlNbT92qxRlQg+Gfnh6NW9A9eh5o2+EHFYH+Kk+cyHsPl8BESkurXJ3/crRl1TC1/tVkvVCvgY9IJIkRQb2hdvPArITDIE7M29b89HL1oPE14/mk1VeiAIT6+YbPXdMHxImDNuOTresp5Uuu6AKTU9z/e8mT2zwPWKpcGn8DMT8BWlDrP3vmVcTCUwqvyaQ+i5vfILpB0FzmU9d9LXyXt3nozosjdHcWaW+iUFvLP3GzAe1mVw8ojsYfPseZDKrMVFONoZ17s175W41Lwz08JuNcCIaIZi9NzzckZS7hMmhaQZkM/0aEr5YoUse6qVTmH3JXEJcCBX6UT3VuCGz+ZyRxFlf/ZfCiPetHFzIYtxOcqONPBpg+7CMIC74nPheWkdK7T2MoeBf08qWJZJ/daL2sQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52536014)(8936002)(71200400001)(110136005)(55016003)(316002)(38070700005)(33656002)(7696005)(53546011)(6636002)(9686003)(508600001)(6506007)(76116006)(8676002)(83380400001)(86362001)(66946007)(5660300002)(26005)(4326008)(186003)(66556008)(64756008)(66446008)(66476007)(44832011)(2906002)(4744005)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AKJv7eYKHINh4jtUUSivRqZvh2/Znn5HeashlTbGJCdW0rKIiX1/IGdvQYgv?=
 =?us-ascii?Q?afXJ/UomhCyunyjsTTW13n1UUV3V/mkGZzoRGPswopx1MBg4WBhiDsyK+n3b?=
 =?us-ascii?Q?wog/V0ro01EEq5oQNpytMtExYjTXDqqb/FKFRVhEGOJ+CzSFGO3aMu8kpPbQ?=
 =?us-ascii?Q?OIKyuWWkPzbfTeUlGhYjsUbPYD7DqIdrpfM7CPiJLDFTs5k7uUV3NdhMkNEu?=
 =?us-ascii?Q?Gh9gLz+AN0IIN8WxSQKTOxWjFsdJGHYC1zM6YKabGRSkH4Jrjd61jaErBLzh?=
 =?us-ascii?Q?ZEMEyzoCrQF1LEdqvJnH8MhFYNPjw31v07p9vlKdM8kEnR2QmR1kpzoiKKmq?=
 =?us-ascii?Q?aGLX0yq4eHGVA2VPb42vApMIpmzTwfEE9734ZFdedPzao42dxa48cFPR1edO?=
 =?us-ascii?Q?TujW7IjBq+svap4kw5eqfgkMFqZ04s9QKE7vxvpqO+JEgEp72RHqDNs3GYug?=
 =?us-ascii?Q?nzuJ7KwuExRySwp92sfXaDENbHVQjYtNKRTNah2e+iw4IXKokOZpkioAxtyv?=
 =?us-ascii?Q?3Lb91rNRLqZ7RMjgzyUkLu+sYUEV73ZNPhXYMPMkCidbFavEzKPj94fc6dz0?=
 =?us-ascii?Q?M/M47LwHu4DgStFC5IKPzyahHN9ttLqvKOlPMDi2MZqlj01XAMuiU4oZAj16?=
 =?us-ascii?Q?aADaXryelk0xdvhefJCQqFKi+l1A3mep5b1dz/pdqVG8IzMUucuqwVrTx2og?=
 =?us-ascii?Q?heQcIre5MNQWpHB1uJnh3BBFEZ3gf8I75+fOzfqWOUkJTbqMoEySsN7bQtuE?=
 =?us-ascii?Q?lAvWoAvC1gZXsOfQYXvTTAGwcd3xCqrWqMiVFxepRvVfCVnRqdnEjHraMSoa?=
 =?us-ascii?Q?BDYz68uP8R5OKyMCPhNxMQ6f9WBT3UgGcYxqM8E3XZCOa8BH3vyfo/lClCM8?=
 =?us-ascii?Q?he+L1C/1a3KdlFxn7tlREKcLSsxGIG3x6HkGsznynU8ZFknAobjXOE9ROfYI?=
 =?us-ascii?Q?LO6G1YaZ26v80qpnbZ6MyjTRxE3NctQxor53v1z20wJdkapSIm3nehLZJPZo?=
 =?us-ascii?Q?sVxBbyJZQpvQ8DONrs4iO90yXFvnSMWsTvahlBHseNUES5FCqXuvD9KmuNaJ?=
 =?us-ascii?Q?7L23EGmq/nSxTnNIKZRoT7Ic6UvsRYnBHJ16BgbsMvoHMTw3Kj0Cfcf3IQJq?=
 =?us-ascii?Q?1iguuO6nfrwZePG3NYzsXC7hHeWM66IoMFqxUmlY+L/lBIZWGL03ofPW4Ak0?=
 =?us-ascii?Q?kbhiP4QIKvGgS82jxktqF412iiu3Tu1JQ5mSoyzjvlYKgWJNgdPPn+mvMjPJ?=
 =?us-ascii?Q?rxnWGCv3nGK3WUUBZqmv9AOR0tKP4v6pur4z2m+RjRmemLDnqU7fOURGAZGx?=
 =?us-ascii?Q?hW1Nu0epd8+welGqsZvcz9C3GdZiwPACgkiA7TrKNBUrKvKO20Fj0UXETtFu?=
 =?us-ascii?Q?hUuGXshXejJzaWcT50mo1DWmb2d1vIaMF1TTxB5HF1byhoP1SoQ/2DduBzex?=
 =?us-ascii?Q?kieiaZ6nFlvlS5/+L2RiGZcWHRBCzqE/puKNt21zfCJKJwOqg0aNy2W71sRw?=
 =?us-ascii?Q?uMvn/bomLF+tgjE12SDDg/l9Z8BOIiQDvAQI1/C9HcqfnkNSglzJXv+c+Oq9?=
 =?us-ascii?Q?Rhm1Lpq2tUEOklXQn59iRIMf3NTVgRjVWHVIE7oD6kc2GrWZR9stpRloZeiY?=
 =?us-ascii?Q?zg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aa2097b-88bb-45cd-6ed3-08d9eba6e3c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 08:33:46.7436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GlXzsvBgea7KgDUb6fJvNfzfF75910/y6C7cg3sIdgaxaTbKrxlWkZ0m/Y09ybPX6gf65gOfrkkJSeUzoRMnPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7859
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Po Liu <po.liu@nxp.com>
> Sent: Wednesday, February 9, 2022 7:49 AM
[...]
> Subject: [v1,net-next 2/3] net:enetc: command BD ring data memory alloc a=
s
> one function alone
>=20
> Separate the CBDR data memory alloc standalone. It is convenient for
> other part loading, for example the ENETC QOS part.
>=20
> Reported-and-suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Po Liu <po.liu@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>

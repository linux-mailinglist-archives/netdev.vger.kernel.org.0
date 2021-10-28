Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DA843E44F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhJ1O5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:57:21 -0400
Received: from mail-eopbgr20089.outbound.protection.outlook.com ([40.107.2.89]:10146
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230258AbhJ1O5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:57:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdKHsFD3KBHN359j4XdavsvXUFpDoJrgyfDdxUL2UX8BkF01MgalnXyWCi/gOR7d+20QEf3LkUVXue7obbm+No9RUVw3bdSRIbltl1nudt9Vi2xOeGwRacYAEqLaPbteRSMFaq2H1rPrwZq9UNfPMDM0EStuFtGB3NnFpzGKoYzf1+1wwGOD0ZiBoXcjJmA4dXVQ8y4FFhHVXhRXr0HCxyS9N/xHo/sLKPiw8ckV/cSHiZxDX9QbFVSDokifLj6xRePvw5JLI+MjjjNgzqHI7VER5kwO8LU08WmP2NrwkpjOPmIapRCd+cfh59UnlYs5LIQEDS35hi0eC8WulnE+9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvO6+GtHWy8dqgidCZo0p8joaO984hwYx9DpX6wYuds=;
 b=UktioVxj96YtCRjhUcyc+fGyK9TUa1THvr3PDF3kJmw/7SFCAUcQ1esEhGPOeCWu1kj/C1Yu5aic6fiKUMGeirzai/apsgsIuDzS3myGrrI3+zC+kFJio5UIuGi6Y7xqe80xAALdbuzRAZRUl4SRgXC1jvTEnCKdvasalL0iu4hH1ijoWtt3wpDg5cg1LmIPxx5iD+yB9RVaKWB3NoCA07xIri6ry77jBuJGM37ZQQcpuJ2WzA2/I/V6oHHJauLksvVz4YZkkGB3Mf/JZwzAY/ckk1gQdZmlHs3x2T4C5u4zU2VV0w7cZUkbMcdbViYuWNaZDXttFB7Yt2X1npa6rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvO6+GtHWy8dqgidCZo0p8joaO984hwYx9DpX6wYuds=;
 b=SbyW4vn7NwbsCG4+iydmucCjjkvDZTe5nfBEOeXcVUPr42G2KycHgRFcJK6QrkKJk+ABGGlHodv2Bvcin0TR6V7mDb5kVkoDb0hTiexaF9vTNwYJvRfKZbA3yGdccXaoeJ5EPn2w6JxO7u/foGeXaw9isnUWi9EOOpf2HkpZ3d8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 28 Oct
 2021 14:54:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 14:54:48 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] net: ocelot: add FDMA support
Thread-Topic: [PATCH 3/3] net: ocelot: add FDMA support
Thread-Index: AQHXzALbT9+TspAQqEqpFNd9PfUpi6voc5yAgAAFVICAAAaKgA==
Date:   Thu, 28 Oct 2021 14:54:48 +0000
Message-ID: <20211028145447.g37g5wb632nyta3p@skbuf>
References: <20211028134932.658167-1-clement.leger@bootlin.com>
 <20211028134932.658167-4-clement.leger@bootlin.com>
 <20211028141219.od5fdthkdqenpegx@skbuf> <20211028163123.76721f6b@xps-bootlin>
In-Reply-To: <20211028163123.76721f6b@xps-bootlin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5533d7b-6b33-4b35-e24e-08d99a22e3a5
x-ms-traffictypediagnostic: VI1PR04MB5854:
x-microsoft-antispam-prvs: <VI1PR04MB58549A7B0308E03D7F66918BE0869@VI1PR04MB5854.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JQZxh1g07VnzINB5M5mOcOpyKxEa+wsHX+/Es4Ci4gvVMXUzqHdT1AW7C5AcLbsb/e7zLqdrfQyllipfB2cKCmEB4IUIwt6aFYO+C7HGvW69UfLpAnrhoTJpCOa9VZRQb76lbOA5kP1Onghhe1GWjlRQiRj25r3pTKpt5gbiKV3tQDCNeVpkpVX9ydPxZE4NPAMiNqopu6eKhz3mntd8CY7FvOhFrU6FAtT5jXCx7MUuAazPKSprYKxj3n3I3onjeJSlDcmaYMP84NltSheO0GMS6b7P1LLJE7OF+xow47LxFCJy+ptUyl0yoqiVvpGfbOmdgErC1insWH0ZLOxcbNFnwHIQw3c9psQmg4bS06kD19t4cYYXaeVa3p2IncBHzcNuJaEcJaWl0cRjKjWobsMOPoK+/SMuIZ7ruKAPxRpCtPq9UCE+CGzjlCnaIOAgjZgMPDa8bvhOrbZfPdMFGnuOpjWEIek+qU5QrvH6MYXlZGyUgnwkqGvLpU8j3CeE4CE1wkq8vPsxt32Vlxmn8sv5ezLzZKAofaY+7Cz9tBkkVxL5Vz8lrsGWd++I6GhEoiDK41fNuMzNLNjbE9dRh1vzdxwZPCUTXrF2pumVE2c6LSJJb3jcufmC+thT3T9VN5IXy6VsDYmvzoK0SPjpgTU38TnPuQeB4i3dnvKYfe6S23IdJZe3f3mRGd30NKB+tlwEPvD0b5/dFzTahrmDbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66946007)(316002)(26005)(7416002)(44832011)(508600001)(186003)(6916009)(8676002)(66556008)(66476007)(91956017)(66446008)(83380400001)(64756008)(5660300002)(76116006)(1076003)(6486002)(86362001)(9686003)(54906003)(8936002)(4744005)(71200400001)(38100700002)(6512007)(122000001)(33716001)(6506007)(38070700005)(4326008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?oUzS3eS6NUqF57nYkxz7krvFWKgcrvQcgrNcoXRAK5Zu1RS4mYqcqDELac?=
 =?iso-8859-1?Q?vHX7b2xlqi1QvDrBdolYcO3V84omiNwaA4zRSVjEAmgp7rem+mH7kiaJ4X?=
 =?iso-8859-1?Q?O/3jO/wnrIea018eZR7nuyCNp9kKmEK8qjn2Ka4Nuo6Zot84TqaP6anrpD?=
 =?iso-8859-1?Q?TajwJ1Slu+144aOaXJzjkqtUljNDu9kXSM3ksFlIhJ+ZEZdG9cB/K6Rv5N?=
 =?iso-8859-1?Q?MepSgdIJIA34yU845apLAh2Rnnk5B6pIV/W8OGc4H90c5keprafwNnGbkw?=
 =?iso-8859-1?Q?byTAkwMH1Yc2fuUg7au5vUBUcH0GkONrlFcCHqAlVoTeViSsl011GmlEJ9?=
 =?iso-8859-1?Q?+peVPO42xjkS8RiNEngu42yK4l1oNYZ09WZkPMUFAcWppuM7ML/ouUm/2y?=
 =?iso-8859-1?Q?rIuvx9de4pImfYsI6ncDjVx/x72lOtZIRDh+Jc7SAG2O08i1M34vvDPL+p?=
 =?iso-8859-1?Q?fpr+oM3mZqxqQeSDwDxNcLZw4ImdUikgbg5tdKAbvLv+eFNm7dU4u4IrSw?=
 =?iso-8859-1?Q?+2sAzknUnU5eT7UUep9oVjpE5UPRDzJpqnDjV3TtzpDz1yCvEsjc+Da5ra?=
 =?iso-8859-1?Q?CbVFiMsvzEyvq7ufPTIF9OOCFWKeVCpkU5RXobca9pW/dcMhkepDvWdvxQ?=
 =?iso-8859-1?Q?VqFo2CetaldWs16Igph7qTWFKNs4DHIACjGW2yXziaarkXbA6VPrWe8u1q?=
 =?iso-8859-1?Q?LvPt2ytNeXXjNf0EZxqSNESdiNeWDQGimr7Jq69RjOttBU0z8yHiJAm8QO?=
 =?iso-8859-1?Q?ln3XF7MwDbQ5y7FZHMItnhuSd4fr0DSl2WHoaCWh2TxjOrs7iIlIWwvFjq?=
 =?iso-8859-1?Q?wxFDWFwkuQ6cJ8owBwhrUchMeAANy1e2tClB7TiVYTVZNDWCTABJFcOR9n?=
 =?iso-8859-1?Q?bC/7T14q/H6cVVnkSyKvW+WvW48TpxvPd9NE0zQ62Ves3P3mt+odbQXut7?=
 =?iso-8859-1?Q?qBXOCMocRAUQF27hIdrlBusMa7CnrzidCcyWMoSAkem655vspbTEpuHqJM?=
 =?iso-8859-1?Q?Y2wt+xqRubXwpiPQnmRHPLSOKt5+MBO6QCna/NCZ2KlSkHE+hqj9s6CdhL?=
 =?iso-8859-1?Q?OZoZAFyQ/gTJx4BZadqxme1RaGpVgVAI8BN/FCQNYeeC+pIGxRHpLu8ONi?=
 =?iso-8859-1?Q?18RXhyv13Ph+m0TdjuqxTm92HNmqTVORZvUqaltv8sUUL5M90IQG6ebqCl?=
 =?iso-8859-1?Q?x71MunJGWFoFEoV4jARnX6EHTQfnRoSHBqRca3DphFJ7yVBOu59BP7kf2Q?=
 =?iso-8859-1?Q?j9ay4e8KjnXIrwh25/2EcHQTcTEMmt7c5TVZrHBRjZeRm5EZ8rSjLZyYH/?=
 =?iso-8859-1?Q?uG7E83tcT6fTjs5dYauPxre10pmYEo5WyCwNGNNTuaDk1uTNfdzcjYxNKs?=
 =?iso-8859-1?Q?XCwbHAhM8xhSG9dhAIqndcvLtQrBOuLKObscWXBBXdPOMvmkvd4hq57BOh?=
 =?iso-8859-1?Q?2WTYuQSrs6+9QaiC6YzXWK/wUTHyRgxYRSLblIdHaZf6wsmtzrYjEhOhG0?=
 =?iso-8859-1?Q?9KhFXf77oQ4/WFiQtEAQbTMvJ8m3qbe9RooQ4JZjIzl+lDSGAwkQrlgBi4?=
 =?iso-8859-1?Q?B3skXqQaUTvTBwR2oh7owCZqJDAhn4T4WxiBtE24Nqg5TwuUqGZUJGdPrd?=
 =?iso-8859-1?Q?CFRtNJsG4bWSQs8aJlwFRyuAVTTWfyfEWKkWLmW7zjejwEu0JkiLR9/wAF?=
 =?iso-8859-1?Q?uH+wK6R1s0QVFQwJT1soRkzzY5By6Rzv40qg2tsm?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <0E79481D62E6884ABA8335ACBD04E369@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5533d7b-6b33-4b35-e24e-08d99a22e3a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 14:54:48.7131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3m1YIEe5sCeMsSPcmx0uafeTUDK3omSd/HNLMVQfj4jexVG+JsV2na9h6HJt1FSp/VfFF/c2CPfGX8kQiiq6Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 04:31:23PM +0200, Cl=E9ment L=E9ger wrote:
> > Can't we make the FDMA and the manual injection/extraction registers
> > use the same endianness, instead of duplicating code? I can
> > regression-test the manual inj/xtr regs on LS1028A.
>=20
> I guess this would be possible by disabling byte swapping
> (INJ_GRP_CFG.BYTE_SWAP) when sending the IFH when in register based
> mode.
> BTW, while checking performances, I noticed that the CPU spent quite a
> long time in packing so I added precomputation of IFH. I could probably
> modify the register based inj/xtr to also use this.

packing() is not the most optimized thing in the world, so I wouldn't
mind if you changed it to some other API, but the ability to read,
understand and modify the XFH/IFH headers easily is something I care
about, so no weird macros that depend upon some particular endianness,
please.=

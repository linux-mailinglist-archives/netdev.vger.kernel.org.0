Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0002231DCF2
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 17:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbhBQQKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 11:10:14 -0500
Received: from mail-eopbgr150049.outbound.protection.outlook.com ([40.107.15.49]:8294
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234002AbhBQQKM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 11:10:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZzjLsvUVFj6b2k9Jtj7C/JYNrceH53sVtwKYWb7tGCRrY2XAhgvcE4qEr1ctbYX6wGCDqmSw/CFiqdcin0JvMFvlXeSJ8+E7MDROovBlEufEOV4SIj4mcIZzgUyorA9bWNBa4Ih2RWlDlIIXI0ZxoRKNjDiamwBII2Kn/TiYo/eSoV2ciQAMiQY3IlhTFAFndPfBTetwKiFA5+oMTg4tz4aTV4w1s67KM0SkEAJTNzEusx9hG9p0YjkcS1KL06beK1BTqJTBglV9oeBTjyei+sUFikV+C2aJmlFThJI6u13WU+lfLr3FU9nC2ZbcZ/6WsXTXNXk5mJobWeYFFyk3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NZFWy5C/cLP0yScKVt0E73oPievWM8F0hNc0HEWYSA=;
 b=QnRKH2lfMzpCyGLDkoYkYKIojCLotjKzqb+gjAg3lwa3py9RI37kT+yCLcINedUQjgVc/x469tZp/AOgWLWnfVWYVjdvZBsRrQ6cPRZulxS5LfQBCn9wvTRDUG06CZa2nswaAr8rxPxVdft96iCSkNoBegp6jvEXokd/4ifrUpOR7qzWaOoeiBxW7OmBtRWK+N2mB9AXALTpnp9a6+N1PNQVv9Fsfw3dcQf3QVC+uhBh4cC4cUzb4syk15MYtDzMB+hDz9d9t9rjXCvvGyINBkw/5j9bCk+O3Dqcm03yN9v9VxnTLAm/ROR/V9Qn6LWAhelHcYezH1UAUFrST07qLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NZFWy5C/cLP0yScKVt0E73oPievWM8F0hNc0HEWYSA=;
 b=Xb2oHDslRXZCGux2n+qhNlXicC+X5bCBv2H4Hvxw8XkKn5Z4qitso6Zo2OWUExh61Hf+5KQSq/o4zpEUu43Pl4uOkCJD7kxP6uSU3zcFDELCapS2unk4k5X3RXwknDfM58PN0JXlr2cKl6XJxk4JNyXyRoO/fZxRFJzDYbKrgCo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 16:09:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 16:09:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v4 2/8] switchdev: mrp: Extend ring_role_mrp and
 in_role_mrp
Thread-Topic: [PATCH net-next v4 2/8] switchdev: mrp: Extend ring_role_mrp and
 in_role_mrp
Thread-Index: AQHXBKy9eGp+yjutnkaeTLTu5mS83apcJ5yAgABalICAAAL5gA==
Date:   Wed, 17 Feb 2021 16:09:23 +0000
Message-ID: <20210217160923.fimumxafloc6276i@skbuf>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-3-horatiu.vultur@microchip.com>
 <20210217103433.bilnuo2tfvgvjmxy@skbuf>
 <20210217155845.oegbmsnxykkqc6um@soft-dev3.localdomain>
In-Reply-To: <20210217155845.oegbmsnxykkqc6um@soft-dev3.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.13]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fe81a1fd-d947-4012-a783-08d8d35e6493
x-ms-traffictypediagnostic: VI1PR04MB6942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB694207F3FFB103E5AD1E4865E0869@VI1PR04MB6942.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lUWNkstOqZ6BDPU0/HNEIvFZ4r6IwxtJ/wnAoWkGnBjE2AXu22VZzEU+Cuglw8KVJT/BJIr9BJBHgptLKRXxoMNExGdHKG96m+PuGShH/BoWYMikfJlY1pMov7jcCAL8uc9TCMYyzMlz6iQGLWLxpK/wvJSmcx6AqFXRqqksw2TEJdP6+LqQ07rf1ftOjcSn7vy8M1oePMda/xkxBvDr94kBI4UM2vtZNm6/RITNIRP+B5JspQFMYYz22wISiaapAmlvSmp20XULkg0v//tGniD9XETVCw/fFr664bM5cRIoRSM2yk3pXJ0x72hiXMvY1JMRFPtbdT3BzxdcMJ3LlT4ycUQCIOmBe30luPV5zXLs3XePJZEh6reenMJ3d4BPQs8nSQLGKdTIW/uscGnzS98PhKsZCa5zOn9DnZkYcH8ewrQErq0HAlPguEPbKp0pPjabUQH++U8NxVtST68At8U8hNa3S5TSoBJCqNG53U0PZUNvRDe7Hsww5ewEVgWz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(136003)(366004)(346002)(396003)(376002)(316002)(64756008)(6506007)(478600001)(66446008)(66946007)(76116006)(1076003)(66556008)(91956017)(54906003)(33716001)(9686003)(44832011)(66476007)(71200400001)(6512007)(6916009)(5660300002)(8676002)(186003)(8936002)(26005)(4744005)(7416002)(86362001)(4326008)(6486002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pzEVxEVWY/uvc3dnYUi29RRgbRWNs72mldzVzbtHbKmq+7884NWLJ64RoUy7?=
 =?us-ascii?Q?4PFSXMfOdfGwFyx0RfEeDKq5KAbuITIpiMzdGlZsMaRQ0t//2jKIFHpdLns3?=
 =?us-ascii?Q?wvIYmeScWItZjdzYgyXMefyceea6X6BLHobGX6WdgeAOzNwQHtvt/KQWY2UD?=
 =?us-ascii?Q?IG2NgCYueQ6p4CdB4Qcg4cnKxAMh3KVlbI76aaNnTsT5E6aUmbdQ0vBERQm4?=
 =?us-ascii?Q?0F2DdUtRrSDVHo/Ne4DmWR7wNFnCVC7/gzw08Uj7GJlCVEkdYBWtcDqxpeQy?=
 =?us-ascii?Q?aVrJPnh/iI6l/RkdqfZ3d1yVKVXZdZNtg7Xrn/toXiAY+KUpHDNcURwy85ob?=
 =?us-ascii?Q?xqn1CWhYEo7MaqFe841ZykhStqQtkAwRp+J7oG543Jla5eB0jK1DoNPjOIcw?=
 =?us-ascii?Q?9rvvJ94+jlT43NkfgaSku9jA+tm9FEADcWlqi7+zd9ATY/V96GM+d5on4pWJ?=
 =?us-ascii?Q?RndYHHdx2jupu7ys6AmkipdsLeToPfaO5S3Oa0u1/8En5eESHvhv6ZKz6hp3?=
 =?us-ascii?Q?qT7Gv3CMgI2F5Z8t1nn+xhzxanJOhwnNQAnxW+xLxvDeNldG6ADoyOnR4dqF?=
 =?us-ascii?Q?6s/8AiN7ZKhAwUeLvBZC3lGlDk1DhxQtz7kpibUFWU62SSZ2sF602PQY4TJF?=
 =?us-ascii?Q?xN280Of9treg5SNe0THRz8m444z9Z8HdfbeG8Vq1qrTyP9DOeiyVYGXza0Hz?=
 =?us-ascii?Q?TOlna4rlR5ohc9Lxd1/rX+Srsv6Oc8RmFmivn1A0cI/A7qhKdzFMn4q1dn9H?=
 =?us-ascii?Q?tffGruUR5J+mbYit0z8zfyrGdKhLxz8NFVWC2Q6jCBA+ftPivCG3bIWQ3GHa?=
 =?us-ascii?Q?qdiaDc6HhSN7hlR29zFgKSXsEAdMbOKQRU/t+Pbbs4Z6WmnjBDcHyMp9cKVx?=
 =?us-ascii?Q?3fTDo6EDUIaTZnL8MVljEYPihtfOSDcJXxdZGswW1ThmTd0Mtu/BIZM7ntIv?=
 =?us-ascii?Q?qFQDh5mnY5xMzPKJAeZONKLkpKM1QwbsFNYrkuMD+vpBcCrXdp/bd43Fe3TK?=
 =?us-ascii?Q?hiCouJQHS+jwsx5qoFZdCp4j7EYCyMJ2UgJbSBzGkxrgHKVNUCkRQXxgIuU6?=
 =?us-ascii?Q?G/coXhLJ7l6diZnOo63haRUy9YR58b8pJlpRtGsvHmcnVTGYppTK/DeZOZuG?=
 =?us-ascii?Q?ys/OLxMCvyZ21JwNQ8EKo78VU+X/m7dPcDz7yBIM6HqRPYvhPZ6mM3029eyy?=
 =?us-ascii?Q?0jm2PTsr2hhKq6XR7XK0SZDsV/3p/QhYsbZsw6A84+wWk0LREWTHaRWRRKJk?=
 =?us-ascii?Q?k29fec60t2OF3hT9Jy02iXqcyZe/bloTKB4UNIhkJLw/wPe8cGcSo+B1GiPQ?=
 =?us-ascii?Q?JtB/6Iv4n28I9x8yh8v2I7+J89/gDR6rr23rVdZVM3/c0Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <722080CF38BD8340897DAF4CA059A370@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe81a1fd-d947-4012-a783-08d8d35e6493
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 16:09:23.9430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y62K4bBMtxrK6rfL1wtBLs/Y2g057PygdzWphd9+8YzANxdO4c1vDNFUqGz1yNB0flHkLo5QwOMP/Q06cNw1Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 04:58:45PM +0100, Horatiu Vultur wrote:
> > If a driver implements full MRP offload for a ring/interconnect
> > manager/automanager, should it return -EOPNOTSUPP when sw_backup=3Dfals=
e?
>=20
> In that case it should return 0.
> So if the driver can:
> - fully support MRP, when sw_backup =3D false, return 0. Then end of stor=
y.
> - partially support MRP, when sw_backup =3D false, return -EOPNOTSUPP,
>                          when sw_backup =3D true, return 0.
> - no support at all, return -EOPNOTSUPP.

Damn, I asked the wrong question.
I meant to ask about what it should return when sw_backup=3Dtrue.
But you answered anyway that if it returns 0 when sw_backup=3Dfalse, it
can simply not deal with the case where sw_backup=3Dtrue, because that is
never supposed to happen.=

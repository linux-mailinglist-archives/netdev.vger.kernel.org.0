Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2943F05A5
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238728AbhHROF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 10:05:56 -0400
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:12423
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238531AbhHROFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 10:05:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgLifeZR65KUhviHhq3mu5gWCVc47IKR/tRCHBSd6dGhDQDrevkxO+i3fEj5uAc1vYliaqwLWm+Ksugev0EvCYJf8nY5dWCezj8KtX98DH0QmXox24FE1pI+xqky+O14n9me2QEjCtnWf0ME07B6KW+ySUF/MhAtFRx6ZdzcKj2W9Znh96OtWsrsQzglAQ3+japGF3Ftgq8KDVeRvAXCpq6tdyDzmuWmTCF4y3Xd8+P+WO8qrXWikffdb20kYsg/JNvxYuAKUT9AMX0Xt6LJOrNctLq24imahu5BzzmASbm8fr+4XtKctHhrwuDD/XcXO51bRtjjpFTVf99K/Bcs+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4z/bBMeXhXClhp+wEjc6gike6SmLFByTx/dad+ZMRA=;
 b=MCONoBWvXPpj8iJG77lRNpE8gp0OyDT5mFHs2R5ILbFtJEHEs9sguGk9xkjM/2IEuv2huj38m0+59hiowZmgQAbtoVZ7FEWroF7meUzu2Cw21xzv7lumBI8gbTzg3mO1ayhsbJevb6Nbhuuai3zi1zp1DzETS6s0v/OD/YrGdoXhwe0EBEo8JVvha2eZKnn/ef9uzky/FnxJun0MjEnPt5b8k0q3knGE8l5wyj2FdNI1E5JhI6C1NQTRyS3FQztvo+76QYTTiawqA4yIK8hAF7Jc7RRKBzU3QLnptPpid1G2WrAcaDaHAsDMuZREqIfsu9gX9oqa1ZRI5vKstnHn0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4z/bBMeXhXClhp+wEjc6gike6SmLFByTx/dad+ZMRA=;
 b=epNMP8ajoMMRTPy2oqdaL2urpMKFYmv6DhXQgpJdM7Kh1TaVF37UsoA/3W+Fh89q3c2MNYM9DcmwQ1Qj44D8qWRhMM/qr0DbG00EtjRDFB6/8BksROpwpxi8d6Li7ryr4tGJc8015Ro9UGDOqgnMXamBrK6sSwPt7556lXPNSVQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7470.eurprd04.prod.outlook.com (2603:10a6:800:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 14:05:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 14:05:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [RFC v2 net-next 1/8] net: mscc: ocelot: add MAC table write and
 lookup operations
Thread-Topic: [RFC v2 net-next 1/8] net: mscc: ocelot: add MAC table write and
 lookup operations
Thread-Index: AQHXk/d6/YQinAuyVUGo8AzjgjyFvKt5TDcA
Date:   Wed, 18 Aug 2021 14:05:19 +0000
Message-ID: <20210818140518.5y3pbpy342oeyxac@skbuf>
References: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
 <20210818061922.12625-2-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210818061922.12625-2-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72393115-a217-4268-9b92-08d962513648
x-ms-traffictypediagnostic: VE1PR04MB7470:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB7470D9460B35248D92585A25E0FF9@VE1PR04MB7470.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Ptn3iVHKZ3XAVwylbiqwCij0zTlWac3DTMtXWvPpQ7l87jRJHNF5vgnyEBcab57g0n7bTX7r3SKy/Ww5lvoFHHU1V/WnTqsxCItsrSdVpOJkTr70kbnXMuimTadAQLs4mhzH/NY7SY8ICp+hi48kglYcUxSzIMpqwf5cxU/vKkWkcwTB76PqnWkBPNrh4LYDspd8ddE01BM6nBYQVeTxTmN3Ydf4rlW257HYk0rKF7NCf6DljAxcodClth+XfUb8e4u8zBHehQh1UNmSzzkkbGUxytll+lQCmJh1cOLP7XlL7s42N0MoU6kkRkUGMWwgq6mvHht4dJ+fOTcPopYBIruuY4u++N31ubjD4qt0xrKdUZWTuovfuQRpAlPnWUv5JM+Vvc0Yp98iXEOqZL5QpXLNHcQce9QkdSjywJ8uTM1dfxOmKvDqNZd5aQgCYOtDr5mCfRosx3GH2eTQ7eOfKYXCYi9lGNQ6OFuGHL9kNe81Rv7P9nzuepUZO+xJSVJw10UVRKd1TcfHxTQzaWdQeJiY0Hi/Wyu00xv688cqrIl7b5PCfp5MU94yCTOUlLxDo5bVXkDpbPIJsLQBn0c8JeEyK31ynmkt+52PvVoUO+11kRmpFRC94PhcvxZaAR6yhkTvgCLyj/jEmbEGVPDplOPizsrL6sLHywcDfSyZYeQcnB+hsXUqA0vXSYjUujzpRgF8Z9n4yYJ2q7D9VYE0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(44832011)(2906002)(508600001)(6512007)(6506007)(4744005)(54906003)(26005)(38070700005)(33716001)(86362001)(9686003)(6486002)(5660300002)(66446008)(66476007)(64756008)(66556008)(6636002)(316002)(66946007)(122000001)(4326008)(38100700002)(8936002)(7416002)(6862004)(1076003)(8676002)(71200400001)(186003)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uXolSSHSmfpup0LT/y9PeCDQGTJBnfrtGmO99RE3FjeAnPMgCJG0R5+ADYcZ?=
 =?us-ascii?Q?HYKxAhl7WkM/fgBtAHl3HBrCegycIZXQ+wTUmQYrCWFIuFjl7cGBT6z2Lee7?=
 =?us-ascii?Q?vIZp8D/avHLAde8ESwgkrdeWOVcEkvggpj/O0PjJMP/QBq/FnSrx8IarYtWx?=
 =?us-ascii?Q?HBS4KO9nT/fmxmiQc2F6nc6WX5QYdFZ0mIIp0NvrKMKQ6yq9pHNrSzTmUMgi?=
 =?us-ascii?Q?e202lQcHtl6i3WnGu7yKssjEgPS3O2WE2hO8lPailJPy4TCjUktXbZAaN42f?=
 =?us-ascii?Q?IAohUU8ciX4KvI3fMUFDBHC8auMl7YrUckwgCWUAA2ODtX7Df2NGNd4z3z8T?=
 =?us-ascii?Q?xVELEN4sf/6BPuN5jXAGc/vwtVaw9R5OudBMWHFlw+6hkUkWIA18zbX9eFo5?=
 =?us-ascii?Q?kFb9uN3fgLC5NT3Kg9yS2sviVwG0fOkLOoYEl4Ourh9C/dzFDCNJ/cNwmXSY?=
 =?us-ascii?Q?S9tDPSSOA6FYcqHWmkYP6lf3JSJFr9/IbqiwxHLcYl0H4n4Mvxv1PY1lPTT1?=
 =?us-ascii?Q?JLWxQxrwVb4evJw+qnr/q0DsOOXfHivGPBJCCtqiBUufr98ySqc/CL/brDiB?=
 =?us-ascii?Q?yWzpT8RrgXmEO/Wpb0mNujsrJIfOcPAf/Y/wDIoNfIQOG/2pO91/cV6e+NSV?=
 =?us-ascii?Q?o/w7yRQ+4ZahsHgJjV1UzSKi+/Vcf9nHl8w3hCpFnfoez1eIRPdGRU4cAhz3?=
 =?us-ascii?Q?cAgIDA7+OYpeJtwlX1bbYAFpTciixlGZkOAE/lOi08R9DAC+mNImfStK7oLL?=
 =?us-ascii?Q?mjtbN+2auIc/eh8Io+eE5jRL1KWMcLxnTf0t4A/lh8zK6HKobzRtm8Rh2uMZ?=
 =?us-ascii?Q?gnJiQCvGx1+XL3hzBlwJPOJwrzFvdcU0bl9I+59Qq7CRe/Tvf92NO3o/qhKn?=
 =?us-ascii?Q?Ec4r6JSlIdH/rzr6YYaV+WbrhSUsCPaZ8KDZB+6sexm51o1jRFOrqLckglnp?=
 =?us-ascii?Q?MW5/n+JagwFKCufi4ju6ZNlrJNtBEzt9pRIEA/DxRrHSY+blQcXuFwDndbiD?=
 =?us-ascii?Q?V/oS9lSIukiu/IRWXiET93bXTbZ3rHLQFfjHPBdovvFsUYJI3vVl8creRQzO?=
 =?us-ascii?Q?0rdPUYGCkXultMSRRtILiSuoK1/fMA3UR9KdSPnNDw3TrPDnHYn43IQfUTri?=
 =?us-ascii?Q?tVHl0WsaTk/XL5hD33Z9lOugJHYT19I1F7wr1EhQWOVDAxDqFW0xro/d/a/E?=
 =?us-ascii?Q?bcch81oD2HJC2T/dO0zM1FvCeNScbt8Kr+K6R1q0D1ILaQEd6gqQBhU1hJX9?=
 =?us-ascii?Q?TxRrySYpQPZ+m9sYvEgzRiMT1UUrBIaaGS69qOUsXqvCacwPZW8wS1u4dI8/?=
 =?us-ascii?Q?c+4quAlcCRv9MJbQ79KdIRc6?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E2DF6FE6CECFCA4AB29049C24EC8C8AE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72393115-a217-4268-9b92-08d962513648
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 14:05:19.1447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jHn3w2zWuC9eocdAuMim94pfzsy1nlQmhkPFmjejcj4OSs+CU47f396A8xhouc1oIXnjWnWpsfh6/ldSakTtmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:19:15PM +0800, Xiaoliang Yang wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> ocelot_mact_write() can be used for directly modifying an FDB entry
> situated at a given row and column, as opposed to the current
> ocelot_mact_learn() which calculates the row and column indices
> automatically (based on a 11-bit hash derived from the {DMAC, VID} key).
>=20
> ocelot_mact_lookup() can be used to retrieve the row and column at which
> an FDB entry with the given {DMAC, VID} key is found.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

This patch needs your Signed-off-by tag too.
And I think the functions need their prototype defined in a header too,
otherwise the compiler will complain that they are unused and that they
are non-static but also no previous prototype.=

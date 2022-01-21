Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BC04962B7
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381785AbiAUQXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:23:31 -0500
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:48868
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232442AbiAUQXa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 11:23:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axDXxJ6v/0r1kLhjlxKrgaClDBvJwDAnYKSAUonAsMDvszEn7NeE7eg+gGXg3xAidik0uQ69nliNlAjQGPj1tZqdiZy46bzDIsnyGEBzp2Uxxf0SIhzPmQhFrpurN8QATkRtAFkAvsFadJ4qGL71J7l5esRsMgIpin/6GBMfZJoSSMwc4fjwwExY2LnyoFGMu0l4gM9EEQQZVllbbkOs5vDuTeaXsKEOttgdpIt7bjalYwouHmvLOYV5vsW9Ys6rIo0s5L9HPU3Xza4+bq34seUJKjesSdQE5rupWdyGdED7ZioZnvAnqmD3/B3i3yFWmSUY7N3yDDzEAvX8q8mPrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARBxoUs+k3PuVk/VPKoEhGQaWa6X8HxwMLuu+SbAfuA=;
 b=gNwYN+wUdzuCRrTy6q6YF8cv5gD53cjGDGYSe9Wxg0eQNAhHdpFqDxrw5DcvwGmFIogYco8D9wi5TrHIEQfGPHsknbgmytZYvW7Tw939M7/tjqsRdmCRTn60Yy43xHYBVxsqGyMrknK9p3Dm/8TGpYJAF5HANKs9V4YAIyRIKDoJv5/AuGeUdiQHIXebQJPHLOIH95MfySLT4YIyftCprr5DLzPdHK/EHamOAbtdA9H3635wdw0j0QOW7gvwKE10ZwBzPjfZe9vjZ/YO6vVRB3YPPmFXRCnx5tJnskNkxdD41hRBfs/2/UYMG+Qcjdchtb9musreNM8aX7UnoY+Hsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARBxoUs+k3PuVk/VPKoEhGQaWa6X8HxwMLuu+SbAfuA=;
 b=OX8ye0sJijkRh6BRFoaBSHxJ8CF6OL3wmMdHRiF4YLbad8hFs8r352FKH1pLG0LiLFyJp/Fc7TYC61p7ywwBRoPuD1TnBUUejuHMgatjaaMCtgqIm+jig+c8mSsaRR+uUWPYJx5gCkST3xEnGW1AMlyIgeThsRhKq7BeEcXIjoo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB6PR0401MB2311.eurprd04.prod.outlook.com (2603:10a6:4:49::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Fri, 21 Jan
 2022 16:23:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4909.012; Fri, 21 Jan 2022
 16:23:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Thread-Topic: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Thread-Index: AQHYAPlHUZ7+aaeSVU6jmUK14JiGzaxsOSsAgAC1gICAAAeKAIAAtFaAgAAKjACAAA9mgA==
Date:   Fri, 21 Jan 2022 16:23:27 +0000
Message-ID: <20220121162327.4p3iqbtt4qtnknhp@skbuf>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <20220120164832.xdebp5vykib6h6dp@skbuf> <Yeoqof1onvrcWGNp@lunn.ch>
 <20220121040508.GA7588@hoboy.vegasvil.org>
 <20220121145035.z4yv2qsub5mr7ljs@skbuf>
 <20220121152820.GA15600@hoboy.vegasvil.org>
In-Reply-To: <20220121152820.GA15600@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a050f50b-350f-4475-f1ba-08d9dcfa5b44
x-ms-traffictypediagnostic: DB6PR0401MB2311:EE_
x-microsoft-antispam-prvs: <DB6PR0401MB2311A373BB46BF20A9B41E7CE05B9@DB6PR0401MB2311.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vO73gZ86uavaM274b3+o02Ir+HPXMdzkXBUmCMdOXpgBcNeQphuaSY/uF/mOPBmSLgyKypgH5TSRXvSuTMQtLYN4x+AN4jdiq458u8SinGCVekOHuvNqo3MTC1eVGMbv/LzDOtQB1VM28f9tpr4k+HL/xyhAiFgrWUXGmPIimbd31GOWaAp1JYJDWS26QsaIBijYy5l3Y7VplefB1fBgUt9gjAlj1SpKi8TWVFoEIdjeNIeiLIzgWJfj+mOyRnGffQmqL6rNszBoVjn3sRdA0EFtA/f4bl+PXmVasWJ+4ykZD99m2uQTg87JsLXRSFIPA9mI2tR3tgmxL2/A4u8nQNXt55cxv2I784yQC5ttHOmziqHtXc1Zl/jVtCzIOi4MrLFOEDmfntVrbVrX8ie2Ypf0bbcktrVsvDQoleuvXH/Jdi2L1Rd4CspUl3mZtIw5ZQKW5fPyak28TNPD1utMHhCgqRz2aHGurV8wqVj0rQcER5oRsVZl8CVqGZ4fhGT5oaCgXCBUpLdXrT93Sc+3n7BNGt/UUMLMMSNkXD/N7Obkl54Aj/UMfjjSv3yPisZOuGBb7v7gJUKrp6nG/FUObQzeIWmaF7PWwYhn60kSo/5LKDTteLatL3gTKuk/HvDMOg02kLMIkTx36FA905dQs8zYTLCMbXuUhP6ZefDD8vFVfxh6HRNyr/GbbIDZACnDmuNWlCIB6N53odl/hj/SeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(2906002)(91956017)(26005)(4326008)(6512007)(9686003)(1076003)(76116006)(33716001)(6486002)(6916009)(8676002)(44832011)(66476007)(66556008)(64756008)(66446008)(54906003)(122000001)(66946007)(6506007)(7416002)(38070700005)(86362001)(316002)(8936002)(5660300002)(186003)(38100700002)(508600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OT87O2T/5z29xygX69mAIwMqeZHQgEjzjog6cpTVYRtRblq+P4lkrv4JQdO8?=
 =?us-ascii?Q?LqJUFfw1JYZ2y+4tSasnFyMFCeHh8MMwhpZ/JQBO7sWHo2JAph2J0C6b/zoq?=
 =?us-ascii?Q?M3oPUe4bJoKjTkKIJzw01hQYXHZbAMxHbe29+ShQYqAYxtL01DsQ3MPHtAJY?=
 =?us-ascii?Q?GNGcSkS3gmWhElV8SAfCtFhargPKLudeEd0ydR51dEEcQqHft9pjfCph9KUR?=
 =?us-ascii?Q?u2KSWuED+Hb9jV6ZhrW0pVwRChqXVjxXQPNE11BX/FfxQbb/JGwdA0HZRyeY?=
 =?us-ascii?Q?yJTHcRYqLowaCmEWwpc+QO4egQaHdOgI8/D9XGZxRDGuya2b/DamDk+fOeUq?=
 =?us-ascii?Q?95rfZWFACW+JE+tb7imZnOfr4PmgHcwsikDcpig3D6WcN84R5q+kNMVDYJWX?=
 =?us-ascii?Q?5Fgo/zdQ6laBmJ1sJ82zt9sYXKYyXkMN8T3rTLzEtU8w/p13rcQ+MzYMTrJn?=
 =?us-ascii?Q?TXfw7cKYDoacUSqvwnNj9M7wjoFfHLw7kZBpxV29eCYgXy6B9oyS9/e+1VRF?=
 =?us-ascii?Q?j3WyT1gdwRCzETIXi0pyu5xCYAVFls/OZwHzXjatX+hLPzM9cZRgdUXgVEFW?=
 =?us-ascii?Q?ZtRypiGFqDdYpPYyEY+C2E96MvwWSkgbpuSZg63lx7xM0SjNnXxR1uhlFrde?=
 =?us-ascii?Q?5MWr0XiyvGStYyk4ag6gybhW8pbVIaE1qExpVZACFunPBg7NAPrTyJD+rpq8?=
 =?us-ascii?Q?Yb6LHPjp/ofLAVwQEGG16iAy61Ux7IQAw+YD18ODWprrOaFogHTKULjX3weD?=
 =?us-ascii?Q?mp/vv9yyUahmksWtZ5eJyRy1Gr7EZgsibn0iT4mRJYBR5bn/gaG6W2kgzObt?=
 =?us-ascii?Q?HrWWpoTO+J21F/FXyzk7pBvBNnMmaCIMxFepDt6QTjct5Tb4RE/Trm6S2kop?=
 =?us-ascii?Q?2u2fkdLawCOyMwk643ljjb2ual7N2yKCOfs/NmClZwjg0dvjQzoz38i7aZ3A?=
 =?us-ascii?Q?oV/rkuy8tsonag/0IDBnjbtxecRBMrze7z4ZFT00u6bbMP7DUBj65683qjhv?=
 =?us-ascii?Q?KmtGxwsdI0+m7ddRoJ3B6Zno3E+HR0n3bPBaR9xNhb6pyHls2cUGGFhGbq6+?=
 =?us-ascii?Q?DrDrKbUqmKaXk5eO4CoW36ixetgSbU69bK0CwhK7dianr3RdanJMrtjGxyyx?=
 =?us-ascii?Q?S+TszOEe2NXKeaxoLac+OiD9eyHjTUhCW9iCez30IB7tUsw8Lm0ZtQ0ooDzy?=
 =?us-ascii?Q?DP+TC0/Hl0rdHkMMWxNXryZWq9Oz+QnCCnuWl0CWQMzChA48eUqTeHsHNmr2?=
 =?us-ascii?Q?fMZmHXJB8DKUoLVRVXX6bEyXARS9vQ1CvJh+ucBESLcxZjJtveNlf+9m2lRT?=
 =?us-ascii?Q?zRxYbhEFleWduvTr6nXfcXt22v413ecDAo3CeutyQ6R/mqfL0U720eQcjE6F?=
 =?us-ascii?Q?jhHyZvcC+8AVFiDKy9VjbbZg7toGbX1oKBpNgNQTQbWOK/bvB0OLMCdPoDVh?=
 =?us-ascii?Q?sqkK124TqjVlAgg5f+64gnMwAgiPDlNs5AM0I5RD4heU7SbA/++Juju2uj8e?=
 =?us-ascii?Q?UROubqVtlbtuohTyZhUG2w6S0F8y9H1MEQNZKbKFaUvXFIitEG6AgKuWUgk6?=
 =?us-ascii?Q?bJwURFzlQ1R0GT8rElLh/a44ZvhtLJAwE5EmzqrZsCKrOx6G/CHevkCi9vrC?=
 =?us-ascii?Q?4TS1wAWcGGrbeUau17actX0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2773BAB5E6BCE94ABDE184A97F424738@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a050f50b-350f-4475-f1ba-08d9dcfa5b44
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2022 16:23:27.9409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SFucUTXJbvB8IjM6/FpqYCvA7EGIO0DBQuHN7CHhbaTCClTFf0I8n4T2duPwcTDUJSwEUgk/zB6kwNUN9SMs2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2311
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 07:28:20AM -0800, Richard Cochran wrote:
> On Fri, Jan 21, 2022 at 02:50:36PM +0000, Vladimir Oltean wrote:
> > So as I mentioned earlier, the use case would be hardware performance
> > testing and diagnosing. You may consider that as not that important, bu=
t
> > this is basically what I had to do for several months, and even wrote
> > a program for that, that collects packet timestamps at all possible poi=
nts.
>=20
> This is not possible without making a brand new CMSG to accommodate
> time stamps from all the various layers.
>=20
> That is completely out of scope for this series.
>=20
> The only practical use case of this series is to switch from PHY back to =
MAC.

I don't think my proposal is out of scope. It deals with the same thing
as what you propose: the kernel makes a selection by default, user space
can change it. The need for PHC identification in the cmsg arises as a
direct consequence of the fact that there are multiple PHCs in the path.
It isn't a requirement that I introduced artificially. Your solution has
a need to deal with that problem too, it's just that it omits to do so:

|               When changing the value, some packets in the kernel
|               networking stack may still be delivered with time
|               stamps from the previous provider.=

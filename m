Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F271649618B
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 15:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381270AbiAUOuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 09:50:40 -0500
Received: from mail-eopbgr150081.outbound.protection.outlook.com ([40.107.15.81]:1446
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351303AbiAUOuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 09:50:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJ5g/IUKHxnF5Mnds+gbEqNkwYoDB6Eu/t0xxSgd1jQ1XPqxT+BKzDuNVHdp2ZY7B4cqKM61yypQM58/AuYNUciuTC4+NL0bauv5ro7yoDf8rQ9Q6RiHxYq6lTi9y7z95dt94THGSpa8EBTSqW/3Umx7UfNCVOvuoKnrrogSVmbAf2Hccegc4dyYvIyWRNHwBIKfySgoyLfL9Uj60VblEf1ALLku0uAUgTJw3hfyKQHD8aeAw6RKAdX1DeWkPlIpJi0DQlTPNoBLQ6/g9n/GE4wFm9vlqp6JEzms20kjAOELKlhBaWhuS9iTMxq37nC10lF3NvWw/2Q35Jv0/7ckGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gi0egkRzxFrC/UDy0knnJyQO4ICYMjRGq09tD+Al2SQ=;
 b=KHAkoCDc+ZKu2pfXHIpcddT0N3s6ttycxr39niRxG785uyF4CxosARxppEWHIJrykGuLtikYuRDaJYXKGp0LhLkmJ+FnzC7Y7k1cqyZybbU5APanGiVADEBfHQDcagQD2qB/DSdeYNEQE5HqYgf6USRr1TNCYOfvV8Dk8Uz3gIlsWVaWccWthLXSGZEim4jYx+x2sgRAISM/R+E1/5xhdOMBWpAmNYy/mRjIHKgjL/Je4YumPm6ESOCL0U9DWJ9Q9oetn+ZkcPmkRN2yD0vBGz6z4b9sjFzEkRvuZFPZIfeOIpkUdnktl7DCvoiNrhkV2SnvVz94ODt/iGKfRV+dNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gi0egkRzxFrC/UDy0knnJyQO4ICYMjRGq09tD+Al2SQ=;
 b=SKFRpRMTAyQQ/G30O2PPcZT5YJ+D3wK6LMdM1G1MlVxm6Cbjg14qyKniuDBMXhY+Fa8MZDdK3wdv5Hvt/48LoBOb47Hs2oaAYFhCuKeRL4O8OwdS/6HCtZUy91wFW0ZeWpLSxoF2qcuUVcF+pXDgRiLmpnjyebGnz9prt/55ifI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5301.eurprd04.prod.outlook.com (2603:10a6:20b:f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Fri, 21 Jan
 2022 14:50:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4909.012; Fri, 21 Jan 2022
 14:50:37 +0000
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
Thread-Index: AQHYAPlHUZ7+aaeSVU6jmUK14JiGzaxsOSsAgAC1gICAAAeKAIAAtFaA
Date:   Fri, 21 Jan 2022 14:50:36 +0000
Message-ID: <20220121145035.z4yv2qsub5mr7ljs@skbuf>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <20220120164832.xdebp5vykib6h6dp@skbuf> <Yeoqof1onvrcWGNp@lunn.ch>
 <20220121040508.GA7588@hoboy.vegasvil.org>
In-Reply-To: <20220121040508.GA7588@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea97deb4-a1e4-4473-d1d5-08d9dced62d8
x-ms-traffictypediagnostic: AM6PR04MB5301:EE_
x-microsoft-antispam-prvs: <AM6PR04MB53012609E8B3C073AB701954E05B9@AM6PR04MB5301.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yqrd56uX/98uFcAcQl+0iHnFI+/h90AZ9nId9lPSDsT31jAyP10bbqI4l54pWFvU2dZdBZ2EB4kPO+UrttR+IW3zXToSA9btWMyLz+ItaNxSrZ0uiYjPpxltv1az895R1hWt/2X+UlxDaQ650SO7F73hJxG8xHwqW1ozHOLylxQRJMh6RgwYMUgn9lAgAOzYPDWXEApX9vKNgy2HTiGcL5HO3R4p1I0q+PaWCrBOBcYxRltQAsd573OHRF+KvzD7Vejgv75VWb0uaFMcZF6wlKuSZkhR8OvqEgxNhedyomuQeBBzjd+KPbyyWQd6VtY2sr25AR3Qn47kw7hZdmQxrHHPg7OCY/JePIqDMFsxet6s8FFBqdDhWacua5OFQfbyzNG+ldHOOxKSHpv1jLssh1003QO224nY+wiWcXuHGUmoRLs6vErwSsKkxlV/bHZFqVoMehRDSh1hR4BSULpMKAUKjorE35FHzciLTI2TydVr2tv0nefrwrTX5uLyRU/oKL7rvMfFrWb4w1wRtpTxaBAIMKgu9mkOmAkK1ycBeVJQeEIuxc+zz2kYqCslCcujBmuP6KVLkHIKcXp9wilPuLKpt2I1W65FaCXkq5Cvx0KvXBG1JetKSJzFvnvQZzvFSkryaIy0ncOS7djU7gJDg0tLQBAo7H+fI89JC4012WUrOi80Z/hP/Nw6tm5ntf8gADqUktQT9wrda96VJLaRZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(26005)(44832011)(66476007)(38070700005)(76116006)(186003)(5660300002)(4744005)(4326008)(86362001)(8676002)(508600001)(66446008)(64756008)(71200400001)(8936002)(66556008)(9686003)(66946007)(6512007)(54906003)(7416002)(2906002)(33716001)(38100700002)(316002)(91956017)(6506007)(6916009)(1076003)(122000001)(83380400001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1J8+XAR7MVBk3s9YUdnHqre8Qm4Xzwc4AyGuFtkuCN8B+MoVkhfEMmrlcLEo?=
 =?us-ascii?Q?FpdsKVuDAkTUdoPFYQpv9PBejCiPgyvepdop0ZngDULYCTA7KfTjkgJbtEMs?=
 =?us-ascii?Q?au5qIBDSbS6AcM2qJ9QDG14EpkRwEpM4iJv0WsNF5xAPQkWhV3w9K3rwwyAT?=
 =?us-ascii?Q?5Yobx3nMmHD7+vW5ZPTIzTxq3mzIBw4jfrIK9MAXb4UWJxEK7lYMazCLfrE2?=
 =?us-ascii?Q?iPQLsQnKjHEnt+0RRqzu9bm0/wVXBjlimEo6S8UBHjp1j/Po78RkPMGx56K0?=
 =?us-ascii?Q?sv7um3sgcLnsVevOCbqYXf5d9nAoOfrlffkd8i4ixiXtzvw0AqVzvqYZ1/mF?=
 =?us-ascii?Q?HADv+G0Hcwm/nBWJtrecCQri9aTq0UucLBfCgS9JWIOcoQ8q7hEDnn387tb9?=
 =?us-ascii?Q?qe0h55rexl6Ycab6QCkPp2AjJOf2RyV1NLqoE+bPNmTAeKvou2huRKrUPyf5?=
 =?us-ascii?Q?bZtuC4YA7NCY36E24XmGQ53s21jjgjQcYIIAD4Kv8rZ13LtGcLAu9OYiH1Se?=
 =?us-ascii?Q?3bOwFQti6MU9KP3c8+TNsCqnF/KyiTAFFE5prfYZ/bmjfOPgA5QybTXUJGtM?=
 =?us-ascii?Q?HAyESa0J0Z0t1CG93x7e6Gcr6pX1IxchL/GBUm0OwSTggm2vHwDkm/CLbPmE?=
 =?us-ascii?Q?TQD/JMUKZJB4PRg4Jrf+U5ehNT6+jIpjhjgpctFX4PdW07GD4Ka22FP3UqdD?=
 =?us-ascii?Q?nlia9EC8k5mIhRU+aqBP2qZ6vP2H0I6YuI/CKbeR634YIIjw3N0o3glAyiF/?=
 =?us-ascii?Q?dz3Ij+M2gdeEmxtvkI0Rvm8YwgyigTfVgYy7DGjTdPOI0w3kuKWQnQ2fv1T6?=
 =?us-ascii?Q?fpk9egClxmBqdTf8L9uPAkxP3xj9Sk2X2DDXv1zCPTSL6Bwsv4BHBqcENWGK?=
 =?us-ascii?Q?2HgVFauuWofb9ZHlW0aaa3Kn46p13RFNdbZb2YtUxsFdXSVIfQvtgFJfayvh?=
 =?us-ascii?Q?ogT7GCn0CVSDbXxUIlE/eDzJQ/3J454fDkkLXz3tKYahJD+GHg/TeEJMWvod?=
 =?us-ascii?Q?3VwgE3/LFNDc7nW9zfCQsMFkEd0MGDW/Y2VjUL/pKiXemvi/gZOlVeoSuTqm?=
 =?us-ascii?Q?oiga1zjsAnovk8T1w+sSVuqD0z9HkWWhazY95NGlOcT8syZ/H+6tmQCxeBCm?=
 =?us-ascii?Q?cdQj9UltSBwtVdVPWbJhd9kwWmrjxwb7tILqonh848LTtETZI4PBjM6iz1FV?=
 =?us-ascii?Q?j22FtU0G0pkLVcsoipab8D6ws2UoC8M43YYQncn5kSAJVPGMVIseU2743Pjw?=
 =?us-ascii?Q?oioUAF6GDflxMHA7auXqCnHF69X4DMnkDATyDd+CsCR0JsrqOQRPhvPDKBqq?=
 =?us-ascii?Q?kGGiXzz05bHefdGFJ2bufLLQ4EgRWDCJTD0zKddWf7U18SwIJ08e9hW3SdfV?=
 =?us-ascii?Q?bn3SKP8ewiCdphKJZtpiLvlF7n1pTq6Aec4NWHsoDUqY2QIbO/DUWelmG5BD?=
 =?us-ascii?Q?bvjojMPQ5LdWgF8W0h/ds+fa/hzcVFibbQ90CfdZC9zgef3IA7qQtZPsm40I?=
 =?us-ascii?Q?Z0Ft8EXGrZvXek65yQhRgdQ1PZ2UVuSY0ML3FCFxrcvt229lLENDZthRJLRM?=
 =?us-ascii?Q?DHKNFnjzBIrP64zaCzLaTl98lI+D06uqmh/ZLz8Fj/Hb/KpZl04yMvgYoybk?=
 =?us-ascii?Q?Bt8WCTR5dWrbz8Gm5jtxyKI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6DD71137813661469313FE1A0E80D3FC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea97deb4-a1e4-4473-d1d5-08d9dced62d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2022 14:50:36.9310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UdYw3RVy48i8J8UdDRz0krjXUCgHGi4H5o+NJQmrxibOMvy38dxBpP0nesjDp5X9BGoVQf4HCFv6Nhh/IH1nHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 08:05:08PM -0800, Richard Cochran wrote:
> On Fri, Jan 21, 2022 at 04:38:09AM +0100, Andrew Lunn wrote:
>=20
> > So in the extreme case, you have 7 time stamps, 3 from MACs and 4 from
> > PHYs!
>=20
> :^)
> =20
> > I doubt we want to support this, is there a valid use case for it?
>=20
> Someday, someone will surely say it is important, but with any luck
> I'll be dead by then...

So as I mentioned earlier, the use case would be hardware performance
testing and diagnosing. You may consider that as not that important, but
this is basically what I had to do for several months, and even wrote
a program for that, that collects packet timestamps at all possible points.
And to your point, the more complex a system is, the more important it
becomes to be able to diagnose it precisely.=

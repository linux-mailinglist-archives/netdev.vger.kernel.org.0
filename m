Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C93D585A6B
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 14:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiG3M22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 08:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiG3M21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 08:28:27 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A4319C1A;
        Sat, 30 Jul 2022 05:28:27 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26U9TObH016334;
        Sat, 30 Jul 2022 05:28:20 -0700
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hn20q0buf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 30 Jul 2022 05:28:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ea0BTiqqD+agwgfw1FVoITpHEybDxLwDTQARqGsudlahUOnionyfC+qtUr65CBVo25PGI83sTAv2U7gZgGtKPaO/xyf4SKyW8vAcPIzeIoYTyieztwXzjTpiPHVqCFjXCQoifdVmSfSqfXz3zvsvMc2sigAdurMKwWLOnmARpNgHwZX0qeR8YHRnwCDy5IrJIlub6KyaV59CxPsyi+GfY4GcemE6ekZGGy52AgHQ16+aCFz5n36KbcdQJJo2Ad9d29McRojtcRkILC4CjNvlWPcc4a6j/MxQf7VRCXheIBkelfUiAzdTdwCHagkYsa3Vv+pVlTrMnxx8ThcGKnv2ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TBehImMPx52YivJaXuRqGC+TyBkyUEuH5GXs8b0emCw=;
 b=gMtG1GnqSVHO3/0Hrch+oRz2DtO+PvwnQ+MxsunNc2PchqcTbDDi3S13JCxWws35qduBoNJ9GitGQHg1xJmQNjsSgPojJ/YvUlTB4W/7vfEOJuvRE65HyNcvQ2D5+SG12KA2/aC3MsSQcQTQeXNiBfzbZGX1YoN5J6Nz3VhKAuFLnPGzEhzBu0ZJFYqKY0XCITfA1isyNqWvyc/ASju5EkBLHxcYRq3jBIIMpfJpeLQoZS43bjHFOJJTkBXoLirN9E+OaAGcy13RfHuPEmSZXuqmg0PvVgkComBA7QtYHyhnI8JLPkkhnMqO9I0ljnevtEa6Cbz5cwVLnGwq1wIIDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBehImMPx52YivJaXuRqGC+TyBkyUEuH5GXs8b0emCw=;
 b=nwltUZnFGihAfGksfktv+M81HPD2P6OE1rECnuxr1yaI2H0qjob4P17s3+cc+jDmvVQsACyKRmF6+MxijZf/8lxTp+y6gA2ei8cPzDvBnLZftwYASJpRa3ZCOB7q5VCBnG9MlxulykBn2ratsYL0C3PZgclwBC6KZqdm3Uy2QL0=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by DM4PR18MB4318.namprd18.prod.outlook.com (2603:10b6:5:399::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Sat, 30 Jul
 2022 12:28:19 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::398b:afc8:fceb:cf62]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::398b:afc8:fceb:cf62%7]) with mapi id 15.20.5458.025; Sat, 30 Jul 2022
 12:28:19 +0000
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: Re: [net-next PATCH 0/4] Add PTP support for CN10K silicon
Thread-Topic: [net-next PATCH 0/4] Add PTP support for CN10K silicon
Thread-Index: AdikDywq8wWbQafaSly0qemFHpgwvA==
Date:   Sat, 30 Jul 2022 12:28:18 +0000
Message-ID: <DM6PR18MB321268C047FEFB3AF8833409A2989@DM6PR18MB3212.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6297bfde-b370-4be0-afd1-08da7226fc27
x-ms-traffictypediagnostic: DM4PR18MB4318:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MY/dTUmDF/hFZozOCT/wUDoJuIsmSRB6+Nv/75Ltgv3t2JHvm1CK+f+7CSw3Arn3Y9945iIQp1M7gPUdmtJtuTUCJlObZMWmXW3Y4bxZRHD+BGz3IEnWgomMZv+/FPpiG83c6SDXQAFtutxZ4Ug1FD0/ym+hmkyVVH5p2cuV3zz93X/1fx1GN8LGLsm7T87NCP1QyEULV9UPRoUetg07Bcu2xp2Csb0/PITNefL7t7KYElYF+fLwxS3AnEdnrnfupzo/ap/rAUiY4PZvVsp+5LbdpL3+tLiad++DSIVqIdnB1pZDeKcyKEs6+3vsh3FzgyzB0zwiwg9/zmXReMR1APp/Q6u4kRz506xqLYkTxx7bXiFEZ14HdkgW+Oeh4XPZrkW2LT+icw0/yRpgmJWKz+iP/5veiTbqb2qEiIJUit22Wxrmc86IPIkskvQIny6P9CwAhD4cm14mtP7KbMDaewOP4gcOAY8wicj7JUbgmSFFk1+xEktxd/Y/7HWa5LtxZiNAc+dsEQQ+G7oLv7LkGYIF3OsbRkgaKAIbJkUi+I+eamg7CbiilxrFm/oapsPH9lDOQDWK/Q79s0wwlrC6DxBZn1qFI23PQHiM5HTbJqeFV8NdvSOZq5XGvm6ubKx3D3oy+iYlx7dBBTSgtRDLy8Gn4p0RE7d2jZIgkGsSfr+3E7VtYC3S0bZ2reFcJzv6vVWcDD5vSaPNi/x6hD3ZJs5ez8qgODfWN0R3+iEakQGrcrR+cRU81wA3/N1Fnp4L81iHo5F0RxNLyur4h5WrKJ1WWMyrqBQqqV2QqXKxA7w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39850400004)(376002)(366004)(396003)(38070700005)(86362001)(33656002)(55016003)(38100700002)(66946007)(8676002)(66556008)(52536014)(76116006)(64756008)(4326008)(71200400001)(66446008)(66476007)(8936002)(5660300002)(478600001)(316002)(54906003)(6916009)(107886003)(122000001)(83380400001)(186003)(2906002)(41300700001)(4744005)(26005)(9686003)(53546011)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Gpm/HYnznV+0QtEZsXq2+UiyehyL2fm/Wga0cBw/Yzm5KlY9Phn00EW/Nilf?=
 =?us-ascii?Q?/RKSJHUVH8IKn8Lu/kofQr8vn2nvt0XvJYlU6Tfzwi3JDb8PnnaZbS0Tt337?=
 =?us-ascii?Q?Q0RutiQjJNjeSuGCJvhy19lPssdASkmjeoHulqw0iLhdCiCgL1ximA5sNbC+?=
 =?us-ascii?Q?1xzNq9Pq8uRAUNH0LJIrybc9oOpff0c4DIaqYSPggSW+RjFf3mDfIwW5t8pd?=
 =?us-ascii?Q?T+CgViv/wTFXw5br67kRBikyNyN4HUwKvu/H4O7EF5DQU+reoly+wefsUeRW?=
 =?us-ascii?Q?WC2k3QxvfER3XR9WeHp8Y5EXHlhcPOEobLGak4RiJB/3EAbGb9vaPkVDzmKV?=
 =?us-ascii?Q?7MWt2UgV5Ygfcuw+6SzVZQL4kldjHVM8862Ky28yN8S+nD78MXBivABP678k?=
 =?us-ascii?Q?JbSO1M6WQxbcLY4CCOzK7+ssG5RAKcLpD0VPz1lV0K9E+VlmqgmJ5az657SD?=
 =?us-ascii?Q?HZvRcazLOTAle9FybF7LwcOymWpg4RkpTA2cFekiWnK6/UsQWpCg4AbI+ToS?=
 =?us-ascii?Q?aVbGcr8c+hUmz+f21vBv72GbbGgZfn/y0hU25whp29lZk7fOOHqZvZLgyZxU?=
 =?us-ascii?Q?CDedSQKxhEnQEdgdMal/9s/d/rJQ9yyUHSfzvPxcMlClW8LyyrsGm5E1EX/+?=
 =?us-ascii?Q?M/TB56Zc1d4QTQ0wbPWYyOBtIQ20oehzMd4+B0ZLvy3BV+yC9Pf96XsRpeb+?=
 =?us-ascii?Q?ZYL1PrrktIlSqgH+L2wSXt9Twt8wxIAVfoQ4BXirWJP0rs305/THmPvwtD3d?=
 =?us-ascii?Q?8L84F8sbwPGcaJ1v0YYzCt8biOiuBrG034kCLXPuswAWICxTP5dL7i3pFHQV?=
 =?us-ascii?Q?wuVzQMbIWIxHT1Bs8GfUhaRsAWsjfC5nY17x6jxe042/00qK/4SeSO+BnSQZ?=
 =?us-ascii?Q?0Tk3Ajls1L1h0iiOFAgLdHjJQ348usub68ePKXLLYz3csdzRwirUjtjUo9X6?=
 =?us-ascii?Q?re5EBNUO9jFBJ1XICXpph5LEZf3n7DnVV0h6j54bPOi9Z8F4byTpw52Pqusc?=
 =?us-ascii?Q?KjwM3/EtkEhwEq5WpzB3BbgB9xhRBG6ufJntPWEawSJBHqUxjGGuu2kXoQ7g?=
 =?us-ascii?Q?MafdDIUHh38de/s2UXYYlbcdQQWgGWTNgu8pAm0yi6tC7xMp2JvjXpVd4Fm5?=
 =?us-ascii?Q?UbIJsUBrxRcHYGmcyMLcRtAwh+q4ePC7jteHHIKSqAy37HSbdEC/i/IXYmCX?=
 =?us-ascii?Q?EA2cieEg3ki/teDXOL2cxWYroM0jdrsvsD32tWgFzlIudibnElzbuLucAT1P?=
 =?us-ascii?Q?q4NZoOF/x4P6cylBxx0hn7xjES6S4eYi4dH3DlG+sjM5GJwf96xHV33sG9Rx?=
 =?us-ascii?Q?FAjonmljX0nCuAtHJ0azUQb+9aoTmVeMogGyz/xn/LaQF7bXkcOcP5foE/Do?=
 =?us-ascii?Q?mhPV+Jes4l4a+Q04C9gKqSjbXzPkez10/0F9GmsVio9yumHxCDjtFYxidiL0?=
 =?us-ascii?Q?jXaDlk0osvRryHtUXfJyt+HJdDXTjZ0dYVrOYBiY2XOT1o01k/VGUsnUDOZF?=
 =?us-ascii?Q?Czt9431Vz+mKtVStsJINsyS8mAGn+MdZyb6g33IyorwiZN4/3B98hT43ambe?=
 =?us-ascii?Q?5peKZ8pd802kX/SfEn9Ponl4Ltc8ywwZajC/uKQe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6297bfde-b370-4be0-afd1-08da7226fc27
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2022 12:28:19.0660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f9pXjcpso1HbOXSdDnBYWYodGGvWHL4cBzSdGZM8ji5weNDVVZknGE0rqMN37xTsOsD868vTfJd2QhNUgTFjzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR18MB4318
X-Proofpoint-GUID: rq2leBsL3M738hADkThSMZnrPs5sTPat
X-Proofpoint-ORIG-GUID: rq2leBsL3M738hADkThSMZnrPs5sTPat
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-30_07,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, July 30, 2022 8:56 AM
> To: Naveen Mamindlapalli <naveenm@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri Gouth=
am
> <sgoutham@marvell.com>
> Subject: Re: [net-next PATCH 0/4] Add PTP support for CN10K silicon
>=20
> ----------------------------------------------------------------------
> On Thu, 28 Jul 2022 17:46:34 +0530 Naveen Mamindlapalli wrote:
> > This patchset adds PTP support for CN10K silicon, specifically to
> > workaround few hardware issues and to add 1-step mode.
>=20
> You need to CC the PTP maintainer on ptp patches:
>=20
> Richard Cochran <richardcochran@gmail.com>
>=20
> please repost.

Sent v2 patch set including PTP maintainer in CC list.

Thanks,
Naveen=20

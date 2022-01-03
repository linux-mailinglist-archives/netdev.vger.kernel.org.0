Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279CB4834A3
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 17:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiACQQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 11:16:52 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3094 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232511AbiACQQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 11:16:52 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 203FVaux003350;
        Mon, 3 Jan 2022 16:16:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=c+jKPXHXgl3Uz8t1hmKiZ+zPD7kCfAhYPS6UxFuJlYE=;
 b=jw/yna4Ygl8ujoDFTVoftXOMGuSXvuxZNqBeY4ICDv1vNltUvPi8PubONBtigSPn3VP7
 MbLT9RJQfo7JOzTFBf3nud+3NaVfMW6aJvIgQuCThT6UZA/EGkH8f2xGZJmNJ52nVWuw
 YJ9IyvdxCKh+Lg5NF5Stx06l5XWu9rpZ1Lhmp2x4rny0LinXWGLvfS7A1veRZwxl3Ave
 D/HJ8WJs+5IbxzzAH7DNec6tc7+ouonqBEMEbJuZsjHZrFM1E7G2GH2gl7h9cvby3Oeg
 umCdqqQZxl94/dxJmyNIfBTSC2QsJ6Om5zv2uH59asSuiE4FOFh7bth9GeETyKSasgJV cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc3v4g3ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 16:16:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 203GFYj9078888;
        Mon, 3 Jan 2022 16:16:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3020.oracle.com with ESMTP id 3daes2fhy3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 16:16:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXTySY17++LjyDMGbAG3j4XVDRRYRb/M7wsU8f2wwfLtLYm2IprqezysJpMCcF1u+u6I7nWiddKZzYiXz2aghslwtkTJzr2RSpl2B9mu28jQt4I0hGKknJzUvMJI6I3IasnSgVly/ZKMi2p+NZczdLKPaNDp8Y2mP0hfJJs7NpZxO/vU/u8vZREnATzk8Px77r23tmJNpitW5cOFj+k7V8o28+FzSKgheYqA1Kz5lna5IsBWvpB+tqsZRHjCxKWR2PhF/YMoWiK/OcqQzfvbFYkgzVcUbfIAsaXqpYhH/JiX/zvtId3R9IbKG5A7tFHTq8e7BET3+O7KvJwb5lsWNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+jKPXHXgl3Uz8t1hmKiZ+zPD7kCfAhYPS6UxFuJlYE=;
 b=YKyche+DorT6hwmGTD3p6Ib7aMN7oprhhphsMOqu5oUVeaa+ocDYJrIpdb3SU7Bb2eKfXUL8YUnGS55M9rQyKtZh2FaeYcZ31gmnJF1V4rleZRp0L+OXhXBdKW3SxlUxXvbYBZaQnn/uQkLrX8IT5E/gOLk56aha+KQ7aElIbVjI8MG78d8q2vj7eW02pUGKRxFrLnK3VuZtB4EOSkP0CF+4NnhvRe3m/j812hd8kgap8FE0gmVjzAaavyf69h+jO+SS7l7PztqArn0g9Bb46wxtqxFhu4w/1jLY7+/uqOt/VIsb9rBW+i3AUZ9l5SUTei9rmqgBo5p2xvUZjCu4Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+jKPXHXgl3Uz8t1hmKiZ+zPD7kCfAhYPS6UxFuJlYE=;
 b=MH/3bT7EG2RFQAmf5/L4Z3YlKBZFcU4G8FB7r2uWj65CP+Aa8rGo704f5lHDwNPg/4/QE2msmjkGqmTBpXY4aR2V4/TDI0G0wXsU5jnMxZ5+Z3v3SVaqLNFiOkWrWGzpM8vcxsXKdnsvR7tgFtQ/1a4pYLeytibf/GitKXX3qYg=
Received: from PH0PR10MB5593.namprd10.prod.outlook.com (2603:10b6:510:f5::16)
 by PH0PR10MB5731.namprd10.prod.outlook.com (2603:10b6:510:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.15; Mon, 3 Jan
 2022 16:16:47 +0000
Received: from PH0PR10MB5593.namprd10.prod.outlook.com
 ([fe80::518d:1011:338d:d68b]) by PH0PR10MB5593.namprd10.prod.outlook.com
 ([fe80::518d:1011:338d:d68b%5]) with mapi id 15.20.4823.023; Mon, 3 Jan 2022
 16:16:47 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     "Liu, Congyu" <liu3101@purdue.edu>
CC:     "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Mark Haywood <mark.haywood@oracle.com>
Subject: Re: RDS: Can RDS sockets from different network namespace bind to the
 same address?
Thread-Topic: RDS: Can RDS sockets from different network namespace bind to
 the same address?
Thread-Index: AQHX8hmak5+wRWxCJkKD7YcR9QouH6xRlmeA
Date:   Mon, 3 Jan 2022 16:16:47 +0000
Message-ID: <CE5C7791-1811-48AC-807B-D49ADD9068AA@oracle.com>
References: <MWHPR2201MB107202E590B041A3B1091FC0D0779@MWHPR2201MB1072.namprd22.prod.outlook.com>
In-Reply-To: <MWHPR2201MB107202E590B041A3B1091FC0D0779@MWHPR2201MB1072.namprd22.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
authentication-results: purdue.edu; dkim=none (message not signed)
 header.d=none;purdue.edu; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6889ba89-65ed-475e-5b41-08d9ced470f4
x-ms-traffictypediagnostic: PH0PR10MB5731:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR10MB5731A413FFAAD7A9262515E1FD499@PH0PR10MB5731.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tbtHCXEfbOXv+y5vY+IrgWKlOqn66UojRJzwX0etIGq5SAqP2Rd92SkQlYN4MiofAasYGf5KdtYk1z1h/5QLSGatovvdkPvqse2MRaKBlrhs4bm9+eL+6SbDnFNHnfAJE5b2nyS1qerm5ggqUiiaBJbU4xcRy8HA5RkBfX1orGx7K5xAR6wXy44/MPsUzwfMrCGDDoG6aawJCK2HJu+vBnhwlKy1fRwuoqNkEZC5Yo7MF9QBn7INex1iZQIwDeCwQtdhkDSZYs1Xy9pxzr8uVsHC3GJjVPkQXxPWlID4LTEQrlv6mJfazLpl6/ita8ltHaRg/hMjJ8NRA5Mxn/uxm9PEr/GwJpsDdSid2KiId2C5k31f81nmkP7i3QpAiKXIjncBaVvQW7Hx9VJV414mOxFCc8CnLWsrfnjnAPIhU9bioW4lBbJ/wRun8soA/VDUfEk44Ld9oJ8YcW6wBdl7vT2YX7poJ5CRjaVtZjys8yMlRnDSiTuzx6oBmF7TwscSepNA0f39nUASdEktSrDG426PugC5RgNXzABsq+tP8qOtLO3VCajp80r+BwyLM1ukPiPqp4a0EGX2utJLEuDeU/b0Gc+oxnzFD3OMPA13H8CzMu5VljyhWheM8iP3QWdQpH9EUFbGDVtV2CwB9gl4MREsr/z/shPjGXrP6HpbIJczjy3hqa39r+Jcvbw+E0nvNzetR8DcHSg9NTHsgqy+1GTOZ9Hr1ZuNrPminWjSnu8V09bHJDeArG+RopUEyEhN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5593.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(6512007)(4326008)(86362001)(8676002)(5660300002)(76116006)(38070700005)(2906002)(4744005)(53546011)(508600001)(54906003)(33656002)(107886003)(8936002)(64756008)(38100700002)(71200400001)(36756003)(6506007)(66446008)(2616005)(6916009)(66946007)(83380400001)(66556008)(44832011)(6486002)(316002)(186003)(26005)(296002)(91956017)(66476007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I4zxQR9Jy8aPjjnjocRJMr4C93AYu2OzsQg7f5X98NM9HKQjrSp4aSOp0JdJ?=
 =?us-ascii?Q?mWKkobUE9JkZz6zQwgIMhOEyTmrlpYUbIi4hrKfgxPx93ziJeIAHil4VA3YF?=
 =?us-ascii?Q?Hf55xpimMQY6YZzyU4eREZW+wK1bZmUgIdsKOxyXKd57dLah16XhyQvo32RR?=
 =?us-ascii?Q?rm7tuASOk7KzpbEfpFUCM8wlN1+osITYm6fLDO9xLZAWktebinW96+QZ/ZSm?=
 =?us-ascii?Q?2etqPdxkQkePdlKGnaduWO+9voBcky+5NY4SC1Wbfi030qN/joHtZJ55iYU9?=
 =?us-ascii?Q?1BJ0dFBOpQxMbxyg5FD/68ZKmY4uzOqDvvPo8WiC9kGsuK1zSFLKSe03Dxri?=
 =?us-ascii?Q?RHzThfBFhuRN6zY8x0z6I1V1XRVM2L85wQDCnByXTI136J0c1ZhpBlv+kbeu?=
 =?us-ascii?Q?HYFPR+Rs5TRspA1UiWZYKPdiXAiDPLmRoVrSWvMA6zYEEoOyfA+voDO9JFMb?=
 =?us-ascii?Q?YYvpfyuhTwEC2aKUm4Ys4hsZvWECBjSfu7II7im3rtGq4hETcicl8Uck1zM/?=
 =?us-ascii?Q?ivp2cbSbLHiLdoxx1szCWK1Hpr1+uhSHXtQipTtrLGW1U7agpr/sv3KpVGBY?=
 =?us-ascii?Q?e37jsVOgjiAEpVpK/iDXp1GUYlF/Y6lTYj8gc1VFzix22LyBdB5Inpl2m4hL?=
 =?us-ascii?Q?QQoQ+q2ucKDQXHLAkMWZJrI7wnMCIAld1rxwvG+CCohMVMT8+vJUSf4NsFwB?=
 =?us-ascii?Q?bpSKebcBkRqZAQxST0zYkM+c2d5iEhmZSJALgKGRqKrYkC9mKlEgH4RmLTN8?=
 =?us-ascii?Q?09t3LVi5bkbFgSr5MpFfAp1pfS7ZXbng0L3ofyz4FcRmrvAD7Yt7Xy3A31ga?=
 =?us-ascii?Q?5aMDkCiBZOo2sI4bV55p0gGaqpWqkqPAxUaAN2v1E3I6QzoKVtEihU70j8kT?=
 =?us-ascii?Q?YwwOI6H+r0uqz7yK48W5Xx1/YQRCUsBXHFyEdbTdDTgcH6gYPc8kajFkeYmG?=
 =?us-ascii?Q?tZoKpONlbpxfPqFoKOaIS2Quh1K0WoRdhpIYTC55FVh5ipTk8UZrNM6GKdAq?=
 =?us-ascii?Q?JLmLgi0utcVqb4NUhpu3CbidkfzsOZaLtBMYUcng3u7DcLEvM2WXuIKwsQj3?=
 =?us-ascii?Q?E+eGg1OOLmF+wpfETStxGCPBB8dMxZzRskNOTywDu6mNh6lpqppJhu2NVo6d?=
 =?us-ascii?Q?QJGLfD73QQpGbbxHTmz7eOrHlYAqa1JyyUi6t/OokEF3xrF6zSMruLWiolfp?=
 =?us-ascii?Q?n/3MqakAxNxU1W1jBYhbYYfb2oL2jlMNdVkH6IUl7sEqKTmhXIPFeGseHGOy?=
 =?us-ascii?Q?T7b1Xm/L3X8C6cG6R0IRr4136mUIQKO1xFSJhakod7FJnRBXoVGojgGyqbC5?=
 =?us-ascii?Q?3mRixoCDJbvO+gVIN9TyU31hkkB+kL+HPCGwJvNx5gUtmA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC63DF1C28F3EE4DA9ADC46C5B35E302@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5593.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6889ba89-65ed-475e-5b41-08d9ced470f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 16:16:47.1680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VfvFyUko1WfG14VOD+L/aCVt/5Hh19nY0HV0pjj7IfbJMzK9M3X8Y33r3GG6hhq+OFdU1BaZ4CLc8/C0K841kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5731
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10216 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030111
X-Proofpoint-GUID: pgh6IvxC_baB_JCgbdjSsHSYbMr54kdt
X-Proofpoint-ORIG-GUID: pgh6IvxC_baB_JCgbdjSsHSYbMr54kdt
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+mark

> On 16 Dec 2021, at 02:32, Liu, Congyu <liu3101@purdue.edu> wrote:
>=20
> Hi,
>=20
> (Resend this email in plain text in case the previous one was spammed. So=
rry for the trouble caused.)
>=20
> I am writing to ask about if two RDS sockets from different network names=
paces can bind to the same address.
>=20
> I am doing research on container security. Recently our tool produced a s=
imple test case with confusing test result: there are two network namespace=
s A and B. Both A and B has a tun device, and these two tun devices have th=
e same IPv4 address. In namespace A a RDS socket is created and binds it to=
 namespace A's tun device. It works. But then in namespace B the other RDS =
socket is created and binds it to namespace B's tun device, it fails with e=
rror code EADDRINUSE. Is this considered as expected behavior?=20
>=20
>=20
> Thanks,
> Congyu


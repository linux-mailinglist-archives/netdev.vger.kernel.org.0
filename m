Return-Path: <netdev+bounces-6578-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A99C4716FFA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6AB21C20D4F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE17931F05;
	Tue, 30 May 2023 21:49:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5139200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:49:19 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC48E126;
	Tue, 30 May 2023 14:48:47 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UKO6Fa003892;
	Tue, 30 May 2023 21:48:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=qsOo74QFfWeR3uX1Imr9Fsx2ILwVYPlNaAy0mKpy16E=;
 b=CvK+xvUErar3hUITxcvXoiScXCTudowP3p+o5Ooo87+JDeOf/FuvbMnOzoL7zo/41mZj
 uT5zcRIWxCasemXhFGZOPJXglpegrqzthRmAk714czdcSVVlnohDvsJehRJnDCeGvOfE
 eYiYhyAN+JTqzNf4rKdCcderiDOQLhIAlW+XXXRW6dNbbHpMNJimclWyRBs2koKNn1t7
 XTnhRbIMtnutdDv4Y9ebIvxBy/Q9k/k080gHkG/rAO1Yc82RM+Q+ZkpzEOVpzDS+lK1s
 d8uhsMyozz18VPp2qbwUy967XIBeZBCJk10yLHYX0Ycohu0SpAAXf0VbwxuG7nBRWgzN kw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhwwbyq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 21:48:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34UKnDNf014665;
	Tue, 30 May 2023 21:48:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a4hjku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 21:48:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hm7QaPlMkbyBhKQrob5PsP/+V+Pd/PO5IodZVLkMXktPexZUS4Dzp3aOIbiz2GBf466cpuG9CTmRGllKMXA0C9QlaEQK0WE0Y5tr3lLHCSs5KK9Ig+kuBT6tq1FZK72iJdndG54hRuZBjdMOEMGY9/V4aLeNJu594NI0BxFWr2PJhOOCfH69v/UT1QNQeaXovjX5vtyyEPrwDLdjYPVI3TxDjg3gMpfGvLfJvxPxJZPt1UeBDaof8CsISy9EC92YGBKEalG15XlZCOELdmOa3Q3naYGYeL8IDFothWiODH5s9wiiDq3qDAuW8ac3r0epDyhyOOGXcF1/VR0L2aaD/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsOo74QFfWeR3uX1Imr9Fsx2ILwVYPlNaAy0mKpy16E=;
 b=il/Sqlu97HFf5zjwpC8za0J8g5M91LDbd5fQBAyiUJZ3aCSE/O5t+rTJdjjBy0XdykEu63P3ojH/A7euXM7Kiaqw6JNwDor83FbtJVBRx1wuR0crTzDu2rdY+46rQcEgUVVtFtjQaZDpH3ZgXvsyrmH2nwSBgZIedE9b8TLlv6AimnDM5ECSkZpzS0IFzVxPU2HZXDSfsQK0P5EXWRORS1ng25lKA6HyQWJ/ieUw0z6WjzNq1IP0Xgs4lIjJenvQNGOVJDU12AtjZH69C8B/VLoOL6+hkpGf2rdz1oZcUxtMfgl4dj+7uMd6zhIvZH90ZIgMwSxOPuPSFMo46tA4yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsOo74QFfWeR3uX1Imr9Fsx2ILwVYPlNaAy0mKpy16E=;
 b=n0rKKHdMfx1f/B9vysEIbuHmrUNOsUtbRlNAc3TM/tHXpERGwEQp3vqGUp2LN77yPuEBTnUgXMnaG0Cd1w1TjNWeUybUBm3JqmSzjkbcQSd/uJAs9tY0dkkzH3CmVIxvk3sP0HUZyrfhFWQa32mcev8uBbnWAFLg53W1Z5ljls0=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB6898.namprd10.prod.outlook.com (2603:10b6:208:422::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 21:48:32 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.020; Tue, 30 May 2023
 21:48:32 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Saeed
 Mahameed <saeedm@nvidia.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open
 list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: 
 AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQCAASStgIAAwYyAgAPUTgCAIGXVgIADNpOAgAEJHQCAAG8SAIAAIggA
Date: Tue, 30 May 2023 21:48:32 +0000
Message-ID: <C34181E7-A515-4BD1-8C38-CB8BCF2D987D@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com> <875y8altrq.ffs@tglx>
 <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com> <87o7m1iov9.ffs@tglx>
In-Reply-To: <87o7m1iov9.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA1PR10MB6898:EE_
x-ms-office365-filtering-correlation-id: 90f70800-429c-41f0-928c-08db61579cf3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 5toVjKEPhnC7HVDuLg7YZNs0fDl9KWg57oDSJxh0i9qZzM/SWGjB1nbWRGuEK2NAwfDiKf3f6RxjQ9q99SUmuZr/6m9OewDj3vab4iiJJ71t69jj0t7ENbfltp3m2XQUT+iDF9arfSGefBVKh5URwJl0bBOa0MHZ02vXQO0RfvYRrigCBesW5rfklf39xTNgZm/hRD6hd/zibPuVvVjWSyuNf+nEXGUinTuNP0QLUR73Q2oJcVV7TWrMxuxjJ3QZJRQQ/Bf+ztAkMj+xyxAxIWK9Ul1Us67G96KoQFZsN5aiSCt/vtT8IJ7BkQmz6T0PnQK1SCTcZK8rPdZpcukMEQrYCaJsNDflHgBTcHWSVgbJcGj55TrbL3s3LgXyHMFXuQDcdDz4JanpRku4hQU+d43/ijgyLxr4MebjTj1/csjC9Ez5KRQjb7Ffh4Wwe8x6EgEdqeUpwti/yNBNQj8Y4JqAz6nP025wjf5FrQdkx/cARSQuALgHqqQLkH9vYQthSdPD/QfsIBj/uAHUrN5NEQsTDEVigN+Azim/z6bx8TRJGR2UYS+FvDmOpqJXsSMu0fnXu0HJ0k3xyB2qleLA+2blMzRTuwMhOvDpv2jpHz7Av1aOmTnBHb680mXpQ6c5xe6+8kUPCj7S+yUsY7FE8Q==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199021)(83380400001)(86362001)(36756003)(71200400001)(91956017)(33656002)(66946007)(76116006)(64756008)(66476007)(316002)(5660300002)(66556008)(4326008)(6916009)(66446008)(38070700005)(8676002)(38100700002)(8936002)(6486002)(122000001)(41300700001)(53546011)(54906003)(2906002)(2616005)(6512007)(6506007)(186003)(478600001)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?VJrXyL69iuqoZsVnOsqv5krC1CvImtcm5ET2iVvk5ESkVKI4CsZO/B/hKhrG?=
 =?us-ascii?Q?E1p2ZNcgyE535DI2vFwpMiL/pCsGzJ6OFZD52gI16/Yy6jIu94OJqtJK9ZXr?=
 =?us-ascii?Q?MshN68X4mnq+mU8IuNFIL8B2T9LicZEEW5Plk7lDCrYhMTvBgoVjA1V+oJib?=
 =?us-ascii?Q?/+w2sGJTlpUZAr9IkE+O4vHYdcWRsTYFrKhwmY7aFHCALohv9lvlDsyAYgYP?=
 =?us-ascii?Q?gpM6q13iMPoWlIiiOfkHWQMvXVtNcKnPhIEeukwdDY3PbtzaEXID9G+W9crK?=
 =?us-ascii?Q?EdEZrSAmgGd+drwATo+Bo63X1/tk38QwQFHjUThPjZ5mresKnVqKFqpuzGN4?=
 =?us-ascii?Q?v9YUhGRQAQMA2ou+D+QWwWH7UL/tiZjhSlVP7Fa7tmgL4sTwcCyTbIXyF1Kf?=
 =?us-ascii?Q?dvV4VtaoSYNVKQfhacN+AJ7Pi28daioLIfpYymecCL4nxSnDDe+WwRdxskJ4?=
 =?us-ascii?Q?u17dgsTLxU31jcN09HkGFeMFWb1pllF4wAAsXN4j92j1Hbwu/bkmdT1lVkn+?=
 =?us-ascii?Q?PQKsTlpn2pSrW0KzkUv69cBC80VqQqcQIW2J1q2Y3kLZVsUOr1UOK+LLzuTB?=
 =?us-ascii?Q?iJQNhtrMp9D57m/zqfkaIqeaYm7XQYEucFshUb2dCZs6QBTUbf/cduTFwzwn?=
 =?us-ascii?Q?pMR29IMA/q2LLAe5zX+OyAcG44hqDMl8JujT+8IWTHn8M8Mtr1s8aEkfrHPe?=
 =?us-ascii?Q?42o/oiEmK9WvEcWrtzAd2Mxtha3xPdEavR1gqqAMc95csGEt7LQB6sL+OQFB?=
 =?us-ascii?Q?RK6HVyD2chXXxJaYorTvMvziwTlYxPNqalJ/23GSVmHQ061yLwbDhTDkYUbK?=
 =?us-ascii?Q?gmKNdao973c7kZLEsmMgTT5yO6WV6ttxmYOBnTGPJ20EtoygGu6A5yp4V0qQ?=
 =?us-ascii?Q?AmPV4Kp0raKmsIirXq0qimBygN8E0VcU6AKMJLcdK4nQpJo51plaJZeny08Q?=
 =?us-ascii?Q?E2AGcN5B7uEZDQDCsrBoHM6AXACO1+pbiEaqIqsIICOLxRoPeyqr3h063Xf7?=
 =?us-ascii?Q?FijgUWWw0gurkl/wwkfaCvOXAGf9CknKRq3t/NICjzdAVueG2KlZz0VdoAjD?=
 =?us-ascii?Q?g68S+Z7Fa7YUBTgTE90IjZhWijcHeHP/eJb44TdievonzzVhiltPJSWAoowN?=
 =?us-ascii?Q?qHXkRTw1u3fC7TRyd7zABZ0rIaWX899+zgDkRItqbIncdjQm7umgMgwfIk8o?=
 =?us-ascii?Q?CMHA1urIVSgajxFFMe5t1NN0AM19kD+P9TJ1OMH+9P5epcGJdtGFwU9sJIC8?=
 =?us-ascii?Q?JKxL/y6Gd2Kiwin5/ZPPQWW5+fBMxOK/1h2ivttU1QepeQlm4qEhznZHE2rF?=
 =?us-ascii?Q?kZi8k85SQfYDL/Goc6LEfzWypxUMmGCrIaKXt2MM17+R+kV1dIom8JLzu4E3?=
 =?us-ascii?Q?fnFHKzvKHIyTqglvVVd0eSNf6vwfvtc5GUn68lt6G+kvspPz/u6ws8ODUJmV?=
 =?us-ascii?Q?CYKM0txNJ3I5DyO/+dP8bAzUWjukKrLiWmwLctxj8EchjINxs/MxlxjTcjsI?=
 =?us-ascii?Q?yTsfox4CWr3j8zROaFRADED035IQXpEKm8VL990g5qPWY4T4hAYSvuz2ftYv?=
 =?us-ascii?Q?m3Bm56O8KKbL5gxezUqjKd2Ss54aix7Y1mjxEPuqcvcO3Zg747JXsM6obE7Z?=
 =?us-ascii?Q?yw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <269BB39A4A0E3047849ABC90DF85A139@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	C253yNGd3bN1ht/gpMUjo/Oz4ajrFjfprRp/I8H+0q9Ch85YTFQ7zReAjoe6nyeUY7EiWE0Pa4fZ/22be0BIFfGG/0mO9b0zGDNo+fj7Cvxdx83VsSCEsnCdOX+FnN8sTMs6SiOrjWkgNt385kV+KQxwby3jyUCb4QLDI5FDptv/NrDXWI34PFV20Aol/5Jgp2+idQ470xrexfCr3PKH81vRjPfzXpQRde9FCvPSkfjC5DqzeU+/fELo8R/aS3YDJdClPLVZ8Z33wZUPjPeJyqsasX/q/RUcgqUWndluAPZI/BsNl0BLTkkE0og0540TR0KCmaKX27aBm6rhIAqCAcFMTVmBg3g7P3xQg/BHJV34+/XOOJxTforF+tlrkXV7rxwkdG25mOU0OaGVVIDVPOYjFWRkTwnByT2BhZ9amvz9/+H435rk3UF7a5AVWRNHsLle5gcbigQh1P+f89y6O6gXVM75Q4fBg/1Bpvoj4m6wIGjb5jHcFguD982C0dQBXW4YSWkoYoXNOZhp/QFXD1NHkA//B6iOvQJNuLuWCvG8siVVj80tPUpIfcruPU/W1n7HWTbDupzgJEpF9JWGEw9jQpGCWQeitFqvyrEBibUkvyBcOT5LR6NvL9JsAr1ktKDGRtkog7oao5apLslPxX68/KY8Q7dj/j7lnLcORUJFc3xqIMBQqcdT+AB48f/L0+llDOJqfoXVK4jxW2hj6Ciimao2h0/oeKF1s+jJoB8a0CZkrizDOXvkG0Xu8lCxjGK+hA0BQDu3FakP96t0aKvTRT0yyaLadrpNTvvVhAW571If4f/J3lxVr7mkkMvw5UTyiEWjVS60in9YBmpENm6lYyjVa0Ht87u8nl1x4hY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f70800-429c-41f0-928c-08db61579cf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 21:48:32.5902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZcHgz8gSoAhTDMN2nUuVKYlSUd1WpNA4TF7bIOw7j3ElEQNMNpy8LB8bAJOUpjpbJsVWLiFgllyDNGH/ZJ4pDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6898
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_16,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305300177
X-Proofpoint-ORIG-GUID: 4n0c0kvNYFqeiNkkHI60vgOo3Kiiv9t6
X-Proofpoint-GUID: 4n0c0kvNYFqeiNkkHI60vgOo3Kiiv9t6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 30, 2023, at 3:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> Chuck!
>=20
> On Tue, May 30 2023 at 13:09, Chuck Lever III wrote:
>>> On May 29, 2023, at 5:20 PM, Thomas Gleixner <tglx@linutronix.de> wrote=
:
>>> But if you look at the address: 0xffffffffb9ef3f80
>>>=20
>>> That one is bogus:
>>>=20
>>>    managed_map=3Dffff9a36efcf0f80
>>>    managed_map=3Dffff9a36efd30f80
>>>    managed_map=3Dffff9a3aefc30f80
>>>    managed_map=3Dffff9a3aefc70f80
>>>    managed_map=3Dffff9a3aefd30f80
>>>    managed_map=3Dffff9a3aefd70f80
>>>    managed_map=3Dffffffffb9ef3f80
>>>=20
>>> Can you spot the fail?
>>>=20
>>> The first six are in the direct map and the last one is in module map,
>>> which makes no sense at all.
>>=20
>> Indeed. The reason for that is that the affinity mask has bits
>> set for CPU IDs that are not present on my system.
>=20
> Which I don't buy, but even if so then this should not make
> for_each_cpu() go south. See below.
>=20
>> After bbac70c74183 ("net/mlx5: Use newer affinity descriptor")
>> that mask is set up like this:
>>=20
>> struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
>> {
>>        struct mlx5_irq_pool *pool =3D ctrl_irq_pool_get(dev);
>> -       cpumask_var_t req_mask;
>> +       struct irq_affinity_desc af_desc;
>=20
> That's daft. With NR_CPUS=3D8192 this is a whopping 1KB on stack...
>=20
>>        struct mlx5_irq *irq;
>> -       if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
>> -               return ERR_PTR(-ENOMEM);
>> -       cpumask_copy(req_mask, cpu_online_mask);
>> +       cpumask_copy(&af_desc.mask, cpu_online_mask);
>> +       af_desc.is_managed =3D false;
>>=20
>> Which normally works as you would expect. But for some historical
>> reason, I have CONFIG_NR_CPUS=3D32 on my system, and the
>> cpumask_copy() misbehaves.
>>=20
>> If I correct mlx5_ctrl_irq_request() to clear @af_desc before the
>> copy, this crash goes away. But mlx5_core crashes during a later
>> part of its init, in cpu_rmap_update(). cpu_rmap_update() does
>> exactly the same thing (for_each_cpu() on an affinity mask created
>> by copying), and crashes in a very similar fashion.
>>=20
>> If I set CONFIG_NR_CPUS to a larger value, like 512, the problem
>> vanishes entirely, and "modprobe mlx5_core" works as expected.
>>=20
>> Thus I think the problem is with cpumask_copy() or for_each_cpu()
>> when NR_CPUS is a small value (the default is 8192).
>=20
> I don't buy any of this. Here is why:
>=20
> cpumask_copy(d, s)
>   bitmap_copy(d, s, nbits =3D 32)
>     len =3D BITS_TO_LONGS(nbits) * sizeof(unsigned long);
>=20
> So it copies as many longs as required to cover nbits, i.e. it copies
> any clobbered bits beyond nbits too. While that looks odd at the first
> glance, that's just an optimization which is harmless.
>=20
> for_each_cpu() finds the next set bit in a mask and breaks the loop once
> bitnr >=3D small_cpumask_bits, which is nr_cpu_ids and should be 32 too.
>=20
> I just booted a kernel with NR_CPUS=3D32:

My system has only 12 CPUs. So every bit in your mask represents
a present CPU, but on my system, only 0x00000fff are ever present.

Therefore, on my system, any bit higher than bit 11 in a CPU mask
will reference a CPU that is not present.


> [    0.152988] smpboot: 56 Processors exceeds NR_CPUS limit of 32
> [    0.153606] smpboot: Allowing 32 CPUs, 0 hotplug CPUs
> ...
> [    0.173854] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:32 =
nr_node_ids:1
>=20
> and added a function which does:
>=20
>    struct cpumask ma, mb;
>    int cpu;
>=20
>    memset(&ma, 0xaa, sizeof(ma);
>    cpumask_copy(&mb, &ma);
>    pr_info("MASKBITS: %016lx\n", mb.bits[0]);
>    pr_info("CPUs:");
>    for_each_cpu(cpu, &mb)
>         pr_cont(" %d", cpu);
>    pr_cont("\n");
>=20
> [    2.165606] smp: MASKBITS: 0xaaaaaaaaaaaaaaaa
> [    2.166574] smp: CPUs: 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31
>=20
> and the same exercise with a 0x55 filled source bitmap.
>=20
> [    2.167595] smp: MASKBITS: 0x5555555555555555
> [    2.168568] smp: CPUs: 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30
>=20
> So while cpumask_copy copied beyond NR_CPUs bits, for_each_cpu() does
> the right thing simple because of this:
>=20
> nr_cpu_ids is 32, right?
>=20
> for_each_cpu(cpu, mask)
>   for_each_set_bit(bit =3D cpu, addr =3D &mask, size =3D nr_cpu_ids)
> for ((bit) =3D 0; (bit) =3D find_next_bit((addr), (size), (bit)), (bit) <=
 (size); (bit)++)
>=20
> So if find_next_bit() returns a bit after bit 31 the condition (bit) <
> (size) will terminate the loop, right?

Again, you are assuming more CPUs than there are bits in the mask.


> Also in the case of that driver the copy is _NOT_ copying set bits
> beyond bit 31 simply because the source mask is cpu_online_mask which
> definitely does not have a bit set which is greater than 31. As the copy
> copies longs the resulting mask in af_desc.mask cannot have any bit set
> past bit 31 either.
>=20
> If the above is not correct, then there is a bigger problem than that
> MLX5 driver crashing.
>=20
> So this:
>=20
>> If I correct mlx5_ctrl_irq_request() to clear @af_desc before the
>> copy, this crash goes away.
>=20
> does not make any sense to me.
>=20
> Can you please add after the cpumask_copy() in that mlx5 code:
>=20
>    pr_info("ONLINEBITS: %016lx\n", cpu_online_mask->bits[0]);
>    pr_info("MASKBITS:   %016lx\n", af_desc.mask.bits[0]);

Both are 0000 0000 0000 0fff, as expected on a system
where 12 CPUs are present.


> Please print also in irq_matrix_reserve_managed():
>=20
>  - @mask->bits[0]
>  - nr_cpu_ids
>  - the CPU numbers inside the for_each_cpu() loop

Here's where it gets interesting:

+       pr_info("%s: MASKBITS:   %016lx\n", __func__, msk->bits[0]);
+       pr_info("%s: nr_cpu_ids=3D%u\n", __func__, nr_cpu_ids);

[   70.957400][ T1185] mlx5_core 0000:81:00.0: firmware version: 16.35.2000
[   70.964146][ T1185] mlx5_core 0000:81:00.0: 126.016 Gb/s available PCIe =
bandwidth (8.0 GT/s PCIe x16 link)
[   71.260555][    C9] port_module: 1 callbacks suppressed
[   71.260561][    C9] mlx5_core 0000:81:00.0: Port module event: module 0,=
 Cable plugged
[   71.273798][ T1185] irq_matrix_reserve_managed: MASKBITS:   ffffb1a74686=
bcd8
[   71.274096][   T10] mlx5_core 0000:81:00.0: mlx5_pcie_event:301:(pid 10)=
: PCIe slot advertised sufficient power (27W).
[   71.280844][ T1185] irq_matrix_reserve_managed: nr_cpu_ids=3D12
[   71.280846][ T1185] irq_matrix_reserve_managed: cm=3Dffff909aefcf0f48 cm=
->managed_map=3Dffff909aefcf0f80 cpu=3D3
[   71.280849][ T1185] irq_matrix_reserve_managed: cm=3Dffff909aefd30f48 cm=
->managed_map=3Dffff909aefd30f80 cpu=3D4
[   71.280851][ T1185] irq_matrix_reserve_managed: cm=3Dffff909eefc30f48 cm=
->managed_map=3Dffff909eefc30f80 cpu=3D6
[   71.280852][ T1185] irq_matrix_reserve_managed: cm=3Dffff909eefc70f48 cm=
->managed_map=3Dffff909eefc70f80 cpu=3D7
[   71.280854][ T1185] irq_matrix_reserve_managed: cm=3Dffff909eefd30f48 cm=
->managed_map=3Dffff909eefd30f80 cpu=3D10
[   71.280856][ T1185] irq_matrix_reserve_managed: cm=3Dffff909eefd70f48 cm=
->managed_map=3Dffff909eefd70f80 cpu=3D11
[   71.280858][ T1185] irq_matrix_reserve_managed: cm=3Dffffffff98ef3f48 cm=
->managed_map=3Dffffffff98ef3f80 cpu=3D12

Notice that there are in fact higher bits set than bit 11.

The lowest 16 bits of MASKBITS are bcd8, or in binary:

... 1011 1100 1101 1000

Starting from the low-order side: bits 3, 4, 6, 7, 10, 11, and
12, matching the CPU IDs from the loop. At bit 12, we fault,
since there is no CPU 12 on the system.


--
Chuck Lever




Return-Path: <netdev+bounces-8896-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C13F3726341
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BE301C20C8D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF091ACB5;
	Wed,  7 Jun 2023 14:49:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D626139
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:49:19 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959061BFF;
	Wed,  7 Jun 2023 07:49:16 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357EefhQ017112;
	Wed, 7 Jun 2023 14:49:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=2eeSBKr2aDAtHIAOw6lTba7YxAtAd/mFhiRM1tK+5/c=;
 b=39em+I/S2mRKryhOrcxZxrLrQZ7zih5WKWi43DkUjRO3EU1+TEzTdfp0qtMk5M2Gm0f4
 s/2R39xO8JQiG7gVLeGpL8who+ZaQNUa1hRGxfdPcQ8ZPWDNeOkJsEf6x0p/2U5Cl5JW
 vIxYOpgNxNdvSmpD3mNHa8szoKzVEMq0otG55Z2+Th6uB66tieW6SubPDGqvVUv7hIsM
 n57qoFozAG4HvRzoCDSZTWuho9NW7ZnwV1DLI9Jv4aE1s95PgFmfNSvo1y4uZh9EnIQF
 7hPT5ka5RgC6FMQLboja0Q2JjgfhudVIBH6f0qXjnSc0lobe+juVW22oVW1/UmI2VUnw zw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6pj0hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jun 2023 14:49:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 357DjI8J036835;
	Wed, 7 Jun 2023 14:49:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6juhm2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jun 2023 14:49:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EnPnbXZg1seupEYPyBpEzdscjG6kOXXod6ORONvNJrbsyolkE+QKnDb6QBdRVRoHShWHJhaEqkNQAxehgUyYN/RNhUbQUXA46/lQMcUAkM4tvuczOgsjoSCdVxbNohvU+isO1Z5jniadeRqJeR3n5FPIS2wbBJuSfrTwphzVP4wetsd/PqxdzzAhb4KHTVr/118mYWZ3Puzy3W6/nQK54BdDD6pPrC5PoZWymBPKmmF1SQacmb6Ove4Ls4snbNcTC5kGXUfBpTnKf2fBNGr0KnB5ehnxSoWy0hmg6z0Xjb4sVJJH7YNLSMqoVNaprNZ6ieYtAB5Y1bwOWvDscebVoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2eeSBKr2aDAtHIAOw6lTba7YxAtAd/mFhiRM1tK+5/c=;
 b=Q5L6mbSXFxcjul1LVVAmVoP1vhW3HFeI8y4rGUj10pXtWhPvx9DrvbxBZTLEPrxBWT1hqTmibd2z/KWdkm1VI+mBtXjxpzxks+L3ieGL8+8MAEYmnB/mCd97seGCLrhNe51uXuhzojyK0Mf3xZAdjFtVpBHdEIfC9cvxZs61bUiAtqO7N7S0HCckn6evQLSFbxxN/gkl6lmRw3FkYARLvjdgKj4UEwsVkOCw6RULnnjPGwHqiGClQxxyzmSVL4Lx0Xj/JrcR/Y7zgtB3g8mkMr+vLQoFnyW3QtU7JCeRUj0ltlPJoNtHvY0y4UgI8qC0rvNYfAJxkEO5NN6v2iXNtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2eeSBKr2aDAtHIAOw6lTba7YxAtAd/mFhiRM1tK+5/c=;
 b=Cd7ygTNwSDssCul2zVMGao2H2DGl65h8jWUFVwpNjMJHlS3QDFWAnUui+ZazzGtoH2MX2H7nllXSUAfNh0I1oHFaXXvLJuixpl64qomn0evZoCYCVoiSzMCadkcH+6uX5tY54nyi3c4maZTHX0Ar9jzYKaxFsrrfYcmbPCjqM5o=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA0PR10MB7274.namprd10.prod.outlook.com (2603:10b6:208:40f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 14:48:59 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 14:48:59 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Chuck Lever <cel@kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>, Tom Talpey <tom@talpey.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Topic: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Index: AQHZlYfl1VISa1yiqkOAQn9cpjE/26998bCAgABKgwCAADLZAIABBDkA
Date: Wed, 7 Jun 2023 14:48:59 +0000
Message-ID: <95E53E7B-829B-454A-A15E-0B5062CE2FCB@oracle.com>
References: 
 <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
 <ZH9VXSUeOHFnvalg@nvidia.com>
 <325C9DBC-5474-427C-9431-19A59D64F28D@oracle.com>
 <ZH++hitKpvcFC/hQ@nvidia.com>
In-Reply-To: <ZH++hitKpvcFC/hQ@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA0PR10MB7274:EE_
x-ms-office365-filtering-correlation-id: 25981488-d6e0-45cb-e4da-08db676653f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 xThi7vZRX7VhRrc8WxU5ZPXH+Cdgt5IEjC9ZAE6EcyIVAN5lRHjYK+0w+LDOdMVyVWVubOrTnkxektLb2xc9TVbZRk9qN/G4a5s70BuSNVXr8KoTo3zfWIGTjirwKILioW/ATKW/M2liiDeSfjL8ggqALPBrbCZDGOHWmhD0/CfqS2EqLLSqyWPLPaFEu0hg3s5QuanqXwny1zciuh8E8dxvqTxjrvUxT8IzGZ23PLZ4spaR4+YuZKzdliHHYxUuFZyoXgTJosW5a4BC8wTckk2karnKZQysC6o0XSS4zKoXjRh6cbC6z1ms3OAxJUztuChRfaPX+2xA8woUmZipHr78Zceyw+lOcPkZg9SZ3Vfm+/zJfzTPCEoWYhqpZhc35Lmy2msVLGqHtGHFUrmHC2pSFtddNmORPsWSQk5vxMqM1smKf33cEwLS2o45KqNvEjzCqJ0WBKWLhzorBydehYlrMK958V0ABBE4sdBdFQA0l3KxvaFTa5r+mNdGds/25qELasBK91+gg+Oxv4rIIUmZRiFzujNmTmlwTt30mU0XgvZ2QyjQBEg+VIT4zisQEaNXZRU13hJGoVtZBTPptcBCaFWIj+JJW0/iH/1lrBuSw1+R3fQ22VgDGXHDksNX/CbxHGr35VkJRCOiDmG3wQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(136003)(346002)(451199021)(2906002)(83380400001)(2616005)(33656002)(36756003)(86362001)(38070700005)(38100700002)(122000001)(6486002)(41300700001)(5660300002)(316002)(8676002)(8936002)(54906003)(478600001)(66556008)(91956017)(66946007)(66446008)(71200400001)(64756008)(76116006)(66476007)(4326008)(6512007)(53546011)(6506007)(6916009)(26005)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?Yf38egyNrE8h2tqM9luDgY0A505fg2vfhaZvXI4UtCNUX9HzmkYZfUV4R9jd?=
 =?us-ascii?Q?ta/MVVaBsxOGlOrLlSYXFCsaCnKXiezyzhL4DQR4RZgMFIcc6Y2iTicsRThT?=
 =?us-ascii?Q?eCPyJ8Bte/ezzC3eR4Qh/WbKbIA/wiZWxRkK91NdiOgRJKd0QwFu69xT5dDv?=
 =?us-ascii?Q?EmjCtyuVsd95cY+6MzdrcnIrteExOAOzlHmQ7zYZ6E0NObRkRq1BX+bHwQ16?=
 =?us-ascii?Q?FVxs3EnFzzBQoFXIHZImOt8AzSpchkYodt+fNNYVaLmLRCG5+91jdHjj3kUm?=
 =?us-ascii?Q?8AuZg5Yp8CEwQP3aAj20BU80hk43k0nzjOInhUzwLIqw3PcytEITL5xbwI/C?=
 =?us-ascii?Q?ofhf67ctJ96OrxZR/tXtr1zpxX4vPqAysrV0aPLLbpIh08EL4OJTE97Qtk89?=
 =?us-ascii?Q?S87Ft2/1DyxawvqhwNYBC5NiJKcUjb3mGXOU8xJ2/GeuW+bqXWvav6zCSMGl?=
 =?us-ascii?Q?Y5oNF6I/zqNAZTqtSU89SfZ/igedqI7WxJg/RFgz1y/XCEbBqDl4mB4ZsCVa?=
 =?us-ascii?Q?tNYM9/9bjIzx87nuR6SEcoIVDslivH3E7cBlHXMIy/NpT5+WcAFiUbQDOPJ/?=
 =?us-ascii?Q?gCH9cGBqBes4jCrCq/ZwPdef0NS53v+fo2zHuw3krxUwyWjYWqZqgTEAqoXp?=
 =?us-ascii?Q?EzHA/ODdDOkN/ZwGkm3WvZ59+TS5SjhmoMhVhFULhZhRSxcW7jeJD4pm6IAF?=
 =?us-ascii?Q?hE+4d5Ls6sZCH/yYkwjM46MHaozNm/g/bp2xtCLhSQBa20ho2riyDg1VY7yK?=
 =?us-ascii?Q?mwcfCEYq+fbdx5wouCwJ/1u5jmERgrGCJ5b0fV8nieq+2vY+DFENN9GXY5hk?=
 =?us-ascii?Q?m8u7k6HFHMrFBfYwevUw/Y7Zbboj7MiOALSLNnOCz8Pu1bKowpd3fUwz/v4F?=
 =?us-ascii?Q?LYTUGtnHuTvtNPk/7ZmTR936/CIgsnHtYKAtR3vqIhBY+izK8TkwGTU1lxel?=
 =?us-ascii?Q?C9OLmlWKt+kcOG3iMzzECxPyou0ZPdO3oo92tGE091y5ObA4CaLBKJzAW2zd?=
 =?us-ascii?Q?8ZxztV/jpczSCGT/VbKt05W9FxzW+70fucLy3RGV4S6GgWEWrDATFSAjjJmV?=
 =?us-ascii?Q?vqyl9/0QQZm2+EV+KO8hpuzNJk0VK1ylRPrVh30zA++STtSWRZeliVlN+p38?=
 =?us-ascii?Q?fn/VtdlmwnRk7QEjpSES+dtA80+wpn056aL9AEQxEcS6hIBCU93lLRlEQs/i?=
 =?us-ascii?Q?lm9KT/FJ99NuzQDFX7fAM42t6NlHmK5p4jJkMaYM//PqdS2coltcTtNdxavZ?=
 =?us-ascii?Q?BssGA1xge6QqwVcivNwLdc3uLRtxM9iPmB1Sgw6gT5LcyidefJK6pVDXp+48?=
 =?us-ascii?Q?sDGjX93R+S1RpTxwJSqMFbJ4L0Px+Lf5m1KfoGlPJ2uB/spzL4iPBGUX1EIe?=
 =?us-ascii?Q?KW9LvwmiVYnGMuTsCxICNMJa5eDmhTmgXRha2Z5/K/6HffIOBFNDaJaV0OQ8?=
 =?us-ascii?Q?WSFy0yjRCrcwFoxmUuW8Q6ONK1hXHpw+15Z7FfKdBCxXevvof60j+6RKCku2?=
 =?us-ascii?Q?f6iP+s54i7FXA5HJ9mHIiFFnU7uhCxInpyRjTjui4OLLy5EVQdsNg+YNXxDY?=
 =?us-ascii?Q?sZVsQlCZ1FHNpKczgJ7aPMl1rtBXKrEHoDMmQpjl7kLtu2RNKIlmHEMOQhCW?=
 =?us-ascii?Q?TA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9721518967A5D3459D0A4D976860D3C9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Xs3S3jQkeRHRF1PDwdfvHosTeltdHZF5Xn6Yus34qULKfoiRKBCBaDqv4gnFXXYwklMe7MKrdn3WV6vK/WplMJP+kkKy5qrAS2ivXeTPyM/SELMm1XiAX7cqF8Umgxn38Dw8iloTQs4kyGJjGyeJfjxIY5aGheOk1QLRYjyn02ZAa6ONYPrG8edxeoJS/+DYCxqOCIca/A/wROtLozxdngqG1aRxYL60mEH4B/zhG0Xjbl3uXNnFlI1Zl0KNNsSk3yqNDlhP+gx9decvL7c0bbTCqRX7K+BKb5lxEWYXT6mi/SKNi7wlDWjtKVo4JuUM+2FWUKl21V8/ouh6zKDsuUOEb2sXVr7ICYHV9GrLRU+s3UJB2qqQmEABYU4hltHzA/hyFlpyUYYZPL3rQdGUiGno0u+swmK52yvzPXAqxovO2eoo9sNMt7rJm9U6+YNvii1kp0QFB96AWDI71H4qjMC3vEBO+MQYMC3KdKPmtEK41hRDYJ8tCoZCKd4yAVcBCexO5Orc6Cfe15Aw3GK19+3ZMQSZv/XrYygFAgT0PNA5pehn7Cll73vYehhr1kj/0MUjQdifGWvotXUl0hDnUnVJ+k00liZD/pVL8hnevuRcCM2fdc1r9d7AQoWZg6TAo9k9Y00cxLZlpqEbpMy2b0jmTYxwqg01BSr/MHaLZxvl6+1IOVPEOvzn+auGOtnj3lBbLVUGjHuMjDYROzLgHCL/NyOhXHkz5Cu9cGZQ2yP3BhCqzEMbT0mwbkuAB2i66IMNqaCBjkwv6rHwp6vKZ/by84TzeBtZPODSA7sR+CVSk5wz0pBwW7lYy+SSlF7viBArrNSrUkpXN9E4Dfr/n0DK9HP/r4+wzZ3z4ucu8CJAhIfsvIYI3EsCxTJG61c7
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25981488-d6e0-45cb-e4da-08db676653f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 14:48:59.5181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0icR2z6ocmHYl1U0h/UKLMpIPjj+c2YWxTQ6HFs82RVNeK2lTtBkOoH45yada+x2hjFBblS9+BnAVcaRHpwyhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7274
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_07,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306070126
X-Proofpoint-ORIG-GUID: gb5IIp2EsI_dTpdIfORyjmRhN_MQtsSX
X-Proofpoint-GUID: gb5IIp2EsI_dTpdIfORyjmRhN_MQtsSX
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 6, 2023, at 7:17 PM, Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> On Tue, Jun 06, 2023 at 08:15:36PM +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On Jun 6, 2023, at 11:48 AM, Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>=20
>>> On Fri, Jun 02, 2023 at 03:24:30PM -0400, Chuck Lever wrote:
>>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>>=20
>>>> We would like to enable the use of siw on top of a VPN that is
>>>> constructed and managed via a tun device. That hasn't worked up
>>>> until now because ARPHRD_NONE devices (such as tun devices) have
>>>> no GID for the RDMA/core to look up.
>>>>=20
>>>> But it turns out that the egress device has already been picked for
>>>> us. addr_handler() just has to do the right thing with it.
>>>>=20
>>>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>>> ---
>>>> drivers/infiniband/core/cma.c |    4 ++++
>>>> 1 file changed, 4 insertions(+)
>>>>=20
>>>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/c=
ma.c
>>>> index 56e568fcd32b..3351dc5afa17 100644
>>>> --- a/drivers/infiniband/core/cma.c
>>>> +++ b/drivers/infiniband/core/cma.c
>>>> @@ -704,11 +704,15 @@ cma_validate_port(struct ib_device *device, u32 =
port,
>>>> ndev =3D dev_get_by_index(dev_addr->net, bound_if_index);
>>>> if (!ndev)
>>>> return ERR_PTR(-ENODEV);
>>>> + } else if (dev_type =3D=3D ARPHRD_NONE) {
>>>> + sgid_attr =3D rdma_get_gid_attr(device, port, 0);
>>>=20
>>> It seems believable, should it be locked to iwarp devices?
>>>=20
>>> More broadly, should iwarp devices just always do this and skip all
>>> the rest of it?
>>>=20
>>> I think it also has to check that the returned netdev in the sgid_attr
>>> matches the egress netdev selected?
>>=20
>> Both @ndev and sgid_attr.ndev are NULL here.=20
>=20
> The nedev to check is the dev_addr->bound_dev_if, that represents the net=
dev
>=20
> It is some iwarp mistake that the sgid attr's don't have proper
> netdevs, that is newer than iwarp so it never got updated.
>=20
> So, maybe it is too hard to fix for this, and maybe we can just assume
> it all has to be right

sgid_attr.index is not set it looks like. I will send you an "official"
version of this patch and we can go from there.


--
Chuck Lever




Return-Path: <netdev+bounces-6896-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A09017189AA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:53:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 314F91C20EC9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E2D182B5;
	Wed, 31 May 2023 18:53:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20387805
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:53:21 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FEC10F;
	Wed, 31 May 2023 11:53:19 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VERRhM027610;
	Wed, 31 May 2023 18:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=HzE++GLxi+XPD7BW71chhhVAZ2MW8Br07f2FpkzbB4c=;
 b=maa0cXuxshbyfrOi9Ku9r3/k53E/bQ/L2qQ/fVuqDd8M5+OXWXyBQVvGI6kvPOf3och0
 3EK00LVXuvSnU3iqoyeCGyP84LNelzwQQeFYh0TOvXDL0MtrrLVYfxqhDeR/wwGnohLZ
 AkgRQKWQerARNLSyow/1OswwZSveBKgacxLhzhGt+T38FJlQhDpOajQzp7sKKzP1hF/6
 X50D7Pk37A/fLn0p7ROobsphSKbRZu4Zq4p/yFn/Iwg16N7JziwshjeCQ7wWHYy0NECr
 bzhEGC7VEuGjkWdk0Sfa5xScGfxG+8N2adGez854VA/JlRdGI62S1vYRz7pSwZI9rKtL vA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhwwem9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 18:52:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VI60TG019761;
	Wed, 31 May 2023 18:52:41 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a6a0b3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 18:52:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pc07/fFh09+TeDWmrkJ4E2pGlaSOpKXWAIs6mxAlRKlEwzrBMdteNlyi25U9LXsDOudQ0bgoJCX7VEz+l5CPFvSyn22crMM2JCEheK8x97B5roXyjIDlB+nmYSg3Z7RWGXhgn3f7B7xisMma/lxex4B6tVt1yxHTTYKn7m8wddqrtiass+UMcwbBNoUbJms0pAFsG3pXG6a1gBm7F1LfdYk4KDXJlawKbq4OzUyGOb5O6DdRsKw8feGYnaolfc/Du1N3ucRbomtVMr5Jpz03PDYvVPzWapcZUAbCzLaTME/ro4W5BarW39RNllEvlxyidB2vYlLdQavGBu7uGNggww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HzE++GLxi+XPD7BW71chhhVAZ2MW8Br07f2FpkzbB4c=;
 b=DbPPd6Ffd1HqHZLxN8DwdwtkxSHE82rkamTmVnOIu1/5xFseScJ/ucmqyuC0cUq7WEc3VleEgZAeqANOSs+yLMB5MvkrSVQ/J8MpAp59jYWO3Jb/Oq+C04qrj5tzG33iB2fuXx3jsCUZ9PxsHtQoapavTjeNcHqVowdltUvTOinj8PL+jhI3ZYp359xGhHnAatHR99rQMCp5LIZtyFvRKjhtIqApEfdOfigq5HW1b6RXXRsrJAi6oTr9qwN73e8WBy3o2vWYCKibDUQPG6daO0ASwLQ7c1zeHfsJa6hkNWeQmeez9unskvAOoU+ZszazQhIcRVRslmaQmH5LrYbTnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HzE++GLxi+XPD7BW71chhhVAZ2MW8Br07f2FpkzbB4c=;
 b=zg4ZTVPi0MaDKbYWqILsQqpaGpWA2Drtz/P6W69VJQ3jGLGSO6uF0AvIVIPOyxUn/fPhMaThd86vMN+bTXnTlAC4Vuq19bY3TXoFMbUYuBIPQiGZIFEBWZ+HGBYE1367kCxuaX1tuoeKn9UdrDS6WNMDep+QbvpIlKKYubkYPqQ=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS7PR10MB7190.namprd10.prod.outlook.com (2603:10b6:8:db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 18:52:39 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.020; Wed, 31 May 2023
 18:52:39 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Saeed
 Mahameed <saeedm@nvidia.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open
 list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Peter Zijlstra
	<peterz@infradead.org>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: 
 AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQCAASStgIAAwYyAgAPUTgCAIGXVgIADNpOAgAEJHQCAAG8SAIAAIggAgAEbjoCAAAZgAIAAIy6AgAAcEwA=
Date: Wed, 31 May 2023 18:52:39 +0000
Message-ID: <7AECA9A6-1F7D-4F82-A4C1-83616D4D6566@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com> <875y8altrq.ffs@tglx>
 <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com> <87o7m1iov9.ffs@tglx>
 <C34181E7-A515-4BD1-8C38-CB8BCF2D987D@oracle.com> <87ttvsftoc.ffs@tglx>
 <48B0BC74-5F5C-4212-BC5A-552356E9FFB1@oracle.com> <87leh4fmsg.ffs@tglx>
In-Reply-To: <87leh4fmsg.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS7PR10MB7190:EE_
x-ms-office365-filtering-correlation-id: 6ac50602-6cec-42d0-6b67-08db620834f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 /I+ecxGSCjsPzC7N56vrfto5Gop9RI19x0TXPLOxJn4CD2qMzJHcf8IozpFfrCXW3fRKOdiUNxt7elgm1BErM7oQsBagOLvEKcRZO0rE9RtFQEfy5+DxTJ+SNtVP3p2yZ8gGYaGVn+F69h93+RQU/FO4vRfmJJnL0Ld80qTDJNXs9KGjdu5ndJIhhv7sym2+YfQPEaqlH87iUASbLujXCmPfpKgrKW83R6uhGul8LzwIbvN0Om6Y4keaAUo4psXJ8nZhBmOjkv5pK6NHdQqTN2KGKgtJqA/12uaNdxYYWKOxPz6JkjYXQ3rQG+CdS44iWS9jjgfhxTHGHEbbCWx94IxYYDSQS2HzVWo9UwcquvZSJSJDE7DPzraUUnAKPY7OyFVvTrAuDNm5/Ay9CUrsOTYZ/Qs3vkId2yAIGyAniEi549xcp3+beka0p8zyVIlrpVL0jfRv96fdqGOxHkZC3zAV6Gqe7MLhr5VmnrIWZ1MmIj4mRKOsgJiXT5bcfpziITF9lroIoc7u4VJdK5JWdySadp+p8k/mZGk1+TwjRz2lRBRV863PZ0bCu+TlqmmpK+PCSmITx1+SPjGJOy4QhhVME9nn7SPT59yq3u8LJqjwTN7ekV7WtB/BVKbtHs9TeAIcNJ4GTgwysYRYAOQJdw==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199021)(71200400001)(122000001)(478600001)(38100700002)(26005)(83380400001)(186003)(2616005)(33656002)(6512007)(6506007)(53546011)(36756003)(6486002)(38070700005)(316002)(41300700001)(76116006)(91956017)(64756008)(66556008)(66446008)(66946007)(4326008)(6916009)(66476007)(86362001)(8936002)(5660300002)(2906002)(8676002)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?IWgJxHXiUR5hevh2GAzPpEczk6d9Nrbk13/bOTfT7SyxFcmRA8D0rhLgvwQg?=
 =?us-ascii?Q?Wi1FQ6GVeZouoeFFc/ejmNSKttA6d4MpNmZY2bezkvScQZg5+yT8Mh/7i8ko?=
 =?us-ascii?Q?BkfZ63H4F8jsCvgEXwqxZ6M/dx/msxu9ex2jBo3xMqqIuirGuxOEFRG2rK2t?=
 =?us-ascii?Q?TGS5fMLe3yM1A+kLqtUaCs+4aWZHbBjzYLJgiJXnqXZyh5MgDanvBTg0JyP4?=
 =?us-ascii?Q?yewIAn4PxV3Z7gRfwIQ0ps7AB1/Ibvt2HpC0rJ815sbIOfTSC7dD6GmeUmaU?=
 =?us-ascii?Q?pkFo5raT4a7lsR3zZpkvYdqY0hei6EymzyMam4s++y3Tp0hfuMuWqjHof1Bf?=
 =?us-ascii?Q?egeF9hLJ1j/hl+bEuJAFw/klRbDskTQlRm5ciLd6eWIoHoIZH/9U/HB/TUDH?=
 =?us-ascii?Q?ZQ169Coc4eJEWhItr+5I9eh0qDiVFv2qq+JsAX1w1o1dQq33XCPpxhuz4ob4?=
 =?us-ascii?Q?mZWxjT1stjZvKzm2ysF7bsA31qXd1xKJLvmF6Sr1q9qoWGxwMAE6MZQYE5X1?=
 =?us-ascii?Q?/zjGIsa9cCgvGFcwgwGAJRuRPbmTKahXRGSudrmtFXzZdJKfi387gyS3JNGi?=
 =?us-ascii?Q?GheGJX6HVqP8jpuYuPkJVEuyxUkFun3mwWJ/kgdp+XHSLIQ00fIEl0g7Z+kb?=
 =?us-ascii?Q?kIy53dMpF/orSAUnJiUdJK/UXmLBarWYA7SvEBKkGYFGXVRwbpoCBoiUoG/N?=
 =?us-ascii?Q?Qx/vUa4yajY/nzTLP1QF35a+ONiuquaoJulaxczfMjS13BUDvEd1AGsuXKJf?=
 =?us-ascii?Q?E8+pecuuyBY1RiDuLaA+ZrDuiXuxxlqZS1tO2sbxxQw8/UAvAq0Vnb42lhrd?=
 =?us-ascii?Q?FLs8aOG1W8zAyE7kE70PwT8wpmTEdo6fs82XWgTDEK5uDES/G7u+DVgrWN3V?=
 =?us-ascii?Q?YpWVutS62Up6JzSFEnJ7OXqx4fBqHe+zPKImCq5auTFZrNY2W/KOihcCf0u9?=
 =?us-ascii?Q?JdgBvUqcTLLAJSgbANloUkHArFR5fpsmFkvo3ZpcR7FFN6aq1hpOC4WZf8iB?=
 =?us-ascii?Q?sZz9aBuuZOV8KhRMwoMcU+1DKTektmPEehe5u4iw6g8ijiVxLYGmnoejOeHW?=
 =?us-ascii?Q?afX+jluIw+vwb+bToTGiGQx7FCSaK7TdzsEl17alqBjRaaB2dfCZZZmYcP1Z?=
 =?us-ascii?Q?wEQkIQBsg89yAGxHuwxfML32bCH0q0d1IIzdCy3fzlAOxECa4m3HjqPxX84J?=
 =?us-ascii?Q?WchleGLq7MQJ+sxh5/akO/qItBSdVyKZG114mVNKA/x7C/WzLMVgcnCNAtVx?=
 =?us-ascii?Q?23lPqfztdA3EfdSYWT36+z1GxLEdixLpXi7xRcNBrRvH+sCJ1xoi5ywC1467?=
 =?us-ascii?Q?QlmEhL0TOwl7MPm+IitAdUdANlIPzXh2I0OK9hjxZ8ud/pxHKX0WidZ64ZnW?=
 =?us-ascii?Q?b8LIj3RwWWf3HO/93qNWG5YARGJGh58RxkAh6oHmqM8IdbD4Xq3LHQEjA4Fg?=
 =?us-ascii?Q?7Ps4CfN13/QMQ7TdXWFUtXJw271JX19itThfVQu8bZFQbFSuwFRqM7+VSvjB?=
 =?us-ascii?Q?ILA19bVSiCfYD02r57gGBVnKIa8OspWk1BzCLsNy57HXZW104TIuq1ngsNgq?=
 =?us-ascii?Q?4Ksnid19CLjOXgWZXsUg3uZp9HZj6d86FyhTpSMkJmTT6Y4jzjrQRBe6jjgN?=
 =?us-ascii?Q?pg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E0F35BDEEEDEA4C95C75B81F592DFB6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	TUjYXpsIechSX0JK0ZVIePT+tJVKcgNgV+tHnvMsX2e/qWVFSjUWqnKCSSsxbmFYri3gNA8kwkzgCE9ScMwk73oD45zj1mPOULtdKHvqOCAZ8bfUhwDDUgLBjwzxsom6aLGUVQFZ2fMIMieFHoYfTd+l7/sZ/N754FTBPE8SEPKXI4kFEvGXaZkRQGK+wn3OqS8AabJn5kJo3l3YomLvnmkF0y7HS8/E9cvIiTMkYvtsH1jDjA3h8/Hwcg5j9nN+Jbyci6ypoqIlFILaIB5kFz931XmrksIknbA9tV/X92IdcH61ed61tytglKnOnE8yPTDRZRZHM9aJekG9V6gT+/9ORr2HTPHKKq7P9CwJgbnk0FSJ57z32rIGqx8McaCwGeVBSUZHW8v/4oNmc+FzaoMcIfizo88wqjy7syE2AOQ/4b+PxhI/7zA0CxXNgNJnJUF8GEpjvZN5K3OiIU36cX01lbtScJaFE/0a4Yoj0tUmaG38JlPQRlmILyLSxp4MVOQ+d1lDBVIMJqpDQFOX3IF9ouEwBQH6eeALzg8DPqJCrCcOy6f9tfFVP2mdY/iXIS6tmADU2L9FAt93VTA8pW5DyTvalcS9DIM7zKlO1mJIKW8LO5FF2wN4dN06+ps26BHcskZGV38HqsBYRjfUBOxrbdNBoCK8eB+n8bgPP4aAaw1XsisGIP5qvrulDQLGt1P6X6a/0fcqsFOr3YswtZxom8YROr6a9op3nKkVhK3RI9TiLMznSpNe8StrzdfOybLvV0I2hw2l/jZI80puEKtbbQuzXLHzFAbE9SooyE4mPeHHLUDoYiHF0d2So/6Msrfn67JSILTCudcAqG5JKn8e0yGDzlIULZXXCwlFBpf6Xsk5h8/MZrpLw4hA2ViOd7YortwVtGsCg2iMrhwhZg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac50602-6cec-42d0-6b67-08db620834f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 18:52:39.0473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BbrLqHesGfOWyVLzgEcpV4NqiqilHmxr0bqEsyK2Uz/OWpGOu68fnQu69glGPO7YwbqlAzWpl7srOXc4N4KkGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_14,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305310159
X-Proofpoint-ORIG-GUID: kKvEbyRzhFRcbDZOOyPuj0S3YXCnE3o4
X-Proofpoint-GUID: kKvEbyRzhFRcbDZOOyPuj0S3YXCnE3o4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 31, 2023, at 1:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> On Wed, May 31 2023 at 15:06, Chuck Lever III wrote:
>>> On May 31, 2023, at 10:43 AM, Thomas Gleixner <tglx@linutronix.de> wrot=
e:
>>>=20
>>> mlx5_irq_alloc(af_desc)
>>> pci_msix_alloc_irq_at(af_desc)
>>>   msi_domain_alloc_irq_at(af_desc)
>>>     __msi_domain_alloc_irqs(af_desc)
>>> 1)      msidesc->affinity =3D kmemdup(af_desc);
>>>       __irq_domain_alloc_irqs()
>>>         __irq_domain_alloc_irqs(aff=3Dmsidesc->affinity)
>>>           irq_domain_alloc_irqs_locked(aff)
>>>             irq_domain_alloc_irqs_locked(aff)
>>>               irq_domain_alloc_descs(aff)
>>>                 alloc_desc(mask=3D&aff->mask)
>>>                   desc_smp_init(mask)
>>> 2)                    cpumask_copy(desc->irq_common_data.affinity, mask=
);
>>>               irq_domain_alloc_irqs_hierarchy()
>>>                 msi_domain_alloc()
>>>                   intel_irq_remapping_alloc()
>>>                     x86_vector_alloc_irqs()
>>=20
>> It is x86_vector_alloc_irqs() where the struct irq_data is
>> fabricated that ends up in irq_matrix_reserve_managed().
>=20
> Kinda fabricated :)
>=20
>     irqd =3D irq_domain_get_irq_data(domain, virq + i);
>=20
> Thats finding the irqdata which is associated to the vector domain. That
> has been allocated earlier. The affinity mask is retrieved via:
>=20
>    const struct cpumask *affmsk =3D irq_data_get_affinity_mask(irqd);
>=20
> which does:
>=20
>      return irqd->common->affinity;
>=20
> irqd->common points to desc->irq_common_data. The affinity there was
> copied in #2 above.
>=20
>>> This also ends up in the wrong place. That mlx code does:
>>>=20
>>>  af_desc.is_managed =3D false;
>>>=20
>>> but the allocation ends up allocating a managed vector.
>>=20
>> That line was changed in 6.4-rc4 to address another bug,
>> and it avoids the crash by not calling into the misbehaving
>> code. It doesn't address the mlx5_core initialization issue
>> though, because as I said before, execution continues and
>> crashes in a similar scenario later on.
>=20
> Ok.
>=20
>> On my system, I've reverted that fix:
>>=20
>> -       af_desc.is_managed =3D false;
>> +       af_desc.is_managed =3D 1;
>>=20
>> so that we can continue debugging this crash.
>=20
> Ah.
>=20
>>> Can you please instrument this along the call chain so we can see where
>>> or at least when this gets corrupted? Please print the relevant pointer
>>> addresses too so we can see whether that's consistent or not.
>>=20
>> I will continue working on this today.
>>> But that's just the symptom, not the root cause. That code is perfectly
>>> fine when all callers use the proper cpumask functions.
>>=20
>> Agreed: we're crashing here because of the extra bits
>> in the affinity mask, but those bits should not be set
>> in the first place.
>=20
> Correct.
>=20
>> I wasn't sure if for_each_cpu() was supposed to iterate
>> into non-present CPUs -- and I guess the answer
>> is yes, it will iterate the full length of the mask.
>> The caller is responsible for ensuring the mask is valid.
>=20
> Yes, that's the assumption of this constant optimization for the small
> number of CPUs case. All other cases use nr_cpu_ids as limit and won't
> go into non-possible CPUs. I didn't spot it yesterday night either.

This addresses the problem for me with both is_managed =3D 1
and is_managed =3D false:

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/pci_irq.c
index db5687d9fec9..bcf5df316c8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -570,11 +570,11 @@ int mlx5_irqs_request_vectors(struct mlx5_core_dev *d=
ev, u16 *cpus, int nirqs,
        af_desc.is_managed =3D false;
        for (i =3D 0; i < nirqs; i++) {
+               cpumask_clear(&af_desc.mask);
                cpumask_set_cpu(cpus[i], &af_desc.mask);
                irq =3D mlx5_irq_request(dev, i + 1, &af_desc, rmap);
                if (IS_ERR(irq))
                        break;
-               cpumask_clear(&af_desc.mask);
                irqs[i] =3D irq;
        }

If you agree this looks reasonable, I can package it with a
proper patch description and send it to Eli and Saeed.

--
Chuck Lever




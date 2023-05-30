Return-Path: <netdev+bounces-6401-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F25657162A3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AD8028110B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407C8209B6;
	Tue, 30 May 2023 13:51:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C12B1993C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:51:31 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35032106;
	Tue, 30 May 2023 06:51:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UDOH2B009085;
	Tue, 30 May 2023 13:51:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=bduE1oa1JJRZeTtk7z5AyqUbOHmBc8sVXLS8GEXWRes=;
 b=Bj2HiKC94heKxqz1Xsddq7EGzHaFBZI3ZA36rlVbakulANvZDEhuViERvGtciSzKgaZT
 xBGUG/wPvpClnrTsDUJ8Uf6rxdj/5GVo7wnTbLF/Hp0s4bSoMym4Wg/SXIfTrWUO+HWl
 CN0vmCAe/Kg09QYagi8XkA/BTYDMZjcxjrNtziuyOwI7QAG/bKVfSv38rvaQBDFhuoab
 TcOvqEuSJ72rkY/jUGwEg/UWWeoaX9Jjh08mAjvYtOQHt9KjjrRZBLqbGDZCN9pB9yG7
 3C2Mj6SjYy4zRii+X/H3F9GxLOVyCKrHZjctmWC5Jt9tOOkvCfT4tyQi1fSuwQYrtfL9 LQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhj4trkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 13:51:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34UCWHvH019733;
	Tue, 30 May 2023 13:51:05 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a44csy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 13:51:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPqWN5SZz181KpWYUkgngSOc1xKz71u5cp6D3EKs9NPr0O7UdI4U8UHpe8yBjtY9lR8W96WtnHjzAr3UNaE8r0Uho/VQqZrydzHxiEEazJn6CTYUAforoA9gCCMLbY+hYJ1CiGg6FL6G9t3nAQ1Kl+D6u5tS4JRWa/Aaesi4Aek7ivDU1S9Ezweea6csdtMUxupG889/sG5dZxg32U6qkBxSYbqIvvJ+IkesTsigax1OYdXVJRVVfDYMoGVlV91UzFH3EhUmznN6TeK9wm5FY10tqkKPlXasH8hbIsb/7Rp9KCOiLZJxd2IwRPMN4T9SCQdLLfvT7gydWA8mnHZtYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bduE1oa1JJRZeTtk7z5AyqUbOHmBc8sVXLS8GEXWRes=;
 b=jC/DJcQBas/oXtHSVvDxe+YhL2zsgZ99mVFgXvz7IKw2VxBCsTG9rYBDDVuQOxglblkZ3K8IqQjT0ynKUKB6isqbUntogJQ2aoLqC/alpvg+RjfQLbBZWTe3GjiDRA0Z5TghXew64asG+eP1ee7Mfwo4MepExKMZTWPBndZkQb2gXrTejt5plB1QpfNQIzUSf1FCk0hCcmHCSk4mNWjNyYOZqmymlWziB+iNHm8Qovf44mLIuimlnM7cxFxxDDoon+2aoKMTO6GrGug2nOx3JoIvxRfHX5L3l1SOl/QHRw12mYNzA4RtlmyL15wBeYJr37Gzs9PW3w0bsyzwk2/C0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bduE1oa1JJRZeTtk7z5AyqUbOHmBc8sVXLS8GEXWRes=;
 b=vxQ/5RLCyvMqXynOQ2MDPHhFnqqmx/6c4UfgHASli0VyeDsV6UnxGTe5Uuhd7U90VfQXV3wHzyR/WVjJaC9G5foxch9ac8EydQv7KUmZxVetsRzBGTin5XzgF1ICn8shMtUSCjZ2HRe67gEvcovZGVmEwm+IN2oWbZanGj4p6j8=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA0PR10MB6915.namprd10.prod.outlook.com (2603:10b6:208:431::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 13:51:02 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.020; Tue, 30 May 2023
 13:51:02 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Eli Cohen <elic@nvidia.com>
CC: Shay Drory <shayd@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Saeed
 Mahameed <saeedm@nvidia.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open
 list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Thomas Gleixner
	<tglx@linutronix.de>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: 
 AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQCAASStgIAAwYyAgAPUTgCAIGXVgIADNpOAgAEJHQCAAAVBAIAABeaAgAAAiQA=
Date: Tue, 30 May 2023 13:51:02 +0000
Message-ID: <86B0E564-52C0-457E-A101-1BC4D6E22AC2@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com> <875y8altrq.ffs@tglx>
 <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com>
 <FD9A2C0A-1E3A-4D5B-9529-49F140771AAE@oracle.com>
 <DM8PR12MB54005117BF33730B4845DCD4AB4B9@DM8PR12MB5400.namprd12.prod.outlook.com>
In-Reply-To: 
 <DM8PR12MB54005117BF33730B4845DCD4AB4B9@DM8PR12MB5400.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA0PR10MB6915:EE_
x-ms-office365-filtering-correlation-id: 635477db-7aa2-4de3-e5b8-08db6114e83c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 k02zAXld4IZnIWfPSuVS69/KWzUDkC0X+YlM9P49Q9NSk0q3irNZ9v1nO2eWvJaIUp2/+vZwup53fKIGzN8XWz18oc32IOpVDKXiOaGB4U6GF05UO1v9dfVW0BI8Sc/zytp4HeY3Awx3OZUcojrV4NJeL6EMv4tdV+RZhbsizmwQmlvwKUm/BU1HHu8sQDAxNgMxymB3D40RiDXJVFZbp/RSuAwKbPEXgnceJQTS3FbB+BorVRcfnVlYP9osW93wIA15a7x4W4DrAXEN/blke+A93KHPc6SerCn16tFHUKZmMa2Bbr3DuOINdSqql0Z12dEDkOoyaTEFR1W7jjSq99jRtwgY+pHK5mb3+eTCFLCpom12tJzdmYz9q9R6DM9TqtqXg8kkelq65iNh6dfFiFg09e3HHbZW4BK4uyDeCJGFPsMtFTmZR5wUYXXwZLtItqvvEXXY/33JkgasvRR29Om/4tHP6ZeXVihGCjGWjTjWDxSVBgMmVSLEam2i1E1YGo3BR0iVtr6y9MrDgtgcwswDDznytjf2NFsgBmyqHiydpbfC5zAK1RuJYY/rXLMeFCIi7YsIMvv439wvzplIOxNK+PKlXa+WURgtEDwyzX4/JNojpabWM6FYYL4KDsiOmkhTm8r8mkT6HmWu48zWQg==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199021)(26005)(6486002)(53546011)(6506007)(6512007)(71200400001)(33656002)(2906002)(186003)(316002)(5660300002)(41300700001)(36756003)(8936002)(8676002)(478600001)(122000001)(38100700002)(54906003)(6916009)(86362001)(4326008)(2616005)(76116006)(66946007)(91956017)(38070700005)(66476007)(66446008)(66556008)(64756008)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?QdUNKfEQaEtZP0gp4OE9BX4EW/S5rXsl6MNZ7VhV7fbtZdkLOS/k4l1ZTYCd?=
 =?us-ascii?Q?nzMkF0Zf0ONco+q3TFLWOm6Gp7ucpxVhRYxC4bd+0NDCKhU2tmSVdlgEg4Im?=
 =?us-ascii?Q?O21skprfSSCi03dHabrArLhXd66CCML/p0vHa3GOziVKquHb1M3uWGmLGoTK?=
 =?us-ascii?Q?h5x0NoNp2u2DQ270mmr/ydcQSqwVPShd9WnfblNZEk18EZhIRftfdp2A/CeK?=
 =?us-ascii?Q?mW0vL5zXRcR6FMbXto/0+lwhokRVEBe3voaWYcduXW+q0PUsNwXw6Eu0959r?=
 =?us-ascii?Q?YBhigVReQNOzCPtOM6i0vFcbkiJGQOcC56jvyBO8W9CHp4dE3C9nquwA4VLj?=
 =?us-ascii?Q?3SKg6cBmNMbyvjN5Zz+VK3F0EnNVlCe0w/wGGDpQMM/Wqw4STmCST38SO0FL?=
 =?us-ascii?Q?4IV+Mcthv8E0gWyy4A/7uoev9798v9Eh33X6XCMRH9LmoPyv6kDOcKvNU8R4?=
 =?us-ascii?Q?Xve+jPUNsf3BWIHo9LsjhNCgwZUm95DrSfdgrTlNN5f7jBPafLlSRxPxJFsy?=
 =?us-ascii?Q?Fojao4G7qleY2ce9CNEcpaUkHvBRqCdl8pId4xyKGFAZC/edu7UnlhuCr1iM?=
 =?us-ascii?Q?QDmQaIkrsPoMNXj8btTnllX/Pp2Oqriy+vslZ0l+mH8FfFmFl2cNG9kqnh4b?=
 =?us-ascii?Q?uJzYh3K1WI+tpsWbudv76a1B+ViJmx5fzzeXYIg+pOQIfyAJK6whKuZw3P+V?=
 =?us-ascii?Q?0lYz5EIdLlnJ1JLRHhz4E4NUFUTXHyrhXaVkSldQzzjgcQbcj0fMKA5BQJzx?=
 =?us-ascii?Q?qNTLQGlxFyps2S3Hdy7sUehl9Ju5TZtxP9f7rY2X8gsK47Wv3/pmhtQREPmF?=
 =?us-ascii?Q?KYP5Elx2fWc2DJ+LEt5JusgS1dZ3SlmlgofKAUQgFInsx4yOnF4E6kvF7yWY?=
 =?us-ascii?Q?++zy3M60na4BN0+5ZCY8YS1nkRFKoKoLRrKR5c8mQJOaZzN8Cs9zgcH2cTEn?=
 =?us-ascii?Q?TckXw483eqwRAAO363rIEfrjV54dYWgTNvMI4HRkaicXesMZiRGSCr28qoaa?=
 =?us-ascii?Q?ZGCozhVI8vOFU6BLik1vA/dFDndWfV8d9WPwtQyg8CL8f4sIn2rogTANNX1y?=
 =?us-ascii?Q?ClX3lsQKMYqhK50rEs0O7gjmJuJpDEneyLmBIsQ2GA4zYUCmcXOWmMlMhefR?=
 =?us-ascii?Q?z0WMDje5rIX9P2lyeaJbJIFxBDCaIfalJTSdx7BCCXWJhax8FC/SzZZRcybN?=
 =?us-ascii?Q?7HyeuYXz6AQHnC+TWzKlFhT2g7Fdjh9d0mLmUfNq2uAdLYyARC5S0cFqPl9z?=
 =?us-ascii?Q?sXsPVHy17+4U/fQiq0yPahBVIHuPgRyWVMKrNP8s5baPv4UOOXdtZuZDAGVE?=
 =?us-ascii?Q?B1WwKnq+CIWPEl+N77Xp4zzY1su8XOrncqLX0/WEkQ8XUE6EZT5b65BGllWX?=
 =?us-ascii?Q?kEPMoSB915imQWhLxBNiGCxRhR3RJUwNppDxsq+7Q6WSq7/5Y8uWdS/8aCVT?=
 =?us-ascii?Q?ij4KC8CoER5JNjQMhg3SySw4lk1lq8uZwkCSqQbi1v36jogHLXGniAwU4Ozg?=
 =?us-ascii?Q?Pb8HbHmssRMZm6VMQlUXfSMjUSzVCm8whWp10tZ9mEueN0/XHBAOjg4ko3iN?=
 =?us-ascii?Q?aIRA5XZRQx8Y/IUi1Hr8gbM5+9fz7g+m9EFKxi+qOAA+Fwxya+blv8uRvqNJ?=
 =?us-ascii?Q?4g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <229DC3033F5BBD4184D429B9C29C647C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UGSAde9MIS2Elq6u5G18agcOv0v7MuDqJ3QMfZcM4J8s/hyWOy1nA13FJjL4nrpgCn6XBE8OifISwhA3UAONZaI8Eeb2iVp7BZwoY/Xo3CuRaFyeLUsFiD+zdbSea8LtAK5+FcyCXCR2CQMNSGVEB7YU99PYk/SoKCYsyGRW1ew+cKTx6VsgCg+Qc7Q5PFeJ8uLWKVLtcubTHmoje7tyyISrP2Y6Bk7IEHfM+xEaDb/ShPGOtaArX2XwW/6lg5zEKkfor0BAI7JGRgTyqyj6h/OWS8nUfNSJ0dANe0ZUU/tfokT2YuLuSXp+2wYWUYifukFkf/T7ipDy3koS6Odbq7+QPFV2it8iEx51LXViuunu6txPYK4t0MGW8aiMX2pjmqN7/7dQ7xSL5ON3bRR533LzG4seXMv7UKViJZFr/ZhbdYdc6rxtVIlimXxcuQ1Oieet4S2gnVqkZANPz0U3yDMm7fFkHSOjZcA0VTudNky9oO+q9mad45sdrg2yTm0ujorzqthueTnVsPI/N92DVq1tMSranpnHBM0/tg0UOoPJvEXmTd+M7Z4r6lxcfqIRW42sR1oWHxlBv5nUvQ3uxl2HOcsFxgFQJVWqWNlRaUcmcRC318y/AzSoDPptbeMMszy9es2i79fFeJpm+WEutzzWGNM2akbGl7XX4jcye2YXswx7qg+t4+IO9hltu7eop4IEKNT9hSAjzWhhQrCLU+yyNMJB/QGix16I5dT5plMbpyYVFgvHnGMS1SDaaCw+m0vapeOIKGOiUWM6OId5LFEP5tVAaOK7GEt8rG71ER1c683suuTOA4P9RL1F6xk10McF7D9lvB4+5r+Rp6M+ZPzloVBkSzDBnSHQf8weBow=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 635477db-7aa2-4de3-e5b8-08db6114e83c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 13:51:02.6272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fjJ52S5yP4voEaQ6YrGB1meR7y+CWPL9MsNbPdWtfHGwk/q9HMPcSMx4cLPFixCLWh1YWvNU1jmZ3q9vjCWgkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6915
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_10,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305300112
X-Proofpoint-GUID: ErcsbE-pXLmYVSLVSn8SIufWk728aRIN
X-Proofpoint-ORIG-GUID: ErcsbE-pXLmYVSLVSn8SIufWk728aRIN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 30, 2023, at 9:48 AM, Eli Cohen <elic@nvidia.com> wrote:
>=20
>> From: Chuck Lever III <chuck.lever@oracle.com>
>> Sent: Tuesday, 30 May 2023 16:28
>> To: Eli Cohen <elic@nvidia.com>
>> Cc: Leon Romanovsky <leon@kernel.org>; Saeed Mahameed
>> <saeedm@nvidia.com>; linux-rdma <linux-rdma@vger.kernel.org>; open
>> list:NETWORKING [GENERAL] <netdev@vger.kernel.org>; Thomas Gleixner
>> <tglx@linutronix.de>
>> Subject: Re: system hang on start-up (mlx5?)
>>=20
>>=20
>>=20
>>> On May 30, 2023, at 9:09 AM, Chuck Lever III <chuck.lever@oracle.com>
>> wrote:
>>>=20
>>>> On May 29, 2023, at 5:20 PM, Thomas Gleixner <tglx@linutronix.de>
>> wrote:
>>>>=20
>>>> On Sat, May 27 2023 at 20:16, Chuck Lever, III wrote:
>>>>>> On May 7, 2023, at 1:31 AM, Eli Cohen <elic@nvidia.com> wrote:
>>>>> I can boot the system with mlx5_core deny-listed. I log in, remove
>>>>> mlx5_core from the deny list, and then "modprobe mlx5_core" to
>>>>> reproduce the issue while the system is running.
>>>>>=20
>>>>> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core 0000:81:00.0:
>> firmware version: 16.35.2000
>>>>> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core 0000:81:00.0:
>> 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc:
>> pool=3Dffff9a3718e56180 i=3D0 af_desc=3Dffffb6c88493fc90
>>>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefcf0f80 m-
>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefcf0f60 end=3D2=
36
>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core 0000:81:00.0:
>> Port module event: module 0, Cable plugged
>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc:
>> pool=3Dffff9a3718e56180 i=3D1 af_desc=3Dffffb6c88493fc60
>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core 0000:81:00.0:
>> mlx5_pcie_event:301:(pid 10): PCIe slot advertised sufficient power (27W=
).
>>>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a36efcf0f80 m-
>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a36efcf0f60 end=3D2=
36
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a36efd30f80 m-
>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a36efd30f60 end=3D2=
36
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefc30f80 m-
>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefc30f60 end=3D2=
36
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefc70f80 m-
>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefc70f60 end=3D2=
36
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefd30f80 m-
>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefd30f60 end=3D2=
36
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefd70f80 m-
>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefd70f60 end=3D2=
36
>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffffffffb9ef3f80 m-
>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handle
>> page fault for address: ffffffffb9ef3f80
>>>>>=20
>>>>> ###
>>>>>=20
>>>>> The fault address is the cm->managed_map for one of the CPUs.
>>>>=20
>>>> That does not make any sense at all. The irq matrix is initialized via=
:
>>>>=20
>>>> irq_alloc_matrix()
>>>> m =3D kzalloc(sizeof(matric);
>>>> m->maps =3D alloc_percpu(*m->maps);
>>>>=20
>>>> So how is any per CPU map which got allocated there supposed to be
>>>> invalid (not mapped):
>>>>=20
>>>>> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handle
>> page fault for address: ffffffffb9ef3f80
>>>>> May 27 15:47:47 manet.1015granger.net kernel: #PF: supervisor read
>> access in kernel mode
>>>>> May 27 15:47:47 manet.1015granger.net kernel: #PF: error_code(0x0000)
>> - not-present page
>>>>> May 27 15:47:47 manet.1015granger.net kernel: PGD 54ec19067 P4D
>> 54ec19067 PUD 54ec1a063 PMD 482b83063 PTE 800ffffab110c062
>>>>=20
>>>> But if you look at the address: 0xffffffffb9ef3f80
>>>>=20
>>>> That one is bogus:
>>>>=20
>>>>   managed_map=3Dffff9a36efcf0f80
>>>>   managed_map=3Dffff9a36efd30f80
>>>>   managed_map=3Dffff9a3aefc30f80
>>>>   managed_map=3Dffff9a3aefc70f80
>>>>   managed_map=3Dffff9a3aefd30f80
>>>>   managed_map=3Dffff9a3aefd70f80
>>>>   managed_map=3Dffffffffb9ef3f80
>>>>=20
>>>> Can you spot the fail?
>>>>=20
>>>> The first six are in the direct map and the last one is in module map,
>>>> which makes no sense at all.
>>>=20
>>> Indeed. The reason for that is that the affinity mask has bits
>>> set for CPU IDs that are not present on my system.
>>>=20
>>> After bbac70c74183 ("net/mlx5: Use newer affinity descriptor")
>>> that mask is set up like this:
>>>=20
>>> struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
>>> {
>>>       struct mlx5_irq_pool *pool =3D ctrl_irq_pool_get(dev);
>>> -       cpumask_var_t req_mask;
>>> +       struct irq_affinity_desc af_desc;
>>>       struct mlx5_irq *irq;
>>> -       if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
>>> -               return ERR_PTR(-ENOMEM);
>>> -       cpumask_copy(req_mask, cpu_online_mask);
>>> +       cpumask_copy(&af_desc.mask, cpu_online_mask);
>>> +       af_desc.is_managed =3D false;
>>=20
>> By the way, why is "is_managed" set to false?
>>=20
>> This particular system is a NUMA system, and I'd like to be
>> able to set IRQ affinity for the card. Since is_managed is
>> set to false, writing to the /proc/irq files fails with EIO.
>>=20
> This is a control irq and is used for issuing configuration commands.
>=20
> This commit:
> commit c410abbbacb9b378365ba17a30df08b4b9eec64f
> Author: Dou Liyang <douliyangs@gmail.com>
> Date:   Tue Dec 4 23:51:21 2018 +0800
>=20
>    genirq/affinity: Add is_managed to struct irq_affinity_desc
>=20
> explains why it should not be managed.

Understood, but what about the other IRQs? I can't set any
of them. All writes to the proc files result in EIO.


>>> Which normally works as you would expect. But for some historical
>>> reason, I have CONFIG_NR_CPUS=3D32 on my system, and the
>>> cpumask_copy() misbehaves.
>>>=20
>>> If I correct mlx5_ctrl_irq_request() to clear @af_desc before the
>>> copy, this crash goes away. But mlx5_core crashes during a later
>>> part of its init, in cpu_rmap_update(). cpu_rmap_update() does
>>> exactly the same thing (for_each_cpu() on an affinity mask created
>>> by copying), and crashes in a very similar fashion.
>>>=20
>>> If I set CONFIG_NR_CPUS to a larger value, like 512, the problem
>>> vanishes entirely, and "modprobe mlx5_core" works as expected.
>>>=20
>>> Thus I think the problem is with cpumask_copy() or for_each_cpu()
>>> when NR_CPUS is a small value (the default is 8192).
>>>=20
>>>=20
>>>> Can you please apply the debug patch below and provide the output?
>>>>=20
>>>> Thanks,
>>>>=20
>>>>      tglx
>>>> ---
>>>> --- a/kernel/irq/matrix.c
>>>> +++ b/kernel/irq/matrix.c
>>>> @@ -51,6 +51,7 @@ struct irq_matrix {
>>>> unsigned int alloc_end)
>>>> {
>>>> struct irq_matrix *m;
>>>> + unsigned int cpu;
>>>>=20
>>>> if (matrix_bits > IRQ_MATRIX_BITS)
>>>> return NULL;
>>>> @@ -68,6 +69,8 @@ struct irq_matrix {
>>>> kfree(m);
>>>> return NULL;
>>>> }
>>>> + for_each_possible_cpu(cpu)
>>>> + pr_info("ALLOC: CPU%03u: %016lx\n", cpu, (unsigned
>> long)per_cpu_ptr(m->maps, cpu));
>>>> return m;
>>>> }
>>>>=20
>>>> @@ -215,6 +218,8 @@ int irq_matrix_reserve_managed(struct ir
>>>> struct cpumap *cm =3D per_cpu_ptr(m->maps, cpu);
>>>> unsigned int bit;
>>>>=20
>>>> + pr_info("RESERVE MANAGED: CPU%03u: %016lx\n", cpu, (unsigned
>> long)cm);
>>>> +
>>>> bit =3D matrix_alloc_area(m, cm, 1, true);
>>>> if (bit >=3D m->alloc_end)
>>>> goto cleanup;
>>>=20
>>> --
>>> Chuck Lever
>>=20
>>=20
>> --
>> Chuck Lever


--
Chuck Lever




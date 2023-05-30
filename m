Return-Path: <netdev+bounces-6394-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C857161D2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 922C41C20C3E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C381F16A;
	Tue, 30 May 2023 13:28:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3172134C8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:28:52 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90384A1;
	Tue, 30 May 2023 06:28:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UDO6RH020362;
	Tue, 30 May 2023 13:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=D9l5b7WOF8ITobKRwsO2nNWxfN1/+wMO2Gyth+jWp4A=;
 b=KQRtxe9n4r9RJoWv+sLC1GUacOfoZROErUxfiWyRySVcw1M6+rZyQjHeTAAoyZOeth9e
 vcrbSpQ5ckKkEzwU5Lu7Fp9ePvf8zTufaWBDY/y9/87AJNqINYuwFnvWwokQncc3id/1
 MxKhZO/r3kXJNBu3nI2CE/stTJldI5pR1fDv3BpDENAKZWwczgB24aDMQFzTzJDpIeCW
 DKdZ289xlxNc77CgHcbXlF2jzhSTUEWUHD2qetrlabxxjdFjCfGWjv37kCcPiU8j58zU
 ABZmOppXJSO9IWlJxOxkYpkFr4ulcVwc29/Y5XeEkh4ZKQ/zkTzPWMiLPfmdglEtC07v xQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmejph1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 13:28:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34UBZv4U003629;
	Tue, 30 May 2023 13:28:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qv4ybecv0-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 13:28:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlf8IKgNxJJ+W017sJ7euJrD5HJ91d4oFHK4thXPMjtOLVb8oiUAER/Z3ob1VfJmRu+LfwN4cmmfQLaw+RUA3hgp3fVsjrkc1fVLTYJFi4PhJoMDdozw1AFfzImeoQoZrUgr3aQQvMxqh1A0FTMba4d8U3as7cKyYI8MQ9GjaKP7IpAgGBdoixz5B0WNH1mDnW3xTJkDUpWHvRTTyRPxwjaaS/5fcgUtaWRnkdDzbeAnQ1X2hsj6UmqiuPVHTa3TUu9VFd+Xybk/8EaqGFroRsaTUrxR/wangmsZC8JSvfRTfA0qf/hLcynttqtPTBiJ95z1U2JHxw5CDXWjzrLvpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9l5b7WOF8ITobKRwsO2nNWxfN1/+wMO2Gyth+jWp4A=;
 b=dmLzy6hV4lW1sDW89+91WQHSCr+JoQzqnnjt/4PyygeW2LBlGus9AB4F28AXWavfmHRyQWXxVQ93YS394yCkA/SSxIJ900hCmiq3yF2NITB77wKPSW/HvZ+eD3lZ+X/z1lnbqsa920OASZa2WDmXVHnqT310jCDIjSxaBTQ1REasrIXpekPhGhSeAilWFivyZTks6yGjXC5MEVcesQ+IMT8ypS6uiV5ddHbknwO0/f43FiuQLnmEPiv2pfnOadpTrhXdcyXUpGsAab6/64txoHpX/OJuXtAchSisBMJtkrI8d6ZiQpiSdehd+W3ls5JYOt64gYfONWceDS2OeEzXcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9l5b7WOF8ITobKRwsO2nNWxfN1/+wMO2Gyth+jWp4A=;
 b=P+zfGpwnDjw0ApoaIjOWIPDhU1TKEJny8SFgAxVzrP2Pq9PJ6Cz1UvAqjnB/j9uaC+V3a0eE9bdVm2cuhqj4twrlAoDxERtI4FiOxr0AXtMM1idOMzp4gZKXZgbfGjqS328vuBNBp3qAl5Wt2q2A4ZQxYw5jYp+O/iww0nK+KxQ=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS0PR10MB7128.namprd10.prod.outlook.com (2603:10b6:8:dd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.22; Tue, 30 May 2023 13:28:00 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.020; Tue, 30 May 2023
 13:28:00 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Eli Cohen <elic@nvidia.com>
CC: Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: 
 AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQCAASStgIAAwYyAgAPUTgCAIGXVgIADNpOAgAEJHQCAAAVBAA==
Date: Tue, 30 May 2023 13:28:00 +0000
Message-ID: <FD9A2C0A-1E3A-4D5B-9529-49F140771AAE@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com> <875y8altrq.ffs@tglx>
 <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com>
In-Reply-To: <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS0PR10MB7128:EE_
x-ms-office365-filtering-correlation-id: a3da019a-7c91-41c8-a4cd-08db6111b07a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 ew2KPASFEXi1N/l+BnAquGnkdlaGrS3+cg2KP23cMIxayYyd5kEp2IsAM+kxnQbN/QLo2uwAoBzxsXawpg4944ikmqBx6Tz4iLcrAUJZ3vV20Vi7GcSyhL4aT0G592lvaJd9fk5dN0ekMdfsBj9tGMxe8rcLd0sJDl0/KUQ/qFG3tPhsMMxSmfWZcLPmsiNZXaGDI5WngTqbOJZTG9RYICfdZOkObgbRxHiW6CkM/iH6Q6dDx/8ExI9Ko853SGVHWvpfMAiUyaKq+86W8jaw8zxx+yLL8DLPRZLWTeJPanx4CURyd/RwAFjBWIukGfmliSYTrNLtZz+amJU+ez045ua/00EvughAOEqPK22hXH7xcpqux9SD6dJCLB0xoZ2ZYOUnXf9TtIEUs6AIuW5gjMUWtiUaQdpme0pEcYcT9LeodjDb8OdDTDy1cqW/mDubxRRuTJK4SZ22cimVSpKhlzHThWZiKA3PO5WbtaTQDX4mCxD1BkV+aBPpgqU2p28b9mBVjFpEpgVvZzhdAtwJ9PpnO/2JQMEKxmYbxFrp2UVR0R9pEm9EmqQfKZo7wjtij8B28SsWXwvftxIDpP8ryByt1HCGZhcqoCDjZQRxvpL6yq4aA1NB0rx/m6wEJQTQ9sWAGY/1ffzozd4WOgQMhQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199021)(122000001)(38100700002)(41300700001)(316002)(6512007)(38070700005)(6916009)(4326008)(33656002)(71200400001)(86362001)(2906002)(8936002)(6486002)(8676002)(91956017)(76116006)(66946007)(2616005)(36756003)(66556008)(64756008)(66476007)(53546011)(66446008)(54906003)(6506007)(26005)(83380400001)(478600001)(186003)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?3gjg/Ga1lX1s2pGIckS3y/BK5nKJ92FQT0DiGvqRWqaljw7pM2nGZWC9tJBL?=
 =?us-ascii?Q?KJk6oQ9g+LR4eHmx3s1bDUSKaseCDpkE9r8ENY2XPtGjCSF/Z9KKR6cC8zlP?=
 =?us-ascii?Q?3rC0FMVAVKamUoXdQ0NGjK5vvx4AaFfvyQjjhn7sCWVVYGzQQO8mMKEKUYEu?=
 =?us-ascii?Q?qK1hLbZBTEdcRNm3kWdlP0M8ybjb5VdOJ84N5aCgUrjeML3rMFHOobPHVPtQ?=
 =?us-ascii?Q?5WueqXIxz+RVkm1atJiNVw35glawMqqd4GGMpiIYVOYFv5BOPT4WxJkQblLq?=
 =?us-ascii?Q?UevzQ7H+X7cLgifCZOzVNiVtnG9olUKtGTMWdkxaf7ED+u0ql7qxqDl05nWF?=
 =?us-ascii?Q?7me7qDF76dL32pLcq9gvRFqPVkeHIfNsSQ2Qy4r5ImbtrXcDDW54cI02uech?=
 =?us-ascii?Q?gR9qq3wKVBt42/EOgm5WFX6jgeG9fXyuYeIcOdLMt82n7VM2d0y275O8Fdvv?=
 =?us-ascii?Q?nHsj3woP2ayY4+E8xAPny5IKsvvFHPIfac0iZcLJclm1QjvR5j1fwLBgLvYu?=
 =?us-ascii?Q?wBBo6wnjXMeg8puD1ZHonZr+k8t4x61o83emlbvXixFvFU8Qa6izCt6aaspU?=
 =?us-ascii?Q?jRfO2It42F13nsxLWvBUn/tBJ7RERYxKPYIo6LD8q9iIWCQ+mi7YFCGc78Hf?=
 =?us-ascii?Q?iVWp6TAdSPB3uLjSs33ecOfvCjfAa+Dgr7PjpId98DqZnyC7pjsMUb9O5S7P?=
 =?us-ascii?Q?vE89/zQAjalM+fEIFCAEwOk25xWQGCiH2PmuUIpMqd9ONG3LI7YFcbA63xZ/?=
 =?us-ascii?Q?hyFPC2W7boMpPB9G09IZ7EPCevXBAl0s6XJC6F8EKb0vC3I0JhuFXKBk0S1e?=
 =?us-ascii?Q?QOXBZ5rK0CPqyjL96ZhE1v/z8IB0ZGduRuTVQOt46VE2pkr348I93CKiNSMu?=
 =?us-ascii?Q?8+5Y7gBnHx4L/StyeoDd3wFswwxh5lBdJvqs+fo1xsRTXplwA5fo+wdmPIVI?=
 =?us-ascii?Q?fmnjaX3N/uouOjZzrHuMFeyzQ7sywd/fJAbdCl9cGwa9o0o+4mLYy3PxRb0n?=
 =?us-ascii?Q?yxO/j5zaL4JuP0xVKjvOMsN9RiOiErePdNzZ9NvhTmc7b1dw+b9GG6SFVxpp?=
 =?us-ascii?Q?Kpfdm9JoBBKayBOa//6oP81h1oWc6LZuPyKt48h3lyvqv03ChT5d1dg5pEZa?=
 =?us-ascii?Q?reNPE1ha8w2Z4tPJ/ucUzCXgv0FO4jXoqmVufoQVSJHzkgLL7xan01c59HjP?=
 =?us-ascii?Q?SCKBxBmTk69RHnZ69axoVUhYJb++m6GuOb1WRjQJrJnEWK0GVzdqSjql6bs/?=
 =?us-ascii?Q?1o4gRzT7RLBIgE9lLh49EA5qtSHD18ukxZFtuBDBaaHUJpp3JvzdooLOpGIe?=
 =?us-ascii?Q?YlezzjaSh13ufgmwYS0vs8SnS18ezTZKk2HFGoikVUHjbVD2C6YhAXOVaHPb?=
 =?us-ascii?Q?l3YQHG0hyOBg6wDeIYYR98jO6PVVqUlGq3AkodJcpOqP/5XJY9TXLUE48xRk?=
 =?us-ascii?Q?mJlaZ+5d8pFV2U9Es5oxidDWPV402V/ksbdOmnKiKMLE53KFB/h32GxbImBe?=
 =?us-ascii?Q?QEWJVWukYoz0tBV/am1HisbG+yTBkQQgzo9SrVGx8NGaba4Gk1uPoCbhCVZ0?=
 =?us-ascii?Q?Jnw7Z8h+llv1nQxhQ307tfNFqgcPmEtolrT/LMrjW18dqPpbywW9sQlf9UcP?=
 =?us-ascii?Q?2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1DE181B2329F0C439D1012B70BE47536@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	On/3raoWyyuOXmpGeQKbPjMTvNyJ6R1ajjFB218pffaYyX+PGviXVCtXflU46SxsGqp9cF4HB4om1UK2DZJxChWxZ1Wvv1sMPwp9hLHFBocdrm6xmabllNaOWHOawy/8PdD3GlfyevLDlnp54lnUYQ1IrwLl0azTe/AzLEU4oaH+WmYAkawKPJpJrF+GL1eWIglWlpymLYamp7ysvhk58vA+79RIaGA7s1CC8wMeYoKXMckIe3jPPKYzTTBeeqE5aVwvyhfIPrHG193ixNqsV+7KEQZYVphehDjvUplcyu7ewk3kBAgdMEd2oYFQtZGL8XGJyCiVWDK25w8dRLbSLFqSmbvsH403/WpNQ4PJPWLQgK1udLKyPWPohHyG7sKhtpFeS0vUOaNqieYXldBI/Hk+tIEf6NAwjcFQj/DSq6dEt4KHQvl2GrENThvSd9CX7SyImmWR87SCHomRbFHIcLBWqbrtZnY8Y539Kv6+qPqvm8Yv8c68BJZ8QVPH9b2BYHSK57iVQICbMjja2u6EmFSFfwpd1AoDSccJcaIzJ1rEnxXqku4VQjSYQcyHFBO/JsfVI0RaLXtM/MaUUnbYNZZRKAJ1Wpw5UDvTeKxiayTcvnz5A3tNgQrx0HmlaHG2PGRO1A4wViXYN8+f7ci+fwyQg+gvxCz3qzUF4KpYM7cD60TcoktalMyrU/hB4xgRBeH3WdDOeoTpcBD/rujvGNETHRe6p657fkyP1MeisGn3PscsjW+0S7wCWtVol5zzteu7IwNbP8PRtyRsgYXVfzT1yjKoo8mpJ5FFlyJRYl7Z0kNbQAC9gZBtEeuIJgBgxUB91GwTyScWeBtoVP5vvUbTukTZgd3ziBRDpT16Rgo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3da019a-7c91-41c8-a4cd-08db6111b07a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 13:28:00.6225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HEUENpnqTQKp/Au5H8NP9gkoNPPltOydyQrV+EBN5m28a5FO8hrNQ7oaRpTknBKEcHRV5sZkaCko2rBpe0gAiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_10,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300109
X-Proofpoint-ORIG-GUID: DxZ7Ach_ka3ma_PmDwJBkwrWG3m5bdcc
X-Proofpoint-GUID: DxZ7Ach_ka3ma_PmDwJBkwrWG3m5bdcc
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 30, 2023, at 9:09 AM, Chuck Lever III <chuck.lever@oracle.com> wro=
te:
>=20
>> On May 29, 2023, at 5:20 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>=20
>> On Sat, May 27 2023 at 20:16, Chuck Lever, III wrote:
>>>> On May 7, 2023, at 1:31 AM, Eli Cohen <elic@nvidia.com> wrote:
>>> I can boot the system with mlx5_core deny-listed. I log in, remove
>>> mlx5_core from the deny list, and then "modprobe mlx5_core" to
>>> reproduce the issue while the system is running.
>>>=20
>>> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: f=
irmware version: 16.35.2000
>>> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: 1=
26.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc: pool=3Dff=
ff9a3718e56180 i=3D0 af_desc=3Dffffb6c88493fc90
>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefcf0f80 m->system_ma=
p=3Dffff9a33801990d0 end=3D236
>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefcf0f60 end=3D236
>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: P=
ort module event: module 0, Cable plugged
>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc: pool=3Dff=
ff9a3718e56180 i=3D1 af_desc=3Dffffb6c88493fc60
>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: m=
lx5_pcie_event:301:(pid 10): PCIe slot advertised sufficient power (27W).
>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a36efcf0f80 m->system_ma=
p=3Dffff9a33801990d0 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a36efcf0f60 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a36efd30f80 m->system_ma=
p=3Dffff9a33801990d0 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a36efd30f60 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefc30f80 m->system_ma=
p=3Dffff9a33801990d0 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefc30f60 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefc70f80 m->system_ma=
p=3Dffff9a33801990d0 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefc70f60 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefd30f80 m->system_ma=
p=3Dffff9a33801990d0 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefd30f60 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefd70f80 m->system_ma=
p=3Dffff9a33801990d0 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefd70f60 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scr=
atch_map=3Dffff9a33801990b0 cm->managed_map=3Dffffffffb9ef3f80 m->system_ma=
p=3Dffff9a33801990d0 end=3D236
>>> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handle pag=
e fault for address: ffffffffb9ef3f80
>>>=20
>>> ###
>>>=20
>>> The fault address is the cm->managed_map for one of the CPUs.
>>=20
>> That does not make any sense at all. The irq matrix is initialized via:
>>=20
>> irq_alloc_matrix()
>> m =3D kzalloc(sizeof(matric);
>> m->maps =3D alloc_percpu(*m->maps);
>>=20
>> So how is any per CPU map which got allocated there supposed to be
>> invalid (not mapped):
>>=20
>>> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handle pag=
e fault for address: ffffffffb9ef3f80
>>> May 27 15:47:47 manet.1015granger.net kernel: #PF: supervisor read acce=
ss in kernel mode
>>> May 27 15:47:47 manet.1015granger.net kernel: #PF: error_code(0x0000) -=
 not-present page
>>> May 27 15:47:47 manet.1015granger.net kernel: PGD 54ec19067 P4D 54ec190=
67 PUD 54ec1a063 PMD 482b83063 PTE 800ffffab110c062
>>=20
>> But if you look at the address: 0xffffffffb9ef3f80
>>=20
>> That one is bogus:
>>=20
>>    managed_map=3Dffff9a36efcf0f80
>>    managed_map=3Dffff9a36efd30f80
>>    managed_map=3Dffff9a3aefc30f80
>>    managed_map=3Dffff9a3aefc70f80
>>    managed_map=3Dffff9a3aefd30f80
>>    managed_map=3Dffff9a3aefd70f80
>>    managed_map=3Dffffffffb9ef3f80
>>=20
>> Can you spot the fail?
>>=20
>> The first six are in the direct map and the last one is in module map,
>> which makes no sense at all.
>=20
> Indeed. The reason for that is that the affinity mask has bits
> set for CPU IDs that are not present on my system.
>=20
> After bbac70c74183 ("net/mlx5: Use newer affinity descriptor")
> that mask is set up like this:
>=20
> struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
> {
>        struct mlx5_irq_pool *pool =3D ctrl_irq_pool_get(dev);
> -       cpumask_var_t req_mask;
> +       struct irq_affinity_desc af_desc;
>        struct mlx5_irq *irq;
> -       if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
> -               return ERR_PTR(-ENOMEM);
> -       cpumask_copy(req_mask, cpu_online_mask);
> +       cpumask_copy(&af_desc.mask, cpu_online_mask);
> +       af_desc.is_managed =3D false;

By the way, why is "is_managed" set to false?

This particular system is a NUMA system, and I'd like to be
able to set IRQ affinity for the card. Since is_managed is
set to false, writing to the /proc/irq files fails with EIO.


> Which normally works as you would expect. But for some historical
> reason, I have CONFIG_NR_CPUS=3D32 on my system, and the
> cpumask_copy() misbehaves.
>=20
> If I correct mlx5_ctrl_irq_request() to clear @af_desc before the
> copy, this crash goes away. But mlx5_core crashes during a later
> part of its init, in cpu_rmap_update(). cpu_rmap_update() does
> exactly the same thing (for_each_cpu() on an affinity mask created
> by copying), and crashes in a very similar fashion.
>=20
> If I set CONFIG_NR_CPUS to a larger value, like 512, the problem
> vanishes entirely, and "modprobe mlx5_core" works as expected.
>=20
> Thus I think the problem is with cpumask_copy() or for_each_cpu()
> when NR_CPUS is a small value (the default is 8192).
>=20
>=20
>> Can you please apply the debug patch below and provide the output?
>>=20
>> Thanks,
>>=20
>>       tglx
>> ---
>> --- a/kernel/irq/matrix.c
>> +++ b/kernel/irq/matrix.c
>> @@ -51,6 +51,7 @@ struct irq_matrix {
>>  unsigned int alloc_end)
>> {
>> struct irq_matrix *m;
>> + unsigned int cpu;
>>=20
>> if (matrix_bits > IRQ_MATRIX_BITS)
>> return NULL;
>> @@ -68,6 +69,8 @@ struct irq_matrix {
>> kfree(m);
>> return NULL;
>> }
>> + for_each_possible_cpu(cpu)
>> + pr_info("ALLOC: CPU%03u: %016lx\n", cpu, (unsigned long)per_cpu_ptr(m-=
>maps, cpu));
>> return m;
>> }
>>=20
>> @@ -215,6 +218,8 @@ int irq_matrix_reserve_managed(struct ir
>> struct cpumap *cm =3D per_cpu_ptr(m->maps, cpu);
>> unsigned int bit;
>>=20
>> + pr_info("RESERVE MANAGED: CPU%03u: %016lx\n", cpu, (unsigned long)cm);
>> +
>> bit =3D matrix_alloc_area(m, cm, 1, true);
>> if (bit >=3D m->alloc_end)
>> goto cleanup;
>=20
> --
> Chuck Lever


--
Chuck Lever




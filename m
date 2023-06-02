Return-Path: <netdev+bounces-7422-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73327720388
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EB9B1C20E90
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C5F918C3B;
	Fri,  2 Jun 2023 13:39:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1903215BF
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:39:02 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3191A7;
	Fri,  2 Jun 2023 06:39:01 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352CQFi7028608;
	Fri, 2 Jun 2023 13:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Fbd0yhUCnr2mpx2tPC+5q/yt9GMhdVMak8IVnOZGNJQ=;
 b=yGzaYLI6zyeN/B9cgR/ex+CgxZQFepSujvQUjOhUpTKyNsb3KPzIE9jS9JCL/NN0eghB
 eNwJjcJO1ydIu5gXOKTsnqGwqPg0Me1ttO9/N0vlOmo51mXURAr7U9EmD9fpkeD1Qq7M
 arn/wXOpBRrR3KdGEPsCOu7UQK7q/eobb60d+kpyV0/iGZ2pB4nSV/pESWoSS9FL2P/h
 YN1VciZbTfK+grn2E2/QhFiBrzWnBkuiwrNiDL/qLTEYyUOIdfyXRuLaeloSzOmiZ73g
 ZbLLD8PcXHiwoVpfmZhpxdXegYKW9SrM/4oi1qNJiaAevJK2vEz6RKpaV2nAKGR7m8CE Kg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhjku0y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jun 2023 13:38:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 352CMHnu035237;
	Fri, 2 Jun 2023 13:38:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a8kvyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jun 2023 13:38:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3PSgGwsrpqUiMbbDhJIiaObOtEXlzKZkzVUYSTt1pLRAx9+sFze1uANCeCApYhEwzWEosspiXuxt1N1CZZYTiUQZ9Kn9nS8j5yxjOkpVYBIWoI3Kw0nTW2tqHU2mAWXuo71W4bN9Vq96MYeAkB6o7cncQ/GqQC4iElZWDA5m/ofow5s6QnUmu9Euxrwr0yMZb6iPsj+CdOjsQc2/LPMxNzHLQLpuo8oZHFPBXGUk42BtKLccqBNsFSlMeUKWakNsAVLB0LqeAHMf6jO0A2rVijTo60wDolz0Th74TsI+IqYRsDACzgdKkwOofgK7EzB9+CqlPQbI1SBZKurqMrhHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fbd0yhUCnr2mpx2tPC+5q/yt9GMhdVMak8IVnOZGNJQ=;
 b=fI1eS/L3rJryDivScjbcSn2pPJQH9urS1OKP9Gfggjk9U0wmcQi50qN6pR7Bi/w+PsIRfw2LFJXBnXteRYvQ4xX7VSvbKRi3QVZSleBH0BkIM5ndINYxZPSWE+tE+4sJ7zHPOAa+NzTi61ZiCEzjV/FKcTiZVEtV5WG88bJYTeFX3Z2amAi09Hg8soGIIUbWfoNLU01Tx94bxPmtVk1LP+NPANXtWAclmTMLbLIb7TbjBkqAVsM7aloXZtImTFA4mECGCba8Xpd3VXaQGIqVb+ACW3RQ/lNoV+/UvmUpdYGRLl7tBNPamTb/6l69XSfoBThN4IKDSJS+Vavd3CvY9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fbd0yhUCnr2mpx2tPC+5q/yt9GMhdVMak8IVnOZGNJQ=;
 b=usCDMCPh/gong3z1IDKeBC40FY62f9r1KALxxfoYYX2Bz+8o+eDjcx4sp/Z4Z13w9yCNVOyhAeltEMTASXdRfpn4stwui9aw/OYXBQDaWiZvzUI9IfSoWHZJrgUAATDkT0gNVV8SVuAtTWGd8QwLX5zgOdyXkZu9ufrVSwNUI4k=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH2PR10MB4280.namprd10.prod.outlook.com (2603:10b6:610:aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Fri, 2 Jun
 2023 13:38:46 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 13:38:45 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Linux regressions mailing list <regressions@lists.linux.dev>
CC: "elic@nvidia.com" <elic@nvidia.com>,
        "saeedm@nvidia.com"
	<saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        linux-rdma
	<linux-rdma@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9QVtoAgCcyyQCAACq0AA==
Date: Fri, 2 Jun 2023 13:38:45 +0000
Message-ID: <AAFDF38A-E59A-4D6A-8EC2-113861C8B5DB@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <bf2594bb-94e0-5c89-88ad-935dee2ac95c@leemhuis.info>
 <5b235e0f-cd4c-a453-d648-5a4e9080ac19@leemhuis.info>
In-Reply-To: <5b235e0f-cd4c-a453-d648-5a4e9080ac19@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CH2PR10MB4280:EE_
x-ms-office365-filtering-correlation-id: bcca1edd-b6b8-4171-7fe8-08db636eb03d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 GvXudA9patuN/XgQK6AwtrEC4gRyB7qEZCqzjWmG51iKtj6eUziqZ6MnFKkQ+EabGkE3ht2Hb7B1dsh5IfS9rnev5IvaaJGIr4AaXKa/eGbeVJGwNkH5OSMOsIGh8v0MzFNQChnliJNXcleIg1dvoZXa23d46jBTnY2iTDCQqZatrtBiA4bzeaDb7ZqVbUGwCLAicXlE8FDtcU8MnwOaKKvhMWLAoEFZ2wwPdWRJHsOophLkfMhEnw2+Z48vwMHDdnXmVH65nZS6LGWEljNmc0LsVW1dyW0STwk8MndvK/KEGD1UWiGU3wHj8OBBP70tKFiQFSyAgFamwNvs9+4TSkVeobAYL4LSE+OmxEbdrvdjwueahH3wtIhdTW/RVzlzEc95KB6cDaUE5nmePcXSp4LHscPWn6gYveLS+2l1/CQ5u0KMybEKO75Cme7PjQddLVBdea+xOvMt9xvsGGmn3fpVuD0ou7q+nUQo81KngrpXNjChzrnWdD1Cd2hJiLc9AMpgOQCN8efLrz4GGG6egpisSYqsjCqKNfX5jCtRaFKuaX4XE4DufdgYY5lSvI8AJOj3zMBOJuzjuC9AMSn+yFzlMqXhX8pavNE0hZJWvrwEyKUkSG0BDYUOhw6Vqz8T90bu1QmG23DPQcHc51xXEA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(396003)(376002)(346002)(451199021)(33656002)(478600001)(6512007)(2616005)(6506007)(53546011)(26005)(36756003)(186003)(83380400001)(6486002)(71200400001)(41300700001)(966005)(38100700002)(122000001)(6916009)(4326008)(76116006)(66556008)(66476007)(66446008)(66946007)(64756008)(316002)(86362001)(2906002)(38070700005)(5660300002)(8936002)(8676002)(54906003)(91956017)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?THpJWHl3NFMyN25QK1Q3VEw3V0U3OWxlTWpNZFNROUU2dnpFYm1PYXRFY0Ra?=
 =?utf-8?B?SkhYMElORWRHaTJzaE9GY1dnOFVzNTltd3M3d3M3RFJ6YUs4bGVkUllyR0lT?=
 =?utf-8?B?Tnp2d2RVSDFwdVhKWjhkSlZLeXNkRVhTaGEzVWVBSzQwMkRjU0xXaVVxdjFZ?=
 =?utf-8?B?dmNJdTRyWmFTbDVJY281ZmRNU1cyODlYbmR5ZklFaGlBQWYvN3RHWFd6RmYy?=
 =?utf-8?B?a0JEKzl5UGEydzdxd28xQXdJK0RMVGl4UWhjR3NKeFhHa3RhRkxXd0xhQ2ww?=
 =?utf-8?B?cWM5SDZCbFQvTTRETlBhb3hidm5sN0RaTkxDV2t4V0JzbVlqSE5NNGo1aDZK?=
 =?utf-8?B?cmZiUDh5OVpuRlQ0c2VheU43U2luVlNpTzlkYWMwN1B2YUxuc2FGcENHMzly?=
 =?utf-8?B?eXBkOC9oWWVra3pINWpDazlDNjBTS0dMdVJGcHp3dEdrMC8yWHlSdDBWUUM0?=
 =?utf-8?B?MGwyQjBuNUcxTHBkWGVaTmpiYm9Sak45RlU0L21UMWFMT01OZkFKNFY3N2JC?=
 =?utf-8?B?bS8vemxOK00wVHZpY2xQNEcxcFRTRjhZWWpEa3dJQVJoaEJhNDF3QkpoOTll?=
 =?utf-8?B?REdYUENFb2NwTzN6ekxqeFI5dVlVQ29pdnpYOWdOSkNJckRKczZBcWZRTWlu?=
 =?utf-8?B?WEN3dGtoeU1pMVI4MVJFQ0NGZHpQZEVtMmVGbHpSbG9ORGNoMlFUUkxtVDNy?=
 =?utf-8?B?MFBYS29ETXFOdkN4amdZaGdmL2RockNnbWN5VUFvdmRiVithL3VhSjRiNFFt?=
 =?utf-8?B?QVRva3JaMFQ0UlNoQWJwMlpOQWlOcnlCVEpyTXBFb1NyU2dFZlNzTlBLWUty?=
 =?utf-8?B?MTI3MnJBUUw5VlVQWldjYjhQTEhIS2xjTHhXVWZjZktHV29yQ3NyWWRTOVZT?=
 =?utf-8?B?elFVNWtzT01ENGQxTG9BWlFLM2w5VDRHZnlQVFRlaTBmVFlma1QzMERwL1kr?=
 =?utf-8?B?cWNHY3dQTjI1KzB2Z3FmZXdvODdTamtSdzlCMSs5dE9DM0QxVG1SdGdQS0dx?=
 =?utf-8?B?ZjFtSXVEMGtWcGwwZW11TkxLWGJqd3d6YVBUcFNkTk5Sa0pZeUl6cFdCR2FH?=
 =?utf-8?B?MU1jVEJJemE4aS9mVW9nbmUzMnhPTkVJNmNXb0JKdHhSK25sVkk3SGlaQnlC?=
 =?utf-8?B?bGVJSVhUZEJLQWsxVUhtRUt6eHhlVk5RSi9FRUhNb2VVaWVaYnFkZzR4eFVK?=
 =?utf-8?B?ZGJPb2IwQXNZeXBzK1lNMEhBRUZWMGdaVUtXYmxvSUF1UDBTWjhzb29ab2N1?=
 =?utf-8?B?SDJGdW1iVFFBMmt6WDRuU0s4eERsWVA3Q2ljNTNwbkpnYmh4MndmdFNvU1dI?=
 =?utf-8?B?K2FDUjNVbkc0MncreHlsZk5CaEppSnN2dm42S3Nmb21HL05jMjZ6VS8vWmky?=
 =?utf-8?B?VytnYnhkZVAxakQvUzRsNUI5aTl3UDh2N1pyTEF2Sk1HNEthRnVxdjg2dlVm?=
 =?utf-8?B?NjdCM3VFL0l6ZWxNZGl4b2xWVER6QWVNTkpjYlpsbTduK28vRzBWaTFZNnJp?=
 =?utf-8?B?eGJkOExvQ2dkbjYzRDBWbkVoUmxBWHNHQzZMMytpTTg5djY0YkdJcGcyMXdJ?=
 =?utf-8?B?V0p3VWJHeDYxaFpuQVVSZmcvNTNZTnpMVWtXdFRLYlpyRk5qcTdGdUJGOVRW?=
 =?utf-8?B?eXBZVWJ2VElnb3lPTHVMaXptVlprZUNuVHRWRWhOczJKdTg1Ymp1VjlkL1M0?=
 =?utf-8?B?STdDaWNyMTlySEJWdHJLQUgrRS9PV1pDSWlHQWZiQ3Q0WTdTZzhTR2VwTEtp?=
 =?utf-8?B?dEFKVHdUNG52Sm1HeEhyMUR3VTZrODdPUUhHQSsvaFB2Z3Iybitwalg1VXZF?=
 =?utf-8?B?T2xrZXVZUzFkcU1wZVdxR1VOc3J6N3BGMXgwalEzd25JMTQydFl3azhqdHVS?=
 =?utf-8?B?NlMzaERZVVdoVEVBcHdVa3I5UmZkUWdMOXBmeEtFM2s0ZFVMQnVVQXhFQTN2?=
 =?utf-8?B?azN4akdmR0xabUFMc1lUaVk3UWRwcVpiS1V2QWFyN0RVWDM3UnJoNFNNajE3?=
 =?utf-8?B?ZXljeWJmVHp1cHB4L1hLTVhvdnFkUjBsSktiY3dKWWVDc2JINGowVXp1Z01Y?=
 =?utf-8?B?ZTN0dmV1TzlNbWIvWFFKY2lyeXRDVWhRNHZ2ZTRYYWlzY2JUbU4zdHAyTjhQ?=
 =?utf-8?B?cllYeEdGeG9PeWpudUFvTUtxdklMbmNaZ3ZxR2dueVJGS21JYzEySFBDdDVa?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E679F9703814D44A95FECF6A9B114B4D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ObtbIsH9HJFQqss/EeiL6D5YKuQcHoQvAuyPtg2fy0+5Ufi3KZ6Gv2RlgnNrd1sLMV22zuQzBy87zis1TX8zfLC9FGzj/Es/f2WMcvk9+496mEDLZsXqo3IkWHqyKDNET2txmqEow95f53DiDaCPmMiUAWnFulnflP7zK5ep7ROp7AvnGux74ZewbYaxH/vrgdY+ZKyIe1/ryyL6n9eOHkrwWTYfM8c9h+1kiBs0DCaO5U7SzzKC2b3+c+5cbcxxJAuWcly6feBdi1hqbOfURpH8lu/q1HVrGfRjzTDijtjxhTWGfBXTTbAndO01eG0tP6VPuE12hD0yzTZQA1AtX1QoTmmgyGDg74KnDzcu7X0f3Tq2VOG+BelADuFhTYmK6kFPOMMV9TFxBiXOffy8GSj44bznzmoQwhdLjePR/cYYYyO3iYjcQa8L8sEdVy1JXQ2WdRVq+DakWWMBnyLIr+rEarG97aaseUfv1B804u3TqGitYj3QDwHZs/Be35wsMJ1MRGmdjzFL3XB74osSUZ9zg3565pmoVPWwW6/f2m/YNt44NlIpbVHZ30ZUyiJjISZ4S6Y/zd6DvvbyOfNHMt5c2GXN9kSsJ8gyRIuebV02LLYoA7WeR+CUm+dlvJqp2UWFVGeQgYw1LCgVD3SIouoUwGaUBdzWDimfhEjzaZWnuWzd65MotVgGDcy6gXn5axNd2x+nAIlTgJ7jSOFeJBE1foQNcSAaFRN/XpvGRk+zYHK/Ybh09D7Fw3x4IM+h2dY1yFUkF/NApshjNhrr9W59smArhqYfXFaXp1qU6u+oVWM1MQcjUomtZv4KJYmDgEhoUg9uYTSjkn7NtgS7xf/MLTFqyRVwcfLoAMzMsaA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcca1edd-b6b8-4171-7fe8-08db636eb03d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2023 13:38:45.7372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lWzGccBOuhGg1vKcLVh1V0GeKeCmvl64sUA9Zqb3FBsTtyMECJO7A+g/XKgq3LJ9QZ/gNrtKWGxMX10kRMmKug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4280
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_10,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306020103
X-Proofpoint-ORIG-GUID: 1qNF_YTN1a9d6iEHjU50rZCIhJAKeTyM
X-Proofpoint-GUID: 1qNF_YTN1a9d6iEHjU50rZCIhJAKeTyM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgVGhvcnN0ZW4gLQ0KDQo+IE9uIEp1biAyLCAyMDIzLCBhdCA3OjA1IEFNLCBMaW51eCByZWdy
ZXNzaW9uIHRyYWNraW5nICN1cGRhdGUgKFRob3JzdGVuIExlZW1odWlzKSA8cmVncmVzc2lvbnNA
bGVlbWh1aXMuaW5mbz4gd3JvdGU6DQo+IA0KPiBbVExEUjogVGhpcyBtYWlsIGluIHByaW1hcmls
eSByZWxldmFudCBmb3IgTGludXggcmVncmVzc2lvbiB0cmFja2luZy4gQQ0KPiBjaGFuZ2Ugb3Ig
Zml4IHJlbGF0ZWQgdG8gdGhlIHJlZ3Jlc3Npb24gZGlzY3Vzc2VkIGluIHRoaXMgdGhyZWFkIHdh
cw0KPiBwb3N0ZWQgb3IgYXBwbGllZCwgYnV0IGl0IGRpZCBub3QgdXNlIGEgTGluazogdGFnIHRv
IHBvaW50IHRvIHRoZQ0KPiByZXBvcnQsIGFzIExpbnVzIGFuZCB0aGUgZG9jdW1lbnRhdGlvbiBj
YWxsIGZvci4NCg0KTGludXMgcmVjZW50bHkgc3RhdGVkIGhlIGRpZCBub3QgbGlrZSBMaW5rOiB0
YWdzIHBvaW50aW5nIHRvIGFuDQplbWFpbCB0aHJlYWQgb24gbG9yZS4NCg0KQWxzbywgY2hlY2tw
YXRjaC5wbCBpcyBub3cgY29tcGxhaW5pbmcgYWJvdXQgQ2xvc2VzOiB0YWdzIGluc3RlYWQNCm9m
IExpbms6IHRhZ3MuIEEgYnVnIHdhcyBuZXZlciBvcGVuZWQgZm9yIHRoaXMgaXNzdWUuDQoNCkkg
ZGlkIGNoZWNrIHRoZSByZWd6Ym90IGRvY3Mgb24gaG93IHRvIG1hcmsgdGhpcyBpc3N1ZSBjbG9z
ZWQsDQpidXQgZGlkbid0IGZpbmQgYSByZWFkeSBhbnN3ZXIuIFRoYW5rIHlvdSBmb3IgZm9sbG93
aW5nIHVwLg0KDQoNCj4gVGhpbmdzIGhhcHBlbiwgbm8NCj4gd29ycmllcyAtLSBidXQgbm93IHRo
ZSByZWdyZXNzaW9uIHRyYWNraW5nIGJvdCBuZWVkcyB0byBiZSB0b2xkIG1hbnVhbGx5DQo+IGFi
b3V0IHRoZSBmaXguIFNlZSBsaW5rIGluIGZvb3RlciBpZiB0aGVzZSBtYWlscyBhbm5veSB5b3Uu
XQ0KPiANCj4gT24gMDguMDUuMjMgMTQ6MjksIExpbnV4IHJlZ3Jlc3Npb24gdHJhY2tpbmcgI2Fk
ZGluZyAoVGhvcnN0ZW4gTGVlbWh1aXMpDQo+IHdyb3RlOg0KPj4gT24gMDMuMDUuMjMgMDM6MDMs
IENodWNrIExldmVyIElJSSB3cm90ZToNCj4+PiANCj4+PiBJIGhhdmUgYSBTdXBlcm1pY3JvIFgx
MFNSQS1GL1gxMFNSQS1GIHdpdGggYSBDb25uZWN0WMKuLTUgRU4gbmV0d29yaw0KPj4+IGludGVy
ZmFjZSBjYXJkLCAxMDBHYkUgc2luZ2xlLXBvcnQgUVNGUDI4LCBQQ0llMy4wIHgxNiwgdGFsbCBi
cmFja2V0Ow0KPj4+IE1DWDUxNUEtQ0NBVA0KPj4+IA0KPj4+IFdoZW4gYm9vdGluZyBhIHY2LjMr
IGtlcm5lbCwgdGhlIGJvb3QgcHJvY2VzcyBzdG9wcyBjb2xkIGFmdGVyIGENCj4+PiBmZXcgc2Vj
b25kcy4gVGhlIGxhc3QgbWVzc2FnZSBvbiB0aGUgY29uc29sZSBpcyB0aGUgTUxYNSBkcml2ZXIN
Cj4+PiBub3RlIGFib3V0ICJQQ0llIHNsb3QgYWR2ZXJ0aXNlZCBzdWZmaWNpZW50IHBvd2VyICgy
N1cpIi4NCj4+PiANCj4+PiBiaXNlY3QgcmVwb3J0cyB0aGF0IGJiYWM3MGM3NDE4MyAoIm5ldC9t
bHg1OiBVc2UgbmV3ZXIgYWZmaW5pdHkNCj4+PiBkZXNjcmlwdG9yIikgaXMgdGhlIGZpcnN0IGJh
ZCBjb21taXQuDQo+Pj4gDQo+Pj4gSSd2ZSB0cm9sbGVkIGxvcmUgYSBjb3VwbGUgb2YgdGltZXMg
YW5kIGhhdmVuJ3QgZm91bmQgYW55IGRpc2N1c3Npb24NCj4+PiBvZiB0aGlzIGlzc3VlLg0KPj4g
DQo+PiAjcmVnemJvdCBeaW50cm9kdWNlZCBiYmFjNzBjNzQxODMNCj4+ICNyZWd6Ym90IHRpdGxl
IHN5c3RlbSBoYW5nIG9uIHN0YXJ0LXVwIChpcnEgb3IgbWx4NSBwcm9ibGVtPykNCj4+ICNyZWd6
Ym90IGlnbm9yZS1hY3Rpdml0eQ0KPiANCj4gI3JlZ3pib3QgZml4OiAzNjg1OTE5OTVkMDEwZTYN
Cj4gI3JlZ3pib3QgaWdub3JlLWFjdGl2aXR5DQo+IA0KPiBDaWFvLCBUaG9yc3RlbiAod2Vhcmlu
ZyBoaXMgJ3RoZSBMaW51eCBrZXJuZWwncyByZWdyZXNzaW9uIHRyYWNrZXInIGhhdCkNCj4gLS0N
Cj4gRXZlcnl0aGluZyB5b3Ugd2FubmEga25vdyBhYm91dCBMaW51eCBrZXJuZWwgcmVncmVzc2lv
biB0cmFja2luZzoNCj4gaHR0cHM6Ly9saW51eC1yZWd0cmFja2luZy5sZWVtaHVpcy5pbmZvL2Fi
b3V0LyN0bGRyDQo+IFRoYXQgcGFnZSBhbHNvIGV4cGxhaW5zIHdoYXQgdG8gZG8gaWYgbWFpbHMg
bGlrZSB0aGlzIGFubm95IHlvdS4NCg0KLS0NCkNodWNrIExldmVyDQoNCg0K


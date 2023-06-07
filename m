Return-Path: <netdev+bounces-8921-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 388547264C1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87B8C1C20E88
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0806E370DA;
	Wed,  7 Jun 2023 15:35:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D805814AA5;
	Wed,  7 Jun 2023 15:35:56 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF01C1BE2;
	Wed,  7 Jun 2023 08:35:51 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3578bfcP010042;
	Wed, 7 Jun 2023 08:35:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=jFyyI1+lujXI8YManbdB9Lqw3Ml3vMRKrk7dTB4n5mQ=;
 b=f5opnhrg4jfu2iYYK8vHBTkwa5x3NL8Zrrpmvk+86F9vnXRRcM0gZbdX/MrmAigc4YNT
 nc/3qTlDyQvWwAFmA3gFgdPgoFjIAdaCSraMfRzUo47/xUJIsjykaKa70mieTFNeN1nJ
 kJYiqMv526aZzL0+jLpfFkpfKoXxMNV35Kg54qWPgOj2lTvEnyLAHM5S3eyy1/GNwjjb
 iTo4iLwbH8uAfQSuNSzMoZY7ZwfOckE3U8SynjrIyoDoNpD/oUxYiU/BjxD9ZsuKWdmI
 5A35HHLoK0Lqpby/45beB+B2xeCrr47/DaJqKYx7xLuJTwOFUmwJujnkskHYw82Rpz5P dg== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r2a89q9hr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jun 2023 08:35:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/OKrqfHF5vZGXt4OpkRTNAz+0SjE8sx+uDH/j7CoFNw27IyNwIuti9+NdLaeAPQA4VbF/onwquCmbkjXyQZo+FEJWm+NOvvzuSxLA0WisurU1+zay1ux8IprhlqHLbW1bo1AIbjvgcqPfCV3DcBAVUqHom1SHRKT2GUmdquo5hH9K/uCgmm6O8A8+CoO9ptvsXNLUw+H3wZdkAp9m9VXqd1/AVb9j+0LqtvTRLq/qEbR7dQOJzF7GaRvxjXNgHieCzpZTmORgP0PWnvdy/Wj5NT/kFnMyRznbg1iMpCIHq9S11bLmK/soDyFKq8EUgzq/W8vP5TxXv7b6LRDnMsrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFyyI1+lujXI8YManbdB9Lqw3Ml3vMRKrk7dTB4n5mQ=;
 b=D4vnzgQog+ImH3Ct8V1e/VC5gz1y7mP7zyOf33/HI5fZ0BoMlrcpReywaVpoJOklm7jnVcKVlUFlPl4NDHOS8yNbnjhfo9RY9iwn/4V+6fu1hdy88f6H/3qnwF8Z4XW7lHBpmBgMN1HY9S49BEI95nL+g/Ag/NmuPNVFCRenkBOui3+tYLqoiAnEKx88Fb1SzkXSq1jmXMCpstQU54UGAOu2tKt2MZplM6XlBESUGTl5seaZv6imRgFd4XGJUPR/xAec/GPXWmdj1ZrYaBLK+GlepxuXpbHld/hVAixNm3BjReRJ0aStZP5icIRMFemFMHzjW1GWZunsfwMTZ7ySag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB4456.namprd15.prod.outlook.com (2603:10b6:a03:375::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 15:35:27 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%6]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 15:35:26 +0000
Message-ID: <44c1da5c-251a-fd92-2a14-655d2e99bf03@meta.com>
Date: Wed, 7 Jun 2023 08:35:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH bpf v4 2/2] selftests/bpf: Add test cases to assert proper
 ID tracking on spill
Content-Language: en-US
To: Maxim Mikityanskiy <maxtram95@gmail.com>, bpf@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Eduard Zingerman
 <eddyz87@gmail.com>,
        Maxim Mikityanskiy <maxim@isovalent.com>, Song Liu <song@kernel.org>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
        Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
References: <20230607123951.558971-1-maxtram95@gmail.com>
 <20230607123951.558971-3-maxtram95@gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230607123951.558971-3-maxtram95@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::47) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SJ0PR15MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: c511f25f-f5f7-43d5-7fdb-08db676cd0b0
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Cq/XnkFEctA2OcMYeCvbDA6dfCDWeTCrj2cmtVOX1i+5wtTc5IxQ7e3oGNdmeLH6RH7V+1kehJvZ0kFlwDRLGWIjN9uR+4x+hX16S+3cLKqojgmh3VzXfzkkzN8PheWrr7f8mi2/HDU5qOArjKV89d4o/HqEbmPrFdhxBsEb7I8tvStXqRflno8CEWM4QRExvMV2sdz1Q0Y2HySVevAFwK8EdY2fGiFjYI3xDKGYoCrg2e6CPXeNglVPATlWVzC7t/ITvU6q3QXWsrJPtA9Dky4DgDCpPrSkZuLWHqNuY1Cirv75Y/lYMPmaiG69Y/vayigMSNx6u3tdT85EeDOz2+k+4MOGa9R0hbi/M2maBrhYvPwaWwwV+JNARSlGKRb5nF5yda6aYAUwAZRitlLdGWUwdXqjxHZed1h6rSbxXdMEA26lFjVZvjsLI8WB2C+yk1IalaSyUBMaTBg10cJgrInIRcpzRkQF43o5evvfPMP84ZWtnaekXMI509RbEi9Zbuv/UFuxstw8ZHq5Ip0IekJg2lNqHWsLv+1sqTI1jPNVFzadh5DAmxD1S1rohS7NCAEdW5J81bi36OW75fx2L+jhYcQ9dtCvUChQp+yAI7/RNPCsrTX5tf+kGcf9SPtvGwGKl7A+w/9/QTwIKsohsQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199021)(53546011)(86362001)(186003)(7416002)(6506007)(6512007)(31696002)(6486002)(2616005)(31686004)(6666004)(8936002)(8676002)(5660300002)(478600001)(36756003)(54906003)(38100700002)(2906002)(4744005)(316002)(41300700001)(4326008)(66946007)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MXV1YUxEd1AyRmd1NjlDTThMY2g0bWtOeWVUR0ZXZU5XQ25tM1FvT1NXczZp?=
 =?utf-8?B?TjY1RHkwaUVzaWpaYmhBc2Z3bWVWRE8wSzRHMkNMajNhUlkwREpjanpXZjF6?=
 =?utf-8?B?YmFIRjIzSjFrQUlXcFlGTmU2YTBjdXpnUVhyZFFuTEljcjZNdDRDSkc1VE81?=
 =?utf-8?B?SU5jNkIzQmllZzdUdWtVS1ZoYnFqWkQ2TUxjYVJPZWNiVnp4ZzV2d010NnRW?=
 =?utf-8?B?YysxNk9wWDBDeGxVNjlkWHBzQjVmMUxiT2ltTVd0a1JnalBLVURTWkVnNFkz?=
 =?utf-8?B?SzU4R0FlZEY2S2NzdkRLckxsYWVhR3pWQ2pubHBXdWRadDZhVjJtb2NidFVy?=
 =?utf-8?B?SGZleXVQZlpCbmNoUWtIMGk1elBRRXVOUjEyNGQwWGhxaThTR0FJMk1GNkZj?=
 =?utf-8?B?ZEJKbVVvS1VEMEJJRHdoZnFkSUs4bTJmSHBUTHpLenlWRUtma3REaVhqRDE2?=
 =?utf-8?B?ajF4OU5LbDZ3MXc1QUd5VG1KOGcxODBmNTc1TWpTUzBrTGlrWjdvd09wMFNO?=
 =?utf-8?B?dkp5V2pIZ1QwOGZZY2MvcVFiUHFnUktSTnIzdE1FdmJteUhyL0dBcGorTXhT?=
 =?utf-8?B?ZG5TVWxqV3FoTGtJZW96azJLdlBUZVJmeUYvbGlucXQ5NDYwQjhpdjY2eUlm?=
 =?utf-8?B?WW9RS2dHTjJ4ZVhqaDlxOFBpTGQvcjRnVEEyVmpQV1NYRjg3Q1VGd21hTXRO?=
 =?utf-8?B?MHp4WGF0RUM3eHllbXExM0w0WTl0YzVwV1lOVHZIL3VmSTI4WmpNMXp3emlj?=
 =?utf-8?B?UjBxUWNiajUxSVJRWFhPWlhvV3VVY0s4eWFwQlpuZnc1N2RGeUhVZURkdWV0?=
 =?utf-8?B?Wk41elQzVElrMzhQRlA4RDByVnVLTlVwVk1ReEp0MlMrSUhXbjh2SnFWQk45?=
 =?utf-8?B?VDNJSHNoNFRCQWhleFF1eVJvc2FXNkxOSFUySy9oWWNzTG1weXR1T2VkcEFx?=
 =?utf-8?B?T3VSdldaUDFKaFFCSjBzYlUyZ011S0NxMGhHMjRDek9GUXhTQ1VMcVJCNnVC?=
 =?utf-8?B?WG0xc2FYUC82QVJiNlVZUEZOUnVMeW05OFhzNEpyQVNTbTZNa21LZVhPVllx?=
 =?utf-8?B?amdlREwzRVNyL2xPakNxNUlnU3QwQVZoVjgxSHhJNFIzU0dKNHpsMmpEODU0?=
 =?utf-8?B?dkdpaFhtTjBYSHFqTGlpcXRvdUs3Z25ZWnRiSXBYcGxmVFBFeUdWU21BN1ps?=
 =?utf-8?B?dGEzRndYeWozOU4wY2trVDA0OW5GNDR3Ly9wZzVlaVZBNDhUZFpkRFIzRnpu?=
 =?utf-8?B?UGRsMGsrRk5qOFliZnRlY2FXbzluYnhPUWJYT1hSQk85eVY2RjNjNkRiWmY2?=
 =?utf-8?B?bXNXWStUOUcvck1MaFhqcnFMSE52M1ZBYWtJWllHTGN5SFFIcE9SaHNsWTB2?=
 =?utf-8?B?dmxYK2lWSUg5cDU0TGJzM08vWlZPMUwyblJ6TU5zODMySVBlQ0ZqMloxK3FG?=
 =?utf-8?B?RzBvRC8yYTdsVXM4U3dUdFR0UzR4ZWNvQVNMakE5Y2djMVZQZWN2ODluTGJQ?=
 =?utf-8?B?Z1hZR1NkcE1JOGlhNy8rTmQ2WHI5ZmU2VHZvREgxYzVVcGJRR1dOaDVOSTBQ?=
 =?utf-8?B?aDVLUHJWbEJNQXFBOUNLYUlvU2E5Rzh6QWVhTVlmSWxrMlZXMGFVWFdOVmdm?=
 =?utf-8?B?cVdJY0tVekszWHNLRTJBbkw0alBsQ2hDOUU5QnhjbmQ5Z0Y1MTV5Z2dsTHFq?=
 =?utf-8?B?TGRNSXNiQWlYWEpBNTM4VzlPSFh0Q1g3TzloVWxVbEZ2eitSTXRUOHhJZmtE?=
 =?utf-8?B?U2FRRFlaRHk2dElqN0FkSWdVVjJkZUhWaFNpSEMweG9yTGVHT2JxbmE1Szla?=
 =?utf-8?B?RjMzRVdNcjlpNXRsTXZyeGIvMi95aTN5c2RRSnhWWmdLSkt0Tjk0bk04UVRS?=
 =?utf-8?B?aVdUMFplSC95SXNUTzRaT0JrYlNQMFRGT1dtWnljMUd2cncraXI2OERSbE00?=
 =?utf-8?B?L0dHME9ObFN5ZUZnRG53ZG93Wmg3b3pCYTB3L3VvYy9ML3hiMk1LdnVPcjVu?=
 =?utf-8?B?S3ZKTFZxbVk2a3oyVEVnZ0l3ZGEzU2Z5RWppRjVFczNRYkx4MFhscFpuM3pu?=
 =?utf-8?B?L1ZwV2RCdnRnbm1Wck1wNEtKVEp4Y2ZPd2ZyWklhWXpFMWNFQW9MZ0k5VS92?=
 =?utf-8?B?eStZdUc0QjllM1htN0NXd2g2UWFxeXNqdjJDRFNzaVk3eDVVKzVQNWdqekRM?=
 =?utf-8?B?OWc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c511f25f-f5f7-43d5-7fdb-08db676cd0b0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 15:35:25.9890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgEAyXXWAaWY6M9p2T4hA6f2yu6ckeJBwFh1vZV2PQDSsLXutP7QN/1hkEIjW69t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4456
X-Proofpoint-GUID: pssZgoUQIRZmSIPEg0kQK-DKvrsZwpZk
X-Proofpoint-ORIG-GUID: pssZgoUQIRZmSIPEg0kQK-DKvrsZwpZk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_07,2023-06-07_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/7/23 5:39 AM, Maxim Mikityanskiy wrote:
> From: Maxim Mikityanskiy <maxim@isovalent.com>
> 
> The previous commit fixed a verifier bypass by ensuring that ID is not
> preserved on narrowing spills. Add the test cases to check the
> problematic patterns.
> 
> Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>

Acked-by: Yonghong Song <yhs@fb.com>


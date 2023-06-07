Return-Path: <netdev+bounces-8658-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C50E472518E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:33:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68D5C28120F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7303E632;
	Wed,  7 Jun 2023 01:33:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F677C;
	Wed,  7 Jun 2023 01:33:08 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19C21984;
	Tue,  6 Jun 2023 18:33:04 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356IelG8032684;
	Tue, 6 Jun 2023 18:32:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=e2EPiJ1XjgBHXfouynQzOa8jk8cBACIVK5AjH7/z+cY=;
 b=i01kxM+iX+JheeEJXqYvYJ7d96x0xIGvG9eYdVsoSQ5MaQxlcB2SKpb52a4b9zNkOavU
 FCS/zalESDwDHFFkPEmkXcqZXOrhU09DzmXpIBB6pWq1eDGuXzJ2KHqBFvF5LTawqlKC
 5mq/x7nGIGYj4DhmLmfLgkVaQ3Des6RDqsykHtYCETe8LZnhfCljyhZ/t4swpay8tkhm
 z11jfRgsv+UlNSZFwayqPSlZ+m70JL/ZCQzl85hZbGjUsNkrwFPGk7/tRg2lQ0REBAw2
 CJjnp8/Y/AFZRSieLp1ZJysifRhGiNbiZNeNesFF6aUuFUhMXcpQ2ltC3UVAW07JVIHd nQ== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r2a72jmnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jun 2023 18:32:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcLgy6LjAokQxccxnVGcoT4zlAtxyA3P5H9b1IINFTqfOjBHDVOq1eUqU5cY0dq3AZedY06boE6gdqr1bwxP4J3YUmCQhdMXAN95PFcDHszWFSadj+BQLFFextj2oa44Dn53v/GxaNBwCTXVsGqYa7Z5bkylIqMIfUwVD4qW0tPg92DoyConyDeddpL/PRCiz647yO/iI0EsFpzeLBBgTYKDRztJlPFIKwvpDnAJyKKSan5K/+iMifpSvDdxI3AV31ZOoi+Hyd0sOLfTA/1igVvdMDtWpVF0GKrGw3rT+O7bQf6Wa3RK19+e8Sf/s9P7LzuKLzRVo4Z186h6Ij0e/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2EPiJ1XjgBHXfouynQzOa8jk8cBACIVK5AjH7/z+cY=;
 b=LzAMOMVo/Om6BH3Hc8npT4tTHQYaR2agfVl8Rj4Ipx3BKIG+dwqJ1KnSHZV1abEXWjN9KgLbwCM+MiAx222Z8lkuK8whSUQ4N3o6h8C4YlPgIispBZa5DYayjqeEyLGH2/mvwwH3VAJbOtJz8la+fmXfGM6B93g/C1chulXZbRjqu4PXPI/adPkNbTQszpL9ANWAdekuePMnoFw4YeMrftXdmRJTI4aC+ZXzadIr2aWsK8HQTUXDmjXd/uSEo25H7fTeiENnOObc1XYy0cyOPjOnBUqIvXIhmYbwoULt2CmFsMksmxu+GXZveUOFvkHfwgbH9UdLTGSnId3ivPTs3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4545.namprd15.prod.outlook.com (2603:10b6:806:198::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 01:32:41 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%6]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 01:32:41 +0000
Message-ID: <11eb089f-9e71-856f-7f01-375176bd5edf@meta.com>
Date: Tue, 6 Jun 2023 18:32:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH bpf v3 1/2] bpf: Fix verifier tracking scalars on spill
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
References: <20230606214246.403579-1-maxtram95@gmail.com>
 <20230606214246.403579-2-maxtram95@gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230606214246.403579-2-maxtram95@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:a03:254::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA1PR15MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: 4be64775-fff3-4278-3335-08db66f7159c
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	3zcGIccMaDU4jDAmZC26HwUuBLterHnyHA7r6Z/znN7YqmuKmtnCaUCzXZepm17CWTODdheO0zPzLUGIRvQYyYtPNHlkcNmQN6bUXiBQ/Zc7pKvTqZEEcFRt71R9SMOIIIhHkSWJbFRKVYDNJDfVCU8IDRgJTjj14flNlfoBv59K9lF9VfQJ8oyRbIehdyR3ac755bbgNNhQflu5MsxXtwYiKt3znzZQ2A33aAXFqllh5q+yMBJcjx41pKOtyDQvjWWX2cdeTVT0NZokdn9WuquP6nTkq88jwvNTirS8DW3o2ztmBS30nu0e6j7ABIVzBsHbsCo85nMDCLJn9pEXPA4V/YC36ZJHUgWR7P1v7WvHWpf14gJZOIhSciniYwdpyswRbRa+eaBrZUA/LKrWIxEtmWLGDETGCC/OtPLS+Zq8iAPodxAknvOL5x8zKLXMJuEMnjCPlPibTqQ/8/XIQlK4N59H+GKHQQeOGY6Q6ZspYORx6YjsYzM9rhdw+YEDQTCauzTdZecl1kgarAVzZhz7EjOkpz0RM+c5fGw556tcC/2EUInSKQfjwkMTNz7GM+6nXLw0GJaqdrUfk/YDKYY8k73Ggg4i54IVR0mwh2OEKHSwNNH0gQtNSd3dmb7hWU0S+YpT64EpGKsnEkiZVA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199021)(53546011)(6506007)(6512007)(2616005)(38100700002)(41300700001)(6666004)(83380400001)(6486002)(31686004)(186003)(478600001)(54906003)(4326008)(66556008)(316002)(66476007)(66946007)(7416002)(8676002)(5660300002)(8936002)(86362001)(2906002)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?S2l5RmRrclR2bEwweXBEeHdVRUhXZm9JSWF0QVovUjFHYU5yZklZTGcvSDJU?=
 =?utf-8?B?bFFCbThPSHN0eHQzOGl5c2tYU09pRFBhaEllWnJmKy9lQWRaUDNjY0JhNzBR?=
 =?utf-8?B?Y1p5bng4OFBVSC82VTdUMHJYSGsyUFhhRWN2SXR0Y2t1V0tETVozNVZ6Z2tT?=
 =?utf-8?B?cXlHNVoxcDVEcXZiWG5oQUdaSTYrNTJ2bzZFTWFxdFJCSFZEc3IxQnptQVdO?=
 =?utf-8?B?MTMrOXdqdmtIY1pOc1pqTi9NblFpMW11VklVRUcrMW5xay9lYUN0UVZ4WExr?=
 =?utf-8?B?Z0dNVDhJUDZVbWQ0SWJZaDRsRWhTM3c2cEIrUlNyQ1J6bUNIVCtsakxPZ1B6?=
 =?utf-8?B?emttV0hnSUI0N3FYeTVyNEw2ekwrY2Z3VjM4WnZlcTQwbWhKN1ZZRXNZeFpN?=
 =?utf-8?B?YTQ3ZmZoVkdqVUdhQVhBMEpIQVdERGRyWWR2cEZrVnU4cHNmTDJyZElNRTlL?=
 =?utf-8?B?YVVNMStEU2g0ZjI2YlpuNnVpRUcwb2F5a2xSRm9XS3huKzlqN3lPZHFoL0Nx?=
 =?utf-8?B?cTBFdGJiRnNHQzd4dFdXRVZHMS9wdWloa0dGaWpNNk5XeVNaeTh2TjllckdG?=
 =?utf-8?B?ZWZVMlJxbHNpQ2YveHdiaGd0VkgzR3J2VC9neDFYdUdFY2dlMVR4Z2wrdGFP?=
 =?utf-8?B?T3lYUkpKM1VBRHpmbTZZRU5kbWdCbldFaVdsTHJ2RWREMWw2YmVQR0lZWDIv?=
 =?utf-8?B?aWM0eG9DMkJucVMyS0k5N2dzNmcxOEhWZ3NFajl0eDFFWVoxTDRndmRiaXNN?=
 =?utf-8?B?RW9CWVdIOU1CcU1na2wyN0JpNlYwdVpwT3UyTDk0djRSWGpaOWljZXNOWVU2?=
 =?utf-8?B?b085Q1ZmaGoyM1NHSVptSTRHR2NlaFcrLzdTNERMb0FKS01vM2M5UGNsaUEv?=
 =?utf-8?B?SEZoQUl3T2FvN0x2MVh1aVB0YTZmbStMTGhIMTg3S1VBekxZSzFOOWhmQWs5?=
 =?utf-8?B?Mms2SnNxRWZXYWg2ZUMydElHS296cVY1a0E5YWVCaTk4SHV6dlYxdnV2citM?=
 =?utf-8?B?TVJ1TW5VamJnV3h2YVVxbFZ0ajRvaEY5aXVYZ3lCV042V3pFSko0b0dsTjR5?=
 =?utf-8?B?UkN6Slg5c2FzYVB3Y3Q0RVBjdXRHVTUxMXVLN3hxMnRLOGNPSWVkTzJtUjIz?=
 =?utf-8?B?SFBUcWNFZ2pjTXdUK2tPMlNrSTlpbVZSZ1A3eGV4VUJHVXFSanpkUlpobWRH?=
 =?utf-8?B?THlyV1lFOVhha2o3N0dvQ3FCa3ZBbERwSHlMSy90aFZsUE5DbzRLUXVVMXA4?=
 =?utf-8?B?R0s0QTkzc0FEWjh4NSs5VjhIdGQ2TnZzdE05aUZ4akRCVUdkaFRXc25qUkdi?=
 =?utf-8?B?OC9zMmxjdTFGVXZXNXljWTl6Z21oOUNsNVB1WUdhK2ZNdENva2c3cVhFUWNm?=
 =?utf-8?B?RU5yQ1AwcklHYnRmUE1RbFh3OHBDUjJJd1FTVTZaenhsMEkvVmZEQ1FBb2dv?=
 =?utf-8?B?UzI2a1RPNFk1NmMrQmdjOVE4N0RKL2U4UmRrZit1QXpEMTNoMUZ3dE93WjMr?=
 =?utf-8?B?WW1abndzQzBKRFpVaWtRT0szeXN4eWtXS083Ujg0dWMwNjk2ekEyaHZtZFB6?=
 =?utf-8?B?M1p4bjBXbWRiMkpOMS9BK0haV2RXdVR0R21IWStZV0t4QnJWVkpTVHozY3Jv?=
 =?utf-8?B?WE5xREhpRFFMbmpVdGFCTk5ZbkUwa0NXNFZlV3JmTEZLcjdvL3c5aG1UMGhv?=
 =?utf-8?B?UlFCa3BjcTVmZlhxeWZsaUtkbTNzejArNktaM1ZmUEQ5Sm9IaFFxc2NLQ0pO?=
 =?utf-8?B?UExDa0FRcE1oQ1dYRnZZREJyZXB6L1JFbWNLYW9vTVJMMVdHbnQyWkEvT0FZ?=
 =?utf-8?B?N1FoNCtQUGpuKzByK2JLaUNjYUpOcGlQcGhWK1hRSDFhZEJGTkc2bVNORmF0?=
 =?utf-8?B?SXcyekFCYVJ4LytZVzMrU2xBZXROZzZKeEsxME5oaERxeUdyckNDeG1JUVpH?=
 =?utf-8?B?TjFvTmp5Z3BNbXBYd2o2QklCM1lyZ3FuTExKb242dE55MjJ4c2Zsb1dPSkNH?=
 =?utf-8?B?Wk80b3RzWTZDNkg5SXZ4MmdjVFVuWXBONG5uZ3JGYXl2M0dsb3hOeHlJOWpB?=
 =?utf-8?B?YTdlTWJEWHE4bHdjRnRFLy93MFFXVlJvbzNLZmlDR0k5bk5NcEVIRmxQdzlT?=
 =?utf-8?B?V1YzZFkyOUVERHMrTGdWL2JZOEVxZXdOYUY2c1JWRndTU3BjQW96clcvczVs?=
 =?utf-8?B?SWc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be64775-fff3-4278-3335-08db66f7159c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 01:32:41.0165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4XVraXoOzGyS1pulTNCFT2eZF596pNIbkEpkYoIQgBYqWiTlJjh60AQO1uk0drY5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4545
X-Proofpoint-GUID: _dreRhtNCyrIcZA5pgE78x7lX1bAeMFU
X-Proofpoint-ORIG-GUID: _dreRhtNCyrIcZA5pgE78x7lX1bAeMFU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_18,2023-06-06_02,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/6/23 2:42 PM, Maxim Mikityanskiy wrote:
> From: Maxim Mikityanskiy <maxim@isovalent.com>
> 
> The following scenario describes a verifier bypass in privileged mode
> (CAP_BPF or CAP_SYS_ADMIN):
> 
> 1. Prepare a 32-bit rogue number.
> 2. Put the rogue number into the upper half of a 64-bit register, and
>     roll a random (unknown to the verifier) bit in the lower half. The
>     rest of the bits should be zero (although variations are possible).
> 3. Assign an ID to the register by MOVing it to another arbitrary
>     register.
> 4. Perform a 32-bit spill of the register, then perform a 32-bit fill to
>     another register. Due to a bug in the verifier, the ID will be
>     preserved, although the new register will contain only the lower 32
>     bits, i.e. all zeros except one random bit.
> 
> At this point there are two registers with different values but the same
> ID, which means the integrity of the verifier state has been corrupted.
> Next steps show the actual bypass:
> 
> 5. Compare the new 32-bit register with 0. In the branch where it's
>     equal to 0, the verifier will believe that the original 64-bit
>     register is also 0, because it has the same ID, but its actual value
>     still contains the rogue number in the upper half.
>     Some optimizations of the verifier prevent the actual bypass, so
>     extra care is needed: the comparison must be between two registers,
>     and both branches must be reachable (this is why one random bit is
>     needed). Both branches are still suitable for the bypass.
> 6. Right shift the original register by 32 bits to pop the rogue number.
> 7. Use the rogue number as an offset with any pointer. The verifier will
>     believe that the offset is 0, while in reality it's the given number.
> 
> The fix is similar to the 32-bit BPF_MOV handling in check_alu_op for
> SCALAR_VALUE. If the spill is narrowing the actual register value, don't
> keep the ID, make sure it's reset to 0.
> 
> Fixes: 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
> Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>

LGTM with a small nit below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/bpf/verifier.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 5871aa78d01a..7be23eced561 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3856,6 +3856,8 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
>   	mark_stack_slot_scratched(env, spi);
>   	if (reg && !(off % BPF_REG_SIZE) && register_is_bounded(reg) &&
>   	    !register_is_null(reg) && env->bpf_capable) {
> +		bool reg_value_fits;
> +
>   		if (dst_reg != BPF_REG_FP) {
>   			/* The backtracking logic can only recognize explicit
>   			 * stack slot address like [fp - 8]. Other spill of
> @@ -3867,7 +3869,12 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
>   			if (err)
>   				return err;
>   		}
> +
> +		reg_value_fits = fls64(reg->umax_value) <= BITS_PER_BYTE * size;
>   		save_register_state(state, spi, reg, size);
> +		/* Break the relation on a narrowing spill. */
> +		if (!reg_value_fits)
> +			state->stack[spi].spilled_ptr.id = 0;

I think the code can be simplied like below:

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4230,6 +4230,8 @@ static int check_stack_write_fixed_off(struct 
bpf_verifier_env *env,
                                 return err;
                 }
                 save_register_state(state, spi, reg, size);
+               if (fls64(reg->umax_value) > BITS_PER_BYTE * size)
+                       state->stack[spi].spilled_ptr.id = 0;
         } else if (!reg && !(off % BPF_REG_SIZE) && is_bpf_st_mem(insn) &&
                    insn->imm != 0 && env->bpf_capable) {
                 struct bpf_reg_state fake_reg = {};

>   	} else if (!reg && !(off % BPF_REG_SIZE) && is_bpf_st_mem(insn) &&
>   		   insn->imm != 0 && env->bpf_capable) {
>   		struct bpf_reg_state fake_reg = {};


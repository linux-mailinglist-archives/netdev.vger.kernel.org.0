Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E91C47B0FC
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 17:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbhLTQUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 11:20:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48364 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232820AbhLTQU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 11:20:29 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BK5L5hD030388;
        Mon, 20 Dec 2021 08:20:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EH/tZSdScYOPzlKfks/tE/KMjjavhyDbUO/75JgmmS4=;
 b=dXeIU6y8nPi1botZM9wkUGJCI2+WPiL4FjaB3UIozk7MjV1W0qYo3h+6A5OdsiclIXqI
 JndNGcH1CPExbFKcnnCGsAFuFsdIKFSIiZRnkafO39hWF50v42G5WMElFwNd1ALe4Y6J
 wncdBwZGicAOUcCRk4uyAUxjAe7MU/47Mms= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d2kkubt37-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 20 Dec 2021 08:20:09 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 08:20:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcSTPwzysvMHaJjn6oxGgnyvSxY/htImiZHahPD3/imYU6H7CMECXGjpfY+WP5FNEvVTgcCRQoPhLijqulU2kYdREZwQIMTmqm4rlPsXak3EXqZRJprHAR+4j8Ssk2zjbOs4my/u6rKpOymuty8BO0diEWVbrZWIPCBHmWaSgIOzDM7NfGga/i9gWJZWBP4HMXDx0r8JXpPlNK2lmbrM6SBdid3pIBja2Gh70f2P2FHOSn//soyIcFv3RsWuHA/tcAiie92WIeBZWEz9OOOCmPF2VgH51b3la/N16bC0+MP3uyMptPXW2BIhqAfGl4fIR94ya5w4u4dtl0NtcDlMbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EH/tZSdScYOPzlKfks/tE/KMjjavhyDbUO/75JgmmS4=;
 b=g/xkDH9ddT62Sp3mV9dSXFKTpykjUXBa4pX84j9t/CIZJJl9ih1rj+etkU7HPRitlQlZCN2z6f4r4N9fBFhBhvabvC2r06TgJvWbAYzl4RaqmYoQKw4MGzLsdBKKlI6V85mhuwa+CKrjqGSuImf0beRpWEw7Ou70y72bIk6NkY2Atngjp8Vl4CLxFaBxKzzdb5TWy5qdhPKdeCMnEF3/CMHitzKaicmXX2p1PN7324RJhhpI1zJTK00FFYeTpctnqg6K/UXBDYsg9Wvjo/ElwfagC2lb7BIiDk/Yg/TMs+T2/73jZabFu7QQb9cYmZMWfClt0BDJffKjZuZZ7pdowQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4919.namprd15.prod.outlook.com (2603:10b6:806:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Mon, 20 Dec
 2021 16:20:06 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26%5]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 16:20:06 +0000
Message-ID: <168b7dbd-777e-ac20-a49a-4a62a8ed872b@fb.com>
Date:   Mon, 20 Dec 2021 08:20:02 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH bpf-next] bpf: Use struct_size() helper
Content-Language: en-US
To:     Xiu Jianfeng <xiujianfeng@huawei.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211220113048.2859-1-xiujianfeng@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211220113048.2859-1-xiujianfeng@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MWHPR12CA0043.namprd12.prod.outlook.com
 (2603:10b6:301:2::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e7e8cc9-1fe7-42c3-9aa5-08d9c3d495b8
X-MS-TrafficTypeDiagnostic: SA1PR15MB4919:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4919F7244EBF52E537004D54D37B9@SA1PR15MB4919.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C3O+oj6ZLvjV1KBDCiXLBJ3sVrf3mySei67A/6W0UE/X+DBGINXxq+FIm0jbI0jSjwPA2Ki7vjQPHTNXJihcb7S5y+stU4W69Eqb11WKGJvVo764XE7XVovj93rSmEmWctABGsLWSnorK660x1Mk/ucS2ZoRupAlMJUDMe168WLO09d3qY4di8n+wjKtf10ogP/d9Dhf9qKIIMofudTyqn7EHpH8aovYAZfJM47RJcNfEyPf6DwMPIsR2EJ+9AEMO/c4H4GKMlujcivLluN5hEvje6Iby3UZOwSS5UATosxnA4lQTQ6ASzFyyLO9Gu4lvM4w+Sb6CEDYt4lj1NFB+0vd/rzG+dJa6Q9fsKa48YXT8vaBfFKO9HV9cTh9FlCEfQ4T9pZfHnnYBaKXFy63qX3+LFOZ8trL8TwKUuNL1vHtVemnZCKe3CebTQpjXC/M80CUUxuR2FGc+dfkaF3pYCTFFU32lt/tmmZvU29FqbW4tjeG8fYjvdtMDI47BMuDwi316HfQCG6ci0Me7zwFcvuFJbUKdUJdpHg5/nuOYoDTjVqU6fYDGm5a9oV44SyVqWn6ZmevxQyGQO/Oxi2WoFQn0ksI92WNDIPhSkxNLrhvZACygb9AnSTkka1yfUMMfzxBS8GajTa5rrv1IXlKIZWgbOb7QUb44YMDU/P9AAV8O/Lfc0TSYRgsDAWWexwHHBPl7vt8PrENZbeLhPLub4vX6rN6G7SDkBBEsmNAPDj1MV3wF42j7xbqApEQC9r8dj1Va7Y3bixCyd7MuDg35eORgMPNCAbh47Zcy7c3qN4w73xCzbh4N9+rFhmaJSae
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(6486002)(5660300002)(86362001)(66946007)(83380400001)(66556008)(6666004)(66476007)(52116002)(186003)(508600001)(8676002)(2616005)(36756003)(966005)(53546011)(6506007)(8936002)(316002)(38100700002)(6512007)(4326008)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bS8vaExiMEZpbzVZdXczNExIcklVQ0hmVk9jV3RJQjU2clNuL3BiWFpacmhL?=
 =?utf-8?B?K3JRcnNEdUI1TC96VkEyTi9valIrNUhWMjRsNTZ4WW4zL1d5bUFLd1VFMHVW?=
 =?utf-8?B?R2hFOWppMDJsUy8zL1Bubjl5U3BRZWUrTW9hTDBSakJDYUZkSE9GMmMvWU1C?=
 =?utf-8?B?eEhRd0JzcjI4UjFVUkRva2pZamRQbUtKZUJGTFNUNzNXVkg2c0YvRVFFdFVS?=
 =?utf-8?B?dDd2bUhJanpDcnliTjZMenVhK2djeUtpQm9YRVBIeUdYZzE4SXB6L3ZRTWZZ?=
 =?utf-8?B?Yk15Q2xocmt3T3A3cCtoaDNRYzNreWRHZ0tYREsxMTZjOGZzM2FrYkZIZ0ZI?=
 =?utf-8?B?RDdyZlB6Q2VpVmQ1a05ZeEZMNkhyM29NNDNwRXZpL21naWFUWFVMMml5bVRv?=
 =?utf-8?B?cnNGYjYvaWQxSXlmUHlBL2tQS1RrZy84NTh3clNrL2wwYXUxVkswVGI5akls?=
 =?utf-8?B?NUtyRk1ac01RUzRISjdvSWgvVlVHQzU4ZmVzSjhqdlVKRFhnMTM3Rkpjdisw?=
 =?utf-8?B?d3B5MGdsN3FkSGJydjBFTThoYVZmRVlEN29BS1VPSWhGY2NGVzYwRWNuWWlv?=
 =?utf-8?B?b051aHg5ZDhIYkgyaUFKMVJiR0g5Rk81SS9kMWZlN0R6OWhET2grUExYSHJx?=
 =?utf-8?B?QVUwazM4SzZKQTRubXUrNlhjRVJjbXNUS1FJTWFZN245NC80UE0rUFo3V285?=
 =?utf-8?B?NEZFaTM3dWVuYnJNdG1uM2J3M1JLSFR4blhONlVDbFFDWHFwbWo0UjB6OHJk?=
 =?utf-8?B?UUJVcC9rcFBTblZ2UnczOVRiM1pSK0FicFZUTVNDMFdUeElPZDh1SFVzR0xy?=
 =?utf-8?B?V0RLaG5SL3ZuL2RHVHlVVCtRSS82L2xLOWdWZTBDUm9jdVEzODVETll1SDFr?=
 =?utf-8?B?Qm9nNFlybE14di9oMzVsSjlyUHFJOUEwOHNWM3ZCQUtGY0tFTUp4R282WEoy?=
 =?utf-8?B?Y1c3N25uc2F6QllRZzNPQzdsNWxhYmRyL0tJckNyT1RNUUh0Vzh1R21zaWpr?=
 =?utf-8?B?MGx6RFZYNDBrQkRvRHJqczhQMm9IakcrUmFZV3E1aTVVaTlic2djSmtwaHBU?=
 =?utf-8?B?OS9zRy9OL3pGSTB4Q08xcDUwcVVSWVZnYnE3YTkyd1cweWg4RTJCaUx3V0NF?=
 =?utf-8?B?ckhKaElMRmpvd2x3YVBUYTAwZFZwQnFTOHkwak5KZjVlWWljNWhZb0RoMGZQ?=
 =?utf-8?B?c0tnSFJHWnNTSzBkSFZjckM3cnhQdHJQYk9EVmFaZ0hMWjJ5MVlab25WWEJn?=
 =?utf-8?B?RlB3Lzl3N3YxSlowSXNDM0Vod01kT0t1cXppM1RtQ1N2bkt2aUo4WHpOU3lQ?=
 =?utf-8?B?REIwK0IxYUJWcWM3bU5USWYzNmFZVVA0V0ZUYTVjVWRiSHlIK3drL0kzdVZo?=
 =?utf-8?B?aW8yd3MwY0cxWHBieklvMFF4Nm1nRTM5cmIrSlc2VHVkWk1JRWhHdDZYSEhj?=
 =?utf-8?B?L2E4b2hQOGhFNDA4Q2krUjczYkgyL2tCQllXRGt5aFQrTUc2MDAvNVpXbUx2?=
 =?utf-8?B?eGdWTXkvZGZZTW53R3BvOTFRNDU5SkNLT2RsS0Q3ZjR6VHZKYzJrcktySXdO?=
 =?utf-8?B?TVl4UHFiSzFEL1VlOVhhN2VaVlJXVWVGTGFxRTdQWHJtUTJ3MDVmRnBkNGJl?=
 =?utf-8?B?b3pUNGhXQ015YjcwbmVlMDJIYlVlbTIvUTVWVnJxWkZCd1B1VGRyNERBaE1a?=
 =?utf-8?B?aHJrS3NzZW9YRFR3M09TLy8xTUhzSjRYL3k2eUs0QW5MUFlqcGVta1hSM1ZL?=
 =?utf-8?B?SGtzS21iVm1BYklIV0NraFIwb0FiSExCdXk1bGJINjd1ZXYxNmhyeVBENkwv?=
 =?utf-8?B?Y2NiMG1GWFdpRjE5RUs0MVVUeUo2M2JKbktVZGJxOVVKcDJsYXdIa085Ulg3?=
 =?utf-8?B?WlRRU2svZXFSK2xFbWN5OE9JbC9rQTRwNHZMSGMwTGZPTlZiRUZlb3E1a01D?=
 =?utf-8?B?UzFsMFFjaVlBT2RpYTNXN1pSVS96U3JiTWd5L1B1TVg3WllwZ3RhYk1haVBY?=
 =?utf-8?B?VUx4czgvQ01KK2djd0ZaWUR5US9VNTZIUy9ORGVPK0JWR0E5aHd5U1NlNEhP?=
 =?utf-8?B?RmJCL0ozQmpCWWpaZHlxYTZpQ1ZvbGJBZzRaa2pRbnMxUlpVcVA4TGwwRXVW?=
 =?utf-8?Q?dkmSB+OL9uUMAUcMO6EA+GUYQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e7e8cc9-1fe7-42c3-9aa5-08d9c3d495b8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 16:20:06.3428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fhQtVXElQsW017FJGhWfGrgSLqQ60q01pdq2AKFZPtQNxwdxtzFJPOJL3/TKEQoF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4919
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: c65b9A2Sc55PTfLPITxqXG-MnNV8Ya5A
X-Proofpoint-GUID: c65b9A2Sc55PTfLPITxqXG-MnNV8Ya5A
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-20_08,2021-12-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=852 priorityscore=1501
 phishscore=0 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 clxscore=1011 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112200093
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/20/21 3:30 AM, Xiu Jianfeng wrote:
> In an effort to avoid open-coded arithmetic in the kernel, use the
> struct_size() helper instead of open-coded calculation.
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>

Ack with a minor comments below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/bpf/local_storage.c   | 3 +--
>   kernel/bpf/reuseport_array.c | 6 +-----
>   2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
> index 035e9e3a7132..23f7f9d08a62 100644
> --- a/kernel/bpf/local_storage.c
> +++ b/kernel/bpf/local_storage.c
> @@ -163,8 +163,7 @@ static int cgroup_storage_update_elem(struct bpf_map *map, void *key,
>   		return 0;
>   	}
>   
> -	new = bpf_map_kmalloc_node(map, sizeof(struct bpf_storage_buffer) +
> -				   map->value_size,
> +	new = bpf_map_kmalloc_node(map, struct_size(new, data, map->value_size),
>   				   __GFP_ZERO | GFP_ATOMIC | __GFP_NOWARN,
>   				   map->numa_node);
>   	if (!new)
> diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
> index 93a55391791a..556a769b5b80 100644
> --- a/kernel/bpf/reuseport_array.c
> +++ b/kernel/bpf/reuseport_array.c
> @@ -152,16 +152,12 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
>   {
>   	int numa_node = bpf_map_attr_numa_node(attr);
>   	struct reuseport_array *array;
> -	u64 array_size;
>   
>   	if (!bpf_capable())
>   		return ERR_PTR(-EPERM);
>   
> -	array_size = sizeof(*array);
> -	array_size += (u64)attr->max_entries * sizeof(struct sock *);

We have u64 type conversion here while struct_size used type 'size_t'. 
So we won't have problems for 64bit system. But for 32bit system, we may
have a slight different behavior here as the current code can return a
u64 value and the struct_size(...) returns a size_t type value with max 
value SIZE_MAX.

In __bpf_map_area_alloc() we have a check:
         if (size >= SIZE_MAX)
                 return NULL;
so we should be fine for 32bit system.

> -
>   	/* allocate all map elements and zero-initialize them */
> -	array = bpf_map_area_alloc(array_size, numa_node);
> +	array = bpf_map_area_alloc(struct_size(array, ptrs, attr->max_entries), numa_node);
>   	if (!array)
>   		return ERR_PTR(-ENOMEM);
>   

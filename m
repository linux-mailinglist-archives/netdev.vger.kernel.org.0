Return-Path: <netdev+bounces-6671-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4D2717647
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:39:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48F0B1C20D54
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 496D64A3C;
	Wed, 31 May 2023 05:38:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2632620F3;
	Wed, 31 May 2023 05:38:58 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E5311C;
	Tue, 30 May 2023 22:38:56 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34V3P3ur010975;
	Tue, 30 May 2023 22:38:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=qS54MR+dBHjyPTrpmKZyEyXn6cHxQFkqaI6Jz9U35cE=;
 b=dkg9CzWdZ13XUX4NX9yHhZsH9P9K3n03suiZFX4UoRQ/3sI37xHB3Dskr6DA19XWkPjM
 ZTicqrmV7pLEu9ruWlUmoEbNvSKevuiaZrPh05ZoPQPN+81rRoFhOZ3Y8WKe8eJfBfUK
 M69hZB3vmTO2bol2/moGmxG9OiZENdFwdgidfUDyzAbsBMKqu06eB1UsEEYw+I3ekZVx
 MhxqB3Pt4zMmqiDANlmxCkKLDzZdDO7FU8HqFtFYAgs44GZablYz//jw2Gc83pmxdVLs
 3uAROid+oo5+f2Kx37WA6SEC+wVRdzOGAEM0dnPt/ip/fp3Vu1QqLEOghwEloAZdSKtT /w== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qwfn0q79a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 22:38:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blEGUwqpamG3fWJvtQaW3CEPHiwjGNJ/R/8VtD/Ta7U3lXRjbKzdxlCFWnwKM8zRcu7YqIiImCwTo2G/SpHOhmq9fEN7ib2bG4zS1xW7cyWIBK+pC+LLN8Zyl7B/D9KnNvoc/98xCcdkps55YNAcMzccRLe0gZcw7OaRp9SCWRyFGUHzU43sRJ5SvFLtw8SrET7CHWf/p4tWW0/xTT+hqkjH20rxv3ZA7UbnXAV9qvvh5HFpSpobzBdPAPMh2fWFglsGW7ocOL6soGDCxLw41zR1EDrtcr4SmB0mS2cnqWU1q9B7LUOyXvEATBAZquq+y1oOIuqmo6aEH1oz3mjI5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qS54MR+dBHjyPTrpmKZyEyXn6cHxQFkqaI6Jz9U35cE=;
 b=gVtQ0VVurxnhmBcEuAiiyKrioT1RATs5cslFbHe3z35KAHD4IbRaQglfDhSPq4JQLtVj2U8zTiYhp/fxzdbElZ//o2F+FUoL34cblaCni5AUXgOoBUcrmBjc7MTeuCpQUbzjrCyDiCXtNO/1KK74QCdqaykvijtjsslbXnZ5FoCAGWi+OLRVcgp/6sfiFvvu/2+3XDqD2Q7yXxTMsjNuIJfF/i1hFgpcSqYOJGOvOeBq8sDiR9sC++mpqoYrszqY3beKeTdoJ4m8xgC2Czsiq1hsk1fImeKoJzFeLTsLwfB6LQv8yA7F27WYnrZ7q4s9dn6RwpNxqP/j/sl32ibvhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ2PR15MB5764.namprd15.prod.outlook.com (2603:10b6:a03:4d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 05:38:34 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%6]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 05:38:34 +0000
Message-ID: <40fc10d4-b68d-83c3-b659-e291031df5bd@meta.com>
Date: Tue, 30 May 2023 22:38:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH v2] kernel: bpf: syscall: fix a possible sleep-in-atomic
 bug in __bpf_prog_put()
Content-Language: en-US
To: Teng Qi <starmiku1207184332@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230530070610.600063-1-starmiku1207184332@gmail.com>
 <4f37f760-048b-9d54-14ae-d1f979898625@meta.com>
 <CALyQVaxuONP8WXSVGhT2ih12ae0FwE3C+A1s4O7LArTHERmAxg@mail.gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <CALyQVaxuONP8WXSVGhT2ih12ae0FwE3C+A1s4O7LArTHERmAxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0054.namprd07.prod.outlook.com
 (2603:10b6:a03:60::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SJ2PR15MB5764:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e8c91e9-4ba1-45c7-6c9a-08db61994636
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	W41NBTuKWTR0PZc2FwbGMWMZKy9loeU16Hp4K9LkSnVdJMuRjB9i9cQ8nZ/ZHIgvBLDcSviciCJTfmFTBiImEq8btjofjFneKacUxAXu4oMUIIZfMeEQ28WvCd5GlUGonMUPcHxVKZfknX48ynBi3Tiifvp/S5nEoIF9r6Pgm8ci1BBNmTsubwRZAAOyvbkeRvS/gMn8VJkw+12A4H6R88gXMvwY/NLLddG6Ic8ddcpDhE9zGhJU9g3neYzzmC5Vof2uL5NpaIfgE6jK9B8dDVNYGfJe77wb/o4Y9fTrWe1tG5k253W07MK6feAPuA4deqT2aHX30dphXMX0kpfW+B1lopDYiUQHs6uOVdjqVZ7Kyl68FVtu0ckCHsfrBvbDxPbXWWthLuETY+wYbahyrW+anVPuQNn2cyE6R6ogjqoQ4/XgN+H/JJ+kEsVgzqXmrsg7ShBRwEf0Qeaon3D/fC4CXxO+9BQChUb8Y+vvsGkuXH7tdkkVgukGYYR67Ly9B5KMJSoRYTKNWzxV/sxnN8PrrXVWMwvg/xv19/wA7d56jtIG4QJTtMCj6ovApZG9q9Oshn++39WvXyIzgXKVRxcddPzhH5qhGKDDrAoBltKGDN3RZM0Y5eeP+vOro0l7+H2H+5QKzfyn2dQNOzfUiQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199021)(6916009)(66556008)(66476007)(66946007)(86362001)(4326008)(478600001)(5660300002)(41300700001)(31686004)(6486002)(8676002)(8936002)(7416002)(31696002)(6512007)(6666004)(6506007)(316002)(53546011)(186003)(83380400001)(2906002)(2616005)(36756003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MVpMRDhxalJPS0NXazMzQzJ4My9ueERQeDI3cDZubmFHOW5SMVBoeDJ1NDlV?=
 =?utf-8?B?blZyV0w4OVYwbHE0WW5TQ3I3cVlpeUJlZG1NVWVWZUdCSTV3d2w2OVBQNng4?=
 =?utf-8?B?N2JjSjh5QW42bkg3aE5SV0xVSUhpa0xTK0RMMkhESU9ldnhRMEdrTm1IWmRh?=
 =?utf-8?B?Qzd4ZDBURWpnTHRDSWJvRDVkVEhCUWlnVmFEMFoyUUwzL3pEUHRkUTZWNHdB?=
 =?utf-8?B?T3BMSGpDQ21pZVdNVE40T25FVzRBSmF0eW1WM1IwcFV5NmZnZGlpMHpDREhU?=
 =?utf-8?B?QkFUMkVPeVhXeXFBQnl6MERhT1dzalpEclBrMm9EdnczaUxjQWhKWFJzcHBQ?=
 =?utf-8?B?UlRFcis1SXFuS0REZFYxSzFUalhVdllqZ1ZzbDdLZmtEZmFrSXE3MnlrRnpq?=
 =?utf-8?B?bDNHU1E0NGFNbW9BWkJkZXBiaFVFNXd3eTFibkpPbHZSYURuVW5FdURCODls?=
 =?utf-8?B?K0grVVQ4am5jSGgzN21YSGVDNm9aQW44WWNJVFZUZzMzRVFnRG9OeTNDVmx3?=
 =?utf-8?B?bzQ3VmRuSVN0TE9Ic29paFpmaGptZzk4YWF1cnh4aVBaOFFlVHFnYzY0dzRr?=
 =?utf-8?B?VVNJa291U1ZYRFIycXBoSDJXVmhnWjJpeEp6d1F0aTRoR09VWVNnOGZaMlJ3?=
 =?utf-8?B?M1d1Vmc3RUF6WTBzTW5HMTkzWkt0RnN2QXM2OUYxTXI2cGtua3NGT2dZck9X?=
 =?utf-8?B?R2E5UXY0RjlTdkJIc1JSNjhtZ0FQRnl6cjkyYzhNNHNCc21uQ0tFdE03Nzgx?=
 =?utf-8?B?a2N5Z1Rod2tnZ0lPcnY2Q1NGRkMvejhrYUpFUkpHeEo3WFcycXEzc1RRSXkx?=
 =?utf-8?B?TUdkcUJuM2E0QldacDR4YW9JWFgxZUtVbWdicWV4QUhNOWlFZEYvSWR3MXQ2?=
 =?utf-8?B?dUFGbEk5dUR2QXJxSGV2N3R1YlRmWFpVNHhFTjBnMk85djJkV2ZuY1FkbFVi?=
 =?utf-8?B?WmJ5Smk1ekR6NGxsRS9uekxaTCtkdk9wVHkySTRxcGdmSnFneGxhQWZzUUpO?=
 =?utf-8?B?OU1xUUZNU242dHAxZzFZUjhSc3FzQi8xdGFsZ1NvVXYxZGhhdG00bzI4alpU?=
 =?utf-8?B?d01vNDJvVGRzMEdxeExRRldRRDZORkM0SXk3elpKSXlmM21VSld6UzRLTkNh?=
 =?utf-8?B?WVZrSWREdnVUZUxpajFYdW5IbGVJSGlwWlRXNS9oNEdJWFMzaHJEd2MxZFVK?=
 =?utf-8?B?ZXovUGlTOEg5aHRBNUNkQS9ieUxINzFEaUd6ZFVjRUhZZy91dktPdnJhRjI0?=
 =?utf-8?B?S2lLaWhFSUFJUkorcHpUUlUxbGpVK3dHaTdYc2NJV2lOYzlLa3lUdjdNRCt1?=
 =?utf-8?B?aUMxS2VzTkhSdHhYMXZoOHlLNkV2ZTBVUHdqTFVxdEdKRkFwY3BGY0xIZWhF?=
 =?utf-8?B?a3VQM3RSOXVOQXRIM2dRSThod0RiWm9EVFk4OFlrM2VKSTVpb3VRcFgwRG9Z?=
 =?utf-8?B?NkNrVDdHTVVyU0VGcWwxdXpITUpqSEVjazhCUHZodkU1WjhyUm1LalFka054?=
 =?utf-8?B?NW9TelQ0aEUyTTZyaExaRC9BZXlZRVpkOGwrU3I0cEFRR3d2L1laN09sbGJl?=
 =?utf-8?B?L2tJVlpiR3ExcUh3ZmZCVHUveFdpNjFjTktKWU5McXhSaHNPWnBVaE5EQXFk?=
 =?utf-8?B?WTBGc1VoaFlqSERtYThXTmdnYmVLS2szT2puZ29XbTBMbmFNSXJvenFJbWhV?=
 =?utf-8?B?aFNvcUhpQXZidTFJLzVDODhnV3REVUtkcGlDRUhRbjhtMWJudkF3MkFwcndW?=
 =?utf-8?B?MXVuNG50R1l4ZDBLcS9aVS91VE0raTBxbHJHYU03R2N6ampIQmtjZy9ieXlQ?=
 =?utf-8?B?TW91bFZxT3lIRjZlWkZySi9SOWl4RFczZ3Y4a2JrZ2w2aC90ZHdkUWpBVmZU?=
 =?utf-8?B?eGpSeEFFLzBJVk9YUmxnZmZKbVhjSGNPRDAyQXUwNmZidVEvMmR2R21iS2I4?=
 =?utf-8?B?Z2cvNEVWV3hsUytxQS9CT3FlODlIMlZ6RW9OeW5UcFlpdjYyNEgxMTd1Qk1B?=
 =?utf-8?B?ZWkxMFU4dmdqSDRZZFgvMEN1TWh3TnZBNmQ5c2JGTlY1Mk82UnhwT0xVVjdD?=
 =?utf-8?B?NkEzODI1TXIrL09pU0FvWGlMRmFtVlJackpmZHpGeDdWYnlSbk9iTFNDdXNv?=
 =?utf-8?B?a1hOQVVYWGRnTCs3UmFxYjl1SnFOSlFLRC83RE5yc0RhSHFYMDdIQi9qY1hs?=
 =?utf-8?B?ZGc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e8c91e9-4ba1-45c7-6c9a-08db61994636
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 05:38:34.0795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epeCF34dzA/aNAjkmwSmmlDjnW/KfrXvSXnIhSqzM8KhMDQLkS7onF6PYvacXvT6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR15MB5764
X-Proofpoint-ORIG-GUID: qPhfV_vg7Dk9cIBM5WegSn6WFJrAgW1y
X-Proofpoint-GUID: qPhfV_vg7Dk9cIBM5WegSn6WFJrAgW1y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_02,2023-05-30_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/30/23 10:30 PM, Teng Qi wrote:
>> I would really like you to create a test case
>> to demonstrate with a rcu or spin-lock warnings based on existing code
>> base. With a test case, it would hard to see whether we need this
>> patch or not.
> 
> Ok, I will try to construct a test case.
> 
>> Please put 'Fixes' right before 'Signed-off-by' in the above.
> 
> Ok.
> 
>> Could we have cases where in software context we have irqs_disabled()?
> 
> What do you mean about software context?

sorry. i mean softirq context.

> 
> On Wed, May 31, 2023 at 1:46 AM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 5/30/23 12:06 AM, starmiku1207184332@gmail.com wrote:
>>> From: Teng Qi <starmiku1207184332@gmail.com>
>>>
>>> __bpf_prog_put() indirectly calls kvfree() through bpf_prog_put_deferred()
>>> which is unsafe under atomic context. The current
>>> condition ‘in_irq() || irqs_disabled()’ in __bpf_prog_put() to ensure safety
>>> does not cover cases involving the spin lock region and rcu read lock region.
>>> Since __bpf_prog_put() is called by various callers in kernel/, net/ and
>>> drivers/, and potentially more in future, it is necessary to handle those
>>> cases as well.
>>>
>>> Although we haven`t found a proper way to identify the rcu read lock region,
>>> we have noticed that vfree() calls vfree_atomic() with the
>>> condition 'in_interrupt()' to ensure safety.
>>
>> I would really like you to create a test case
>> to demonstrate with a rcu or spin-lock warnings based on existing code
>> base. With a test case, it would hard to see whether we need this
>> patch or not.
>>
>>>
>>> To make __bpf_prog_put() safe in practice, we propose calling
>>> bpf_prog_put_deferred() with the condition 'in_interrupt()' and
>>> using the work queue for any other context.
>>>
>>> We also added a comment to indicate that the safety of  __bpf_prog_put()
>>> relies implicitly on the implementation of vfree().
>>>
>>> Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
>>> ---
>>> v2:
>>> remove comments because of self explanatory of code.
>>>
>>> Fixes: d809e134be7a ("bpf: Prepare bpf_prog_put() to be called from irq context.")
>>
>> Please put 'Fixes' right before 'Signed-off-by' in the above.
>>
>>> ---
>>>    kernel/bpf/syscall.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>>> index 14f39c1e573e..96658e5874be 100644
>>> --- a/kernel/bpf/syscall.c
>>> +++ b/kernel/bpf/syscall.c
>>> @@ -2099,7 +2099,7 @@ static void __bpf_prog_put(struct bpf_prog *prog)
>>>        struct bpf_prog_aux *aux = prog->aux;
>>>
>>>        if (atomic64_dec_and_test(&aux->refcnt)) {
>>> -             if (in_irq() || irqs_disabled()) {
>>> +             if (!in_interrupt()) {
>>
>> Could we have cases where in software context we have irqs_disabled()?
>>
>>>                        INIT_WORK(&aux->work, bpf_prog_put_deferred);
>>>                        schedule_work(&aux->work);
>>>                } else {


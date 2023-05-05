Return-Path: <netdev+bounces-613-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 543EE6F88E0
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:47:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DEA32810BF
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 18:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C8EC8C5;
	Fri,  5 May 2023 18:47:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB9DBE62;
	Fri,  5 May 2023 18:47:17 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4A1203E0;
	Fri,  5 May 2023 11:47:14 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 345FPZvM031290;
	Fri, 5 May 2023 11:46:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=/o7cToMRRMI5NBtSdDxyU+f3+bHXmIuyysgWD/DyY0U=;
 b=Ms2kfr1xGtiWoIzcq0yoqJBQ5x28MazlYx6xVyvTloUsvWFWN4z2fDjokbkugrKIaaTb
 qJ8GMMKX8e0bYTXd+U7CxXstQu7RzLDZOhGyx0iiLYOaEqMHuJWTebojD3uju1a4yd2i
 JNVTBJDEn683/9uneWKKzng+evdOh4GWT4H54pHT4hwNMgegeKYlkpiuis0MJzlFq9Fq
 5YivvifMjroTCTGk96fCeiSit+oRaJPae0OT3DQ1sTtxbc5MdO9fPrN3k/f0Uq7Isl/B
 DzQw0DLE3B54dXGGAEwsND9UM8maTvq08WWBwqv93JDpuqFyL0Ud6dUIVKn/qzcEtDUC 7w== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qd4e1sd5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 May 2023 11:46:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkV3VQyzEvMrSljKWBJiSOhIeUmroYh1p3Mm5nsP1h3eSd0kSCI3vAd7G9fKvwNvnDhOnhYi4Cg3C7mJpt3CeUc+a8Tq+4mCm7053mWqg4Xlh2nAJ2mv+VL4eTPEAOq9vIpm1LWdssgC7rIRZSTIK1tkVPipu+0v0LtZx0veGC4/DVfRr9aOFruGqYqn1dWTqpGxB7V3TDsJGaLTM64aVE3h5dQiEXYNqoEUAreevs2KSBLTWFZ83wgpxhmZWbvM9jBEvlmKWouJXlONZIpL+h4xVUetC2ERrNfbUL5sijltoaag39Rbc8nmlidH5UUrfHXX0wHZU4KfK2Cih2XzWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/o7cToMRRMI5NBtSdDxyU+f3+bHXmIuyysgWD/DyY0U=;
 b=af9F5W74PNCj0NtX5bCoOlb8O+c41qfzaErW+RBoF8MojgWQYtk4NR3NzKxqUj7MHMQ172l+nTzUBbv3kREY/d2TBmaEbxxVQISco9kFWsHvW6Gvq41/PNWCCgK72qJs21lEGhIVj2FRUDeuLAPsKr29qMpFLgdxQDk4gzta1+I1dEc6W15eKFHwB3y5TRFEtFXhSTzeIGwT6nV6sr6c54kkSBX0BitTO4VOSwH1kVlEK+sN1LGqGDZggFgjEJt+PxIfcZYUXyl405csm7G4ViV52mhUUylngnGpf6PwTsPbTq+5nGtpydCxEjYZNnpq8jg6EzOdRKgtHzKFt+XtDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by IA1PR15MB6339.namprd15.prod.outlook.com (2603:10b6:208:444::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 18:46:38 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 18:46:38 +0000
Message-ID: <d5de53ef-3303-29c0-a4ae-4bede3ef315a@meta.com>
Date: Fri, 5 May 2023 11:46:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH bpf-next v6 2/2] selftests/bpf: Add testcase for
 bpf_task_under_cgroup
Content-Language: en-US
To: Feng Zhou <zhoufeng.zf@bytedance.com>, Hao Luo <haoluo@google.com>
Cc: martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com, shuah@kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        yangzhenze@bytedance.com, wangdongdong.6@bytedance.com
References: <20230505060818.60037-1-zhoufeng.zf@bytedance.com>
 <20230505060818.60037-3-zhoufeng.zf@bytedance.com>
 <CA+khW7hZb6EJcoXUzkvrHKztsQ_J4cN+RRQjF-a73A8zE8S_NA@mail.gmail.com>
 <194f1ac1-6bb0-e3fc-5394-ad5cb95721d0@bytedance.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <194f1ac1-6bb0-e3fc-5394-ad5cb95721d0@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|IA1PR15MB6339:EE_
X-MS-Office365-Filtering-Correlation-Id: 38e5f31f-157d-49fc-e092-08db4d990eda
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	N9sRDQ32pnoNeYdWkhVm/FruIqPW9be9TsHvt+hJPDQ6ZZtrU4nW6//esPcuK1UZzwunL+MYDMguNj53/RXeSYJ1rzIqvWrhDra7/lk+6voDz73sV/ZqCkfHObtyBqVbdecR0YWQNjZJDsoJ5sZOkSLAf0rroSQuwLVDsE9u57LZQ1hZocPD4ob/PJeN7axaLHu/rFWBZP5To34GLH2tAoS/zIUhQf+2HwKsdLR4foTa49FbDDrQxycRCd5Mbug884lSkjo6DUJugdfqjpGd2IAlx4jAJHRbc8RyI/geBL3EognRE1jEL145vloZ2m31JjA1AA5nx2qT0odp/+JuIjY0Qo2ykWX1Z0jAOqSgJxsouaAq61KZXh2cz8Vl9Mpyf25q9B21H4acAhXtITVTVpEyXkOg4Tas2pp6CPYON6C5VexnO22RDi9TsuAMKYCDA0VidhWIGf8S+M92ua9goM0oWk0SDPAlNo0LbKozSZZCuI1846TAvc3QtucX1yahLNIEZxDdrtVzqLHppUaqgoGv3T8PnbexjzTUwu40Tdau9mWqd2UFSuwIHhJRM8nNMm4gN/aYyjq5/PaI48fGD10m9ZCI7K7RYQ+/vbQcpggpFnIrEah+6xe1rxmRx0CtSv56i33nEFNmI1ovOu+Zyw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199021)(36756003)(6666004)(31696002)(86362001)(478600001)(110136005)(316002)(66946007)(66556008)(66476007)(4326008)(6486002)(7416002)(8676002)(8936002)(5660300002)(2906002)(41300700001)(186003)(38100700002)(2616005)(6506007)(53546011)(6512007)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dUNURW5wWUFuaHRmOCtnQU8xcVJBZ293NTlWUnR4ajlVZ3Q1NXNRTmc2VERW?=
 =?utf-8?B?OHR6YUNJNWJaQVkyelU4Z0ZVdkl4ZnIvM29lTVR0eUNZeCtlYjJLUmtKcmhS?=
 =?utf-8?B?REgrNW14ZHU3T1d1Ry9DWmlEZFI3VjFYdEdaZWJpNUtBeEYzMHZ1OXQ3YlU1?=
 =?utf-8?B?bzZjMFBLcUNTdkFIZFJJR1dDN25CcUJ1SUFaTUlGcWZDOXE2cmVOV3FFVk9L?=
 =?utf-8?B?d2gxM3J0bitpYU1pakhORGIxRTV5am4yM1dGYmtmRkgvcEQrUk9oR2xPSGg3?=
 =?utf-8?B?Vi9zalJ3OWEvOHZSOGNqRVBscU44WXNYM1F4THhyakxFR2lLMkpVNHpRcDBX?=
 =?utf-8?B?SlJFYkk4M3ppekFya0ZESUFMUW9xaE41OXZVeEhscVhGekVaWmFLZStHd0Uv?=
 =?utf-8?B?QUxSbXo3WmhvWkRySlIvMStvOVFjeCtSOS9vWm8va2RmaUlzSjVNamV5WTJR?=
 =?utf-8?B?WXNhSG9rZVpYVUI5MDhXWHF4QVByOU5DaGk4eHpPSmMvN0ZjMkJqZyt5Qngr?=
 =?utf-8?B?VThtQm5IWVdQR1AyRnVIM1p6SDZvYktqeVJuQmg3MThvY1lIUWd0NkFoV05h?=
 =?utf-8?B?M3plMGRtM2Rwbm9wOEdkcTc4MExZQUFsR2k5ZWQ4dmVDRDJUQVZ1T1NZS2t0?=
 =?utf-8?B?dElWUkFjNTlucUZtQnRxZU56dGpQblM4VDRpQUdJQzd4bEpFS2h0bktkcU9Z?=
 =?utf-8?B?SXBaUXFHaWNqSGZmemZ2YTN6M3o3QXBhQzBNdGN6VGtYWmxHU3ZwS0Npcld2?=
 =?utf-8?B?RjF3ZWF6OTBjZmVnWHJOenBSanUvdkdQeDBhSzN4SHdUUmZZMVI0bVRNb3hz?=
 =?utf-8?B?a3JLN09BU1grK1VtUHMvcFpRR2V4S2xwbnNsNktoKzZON0Rma1BHOVIyem83?=
 =?utf-8?B?bTZXUHNPeHdQZWtKVXhvOStNVG5LR283QXlIMGJQZk1GblNxZVdjMUpJNXdq?=
 =?utf-8?B?eWhZMkc3dXZZQUNpeGRRdkV1KzlqdGVuYjNqSkNkaWNtUjArM3d1Vy9yQVE5?=
 =?utf-8?B?bjBIWVFScW9wTjEvc3diSFVKSXJ5alpHaHRXSFltckIwRjl0LzR5U2NwOFo3?=
 =?utf-8?B?N2tFaU8vNm5kU3pLMmNBa053dHRDYVRmTy9jbElPT01Ya2ZQaTBkc1R3L0Yy?=
 =?utf-8?B?QjZteHN5cUlvaFpMbVFLNDdIdlg0RjhVT21xb0RzWUQ2UXlWOWltRGl4Lzkr?=
 =?utf-8?B?bzJnYXdrUzR5OUdrWi80VS9aem1HNDhsWVhZZTZFL2oyT3YwbDBWTmJlZDZv?=
 =?utf-8?B?M0ZiNnpBYk1QbXdmTWRTNWN3VmxwZ0NCa05mWDVGc2NsRUZZbDYwdVhvNmVs?=
 =?utf-8?B?ZE9vUG1va1pTaXhFQm9IeUFiNWVoTEx4TllrMzJwMk5Jejc1bTBXR3YyTzVo?=
 =?utf-8?B?aE5jZFNydDNqK05jV3VsNzUzYkttOUQwUTAvVXhZQWJEbUNVL0t5NnlLY2N1?=
 =?utf-8?B?S2xTNDVQWTRLalZxZHVHQzRyTmx1RzU0ZkZTa0NGTVFxWDVjUmpFOEthdk9w?=
 =?utf-8?B?TXFDNDhkNFc1TE9NS042VUwvZ0RLQy83NEdJakYxMUNmRzN6Y0w4SEw4enZD?=
 =?utf-8?B?akhybEsvMDF0SnVETHZZY05nNFhRY2xneUlmb1RQYTRMUFhpM0FmZ0VXUnFB?=
 =?utf-8?B?SUp5UXpxN2hyUEpJTXZ2QTFuby9jMTFCYnZPS1FHN3NHaXdyVWdNMEFUcFJP?=
 =?utf-8?B?eE92S3Fyc292M3F5djZMcGhhY0JYVEYwcVFCVzNpc3JvUHpQWXZGc2NLQlE1?=
 =?utf-8?B?ZXFCL2M1c08wZk9aaDhmL1lDWWV4VGk2SjhtckVEbEJwdGJHc3p1bHMveVo5?=
 =?utf-8?B?aFRYZCtQd2pqNkhRTDlyc3c0K0g5dTM4MDI1VFh4MnZNNWdrbisxYlZka2Yv?=
 =?utf-8?B?d2N5d001RFF2enZVK2d0RWhua3ovb3phS3pPdlF4ekY1RC9ZM0JqTS9LWUQy?=
 =?utf-8?B?TzhlREN3Zi94aGRSdExVOUhDaW9tQUI4VnBRTWZXQkVlWFhhbzF5Z2NhdW9n?=
 =?utf-8?B?UTZmb3kzemxCeUJaRGVPckUyNlNMbFRRenZxM1REMWZ1T1R4VXdPMXJyV3RW?=
 =?utf-8?B?SVRIVlFIa29Ia0wyN3R2WHFsRHFVVnZkeFNDd2VSdTliVnRDbVBMWTFWeWYy?=
 =?utf-8?B?OWt5QzdUbDUvbURhNVdOcTA2Mk1NY0hxaUN1eVNjU0dTbzR0QW1yVnZtVWhq?=
 =?utf-8?B?b3c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e5f31f-157d-49fc-e092-08db4d990eda
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 18:46:37.9841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 98ytFXq9vwQuZ2E83DFsoVmfgJfCB5bKAbNuhJUdYaIIbI/zx9Zoe10O8kwUGn01
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB6339
X-Proofpoint-GUID: nizAYi9s0j80rRR0mxq-aefHgJwgOnUk
X-Proofpoint-ORIG-GUID: nizAYi9s0j80rRR0mxq-aefHgJwgOnUk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-05_25,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/5/23 12:24 AM, Feng Zhou wrote:
> 在 2023/5/5 15:13, Hao Luo 写道:
>> On Thu, May 4, 2023 at 11:08 PM Feng zhou <zhoufeng.zf@bytedance.com> 
>> wrote:
>>>
>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>
>>> test_progs:
>>> Tests new kfunc bpf_task_under_cgroup().
>>>
>>> The bpf program saves the new task's pid within a given cgroup to
>>> the remote_pid, which is convenient for the user-mode program to
>>> verify the test correctness.
>>>
>>> The user-mode program creates its own mount namespace, and mounts the
>>> cgroupsv2 hierarchy in there, call the fork syscall, then check if
>>> remote_pid and local_pid are unequal.
>>>
>>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>>> Acked-by: Yonghong Song <yhs@fb.com>
>>> ---
>>
>> Hi Feng,
>>
>> I have a comment about the methodology of the test, but the patch
>> looks ok to me. Why do we have to test via a tracing program? I think
>> what we need is just a task and a cgroup. Since we have the kfunc
>> bpf_task_from_pid() and bpf_cgroup_from_id(), we can write a syscall
>> program which takes a pid and a cgroup id as input and get the task
>> and cgroup objects directly in the program.
>>
>> I like testing via a syscall program because it doesn't depend on the
>> newtask tracepoint and it should be simpler. But I'm ok with the
>> current version of the patch, just have some thoughts.
>>
>> Hao
> 
> Yes, your method is also very good. The reason why I did this is because 
> of Song's suggestion before, hope that the parameter of the hook point 
> will have a task, so I chose this to test.

The motivation of this patch is:
   Trace sched related functions, such as enqueue_task_fair, it is 
necessary to
   specify a task instead of the current task which within a given cgroup.

So I think it is okay to have a test related to sched.


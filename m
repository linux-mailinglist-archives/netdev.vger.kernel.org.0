Return-Path: <netdev+bounces-611-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9386F88CC
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:44:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F8FD1C21949
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 18:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B4FC8CF;
	Fri,  5 May 2023 18:44:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370ADC140;
	Fri,  5 May 2023 18:44:34 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519FE1F496;
	Fri,  5 May 2023 11:44:30 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 345A5C53024406;
	Fri, 5 May 2023 11:43:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=EI00Bmw9fThIZBOdPvWOn7nlljNNWoHeO6RsGXz2JGY=;
 b=Hgyz3DSiOk7Hc0itZtQbDHhGW2znt79TuHcnARxZjL0OCwvUU0GEplnaRdYLtHo+ZI/o
 QJWrtvV/pvGDmJx6TUuakWSfjTHBscA6ZhVFyPGkGFAjGpUkM+u6svwNFr9QMrsUjJjE
 /fnfqD/24ZFDwWHH3fGT/kBsNCDjP74aBViCdLovnN2nKLUEEYYY/tW0Gku63icqXldY
 lzJGHpGph4EMCR/FSkOdQYMmqo2etNQ7l0qyC7r6YzaGjx+vLMKLBJBi2bIV4pzCjv5/
 RDa1PcKtOUachYtRATun3PcSJPznrbJcgckoiavRbHRb6WMvddrfr8/il+rgYla6THl0 sA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qce9tj54y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 May 2023 11:43:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPB2BVVmN3ETLSAJw6BCZSvcQMEYXvDx9LsJkQry1ynj3RVbNp4RG7Yj2r7wiCBrSbwIFETQ9zWVvrquMxJvG8orfRUauqEk4lBChBMWg20eK02C6DMeYOKeJg8MSD/JOvUdbmPoD+WT0IcmST0PtMvTr2JE9FaHIZi4gsIr8gFUkzS1Dzuyv92G2aBDigc8YCe7qk60NaF4Xm0dtSZX5fVlMXvifRuRp095e7Ocq6PFPfc9qlJrL7//hE8xFni260OvELTVgu3QN35cC1MzfRmS4ulaG0Blp5KxwUe1PwSQ3XIR3T5hULGhBX4dxzwsSbAQF9E2vKH96MnHZEd4Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EI00Bmw9fThIZBOdPvWOn7nlljNNWoHeO6RsGXz2JGY=;
 b=Dj2sj4HJZq3NH9W51ONpBZYBsVFXD9/amZ8qidTsHKb8u3vmzFt+TOGNVMJbFeTliJmQzc4ZNZpD6wYYjkabmnW7GJJXsA0zNA4RRhz794iyi8oEP+xs8ETI5P4Zzv4t4T6yKwt757W5pafli9nJEBJzDCBgc2fp8h/Tv0784I5IMtudCYLlUrUcKc5OOfnECiRME7fAGTPmLfIPZoETSFdWGVNKVj8yskHS+qGMt/+K66waFUlUBJx80oe7KgzYPGvlVQKqx94mlzgmMJcORPPhAMSZ6Nno/gqAFZxzV3ahy0yJjkli/CQvm8t1W7VI9fYIt4Y+LLXMU7GgUSG3Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by IA1PR15MB6247.namprd15.prod.outlook.com (2603:10b6:208:450::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 18:43:52 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 18:43:52 +0000
Message-ID: <b592dba0-685b-942f-3e0a-88f656733eae@meta.com>
Date: Fri, 5 May 2023 11:43:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH bpf-next v6 1/2] bpf: Add bpf_task_under_cgroup() kfunc
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
 <20230505060818.60037-2-zhoufeng.zf@bytedance.com>
 <CA+khW7g_gq1N=cNHC-5WG2nZ8a-wHSpwg_fc5=dQpkweGvROqA@mail.gmail.com>
 <f7a85b88-aa8c-a26a-8ccb-a20c62a76faa@bytedance.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <f7a85b88-aa8c-a26a-8ccb-a20c62a76faa@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:40::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|IA1PR15MB6247:EE_
X-MS-Office365-Filtering-Correlation-Id: 8829ae9d-6975-4e3f-4eb4-08db4d98ac4a
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	eLd9YLyqx+mcSa1fMcmnwg5PYdF35xSmyePed/4a9LMAWpjHAZM0u/N+/jO+jhODEeX0S+VJxlQr4igS8D/75IVIAdQfbNGuiZKzZu94/8ftBIGOKfyjOLYWE/oZA8u2TBYKFwhETwxu3hKa9u+NxiUo0w5vCK5OskWFmjN1ZQTbW/k5IuE982PjzQEy/6NyAdE6EL3W+IqKK8Iny4GUjMlPkC+Kzxb+Bfr3PtDtXOxtxLoD3+YNDQy8W+DoF0t8hCq+oY6ssNfBjoh1sPJ4vFs+W4JhkkgG3vFN16TkfoZlvKRxKZQ7FNpHSzeyoSoMk22wCWMQaD5n2t1Gg6r8AegLNMD4R1IUK61TKB1KbWvYNRFQ0XvPAPudyQWHafxGnnySi8dB7vEY/F87BIGrk2Z/V0NiixmNB6Na2Qm74Peq5/MyDLNJLWOU8BWg+djtwPVLluTAwTv+joRqZwcNuMPVUyzST8DIi7qj15sLcu08xO3WNO8dkVjkIuqL7j396mmfwHov/kVc/cN2QAlqN8ygU3oI8Pyl/3GNx9oBW3B1L5QfD1x32nOaehLBQRYEgspnXnC8VFqapqO1krw3Og5wuVUdbWS7Q8vAKCTJTdr2u48OZf4HttoQ7ea7+KVPpCO/sic5MpNtTiY1GblT9w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199021)(31686004)(66946007)(4326008)(66476007)(66556008)(6486002)(478600001)(316002)(110136005)(36756003)(6666004)(31696002)(86362001)(83380400001)(53546011)(6512007)(6506007)(2616005)(41300700001)(8936002)(5660300002)(8676002)(7416002)(2906002)(38100700002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aUJaOWV2RGxEcG82c0R0WnJ3SityVmFDWUt3WVJMN21xdEpwa0Fnc2NBSUZ4?=
 =?utf-8?B?UEdLcVh6SjZtcEw5SVZ4LzhoeTR6UGpaanRWQ0hLU0MwSUllV09WZ25FNW5J?=
 =?utf-8?B?RUZmYWhweFlpclE5Ly8raHRyZWZnWlJQVU1RRUhEVXUrSE1ia2xoSUZsZmIw?=
 =?utf-8?B?ZTNYbTJPZkRPcVMwZUgwMytMdUZ2VzZpN3hXN25ESDFBTmdTenZWTFVjNGVN?=
 =?utf-8?B?NDFMbVRPUWJKdXExT3BUYTlwelZTckpncmx2WHhpUVNrc1BvNE50VmpnbExO?=
 =?utf-8?B?MFRLL2R0WENuYkp2QWhQOVJBSVZsNCtWYVJFWVhKMCtmdE5XWWJ4QlNTbW5F?=
 =?utf-8?B?bmptdDNsQU9WL0ZBVmh0YU9Dd3IwV2orOEhoL1B4OVowMFpzS2FQVW0wK3c2?=
 =?utf-8?B?T3pOa0o5ZXRXRG5DNDJ4SFY4NElDSkMvd3k2emRHekJWK2VZWlphcWg4TlFq?=
 =?utf-8?B?MVN3MjBGdjY0SDRwK2dkVnBwd0lUR1ZUQnU0QnpwcTdCOE1VdUlGOWdpbmVR?=
 =?utf-8?B?ak5NN2JNZlk3K1pTNVd5VTlGNlhzRmhYNG1ZZGR5Q0JxNjl1eUxFRTNpOTU4?=
 =?utf-8?B?T0wwQThvcnM1T3FQWG5ZQTJkYmFUNll1am5kTzcycXpzYWdINExHR0pwUmo1?=
 =?utf-8?B?K2UvYkhid0JxM1c3OU9qVjZmNUxXRVRmeFc5emw3d0REanRKLzYwK2xOa3Fp?=
 =?utf-8?B?a2RYR1RTUVRIeU1WYURCR21xU29IblhhM0hVUW5Qd2k5V0o0T0p6QlQ5VVRS?=
 =?utf-8?B?aWpEUjNxUDZPVGRBYk1SSmU5SS9weFh4WVNoUjhXSjBPR1FKT1krVGcyRVh4?=
 =?utf-8?B?N0d3OW5OTWRpdWs2aUZqQnJJa1FxOWJueHhWTUF6WWtHVXhxRm5MYWJHWS9a?=
 =?utf-8?B?TkR4UXJsVEVFWHZpTHE4WmtNM3JuazRoU1Z6TllZTFlkMkQva3YreitFaGpP?=
 =?utf-8?B?MVR4UkRCUDdYeFFmVzJlNGsxMG9mQ2d5bmQ1bE0yRXlVUXVva0J3YVhQMU56?=
 =?utf-8?B?eW5hVTRMeXl4NnBHTVVkcytYdkVTRkFpeitKeE5YNHU1UDJXUDljTjJEVCtN?=
 =?utf-8?B?ZXBEeEFnMnJPN2R0WUlXT2pYS2dCSXBLdVFKWDVzaGlBeFFGS1FnOFk2c3U4?=
 =?utf-8?B?b1RUNE1lSnArRmFpWXg2RGhZMWVIREc5dDJrVTlTc2E4UEtmclA2UmZUTFlN?=
 =?utf-8?B?Z1RCZDZPT1ZrZzYvSUFBZzNQKzEvWTV3UmhtRVJaKzV2Z2FtQUsvMzE1WDVo?=
 =?utf-8?B?aWRGa2JqNjkyK1d6dGF1L2NVaGFNRFNxclFYWTdNeUFaR0pYNllUN0h6Y09w?=
 =?utf-8?B?ZEUraU1JTVN1TnBSOTNONjgzM2FydHJvQkV5UlEzTVgvdGtVQUxWYW82SjM5?=
 =?utf-8?B?UEdGQld6QmkwczJwT3JFTkRkbEFVbXVHdTNNajFZakV4WDNzb0hZS0Jmbm9h?=
 =?utf-8?B?bFdYVmlDNm1YUDNxNTBRaFc3eXNRaHFObWp1UnFsRzRCaG5oTFJPdnNXWFVp?=
 =?utf-8?B?TzNxaFNTelRXN0VXZjdaeUh1elNqYVlWMVRKT2pObytEcm9EbWZYVlc1T3Z3?=
 =?utf-8?B?RklqNitXdTNJV0JhenlEbDBNdkxYcXhIcXpTOE05YWtlaU5HOExSUlRrK2FZ?=
 =?utf-8?B?ZVRHQWpsMFpFalNxeTZLN2toQnF3YzhCQjlCMnY2enRWaUNYTUNZZGROa2I0?=
 =?utf-8?B?RzZ3Q0ZIcEtsbVJsYXovUGs2SjY3Zk40UVlSYUxNMkY4aTdzajZYOE1DNWk3?=
 =?utf-8?B?QW15NHQ4UlVuajNHa1dTWWxwSmFWUno5dU9KZEMxdExVUHBIYjF0YlRrdk5l?=
 =?utf-8?B?YU1hMlNlNlFKTlM4aStaaTNMeTg5Y2hIY2NncWsxR1d0WmNrdGRMY3lFd3Vt?=
 =?utf-8?B?RnFLMXNnN3N2OE45dVc3RURiR2VJU1VEa2hwbEVtREY5OGpPS3ZRNDJtRWRm?=
 =?utf-8?B?RkdzVDljeGhHdUlKY1BnaHZyWkpLRFNBbjVyQkRXN0JvZHZZYmNzb2U5Q2FM?=
 =?utf-8?B?dW9vSDZNZVpXSEg4TWcvTm1QSHdMdHpOQVQ5MDNIMU5Ia0xpbmxsbWxRVVd5?=
 =?utf-8?B?VjBaS2ZZSWNBZjdYR1IrVUdCMXh5eEhvVVJyQ2xFYWcvNG03bklRdEdyUWQ2?=
 =?utf-8?B?SWRvZjk5OTY3SWQ5a3A5djkyQUhXTXNlaGlMQ1Vpc1JzbS96eGtLSUpzeDc5?=
 =?utf-8?B?aWc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8829ae9d-6975-4e3f-4eb4-08db4d98ac4a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 18:43:52.6496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMBbmCWFcYdBqKEkCrAmGYq7MOnZjs7zlqf5B3hPbUn3GC1w3r090ezOCoN6xzHt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB6247
X-Proofpoint-ORIG-GUID: wb-N9e0XtuKgBGxMzGnuvQ6A2Ni7Ts_3
X-Proofpoint-GUID: wb-N9e0XtuKgBGxMzGnuvQ6A2Ni7Ts_3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-05_25,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/5/23 12:18 AM, Feng Zhou wrote:
> 在 2023/5/5 14:58, Hao Luo 写道:
>> On Thu, May 4, 2023 at 11:08 PM Feng zhou <zhoufeng.zf@bytedance.com> 
>> wrote:
>>>
>> <...>
>>> ---
>>>   kernel/bpf/helpers.c | 20 ++++++++++++++++++++
>>>   1 file changed, 20 insertions(+)
>>>
>>> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
>>> index bb6b4637ebf2..453cbd312366 100644
>>> --- a/kernel/bpf/helpers.c
>>> +++ b/kernel/bpf/helpers.c
>>> @@ -2149,6 +2149,25 @@ __bpf_kfunc struct cgroup 
>>> *bpf_cgroup_from_id(u64 cgid)
>>>                  return NULL;
>>>          return cgrp;
>>>   }
>>> +
>>> +/**
>>> + * bpf_task_under_cgroup - wrap task_under_cgroup_hierarchy() as a 
>>> kfunc, test
>>> + * task's membership of cgroup ancestry.
>>> + * @task: the task to be tested
>>> + * @ancestor: possible ancestor of @task's cgroup
>>> + *
>>> + * Tests whether @task's default cgroup hierarchy is a descendant of 
>>> @ancestor.
>>> + * It follows all the same rules as cgroup_is_descendant, and only 
>>> applies
>>> + * to the default hierarchy.
>>> + */
>>> +__bpf_kfunc long bpf_task_under_cgroup(struct task_struct *task,
>>> +                                      struct cgroup *ancestor)
>>> +{
>>> +       if (unlikely(!ancestor || !task))
>>> +               return -EINVAL;
>>> +
>>> +       return task_under_cgroup_hierarchy(task, ancestor);
>>> +}
>>>   #endif /* CONFIG_CGROUPS */
>>>
>>
>> I wonder in what situation a null 'task' or 'ancestor' can be passed.
>> Please call out in the comment that the returned value can be a
>> negative error, so that writing if(bpf_task_under_cgroup()) may cause
>> surprising results.
>>
>> Hao
> 
> Hmm, you are right. As kfunc, the NULL value of the parameter is judged, 
> and bpf verify will prompt the developer to add it. There is really no 
> need to add this part of the judgment. See other people's opinions.

Thanks for pointing out Hou.

Currently, bpf_task_under_cgroup() is marked as KF_RCU.

Per documentation:
2.4.7 KF_RCU flag
-----------------

The KF_RCU flag is a weaker version of KF_TRUSTED_ARGS. The kfuncs 
marked with
KF_RCU expect either PTR_TRUSTED or MEM_RCU arguments. The verifier 
guarantees
that the objects are valid and there is no use-after-free. The pointers 
are not
NULL, but the object's refcount could have reached zero. The kfuncs need to
consider doing refcnt != 0 check, especially when returning a KF_ACQUIRE
pointer. Note as well that a KF_ACQUIRE kfunc that is KF_RCU should very 
likely
also be KF_RET_NULL.


The pointer cannot be NULL, so the following line of code can be removed:
 >>> +       if (unlikely(!ancestor || !task))
 >>> +               return -EINVAL;

I think we do not need to check refcnt != 0 case since ancestor and
task won't go away.

In the example of second patch, both arguments are TRUSTED arguments
which is stronger than RCU, so the test itself is okay.
I am considering whether we should enforce arguments of the kfunc
to be KF_TRUSTED_ARGS, but I think esp. in some cases, cgroup
might be RCU protected e.g., task->cgroup->dfl_cgrp. So leaving argument
requirement as KF_RCU should be better.

> 
>


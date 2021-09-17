Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7683A40FABE
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhIQOuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:50:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31960 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231626AbhIQOuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 10:50:44 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 18HEdlWV017891;
        Fri, 17 Sep 2021 07:48:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=IWTROyg+fkKQ8c8VDjhBTrm45xGb+w4PncLC70LAO4Y=;
 b=OM6Qnlly96RsYvy/H4EzLh7MeoBT0XTGUALMWxuX2iUiTr5O/mv7qH8MzhxG3v3mFyGJ
 7Q1BaMz2SNiwUD8bEWeG09f1yt3GhkOUt7PCW5ixGoFJVsHwdaNcfSZ7eGWoq7Py0e5m
 eMdaBxrHJ0dkqOpun/A+O+SaAhNVmH0/du0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3b4gxhv9dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 17 Sep 2021 07:48:58 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 17 Sep 2021 07:48:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rua4c+UCSqIxzV9iPj+L/ChYR1jwWGmxSrs2p+0pqzFdU9b0fflq56yY2335040irqqp+R/BvvVq0hilUHxGP5pIIT66zLZLlaI33WKOqZxgcgYCU8DpyzI+aDbdt8GMzOcqDo6EfCj8QXxFDgh6mJ+ANybVAbBclyoB+Rt3eeeU3pb3wzvAKVVyUP+DXACEW8MHZSOrCyWdGGYZR/EtgwO0Zhl+QwwKFOcUu6S9nZVKcR7Z2qRE3MTywxIJJPbXSYJIrUw0VfdnfMEtpq5FXyAvVfILl5UcoE6+5v6JjZkVGRB3yJF9u5XkifMoslemx7vrzQCoslu9WUXHPpsWOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IWTROyg+fkKQ8c8VDjhBTrm45xGb+w4PncLC70LAO4Y=;
 b=kDKzHVibGktTANPZ7KeCvCbEBceIsJ4w8PUlG+9+kQDzLPtp6RonGBpu5844qhDtOOBMZvZRnAlwhUtrJV7RqLE4PaX7unC2J5xtFAf9tEumzUJmDMqV0Vi0jXZ/dtsQ9SbggpkSmKQXLwN9Vft7jt0vYS4okqoYV5QIogI2F2Ozq1au1buCBK7Q0CAiV92l2uAIFR8CM+ode0pg0RE4AxEYDHUaZQqJNeE32AWONJOF/MgAoDdNK6+OawfUnF1M9GNqWySN2lNffjqYb4beGezFJJ/pyiQQkUgWZZ4UeqO3xUBr6NgGbakEgk1lZuSD8IYjBTvqaw3BjcfdXx/WBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4500.namprd15.prod.outlook.com (2603:10b6:806:19b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 17 Sep
 2021 14:48:55 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 14:48:55 +0000
Subject: Re: [PATCH 1/3] bpf: support writable context for bare tracepoint
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20210916135511.3787194-1-houtao1@huawei.com>
 <20210916135511.3787194-2-houtao1@huawei.com>
 <9cbbb8b4-f3e3-cd2d-a1cc-e086e7d28946@fb.com>
 <b76d4051-abff-5e75-c812-41c6f283327f@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3001e875-9a74-8e22-3a7c-be3d280cd866@fb.com>
Date:   Fri, 17 Sep 2021 07:48:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <b76d4051-abff-5e75-c812-41c6f283327f@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0011.prod.exchangelabs.com (2603:10b6:a02:80::24)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPv6:2620:10d:c085:21e8::1426] (2620:10d:c090:400::5:ad12) by BYAPR01CA0011.prod.exchangelabs.com (2603:10b6:a02:80::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 14:48:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a975074-7e7c-47a0-2253-08d979ea45f4
X-MS-TrafficTypeDiagnostic: SA1PR15MB4500:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4500DBAF02621A7DF3971706D3DD9@SA1PR15MB4500.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rAQhCg0vmKe7aIImETQc1bqr/NL3SQTrySg16SUTl7TkOZ+DfmGXPoaw5ZFdYaY/M5Ku5h18xaZJRr3YqNLy+cC2eVTDcO2JnKkJwjAcxw8ks2VbQ3DrjEUjGtR4anlLCj4eghsoWIl1e520cAsJ/Vk4tHPnirPtwZwOBFyh9hGd8IBUKVHef/EK1J4w8CBSGVi9RxTF7kzHJruo6AjNFmr9bk+LXFtrqANdSwv6QnrIEzEAMXl+yR/cJ5ZO1/aTo7EL0QI0BsGbi/5563kKyEoXBR+wqCfMzEXivIVFgEWotHuwna4/elgDR/PDEQKmdq59AEO3l7nuWBkw46ncfDZJdUBC3oDMLiV1dan7X91gJCICpv667vAGwQgMjxWwf7Y/GdY5+wrLuT+X0/vIxCkLjtZ4s/DOhnAzKfqygP51QNc3d5n1hFilVTHcbxsqoNU/RgODe2wWwElcCuxvlbya+KmE6dbrU4fJ5Wiw05vcyALsryVCFy4lUyVwzQdTsnW0zzql727et00tMMrCf/+kF+isVorehD9MZBzD0m8DImo+AL+7JJEcpfBczXlPsO8ljgHGgbfTiodcHe5EIFEVMN7tox+lalZ1P9kitBKQf6E1CurMDcB846unX2IjolLnQu7yKaBqzqEMlG0skQAqZElxnpJIvfvafE0ZvHjXjyeIQuA4rOXCofeX/V96OwaWX0zN2K6xV8cZn0VKmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(110136005)(53546011)(6486002)(66946007)(66556008)(186003)(316002)(31686004)(36756003)(54906003)(4326008)(2616005)(86362001)(508600001)(5660300002)(83380400001)(2906002)(8676002)(52116002)(8936002)(38100700002)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEZhREg3Z0MvZXNFWUVsOXRzVFJ1VzBwNVVWR3RKekdPRWp0UlZ6blZmVm9j?=
 =?utf-8?B?T3NjQ3hNRDJseVpuTTN5dUxIT0VjREtKZFhVSFJObHE4dlZqeXExaWJqWG5I?=
 =?utf-8?B?QmpWYWVJREVnMEd0SlIyeFNkamxSMThRaEZzRTVJWmxtVGVnalVENkNBNHUr?=
 =?utf-8?B?N0xsaEd4a0F2Tk8vbXB0dURVKzRMc3ZOaE1QUVBDQzI2VkVpZDFHYzFObFRR?=
 =?utf-8?B?eEV5N1BUZUhubVllMWhlMmFTZ0xUcEV0ZEhXanFyKy8yWEtFMjV4TDR4MkJ5?=
 =?utf-8?B?YVV3UmdjU0hmcUtHUVREY1pNTTg1RGpUMFB3N1NJMFhoQm9FVWZSZlBDa0Vn?=
 =?utf-8?B?OXR4VkVQdGtaVXVMM1BWZHZ5ajJQRFVPVCtBeGtBM1dJQ3FJU1hVM1ZqTzVG?=
 =?utf-8?B?UWZYK0hkRCtOc3FmYUU0cU5MNGpESFBvUzFOQnJkbmFvZkZCZ25MM0Y5WmRT?=
 =?utf-8?B?Uml5dEJXd0EwbjVaV1hQZ3VIZkVkM2ZobGFnbWtTekR4QTdMWFVQT2paVnE1?=
 =?utf-8?B?UkpOSlRvcjgzSmRiQnRGd0FSQWlrVHA4V1ZYZEZvVkl0VjQzVXNNRDNIR3E4?=
 =?utf-8?B?OTcyTWt2ZmlDQzMzK3FtR2FXN2ROTDRsSnlBUTE0S04wZTZrSkJ1V2NWQWxI?=
 =?utf-8?B?RkZUZVNlQXR6R0dUVEhEOWJ1QkpmVGtVL2QzUVQzN1FvTVVuTW4wMkRMaGp0?=
 =?utf-8?B?czlVYzdLTlQ5SE51VURJbDRGWDRsWFdEczB1cFFOL2Y1QVNTMkRkbTZrbmIy?=
 =?utf-8?B?SHBad1lVNGN4T2NZZWRKZEtzaUNmU3k5Q2NhaGRLS0tQMUs1Zk82UngzZjFM?=
 =?utf-8?B?WVpWTVJXSS85cGREYUdSNmIwZ0tlUXNzd2ZFQUlOa3lQZjdmRkRHYVZWU2Ix?=
 =?utf-8?B?ZXl1U0dhSTlmM0tZaVMxcURKZHlLQmdtUHQ3ODAxMk50L3hReEpmZys1d0lL?=
 =?utf-8?B?TTBiY2FCRGVJUjN2aEUweGxZME5qVkRMSDNyMXlac3lFbEI3ZXV5VzZJY0Y5?=
 =?utf-8?B?cGV4SWN1TExQUHUxbEF5bTA5cytBajdSZXFPcCtUbVRIMmhFQk9FSGlsdHNm?=
 =?utf-8?B?dG02NHZ6bmNHUUlIbzVpN2lHM0hPQ0Zub2dMSnhEUlZFdHJ1bE83NHRFRTdt?=
 =?utf-8?B?WlNuYTVPSXV5ZnEwMkNnK3B6TGxzMTRRY3d1YSt5ZmVFTFI3RFBUSHJIOG82?=
 =?utf-8?B?QndvK21ZMGxIY05GYVNUcHM1blBNNnpzWWRPYVFMMWh5Y2p0UkhESHZZaHJG?=
 =?utf-8?B?QjQvOVdUaVg3RlRyQkF1OGdSR2p2TERndHFESnl4ODZzNGc4OXFKQTc5ckVG?=
 =?utf-8?B?TGRTQVAwTnZoTkh5UUcvcjBmS1hlN01XVzFFZ0lIUmpMT01BckR5SHFjeVpX?=
 =?utf-8?B?ekhLd1BydmZBZEZmdUYwQUZ0V3o4WVZja3NQa3JEYUV4NG5IYWtLUDF3cmNy?=
 =?utf-8?B?OXZPazVOaFljMWllN2xUVlN4T0cwVDd3R1ZPbFBMaFBBYkZlR1ZuMGlIa3gy?=
 =?utf-8?B?bkk3VFNQd3poZ08reDZBWVFHY1ZVZG9WMndCMlkwcFFDMGxsd1NUdVhUdFBS?=
 =?utf-8?B?R241WWMyREpCV3hLZXVkTVd1TmFaZDIrTVFNdmZoVzVpMUpodVFaTGlMVnRj?=
 =?utf-8?B?aEJWNzQrU2RMckdtdStBVTZjRE9Pd29MRWcxQ25OZlk4QlM0VTdiTEhhQUMv?=
 =?utf-8?B?WUV3b0NmeWFQOG1HcmUwc1pXSzBRUm03RVQzR0NaYkRuU2hSMzhsd1hYWGIw?=
 =?utf-8?B?Z0MrS01UQTRvUXRwQzhxSlhYTzhDS0p2eGduM25VUVZ0NG9IenB0Y3lsblFL?=
 =?utf-8?B?NVRoTGVhdTVHZnZYSUNaQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a975074-7e7c-47a0-2253-08d979ea45f4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 14:48:55.6059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULVMIQy6kF1m+oGMm0E792HOjjdv4qYLSL/YW7athzMrKIaF7+mA6DNd9tssqrIc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4500
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 0LBeHsylIs5WAhQHpm6MR4skkm0tmNQ5
X-Proofpoint-GUID: 0LBeHsylIs5WAhQHpm6MR4skkm0tmNQ5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_06,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 priorityscore=1501 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/21 6:45 AM, Hou Tao wrote:
> Hi,
> 
> On 9/17/2021 7:16 AM, Yonghong Song wrote:
>>
>>
>> On 9/16/21 6:55 AM, Hou Tao wrote:
>>> Commit 9df1c28bb752 ("bpf: add writable context for raw tracepoints")
>>> supports writable context for tracepoint, but it misses the support
>>> for bare tracepoint which has no associated trace event.
>>>
>>> Bare tracepoint is defined by DECLARE_TRACE(), so adding a corresponding
>>> DECLARE_TRACE_WRITABLE() macro to generate a definition in __bpf_raw_tp_map
>>> section for bare tracepoint in a similar way to DEFINE_TRACE_WRITABLE().
>>>
>>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>>> ---
>>>    include/trace/bpf_probe.h | 19 +++++++++++++++----
>>>    1 file changed, 15 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
>>> index a23be89119aa..d08ee1060d82 100644
>>> --- a/include/trace/bpf_probe.h
>>> +++ b/include/trace/bpf_probe.h
>>> @@ -93,8 +93,7 @@ __section("__bpf_raw_tp_map") = {                    \
>>>      #define FIRST(x, ...) x
>>>    -#undef DEFINE_EVENT_WRITABLE
>>> -#define DEFINE_EVENT_WRITABLE(template, call, proto, args, size)    \
>>> +#define __CHECK_WRITABLE_BUF_SIZE(call, proto, args, size)        \
>>>    static inline void bpf_test_buffer_##call(void)                \
>>>    {                                    \
>>>        /* BUILD_BUG_ON() is ignored if the code is completely eliminated, but \
>>> @@ -103,8 +102,12 @@ static inline void
>>> bpf_test_buffer_##call(void)                \
>>>         */                                \
>>>        FIRST(proto);                            \
>>>        (void)BUILD_BUG_ON_ZERO(size != sizeof(*FIRST(args)));        \
>>> -}                                    \
>>> -__DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
>>> +}
>>> +
>>> +#undef DEFINE_EVENT_WRITABLE
>>> +#define DEFINE_EVENT_WRITABLE(template, call, proto, args, size) \
>>> +    __CHECK_WRITABLE_BUF_SIZE(call, PARAMS(proto), PARAMS(args), size) \
>>> +    __DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
>>>      #undef DEFINE_EVENT
>>>    #define DEFINE_EVENT(template, call, proto, args)            \
>>> @@ -119,10 +122,18 @@ __DEFINE_EVENT(template, call, PARAMS(proto),
>>> PARAMS(args), size)
>>>        __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))        \
>>>        __DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), 0)
>>>    +#undef DECLARE_TRACE_WRITABLE
>>> +#define DECLARE_TRACE_WRITABLE(call, proto, args, size) \
>>> +    __CHECK_WRITABLE_BUF_SIZE(call, PARAMS(proto), PARAMS(args), size) \
>>> +    __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args)) \
>>> +    __DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), size)
>>> +
>>>    #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>>>      #undef DEFINE_EVENT_WRITABLE
>>> +#undef DECLARE_TRACE_WRITABLE
>>>    #undef __DEFINE_EVENT
>>> +#undef __CHECK_WRITABLE_BUF_SIZE
>>
>> Put "#undef __CHECK_WRITABLE_BUF_SIZE" right after "#undef
>> DECLARE_TRACE_WRITABLE" since they are related to each other
>> and also they are in correct reverse order w.r.t. __DEFINE_EVENT?
> If considering __CHECK_WRITABLE_BUF_SIZE is used in both DECLARE_TRACE_WRITABLE and
> DEFINE_EVENT_WRITABLE and the order of definitions, is the following order better ?
> 
> #undef DECLARE_TRACE_WRITABLE
> #undef DEFINE_EVENT_WRITABLE
> #undef __CHECK_WRITABLE_BUF_SIZE

This should be okay.

> 
>>
>>>    #undef FIRST
>>>      #endif /* CONFIG_BPF_EVENTS */
>>>
>> .
> 

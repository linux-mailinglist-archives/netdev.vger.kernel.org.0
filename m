Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC3F369C55
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhDWV5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:57:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54072 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244125AbhDWV5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 17:57:00 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NLimOC010334;
        Fri, 23 Apr 2021 14:56:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4iWaNmKqDwpTHBXqoza/f2EN84OhPMpqPr6+IahXNBE=;
 b=ADxw4BvRCh6fTHRjqDXLYrf338N4SqZj9Af5rE7xh1Fi0lt2Hm9jRYly/qNgJoLYaUwA
 c6HgrczyLLffv8SiBsrO7tco/AwS6TIdwCk/Xs0R1IVpcoBWeWPHzLYPcV0zaH55mWv5
 sdB6FyvDWOklBtrVj9ATcmeYPz/Cm2E/x74= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 383b4q96vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 14:56:10 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 14:56:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gECHAF3b+y/YJ+vUyICSNOGttI3vO5fU7b4vLh78nLsLZWQEcYm+3o6mXh9UsCYg4oTIQzxfRb5PHP2JVYHaEwKT6kTboolc5670Op7mSpd0hTFXCUB8D3X4OG5FjQwmCQnc/asWIOSZ53qA5EujwTJTWjbRpI812uKUDqKYtk/y2PNwmKxZU4ZTuzd3d4dSda17ugAwhN6LERH5f5OT+jSCuNWb2j8k4Hg5SSjslDPqHzYtJsumRWIF6/VSpybrEARZYp/Q6Pr8P00j4x/WECQgB7zLKZOFgl1tqTl6ckaF8PzZRYyz87slJBtjOQfC7P8R7rlcLNJw7qQn9gSbcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iWaNmKqDwpTHBXqoza/f2EN84OhPMpqPr6+IahXNBE=;
 b=YNkuMydrl3PIsI2Ig0uFD7qdymRh2SKar5wChXyAY/vkGajJivSf9IsBYBDiuLo56dh7O5pg56drqFZ7N5+bm4XmWYqCH2cZdXB421xgum3VQtjc3j9spHbmRK+n7A3Yc6ZWBgzx9LBlCYjuUhPRWsqPjLXnTF48ct1iorBbj2L0RJp8NQhdcpitnsOhwV9Z6fAY2tKosno9ehxCGkJz4+/Xu6OD+UsCy0u+eW3FoOfIybvbV4pWaHZ8KJ2O8qvh/yHG+jx4DtHfFbN9hPzUxDRDkaZFPa8muZcZ2iTt1Q5m2OvtUYSNi5CtFIKliK5n9Tl0fpLmia9C0szltTUeXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3903.namprd15.prod.outlook.com (2603:10b6:806:8a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 21:56:06 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 21:56:06 +0000
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during
 linking
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20210423185357.1992756-1-andrii@kernel.org>
 <20210423185357.1992756-3-andrii@kernel.org>
 <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com>
 <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com>
Date:   Fri, 23 Apr 2021 14:56:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:d0ec]
X-ClientProxiedBy: CO2PR04CA0132.namprd04.prod.outlook.com
 (2603:10b6:104:7::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:d0ec) by CO2PR04CA0132.namprd04.prod.outlook.com (2603:10b6:104:7::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 21:56:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54b468b8-36cc-4d2b-6122-08d906a2989a
X-MS-TrafficTypeDiagnostic: SA0PR15MB3903:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB390378383B4D2AA283EB5A95D3459@SA0PR15MB3903.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PIIfLp4a9S+WuNRFgCawOqgV0QlxdJvLbd9hSYijiocsfSGNFFxi+N3gPaktOfl+dfaXQixgrOo5RlCq6vzw+psxoBUwc10KkbRjyAAWWbYI6+mpVp4XCYz+iudBXxnPEyrraA7cf1r/r1PEXIP8ir8ku3BzQb7mk1u3XgK3AymVEaql5uizqOyftx0R3MBVLSbkj6F7Gfu0l5esXg1DXxt75sODgEwT473Pr4I4ykhYm1mmC+/mjsWpsTe4GOoKxZuEQsFPGcRcgru0U/50p73/SO/JZfeiXccvHDUJaNArCvYqPYUK77YxJXC/IpDtK1ALxMReet9+SDx8j7F3pfOmS+qBaewq1w6DWUxZTMAYdvA/xot7jHdPJPJH0ind+IGIxY3pDGtUfLWXQeSH8J5bpZbxRGIGyNCakyZ3HQvW24V0I9EghplCMjUhSmUhNvS/FGIN9E7ecQzhyELalj/PrSerMqy9QUU60IW7btfoXPlScxL/W3spQ36Kw+JhKVmqMf8dVxr5wqToWIzk0b85+6eVyRuoBlYQde1MdZWdyKlEhFOwhm03aFI6eOzvrtl9CCx09bPYPx0Hjlnpj6PuSuTXggi0nCyz4d8GMGCQnfQktjJp3oeJdF8rW3znKTAH/bvEFlq9nB7G0+jTwY2e3S0yL78k0AFOno/VGViMkPMVmTId2nZ6gHSJ6Lex
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(31686004)(31696002)(2616005)(83380400001)(316002)(86362001)(5660300002)(2906002)(66476007)(6666004)(4326008)(54906003)(6486002)(36756003)(478600001)(66556008)(8676002)(66946007)(52116002)(8936002)(53546011)(6916009)(38100700002)(16526019)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ME9ZdkJoZ29Hc0U3dlV6K0hpVzUzdExoeSswWmY0UlVkTVVaRlozNm0xeXdI?=
 =?utf-8?B?Zlc5SWVGbElnclZEUHp5VjRHR3RFbTg5K1JzTldJS3NMcVhWREJuZEZkUWxu?=
 =?utf-8?B?cXhYcTNobVZ0ZDJmMGE5eTg1U2JsT0lZV011b3JYU1NmZnU0M1RIdXExVFdJ?=
 =?utf-8?B?dDl2eHVMU2pQbUp6eTRscVRZRE9CQW84RWZUK1FGSlJZREVKT0dHMVJMWGtj?=
 =?utf-8?B?ejg2Tit4azRhbEtsWUFBRy9IdUFhZXhKU1Q0ODNZbHpGOGFBQ04rVXRyWVM4?=
 =?utf-8?B?dXdDWi9RS1B2RVBHdzhyVUhLZlh6UUhQK2kyS2dVZDVzSlh2SEdLdVBLMjBr?=
 =?utf-8?B?RXI1bFJPcklKZkRESWFYdXFqSERrZ0VvMmV5ZWtOMU9KTVB6VUptYnFFdVVZ?=
 =?utf-8?B?S2cweXRoc1RvbTJoWjh1ck5HMkhiMXNhOEM4dGY3VlphZ1hldVVWY2hhVzVu?=
 =?utf-8?B?b3hIZG1pYXJsd2xiUkc2azRkWkJRYTJUcUpzTDFGdEgrQWx4MmhBYkhjdVdP?=
 =?utf-8?B?NnZrNkhZQ2tHZ0ZPaSsrUm9Hb29qWHpjV3pPTEt0QklSUEtQaHJiQ2l4VjFs?=
 =?utf-8?B?YXRIZzVucERBMFNKMXVxWE13RkRwYWhIc3UvN09BcnNNaUJQUVRCVHdOYnl4?=
 =?utf-8?B?ZnJWck5PSEhqMytyS2o2ZGFaU2FZYnM1dFlSUkIzclgyQkt6aitKelNIQWRv?=
 =?utf-8?B?NEpxVVBRbFB5cVNiU0gxRWIvS1R5U3EzSkUwamVjSnk5aldZWWJmOVZ2NW1S?=
 =?utf-8?B?eHF3R1ZmcnNPZzgrSFFidFB4QlpEeGpOdWExNG9tVEN1YzE2VVV5a0F4S2Fa?=
 =?utf-8?B?VUxMdjNvVnpmSktoSGJpeDdKL05YKzZnS2FyR3B1N3RRMzhDbEFGRkxRV2Ey?=
 =?utf-8?B?OGxMMzAwKzhUVzBLOVhtbHlvR21pVFZUc0k4VkxtbmlQck5DWjYwTjZwTkxZ?=
 =?utf-8?B?TzlQK1ZqU3ZxNFpkVlUzSSt3TGN3bUV5Y3dyQmdsbml3NXdnSWhkV1dHNnR6?=
 =?utf-8?B?Vml2Qmdqb3M0TE1ZbmppcFFnZ1REZk1VSTNyMmdtVHRxN25PUEYrQUxHbmVV?=
 =?utf-8?B?LzJDY3VsbG1HemQ3eEFBYVBIbVVxNUN3Z1N1TWl6REN4NFl6Qm1VV1Q0Qng1?=
 =?utf-8?B?UzJDRWlRSXJEQVdvMWNTdFUvdWRzNy9hSHhXVGl5SFMyVkw1d1hyUkM4NnV2?=
 =?utf-8?B?RnVHSFdxUm9wMUw3Y0cyQ3ZyOHRPQmduNXZRWXpTY0FuOHpJYkxuSFN6a1ZF?=
 =?utf-8?B?SWhXZnZnSEUwR3I5S3MrQ1NxckpET3o4ZEovdENFT0t6Mlh1Y1NlV2NSaWYr?=
 =?utf-8?B?YnNiWWdNQlNhMXVPTWlHWmYvZ3l5ck4zZGs3VXRxTzVjamhKc1JUc21KMitD?=
 =?utf-8?B?TVNSK0NpT21TVllTR2lkVGsyZWFUZ3hkVkoxem42eVRsSHZLMmhaZnVQdWYv?=
 =?utf-8?B?OU9VaHpkemk0VUkxUzFXWTFuQ1hyYmxqTERhQW1sT0JFLzc0NURSYlFEZkI2?=
 =?utf-8?B?cjV4V2w3c2tibEdPL0JOYWJyd29qd0dMWEkzMmZNWVkxTU0vRTYvdTU4VUR5?=
 =?utf-8?B?bG1OZmUyVW1CNEFCS2QrcHorR25HTVp4VW9Gb3VGUEE3Z1ljZFBoMCt4d0F0?=
 =?utf-8?B?bWZWZHhMcEN3VEdXbnZ0ZFBuWk4xVVpiM0o3SjYzbiszZnpuajRtZE9GZXlx?=
 =?utf-8?B?VWVtQWwxZm5MSmpEdjQ3UEtCVVpEQUxjTFZBTEhJZDRlZ29waEczNTdqcmJm?=
 =?utf-8?B?ZXpleXJHYUFKcUI4R3ppQWhIdkE1NUtnL0t6ZUQvU2N1RWR4WEhQS25uY0ZB?=
 =?utf-8?Q?Gbu8JK+zURJCJgm08fyG+QAczmBhFHBJWmNP0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b468b8-36cc-4d2b-6122-08d906a2989a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 21:56:06.5787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F0IFdKMvzZws/sHdKrUcXPIqtVGGth9uwr1zj+/+jhh4s66y1RxUxHfscezdq52F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3903
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 7p9gsJ6hmfw6D17ggV8zRNfNz27zUKyW
X-Proofpoint-ORIG-GUID: 7p9gsJ6hmfw6D17ggV8zRNfNz27zUKyW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_13:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 mlxlogscore=999 phishscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230145
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 2:38 PM, Andrii Nakryiko wrote:
> On Fri, Apr 23, 2021 at 1:24 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 4/23/21 11:53 AM, Andrii Nakryiko wrote:
>>> Prepend <obj_name>.. prefix to each static variable in BTF info during static
>>> linking. This makes them uniquely named for the sake of BPF skeleton use,
>>> allowing to read/write static BPF variables from user-space. This uniqueness
>>> guarantee depends on each linked file name uniqueness, of course. Double dots
>>> separator was chosen both to be different (but similar) to the separator that
>>> Clang is currently using for static variables defined inside functions as well
>>> as to generate a natural (in libbpf parlance, at least) obj__var naming pattern
>>> in BPF skeleton. Static linker also checks for static variable to already
>>> contain ".." separator and skips the rename to allow multi-pass linking and not
>>> keep making variable name ever increasing, if derived object name is changing on
>>> each pass (as is the case for selftests).
>>>
>>> This patch also adds opts to bpf_linker__add_file() API, which currently
>>> allows to override object name for a given file and could be extended with other
>>> per-file options in the future. This is not a breaking change because
>>> bpf_linker__add_file() isn't yet released officially.
>>>
>>> This patch also includes fixes to few selftests that are already using static
>>> variables. They have to go in in the same patch to not break selftest build.
>>
>> "in in" => "in"
> 
> heh, I knew this would be confusing :) it's "go in" a verb and "in the
> same patch" as where they go into. But I'll re-phrase in the next
> version.
> 
>>
>>> Keep in mind, this static variable rename only happens during static linking.
>>> For any existing user of BPF skeleton using static variables nothing changes,
>>> because those use cases are using variable names generated by Clang. Only new
>>> users utilizing static linker might need to adjust BPF skeleton use, which
>>> currently will be always new use cases. So ther is no risk of breakage.
>>>
>>> static_linked selftests is modified to also validate conflicting static variable
>>> names are handled correctly both during static linking and in BPF skeleton.
>>>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>> ---
>>>    tools/bpf/bpftool/gen.c                       |   2 +-
>>>    tools/lib/bpf/libbpf.h                        |  12 +-
>>>    tools/lib/bpf/linker.c                        | 121 +++++++++++++++++-
>>>    .../selftests/bpf/prog_tests/skeleton.c       |   8 +-
>>>    .../selftests/bpf/prog_tests/static_linked.c  |   8 +-
>>>    .../selftests/bpf/progs/bpf_iter_test_kern4.c |   4 +-
>>>    .../selftests/bpf/progs/test_check_mtu.c      |   4 +-
>>>    .../selftests/bpf/progs/test_cls_redirect.c   |   4 +-
>>>    .../bpf/progs/test_snprintf_single.c          |   2 +-
>>>    .../selftests/bpf/progs/test_sockmap_listen.c |   4 +-
>>>    .../selftests/bpf/progs/test_static_linked1.c |   6 +-
>>>    .../selftests/bpf/progs/test_static_linked2.c |   4 +-
>>>    12 files changed, 151 insertions(+), 28 deletions(-)
>>>
> 
> [...]
> 
>>> +static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
>>> +                             const struct bpf_linker_file_opts *opts,
>>> +                             struct src_obj *obj)
>>>    {
>>>    #if __BYTE_ORDER == __LITTLE_ENDIAN
>>>        const int host_endianness = ELFDATA2LSB;
>>> @@ -549,6 +613,14 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
>>>
>>>        obj->filename = filename;
>>>
>>> +     if (OPTS_GET(opts, object_name, NULL)) {
>>> +             strncpy(obj->obj_name, opts->object_name, MAX_OBJ_NAME_LEN);
>>> +             obj->obj_name[MAX_OBJ_NAME_LEN - 1] = '\0';
>>
>> Looks we don't have examples/selftests which actually use this option.
>> The only place to use bpf_linker__add_file() is bpftool which did not
>> have option to overwrite the obj file name.
>>
>> The code looks fine to me though.
> 
> Right, I was a bit lazy in adding this to bpftool, but I'm sure we'll
> want to support overriding obj file name, at least to resolve object
> file name conflicts. One other problem is syntax, I haven't thought
> through what's the best way to do this with bpftool. Something like
> this would do it:
> 
> bpftool gen object dest.o input1.o=custom_obj_name
> path/to/file2.o=another_custom_obj_name
> 
> But this is too bike-shedding a topic which I want to avoid for now.

Okay. The additional option thing can be done later.

> 
>>
>>> +     } else {
>>> +             get_obj_name(obj->obj_name, filename);
>>> +     }
>>> +     obj->obj_name_len = strlen(obj->obj_name);
>>> +
>>>        obj->fd = open(filename, O_RDONLY);
>>>        if (obj->fd < 0) {
>>>                err = -errno;
>>> @@ -2264,6 +2336,47 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>>>                                obj->btf_type_map[i] = glob_sym->btf_id;
>>>                                continue;
>>>                        }
>>> +             } else if (btf_is_var(t) && btf_var(t)->linkage == BTF_VAR_STATIC) {
>>> +                     /* Static variables are renamed to include
>>> +                      * "<obj_name>.." prefix (note double dots), similarly
>>> +                      * to how static variables inside functions are named
>>> +                      * "<func_name>.<var_name>" by compiler. This allows to
>>> +                      * have  unique identifiers for static variables across
>>> +                      * all linked object files (assuming unique filenames,
>>> +                      * of course), which BPF skeleton relies on.
>>> +                      *
>>> +                      * So worst case static variable inside the function
>>> +                      * will have the form "<obj_name>..<func_name>.<var_name"
>> <var_name  => <var_name>
> 
> good catch, will fix
> 
>>> +                      * and will get sanitized by BPF skeleton generation
>>> +                      * logic to a field with <obj_name>__<func_name>_<var_name>
>>> +                      * name. Typical static variable will have a
>>> +                      * <obj_name>__<var_name> name, implying arguably nice
>>> +                      * per-file scoping.
>>> +                      *
>>> +                      * If static var name already contains '..', though,
>>> +                      * don't rename it, because it was already renamed by
>>> +                      * previous linker passes.
>>> +                      */
>>> +                     name = btf__str_by_offset(obj->btf, t->name_off);
>>> +                     if (!strstr(name, "..")) {
>>> +                             char new_name[MAX_VAR_NAME_LEN];
>>> +
>>> +                             memcpy(new_name, obj->obj_name, obj->obj_name_len);
>>> +                             new_name[obj->obj_name_len] = '.';
>>> +                             new_name[obj->obj_name_len + 1] = '.';
>>> +                             new_name[obj->obj_name_len + 2] = '\0';
>>> +                             /* -3 is for '..' separator and terminating '\0' */
>>> +                             strncat(new_name, name, MAX_VAR_NAME_LEN - obj->obj_name_len - 3);
>>> +
>>> +                             id = btf__add_str(obj->btf, new_name);
>>> +                             if (id < 0)
>>> +                                     return id;
>>> +
>>> +                             /* btf__add_str() might invalidate t, so re-fetch */
>>> +                             t = btf__type_by_id(obj->btf, i);
>>> +
>>> +                             ((struct btf_type *)t)->name_off = id;
>>> +                     }
>>>                }
>>>
> 
> [...]
> 
>>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
>>> index ee49493dc125..43bf8ec8ae79 100644
>>> --- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
>>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
>>> @@ -9,8 +9,8 @@ __u32 map1_id = 0, map2_id = 0;
>>>    __u32 map1_accessed = 0, map2_accessed = 0;
>>>    __u64 map1_seqnum = 0, map2_seqnum1 = 0, map2_seqnum2 = 0;
>>>
>>> -static volatile const __u32 print_len;
>>> -static volatile const __u32 ret1;
>>> +volatile const __u32 print_len = 0;
>>> +volatile const __u32 ret1 = 0;
>>
>> I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think
>> this is not in a static link test, right? The same for a few tests below.
> 
> All the selftests are passed through a static linker, so it will
> append obj_name to each static variable. So I just minimized use of
> static variables to avoid too much code churn. If this variable was
> static, it would have to be accessed as
> skel->rodata->bpf_iter_test_kern4__print_len, for example.

Okay this should be fine. selftests/bpf specific. I just feel that
some people may get confused if they write/see a single program in 
selftest and they have to use obj_varname format and thinking this
is a new standard, but actually it is due to static linking buried
in Makefile. Maybe add a note in selftests/README.rst so we
can point to people if there is confusion.

> 
>>
>>>
>>>    SEC("iter/bpf_map")
>>>    int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
>>> diff --git a/tools/testing/selftests/bpf/progs/test_check_mtu.c b/tools/testing/selftests/bpf/progs/test_check_mtu.c
>>> index c4a9bae96e75..71184af57749 100644
>>> --- a/tools/testing/selftests/bpf/progs/test_check_mtu.c
>>> +++ b/tools/testing/selftests/bpf/progs/test_check_mtu.c
>>> @@ -11,8 +11,8 @@
>>>    char _license[] SEC("license") = "GPL";
>>>
> 
> [...]
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB44369E87
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 04:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbhDXCht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 22:37:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232155AbhDXChs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 22:37:48 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13O2aaN2019345;
        Fri, 23 Apr 2021 19:36:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=D2SP62oVe0DS5rTG3R5gge+mvmMWy+1SvLJA4OfjeR8=;
 b=ZdhPjUY/GqWUv8DDUL+a1tfVUP0w4BfFoFdCBtn0rcGkPqp58z652gguZZVMmjVDS63m
 sFSu/IM5AjdgFzP7IzOx/HqxoNWuSPfGgh52jS4CNbd5un0bZLZXnVt1yOhkgpn0nnaO
 J/zRVkNSIPgbpjkBu1KPkNdtwdER42R015o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383an2a92a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 19:36:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 19:36:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lt0gN0Q71MCl3PaGPYMo+iW7M801QD48lenD3clSXWjxwGjVA1LzO7Stcht5zSmxLxiEac9ClloINiSuV6tMHWAuTov2Jq3wEGDbM3kAS0iVghOJwMo0sYflMRI2sCYzORciT9Vmzl64ZpHoqhp0kg5+IELACHNgahqigSEFGdJQCwirRf6Vuflbc1m/C/4p9jCQmLoX+YF5wJxie6N4WbsAYKTxwlrqAsOscePfD/zNPPkLAxo7c6onWBC4xCv3LzzSRG/mL83v7BT0/PlvYVUJIl+fxc08hOCQXaDP9TAnm2DrbObWenX2LuJefxhVQRsp4gNY1r6426Q2znhXVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2SP62oVe0DS5rTG3R5gge+mvmMWy+1SvLJA4OfjeR8=;
 b=KyIcifKkT3QfLkD2ISGgdllR8rOBpQ/hEqeU0SFPmVESb8zD16MoANeidz0kgaArrF31v4gr491z+wIL1kfQ/XxS/0unE2mDvp6sckEcu2l5uszwXqiGhSJWXY/GG5ww/+ZlRFmHjHZvBU++vf7lNj3mf7LAwHKr43EC1yZ/WVlfObx+IgiggGC6XdWsyS/eOGLxCmLz677ewiVupvftWiYBmV6zlBswvkvjrnNGN8JLMvwUrR+OhPkLLADQ8hmyIi1+JAnewmXfUIAF9Qv5dbvjfRPRVwJWqb52ugN4opqo24rzepqrM+xe9kAZVOZsxj1em/LwyUSf+3Ig66V8tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2285.namprd15.prod.outlook.com (2603:10b6:805:19::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Sat, 24 Apr
 2021 02:36:52 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Sat, 24 Apr 2021
 02:36:52 +0000
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during
 linking
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20210423185357.1992756-1-andrii@kernel.org>
 <20210423185357.1992756-3-andrii@kernel.org>
 <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com>
 <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
 <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com>
 <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
 <CAEf4BzadCR+QFy4UY8NSVFjGJF4CszhjjZ48XeeqrfX3aYTnkA@mail.gmail.com>
 <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com>
 <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f9d8328e-6f3e-59c7-05f5-d67b54e6b4ce@fb.com>
Date:   Fri, 23 Apr 2021 19:36:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:81f0]
X-ClientProxiedBy: MW4PR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:303:8d::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::134e] (2620:10d:c090:400::5:81f0) by MW4PR03CA0167.namprd03.prod.outlook.com (2603:10b6:303:8d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 02:36:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20f1c3c3-4a4a-4286-033a-08d906c9d196
X-MS-TrafficTypeDiagnostic: SN6PR15MB2285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB228539B89857B663F85FB0BDD3449@SN6PR15MB2285.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SsSgFEOrXBrLuDr487Um9MPEyGwy681FydBp4B1x0jcAZC5AlgAvyvR54IcQvoxhYPFSOoQX36xif3+DSLARXz56NA7chDLhBqH0+fK2/U5K2kZeYhf90UP+/FPAkQfap+PaIa0qdHIiAk4CkwqqUKU3DrJKspLtED/qYQVZkFz/57ix7WGt2ZHrhrCtwu8FSC4CLLg6KjmmWTUC5Rf9jMn81HIr9XC4VXo+NWTO0IT6Ho8cywtcTHaCfNxadiNp0IbolERDPHSu3zWDz338FekZTKTYhitZQQzMBHOFC0V/CvtqoNpq0nH4LkJBXjeIo3H6wcxeYXcxeWS1F1Bm1n6iQtau6yFEiCQNf0b8nxL4QZwvRKrJZ7aGNQ3bsnLVU/mW79kUsCG/5QQiWSbdgQz6jN67qKPt+4k5bc7l6oJUXZOtSYyyMp5ua2y1fwsyxX+PSLjfL8ol+hT0leKGqmUhtbszO7ogEel+1bzNmOg7G/rz4CtUspsmK/D3gyheEmEHLMAyIdQXBfYy+XVV8EcpwwuALZ/tqrc1T1j5Im+I0PaJbSu/MsrG2uWAbk4QE7Hww7sUiqp3U3Ta9NwHtDr+w5dlRvWg67KghUgaI8NCY/z6MVILRILuoYaBBzDiOygbV80Tg16bVSfqI/4lGR+uH6mP9gWoZEOp02dulUmmNUGJ8rUUackUsFvFjLEb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(31696002)(66946007)(316002)(36756003)(54906003)(8676002)(86362001)(52116002)(4326008)(186003)(6486002)(31686004)(16526019)(53546011)(66476007)(110136005)(8936002)(66556008)(2616005)(478600001)(2906002)(83380400001)(5660300002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YkZPYS9JcFl2WlY5ZW53WE5BWnRUNXNuSFdDaUZwR3krTllXYndTTEVXNXVp?=
 =?utf-8?B?Uyt4a1RTSWxvdWRiaktrSjBlRzloODRwQ1hQdEZPQlRnNVBRT0hxU1pIc0g2?=
 =?utf-8?B?NVMrOVZma1d4QkszMlBqNmVmT3IzNmwyMGF0amJnbHhVK2N2S0xCSmNuWUJy?=
 =?utf-8?B?eWc4ZWljKzBXakRNSm0rWXNuQjZJYTIxN0dURDI3M2JKYWc2a0YwR3dUMlhX?=
 =?utf-8?B?VFdGTEZzcDkzcUM3K3VqTUtVdGJMc2IxNThPV2JFM0NoZUlGanZ0MmxqOUd0?=
 =?utf-8?B?SmxJL3p0S0tkL3lEL0d1QTE3OU9jYlAzV0hDSmVHTDlGbCt2V1JqbFhTZ3dw?=
 =?utf-8?B?OXFTTnBhY3oxZ1N0Yk15V3NUbzJReW1aWXM1REl0cTdLM2dhSDVSUU5xeG04?=
 =?utf-8?B?OWFGZ3lXNnFrUlU0RDU3QlFGb05zMk1DaWdiUjJ6VGpzK08wZjc5REM0WU53?=
 =?utf-8?B?ZlNLMk04SGppS3JZQm41WGVYQjhieTM5anFyRTNoMDRvSDB5Q0I5VHgvbzU3?=
 =?utf-8?B?Y0hMZ3ladlpVaURLMk9oNUUwTjRkVHRwb0w3QlQxai93YXhBNERkemMzTktj?=
 =?utf-8?B?ZGtMbW1HODBvczYzYUk3c1J2dVJMRWt0cjNYVjNFbkVRSWRTcm9wTVlyRW4x?=
 =?utf-8?B?a3hsZ3RIbEJmUXpudDRYbGlDSjBzeUIvLzdtRm40VDBNNDlGQ0dYMng1Q1F1?=
 =?utf-8?B?anJkZmRWRGZQSVkzWVJ2byt6T3Z6K1l0SUF3cG1PUHVTc0pkcWUwbWQ5V1Zq?=
 =?utf-8?B?MXRSOXF6YkNNY3o5K2JMSm1MZlM4RU1NZWdzamVXRDlndjlORWI5Y1huRlB4?=
 =?utf-8?B?OWlhc3NPc2FIMEJlTnNCMUpoWHlIbFhYRmRnWjJuY28yUjB1eXZTYXRtUkpp?=
 =?utf-8?B?cXdKZTRTQ0xodTdSek1uZnd1a1dVWk5GM3p5bVFCNXgrb0FWaUZIWk44MkhO?=
 =?utf-8?B?WWpzV3NjT1pyaDRhektwZGt1dWZuKzQ0emFYL1Zac2hTeHhrdjhJK2JuZXhB?=
 =?utf-8?B?YmU0NEtxY2x6VW42c2ZuajlWM2NZV3FGajJzK1U1K003cGIwb1lEdGNHd2FQ?=
 =?utf-8?B?emVmQW1IWEFaeWhBbGZpZXJpdnBZa21xQVNaWmd2RTBSam1QR2R4ZnJyUHEy?=
 =?utf-8?B?bFNUYTFGU1V2VmdtMDU1aFNPdXQ5YjlkU1lJcFV3YXh2aTRGVFg3MENRRzgr?=
 =?utf-8?B?YXBwWHJTRkk5WnFsVy9EZU5LYkgwWjhZU21DZEZidVNkMkxvL3ZMRzRWYlNn?=
 =?utf-8?B?eS9Pd01LTS84TG5hVDF2TVA3ZHZBcWI0N1FybXd5Z3JOTkRmNXFQaWFaY2l5?=
 =?utf-8?B?cXZ3VWdQV2dJbGUzYngvL0F0MFQvUE50YVFORkZFUklsSlFVKzNtSUU4VWhQ?=
 =?utf-8?B?QjdEaExsRVlvQStkLzlWcmNIdHM1dnB6amlrR2FTUmtBbE9LbmQ2a3RVUjZT?=
 =?utf-8?B?WFdnVFpuQUZyTGZPM2tSVkMrVktraFN4RnQzREErTFM4NTBqS3NpK0pDZTlp?=
 =?utf-8?B?UE1MYjNINUlDVkhpUjd4bC80UkNYeTE0RXAvbTBmQk5HQ3RLd2o5SU9sMzZG?=
 =?utf-8?B?VFNmQlhMRkIzb3JkVExhbkZITURjZ3pMZFFXeWxlL0IzeWdmK1NJNTEySldl?=
 =?utf-8?B?Zk40WmJoM2gwcW9OWk5BTWpLZGZJeDAvSUJIditzaFFMT0UrMGdaSXlPSVF2?=
 =?utf-8?B?aUIwVzRGVmczMHJKUW94MFFIdHE1dk9XTjZJb0Q3cWZIaHRGR1V2dHZ1ZEtO?=
 =?utf-8?B?clVCS0llb09YRGF6c25XalVGTnlpa1NnRlkvS2lXV2paQU9hS0ZpTWdZek04?=
 =?utf-8?Q?tvXNLTB+up7ebhhgsIAaWfaH/RsEEx/rd9Qco=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f1c3c3-4a4a-4286-033a-08d906c9d196
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 02:36:52.6347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8vS4cmyfxBqIySuFDjS91AamawbriHuPNQffE6KzL2vy983HO8viAJKN8l5Uztv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2285
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: i72jDZ9YKzYJhMoGdyMOLlJzCZp05ik5
X-Proofpoint-GUID: i72jDZ9YKzYJhMoGdyMOLlJzCZp05ik5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_14:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104240015
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 5:13 PM, Andrii Nakryiko wrote:
> On Fri, Apr 23, 2021 at 4:48 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Fri, Apr 23, 2021 at 4:35 PM Andrii Nakryiko
>> <andrii.nakryiko@gmail.com> wrote:
>>>
>>> On Fri, Apr 23, 2021 at 4:06 PM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>>
>>>> On Fri, Apr 23, 2021 at 2:56 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>>>>
>>>>>>>> -static volatile const __u32 print_len;
>>>>>>>> -static volatile const __u32 ret1;
>>>>>>>> +volatile const __u32 print_len = 0;
>>>>>>>> +volatile const __u32 ret1 = 0;
>>>>>>>
>>>>>>> I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think
>>>>>>> this is not in a static link test, right? The same for a few tests below.
>>>>>>
>>>>>> All the selftests are passed through a static linker, so it will
>>>>>> append obj_name to each static variable. So I just minimized use of
>>>>>> static variables to avoid too much code churn. If this variable was
>>>>>> static, it would have to be accessed as
>>>>>> skel->rodata->bpf_iter_test_kern4__print_len, for example.
>>>>>
>>>>> Okay this should be fine. selftests/bpf specific. I just feel that
>>>>> some people may get confused if they write/see a single program in
>>>>> selftest and they have to use obj_varname format and thinking this
>>>>> is a new standard, but actually it is due to static linking buried
>>>>> in Makefile. Maybe add a note in selftests/README.rst so we
>>>>> can point to people if there is confusion.
>>>>
>>>> I'm not sure I understand.
>>>> Are you saying that
>>>> bpftool gen object out_file.o in_file.o
>>>> is no longer equivalent to llvm-strip ?
>>>> Since during that step static vars will get their names mangled?
>>>
>>> Yes. Static vars and static maps. We don't allow (yet?) static
>>> entry-point BPF programs, so those don't change.
>>>
>>>> So a good chunk of code that uses skeleton right now should either
>>>> 1. don't do the linking step
>>>> or
>>>> 2. adjust their code to use global vars
>>>> or
>>>> 3. adjust the usage of skel.h in their corresponding user code
>>>>    to accommodate mangled static names?
>>>> Did it get it right?
>>>
>>> Yes, you are right. But so far most cases outside of selftest that
>>> I've seen don't use static variables (partially because they need
>>> pesky volatile to be visible from user-space at all), global vars are
>>> much nicer in that regard.
>>
>> Right.
>> but wait...
>> why linker is mangling them at all and why they appear in the skeleton?
>> static vars without volatile should not be in a skeleton, since changing
>> them from user space might have no meaning on the bpf program.
>> The behavior of the bpf prog is unpredictable.
> 
> It's up to the compiler. If compiler decides that it shouldn't inline
> all the uses (or e.g. if static variable is an array accessed with
> index known only at runtime, or many other cases where compiler can't
> just deduce constant value), then compiler will emit ELF symbols, will
> allocate storage, and code will use that storage. static volatile just
> forces the compiler to not assume anything at all.
> 
> If the compiler does inline all the uses of static, then we won't have
> storage allocated for it and it won't be even present in BTF. So for
> libbpf, linker and skeleton statics are no different than globals.
> 
> Static maps are slightly different, because we use SEC() which marks
> them as used, so they should always be present.
> 
> Sub-skeleton will present those statics to the BPF library without
> name mangling, but for the final linked BPF object file we need to
> handle statics. Definitely for maps, because static means that library
> or library user shouldn't be able to just extern that definition and
> update/lookup/corrupt its state. But I think for static variables it
> should be the same. Both are visible to user-space, but invisible
> between linked BPF compilation units.
> 
>> Only volatile static can theoretically be in the skeleton, but as you said
>> probably no one is using them yet, so we can omit them from skeleton too.

I think it is a good idea to keep volatile static use case in
the skeleton if we add support for static map. The volatile
static variable essentially a private map. Without this,
for skeleton users, they may need to use an explicit one-element
static array map which we probably want to avoid.

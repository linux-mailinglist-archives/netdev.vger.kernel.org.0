Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F7B36B6E9
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 18:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbhDZQfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 12:35:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2026 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233934AbhDZQfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 12:35:30 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13QGYR6Q003854;
        Mon, 26 Apr 2021 09:34:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=IRRy6nLoNneVM0yO9Fi9isZJ0FRTJ9yB0991u4IQzXY=;
 b=H0v7HmKIo7gFzpMRoFigMmjZyqiDW2A53F0LSPPIDQG4likR/CUSSlmzdB/jG2idgAl2
 o4BIK/F5p+cwbxiWjs9IZlcEMV4pi2TTtCYVuNFutpsi7kAEGilIyBw3G4UGwf5cPYo7
 R5XXpZzemeqQMWxooBot7DOqcydoFO8OKR8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38531qxg75-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Apr 2021 09:34:35 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Apr 2021 09:34:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZ7XQaKFHZCilgIS8QaUsvZRWD+XBqJuk+lUkKq2PvR4vI9cCxkCOuBfbQVWRCd+AAGa0w2m2K64UJdMPuytl10IWnDHDe6AwtnMhU6qrqiQvwi0JoKbyS3hoK2x0kUxpd7Z7lXsWxGOzqf+FwNiLMKKdT0hO1eyyq9EDYvb4ahKuq7AwHzRdSrdnVeVbp/GGpm2Gv9nuCujz7KnejcXldEd+XGzuKssr30HhGYyERDT/+e+7spOHcbP0abPUFgmfas7biI5WaSK2mGXpibQVX18lYLFazR0iAdxN0Ga7EiNIQmNamiK6fhv+MLnRugWgo+LoXWfLJ+Udo80zx6sSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRRy6nLoNneVM0yO9Fi9isZJ0FRTJ9yB0991u4IQzXY=;
 b=QyDY2q/AzyGevfFz9krU8xBfjU/xSlpeobPqEeWqzmE3LnMYaXbajELHsjFvoj054lyCVkVZRELnimcf0MiNNAs76nztiLK4+B/3dtJaVH0ycpB6w7VwwT2gDGxPX9r2NGEger8PwUKr7yVexSb5S2DIZCo6rzHSLQDyOs81Z5pir0qf9EKzgORxugeolVA2i378AZmfEyNT/Iv1JDfey3Q+pBVbfLIGcDJah/5aSwpiHOU2cgQKmQRy+HrjBrlJU7CpMoOIz5zD4latppfXxaWuC3fj84RAJCymoRgazRmZ2u3t1slwHRBXhtedzv76uSaU5sriCUv0j3GCAYYCJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4417.namprd15.prod.outlook.com (2603:10b6:806:194::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Mon, 26 Apr
 2021 16:34:33 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.027; Mon, 26 Apr 2021
 16:34:33 +0000
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during
 linking
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
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
 <f9d8328e-6f3e-59c7-05f5-d67b54e6b4ce@fb.com>
 <CAEf4BzahtXOck_TTtvY4bRtnyqEw=Cxd6T0QbTdwF=UH-p-5Dw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <aa994909-8e53-ae19-784d-a315e7d96753@fb.com>
Date:   Mon, 26 Apr 2021 09:34:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <CAEf4BzahtXOck_TTtvY4bRtnyqEw=Cxd6T0QbTdwF=UH-p-5Dw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e445]
X-ClientProxiedBy: MW4PR04CA0365.namprd04.prod.outlook.com
 (2603:10b6:303:81::10) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::12ae] (2620:10d:c090:400::5:e445) by MW4PR04CA0365.namprd04.prod.outlook.com (2603:10b6:303:81::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Mon, 26 Apr 2021 16:34:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 363a07a1-30e9-45de-3c62-08d908d12c70
X-MS-TrafficTypeDiagnostic: SA1PR15MB4417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB441772656AE9B8F4363D0D95D3429@SA1PR15MB4417.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8DTC8BHBd5/YUdWARhWkoYLX/VYYtkZkUDXMBwyuXGnBO4jZzRiS6ba0X0VWrutpLW4Yx3DzlFlyV+AXvwBLsOV4biKXxnOTMGOJdN3Z12ZL6ftVUYcZOHqFyN19zgMuNkrJPcaWyFIei3euKhSLSlFyhoGfiqxCknD147FoXAwMLUILQObF+CAuYNyZAwbutUPOMCsgks+IPwYfFpcnk7CTYZAsM5ESayXxPPTXfNHVofQg+g0Q13sWiIY6n9lZzvlSGxCDHRfW7/VjGsyqmfFL9t9lZ8ACjlUkVssoHJLxSsHU4hHr5Weo4cnsncY5G9JUsDQJmRL8z1AQNxcC0570IFJgtYoLD5YYcunXdAPVWKWkdPfLQFR+aFsCx50m3dsScPGkP8igDRs4cHIJRqWfkFHznI1p+ObIEFAqg6QGF7/CkHJmzx3NuFnsnWGowTWtIs75RryDV4PgKB+JDySnCfkg7YYUtu0NgrHiq1nHas3ntQmmhXqUdF42ArfErJHjWqh0HlFgHUrnCPbTtbol4LSwss90oahzydSEr6GjL6RIZQdnrf4h9Ar9K25P1raZHdtTmRQyMfaMMw+vkcY4VO/xZDTUCCXojyOO0KnidGzYU3gEvjooDuU2zxefhMdovTPOvKFn2cG/sdjW1qwa6BE0+4xxeX+P/+9OQufMvm2w4wivf3ri21R+UieH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(478600001)(66476007)(66556008)(83380400001)(66946007)(8676002)(8936002)(31686004)(316002)(186003)(5660300002)(52116002)(53546011)(36756003)(6666004)(54906003)(31696002)(2616005)(6916009)(86362001)(4326008)(38100700002)(16526019)(6486002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R0U0RW02UFpvUUxvVUdOOEhPVU5DNGk4RjQxT2pHQTNORkFSTTFieGVpaHl3?=
 =?utf-8?B?cWY3M3NqTUo2ZE4yYXhWUnFpb243bHg5b0dlbGhsYXI2MWxOWkZ2YUtxMG8w?=
 =?utf-8?B?NnM5MEFaVWJ4ZGs3K1YzaXpCZURRMUkwc3BzNmFJczFJeEZZWGRxc0ErVFN5?=
 =?utf-8?B?M3k0eUM3R1ZPK1pxSVF2V294MEZBaFJMUEs0WVlsekc5bnRLWnRTcisrdEpU?=
 =?utf-8?B?a281eXMwVVNrMnNlSWRkbldlM1VnMnh3cHhudUMzeFppK3dZNWUxNVEyejBB?=
 =?utf-8?B?N2tmbDB5K3FMZnBzQTd5b0RXaThRYm5DSG1pTnVUU01sZ25ycU5NUERBQ2I3?=
 =?utf-8?B?RkJBdnVsV3V6NUpXNDhqREdWdytObkhvQkpqMElkNVY1bGd4WUsxb0xQVkN5?=
 =?utf-8?B?ZGZHUTNjSE05bW5FVm5JWDBCN0cxRWhIMXVCd0RQdEZUbXdkQUNVRTVMVTlH?=
 =?utf-8?B?NGJNMXczVHhSdWZNRHM2NC9rVS9YM3NzelpLY0l4NVVJK1I0MFV3MXlUTE5X?=
 =?utf-8?B?SitWaW1BeUxaNHJzNnJZbXp2R29SdENRYk1yN3F3eW5QeFdIMzZDL3E5Vmh1?=
 =?utf-8?B?MnVqUkIzVFliRnhTUDBxd3NyR2Q4UlhjZUpNUmIxYmZrUEM2czlPbmdIRU1q?=
 =?utf-8?B?RmMxYkd3ajUxU2NnNnRucUVUeXVKaTlrdGJqTnVkU2dQYWNVUGdZMi9tQ2NW?=
 =?utf-8?B?dThkNSt0clBXYU5lb0hFMEpXbTluK05pNG12bjlVdGdtNVdRVEZURVkvWnB0?=
 =?utf-8?B?ZzBINURtRTJxVHJnR1oyVXFaZzFnZ09qdEd2TlhYZkY0T2szalRBNjZxQXlo?=
 =?utf-8?B?SGZ2bkF4MHlSY0ZxcVljWks1d3hZSEFYWDRtRk92cDl3M2JUcjBaTlhFbjFB?=
 =?utf-8?B?WTJOMmdJUHFqNTFmd2FzNWZpbjFoOENyMTZ2Z1hsYWsxMGg5aGhmOG4xR0xV?=
 =?utf-8?B?dUZhb09ucGdHVFlnUkdYMEtiazZWN1E5TDQ4ZkIxRDM1N2RybjFBVElaSnRn?=
 =?utf-8?B?dVJ4bFJ3S2ZPM0NZTUw4ZldQSmQxakpGOG9XNWozbzA2bkEzYUJ1TUpGcFBF?=
 =?utf-8?B?ejBPQjl4bitPdFY2RG56WUlhUTYzb2VBVGt4YllUWHRodDlQS0xxa2lVWGI5?=
 =?utf-8?B?czYraHNCRDE3UjZ1VTBtd0pJNkMxYjJGZ0d0cWpVakRHZEdBdkFiWTV0U2ls?=
 =?utf-8?B?SU9jVTdTY3dEam5kbEFXWUlZNitlVTZwdnRNNThrUzNxMEM0aFRvK2dieE0z?=
 =?utf-8?B?UjNRTG5JK3VKbCszT0Y3WEJRaFE1QlVCalRrTlNVTmxoSlNGV1RJeVlMdE14?=
 =?utf-8?B?NWtSd0lyZjJJR3h6VTIyQUFiSXBTKzlWZWU3VmZmTGV1WS9xbzhZSTcwc2gy?=
 =?utf-8?B?SkpmM0NCeGlSM3VOZGt4aXE4ZFBmM3FIdGdKQkdDSTA4bUw4aGF0aGU0eTg2?=
 =?utf-8?B?VzJCUXhPamZGUW9VOUg0QWh3QkFIZW01NmRVM21rdk5WM3FsQXpxUVB2OUpY?=
 =?utf-8?B?OHljRXcvem1helMyZnRUbVVkNE9DcUQ2Z0xMNjF0cUJrc0RnN2kwQ2ZEKzE2?=
 =?utf-8?B?a25JZEh6c3htcTdVS0Z1M01DTHlrQW5zYkwvQ013WHZkTGZ5MTlCam1IbFNl?=
 =?utf-8?B?WU1CcXUyKzhlNVU4Z0ZQTjZwTEVPM3JCazY0d3g3b0k2Wmw5b1VDZHExRURU?=
 =?utf-8?B?eUdwZ0xMUEh4L2ZwY3dGaWEvVEcvQWpHdXovUmZEUW1WZXpoa3VOVFM5ZHRV?=
 =?utf-8?B?TWwrQjhDbGtwaHNqek5wL2NBK28rUTYweUZoSFpiRWlKU1pESDZ4Z2I2WGt3?=
 =?utf-8?Q?+KAl8wmQiFJK4y2ZfqxoeWzbPo8KLbdOLAH30=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 363a07a1-30e9-45de-3c62-08d908d12c70
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 16:34:33.7385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F7YWhPPm+tqvt6sDUNku9UyvB9EZKGX1uLAWhmUUpvtRexFfkhrFMFIKMDFuLFO3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4417
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: acFbiv6MlAK0kIbJ1KOMbHEmxTAt_uRL
X-Proofpoint-GUID: acFbiv6MlAK0kIbJ1KOMbHEmxTAt_uRL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-26_09:2021-04-26,2021-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/26/21 8:45 AM, Andrii Nakryiko wrote:
> On Fri, Apr 23, 2021 at 7:36 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 4/23/21 5:13 PM, Andrii Nakryiko wrote:
>>> On Fri, Apr 23, 2021 at 4:48 PM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>>
>>>> On Fri, Apr 23, 2021 at 4:35 PM Andrii Nakryiko
>>>> <andrii.nakryiko@gmail.com> wrote:
>>>>>
>>>>> On Fri, Apr 23, 2021 at 4:06 PM Alexei Starovoitov
>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>>
>>>>>> On Fri, Apr 23, 2021 at 2:56 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>>>>>>
>>>>>>>>>> -static volatile const __u32 print_len;
>>>>>>>>>> -static volatile const __u32 ret1;
>>>>>>>>>> +volatile const __u32 print_len = 0;
>>>>>>>>>> +volatile const __u32 ret1 = 0;
>>>>>>>>>
>>>>>>>>> I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think
>>>>>>>>> this is not in a static link test, right? The same for a few tests below.
>>>>>>>>
>>>>>>>> All the selftests are passed through a static linker, so it will
>>>>>>>> append obj_name to each static variable. So I just minimized use of
>>>>>>>> static variables to avoid too much code churn. If this variable was
>>>>>>>> static, it would have to be accessed as
>>>>>>>> skel->rodata->bpf_iter_test_kern4__print_len, for example.
>>>>>>>
>>>>>>> Okay this should be fine. selftests/bpf specific. I just feel that
>>>>>>> some people may get confused if they write/see a single program in
>>>>>>> selftest and they have to use obj_varname format and thinking this
>>>>>>> is a new standard, but actually it is due to static linking buried
>>>>>>> in Makefile. Maybe add a note in selftests/README.rst so we
>>>>>>> can point to people if there is confusion.
>>>>>>
>>>>>> I'm not sure I understand.
>>>>>> Are you saying that
>>>>>> bpftool gen object out_file.o in_file.o
>>>>>> is no longer equivalent to llvm-strip ?
>>>>>> Since during that step static vars will get their names mangled?
>>>>>
>>>>> Yes. Static vars and static maps. We don't allow (yet?) static
>>>>> entry-point BPF programs, so those don't change.
>>>>>
>>>>>> So a good chunk of code that uses skeleton right now should either
>>>>>> 1. don't do the linking step
>>>>>> or
>>>>>> 2. adjust their code to use global vars
>>>>>> or
>>>>>> 3. adjust the usage of skel.h in their corresponding user code
>>>>>>     to accommodate mangled static names?
>>>>>> Did it get it right?
>>>>>
>>>>> Yes, you are right. But so far most cases outside of selftest that
>>>>> I've seen don't use static variables (partially because they need
>>>>> pesky volatile to be visible from user-space at all), global vars are
>>>>> much nicer in that regard.
>>>>
>>>> Right.
>>>> but wait...
>>>> why linker is mangling them at all and why they appear in the skeleton?
>>>> static vars without volatile should not be in a skeleton, since changing
>>>> them from user space might have no meaning on the bpf program.
>>>> The behavior of the bpf prog is unpredictable.
>>>
>>> It's up to the compiler. If compiler decides that it shouldn't inline
>>> all the uses (or e.g. if static variable is an array accessed with
>>> index known only at runtime, or many other cases where compiler can't
>>> just deduce constant value), then compiler will emit ELF symbols, will
>>> allocate storage, and code will use that storage. static volatile just
>>> forces the compiler to not assume anything at all.
>>>
>>> If the compiler does inline all the uses of static, then we won't have
>>> storage allocated for it and it won't be even present in BTF. So for
>>> libbpf, linker and skeleton statics are no different than globals.
>>>
>>> Static maps are slightly different, because we use SEC() which marks
>>> them as used, so they should always be present.
>>>
>>> Sub-skeleton will present those statics to the BPF library without
>>> name mangling, but for the final linked BPF object file we need to
>>> handle statics. Definitely for maps, because static means that library
>>> or library user shouldn't be able to just extern that definition and
>>> update/lookup/corrupt its state. But I think for static variables it
>>> should be the same. Both are visible to user-space, but invisible
>>> between linked BPF compilation units.
>>>
>>>> Only volatile static can theoretically be in the skeleton, but as you said
>>>> probably no one is using them yet, so we can omit them from skeleton too.
>>
>> I think it is a good idea to keep volatile static use case in
>> the skeleton if we add support for static map. The volatile
>> static variable essentially a private map. Without this,
>> for skeleton users, they may need to use an explicit one-element
>> static array map which we probably want to avoid.
> 
> I agree, `static volatile` definitely has to be supported. I wonder
> what we should do about plain statics, though? What's your opinion,
> Yonghong?

I think we should support plain static variables if they survive the
compilation. The 'volatile' keyword is only to prevent compiler from 
removing the static variables. For example, for the following code,

static int aa;
void set(int v) { aa = v; }
int foo() { return aa; }

the compiler won't be able to optimize "aa" away. Adding "volatile" to
the definition also works, but seems awkward. We should support this
case even if user doesn't add "volatile" in the static definition.

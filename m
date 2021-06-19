Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDCF3ADAD9
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 18:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhFSQXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 12:23:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25828 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232640AbhFSQXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 12:23:00 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15JGFCZx020808;
        Sat, 19 Jun 2021 09:20:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=WnVxsMOxOYd3FIuAv52CXAxkCbptem89q80l+T1DXxQ=;
 b=ZSWrnyMTMNjPD5gzm9vJHVuRXkgH3n7cLP3tru5Oascq/9Z2U8ZUPdvDc5DccLAWpoOd
 sKAtkfFJSVUJPfEfHaG4a0um8mtq4AP5GcPG+oEg+rIilaib2K2CJrD863/Go/8X2ac/
 xUyeN+D+jsVl+WAmDM4YPjB4zhBHQX/cj4Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 399eb01474-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 19 Jun 2021 09:20:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 19 Jun 2021 09:20:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juuRx6qgqO1gDBtAU7x8dTkssR9WWrBvJ5cZGYhl8JZjhFsvHouZ9nywIRTER9YChc7luod4pH1svsH9MvP20SnKypHvDP9/fYoKp8wZUjc2oD7Gqe6vca5ioIxQeUi3IHQFS4FeOda3JBYTQkusyclBkZF1k04x/TXoliElghhcd/6fawGu5vDg37xuFkRhiIR7cMmffxPFzZw0dOznGNy1NJiBoqHgZlc0bGOOr8P/BsMD4X9+icIYEFgMd1a+2wBE8/M3Bl3Jaalj6WtBxk+NpqpyE337iQPHtw/IDFDd1KezHmAq7/epCpddmASD9ArXZHyV/YqhQa+W42kLWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnVxsMOxOYd3FIuAv52CXAxkCbptem89q80l+T1DXxQ=;
 b=HWr4u+WslFiPZ0UnD6sOk1+bHhLpf4fBE6jeF9HzBphetkn9OFCWcmuSQiJq+TUvTQcQ7KlCVNIhdJAm4mOyyyh0LxH9C+yHT6uK66LFBmzxPyPDkGszMbA0QLLE9Yii5iwGy6XFCdcCDjkOnJDbCA/Z2SDWfjqitC8lmsMM1S77c/i5qPg8A1xYmUHOJP5qVa1mlx9vO9ezAMmB/kboTZbBypHFLHoxCGEQbPGIKl8IcPHYTe99DMzN/ubMjMM5sytmNjuqANl0k5aqKtqh8fs+zW60k5oaPqqWVVDEhAkDMD2gVdPzli+aOVdVtF6NzXkb1XTLvevfN7PiNKdSNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2478.namprd15.prod.outlook.com (2603:10b6:805:1a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Sat, 19 Jun
 2021 16:20:01 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4242.023; Sat, 19 Jun 2021
 16:20:01 +0000
Subject: Re: [RFCv3 00/19] x86/ftrace/bpf: Add batch support for
 direct/tracing attach
To:     Jiri Olsa <jolsa@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <CAEf4BzaK+t7zom6JHWf6XSPGDxjwhG4Wj3+CHKVshdmP3=FgnA@mail.gmail.com>
 <YM2r139rHuXialVG@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4af931a5-3c43-9571-22ac-63e5d299fa42@fb.com>
Date:   Sat, 19 Jun 2021 09:19:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <YM2r139rHuXialVG@krava>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:4564]
X-ClientProxiedBy: BYAPR01CA0003.prod.exchangelabs.com (2603:10b6:a02:80::16)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1349] (2620:10d:c090:400::5:4564) by BYAPR01CA0003.prod.exchangelabs.com (2603:10b6:a02:80::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Sat, 19 Jun 2021 16:19:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d09fd9b-2854-45f2-7952-08d9333e1674
X-MS-TrafficTypeDiagnostic: SN6PR15MB2478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB247832447F88FB48DE69209DD30C9@SN6PR15MB2478.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zJG7C7S/rcc3wWGTKFuVrkREmhKldhBaFzz7ciKjXrY+VXloHTfQvmc6JOpMPxayfcL0tU2iqzE5Lrxa7RzfTLuDfenPpFKymX/++v0nCsf53ZfCWJiRvLlAP2oQObxtqvzIvajHofaE+QrCc+lNbDxxYfiCbKLAM70695/O6W0DcAZlC+1eDFAFgxyiVH0pStPl/VCUuf3OCyiTJkNikf+wLfTTQz6a9yS1SAiJRIp62yLjfqDHWlRG/eekV7Y0+0rpfKxCpXUOnZZJUz7I88CuhLKkfyc94RrZBNcxyl/zXo3fylsI1P2zit22kQogU8NEqXHQ77hVOSykT4g5RHTJ9bqjz1zByoFKccExTH+XM9iBeU7bRlowsXODfADWZxYQkW06pE1EJy5TOEtmNPGpMwYRK6BxSt6wpzhXxdmafvlL2Sdr47/YWNL/8HwjWBCfga2I4Ldsp386F8hvU3I/TgHyBpVZKwggfbo775Z4JroXVitS+QbtUj5RK+9x1f/1oQtYPwAP3xg9Uyumeb59YDOJ8qgUKigTn6bkX6W13wWey9Sk/VLPxZBLlYi2luRTe3o8LL9/HKkDiElnql8/F9x/Hax9WerDaFCOMKd8muhf2mnPCyg/XLnnOpt1fiAdZdyeUYr+u9AJQICctBmy8QD4oK1yRdsuEu6ug2s1KhSfttZ/TaQAfDTA0+/m6jWtSFgfi5fzjhEGct36/PJz5pTyRl/FRHHSaWD+rbFz90/lWN2h40P2msKx5TCP7+wiUa4l56LmZjr/5TfZlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(83380400001)(36756003)(4326008)(31696002)(478600001)(2616005)(31686004)(38100700002)(966005)(66476007)(66556008)(66946007)(316002)(7416002)(54906003)(186003)(110136005)(5660300002)(6486002)(8676002)(53546011)(16526019)(8936002)(86362001)(2906002)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFo2R2F5emlRSVhJbUN0MXVDWHBWVmxrekJRUnJpU2hJRUtjSnFKZm11aTF2?=
 =?utf-8?B?aTIvUGZFYXk2c1RnNVRaNjVqSVdUb2xFTFNVclZLZ1hPWWVwdlJNUjV4a0Zm?=
 =?utf-8?B?OEVFenZpUUJwTUxTdEFTWklNZWdQTlc1bFVPa3NOcDNHOGNuTVp2M0dWM0px?=
 =?utf-8?B?ZHFNNFM3aXk1d3MrZUsySWpWRS94cEZ6djRpRXIyOFpONXY0ZVgwUG5FdWxu?=
 =?utf-8?B?MUdtZUFLcXgwcFBlVzJLbW13TVJ0WFZiMnBaSjA5NE5zcmxBUEx5aWJWU08v?=
 =?utf-8?B?RmYwRzNzZTFnSVdlcU4rbzlQUE5CQ2h0SkNncS91aWoxUlhPTEg0RkU3WVBv?=
 =?utf-8?B?cG81NzJ1MDVvSmtqd3FFQnAvRzhCQy9Ia2hOZkdUeVE3Y0twOU1EVW44bmpk?=
 =?utf-8?B?c1RvejNBQ3lkamtUZzBvaUFwUUV4RmhkeExSZTRiVHlRcFR6L2VrVXFUbGN5?=
 =?utf-8?B?amtNa1lSaHJ2aFJsQ0p1WFJnSHhyVEJtZytPbUJQQzFjdDFmeWpxSjI1cHBw?=
 =?utf-8?B?WVVCcXU1eUlmWVJtZEJUSnJhbzY0NjJHZXRyZlkrMWhBam1rVldsT1k1Zy9x?=
 =?utf-8?B?THljbVJwbXhxelJYRjc1bFUxZ01ZdU1LWGE5UFVSWWtYdStzTGt1Mm5Zb0Jn?=
 =?utf-8?B?S1B5ZituNFNPZjU4aU5Tc0hCdVhKeVAzaWExbkVMckN6V0FLOTlvaEZqbDMr?=
 =?utf-8?B?dDlmZ2lSVU4rMVh4Ty80RlE2d3ZhbnRJOFlRa2ptaHdSOTlCa2tqZ0NFS2tt?=
 =?utf-8?B?bWhvRU8ycUpXUmh6ZVdPeUtGN2haYzRxcjQ3Z0VsLzhTM0FmL2VJOXp3VVN4?=
 =?utf-8?B?dVRUaklzc0dIQk1uTHpaSmRCVGZCY1dqUTZyblppTmpyS0pMdm9QV2VTemZz?=
 =?utf-8?B?T09MTExKcndVWnFKVXpHcURLV285dEhQWTNzbXZ6dXJObDRIbGxIMW85SndW?=
 =?utf-8?B?eXFZMFV4dFhRRU0zMERmdHZSMkF1WlN6VlBOcTRxVXVCVWkzYlZaY3hUN3dM?=
 =?utf-8?B?VW90Vmo5TVU2SUhZZFN5V1FSS2VLUTdtbS9qVXFranEySHFtMDFJdXFPdVkv?=
 =?utf-8?B?bnVFdU90OEVoeW1ndGhScC9JUVczbStpSktIRERXL05sdk9PTlp2TUlwVTZD?=
 =?utf-8?B?TWUzZThOaURGNTlDZEhyVVpIS3JtS2IzN1h0QjBMUXB0cHVFNjZKUEkyYkg2?=
 =?utf-8?B?ZFdueWpUemZLS01KK3ZFNHFETkZVTVY2VFFWQzZ4M3NYWVk0SVcrRGsweTlQ?=
 =?utf-8?B?OFVzVjZiL2dOR0pDaUhGN0h4TlJMYWNqa3VmV2ZsOE1tbGRieDdUK2lnWmpi?=
 =?utf-8?B?aUUralRYb1hWVUpsMGNUei8vUkU0SUJLQjZ3eEFCZW02TDF3eXhiWUhKeTZH?=
 =?utf-8?B?eW0xdXAyd2h2ZXorT2k4c2J3REk1ektFTDdJVng0TU55U3VCc3ZpdUlkNWlQ?=
 =?utf-8?B?UzNoc0dGbWF5RytLbU1pUldZUFVWbXN2a2FmT3lGY1ZSS3NlZkdzTDBRZzNl?=
 =?utf-8?B?cDJoSVlOdnFkWnNhWmxtZzM3Ym80Mnh3RzV0UzNYOHFMd1VmRmJhaTdyUklL?=
 =?utf-8?B?OFdIZW50Q3pQRGVCbDF3cEJmT2kzcjUrRUhQWlo0R1l2aXV0U2E3ZGFPaTJZ?=
 =?utf-8?B?bHkxaE9RU2t5dENTQjRldVZST1BaYXFWaEZnVStKL2krUkYwWU9xV3lLYkFv?=
 =?utf-8?B?aWErT0JWTkxRV1UvSjE3MjZMdUMrK3h6SHFmcHp6OUo3WHlwNVBYdDF2WGd0?=
 =?utf-8?B?WFl1OENITGFCZ2cvcjZKSlpGejd6Zm1GMWcrOEUya0xjS3o1c0NkRnJtdEpN?=
 =?utf-8?B?b2Q5am1hNFdrNFdDMjFlZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d09fd9b-2854-45f2-7952-08d9333e1674
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 16:20:00.9625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFS6ACh+2RqQiKh89Q84QW5cwutCQYkVPvGTd42yU/Pcn9VWlvAdzdcukSN7M+BW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2478
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: VmCF6NskusvuHdiX-QpDYusfTs8jKu0S
X-Proofpoint-ORIG-GUID: VmCF6NskusvuHdiX-QpDYusfTs8jKu0S
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-19_13:2021-06-18,2021-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/19/21 1:33 AM, Jiri Olsa wrote:
> On Thu, Jun 17, 2021 at 01:29:45PM -0700, Andrii Nakryiko wrote:
>> On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
>>>
>>> hi,
>>> saga continues.. ;-) previous post is in here [1]
>>>
>>> After another discussion with Steven, he mentioned that if we fix
>>> the ftrace graph problem with direct functions, he'd be open to
>>> add batch interface for direct ftrace functions.
>>>
>>> He already had prove of concept fix for that, which I took and broke
>>> up into several changes. I added the ftrace direct batch interface
>>> and bpf new interface on top of that.
>>>
>>> It's not so many patches after all, so I thought having them all
>>> together will help the review, because they are all connected.
>>> However I can break this up into separate patchsets if necessary.
>>>
>>> This patchset contains:
>>>
>>>    1) patches (1-4) that fix the ftrace graph tracing over the function
>>>       with direct trampolines attached
>>>    2) patches (5-8) that add batch interface for ftrace direct function
>>>       register/unregister/modify
>>>    3) patches (9-19) that add support to attach BPF program to multiple
>>>       functions
>>>
>>> In nutshell:
>>>
>>> Ad 1) moves the graph tracing setup before the direct trampoline
>>> prepares the stack, so they don't clash
>>>
>>> Ad 2) uses ftrace_ops interface to register direct function with
>>> all functions in ftrace_ops filter.
>>>
>>> Ad 3) creates special program and trampoline type to allow attachment
>>> of multiple functions to single program.
>>>
>>> There're more detailed desriptions in related changelogs.
>>>
>>> I have working bpftrace multi attachment code on top this. I briefly
>>> checked retsnoop and I think it could use the new API as well.
>>
>> Ok, so I had a bit of time and enthusiasm to try that with retsnoop.
>> The ugly code is at [0] if you'd like to see what kind of changes I
>> needed to make to use this (it won't work if you check it out because
>> it needs your libbpf changes synced into submodule, which I only did
>> locally). But here are some learnings from that experiment both to
>> emphasize how important it is to make this work and how restrictive
>> are some of the current limitations.
>>
>> First, good news. Using this mass-attach API to attach to almost 1000
>> kernel functions goes from
>>
>> Plain fentry/fexit:
>> ===================
>> real    0m27.321s
>> user    0m0.352s
>> sys     0m20.919s
>>
>> to
>>
>> Mass-attach fentry/fexit:
>> =========================
>> real    0m2.728s
>> user    0m0.329s
>> sys     0m2.380s
> 
> I did not meassured the bpftrace speedup, because the new code
> attached instantly ;-)
> 
>>
>> It's a 10x speed up. And a good chunk of those 2.7 seconds is in some
>> preparatory steps not related to fentry/fexit stuff.
>>
>> It's not exactly apples-to-apples, though, because the limitations you
>> have right now prevents attaching both fentry and fexit programs to
>> the same set of kernel functions. This makes it pretty useless for a
> 
> hum, you could do link_update with fexit program on the link fd,
> like in the selftest, right?
> 
>> lot of cases, in particular for retsnoop. So I haven't really tested
>> retsnoop end-to-end, I only verified that I do see fentries triggered,
>> but can't have matching fexits. So the speed-up might be smaller due
>> to additional fexit mass-attach (once that is allowed), but it's still
>> a massive difference. So we absolutely need to get this optimization
>> in.
>>
>> Few more thoughts, if you'd like to plan some more work ahead ;)
>>
>> 1. We need similar mass-attach functionality for kprobe/kretprobe, as
>> there are use cases where kprobe are more useful than fentry (e.g., >6
>> args funcs, or funcs with input arguments that are not supported by
>> BPF verifier, like struct-by-value). It's not clear how to best
>> represent this, given currently we attach kprobe through perf_event,
>> but we'll need to think about this for sure.
> 
> I'm fighting with the '2 trampolines concept' at the moment, but the
> mass attach for kprobes seems interesting ;-) will check
> 
>>
>> 2. To make mass-attach fentry/fexit useful for practical purposes, it
>> would be really great to have an ability to fetch traced function's
>> IP. I.e., if we fentry/fexit func kern_func_abc, bpf_get_func_ip()
>> would return IP of that functions that matches the one in
>> /proc/kallsyms. Right now I do very brittle hacks to do that.
> 
> so I hoped that we could store ip always in ctx-8 and have
> the bpf_get_func_ip helper to access that, but the BPF_PROG
> macro does not pass ctx value to the program, just args

ctx does pass to the bpf program. You can check BPF_PROG
macro definition.

> 
> we could perhaps somehow store the ctx in BPF_PROG before calling
> the bpf program, but I did not get to try that yet
> 
>>
>> So all-in-all, super excited about this, but I hope all those issues
>> are addressed to make retsnoop possible and fast.
>>
>>    [0] https://github.com/anakryiko/retsnoop/commit/8a07bc4d8c47d025f755c108f92f0583e3fda6d8
> 
> thanks for checking on this,
> jirka
> 

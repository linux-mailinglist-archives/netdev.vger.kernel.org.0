Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEFE3ADF86
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 18:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhFTQ70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 12:59:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3556 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229600AbhFTQ7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 12:59:25 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15KGt8bE024489;
        Sun, 20 Jun 2021 09:56:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/5ZROsOLQMJ95uvpMBVVuzkI+36wy3g+v27XET0jh+g=;
 b=RkWQrA2zjIX5hbIEQm8PAQNo+q5IPiiHAaD/8rOVOtK8T2n9qBR2aCG6HQkGm4Sh+5O4
 rhRQ6RjGTUdRdSRoHNICpyz+F+Cq9bdxWEBRqBTJTOnPRK4rME5O6dl0H50IGVgaJdI/
 HU2XxXewFwi6z2zzJ9hHeq7M8vsbRhnKnHY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 399e9qmr32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 20 Jun 2021 09:56:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 20 Jun 2021 09:56:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecFz2cRvd/G5KW/fuIVBzPGF194cVkgmvPU1ka+Xry4de6Zu/5ryd4i0T5GRqsZQrZWa3eIvmbX2TASVCSmKHEzoZzqv9kvgC52RueBu6T+w0uJ4Ms75vuD573WuCkytnJuJaFk1tprzn7AJVUZ684/0AQCPBze3RqwZ7XSlQ8P/BAO1qjiYA9pCIDrXd8hfQFExHQPAJ9mlGb1mL1eLuuP4KOs7hC939f/9CfyIDo/7pnY5dRxT5mqo/8xpqODjBrGrp1VCuNOKrIGl0JlONYZm8Q1mZGUACt4sgD8NDP1X9SoOA5mmQFzXmVZ36qU08b3GdAxhm7CiaAJm5eX7bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5ZROsOLQMJ95uvpMBVVuzkI+36wy3g+v27XET0jh+g=;
 b=KZqU3QyVHIJ681PYFXihtBHLyo8hcq59xz942+PTu8z0X71jOiNo2oOfO7oKaH13dTAufycRIH7JFtL1UsMa08PECbi7aGkWCQAMGzd0FX1kn/9bGzhciPd/lgUKms+gpezA3eeVsxHNHPhZrlBKtu+2EJHBKtz2lGZ+eYLVj/iNr4OYznDnoj0huKk3/Svg278yCDLN4bexx6yimJYnOHJIczgGe+oKm1Qhr5RbXjaFHSEGzs4lAIIQuf+46C2l/VWEpLhaV5b6MHI3y523YhqSlFoVDoA4QUcU0WBrXAfekO8EgyN0qgtOc9Wj+JxTYj8Jy0E9IBWIF4+yWKt30w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4338.namprd15.prod.outlook.com (2603:10b6:806:1ad::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Sun, 20 Jun
 2021 16:56:23 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4242.023; Sun, 20 Jun 2021
 16:56:23 +0000
Subject: Re: [RFCv3 00/19] x86/ftrace/bpf: Add batch support for
 direct/tracing attach
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
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
 <YM2r139rHuXialVG@krava> <4af931a5-3c43-9571-22ac-63e5d299fa42@fb.com>
 <YM4kxcCMHpIJeKum@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e8f7ab9f-545a-2f43-82a6-91332a301a77@fb.com>
Date:   Sun, 20 Jun 2021 09:56:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <YM4kxcCMHpIJeKum@krava>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:7bdd]
X-ClientProxiedBy: SJ0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1349] (2620:10d:c090:400::5:7bdd) by SJ0PR05CA0026.namprd05.prod.outlook.com (2603:10b6:a03:33b::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Sun, 20 Jun 2021 16:56:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8337e42-39d4-4800-cd9e-08d9340c55ad
X-MS-TrafficTypeDiagnostic: SA1PR15MB4338:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB43387A555EC6389CFCFAE7EAD30B9@SA1PR15MB4338.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lVum0d8t6W6gQsxzIugaWQtiRk0N1TQYEUNR7WnRWiVc0WqUuhYlu+jzd/qOq+TtPkoDrJoliw6DmgHNfwuNMhM02BbpGdSnuufjAtErYRPzbYXz5UzPiCnVr4FiipWHMiQHixPQxWIMQFm6tCaotmghDmgp/e2qCQ3//ZB+mUHtce3lwnsqNBiF9aLwmajUTRdU7VeATp7X09eGTmfMG4fCOzYQba2NeCi6HQSA2G6vPP9foK4AYnSEKrTIyLZJmh1hDNBhWrVvi14yiVaSONcGBPAXoi7eoYsXc4B/XA8+1uWESCl6zIsQQHrUVde74ohO0auRYH88pHYVFUWB4ovpsC6ubwj4E/hQB7kxv4n2Pr/rKxZQ9GhshPWgHsgaj1JWdxHfo2VVB6vEbfctCVzANuspfnLwQtqFmXuyb4obMK0ELzYooPjOYjfgJ77YqOxyIeGeA3P/U2MiRo8ezjeocmwFGXeFcTdn+QxVRqg6ETxKAsNZZD4oThtgtMyNH3aSeUE/TBvisnx1+hfofi0RBDLfEPuaFpidC7vrJYmaQEm58cvI0aWsiYL9nvVQ8tMb3RKDi9U9gTKz0yRl3aNkRrc2YNe473IXXBG+i3Bc/hX0TN+zj4sCmhhChQzVV5FVPTSujdMPFIBVrOJtuxDI5TD2l6SOwWMZ68wQgA0GFYwI/+7KD31WrNoJr2yd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(38100700002)(31686004)(7416002)(83380400001)(31696002)(316002)(186003)(16526019)(478600001)(52116002)(66556008)(4326008)(53546011)(2906002)(6916009)(86362001)(6486002)(5660300002)(8676002)(36756003)(66476007)(8936002)(54906003)(66946007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akRpZjhwTGlOM1JrSG1TN21vQ0JkRXVwSDRBWWgyUklGVTViYWNuakZBR0Rl?=
 =?utf-8?B?Y1V2Ri9CelQ0amNraTlJRUtOZXdiS3BxUFE5TWtTaDhLWEV4NE9kS0dWeWxP?=
 =?utf-8?B?aU5wL2w1TkRCRmMrRG9PS2dmT3F2Q2VHbjNMeXRQampOQVFRbXZ2STEvVmp6?=
 =?utf-8?B?QTQ4VG5vYVc2R212MWJGZU10eEVGR0I1ZFRhQnNVUGJNdmtyUXRyMnpLZklh?=
 =?utf-8?B?emFrRU1Yak1OYnlkeTFWVEE2M1ZyRGRDbUFlQWg1ODczdkhnUm1vRytqeUdW?=
 =?utf-8?B?N1ZkSzJJYkRhcVdVNUhUUVhEMUdqUWsxR0FnZVJ5NzhsVlBtRGdZYWY4UzFN?=
 =?utf-8?B?cjFQS3Y0cVZBZldrcERkS041c2JWWFpud0VuK0xEVytncSsyRzVSWUZoRjYv?=
 =?utf-8?B?VVR4Vzg2OVQ4T2RIbzY3Zmp1VGpyWk9LVUMxK0VuREJLM05iYThoTUROa0xD?=
 =?utf-8?B?bVFNQkRLSmowNktNcTNHRm5nUURpbEZqZ1J4bUtkN0VxZ2FoM3JXeHpzclpz?=
 =?utf-8?B?OU1UQjlEUHlQcU4rTVdqR055YWNBd3R6dEJHc2JaNG16TzJEYVBndE1ncVpN?=
 =?utf-8?B?SWNRTm9uREZkVXErb3pGay8wdk1YVTJ1YjRMSTk4dUQwM3prajV5L3VNa0U2?=
 =?utf-8?B?K0Y3MFhOSllqS20rbVJrZEptMlJJbk44RWwzNEV3aU9JN3lBMjZualdyWms5?=
 =?utf-8?B?d0NvQmRyb3dmNEVXTG13NitsYlExK3pNb2oyL0N1dXcxalVIc0lhWW1OdENI?=
 =?utf-8?B?WTkzUmpMVGxqTk9Fdi9mc1VxaGVyWXNSQURHMWJ3Z0laQzUvZWVsYlVOckxa?=
 =?utf-8?B?SkIyaXRxMGFCN2ttZVFXdTdKNExXNDBRbTVlRHB0SkorTnRwalNlMG9zWFhE?=
 =?utf-8?B?U083dTZxaXppMkRrQVl5MjVVVUFnLzN4d1Vhc3FYdWdQRHFHS0JjYlJmT3Bs?=
 =?utf-8?B?YzZJNk1zdUt3aEpXSHpyL2lPY29pNHBJdmZYb3p6c1pIZlRjajFKNDUvcThZ?=
 =?utf-8?B?M0Z6eWZjWkVoaUkyV0xDTUUxM0NMVzA1eng5NE1oQXA4N1NMUmEwY3N2QXZG?=
 =?utf-8?B?SkdIU0l2K1llY0lrQlZiMVpFZVlCS3dRRWVqL2NwU0ZtaVhibDNFRUVtNEVY?=
 =?utf-8?B?d1FCMVZSVGZMb21COXlVcHFwK1pTWWdDNkpNd0FMQ25GK0E0YUtsVVpLMWp5?=
 =?utf-8?B?T2Y0OVJKcC81Z0JYak1GYTkyTEYweVdMMUVzVFhGMGtWWSt2UzZRVTFaT3lq?=
 =?utf-8?B?M3orWW16Ym1rVDJFZkV2Q1FjTkJ5Y3JQOTUrOFpHYnRBNE9pK3dkam1RUUFu?=
 =?utf-8?B?MVJZaThwS0RjZnRRWE1NSFJETlNZZ1FlYjJFeXZmbCtQclR4UjBjejVjdTFm?=
 =?utf-8?B?Ym1NNXNTR3dpSk9Wd3lrVVMwdG9rTUhRSDNLWlFrU2lUYW1kZzloM3orNE9m?=
 =?utf-8?B?aXhMOEJwNFlwcmE0c2Z2bXp2T2FVcEpwT1Azc2FxYnVNdWNsWllDalptTHhy?=
 =?utf-8?B?QXlySDlxQndoZU9oTkVYd0N3bGc5U1NYQVp1QkVaWXFQb1FZYlBwWGdpQ2VG?=
 =?utf-8?B?bVFJT00yNDR4dmZpUDBCbmhEdXowVk9iOWRPZGZrc0NVU1I0T08yOUtxSDdE?=
 =?utf-8?B?OTBVcjRZWWViTjJLRzdIWDV2MVhrbjUzNUl4WlBodXBBMThHNndPTnlRc3NR?=
 =?utf-8?B?d3FCUVlCa0pCYzNSTzE4SVJJWW55UE5LYlgvWjk0VmJiK2tPSmZ0bTQwQWgr?=
 =?utf-8?B?ZDZSMjQ3UTZHUTNnV2w1WkxhbjJhQ3RoWmVDRHdjVVlWbnd6QVBmbHk5MDJ3?=
 =?utf-8?B?RUQ1NCs5N1ptRkM5d0hLZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8337e42-39d4-4800-cd9e-08d9340c55ad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2021 16:56:23.4189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OLlo+oSge5BSZUm/PCTtyCHQu0gkXFEX4t6/E85B08qI/cnvNIhqjJ7Z75r9gsT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4338
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: GwLIOLTeZLYQdFLYv6iC-qPEKdiSAucA
X-Proofpoint-GUID: GwLIOLTeZLYQdFLYv6iC-qPEKdiSAucA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-20_08:2021-06-20,2021-06-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106200123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/19/21 10:09 AM, Jiri Olsa wrote:
> On Sat, Jun 19, 2021 at 09:19:57AM -0700, Yonghong Song wrote:
>>
>>
>> On 6/19/21 1:33 AM, Jiri Olsa wrote:
>>> On Thu, Jun 17, 2021 at 01:29:45PM -0700, Andrii Nakryiko wrote:
>>>> On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
>>>>>
>>>>> hi,
>>>>> saga continues.. ;-) previous post is in here [1]
>>>>>
>>>>> After another discussion with Steven, he mentioned that if we fix
>>>>> the ftrace graph problem with direct functions, he'd be open to
>>>>> add batch interface for direct ftrace functions.
>>>>>
>>>>> He already had prove of concept fix for that, which I took and broke
>>>>> up into several changes. I added the ftrace direct batch interface
>>>>> and bpf new interface on top of that.
>>>>>
>>>>> It's not so many patches after all, so I thought having them all
>>>>> together will help the review, because they are all connected.
>>>>> However I can break this up into separate patchsets if necessary.
>>>>>
>>>>> This patchset contains:
>>>>>
>>>>>     1) patches (1-4) that fix the ftrace graph tracing over the function
>>>>>        with direct trampolines attached
>>>>>     2) patches (5-8) that add batch interface for ftrace direct function
>>>>>        register/unregister/modify
>>>>>     3) patches (9-19) that add support to attach BPF program to multiple
>>>>>        functions
>>>>>
>>>>> In nutshell:
>>>>>
>>>>> Ad 1) moves the graph tracing setup before the direct trampoline
>>>>> prepares the stack, so they don't clash
>>>>>
>>>>> Ad 2) uses ftrace_ops interface to register direct function with
>>>>> all functions in ftrace_ops filter.
>>>>>
>>>>> Ad 3) creates special program and trampoline type to allow attachment
>>>>> of multiple functions to single program.
>>>>>
>>>>> There're more detailed desriptions in related changelogs.
>>>>>
>>>>> I have working bpftrace multi attachment code on top this. I briefly
>>>>> checked retsnoop and I think it could use the new API as well.
>>>>
>>>> Ok, so I had a bit of time and enthusiasm to try that with retsnoop.
>>>> The ugly code is at [0] if you'd like to see what kind of changes I
>>>> needed to make to use this (it won't work if you check it out because
>>>> it needs your libbpf changes synced into submodule, which I only did
>>>> locally). But here are some learnings from that experiment both to
>>>> emphasize how important it is to make this work and how restrictive
>>>> are some of the current limitations.
>>>>
>>>> First, good news. Using this mass-attach API to attach to almost 1000
>>>> kernel functions goes from
>>>>
>>>> Plain fentry/fexit:
>>>> ===================
>>>> real    0m27.321s
>>>> user    0m0.352s
>>>> sys     0m20.919s
>>>>
>>>> to
>>>>
>>>> Mass-attach fentry/fexit:
>>>> =========================
>>>> real    0m2.728s
>>>> user    0m0.329s
>>>> sys     0m2.380s
>>>
>>> I did not meassured the bpftrace speedup, because the new code
>>> attached instantly ;-)
>>>
>>>>
>>>> It's a 10x speed up. And a good chunk of those 2.7 seconds is in some
>>>> preparatory steps not related to fentry/fexit stuff.
>>>>
>>>> It's not exactly apples-to-apples, though, because the limitations you
>>>> have right now prevents attaching both fentry and fexit programs to
>>>> the same set of kernel functions. This makes it pretty useless for a
>>>
>>> hum, you could do link_update with fexit program on the link fd,
>>> like in the selftest, right?
>>>
>>>> lot of cases, in particular for retsnoop. So I haven't really tested
>>>> retsnoop end-to-end, I only verified that I do see fentries triggered,
>>>> but can't have matching fexits. So the speed-up might be smaller due
>>>> to additional fexit mass-attach (once that is allowed), but it's still
>>>> a massive difference. So we absolutely need to get this optimization
>>>> in.
>>>>
>>>> Few more thoughts, if you'd like to plan some more work ahead ;)
>>>>
>>>> 1. We need similar mass-attach functionality for kprobe/kretprobe, as
>>>> there are use cases where kprobe are more useful than fentry (e.g., >6
>>>> args funcs, or funcs with input arguments that are not supported by
>>>> BPF verifier, like struct-by-value). It's not clear how to best
>>>> represent this, given currently we attach kprobe through perf_event,
>>>> but we'll need to think about this for sure.
>>>
>>> I'm fighting with the '2 trampolines concept' at the moment, but the
>>> mass attach for kprobes seems interesting ;-) will check
>>>
>>>>
>>>> 2. To make mass-attach fentry/fexit useful for practical purposes, it
>>>> would be really great to have an ability to fetch traced function's
>>>> IP. I.e., if we fentry/fexit func kern_func_abc, bpf_get_func_ip()
>>>> would return IP of that functions that matches the one in
>>>> /proc/kallsyms. Right now I do very brittle hacks to do that.
>>>
>>> so I hoped that we could store ip always in ctx-8 and have
>>> the bpf_get_func_ip helper to access that, but the BPF_PROG
>>> macro does not pass ctx value to the program, just args
>>
>> ctx does pass to the bpf program. You can check BPF_PROG
>> macro definition.
> 
> ah right, should have checked it.. so how about we change
> trampoline code to store ip in ctx-8 and make bpf_get_func_ip(ctx)
> to return [ctx-8]

This should work. Thanks!

> 
> I'll need to check if it's ok for the tracing helper to take
> ctx as argument
> 
> thanks,
> jirka
> 

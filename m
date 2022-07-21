Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1323957D31D
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiGUSQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiGUSQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:16:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873F18AB12;
        Thu, 21 Jul 2022 11:16:32 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LG8kL9008841;
        Thu, 21 Jul 2022 11:16:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=yenDaMJACw314ACpk5AfWcDFiqjGF+wzXyECwIp9jlo=;
 b=O9wpPQ3l+Dd0dqVVwJTULXVV/o4UVHB1l9kcH1pYv7kQHURM25po6pwDb+wUuYEzqYMG
 oXOkE/CrSLfVLnnTqJIxLr3upeamFuWfN71pb7CLCe/uTPmJKNgryp3D6i1NqQaGcf7+
 3hucQD319Vi7STrXzEfk60PyeoZOMcalxFc= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3heyc8vesg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 11:16:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6Q+V9cz+fduUhmnveY0DBqs4b0p5oN6GXvEnMqF4OVI++LpG/Rlydmw4l1ldmfoQZDBSnJwt9M8ZmfFvfIl26Iw1SpV4DxvwBZHAVyA8rGf3Dgbhp8n5iUHJY2fN8TMk145LYETKvxd1SHtlVd4NOpCCFMwcmvpRqUH75gkzuyE12lx5UcCQat2d4a5YBmNo+QTcdLyPzXfUEluKrZvBBhKvRSRogItAbgR80xmJtgnMLlQhC3p5LTBPxZ3r/y03FTipkuUhcwbZ8OrVq9x9ajOFx4ll0OzVu2ntDRJRSI9f/zgFG/nN/Avo5pA68gaQYSL5zgF5i43EnJ9z9VR7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yenDaMJACw314ACpk5AfWcDFiqjGF+wzXyECwIp9jlo=;
 b=oZv0UnfUvGNGVnBn6L89gD24ZQIb1iRpvh/6BswvQ+IJBEv9eNZN31/5uVYAcw6Xt22NQkXcyA+LJvhMOIportKMMwe2OX9LN7mr7JberYDvHjVdKWbL0V5XsHgDNxBInOWq465sDlNLbqYul/vH1CRoO16xZKGeybngafxUjDHUSyalAJAZ2Yn0OO0TmqC1WnxzKGUUHW/EjknBsVBPSlU6+ED5p4ZZabmEF9m79bbF2R7yU5A6j+MYiKJzcTecMreEF5twmzxx1clfSmGFbfjICJ7FnN8GzV5Q5D+HKO+x/b+jTmZhWKZcW56Bnc2/ng6dm8Q4AnhTIIsv5kza5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN7PR15MB2276.namprd15.prod.outlook.com (2603:10b6:406:87::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 18:15:44 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 18:15:44 +0000
Message-ID: <6935de9f-49da-7703-55ae-241a8b838c6c@fb.com>
Date:   Thu, 21 Jul 2022 11:15:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v3 4/8] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Hao Luo <haoluo@google.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-5-yosryahmed@google.com>
 <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
 <a6d048b8-d017-ea7e-36f0-1c4f88fc4399@fb.com>
 <CA+khW7gmVmXMg4YP4fxTtgqNyAr4mQqnXbP=z0nUeQ8=hfGC3g@mail.gmail.com>
 <2a26b45d-6fab-b2a2-786e-5cb4572219ea@fb.com>
 <CA+khW7jp+0AadVagqCcV8ELNRphP47vJ6=jGyuMJGnTtYynF+Q@mail.gmail.com>
 <3f3ffe0e-d2ac-c868-a1bf-cdf1b58fd666@fb.com>
 <CA+khW7ihQmjwGuVPCEuZ5EXMiMWWaxiAatmjpo1xiaWokUNRGw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CA+khW7ihQmjwGuVPCEuZ5EXMiMWWaxiAatmjpo1xiaWokUNRGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0006.prod.exchangelabs.com (2603:10b6:a02:80::19)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ec1ec4b-cd32-4441-f17f-08da6b4506de
X-MS-TrafficTypeDiagnostic: BN7PR15MB2276:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DqAR8ixpvZtWAw4S7LIbj5D2ICwA5ujuB3RC/dGaGMz8jO/98+BX/R5sM/lyaxZjaNHjnSVSfRWe7gmbhFNpa3Q5+aCpuhfdVF/c83E8/5ASWqxvMf3YZ+caWwVU7HM0l7wKRRD/UL85FC/3phOdLvDLHtoEYq7mnruD9GJ0r9vpFFw5MJh/Sa3i29qLpw7lUTGNQ0PQ4k2NCoSdJUi6PRE4shqibW/P8BU+aDNikNEkyuFmcSdyA5zmpUu1PEaU3hAEZUn7V4hXqWou8ZSPgaHQ28ju+8KCUKtlmO+ZCNQ0DGF/vvvu+SRgnyx8dpy5atr5JtDH/jjAzSrECnraZTSZaFWQjkXdEC1rnsH+cPn0nhgBc9Czic2Jb/O7oc5kRv4LVfJjdF7gFFxS1rR4RdTfHcWafIksnHvNDfvYXGmXhb4YNCPGCnVDflGGSUmmTDyj3W0pHh4FGyjzVOMspwgUJZdre3nz+8NpUt+fv8QkhBcpaiA72A64/Efz1/4+Wb7qR61aT7GzTBVOb9gtIYGODtDeu2mM4AuYQtnU+p2poE1axIye+StDi9WeZfkkeCINQQDX0wJei1IA1H1V3gb7n9vDuThHPy3OCpg/QFv0GLMfKddpvQJRhxnFtVAdidFsCAcrILbKBHaeidIVrsq3nsXVUIOloVSWCZakhONJSjzdamritH4X/P588byu5rvLHEPJjs0J+Hi7T2+H5DRbyryt0X0XTEjNAhPT3WqaaVUgzkfmKBr0mHjcuKNUBHWuco4w4cYI3ax6h0Uk/pcpW1MB23i0xqWtrlwFVgoXCURR1WkP/ZGoeNUSi6iKF6P78Z3hPDe/HGAZtDMT7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(38100700002)(86362001)(31696002)(66556008)(8936002)(4326008)(66946007)(8676002)(66476007)(2616005)(7416002)(5660300002)(83380400001)(2906002)(6512007)(6506007)(53546011)(186003)(316002)(6666004)(6916009)(41300700001)(31686004)(36756003)(478600001)(6486002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnpObC8wSTZicXEybk4xNEFkZ2V5amxjd21KWGRUR09rMVFpUE8vR0FkYmFI?=
 =?utf-8?B?cW9RUDY2WC9RKzRQVm1wVk8xaGhkQ2hyZWt2M1QwR2xFdnFvNTlmaFQ0UDdX?=
 =?utf-8?B?MUNCY0pRb0JuZGZydG1teHBUZDBwbFBuT0JOcXRRY1NRcEZTdXd3WTI2OTkz?=
 =?utf-8?B?eVBPN0FtQnp4V1lSVk5oWElPbFpkR3lsTWw1UlRoTDZYNUwzMzg5aFlyWmtW?=
 =?utf-8?B?MWxNei92dDBWQ3Y2aTArWll0NVlsUjFPTDJwdFBjKzlndGFBN0psZjVFalFk?=
 =?utf-8?B?eWdZUGFaNlRIWXQ1aWZabzI0UGlQWVkzVFUrK09mekRsQTRmRVlNMXZGMWdx?=
 =?utf-8?B?Y0V1ODNLeUhVNFFTczYycHh4dEtEeXh1M0o2dWw3by9NNzJycXl3bmEwMjNO?=
 =?utf-8?B?eHFGVE5GUzdsdkdOUVhxYkVvR2s3SUJJS3NNTExWcDlxdVA2V20xVWpDMjYr?=
 =?utf-8?B?NzZ4N1NXSTFjNzZSa2RqVWh5T0ZYdVVRdi9vckFVbU0vRWE1VktOSER1ck5D?=
 =?utf-8?B?SnNSVng2eXBURmdDVURTc3dLam5ZWGZBQldHUWFQZTVadDUyYzZkbVR3RmtP?=
 =?utf-8?B?a3ZvMWV5SHFXME1qWGdpNGVxbkJVNFU3ZG9NZWFJanlvSHRWaHdna3pvRTkx?=
 =?utf-8?B?T0dveVZTYy9Ua2twOFNFWGxDeGVURG5qTXNwajcxb2RDWmN5QWtadnNXbEJQ?=
 =?utf-8?B?aExYaG4vUXBvVTdZbUorb3AxcVdCMjBUS2dMTUhEbW9kdnJ1Lzh3OXNreEoz?=
 =?utf-8?B?cG9aWG9GZ2NDZTJuYURSeUNXbGpSRTVCcXFqc1lFNGxxWTZDeUd0WDc5Ly9y?=
 =?utf-8?B?Vkl4TzdIOFJ6N2JQMkoxWjVoTnRlQlhOYlhXMldtTzNKSnJUUVRaMVhOV1RL?=
 =?utf-8?B?bWg4ZWhocGpoTjg2L3lSR1VrTHo1ZytJWEc3NDExbGJxYml5bTAxZ0daRzhk?=
 =?utf-8?B?N3RWWEpORXk0alVNVkg2aDByNkdmOFNzbWphY2hQN2FtQ0dZUjN1WmRkb2Fl?=
 =?utf-8?B?UDdaYm1kOVRhenNxYTNXYXFNejNuOXVaelRlWXlhMWJ3WGNGeTNvU3ZHYmdD?=
 =?utf-8?B?QTEyUzNIUDRPazk2YVBJL0Frd1B4U094Mm90S2NSSDRQMHVyMDArQVZPRjBu?=
 =?utf-8?B?aDdNd0t6L3dmUkhCYUkzTlZRMzk2WlVEdHlvckxhZ3VubDRCdUQ2VkZ2QWJB?=
 =?utf-8?B?c09XaDhjNWhWTEw2eFRINjVNTDArWVJpa056MlJhdG1lYlBSeTBkOGV0ZkhG?=
 =?utf-8?B?bDdSWERzNW9LaUZDMzFkZVp3bFFwY1kyR2J2dXJpa25mRnBxc3JjOUZlSGQ0?=
 =?utf-8?B?RjBVZW1ZbHZzZFFCaS9xbXlHZ08vdmFWWXhkYzNGMnpZVUFsMmZ1M3V5cCtS?=
 =?utf-8?B?Ui9QZklKcFdiNkJYbEQ3SU82cEhkSG9PcWl1TnpTSWtnSittbkFPdS9wZStw?=
 =?utf-8?B?d1pXVjJwWTFaWlllaWVEKzJjTEFaVkVZb21YcWVVZjZORXRQeCsweisyYStT?=
 =?utf-8?B?WDYxZjV2aEd3azNITVVvbnlFdVBFUXBrcVVEZGVadGJpUGRiNThFTjNSOXJJ?=
 =?utf-8?B?N2ZUd3VLWWlDVEVocU8xVVRkeVBmTVJ2bThrNnhkUlJ5ZmhlVDRaL3EzaUVk?=
 =?utf-8?B?WCtoR0M5UnFmTjlaS2FYZFZhbEpaMmkzakRtZEx2Yzc1b0dYOVdtRnVDQjli?=
 =?utf-8?B?cGxXTHhVaFpkTTBSdnJCZVBIOGxhdzk3VmdnOEx6RHpDKzBxN25BYTBDY3BE?=
 =?utf-8?B?ck9obVEwZlBuRGFRd2JuOThhVHlEUW03UStMU2xRZ0lnN2JZd1NYMGNDUmxC?=
 =?utf-8?B?Wi9lNXVveGR4eDExdnJ1b1MyNlhYdkcwcnB0SHBxMmdudjN4YStVZjdOZkNr?=
 =?utf-8?B?YmN6OEFiZmoybnBsLzRuYWVZemFJckc0bnY1eUd1VzM2Y2lzTG5lZjF5cGth?=
 =?utf-8?B?cGJZK1Y3ZkNSc0VKNktwaVRtVkpKVmk0akVnRmQzNUE3NnNVZW00UDE0K3ky?=
 =?utf-8?B?YkZYc0hoeGpXL3VSL0grMDNHdDViZFR6VytnSjZIWmtzdW5KS0E2cmhOLy82?=
 =?utf-8?B?YnpPRHdVRkRHcm1JaGZadFcrNitFNUpjRFhReUdXZnNWcnMzSHJ5NXBCYXQ3?=
 =?utf-8?Q?IxGsSgtAJEiDr8H/kYNHz1zbs?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec1ec4b-cd32-4441-f17f-08da6b4506de
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 18:15:44.0410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pSMeKwU1XNSuj40X2ExTSE07IvKcPCwsbrSHJdsgKbCokjjdhzu/sDQ2qpyvUh56
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2276
X-Proofpoint-GUID: N_9b1HNRnsc3EbSLJhNYgSVesWlCQIC3
X-Proofpoint-ORIG-GUID: N_9b1HNRnsc3EbSLJhNYgSVesWlCQIC3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_25,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/22 10:21 AM, Hao Luo wrote:
> On Thu, Jul 21, 2022 at 9:15 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 7/20/22 5:40 PM, Hao Luo wrote:
>>> On Mon, Jul 11, 2022 at 8:45 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>> On 7/11/22 5:42 PM, Hao Luo wrote:
>>> [...]
>>>>>>>> +
>>>>>>>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
>>>>>>>> +{
>>>>>>>> +    struct cgroup_iter_priv *p = seq->private;
>>>>>>>> +
>>>>>>>> +    mutex_lock(&cgroup_mutex);
>>>>>>>> +
>>>>>>>> +    /* support only one session */
>>>>>>>> +    if (*pos > 0)
>>>>>>>> +        return NULL;
>>>>>>>
>>>>>>> This might be okay. But want to check what is
>>>>>>> the practical upper limit for cgroups in a system
>>>>>>> and whether we may miss some cgroups. If this
>>>>>>> happens, it will be a surprise to the user.
>>>>>>>
>>>>>
>>>>> Ok. What's the max number of items supported in a single session?
>>>>
>>>> The max number of items (cgroups) in a single session is determined
>>>> by kernel_buffer_size which equals to 8 * PAGE_SIZE. So it really
>>>> depends on how much data bpf program intends to send to user space.
>>>> If each bpf program run intends to send 64B to user space, e.g., for
>>>> cpu, memory, cpu pressure, mem pressure, io pressure, read rate, write
>>>> rate, read/write rate. Then each session can support 512 cgroups.
>>>>
>>>
>>> Hi Yonghong,
>>>
>>> Sorry about the late reply. It's possible that the number of cgroup
>>> can be large, 1000+, in our production environment. But that may not
>>> be common. Would it be good to leave handling large number of cgroups
>>> as follow up for this patch? If it turns out to be a problem, to
>>> alleviate it, we could:
>>>
>>> 1. tell users to write program to skip a certain uninteresting cgroups.
>>> 2. support requesting large kernel_buffer_size for bpf_iter, maybe as
>>> a new bpf_iter flag.
>>
>> Currently if we intend to support multiple read() for cgroup_iter,
>> the following is a very inefficient approach:
>>
>> in seq_file private data structure, remember the last cgroup visited
>> and for the second read() syscall, do the traversal again (but not
>> calling bpf program) until the last cgroup and proceed from there.
>> This is inefficient and probably works. But if the last cgroup is
>> gone from the hierarchy, that the above approach won't work. One
>> possibility is to remember the last two cgroups. If the last cgroup
>> is gone, check the 'next' cgroup based on the one before the last
>> cgroup. If both are gone, we return NULL.
>>
> 
> I suspect in reality, just remembering the last cgroup (or two
> cgroups) may not be sufficient. First, I don't want to hold
> cgroup_mutex across multiple sessions. I assume it's also not safe to
> release cgroup_mutex in the middle of walking cgroup hierarchy.
> Supporting multiple read() can be nasty for cgroup_iter.

Right, holding cgroup_mutex across sessions is not bad idea
and I didn't recommend it either.

I am aware of remembering last (one or two) cgroups are not
100% reliable. All other iters have similar issues w.r.t.
across multiple sessions. But the idea is to find a
*reasonable* start for the second and later session.
For example, for task related iter, the previous session
last tid can be remember and the next session starts
with next tid after last tid based on idr. Some old
processes might be gone, but we got a reasonable
approximation. But cgroup is different, holding
the cgroup pointer with an additional reference
across sessions is not good. but holding cgroup
id requires to traverse the cgroup hierarchy
again and this is not efficient. Maybe other people
has a better idea how to do this.

> 
>> But in any case, if there are additional cgroups not visited,
>> in the second read(), we should not return NULL which indicates
>> done with all cgroups. We may return EOPNOTSUPP to indicate there
>> are missing cgroups due to not supported.
>>
>> Once users see EOPNOTSUPP which indicates there are missing
>> cgroups, they can do more filtering in bpf program to avoid
>> large data volume to user space.
>>
> 
> Makes sense. Yonghong, one question to confirm, if the first read()
> overflows, does the user still get partial data?

Yes, the first read() and subsequent read()'s will be okay
until user space receives all 8KB data where 8KB is the
kernel buffer size. For example, if user provides 1KB buffer
size, the first 8 read() syscalls will return proper data
to user space.

After that, read() should return
EOPNOTSUPP instead of return 0 where '0' indicates
no more data.


> 
> I'll change the return code to EOPNOTSUPP in v4 of this patchset.
> 
>> To provide a way to truely visit *all* cgroups,
>> we can either use bpf_iter link_create->flags
>> to increase the buffer size as your suggested in the above so
>> user can try to allocate more kernel buffer size. Or implement
>> proper second read() traversal which I don't have a good idea
>> how to do it efficiently.
> 
> I will try the buffer size increase first. Looks more doable. Do you
> mind putting this support as a follow-up?

If we cannot finalize the solution to completely support
arbitrary user output for cgroup_iter, we need to support
EOPNOTSUPP so user knows it should adjust the bpf program
to have less data to user space through seq_file. For example,
they can put data into mmap-ed array map. Please explain
such a limitation and how to workaround this in commit
message clearly.

So yes, to support buffer size increase through link_create
flags or to support a better way to start iteration after 8KB
user data can be a followup.

> 
>>>
>>> Hao
>>>
>>>>>
>>> [...]
>>>>>>> [...]

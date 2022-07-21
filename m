Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2A257D13D
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbiGUQR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiGUQRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:17:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A7E8C17B;
        Thu, 21 Jul 2022 09:16:06 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LG959t000793;
        Thu, 21 Jul 2022 09:15:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=crSb/D02EAQWHXrlytNzRppEIZpLQ9Wq6QrTmuyMV7E=;
 b=NEroBHJmLjtzx4Hg3GhEPr30JqAwADRkCR7JGoBbtekGEavxZaaYxYSSUdOJ3Ybj3FA9
 bAV1WaHre7iqoJpEbfgeVEt751oBuyExhqfpUv7Qot/l9BF8Y6cGedVqgvg94AGX4GrU
 8p/biAsBsUAAwmk1GvRnud4EWRUJEi4U0jc= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3henhb712x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 09:15:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnDFUdsxjvXhPiYtEIY/7tLazE3C9eJRL/caLN09Kkvu4otYGjFlFuktRiKBV0Zy0T0IB9ef1tcVk5z6P06S9PD9mOKyCHr8E8nDwW/EdkstBTFTJqcpzV5V/dGIaWmGLduZZvLVL3r/eKuhQ+yhh+W0VpqXsVlhUFuGUzgsvQmMaZZ9teCQlkNGRiKBQdlsfXIPq5SlyR1etxqPj9YwKwA1EU0C3tTqqXjhCLFJ+P1Ja7TVl3cGMjgTSl7WntJaAXH9WEizA1kEW7hXSIFPvN/agORrdZmoxnpXBfDMkEC+bceCVdm0v3yhwFn6wXZvn0T8A6IbcRTqPS6k99JWjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crSb/D02EAQWHXrlytNzRppEIZpLQ9Wq6QrTmuyMV7E=;
 b=N/7LNsRXDXfIAmjSrnoxdrdyKQNXut6/dp8jNJ3O+L9klAptVOKN9/8DT5/wAG5IMCCBp29n5h2UZGii33ZZ8TGjhdRZ6WxI5dZWxPAqXCh/6aVlQGlfFkEii8XuQsCcsL0tFXi+wo6QcPRPMiVhcl+QesTg8HlcFVBf2efquSWW8ELVb89h1qvseh5mCY8Jv2zxkIN1rWb44GJkpafBiXaEkrjNl/n8riuIr7POQblwXdvB6qBR1FYjX9IGA5wX2247+zk/RamhWrvqDavL0rVo6yrdo0Y45irz+G08s7f1mBsTktjqYYVyvX0pRkad3S3ALYqyQawiiPBqgkoh3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MN2PR15MB3021.namprd15.prod.outlook.com (2603:10b6:208:f4::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 16:15:13 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 16:15:13 +0000
Message-ID: <3f3ffe0e-d2ac-c868-a1bf-cdf1b58fd666@fb.com>
Date:   Thu, 21 Jul 2022 09:15:07 -0700
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
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CA+khW7jp+0AadVagqCcV8ELNRphP47vJ6=jGyuMJGnTtYynF+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:208:d4::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ff52a17-8544-4fc1-8403-08da6b3430e5
X-MS-TrafficTypeDiagnostic: MN2PR15MB3021:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: doTbkgJwzMi6Fl1nywcqeZYAQYepBy4fe1TNTGpgf5wvbG0kyrx/fCIRm5Q2tXxxel6/HPIlE7KxXYoturZ3D5P8QgTpv40AOWD1SRBmBZcRnDopbKrf/Pt+P0H7822c5Wfzqg3gbVm4QkF1XagFZc0xic1dzTMprMQlK2oRlfJP8e4cWRhYyAjDl4+Bd+w1rPAjaJThAsESndN/80EYqabbTxr3UsqA4FgEhEFuS5xWC7JTuN/3MHVo+8RRQ9DVWWK3FXH98Yf6zYE26PoTAtCGqv9xV9FEuVOokD1U9cv1Nc68BbPXSAxC5e+MYMlA6yTaa3dut0UmSRAMOMUaRI7QA4xAlwTp8h/JcbiamafG7u1S5oeecVwzuErtnJ/RNTsC0dcEUvRCDOIxx8tC1liwExHxj6T69btMtSzxy8Y5Gph3Npqmg5gv0RUhykhdv5KfVKRF2PJwbwRDnwp5CgiGUKwjaNrtKjiR1fAJNL6V8yKbQjacs6lC6T2AJBL+qqQTM/ybLQgrZhCksKLa7zdpd6YhMBuzlpMQ18MwX6xkUXBokeoTHY+0EgSwqC4ePENOqyKmFFAj+/YnR5UDFk5Mo8B1t0hKaI7UgRG2nwgnpU2Ehlz25dFgeVYmYsAkS9ZsHR9fiJRl5F3osEauNzV1u9U6zGqOKucf6aY/nRxxvDEqUsxAhWy5l09xF8Cuh/PSB6/jU+y9XTRIFplleSWcRkASZzR4PD4lS33imUZwRRXcvi+mfFKKsB2oV08OGXcgiu5DOsD1NNxmctmUyLDKI1fbytuoyPD7w+P+quIvNVNKOgbHuTv17p/oQTwH1TT7y1BcEk5dY8FJMtnf4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(86362001)(31696002)(66946007)(38100700002)(83380400001)(8676002)(54906003)(66556008)(66476007)(316002)(4326008)(6916009)(2906002)(8936002)(36756003)(6512007)(5660300002)(6506007)(6666004)(53546011)(2616005)(41300700001)(7416002)(31686004)(6486002)(478600001)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEtSTEFZZ0ZZeXBEME9kYzFnYk53N1dUVmphaTBCOEc3dGhQTG9TT09uRVdI?=
 =?utf-8?B?ZUk4MnZyVzZsZjRJWW0yV0lyQTVmWHIrdnpvNCtzeWovMW5Wd0g2TEg0S3Ey?=
 =?utf-8?B?M1U2OHJqR1pCYkJNWnVma0hNSHAzd0RpZ2JwcXVOWm85QTlUYVQxUUtSZHBr?=
 =?utf-8?B?YzRVbXVqRnhIV01PaWNvM0RkeWpzTklPWkRKYTdsZnlJQWlmYUhqVjgwaWlX?=
 =?utf-8?B?V0dUM2srczg4K2hEaE5Wc09kRVV6bmllYXM3K29lNTR0MzRTVVFxWHlMb3M2?=
 =?utf-8?B?cVM1VkxES2UzNHFtTjcwcytpR2xZSjNBQXNaZDN1WjMrMXRYQTVvR081c0pn?=
 =?utf-8?B?dUZSdm5aY3NJK0RmUlVpVjBOUEdYVzE1RW92OUFsNXRETzhyamJNNFRXWTBi?=
 =?utf-8?B?TTlKZEJoNFhsc3E1Vmh2VVFNTFpsdktyVkJxQmN1QzdTVm04THdwbzB6Mk5h?=
 =?utf-8?B?SFB4OEFqWHNJTFJDMGwrWHI4UnN1MVFkdmVBTWM2UW5JQ1JYVHJxNndEaVlD?=
 =?utf-8?B?VnhMM3dla25OalhvNm9rN1RtNkZkcUZybGk1ZzUvMXM2UmljcFNPT2ROTlVL?=
 =?utf-8?B?eUtiUGNtK0dyb2lhWk9rOFVBQUhtMC9Zc0NmcjFJWHRoZVNuMm1oMFhlcXZh?=
 =?utf-8?B?NWM4MFNrcHdGL1ZjS2t4b21nSXU2blJmYTRiQUhEb1p3aGxFckRUVUwxT1dx?=
 =?utf-8?B?V2J5ZUloTTZZMU9HeWk1c2ptNE1LdjZXRkhkclF2VWpKckZ5cC96NWRhYjFw?=
 =?utf-8?B?M2RiUWhiWVZvZENoSW9vb3pTWjY2VmZHakFJRHhKZXEvYnVER0lEQ0dFVnlR?=
 =?utf-8?B?ZmphUERycTlrYVB4eXdpNGgrUEVSRTRVblgwOVF6Mk1GRXVEM25jNE1EL0VR?=
 =?utf-8?B?REluUWNKR2dxMEs4dGpBTGFDVXJ1YXBkeXRneityVTN6WW9TM3dYdVJvYldv?=
 =?utf-8?B?NlA2NWdqL09pWEZ3U3pzVlNDZVpRSFpFMHVhejdReCtRNWlXYzcydkx3cHM5?=
 =?utf-8?B?MnhWVXBUZUxQOTdLcG5vREFQd3VINnNxYTQ5Q0xvR3J5MjFtcFcxNlpXbU1p?=
 =?utf-8?B?VW9ucFBHZ0Rpcm1saGw5YXV6cUF1ZncrK1hqNjFvUERadHRnM1RUU1o2WUFJ?=
 =?utf-8?B?WGkwWFNnc25DNXpBRTcySWhLaytJMGxINWtsRTFKREtoRzdxUldDeDFiR1l4?=
 =?utf-8?B?QjFlMGJaanIzZjV0UW9xMk9JZGhmVEVqd0c0UExzS3pNVmVhTFFKdWU2REt0?=
 =?utf-8?B?Z3J5dEM1emJNUU5aZ0Nwby9LdE9qQStLelRzYnJzK1hTSTRRRTc0dXJwZFB0?=
 =?utf-8?B?QmdJL1UwR0xJQm4wdTlDcUtQZ2pvTXRmWmdaZ2xHcmFYTTVndzZCdFVaNlc2?=
 =?utf-8?B?R0tLNUhFbzU4bVpKUlpyRWxIY3NhRnBMYXc3RmYrd2d6eTZQeVM0M2JieGt4?=
 =?utf-8?B?ZlNEUkNWSUQybklSNi90Z3pVTVhkL3VUQzBVcGhFY1lZY1grTkw0dUVhRnFF?=
 =?utf-8?B?Zmc2ZzRqK3NobHRjM1Q1OFNWaWo4UEZhKzNCU2xPYVRmYmxYVnoxTXowbTZD?=
 =?utf-8?B?RmxiMHNBSHpKK0VBcUV6bTRXRjAxWSs1aHZ1a05PdUttTU96dFU0ZDhOR1or?=
 =?utf-8?B?c3RBOEc4Q1N6VjdsZEhVWXN2dlRqZUpiOWY0TWx0ZFc2ZEVkQklhdXY4SGFX?=
 =?utf-8?B?NkFwcGVyK25teXNLU1hVN2Zjc1RuVGZmcHUyZ3c2M0RxVVcxTXBDaFVEZEwz?=
 =?utf-8?B?S0pVV2UyR0xpc1hXazVrdFhGSEl2UVVFN01ZZ2NxVHA0N2hnZmZtYTBic2pN?=
 =?utf-8?B?RFZ3Y29lYWZYOUFNcWc3c2RzZWlPSGNkWGhoZTIvKzgvcFg5YlFkT2Y1OGpm?=
 =?utf-8?B?QnhtWlZYNjVyU2xTL1RHb0NZd015dlFjaU1HM2J0bTdNUVlYUDAvU2cyM0Y5?=
 =?utf-8?B?a0NVWTRYWXp0bklsTkMrZ0xCRzR6aE9lVERTVWk3QkJxMVVPSENYc2Z1V1lH?=
 =?utf-8?B?c040c2s5QzlURXMwbTJNMkdzMXFvc0tkRFREVVFTa0NmMkdOK2N2ODZqeHpU?=
 =?utf-8?B?eUZTTFZyc3ozbW00bHM0ZExkdTF1ZTVjZ1JXaEZ1U3M3Tm0ySERVdjB3T3Jh?=
 =?utf-8?B?QWhlS0MzdXZsS05sMFpyOXQrRzlBdUhMVG14YXNsZENJQ29WWFBYdERaY1Ux?=
 =?utf-8?B?bXc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff52a17-8544-4fc1-8403-08da6b3430e5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 16:15:13.1978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1XE0xIRprjcgbDHDVyc/YRBd1/g7FtBfov0/lMf9HFSFmlZJr6Rmfgvj61WKqKpl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3021
X-Proofpoint-GUID: r5rLMkKdlMpBTkQyv1DQzB9nLwV7_RUR
X-Proofpoint-ORIG-GUID: r5rLMkKdlMpBTkQyv1DQzB9nLwV7_RUR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/22 5:40 PM, Hao Luo wrote:
> On Mon, Jul 11, 2022 at 8:45 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> On 7/11/22 5:42 PM, Hao Luo wrote:
> [...]
>>>>>> +
>>>>>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
>>>>>> +{
>>>>>> +    struct cgroup_iter_priv *p = seq->private;
>>>>>> +
>>>>>> +    mutex_lock(&cgroup_mutex);
>>>>>> +
>>>>>> +    /* support only one session */
>>>>>> +    if (*pos > 0)
>>>>>> +        return NULL;
>>>>>
>>>>> This might be okay. But want to check what is
>>>>> the practical upper limit for cgroups in a system
>>>>> and whether we may miss some cgroups. If this
>>>>> happens, it will be a surprise to the user.
>>>>>
>>>
>>> Ok. What's the max number of items supported in a single session?
>>
>> The max number of items (cgroups) in a single session is determined
>> by kernel_buffer_size which equals to 8 * PAGE_SIZE. So it really
>> depends on how much data bpf program intends to send to user space.
>> If each bpf program run intends to send 64B to user space, e.g., for
>> cpu, memory, cpu pressure, mem pressure, io pressure, read rate, write
>> rate, read/write rate. Then each session can support 512 cgroups.
>>
> 
> Hi Yonghong,
> 
> Sorry about the late reply. It's possible that the number of cgroup
> can be large, 1000+, in our production environment. But that may not
> be common. Would it be good to leave handling large number of cgroups
> as follow up for this patch? If it turns out to be a problem, to
> alleviate it, we could:
> 
> 1. tell users to write program to skip a certain uninteresting cgroups.
> 2. support requesting large kernel_buffer_size for bpf_iter, maybe as
> a new bpf_iter flag.

Currently if we intend to support multiple read() for cgroup_iter,
the following is a very inefficient approach:

in seq_file private data structure, remember the last cgroup visited
and for the second read() syscall, do the traversal again (but not 
calling bpf program) until the last cgroup and proceed from there.
This is inefficient and probably works. But if the last cgroup is
gone from the hierarchy, that the above approach won't work. One
possibility is to rememobe the last two cgroups. If the last cgroup
is gone, check the 'next' cgroup based on the one before the last
cgroup. If both are gone, we return NULL.

But in any case, if there are additional cgroups not visited,
in the second read(), we should not return NULL which indicates
done with all cgroups. We may return EOPNOTSUPP to indicate there
are missing cgroups due to not supported.

Once users see EOPNOTSUPP which indicates there are missing
cgroups, they can do more filtering in bpf program to avoid
large data volume to user space.

To provide a way to truely visit *all* cgroups,
we can either use bpf_iter link_create->flags
to increase the buffer size as your suggested in the above so
user can try to allocate more kernel buffer size. Or implement
proper second read() traversal which I don't have a good idea
how to do it efficiently.
> 
> Hao
> 
>>>
> [...]
>>>>> [...]

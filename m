Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A0152BD2D
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbiERNnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238092AbiERNna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:43:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99481BE134;
        Wed, 18 May 2022 06:43:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bHnY+PdPU3zXDJdTWx2a/opHdf1DwPCSmMwwzdQg2x4WA5HnER/I81OdiUlq+jJryeLcxHN+kRflWMzgVzfhL2FFM4YPUgh0WlkkLOrvq/Wghb/xDWgizU6RxtC2iA9kih4JS72XuRNn5XfltH2RhfoHLH4HWSh7sxvwcXmJrgXJ4UbFnM3kHUaXPLqByJP0FhGsEG+RMJoYCVa5ZfVXPBu/EHx92PStq3WOUYxmbCBpRPbpyU7cSNR9lto/H9gP0C98Tyzx1ss/gy2bpp9VlTN85NzmmS/kp9RfsQZyT4hQBjQEDwfHP3vgKT/J4gO+BdqSL8e4AFq7oTJOEgUcgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lAPVzkF+Eb67QOv3ZZ2PWnhSU52nuYr81HpLDlgBEp0=;
 b=SePjN+nLSSQ3DW/34AqaRvyxVc2guqKgRqV9YnTJwMOG0a2M9GfDdg3B8OAa7mZINsHMRqi6vuz/S5hcbcFjaVO0mSuNGpb2xrD163xnkHRiHXC0/Qvyq3atImOYR7vd/yKfstWtFaBfOFk+Nnb0asQIXnyxZ+I8OwM+KPE+fu0PulBYHcANRPF1sYLVD5ur+w67L5BrhlRmA2w/oDXQwr8Q9QgiwXjfSIdYJNdTVEeVkII5N2TacAEgkwRQu0PwQzaEYlqlIr1tTCGLCVhunflMQ8yFkHzbpwq5FMU5/HqQZKSX2ETu9zhWwUeHRbm9v7fntooStwT/8MKxdIoBmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAPVzkF+Eb67QOv3ZZ2PWnhSU52nuYr81HpLDlgBEp0=;
 b=D+GaFKxVDI/xaYPMJegccZ0jcLZLFyEx7ELbBWsQPHC7qQ+ylScS5nzYHlRpZT11kF/g2P1LXSkdTWb+5JJ20d40g8UcNHqVKjJNARxS/H8QW9WiaUpxfps9EQwD7def5wgh9sn0373RMGOe2bUWGIxwaK6tZgiz57hu7O+uE1f/Ar54/A1lKIKivy6TUMrMP3xrzLN8WOG4etNx/jHF4c/wnrL7HRz1K5jnozpi3FOU7zX0vHjF85CD3oQyBQ5QUwpL7fgXfvm7wcPpXHZBnPYIhc6w94ti0uFKeyUwBHqVRH4xOwHvpu0OzTNZNfSLTGlJQrGfdjn4Y2yl7pBpQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5142.namprd12.prod.outlook.com (2603:10b6:208:312::22)
 by SN6PR12MB2781.namprd12.prod.outlook.com (2603:10b6:805:67::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 13:43:24 +0000
Received: from BL1PR12MB5142.namprd12.prod.outlook.com
 ([fe80::788b:2583:87af:97d3]) by BL1PR12MB5142.namprd12.prod.outlook.com
 ([fe80::788b:2583:87af:97d3%5]) with mapi id 15.20.5273.013; Wed, 18 May 2022
 13:43:24 +0000
Message-ID: <ab156744-21fe-61dd-8471-8626c88e6218@nvidia.com>
Date:   Wed, 18 May 2022 16:43:03 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v9 0/5] New BPF helpers to accelerate synproxy
Content-Language: en-US
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
References: <20220503171437.666326-1-maximmi@nvidia.com>
 <CAEf4BzbSO8oLK3_4Ecrx-c-o+Z6S8HMm3c_XQhZUQgpU8hfHoQ@mail.gmail.com>
 <a330e7d6-e064-5734-4430-9d7a3d141c04@nvidia.com>
 <CAEf4BzYnVK_1J_m-W8UxfFZNhZ1BpbRs=zQWwN3eejvSBJRrXw@mail.gmail.com>
 <13051d07-babc-1991-104b-f4969ac24b9b@nvidia.com>
 <48df5a60-f6e2-de05-1413-4511825511a5@nvidia.com>
In-Reply-To: <48df5a60-f6e2-de05-1413-4511825511a5@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0099.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::14) To BL1PR12MB5142.namprd12.prod.outlook.com
 (2603:10b6:208:312::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b8fa75d-e4fb-4022-5ba8-08da38d46122
X-MS-TrafficTypeDiagnostic: SN6PR12MB2781:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB2781430C13BD7F7B22805170DCD19@SN6PR12MB2781.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +5ReuA4fDLOMTbcWSepzJ88CDjMDUoL5iaceKYh5+nfdpGXCw4rRcLTtii5Zr21GUp/c1ninnQltMYosHdDhNliiM1Yok+zsUlAspcNV9QCXNqVyhOM9mElUlixIP0ECUCjZ6qQmuQa1oyOp2pMsYdnDaqsmfMDbPuXFY5Rz5mjofrpvQUfEJ8ZlmxA8ACA/j5kOLEmT70mx71/1tqkKPaFCmCYT1dLctPSrbomIEfe7y8K67XwgeOFBqOxuCiQ+FkA9NVPRh26sfLTzkmF5WmvrFFOrZU0rqsS3kcZBTXNKf5dlNxISZ6P0iLDmMtKy+t66W5ui2r6p6D4V7cY2GkqMxOQvJUi3S62y4+dCagYgfDcKS/jFU4T5m7qCrphN05f96a0po8VuMCe9yqsWpxYwYu8O8vtCcxONz08npGnS6XsddeiDhUS23pXot5H8pb1byeEsWfzB7cf8+8zryVm3SO5+xDLd5ngsOzBa7kYV5VNquw1/bnotjiLCAhxKGcf4KZ2LVuHwIkz5jC7wJGkRi5a90L2WEPBmSM3WrOmbX4XPqrZMArMV7rNmkI2vBtIL5e8MrkhyNoBrXRTZVgw2nUMZCEn/3YHBflOn9dsKq2Ckr+bKehzpv7gY2oFaJP3RPh6qGLFAxGxMH4IvUdgIuq0pQDnW+WUhX10MRLP12hifHgjpB2RHo46yYMWaekQRioE1jeeJQuCjqCQXwarv6gZ9a9qid0CvNEjmED4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5142.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(36756003)(31686004)(38100700002)(2616005)(316002)(26005)(8936002)(6512007)(6486002)(2906002)(6506007)(6666004)(31696002)(5660300002)(86362001)(508600001)(66556008)(66476007)(186003)(66946007)(7416002)(54906003)(6916009)(8676002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3BYZkxpWGk0bzZjVHkyK2FDSWlXcitzSGJuQ3BoRDZaQndBNUl5c3dqWGJW?=
 =?utf-8?B?N1R4SnREUWU2M0xyNEJnczhnSFpVd1JxTWFjZU9rSDdDY0FIci84b052dG1S?=
 =?utf-8?B?bSttT3NWUkFaQ3ZMYitaaEVhUitrbDUxbWFuK0J6SFYwa3oxZkF0eWZobkZt?=
 =?utf-8?B?MThIaGdBMWZ6VitHTTZSOFlseFVkYlBCTHdoSW5qaG9wU1l0SXY4WWo3YTNL?=
 =?utf-8?B?Q25DMUpmOWJwQzdjS3ppYW16NHY0VXVjTGZiZ1Nqc3hiT0FOd1A4VUc3WVc2?=
 =?utf-8?B?L3ZFeU84aDJ2MHIrakNIZm5WUW4wZElTV2l2MXh4dEFKak9vQU53bTZoUFo5?=
 =?utf-8?B?N0hZdDByT2NnMWMvWVRuenRGK0V1ZXNYbFBkaWFjd3F4RjF1RTJvR0lqZU1n?=
 =?utf-8?B?SjI5bFNBTzJHK0NlTE1UZ1VXYXp4dXlkU0c4MFhEYjhTQmVVWHJ6L3dKVlNQ?=
 =?utf-8?B?Vzk1UFBjM2xPMktaMk05TjZCRTFqTUFOVFRRTVozNktPNytJWFVjOUpSSWd6?=
 =?utf-8?B?NjVBOTBMQUt1R2tnOHRFOFVPZHFtc1czNU80a25VS09icGNiQjFyRjNXV2l5?=
 =?utf-8?B?QnljZGs3TFZsWUw0MHhkMmxqN3h0eTJ6OVBIYXpHNnVYZWhFT2p2d09zcXla?=
 =?utf-8?B?Q2VJS3JZWGorcGFLVHlaNHJXYVRzRE1HNjB2VWF3SlVMNGRTcUxtTy9OUW0z?=
 =?utf-8?B?T1FZU2FScHhaei95ZmlpYXh4c3VzZXFHdEZtOFQ2RkVZay9Id2d2eXllZ2FW?=
 =?utf-8?B?Nmp6S09nL0VidEc2b29JY1FmSUs5b1JnWHRaMUFPWlVvYzdyaC9KZ2xVbkhF?=
 =?utf-8?B?MS9PNC9nL05CUDFMb2o0RVVUeWVSdXpUenhMVldwaXVyRHZ4TVZzb25TOWJr?=
 =?utf-8?B?U05kTVR6SWVuaDNhVGsya3lhMHNRTzBiWmNKRVdJMHd1azdhVkdjektzRzRh?=
 =?utf-8?B?aUhRM1BzekJCWHN2NWE0d2xWbjhuZVNTc1BQSVhnaFYzeEZCS1JMLy9YRzJj?=
 =?utf-8?B?b25SckJqMlYrVWdEeGhycTZ5YmNBRDRRVVBrRnpKK3d0RzJhb1I4MWc4OHNR?=
 =?utf-8?B?MDVKL1JnV0xYRmxwTjhuR1dMQ1FVbU15eXFCY25jYXRmNVcvUmVkS01LdmxH?=
 =?utf-8?B?SHdHWGh0WHhpYzU5eXhEMWg5amZJb1QwWGk2RnBYM3IvUFg4V2JncGxUWGtz?=
 =?utf-8?B?NUZlaW9FZGYwVUZ5SnlOYzFjY2pyM3Q3SGhDZ2Q5R1JiczdPbEs2OG5pbFBG?=
 =?utf-8?B?SlJNWGxYZWd4ZlNCY1o3ckNBU2pPWFpweC8ydTU0UnF5bU1aaTB1L3RrUjdF?=
 =?utf-8?B?ck1PUkE3a1ZzR2g1UkZzZGphUytrWlh3MUFIS3FMa2oxK1Uyam9XLzhpZTJk?=
 =?utf-8?B?dys4MlhiQUF1SUdnSlRoV2ZPcXVUYXNVOVhoZmVlekN6K1o3UnM1eXJQMCtp?=
 =?utf-8?B?b2pQMDNEcWRaRFI2dHRoNUlmdndteTRtYU82MFhscCtWdERnRGpCb1VWVTVQ?=
 =?utf-8?B?TkNYZllNQ1h1T0RoWlBvdFg5TU5sNWNRNlhVazhUSVRCcUptelhaVjRqeXYw?=
 =?utf-8?B?Y1N4K2VpWDVJWDYrM3k0eEcxT3dkZ0d6VENJTjR0dlhVekt1T3FTdlM3NzlW?=
 =?utf-8?B?TktnUXdrMnBaSzl1ZDRIZ2F5alQyeDFJSjlCQThFcThoNXVHVTc5Yk85am94?=
 =?utf-8?B?RHB6VERXSExHOXdlUkgxdTcyRjhqNHBoeFYrN0pyQ3VFZGVOamxBbElJRmtr?=
 =?utf-8?B?MHBpbURjK3BGNCtidXF6a1lEcmYvbTB1Yk4rbzYwRStkK0pUUEpMT09PU2lG?=
 =?utf-8?B?WWJqdjZNSzJBbU5LTm0zMU8rS0hhNDcweEhYTURCbDZBTnVVSnhpeExJQkVz?=
 =?utf-8?B?aWkxVXl2TlFZVnRqRTdUVW1KRnM4RDdPYTJIdlNkWnkwTmdUSzFkMmtrUVBC?=
 =?utf-8?B?Nzc0a3BEa0hQUmhOVGpqQ2ZSMlF3WHo5TXJrOTNEQ28zU21OTitncWNjYXdS?=
 =?utf-8?B?MnozNWJJZzVSRXBnbTNvRXZ0U2pZdzVIN01OVU5aVG5WbnNLanlEMy9SOGl5?=
 =?utf-8?B?dVljWFVCalQ5WXE5d05LcUlZcWhhWFBGbFhPVU1WcTVXcWVFNFovUDE1cWRx?=
 =?utf-8?B?NFZCaDc4ZlRXVnFHUDJXeDd2aTNmTmxHWEZNcFordUcvbDNNN3BhUXJlTjVx?=
 =?utf-8?B?YkVEbVUweThwbFFYQ0wxalgwS0EvUFEwYk03c00wSmpFYXZVTE90dTYzajk4?=
 =?utf-8?B?UXQyaWRlT3gwSEFZbERDL1FuVnZTTlFDVkdFM2ExaGJnZFhiYWVQMnBNUjh5?=
 =?utf-8?B?ZzA5MGxXV09UZm0wMDg1N0tWYVFNbUw4T2JKVXhUb1JtWktlR3cwZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8fa75d-e4fb-4022-5ba8-08da38d46122
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5142.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 13:43:24.4115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F/8Zz3YhZzV/1fym3Ll6WbJNO9JKch/a1DPES2oopnFHRFUmCRrXR264JqOY4wLi//XmMe7z2BP4cbhMVoc2YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2781
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-16 20:17, Maxim Mikityanskiy wrote:
> On 2022-05-11 14:48, Maxim Mikityanskiy wrote:
>> On 2022-05-11 02:59, Andrii Nakryiko wrote:
>>> On Tue, May 10, 2022 at 12:21 PM Maxim Mikityanskiy 
>>> <maximmi@nvidia.com> wrote:
>>>>
>>>> On 2022-05-07 00:51, Andrii Nakryiko wrote:
>>>>>
>>>>> Is it expected that your selftests will fail on s390x? Please check 
>>>>> [0]
>>>>
>>>> I see it fails with:
>>>>
>>>> test_synproxy:FAIL:ethtool -K tmp0 tx off unexpected error: 32512 
>>>> (errno 2)
>>>>
>>>> errno 2 is ENOENT, probably the ethtool binary is missing from the 
>>>> s390x
>>>> image? When reviewing v6, you said you added ethtool to the CI image.
>>>> Maybe it was added to x86_64 only? Could you add it to s390x?
>>>>
>>>
>>> Could be that it was outdated in s390x, but with [0] just merged in it
>>> should have pretty recent one.
>>
>> Do you mean the image was outdated and didn't contain ethtool? Or 
>> ethtool was in the image, but was outdated? If the latter, I would 
>> expect it to work, this specific ethtool command has worked for ages.
> 
> Hi Andrii,
> 
> Could you reply this question? I need to understand whether I need to 
> make any changes to the CI before resubmitting.

I brought up a s390x VM to run the test locally, and there are two 
issues with the latest (2022-05-09) s390x image:

1. It lacks stdbuf. stdbuf is used by 
tools/testing/selftests/bpf/vmtest.sh to run any test, and this is 
clearly broken. Hence two questions:

1.1. How does CI work without stdbuf in the image? I thought it used the 
same vmtest.sh script, is that right?

1.2. Who can add stdbuf to the image (to fix local runs)?

2. It lacks iptables needed by my test, so if I resubmit my series, it 
will fail on the CI again. Who can add iptables to the image?

I also compared the old (2021-03-24) and the new (2022-05-09) s390x 
images, and ethtool was indeed added only after my submission, so that 
explains the current CI error.

> Thanks,
> Max


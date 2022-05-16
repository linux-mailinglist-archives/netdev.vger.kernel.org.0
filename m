Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4AB528BC7
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 19:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344115AbiEPRSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 13:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbiEPRSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 13:18:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB60C3617E;
        Mon, 16 May 2022 10:18:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fX0u3irggqSliYzV/vFXXam1+M3y0p8sDB5UI44YkR/SFfS/6ET+hcQd1SWkDtP4c/eKAj2ZM3Yb+AToqXlNGDhNjUXzTZXmCi/EVb/uGbT3tU7g9hOGGz7F/hcmMtyVPG/MX/u/2h4C6ki9WsYJTC8oGytSeuMhu6H7+j4SJTbAUBC71B/b8ucD4KOVPhmK1PLh+ETXifPdT2ECI8DQQtCwvD/MW4TXFC6iOFUONb96sXCE7A3uVK283mfmBt+/3RJXm2nK+fYq1xnpHnnr88N5dY7pQDBx5+5ant/ScLkjUCqHduWE/yMIhSRiftHToQ5ewjiqbej47F39F4a+dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fpwiYF57dsiTsjW3+i5oFS1ehTjyl0+jnlWSR+VEmBg=;
 b=JASud7cGny5SDSOOQh5WpJPSJScqMPvHMwNpwGLHVV1fAuovUiC1/VmmBHl+aWr0MDDWmxXERaOmyJCOlda1vglgzOLSB2pbd7H9r2+ptESQuX/B3XuXlo9BvgK86nUYdeKY8HcOOY2/bMVgsCP++HTfL/jAvf46vFYENYwgqHfvF6rc33cQWK5iA0eALjxmZxeuUidN9n4hS/IsuORUQQkTg1D/Ec2FmaQF/HDo4BlYAYALLRxpB82l4dm9aZz0YScVTOfK35er2wue+SSZVEWrUZ+JOMcKT/Fl11xlzGsvjOKx/MXN8Zed31AUjcIqtoyHCJLG2PDYCYuPvGoVfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpwiYF57dsiTsjW3+i5oFS1ehTjyl0+jnlWSR+VEmBg=;
 b=EyW2hSsFs7W2m5rmrVNWpC6vKfycQP2VGKM9fQM9fPwGfslFECV6oYKqjbxP07g+04gX3cr+xytrNhQcGpcrKRNAiSv5ZZkCNUsCEDvlY+opXGC9MSJjTJYlXNGVG+h24IHYBW0Zx/nE9eORdDEFZrni7tLvx3krX7sg2INnyEJrEFjzuMZA0HXigFLXq8I1PC4pYvokIIykqPgrh3/aHCeOmtuZlXPw1skEIlqSR65KZ0eLwpeeFda4Gpw5PGmIRApJ7FFhY6pc31dku+uWLFST4M4PkSyRpjpGQzftpXg0gwX6wlnwmARnMEp84bN+SuHjsSW7S61E/eJZ9uRHwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by DM5PR12MB1836.namprd12.prod.outlook.com (2603:10b6:3:114::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Mon, 16 May
 2022 17:18:06 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 17:18:06 +0000
Message-ID: <48df5a60-f6e2-de05-1413-4511825511a5@nvidia.com>
Date:   Mon, 16 May 2022 20:17:48 +0300
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
In-Reply-To: <13051d07-babc-1991-104b-f4969ac24b9b@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::17) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 322ecbca-6998-42cb-e992-08da37600a80
X-MS-TrafficTypeDiagnostic: DM5PR12MB1836:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB18364C27CC2F0247C773C09CDCCF9@DM5PR12MB1836.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SQvSeBx4kNQs3bdQOBzh/8YjsUtk7k3bFExmBL5rmYAeXfmpkhSBi9aPWTIHB1weB2GE1zfsg0Ryj0ZojElpB4zmdbYJpPCO/71GlZCp6AkjWXZ/P/amVvR5eldzzBoCVGpPjK8Ax62pLZ6/0HlCa/8I6KBiq59qHSKAas288m2FwJ5ZcOKoplVk6sPMJs+AEVEa9aL277EucNT/LzZuoGCGo+JXRUtQdBqDd1LnMVK29ZOiaJLSLW4jG7sLNVhEt2sJO1k9ZIdYYVth3jIs54c7tV6VaFZlp8KrREU3yWK65O9EHGp0lShXclkka3Gvp4c0JYKGGNp0EWEkgYA3EfpLGq5dnJqnpukYv4KvwWg+bdbG5Mt3Z3jketJZikJr0A7OokdVAmDXxBxUPnQWOa0k2E9Z/RBir8ieM0Tq+gXjXJ2VWAh9QYnSkVSFF7aFLdcWDDp+t+80jGI12h8jjVHw/pDiZ5sii2M/+ggvlTiDtGix+32gTiBMq+rJTMQ1ekxGthzLTVLbylpZxAiiddCyazILbWhX+1byAQG+6SuZ8phwLZwA9L9n3jHW1t/5Y9SXLyn6ebLdp/Ym/Pn6UMyHI1xOcF7nZtWwzkG/xwijWUMYToYDf8IE5nC5HwXaZdKaDpdXXr2IdlDcHuXY8/CPfCN2knRJvout5JAR2WVgBP9cpPpNAzMktGX4nvqD/EutB/LzhUqjcm5ItKHf9pRi5p5h+NbPTfFV65ba5Ys=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(36756003)(86362001)(4326008)(54906003)(26005)(316002)(38100700002)(8676002)(6916009)(186003)(2616005)(53546011)(6512007)(6666004)(2906002)(6506007)(5660300002)(6486002)(8936002)(31696002)(66946007)(66556008)(66476007)(508600001)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEVJdDNmZmkyOGdybGlQUmE4Y3Q4dmRsOXNOdHBNRHI4cDhic1JCd1FIcE9D?=
 =?utf-8?B?aTFIcCs0MWw0eEQzcm1FTFlnVmI2NnZtbWtXL2tLSEFvT3BYYjVzanU4UUsy?=
 =?utf-8?B?R1l6V3d2U3oyQSttcGpVOHU2ZFNxTWcwaXN6T3l5VVJLczRBT1JyR0JkQWlE?=
 =?utf-8?B?OGJESm1aSk95bm9uam1aVVZ3UUJVOHFNSWJrSW1jN3kwVVZVNlEvUC9KRDY3?=
 =?utf-8?B?ZUpEY1FSUWhLVE5FcjBENnhYQW1tZEpkUkhsV1AycWthNFI3VmpScWxUcmhh?=
 =?utf-8?B?L2U2RzRZSkV5bEhMSjlBb3dzbExMRGNheWZZMWl5RnV6MFA0c0NnWDdESWd1?=
 =?utf-8?B?OTFRMEt0VEhEcWlmWlVZN3lTQkNRd0s4RnRQWWJEaGFwUXJkNThOc1BGVXE4?=
 =?utf-8?B?UnpEeFlJcmgyd245aVd2VDY3UWFnbGtuQTNMRTRZUUhtRzdlWjhSOVJvbEt6?=
 =?utf-8?B?K3ptMGp1QlRxT0dNd2VVL3FYRVFSTVlQWUhtWUpYOVF2dnU2Yk5Fc0RpSkF6?=
 =?utf-8?B?T1l0K2pva2g4bXB3dDVlamI1YVpoOW1wR2txeXBKRlhQR3BncVM2dHBwaXpD?=
 =?utf-8?B?a2NxVHpucVRkbnhkVVBPSXJaZGZwMHdkNDRSclV2ZUNZcTBpaTdubzc0RkJR?=
 =?utf-8?B?WVpDQXA2Rm1IVzRmRFZjRk4vRmlVQUZCMkNHWW1hNTVtK3hXSHR0eWUvaHhI?=
 =?utf-8?B?dEFsNmNsVU1PKzJhSTFYYnkvTmRmYXRMSnF4S3BnajQ0QTdMRHhtWXpOajI5?=
 =?utf-8?B?QVZjdk5MMXJ3NWp6T2JsWEpsV05lWGVTTFFiRGp6bTRiUmFjMzFES3oveGZQ?=
 =?utf-8?B?d3lyZFlWNzBlUWJLdEhtNlFpZ0NrV3FYNlhMM2EyRVpvZ3dtZHU2aXhvbCts?=
 =?utf-8?B?TXFGVTNiM0tBNnMxdFErSDFHN1hnMkJLNWovYWlhd3p3ejFXdGxDWWU4R1Zx?=
 =?utf-8?B?eGdkazVnYnVrVTNQclMxTGJMaGlSbW5VdUZ0R3NxMy9XUXI4UEUvc0xmTXVm?=
 =?utf-8?B?dVVtVFBoS3lRRUJkOXFiSlBsOUZGYUFQMlRPQm4yK2pNZ1BxT2prL2lqOXBQ?=
 =?utf-8?B?a1NZN21reFgrVDNqMkwrWEtnajRZdHB2cm1qUmhIVlJrbWMxbnhzQTkwK1Q1?=
 =?utf-8?B?S2FSQkdxN3hxRnYrSHNiK2M1d2dReFV1MDJrRHYxeDc5Y0hyMitmY2o4REIr?=
 =?utf-8?B?VGdQQXUzdUZRREFXNDN0RXhza1lMS1hQZEY0b2VYay9KaEptVjNQQjlRa3Br?=
 =?utf-8?B?ZHF0V2kzZTg1OEx0UStlaTlOODRSck5WSnQrNnZ5VXFHUUYxaUZyM2tOeVRs?=
 =?utf-8?B?OHRzcU9hL1M1S3V6VTBTK01QaVYxNjduZVVlZ0dpbld1MHJ0cThtTFNWalA2?=
 =?utf-8?B?VjA4V1FOaDN4QVdkeklSYmlpTEhzMEFJNHRTYW9tTWRubGUyQkE5NkVCYTRX?=
 =?utf-8?B?SU1PTGhkamNCSGNnNlVyRU5OeWFvWHE3VkdaN0IySWVuTTF2RWFITDYrbXl3?=
 =?utf-8?B?bkRGaVhqS3BleEV2Zk1kdktCVGxrR3NndjlOTWRmTnRCWWJjcEJkOURXN3Jh?=
 =?utf-8?B?aFNDVE9SK2I4ZXNjWk9rOGR5eWh5dVArQzdTaklFaGFnUURKOGVyL1N0Wlcr?=
 =?utf-8?B?SEkwdjd3Tnk4M29wR1U3V0pHS2twTVRrSnAwYVlXaUdCZU0xYlk4UGl2QUJK?=
 =?utf-8?B?bGlZWGFkVjREb0hXSURsR0xGVGRIbkI4akw5eWc0RkVnSDRCZTdmZUhMRU5z?=
 =?utf-8?B?c1lUczIzR0RtT3h3RU9tTzVwRTNWVjJEN3NNY3RRcEpPNDhCR0JlOFMzQUZz?=
 =?utf-8?B?NGw2bGtJcHlTSW1SS01ETG56eisrN1RJbk9ONG5xU3R2Sjhnb3dmNGMzNlpv?=
 =?utf-8?B?dThQOG13NzhLZXVxVWhFOUZzQkRkejU4M05Gd04yNEM0UTdqaGhGcmdpSzVs?=
 =?utf-8?B?aGVxZUdxMGtQTkNpTmFrdjlJdC9sZDlxQ1dtaVZadUVHK1FCR2c4VCtibFc5?=
 =?utf-8?B?RHpzQ1NJQWxOTkRtc1dxUXpJMjBzbUI4MDBaaTNvQ0VEeGlDa0Qxc0xpYyt1?=
 =?utf-8?B?YVFBeWIzUEx4MWRTTGVjQXRPNzBmdTR4WWg0bStvU296MFEzdUVUaEpyRHZQ?=
 =?utf-8?B?WVRTdzJOZS9HeWQyN01MdnlVckZQaGs5WS9nV1JjVUgwWXdod3FCOXBYb1NG?=
 =?utf-8?B?akpKUGx1WVRUSjNxaHFxc3R2YWc0RHpYVnczd2loQXBnekNrMmhiRDhWSlhj?=
 =?utf-8?B?a1BaUFRIcXFDRVhIMXROczZmS1dGMzFIcE1wY2x4OFU3eUs1ZEVpSW4zQU5K?=
 =?utf-8?B?cDVvcUJJT0tVUm40aVZUZlNNbmxLMHlXbXM1cVB0V3RZYm9FMUFUUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 322ecbca-6998-42cb-e992-08da37600a80
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 17:18:06.3886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7RxVyPd3nqSPqPxJNiZ2L+UKWzV8lhgCBkY6JSPzPAp3gMCcjOiVdNNqfOFDT0k0jFgEfCMmAHIbwijZSPMtJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1836
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-11 14:48, Maxim Mikityanskiy wrote:
> On 2022-05-11 02:59, Andrii Nakryiko wrote:
>> On Tue, May 10, 2022 at 12:21 PM Maxim Mikityanskiy 
>> <maximmi@nvidia.com> wrote:
>>>
>>> On 2022-05-07 00:51, Andrii Nakryiko wrote:
>>>>
>>>> Is it expected that your selftests will fail on s390x? Please check [0]
>>>
>>> I see it fails with:
>>>
>>> test_synproxy:FAIL:ethtool -K tmp0 tx off unexpected error: 32512 
>>> (errno 2)
>>>
>>> errno 2 is ENOENT, probably the ethtool binary is missing from the s390x
>>> image? When reviewing v6, you said you added ethtool to the CI image.
>>> Maybe it was added to x86_64 only? Could you add it to s390x?
>>>
>>
>> Could be that it was outdated in s390x, but with [0] just merged in it
>> should have pretty recent one.
> 
> Do you mean the image was outdated and didn't contain ethtool? Or 
> ethtool was in the image, but was outdated? If the latter, I would 
> expect it to work, this specific ethtool command has worked for ages.

Hi Andrii,

Could you reply this question? I need to understand whether I need to 
make any changes to the CI before resubmitting.

Thanks,
Max

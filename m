Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFACE52C54D
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242716AbiERU5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242699AbiERU5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:57:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F06420D4F9;
        Wed, 18 May 2022 13:57:41 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24IKi607009104;
        Wed, 18 May 2022 13:57:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gzgKVxWkg4nCN7wN4jgRlYR/kGLVOQXYeJ0U0F/5D2E=;
 b=XqvPDyOEIzprpJKhGjh2/FI08Xe9StR+pt9+4+eJCgNOPIw/6/5k/LKowSKpTyX/xorX
 WTkIec3/IqbQwATusMaI0n6M52Vve3WTtBf8X1rtbviW4NLms9PknMc/AS9+CwP1x+ez
 L6ULXTWk4E/OkWZEIKcoYuZLrQLEgcxnP6k= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g4836w0cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 13:57:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yh1MiM8ykAtZ9TiljqCxkff7nxL4C2XgPJjck2llwUbYKQzhLWYzjJrKhpUjVLaD8oz3HH4Dp0j+NIHe6kqOXekRjl0FVJvvi9neaC9AZyiwGemuwb9NvuinIOKqcS0FCSWciw9qeOiZZaRgOLxC31L7Ir1BndNQZWgJGQWRl8zN9f7jEarb48ytoj5PC8KKQTfpgGewM0S4jSRnVTNYCMCGbhTNEtThv+7OmyfnP6oIP+dS3lEFCfCAoYB6zjZi6jBmQEdP8fKWkoal0AcNwn/9OFgwF3t2DgR6A3040j/xTctY1JTW9G8zTl+vtwSExmfzxSSpel+PJsmEnrj36g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gzgKVxWkg4nCN7wN4jgRlYR/kGLVOQXYeJ0U0F/5D2E=;
 b=cBftZx7HYLr9k/awGRIPge9kssO1C43mZIQbzWRE0LBD3nwBquC14jRioUbeH1Jthe0DqYckv75jU/JJObOwFKdC6jMxaX/yQCFw0kxrH8bGkK/SNt9K6eFw2vEe90FLUA7/MJFt66Ns6OzvRByJ3dQG+EW/Mh1/zqZHiP/rKJgY/JIavTxOiui+JTcAlWOmczwV72Ls4GudCaQzDk52UtTkF+fJeV9DZG10z+yjLOwds93FRAeH2z5SCVf+t3hFQVFNBItFQPq+WeYjIZgK4h1NYVwg40clxTQoluVvhxPEdhwC0wAOVp5Gex1bknocbYpxBiTbXWZCYs35ZdKTAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB2425.namprd15.prod.outlook.com (2603:10b6:5:8e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 20:57:23 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 20:57:23 +0000
Message-ID: <5c2c046c-ed85-3718-223f-b74a05d0b483@fb.com>
Date:   Wed, 18 May 2022 13:57:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf v3 2/2] bpf_trace: bail out from
 bpf_kprobe_multi_link_attach when in compat
Content-Language: en-US
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1652876187.git.esyr@redhat.com>
 <47cbdb76178a112763a3766a03d8cc51842fcab0.1652876188.git.esyr@redhat.com>
 <7bbb4a95-0d12-2a8f-9503-2613d774eaaa@fb.com>
 <20220518200358.GB29226@asgard.redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220518200358.GB29226@asgard.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: PH7PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:510:174::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8918b872-9f68-4401-849f-08da39110170
X-MS-TrafficTypeDiagnostic: DM6PR15MB2425:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB24252013FC5418D6004195F7D3D19@DM6PR15MB2425.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Ono1vDyjCBG0fsNqDflGaiHPImcRY3f0YonBIL8F4TsiRBhey8IgD58lnIJyrTgPLmbFydZUKHBsmlJGSPJS566Q+PKBdj1XMqvfHg4wqZHubBad5IzdMdJcYJnwbqImTHfakJVGgxlQgvyjfG9Za0LAx5uYPzCDni8ALC1DctzMiBeu3A6VLpfCXRpQX4JBfG7T41Ok3ljm+H6DvCWvSLLJQKdHcn2rX17cuYqnBPL9b7ZxLYnWyxwRQBp+P3+s7btFeYgxTi21DUtNXG1RVy5SsceNJc1GIk5TyzdTZPN8giX8DXSAaYBoOEN1TfMu+yy4K7pTx74Zkdj7EvqT9PXi4tBm0ZYVbGtnm0v/Rhb6mB8eK4AL+jbknNoc8S9zTI1ReBpJnFv8n2QroUyrIBJe7c+H+m/3fOzgtamRuCY3kwvOcd+Vd+yHWP1Wrs34orlv6oD8Dls+qpbyScu8jaIrDY+sIq832wdd7Nyc8JdmVVUgW6zCDkxf63T7a3RTaldyEphxw+dxn2wiyn4B+i/6HHz2EB7nnO4IbhMK72iAsuVMvfTCOT1C3GCufCjsbQLQhnfpmkTl+tG4fGCBe0l8/B52yux9lN5tpI5O5UtXF+7UzxXdCuFKL2JAahfXpT5H50nUQQ8pF3o6EwrmfwvQMpc0ebjzYEjoY1Ttl8CiCO0inPTlgjDENLTVbu76puGaXw17DKzwABUZax3XEXbMfGFZO9T8VqpWNZROFhclGh+tuz38YRHqnsPBfm69EPGK1xGXRoYnT8VtFaBHYIFxutnGN6A15jmnWZCqdqlYL7+6JN6k3fDRLKDPcdBmsbcNIUM4H3JQZMwhalSLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(316002)(86362001)(8936002)(6512007)(2906002)(31696002)(7416002)(2616005)(36756003)(53546011)(52116002)(31686004)(83380400001)(6506007)(66476007)(4326008)(66556008)(38100700002)(966005)(5660300002)(54906003)(6916009)(186003)(66946007)(6486002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qko0WXFiWFhlOHJTN3NwUXd5SVJ2aUNWTkhnMnN4OWFLVDhtRDJrd0ROdHNa?=
 =?utf-8?B?Smg1NzAvR2JOdWZUdkEwUmk5ZmZYeTkzTWhhdWU3V2xJWHhwR3hsK1pwNFUy?=
 =?utf-8?B?Wm8xVGNRR3E2K1d0QW8rckZ6V1haOGxMK3MrQVFPa1FxL0JJS3hiYW9XRGlx?=
 =?utf-8?B?d0tEM2tjb3RYMVp1TmE0bTNTRUpQRzV2VURWelE0MEpQdW9GZzJ1TkNUYWV6?=
 =?utf-8?B?NjNLT0VQdzNiaGdwUFFsYlFzQzc5UzZLZjhIaXk3SXcvMXh6Z3psNm9LMG1R?=
 =?utf-8?B?dDh4eUl0WnlPRmI0R2hXNWk1NTZHVmNOVDRIM1pyQU8rMDNadmV4MlhxcEpF?=
 =?utf-8?B?Nm1DMHRtdXRteEd1TU4vTHVuWllQd0s0Zmc0ZGdZWWtwQS8ydVRpUFlnNzRn?=
 =?utf-8?B?Y1djOGdSZ0hyT1kwcUpTWlFocy9tTzJVVVIyUEhMVndQR0srbmhTclpGVW1B?=
 =?utf-8?B?cjZzdGo4NUlPV1lSaVI2WnphS1EwbkplL09qbjJ3UjdnbWw1bVRJRWVUM2h1?=
 =?utf-8?B?TEtkRGg3NGVIdjY4L0tzUTM1dTRJWDkyQVNuaDVMK0xLN2NZM2pnenNTZ2pH?=
 =?utf-8?B?Y0tRNG5DUmxubXc4cjg2VE1Ldkc3aVRLL3FFVmxhbGFWeUs1S0RMTWcrUnZJ?=
 =?utf-8?B?OXYwUmpHb2V5cDYwNXp0Z1FwV2gySlBkSmhpUVdQUzkyc1hDMFVaM3pRL253?=
 =?utf-8?B?R1Y4Y0p3WVNiZjhLbDJMWE43NFhPcThPdTk0N0JPeFpReE9Cb1pRRi9YZkdH?=
 =?utf-8?B?cThUSXl2TG5DSmhyekJES2IwOUNyYnhvV09FRWJwejZEM054bGVmVU5IbFpV?=
 =?utf-8?B?RGNPTFdYeEtNSnNkUnZQQ25IMjlCTkw4WTFkdEp5STNWclZtRmZKbHpzMXda?=
 =?utf-8?B?bHFkdFBKcThLMGdQZnlpM0RyRnZkY0FzOEQ5VUlTcTY3WEdCMldYUTJwdjc2?=
 =?utf-8?B?RXJIbFNPaGdWTzluckZOeEwwZjVicnJKRFZoY09PL05ORUNWdk1MemR2aHNw?=
 =?utf-8?B?VXlYRmFaYURIZ1YzWVhVWlJzS09aRlo3Z0diTmsrc1ZzWHZJZVl5eHpEakpY?=
 =?utf-8?B?clh3VSt6UGVKRkZWdXcvSnkzWEkycDdFZGNDT1JkRVhaWGRFQ0xiRTkrb25M?=
 =?utf-8?B?bWtJMExCbkRMcVd6QmhMQ2hVWTVteXVQYU9JcVpDYnQvRGNIalA3Y09QMGpo?=
 =?utf-8?B?UWt5SkY5VVAyQXFmcXZFYzI0VHlIMjRJdUl3VWhXRTI2RVMzdGUySDdTYUlG?=
 =?utf-8?B?MEc2UFFqNHlXOTY2bitlWTNnaE1lSTdrUDdZSFI5V0QvbHYwc2VXclZJWDZt?=
 =?utf-8?B?Y1FaMnVRdE9jcUxlOUFOM3Q2N2pBNVBHV1RZeUdrdlVSU0wxc3diekUwbG16?=
 =?utf-8?B?NkVQRm1hT2wxNk90VFp4T1BlTnNTN1N1ZTVZTW15SDBoUVJ6SFFDTjJ3NnBn?=
 =?utf-8?B?Y1RheGttdkdQaHNvaTgza29KT1VwK1VVR0JDbkNZcUZxNENqNXdna2xlYnNR?=
 =?utf-8?B?Qlp2dWd6dW5uZS8rRGFRaHNNVkkyNFJab05xTjBzWEdTanF5NmMvaTdCSzB2?=
 =?utf-8?B?VU1VVzMyNmZlamE0SXFHQUkyZnk2VTN5WEpwVU5ITy9UdVlVRk94QTNJUU5N?=
 =?utf-8?B?dmptWjA5d3d1Z1ZTQ21HVndTbEVJQ2pUVUcreUhvTEhDRTRzMTQ2RHNXRXd6?=
 =?utf-8?B?RXhVZnJqK2p0Yjl2QVFwN2ZOTW90SkRZOHZvYm91Tm4xOEpkcTFiL2NIU2Nx?=
 =?utf-8?B?RHdLbms2TmZxOWlub2lNWXBmcE5NK3RiT0pNbE1CN0ZUemxlSmxyYXhMRktC?=
 =?utf-8?B?NVhxWWQvS2gyT05lLzlUeHJvVEFvSWhkcFQrT0xqeGtESjl5WlN3b2V3dWZ5?=
 =?utf-8?B?aGdxaXArYyszeEJ3WUFKU0Q1VFdpK0hYTGVMVk9IZUljeFR6bGNtbGhPVGU0?=
 =?utf-8?B?WGk3OFp2eFE5SjZnaTR4R2dyQWl0Q25teDdORmdzak4zdFdoanFJVC9WOHho?=
 =?utf-8?B?bWhBN0lLaHlWYTdVekpTTzM3Y1dVQzZkYVJ6cFBJU3NTSjJ6SHJIRWszVC9o?=
 =?utf-8?B?UzY0cmk0SXBoWnZ3SlI1bHlrc3dvd21VcjZmTm1sWmRTMjhUTHUzYnhLWjJI?=
 =?utf-8?B?Q2hvTUI1dGtGWFg0Q3BqV0taNGRSV2JJcEpFditDWllvbzRiS2dXK2IrV2Zv?=
 =?utf-8?B?QmJDSXhLQzZ6ckpGeG5qYzB6ZVBwQTR4dHRCczZla2toMkxNK3FEaHpIcWxR?=
 =?utf-8?B?OFZBVzBiK0c2endkUC91Zk1xQUs4SDNmTHdSdi9HdDVGeGFEQ2w5QzF2Q1FK?=
 =?utf-8?B?WktwYXloajQzVW1pL1RtMGpzSmQ4aW4zUXJackVHOVhuODB1SEJianZMbk5t?=
 =?utf-8?Q?uoQJiq3GxojkWau4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8918b872-9f68-4401-849f-08da39110170
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 20:57:22.9131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BzW8NJewoBYxweIxT4ouufxeHqK/i8TU5RbUuDW8brcxP2Kf43epEL2UevnK+mcz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2425
X-Proofpoint-GUID: HFrE5LcfemPgdzHjkAsF8Ss1gfpgJRYR
X-Proofpoint-ORIG-GUID: HFrE5LcfemPgdzHjkAsF8Ss1gfpgJRYR
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/22 1:03 PM, Eugene Syromiatnikov wrote:
> On Wed, May 18, 2022 at 09:55:05AM -0700, Yonghong Song wrote:
>>
>>
>> On 5/18/22 5:22 AM, Eugene Syromiatnikov wrote:
>>> Since bpf_kprobe_multi_link_attach doesn't support 32-bit kernels
>>> for whatever reason, having it enabled for compat processes on 64-bit
>>> kernels makes even less sense due to discrepances in the type sizes
>>> that it does not handle.
>>
>> If I understand correctly, the reason is due to
>> in libbpf we have
>> struct bpf_link_create_opts {
>>          size_t sz; /* size of this struct for forward/backward compatibility
>> */
>>          __u32 flags;
>>          union bpf_iter_link_info *iter_info;
>>          __u32 iter_info_len;
>>          __u32 target_btf_id;
>>          union {
>>                  struct {
>>                          __u64 bpf_cookie;
>>                  } perf_event;
>>                  struct {
>>                          __u32 flags;
>>                          __u32 cnt;
>>                          const char **syms;
>>                          const unsigned long *addrs;
>>                          const __u64 *cookies;
>>                  } kprobe_multi;
>>          };
>>          size_t :0;
>> };
>>
>> Note that we have `const unsigned long *addrs;`
>>
>> If we have 32-bit user space application and 64bit kernel,
>> and we will have userspace 32-bit pointers and kernel as
>> 64bit pointers and current kernel doesn't handle 32-bit
>> user pointer properly.
>>
>> Consider this may involve libbpf uapi change, maybe
>> we should change "const unsigned long *addrs;" to
>> "const __u64 *addrs;" considering we haven't freeze
>> libbpf UAPI yet.
>>
>> Otherwise, we stick to current code with this patch,
>> it will make it difficult to support 32-bit app with
>> 64-bit kernel for kprobe_multi in the future due to
>> uapi issues.
>>
>> WDYT?
> 
> As 32 bit arches are "unsupported" currently, the change would be more
> a semantic one rather then practical;  I don't mind having it here (basically,
> the tools/* part of [1]), though (assuming it is still possible to get it
> in 5.18).
> 
> [1] https://lore.kernel.org/lkml/6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com/

I think for patch [1], we only need libbpf and selftest change, no
kernel change is needed since we
explicitly does not support 32bit kernel in the
beginning of function bpf_kprobe_multi_link_attach():

         /* no support for 32bit archs yet */
         if (sizeof(u64) != sizeof(void *))
                 return -EOPNOTSUPP;

and in kernel, address (pointer) size will be considered
long (64bit) which is exactly the libbpf change did that.

> 
>>>
>>> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
>>> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
>>> ---
>>>   kernel/trace/bpf_trace.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>>> index 212faa4..2f83489 100644
>>> --- a/kernel/trace/bpf_trace.c
>>> +++ b/kernel/trace/bpf_trace.c
>>> @@ -2412,7 +2412,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>>>   	int err;
>>>   	/* no support for 32bit archs yet */
>>> -	if (sizeof(u64) != sizeof(void *))
>>> +	if (sizeof(u64) != sizeof(void *) || in_compat_syscall())
>>>   		return -EOPNOTSUPP;
>>>   	if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
>>
> 

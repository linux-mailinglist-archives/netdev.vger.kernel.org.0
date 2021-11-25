Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A2645DC74
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355278AbhKYOj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:39:29 -0500
Received: from mail-bn8nam11on2048.outbound.protection.outlook.com ([40.107.236.48]:6752
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347649AbhKYOh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 09:37:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNEZ97fIRVle38av3VGMKPUlNyiDLH9rzemM51qiAN8lexwMNlY+3/HR8c1z5kBvFSJAi8SzA/DwnAMUcaTTgAZ8Ug0Set6hla3KVBYVQm6gcZ75GHeCuMRvCcT7zYT5pc0GeGHDBQFXcSM6/xs3VP4+9Sw/SkiYc27l9OZkAET14eMwQ3lm8ZvCy9yIzel1NwFFUo8LqhLLxzAWTmzzZy4kpxCQ4Ok6+GbLZNBwpLlJnYeINWQ/B0kfIEQ2pPWCtVzBs4L9Q91kPRcTN1Iq40CcCLnsCgSOhnOI8AlwuIzh58XpfJrbsJ/0GOVTsgQISNhLwM2tmK0PkL62NudwzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7E1QnrLGsJfobaR4D2SIjWe35pxhcuK+pJKWRzSvuw=;
 b=LG/jfUdg99ZZTzWQ1ou4iOxjOYRkGgWhR3PbQdovK22KvFuxnP3iKkao/cWsHAOjxGq+bTaJvyink0pS++1sDC4Z8Bkq8PwdX/WzemiCEj7p9J8eEp3HgQhXfo4w8sZ8O5FTbjd9/jzPcoXqlN2x0+QrsDEgNMnzCHiQomB8zxFTw6+cCQHw5IpDL2fYvW9q9Me1/iNsLwXVTpZhESwSufjeCfzuDhPQyJ8EEl9fkF78lzYeaGanYIg0vOWL+NsP7SEUMyDcXkMi8h4bC6pkZErEm4hCitWEb6C3XH7GQOvZ41yithG5ZDnb8LCEY9RvLbykGV0Im4Wr+12Q7YbqTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7E1QnrLGsJfobaR4D2SIjWe35pxhcuK+pJKWRzSvuw=;
 b=Nr/7eFA+EBXYFUHrxnXztothkkyEyTiKHT5tGNY6ceVOOZIMlnlX6jKVnUmzA1j1Qlzf+P+vUfP5l9B4XJj40GgEMj9gTbX2fgKLEN3PU8Q1tjujRzW/PYKpEAFTpcver4j8JRwAn/UTRgAdRBzqHmFNkN1Q147Vd4drzrRZYJYeV6x9UUnX0bNZxBZp/FSZGOtS/SR73prbzZ7zwNfBMCZZ3HbcUF3/fQJfWdrT2ykkk540xvmpZBujr4LlOTXNbO48Ym7LpPXJbzIVgF6Oq7X12P9kGHwVa6cSa5Z8iCUv5tyAIMuhA+IOJ/9sxRIas2UD1SwgEp51TVJuL9tWDg==
Received: from CO2PR04CA0202.namprd04.prod.outlook.com (2603:10b6:104:5::32)
 by DM5PR12MB2360.namprd12.prod.outlook.com (2603:10b6:4:bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 25 Nov
 2021 14:34:14 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::81) by CO2PR04CA0202.outlook.office365.com
 (2603:10b6:104:5::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Thu, 25 Nov 2021 14:34:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 14:34:14 +0000
Received: from [172.27.15.34] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov
 2021 14:34:06 +0000
Message-ID: <3e673e1a-2711-320b-f0be-2432cf4bbe9c@nvidia.com>
Date:   Thu, 25 Nov 2021 16:34:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH bpf-next 09/10] bpf: Add a helper to issue timestamp
 cookies in XDP
Content-Language: en-US
To:     Yonghong Song <yhs@fb.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        "Florent Revest" <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>, Tariq Toukan <tariqt@nvidia.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-10-maximmi@nvidia.com>
 <CACAyw9_MT-+n_b1pLYrU+m6OicgRcndEBiOwb5Kc1w0CANd_9A@mail.gmail.com>
 <87y26nekoc.fsf@toke.dk> <1901a631-25c0-158d-b37f-df6d23d8e8ab@nvidia.com>
 <103c5154-cc29-a5ab-3c30-587fc0fbeae2@fb.com>
 <1b9b3c40-f933-59c3-09e6-aa6c3dda438f@nvidia.com>
 <68a63a77-f856-1690-cb60-327fc753b476@fb.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <68a63a77-f856-1690-cb60-327fc753b476@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c2855b4-d273-4c6c-7097-08d9b020a79b
X-MS-TrafficTypeDiagnostic: DM5PR12MB2360:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2360CA708F6A32EC90D8110DDC629@DM5PR12MB2360.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: esV5TYoR2qsTNqZ8Qvk8ws89YpGJ8tMP2LdAUbRMkdicpx76+OY1JycUCzYZtPIS1WKkM5OWb+6xwjF/w2UppOOw/KQ+SPzlxBVf4WQfSXLpICYfSWtiAzyUEyOI9vDPzpLk8sAowhq2Zt0c4xDc+OIlkgFzPrtrbx2W/xCUgKfoJ3r6kANuOXT4gYroQoOHR+reSwnYTGgCGOxR79CHOo6bqjDEYsFmxfO3TIGeYTOp+YJpxRKN0NrPCBc8VVYlO7f8sWiISFNthdR8r2j96Bk3RcM3UzttW3jhoffUX22QTddZN+rzDHz84Jceqky8MnTa9ANZBMM99wS2mywwQ9lqHg2py7L/uLZ5Lep5Sk5VxTf1lYd8J3YfSDGt2S1uxP5nW6tXmwfM+6FTPxKDutRi0/4vsH3AcBRFdipQPALkXvGNm+OR2PUALeaa7LC1Xihksj74R2k70fHlm9Pmqifp0WdAwgFLWTmhLPJ+5TDJjiyjmzzUfGt8eqNvZ0LvwezXTCELjoJ2TxD8AnHPjBF/UxAtvfMF8CROhdvNXCuP6Z6NNKGBc04hsM5pkJK0C0uPIj1XhqQrPAO03mbrMFcBu9/FfWU16P2QgH4QZUBdnTVIO/cl0QsnkOQXcbVil4y8csnjRg1GeytsauVgEhLk8o/eolZhSfV/tprvR+CLffyf4RMljO1/ARdhCGRS3URg44YboKx1TFZu1fSp/gW4PBo6ejULupScphYswww=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(5660300002)(2616005)(31686004)(6666004)(508600001)(336012)(2906002)(31696002)(7416002)(16576012)(8676002)(8936002)(82310400004)(36860700001)(110136005)(54906003)(66574015)(316002)(186003)(426003)(356005)(36756003)(47076005)(7636003)(70206006)(16526019)(4001150100001)(70586007)(4326008)(26005)(53546011)(86362001)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 14:34:14.5730
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2855b4-d273-4c6c-7097-08d9b020a79b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2360
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-09 09:11, Yonghong Song wrote:
> 
> 
> On 11/3/21 7:02 AM, Maxim Mikityanskiy wrote:
>> On 2021-11-03 04:10, Yonghong Song wrote:
>>>
>>>
>>> On 11/1/21 4:14 AM, Maxim Mikityanskiy wrote:
>>>> On 2021-10-20 19:16, Toke Høiland-Jørgensen wrote:
>>>>> Lorenz Bauer <lmb@cloudflare.com> writes:
>>>>>
>>>>>>> +bool cookie_init_timestamp_raw(struct tcphdr *th, __be32 *tsval, 
>>>>>>> __be32 *tsecr)
>>>>>>
>>>>>> I'm probably missing context, Is there something in this function 
>>>>>> that
>>>>>> means you can't implement it in BPF?
>>>>>
>>>>> I was about to reply with some other comments but upon closer 
>>>>> inspection
>>>>> I ended up at the same conclusion: this helper doesn't seem to be 
>>>>> needed
>>>>> at all?
>>>>
>>>> After trying to put this code into BPF (replacing the underlying 
>>>> ktime_get_ns with ktime_get_mono_fast_ns), I experienced issues with 
>>>> passing the verifier.
>>>>
>>>> In addition to comparing ptr to end, I had to add checks that 
>>>> compare ptr to data_end, because the verifier can't deduce that end 
>>>> <= data_end. More branches will add a certain slowdown (not measured).
>>>>
>>>> A more serious issue is the overall program complexity. Even though 
>>>> the loop over the TCP options has an upper bound, and the pointer 
>>>> advances by at least one byte every iteration, I had to limit the 
>>>> total number of iterations artificially. The maximum number of 
>>>> iterations that makes the verifier happy is 10. With more 
>>>> iterations, I have the following error:
>>>>
>>>> BPF program is too large. Processed 1000001 insn
>>>>
>>>>                         processed 1000001 insns (limit 1000000) 
>>>> max_states_per_insn 29 total_states 35489 peak_states 596 mark_read 45
>>>>
>>>> I assume that BPF_COMPLEXITY_LIMIT_INSNS (1 million) is the 
>>>> accumulated amount of instructions that the verifier can process in 
>>>> all branches, is that right? It doesn't look realistic that my 
>>>> program can run 1 million instructions in a single run, but it might 
>>>> be that if you take all possible flows and add up the instructions 
>>>> from these flows, it will exceed 1 million.
>>>>
>>>> The limitation of maximum 10 TCP options might be not enough, given 
>>>> that valid packets are permitted to include more than 10 NOPs. An 
>>>> alternative of using bpf_load_hdr_opt and calling it three times 
>>>> doesn't look good either, because it will be about three times 
>>>> slower than going over the options once. So maybe having a helper 
>>>> for that is better than trying to fit it into BPF?
>>>>
>>>> One more interesting fact is the time that it takes for the verifier 
>>>> to check my program. If it's limited to 10 iterations, it does it 
>>>> pretty fast, but if I try to increase the number to 11 iterations, 
>>>> it takes several minutes for the verifier to reach 1 million 
>>>> instructions and print the error then. I also tried grouping the 
>>>> NOPs in an inner loop to count only 10 real options, and the 
>>>> verifier has been running for a few hours without any response. Is 
>>>> it normal? 
>>>
>>> Maxim, this may expose a verifier bug. Do you have a reproducer I can 
>>> access? I would like to debug this to see what is the root case. Thanks!
>>
>> Thanks, I appreciate your help in debugging it. The reproducer is 
>> based on the modified XDP program from patch 10 in this series. You'll 
>> need to apply at least patches 6, 7, 8 from this series to get new BPF 
>> helpers needed for the XDP program (tell me if that's a problem, I can 
>> try to remove usage of new helpers, but it will affect the program 
>> length and may produce different results in the verifier).
>>
>> See the C code of the program that passes the verifier (compiled with 
>> clang version 12.0.0-1ubuntu1) in the bottom of this email. If you 
>> increase the loop boundary from 10 to at least 11 in 
>> cookie_init_timestamp_raw(), it fails the verifier after a few minutes. 
> 
> I tried to reproduce with latest llvm (llvm-project repo),
> loop boundary 10 is okay and 11 exceeds the 1M complexity limit. For 10,
> the number of verified instructions is 563626 (more than 0.5M) so it is
> totally possible that one more iteration just blows past the limit.

So, does it mean that the verifying complexity grows exponentially with 
increasing the number of loop iterations (options parsed)?

Is it a good enough reason to keep this code as a BPF helper, rather 
than trying to fit it into the BPF program?

> 
>> If you apply this tiny change, it fails the verifier after about 3 hours:
>>
>> --- a/samples/bpf/syncookie_kern.c
>> +++ b/samples/bpf/syncookie_kern.c
>> @@ -167,6 +167,7 @@ static __always_inline bool cookie_init_
>>       for (i = 0; i < 10; i++) {
>>           u8 opcode, opsize;
>>
>> +skip_nop:
>>           if (ptr >= end)
>>               break;
>>           if (ptr + 1 > data_end)
>> @@ -178,7 +179,7 @@ static __always_inline bool cookie_init_
>>               break;
>>           if (opcode == TCPOPT_NOP) {
>>               ++ptr;
>> -            continue;
>> +            goto skip_nop;
>>           }
>>
>>           if (ptr + 1 >= end)
> 
> I tried this as well, with latest llvm, and got the following errors
> in ~30 seconds:
> 
> ......
> 536: (79) r2 = *(u64 *)(r10 -96)
> 537: R0=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) 
> R1=pkt(id=9,off=499,r=518,umax_value=60,var_off=(0x0; 0x3c)) 
> R2=pkt_end(id=0,off=0,imm=0) 
> R3=pkt(id=27,off=14,r=0,umin_value=20,umax_value=120,var_off=(0x0; 
> 0x7c),s32_min_value=0,s32_max_value=124,u32_max_value=124) R4=invP3 
> R5=inv1 R6=ctx(id=0,off=0,imm=0) R7=pkt(id=9,off=519,r=518,umax_va^C
> [yhs@devbig309.ftw3 ~/work/bpf-next/samples/bpf] tail -f log
> 550: (55) if r0 != 0x4 goto pc+4
> The sequence of 8193 jumps is too complex.
> verification time 30631375 usec
> stack depth 160
> processed 330595 insns (limit 1000000) max_states_per_insn 4 
> total_states 20377 peak_states 100 mark_read 37
> 
> With llvm12, I got the similar verification error:
> 
> The sequence of 8193 jumps is too complex.
> processed 330592 insns (limit 1000000) max_states_per_insn 4 
> total_states 20378 peak_states 101 mark_read 37
> 
> Could you check again with your experiment which takes 3 hours to
> fail? What is the verification failure log?

The log is similar:

...
; if (opsize == TCPOLEN_WINDOW) {
460: (55) if r8 != 0x3 goto pc+31
 
R0_w=pkt(id=28132,off=4037,r=0,umin_value=20,umax_value=2610,var_off=(0x0; 
0x3ffff),s32_min_value=0,s32_max_value=262143,u32_max_value=262143) 
R1=inv0 
R2=pkt(id=27,off=14,r=0,umin_value=20,umax_value=120,var_off=(0x0; 
0x7c),s32_min_value=0,s32_max_value=124,u32_max_value=124) R3_w=inv3 
R4_w=inv9 R5=inv0 R6=ctx(id=0,off=0,imm=0) 
R7_w=pkt(id=44,off=4047,r=4039,umin_value=18,umax_value=2355,var_off=(0x0; 
0x1ffff),s32_min_value=0,s32_max_value=131071,u32_max_value=131071) 
R8_w=invP3 R9=inv0 R10=fp0 fp-16=????mmmm fp-24=00000000 fp-64=????mmmm 
fp-72=mmmmmmmm fp-80=mmmmmmmm fp-88=pkt fp-96=pkt_end fp-104=pkt 
fp-112=pkt fp-120=inv20 fp-128=mmmmmmmm fp-136_w=inv14 fp-144=pkt
; if (ptr + TCPOLEN_WINDOW > data_end)
461: (bf) r3 = r7
462: (07) r3 += -7
; if (ptr + TCPOLEN_WINDOW > data_end)
463: (79) r8 = *(u64 *)(r10 -96)
464: (2d) if r3 > r8 goto pc+56
The sequence of 8193 jumps is too complex.
processed 414429 insns (limit 1000000) max_states_per_insn 4 
total_states 8097 peak_states 97 mark_read 49

libbpf: -- END LOG --
libbpf: failed to load program 'syncookie_xdp'
libbpf: failed to load object '.../samples/bpf/syncookie_kern.o'
Error: bpf_prog_load: Unknown error 4007

real    189m49.659s
user    0m0.012s
sys     189m26.322s

Ubuntu clang version 12.0.0-1ubuntu1

I wonder why it takes only 30 seconds for you. As I understand, the 
expectation is less than 1 second anyway, but the difference between 30 
seconds and 3 hours is huge. Maybe some kernel config options matter 
(KASAN?)

Is it expected that increasing the loop length linearly increases the 
verifying complexity exponentially? Is there any mitigation?

Thanks,
Max

>>
>> --cut--
>>
>> // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>> /* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights 
>> reserved. */
>>
> [...]


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D248B69F0A5
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 09:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjBVIts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 03:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjBVItq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 03:49:46 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7563432E;
        Wed, 22 Feb 2023 00:49:44 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id v3so6853463wrp.2;
        Wed, 22 Feb 2023 00:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5mEsa1ejzLTxMpeAJ7GQBv+4bag7991f9sv2Z+KhuC8=;
        b=PTIX2Hy9WmXm1450bFElNmXVBn9MlXDa52JkxKJAW2nNrVG6lSy8aY1pI+dD8ZFKQD
         quQI02w1lh3oG7WIvPnpMnv4Dy0iKmwl4Kcl90uV+fRy8tM1VQVAFP9qGPAteWqu5++a
         3n4DTCBtQmtvIr9y5LqG47h+JZAdmedCMrIpbAuPHde8u2ErBLi9KKkEYlhCvxgA0liA
         H8dV+UJEUSiflEAvoE7NcSRK1c69lytbo9oO0A3VgcFBIB+hxu5M1d4pqClP7e8kQTfH
         tYWnm29ihECYNNWlKWEuuvH0x+C+ZBLBp04+KoYDgjEBotIG6+VS0u+s33LWfI8KWwdJ
         tRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5mEsa1ejzLTxMpeAJ7GQBv+4bag7991f9sv2Z+KhuC8=;
        b=fRvJuvskvxRjh1+fSLxj/SaxI0mU4kIUE2IrXI7/OoDJTE+uezssNY0sqXe9d+aroN
         R5OOo4aJKXPjf3Lmf0HY7NC1Mah1lTPgvRYbAbYJuRuba0BhAHH5lsUWoyxxHo3/kI1p
         yf3sUKo8avjhdNH+94Xebtsu1g0Mp+BjoylNASYooFZIUnMP6iOMoFFyayXATflGucKF
         hEWpEucgsuiQyFLkpcUv2/aBMKlVqAVpBd70ApJoblkmj3ylfoNcrQsDbGZUeg7QZ4us
         kbBCl6VTyvDtb71h4aQYcgRZwhRENlc/yVpgeelcKWr4C9Z1NOW+1o9HErWt2nP9kJhp
         FSTA==
X-Gm-Message-State: AO0yUKWFMSEmT1AqIz+Q8hfZA4Lhjm0xRm6O8JWawjTKKjAsp858EOXe
        6tsjGzMu/SGgizOP3NqbtS4=
X-Google-Smtp-Source: AK7set+3zFq9aK78tY6ni1fdTcST7tHw98iTheAXjW30jzqwxPb+z6A/OgVvdo8TkknGNXCkoMB9pw==
X-Received: by 2002:adf:f50b:0:b0:2c5:4db8:3dde with SMTP id q11-20020adff50b000000b002c54db83ddemr6146502wro.70.1677055782952;
        Wed, 22 Feb 2023 00:49:42 -0800 (PST)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id j27-20020a5d453b000000b002c577e2fc87sm8430664wra.15.2023.02.22.00.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 00:49:42 -0800 (PST)
Message-ID: <6f90f500-ed4c-0650-0044-1cd1e3a632c3@gmail.com>
Date:   Wed, 22 Feb 2023 10:49:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: Bug report: UDP ~20% degradation
Content-Language: en-US
To:     Vincent Guittot <vincent.guittot@linaro.org>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     David Chen <david.chen@nutanix.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Network Development <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>, Malek Imam <mimam@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Talat Batheesh <talatb@nvidia.com>
References: <113e81f6-b349-97c0-4cec-d90087e7e13b@nvidia.com>
 <CAKfTPtCO=GFm6nKU0DVa-aa3f1pTQ5vBEF+9hJeTR9C_RRRZ9A@mail.gmail.com>
 <8f95150d-db0d-d9e5-4eff-2196d5e8de05@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <8f95150d-db0d-d9e5-4eff-2196d5e8de05@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/02/2023 13:50, Tariq Toukan wrote:
> 
> 
> On 08/02/2023 16:12, Vincent Guittot wrote:
>> Hi Tariq,
>>
>> On Wed, 8 Feb 2023 at 12:09, Tariq Toukan <tariqt@nvidia.com> wrote:
>>>
>>> Hi all,
>>>
>>> Our performance verification team spotted a degradation of up to ~20% in
>>> UDP performance, for a specific combination of parameters.
>>>
>>> Our matrix covers several parameters values, like:
>>> IP version: 4/6
>>> MTU: 1500/9000
>>> Msg size: 64/1452/8952 (only when applicable while avoiding ip
>>> fragmentation).
>>> Num of streams: 1/8/16/24.
>>> Num of directions: unidir/bidir.
>>>
>>> Surprisingly, the issue exists only with this specific combination:
>>> 8 streams,
>>> MTU 9000,
>>> Msg size 8952,
>>> both ipv4/6,
>>> bidir.
>>> (in unidir it repros only with ipv4)
>>>
>>> The reproduction is consistent on all the different setups we tested 
>>> with.
>>>
>>> Bisect [2] was done between these two points, v5.19 (Good), and v6.0-rc1
>>> (Bad), with ConnectX-6DX NIC.
>>>
>>> c82a69629c53eda5233f13fc11c3c01585ef48a2 is the first bad commit [1].
>>>
>>> We couldn't come up with a good explanation how this patch causes this
>>> issue. We also looked for related changes in the networking/UDP stack,
>>> but nothing looked suspicious.
>>>
>>> Maybe someone here can help with this.
>>> We can provide more details or do further tests/experiments to progress
>>> with the debug.
>>
>> Could you share more details about your system and the cpu topology ?
>>
> 
> output for 'lscpu':
> 
> Architecture:                    x86_64
> CPU op-mode(s):                  32-bit, 64-bit
> Address sizes:                   40 bits physical, 57 bits virtual
> Byte Order:                      Little Endian
> CPU(s):                          24
> On-line CPU(s) list:             0-23
> Vendor ID:                       GenuineIntel
> BIOS Vendor ID:                  QEMU
> Model name:                      Intel(R) Xeon(R) Platinum 8380 CPU @ 
> 2.30GHz
> BIOS Model name:                 pc-q35-5.0
> CPU family:                      6
> Model:                           106
> Thread(s) per core:              1
> Core(s) per socket:              1
> Socket(s):                       24
> Stepping:                        6
> BogoMIPS:                        4589.21
> Flags:                           fpu vme de pse tsc msr pae mce cx8 apic 
> sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx 
> pdpe1gb rdtscp lm constant_tsc arch_perfmon rep_good nopl xtopology 
> cpuid tsc_known_freq pni pclmulqdq vmx ssse3 fma cx16 pdcm pcid sse4_1 
> sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand 
> hypervisor lahf_lm abm 3dnowprefetch cpuid_fault invpcid_single ssbd 
> ibrs ibpb stibp ibrs_enhanced tpr_shadow vnmi flexpriority ept vpid 
> ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid avx512f 
> avx512dq rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni 
> avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves wbnoinvd arat 
> avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni 
> avx512_bitalg avx512_vpopcntdq rdpid md_clear arch_capabilities
> Virtualization:                  VT-x
> Hypervisor vendor:               KVM
> Virtualization type:             full
> L1d cache:                       768 KiB (24 instances)
> L1i cache:                       768 KiB (24 instances)
> L2 cache:                        96 MiB (24 instances)
> L3 cache:                        384 MiB (24 instances)
> NUMA node(s):                    1
> NUMA node0 CPU(s):               0-23
> Vulnerability Itlb multihit:     Not affected
> Vulnerability L1tf:              Not affected
> Vulnerability Mds:               Not affected
> Vulnerability Meltdown:          Not affected
> Vulnerability Mmio stale data:   Vulnerable: Clear CPU buffers 
> attempted, no microcode; SMT Host state unknown
> Vulnerability Retbleed:          Not affected
> Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass 
> disabled via prctl
> Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers 
> and __user pointer sanitization
> Vulnerability Spectre v2:        Vulnerable: eIBRS with unprivileged eBPF
> Vulnerability Srbds:             Not affected
> Vulnerability Tsx async abort:   Not affected
> 
>> The commit  c82a69629c53 migrates a task on an idle cpu when the task
>> is the only one running on local cpu but the time spent by this local
>> cpu under interrupt or RT context becomes significant (10%-17%)
>> I can imagine that 16/24 stream overload your system so load_balance
>> doesn't end up in this case and the cpus are busy with several
>> threads. On the other hand, 1 stream is small enough to keep your
>> system lightly loaded but 8 streams make your system significantly
>> loaded to trigger the reduced capacity case but still not overloaded.
>>
> 
> I see. Makes sense.
> 1. How do you check this theory? Any suggested tests/experiments?
> 2. How do you suggest this degradation should be fixed?
> 

Hi,
A kind reminder.

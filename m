Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1E8693715
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 12:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBLLuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 06:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjBLLuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 06:50:35 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CF41040F;
        Sun, 12 Feb 2023 03:50:33 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id m14so9576614wrg.13;
        Sun, 12 Feb 2023 03:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PAjseFappvCbXNndzgK9Rx/Bm85RAHNs9kBGaL53zG0=;
        b=AwXG8VrQ244egUBFKukovpWg9cK0W6DUI9e3e+4nUvpJKtUuEIJw8G6CE3tfsqzvAT
         4GJL9XnsUgPplhoM7vOrT2KnnUdqCdAe6nbZOwgEWSsS6XyC+HsTWKtS4fZ+TQWDtgmm
         OTX3OHVdUtBijLcTfhpmFLsiFnpHFJggdFCuWePlUgdaMCjryTGV8CruIIioeCzTorfc
         1uDA59XKh4TVguYCGUoVMn/66dndICziHFECRUwvrrT7QxWABppkvmkBYPjgxzpVn2Mn
         Rzg35NCoDU0jEnQ2ZkMhBLyv/cG53Q7gj4mL2r+Ou41py99xeeeRPZMyCmTpchpGfery
         RUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PAjseFappvCbXNndzgK9Rx/Bm85RAHNs9kBGaL53zG0=;
        b=6udZNkuIM19py3QdYH4oQD2Yp1mqC51XE8d/x+NO+nzDONiF9uXanimyo4x3lqubmE
         xtgEi5aUJjSoP4Be3IJeQWdxORvDvMOWIwQHgW/kUgnsS5yRp/FVLwssaLTLNubllyxr
         gm1iRcytiHSmalOIE6o6PUsx4LN4SJzjSt7FrsffIwO2Q0uCagClckRHv7ak/IiF7Xrv
         iz9YreDK6z5bOtZhglXSW8E3G++lsHdJfK6DkdKVfnehS2DWxfsCf3feum/H/7Qhz62f
         Gow/4Kt+eFrzyS65Piq3W8hjNvWX6DB45U6bMtdJ6+P2gpzWyvg0ZysDbL/SGl1ayDzu
         1qpA==
X-Gm-Message-State: AO0yUKUPR/0KINr080Y5tJ8rlQ1V35OpYJNc9ogVxAI2bBpG7976utbM
        2feLtONrY4CQOhAzIrwOIOA=
X-Google-Smtp-Source: AK7set+mxQFa/RPRfP2COXmrzF6BE7KRpGXvuJhafKGdg5WiUW3vjxzqyd1evs22edEuwecATYC2GQ==
X-Received: by 2002:adf:cf07:0:b0:2c3:e677:ec5e with SMTP id o7-20020adfcf07000000b002c3e677ec5emr19388908wrj.48.1676202632361;
        Sun, 12 Feb 2023 03:50:32 -0800 (PST)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id g10-20020a05600c310a00b003e1e8d794e1sm1722270wmo.13.2023.02.12.03.50.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Feb 2023 03:50:31 -0800 (PST)
Message-ID: <8f95150d-db0d-d9e5-4eff-2196d5e8de05@gmail.com>
Date:   Sun, 12 Feb 2023 13:50:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: Bug report: UDP ~20% degradation
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
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <CAKfTPtCO=GFm6nKU0DVa-aa3f1pTQ5vBEF+9hJeTR9C_RRRZ9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/02/2023 16:12, Vincent Guittot wrote:
> Hi Tariq,
> 
> On Wed, 8 Feb 2023 at 12:09, Tariq Toukan <tariqt@nvidia.com> wrote:
>>
>> Hi all,
>>
>> Our performance verification team spotted a degradation of up to ~20% in
>> UDP performance, for a specific combination of parameters.
>>
>> Our matrix covers several parameters values, like:
>> IP version: 4/6
>> MTU: 1500/9000
>> Msg size: 64/1452/8952 (only when applicable while avoiding ip
>> fragmentation).
>> Num of streams: 1/8/16/24.
>> Num of directions: unidir/bidir.
>>
>> Surprisingly, the issue exists only with this specific combination:
>> 8 streams,
>> MTU 9000,
>> Msg size 8952,
>> both ipv4/6,
>> bidir.
>> (in unidir it repros only with ipv4)
>>
>> The reproduction is consistent on all the different setups we tested with.
>>
>> Bisect [2] was done between these two points, v5.19 (Good), and v6.0-rc1
>> (Bad), with ConnectX-6DX NIC.
>>
>> c82a69629c53eda5233f13fc11c3c01585ef48a2 is the first bad commit [1].
>>
>> We couldn't come up with a good explanation how this patch causes this
>> issue. We also looked for related changes in the networking/UDP stack,
>> but nothing looked suspicious.
>>
>> Maybe someone here can help with this.
>> We can provide more details or do further tests/experiments to progress
>> with the debug.
> 
> Could you share more details about your system and the cpu topology ?
> 

output for 'lscpu':

Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit
Address sizes:                   40 bits physical, 57 bits virtual
Byte Order:                      Little Endian
CPU(s):                          24
On-line CPU(s) list:             0-23
Vendor ID:                       GenuineIntel
BIOS Vendor ID:                  QEMU
Model name:                      Intel(R) Xeon(R) Platinum 8380 CPU @ 
2.30GHz
BIOS Model name:                 pc-q35-5.0
CPU family:                      6
Model:                           106
Thread(s) per core:              1
Core(s) per socket:              1
Socket(s):                       24
Stepping:                        6
BogoMIPS:                        4589.21
Flags:                           fpu vme de pse tsc msr pae mce cx8 apic 
sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx 
pdpe1gb rdtscp lm constant_tsc arch_perfmon rep_good nopl xtopology 
cpuid tsc_known_freq pni pclmulqdq vmx ssse3 fma cx16 pdcm pcid sse4_1 
sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand 
hypervisor lahf_lm abm 3dnowprefetch cpuid_fault invpcid_single ssbd 
ibrs ibpb stibp ibrs_enhanced tpr_shadow vnmi flexpriority ept vpid 
ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid avx512f 
avx512dq rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni 
avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves wbnoinvd arat 
avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni 
avx512_bitalg avx512_vpopcntdq rdpid md_clear arch_capabilities
Virtualization:                  VT-x
Hypervisor vendor:               KVM
Virtualization type:             full
L1d cache:                       768 KiB (24 instances)
L1i cache:                       768 KiB (24 instances)
L2 cache:                        96 MiB (24 instances)
L3 cache:                        384 MiB (24 instances)
NUMA node(s):                    1
NUMA node0 CPU(s):               0-23
Vulnerability Itlb multihit:     Not affected
Vulnerability L1tf:              Not affected
Vulnerability Mds:               Not affected
Vulnerability Meltdown:          Not affected
Vulnerability Mmio stale data:   Vulnerable: Clear CPU buffers 
attempted, no microcode; SMT Host state unknown
Vulnerability Retbleed:          Not affected
Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass 
disabled via prctl
Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers 
and __user pointer sanitization
Vulnerability Spectre v2:        Vulnerable: eIBRS with unprivileged eBPF
Vulnerability Srbds:             Not affected
Vulnerability Tsx async abort:   Not affected

> The commit  c82a69629c53 migrates a task on an idle cpu when the task
> is the only one running on local cpu but the time spent by this local
> cpu under interrupt or RT context becomes significant (10%-17%)
> I can imagine that 16/24 stream overload your system so load_balance
> doesn't end up in this case and the cpus are busy with several
> threads. On the other hand, 1 stream is small enough to keep your
> system lightly loaded but 8 streams make your system significantly
> loaded to trigger the reduced capacity case but still not overloaded.
> 

I see. Makes sense.
1. How do you check this theory? Any suggested tests/experiments?
2. How do you suggest this degradation should be fixed?

Thanks,
Tariq

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4427369F953
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 17:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjBVQwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 11:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjBVQwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 11:52:05 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EDE3D930
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 08:52:04 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id d10so1044663pgt.12
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 08:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OgFGKCHcPpSicwmjtvQ4xeUm3FP6DvBHB7jDiI5J/2M=;
        b=TH679C3csg8+gq6s8byilYneKQcEqmMLkaju8zvbdGa5wu5h1n41SMYKg09Y5apmIH
         C3M1d7dJrJXlMcPgqNaGnHXHK02VuWHo5E0miIYoR64PGGPo+AsASkwyCulkxiaeJ7L9
         5rDMn9esmz02vNCSNq7bQREv7+PFFiHzh+BKvDYyicx/s6LwDA5lAEZ4rF73xELmVJhD
         dPmxgVubHDM7Va9GLEqtwtnWQEyMBCgRqT4A7uy4gooTahSeOlVUBDcwsl74rg6qV2Ow
         sxSCqlwKBFom5CGpLnY4kf83TF+aAJGDePs0i3xygsjUc747h8YCt4yCJsC5eVnczNGc
         JmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OgFGKCHcPpSicwmjtvQ4xeUm3FP6DvBHB7jDiI5J/2M=;
        b=3d3Wxrx5v8nQNMe6X261mAq8mMooTieKoQL+CQ07zZtK/pCffbZ+HR5Q4Qaxk33YWj
         w3orNunnt2Vtl0HcnCM4j+7bHfx3VBVYDpSYMXf2OR5iKxP0xRr0bmyBhFejtaUOJ2Ir
         gGxPQWVBXawAV9CDz0fep/9z6itw176EqRYlRaVWDNEeq4EgqJyOo18aaD5P5l+MmExv
         EYN7WX9FBLYBuuy1tCJBYRYGT5x7SaRZX+4K8IVSfdoCqRUEXzUoHyUe+lh+5gVMtbAo
         P+ru5P6/rKIy9wh6C8cDZG/29IH9JqWYAmXHfWkURj3+tqzFpBL0fx/Iej23guUWpTaB
         UHBQ==
X-Gm-Message-State: AO0yUKUonC6N94QgEcAJ+g28vN3AD4cHwywsgQPfZyBvc3UUDdHas2XD
        FoC3QHrrbLgymUvHOgL1f3zHYL61ivJ25DjQjhuN+A==
X-Google-Smtp-Source: AK7set85QDn+lIBvpfAllfvA+/HkfOgtbrBtrdoZtd65RCR9vp91odZAfLLxlmekBnO0HwlcvRBubFCi/XUsbDBqeVw=
X-Received: by 2002:a05:6a00:be3:b0:5a9:b27e:af42 with SMTP id
 x35-20020a056a000be300b005a9b27eaf42mr1405058pfu.6.1677084723962; Wed, 22 Feb
 2023 08:52:03 -0800 (PST)
MIME-Version: 1.0
References: <113e81f6-b349-97c0-4cec-d90087e7e13b@nvidia.com>
 <CAKfTPtCO=GFm6nKU0DVa-aa3f1pTQ5vBEF+9hJeTR9C_RRRZ9A@mail.gmail.com>
 <8f95150d-db0d-d9e5-4eff-2196d5e8de05@gmail.com> <6f90f500-ed4c-0650-0044-1cd1e3a632c3@gmail.com>
In-Reply-To: <6f90f500-ed4c-0650-0044-1cd1e3a632c3@gmail.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Wed, 22 Feb 2023 17:51:52 +0100
Message-ID: <CAKfTPtCSw4QL6F7sR+JVSJE2+_zhZ4eNdBtyQx6KZSD_b2kdhw@mail.gmail.com>
Subject: Re: Bug report: UDP ~20% degradation
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        David Chen <david.chen@nutanix.com>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Feb 2023 at 09:49, Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
>
>
> On 12/02/2023 13:50, Tariq Toukan wrote:
> >
> >
> > On 08/02/2023 16:12, Vincent Guittot wrote:
> >> Hi Tariq,
> >>
> >> On Wed, 8 Feb 2023 at 12:09, Tariq Toukan <tariqt@nvidia.com> wrote:
> >>>
> >>> Hi all,
> >>>
> >>> Our performance verification team spotted a degradation of up to ~20% in
> >>> UDP performance, for a specific combination of parameters.
> >>>
> >>> Our matrix covers several parameters values, like:
> >>> IP version: 4/6
> >>> MTU: 1500/9000
> >>> Msg size: 64/1452/8952 (only when applicable while avoiding ip
> >>> fragmentation).
> >>> Num of streams: 1/8/16/24.
> >>> Num of directions: unidir/bidir.
> >>>
> >>> Surprisingly, the issue exists only with this specific combination:
> >>> 8 streams,
> >>> MTU 9000,
> >>> Msg size 8952,
> >>> both ipv4/6,
> >>> bidir.
> >>> (in unidir it repros only with ipv4)
> >>>
> >>> The reproduction is consistent on all the different setups we tested
> >>> with.
> >>>
> >>> Bisect [2] was done between these two points, v5.19 (Good), and v6.0-rc1
> >>> (Bad), with ConnectX-6DX NIC.
> >>>
> >>> c82a69629c53eda5233f13fc11c3c01585ef48a2 is the first bad commit [1].
> >>>
> >>> We couldn't come up with a good explanation how this patch causes this
> >>> issue. We also looked for related changes in the networking/UDP stack,
> >>> but nothing looked suspicious.
> >>>
> >>> Maybe someone here can help with this.
> >>> We can provide more details or do further tests/experiments to progress
> >>> with the debug.
> >>
> >> Could you share more details about your system and the cpu topology ?
> >>
> >
> > output for 'lscpu':
> >
> > Architecture:                    x86_64
> > CPU op-mode(s):                  32-bit, 64-bit
> > Address sizes:                   40 bits physical, 57 bits virtual
> > Byte Order:                      Little Endian
> > CPU(s):                          24
> > On-line CPU(s) list:             0-23
> > Vendor ID:                       GenuineIntel
> > BIOS Vendor ID:                  QEMU
> > Model name:                      Intel(R) Xeon(R) Platinum 8380 CPU @
> > 2.30GHz
> > BIOS Model name:                 pc-q35-5.0
> > CPU family:                      6
> > Model:                           106
> > Thread(s) per core:              1
> > Core(s) per socket:              1
> > Socket(s):                       24
> > Stepping:                        6
> > BogoMIPS:                        4589.21
> > Flags:                           fpu vme de pse tsc msr pae mce cx8 apic
> > sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx
> > pdpe1gb rdtscp lm constant_tsc arch_perfmon rep_good nopl xtopology
> > cpuid tsc_known_freq pni pclmulqdq vmx ssse3 fma cx16 pdcm pcid sse4_1
> > sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
> > hypervisor lahf_lm abm 3dnowprefetch cpuid_fault invpcid_single ssbd
> > ibrs ibpb stibp ibrs_enhanced tpr_shadow vnmi flexpriority ept vpid
> > ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid avx512f
> > avx512dq rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni
> > avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves wbnoinvd arat
> > avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni
> > avx512_bitalg avx512_vpopcntdq rdpid md_clear arch_capabilities
> > Virtualization:                  VT-x
> > Hypervisor vendor:               KVM
> > Virtualization type:             full
> > L1d cache:                       768 KiB (24 instances)
> > L1i cache:                       768 KiB (24 instances)
> > L2 cache:                        96 MiB (24 instances)
> > L3 cache:                        384 MiB (24 instances)
> > NUMA node(s):                    1
> > NUMA node0 CPU(s):               0-23
> > Vulnerability Itlb multihit:     Not affected
> > Vulnerability L1tf:              Not affected
> > Vulnerability Mds:               Not affected
> > Vulnerability Meltdown:          Not affected
> > Vulnerability Mmio stale data:   Vulnerable: Clear CPU buffers
> > attempted, no microcode; SMT Host state unknown
> > Vulnerability Retbleed:          Not affected
> > Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass
> > disabled via prctl
> > Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers
> > and __user pointer sanitization
> > Vulnerability Spectre v2:        Vulnerable: eIBRS with unprivileged eBPF
> > Vulnerability Srbds:             Not affected
> > Vulnerability Tsx async abort:   Not affected
> >
> >> The commit  c82a69629c53 migrates a task on an idle cpu when the task
> >> is the only one running on local cpu but the time spent by this local
> >> cpu under interrupt or RT context becomes significant (10%-17%)
> >> I can imagine that 16/24 stream overload your system so load_balance
> >> doesn't end up in this case and the cpus are busy with several
> >> threads. On the other hand, 1 stream is small enough to keep your
> >> system lightly loaded but 8 streams make your system significantly
> >> loaded to trigger the reduced capacity case but still not overloaded.
> >>
> >
> > I see. Makes sense.
> > 1. How do you check this theory? Any suggested tests/experiments?

Could you get some statistics about the threads involved in your tests
? Like the number of migrations as an example.

Or a trace but that might be a lot of data. I haven't tried to
reproduce this on a local system yet.

You can fall in the situation where the tasks of your bench are
periodically moved to the next cpu becoming idle.

Which cpufreq driver and governor are you using ? Could you also check
the average frequency of your cpu ? Another cause could be that we
spread tasks and irq on different cpus which then trigger a freq
decrease

> > 2. How do you suggest this degradation should be fixed?
> >
>
> Hi,
> A kind reminder.

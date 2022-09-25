Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047325E9189
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 09:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiIYHsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 03:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiIYHso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 03:48:44 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376E337F90;
        Sun, 25 Sep 2022 00:48:43 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a26so8364370ejc.4;
        Sun, 25 Sep 2022 00:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=NPryojRVWrHTWftBM3+nGe/FEaKEi2zn6ID8jRnj95o=;
        b=UHdE/Ozczuk466WSCjjpdbP4Udazo0rO27CzdCgwt98DsrtnGt547Jxj9Xorerej4r
         W9On5DaqxYqI8hhZ8RNpph1FYBjyRAZsC1PwM2sFhL27zSQwQrR85DMakb6WUF1xc5B8
         AdOnOYsWTiUWFuf570ftUWktWxgBWmWQ6F2XG3+hz54C88N19AcJK/+vAzgBHL8P5U8y
         k9Lay1B2pZ2MLBkD1gyJ+2s3CUbtUrGezfmOFhSVjgLsWGZjF71og3KYSXv7j2Z25N6z
         Y+8FnYXAJIt/ZpzMYy8+bdJnCljSxyVM1X5u7N9rgaMgsnOsTN6z1p3WxewIOJED32WJ
         75OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NPryojRVWrHTWftBM3+nGe/FEaKEi2zn6ID8jRnj95o=;
        b=zXfFcuWu3P/2O0YgIGE1hh7osCQ6WrX7ZiRuTuZIdEjEbS5bS+vAcmUQe1BVqcKtWk
         ufSu1ZE0DnH5INwB9L0F0xfBjUWilqOHnA0OPFAAgUwhnvCNu3GLS91khu/6/hml0zPj
         bYKdkNwu8sljv4GTcMX58QVwuzahe2uebZnRWKtGqq68bQmXXANE6Lh1ogtsM6w9ZcUj
         J86YZofHkt+1MX7XE4NCHaZ//X/BnmjcvV1KSnyxBE4PBAeZwg4edOJXnhzmAv1TThOm
         dscnVL4Z/OSm6Eoj9nwqIuTJktFzChFwzuqS2WALoevaYOBUgYGbgVBp6kM4lZDhkPOU
         Yhbg==
X-Gm-Message-State: ACrzQf380Zp/EkzgYGY93q87MRXn79JudmRG2n0UkxQOeo3NKhVc57Uy
        43gt+m6QcCLvlS6jz1kl2sQ=
X-Google-Smtp-Source: AMsMyM486OUL3jZ2ltdLxEmKE1lmKCq+ApFBWoPZnSjv1xr0D6+aTvPlF6arEgFNu5JnG1jCxfVHSg==
X-Received: by 2002:a17:907:2c78:b0:779:7327:c897 with SMTP id ib24-20020a1709072c7800b007797327c897mr13238793ejc.657.1664092121622;
        Sun, 25 Sep 2022 00:48:41 -0700 (PDT)
Received: from [192.168.0.106] ([77.126.16.127])
        by smtp.gmail.com with ESMTPSA id 27-20020a170906301b00b0073d9a0d0cbcsm6468803ejz.72.2022.09.25.00.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Sep 2022 00:48:41 -0700 (PDT)
Message-ID: <edb78d88-4c1b-f73c-0efa-9ccc70e99a48@gmail.com>
Date:   Sun, 25 Sep 2022 10:48:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v4 0/7] sched, net: NUMA-aware CPU spreading interface
Content-Language: en-US
To:     Valentin Schneider <vschneid@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20220923132527.1001870-1-vschneid@redhat.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220923132527.1001870-1-vschneid@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/23/2022 4:25 PM, Valentin Schneider wrote:
> Hi folks,
> 
> Tariq pointed out in [1] that drivers allocating IRQ vectors would benefit
> from having smarter NUMA-awareness (cpumask_local_spread() doesn't quite cut
> it).
> 
> The proposed interface involved an array of CPUs and a temporary cpumask, and
> being my difficult self what I'm proposing here is an interface that doesn't
> require any temporary storage other than some stack variables (at the cost of
> one wild macro).
> 
> Please note that this is based on top of Yury's bitmap-for-next [2] to leverage
> his fancy new FIND_NEXT_BIT() macro.
> 
> [1]: https://lore.kernel.org/all/20220728191203.4055-1-tariqt@nvidia.com/
> [2]: https://github.com/norov/linux.git/ -b bitmap-for-next
> 
> A note on treewide use of for_each_cpu_andnot()
> ===============================================
> 
> I've used the below coccinelle script to find places that could be patched (I
> couldn't figure out the valid syntax to patch from coccinelle itself):
> 
> ,-----
> @tmpandnot@
> expression tmpmask;
> iterator for_each_cpu;
> position p;
> statement S;
> @@
> cpumask_andnot(tmpmask, ...);
> 
> ...
> 
> (
> for_each_cpu@p(..., tmpmask, ...)
> 	S
> |
> for_each_cpu@p(..., tmpmask, ...)
> {
> 	...
> }
> )
> 
> @script:python depends on tmpandnot@
> p << tmpandnot.p;
> @@
> coccilib.report.print_report(p[0], "andnot loop here")
> '-----
> 
> Which yields (against c40e8341e3b3):
> 
> .//arch/powerpc/kernel/smp.c:1587:1-13: andnot loop here
> .//arch/powerpc/kernel/smp.c:1530:1-13: andnot loop here
> .//arch/powerpc/kernel/smp.c:1440:1-13: andnot loop here
> .//arch/powerpc/platforms/powernv/subcore.c:306:2-14: andnot loop here
> .//arch/x86/kernel/apic/x2apic_cluster.c:62:1-13: andnot loop here
> .//drivers/acpi/acpi_pad.c:110:1-13: andnot loop here
> .//drivers/cpufreq/armada-8k-cpufreq.c:148:1-13: andnot loop here
> .//drivers/cpufreq/powernv-cpufreq.c:931:1-13: andnot loop here
> .//drivers/net/ethernet/sfc/efx_channels.c:73:1-13: andnot loop here
> .//drivers/net/ethernet/sfc/siena/efx_channels.c:73:1-13: andnot loop here
> .//kernel/sched/core.c:345:1-13: andnot loop here
> .//kernel/sched/core.c:366:1-13: andnot loop here
> .//net/core/dev.c:3058:1-13: andnot loop here
> 
> A lot of those are actually of the shape
> 
>    for_each_cpu(cpu, mask) {
>        ...
>        cpumask_andnot(mask, ...);
>    }
> 
> I think *some* of the powerpc ones would be a match for for_each_cpu_andnot(),
> but I decided to just stick to the one obvious one in __sched_core_flip().
>    
> Revisions
> =========
> 
> v3 -> v4
> ++++++++
> 
> o Rebased on top of Yury's bitmap-for-next
> o Added Tariq's mlx5e patch
> o Made sched_numa_hop_mask() return cpu_online_mask for the NUMA_NO_NODE &&
>    hops=0 case
> 
> v2 -> v3
> ++++++++
> 
> o Added for_each_cpu_and() and for_each_cpu_andnot() tests (Yury)
> o New patches to fix issues raised by running the above
> 
> o New patch to use for_each_cpu_andnot() in sched/core.c (Yury)
> 
> v1 -> v2
> ++++++++
> 
> o Split _find_next_bit() @invert into @invert1 and @invert2 (Yury)
> o Rebase onto v6.0-rc1
> 
> Cheers,
> Valentin
> 
> Tariq Toukan (1):
>    net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
>      hints
> 
> Valentin Schneider (6):
>    lib/find_bit: Introduce find_next_andnot_bit()
>    cpumask: Introduce for_each_cpu_andnot()
>    lib/test_cpumask: Add for_each_cpu_and(not) tests
>    sched/core: Merge cpumask_andnot()+for_each_cpu() into
>      for_each_cpu_andnot()
>    sched/topology: Introduce sched_numa_hop_mask()
>    sched/topology: Introduce for_each_numa_hop_cpu()
> 
>   drivers/net/ethernet/mellanox/mlx5/core/eq.c | 13 +++++-
>   include/linux/cpumask.h                      | 39 ++++++++++++++++
>   include/linux/find.h                         | 33 +++++++++++++
>   include/linux/topology.h                     | 49 ++++++++++++++++++++
>   kernel/sched/core.c                          |  5 +-
>   kernel/sched/topology.c                      | 31 +++++++++++++
>   lib/cpumask_kunit.c                          | 19 ++++++++
>   lib/find_bit.c                               |  9 ++++
>   8 files changed, 192 insertions(+), 6 deletions(-)
> 
> --
> 2.31.1
> 

Valentin, thank you for investing your time here.

Acked-by: Tariq Toukan <tariqt@nvidia.com>

Tested on my mlx5 environment.
It works as expected, including the case of node == NUMA_NO_NODE.

Regards,
Tariq

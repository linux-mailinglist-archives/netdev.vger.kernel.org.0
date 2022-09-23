Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556B25E7ECC
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiIWPpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiIWPon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:44:43 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5176A2DF9;
        Fri, 23 Sep 2022 08:44:35 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id i3so344704qkl.3;
        Fri, 23 Sep 2022 08:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=J+F/7xSR1fVfr4VMwp8XOBioJhMBO1CARhFRawRhI+o=;
        b=ZrTY/0o7L+Q0IFKktTqkBhHc6cwdzr6NEvMKK47EAIw8ykVLWbCUfc44F8XI1/S0H4
         v/J0d2HLwadmLQxhovem8nompt2UpmeJ5UlqnCO8xQ9Si69cPZiuk+o/D747HUgVZ0RA
         B9lko0W9XQNKQVJuNWpM7qO2B9YSbE+rYaHBbLfM1Jx1e5Rg1nhDkEazuYjx3YpdEd9Z
         H+uq+4wBEBjYUumo+TTAwdLhEtFnzK1r7DYGR4Hk920Bub1banVHyZ2JpMKwhIjxdnTu
         iWQfvTTgsPxcxJoCY9gXOUxCMiHfjD8geIm+MzP70CxsQ3s0b71VbtaGSIuHjgFZj0JT
         MQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=J+F/7xSR1fVfr4VMwp8XOBioJhMBO1CARhFRawRhI+o=;
        b=ORqSj2ld33z13kpRVcyYpyvmfYJaVnLe14sYJ9LWHSTRkY37WmYdGSO0r+onw2kL7K
         21Z6f5zA/9iZveg4UPtDz4XuKg0w7VYN6oZDAph1PMODj/rzxE/AiRwE8Ci0wLz1Vv1Y
         g7iNWXzTVk6aOQmhbiYYmPFaMXFtXGHoHlyPDDZZJ+F5v3kqqn2dRSOYWmhwTbpSzOgD
         zMTlpQGT2gxEfr36S0AhYE7vKVXINmsVdfONO1hKd8hkC03CUFFi8Krgn0Ch/V1krzfi
         7mjX8GB5RgyqZPYZLqs51Dh/rN+zH9/s1hejSMlkHjS3n4LfbuvM8t0HLsvqKrIgZ2aT
         o0SA==
X-Gm-Message-State: ACrzQf0bzM2F6ZmNlgWOpdcOE7ysyRWqCyMVfXiPX1x7t3H4R8/wfUqo
        /Vyb+ZvKYKS2YycLrW2xBo4=
X-Google-Smtp-Source: AMsMyM57vTXHlGuwz69uxcS15p8ZHbwWB1zPQMGd1e+vEq3kvWmFwYBUwgCIPiS7JbaZxL0XpxKmfg==
X-Received: by 2002:a05:620a:4503:b0:6cf:43b6:6673 with SMTP id t3-20020a05620a450300b006cf43b66673mr6042934qkp.729.1663947874034;
        Fri, 23 Sep 2022 08:44:34 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:2170:e39b:cf3e:8e0a])
        by smtp.gmail.com with ESMTPSA id y2-20020a05620a44c200b006bc192d277csm5928968qkp.10.2022.09.23.08.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 08:44:33 -0700 (PDT)
Date:   Fri, 23 Sep 2022 08:44:32 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
Subject: Re: [PATCH v4 0/7] sched, net: NUMA-aware CPU spreading interface
Message-ID: <Yy3UYPU3noB7UtGX@yury-laptop>
References: <20220923132527.1001870-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923132527.1001870-1-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 02:25:20PM +0100, Valentin Schneider wrote:
> Hi folks,

Hi,

I received only 1st patch of the series. Can you give me a link for
the full series so that I'll see how the new API is used?

Thanks,
Yury
 
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
>   for_each_cpu(cpu, mask) {
>       ...
>       cpumask_andnot(mask, ...);
>   }
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
>   hops=0 case
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
>   net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
>     hints
> 
> Valentin Schneider (6):
>   lib/find_bit: Introduce find_next_andnot_bit()
>   cpumask: Introduce for_each_cpu_andnot()
>   lib/test_cpumask: Add for_each_cpu_and(not) tests
>   sched/core: Merge cpumask_andnot()+for_each_cpu() into
>     for_each_cpu_andnot()
>   sched/topology: Introduce sched_numa_hop_mask()
>   sched/topology: Introduce for_each_numa_hop_cpu()
> 
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c | 13 +++++-
>  include/linux/cpumask.h                      | 39 ++++++++++++++++
>  include/linux/find.h                         | 33 +++++++++++++
>  include/linux/topology.h                     | 49 ++++++++++++++++++++
>  kernel/sched/core.c                          |  5 +-
>  kernel/sched/topology.c                      | 31 +++++++++++++
>  lib/cpumask_kunit.c                          | 19 ++++++++
>  lib/find_bit.c                               |  9 ++++
>  8 files changed, 192 insertions(+), 6 deletions(-)
> 
> --
> 2.31.1

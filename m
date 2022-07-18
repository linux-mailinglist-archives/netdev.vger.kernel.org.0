Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0150578433
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiGRNr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbiGRNrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:47:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF3B23BF2;
        Mon, 18 Jul 2022 06:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J02fxs1n/8kyX7XvF1s7j1jst0rwr27utQliCyPhz3s=; b=rCspQLSSbzSPUkSSSMeqml9hI1
        K5TCIMXTyIda3KbVR6Cr1Fa1FZhyuG3B/c/EEehcMV2QKCnEF8iCaaSDBCWF0x3RCNTZvmHyYbuVQ
        YXdYN0gJDHj2TnCKHGosJQQrlszhUc+d5F0ZjC6RBgRrGdxAFkv324tuMIGb/onvPyIgcCTrYOmIZ
        PaIkCwdiMk7WgLiSoMh6OzEfuUvqNkhbuMTXmmFC07v4rzNCSHUYK55K0Ddx7HdFwgFC/rc/mCOy/
        Cp2ZGJSdOrr6TMr0pX4xIxnA3R5UWV5DHMPLI1ZpuL2nq3NHqZ9Ude8Z68Fk6xTDdShBia8t5GUqO
        aGTh4JCg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDR5R-00Cj3N-Pw; Mon, 18 Jul 2022 13:47:02 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1A010980299; Mon, 18 Jul 2022 15:47:01 +0200 (CEST)
Date:   Mon, 18 Jul 2022 15:47:01 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V2 1/2] sched/topology: Expose
 sched_numa_find_closest
Message-ID: <YtVkVQvbh9K93WJg@worktop.programming.kicks-ass.net>
References: <20220718124315.16648-1-tariqt@nvidia.com>
 <20220718124315.16648-2-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718124315.16648-2-tariqt@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 03:43:14PM +0300, Tariq Toukan wrote:
> This logic can help device drivers prefer some remote cpus
> over others, according to the NUMA distance metrics.
> 
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> ---
>  include/linux/sched/topology.h | 2 ++
>  kernel/sched/topology.c        | 1 +
>  2 files changed, 3 insertions(+)
> 
> v2:
> Replaced EXPORT_SYMBOL with EXPORT_SYMBOL_GPL, per Peter's comment.
> 
> diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
> index 56cffe42abbc..d467c30bdbb9 100644
> --- a/include/linux/sched/topology.h
> +++ b/include/linux/sched/topology.h
> @@ -61,6 +61,8 @@ static inline int cpu_numa_flags(void)
>  {
>  	return SD_NUMA;
>  }
> +
> +int sched_numa_find_closest(const struct cpumask *cpus, int cpu);
>  #endif
>  
>  extern int arch_asym_cpu_priority(int cpu);
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 05b6c2ad90b9..274fb2bd3849 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2066,6 +2066,7 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
>  
>  	return found;
>  }
> +EXPORT_SYMBOL_GPL(sched_numa_find_closest);
>  
>  #endif /* CONFIG_NUMA */
>  
> -- 
> 2.21.0
> 

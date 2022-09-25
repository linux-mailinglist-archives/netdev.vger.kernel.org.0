Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63505E93CE
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 17:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiIYPAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 11:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIYPAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 11:00:51 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452652C122;
        Sun, 25 Sep 2022 08:00:50 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id s13so2983555qvq.10;
        Sun, 25 Sep 2022 08:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=k7/n9LKl8+NYBvbK3GjeK8nB3W0PcRRMS1DKnCrW1Ds=;
        b=TWQf5CQTSWAkaIQLU/iRDaGW8c/OpljZVoIS2h5PLroE+mx9ceMOL0dMqRjtwNCXxA
         EyuSHABw80pVQUrwPu/kvYNlcUfFLPTKz4FVfyfNuEqbawhnVMrQ2ZJSDSGL7Pcyv17c
         8cmtPSGiKkhpWwMv6gg4cC+m7kYqJ4HXpyJ202RR/7sApLdXx7vwRn321yDd/T806p39
         MRQp+qgZSLvC4EyXWULnjLzf6yu+jABBrVd16/PI5rSkuhF2dKll5mF5rYFsD5gxhciU
         +UoMXqqpc8N1Zgw5NVQGmKSORQdsa6viJsQBFulXa6tSrFkDeGuukgf0G+FWY2mrlMOp
         4pUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=k7/n9LKl8+NYBvbK3GjeK8nB3W0PcRRMS1DKnCrW1Ds=;
        b=oiRMBLMhmVvo5/u8wXAEY/vF6JSD6b0d99+QcbB3Feg2Mblxa40zu0g27noagH8w/J
         /wYirV8YSxytUi0BNUfsZgh/ba1Lj7uK5CLGbZLC9S3ByayWxZMnw6SSmb7/Ikcf5kQa
         u5LS5mxurRWHgL73fNUvP2xI0m6dAFHMX/wH2Ep1g10EjOTTHzyP97Nt44RnZbrEDOyB
         rdsYrc2FaRS/IltYvoCWKHg6ZYCs0JNDh+HWAPIjijf9m2g5acFAt6kAAXLu01aBi9jc
         +mBrTub1+r7gttS36nRODqyaftcYccuLbSV1/Vgq0bfohhlnn2aSwALWCszgR43T+otE
         WCKw==
X-Gm-Message-State: ACrzQf0lzYxjrxrm0t1/N1cgrwpuJ8ZqpeGQcLLBsMy/j3xf/stv0PRa
        tYVIJAVt6jx/bFJ0lZwE0A8=
X-Google-Smtp-Source: AMsMyM6VEuIG+hFLwoHz2z6MudX8NGFGWVwAv0eNrGzy3AifikKHtUxACRJww5yThr6Fojdjw0hGFw==
X-Received: by 2002:ad4:5763:0:b0:4ad:6e59:f09e with SMTP id r3-20020ad45763000000b004ad6e59f09emr14166218qvx.119.1664118048997;
        Sun, 25 Sep 2022 08:00:48 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:2eaf:6d8e:66c4:eb75])
        by smtp.gmail.com with ESMTPSA id t6-20020a05622a01c600b0035bb84a4150sm9656368qtw.71.2022.09.25.08.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 08:00:48 -0700 (PDT)
Date:   Sun, 25 Sep 2022 08:00:47 -0700
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
Subject: Re: [PATCH v4 5/7] sched/topology: Introduce sched_numa_hop_mask()
Message-ID: <YzBtH8s98eTmxaJo@yury-laptop>
References: <20220923132527.1001870-1-vschneid@redhat.com>
 <20220923155542.1212814-4-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923155542.1212814-4-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 04:55:40PM +0100, Valentin Schneider wrote:
> Tariq has pointed out that drivers allocating IRQ vectors would benefit
> from having smarter NUMA-awareness - cpumask_local_spread() only knows
> about the local node and everything outside is in the same bucket.
> 
> sched_domains_numa_masks is pretty much what we want to hand out (a cpumask
> of CPUs reachable within a given distance budget), introduce
> sched_numa_hop_mask() to export those cpumasks.
> 
> Link: http://lore.kernel.org/r/20220728191203.4055-1-tariqt@nvidia.com
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>  include/linux/topology.h | 12 ++++++++++++
>  kernel/sched/topology.c  | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 4564faafd0e1..3e91ae6d0ad5 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -245,5 +245,17 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
>  	return cpumask_of_node(cpu_to_node(cpu));
>  }
>  
> +#ifdef CONFIG_NUMA
> +extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
> +#else
> +static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
> +{
> +	if (node == NUMA_NO_NODE && !hops)
> +		return cpu_online_mask;
> +
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +#endif	/* CONFIG_NUMA */
> +
>  
>  #endif /* _LINUX_TOPOLOGY_H */
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 8739c2a5a54e..ee77706603c0 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2067,6 +2067,37 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
>  	return found;
>  }
>  
> +/**
> + * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away.
> + * @node: The node to count hops from.
> + * @hops: Include CPUs up to that many hops away. 0 means local node.
> + *
> + * Requires rcu_lock to be held. Returned cpumask is only valid within that
> + * read-side section, copy it if required beyond that.
> + *
> + * Note that not all hops are equal in distance; see sched_init_numa() for how
> + * distances and masks are handled.
> + *
> + * Also note that this is a reflection of sched_domains_numa_masks, which may change
> + * during the lifetime of the system (offline nodes are taken out of the masks).
> + */

Since it's exported, can you declare function parameters and return
values properly?

> +const struct cpumask *sched_numa_hop_mask(int node, int hops)
> +{
> +	struct cpumask ***masks = rcu_dereference(sched_domains_numa_masks);
> +
> +	if (node == NUMA_NO_NODE && !hops)
> +		return cpu_online_mask;
> +
> +	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (!masks)
> +		return NULL;
> +
> +	return masks[hops][node];
> +}
> +EXPORT_SYMBOL_GPL(sched_numa_hop_mask);
> +
>  #endif /* CONFIG_NUMA */
>  
>  static int __sdt_alloc(const struct cpumask *cpu_map)
> -- 
> 2.31.1

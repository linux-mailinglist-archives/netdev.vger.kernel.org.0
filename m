Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E025E953B
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 20:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbiIYSFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 14:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiIYSFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 14:05:20 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B2D1CB2E;
        Sun, 25 Sep 2022 11:05:18 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id b23so2920493qtr.13;
        Sun, 25 Sep 2022 11:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=JKE0avk2agse0RfyTYwfmZtHd0Xz4kE8lQXynudu2As=;
        b=pPEosRMaSEYtfU7ncPPfTGVrG73p1rJV3iAiOcnyzLB3OMEbJxsRKSM55vo3kYlrsP
         0XWlin6agoRCfdz3YZdupnxBZxV1pweOIpUts1QHO9HNfufEbFao3Uz0VD2QcEwfB4t2
         tZGRN/Dae2PzxR5BKzOz3L2EsbVGHu+sH8xhkc4Tx8RV+hfWadhHLKUukC9aEgdjzy8z
         O8QIDva69zSGLGY74o9SKpBGh5tqMmfqievfRmhuKHiawC+hL/i7hmuVHjwFvn4zcMvx
         0TY4tpSLG5XL+x2fkYw1bH4zRGWRYLuT9y6+QdCR6vL13Fl8wlXTGy/dNUsLtbwwt53L
         b4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JKE0avk2agse0RfyTYwfmZtHd0Xz4kE8lQXynudu2As=;
        b=ZQozt131Gt8udUp9naRDwlmnt+ehlaeJ6/Vqn6SewANEVJpEqkhTP2NlkNmOve5Apd
         EY/7C6uhwXH2+64/3uQRczCHqdd6GOvL/LpcIWVPF4j7XDnqEwDnGRzn/LnujY53EhoC
         dAbuBfQidTaXbpqc3XPmKCWwusq6bU9d28+Lzrv4+OQq99mpvqQzAoIzQykh4d3mAD7p
         F7YIZ89ZnN+aWfR9j8CKX8YQqTCG+0n9m0hFgWj0AO6rWz5DQQqSrGsixrb4J9llNC30
         AXjUmiuyp3lPs5H5/IvMEJ1bM4qB5KMO23dcf5zChdOSOkinf1oCUpuGTIY39m230yUF
         xkJA==
X-Gm-Message-State: ACrzQf1B6e55dizR1EtFw7c9A9FcZhwUnaGJG10wctQXm5Yo/gDtClyA
        Z80O+zLzp/f9NqM3W9yUEJA=
X-Google-Smtp-Source: AMsMyM6EBZiZ+Y7U/trqNcXvNyJNbSikwbfTJy5j5025u/0IbZIE3wssrJPH/05w2NMvJYAYKMPg5g==
X-Received: by 2002:ac8:5c55:0:b0:35b:b8d9:2ff8 with SMTP id j21-20020ac85c55000000b0035bb8d92ff8mr15240964qtj.554.1664129117774;
        Sun, 25 Sep 2022 11:05:17 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:7be8:ebb8:b71d:18b9])
        by smtp.gmail.com with ESMTPSA id bq22-20020a05622a1c1600b0035ba48c032asm9388700qtb.25.2022.09.25.11.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 11:05:17 -0700 (PDT)
Date:   Sun, 25 Sep 2022 11:05:16 -0700
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
Message-ID: <YzCYXEytXy8UJQFv@yury-laptop>
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
> +const struct cpumask *sched_numa_hop_mask(int node, int hops)
> +{
> +	struct cpumask ***masks = rcu_dereference(sched_domains_numa_masks);
> +
> +	if (node == NUMA_NO_NODE && !hops)
> +		return cpu_online_mask;
> +
> +	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
> +		return ERR_PTR(-EINVAL);

This looks like a sanity check. If so, it should go before the snippet
above, so that client code would behave consistently.

> +
> +	if (!masks)
> +		return NULL;

In (node == NUMA_NO_NODE && !hops) case you return online cpus. Here
you return NULL just to convert it to cpu_online_mask in the caller.
This looks inconsistent. So, together with the above comment, this
makes me feel that you'd do it like this:

 const struct cpumask *sched_numa_hop_mask(int node, int hops)
 {
	struct cpumask ***masks;

	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
        {
 #ifdef CONFIG_SCHED_DEBUG
                pr_err(...);
 #endif
		return ERR_PTR(-EINVAL);
        }

	if (node == NUMA_NO_NODE && !hops)
		return cpu_online_mask; /* or NULL */

        masks = rcu_dereference(sched_domains_numa_masks);
	if (!masks)
		return cpu_online_mask; /* or NULL */

	return masks[hops][node];
 }

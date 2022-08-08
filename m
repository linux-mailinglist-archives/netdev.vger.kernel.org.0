Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C5758CAA4
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 16:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243009AbiHHOjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 10:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242542AbiHHOjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 10:39:15 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8910DBF6B;
        Mon,  8 Aug 2022 07:39:09 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id q1-20020a05600c040100b003a52db97fffso2650480wmb.4;
        Mon, 08 Aug 2022 07:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=nchxxht1A2DhUXz5mgywXQGXigLJr21XLNIvAj/Rk48=;
        b=qNFn1GhNDVQ/3aAZgW5aR4YSk0GUww2EaFGaNttYXPBlYNKWsydJsOAznilwbwbwyq
         bDqnNPgpPoBTCIhKe8IyiloUbZA8Vx31cH80EmekZO7XpGL9/j1YEezs699vdhYqQUvp
         wQNxqFzWO4v5AfF3tIAcrbJM85wKcK27iVRPssUUJ3UqwzDkBrP8BHrb90r1BtqbDXbx
         27+rEOjnR1Z1QNlEin+4D12uj22k+BP7xOjDWv/qoN2+Y1ZrKyXm4sRHlDbFuasfQSlR
         YekanHB8nAgOJFMRLiw5LzS8DFO505kbUUgGvA91v124SsZxCf/1nLvS34TlKGfWIGvO
         /HRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=nchxxht1A2DhUXz5mgywXQGXigLJr21XLNIvAj/Rk48=;
        b=cYlVxmsXNDs0sc9cp+ftf7GCP935NrAjXw0G9CqkrroxjRNM1zMTT0gzdyFDb3fIpt
         BbhlL32Sy2YLM+klrcHzrIAVKR1iAgiCY36FZjR3hjOW7koZFLAxRr8K0ApOpmZRYdRH
         g9R2PaPsqYxOEJZOwTuIg9OHhAxHUMPb39qlWYTROE2eGiA4Dh23pXnr9D9A+tWgAVFT
         gcfLTFAKdeh5fqfCMN1ta1rXg4OMOHzGlDnh1X3jue+66pO3KfmdWlqlomW28IZn1Hur
         KAn54zhgEUUZ8Zc2IoCUceRw8JvnHIux5526rcLpFNTasiTQaZZ3zfohtj8rToXKmOgU
         Xq2w==
X-Gm-Message-State: ACgBeo2TLViX0iCjjdVVf9RgtJkS4mQt+yO/m+0qwq5fc7AdK9+mN9fy
        T6AkgcFc1AOMOc63IHk7srg=
X-Google-Smtp-Source: AA6agR6VAAvZBkYjr4LFwhGN74rsKgB4cUpS9V/KF7pAPS1yz12Wxtvbxpssbx8GLCq5IpMu6tjqzA==
X-Received: by 2002:a7b:c7c9:0:b0:3a5:18ff:753b with SMTP id z9-20020a7bc7c9000000b003a518ff753bmr10484068wmk.172.1659969547851;
        Mon, 08 Aug 2022 07:39:07 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id o41-20020a05600c512900b003a2e1883a27sm22548142wms.18.2022.08.08.07.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 07:39:07 -0700 (PDT)
Message-ID: <df8b684d-ede6-7412-423d-51d57365e065@gmail.com>
Date:   Mon, 8 Aug 2022 17:39:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next V4 1/3] sched/topology: Add NUMA-based CPUs
 spread API
Content-Language: en-US
To:     Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org
References: <20220728191203.4055-1-tariqt@nvidia.com>
 <20220728191203.4055-2-tariqt@nvidia.com>
 <xhsmhedxvdikz.mognet@vschneid.remote.csb>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <xhsmhedxvdikz.mognet@vschneid.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/2022 8:28 PM, Valentin Schneider wrote:
> On 28/07/22 22:12, Tariq Toukan wrote:
>> Implement and expose API that sets the spread of CPUs based on distance,
>> given a NUMA node.  Fallback to legacy logic that uses
>> cpumask_local_spread.
>>
>> This logic can be used by device drivers to prefer some remote cpus over
>> others.
>>
>> Reviewed-by: Gal Pressman <gal@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> 
> IIUC you want a multi-CPU version of sched_numa_find_closest(). I'm OK with
> the need (and you have the numbers to back it up), but I have some qualms
> with the implementation, see more below.
> 

I want a sorted multi-CPU version.

>> ---
>>   include/linux/sched/topology.h |  5 ++++
>>   kernel/sched/topology.c        | 49 ++++++++++++++++++++++++++++++++++
>>   2 files changed, 54 insertions(+)
>>
>> diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
>> index 56cffe42abbc..a49167c2a0e5 100644
>> --- a/include/linux/sched/topology.h
>> +++ b/include/linux/sched/topology.h
>> @@ -210,6 +210,7 @@ extern void set_sched_topology(struct sched_domain_topology_level *tl);
>>   # define SD_INIT_NAME(type)
>>   #endif
>>
>> +void sched_cpus_set_spread(int node, u16 *cpus, int ncpus);
>>   #else /* CONFIG_SMP */
>>
>>   struct sched_domain_attr;
>> @@ -231,6 +232,10 @@ static inline bool cpus_share_cache(int this_cpu, int that_cpu)
>>        return true;
>>   }
>>
>> +static inline void sched_cpus_set_spread(int node, u16 *cpus, int ncpus)
>> +{
>> +	memset(cpus, 0, ncpus * sizeof(*cpus));
>> +}
>>   #endif	/* !CONFIG_SMP */
>>
>>   #if defined(CONFIG_ENERGY_MODEL) && defined(CONFIG_CPU_FREQ_GOV_SCHEDUTIL)
>> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
>> index 05b6c2ad90b9..157aef862c04 100644
>> --- a/kernel/sched/topology.c
>> +++ b/kernel/sched/topology.c
>> @@ -2067,8 +2067,57 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
>>        return found;
>>   }
>>
>> +static bool sched_cpus_spread_by_distance(int node, u16 *cpus, int ncpus)
>                                                         ^^^^^^^^^
> That should be a struct *cpumask.

With cpumask, we'll lose the order.

> 
>> +{
>> +	cpumask_var_t cpumask;
>> +	int first, i;
>> +
>> +	if (!zalloc_cpumask_var(&cpumask, GFP_KERNEL))
>> +		return false;
>> +
>> +	cpumask_copy(cpumask, cpu_online_mask);
>> +
>> +	first = cpumask_first(cpumask_of_node(node));
>> +
>> +	for (i = 0; i < ncpus; i++) {
>> +		int cpu;
>> +
>> +		cpu = sched_numa_find_closest(cpumask, first);
>> +		if (cpu >= nr_cpu_ids) {
>> +			free_cpumask_var(cpumask);
>> +			return false;
>> +		}
>> +		cpus[i] = cpu;
>> +		__cpumask_clear_cpu(cpu, cpumask);
>> +	}
>> +
>> +	free_cpumask_var(cpumask);
>> +	return true;
>> +}
> 
> This will fail if ncpus > nr_cpu_ids, which shouldn't be a problem. It
> would make more sense to set *up to* ncpus, the calling code can then
> decide if getting fewer than requested is OK or not.
> 
> I also don't get the fallback to cpumask_local_spread(), is that if the
> NUMA topology hasn't been initialized yet? It feels like most users of this
> would invoke it late enough (i.e. anything after early initcalls) to have
> the backing data available.

I don't expect this to fail, as we invoke it late enough. Fallback is 
there just in case, to preserve the old behavior instead of getting 
totally broken.

> 
> Finally, I think iterating only once per NUMA level would make more sense.

Agree, although it's just a setup stage.
I'll check if it can work for me, based on the reference code below.

> 
> I've scribbled something together from those thoughts, see below. This has
> just the mlx5 bits touched to show what I mean, but that's just compile
> tested.

My function returns a *sorted* list of the N closest cpus.
That is important. In many cases, drivers do not need all N irqs, but 
only a portion of it, so it wants to use the closest subset of cpus.

IIUC, the code below relaxes this and returns the set of N closest cpus, 
unsorted.


> ---
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> index 229728c80233..2d010d8d670c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> @@ -810,7 +810,7 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
>   {
>   	struct mlx5_eq_table *table = dev->priv.eq_table;
>   	int ncomp_eqs = table->num_comp_eqs;
> -	u16 *cpus;
> +	cpumask_var_t cpus;
>   	int ret;
>   	int i;
>   
> @@ -825,15 +825,14 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
>   		return ret;
>   	}
>   
> -	cpus = kcalloc(ncomp_eqs, sizeof(*cpus), GFP_KERNEL);
> -	if (!cpus) {
> +	if (!zalloc_cpumask_var(&cpus, GFP_KERNEL)) {
>   		ret = -ENOMEM;
>   		goto free_irqs;
>   	}
> -	for (i = 0; i < ncomp_eqs; i++)
> -		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
> +
> +	sched_numa_find_n_closest(cpus, dev->piv.numa_node, ncomp_eqs);
>   	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
> -	kfree(cpus);
> +	free_cpumask_var(cpus);
>   	if (ret < 0)
>   		goto free_irqs;
>   	return ret;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> index 662f1d55e30e..2330f81aeede 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> @@ -448,7 +448,7 @@ void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs)
>   /**
>    * mlx5_irqs_request_vectors - request one or more IRQs for mlx5 device.
>    * @dev: mlx5 device that is requesting the IRQs.
> - * @cpus: CPUs array for binding the IRQs
> + * @cpus: cpumask for binding the IRQs
>    * @nirqs: number of IRQs to request.
>    * @irqs: an output array of IRQs pointers.
>    *
> @@ -458,25 +458,22 @@ void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs)
>    * This function returns the number of IRQs requested, (which might be smaller than
>    * @nirqs), if successful, or a negative error code in case of an error.
>    */
> -int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
> +int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev,
> +			      const struct cpumask *cpus,
> +			      int nirqs,
>   			      struct mlx5_irq **irqs)
>   {
> -	cpumask_var_t req_mask;
> +	int cpu = cpumask_first(cpus);
>   	struct mlx5_irq *irq;
> -	int i;
>   
> -	if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
> -		return -ENOMEM;
> -	for (i = 0; i < nirqs; i++) {
> -		cpumask_set_cpu(cpus[i], req_mask);
> -		irq = mlx5_irq_request(dev, i, req_mask);
> +	for (i = 0; i < nirqs && cpu < nr_cpu_ids; i++) {
> +		irq = mlx5_irq_request(dev, i, cpumask_of(cpu));
>   		if (IS_ERR(irq))
>   			break;
> -		cpumask_clear(req_mask);
>   		irqs[i] = irq;
> +		cpu = cpumask_next(cpu, cpus);
>   	}
>   
> -	free_cpumask_var(req_mask);
>   	return i ? i : PTR_ERR(irq);
>   }
>   
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 4564faafd0e1..bdc9c5df84cd 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -245,5 +245,13 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
>   	return cpumask_of_node(cpu_to_node(cpu));
>   }
>   
> +#ifdef CONFIG_NUMA
> +extern int sched_numa_find_n_closest(struct cpumask *cpus, int node, int ncpus);
> +#else
> +static inline int sched_numa_find_n_closest(struct cpumask *cpus, int node, int ncpus)
> +{
> +	return -ENOTSUPP;
> +}
> +#endif
>   
>   #endif /* _LINUX_TOPOLOGY_H */
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 8739c2a5a54e..499f6ef611fa 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2067,6 +2067,56 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
>   	return found;
>   }
>   
> +/**
> + * sched_numa_find_n_closest - Find the 'n' closest cpus to a given node
> + * @cpus: The cpumask to fill in with CPUs
> + * @ncpus: How many CPUs to look for
> + * @node: The node to start the search from
> + *
> + * This will fill *up to* @ncpus in @cpus, using the closest (in NUMA distance)
> + * first and expanding outside the node if more CPUs are required.
> + *
> + * Return: Number of found CPUs, negative value on error.
> + */
> +int sched_numa_find_n_closest(struct cpumask *cpus, int node, int ncpus)
> +{
> +	struct cpumask ***masks;
> +	int cpu, lvl, ntofind = ncpus;
> +
> +	if (node >= nr_node_ids)
> +		return -EINVAL;
> +
> +	rcu_read_lock();
> +
> +	masks = rcu_dereference(sched_domains_numa_masks);
> +	if (!masks)
> +		goto unlock;
> +
> +	/*
> +	 * Walk up the level masks; the first mask should be CPUs LOCAL_DISTANCE
> +	 * away (aka the local node), and we incrementally grow the search
> +	 * beyond that.
> +	 */
> +	for (lvl = 0; lvl < sched_domains_numa_levels; lvl++) {
> +		if (!masks[lvl][node])
> +			goto unlock;
> +
> +		/* XXX: could be neater with for_each_cpu_andnot() */
> +		for_each_cpu(cpu, masks[lvl][node]) {
> +			if (cpumask_test_cpu(cpu, cpus))
> +				continue;
> +
> +			__cpumask_set_cpu(cpu, cpus);
> +			if (--ntofind == 0)
> +				goto unlock;
> +		}
> +	}
> +unlock:
> +	rcu_read_unlock();
> +	return ncpus - ntofind;
> +}
> +EXPORT_SYMBOL_GPL(sched_numa_find_n_closest);
> +
>   #endif /* CONFIG_NUMA */
>   
>   static int __sdt_alloc(const struct cpumask *cpu_map)
> 

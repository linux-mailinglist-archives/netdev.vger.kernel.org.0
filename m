Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFDB591F13
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 10:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiHNITP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 04:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiHNITO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 04:19:14 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1880F15FF5;
        Sun, 14 Aug 2022 01:19:11 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n4so5727059wrp.10;
        Sun, 14 Aug 2022 01:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=iy8truvTqzSqr+9WYjyhlsrIh8jpWPkvlc0GKe4+4ms=;
        b=kV3RryWwUAHogBRIkEK9QWFFDwpPzgmmVundfRU8gl1WFKIWX6cOv4osd1PZ6VsB3w
         YJ+CsuaHVM8bSrAdwhcPT6CdgTkqi9dC8HThA7M5xi/9anV2v5aZuR8cqy3wVcP0IYVT
         ocnCVj3JHcUTBsdFACVTxyDrbx/oGRj2XLTnXuhSA7RPXBqDZgrLZN86iiYa3dRUwEd9
         6OBMow7uSiAEo+FsVvns9Q3ZD21ARu0nErzBqQUV9ss0H1/RgJAOCEJIlawdJeSsDd3l
         rg3vVr5cuCZo6CbWtZYnNEFKBrm18vWcgtSyzpnYeRq+0uzKHtpVsx4rEpuOzmd90ptw
         eRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=iy8truvTqzSqr+9WYjyhlsrIh8jpWPkvlc0GKe4+4ms=;
        b=OgWd+5Ensp6TSeENS1QOtZZ8t4WVILbCfUW13gNCN+KJh22B6bXtVE6bmoYu5SBqXY
         Tkw1KpwTF80QiB/7TcKKLEMESbIVS3C9PjV1biK4zVasd6Yqhs6I/gR9j+O3CGu4iw5Z
         0UVBZMuo577tAyj63y+yTSkmRi4/kEyTEjlARgL9/3QyW5e3hEJfJ9PMdUctB0h8srjK
         W+2SY0kSjADr2+o64akRBug7Svcp8XM9kZ9OAEAjbKzDe2J6wrEwp8w7LSQCKJFqSFzf
         fK2YaEYneLMss4QGfwfZwtzmHIF2vUzDT9evGHOIeRqdtI1+ykhko7/8FSziAjSG2GKG
         zUCQ==
X-Gm-Message-State: ACgBeo3jJThun9VJBq8JpyhBjXGSZae/I9352ByQx2gIe3mfKn4O0Ktj
        CVI39aVCY2ON4mfNja9Eelw=
X-Google-Smtp-Source: AA6agR7JNqRvITfDsD6k0aIJRX9uEaWw1fjH6C83nzw0csIW+69YVfbFlw41KC/6U9A/Mp7lq438Jw==
X-Received: by 2002:a5d:5a96:0:b0:223:8131:e4f2 with SMTP id bp22-20020a5d5a96000000b002238131e4f2mr5854694wrb.345.1660465149425;
        Sun, 14 Aug 2022 01:19:09 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id c14-20020adffb4e000000b002205cbc1c74sm3890005wrs.101.2022.08.14.01.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Aug 2022 01:19:09 -0700 (PDT)
Message-ID: <6a2dae6d-cbac-84ba-8852-dadd183fb77d@gmail.com>
Date:   Sun, 14 Aug 2022 11:19:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/2] sched/topology: Introduce sched_numa_hop_mask()
Content-Language: en-US
To:     Valentin Schneider <vschneid@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
References: <xhsmhtu6kbckc.mognet@vschneid.remote.csb>
 <20220810105119.2684079-1-vschneid@redhat.com>
 <db20e6fe-4368-15ec-65c5-ead28fc7981b@gmail.com>
 <03aaf512-3ac5-fdfe-da2d-3fecd24591e2@gmail.com>
 <xhsmhmtcac0up.mognet@vschneid.remote.csb>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <xhsmhmtcac0up.mognet@vschneid.remote.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/2022 5:26 PM, Valentin Schneider wrote:
> On 10/08/22 15:57, Tariq Toukan wrote:
>> On 8/10/2022 3:42 PM, Tariq Toukan wrote:
>>>
>>>
>>> On 8/10/2022 1:51 PM, Valentin Schneider wrote:
>>>> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
>>>> index 8739c2a5a54e..f0236a0ae65c 100644
>>>> --- a/kernel/sched/topology.c
>>>> +++ b/kernel/sched/topology.c
>>>> @@ -2067,6 +2067,34 @@ int sched_numa_find_closest(const struct
>>>> cpumask *cpus, int cpu)
>>>>        return found;
>>>>    }
>>>> +/**
>>>> + * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops
>>>> away.
>>>> + * @node: The node to count hops from.
>>>> + * @hops: Include CPUs up to that many hops away. 0 means local node.
>>
>> AFAIU, here you work with a specific level/num of hops, description is
>> not accurate.
>>
> 
> Hmph, unfortunately it's the other way around - the masks do include CPUs
> *up to* a number of hops, but in my mlx5 example I've used it as if it only
> included CPUs a specific distance away :/
> 

Aha, got it. It makes it more challenging :)

> As things stand we'd need a temporary cpumask to account for which CPUs we
> have visited (which is what you had in your original submission), but with
> a for_each_cpu_andnot() we don't need any of that.
> 
> Below is what I ended up with. I've tested it on a range of NUMA topologies
> and it behaves as I'd expect, and on the plus side the code required in the
> driver side is even simpler than before.
> 
> If you don't have major gripes with it, I'll shape that into a proper
> series and will let you handle the mlx5/enic bits.
> 

The API is indeed easy to use, the driver part looks straight forward.

I appreciate the tricks you used to make it work!
However, the implementation is relatively complicated, not easy to read 
or understand, and touches several files. I do understand what you did 
here, but I guess not all respective maintainers will like it. Let's see.

One alternative to consider, that will simplify things up, is switching 
back to returning an array of cpus, ordered by their distance, up to a 
provided argument 'npus'.
This way, you will iterate over sched_numa_hop_mask() internally, easily 
maintaining the cpumask diffs between two hops, without the need of 
making it on-the-fly as part an an exposed for-loop macro.

> ---
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> index 229728c80233..0a5432903edd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> @@ -812,6 +812,7 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
>   	int ncomp_eqs = table->num_comp_eqs;
>   	u16 *cpus;
>   	int ret;
> +	int cpu;
>   	int i;
>   
>   	ncomp_eqs = table->num_comp_eqs;
> @@ -830,8 +831,15 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
>   		ret = -ENOMEM;
>   		goto free_irqs;
>   	}
> -	for (i = 0; i < ncomp_eqs; i++)
> -		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
> +
> +	rcu_read_lock();
> +	for_each_numa_hop_cpus(cpu, dev->priv.numa_node) {
> +		cpus[i] = cpu;
> +		if (++i == ncomp_eqs)
> +			goto spread_done;
> +	}
> +spread_done:
> +	rcu_read_unlock();
>   	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
>   	kfree(cpus);
>   	if (ret < 0)
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index fe29ac7cc469..ccd5d71aefef 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -157,6 +157,13 @@ static inline unsigned int cpumask_next_and(int n,
>   	return n+1;
>   }
>   
> +static inline unsigned int cpumask_next_andnot(int n,
> +					    const struct cpumask *srcp,
> +					    const struct cpumask *andp)
> +{
> +	return n+1;
> +}
> +
>   static inline unsigned int cpumask_next_wrap(int n, const struct cpumask *mask,
>   					     int start, bool wrap)
>   {
> @@ -194,6 +201,8 @@ static inline int cpumask_any_distribute(const struct cpumask *srcp)
>   	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)(start))
>   #define for_each_cpu_and(cpu, mask1, mask2)	\
>   	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask1, (void)mask2)
> +#define for_each_cpu_andnot(cpu, mask1, mask2)	\
> +	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask1, (void)mask2)
>   #else
>   /**
>    * cpumask_first - get the first cpu in a cpumask
> @@ -259,6 +268,7 @@ static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
>   }
>   
>   int __pure cpumask_next_and(int n, const struct cpumask *, const struct cpumask *);
> +int __pure cpumask_next_andnot(int n, const struct cpumask *, const struct cpumask *);
>   int __pure cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
>   unsigned int cpumask_local_spread(unsigned int i, int node);
>   int cpumask_any_and_distribute(const struct cpumask *src1p,
> @@ -324,6 +334,26 @@ extern int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool
>   	for ((cpu) = -1;						\
>   		(cpu) = cpumask_next_and((cpu), (mask1), (mask2)),	\
>   		(cpu) < nr_cpu_ids;)
> +
> +/**
> + * for_each_cpu_andnot - iterate over every cpu in one mask but not in another
> + * @cpu: the (optionally unsigned) integer iterator
> + * @mask1: the first cpumask pointer
> + * @mask2: the second cpumask pointer
> + *
> + * This saves a temporary CPU mask in many places.  It is equivalent to:
> + *	struct cpumask tmp;
> + *	cpumask_andnot(&tmp, &mask1, &mask2);
> + *	for_each_cpu(cpu, &tmp)
> + *		...
> + *
> + * After the loop, cpu is >= nr_cpu_ids.
> + */
> +#define for_each_cpu_andnot(cpu, mask1, mask2)				\
> +	for ((cpu) = -1;						\
> +		(cpu) = cpumask_next_andnot((cpu), (mask1), (mask2)),	\
> +		(cpu) < nr_cpu_ids;)
> +
>   #endif /* SMP */
>   
>   #define CPU_BITS_NONE						\
> diff --git a/include/linux/find.h b/include/linux/find.h
> index 424ef67d4a42..454cde69b30b 100644
> --- a/include/linux/find.h
> +++ b/include/linux/find.h
> @@ -10,7 +10,8 @@
>   
>   extern unsigned long _find_next_bit(const unsigned long *addr1,
>   		const unsigned long *addr2, unsigned long nbits,
> -		unsigned long start, unsigned long invert, unsigned long le);
> +		unsigned long start, unsigned long invert, unsigned long le,
> +		bool negate);
>   extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
>   extern unsigned long _find_first_and_bit(const unsigned long *addr1,
>   					 const unsigned long *addr2, unsigned long size);
> @@ -41,7 +42,7 @@ unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
>   		return val ? __ffs(val) : size;
>   	}
>   
> -	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
> +	return _find_next_bit(addr, NULL, size, offset, 0UL, 0, 0);
>   }
>   #endif
>   
> @@ -71,7 +72,38 @@ unsigned long find_next_and_bit(const unsigned long *addr1,
>   		return val ? __ffs(val) : size;
>   	}
>   
> -	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
> +	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0, 0);
> +}
> +#endif
> +
> +#ifndef find_next_andnot_bit
> +/**
> + * find_next_andnot_bit - find the next set bit in one memory region
> + *                        but not in the other
> + * @addr1: The first address to base the search on
> + * @addr2: The second address to base the search on
> + * @size: The bitmap size in bits
> + * @offset: The bitnumber to start searching at
> + *
> + * Returns the bit number for the next set bit
> + * If no bits are set, returns @size.
> + */
> +static inline
> +unsigned long find_next_andnot_bit(const unsigned long *addr1,
> +		const unsigned long *addr2, unsigned long size,
> +		unsigned long offset)
> +{
> +	if (small_const_nbits(size)) {
> +		unsigned long val;
> +
> +		if (unlikely(offset >= size))
> +			return size;
> +
> +		val = *addr1 & ~*addr2 & GENMASK(size - 1, offset);
> +		return val ? __ffs(val) : size;
> +	}
> +
> +	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0, 1);
>   }
>   #endif
>   
> @@ -99,7 +131,7 @@ unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
>   		return val == ~0UL ? size : ffz(val);
>   	}
>   
> -	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
> +	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0, 0);
>   }
>   #endif
>   
> @@ -247,7 +279,7 @@ unsigned long find_next_zero_bit_le(const void *addr, unsigned
>   		return val == ~0UL ? size : ffz(val);
>   	}
>   
> -	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
> +	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1, 0);
>   }
>   #endif
>   
> @@ -266,7 +298,7 @@ unsigned long find_next_bit_le(const void *addr, unsigned
>   		return val ? __ffs(val) : size;
>   	}
>   
> -	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
> +	return _find_next_bit(addr, NULL, size, offset, 0UL, 1, 0);
>   }
>   #endif
>   
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 4564faafd0e1..41bed4b883d3 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -245,5 +245,50 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
>   	return cpumask_of_node(cpu_to_node(cpu));
>   }
>   
> +#ifdef CONFIG_NUMA
> +extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
> +#else
> +static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
> +{
> +	return ERR_PTR(-ENOTSUPP);
> +}
> +#endif	/* CONFIG_NUMA */
> +
> +/**
> + * for_each_numa_hop_cpu - iterate over CPUs by increasing NUMA distance,
> + *                         starting from a given node.
> + * @cpu: the iteration variable.
> + * @node: the NUMA node to start the search from.
> + *
> + * Requires rcu_lock to be held.
> + * Careful: this is a double loop, 'break' won't work as expected.
> + *
> + *
> + * Implementation notes:
> + *
> + * Providing it is valid, the mask returned by
> + *  sched_numa_hop_mask(node, hops+1)
> + * is a superset of the one returned by
> + *   sched_numa_hop_mask(node, hops)
> + * which may not be that useful for drivers that try to spread things out and
> + * want to visit a CPU not more than once.
> + *
> + * To accomodate for that, we use for_each_cpu_andnot() to iterate over the cpus
> + * of sched_numa_hop_mask(node, hops+1) with the CPUs of
> + * sched_numa_hop_mask(node, hops) removed, IOW we only iterate over CPUs
> + * a given distance away (rather than *up to* a given distance).
> + *
> + * h=0 forces us to play silly games and pass cpu_none_mask to
> + * for_each_cpu_andnot(), which turns it into for_each_cpu().
> + */
> +#define for_each_numa_hop_cpu(cpu, node)				       \
> +	for (struct { const struct cpumask *mask; int hops; } __v__ =	       \
> +		     { sched_numa_hop_mask(node, 0), 0 };		       \
> +	     !IS_ERR_OR_NULL(__v__.mask);				       \
> +	     __v__.hops++, __v__.mask = sched_numa_hop_mask(node, __v__.hops)) \
> +		for_each_cpu_andnot(cpu, __v__.mask,			       \
> +				    __v__.hops ?			       \
> +				    sched_numa_hop_mask(node, __v__.hops - 1) :\
> +				    cpu_none_mask)
>   
>   #endif /* _LINUX_TOPOLOGY_H */
> diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
> index 976092b7bd45..9182101f2c4f 100644
> --- a/kernel/sched/Makefile
> +++ b/kernel/sched/Makefile
> @@ -29,6 +29,6 @@ endif
>   # build parallelizes well and finishes roughly at once:
>   #
>   obj-y += core.o
> -obj-y += fair.o
> +obj-y += fair.o yolo.o
>   obj-y += build_policy.o
>   obj-y += build_utility.o
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 8739c2a5a54e..f0236a0ae65c 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2067,6 +2067,34 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
>   	return found;
>   }
>   
> +/**
> + * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away.
> + * @node: The node to count hops from.
> + * @hops: Include CPUs up to that many hops away. 0 means local node.
> + *
> + * Requires rcu_lock to be held. Returned cpumask is only valid within that
> + * read-side section, copy it if required beyond that.
> + *
> + * Note that not all hops are equal in size; see sched_init_numa() for how
> + * distances and masks are handled.
> + *
> + * Also note that this is a reflection of sched_domains_numa_masks, which may change
> + * during the lifetime of the system (offline nodes are taken out of the masks).
> + */
> +const struct cpumask *sched_numa_hop_mask(int node, int hops)
> +{
> +	struct cpumask ***masks = rcu_dereference(sched_domains_numa_masks);
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
>   #endif /* CONFIG_NUMA */
>   
>   static int __sdt_alloc(const struct cpumask *cpu_map)
> diff --git a/lib/cpumask.c b/lib/cpumask.c
> index a971a82d2f43..8bcf7e919193 100644
> --- a/lib/cpumask.c
> +++ b/lib/cpumask.c
> @@ -42,6 +42,25 @@ int cpumask_next_and(int n, const struct cpumask *src1p,
>   }
>   EXPORT_SYMBOL(cpumask_next_and);
>   
> +/**
> + * cpumask_next_andnot - get the next cpu in *src1p & ~*src2p
> + * @n: the cpu prior to the place to search (ie. return will be > @n)
> + * @src1p: the first cpumask pointer
> + * @src2p: the second cpumask pointer
> + *
> + * Returns >= nr_cpu_ids if no further cpus set in both.
> + */
> +int cpumask_next_andnot(int n, const struct cpumask *src1p,
> +		     const struct cpumask *src2p)
> +{
> +	/* -1 is a legal arg here. */
> +	if (n != -1)
> +		cpumask_check(n);
> +	return find_next_andnot_bit(cpumask_bits(src1p), cpumask_bits(src2p),
> +		nr_cpumask_bits, n + 1);
> +}
> +EXPORT_SYMBOL(cpumask_next_andnot);
> +
>   /**
>    * cpumask_any_but - return a "random" in a cpumask, but not this one.
>    * @mask: the cpumask to search
> diff --git a/lib/find_bit.c b/lib/find_bit.c
> index 1b8e4b2a9cba..6e5f42c621a9 100644
> --- a/lib/find_bit.c
> +++ b/lib/find_bit.c
> @@ -21,17 +21,19 @@
>   
>   #if !defined(find_next_bit) || !defined(find_next_zero_bit) ||			\
>   	!defined(find_next_bit_le) || !defined(find_next_zero_bit_le) ||	\
> -	!defined(find_next_and_bit)
> +	!defined(find_next_and_bit) || !defined(find_next_andnot_bit)
>   /*
>    * This is a common helper function for find_next_bit, find_next_zero_bit, and
>    * find_next_and_bit. The differences are:
>    *  - The "invert" argument, which is XORed with each fetched word before
>    *    searching it for one bits.
> - *  - The optional "addr2", which is anded with "addr1" if present.
> + *  - The optional "addr2", negated if "negate" and ANDed with "addr1" if
> + *    present.
>    */
>   unsigned long _find_next_bit(const unsigned long *addr1,
>   		const unsigned long *addr2, unsigned long nbits,
> -		unsigned long start, unsigned long invert, unsigned long le)
> +		unsigned long start, unsigned long invert, unsigned long le,
> +		bool negate)
>   {
>   	unsigned long tmp, mask;
>   
> @@ -40,7 +42,9 @@ unsigned long _find_next_bit(const unsigned long *addr1,
>   
>   	tmp = addr1[start / BITS_PER_LONG];
>   	if (addr2)
> -		tmp &= addr2[start / BITS_PER_LONG];
> +		tmp &= negate ?
> +		       ~addr2[start / BITS_PER_LONG] :
> +			addr2[start / BITS_PER_LONG];
>   	tmp ^= invert;
>   
>   	/* Handle 1st word. */
> @@ -59,7 +63,9 @@ unsigned long _find_next_bit(const unsigned long *addr1,
>   
>   		tmp = addr1[start / BITS_PER_LONG];
>   		if (addr2)
> -			tmp &= addr2[start / BITS_PER_LONG];
> +			tmp &= negate ?
> +			       ~addr2[start / BITS_PER_LONG] :
> +				addr2[start / BITS_PER_LONG];
>   		tmp ^= invert;
>   	}
>   
> 

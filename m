Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C91C578B3F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbiGRTt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiGRTt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:49:27 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F70725DF;
        Mon, 18 Jul 2022 12:49:26 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id sz17so23234159ejc.9;
        Mon, 18 Jul 2022 12:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HYS8d97OSWqWFt6qraEk8QQYqaDKoCu9P8dNF7MQV/I=;
        b=RQqo5euyUNZsNSDq76e+Y6Cv3Yfw/KrbWFz3lAinvv27/90P/dhfgqzg2IbRDBN7O7
         +VQ2m7hOk4ZGFrXCnHACMXuauL3TuF2vpfwKjpFKWjwdnfn/309SqQdCy4yBZ0kwbe48
         ySQZzZVKf2rCRkw0109fbQrUt6mNVPt1Q694GFB6kgOTnazJYwfOj3zhUNXwVdXA9Y5R
         s0d9rxiiWM9UHF4OArALxG7Bh9/uCQwNTXJ8vzSL681fvxc69wvWDo3+Upp7GKe7ANXz
         pdTYA3bh6wgnCEFny2rthbqMJa3uJLnDwhUhifdCKoCbcaDCChcwEyd2KvDp9uUY/sBY
         s8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HYS8d97OSWqWFt6qraEk8QQYqaDKoCu9P8dNF7MQV/I=;
        b=Vs515rMqaa57tra7WEOTWyyqrQJgak0m1JEgqjlM9LB01IUAvE8fcg+YRdR1dYnDW9
         +SVUYQyqFPvDy4D36yfn+2GhgfdSgJmXB2oKK5rDorullaufZkqSm8fm4S/mJZ/nwyLr
         RPrdAUrDX4w/SIamQh1CjkuIMIUAbkMdFHg6aDsY3EVAizjgD/3V1w7wDNWaamBbXLBW
         O58+aq4sRgXU4tk+kKEEaTnjpunQZHQdO+hT4SkUs0+i5wY8Ljhph1+/ffErm5LedOMN
         orqR+LzZoOCaMFGVO+JPIQPv48NSDlTkFISN1t/Gq/a84lJTpPqJv9/O1prrIlhJTBYl
         iAFQ==
X-Gm-Message-State: AJIora94BylGHrsOl5OhfQgfWBHEunzWHgwyoWeHbTkvIOlNQom1YLSx
        MRvqloAeZehPBs4ffDpiaHs=
X-Google-Smtp-Source: AGRyM1teajZoX5+KI3lN1KKf4u/ANfoSP5l4g1qk1vVWzKjnntOq9y9g7rs0LxxBLBs9tyWYsF2JHw==
X-Received: by 2002:a17:907:a40f:b0:72b:64ee:5b2f with SMTP id sg15-20020a170907a40f00b0072b64ee5b2fmr28425844ejc.268.1658173764701;
        Mon, 18 Jul 2022 12:49:24 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090604c100b0072afb6d4d6fsm5952705eja.171.2022.07.18.12.49.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 12:49:24 -0700 (PDT)
Message-ID: <2fc99d26-f804-ad34-1fd7-90cfb123b426@gmail.com>
Date:   Mon, 18 Jul 2022 22:49:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next V2 2/2] net/mlx5e: Improve remote NUMA
 preferences used for the IRQ affinity hints
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Tariq Toukan <tariqt@nvidia.com>
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
References: <20220718124315.16648-1-tariqt@nvidia.com>
 <20220718124315.16648-3-tariqt@nvidia.com>
 <YtVlDiLTPxm312u+@worktop.programming.kicks-ass.net>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <YtVlDiLTPxm312u+@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2022 4:50 PM, Peter Zijlstra wrote:
> On Mon, Jul 18, 2022 at 03:43:15PM +0300, Tariq Toukan wrote:
> 
>> Reviewed-by: Gal Pressman <gal@nvidia.com>
>> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/eq.c | 62 +++++++++++++++++++-
>>   1 file changed, 59 insertions(+), 3 deletions(-)
>>
>> v2:
>> Separated the set_cpu operation into two functions, per Saeed's suggestion.
>> Added Saeed's Acked-by signature.
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
>> index 229728c80233..e72bdaaad84f 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
>> @@ -11,6 +11,9 @@
>>   #ifdef CONFIG_RFS_ACCEL
>>   #include <linux/cpu_rmap.h>
>>   #endif
>> +#ifdef CONFIG_NUMA
>> +#include <linux/sched/topology.h>
>> +#endif
>>   #include "mlx5_core.h"
>>   #include "lib/eq.h"
>>   #include "fpga/core.h"
>> @@ -806,13 +809,67 @@ static void comp_irqs_release(struct mlx5_core_dev *dev)
>>   	kfree(table->comp_irqs);
>>   }
>>   
>> +static void set_cpus_by_local_spread(struct mlx5_core_dev *dev, u16 *cpus,
>> +				     int ncomp_eqs)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ncomp_eqs; i++)
>> +		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
>> +}
>> +
>> +static bool set_cpus_by_numa_distance(struct mlx5_core_dev *dev, u16 *cpus,
>> +				      int ncomp_eqs)
>> +{
>> +#ifdef CONFIG_NUMA
>> +	cpumask_var_t cpumask;
>> +	int first;
>> +	int i;
>> +
>> +	if (!zalloc_cpumask_var(&cpumask, GFP_KERNEL)) {
>> +		mlx5_core_err(dev, "zalloc_cpumask_var failed\n");
>> +		return false;
>> +	}
>> +	cpumask_copy(cpumask, cpu_online_mask);
>> +
>> +	first = cpumask_local_spread(0, dev->priv.numa_node);
> 
> Arguably you want something like:
> 
> 	first = cpumask_any(cpumask_of_node(dev->priv.numa_node));

Any doesn't sound like what I'm looking for, I'm looking for first.
I do care about the order within the node, so it's more like 
cpumask_first(cpumask_of_node(dev->priv.numa_node));

Do you think this has any advantage over cpumask_local_spread, if used 
only during the setup phase of the driver?

> 
>> +
>> +	for (i = 0; i < ncomp_eqs; i++) {
>> +		int cpu;
>> +
>> +		cpu = sched_numa_find_closest(cpumask, first);
>> +		if (cpu >= nr_cpu_ids) {
>> +			mlx5_core_err(dev, "sched_numa_find_closest failed, cpu(%d) >= nr_cpu_ids(%d)\n",
>> +				      cpu, nr_cpu_ids);
>> +
>> +			free_cpumask_var(cpumask);
>> +			return false;
> 
> So this will fail when ncomp_eqs > cpumask_weight(online_cpus); is that
> desired?
> 

Yes. ncomp_eqs does not exceed the num of online cores.


>> +		}
>> +		cpus[i] = cpu;
>> +		cpumask_clear_cpu(cpu, cpumask);
> 
> Since there is no concurrency on this cpumask, you don't need atomic
> ops:
> 
> 		__cpumask_clear_cpu(..);
> 

Right. I'll fix.

>> +	}
>> +
>> +	free_cpumask_var(cpumask);
>> +	return true;
>> +#else
>> +	return false;
>> +#endif
>> +}
>> +
>> +static void mlx5_set_eqs_cpus(struct mlx5_core_dev *dev, u16 *cpus, int ncomp_eqs)
>> +{
>> +	bool success = set_cpus_by_numa_distance(dev, cpus, ncomp_eqs);
>> +
>> +	if (!success)
>> +		set_cpus_by_local_spread(dev, cpus, ncomp_eqs);
>> +}
>> +
>>   static int comp_irqs_request(struct mlx5_core_dev *dev)
>>   {
>>   	struct mlx5_eq_table *table = dev->priv.eq_table;
>>   	int ncomp_eqs = table->num_comp_eqs;
>>   	u16 *cpus;
>>   	int ret;
>> -	int i;
>>   
>>   	ncomp_eqs = table->num_comp_eqs;
>>   	table->comp_irqs = kcalloc(ncomp_eqs, sizeof(*table->comp_irqs), GFP_KERNEL);
>> @@ -830,8 +887,7 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
>>   		ret = -ENOMEM;
>>   		goto free_irqs;
>>   	}
>> -	for (i = 0; i < ncomp_eqs; i++)
>> -		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
>> +	mlx5_set_eqs_cpus(dev, cpus, ncomp_eqs);
> 
> So you change this for mlx5, what about the other users of
> cpumask_local_spread() ?

I took a look at the different netdev users.
While some users have similar use case to ours (affinity hints), many 
others use cpumask_local_spread in other flows (XPS setting, ring 
allocations, etc..).

Moving them to use the newly exposed API needs some deeper dive into 
their code, especially due to the possible undesired side-effects.

I prefer not to include these changes in my series for now, but probably 
contribute it in a followup work.

Regards,
Tariq

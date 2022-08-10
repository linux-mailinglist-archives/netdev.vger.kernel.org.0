Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6C558EC89
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiHJM63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiHJM6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:58:07 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBF160521;
        Wed, 10 Aug 2022 05:57:58 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q30so17621966wra.11;
        Wed, 10 Aug 2022 05:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=kFP7JSHQfbm4e+MXf5fq9By6mFcnxetTQd1OhAdVGRs=;
        b=I6v4DJvT+qkHSGKc1lDx8enEj3psLXQaHLZ7aytBp+2OAB//NS3KUAjWagckiAhg3a
         ooIGjb8/22hbmb3ccUG4CLmYQNGBm+hcOqCn42SiYyW4bnFUp7petJZZ4QFWNDLVKLwV
         8Nfj7uLrn8yB9Lar/PR4/rr1eHpAsbKIY55O0dqBAymNqNakaXLebLUTLm4wSpAOzdrk
         yb3wvJK5EDAnhYd+VN1JWLwYrpIZLbwydKulihZ5WAALYIZ6z2/f0OzGde9n+lA8jDp3
         JrI3PWZ4GYYXthG4ESUr6YNvdolLWqcrU9vsYHubpWDSGiYC3+KhTx9tLWHysdT2DQ7v
         Rj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=kFP7JSHQfbm4e+MXf5fq9By6mFcnxetTQd1OhAdVGRs=;
        b=XzQk2MGp+AglTsj0PUMslFN2IGZApDaUhnoUu8Dj0j6iTdMXC1sB36sbJEvvlOkOV8
         dHImcXOazIcIjQxQw86SWowcz34KOO4kVnVXiRxycscx5HCXastyOZ8A1Zgtdo82gFj/
         2lxdGXwP0W1XF+xwVI1KSK26LC90Q8UIrxXG0EAieJKHWXKCiSPutk4oww1C0CHOYmCb
         6X47Jy4utVWYToEQ13yJf1sUHBNzCmfWskgS0eQ2dTOcePlp+eOTV0x9FDpeua/Ue005
         XfxQZx81nvCWEOqxzPusFceRoGCqAxNxLsVOKUaqGKlicT2ZSFWp01lytsuzj5eQZt1V
         g2wQ==
X-Gm-Message-State: ACgBeo1/EY4K9WIr/WUrTMpw1MXw5XLi8aw6edrVKc8aMxy4G2AwHc3S
        P8kzx969R/YKovxfLPd0N9g=
X-Google-Smtp-Source: AA6agR7AwaTPsF5uR4hWwfite11HOGBAukKSYVvKkqSD/I6DXNcNUUEF0OOgwKOt4We/TGYb3t9Bbg==
X-Received: by 2002:adf:d4c2:0:b0:21e:ddf3:8b14 with SMTP id w2-20020adfd4c2000000b0021eddf38b14mr17729524wrk.355.1660136277113;
        Wed, 10 Aug 2022 05:57:57 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c3b1500b003a317ee3036sm2542345wms.2.2022.08.10.05.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 05:57:56 -0700 (PDT)
Message-ID: <03aaf512-3ac5-fdfe-da2d-3fecd24591e2@gmail.com>
Date:   Wed, 10 Aug 2022 15:57:54 +0300
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
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <db20e6fe-4368-15ec-65c5-ead28fc7981b@gmail.com>
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



On 8/10/2022 3:42 PM, Tariq Toukan wrote:
> 
> 
> On 8/10/2022 1:51 PM, Valentin Schneider wrote:
>> Tariq has pointed out that drivers allocating IRQ vectors would benefit
>> from having smarter NUMA-awareness - cpumask_local_spread() only knows
>> about the local node and everything outside is in the same bucket.
>>
>> sched_domains_numa_masks is pretty much what we want to hand out (a 
>> cpumask
>> of CPUs reachable within a given distance budget), introduce
>> sched_numa_hop_mask() to export those cpumasks. Add in an iteration 
>> helper
>> to iterate over CPUs at an incremental distance from a given node.
>>
>> Link: http://lore.kernel.org/r/20220728191203.4055-1-tariqt@nvidia.com
>> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
>> ---
>>   include/linux/topology.h | 12 ++++++++++++
>>   kernel/sched/topology.c  | 28 ++++++++++++++++++++++++++++
>>   2 files changed, 40 insertions(+)
>>
>> diff --git a/include/linux/topology.h b/include/linux/topology.h
>> index 4564faafd0e1..d66e3cf40823 100644
>> --- a/include/linux/topology.h
>> +++ b/include/linux/topology.h
>> @@ -245,5 +245,17 @@ static inline const struct cpumask 
>> *cpu_cpu_mask(int cpu)
>>       return cpumask_of_node(cpu_to_node(cpu));
>>   }
>> +#ifdef CONFIG_NUMA
>> +extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
>> +#else
>> +static inline const struct cpumask *sched_numa_hop_mask(int node, int 
>> hops)
>> +{
>> +    return -ENOTSUPP;
> 
> missing ERR_PTR()
> 
>> +}
>> +#endif    /* CONFIG_NUMA */
>> +
>> +#define for_each_numa_hop_mask(node, hops, mask)            \
>> +    for (mask = sched_numa_hop_mask(node, hops); 
>> !IS_ERR_OR_NULL(mask); \
>> +         mask = sched_numa_hop_mask(node, ++hops))
>>   #endif /* _LINUX_TOPOLOGY_H */
>> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
>> index 8739c2a5a54e..f0236a0ae65c 100644
>> --- a/kernel/sched/topology.c
>> +++ b/kernel/sched/topology.c
>> @@ -2067,6 +2067,34 @@ int sched_numa_find_closest(const struct 
>> cpumask *cpus, int cpu)
>>       return found;
>>   }
>> +/**
>> + * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops 
>> away.
>> + * @node: The node to count hops from.
>> + * @hops: Include CPUs up to that many hops away. 0 means local node.

AFAIU, here you work with a specific level/num of hops, description is 
not accurate.


>> + *
>> + * Requires rcu_lock to be held. Returned cpumask is only valid 
>> within that
>> + * read-side section, copy it if required beyond that.
>> + *
>> + * Note that not all hops are equal in size; see sched_init_numa() 
>> for how
>> + * distances and masks are handled.
>> + *
>> + * Also note that this is a reflection of sched_domains_numa_masks, 
>> which may change
>> + * during the lifetime of the system (offline nodes are taken out of 
>> the masks).
>> + */
>> +const struct cpumask *sched_numa_hop_mask(int node, int hops)
>> +{
>> +    struct cpumask ***masks = rcu_dereference(sched_domains_numa_masks);
>> +
>> +    if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
>> +        return ERR_PTR(-EINVAL);
>> +
>> +    if (!masks)
>> +        return NULL;
>> +
>> +    return masks[hops][node];
>> +}
>> +EXPORT_SYMBOL_GPL(sched_numa_hop_mask);
>> +
>>   #endif /* CONFIG_NUMA */
>>   static int __sdt_alloc(const struct cpumask *cpu_map)

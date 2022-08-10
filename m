Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F20358EC34
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiHJMmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHJMmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:42:47 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FB675FD5;
        Wed, 10 Aug 2022 05:42:46 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j7so17646728wrh.3;
        Wed, 10 Aug 2022 05:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=DUrhPqHeoVNO899nTZKgNQgtiwDSI706ohCzG3KW7J4=;
        b=WcGD1ArzO/1Mu8mRXXtb7iLruifPyA2zuNn4sSc4YipG1vcXuX84r68dX+p3YQB5UM
         Jm3fUrPFY3lrQtBtABdY0If1ZVj+4D0zqh4hrxEhftcqLDCr99Scjk8TsVSjtyXoIdyn
         lNnJSfF508yGSQ33wlS1cRTDjtzDCWQptKE0+Uu26a6YP9U/GUenIWW5rlhgs8nzSu6x
         TgoPgl6B+67NTeHALJwoSZEkHzIdt5cuhxUWfKPwDaAQoATIvF2y0FSr6voi7tv6GO7v
         5kW7rdYrDUKb6Sv4uhmXKbYBh3lcsBzBQ5iq4pV580poX9SDzd7KOWTqxti+5MQnc/a2
         to8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=DUrhPqHeoVNO899nTZKgNQgtiwDSI706ohCzG3KW7J4=;
        b=k2gCUsmWx7gbyxvo2otYWZHMzUF5EbUvUxv3uEfs5msaosUeTFbNTKmkFpm+pKWk1x
         B2hvMhs9e2UrVoE5WWQwMvbFooKiY/GCUXZekO4xTKOW98jKFU1N5OgAANIcEVjU29G7
         yarhApnQUiij+ZDVFiQf+j5izdO2s4BKLUr4K3XWCp96KUGn4ikF6XP+BFETMcJKrD25
         nDvVGI2SfvFEGY8cyLav2HIt+7IuDFjd1bgFALu+1M3U1ZTR3R0tHD7vuH/hdyeaqFUE
         yxIPuInunTACXyTiomh2DLcQlsp0UAFh/Mu4xY+LQ9ooG+T/dcQxQcbtr+U71Rkb2Wor
         pnpA==
X-Gm-Message-State: ACgBeo2xoYolRkAOg8c1jXcQJszbw5HjnvaS+Wf9zvlDqFIFQQZGxD8Z
        6RDBuLm7fvowRxrLc7FTx+A=
X-Google-Smtp-Source: AA6agR5/sXHQ9somcqgQY/iBMbsMybLfGD6aTOS9DvG0KEX0mubvMDopVJXy1zBIiJZgS0mD5yVmpg==
X-Received: by 2002:a05:6000:1051:b0:221:6d46:4f0f with SMTP id c17-20020a056000105100b002216d464f0fmr14642822wrx.163.1660135364637;
        Wed, 10 Aug 2022 05:42:44 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id a18-20020a05600c069200b003a32490c95dsm2177927wmn.35.2022.08.10.05.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 05:42:44 -0700 (PDT)
Message-ID: <db20e6fe-4368-15ec-65c5-ead28fc7981b@gmail.com>
Date:   Wed, 10 Aug 2022 15:42:41 +0300
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
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220810105119.2684079-1-vschneid@redhat.com>
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



On 8/10/2022 1:51 PM, Valentin Schneider wrote:
> Tariq has pointed out that drivers allocating IRQ vectors would benefit
> from having smarter NUMA-awareness - cpumask_local_spread() only knows
> about the local node and everything outside is in the same bucket.
> 
> sched_domains_numa_masks is pretty much what we want to hand out (a cpumask
> of CPUs reachable within a given distance budget), introduce
> sched_numa_hop_mask() to export those cpumasks. Add in an iteration helper
> to iterate over CPUs at an incremental distance from a given node.
> 
> Link: http://lore.kernel.org/r/20220728191203.4055-1-tariqt@nvidia.com
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>   include/linux/topology.h | 12 ++++++++++++
>   kernel/sched/topology.c  | 28 ++++++++++++++++++++++++++++
>   2 files changed, 40 insertions(+)
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 4564faafd0e1..d66e3cf40823 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -245,5 +245,17 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
>   	return cpumask_of_node(cpu_to_node(cpu));
>   }
>   
> +#ifdef CONFIG_NUMA
> +extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
> +#else
> +static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
> +{
> +	return -ENOTSUPP;

missing ERR_PTR()

> +}
> +#endif	/* CONFIG_NUMA */
> +
> +#define for_each_numa_hop_mask(node, hops, mask)			\
> +	for (mask = sched_numa_hop_mask(node, hops); !IS_ERR_OR_NULL(mask); \
> +	     mask = sched_numa_hop_mask(node, ++hops))
>   
>   #endif /* _LINUX_TOPOLOGY_H */
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

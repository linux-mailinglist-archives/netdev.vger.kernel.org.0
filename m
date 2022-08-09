Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3245758D74B
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 12:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242229AbiHIKSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 06:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242221AbiHIKSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 06:18:38 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92DB220EB;
        Tue,  9 Aug 2022 03:18:37 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j7so13810916wrh.3;
        Tue, 09 Aug 2022 03:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=dc5u1NxKa9etfng0qiWTVwtMMVoMS+BgmiyLem1i3ds=;
        b=Zbq7BT4lqJXWkxNd/a4eYq5Ki9iM2vn1Evkr5+e5JFw7E9JvwwT+W28SiVvC2Yy2OC
         XrtEmO3ZDGLHWKuri2zX4fXDSxu2/OSXwQCtc69mgyZ/maK2vyfQPoNrfhpHqgBZ5n3n
         szDIuWXorp469KFbhWD/zVkCMQU+uLxqX/xzZaXun4Eh/w7fQFkW376sRWGHZjwj+3oM
         EKVHCTLIRXkkF6onD+GJIsayGVQoNVOLt+JsORgiVUwA+RNeWVpscMXorGYCvbFg2XFD
         YXK0XW/9HKDDYNsFtAS2z69PqJAedVIy5xsSJeObwE8uZrNPy2eK6iKIbqF6T35nuMoE
         Lo9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=dc5u1NxKa9etfng0qiWTVwtMMVoMS+BgmiyLem1i3ds=;
        b=qvOX4p8dVkFz0nyPEQHZDYn2Pki7l0m7Vrfa1iN3+ZZMlpXoqvKGwaAwhKKKaEGwb7
         JX7RA/n30fnhFbP3bwGmJ3ENP98YGJyZUn81DZnw8VdScQWW7m6w4VmRo86rqgbqfUiM
         7futQi5ye9ZQ4GwGT9l0RTXqhRCzsSiZywAo6VNdiGfvoeGdDdBMXBHfFjMTd6H+8s0V
         a1uhGaCAk55Bd3YIvkoExP8+N5bdD7pTnIalyIVbPWdOMhXPX/EPXJTx/a0ws88dxY+t
         js7KMtqhLCwIJhqyE8g62EBzaXLNrwpQ+muMOvsJN5e/H+1K/QpNoxg7pPZ3ceLI6T73
         uJTw==
X-Gm-Message-State: ACgBeo33C8U6gHyoZ3Sdo29Lu5l9DZKifi4iMs9sNc/fPqm95wdjRn02
        2GRNAhWNgVFfluTiLSLlkvA=
X-Google-Smtp-Source: AA6agR6txDR4hjuJtisamDURgy7Bs3qs9YqbYNtOdd+qN6YGUsWNH8B62fav8J0zzJJTFubDzW46EQ==
X-Received: by 2002:a5d:56cf:0:b0:21e:ce64:afe7 with SMTP id m15-20020a5d56cf000000b0021ece64afe7mr13580138wrw.281.1660040316191;
        Tue, 09 Aug 2022 03:18:36 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id e12-20020adfa44c000000b0021e5cc26dd0sm13129209wra.62.2022.08.09.03.18.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 03:18:35 -0700 (PDT)
Message-ID: <12fd25f9-96fb-d0e0-14ec-3f08c01a5a4b@gmail.com>
Date:   Tue, 9 Aug 2022 13:18:33 +0300
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
 <df8b684d-ede6-7412-423d-51d57365e065@gmail.com>
 <xhsmh35e5d9b4.mognet@vschneid.remote.csb>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <xhsmh35e5d9b4.mognet@vschneid.remote.csb>
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



On 8/9/2022 1:02 PM, Valentin Schneider wrote:
> On 08/08/22 17:39, Tariq Toukan wrote:
>> On 8/4/2022 8:28 PM, Valentin Schneider wrote:
>>> On 28/07/22 22:12, Tariq Toukan wrote:
>>>> +static bool sched_cpus_spread_by_distance(int node, u16 *cpus, int ncpus)
>>>                                                          ^^^^^^^^^
>>> That should be a struct *cpumask.
>>
>> With cpumask, we'll lose the order.
>>
> 
> Right, I didn't get that from the changelog.

I'll make it clear when re-spinned.

> 
>>>
>>>> +{
>>>> +	cpumask_var_t cpumask;
>>>> +	int first, i;
>>>> +
>>>> +	if (!zalloc_cpumask_var(&cpumask, GFP_KERNEL))
>>>> +		return false;
>>>> +
>>>> +	cpumask_copy(cpumask, cpu_online_mask);
>>>> +
>>>> +	first = cpumask_first(cpumask_of_node(node));
>>>> +
>>>> +	for (i = 0; i < ncpus; i++) {
>>>> +		int cpu;
>>>> +
>>>> +		cpu = sched_numa_find_closest(cpumask, first);
>>>> +		if (cpu >= nr_cpu_ids) {
>>>> +			free_cpumask_var(cpumask);
>>>> +			return false;
>>>> +		}
>>>> +		cpus[i] = cpu;
>>>> +		__cpumask_clear_cpu(cpu, cpumask);
>>>> +	}
>>>> +
>>>> +	free_cpumask_var(cpumask);
>>>> +	return true;
>>>> +}
>>>
>>> This will fail if ncpus > nr_cpu_ids, which shouldn't be a problem. It
>>> would make more sense to set *up to* ncpus, the calling code can then
>>> decide if getting fewer than requested is OK or not.
>>>
>>> I also don't get the fallback to cpumask_local_spread(), is that if the
>>> NUMA topology hasn't been initialized yet? It feels like most users of this
>>> would invoke it late enough (i.e. anything after early initcalls) to have
>>> the backing data available.
>>
>> I don't expect this to fail, as we invoke it late enough. Fallback is
>> there just in case, to preserve the old behavior instead of getting
>> totally broken.
>>
> 
> Then there shouldn't be a fallback method - the main method is expected to
> work.
> 

I'll drop the fallback then.

>>>
>>> Finally, I think iterating only once per NUMA level would make more sense.
>>
>> Agree, although it's just a setup stage.
>> I'll check if it can work for me, based on the reference code below.
>>
>>>
>>> I've scribbled something together from those thoughts, see below. This has
>>> just the mlx5 bits touched to show what I mean, but that's just compile
>>> tested.
>>
>> My function returns a *sorted* list of the N closest cpus.
>> That is important. In many cases, drivers do not need all N irqs, but
>> only a portion of it, so it wants to use the closest subset of cpus.
>>
> 
> Are there cases where we can't figure this out in advance? From what I grok
> out of the two callsites you patched, all vectors will be used unless some
> error happens, so compressing the CPUs in a single cpumask seemed
> sufficient.
> 

All vectors will be initialized to support the maximum number of traffic 
rings. However, the actual number of traffic rings can be controlled and 
set to a lower number N_actual < N. In this case, we'll be using only 
N_actual instances and we want them to be the first/closest.

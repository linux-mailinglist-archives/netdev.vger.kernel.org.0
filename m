Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD1857811F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiGRLnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbiGRLnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:43:00 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42956B86A;
        Mon, 18 Jul 2022 04:42:59 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id mf4so20700469ejc.3;
        Mon, 18 Jul 2022 04:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=16jnFsvBrAgbEt4xpQGg6hQiZZIMKLW+cCiQ1OqTMC8=;
        b=LLTUoRzUUFKiAu3tR2Vs0NiaFln/YwydRZaSlRdCAhAUv0G1ngreNmz0brJaLV7CzY
         TQU0okdCRNjR9mdfxVKsCu9B/UTsYMkaDQbB9q1Fo0Fy4Kg3/Z82ZQr5Aubb053fhWyd
         iG+0Zw2jqWk8fd5R3JToFHhg1MLmAViu4cbwHNn4gpeljl2VBa6nGpQ0ygjOuPZ5FRav
         X9rSQ++PaIIAP1p4GrNUyhA0I9KKnh1fH7fZRG5nzHpp9Xl0mz0zVXS/tACg4rGK2czG
         eqjUMURqZbYEG3oJCT0/RzNEXd5srhddhELFEmJHJ6rRIE4NMf+s65zrnHi2TH2xCkG4
         rAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=16jnFsvBrAgbEt4xpQGg6hQiZZIMKLW+cCiQ1OqTMC8=;
        b=gZsa7y/qV4wbasF3xnENUL/ETVkx9kjeLMupZ3ERRIXQ3MnaBcDYdk/8K8yj92RLjF
         9LVr6Y7xR0zP5WN/RQga5CewlkHygLk91Db3kSJa9Xdyef3jsPKL0jWt9BkuaDiohZLm
         f8ULFI7+nVNvATrGo0xU6dE+2WJ5Kib6ztuz/FjpMbx8X2SNciH4VrDLlv67GKzbnBtA
         9xXs/N5FZzL2gE0Ie6IIRrVfOFCg39jVUg2FcGzkw/KsAKQcRkML3/veEz7meNJgoqoo
         ZEGUomrWaKo83/2OC7W0q/defX0FF6BF09kzZbgWMSmUa1G8J6quNgAGNw7O8wZqmERN
         iH/Q==
X-Gm-Message-State: AJIora/155z+vXMoXL6/CuknV9vRPGaR/WDrLlSjViU2Iu9QrNl0o+7q
        TOXF98JFTmDTS8Nk9r5gMQ4=
X-Google-Smtp-Source: AGRyM1sEW677SbP17IE3+fkQqGLUtcTguoPwApk3lL8xM5+6N/Zvm4MaZA+Ag8xYApRYkyVNbDh2qQ==
X-Received: by 2002:a17:906:5305:b0:712:388c:2bf5 with SMTP id h5-20020a170906530500b00712388c2bf5mr24946074ejo.559.1658144577795;
        Mon, 18 Jul 2022 04:42:57 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id ek9-20020a056402370900b0042de3d661d2sm8361944edb.1.2022.07.18.04.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 04:42:55 -0700 (PDT)
Message-ID: <72170546-fad0-0b96-e075-b755c3a48bec@gmail.com>
Date:   Mon, 18 Jul 2022 14:42:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 1/2] sched/topology: Expose
 sched_numa_find_closest
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
References: <20220717052301.19067-1-tariqt@nvidia.com>
 <20220717052301.19067-2-tariqt@nvidia.com>
 <YtUzu4d9F+V621tw@worktop.programming.kicks-ass.net>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <YtUzu4d9F+V621tw@worktop.programming.kicks-ass.net>
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



On 7/18/2022 1:19 PM, Peter Zijlstra wrote:
> On Sun, Jul 17, 2022 at 08:23:00AM +0300, Tariq Toukan wrote:
>> This logic can help device drivers prefer some remote cpus
>> over others, according to the NUMA distance metrics.
>>
>> Reviewed-by: Gal Pressman <gal@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   include/linux/sched/topology.h | 2 ++
>>   kernel/sched/topology.c        | 1 +
>>   2 files changed, 3 insertions(+)
>>
>> diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
>> index 56cffe42abbc..d467c30bdbb9 100644
>> --- a/include/linux/sched/topology.h
>> +++ b/include/linux/sched/topology.h
>> @@ -61,6 +61,8 @@ static inline int cpu_numa_flags(void)
>>   {
>>   	return SD_NUMA;
>>   }
>> +
>> +int sched_numa_find_closest(const struct cpumask *cpus, int cpu);
>>   #endif
>>   
>>   extern int arch_asym_cpu_priority(int cpu);
>> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
>> index 05b6c2ad90b9..688334ac4980 100644
>> --- a/kernel/sched/topology.c
>> +++ b/kernel/sched/topology.c
>> @@ -2066,6 +2066,7 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
>>   
>>   	return found;
>>   }
>> +EXPORT_SYMBOL(sched_numa_find_closest);
> 
> EXPORT_SYMBOL_GPL() if anything.

I'll fix.

> 
> Also, this thing will be subject to sched_domains, that means that if
> someone uses cpusets or other means to partition the machine, that
> effects the result.
> 
> Is that what you want?

Yes, it's good enough, at least as a first phase and basic functionality.
Later we might introduce whatever enhancements we find necessary.


Thanks,
Tariq

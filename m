Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A21158DA09
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 16:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbiHIOEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 10:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiHIOEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 10:04:12 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3074BC37;
        Tue,  9 Aug 2022 07:04:11 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id z16so14380780wrh.12;
        Tue, 09 Aug 2022 07:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=DDKIcyj9Z0sGFhBonIYv1vMbP6zsZA0f1KiomNe+d78=;
        b=CJhsWA91H6jWASh85FxrEygMLwuz8qmN2L1vaWzcLg93UW1J5b3gSXC2E0ceH+zCuy
         BQ6W1OM0Q4vVt5DWLJWl5PutysBGcO1HYqclY+LZH9TeeADU9NhehEx/KCkbm+1+AAKJ
         3iRxI6p5eroVoxMzjqF8xhHvTY7xSYBZ3P6gnXVhTXqGZ5EMAbw0GSQqxEbVP3vSpAVc
         PmRA6dAX2zfVSRl5pzO5XOLet/K4wl7l8KX+OjuoYcHqMCZCjsx3hLa3a8b2bEAKP+KJ
         upC3S34qpg/b3/3H2h7RrAVHxJ7vwotTA1PWgZq5IQGSKYH1FugVJJKYtdZCc1FHEWlB
         8MXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=DDKIcyj9Z0sGFhBonIYv1vMbP6zsZA0f1KiomNe+d78=;
        b=vvrz+WvDSXT0i8H8eGvR+9ehH39Jxa+BJmmgsIP6s9gTyXEJMJw/KDjxAFdUjOqntV
         vrm36nCYPOxK33vZyjWZmK/P0jbYGbXB4Ry6Rto8eTShu28vr2jRUQcVfjJeY6HPetJp
         nuWBhfgGHrfGlgcY8jUje/EF3eqiW5wGAKaoN2rr+GJcd94iVYtkVaiF5n4CDiCdoA4s
         sfdfTQbPRWXZyw8FbxnYstbjZ5EskqzWPRFBXYNw2DLkKgDGPOzPp7x5Q5lqpbvgN7Pf
         x2wysXAkcIfBsyLGBV+pNjMzQGu+CxMdySx2Q1+yMdaWs/YWOlUE6X28QWU+vwIhv0ss
         CCTQ==
X-Gm-Message-State: ACgBeo2q+FDvz+uF6eU9i0U8mjKG0asRzSB8dZjw9f6Nb57QCmeUISnT
        zK87Tf+jM+H3IE+NSjsiwWM=
X-Google-Smtp-Source: AA6agR58ORGm0OUkPlmNNA2FCN5hW5yDkabypPTKe4GvE5qlmbvzfHxtYgsz/SjlJ7S3yOpSpdejGw==
X-Received: by 2002:a5d:5903:0:b0:221:9d43:961 with SMTP id v3-20020a5d5903000000b002219d430961mr9892794wrd.385.1660053850399;
        Tue, 09 Aug 2022 07:04:10 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id c5-20020a5d4f05000000b002205a5de337sm13823218wru.102.2022.08.09.07.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 07:04:09 -0700 (PDT)
Message-ID: <69829c71-d51c-b25f-2d74-5fdd231ed9e4@gmail.com>
Date:   Tue, 9 Aug 2022 17:04:07 +0300
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
 <12fd25f9-96fb-d0e0-14ec-3f08c01a5a4b@gmail.com>
 <xhsmhzggdbmv6.mognet@vschneid.remote.csb>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <xhsmhzggdbmv6.mognet@vschneid.remote.csb>
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



On 8/9/2022 3:52 PM, Valentin Schneider wrote:
> On 09/08/22 13:18, Tariq Toukan wrote:
>> On 8/9/2022 1:02 PM, Valentin Schneider wrote:
>>>
>>> Are there cases where we can't figure this out in advance? From what I grok
>>> out of the two callsites you patched, all vectors will be used unless some
>>> error happens, so compressing the CPUs in a single cpumask seemed
>>> sufficient.
>>>
>>
>> All vectors will be initialized to support the maximum number of traffic
>> rings. However, the actual number of traffic rings can be controlled and
>> set to a lower number N_actual < N. In this case, we'll be using only
>> N_actual instances and we want them to be the first/closest.
> 
> Ok, that makes sense, thank you.
> 
> In that case I wonder if we'd want a public-facing iterator for
> sched_domains_numa_masks[%i][node], rather than copy a portion of
> it. Something like the below (naming and implementation haven't been
> thought about too much).
> 
>    const struct cpumask *sched_numa_level_mask(int node, int level)
>    {
>            struct cpumask ***masks = rcu_dereference(sched_domains_numa_masks);
> 
>            if (node >= nr_node_ids || level >= sched_domains_numa_levels)
>                    return NULL;
> 
>            if (!masks)
>                    return NULL;
> 
>            return masks[level][node];
>    }
>    EXPORT_SYMBOL_GPL(sched_numa_level_mask);
> 

The above can be kept static, and expose only the foo() function below, 
similar to my sched_cpus_set_spread().

LGTM.
How do you suggest to proceed?
You want to formalize it? Or should I take it from here?


>    #define for_each_numa_level_mask(node, lvl, mask)	    \
>            for (mask = sched_numa_level_mask(node, lvl); mask;	\
>                 mask = sched_numa_level_mask(node, ++lvl))
> 
>    void foo(int node, int cpus[], int ncpus)
>    {
>            const struct cpumask *mask;
>            int lvl = 0;
>            int i = 0;
>            int cpu;
> 
>            rcu_read_lock();
>            for_each_numa_level_mask(node, lvl, mask) {
>                    for_each_cpu(cpu, mask) {
>                            cpus[i] = cpu;
>                            if (++i == ncpus)
>                                    goto done;
>                    }
>            }
>    done:
>            rcu_read_unlock();
>    }
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABA15ACF26
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 11:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbiIEJqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 05:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbiIEJqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 05:46:39 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6712051410;
        Mon,  5 Sep 2022 02:46:37 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id az27so10572830wrb.6;
        Mon, 05 Sep 2022 02:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=9eP10jBttfX7JFaGq3cafWCXOAtwK03QR6MASyS0HOM=;
        b=nYhXuSM7xuJMcmMto19qavPBc8Df1xvm67JFmo5Yv8Bc+eD9+rLeLU8s5tGUqLhyb2
         K840RtPbhlY9D9tT2MaywRZahsGA33CfLs0lUrRu4msixNtRHsiGaK0sEkCMbvVbA+Xe
         /I7EBmEBgRZfYpWKe+Fk9DeOUFskXKa4GJ6R9ZgSFG25m5pOZbip3Qby8GxCLeVlM2+5
         Q2S432QXNcv1In+N30oLGMlrm41IrIwLfXpoRi6+qik5gdAdVBFR4CKWXg8w3jNOEANy
         tLTffDP4TKNpULyKIHjqtR1SGFpP3bGH6nubKgiQStp6N8bJIGViIKWH55KBVQd/weC3
         5nHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9eP10jBttfX7JFaGq3cafWCXOAtwK03QR6MASyS0HOM=;
        b=VHwOkgS5HcwLunhf7X3Xw9g1EWIea774IopHnEUupjL+LqDuaU0XDTlI7LGn6PY6lt
         KP0TM5gGgFEnIapH3BtyBKsYkAT7+UIUyTBdzzo28nn8j5KSOQpwO7FGGQsLj8Pfl9fI
         yVnlCBN3f9X7wglgNcI7xWl5cRb2AC6FHugCXHuLzjwi0Ph7wlwrbaWSkTIahhbM7RGU
         7p7cTwCwE1bysJBgRmRSzIggcwyDxRPe1yB2JBSwhKSddYpx34XVvuDvHfTe1MnufwWJ
         wiWZm0OzpEaW9xm6RVyo+E94pg/FhA4LTXIB9O1V5aVv4BbJH9Fo0H6amUHQ6JPZYex9
         xbZA==
X-Gm-Message-State: ACgBeo2UQTydzKErryskjjly8fCvpmBki1o/B7w6/knrLVzjVoJSIk7H
        QR3RNVDGKIGgbIhJ2BolDu0=
X-Google-Smtp-Source: AA6agR7GujTzGQOYadqeZp0fdwlqL4KI2sWdgFDF9ahNeO0Ar5cAr2lTXVDaK5Eik232Wz1WP7dFEQ==
X-Received: by 2002:a05:6000:1888:b0:222:ca41:dc26 with SMTP id a8-20020a056000188800b00222ca41dc26mr22626610wri.442.1662371195803;
        Mon, 05 Sep 2022 02:46:35 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id i18-20020a5d5592000000b0022878c0cc5esm3224680wrv.69.2022.09.05.02.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 02:46:35 -0700 (PDT)
Message-ID: <b5ce51e6-976b-1729-3023-c4c4deb36f14@gmail.com>
Date:   Mon, 5 Sep 2022 12:46:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3 8/9] sched/topology: Introduce for_each_numa_hop_cpu()
Content-Language: en-US
To:     Valentin Schneider <vschneid@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
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
References: <20220825181210.284283-1-vschneid@redhat.com>
 <20220825181210.284283-9-vschneid@redhat.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220825181210.284283-9-vschneid@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/2022 9:12 PM, Valentin Schneider wrote:
> The recently introduced sched_numa_hop_mask() exposes cpumasks of CPUs
> reachable within a given distance budget, but this means each successive
> cpumask is a superset of the previous one.
> 
> Code wanting to allocate one item per CPU (e.g. IRQs) at increasing
> distances would thus need to allocate a temporary cpumask to note which
> CPUs have already been visited. This can be prevented by leveraging
> for_each_cpu_andnot() - package all that logic into one ugl^D fancy macro.
> 
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>   include/linux/topology.h | 37 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 37 insertions(+)
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 13b82b83e547..6c671dc3252c 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -254,5 +254,42 @@ static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
>   }
>   #endif	/* CONFIG_NUMA */
>   
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
> + * To accommodate for that, we use for_each_cpu_andnot() to iterate over the cpus
> + * of sched_numa_hop_mask(node, hops+1) with the CPUs of
> + * sched_numa_hop_mask(node, hops) removed, IOW we only iterate over CPUs
> + * a given distance away (rather than *up to* a given distance).
> + *
> + * hops=0 forces us to play silly games: we pass cpu_none_mask to
> + * for_each_cpu_andnot(), which turns it into for_each_cpu().
> + */
> +#define for_each_numa_hop_cpu(cpu, node)				       \
> +	for (struct { const struct cpumask *curr, *prev; int hops; } __v =     \
> +		     { sched_numa_hop_mask(node, 0), NULL, 0 };		       \
> +	     !IS_ERR_OR_NULL(__v.curr);					       \
> +	     __v.hops++,                                                       \
> +	     __v.prev = __v.curr,					       \
> +	     __v.curr = sched_numa_hop_mask(node, __v.hops))                   \
> +		for_each_cpu_andnot(cpu,				       \
> +				    __v.curr,				       \
> +				    __v.hops ? __v.prev : cpu_none_mask)
>   

Hiding two nested loops together in one for_each_* macro leads to 
unexpected behavior for the standard usage of 'break/continue'.

for_each_numa_hop_cpu(cpu, node) {
     if (condition)
         break; <== will terminate the inner loop only, but it's 
invisible to the human developer/reviewer.
}

These bugs will not be easy to spot in code review.

>   #endif /* _LINUX_TOPOLOGY_H */

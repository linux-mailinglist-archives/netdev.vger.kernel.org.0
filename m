Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A826B845F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 22:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCMV7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 17:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjCMV7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 17:59:22 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7436076F7B;
        Mon, 13 Mar 2023 14:58:42 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id k2so6659367pll.8;
        Mon, 13 Mar 2023 14:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678744721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HWJODkqrRECt3/P3lNtlpvnWhMMpXFIJVNXQyKBkHq4=;
        b=Jl54/82p38J/9G1j6yQs9Fex7Kzxot4A0dv7cERUkoxcPYmnK/DO5KgN+AtfdhY3OV
         EalwrZU1fwzGFiO03fNQCHNZw3vaxdoqtkY1+S2clSAEL8Jk8dNhCMrSluxp6k3tChct
         0E0wCravxS2gg7Iv9Lx94ov+45dtIFuZXEs7G8oDDZtZoRBQqeBP2LBf9anbnJqWW1fB
         9M+aIjPt5JIAyYYeWxibakptT7bhg6N+O1l1M1Opqr1wQwdohTN4/0HqTT3Tdny5Gt7X
         bt6NwLhyM/EiXLIL+WXUTdhQYlPaddGgBuMoFhQiHkMrJ1rpFVoIxANXK4YfNKkPV8uI
         LZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678744721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HWJODkqrRECt3/P3lNtlpvnWhMMpXFIJVNXQyKBkHq4=;
        b=GhAs9rz0cW9YfGqi+23FhmykbqW9FZ7AogW8CT2i7veOzE03tAZZMjvtWJDMupnVdI
         sP/mhF5guTu3HNK5La66sCaPOy6crGXexpqwrGUIJlOJVKyS+jEflVdfWOupiZW21BlN
         Lboy8n3Lm8gFKkE4KgKitZ4MMSGz9DQHtjQZBMNI5/AhGcWymuBaAqGPTj92dLqNe+Zb
         MIALnc5ucQEIvbZDTcTaxBlG+zXXGNIIjr2yva07qP3dYzFP4c62NpTH1dSLQfCW5KN0
         Gtl50zQKI9NWJTvZOCoLxEHG/ET0sqjMmVAGLKhnaddky9ItZhfUF7qNkst1dGkSbuCl
         qEFQ==
X-Gm-Message-State: AO0yUKWUF/m3aiYnkRHjLcwEt6VCqMbRvWJoT7Gk7uwAXIlDW74dQv50
        gXWtqviOEkuH7xJghkQUlq8=
X-Google-Smtp-Source: AK7set+Xi+rsN8wCRB9yGkku3iN9JU2mvGWFvelQhD8hDD9QRTS0dECDw9WnE8Wr61SMXMqs9CIyBw==
X-Received: by 2002:a17:903:187:b0:19d:16fa:ba48 with SMTP id z7-20020a170903018700b0019d16faba48mr43371063plg.28.1678744721565;
        Mon, 13 Mar 2023 14:58:41 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21c1::1247? ([2620:10d:c090:400::5:3712])
        by smtp.gmail.com with ESMTPSA id kk4-20020a170903070400b0019a7ef5e9a8sm326082plb.82.2023.03.13.14.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 14:58:41 -0700 (PDT)
Message-ID: <cb09d3eb-8796-b6b8-10cb-35700ea9b532@gmail.com>
Date:   Mon, 13 Mar 2023 14:58:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net: introduce budget_squeeze to help us tune rx
 behavior
Content-Language: en-US, en-ZW
To:     Jason Xing <kerneljasonxing@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     kuniyu@amazon.com, liuhangbin@gmail.com, xiangxia.m.yue@gmail.com,
        jiri@nvidia.com, andy.ren@getcruise.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
References: <20230311163614.92296-1-kerneljasonxing@gmail.com>
From:   Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <20230311163614.92296-1-kerneljasonxing@gmail.com>
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



On 3/11/23 08:36, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> When we encounter some performance issue and then get lost on how
> to tune the budget limit and time limit in net_rx_action() function,
> we can separately counting both of them to avoid the confusion.
> 
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
> note: this commit is based on the link as below:
> https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@gmail.com/
> ---
>   include/linux/netdevice.h |  1 +
>   net/core/dev.c            | 12 ++++++++----
>   net/core/net-procfs.c     |  9 ++++++---
>   3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 6a14b7b11766..5736311a2133 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3157,6 +3157,7 @@ struct softnet_data {
>   	/* stats */
>   	unsigned int		processed;
>   	unsigned int		time_squeeze;
> +	unsigned int		budget_squeeze;
>   #ifdef CONFIG_RPS
>   	struct softnet_data	*rps_ipi_list;
>   #endif
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 253584777101..bed7a68fdb5d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6637,6 +6637,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>   	unsigned long time_limit = jiffies +
>   		usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
>   	int budget = READ_ONCE(netdev_budget);
> +	bool is_continue = true;
>   	LIST_HEAD(list);
>   	LIST_HEAD(repoll);
>   
> @@ -6644,7 +6645,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>   	list_splice_init(&sd->poll_list, &list);
>   	local_irq_enable();
>   
> -	for (;;) {
> +	for (; is_continue;) {
>   		struct napi_struct *n;
>   
>   		skb_defer_free_flush(sd);
> @@ -6662,10 +6663,13 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>   		 * Allow this to run for 2 jiffies since which will allow
>   		 * an average latency of 1.5/HZ.
>   		 */
> -		if (unlikely(budget <= 0 ||
> -			     time_after_eq(jiffies, time_limit))) {
> +		if (unlikely(budget <= 0)) {
> +			sd->budget_squeeze++;
> +			is_continue = false;
> +		}
> +		if (unlikely(time_after_eq(jiffies, time_limit))) {
>   			sd->time_squeeze++;
> -			break;
> +			is_continue = false;
>   		}
>   	}
>   
> diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> index 97a304e1957a..4d1a499d7c43 100644
> --- a/net/core/net-procfs.c
> +++ b/net/core/net-procfs.c
> @@ -174,14 +174,17 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
>   	 */
>   	seq_printf(seq,
>   		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
> -		   "%08x %08x\n",
> -		   sd->processed, sd->dropped, sd->time_squeeze, 0,
> +		   "%08x %08x %08x %08x\n",
> +		   sd->processed, sd->dropped,
> +		   0, /* was old way to count time squeeze */

Should we show a proximate number?  For example,
sd->time_squeeze + sd->bud_squeeze.


> +		   0,
>   		   0, 0, 0, 0, /* was fastroute */
>   		   0,	/* was cpu_collision */
>   		   sd->received_rps, flow_limit_count,
>   		   0,	/* was len of two backlog queues */
>   		   (int)seq->index,
> -		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd));
> +		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd),
> +		   sd->time_squeeze, sd->budget_squeeze);
>   	return 0;
>   }
>   

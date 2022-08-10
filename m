Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EAD58EC83
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiHJM61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbiHJM54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:57:56 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CB7868B8;
        Wed, 10 Aug 2022 05:57:38 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l4so17616128wrm.13;
        Wed, 10 Aug 2022 05:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=T2be+Zp3BRWJY28DzQwwQ6dblnROjqmbLs3Ho5BkMeU=;
        b=gfdFdeGfZtxc+le394dNA2aOBnUmu2HKWBAgmY2lLf7anpFNz2oN3dnaro8WgllmXu
         j7N7GDZ9WQt/XYtKXVjzBsCIVWCeyE+6x8jj88swuYES2UwIx5Y14JF2T0kWUB7j+m7t
         6kDIVLnXzDjWwrCBDKO41IKkA7kTZnfdaS8h06lzJJIAJ+wRTNfzgMznvOHv/eZjbWwm
         c+F2l0AXKc6nF0qDnAUO7fXBdWOaddOp0saKUCfrxQddx3OZlElY+WnXSr5itZmwEzaw
         AXGPJUkMKUSQ0cG02XSZBu5AKu+BP0GuURd/GwMxwlY9MHIKrefuYV4BaUiDOQA7RGJs
         0QgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=T2be+Zp3BRWJY28DzQwwQ6dblnROjqmbLs3Ho5BkMeU=;
        b=kVWIdrsRalB/AeGZHfFQQNpCW5vrJFLzsxUHNNbaJpe67a49e4ZQ7jdQ8rQcO4Rjs0
         vqn8p2U4jXwLd+nd0MHkXYewA3eM+mLVw7TV5bEStIAwDF8wzwtkq3hhNcUzNH8QtiIQ
         G4cDmxg7Vz6ncGbktPqFeH0cyEdctZCSpCgmaMvnEMfZ0kSKmc4Im7cqfOnS5sydvZU4
         tsbBzr9BTTIeTUPLRIg7BXWarU1k4ypCdMcUFiQpDHXgchus1ojRDoTbOC1/6bwxkGsL
         eK8rfyG3CzNJV8TGql3T+hxfQE+M7CnCUZbZjeXw3U1t9/PYKXc5w940lR60BM0rOwzy
         6mVQ==
X-Gm-Message-State: ACgBeo1Ow1slq8ujT3P4VXNHz0kocfwmjhlIhPLny7vXuc1b1LAOG3Qa
        G78WZjeb8r2ziTzw4izFPSg=
X-Google-Smtp-Source: AA6agR4aCrPkvCHK3qpBL3kcQh2NZUsredunvzUyeviW3uKJ42iSQWO1RC+C9aqq7DPcGWPL96hH6Q==
X-Received: by 2002:a5d:4b8c:0:b0:223:7c9f:cad8 with SMTP id b12-20020a5d4b8c000000b002237c9fcad8mr1916083wrt.247.1660136256762;
        Wed, 10 Aug 2022 05:57:36 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id e16-20020a5d65d0000000b0021b970a68f9sm16350991wrw.26.2022.08.10.05.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 05:57:36 -0700 (PDT)
Message-ID: <8448dade-a64a-0b6b-1ed0-dd164917eedf@gmail.com>
Date:   Wed, 10 Aug 2022 15:57:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] net/mlx5e: Leverage sched_numa_hop_mask()
Content-Language: en-US
To:     Valentin Schneider <vschneid@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
References: <xhsmhtu6kbckc.mognet@vschneid.remote.csb>
 <20220810105119.2684079-1-vschneid@redhat.com>
 <20220810105119.2684079-2-vschneid@redhat.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220810105119.2684079-2-vschneid@redhat.com>
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
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/eq.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 

Missing description.

I had a very detailed description with performance numbers and an 
affinity hints example with before/after tables. I don't want to get 
them lost.


> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> index 229728c80233..2eb4ffd96a95 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> @@ -809,9 +809,12 @@ static void comp_irqs_release(struct mlx5_core_dev *dev)
>   static int comp_irqs_request(struct mlx5_core_dev *dev)
>   {
>   	struct mlx5_eq_table *table = dev->priv.eq_table;
> +	const struct cpumask *mask;
>   	int ncomp_eqs = table->num_comp_eqs;
> +	int hops = 0;
>   	u16 *cpus;
>   	int ret;
> +	int cpu;
>   	int i;
>   
>   	ncomp_eqs = table->num_comp_eqs;
> @@ -830,8 +833,17 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
>   		ret = -ENOMEM;
>   		goto free_irqs;
>   	}
> -	for (i = 0; i < ncomp_eqs; i++)
> -		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
> +
> +	rcu_read_lock();
> +	for_each_numa_hop_mask(dev->priv.numa_node, hops, mask) {

We don't really use this 'hops' iterator. We always pass 0 (not a 
valuable input...), and we do not care about its final value. Probably 
it's best to hide it from the user into the macro.

> +		for_each_cpu(cpu, mask) {
> +			cpus[i] = cpu;
> +			if (++i == ncomp_eqs)
> +				goto spread_done;
> +		}
> +	}
> +spread_done:
> +	rcu_read_unlock();
>   	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
>   	kfree(cpus);
>   	if (ret < 0)

This logic is typical. Other drivers would also want to use it.
It must be introduced as a service/API function, if not by the sched 
topology, then at least by the networking subsystem.
Jakub, WDYT?

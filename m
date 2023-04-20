Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2A6E8CBA
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbjDTI1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbjDTI1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:27:34 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F463AAF;
        Thu, 20 Apr 2023 01:27:33 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-2eed43bfa4bso354946f8f.2;
        Thu, 20 Apr 2023 01:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681979252; x=1684571252;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jlo4F4g3+lV8QJ0E+q6K5kxPhHFeMG0/1IdnsG1CVbs=;
        b=RbUI3J9JbEu22j/FdIjKbLPtmcuoTQxJBMnXpKoaSO0yIjKk58x3ylfFnfNcdaFc1b
         9uwrAPpCw2XsgjMyjg/Jkp3MKX7JGfQW56x88Zt+J382I8+eFDgAQbiC4kRNu//pck1G
         QTlUoX2bkyZysOPs7OROcNq7K0Qx/A6MSJ4KMVWqbfeitH02J1mxSs9hCuWa0thnb8zv
         kLXsBb43WnESrXHV5w0npPFdRm530YH2nKHDEaS6hnt4ilxntplGTUo2Ecpp5l/R7tjl
         4hXb1gb3Fu3JjXhUWIjO/KkNxCXnioduQmI1Xq2KmqsBlTizzx9ZuYVnU5aF5l3DK8Og
         4F5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681979252; x=1684571252;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jlo4F4g3+lV8QJ0E+q6K5kxPhHFeMG0/1IdnsG1CVbs=;
        b=TzYDh/HoxZwVpNIMUCUgVcaSkCwF+0M46ttbQuG5gcbgdE1mfVhNiMexPOdhZSC+w3
         iCiPuN4+y9CeHpS0d6HGItTLkSSv38B0erqZ+F7Ajhz8hH7U1GRHP2KIk9dAaG/3Uv8m
         QfIzmAHnZYvEx8tkGE+1Acx1tUw/h4ZiStTHQnFWNxtf/zPX45erZ4HSUXnL8cUKwXgW
         RUE1WCGfxHtqTMtZhKXqZQQpw7ek2zPVCB3FY1voOCt7xZWXiEeVr4lieY/f+KMlJs+C
         OSFtXEI/6CrvxueKPsJ2rKAGEGppcWBPhcAebdI0ocEETGOIwzDMZrkbprZGEK1DiJ5/
         BYAQ==
X-Gm-Message-State: AAQBX9eLc4EUHeMfMVb79WQ8Wuu5TdA/YJxHX1J26pNiNwQGyOngYm6z
        uL91Yq3v55+tWkoS0HPqi8E=
X-Google-Smtp-Source: AKy350a0fvCr5yXGh2DWTwSBE5pka+2OSnlP/XdSkIuHFdS2h/tPJ2+Cco6gw1wD04pg2RwRJr9HOA==
X-Received: by 2002:adf:f14c:0:b0:2ff:f37:9d1a with SMTP id y12-20020adff14c000000b002ff0f379d1amr613807wro.62.1681979251597;
        Thu, 20 Apr 2023 01:27:31 -0700 (PDT)
Received: from [192.168.0.103] ([77.124.103.108])
        by smtp.gmail.com with ESMTPSA id f3-20020adfdb43000000b002efb2d861dasm1294605wrj.77.2023.04.20.01.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 01:27:31 -0700 (PDT)
Message-ID: <6b3f92e7-e54c-bb7d-2d72-1a0875989d4a@gmail.com>
Date:   Thu, 20 Apr 2023 11:27:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 4/8] net: mlx5: switch comp_irqs_request() to using
 for_each_numa_cpu
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-5-yury.norov@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230420051946.7463-5-yury.norov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/04/2023 8:19, Yury Norov wrote:
> for_each_numa_cpu() is a more straightforward alternative to
> for_each_numa_hop_mask() + for_each_cpu_andnot().
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/eq.c | 16 +++++-----------
>   1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> index 38b32e98f3bd..80368952e9b1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> @@ -817,12 +817,10 @@ static void comp_irqs_release(struct mlx5_core_dev *dev)
>   static int comp_irqs_request(struct mlx5_core_dev *dev)
>   {
>   	struct mlx5_eq_table *table = dev->priv.eq_table;
> -	const struct cpumask *prev = cpu_none_mask;
> -	const struct cpumask *mask;
>   	int ncomp_eqs = table->num_comp_eqs;
>   	u16 *cpus;
>   	int ret;
> -	int cpu;
> +	int cpu, hop;
>   	int i;
>   
>   	ncomp_eqs = table->num_comp_eqs;
> @@ -844,15 +842,11 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
>   
>   	i = 0;
>   	rcu_read_lock();
> -	for_each_numa_hop_mask(mask, dev->priv.numa_node) {
> -		for_each_cpu_andnot(cpu, mask, prev) {
> -			cpus[i] = cpu;
> -			if (++i == ncomp_eqs)
> -				goto spread_done;
> -		}
> -		prev = mask;
> +	for_each_numa_cpu(cpu, hop, dev->priv.numa_node, cpu_possible_mask) {

I like this clean API.

nit:
Previously cpu_online_mask was used here. Is this change intentional?
We can fix it in a followup patch if this is the only comment on the series.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

> +		cpus[i] = cpu;
> +		if (++i == ncomp_eqs)
> +			break;
>   	}
> -spread_done:
>   	rcu_read_unlock();
>   	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
>   	kfree(cpus);


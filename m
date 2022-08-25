Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4E65A1AE2
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242777AbiHYVQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiHYVQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:16:23 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980D6B729D;
        Thu, 25 Aug 2022 14:16:21 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id r1-20020a056830418100b0063938f634feso7565073otu.8;
        Thu, 25 Aug 2022 14:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=WgvG2W29oRYqx+pgSWt6jhXW7xV77AuyXqSnhGc+5XA=;
        b=YTJFbhMlgG5jNIGSn/jzFi5xhXPrbKa20EX719xjEhIE037jficM3USz22fFii2wPV
         IW6bJzFksTZpnQn+lS7KVD50WMWdAtsLwdKb0I5WLbXt29TMe5+NU2W2A4KZv5Rvc+BT
         pRbJzCTmf6i1dvZaRiSy2SZ5w7h6g4FWT1thiRz3Ite8KdnYOKucYDtVgzkudn6K1hW/
         uQJpLURmIYMALjFuhdnI6KVoCKhpq145PNp3/9RCrrGK/GXBsQh5Kc2xP79ZYo359yik
         LX7/+OoSoFLrC3/2juyViecx5aHJPkP5PR3g+EibV7c/ojcfR4wcVE/tmF7ji3yk+0FQ
         xvjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=WgvG2W29oRYqx+pgSWt6jhXW7xV77AuyXqSnhGc+5XA=;
        b=0zzC9fg2P++TCR8/y0FBbTEwP9+ZQ7EGip0qZ6IK9Gxw0UZT94GB7dF+zIDpen1VQE
         ZN2yhOgWOfOY5MT3bxzHjn7wJR95K0mTLKmczO5dSU/i3NpKtbW9hBFUnP8WJ3JCWWSo
         kiWd0Dj7VoKONG5M3BdmP2/ftM8RqEehra9f1bI4BHNyFRLxEGdvWHC6hgO+72qqRjxU
         7uu61vaqhfHT8gENgGQ4qUFvjzrG5TomXrCKhXX4qtiB3A5XuZMYrqPw/r2J/CIiU0kK
         sLORnVv/5JrWZZW5r97kJQEYnxzs7E0duIpHi6w2+Faa2InE83+tvwfxRvh3fRKSOk7r
         lYvQ==
X-Gm-Message-State: ACgBeo1cr8Bfr/dKesyV/AxJrhz3pi/h53kgWjudcc/T20Eh47dvwuYJ
        D7xactvGiVMkoV1jbycdzBU=
X-Google-Smtp-Source: AA6agR7/xDw/ouHQ0sD6PHgtrb5u2On7h+B3nA3d5B9WOAtCtR7hyB9VUWMqDpgpBVtksulJAmixcg==
X-Received: by 2002:a05:6830:1b62:b0:639:21d9:dec2 with SMTP id d2-20020a0568301b6200b0063921d9dec2mr340325ote.356.1661462180617;
        Thu, 25 Aug 2022 14:16:20 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id p81-20020acad854000000b00342ded07a75sm207899oig.18.2022.08.25.14.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:16:20 -0700 (PDT)
Date:   Thu, 25 Aug 2022 14:14:08 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
Subject: Re: [PATCH v3 4/9] cpumask: Introduce for_each_cpu_andnot()
Message-ID: <YwfmIDEbRT4JfsZp@yury-laptop>
References: <20220825181210.284283-1-vschneid@redhat.com>
 <20220825181210.284283-5-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825181210.284283-5-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 07:12:05PM +0100, Valentin Schneider wrote:
> for_each_cpu_and() is very convenient as it saves having to allocate a
> temporary cpumask to store the result of cpumask_and(). The same issue
> applies to cpumask_andnot() which doesn't actually need temporary storage
> for iteration purposes.
> 
> Following what has been done for for_each_cpu_and(), introduce
> for_each_cpu_andnot().
> 
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>  include/linux/cpumask.h | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index 1414ce8cd003..372a642bf9ba 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -238,6 +238,25 @@ unsigned int cpumask_next_and(int n, const struct cpumask *src1p,
>  		nr_cpumask_bits, n + 1);
>  }
>  
> +/**
> + * cpumask_next_andnot - get the next cpu in *src1p & ~*src2p
> + * @n: the cpu prior to the place to search (ie. return will be > @n)
> + * @src1p: the first cpumask pointer
> + * @src2p: the second cpumask pointer
> + *
> + * Returns >= nr_cpu_ids if no further cpus set in *src1p & ~*src2p
> + */
> +static inline
> +unsigned int cpumask_next_andnot(int n, const struct cpumask *src1p,
> +				 const struct cpumask *src2p)
> +{
> +	/* -1 is a legal arg here. */
> +	if (n != -1)
> +		cpumask_check(n);
> +	return find_next_andnot_bit(cpumask_bits(src1p), cpumask_bits(src2p),
> +		nr_cpumask_bits, n + 1);
> +}
> +
>  /**
>   * for_each_cpu - iterate over every cpu in a mask
>   * @cpu: the (optionally unsigned) integer iterator
> @@ -317,6 +336,26 @@ unsigned int __pure cpumask_next_wrap(int n, const struct cpumask *mask, int sta
>  		(cpu) = cpumask_next_and((cpu), (mask1), (mask2)),	\
>  		(cpu) < nr_cpu_ids;)
>  
> +/**
> + * for_each_cpu_andnot - iterate over every cpu present in one mask, excluding
> + *			 those present in another.
> + * @cpu: the (optionally unsigned) integer iterator
> + * @mask1: the first cpumask pointer
> + * @mask2: the second cpumask pointer
> + *
> + * This saves a temporary CPU mask in many places.  It is equivalent to:
> + *	struct cpumask tmp;
> + *	cpumask_andnot(&tmp, &mask1, &mask2);
> + *	for_each_cpu(cpu, &tmp)
> + *		...
> + *
> + * After the loop, cpu is >= nr_cpu_ids.
> + */
> +#define for_each_cpu_andnot(cpu, mask1, mask2)				\
> +	for ((cpu) = -1;						\
> +		(cpu) = cpumask_next_andnot((cpu), (mask1), (mask2)),	\
> +		(cpu) < nr_cpu_ids;)

The standard doesn't guarantee the order of execution of last 2 lines,
so you might end up with unreliable code. Can you do it in a more
conventional style:
   #define for_each_cpu_andnot(cpu, mask1, mask2)			\
   	for ((cpu) = cpumask_next_andnot(-1, (mask1), (mask2));	        \
   		(cpu) < nr_cpu_ids;                                     \
   		(cpu) = cpumask_next_andnot((cpu), (mask1), (mask2)))	

> +
>  /**
>   * cpumask_any_but - return a "random" in a cpumask, but not this one.
>   * @mask: the cpumask to search
> -- 
> 2.31.1

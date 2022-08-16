Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E4659657A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbiHPW0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbiHPW0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:26:45 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF68C90814;
        Tue, 16 Aug 2022 15:26:44 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id p132so13620763oif.9;
        Tue, 16 Aug 2022 15:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=CwyJ6GUKaEkPsKlT4efasHrB0kt/DM6/7ER1yUHSsiI=;
        b=TTcyewG+T9Wi//ubAMpljSmvJgj/c00kw7sJ/Kz4AFxKfugrcGs1LIeL90hyTdh1/n
         zHFkv/zpUhY3FQUnO5IMBL8HA1jZq8GWaPDFyzyz+7Swk2wSX6v4P3U4mPo8MIDLloR2
         1BN04uO+3dfls7pqh7hM+l4pdy3ICm8ZQ7g2rmaWYCIeozqeg+vv3dlO+GgKHgScHb0i
         tnBVA9JaPEONcXJ3apTmHyTVaS1x1mCQsY6Yr11yFD/h642ov7rQupKurNm6E9Io0Opg
         1uHBvveRiRvFfko/J6Vwad5fNsvuUGLuB65p5TgZEqXiLtJTZYZTd+eOgzP5eWeaZ+yU
         pohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=CwyJ6GUKaEkPsKlT4efasHrB0kt/DM6/7ER1yUHSsiI=;
        b=IBJBVrxHExKPTkBP1vfVEc9k2XHZsrGzGvdepV4oHFOXR9LJtNynjnOJpGFsN+amzV
         77QThY/Xb4VjwFHqtsKiMx52wCm7vJsbuBgyF0MC3JPHRHDEDLHLdkSHx/uGL0L19gXv
         NQ8HGj93q8QNaW1uwr7x4KDdbBL71h2RRhRPyqOexSPRSHrdXCGnegIQ1vSrpAlE5IAX
         Sf4qfnePsDcmFVAtBlkNryxyKScXiktRbSl2G5tS0y+dYspQJf9k5bVAc8YxvIUX+H/4
         ZvC2yGT+GPMYQNo8fmYh0zgXOwIJqs/slxMn9G52QjgzWA8CVQwrp4/4qHxLyXLJEijZ
         KoiQ==
X-Gm-Message-State: ACgBeo1PruwhFsJQepedVPKudz1Md24PdkE/gO4LbU8Q+Yc62sB5/kF5
        /rcP3A06KtE6r3QFZaBmV3A=
X-Google-Smtp-Source: AA6agR682aZxFQBk2EsMway+bI4HV3bR1eTLOKhCLig8pI3hw4sPKolUMPk/EOostjJB3af3CHgBCg==
X-Received: by 2002:a05:6808:1596:b0:344:9136:8b1d with SMTP id t22-20020a056808159600b0034491368b1dmr297704oiw.250.1660688803750;
        Tue, 16 Aug 2022 15:26:43 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id u12-20020a4aa34c000000b00432ac97ad09sm2622224ool.26.2022.08.16.15.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 15:26:43 -0700 (PDT)
Date:   Tue, 16 Aug 2022 15:24:31 -0700
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
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH 2/5] cpumask: Introduce for_each_cpu_andnot()
Message-ID: <YvwZH/q5rvT6JD5S@yury-laptop>
References: <20220816180727.387807-1-vschneid@redhat.com>
 <20220816180727.387807-3-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816180727.387807-3-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 07:07:24PM +0100, Valentin Schneider wrote:
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
>  include/linux/cpumask.h | 32 ++++++++++++++++++++++++++++++++
>  lib/cpumask.c           | 19 +++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index fe29ac7cc469..a8b2ca160e57 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -157,6 +157,13 @@ static inline unsigned int cpumask_next_and(int n,
>  	return n+1;
>  }
>  
> +static inline unsigned int cpumask_next_andnot(int n,
> +					    const struct cpumask *srcp,
> +					    const struct cpumask *andp)
> +{
> +	return n+1;
> +}
> +

It looks like the patch is not based on top of 6.0, where UP cpumask
operations were fixed.  Can you please rebase?

Thanks,
Yury

>  static inline unsigned int cpumask_next_wrap(int n, const struct cpumask *mask,
>  					     int start, bool wrap)
>  {
> @@ -194,6 +201,8 @@ static inline int cpumask_any_distribute(const struct cpumask *srcp)
>  	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)(start))
>  #define for_each_cpu_and(cpu, mask1, mask2)	\
>  	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask1, (void)mask2)
> +#define for_each_cpu_andnot(cpu, mask1, mask2)	\
> +	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask1, (void)mask2)
>  #else
>  /**
>   * cpumask_first - get the first cpu in a cpumask
> @@ -259,6 +268,9 @@ static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
>  }
>  
>  int __pure cpumask_next_and(int n, const struct cpumask *, const struct cpumask *);
> +int __pure cpumask_next_andnot(int n,
> +			       const struct cpumask *src1p,
> +			       const struct cpumask *src2p);
>  int __pure cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
>  unsigned int cpumask_local_spread(unsigned int i, int node);
>  int cpumask_any_and_distribute(const struct cpumask *src1p,
> @@ -324,6 +336,26 @@ extern int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool
>  	for ((cpu) = -1;						\
>  		(cpu) = cpumask_next_and((cpu), (mask1), (mask2)),	\
>  		(cpu) < nr_cpu_ids;)
> +
> +/**
> + * for_each_cpu_andnot - iterate over every cpu in one mask but not in another
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
> +
>  #endif /* SMP */
>  
>  #define CPU_BITS_NONE						\
> diff --git a/lib/cpumask.c b/lib/cpumask.c
> index a971a82d2f43..6896ff4a08fd 100644
> --- a/lib/cpumask.c
> +++ b/lib/cpumask.c
> @@ -42,6 +42,25 @@ int cpumask_next_and(int n, const struct cpumask *src1p,
>  }
>  EXPORT_SYMBOL(cpumask_next_and);
>  
> +/**
> + * cpumask_next_andnot - get the next cpu in *src1p & ~*src2p
> + * @n: the cpu prior to the place to search (ie. return will be > @n)
> + * @src1p: the first cpumask pointer
> + * @src2p: the second cpumask pointer
> + *
> + * Returns >= nr_cpu_ids if no further cpus set in *src1p & ~*src2p.
> + */
> +int cpumask_next_andnot(int n, const struct cpumask *src1p,
> +		     const struct cpumask *src2p)
> +{
> +	/* -1 is a legal arg here. */
> +	if (n != -1)
> +		cpumask_check(n);
> +	return find_next_andnot_bit(cpumask_bits(src1p), cpumask_bits(src2p),
> +		nr_cpumask_bits, n + 1);
> +}
> +EXPORT_SYMBOL(cpumask_next_andnot);
> +
>  /**
>   * cpumask_any_but - return a "random" in a cpumask, but not this one.
>   * @mask: the cpumask to search
> -- 
> 2.31.1

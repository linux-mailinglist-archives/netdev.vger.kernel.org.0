Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA025E93E7
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 17:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiIYPXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 11:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiIYPXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 11:23:32 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055D72B61D;
        Sun, 25 Sep 2022 08:23:30 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id q11so2831218qkc.12;
        Sun, 25 Sep 2022 08:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=F232+07SEex65wCsfmEG2+nw/5WIhK0scMWWBsftS3E=;
        b=aWIb5oIqcDP7YBMH03rZHBOG4v+QqrTob2L3cL5JMvHqPTcoG6NBhcnd9HFfPaiRi7
         JnR44z8Rt8hiiS/vqVBAXBsiYayYftzfnyGuYvQnEqUsYWWEkg9ewc4tJov3GHLBZ0R0
         XrAWe9QISWjhUL1IyHMJ3sisDdlQ6frmpdrdIrDX4/b+cv1Gt2bcBzHnW2JaLfR0kS2z
         I/5BG8WDT5iwx5DD/5h4K/thAZaPgXEt8QTkk/GTPsllIkrhAx7mwJQfNsTj8oBIONRi
         TmOMvgXA++JskOCSt4h3jbo+WPkTK6vM0zRLhpuK7IpngYjdg5PezB2fRBxJc5+kx56+
         zkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=F232+07SEex65wCsfmEG2+nw/5WIhK0scMWWBsftS3E=;
        b=RrJ22sUILLL/K8Q0fECuCJDmyr7tbzeMrL8hJfqYtWms56PGoHjhR0kZ8BOqukFoAr
         ZCPH4K+LyM0VeT++agPRQmABHO0UgW7pBpz4/gD0nlwABGJ5h7fxlVP+4nq7AFoozvGO
         VtdFcWJX+HjmqRLG1oT1u/PraTSCOufiGFloGoSuKquOyxJGsClSJklXowPW6W18uKWg
         +X6LamfqnOdnaP18NvIX32XCCBfGPZPRkqVoKcn1SOen0C8lhwidr8MJjJZWG5hSdU9A
         Cl43SIFZBDYRX4H5+S0hM4JASF5hoD2pHpBcFir5eFRbDfDsnNLph6Qw5wT3PffIvFVK
         Tl/A==
X-Gm-Message-State: ACrzQf1pSFEjgSFmIT7NYSugr3lJhNN2vHaR/PGX52fBY88Up+VH+7mI
        cezSwKEK00b5NqDR6nv/z0U=
X-Google-Smtp-Source: AMsMyM5epw4OHr4aH1tu7RQruifSnEWvPv3Q0L25mWsT1R+bow/bij2DcXxBgRisc2zdd+fvpJKI+A==
X-Received: by 2002:a05:620a:2699:b0:6cf:3ee4:5657 with SMTP id c25-20020a05620a269900b006cf3ee45657mr11644437qkp.475.1664119408977;
        Sun, 25 Sep 2022 08:23:28 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:2eaf:6d8e:66c4:eb75])
        by smtp.gmail.com with ESMTPSA id gd10-20020a05622a5c0a00b00343057845f7sm9468577qtb.20.2022.09.25.08.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 08:23:28 -0700 (PDT)
Date:   Sun, 25 Sep 2022 08:23:28 -0700
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
Subject: Re: [PATCH v4 2/7] cpumask: Introduce for_each_cpu_andnot()
Message-ID: <YzBycCwecSUlGgjX@yury-laptop>
References: <20220923132527.1001870-1-vschneid@redhat.com>
 <20220923155542.1212814-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923155542.1212814-1-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 04:55:37PM +0100, Valentin Schneider wrote:
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
> index 1b442fb2001f..4c69e338bb8c 100644
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

This is wrong. n-1 should be illegal here. The correct check is:
cpumask_check(n+1);

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

This would raise cpumaks_check() warning at the very last iteration.
Because cpu is initialized insize the loop, you don't need to check it
at all. You can do it like this:

 #define for_each_cpu_andnot(cpu, mask1, mask2)				\
         for_each_andnot_bit(...)

Check this series for details (and please review).
https://lore.kernel.org/all/20220919210559.1509179-8-yury.norov@gmail.com/T/

Thanks,
Yury

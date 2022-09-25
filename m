Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B735E93CA
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 16:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbiIYO6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 10:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIYO6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 10:58:45 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B936E2CC8C;
        Sun, 25 Sep 2022 07:58:44 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id d1so3043993qvs.0;
        Sun, 25 Sep 2022 07:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=2l0jdFkT3rhs2SpZoXVCVhmPyI4lvpR2ASsFANeL4u8=;
        b=dxu7H0F1Vcn+7FADZY7fmT5SGAOFWUotoKbDGjPKwFYU+MXoLw1rI/6bTJ8WMi/V7c
         cR6MxBxRIFVyyh9WObXiY1rY6y1qTE2ypVm3WnhEeThr32sypHIiPIQA97+4JnuiFx5B
         g1J1wby3swpsTqSnnVDfwlSsfvqVqkPEE8YFEslQ8rK3/gYkrbTYoGp2YIONHwCcKAih
         vhYhxK4diaDKyaDKZutYyQeIbek9h1xvBiLEojApPHVdN/Dj4GVj2KWBpLKefxB5rp+l
         sQkzWJIOoq0PXgpBvqoOQGgUMTOfybm//VB+rTCQ4+HTULWO8dOmOCJ0c0sTPCBsrZ+x
         RkYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=2l0jdFkT3rhs2SpZoXVCVhmPyI4lvpR2ASsFANeL4u8=;
        b=dAT55zms8L5e0pcdJ9WU7T1cwV37Nta8JkQudLpgui4ZEwrX4YtCpAdDCuvkp/YEmX
         mOtkklKgwCQKiPo/W47gTmT39fOwanyrrX01ZTcVkM7M7ouuX7ZJwTEG9ijOHJr4CYPQ
         IDUW1GT8LslF9QaGwTK+Y3cDDWcKGZZjKkAPAGtA/3MZJXWs9kwLZF2CloNXDkFOmPYL
         gUATgbCs9UhbF0KDZRRFN5oX92qAgXRieWvvfBa47BOIMiU3InEVohvP336TQMZz2K3q
         1SzYg307r8KZSW1jzOED0Q6y4Pxt+YujE6kMpRKeoIuW418Qj5Ug0FCmh9ZyPehSb2Q1
         Or0A==
X-Gm-Message-State: ACrzQf2EqMdR8xrFgjD+23oeUZVPMdq+mwbipvWGK6dhrv8RZSMPVLHB
        UaYoZajZe5Kp5+nANjMbWRA=
X-Google-Smtp-Source: AMsMyM7dyqrnjYV83Cw2l7eXO6OPvlEZiYWGiuLBw9Oduzf1KDB8NeVLqy5MEc+m9kQspP4SY22UvQ==
X-Received: by 2002:a05:6214:2522:b0:4ad:6956:fc83 with SMTP id gg2-20020a056214252200b004ad6956fc83mr14097789qvb.37.1664117923668;
        Sun, 25 Sep 2022 07:58:43 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:2eaf:6d8e:66c4:eb75])
        by smtp.gmail.com with ESMTPSA id gd10-20020a05622a5c0a00b00343057845f7sm9435242qtb.20.2022.09.25.07.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 07:58:43 -0700 (PDT)
Date:   Sun, 25 Sep 2022 07:58:42 -0700
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
Subject: Re: [PATCH v4 6/7] sched/topology: Introduce for_each_numa_hop_cpu()
Message-ID: <YzBsonBFi9OJ29UT@yury-laptop>
References: <20220923132527.1001870-1-vschneid@redhat.com>
 <20220923155542.1212814-5-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923155542.1212814-5-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 04:55:41PM +0100, Valentin Schneider wrote:
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
>  include/linux/topology.h | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 3e91ae6d0ad5..7aa7e6a4c739 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -257,5 +257,42 @@ static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
>  }
>  #endif	/* CONFIG_NUMA */
>  
> +/**
> + * for_each_numa_hop_cpu - iterate over CPUs by increasing NUMA distance,
> + *                         starting from a given node.
> + * @cpu: the iteration variable.
> + * @node: the NUMA node to start the search from.
> + *
> + * Requires rcu_lock to be held.
> + * Careful: this is a double loop, 'break' won't work as expected.

This warning concerns me not only because new iteration loop hides
complexity and breaks 'break' (sic!), but also because it looks too
specific. Why don't you split it, so instead:

       for_each_numa_hop_cpu(cpu, dev->priv.numa_node) {
               cpus[i] = cpu;
               if (++i == ncomp_eqs)
                       goto spread_done;
       }

in the following patch you would have something like this:

       for_each_node_hop(hop, node) {
               struct cpumask hop_cpus = sched_numa_hop_mask(node, hop);

               for_each_cpu_andnot(cpu, hop_cpus, ...) {
                       cpus[i] = cpu;
                       if (++i == ncomp_eqs)
                               goto spread_done;
               }
       }

It looks more bulky, but I believe there will be more users for
for_each_node_hop() alone.

On top of that, if you really like it, you can implement
for_each_numa_hop_cpu() if you want.

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

This anonymous structure is never used as structure. What for you
define it? Why not just declare hops, prev and curr without packing
them?

Thanks,
Yury

> +	     !IS_ERR_OR_NULL(__v.curr);					       \
> +	     __v.hops++,                                                       \
> +	     __v.prev = __v.curr,					       \
> +	     __v.curr = sched_numa_hop_mask(node, __v.hops))                   \
> +		for_each_cpu_andnot(cpu,				       \
> +				    __v.curr,				       \
> +				    __v.hops ? __v.prev : cpu_none_mask)
>  
>  #endif /* _LINUX_TOPOLOGY_H */
> -- 
> 2.31.1

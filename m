Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A498564674F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiLHCzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiLHCzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:55:39 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741729493C;
        Wed,  7 Dec 2022 18:55:38 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-14449b7814bso431734fac.3;
        Wed, 07 Dec 2022 18:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JVcCFh37FoXjjtXudToxcf21kiMwk5o8/ZLx5Sn1apc=;
        b=h6M+DxJsZY1Y1BRELFRI6g9fQ9hgUhoxXGu5V7Te00bm7y1Tjw9lwzowfMG7fztVsX
         Lo6qGyw1MERMSF8j8G64FDEE7ywHsaXzpVQm4YtKB1LvVsPedIte872L0NJlMK0rRUyb
         rFKYcAdeqgmDQD6gbsa2L/jU3gIpNnftMhTS6Z9bGJ7bwldz/1Na7TB5QTMJEKohEZL7
         9FmavC2kLMZ/vN5JERRyVxNZtbqzToj2XkS/HXqWIJymK9KxFoU1vui5TOnOQMPmJ4i2
         h/V5W2xL3VR/HkMX74qFu7kdBNPevJTkG7k3u2LMmxqXd6hC8WohXkS40aMX9/K997Gs
         Fo1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JVcCFh37FoXjjtXudToxcf21kiMwk5o8/ZLx5Sn1apc=;
        b=Bu6tZIoizFZ6tYTXmzdWc72DfuushuJc3egLosDJMpWH5fL6zoa97yda0b+3wNLyQq
         JmISdpxVoT4unYQ30skJi2p9Wc+giYdt2RQGXFLaBTC98GQ5ggWtC2p58/OU3avHC7CW
         UeyHvIWRgFUVItPzB0e10Ca7BFBNJJf2+RQucnrr+PBCWhBDgATP+fhkGK/i+ldE8+PK
         brEAXoOajEpqaGITOC9n0AoBtP/1uXcyeLWKXxW6i8PjAf0xoaZETd5gvQhQdr9f+N7G
         K4JSHOrW6rb/OK+NMsRyoheppLFrAodFsnpojYW/pttuctXSW+YDWuQDawccxdAXp+fA
         twQg==
X-Gm-Message-State: ANoB5plqTN0II8qn0h2h6HFKrq7dIVLlZoSPqk77gW7FkBFvqgFcEmyA
        lZPsBukkEt3ZqZ8i9kdwnKgf4Z82Awc=
X-Google-Smtp-Source: AA0mqf6Hl9B1s2HNcpOn6a6aflUQrhSQD/tmYTlNGh2qSWqO48H/G1mOIOyDN8K3a/wmlQ2yPLCVwQ==
X-Received: by 2002:a05:6870:4c0a:b0:144:1fa4:dd81 with SMTP id pk10-20020a0568704c0a00b001441fa4dd81mr706947oab.57.1670468137653;
        Wed, 07 Dec 2022 18:55:37 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id r25-20020a4aea99000000b0049ef7712ee5sm9597619ooh.11.2022.12.07.18.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 18:55:37 -0800 (PST)
Date:   Wed, 7 Dec 2022 18:55:35 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 3/4] sched: add sched_numa_find_nth_cpu()
Message-ID: <Y5FSJ6Ywm89BFP3A@yury-laptop>
References: <20221112190946.728270-1-yury.norov@gmail.com>
 <20221112190946.728270-4-yury.norov@gmail.com>
 <Y3JRaSRpDJDUn2br@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3JRaSRpDJDUn2br@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 04:32:09PM +0200, Andy Shevchenko wrote:
> On Sat, Nov 12, 2022 at 11:09:45AM -0800, Yury Norov wrote:
> > The function finds Nth set CPU in a given cpumask starting from a given
> > node.
> > 
> > Leveraging the fact that each hop in sched_domains_numa_masks includes the
> > same or greater number of CPUs than the previous one, we can use binary
> > search on hops instead of linear walk, which makes the overall complexity
> > of O(log n) in terms of number of cpumask_weight() calls.
> 
> ...
> 
> > +struct __cmp_key {
> > +	const struct cpumask *cpus;
> > +	struct cpumask ***masks;
> > +	int node;
> > +	int cpu;
> > +	int w;
> > +};
> > +
> > +static int cmp(const void *a, const void *b)
> 
> Calling them key and pivot (as in the caller), would make more sense.

I think they are named opaque intentionally, so that user (me) would
cast them to proper data structures and give meaningful names. So I did.
 
> > +{
> 
> What about
> 
> 	const (?) struct cpumask ***masks = (...)pivot;
> 
> > +	struct cpumask **prev_hop = *((struct cpumask ***)b - 1);
> 
> 	= masks[-1];
> 
> > +	struct cpumask **cur_hop = *(struct cpumask ***)b;
> 
> 	= masks[0];
> 
> ?

It would work as well. Not better neither worse.

> > +	struct __cmp_key *k = (struct __cmp_key *)a;
> 
> > +	if (cpumask_weight_and(k->cpus, cur_hop[k->node]) <= k->cpu)
> > +		return 1;
> 
> > +	k->w = (b == k->masks) ? 0 : cpumask_weight_and(k->cpus, prev_hop[k->node]);
> > +	if (k->w <= k->cpu)
> > +		return 0;
> 
> Can k->cpu be negative?

User may pass negative value. Currently cpumask_local_spread() will
return nr_cpu_ids.

After rework, bsearch() will return hop #0, After that cpumask_nth_and()
will cast negative cpu to unsigned long, and because it's a too big number,
again will return nr_cpu_ids.

> If no, we can rewrite above as
> 
> 	k->w = 0;
> 	if (b == k->masks)
> 		return 0;
> 
> 	k->w = cpumask_weight_and(k->cpus, prev_hop[k->node]);

Here we still need to compare weight of prev_hop against k->cpu.
Returning -1 unconditionally is wrong.

> > +	return -1;
> > +}
> 
> ...
> 
> > +int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
> > +{
> > +	struct __cmp_key k = { cpus, NULL, node, cpu, 0 };
> 
> You can drop NULL and 0 while using C99 assignments.
> 
> > +	int hop, ret = nr_cpu_ids;
> 
> > +	rcu_read_lock();
> 
> + Blank line?
> 
> > +	k.masks = rcu_dereference(sched_domains_numa_masks);
> > +	if (!k.masks)
> > +		goto unlock;
> 
> > +	hop = (struct cpumask ***)
> > +		bsearch(&k, k.masks, sched_domains_numa_levels, sizeof(k.masks[0]), cmp) - k.masks;
> 
> Strange indentation. I would rather see the split on parameters and
> maybe '-' operator.
> 
> sizeof(*k.masks) is a bit shorter, right?
> 
> Also we may go with
> 
> 
> 	struct cpumask ***masks;
> 	struct __cmp_key k = { .cpus = cpus, .node = node, .cpu = cpu };
> 
> 
> 
> > +	ret = hop ?
> > +		cpumask_nth_and_andnot(cpu - k.w, cpus, k.masks[hop][node], k.masks[hop-1][node]) :
> > +		cpumask_nth_and(cpu - k.w, cpus, k.masks[0][node]);
> 
> > +unlock:
> 
> out_unlock: shows the intention more clearly, no?

No

> > +	rcu_read_unlock();
> > +	return ret;
> > +}
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691C962523B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiKKEMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiKKELk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:11:40 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2653222AD;
        Thu, 10 Nov 2022 20:11:37 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id m204so3918527oib.6;
        Thu, 10 Nov 2022 20:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2kdIP1WeRYup9WYrN50JXtVx97BRTIEhufBzxLjkpYA=;
        b=ca+da0sURkVvT/w+o9IghO9odiWy7U2rEiwocTnlWe8gRPKeY6vA/M3PsJV+6s4GvU
         WfYZKSQU//3TI0w9UwCZ/DVJ1Har1ltjs8l6DnqK1nfLcti12ge1yXp0hbHK08walcTb
         2TfDFld7p8zKluEDkBLpoac2orSne4kZQbn134+liUFuDZI8SVIOcAQzSASduZcqfxDr
         JSIdr2NxzWe9wvHvEKahSEsHFdubdsbCHf9SL16y/WELxf/ugXp1tYdJ/q2yLyUH4UrZ
         JQs8fb8MzBaiqfmwCv8rNYzlzupSidep31WWSr3zhIUsJ8uB4EfEChazB7e9e7zR4Axh
         aHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kdIP1WeRYup9WYrN50JXtVx97BRTIEhufBzxLjkpYA=;
        b=jMLWnvCntSNzazcvCBDfTmzWdqGQDC5wpqBRR7Uq5JlJ03kz3EEhPEdPG9fOC0zy/p
         dth4dGtaGvcXMOAwJfVpnvybAvPRn0ft5agF5aFZha8eulT7m901F7FWN+XDRTuxXc0F
         F1XOIGLZ76+qNg0uW3A5FIZhOoZkqd7/ckTFDjZ2JNw8ny8EK/81sszOj2nhVPFwGeoZ
         M2oHuYJFnp1PfEZpG54i4b42BGO851FJhYUJfJgryu2LzL915IgFIbKmjqs0jVXvVVkO
         lG6VdxfDW0MYQWGU8RrnikP4MG3Bt8ZFC2JjoOgDHQaNX8Ji4apfbQhQQ8mwJRBPto6e
         iDYg==
X-Gm-Message-State: ACrzQf12wI8kuhL0GAJ1/9LrtjP9Hh0+ZCYhIdktZnz4kD43lozZw0UU
        0d6owRPVKhR4Q9LVW/KwsWbkAkNKvx0=
X-Google-Smtp-Source: AMsMyM6RqfzUJQRUyyuyGav+7kCftcXcYL/D6/Myr/JgItXlXdrZ/Tw2jdm/GbNRqBDj8tfCZcsGWA==
X-Received: by 2002:a05:6808:170c:b0:345:20f7:b5df with SMTP id bc12-20020a056808170c00b0034520f7b5dfmr2742007oib.46.1668139896789;
        Thu, 10 Nov 2022 20:11:36 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id u24-20020a056870f29800b0013c50b812a2sm746209oap.36.2022.11.10.20.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 20:11:36 -0800 (PST)
Date:   Thu, 10 Nov 2022 20:11:35 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
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
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 3/4] sched: add sched_numa_find_nth_cpu()
Message-ID: <Y23Ld7fDVO8Z8Oqu@yury-laptop>
References: <20221111040027.621646-1-yury.norov@gmail.com>
 <20221111040027.621646-4-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111040027.621646-4-yury.norov@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 08:00:26PM -0800, Yury Norov wrote:
> The function finds Nth set CPU in a given cpumask starting from a given
> node.
> 
> Leveraging the fact that each hop in sched_domains_numa_masks includes the
> same or greater number of CPUs than the previous one, we can use binary
> search on hops instead of linear walk, which makes the overall complexity
> of O(log n) in terms of number of cpumask_weight() calls.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  include/linux/topology.h |  8 ++++++++
>  kernel/sched/topology.c  | 42 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 4564faafd0e1..63048ac3207c 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -245,5 +245,13 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
>  	return cpumask_of_node(cpu_to_node(cpu));
>  }
>  
> +#ifdef CONFIG_NUMA
> +int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node);
> +#else
> +int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)

Ah, this should be static of course.

> +{
> +	return cpumask_nth(cpu, cpus);
> +}
> +#endif	/* CONFIG_NUMA */
>  
>  #endif /* _LINUX_TOPOLOGY_H */
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 8739c2a5a54e..c8f56287de46 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2067,6 +2067,48 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
>  	return found;
>  }
>  
> +/*
> + * sched_numa_find_nth_cpu() - given the NUMA topology, find the Nth next cpu
> + *                             closest to @cpu from @cpumask.
> + * cpumask: cpumask to find a cpu from
> + * cpu: Nth cpu to find
> + *
> + * returns: cpu, or >= nr_cpu_ids when nothing found.
> + */
> +int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
> +{
> +	unsigned int first = 0, mid, last = sched_domains_numa_levels;
> +	struct cpumask ***masks;
> +	int w, ret = nr_cpu_ids;
> +
> +	rcu_read_lock();
> +	masks = rcu_dereference(sched_domains_numa_masks);
> +	if (!masks)
> +		goto out;
> +
> +	while (last >= first) {
> +		mid = (last + first) / 2;
> +
> +		if (cpumask_weight_and(cpus, masks[mid][node]) <= cpu) {
> +			first = mid + 1;
> +			continue;
> +		}
> +
> +		w = (mid == 0) ? 0 : cpumask_weight_and(cpus, masks[mid - 1][node]);
> +		if (w <= cpu)
> +			break;
> +
> +		last = mid - 1;
> +	}
> +
> +	ret = (mid == 0) ?
> +		cpumask_nth_and(cpu - w, cpus, masks[mid][node]) :
> +		cpumask_nth_and_andnot(cpu - w, cpus, masks[mid][node], masks[mid - 1][node]);
> +out:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sched_numa_find_nth_cpu);
>  #endif /* CONFIG_NUMA */
>  
>  static int __sdt_alloc(const struct cpumask *cpu_map)
> -- 
> 2.34.1

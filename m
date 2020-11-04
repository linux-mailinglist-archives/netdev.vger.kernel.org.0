Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF36F2A6926
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgKDQKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:10:39 -0500
Received: from mga04.intel.com ([192.55.52.120]:25123 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728975AbgKDQKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 11:10:38 -0500
IronPort-SDR: qpqVR/YPFrjOLI15mJUdnWidAbsLwLGF1iDt6YFNixlahJflk8OanTOvmkok7rF5fMWOthf/Ln
 uBw5jBm0r1mg==
X-IronPort-AV: E=McAfee;i="6000,8403,9795"; a="166650427"
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="166650427"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 08:10:36 -0800
IronPort-SDR: OVlaNLuuhBA03nEwTN8JlVV8SooWKFqBQ5GGJ0hDGHbyMl5Cqa3irhSLmHDeS04po779TJidsc
 U1OqiUL/cByw==
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="528985709"
Received: from bjvandec-mobl1.amr.corp.intel.com (HELO [10.212.97.86]) ([10.212.97.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 08:10:35 -0800
Subject: Re: [PATCH v6] lib: optimize cpumask_local_spread()
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Yuqi Jin <jinyuqi@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juergen Gross <jgross@suse.com>,
        Paul Burton <paul.burton@mips.com>,
        Michal Hocko <mhocko@suse.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
References: <1604410767-55947-1-git-send-email-zhangshaokun@hisilicon.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <3e2e760d-e4b9-8bd0-a279-b23bd7841ae7@intel.com>
Date:   Wed, 4 Nov 2020 08:10:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1604410767-55947-1-git-send-email-zhangshaokun@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/20 5:39 AM, Shaokun Zhang wrote:
> Currently, Intel DDIO affects only local sockets, so its performance
> improvement is due to the relative difference in performance between the
> local socket I/O and remote socket I/O.To ensure that Intel DDIO’s
> benefits are available to applications where they are most useful, the
> irq can be pinned to particular sockets using Intel DDIO.
> This arrangement is called socket affinityi. So this patch can help
> Intel DDIO work. The same I/O stash function for most processors

A great changelog would probably include a bit of context about DDIO.
Even being from Intel, I'd heard about this, but I didn't immediately
know what the acronym was.

The thing that matters here is that DDIO allows devices to use processor
caches instead of having them always do uncached accesses to main
memory.  That's a pretty important detail left out of the changelog.

> On Huawei Kunpeng 920 server, there are 4 NUMA node(0 - 3) in the 2-cpu
> system(0 - 1). The topology of this server is followed:

This is with a feature enabled that Intel calls sub-NUMA-clustering
(SNC), right?  Explaining *that* feature would also be great context for
why this gets triggered on your system and not normally on others and
why nobody noticed this until now.

> The IRQ from 369-392 will be bound from NUMA node0 to NUMA node3 with this
> patch, before the patch:
> 
> Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
> 0
> Euler:/sys/bus/pci # cat /proc/irq/370/smp_affinity_list
> 1
> ...
> Euler:/sys/bus/pci # cat /proc/irq/391/smp_affinity_list
> 22
> Euler:/sys/bus/pci # cat /proc/irq/392/smp_affinity_list
> 23
> After the patch:

I _think_ what you are trying to convey here is that IRQs 369 and 370
are from devices plugged in to one socket, but their IRQs are bound to
CPUs 0 and 1 which are in the other socket.  Once device traffic leaves
the socket, it can no longer use DDIO and performance suffers.

The same situation is true for IRQs 391/392 and CPUs 22/23.

You don't come out and say it, but I assume that the root of this issue
is that once we fill up a NUMA node worth of CPUs with an affinitized
IRQ per CPU, we go looking for CPUs in other NUMA nodes.  In this case,
we have the processor in this weird mode that chops sockets into two
NUMA nodes, which makes the device's NUMA node fill up faster.

The current behavior just "wraps around" to find a new node.  But, this
wrap around behavior is nasty in this case because it might cross a socket.

> +static void calc_node_distance(int *node_dist, int node)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_node_ids; i++)
> +		node_dist[i] = node_distance(node, i);
> +}

This appears to be the only place node_dist[] is written.  That means it
always contains a one-dimensional slice of the two-dimensional data
represented by node_distance().

Why is a copy of this data needed?

> +static int find_nearest_node(int *node_dist, bool *used)
> +{
> +	int i, min_dist = node_dist[0], node_id = -1;
> +
> +	/* Choose the first unused node to compare */
> +	for (i = 0; i < nr_node_ids; i++) {
> +		if (used[i] == 0) {
> +			min_dist = node_dist[i];
> +			node_id = i;
> +			break;
> +		}
> +	}
> +
> +	/* Compare and return the nearest node */
> +	for (i = 0; i < nr_node_ids; i++) {
> +		if (node_dist[i] < min_dist && used[i] == 0) {
> +			min_dist = node_dist[i];
> +			node_id = i;
> +		}
> +	}
> +
> +	return node_id;
> +}
> +
>  /**
>   * cpumask_local_spread - select the i'th cpu with local numa cpu's first
>   * @i: index number
> @@ -206,7 +238,11 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
>   */

The diff missed some important context:

>  * This function selects an online CPU according to a numa aware policy;
>  * local cpus are returned first, followed by non-local ones, then it
>  * wraps around.

This patch changes that behavior but doesn't update the comment.


>  unsigned int cpumask_local_spread(unsigned int i, int node)
>  {
> -	int cpu, hk_flags;
> +	static DEFINE_SPINLOCK(spread_lock);
> +	static int node_dist[MAX_NUMNODES];
> +	static bool used[MAX_NUMNODES];

Not to be *too* picky, but there is a reason we declare nodemask_t as a
bitmap and not an array of bools.  Isn't this just wasteful?

> +	unsigned long flags;
> +	int cpu, hk_flags, j, id;
>  	const struct cpumask *mask;
>  
>  	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
> @@ -220,20 +256,28 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
>  				return cpu;
>  		}
>  	} else {
> -		/* NUMA first. */
> -		for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
> -			if (i-- == 0)
> -				return cpu;
> -		}
> +		spin_lock_irqsave(&spread_lock, flags);
> +		memset(used, 0, nr_node_ids * sizeof(bool));
> +		calc_node_distance(node_dist, node);
> +		/* Local node first then the nearest node is used */

Is this comment really correct?  This makes it sound like there is only
fallback to a single node.  Doesn't the _code_ fall back basically
without limit?

> +		for (j = 0; j < nr_node_ids; j++) {
> +			id = find_nearest_node(node_dist, used);
> +			if (id < 0)
> +				break;
>  
> -		for_each_cpu(cpu, mask) {
> -			/* Skip NUMA nodes, done above. */
> -			if (cpumask_test_cpu(cpu, cpumask_of_node(node)))
> -				continue;
> +			for_each_cpu_and(cpu, cpumask_of_node(id), mask)
> +				if (i-- == 0) {
> +					spin_unlock_irqrestore(&spread_lock,
> +							       flags);
> +					return cpu;
> +				}
> +			used[id] = 1;
> +		}
> +		spin_unlock_irqrestore(&spread_lock, flags);

The existing code was pretty sparsely commented.  This looks to me to
make it more complicated and *less* commented.  Not the best combo.

> +		for_each_cpu(cpu, mask)
>  			if (i-- == 0)
>  				return cpu;
> -		}
>  	}
>  	BUG();
>  }
> 


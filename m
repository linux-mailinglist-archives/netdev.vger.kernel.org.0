Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1192D2BB1BC
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgKTRsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:48:46 -0500
Received: from mga14.intel.com ([192.55.52.115]:40218 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgKTRsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 12:48:45 -0500
IronPort-SDR: +tciYNxPefizGlyk36O0igmrydWLHKtw80s/UKAjh1hxnNr7Aem5wGLtAJW160fBsBIZPzuy4f
 t4VtCaeN2FCg==
X-IronPort-AV: E=McAfee;i="6000,8403,9811"; a="170732397"
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="170732397"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 09:48:44 -0800
IronPort-SDR: JRdP999lnjYsuYM41qo/cPZXkW0RFyNdIWqgQ8i1nSrTW5p9/9pAORRLroZPker979X/+Y7RvE
 KCUB2wsSOExQ==
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="545525137"
Received: from rancohen-mobl.ger.corp.intel.com (HELO [10.251.149.97]) ([10.251.149.97])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 09:48:43 -0800
Subject: Re: [PATCH v7] lib: optimize cpumask_local_spread()
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
References: <1605668072-44780-1-git-send-email-zhangshaokun@hisilicon.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzShEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gPGRhdmVAc3I3MS5uZXQ+wsF7BBMBAgAlAhsDBgsJCAcDAgYVCAIJ
 CgsEFgIDAQIeAQIXgAUCTo3k0QIZAQAKCRBoNZUwcMmSsMO2D/421Xg8pimb9mPzM5N7khT0
 2MCnaGssU1T59YPE25kYdx2HntwdO0JA27Wn9xx5zYijOe6B21ufrvsyv42auCO85+oFJWfE
 K2R/IpLle09GDx5tcEmMAHX6KSxpHmGuJmUPibHVbfep2aCh9lKaDqQR07gXXWK5/yU1Dx0r
 VVFRaHTasp9fZ9AmY4K9/BSA3VkQ8v3OrxNty3OdsrmTTzO91YszpdbjjEFZK53zXy6tUD2d
 e1i0kBBS6NLAAsqEtneplz88T/v7MpLmpY30N9gQU3QyRC50jJ7LU9RazMjUQY1WohVsR56d
 ORqFxS8ChhyJs7BI34vQusYHDTp6PnZHUppb9WIzjeWlC7Jc8lSBDlEWodmqQQgp5+6AfhTD
 kDv1a+W5+ncq+Uo63WHRiCPuyt4di4/0zo28RVcjtzlGBZtmz2EIC3vUfmoZbO/Gn6EKbYAn
 rzz3iU/JWV8DwQ+sZSGu0HmvYMt6t5SmqWQo/hyHtA7uF5Wxtu1lCgolSQw4t49ZuOyOnQi5
 f8R3nE7lpVCSF1TT+h8kMvFPv3VG7KunyjHr3sEptYxQs4VRxqeirSuyBv1TyxT+LdTm6j4a
 mulOWf+YtFRAgIYyyN5YOepDEBv4LUM8Tz98lZiNMlFyRMNrsLV6Pv6SxhrMxbT6TNVS5D+6
 UorTLotDZKp5+M7BTQRUY85qARAAsgMW71BIXRgxjYNCYQ3Xs8k3TfAvQRbHccky50h99TUY
 sqdULbsb3KhmY29raw1bgmyM0a4DGS1YKN7qazCDsdQlxIJp9t2YYdBKXVRzPCCsfWe1dK/q
 66UVhRPP8EGZ4CmFYuPTxqGY+dGRInxCeap/xzbKdvmPm01Iw3YFjAE4PQ4hTMr/H76KoDbD
 cq62U50oKC83ca/PRRh2QqEqACvIH4BR7jueAZSPEDnzwxvVgzyeuhwqHY05QRK/wsKuhq7s
 UuYtmN92Fasbxbw2tbVLZfoidklikvZAmotg0dwcFTjSRGEg0Gr3p/xBzJWNavFZZ95Rj7Et
 db0lCt0HDSY5q4GMR+SrFbH+jzUY/ZqfGdZCBqo0cdPPp58krVgtIGR+ja2Mkva6ah94/oQN
 lnCOw3udS+Eb/aRcM6detZr7XOngvxsWolBrhwTQFT9D2NH6ryAuvKd6yyAFt3/e7r+HHtkU
 kOy27D7IpjngqP+b4EumELI/NxPgIqT69PQmo9IZaI/oRaKorYnDaZrMXViqDrFdD37XELwQ
 gmLoSm2VfbOYY7fap/AhPOgOYOSqg3/Nxcapv71yoBzRRxOc4FxmZ65mn+q3rEM27yRztBW9
 AnCKIc66T2i92HqXCw6AgoBJRjBkI3QnEkPgohQkZdAb8o9WGVKpfmZKbYBo4pEAEQEAAcLB
 XwQYAQIACQUCVGPOagIbDAAKCRBoNZUwcMmSsJeCEACCh7P/aaOLKWQxcnw47p4phIVR6pVL
 e4IEdR7Jf7ZL00s3vKSNT+nRqdl1ugJx9Ymsp8kXKMk9GSfmZpuMQB9c6io1qZc6nW/3TtvK
 pNGz7KPPtaDzvKA4S5tfrWPnDr7n15AU5vsIZvgMjU42gkbemkjJwP0B1RkifIK60yQqAAlT
 YZ14P0dIPdIPIlfEPiAWcg5BtLQU4Wg3cNQdpWrCJ1E3m/RIlXy/2Y3YOVVohfSy+4kvvYU3
 lXUdPb04UPw4VWwjcVZPg7cgR7Izion61bGHqVqURgSALt2yvHl7cr68NYoFkzbNsGsye9ft
 M9ozM23JSgMkRylPSXTeh5JIK9pz2+etco3AfLCKtaRVysjvpysukmWMTrx8QnI5Nn5MOlJj
 1Ov4/50JY9pXzgIDVSrgy6LYSMc4vKZ3QfCY7ipLRORyalFDF3j5AGCMRENJjHPD6O7bl3Xo
 4DzMID+8eucbXxKiNEbs21IqBZbbKdY1GkcEGTE7AnkA3Y6YB7I/j9mQ3hCgm5muJuhM/2Fr
 OPsw5tV/LmQ5GXH0JQ/TZXWygyRFyyI2FqNTx4WHqUn3yFj8rwTAU1tluRUYyeLy0ayUlKBH
 ybj0N71vWO936MqP6haFERzuPAIpxj2ezwu0xb1GjTk4ynna6h5GjnKgdfOWoRtoWndMZxbA
 z5cecg==
Message-ID: <6a6e6d37-a3dc-94ed-bc8c-62c50ea1dff5@intel.com>
Date:   Fri, 20 Nov 2020 09:48:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1605668072-44780-1-git-send-email-zhangshaokun@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/20 6:54 PM, Shaokun Zhang wrote:
> From: Yuqi Jin <jinyuqi@huawei.com>
> 
> In multi-processor and NUMA system, I/O driver will find cpu cores that
> which shall be bound IRQ. When cpu cores in the local numa have been
> used up, it is better to find the node closest to the local numa node
> for performance, instead of choosing any online cpu immediately.
> 
> On arm64 or x86 platform that has 2-sockets and 4-NUMA nodes, if the
> network card is located in node2 of socket1, while the number queues
> of network card is greater than the number of cores of node2, when all
> cores of node2 has been bound to the queues, the remaining queues will
> be bound to the cores of node0 which is further than NUMA node3.

That's quite the run-on sentence. :)

> It is
> not friendly for performance or Intel's DDIO (Data Direct I/O Technology)

Could you explain *why* it is not friendly to DDIO specifically?  This
patch affects where the interrupt handler runs.  But, DDIO is based on
memory locations rather than the location of the interrupt handler.

It would be ideal to make that connection: How does the location of the
interrupt handler impact the memory allocation location?

> when if the user enables SNC (sub-NUMA-clustering).

Again, the role that SNC plays here isn't spelled out.  I *believe* it's
because SNC ends up reducing the number of CPUs in each NUMA node.  That
 makes the existing code run out of CPUs to which to bind to the "local"
node sooner.

> +static int find_nearest_node(int node, bool *used)
> +{
> +	int i, min_dist, node_id = -1;
> +
> +	/* Choose the first unused node to compare */
> +	for (i = 0; i < nr_node_ids; i++) {
> +		if (used[i] == false) {
> +			min_dist = node_distance(node, i);
> +			node_id = i;
> +			break;
> +		}
> +	}
> +
> +	/* Compare and return the nearest node */
> +	for (i = 0; i < nr_node_ids; i++) {
> +		if (node_distance(node, i) < min_dist && used[i] == false) {
> +			min_dist = node_distance(node, i);
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
>   * @node: local numa_node
>   *
>   * This function selects an online CPU according to a numa aware policy;
> - * local cpus are returned first, followed by non-local ones, then it
> - * wraps around.
> + * local cpus are returned first, followed by the next one which is the
> + * nearest unused NUMA node based on NUMA distance, then it wraps around.
>   *
>   * It's not very efficient, but useful for setup.
>   */
>  unsigned int cpumask_local_spread(unsigned int i, int node)

FWIW, I think 'i' is criminally bad naming.  It should be called
nr_cpus_to_skip or something similar.

I also detest the comments that are there today.

	Loop through all the online CPUs on the system.  Start with the
	CPUs on 'node', then fall back to CPUs on NUMA nodes which are
	increasingly far away.

	Skip the first 'nr_cpus_to_skip' CPUs which are found.

	This function is not very efficient, especially for large
	'nr_cpus_to_skip' because it loops over the same CPUs on each
	call and does not remember its state from previous calls.

>  {
> -	int cpu, hk_flags;
> +	static DEFINE_SPINLOCK(spread_lock);
> +	static bool used[MAX_NUMNODES];

I thought I mentioned this last time.  How large is this array?  How
large would it be if it were a nodemask_t?  Would this be less code if
you just dynamically allocated and freed the node mask instead of having
a spinlock and a memset?

> +	unsigned long flags;
> +	int cpu, hk_flags, j, id;
>  	const struct cpumask *mask;
>  
>  	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
> @@ -352,20 +379,27 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
>  				return cpu;
>  		}
>  	} else {
> -		/* NUMA first. */
> -		for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
> -			if (i-- == 0)
> -				return cpu;
> +		spin_lock_irqsave(&spread_lock, flags);
> +		memset(used, 0, nr_node_ids * sizeof(bool));
> +		/* select node according to the distance from local node */
> +		for (j = 0; j < nr_node_ids; j++) {
> +			id = find_nearest_node(node, used);
> +			if (id < 0)
> +				break;

There's presumably an outer loop in a driver which is trying to bind a
bunch of interrupts to a bunch of CPUs.  We know there are on the order
of dozens of these interrupts.

	for_each_interrupt() // in the driver
		for (j=0;j<nr_node_ids;j++) // cpumask_local_spread()
			// find_nearest_node():
			for (i = 0; i < nr_node_ids; i++) {
			for (i = 0; i < nr_node_ids; i++) {

Does this worry anybody else?  It thought our upper limits on the number
of NUMA nodes was 1024.  Doesn't that make our loop O(N^3) where the
worst case is hundreds of millions of loops?

I don't want to prematurely optimize this, but that seems like something
that might just fall over on bigger systems.

This also seems really wasteful if we have a bunch of memory-only nodes.
 Each of those will be found via find_nearest_node(), but then this loop:

> +			for_each_cpu_and(cpu, cpumask_of_node(id), mask)
> +				if (i-- == 0) {
> +					spin_unlock_irqrestore(&spread_lock,
> +							       flags);
> +					return cpu;
> +				}
> +			used[id] = true;
>  		}

Will just exit immediately because cpumask_of_node() is empty.

'used', for instance, should start by setting 'true' for all nodes which
are not in N_CPUS.


> +		spin_unlock_irqrestore(&spread_lock, flags);
>  
> -		for_each_cpu(cpu, mask) {
> -			/* Skip NUMA nodes, done above. */
> -			if (cpumask_test_cpu(cpu, cpumask_of_node(node)))
> -				continue;
> -
> +		for_each_cpu(cpu, mask)
>  			if (i-- == 0)
>  				return cpu;
> -		}
>  	}
>  	BUG();
>  }
